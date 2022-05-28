locals {
  DateTime = timestamp()

}



resource "aws_launch_configuration" "launch_config" {
  name_prefix     = "cpf_launch_config"
  image_id        = output.ami_id.id
  instance_type   = "t2.micro"
  security_groups = [output.sg_id.id]

  lifecycle {
    create_before_destroy = true
  }

  tags {
  DateTime = local.DateTime

  }
}
