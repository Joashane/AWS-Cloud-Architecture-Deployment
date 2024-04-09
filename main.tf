terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# VPC for the infrastructure
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

# Subnet within the VPC
resource "aws_subnet" "subnet" {
  for_each = var.subnet_cidr_blocks

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "App Internet Gateway"
  }
}

# Route Table for the VPC
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the subnet with the route table
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Security Group with specific inbound rules
resource "aws_security_group" "allow_specific" {
  name        = "allow_specific"
  description = "Allow specific inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

# Data source to fetch latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 instance with IAM role for S3 access
resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_specific.id]
  subnet_id              = aws_subnet.subnet["us-east-1a"].id
  iam_instance_profile   = aws_iam_instance_profile.s3_read_only_profile.name

  tags = {
    Name = "APPServer"
  }
}

# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "my-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_specific.id]
  subnets            = [for s in aws_subnet.subnet : s.id]
}

# Target Group for the Application Load Balancer
resource "aws_lb_target_group" "app_tg" {
  name     = "my-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Attach the EC2 instance to the Target Group
resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app.id
  port             = 80
}

# Listener for the Application Load Balancer
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# RDS instance for the application
resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = true
  skip_final_snapshot  = true
}

# S3 bucket for the application storage
resource "aws_s3_bucket" "bucket" {
  bucket = "my-unique-app-bucket"
}

# Manage public access settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}