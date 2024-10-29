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

  tags = {
    Name = "public-subnet"
  }
}