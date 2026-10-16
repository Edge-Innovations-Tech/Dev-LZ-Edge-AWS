# Security Policy

This repository holds Terraform modules and a development landing-zone root for AWS, published by Edge Innovations Tech. It is infrastructure code, not a hosted service. The Cantilever platform itself is not in this repository.

## Reporting a vulnerability

Please report suspected vulnerabilities privately. Do not open a public issue or pull request for them.

- Preferred: use GitHub "Report a vulnerability" on this repository's Security tab (private vulnerability reporting), once the maintainers have enabled it.
- Email: `<PLACEHOLDER: security contact address, to be set by the maintainers>`

Please include the affected module and path, the commit or version (`VERSION` file), what you observed, steps to reproduce, and the impact you believe it has. Do not include real credentials, account IDs or other people's data; redact them.

## What to expect

These are targets, not guarantees; the maintainers will confirm or change them.

- We aim to acknowledge a report within 3 business days.
- We aim to give an assessment and a plan within 10 business days.
- We will keep you informed and credit you in the advisory if you wish.
- We ask for coordinated disclosure: please allow up to 90 days from your report before publishing details, and we will tell you if we need longer or can release sooner.

## Scope

In scope: the Terraform modules under `modules/`, the `envs/` roots, the `policy/` rules, scripts and workflows in this repository, for example an insecure default (public exposure, missing encryption, over-broad IAM), a flaw in a policy check, or a secret committed to the repository.

Out of scope: vulnerabilities in third-party providers or services (AWS, Terraform, GitHub), findings that need a modified copy of the code to apply, and reports from automated scanners without a demonstrated impact.

## Supported versions

Only the latest commit on `main` receives security fixes. See `VERSION` and `CHANGELOG.md`.

## Secrets

Do not commit provider credentials. If you find one in this repository, report it as above so it can be rotated; do not use it.

## Related

`docs/SECURITY.md` lists the Zero Trust defaults the modules aim for. This file is the reporting policy.
