# Environments Configuration (Optional)

Define specific variables per environment. Currently used for Azure Resource tags, e.g. `env=dev` vs `env=prod`.

These custom tags are merged into defaults defined in [`/variables.tf`](./../variables.tf)

### Usage example

These values need to be explicitly specified via `-var-file` flag, e.g.

```
terraform plan -var-file=environments/dev.tfvars -out plan.tfplan
terraform apply plan.tfplan
```
