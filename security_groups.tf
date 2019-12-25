/* Public Security Groups */

module "web_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web_sg"
  description = "Allow incoming HTTP connections"
  vpc_id      = aws_vpc.default.id

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