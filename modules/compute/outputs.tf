output "instance_id" {
  description = "ID of the created EC2 instance when service_config.enable_instance=true."
  value       = try(aws_instance.this[0].id, null)
}

output "cortex_inventory" {
  description = "Cortex service catalog inventory for this landing-zone capability."
  value       = terraform_data.landing_zone_capability.output
}

output "tags" {
  description = "Required Cortex tags and provider labels for this capability."
  value       = local.cortex_tags
}
