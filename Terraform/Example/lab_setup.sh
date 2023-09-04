#!/bin/bash

create_directory_structure()
{
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
}

populate_terraform_scripts()
{
	cat << 'EOF' > main.tf
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

	


	
}


#Main Code

create_directory_structure
