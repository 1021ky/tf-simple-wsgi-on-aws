resource "aws_vpc" "main_vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    "Name"    = "main_vpc"
    "project" = "tf-simple-wsgi-on-aws"
  }
}
data "aws_availability_zone" "az-us-west-2a" {
  name = "us-west-2a"
}
data "aws_availability_zone" "az-us-west-2c" {
  name = "us-west-2c"
}
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.10.0.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.10.64.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_eip" "nat_ip" {
}

resource "aws_nat_gateway" "ngw-from-private" {
  subnet_id         = aws_subnet.public_subnet.id
  connectivity_type = "public"
  allocation_id     = aws_eip.nat_ip.id

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table_association" "public_subnet_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private_subnet_rt_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_rt"
  }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw-from-private.id
  }

  tags = {
    Name = "private_rt"
  }
}
