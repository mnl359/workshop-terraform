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
    #key_name                    = aws_key_pair.admin_key.key_name
    key_name                    = var.key_name
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
    public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDftZwLvh3prVYPxD01zBpehPA6NVlL+iDajlDR2PqzB3odo5gVrV+u6vTyw/TfFR70uOkzoLjxl6x7ZbwXpKBAXqD8ke8gIDOAL4wz8QSKtj1lcLiLOEW0ToKhlwHvlZnA0e/GATtCgt/2y4F+h+jG0VmO3Ae+8aayCOSPVHqKhXcdKt5Qa++/7SuUrTuBN6ApJNp7HmVbMGdSbrr4I1gxNDYONompBTwVvBswBy8ySA+BNaAnKUxsX5gJJCtNENcbtg44TMHufmn69XZeUajDtNGeOgeITAIWnuEiOY+3R70idXJZGSDRnZzs4sXYmP7k4PQq07sWuHqXVKUzYWI/ test"
}