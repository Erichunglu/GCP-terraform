# Declare the AWS provider block and pass the 
#required configurations arguments for the provivder 

provider "aws" {
  region = "us-east-1"
}


# The data block used to retrieve a value from a resource outside the TF directory
data "aws_ssm_parameter" "cathay-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#declare the module block for the vpc resources
module "vpc" {
  # use a local source - relative path
  source = "./modules/vpc"
  region = var.region
}

module "s3" {
  source = "./modules/s3"
  region = var.region
#  s3-bucket-name = var.site_domain 
}


#declare the module block for the S3 resources
#module "" {
  # use a local source - relative path
#  source = ""
#}



// security group created for the lab web servers
resource "aws_security_group" "cbl-sg" {
  depends_on = [
    module.vpc.vpc-id
  ]
  vpc_id = module.vpc.vpc-id
  name   = join("_", ["sg", module.vpc.vpc-id])
  dynamic "ingress" {
    for_each = var.sg_rules
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cbl-join-and-dynamic-block-SG"
  }
}


#the resource for the aws instance that uses the user_data input
resource "aws_instance" "cathay-web" {
  #use the value provided by
  depends_on = [
    module.s3.bucket-id,
    module.s3.object-id
  ]
  ami           = data.aws_ssm_parameter.cathay-ami.value
  subnet_id     = module.vpc.subnet-id
  security_groups = [aws_security_group.cbl-sg.id]
  instance_type = "t3.micro"
  availability_zone = "us-east-1a"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
  
  tags = {
    Name = "${terraform.workspace}-cathay-web-server"
  }

  user_data = fileexists("script.sh") ? file("script.sh") : null
  #BUCKET_URL= ${module.s3.bucket_domain_name}

}

