# Real AWS EBS when service_config.enable=true; otherwise inventory-only stub.
locals {
  stor_cfg = try(jsondecode(var.service_config), var.service_config, {})

  stor_enable   = try(tobool(local.stor_cfg.enable), false)
  stor_size     = try(tonumber(local.stor_cfg.size_gb), 50)
  stor_type     = try(local.stor_cfg.volume_type, "gp3")
  stor_az       = try(local.stor_cfg.availability_zone, "")
}

resource "aws_ebs_volume" "this" {
  count = local.stor_enable ? 1 : 0

  availability_zone = local.stor_az
  size              = local.stor_size
  type              = local.stor_type
  encrypted         = try(tobool(local.stor_cfg.encrypted), true)

  tags = merge(local.cortex_tags, {
    Name = "${var.name_prefix}-vol"
  })

  lifecycle {
    precondition {
      condition     = !local.stor_enable || local.stor_az != ""
      error_message = "service_config.availability_zone is required when service_config.enable=true"
    }
  }
}
