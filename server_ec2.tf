# ec2用ami
module "server_ami" {
  source = "./modules"
}

resource "aws_instance" "web" {
  ami           = module.server_ami.ami_id
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "webserver"
  }
}

resource "aws_instance" "app" {
  ami = module.server_ami.ami_id

  instance_type = "t3.nano"
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "appserver"
  }
}


