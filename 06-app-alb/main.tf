resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-${var.environment}-app-alb"
  internal           = true  #private load balancer
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_ids.value) #min 2 subnets for alb

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-app-alb"
    }
  )
}

# we add listner to alb for listen

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn   # aws.lb."add lb here".arn
  port              = "80"
  protocol          = "HTTP"   #if https we need certficate key and value
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"


  default_action {
    type = "fixed-response"   #as application is not read we are giving fixed response

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from APP ALB</h1>"
      status_code  = "200"
    }
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name
  
  records = [
    {
      name    = "*.app-${var.environment}"
      type    = "A"  #we do alias for to lb
      allow_overwrite = true
      alias   = {
        name    = aws_lb.app_alb.dns_name  # resources from terraform
        zone_id = aws_lb.app_alb.zone_id
      }
    }
  ]
}