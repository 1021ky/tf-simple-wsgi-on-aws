# ec2用ami

module "basation_ami" {
  source = "./modules"
}

resource "aws_instance" "basation" {
  ami           = module.basation_ami.ami_id
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "webserver"
  }
}
