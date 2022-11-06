resource "aws_vpc" "geral" {
  cidr_block = "172.16.0.0/20"

    tags = {
      "Name" = "vpc-geral"
    }
}
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.geral.id
  cidr_block = "172.16.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "vpcgeral-public1"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.geral.id
  cidr_block = "172.16.1.0/24" 
  availability_zone = "us-east-1a"

  tags = {
    Name = "vpcgeral-private1"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.geral.id
  cidr_block = "172.16.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "vpcgeral-public2"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.geral.id
  cidr_block = "172.16.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "vpcgeral-private2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.geral.id
}

resource "aws_route_table" "route-tb-main" {
  vpc_id = aws_vpc.geral.id

  route {
    destination_cidr_block = "172.16.0.0/20"
  }
  tags = {
    Name = "route-public"
  }
}
resource "aws_main_route_table_association" "route-main" {
  vpc_id         = aws_vpc.geral.id
  route_table_id = aws_route_table.route-tb-main.id
}
