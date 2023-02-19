resource "aws_elb" "frontlb" {
  name               = "frontlb"
  availability_zones = ["us-west-2a", "us-west-2c"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }
}

resource "aws_lb_target_group" "frontlb-tg" {
  name     = "frontlb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "front-webserver" {
  target_group_arn = aws_lb_target_group.frontlb-tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}
