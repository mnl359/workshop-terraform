/* Public Security Groups */

module "web_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web_sg"
  description = "Allow incoming HTTP connections"
  vpc_id      = module.vpc.vpc_id # aws_vpc.default.id

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
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH ports"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      description = "Allow ICMP"
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
        Name = "WebServerSG"
    }
}

/* Private Security Group */ 

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db_sg"
  description = "Allow incoming database connections."
  vpc_id      = module.vpc.vpc_id # aws_vpc.default.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL Database"
      security_groups = module.web_sg.this_security_group_id # to review while testing the app connection
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH ports"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      description = "Allow ICMP"
      cidr_blocks = module.vpc.vpc_cidr_block
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
        Name = "DBServerSG"
    }
}

/* NAT Security Group */

# module "nat_sg" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "nat_sg"
#   description = "Allow trafic to pass from the private subnet to the internet"
#   vpc_id      = aws_vpc.default.id

#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 80
#       to_port     = 80
#       protocol    = "tcp"
#       description = "HTTP Ports"
#       cidr_blocks = var.private_subnet_cidr
#     },
#     {
#       from_port   = 443
#       to_port     = 443
#       protocol    = "tcp"
#       description = "HTTPS ports"
#       cidr_blocks = var.private_subnet_cidr
#     },
#     {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       description = "SSH ports"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       from_port   = -1
#       to_port     = -1
#       protocol    = "icmp"
#       description = "Allow ICMP"
#       cidr_blocks = "0.0.0.0/0"
#     },
#   ]

#   egress_with_cidr_blocks = [
#     {
#       from_port   = 80
#       to_port     = 80
#       protocol    = "tcp"
#       description = "HTTP Ports"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       from_port   = 443
#       to_port     = 443
#       protocol    = "tcp"
#       description = "HTTPS Ports"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       description = "SSH Ports"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1"
#       description = "Allow to go anywhere"
#       cidr_blocks = "0.0.0.0/0"
#     },
#   ]

#   tags = {
#         Name = "NAT SG"
#     }
# }