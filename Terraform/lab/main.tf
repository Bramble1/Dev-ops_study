terraform {
  backend "s3" {
    bucket="terraformstate7505e1f0"
    key="state/terraform.tfstate"
    region="us-west-2"
  }
}


#specify the provider being aws cloud
provider "aws" {
    region="us-west-2"
}

#create aws virtual private cloud network
resource "aws_vpc" "main"{
    cidr_block="10.0.0.0/24"
    instance_tenancy="default"
    tags = { Name="main" }
}

#create a subnet resource in network
#resource "aws_subnet" "subnet"{
#    vpc_id=aws_vpc.main.id
#    cidr_block="10.0.0.0/25"
#    availability_zone="us-west-2a"

#    tags = { Name="subnet" }
#}

#create an s3 bucket resource for dbtable
#backend where we store state files,in this case s3.
#backend "s3" {
#    bucket="terraformstate4365316d"
#    key="state/terraform.tfstate"
#    region="us-west-2"

#}

#resource "aws_s3_bucket" "terraform_state" {
#  bucket = "terraformstate4365316d"
  #key="state/terraform.tfstate"
     
 # lifecycle {
 #   prevent_destroy = true
 # }
#}

data "aws_iam_policy_document" "example"{


    statement {
            effect="Allow"
            actions=["s3:ListBucket"]
            resources=["arnc:aws:s3:::terraformstate7505e1f0"]
        }
    statement {
            effect="Allow"
            actions=["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
            resources= ["arn:aws:s3:::terraformstate7505e1f0/path/to/my/key"]
        }
    

    statement {
        effect="Allow"
      actions= [
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ]
       #resources=["arn:aws:dynamodb:*:*:table/terraform-state-lock"]
       resources=["arn:aws:dynamodb:*:*:table/${var.mybucket}"]
    }
  
}


#create an ec2 instance resource
resource "aws_instance" "demo1"{
	ami = "ami-07dfed28fcf95241c"
	#ami = var.awsimageid	
	instance_type = "t2.micro"
    #vpc
	#subnet_id = aws_subnet.subnet.id
    #vpc_id=aws_vpc.main.id
	#vpc_security_group_ids = [aws_security_group.allow_ssh.id,"sg-04071389c2ec769a7"]
	
	ebs_block_device {
        device_name = "/dev/sda1"
        volume_size = 20
        }
	tags = {
		Name = "cloudacademylabs"
	}
}

#resource "aws_ebs_volume" "example" {
 # availability_zone = "us-west-2a"
#  region="us-west-2"
 # size              = 20
 # tags = {
 #   Name = "my volume"
 # }
#}

#resource "aws_volume_attachment" "ebs"{
#    device_name = "/dev/sdh"
#    volume_id = aws_ebs_volume.example.id
#    instance_id = aws_instance.demo1.id
#}
