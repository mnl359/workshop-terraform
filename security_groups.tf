/* Public Security Groups */

module "web_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web_sg"
  description = "Allow incoming HTTP connections"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH ports"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  # This is to prevent direct access from internet to the instances
  # Users only can access the service through ALB
  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "HTTP Ports"
      source_security_group_id = module.alb_sg.this_security_group_id
    },
  ]


  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow to go anywhere"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = {
        Name = "WebServerSG"
        Terraform               = "true"
        Environment             = "dev"
        Owner                   = "William Munoz"
    }
}

/* Application Load Balancer Security Group */

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "alb_sg"
  description = "Terraform Ansible ALB Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP ports"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS ports"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow to go anywhere"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = {
        Name        = "ALBSG"
        Terraform   = "true"
        Environment = "dev"
        Owner       = "William Munoz"
    }
}

/* Private Security Group */ 

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db_sg"
  description = "Allow incoming database connections from public web servers."
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "MySQL Database"
      source_security_group_id = module.web_sg.this_security_group_id
    },
  ]

  tags = {
        Name        = "DBServerSG"
        Terraform   = "true"
        Environment = "dev"
        Owner       = "William Munoz"
    }
}