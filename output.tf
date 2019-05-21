output "doujou01_instance_id" {
  value = "${aws_instance.doujou01.id}"
}

output "doujou01_public_dns" {
  value = "${aws_instance.doujou01.public_dns}"
}

output "doujou02_instance_id" {
  value = "${aws_instance.doujou02.id}"
}

output "doujou02_public_dns" {
  value = "${aws_instance.doujou02.public_dns}"
}

output "Web Server Load Balancer Endpoint" {
  value = "${aws_alb.doujou_alb.dns_name}"
}

output "doujou_vpc_id" {
  value = "${aws_vpc.doujou.id}"
}

output "rds_prod_endpoint" {
  value = "${aws_db_instance.doujou.endpoint}"
}


terraform {
  backend "s3" {
    bucket = "doujou-terraform"
    key    = "main/terraform.tfstate"
    region = "ap-northeast-1"
  }
}


# 外部から参照する場合
# subnet_id = "${data.terraform_remote_state.data.public_subnet_id}"
# subnet_id = "${data.terraform_remote_state.data.public_subnet_id}"
# subnet_id = "${data.terraform_remote_state.data.public_subnet_id}"
# subnet_id = "${data.terraform_remote_state.data.public_subnet_id}"

