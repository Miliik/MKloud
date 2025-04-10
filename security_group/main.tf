resource "aws_security_group" "dmz_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all inbound traffic to the DMZ
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic from the DMZ
  }

  tags = {
    Name = "${var.vpc_name}-dmz-sg"
  }
}

resource "aws_security_group" "back_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.dmz_sg.id] # Allow traffic only from the DMZ
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.dmz_sg.id] # Allow traffic only to the DMZ
  }

  tags = {
    Name = "${var.vpc_name}-back-sg"
  }
}