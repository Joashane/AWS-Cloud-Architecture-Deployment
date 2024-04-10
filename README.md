# AWS Cloud Architecture Deployment

## Architecture Overview
This Terraform configuration sets up a cloud infrastructure on AWS, focusing on creating a scalable and secure environment for an application. The architecture includes:

- **VPC and Subnets**: The VPC is created with a specified CIDR block, and subnets are created within this VPC, each in a different availability zone. This setup ensures high availability and fault tolerance.

- **Internet Gateway and Route Table**: An internet gateway is attached to the VPC, and a route table is configured to route internet-bound traffic through the internet gateway. This allows instances within the VPC to access the internet.

- **Security Group**: A security group is defined with rules to allow SSH and HTTP traffic, ensuring that the application can be accessed over the internet while limiting other inbound traffic.

- **EC2 Instance**: An EC2 instance is launched within one of the subnets, using an Amazon Linux AMI. This instance is associated with the security group and has an IAM role that allows it to access S3 resources.

- **Application Load Balancer**: An ALB is set up to distribute incoming application traffic across the EC2 instance. This setup ensures that the application can handle varying loads and provides redundancy.

- **RDS Instance**: A managed RDS instance is created for the application's database needs, using MySQL as the database engine. This managed service takes care of database maintenance tasks.

- **S3 Bucket**: An S3 bucket is created for storing the application's data. Public access settings are configured to block public access, ensuring that the data is secure.

- **IAM Roles and Policies**: IAM roles and policies are defined to manage access to AWS resources. The EC2 instance is given a role with read-only access to S3, allowing it to retrieve necessary data without exposing sensitive information.


## Workflow

This workflow illustrates how a user interacts with a web application, which in turn interacts with AWS infrastructure managed by Terraform. The infrastructure setup includes components like VPC, subnets, EC2 instances, RDS instances, S3 buckets, and IAM roles, all of which are essential for hosting, processing, and analyzing user data in a scalable and secure manner.

![Workflow of the Infrastructure png 50%](https://github.com/Joashane/AWS-Cloud-Architecture-Deployment/assets/156240544/8d7bc7cb-b2ec-4c35-8cd7-c488f73f3072)

- **User Interaction**: The user interacts with a web application hosted on the EC2 instance. This interaction could be anything from logging in, navigating through pages, or performing actions that generate data.

- **Application Load Balancer (ALB)**: The user's request first hits the Application Load Balancer (ALB). The ALB is responsible for distributing incoming application traffic across multiple targets, such as EC2 instances, in multiple Availability Zones. This setup ensures that the application can handle varying loads and provides redundancy.

- **EC2 Instance**: The ALB forwards the user's request to the EC2 instance, which is running the web application. This instance is configured with an IAM role that allows it to access S3 resources, ensuring that the application can retrieve necessary data from S3.

- **Security Group**: The EC2 instance is associated with a security group that allows specific inbound traffic. In this case, the security group allows SSH access (port 22) and HTTP access (port 80), ensuring that the application can be accessed over the internet while limiting other inbound traffic.

- **RDS Instance**: If the web application needs to store or retrieve data from a database, it will interact with the RDS instance. This RDS instance is a managed relational database service for the application, using MySQL as the database engine.

- **S3 Bucket**: The web application might also interact with an S3 bucket for storing application data. The S3 bucket is configured with public access settings managed to ensure security, blocking public access to the bucket.

- **IAM Roles and Policies**: The EC2 instance is given an IAM role with access to S3, allowing it to retrieve necessary data without exposing sensitive information. This setup ensures that the application can securely access AWS resources.

- **Infrastructure Management**: Throughout this process, the infrastructure (VPC, subnets, EC2 instances, RDS instances, S3 buckets, IAM roles, etc.) is managed by Terraform. Terraform ensures that the infrastructure is provisioned, configured, and updated. The code is versioned in this github.


## Conclusion

This architecture is designed to provide a secure, scalable, and highly available environment for an application. 
It leverages AWS's managed services and IAM for access control, ensuring that the application can be deployed and managed efficiently.
