module "network" {
  source = "../../modules/network"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = merge(
    {
      cloud_provider     = "aws"
      service            = "network"
      description        = "VPC, private subnets, isolated data subnets, controlled egress, and endpoint-ready routing."
      zero_trust_default = "enabled"
    },
    try(jsondecode(var.service_config_json), {}),
  )
}
