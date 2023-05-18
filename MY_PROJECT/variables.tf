variable "aws_id"{
	description="aws image id"
	type=string
	default="ami-09744628bed84e434"
}

variable "vpc_id"{
	description="ID for our virtual private cloud network"
	type=string
	default="vpc-03e77649069afb978"
}

variable "key"{
	description="the key name-->pemfile ssh access"
	type=string
	default="access"
}

variable "region"{
	description="set the region for the provider"
	type=string
	default="eu-west-2"
}

