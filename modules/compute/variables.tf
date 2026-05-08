variable "name_prefix" {
  description = "Name prefix for Cortex AWS Compute resources."
  type        = string
  default     = "cortex-dev"
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
  description = "Data classification for resources managed by this module."
  type        = string
  default     = "internal"
}

variable "provider_context" {
  description = "Provider account, subscription, project, tenancy, OIDC, and state context."
  type        = map(string)
  default     = {}
}

variable "service_config" {
  description = "Provider-specific service configuration for the Compute landing-zone capability."
  type        = any
  default     = {}
}

variable "additional_tags" {
  description = "Additional tags or labels merged with required Cortex tags."
  type        = map(string)
  default     = {}
}
