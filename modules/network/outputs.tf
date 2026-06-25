output "vpc_id" {
  description = "ID of the created VPC when service_config.enable=true."
  value       = try(aws_vpc.this[0].id, null)
}

output "subnet_id" {
  description = "ID of the created subnet when service_config.enable=true."
  value       = try(aws_subnet.this[0].id, null)
}

output "subnet_ids" {
  description = "List form of the created subnet ID for downstream stack steps."
  value       = try([aws_subnet.this[0].id], [])
}

output "security_group_id" {
  description = "ID of the default security group when service_config.enable=true."
  value       = try(aws_security_group.this[0].id, null)
}

output "cortex_inventory" {
  description = "Cortex service catalog inventory for this landing-zone capability."
  value       = terraform_data.landing_zone_capability.output
}

output "tags" {
  description = "Required Cortex tags and provider labels for this capability."
  value       = local.cortex_tags
}
