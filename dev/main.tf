data "aws_ami" "bastionhost-amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"] # Amazon

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm*",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}


module "my_key_create" {
  source   = "../modules/key"
  key_name = "devkey"
}

module "my_vpc" {
  source      = "../modules/vpc"
  vpc_cidr    = "192.168.0.0/16"
  tenancy     = "default"
  vpc_id      = module.my_vpc.vpc_id
  subnet_cidr = "192.168.1.0/24"
}

module "my_sg" {
  source = "../modules/sg"
  vpc_id = module.my_vpc.vpc_id
}

module "my_ec2" {
  source = "../modules/ec2"
  #ec2_count     = 1
  ami_id        = data.aws_ami.bastionhost-amazon-linux-2.id
  instance_type = "t2.micro"
  subnet_id     = module.my_vpc.subnet_id
  key_name      = module.my_key_create.key_name_op
  sg_name       = module.my_sg.security_group
  #net_id = module.my_vpc.vpc_id
}



resource "aws_eip" "lb" {
  instance = module.my_ec2.instance
  vpc      = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = module.my_vpc.vpc_id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "example" {
  vpc_id = module.my_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}