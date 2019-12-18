/* Database Servers */

resource "aws_security_group" "db" {
    name            = "vpc_db"
    description     = "Allow incoming database connections."

    ingress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.web.id]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.vpc_cidr]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [var.vpc_cidr]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = aws_vpc.default.id

    tags = {
        Name = "DBServerSG"
    }
}

# resource "aws_instance" "db-1" {
#     ami                     = lookup(var.aws_amis, var.aws_region)
#     availability_zone       = var.availability_zone
#     instance_type           = "m1.small"
#     #key_name               = var.aws_key_name
#     vpc_security_group_ids  = [aws_security_group.db.id]
#     subnet_id               = aws_subnet.us-east-1a-private.id
#     source_dest_check       = false

#     tags = {
#         Name = "DB Server 1"
#     }
# }

resource "aws_db_subnet_group" "us-east-1a-private" {
    name       = "db_private_subnet"
    subnet_ids = [aws_subnet.us-east-1a-private.id, aws_subnet.us-east-1b-private.id]

    tags = {
        Name = "MySQL DB Subnet Group"
    }
}

resource "aws_db_instance" "default" {
    allocated_storage       = 20
    storage_type            = "gp2"
    engine                  = "mysql"
    engine_version          = "5.7"
    instance_class          = "db.t2.micro"
    name                    = "clientsdb"
    username                = "admindb"
    password                = "a1s2d3f4"
    parameter_group_name    = "default.mysql5.7"
    availability_zone       = var.availability_zone
    vpc_security_group_ids  = [aws_security_group.db.id]
    db_subnet_group_name    = aws_db_subnet_group.us-east-1a-private.name
    skip_final_snapshot     = "true"
}