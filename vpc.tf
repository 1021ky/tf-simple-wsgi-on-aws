resource "aws_vpc" "main_vpc" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.0.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main"
  }
}
