#Declare the provider being aws, and we provide the region variable which is in our external variable file
provider "aws" {
	region=var.region
}


#create aws virtual private cloud called main, we tag it to use as a reference for later.
resource "aws_vpc" "main" { 
	cidr_block = "10.0.0.0/16" 
	instance_tenancy = "default" 
	tags = { Name = "main" }

}

#create a subnet resource in our virtual private network
resource "aws_subnet" "subnet1"{
	vpc_id = "${aws_vpc.main.id}"
	cidr_block="10.0.1.0/24"
	map_public_ip_on_launch="true"
	availability_zone = "eu-west-2a"

	tags = {
		Name="subnet1"
	}
}

#creating an aws internet gateway to bind to host port and access internet, route table to route our traffic to our internet gateway we create
resource "aws_internet_gateway" "prod-igw" {
	vpc_id = "${aws_vpc.main.id}"
	tags = { Name="prod-igw" }

}
#now create custom route table for public subnet in order for it to reach the internet
resource "aws_route_table" "prod-public-crt" {
	vpc_id = "${aws_vpc.main.id}"

	route{
	#associated subnet reach anywhere
	cidr_block="0.0.0.0/0"
	#CRT uses this IGW to reach internet
	gateway_id = "${aws_internet_gateway.prod-igw.id}"
	}
	tags = { Name="prod-public-crt" }
	
}

#associate crt and subnet
resource "aws_route_table_association" "subnet1"{
	subnet_id = "${aws_subnet.subnet1.id}"
	route_table_id = "${aws_route_table.prod-public-crt.id}"
}


#create a security group
resource "aws_security_group" "ssh-allowed" {
	vpc_id = "${aws_vpc.main.id}"

	ingress{
		from_port = 22
		to_port = 22
		protocol="tcp"
		cidr_blocks = ["0.0.0.0/0"]
		ipv6_cidr_blocks = ["::/0"]
	}

	egress{
		from_port=0
		to_port = 0
		protocol="-1"
		cidr_blocks = ["0.0.0.0/0"]
		ipv6_cidr_blocks = ["::/0"]
	}


}

#now let's create an instance in our subnet in our vpc
resource "aws_instance" "TEST" {
	ami = var.awsimageid
	instance_type = "t2.micro"

	#vpc
	subnet_id = "${aws_subnet.subnet1.id}"
	
	#security group
	vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
	
	tags = { Name="sub_instance" }
}
	

