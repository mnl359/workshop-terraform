resource "aws_vpc" "default" {
    cidr_block              = var.vpc_cidr
    enable_dns_hostnames    = true

    tags = {
        Name = "terraform-aws-vpc"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = aws_vpc.default.id

    tags = {
        Name = "Terraform Internet Gateway"
    }
}

resource "aws_eip" "default" {
    vpc = true
    depends_on = [aws_internet_gateway.default]
}

resource "aws_nat_gateway" "default" {
    allocation_id   = aws_eip.default.id
    subnet_id       = aws_subnet.us-east-1a-public.id

    tags = {
        Name = "Nat Gateway"
    }

    depends_on = [aws_internet_gateway.default]
}

/* Public Subnet */

resource "aws_subnet" "us-east-1a-public" {
    vpc_id = aws_vpc.default.id

    cidr_block = var.public_subnet_cidr
    availability_zone = "us-east-1a"

    tags = {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "us-east-1a-public" {
    vpc_id = aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.default.id
    }

    tags = {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "us-east-1a-public" {
    subnet_id = aws_subnet.us-east-1a-public.id
    route_table_id = aws_route_table.us-east-1a-public.id
}

/* Private Subnets */

resource "aws_subnet" "us-east-1a-private" {
    vpc_id = aws_vpc.default.id

    cidr_block = var.private_subnet_cidr
    availability_zone = var.availability_zone

    tags = {
        Name = "Private Subnet"
    }
}

resource "aws_subnet" "us-east-1b-private" {
    vpc_id = aws_vpc.default.id

    cidr_block = var.private_subnet_cidr_b
    availability_zone = var.availability_zone_b

    tags = {
        Name = "Private Subnet"
    }
}

resource "aws_route_table" "us-east-1a-private" {
    vpc_id = aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.default.id 
    }

    tags = {
        Name = "Private Subnet"
    }
}

resource "aws_route_table_association" "us-east-1a-private" {
    subnet_id = aws_subnet.us-east-1a-private.id
    route_table_id = aws_route_table.us-east-1a-private.id
}

resource "aws_route_table_association" "us-east-1b-private" {
    subnet_id = aws_subnet.us-east-1b-private.id
    route_table_id = aws_route_table.us-east-1a-private.id
}