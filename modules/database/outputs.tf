output "db_instance_id" {
  description = "RDS instance identifier when service_config.enable=true."
  value       = try(aws_db_instance.this[0].id, null)
}

output "db_endpoint" {
  description = "RDS connection endpoint when service_config.enable=true."
  value       = try(aws_db_instance.this[0].endpoint, null)
}

output "cortex_inventory" {
  description = "Cortex service catalog inventory for this landing-zone capability."
  value       = terraform_data.landing_zone_capability.output
}

output "tags" {
  description = "Required Cortex tags and provider labels for this capability."
  value       = local.cortex_tags
}
