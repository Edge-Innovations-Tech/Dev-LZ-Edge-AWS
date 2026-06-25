# Real AWS Budget when service_config.enable=true; otherwise inventory-only stub.
locals {
  cost_cfg = try(jsondecode(var.service_config), var.service_config, {})

  cost_enable    = try(tobool(local.cost_cfg.enable), false)
  cost_account   = try(var.provider_context["account_id"], try(local.cost_cfg.account_id, ""))
  cost_amount    = try(local.cost_cfg.amount, "100")
  cost_threshold = try(tonumber(local.cost_cfg.threshold_percent), 80)
  cost_email     = try(local.cost_cfg.notification_email, "")
}

resource "aws_budgets_budget" "this" {
  count = local.cost_enable ? 1 : 0

  name         = "${var.name_prefix}-budget"
  budget_type  = "COST"
  limit_amount = local.cost_amount
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name   = "LinkedAccount"
    values = [local.cost_account]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = local.cost_threshold
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = local.cost_email != "" ? [local.cost_email] : []
  }

  lifecycle {
    precondition {
      condition     = !local.cost_enable || local.cost_account != ""
      error_message = "provider_context.account_id is required when service_config.enable=true"
    }
  }
}
