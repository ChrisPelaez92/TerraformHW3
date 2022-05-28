variable "desired_capacity" {

  type        = number
  description = "Auto Scaling Group Capacity"
  default     = 1

}


variable "max_size" {

  type        = number
  description = "Auto Scaling Group Max Size"
  default     = 2

}

variable "min_size" {

  type        = number
  description = "Auto Scaling Group Smallest Size"
  default     = 1

}

variable "name_prefix" {
  type        = string
  description = "Auto Scaling Group Name"
  default     = "CPF_ASG"

}
