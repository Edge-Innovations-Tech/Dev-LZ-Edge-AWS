# AWS network-dev (Terraform Cloud)

Single-module root for the Cortex AWS network landing-zone capability.

## TFC workspace

- **Organization:** Auralis
- **Workspace:** `dev`
- **Working directory:** `envs/network-dev` (VCS) or upload via `scripts/tfc-bootstrap-dev.sh`

## Required TFC variables

| Name | Category | Notes |
|------|----------|-------|
| `AWS_ACCESS_KEY_ID` | Environment | IAM user with landing-zone permissions |
| `AWS_SECRET_ACCESS_KEY` | Environment | Sensitive |
| `AWS_DEFAULT_REGION` | Environment | e.g. `us-east-1` |
| `region` | Terraform | Same as `AWS_DEFAULT_REGION` |
| `name_prefix` | Terraform | e.g. `cortex-dev` |

## Bootstrap

```bash
export TFC_TOKEN=... AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=...
./scripts/tfc-bootstrap-dev.sh --plan
```
