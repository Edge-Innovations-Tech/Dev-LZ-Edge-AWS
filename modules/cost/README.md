# Cost Module

AWS Budgets, cost allocation tags, and development spend thresholds.

This module is part of the Cortex AWS development landing zone. It emits a `cortex_inventory` output and carries the required Cortex tag contract. Provider account identifiers and OIDC trust values are intentionally supplied through variables and examples, not committed credentials.

## Zero Trust Defaults

- Least-privilege access
- Private placement by default
- Encryption required
- Public access disabled
- Audit logging required
- Cost attribution required

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [terraform_data.landing_zone_capability](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags or labels merged with required Cortex tags. | `map(string)` | `{}` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center used for allocation and reporting. | `string` | `"cortex-dev"` | no |
| <a name="input_data_classification"></a> [data\_classification](#input\_data\_classification) | Data classification for resources managed by this module. | `string` | `"internal"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for Cortex AWS Cost resources. | `string` | `"cortex-dev"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Owning team or person. | `string` | `"platform-engineering"` | no |
| <a name="input_provider_context"></a> [provider\_context](#input\_provider\_context) | Provider account, subscription, project, tenancy, OIDC, and state context. | `map(string)` | `{}` | no |
| <a name="input_service_config"></a> [service\_config](#input\_service\_config) | Provider-specific service configuration for the Cost landing-zone capability. | `any` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cortex_inventory"></a> [cortex\_inventory](#output\_cortex\_inventory) | Cortex service catalog inventory for this landing-zone capability. |
| <a name="output_tags"></a> [tags](#output\_tags) | Required Cortex tags and provider labels for this capability. |
<!-- END_TF_DOCS -->
