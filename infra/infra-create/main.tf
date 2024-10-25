resource "aws_instance" "tool"{
  ami = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.tool-sg.id]
  tags ={
    Name = var.name
  }
}

resource "aws_security_group" "tool-sg"{
  name = "${var.name}-sg"
  description ="${var.name}-sg"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags={
    Name="${var.name}-sg"
  }
}