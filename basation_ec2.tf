# ec2用ami

resource "aws_key_pair" "basation_key_pair" {
  key_name   = "basation_key_pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCut+JF1fznZFaA9RVPUYSUijlJGo5R82Dch4B0jCiQhKMpjICHq9kJx+1jDoUgbcwIiDrEBjOWnn0eMBXuXOWRMpm7evV4dv2tQTV8TfYmrSr74uTyXY2hXu7muwUhzyyhFGZznzEJss0lxPX6lvwOE73yzYPoTB4pmh3Bbzxaz1ykvLqriPvLEAQkBw7w2nI6i3Q37y3+aUuO9kykwcprB2S31MEKDD8g6oNl2EI4q31rDXbPIb2US16HjWcv1Z4UKfVPkzjAehQkd/J+ING0H2nx13Z2N44hISgTVUEuxykpLC1/5tdpGdenDhK7tVqbo4QzKKAuEX9DQ3OM3RecPQ8GwBUj48h4kw/4u1I+KcAGNeMNwE/+qCs0XaR6WcFLRAZaePYpU/VY0Pq19IpoyPDLMJ/vOC551n6cO4/Nnpaw4Fhe6EWb9Y71kMmLE+IKQVhaOjY5AwYTXHIcUhQ9GniqLyH5WI0nUJSKQoGiI6QF/zPuiu3fduhuuHCZ/S8= ksanchu@KeisukenoMacBook-Air.local"
}
module "basation_ami" {
  source = "./modules"
}
resource "aws_eip" "basation_ip" {
  instance = aws_instance.basation.id
}
resource "aws_instance" "basation" {
  ami                    = module.basation_ami.ami_id
  instance_type          = "t3.nano"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = aws_key_pair.basation_key_pair.id
  vpc_security_group_ids = [aws_security_group.ssh_sg.id, aws_security_group.web_sg.id]
  tags = {
    Name = "basation"
  }
}

