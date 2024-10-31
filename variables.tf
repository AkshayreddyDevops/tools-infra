variable "tools" {
  default = {
    gethub-runner = {
      instance_type="t3.small"
      policy_name = [
        "AdministratorAccess"
      ]
    }
  }
}

variable "vpc" {}
variable "env" {}
variable "app_ec2" {}
variable "bastion_nodes" {}
variable "db" {}
variable "asg" {}

