output "basation_public_ip" {
  value = aws_eip.basation_ip.public_ip
}
output "web_private_ip" {
  value = aws_instance.web.private_ip
}
output "app_private_ip" {
  value = aws_instance.app.private_ip
}
output "elb_dns_name" {
  value = aws_elb.frontlb.dns_name
}
