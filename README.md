# AWS Application Deployment using Terraform and Ansible

In the following project I would like to show you how to deploy a NodeJS application to AWS cloud provider using Terraform and Ansible. 

I assume you have an AWS account and that you know the basis of AWS administration and configuration. I also assume your workstation is configured with AWS CLI and that you have created an IAM account (user) with full administration permisions to test the instructions described here.

These instructions are based on macOS operating system, but I think they will be the same in Linux with some minor changes.

## Tools and services we need to deploy the application

- Terraform v0.12.18
- Python 2.7.16
- ansible 2.9.2
- GitHub
- git (git version 2.21.0 (Apple Git-122.2))
- SSH
- AWS (under free tier, but it is your responsibility of any cost you may incur)
- aws-cli/1.16.230
- Amazon EC2
- Amazon Elastic Load Balancing
- Amazon Virtual Private Cloud (VPC)
- Amazon RDS for MySQL

## Terraform installation and configuration

Assuming you have AWS CLI configured in your workstation and you are able to create resources with it, the next step is to install Terraform.

The installation of Terraform is quite easy, you just need to download the binary file, unzip it and move it to a standard binary location in macOS.

- wget https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_darwin_amd64.zip
- unzip terraform_0.12.18_darwin_amd64.zip
- sudo mv terraform /usr/local/bin/

To test the binary file, just execute:

```
$ terraform --version
Terraform v0.12.18
```

## Python Validation

By default, macOS comes with Python 2.7.x installed, and this document assume you have this version and any variation is outside of scope.

To validate your Python version execute the following command:

```
$ python --version
Python 2.7.16
```





