variable "subnet_id" {}
variable "ami_id" {}
variable "instance_type"{
    default = "t2.micro"
}
variable "ec2_count"{
    type = number
    default = "1"
}
variable "key_name" {
  default ="devkey"
}

variable "sg_name" {
  
}
