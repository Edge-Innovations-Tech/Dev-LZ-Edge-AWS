# Cortex Development Landing Zone

This root composes all AWS landing-zone capabilities for the Cortex development environment.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

The example values are placeholders. Replace cloud account identifiers, OIDC trust values, and remote-state details before applying to a real development account.
