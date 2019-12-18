/* Web Servers */

resource "aws_security_group" "web" {
    name            = "vpc_web"
    description     = "Allow incoming HTTP connections."

    ingress { # http
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress { # https
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress { # icmp∫
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress { # MySQL
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = [var.private_subnet_cidr]
    }

    vpc_id = aws_vpc.default.id

    tags = {
        Name = "WebServerSG"
    }
}

resource "aws_instance" "webserver" {
    ami                         = lookup(var.aws_amis, var.aws_region)
    availability_zone           = var.availability_zone
    instance_type               = var.machine_type
    key_name                    = aws_key_pair.admin_key.key_name
    #key_name                    = var.key_name
    vpc_security_group_ids      = [aws_security_group.web.id]
    subnet_id                   = aws_subnet.us-east-1a-public.id
    associate_public_ip_address = true
    source_dest_check           = false

    tags = {
        Name = "Frontend Server"
    }
}

resource "aws_eip" "webserver" {
    instance    = aws_instance.webserver.id
    vpc         = true
}

resource "aws_key_pair" "admin_key" {
    key_name    = "admin_key"
    public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHczwxI9IS1TFYTFHTSvvh+yaOTjAil3WNuW8aks5ZdCjCYGfWzfufqrOsfEfTZe+21HRdrx3HdIgGPiW2GNubSmWj7a2M28hLTRt0XSWCvMdkBbaiUJWLhfc8Y5nHBCy813kMs9CgqMN8c6xvyaQt0mNFPh4uEmb0N+dQb6lkibEhBJynNmatALEyin8VDsAzZlISEbmqIhx6s+Ju1luv2YeE5QxjW2A48duHyONiP3fx4DpqZrIY9ZlhBChdTB+vIn+v5iZiG9cYCqqzdmIZTowGub7h7gSx7kYLignFa10uoWmMDR8gNxm59C2r2w7cvqMzxRR39LJ8+TyDAVWj"
}