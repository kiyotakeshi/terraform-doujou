#----------------------
# log bucket for alb
resource "aws_s3_bucket" "alb_log" {
  bucket        = "${var.PROJECT_NAME}-alb-log"
  force_destroy = true

  lifecycle_rule {
    enabled = true

    # delete file that over 180 days
    expiration {
      days = "180"
    }
  }
}

#----------------------
# bucket policy
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = "${aws_s3_bucket.alb_log.id}"
  policy = "${data.aws_iam_policy_document.alb_log.json}"
}

# describe policy document
data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["582318560864"]
    }
  }
}

#----------------------
# alb
resource "aws_alb" "doujou_alb" {
  name                       = "${var.PROJECT_NAME}-Front-End-ALB"
  security_groups            = ["${aws_security_group.webserver_alb.id}"]
  subnets                    = ["${aws_subnet.public_0.id}", "${aws_subnet.public_1.id}"]
  internal                   = false
  enable_deletion_protection = false

  access_logs {
    bucket  = "${aws_s3_bucket.alb_log.id}"
    enabled = true
  }
}

#----------------------
# alb target group
resource "aws_alb_target_group" "doujou_alb_targer_group" {
  name     = "${var.PROJECT_NAME}-ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.doujou.id}"

  health_check {
    interval            = 30
    path                = "/index.html"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}

#----------------------
# target attachment
resource "aws_alb_target_group_attachment" "alb_target_doujou01" {
  target_group_arn = "${aws_alb_target_group.doujou_alb_targer_group.arn}"
  target_id        = "${aws_instance.doujou01.id}"
  port             = 80
}

resource "aws_alb_target_group_attachment" "alb_target_doujou02" {
  target_group_arn = "${aws_alb_target_group.doujou_alb_targer_group.arn}"
  target_id        = "${aws_instance.doujou02.id}"
  port             = 80
}

#----------------------
# alb listener (どのポートでリクエストを受けるか)
# associate alb with target group
resource "aws_alb_listener" "doujou_alb_listener" {
  load_balancer_arn = "${aws_alb.doujou_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.doujou_alb_targer_group.arn}"
    type             = "forward"
  }
}

#----------------------
# ELB
# # Load balancer for web server
# resource "aws_elb" "front_end" {
#   name            = "${var.PROJECT_NAME}-Front-End-ELB"
#   internal        = false
#   security_groups = ["${aws_security_group.webserver_elb.id}"]
#   subnets         = ["${aws_subnet.public_0.id}", "${aws_subnet.public_1.id}"]
#   "listener" {
#     instance_port     = 80
#     instance_protocol = "HTTP"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }
#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:80/"
#     interval            = 30
#   }
#   instances                   = ["${aws_instance.doujou01.id}", "${aws_instance.doujou02.id}"]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 200
#   connection_draining         = true
#   connection_draining_timeout = 200
#   access_logs {
#     bucket  = "${aws_s3_bucket.alb_log.id}"
#     enabled = true
#   }
# }
# #----------------------
# # log bucket for alb
# resource "aws_s3_bucket" "alb_log" {
#   bucket = "${var.PROJECT_NAME}-alb-log"
#   force_destroy = true
#   lifecycle_rule {
#     enabled = true
#     # delete file that over 180 days
#     expiration {
#       days = "180"
#     }
#   }
# }
# #----------------------
# # bucket policy
# resource "aws_s3_bucket_policy" "alb_log" {
#   bucket = "${aws_s3_bucket.alb_log.id}"
#   policy = "${data.aws_iam_policy_document.alb_log.json}"
# }
# # describe policy document
# data "aws_iam_policy_document" "alb_log" {
#   statement {
#     effect    = "Allow"
#     actions   = ["s3:PutObject"]
#     resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]
#     principals {
#       type        = "AWS"
#       identifiers = ["582318560864"]
#     }
#   }
# }

