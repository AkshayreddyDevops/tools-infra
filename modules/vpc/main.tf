resource "aws_vpc" "main" {
  cidr_block =  var.cidr
  tags={
    Name= "${var.env}"
  }
}

#peering
resource "aws_vpc_peering_connection" "vpcpeer" {
  peer_vpc_id = aws_vpc.main.id
  vpc_id = var.default_vpc_id
  auto_accept = true
}

resource "aws_route" "default-vpc-peer-route" {
  route_table_id = var.default_vpc_route_table
  destination_cidr_block = var.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeer.id
}
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name = "public-subnet-${split("-",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_subnet" "db" {
  count = length(var.db_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.db_subnets[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name = "DB-Subnets-${split("-",var.availability_zone[count.index])[2]}"
  }
}


resource "aws_subnet" "app" {
  count = length(var.app_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.app_subnets[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name = "app-Subnets-${split("-",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_subnet" "web" {
  count = length(var.web_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.web_subnets[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name = "web-Subnets-${split("-",var.availability_zone[count.index])[2]}"
  }
}

## Rout tables
resource "aws_route_table" "public"{
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeer.id
  }
   tags = {
    Name = "public-route-${split("-",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_route_table" "db"{
  count = length(var.db_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeer.id
  }
   tags = {
    Name = "db-route-${split("-",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_route_table" "web"{
  count = length(var.web_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeer.id
  }
   tags = {
    Name = "web-route-${split("-",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_route_table" "app"{
  count = length(var.app_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeer.id
  }
   tags = {
    Name = "app-route-${split("-",var.availability_zone[count.index])[2]}"
  }
}

## Route table association 

resource "aws_route_table_association" "public"{
  count = length(var.public_subnets)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table_association" "db"{
  count = length(var.db_subnets)
  subnet_id = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db[count.index].id
}

resource "aws_route_table_association" "app"{
  count = length(var.app_subnets)
  subnet_id = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app[count.index].id
}


resource "aws_route_table_association" "web"{
  count = length(var.web_subnets)
  subnet_id = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app[count.index].id
}


#Internet Gateway

resource "aws_internet_gateway" "main"{
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-igw"
  }
}

#NAT gateway

resource "aws_eip" "ngw-ip"{
  count = length(var.availability_zone)
  domain = "vpc"
}
resource "aws_nat_gateway" "nat" {
  count = length(var.availability_zone)
  allocation_id = aws_eip.ngw-ip[count.index].id
  subnet_id = aws_subnet.public[count.index].id

  tags ={
    Name = "nat-gw--${split("-",var.availability_zone[count.index])[2]}"
  }

  depends_on = [ aws_internet_gateway.main ]
}