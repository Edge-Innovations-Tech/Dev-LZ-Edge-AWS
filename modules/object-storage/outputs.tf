output "bucket_id" {
  description = "Name/ID of the created S3 bucket when service_config.enable=true."
  value       = try(aws_s3_bucket.this[0].id, null)
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket when service_config.enable=true."
  value       = try(aws_s3_bucket.this[0].arn, null)
}

output "cortex_inventory" {
  description = "Cortex service catalog inventory for this landing-zone capability."
  value       = terraform_data.landing_zone_capability.output
}

output "tags" {
  description = "Required Cortex tags and provider labels for this capability."
  value       = local.cortex_tags
}
