terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.40.0"
    }
  }
}

provider "aws" {
  # Configuration options
  #alias  = "west"
  region = "us-west-2"
}


data "aws_ssm_parameter" "cathay-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

module "vpc" { #使用者定義的名稱
  source = "./modules/vpc"
  region = var.region
}

resource "aws_instance" "cathay-web" {
#    provider = aws.west
    ami = data.aws_ssm_parameter.cathay-ami.value
    subnet_id = module.vpc.subnet-id
    instance_type = "t3.micro"
    tags = {
       Name = "${terraform.workspace}-cathay-webserver"
    }
}