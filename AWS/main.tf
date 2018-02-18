# Provision VPC with cidr block of 10.0.0.0/16
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  tags {
    Name = "main"
  }
}

# Provision public subnet
resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "public"
  }
}

# Provision private subnet
resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"

  tags {
    Name = "private"
  }
}

# Provision Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "gw"
  }
}

# Create route to the internet
resource "aws_route_table" "pub" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "main"
  }
}

# Associate route table to internet with public subnet
resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.pub.id}"
}


# Create security group to allow SSH to bastion server from my ip
resource "aws_security_group" "allow_ssh_myip" {
  name = "Allow_ssh_myip"
  description = "Allow ssh inbound traffic"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["82.11.73.243/32"]
  }
  egress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["${aws_instance.priv.private_ip}"]
  }
}

# Create security group to allow ssh from public subnet to private subnet
resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh_pub_to_priv"
  description = "Allow ssh inbound traffic"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["${aws_instance.pub.private_ip}"]
  }
}

# Provision 1 public instance with AWS AMI
resource "aws_instance" "pub" {
  ami           = "ami-d834aba1"
  instance_type = "t2.micro"
  key_name = "awspaolo"
  subnet_id = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh_myip.id}"]
}

# Provision 1 private instance with AWS AMI
resource "aws_instance" "priv" {
  ami           = "ami-d834aba1"
  instance_type = "t2.micro"
  key_name = "awspaolo"
  subnet_id = "${aws_subnet.private.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
}

# Provision Elastic IP for bastion
resource "aws_eip" "bastion" {}

# Provision Elastic IP for NAT Gateway
resource "aws_eip" "NAT" {}

# Associate Elastic IP with public instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.pub.id}"
  allocation_id = "${aws_eip.bastion.id}"
}

