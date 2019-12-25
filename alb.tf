resource "aws_security_group" "alb" {
    name        = "terraform_alb_security_group"
    description = "Terraform Load Balancer Security Group"
    vpc_id      = aws_vpc.default.id

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all outbound traffic.
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "terraform-alb-security-group"
    }
}

resource "aws_alb" "alb" {
    name            = "terraform-example-alb"
    security_groups = [aws_security_group.alb.id]
    subnets         = [aws_subnet.main.*.id]
    tags = {
        Name = "terraform-example-alb"
    }
}