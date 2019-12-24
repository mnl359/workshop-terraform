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

    ingress { # ssh
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

    egress { # go to anywhere
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = aws_vpc.default.id

    tags = {
        Name = "WebServerSG"
    }
}

resource "aws_instance" "webserver" {
    count                       = var.number_of_instances
    ami                         = lookup(var.aws_amis, var.aws_region)
    availability_zone           = var.availability_zone
    instance_type               = var.machine_type
    key_name                    = aws_key_pair.admin_key.key_name
    vpc_security_group_ids      = [aws_security_group.web.id]
    subnet_id                   = aws_subnet.us-east-1a-public.id
    associate_public_ip_address = true
    source_dest_check           = false

    tags = {
        Name = "App"
    }

    provisioner "local-exec" {
        command = "aws ec2 wait instance-status-ok --instance-ids ${self.id} --profile default && ansible-playbook -i ansible/ec2.py ansible/app.yml --user ec2-user"
    }
}

resource "aws_eip" "webserver" {
    count       = var.number_of_instances
    instance    = aws_instance.webserver[count.index].id
    vpc         = true
}

resource "aws_key_pair" "admin_key" {
    key_name    = "admin_key"
    public_key  = file(var.ssh_public_key)
}