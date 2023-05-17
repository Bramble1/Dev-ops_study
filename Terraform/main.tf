#provider resource called aws, we use the export and set the variables to our secret key and access key
provider "aws" {
	region= var.region #"eu-west-2"
}


#creating a resource type aws_instance called demo1
resource "aws_instance" "demo1"{
#	ami = "ami-09744628bed84e434"
	ami = var.awsimageid	
	instance_type = "t2.micro"
	key_name = var.key #"access"
	vpc_security_group_ids = [aws_security_group.allow_ssh.id,"sg-04071389c2ec769a7"]
	tags = {
		Name = "terraform instance"
	}

}

#creat a security group resource and reference it in the aws_instnace resource

resource "aws_security_group" "allow_ssh" {
	name = "allow_ssh"
	description = "allow ssh inbound traffic"
	vpc_id	= var.vpc_id #"vpc-03e77649069afb978"

	ingress {
		description = "ssh from vpc"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		ipv6_cidr_blocks = ["::/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		ipv6_cidr_blocks = ["::/0"]
	}

	tags = {
		Name = "allow_tls"
		Project = "Project1"
		Environment = "Prod"
	}
}

#create a output block resource to output IP address
output "PublicIP" {
	value = aws_instance.demo1.public_ip
}

#output "InstanceState" {
#	value = asw_instance.demo1.instance_state
#}

#declare a variable example, for naming aws image id
#variable awsimageid{
#	type = string
#	default = "aws"
#}

