data "aws_availability_zones" "available-azs" {
  state = "available"
}

provider "aws" {
    region = "${var.region}"
    profile = "terraform-user"
}

# Create VPC
resource "aws_vpc" "terraform_vpc" { 
    cidr_block = var.vpc_cidr
    enable_dns_support = var.true
    enable_dns_hostnames = var.true
    
    tags = {
        Name = format(
            "terraform_vpc-${var.application_name}"
        )
    }
}


# Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.terraform_vpc.id

    tags = {
        Name = "terraform_igw-${var.application_name}"
    }
}


#************************************#
#  Configuration for Public Subnets  #
#************************************#

# Crete public subnets in each of the specified Availability Zones
resource "aws_subnet" "public_subnet" {
    count = length(var.availability_zones)

    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
    availability_zone = element(var.availability_zones, count.index)
    map_public_ip_on_launch = true

    tags = {
        Name = format(
            "${var.application_name}-public-subnet-${count.index}"
        )
        Tier = "public"
    }
}


# Create route table for public subnets
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.terraform_vpc.id

    route {
        cidr_block = var.default_route
        gateway_id = "${aws_internet_gateway.internet_gateway.id}"
    }

    tags = {
        Name = format(
            "${var.application_name}-public-route-table"
        )
        Tier = "public"
    }
}

# Create route table association for public subnets route table
resource "aws_route_table_association" "public_subnet_association" {
    count = length(var.availability_zones)

    depends_on     = [aws_subnet.public_subnet]
    subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
    route_table_id = aws_route_table.public_route_table.id
}


#***************************************#
#  Configuration for Private Subnets    #
#***************************************#

# Create private subnets in each of the specified Availability Zones
resource "aws_subnet" "private_subnet" {
    count = length(var.availability_zones)

    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + length(var.availability_zones))
    availability_zone = element(var.availability_zones, count.index)
    map_public_ip_on_launch = false

    tags = {
        Name = format(
            "${var.application_name}-private-subnet-${count.index}"
        )
        Tier = "private"
    }
}

# Configure Elastic IP used by NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
    vpc = true
    depends_on = [aws_internet_gateway.internet_gateway]
    tags = {
        Name = format(
            "nat_eip-${var.application_name}"
        )
    }
}

# Create NAT Gateway
# (Subnet used by NAT Gateway is the first index public subnet)
resource "aws_nat_gateway" "nat_gateway" {
    depends_on = [aws_internet_gateway.internet_gateway]
    allocation_id = aws_eip.nat_gateway_eip.id
    subnet_id = element(aws_subnet.public_subnet.*.id, 0)

    tags = {
        Name = format(
            "nat-gw-${var.application_name}"
        )
    }
}


# Create route table for private subnet
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.terraform_vpc.id
    route {
        cidr_block = var.default_route
        gateway_id = "${aws_nat_gateway.nat_gateway.id}"
    }

    tags = {
        Name = format(
            "${var.application_name}-private-route-table"
        )
        Tier = "private"
    }
}

# Create route table association for private subnet route table
resource "aws_route_table_association" "private_subnet_association" {
    count = length(var.availability_zones)

    depends_on     = [aws_subnet.private_subnet]
    subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
    route_table_id = aws_route_table.private_route_table.id
}

