resource "aws_security_group" "name" {
  name = "${var.name}-${var.env}-sg"
  vpc_id = var.vpc_id
  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = "0.0.0.0/0"
    protocol = "-1"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.bastion_nodes
  }
    ingress {
    from_port = var.app_port
    to_port = var.app_port
    protocol = "tcp"
    cidr_blocks = var.app_sg_cidr
  }
  tags = {
    Name = "${var.name}-${var.env}-sg"
  }
}