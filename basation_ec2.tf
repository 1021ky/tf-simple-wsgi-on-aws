# ec2用ami
data "aws_ami" "ubuntu20_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "basation" {
  ami           = data.aws_ami.ubuntu20_ami.id
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "webserver"
  }
}
