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


variable "environment" {
    description     = "Environment Definition - Options: development, qa, staging, production"
    default         = "development"
}

/* Subnets */

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

# Subnets per availability zone

variable "region" {
    type            = map(string)
    default         = {
        "development"   = "us-east-1"
        "qa"            = "us-east-1"
        "staging"       = "us-east-2"
        "production"    = "us-east-2"
    }
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
