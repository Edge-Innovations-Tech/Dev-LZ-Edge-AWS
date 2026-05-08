# Architecture

`Dev-LZ-Edge-AWS` defines the AWS Cortex development landing zone. The repository is organized around reusable Terraform modules and the deployable `envs/dev` root.

## Service Domains

- Identity: least-privilege IAM and GitHub OIDC trust placeholders.
- Network: private workload placement with controlled ingress and egress.
- Compute and containers: hardened runtime baselines for the Cortex application.
- Serverless: private function runtime baseline.
- Database and storage: encryption, private access, retention, and backup requirements.
- DNS, monitoring, and cost: operational visibility and spend controls for development.

The current scaffold captures deployable Terraform contracts and Cortex inventory outputs. Replace placeholder cloud account identifiers before applying to a real account.
