variable "tools" {
  default = {
    vault = {
      app_port = 8200
      instance_type = "t3.small"
      volume_size = 20
      policy_list = []
      market_type = "spot"
    }

    github-runner = {
      app_port = 80
      instance_type = "t3.medium"
      volume_size = 65
      policy_list = ["*"]
      market_type = "spot"
    }
  }
}

variable "zone_id" {
  default = "Z1024318Z55DK5FV70OA"
}
variable "domain_name" {
  default = "kdevops23.online"
}
# variable "to_deploy" {
#   default = ["runner"]
# }