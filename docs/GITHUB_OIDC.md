# GitHub Actions OIDC Setup

This repo is designed to authenticate Terraform from GitHub Actions without static cloud credentials.

## Repository

- Organization: `Edge-Innovations-Tech`
- Repository: `Dev-LZ-Edge-AWS`
- Environment: `development`

## Required Setup

Configure a cloud-side trust relationship for GitHub's OIDC issuer and scope it to this repository and environment. Store non-secret IDs such as account, tenancy, subscription, project, role, client, or service-account identifiers as GitHub environment variables.

The workflows intentionally include placeholders until real cloud account IDs are available.
