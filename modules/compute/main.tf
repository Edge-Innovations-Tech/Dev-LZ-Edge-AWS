locals {
  cortex_tags = merge({
    "cortex:environment"         = var.environment
    "cortex:owner"               = var.owner
    "cortex:cost_center"         = var.cost_center
    "cortex:data_classification" = var.data_classification
    "cortex:landing_zone"        = var.name_prefix
    "cortex:cloud_provider"      = "aws"
    "cortex:capability"          = "compute"
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
    capability          = "compute"
    name_prefix         = var.name_prefix
    environment         = var.environment
    tags                = local.cortex_tags
    provider_context    = var.provider_context
    service_config      = local.cmp_cfg
    zero_trust_controls = local.zero_trust_controls
    enable_instance     = local.cmp_enable
    instance_id         = try(aws_instance.this[0].id, null)
    vpc_id              = local.cmp_existing_vpc != "" ? local.cmp_existing_vpc : null
  }
}

resource "terraform_data" "landing_zone_capability" {
  input = local.service_inventory
}
