variable "tools" {
  default = {
    vault = {
      app_port = 8200
      instance_type = "t3.small"
      volume_size = 20
      policy_list = []
    }

    github-runner = {
      app_port = 80
      instance_type = "t3.small"
      volume_size = 65
      policy_list = ["*"]
    }
  }
}

variable "zone_id" {
  default = "Z09304471M1HNSZIX3178"
}
variable "domain_name" {
  default = "devops24.shop"
}
