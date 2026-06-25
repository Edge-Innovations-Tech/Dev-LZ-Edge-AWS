# Real AWS IAM when service_config.enable=true; otherwise inventory-only stub.
locals {
  iam_cfg = try(jsondecode(var.service_config), var.service_config, {})

  iam_enable      = try(tobool(local.iam_cfg.enable), false)
  iam_role_name   = try(local.iam_cfg.role_name, "${var.name_prefix}-lz-role")
  iam_policy_name = try(local.iam_cfg.policy_name, "${var.name_prefix}-lz-policy")
}

data "aws_iam_policy_document" "assume_role" {
  count = local.iam_enable ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [try(local.iam_cfg.assume_role_service, "ec2.amazonaws.com")]
    }
  }
}

resource "aws_iam_role" "this" {
  count = local.iam_enable ? 1 : 0

  name               = local.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json

  tags = local.cortex_tags
}

resource "aws_iam_role_policy" "this" {
  count = local.iam_enable ? 1 : 0

  name = local.iam_policy_name
  role = aws_iam_role.this[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = try(local.iam_cfg.policy_actions, ["ec2:Describe*"])
      Resource = "*"
    }]
  })
}
