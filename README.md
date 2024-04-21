# DynamoDB table access through AWS EC2 within AWS Infrastructure #
## Overview ##
This project automates the setup of a secure and scalable infrastructure on Amazon Web Services (AWS) for managing student information using DynamoDB. It utilizes Terraform, an infrastructure as code tool, to provision the necessary AWS resources, including a Virtual Private Cloud (VPC), DynamoDB table, security group, and EC2 instance.

## Features ##

**VPC Configuration:** Sets up a custom VPC with DNS support and hostnames enabled.  
**Subnet Establishment:** Defines a subnet within the VPC to host the DynamoDB table and EC2 instance.  
**Security Group Definition:** Creates a security group to control network traffic and ensure secure communication.  
**DynamoDB Table Creation:** Establishes a DynamoDB table named "StudentInformation" with appropriate keys and attributes, including a global secondary index for efficient querying.  
**VPC Endpoint for DynamoDB:** Configures a VPC endpoint to enable private connectivity to DynamoDB within the VPC.  
**EC2 Instance Launch:** Spins up an EC2 instance running Ubuntu, providing a platform for accessing and managing student data.  

## Prerequisites ##
Before running the Terraform script, ensure you have:

An AWS account with appropriate permissions to create resources.
Terraform installed locally. Installation instructions can be found here (https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

## Usage ##
1. Clone this repository to your local machine.
2. Navigate to the project directory.
3. Modify the variables.tf file to customize settings such as VPC CIDR block, subnet CIDR block, etc., if needed.
4. Run terraform init to initialize the Terraform configuration.
5. Run terraform plan to preview the resources that will be created.
6. Run terraform apply to apply the Terraform configuration and provision the AWS resources.


**Note**: If you want to access the dynamodb table outside the AWS infrastructure, you have to configure internet gateway. EC2 instance's public IP address can be used to access and manage the student information system.  

## Cleanup ##
To avoid incurring unnecessary charges, it's important to clean up the resources when they are no longer needed. To do so, run terraform destroy after you're done using the system.

## Architectural Diagram ##
![VPCEndpoint-DynamoDB drawio](https://github.com/keshorem/vpc-endpoint-terraform-module/assets/107935939/19735e30-4a42-40f7-921e-566c92ef3c7e)

