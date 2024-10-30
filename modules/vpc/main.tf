resource "aws_vpc" "main" {
  cidr_block =  var.cidr
  tags={
    Name= "${var.env}"
  }
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

   tags = {
    Name = "public-route-${split("-",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_route_table" "db"{
  count = length(var.db_subnets)
  vpc_id = aws_vpc.main.id

   tags = {
    Name = "db-route-${split("-",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_route_table" "web"{
  count = length(var.web_subnets)
  vpc_id = aws_vpc.main.id

   tags = {
    Name = "web-route-${split("-",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_route_table" "app"{
  count = length(var.app_subnets)
  vpc_id = aws_vpc.main.id

   tags = {
    Name = "app-route-${split("-",var.availability_zone[count.index])[2]}"
  }
}

## Route table association 

resource "aws_route_table_association" "public"{
  count = length(var.public_subnets)
  subnet_id = aws_subnet.public.id[count.index]
  route_table_id = aws_route_table.public.id[count.index]
}

# resource "aws_route_table_association" "db"{
#   count = length(var.db_subnets)
#   subnet_id = aws_subnet.public.id
#   route_table_id = aws_route_table.public.id
# }