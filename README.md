# AWS Cloud Architecture Deployment
## Architecture Overview
This Terraform configuration sets up a cloud infrastructure on AWS, focusing on creating a scalable and secure environment for an application. The architecture includes:

- **VPC (Virtual Private Cloud)**: A virtual network dedicated to the application, providing a secure and isolated environment.
- **Subnets**: Divisions within the VPC, each in a different availability zone, to distribute resources and improve fault tolerance.
- **Internet Gateway**: Allows the VPC to communicate with the internet.
- **Route Table**: Defines how traffic is routed within the VPC and to the internet.
- **Security Group**: Controls inbound and outbound traffic to the EC2 instances.
- **EC2 Instance**: A virtual server for running the application, with specific IAM roles for accessing S3.
- **Application Load Balancer (ALB)**: Distributes incoming application traffic across multiple targets, such as EC2 instances, in multiple Availability Zones.
- **RDS Instance**: A managed relational database service for the application.
- **S3 Bucket**: A storage service for the application's data, with public access settings managed to ensure security.
- **IAM Roles and Policies**: For managing access to AWS resources, including read-only access to S3 for the EC2 instance.
