# Environments Configuration (Optional)

Define specific variables per environment. Currently used for Azure Resource tags, e.g. `env=dev` vs `env=prod`.

### Usage example

```
terraform plan -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
```

### Default Values

Project should without without these custom values. See default values defined in [`/variables.tf`](./../variables.tf)