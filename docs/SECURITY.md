# Security

## Zero Trust Defaults

- Grant least privilege only.
- Prefer private subnets and private service endpoints.
- Disable public access to object storage and databases.
- Require encryption for storage, object storage, databases, and runtime volumes.
- Require logging, monitoring, and audit hooks.
- Require Cortex ownership, environment, cost, and data-classification tags.

## Secrets

Do not commit provider credentials. GitHub Actions workflows are prepared for OIDC federation and repository or environment variables.
