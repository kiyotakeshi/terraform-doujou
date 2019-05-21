#----------------------
# alb (web server)

resource "aws_security_group" "webserver_alb" {
  name   = "${var.PROJECT_NAME}-ALB-SG"
  vpc_id = "${aws_vpc.doujou.id}"

  tags {
    Name = "${var.PROJECT_NAME}-ALB-SG"
  }
}

resource "aws_security_group_rule" "webservere_alb_ingress" {
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.webserver_alb.id}"
}

resource "aws_security_group_rule" "webservere_alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.webserver_alb.id}"
}

#----------------------
# ec2 to access apache

resource "aws_security_group" "doujou_ec2" {
  name   = "${var.PROJECT_NAME}-c2-webservers-SG"
  vpc_id = "${aws_vpc.doujou.id}"

  tags {
    Name = "${var.PROJECT_NAME}-ec2-webservers-SG"
  }
}

resource "aws_security_group_rule" "doujou_ec2_ingress" {
  type      = "ingress"
  from_port = "80"
  to_port   = "80"
  protocol  = "tcp"

  source_security_group_id = "${aws_security_group.webserver_alb.id}"

  # 同一のVPC内からのアクセスを許可
  # self              = true
  security_group_id = "${aws_security_group.doujou_ec2.id}"
}

resource "aws_security_group_rule" "doujou_ec2_ssh" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["${var.SSH_CIDR_WEB_SERVER}"]
  security_group_id = "${aws_security_group.doujou_ec2.id}"
}

resource "aws_security_group_rule" "doujou_ec2_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.doujou_ec2.id}"
}

#----------------------
resource "aws_security_group" "doujou_rds" {
  name   = "${var.PROJECT_NAME}-rds-SG"
  vpc_id = "${aws_vpc.doujou.id}"

  tags {
    Name = "${var.PROJECT_NAME}-rds-SG"
  }
}

resource "aws_security_group_rule" "doujou_rds_ingress" {
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.doujou_ec2.id}"
  security_group_id        = "${aws_security_group.doujou_rds.id}"
}

resource "aws_security_group_rule" "doujou_rds_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.doujou_rds.id}"
}
