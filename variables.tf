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
