provider "aws" {
  region = var.region
}

resource "aws_vpc" "cbl-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "cbl-vpc"
    }
  
}

resource "aws_subnet" "cbl-subnet" {
    vpc_id = aws_vpc.cbl-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true

    tags = {
        Name = "cbl-subnet"
    }
  
}