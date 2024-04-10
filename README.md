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

## Workflow

- **VPC and Subnets**: The VPC is created with a specified CIDR block, and subnets are created within this VPC, each in a different availability zone. This setup ensures high availability and fault tolerance.
- **Internet Gateway and Route Table**: An internet gateway is attached to the VPC, and a route table is configured to route internet-bound traffic through the internet gateway. This allows instances within the VPC to access the internet.
- **Security Group**: A security group is defined with rules to allow SSH and HTTP traffic, ensuring that the application can be accessed over the internet while limiting other inbound traffic.
- **EC2 Instance**: An EC2 instance is launched within one of the subnets, using an Amazon Linux AMI. This instance is associated with the security group and has an IAM role that allows it to access S3 resources.
- **Application Load Balancer**: An ALB is set up to distribute incoming application traffic across the EC2 instance. This setup ensures that the application can handle varying loads and provides redundancy.
- **RDS Instance**: A managed RDS instance is created for the application's database needs, using MySQL as the database engine. This managed service takes care of database maintenance tasks.
- **S3 Bucket**: An S3 bucket is created for storing the application's data. Public access settings are configured to block public access, ensuring that the data is secure.
- **IAM Roles and Policies**: IAM roles and policies are defined to manage access to AWS resources. The EC2 instance is given a role with read-only access to S3, allowing it to retrieve necessary data without exposing sensitive information.

## Conclusion

This architecture is designed to provide a secure, scalable, and highly available environment for an application. 
It leverages AWS's managed services and IAM for access control, ensuring that the application can be deployed and managed efficiently.
