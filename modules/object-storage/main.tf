locals {
  cortex_tags = merge({
    "cortex:environment"         = var.environment
    "cortex:owner"               = var.owner
    "cortex:cost_center"         = var.cost_center
    "cortex:data_classification" = var.data_classification
    "cortex:landing_zone"        = var.name_prefix
    "cortex:cloud_provider"      = "aws"
    "cortex:capability"          = "object-storage"
  }, var.additional_tags)

  zero_trust_controls = [
    "least-privilege-iam",
    "private-network-placement",
    "encryption-required",
    "public-access-disabled",
    "audit-logging-required",
    "cost-attribution-required",
  ]

  service_inventory = {
    provider            = "aws"
    capability          = "object-storage"
    name_prefix         = var.name_prefix
    environment         = var.environment
    tags                = local.cortex_tags
    provider_context    = var.provider_context
    service_config      = local.os_cfg
    zero_trust_controls = local.zero_trust_controls
    enable              = local.os_enable
    bucket_id           = try(aws_s3_bucket.this[0].id, null)
    bucket_arn          = try(aws_s3_bucket.this[0].arn, null)
  }
}

resource "terraform_data" "landing_zone_capability" {
  input = local.service_inventory
}
