data "aws_route53_zone" "nodedemo" {
  name = var.dns_domain
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.nodedemo.zone_id
  name    = "node-demo.${data.aws_route53_zone.nodedemo.name}"
  type    = "CNAME"
  ttl     = "30"
  records = [data.terraform_remote_state.outputs.alb_public_dns]
}