#!/usr/bin/env python3
"""Generate catalog-item manifests for the AWS landing-zone modules.

Each manifest exposes governance fields, AWS provider context, an `enable`
toggle (real resources vs. inventory-only stub), and a capability-specific
`service_config` JSON field. `compute` is hand-maintained and skipped here.
"""
from __future__ import annotations

import json
from pathlib import Path

REPO = "Edge-Innovations-Tech/Dev-LZ-Edge-AWS"
OUT_DIR = Path(__file__).resolve().parent.parent / "catalog" / "offerings"

MODULES = {
    "network": (
        "Network",
        "VPC, subnets, internet gateway, route tables, and security groups",
        {"enable": True, "vpc_cidr": "10.20.0.0/16", "subnet_cidr": "10.20.1.0/24", "map_public_ip_on_launch": False},
    ),
    "iam": (
        "IAM",
        "IAM roles and least-privilege inline policies",
        {"enable": True, "role_name": "cortex-dev-lz-role", "policy_actions": ["ec2:Describe*"]},
    ),
    "containers": (
        "Containers",
        "EKS clusters and managed node groups (consumes an existing VPC/subnets)",
        {"enable": True, "kubernetes_version": "1.29", "vpc_id": "vpc-0123456789abcdef0", "subnet_ids": ["subnet-0123456789abcdef0"], "node_count": 1},
    ),
    "serverless": (
        "Serverless",
        "Lambda functions with basic execution roles",
        {"enable": True, "function_name": "cortex-dev-fn", "runtime": "nodejs20.x"},
    ),
    "database": (
        "Database",
        "RDS instances with private subnet placement and encryption",
        {"enable": True, "engine": "postgres", "engine_version": "16.3", "instance_class": "db.t3.micro", "password": "<set-a-strong-password>", "subnet_ids": ["subnet-0123456789abcdef0"]},
    ),
    "storage": (
        "Storage",
        "encrypted EBS volumes",
        {"enable": True, "size_gb": 50, "volume_type": "gp3", "availability_zone": "us-east-1a"},
    ),
    "object-storage": (
        "Object Storage",
        "S3 buckets with block-public-access and versioning",
        {"enable": True, "bucket_name": "cortex-dev-bucket", "versioning": "Enabled"},
    ),
    "dns": (
        "DNS",
        "Route 53 hosted zones",
        {"enable": True, "zone_name": "dev.example.com", "private_zone": False},
    ),
    "monitoring": (
        "Monitoring",
        "SNS topics and email subscriptions",
        {"enable": True, "topic_name": "cortex-dev-topic", "subscription_email": "platform@example.com"},
    ),
    "cost": (
        "Cost",
        "monthly AWS Budgets with threshold notifications",
        {"enable": True, "amount": "100", "threshold_percent": 80, "notification_email": "finops@example.com"},
    ),
}


def module_path(capability: str) -> str:
    return f"modules/{capability}"


def provider_context_fields() -> list[dict]:
    return [
        {
            "id": "account_id",
            "label": "AWS Account ID",
            "type": "text",
            "required": True,
            "identifier": "account_id",
            "description": "12-digit AWS account ID for provider context and budgets.",
        },
        {
            "id": "region",
            "label": "AWS Region",
            "type": "text",
            "required": True,
            "identifier": "region",
            "defaultValue": "us-east-1",
        },
        {
            "id": "aws_profile",
            "label": "AWS Profile",
            "type": "text",
            "required": False,
            "identifier": "aws_profile",
            "defaultValue": "default",
            "description": "~/.aws/credentials profile name on the AAP execution environment.",
        },
    ]


def build_manifest(capability: str, title_suffix: str, description_detail: str, sc_example: dict) -> dict:
    slug = capability.replace("-", "_")
    return {
        "schemaVersion": "1.0",
        "version": "0.1.0",
        "basic": {
            "title": f"AWS Dev — {title_suffix} Landing Zone",
            "description": (
                f"Provisions the Cortex AWS development {capability} module ({description_detail}) "
                "via OpenTofu, executed through the cortex.terraform Ansible substrate on AAP. "
                "Set enable=true to create real AWS resources; false runs an inventory-only stub."
            ),
            "categories": ["Landing Zone", "AWS", title_suffix],
        },
        "userForm": [
            {
                "id": "name_prefix",
                "label": "Name Prefix",
                "type": "text",
                "required": True,
                "identifier": "name_prefix",
                "defaultValue": "cortex-dev",
            },
            {
                "id": "environment",
                "label": "Environment",
                "type": "text",
                "required": True,
                "identifier": "environment",
                "defaultValue": "dev",
            },
            {
                "id": "owner",
                "label": "Owner",
                "type": "text",
                "required": True,
                "identifier": "owner",
                "defaultValue": "platform-engineering",
            },
            {
                "id": "cost_center",
                "label": "Cost Center",
                "type": "text",
                "required": True,
                "identifier": "cost_center",
                "defaultValue": "cortex-dev",
            },
            {
                "id": "data_classification",
                "label": "Data Classification",
                "type": "text",
                "required": True,
                "identifier": "data_classification",
                "defaultValue": "internal",
            },
            *provider_context_fields(),
            {
                "id": "enable",
                "label": "Enable Real Resources",
                "type": "text",
                "required": True,
                "identifier": "enable",
                "defaultValue": "true",
                "description": "true provisions real AWS resources; false runs an inventory-only stub.",
            },
            {
                "id": "service_config",
                "label": "Service Config (JSON)",
                "type": "text",
                "required": False,
                "identifier": "service_config",
                "multiline": True,
                "defaultValue": json.dumps(sc_example),
                "description": (
                    f"Provider-specific {capability} configuration as JSON. "
                    "Merged with the enable toggle and provider context."
                ),
            },
        ],
        "backend": {
            "invocationType": "Ansible Job",
            "deploymentTypes": ["Provision"],
            "templateId": "cortex-terraform-execute",
            "cloudProvider": "AWS",
            "githubRepo": REPO,
            "githubVersion": "main",
        },
        "orchestration": {
            "orchestration_method": "AAP-Job",
            "orch_id": "cortex-terraform-execute",
            "parameters_passthrough": True,
            "options": {
                "substrate": "cortex-terraform",
                "backend": "opentofu",
                "cloud_provider": "AWS",
                "source_git_repo": REPO,
                "source_git_ref": "main",
                "module_path": module_path(capability),
                "workspace": f"aws-dev-{slug}",
                "environment": "dev",
                "data_classification": "internal",
                "aap_template_id": "8",
                "aap_destroy_template_id": "8",
            },
        },
        "tagAssociations": [],
    }


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for capability, (title_suffix, description_detail, sc_example) in MODULES.items():
        manifest = build_manifest(capability, title_suffix, description_detail, sc_example)
        out_path = OUT_DIR / f"{capability.replace('-', '_')}.manifest.json"
        out_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
        print(f"wrote {out_path}")
    print("note: compute.manifest.json is hand-maintained and intentionally not regenerated")


if __name__ == "__main__":
    main()
