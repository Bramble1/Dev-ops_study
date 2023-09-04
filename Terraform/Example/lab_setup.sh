#!/bin/bash

create_directory_structure()
{
	if ! [ -e main.tf ]
	then
		if touch main.tf
		then
			if mkdir Modules Modules/ec2
			then
				if touch Modules/ec2/main.tf Modules/ec2/variables.tf
				then
					echo -e "create_directory_structure() [+]"
				else
					echo -e "create_directory_structure() [-]"
				fi
			fi
		fi
	fi
}

populate_terraform_scripts()
{
	if cat << 'EOF' > main.tf
	terraform {
		required_providers {
			aws = {
				source="hashicorp/aws"
				version="3.7"
			}
		}
	}
	
	provider "aws" {
		region="us-west-2"
	}
	
	module "webserver" {
		source="./Modules/ec2"
		servername="calabvm"
		instance_size="t2.micro"
	}
EOF
then
	echo -e "main.tf populated [+]\n"
	fi


	if cat << 'EOF' > Modules/ec2/main.tf
	terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.7.0"
    }
  }
}
data "aws_ami" "default" {
  most_recent = "true"
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
resource "aws_instance" "server" {
    ami           = var.ami != "" ? var.ami : data.aws_ami.default.image_id
    instance_type = var.instance_size
    tags = {
        Name = "calabvm"
    }
}
EOF
then
	echo -e "Modules/ec2/main.tf populated [+]\n"
else
	echo -e "Modules/ec2/main.tf populated [-]\n" ; exit -1
	fi


	if cat << 'EOF' > Modules/ec2/variables.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.7.0"
    }
  }
}
data "aws_ami" "default" {
  most_recent = "true"
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
resource "aws_instance" "server" {
    ami           = var.ami != "" ? var.ami : data.aws_ami.default.image_id
    instance_type = var.instance_size
    tags = {
        Name = "calabvm"
    }
}
EOF
then
	echo -e "/Modules/ec2/variables.tf populated [+]\n"
else
	echo -e "/Modules/ec2/variables.tf populated [-]\n"; exit -1
	fi	
}

init_infrastructure() 
{
	if terraform init
	then
		if terraform plan
		then
			if terraform apply -auto-approve
			then
				echo -e "infrastructure process complete [+]\n"
			fi
		fi
	fi

}


#Main Code

case $1 in
	1)
		create_directory_structure
		;;
	2)
		populate_terraform_scripts
		;;
	3)
		init_infrastructure
		;;
	4)
		create_directory_structure
		populate_terraform_scripts
		init_infrastructure
		;;
esac	


#create_directory_structure

#populate_terraform_scripts

#init_infrastructure

exit 0
