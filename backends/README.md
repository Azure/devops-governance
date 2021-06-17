# Terraform - Remote State Management

_Last Updated: 16 June 2021  
Description: the document below describes how Terraform State is managed in this project. Your use case may differ._

By default this project uses local state for low barrier to entry for you to deploy and learn about end to end governance. 

When integrating CI/CD automation or collaborating across Teams, Terraform needs a remote backend to keep track of your infrastructre's state. The Azure Remote Backend is an Azure Storage Account.

## Use Multiple Storage Accounts 

Although it is possible to use a single Storage Account to back multiple Terraform state files, that should only be done if the security boundary is the same. In the diagram below, the non-production storage account named `devstorageaccount` hosts state files for two environments:
- `dev.tfstate`
- `staging.tfstate`

Following security best practices and Principle of Least Privilege, the production state is separated into its own Storage Account named `prodstorageaccount`.

![RBAC'd State Management](./../images/tf-state-rbac.svg)

Using multiple accounts gives us _different scopes_ for apply Role Based Access Control (RBAC), so we can limit access to production resources. In the diagram above there are two different Service Principals whose access is limited to their respective production vs non-production scopes.

_Note: the diagram above assumes all non-production environments have the same security boundary. If there are business and security requirements to separate the `dev` and `staging` environments, then 3 different storage accounts would be required._

## Working with Multiple Backends/Environments

### Create Backend Configuration Files

To work with multiple Terraform remote backends, we will also need multiple configurations. Because they contain tokens or access keys, be careful not to accidentally check them into git. This project ignores all `*.backend.hcl` files. 

To get started, create a new file, for example `dev.backend.hcl` and copy the contents from `backend.hcl.sample`. Replace the placeholder values with your own configuration. Create separate configuration files per backend.

### Target Different Backends

When you initialize the Terraform project, you can specify which backend configuration should be used, for example to target or **development** setup:

```bash
terraform init -backend-config=dev.backend.hcl
```

### Toggling Different Backends

If we want to target a different state file, we would change the `-backend-config` flag.

Please note you may need to remove your local `.terraform` folder when switching backends. A scenario for this is testing newer versions of Terraform or [official azurerm provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) on non-production resources (usually on a different git branch), before applying them to production resources.

---

If you do not have any storage accounts, follow the instructions below to create one you can use for testing. Do not use in production without evaluating the configuration for your use case.

## Create Storage Accounts with Azure CLI

### Create a Storage Acount

If you need to create a storage account for your Terraform state files, you can do so with the Azure CLI.

Configure some resource names to your liking:

```bash
export TF_BACKEND_RG_NAME=terraform-workspaces-rg
export TF_BACKEND_STORAGEACCT_NAME=yourstorageaccountname  # must be globally unique
export TF_BACKEND_CONTAINER_NAME=terraform
export TF_BACKEND_LOCATION=eastus
```

### Create a Resource Group

We'll create a dedicated resource group for our state files.

```bash
az group create \
    --name $TF_BACKEND_RG_NAME \
    --location $TF_BACKEND_LOCATION
```

### Create a Storage Account

This holds your actual Terraform state file. Note that we **explicitly disable public access**.

```bash
az storage account create \
    --name $TF_BACKEND_STORAGEACCT_NAME \
    --resource-group $TF_BACKEND_RG_NAME \
    --kind StorageV2 \
    --sku Standard_LRS \
    --https-only true \
    --allow-blob-public-access false
```

### Create a Blob Storage Container

Blobs always need a parent container.

```bash
az storage container create \
    --name $TF_BACKEND_CONTAINER_NAME \
    --account-name $TF_BACKEND_STORAGEACCT_NAME \
    --public-acces off \
    --auth-mode login
```

### Get Credentials for Storage Account

#### Option A - Get Storage Account Key

To get the Storage Account key, we'll pipe the Azure CLI response to  [jq](https://stedolan.github.io/jq/) to extract just the *first* storage account key.

```bash
az storage account keys list \
	--resource-group $TF_BACKEND_RG_NAME \
	--account-name $TF_BACKEND_STORAGEACCT_NAME \
		| jq -r '.[0].value'
```

If you use an Access Key, uncomment the `access_key="…"` line in your backend config file.

Please protect this access key, which allows access to your *entire* Storage Account, including [Files](https://azure.microsoft.com/services/storage/files/), [Tables](https://azure.microsoft.com/services/storage/tables/) and [Queues](https://docs.microsoft.com/azure/storage/queues/storage-queues-introduction).

#### Option B - Shared Access Signature (SAS Token)

Instead of using the access key, we will create a Shared Access Signature (SAS) token for just the Azure Blob Service that expires in 7 days.

```bash
az storage account generate-sas \
    --permissions cdlruwap \
    --account-name $TF_BACKEND_STORAGEACCT_NAME \
    --services b \
    --resource-types sco  \
    --expiry $(date -v+7d '+%Y-%m-%dT%H:%MZ') \
    -o tsv
```

If you use an SAS token, uncomment the `sas_token="…"` line in your backend config file.
