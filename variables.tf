/* Project Tags */

variable "project_owner" {
    description     = "Tag to identify the resource owner name"
    default         = "William Munoz"
}

variable "project_email" {
    description     = "Tag to identify the resource owner email"
    default         = "william.munoz@endava.com"
} 

variable "project_name" {
    description     = "Tag to identify the resource project name"
    default         = "CircleCI"
}

variable "is_project_terraformed" {
    description     = "Tag to identify if the project is managed by Terraform"
    default         = "true"
}

/* Region */

variable "region" {
    type            = map(string)
    default         = {
        "development"   = "us-east-1"
        "qa"            = "us-east-1"
        "staging"       = "us-east-2"
        "production"    = "us-east-2"
    }
}

/* Environment Definition */

variable "environment" {
    description     = "Environment Definition - Options: development, qa, staging, production"
    default         = "development"
}

/* VPC Configuration */

variable "vpc_name" {
    description     = "VPC Name"
    default         = "terraform-ansible"
}

variable "cidr_ab" {
    type = map
    default = {
        development = "172.22"
        qa          = "172.24"
        staging     = "172.26"
        production  = "172.28"
    }
}

locals {
  cidr_c_private_subnets    = 1
  cidr_c_database_subnets   = 11
  cidr_c_public_subnets     = 64

  max_private_subnets       = 2
  max_database_subnets      = 2
  max_public_subnets        = 2
}

locals {
    availability_zones  = data.aws_availability_zones.available.names
}

/* Subnets Configuration */

locals {
    private_subnets = [
        for az in local.availability_zones :
            "${lookup(var.cidr_ab, var.environment)}.${local.cidr_c_private_subnets + index(local.availability_zones, az)}.0/24"
            if index(local.availability_zones, az) < local.max_private_subnets
    ]

    database_subnets = [
        for az in local.availability_zones :
            "${lookup(var.cidr_ab, var.environment)}.${local.cidr_c_database_subnets + index(local.availability_zones, az)}.0/24"
            if index(local.availability_zones, az) < local.max_database_subnets
    ]

    public_subnets = [
        for az in local.availability_zones :
            "${lookup(var.cidr_ab, var.environment)}.${local.cidr_c_public_subnets + index(local.availability_zones, az)}.0/24"
            if index(local.availability_zones, az) < local.max_public_subnets
    ]
}

/* Security Groups Names */

variable "web_sg_name" {
    description     = "Web Security Group Name"
    default         = "web_sg"
}

variable "web_sg_description" {
    description     = "Web Security Group Description"
    default         = "Allow incoming HTTP connections"
}

variable "alb_sg_name" {
    description     = "ALB Security Group Name"
    default         = "alb_sg"
}

variable "alb_sg_description" {
    description     = "ALB Security Group Description"
    default         = "Terraform Ansible ALB Security Group"
}

variable "db_sg_name" {
    description     = "DB Security Group Name"
    default         = "db_sg"  
}

variable "db_sg_description" {
    description     = "DB Security Group Description"
    default         = "Allow incoming database connections from public web servers"
}


/* EC2 Configuration Init */

variable "aws_amis" {
    description     = "AMIs by Region"
    default = {
        us-east-1 = "ami-00068cd7555f543d5" # ami-00068cd7555f543d5 Amazon Linux 2 AMI
    }
}

variable "ec2_machine_type" {
    description     = "Cloud Machine Type"
    default         = "t2.micro"
}

variable "number_of_instances" {
    description     = "Number of instances"
    default         = 1
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

/* Instances Tags */

variable "instance_name" {
    description     = "Tag for the instances name"
    default         = "App"
}

/* RDS Configuration Init */

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

#variable "private_subnet_cidr" {
#    description     = "CIDR for the Private Subnet"
#    default         = "10.20.7.0/24"
#}

#variable "private_subnet_cidr_b" {
#    description     = "CIDR for the Private Subnet B"
#    default         = "10.20.8.0/24"
#}
