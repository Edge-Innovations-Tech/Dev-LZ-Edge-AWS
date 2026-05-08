# Contributing

Run these checks before opening a pull request:

```bash
terraform fmt -recursive
terraform -chdir=envs/dev init -backend=false
terraform -chdir=envs/dev validate
tflint --recursive
trivy config .
opa test policy/ -v
```
