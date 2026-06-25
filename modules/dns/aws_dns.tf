# Real AWS Route 53 when service_config.enable=true; otherwise inventory-only stub.
locals {
  dns_cfg = try(jsondecode(var.service_config), var.service_config, {})

  dns_enable   = try(tobool(local.dns_cfg.enable), false)
  dns_zone     = try(local.dns_cfg.zone_name, "${var.name_prefix}.dev.example.com")
  dns_private  = try(tobool(local.dns_cfg.private_zone), false)
  dns_vpc_id   = try(local.dns_cfg.vpc_id, "")
}

resource "aws_route53_zone" "this" {
  count = local.dns_enable ? 1 : 0

  name = local.dns_zone

  dynamic "vpc" {
    for_each = local.dns_private && local.dns_vpc_id != "" ? [1] : []
    content {
      vpc_id = local.dns_vpc_id
    }
  }

  tags = merge(local.cortex_tags, {
    Name = "${var.name_prefix}-zone"
  })

  lifecycle {
    precondition {
      condition     = !local.dns_enable || !local.dns_private || local.dns_vpc_id != ""
      error_message = "service_config.vpc_id is required for private Route 53 zones"
    }
  }
}
