# ec2用ami
data "aws_ami" "amzn2" {
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

resource "aws_instance" "web" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "webserver"
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "appserver"
  }
}


