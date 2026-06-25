# Real AWS SNS when service_config.enable=true; otherwise inventory-only stub.
locals {
  mon_cfg = try(jsondecode(var.service_config), var.service_config, {})

  mon_enable = try(tobool(local.mon_cfg.enable), false)
  mon_topic  = try(local.mon_cfg.topic_name, "${var.name_prefix}-topic")
  mon_email  = try(local.mon_cfg.subscription_email, "")
}

resource "aws_sns_topic" "this" {
  count = local.mon_enable ? 1 : 0

  name = local.mon_topic

  tags = merge(local.cortex_tags, {
    Name = local.mon_topic
  })
}

resource "aws_sns_topic_subscription" "email" {
  count = local.mon_enable && local.mon_email != "" ? 1 : 0

  topic_arn = aws_sns_topic.this[0].arn
  protocol  = "email"
  endpoint  = local.mon_email
}
