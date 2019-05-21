resource "aws_route53_zone" "private" {
  name = "doujou-example.com"

  vpc {
    vpc_id = "${aws_vpc.doujou.id}"
  }
}

resource "aws_route53_record" "instance01" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "instance01.doujou-example.com"
  type    = "A"
  ttl     = "300"

  records = [
    "${aws_instance.doujou01.private_ip}"
  ]
}

resource "aws_route53_record" "instance02" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "instance02.doujou-example.com"
  type    = "A"
  ttl     = "300"

  records = [
    "${aws_instance.doujou02.private_ip}"
  ]
}
