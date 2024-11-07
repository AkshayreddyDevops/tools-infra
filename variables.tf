variable "tools" {
  default = {
    gethub-runner = {
      instance_type="t3.small"
      policy_name = [
        "AdministratorAccess"
      ]
      volume_size = 30
    }
    minikube = {
      name = "minikube"
      instance_type = "t3.medium"
      port_no =  {
        kube = 8443
      }
      policy_actions = []
      volume_size = 30
    }
  }
}



variable "vpc" {}
variable "env" {}
variable "app_ec2" {}
variable "bastion_nodes" {}
variable "db" {}
variable "asg" {}
variable "zone_id" {}
variable "load_balancer" {}








