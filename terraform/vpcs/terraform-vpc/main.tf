resource "aws_vpc" "geral" {
  cidr_block = "172.16.0.0/20"
  enable_dns_hostnames = true

    tags = {
      "Name" = "geral"
    }
}

#### SUBNETS PUBLICS

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.geral.id
  cidr_block = "172.16.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "geral-public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.geral.id
  cidr_block = "172.16.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "geral-public2"
  }
}

#### SUBNETS PRIVATES ####
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.geral.id
  cidr_block = "172.16.1.0/24" 
  availability_zone = "us-east-1a"

  tags = {
    Name = "geral-private1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.geral.id
  cidr_block = "172.16.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "geral-private2"
  }
}

#### SUBNETS DATABASES ####
resource "aws_subnet" "database-1" {
  vpc_id     = aws_vpc.geral.id
  cidr_block = "172.16.4.0/24" 
  availability_zone = "us-east-1a"

  tags = {
    Name = "database-1"
  }
}

resource "aws_subnet" "database-2" {
  vpc_id     = aws_vpc.geral.id
  cidr_block = "172.16.5.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "database-2"
  }
}



#### GATEWAY ####
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.geral.id
}

#### ROUTE TABLE MAIN
resource "aws_route_table" "route-tb-main" {
  vpc_id = aws_vpc.geral.id

  #route {
 
  #}
  tags = {
    Name = "route-tb-main"
  }
}
resource "aws_main_route_table_association" "route-main" {
  vpc_id         = aws_vpc.geral.id
  route_table_id = aws_route_table.route-tb-main.id
}

#### ROUTE TABLE SUBNETS-PUBLIC ####
resource "aws_route_table" "route-public" {
  vpc_id = aws_vpc.geral.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "route-public"
  }
}

#### ROUTE TABLE SUBNETS-PRIVATE ####
resource "aws_eip" "elastic-nat" {
    vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic-nat.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "route-private" {
  vpc_id = aws_vpc.geral.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "route-private"
  }
}

#### ROUTE TABLE SUBNETS-PRIVATE ####
resource "aws_route_table" "route-db-private" {
  vpc_id = aws_vpc.geral.id
  tags = {
    Name = "route-db-private"
  }
}


#### ASSOCIAR ROUTE TABLES COM SUBNETS ####
resource "aws_route_table_association" "associate-public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.route-public.id
}
resource "aws_route_table_association" "associate-public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.route-public.id
}
resource "aws_route_table_association" "associate-private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.route-private.id
}
resource "aws_route_table_association" "associate-private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.route-private.id
}
resource "aws_route_table_association" "associate-db-1" {
  subnet_id      = aws_subnet.database-1.id
  route_table_id = aws_route_table.route-db-private.id
}
resource "aws_route_table_association" "associate-db-2" {
  subnet_id      = aws_subnet.database-2.id
  route_table_id = aws_route_table.route-db-private.id
}


#### SECURITY GROUPS ####
resource "aws_security_group" "sg-jenkins" {
  name        = "jenkins-sg"
  description = "Allow Ingress"
  vpc_id      = aws_vpc.geral.id

  ingress {
    description      = "Liberar acesso ao Jenkins"
    from_port        = 8080
    to_port          = 8080
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Liberar SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_security_group" "sg-desafio1" {
  name        = "desafio1"
  description = "Allow Ingress"
  vpc_id      = aws_vpc.geral.id

  ingress {
    description      = "Liberar HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Liberar SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "desafio1-sg"
  }
}






