# AWS Application Deployment using Terraform and Ansible

In the following project I would like to show you how to deploy a NodeJS application to AWS cloud provider using Terraform and Ansible. 

I assume that you have an AWS account and that you know the basis administration and configuration. I also assume your workstation is configured with AWS CLI and that you have created an IAM account (user) with full administration permisions to test the instructions described here.

These instructions are based on macOS operating system, but I think they will be the same in Linux with some minor changes.

## Tools and services we need to deploy the application

- Terraform v0.12.18
- Python 2.7.16
- ansible 2.9.2
- AWS (under free tier, but it is your responsibility any cost you may incur)
- Amazon EC2
- Amazon Elastic Load Balancing
- Amazon Virtual Private Cloud (VPC)
- Amazon RDS for MySQL

## Terraform installation and configuration

Assuming you have AWS CLI configured in your workstation and you are able to create resources with it, the next step is to install Terraform.