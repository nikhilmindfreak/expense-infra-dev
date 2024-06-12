resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.environment}-web-alb"
  internal           = false  #public load balancer
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value) #min 2 subnets for alb

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-web-alb"
    }
  )
}

# we add listner to alb for listen

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn   # aws.lb."add lb here".arn
  port              = "80"
  protocol          = "HTTP"   #if https we need certficate key and value

  default_action {
    type = "fixed-response"   #as application is not read we are giving fixed response

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from WEB ALB Bro</h1>"
      status_code  = "200"
    }
  }
}


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"

  protocol          = "HTTPS"
  certificate_arn   = data.aws_ssm_parameter.acm_certificate_arn.value
  ssl_policy        = "ELBSecurityPolicy-2016-08"   #for https we use ssl policy

  default_action {
    type = "fixed-response"   

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from Web ALB HTTPS</h1>"
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
      name    = "web-${var.environment}"
      type    = "A"  #we do alias for to lb
      allow_overwrite = true
      alias   = {
        name    = aws_lb.web_alb.dns_name  # resources from terraform
        zone_id = aws_lb.web_alb.zone_id
      }
    }
  ]
}