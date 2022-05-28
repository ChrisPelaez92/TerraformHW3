variable "vpc_name" {

  type        = string
  description = "VPC name"
  default     = "Terraform-5000"

}


variable "ipblock" {

  type    = string
  default = "10.0.0.0/16"

}

variable "aws_security_group_name" {

  type        = string
  description = "SG name"
  default     = "SG_allow_tls"

}
