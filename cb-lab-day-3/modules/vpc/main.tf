# Declare the AWS provider block and pass the 
#required configurations arguments for the provivder 

provider "aws" {
  region = var.region
}

// vpc for the lab web servers
resource "aws_vpc" "cbl-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "cbl-vpc"
    }
  
}

// internet gateway for accessing the lab web servers
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cbl-vpc.id

  tags = {
    Name = "cbl-igw"
  }
}

#Get main route table to modify
data "aws_route_table" "main_route_table" {
  filter {
    name   = "association.main"
    values = ["true"]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.cbl-vpc.id]
  }
}


#Create route table in us-east-1
resource "aws_default_route_table" "internet_route" {
  default_route_table_id = data.aws_route_table.main_route_table.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "cbl-RouteTable"
  }
}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  state = "available"
}

// creates subnet for the webservers
resource "aws_subnet" "cbl-subnet" {
  vpc_id = aws_vpc.cbl-vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
      Name = "cbl-subnet"
  }
}
