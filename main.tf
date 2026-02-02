module "ec2" {
  for_each = {
    for name, config in var.tools : name => config
          if contains(toset(var.to_deploy), name)
  }
  # for_each = var.tools
  source = "./modules/ec2"
  app_port      = each.value["app_port"]
  domain_name   = var.domain_name
  instance_type = each.value["instance_type"]
  tool_name     = each.key
  zone_id       = var.zone_id
  volume_size   = each.value["volume_size"]
  policy_list   = each.value["policy_list"]
}