# AWS Application Deployment using Terraform, Ansible and CircleCI

In the following notes I want to show you how to deploy Wordpress Web Application to AWS using Terraform, Ansible and CircleCI.

Long explanation on Medium. Comming soon...

**Terraform Variables**

Adjust default values on the following variables in variables.tf file.

| Line | Variable Name | Value | Description |
| --- | --- | --- | --- |
| 44 | vpc_name | terraform-ansible-01 | Name of the custom VPC |
| 49 | cidr_ab | development = "172.22" |  |
| 97 | web_sg_name | web_sg_01 | Security Group to control the access from ALB to the Application Web Servers |
| 107 | alb_sg_name | alb_sg_01 | Security Group to control the access from Internet to the ALB |
| 117 | db_sg_name | db_sg | Security Group to control the access from Application Web Servers to RDS Database |
| 148 | key_name | terraform-ansible-01 | Name of SSH Key for accessing EC2 instances on AWS |
| 153 | ssh_public_key | terraform-ansible-aws.pub | Custom SSH Public Key for accessing EC2 instances |
| 160 | instance_name | App01 | Tag Name assigned to all EC2 instances. Used by Ansible to identify the EC2 instances and to configure them |
| 167 | rds_database_identifier | terraform-ansible-01 | RDS identifier to be used by Ansible to get the RDS Database needed data to deploy Wordpress |
| 177 | rds_database_name | terraformansible01 | RDS Database name |
| 193 | rds_subnet_group_name | db_private_subnet_01 | RDS Database private subnet |
| 225 | alb_name | terraform-ansible-alb-01 | Application Load Balancer name |

This documentation is outdated. I will update it as soon as possible.

Remember to verify that you have permission to create service linked role.

https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAM.ServiceLinkedRoles.html

Adding Elastic Load Balancer permission.

"iam:CreateServiceLinkedRole"

I assume you have an AWS account and that you know the basis of AWS administration and configuration. I also assume your workstation is configured with AWS CLI and that you have created an IAM account (user) with full administration permisions to test the instructions described here.

These instructions are based on macOS operating system, but I think they will be the same in Linux with some minor changes.

## Tools and services we need to deploy the application

- Terraform
- Python
- Ansible
- GitHub
- Git
- SSH
- AWS (under free tier, but it is your responsibility of any cost you may incur)
- Amazon EC2
- Amazon Elastic Load Balancing
- Amazon Virtual Private Cloud (VPC)
- Amazon RDS for MySQL

mysql -u admindb -p -h terraform-20200424225011192900000004.c8zdmqnhosul.us-east-1.rds.amazonaws.com

## Terraform installation

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

By default, macOS comes with `Python 2.7.x` installed. This document assumes you have this version and any variation is outside of the scope.

To validate your Python version execute the following command:

```
$ python --version
Python 2.7.16
```

## Ansible installation

The installation of Ansible is straightforward. We just need to install the Python package manager (pip), if it is not already installed, and then install Ansible.

Execute the following commands to install pip and Ansible:

```
$ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
$ python get-pip.py --user
$ pip install --user ansible
```

In order to test the ansible installation you have to restart your terminal.

To validate your Ansible installation exeute the following command:

```
$ ansible --version
ansible 2.9.2
...
```

You will get an extra information about the Ansible environment.

Dynamic Inventory Documentation

tag_KEY_VALUE ec2.py dynamic tag tag_KEY_VALUE where KEY=Name and VALUE=App01

https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html

## GitHub

You don't need to create a GitHub account to test this project, but I suggest you to create one and fork the following repositores:

- https://github.com/williammunozr/terraform-ansible-aws-catsndogs
- https://github.com/williammunozr/nodejs_catsndogs.git

Even if you fork my repositories or don't, you will need a copy at least the Terraform one. Assuming you have git command installed, execute the following command:

```
$ git clone https://github.com/williammunozr/terraform-ansible-aws-catsndogs
$ cd terraform-ansible-aws-catsndogs 
$ terraform-ansible-aws-catsndogs git:(master)
```

If you forked my repository and want to use yours, just change the URL in the command above.

## SSH configuration

In order to access an AWS instance we need to provide (create) a SSH Key to be used in the Terraform deployment process and it is also required by Ansible in the configuration management process. That's why we need to create a SSH Key, process that we're going to accomplish in this section.

In a Unix-like operating system the default location for the SSH keys is the .ssh directory within the current user's home directory. To create the a SSH key execute the following commands:

```
$ ssh-keygen -m PEM -t rsa -b 4096 -f ~/.ssh/terraform-ansible-aws
For simplicity, press enter to accept the default values.
```

Our last step in this section is to copy the public SSH key file to the root directory of the project and set the value of the variable named `private_key_file` in the `ansible.cfg` file to the full path of the private SSH key.

```
$ terraform-ansible-aws-catsndogs git:(master) cp -p ~/.ssh/ansible_aws.pub .

And set the value in the ansible.cfg file according to your configuration.

private_key_file = /Users/williammr/.ssh/ansible_aws
```

If you change the name of the SSH key (ansible_aws) for something different, you have to adjust the project accordingly. Also be careful to ignore this file in the `.gitignore` file, just put the name of the file you want git doesn't track.

## AWS CLI

The installation of the AWS CLI is also very straightforward, you just need to execute a pip command.

```
$ pip install awscli --upgrade --user
```

To validate the AWS CLI installation restart your terminal and execute the following command:

```
aws --version
```

The configuration of AWS CLI is outside of the scope in this project. An important thing to bear in mind is that in this project we are working in `us-east-1` region. To accomplish the configuration of AWS CLI follow the instructions in the documentation.

- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html


## We are ready to go

If you have all the above steps completed and without issues, you are ready to test the project. The project starts with the execution of Terraform commands. In a nutshell it validates that you have AWS CLI configured, download all the necessary modules, execute the deployment to AWS and launch the Ansible configuration management process. 

To proceed with the execution of the project, in the first time, execute the following:

### First time execution

```
$ terraform init
$ terraform plan
$ terraform apply -auto-approve
```

### Project testing

- Get into the AWS console
- Navigate to EC2 service
- Scroll down to Load Balancers
- Select the one named "terraform-ansible-alb"
- In the description of the Load Balancer copy the DNS name a paste it in a new tab
- You must see the NodeJS application

### Apply changes made to Terraform project

```
$ terraform plan
$ terraform apply -auto-approve
```

### Destroy all the resources on AWS

```
$ terraform destroy -auto-approve
```

# Side Notes

This project is not production ready, it has some weaknesses in its design, for example, it is tightly bound with `us-east-1` region, it must be configured to work dynamically in any region. It doesn't have auto-scaling, if I need to scale the number of instances I have to change that number in the configuration and execute the project again, it is a manual process.

This project was intended to show I have some abilities. But if I have to do the same project for a production ready deployment I definitely suggest Kubernetes, it is strong and easier to work with.

Some things that you can improve in the current project:

- Configure the project's region to work dynamically
- Create an EC2 image with all the configuration needed and the application deployed
- With the EC2 image in hand you don't need Ansible (perfect, less things to install)
- With the EC2 image ready, you can implement an auto-scaling solution, based in CPU and Memory metrics (cool!)
- With the above changes you can implement a CI/CD pipeline that react to changes on IaC Terraform or NodeJS repositories (With CircleCI, awesome!)
- You don't need SSH Keys to access the EC2 Instances (a more secure system)
- Now, you can implement a Blue/Green or Canary deployment easier
- Add Slack notifications. Testing notifications.

- Finally, use Kubernetes.

