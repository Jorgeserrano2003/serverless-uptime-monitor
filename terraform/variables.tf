variable "aws_region" {
  type        = string
  description = "Región de AWS donde se alojarán los recursos"
  default     = "us-east-1"
}

variable "target_url" {
  type        = string
  description = "La dirección URL del sitio web que se desea monitorizar"
  default     = "https://httpstat.us/404"
}

variable "slack_webhook_url" {
  type        = string
  description = "URL del Webhook de Slack entrante para el canal de alertas"
  sensitive   = true
}
