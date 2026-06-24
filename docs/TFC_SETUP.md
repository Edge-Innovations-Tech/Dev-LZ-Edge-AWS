# Terraform Cloud — AWS dev workspace

Connect workspace **`dev`** in org **Auralis** to this repository for Cortex catalog `TFC-Run` execution.

## 1. Version control (required)

In [Terraform Cloud](https://app.terraform.io/app/Auralis/workspaces/dev/settings/version-control):

1. Connect **GitHub** to the Auralis organization (if not already).
2. Select repository **`Edge-Innovations-Tech/Dev-LZ-Edge-AWS`**.
3. Set **Terraform Working Directory** to `envs/network-dev`.
4. Enable **Automatic speculative plans** (optional).

## 2. Workspace variables

Set in workspace **Variables** (or run `scripts/tfc-bootstrap-dev.sh`):

| Name | Category | Sensitive |
|------|----------|-----------|
| `AWS_ACCESS_KEY_ID` | Environment | No |
| `AWS_SECRET_ACCESS_KEY` | Environment | Yes |
| `AWS_DEFAULT_REGION` | Environment | No |
| `name_prefix` | Terraform | No |
| `region` | Terraform | No |
| `environment` | Terraform | No |

## 3. API token permissions

The org API token must allow **queue run** on this workspace (`can-queue-run: true`).  
If `tfc_create_run` / config upload returns 404, regenerate the token with run permissions or trigger plans from the VCS UI.

## 4. Catalog offering

Import `catalog/offerings/network-tfc.manifest.json` into Cortex catalog — it targets workspace `ws-hRYiCkCytLuneW8K`.

## 5. Bootstrap script (vars only)

```bash
export TFC_TOKEN=... AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=...
./scripts/tfc-bootstrap-dev.sh          # vars only
./scripts/tfc-bootstrap-dev.sh --plan   # vars + config upload (needs run permission)
```
