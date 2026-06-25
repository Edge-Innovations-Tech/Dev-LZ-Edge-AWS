output "zone_id" {
  description = "Route 53 hosted zone ID when service_config.enable=true."
  value       = try(aws_route53_zone.this[0].zone_id, null)
}

output "cortex_inventory" {
  description = "Cortex service catalog inventory for this landing-zone capability."
  value       = terraform_data.landing_zone_capability.output
}

output "tags" {
  description = "Required Cortex tags and provider labels for this capability."
  value       = local.cortex_tags
}
