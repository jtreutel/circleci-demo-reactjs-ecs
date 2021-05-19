output "alb_public_dns" {
  value = aws_lb.nodedemo.dns_name
}