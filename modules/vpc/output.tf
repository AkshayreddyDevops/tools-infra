output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "web_subnet_ids" {
  value = aws_subnet.web.*.id
}

output "app_subnet_ids" {
  value = aws_subnet.app.*.id
}

output "db_subnet_ids" {
  value = aws_subnet.db.*.id
}

output "subnet" {
  value = tomap({
    "web" = aws_subnet.web[count.index].id
    "app" = aws_subnet.app[count.index].id
    "db" = aws_subnet.db[count.index].id
    "public" = aws_subnet.public[count.index].id
  })
}