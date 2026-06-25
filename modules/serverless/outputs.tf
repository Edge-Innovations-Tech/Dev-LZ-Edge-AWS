output "function_name" {
  description = "Lambda function name when service_config.enable=true."
  value       = try(aws_lambda_function.this[0].function_name, null)
}

output "function_arn" {
  description = "Lambda function ARN when service_config.enable=true."
  value       = try(aws_lambda_function.this[0].arn, null)
}

output "cortex_inventory" {
  description = "Cortex service catalog inventory for this landing-zone capability."
  value       = terraform_data.landing_zone_capability.output
}

output "tags" {
  description = "Required Cortex tags and provider labels for this capability."
  value       = local.cortex_tags
}
