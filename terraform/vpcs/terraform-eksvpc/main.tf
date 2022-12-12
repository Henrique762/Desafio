resource "aws_vpc" "eks-vpc" {
  cidr_block = "172.16.0.0/20"
  enable_dns_hostnames = true

    tags = {
      "Name" = "eks-vpc"
    }
}

#### SUBNETS PUBLICS

resource "aws_subnet" "eks-public1" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "172.16.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public1"
  }
}

resource "aws_subnet" "eks-public2" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "172.16.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public2"
  }
}

#### SUBNETS PRIVATES ####
resource "aws_subnet" "eks-private1" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "172.16.1.0/24" 
  availability_zone = "us-east-1a"

  tags = {
    Name = "eks-private1"
  }
}

resource "aws_subnet" "eks-private2" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "172.16.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "eks-private2"
  }
}

#### SUBNETS DATABASES ####
resource "aws_subnet" "eks-database-1" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "172.16.4.0/24" 
  availability_zone = "us-east-1a"

  tags = {
    Name = "eks-database-1"
  }
}

resource "aws_subnet" "eks-database-2" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "172.16.5.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "eks-database-2"
  }
}



#### GATEWAY ####
resource "aws_internet_gateway" "eks-gw" {
  vpc_id = aws_vpc.eks-vpc.id
}

#### ROUTE TABLE MAIN
resource "aws_route_table" "eks-route-tb-main" {
  vpc_id = aws_vpc.eks-vpc.id

  #route {
 
  #}
  tags = {
    Name = "eks-route-tb-main"
  }
}
resource "aws_main_route_table_association" "eks-route-main" {
  vpc_id         = aws_vpc.eks-vpc.id
  route_table_id = aws_route_table.eks-route-tb-main.id
}

#### ROUTE TABLE SUBNETS-PUBLIC ####
resource "aws_route_table" "eks-route-public" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-gw.id
  }
  tags = {
    Name = "eks-route-public"
  }
}

#### ROUTE TABLE SUBNETS-PRIVATE ####
resource "aws_eip" "eks-elastic-nat" {
    vpc = true
}

resource "aws_nat_gateway" "eks-nat" {
  allocation_id = aws_eip.eks-elastic-nat.id
  subnet_id     = aws_subnet.eks-public1.id

  tags = {
    Name = "eks-nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.eks-gw]
}

resource "aws_route_table" "eks-route-private" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks-nat.id
  }
  tags = {
    Name = "eks-route-private"
  }
}

#### ROUTE TABLE SUBNETS-PRIVATE ####
resource "aws_route_table" "eks-route-db-private" {
  vpc_id = aws_vpc.eks-vpc.id
  tags = {
    Name = "eks-route-db-private"
  }
}


#### ASSOCIAR ROUTE TABLES COM SUBNETS ####
resource "aws_route_table_association" "eks-associate-public1" {
  subnet_id      = aws_subnet.eks-public1.id
  route_table_id = aws_route_table.eks-route-public.id
}
resource "aws_route_table_association" "eks-associate-public2" {
  subnet_id      = aws_subnet.eks-public2.id
  route_table_id = aws_route_table.eks-route-public.id
}
resource "aws_route_table_association" "eks-associate-private1" {
  subnet_id      = aws_subnet.eks-private1.id
  route_table_id = aws_route_table.eks-route-private.id
}
resource "aws_route_table_association" "eks-associate-private2" {
  subnet_id      = aws_subnet.eks-private2.id
  route_table_id = aws_route_table.eks-route-private.id
}
resource "aws_route_table_association" "eks-associate-db-1" {
  subnet_id      = aws_subnet.eks-database-1.id
  route_table_id = aws_route_table.eks-route-db-private.id
}
resource "aws_route_table_association" "eks-associate-db-2" {
  subnet_id      = aws_subnet.eks-database-2.id
  route_table_id = aws_route_table.eks-route-db-private.id
}


#### SECURITY GROUPS ####
resource "aws_security_group" "allow_http" {
  name        = "eks-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.eks-vpc.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-sg"
  }
}






