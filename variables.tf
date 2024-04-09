variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_newbits" {
  description = "Number of bits to add to the VPC CIDR block for each subnet"
  type        = number
  default     = 8
}

variable "subnet_numbers" {
  description = "Numbers to use for each subnet"
  type        = list(number)
  default     = [1, 2]
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for the subnets"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}