data "aws_ami" "ubuntu" {
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners = ["099720109477"]
}

resource "aws_instance" "frontend" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  key_name                = "ubuntu_laptop"
  subnet_id               = var.public_subnet_ids[0]
  vpc_security_group_ids = [
    var.security_group["egress"],
    var.security_group["frontend"],
    var.security_group["instance"]
  ]
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-frontend"
  }
}

resource "aws_instance" "backend" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  key_name                = "ubuntu_laptop"
  subnet_id               = var.private_subnet_ids[0]
  vpc_security_group_ids = [
    var.security_group["backend"],
    var.security_group["egress"],
    var.security_group["instance"]
  ]
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-backend"
  }
}
