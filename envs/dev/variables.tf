variable "name_prefix" {
  description = "Name prefix used for Cortex development landing-zone resources."
  type        = string
  default     = "cortex-dev"
}

variable "region" {
  description = "Primary deployment region."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owning team or person."
  type        = string
  default     = "platform-engineering"
}

variable "cost_center" {
  description = "Cost center used for allocation and reporting."
  type        = string
  default     = "cortex-dev"
}

variable "data_classification" {
  description = "Data classification for the landing zone."
  type        = string
  default     = "internal"
}

variable "provider_context" {
  description = "Provider account, subscription, project, tenancy, OIDC, and state context."
  type        = map(string)
  default     = {}
}
