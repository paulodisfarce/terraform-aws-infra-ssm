output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "private_subnets_id" {
  value = module.vpc.private_subnets
}

output "instance_id" {
  value = module.ec2_instance.id
}

output "instance_profile_name" {
  value = module.session_manager.instance_profile_name
}


