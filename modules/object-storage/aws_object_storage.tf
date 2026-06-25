# Real AWS S3 when service_config.enable=true; otherwise inventory-only stub.
locals {
  os_cfg = try(jsondecode(var.service_config), var.service_config, {})

  os_enable      = try(tobool(local.os_cfg.enable), false)
  os_bucket_name = try(local.os_cfg.bucket_name, "${var.name_prefix}-bucket-${var.environment}")
}

resource "aws_s3_bucket" "this" {
  count = local.os_enable ? 1 : 0

  bucket = local.os_bucket_name

  tags = merge(local.cortex_tags, {
    Name = local.os_bucket_name
  })
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = local.os_enable ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  count = local.os_enable ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  versioning_configuration {
    status = try(local.os_cfg.versioning, "Enabled")
  }
}
