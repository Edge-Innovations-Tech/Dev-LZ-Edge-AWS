output "budget_name" {
  description = "AWS Budget name when service_config.enable=true."
  value       = try(aws_budgets_budget.this[0].name, null)
}

output "cortex_inventory" {
  description = "Cortex service catalog inventory for this landing-zone capability."
  value       = terraform_data.landing_zone_capability.output
}

output "tags" {
  description = "Required Cortex tags and provider labels for this capability."
  value       = local.cortex_tags
}
