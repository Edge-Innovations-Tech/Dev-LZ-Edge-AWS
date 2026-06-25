locals {
  cortex_tags = merge({
    "cortex:environment"         = var.environment
    "cortex:owner"               = var.owner
    "cortex:cost_center"         = var.cost_center
    "cortex:data_classification" = var.data_classification
    "cortex:landing_zone"        = var.name_prefix
    "cortex:cloud_provider"      = "aws"
    "cortex:capability"          = "serverless"
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
    capability          = "serverless"
    name_prefix         = var.name_prefix
    environment         = var.environment
    tags                = local.cortex_tags
    provider_context    = var.provider_context
    service_config      = local.fn_cfg
    zero_trust_controls = local.zero_trust_controls
    enable              = local.fn_enable
    function_name       = try(aws_lambda_function.this[0].function_name, null)
    function_arn        = try(aws_lambda_function.this[0].arn, null)
    subnet_ids          = local.fn_subnet_ids
  }
}

resource "terraform_data" "landing_zone_capability" {
  input = local.service_inventory
}
