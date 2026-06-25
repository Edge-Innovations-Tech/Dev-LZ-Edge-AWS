# Real AWS EC2 when service_config.enable_instance=true; otherwise inventory-only stub.
locals {
  cmp_cfg = try(jsondecode(var.service_config), var.service_config, {})

  cmp_enable         = try(tobool(local.cmp_cfg.enable_instance), false)
  cmp_existing_vpc   = try(trimspace(local.cmp_cfg.existing_vpc_id), "")
  cmp_use_existing   = local.cmp_enable && local.cmp_existing_vpc != ""
  cmp_instance_type  = try(local.cmp_cfg.instance_type, "t3.micro")
  cmp_ami_id         = try(local.cmp_cfg.ami_id, "")
  cmp_subnet_id      = try(local.cmp_cfg.subnet_id, "")
  cmp_key_name       = try(local.cmp_cfg.key_name, "")
}

data "aws_ami" "amazon_linux" {
  count = local.cmp_enable && local.cmp_ami_id == "" ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "this" {
  count = local.cmp_enable ? 1 : 0

  ami           = local.cmp_ami_id != "" ? local.cmp_ami_id : data.aws_ami.amazon_linux[0].id
  instance_type = local.cmp_instance_type
  subnet_id     = local.cmp_subnet_id

  key_name = local.cmp_key_name != "" ? local.cmp_key_name : null

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(local.cortex_tags, {
    Name = "${var.name_prefix}-catalog-ec2"
  })

  lifecycle {
    precondition {
      condition     = !local.cmp_enable || local.cmp_subnet_id != ""
      error_message = "service_config.subnet_id is required when service_config.enable_instance=true"
    }
  }
}
