# Fetch the latest Amazon Linux AMI
data "aws_ami" "latest_amazon_linux_image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Define the AWS Key Pair for SSH access
resource "aws_key_pair" "ssh_key" {
  key_name   = "server-key"
  public_key = file(var.public_key_location)
}

# Launch Template
resource "aws_launch_template" "web_server" {
  name          = "${var.env_prefix}-web-server-lt"
  image_id      = data.aws_ami.latest_amazon_linux_image.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh_key.key_name

  # User data to bootstrap the instance (Base64 encoded)
  user_data = filebase64(var.entery_ec2_script)

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.vpc_security_group_ids
  }

  tags = {
    Name = "${var.env_prefix}-launch-template"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  name = "${var.env_prefix}-asg"

  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = var.public_subnet_ids

  # Reference the launch template
  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }

  # Automatically replace instances if the launch template changes
  lifecycle {
    create_before_destroy = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  # Tags for ASG instances
  tag {
    key                 = "Name"
    value               = "${var.env_prefix}-asg-instance"
    propagate_at_launch = true
  }
}

data "aws_instances" "web_asg_instances" {
  depends_on = [aws_autoscaling_group.web_asg]
  filter {
   name   = "tag:Name"
   values = ["${var.env_prefix}-asg-instance"]
 }
}


# CloudWatch Metric Alarms and Scaling Policies (Optional)
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-high-${var.env_prefix}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Alarm when CPU is greater than 75% for 2 minutes"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-low-${var.env_prefix}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 25
  alarm_description   = "Alarm when CPU is less than 25% for 2 minutes"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}