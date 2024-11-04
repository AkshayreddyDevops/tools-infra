resource "aws_security_group" "sg" {
  name = "${var.name}-${var.env}-sg"
  vpc_id = var.vpc_id
  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.bastion_nodes
  }
    ingress {
    from_port = var.allow_port
    to_port = var.allow_port
    protocol = "tcp"
    cidr_blocks = var.allow_sg_cidr
  }
  tags = {
    Name = "${var.name}-${var.env}-sg"
  }
}



resource "aws_instance" "main" {
  ami = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  subnet_id = var.subnet_ids
  vpc_security_group_ids = [aws_security_group.sg.id]
  # to run env specific builds ansible/shell ect 
  user_data = base64encode(templatefile("${path.module}/userdata.sh"
  , {
    env_name = var.env
    role_name = var.name
  }))
  tags = {
    Name = "${var.name}-${var.env}"
  }
}

resource "aws_route53_record" "instance" {
  zone_id = var.zone_id
  name = "${var.name}-${var.env}"
  type = "A"
  ttl = 30
  records = [aws_instance.main.*.private_ip]
}





