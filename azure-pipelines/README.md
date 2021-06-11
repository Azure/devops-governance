# Azure Pipelines

Brief notes and considerations when automating infrastructure with [Terraform](https://terraform.io) and [Azure DevOps](https://azure.microsoft.com/en-us/services/devops/).

### Pipeline Overview

| Pipeline | Triggers | Terraform Backend | Detect Drift | Deploys |
|:--|:--|:--|:--|:--|
| [`ci.yaml`](./ci.yaml) | &bull; `main` branch<br>&bull; `dev` branch<br>&bull; `feat/*` branch<br>&bull; `fix/*` branch<br>&bull; Pull Requests to `main`  | local/none | No | No |
| [`detect-drift.yaml`](./detect-drift.yaml) | &bull; `main` branch<br>&bull; Pull Requests to `release`<br>&bull; Scheduled nightly | Azure Storage | Yes | No |
| [`cd.yaml`](./cd.yaml) | &bull; `release` branch | Azure Storage | No* | Yes  |

*The CD pipeline does not check for drift because this is checked at the pull request.

## Security Considerations

### Terraform State in Azure Blob Storage 

Terraform state is always in plain text, which is why it is stored in Azure Blob Storage with public access disabled.

- This storage account is NOT managed by Terraform
- This project prefers [Shared Access Signtures (SAS) tokens](https://docs.microsoft.com/en-us/azure/storage/common/storage-sas-overview) over [Access Keys](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-keys-manage?tabs=azure-portal) in order to:
  - Apply principle of least privilege
  - Use short-lived tokens for CI/CD because we trust for headless actors less

### Pipeline Secrets and Azure Key Vault Integration

- Secrets are stored in [Azure Key Vault](https://docs.microsoft.com/en-us/azure/devops/pipelines/release/azure-key-vault?view=azure-devops) and automatically fetched from Key Vault at build [run time](https://azuredevopslabs.com/labs/vstsextend/azurekeyvault/)
- Because variables are encrypted in Azure DevOps, secret variables not automatically decrypted and must be [explictly mapped into the environment](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch#secret-variables) - at every step.

#### Example

| Variable in YAML | Description | Naming Convention |
|:--|:--|:--|
| `kv-tf-state-blob-account` | Name of secret in Key Vault. The `$(…)` macro syntax means it will be fetched and processed into template before pipeline runs. | Custom  `kv-` prefix for easier debugging |
| `$TF_STATE_BLOB_ACCOUNT_NAME` | Mapped environment variable | Linux: uppercase with underscores |


```yaml
variables:
  - group: e2e-gov-demo-kv

steps:
- bash: |    
    terraform init \
      -backend=true \
      -backend-config="storage_account_name=$TF_STATE_BLOB_ACCOUNT_NAME" \
      -backend-config="container_name=$TF_STATE_BLOB_CONTAINER_NAME" \
      -backend-config="key=$TF_STATE_BLOB_FILE" \
      -backend-config="sas_token=$TF_STATE_BLOB_SAS_TOKEN"
  displayName: Terraform Init
  env:
    TF_STATE_BLOB_ACCOUNT_NAME:   $(kv-tf-state-blob-account)
    TF_STATE_BLOB_CONTAINER_NAME: $(kv-tf-state-blob-container)
    TF_STATE_BLOB_FILE:           $(kv-tf-state-blob-file)
    TF_STATE_BLOB_SAS_TOKEN:      $(kv-tf-state-sas-token)
```

### Why is there an Azure AD "Superadmins" Group? 

In this example "superadmins" refers to privileged accounts at the organization level, e.g. central IT infrastructure admins.

This project creates Azure Key Vaults, which require access policies for the Data Plane. This means you want to create the Key Vault _and_ give yourself access. 

If our CI/CD agent creates the Key Vault, it can assign itself access. But what if we as an infrastructure administrator also want access? If you give yourself access _outside of Terraform_, it can create **configuration drift** that conflicts with Terraform state. Using [Access Policies](https://docs.microsoft.com/en-us/azure/key-vault/general/secure-your-key-vault#data-plane-and-access-policies), you can [assign the Access Policy to an Azure AD group](https://docs.microsoft.com/en-us/azure/key-vault/general/overview-security#identity-and-access-management) instead of an account (service principal or user principal). 

N.B. This is not relevant if you use the [Azure RBAC model for Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide). At time of this writing (November 2020), this feature is still in preview, which is why this project uses access policies.
