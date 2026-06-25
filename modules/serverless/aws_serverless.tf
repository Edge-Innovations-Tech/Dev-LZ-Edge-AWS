# Real AWS Lambda when service_config.enable=true; otherwise inventory-only stub.
locals {
  fn_cfg = try(jsondecode(var.service_config), var.service_config, {})

  fn_enable     = try(tobool(local.fn_cfg.enable), false)
  fn_name       = try(local.fn_cfg.function_name, "${var.name_prefix}-fn")
  fn_runtime    = try(local.fn_cfg.runtime, "nodejs20.x")
  fn_handler    = try(local.fn_cfg.handler, "index.handler")
  fn_subnet_ids = try(local.fn_cfg.subnet_ids, [])
}

data "archive_file" "lambda" {
  count = local.fn_enable ? 1 : 0

  type        = "zip"
  output_path = "${path.module}/.lambda_${var.name_prefix}.zip"

  source {
    content  = "exports.handler = async () => ({ statusCode: 200, body: 'cortex-dev' });"
    filename = "index.js"
  }
}

resource "aws_iam_role" "lambda" {
  count = local.fn_enable ? 1 : 0

  name = "${var.name_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = local.cortex_tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  count = local.fn_enable ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda[0].name
}

resource "aws_lambda_function" "this" {
  count = local.fn_enable ? 1 : 0

  function_name = local.fn_name
  role          = aws_iam_role.lambda[0].arn
  handler       = local.fn_handler
  runtime       = local.fn_runtime
  filename      = data.archive_file.lambda[0].output_path
  source_code_hash = data.archive_file.lambda[0].output_base64sha256

  tags = local.cortex_tags

  depends_on = [aws_iam_role_policy_attachment.lambda_basic]
}
