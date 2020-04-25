module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"
  
  name                              = var.alb_name
  load_balancer_type                = var.alb_type
  vpc_id                            = module.vpc.vpc_id
  subnets                           = module.vpc.public_subnets
  security_groups                   = [module.alb_sg.this_security_group_id]
  enable_cross_zone_load_balancing  = "true"

  target_groups = [
    {
      name_prefix      = "ta-alb"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  health_check = [
    {
      enabled               = "true"
      protocol              = "HTTP"
      path                  = "/"
      port                  = "traffic-port"
      healthy_threshold     = 5
      unhealthy_threshold   = 3
      timeout               = 5
      interval              = 30
      matcher               = "200,301"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Name                    = var.alb_name
    Terraform               = var.is_project_terraformed
    Environment             = var.environment
    Owner                   = var.project_owner
    Email                   = var.project_email
    Project_Name            = var.project_name
  }
}

resource "aws_lb_target_group_attachment" "ta-alb-tga" {
    count               = var.number_of_instances
    target_group_arn    = module.alb.target_group_arns[0]
    target_id           = aws_instance.webserver[count.index].id
    port                = 80
}