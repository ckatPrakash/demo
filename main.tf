/*
provider "aws" {
region = "us-east-1"
}

resource "aws_security_group" "web_sg" {
 name = "web_sg"
 description = "Allow HTTP and SSH"

ingress {
    from_port = 80
	to_port = 80
	protocol= "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}

ingress {
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}
egress {
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_instance" "web" {
	ami = "ami-0c02fb55956c7d316"
	instance_type = "t2.micro"
	security_groups = [aws_security_group.web_sg.name]
tags = {
	Name= "application_server"
	Environment = "dev"
}
}

resource "aws_db_instance" "mysql" {
	allocated_storage = 20
	storage_type = "gp2"
	instance_class = "db.t3.micro"
	identifier = "rdstf"
	engine="mysql"
	engine_version = "8.0.27"
	username = "admin"
	password = "password123"
	publicly_accessible = true
	skip_final_snapshot = true
	tags = {
		Name = "myRDS"
	}
}
*/

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-demo"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-demo"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow SSH and http"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami                         = "ami-0c02fb55956c7d316" 
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  #key_name                    = "your-key"  # Replace with your SSH key pair name

  tags = {
    Name = "application_server"
	Environment = "dev"
  }
}
