locals {
  DateTime = timestamp()

}



data "aws_ami" "main_ami" {
    most_recent      = true
    owners           = ["self"]

  tags = {
      Date&time = local.DateTime

      }
}



resource "aws_launch_template" "lt" {
  name_prefix   = "var.name_prefix"
  image_id      = data.aws_ami.main_ami.id #ami-02541b8af977f6cdd
  instance_type = "t2.micro"

  tags = {
  Date&time = local.DateTime

  }
}

resource "aws_autoscaling_group" "asg" {
  availability_zones = ["us-wes-1a"]
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
}




data "aws_ami" "main_ami" {
    most_recent      = true
    owners           = ["self"]

  tags = {
      Date&time = local.DateTime

      }
}
