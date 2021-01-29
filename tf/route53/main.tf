data "aws_route53_zone" "nodedemo" {
  name         = "jennings-circleci20.com"
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.nodedemo.zone_id
  name    = "nodedemo.${data.aws_route53_zone.nodedemo.name}"
  type    = "A"
  ttl     = "30"
  records = ["10.0.0.1"]
}