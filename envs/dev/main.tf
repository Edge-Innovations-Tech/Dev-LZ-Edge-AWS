module "iam" {
  source = "../../modules/iam"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = {
    cloud_provider     = "aws"
    service            = "iam"
    description        = "IAM roles, permission boundaries, GitHub OIDC trust, and least-privilege policy sets."
    zero_trust_default = "enabled"
  }
}


module "network" {
  source = "../../modules/network"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = {
    cloud_provider     = "aws"
    service            = "network"
    description        = "VPC, private subnets, isolated data subnets, controlled egress, and endpoint-ready routing."
    zero_trust_default = "enabled"
  }
}


module "compute" {
  source = "../../modules/compute"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = {
    cloud_provider     = "aws"
    service            = "compute"
    description        = "EC2 and Auto Scaling launch patterns with IMDSv2, encryption, and private subnets."
    zero_trust_default = "enabled"
  }
}


module "containers" {
  source = "../../modules/containers"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = {
    cloud_provider     = "aws"
    service            = "containers"
    description        = "Private EKS baseline with restricted endpoint access and workload identity via IRSA."
    zero_trust_default = "enabled"
  }
}


module "serverless" {
  source = "../../modules/serverless"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = {
    cloud_provider     = "aws"
    service            = "serverless"
    description        = "Lambda baseline with private VPC attachment, least-privilege execution roles, and logging."
    zero_trust_default = "enabled"
  }
}


module "database" {
  source = "../../modules/database"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = {
    cloud_provider     = "aws"
    service            = "database"
    description        = "RDS/Aurora baseline with no public access, encryption, subnet groups, and backup policy."
    zero_trust_default = "enabled"
  }
}


module "storage" {
  source = "../../modules/storage"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = {
    cloud_provider     = "aws"
    service            = "storage"
    description        = "EBS/EFS baseline with encryption and access-point guardrails."
    zero_trust_default = "enabled"
  }
}


module "object_storage" {
  source = "../../modules/object-storage"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = {
    cloud_provider     = "aws"
    service            = "object-storage"
    description        = "S3 buckets with block-public-access, versioning, encryption, and lifecycle policy."
    zero_trust_default = "enabled"
  }
}


module "dns" {
  source = "../../modules/dns"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = {
    cloud_provider     = "aws"
    service            = "dns"
    description        = "Route 53 hosted zone and private DNS controls."
    zero_trust_default = "enabled"
  }
}


module "monitoring" {
  source = "../../modules/monitoring"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = {
    cloud_provider     = "aws"
    service            = "monitoring"
    description        = "CloudWatch logs, alarms, audit logging, and notification hooks."
    zero_trust_default = "enabled"
  }
}


module "cost" {
  source = "../../modules/cost"

  name_prefix         = var.name_prefix
  environment         = var.environment
  owner               = var.owner
  cost_center         = var.cost_center
  data_classification = var.data_classification
  provider_context    = merge(var.provider_context, { region = var.region })
  service_config = {
    cloud_provider     = "aws"
    service            = "cost"
    description        = "AWS Budgets, cost allocation tags, and development spend thresholds."
    zero_trust_default = "enabled"
  }
}
