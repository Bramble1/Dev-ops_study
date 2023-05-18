variable "awsimageid"{
	description = "aws image id variable"
	type = string
	default = "ami-09744628bed84e434"
}

variable "vpc_id"{
	description = "ID for the vpc,virtual private cloud"
	type = string
	default = "vpc-03e77649069afb978"
}

variable "key"{
	description="the key name refferring to the pem file group on aws"
	type = string
	default = "access"
}

variable "region"{
	description="set the region for the provider"
	type = string
	default = "eu-west-2"
}
