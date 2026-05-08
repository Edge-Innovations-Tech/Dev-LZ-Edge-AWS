# Dev-LZ-Edge-AWS

    > Cortex Application Development Landing Zone for AWS

    ![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.6-blue)
    ![Cortex Certified](https://img.shields.io/badge/Cortex-Landing%20Zone-00C2CB)
    ![Zero Trust](https://img.shields.io/badge/Zero%20Trust-defaults%20enabled-green)
    ![License](https://img.shields.io/badge/license-Apache--2.0-blue)

    ## Overview

    This repository manages the AWS development landing zone for the Cortex application. It provides reusable Terraform modules and a deployable `envs/dev` root with Zero Trust defaults, Cortex tagging, GitHub Actions OIDC placeholders, and policy checks.

    ## Modules

    | Module | Purpose |
    |--------|---------|
    | [iam](./modules/iam/) | IAM roles, permission boundaries, GitHub OIDC trust, and least-privilege policy sets. |
| [network](./modules/network/) | VPC, private subnets, isolated data subnets, controlled egress, and endpoint-ready routing. |
| [compute](./modules/compute/) | EC2 and Auto Scaling launch patterns with IMDSv2, encryption, and private subnets. |
| [containers](./modules/containers/) | Private EKS baseline with restricted endpoint access and workload identity via IRSA. |
| [serverless](./modules/serverless/) | Lambda baseline with private VPC attachment, least-privilege execution roles, and logging. |
| [database](./modules/database/) | RDS/Aurora baseline with no public access, encryption, subnet groups, and backup policy. |
| [storage](./modules/storage/) | EBS/EFS baseline with encryption and access-point guardrails. |
| [object-storage](./modules/object-storage/) | S3 buckets with block-public-access, versioning, encryption, and lifecycle policy. |
| [dns](./modules/dns/) | Route 53 hosted zone and private DNS controls. |
| [monitoring](./modules/monitoring/) | CloudWatch logs, alarms, audit logging, and notification hooks. |
| [cost](./modules/cost/) | AWS Budgets, cost allocation tags, and development spend thresholds. |

    ## Quick Start

    ```bash
    cd envs/dev
    cp terraform.tfvars.example terraform.tfvars
    terraform init
    terraform plan
    ```

    Replace the provider identity, state backend, and OIDC placeholder values before applying to a real cloud account.

    ## Cortex Tags

    Every module emits a `cortex_inventory` output and enforces the common tag contract:

    - `cortex:environment`
    - `cortex:owner`
    - `cortex:cost_center`
    - `cortex:data_classification`

    ## Validation

    ```bash
    terraform fmt -check -recursive
    terraform -chdir=envs/dev init -backend=false
    terraform -chdir=envs/dev validate
    tflint --recursive
    trivy config .
    opa test policy/ -v
    ```
