# 1. Compresión automática del código de la Lambda antes de subirlo
data "archive_file" "lambda_zip" {
type = "zip"
source_file = "${path.module}/../src/monitor.py"
output_path = "${path.module}/files/lambda_function.zip"
}
# 2. Definición del Rol IAM para la Lambda (Principio de Menor Privilegio)
resource "aws_iam_role" "lambda_role" {
name = "serverless_uptime_monitor_role"
assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [{
Action = "sts:AssumeRole"
Effect = "Allow"
Principal = { Service = "lambda.amazonaws.com" }
}]
})
}
# 3. Adjuntar la política oficial para permitir escrituras en CloudWatch Logs
resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
role = aws_iam_role.lambda_role.name
policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# 4. Creación de la Función AWS Lambda
resource "aws_lambda_function" "monitor" {
filename = data.archive_file.lambda_zip.output_path
function_name = "uptime_monitor_handler"
role = aws_iam_role.lambda_role.arn
handler = "monitor.lambda_handler"
source_code_hash = data.archive_file.lambda_zip.output_base64sha256
runtime = "python3.11"
timeout = 15
environment {
variables = {
TARGET_URL = var.target_url
SLACK_WEBHOOK_URL = var.slack_webhook_url
}
}
}
# 5. Creación del Evento Recurrente en EventBridge (Mecanismo de reloj)
resource "aws_cloudwatch_event_rule" "cron_schedule" {
name = "uptime_monitor_cron_rule"
description = "Disparador programado para ejecutar el monitor cada 5 minutos"schedule_expression = "rate(5 minutes)"
}
# 6. Vinculación entre EventBridge y la Función Lambda
resource "aws_cloudwatch_event_target" "lambda_target" {
rule = aws_cloudwatch_event_rule.cron_schedule.name
target_id = "ExecuteUptimeLambda"
arn = aws_lambda_function.monitor.arn
}
# 7. Concesión de permisos explícitos para que EventBridge invoque la Lambda
resource "aws_lambda_permission" "allow_eventbridge_invocation" {
statement_id = "AllowExecutionFromEventBridge"
action = "lambda:InvokeFunction"
function_name = aws_lambda_function.monitor.function_name
principal = "events.amazonaws.com"
source_arn = aws_cloudwatch_event_rule.cron_schedule.arn
}