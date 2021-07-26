variable "region" {}
variable "project_name" {}
variable "accountId" {}

variable "remote_state_db" {
  type        = string
  description = "The name of the Dynamo DB used for locking."
}
variable "remote_state_bucket" {
  type        = string
  description = "The bucket used to store states."
}

variable "aws_key_name" {
  type        = string
  description = "AWS Key Name"
}

variable "ami_id" {}
variable "subnet_id" {}
variable "security_group_id" {}

# Tags
variable "owner" {}

locals {
  tags = {
    owner   = var.owner
    project = var.project_name
  }
}
