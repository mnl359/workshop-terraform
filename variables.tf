variable "cidr_ab" {
    type = map
    default = {
        development = "172.22"
        qa          = "172.24"
        staging     = "172.26"
        production  = "172.28"
    }
}

variable "environment" {
    description     = "Environment Definition - Options: development, qa, staging, production"
    default         = "development"
}

/* Private Subnets */

locals {
    private_subnets = [
        "${lookup(var.cidr_ab, var.environment)}.1.0/24",
        "${lookup(var.cidr_ab, var.environment)}.2.0/24",
        "${lookup(var.cidr_ab, var.environment)}.3.0/24"
    ]

    database_subnets = [
        "${lookup(var.cidr_ab, var.environment)}.11.0/24",
        "${lookup(var.cidr_ab, var.environment)}.12.0/24",
        "${lookup(var.cidr_ab, var.environment)}.13.0/24"
    ]

    public_subnets = [
        "${lookup(var.cidr_ab, var.environment)}.64.0/24",
        "${lookup(var.cidr_ab, var.environment)}.65.0/24",
        "${lookup(var.cidr_ab, var.environment)}.66.0/24"
    ]
}


variable "aws_region" {
    description     = "EC2 Region for the VPC"
    default         = "us-east-1"
}

variable "availability_zone" {
    description     = "Availability Zone for resources"
    default         = "us-east-1a"
}

variable "availability_zone_b" {
    description     = "Availability Zone for resources"
    default         = "us-east-1b"
}

variable "vpc_cidr" {
    description     = "CIDR for the whole VPC"
    default         = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
    description     = "CIDR for the Public Subnet"
    default         = "10.20.3.0/24"
}

##########################
# EC2 Configuration Init #
##########################
variable "aws_amis" {
    description     = "AMIs by Region"
    default = {
        #us-east-1 = "ami-04b9e92b5572fa0d1" # Ubuntu-bionic-18.04-amd64
        us-east-1 = "ami-00068cd7555f543d5" # ami-00068cd7555f543d5 Amazon Linux 2 AMI
    }
}

variable "ec2_machine_type" {
    description     = "Cloud Machine Type"
    default         = "t2.micro"
}

variable "number_of_instances" {
    description     = "Number of instances"
    default         = 2
}

variable "key_name" {
    description     = "AWS Key Name"
    default         = "awscirclecilab"
}

variable "ssh_private_key" {
    description     = "Private Key for Terraform-Ansible Project"
    default         = "awslabs.pem"
}

variable "ssh_public_key" {
    description     = "Public Key for Terraform-Ansible Project"
    default         = "aws_ansible.pub"
}
# EC2 Configuration End

##########################
# RDS Configuration Init #
##########################
variable "rds_instance_class" {
    description     = "RDS Instance Class"
    default         = "db.t2.micro"
}

variable "rds_database_name" {
    description     = "RDS Database Name"
    default         = "catsndogs"
}

variable "rds_database_username" {
    description     = "RDS Database Username"
    default         = "admindb"
}

variable "rds_database_password" {
    description     = "RDS Database Password"
    default         = "a1s2d3f4"
}

variable "private_subnet_cidr" {
    description     = "CIDR for the Private Subnet"
    default         = "10.20.7.0/24"
}

variable "private_subnet_cidr_b" {
    description     = "CIDR for the Private Subnet B"
    default         = "10.20.8.0/24"
}
# RDS Configuration End
