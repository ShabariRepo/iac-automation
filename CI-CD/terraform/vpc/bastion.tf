// Bastion host launch configuration
resource "aws_launch_configuration" "bastion_conf" {
  name            = "bastion1"
  image_id        = data.aws_ami.bastion1.id //"${data.aws_ami.bastion.id}" old way
  instance_type   = var.bastion_instance_type //"${var.bastion_instance_type}" old way
  key_name        = var.bastion_key_name //"${var.bastion_key_name}"
  security_groups = flatten([aws_security_group.bastion_host.id]) //"${aws_security_group.bastion_host.id}" old way

  lifecycle {
    create_before_destroy = true
  }
}

// Bastion ASG
resource "aws_autoscaling_group" "bastion_asg" {
  name                 = "bastion_asg_${var.vpc_name}"
  launch_configuration = aws_launch_configuration.bastion_conf.name //"${aws_launch_configuration.bastion_conf.name}"
  vpc_zone_identifier  = flatten([aws_subnet.public_subnets.*.id]) //"${aws_subnet.public_subnets.*.id}"
  load_balancers       = flatten([aws_elb.bastion_hosts_elb.name]) //"${aws_elb.bastion_hosts_elb.name}"
  min_size             = 1
  max_size             = 1

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "bastion"
    propagate_at_launch = true
  }

  tag {
    key                 = "Author"
    value               = "shabari.shenoy"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tool"
    value               = "Terraform"
    propagate_at_launch = true
  }
}
