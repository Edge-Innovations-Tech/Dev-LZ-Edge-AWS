# Real AWS RDS when service_config.enable=true; otherwise inventory-only stub.
locals {
  db_cfg = try(jsondecode(var.service_config), var.service_config, {})

  db_enable       = try(tobool(local.db_cfg.enable), false)
  db_identifier   = try(local.db_cfg.identifier, "${var.name_prefix}-db")
  db_engine       = try(local.db_cfg.engine, "postgres")
  db_engine_ver   = try(local.db_cfg.engine_version, "16.3")
  db_instance_cls = try(local.db_cfg.instance_class, "db.t3.micro")
  db_username     = try(local.db_cfg.username, "cortexadmin")
  db_password     = try(local.db_cfg.password, "")
  db_subnet_ids   = try(local.db_cfg.subnet_ids, [])
}

resource "aws_db_subnet_group" "this" {
  count = local.db_enable && length(local.db_subnet_ids) > 0 ? 1 : 0

  name       = "${var.name_prefix}-db-subnets"
  subnet_ids = local.db_subnet_ids

  tags = merge(local.cortex_tags, {
    Name = "${var.name_prefix}-db-subnets"
  })
}

resource "aws_db_instance" "this" {
  count = local.db_enable ? 1 : 0

  identifier             = local.db_identifier
  engine                 = local.db_engine
  engine_version         = local.db_engine_ver
  instance_class         = local.db_instance_cls
  allocated_storage      = try(tonumber(local.db_cfg.allocated_storage), 20)
  username               = local.db_username
  password               = local.db_password
  db_subnet_group_name   = length(local.db_subnet_ids) > 0 ? aws_db_subnet_group.this[0].name : null
  publicly_accessible    = false
  skip_final_snapshot    = true
  storage_encrypted      = true

  tags = merge(local.cortex_tags, {
    Name = local.db_identifier
  })

  lifecycle {
    precondition {
      condition     = !local.db_enable || local.db_password != ""
      error_message = "service_config.password is required when service_config.enable=true"
    }
    precondition {
      condition     = !local.db_enable || length(local.db_subnet_ids) > 0
      error_message = "service_config.subnet_ids is required when service_config.enable=true"
    }
  }
}
