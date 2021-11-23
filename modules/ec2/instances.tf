resource "aws_instance" "web" {
  #count         = var.ec2_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name   = var.key_name
  #security_groups = "${var.sg_name}"
  tags = {
    Name = "MyBastion"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = var.sg_name
  network_interface_id = aws_instance.web.primary_network_interface_id
}


