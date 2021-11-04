# Deploy this Project

How to deploy this example in your own Azure account(s). This project uses random suffixes used to meet globally unique names requirements for Storage Accounts and Key Vaults. For details, see [example output](#example-output) below. 

### Disclaimer - not for production

This code is NOT meant to be used for production. While great efforts were taken for code quality and best practices, certain decisions were made for convenience. For example, this demo uses resource groups to separate environments. In practice, however, [Azure subscriptions are a better choice](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/govern/guides/standard/#governance-best-practices) per Microsoft's [Cloud Adoption Framework (CAF)](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework).


### Table of Contents

### [Pre-requisites](#pre-requisites)
  1. [Security Principals - User vs Service (CI/CD)](#1-security-principals---user-vs-service-cicd)
  2. [Azure Subscription](#2-azure-subscription)
  3. [Azure Active Directory Tenant](#3-azure-active-directory-tenant)
  4. [Azure DevOps Organization](#4-azure-devops-organization)

### [Terraform - Infrastructure as Code](#terraform---infrastructure-as-code-1)
  1. [Login to Azure](#1-login-to-azure)
  2. [Configure Environment](#2-configure-environment)
  3. [Initialize Terraform](#3-initialize-terraform)   
     3a) [From local computer](#3a-from-local-computer-recommended) (recommended)    
     3b) [Configure Azure Backend for Terraform](#3b-create-and-configure-azure-backend-for-terraform-optional) (optional)       
  4. [Create Deployment Plan](#4-create-deployment-plan)
  5. [Deploy Infrastructure](#5-deploy-infrastructure)


### Just the Commands

Make sure you read the full document because the pre-configuration of permissions is more complex. But once you've done it properly, deploying this project is simple:

```bash
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/<your-demo-org-name>"
export AZDO_PERSONAL_ACCESS_TOKEN="…"
terraform init -backend=false
terraform plan -out demo.tfplan
terraform apply demo.tfplan
```

## Pre-requisites

If you have a [Visual Studio subscription](https://visualstudio.microsoft.com/subscriptions/), use that for this demo so that the elevated service principals required have NO access to your actual Azure environments.

### 1) Security Principals - User vs Service (CI/CD)

- **User Principal** 🙋‍♀️  
  If you want to deploy locally, you do NOT need a service principal. You still need owner permissions, but a simple `az login` is enough to deploy the resources. 
  [Further Instructions &rarr;](#from-local-computer-recommended)

- **Headless Service Principal** 🤖  
  If you are using this project sample for its [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines/), you will also need to initiate an Azure Remote Backend. [Further Instructions &rarr;](#configure-azure-backend-for-terraform-optional)

For details, please read [Azure Security Principals](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview) official documentation.

### 2) Azure Subscription

- **User or Service Principal**  
  with elevated `Owner` permissions, required to create Key Vault Access Policies

### 3) Azure Active Directory Tenant

> ⚠️ Please consider carefully which Azure Active Directory (AAD) tenant you will use and read the Terraform documentation carefully about configuring the required elevated privileges. If possible, use a non-production AAD tenant.

- **Azure AD Tenant (non-production)**  
  If you have a non-production tenant, use it because the following service principal is very privileged. 

- **User or Service Principal**   
  with elevated privileges so that it can manage Azure Active Directory. [Follow these steps per Terraform documentation](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration) to properly configure your Service Principal.
  
- **Required Permissions on AD**  
  - Directory Role: [Azure AD Provider on Terraform](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration#method-1-directory-roles-recommended) recommends assigning the `Global Administrator` role to the security principal (user or service) in order to manage users, groups and applications.
  
  - API Permissions: if instead of using a role, you can also add the grant access to the following permissions for **_Azure Active Directory Graph API_**, _not_ the Microsoft Graph API:
    - `Application.ReadWrite.All`
    - `Directory.ReadWrite.All`

    See [Terraform documentation](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration#method-1-directory-roles-recommended) on configuring service principals for full instructions.

- **Create "superadmins" Azure Active Directory Group (optional)**  
  This is not applicable if you are just testing from your local computer. You will be made administrator of the Key Vaults generated by Infrastructure as Code (IaC) in this repository.
    
  If you are using CI/CD, the service principal will be made administrator. To give access to both, we can set the `superadmins_aad_object_id` variable in Terraform to include both you and the service principal. Then set the value in [`local.auto.tfvars.example`](./local.auto.tfvars.example) and remove the `.example` extension. See file for further details.

### 4) Azure DevOps Organization

- **DevOps Organization**  
  Create a [new organization](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization?view=azure-devops) just for this demo.

- **Personal Access Token (PAT)**  
  [Create a PAT](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page) and give it _full access_ to the newly created Azure DevOps organization.
  

## Terraform - Infrastructure as Code

### 1) Login to Azure

Make sure you are authenticated to Azure. 

- If you are deploying from a local machine, use `az login`
- If you are deploying from a headless agent, [authenticate using a service principal and client secret](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret) as described in the Terrform documentation.

### 2) Configure Environment

The [Azure DevOps Provider](https://www.terraform.io/docs/providers/azuredevops/index.html) in Terraform expects the following environment variables to be set.

To make this easier, create a `.env` file using the included `.env.sample` as a template and fill in your values:

```
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/<your-demo-org-name>"
export AZDO_PERSONAL_ACCESS_TOKEN="…"
```

Then load the variables into your shell:

```bash
source ./.env
```

### 3) Initialize Terraform

#### 3a) From local computer (recommended)

Assuming you are logged in with `az login`, just run

```
terraform init -backend=false
```

Then continue to [Create Deployment Plan &rarr;](##create-deployment-plan)

#### 3b) Create and Configure Azure Backend for Terraform (optional)

If you're configuring for a headless CI/CD agent or just want to try using remote backend for terraform state, please follow these additional steps. It is preferred to use the Azure CLI. See [./backends](./backends) for full commands.

#### Configure Backend

Create an `backend.hcl` file, using `backend.hcl.sample` as a template, filling in the placeholders iwth your values. hcl stands for HashiCorp Language.

```
storage_account_name="azurestorageaccountname"
container_name="storagecontainername"
key="project.tfstate"
sas_token="?sv=2019-12-12…"
```

Finally run `init` with our new backend config. 

```
terraform init -backend-config=./backend.hcl
```


### 4) Create Deployment Plan

See what resources Terraform will create and save plan to a file

```
terraform plan -out demo.tfplan
```

### 5) Deploy Infrastructure

If you are satisfied with the plan (it does not unexpectedly change or destroy resources), then deploy it with

```
terraform apply demo.tfplan
```

Please see [azure-pipelines/README.md](./azure-pipelines/README.md) for additional technical implementation details.

## Example Output

If it works, you will see something like the output below, which you can also find in the [Pipeline Build Results](https://dev.azure.com/julie-msft/e2e-governance-demo/_build/latest?definitionId=27&branchName=release) for this project. 

```

aad_groups = [
  "demo-fruits-admins-8zfj",
  "demo-fruits-devs-8zfj",
  "demo-fruits-team-8zfj",
  "demo-infra-admins-8zfj",
  "demo-infra-dev-8zfj",
  "demo-infra-team-8zfj",
  "demo-veggies-admins-8zfj",
  "demo-veggies-devs-8zfj",
  "demo-veggies-team-8zfj",
]
arm_environments = [
  {
    "key_vault" = "fruits-dev-8zfj-kv"
    "resource_group" = "fruits-dev-8zfj-rg"
    "storage_account" = "fruitsdev8zfj"
  },
  {
    "key_vault" = "fruits-prod-8zfj-kv"
    "resource_group" = "fruits-prod-8zfj-rg"
    "storage_account" = "fruitsprod8zfj"
  },
  {
    "key_vault" = "infra-shared-8zfj-kv"
    "resource_group" = "infra-shared-8zfj-rg"
    "storage_account" = "infrashared8zfj"
  },
  {
    "key_vault" = "veggies-dev-8zfj-kv"
    "resource_group" = "veggies-dev-8zfj-rg"
    "storage_account" = "veggiesdev8zfj"
  },
  {
    "key_vault" = "veggies-prod-8zfj-kv"
    "resource_group" = "veggies-prod-8zfj-rg"
    "storage_account" = "veggiesprod8zfj"
  },
]
azure_devops_projects = [
  {
    "description" = "Demo using AAD groups"
    "features" = tomap({
      "artifacts" = "disabled"
      "boards" = "disabled"
      "pipelines" = "enabled"
      "repositories" = "enabled"
      "testplans" = "disabled"
    })
    "name" = "project-fruits"
    "visibility" = "private"
  },
  {
    "description" = "Central IT managed stuff"
    "features" = tomap({
      "artifacts" = "disabled"
      "boards" = "disabled"
      "pipelines" = "enabled"
      "repositories" = "enabled"
      "testplans" = "disabled"
    })
    "name" = "central-it"
    "visibility" = "private"
  },
  {
    "description" = "Demo using AAD groups"
    "features" = tomap({
      "artifacts" = "disabled"
      "boards" = "disabled"
      "pipelines" = "enabled"
      "repositories" = "enabled"
      "testplans" = "disabled"
    })
    "name" = "project-veggies"
    "visibility" = "private"
  },
]
azure_devops_service_connections = [
  {
    "fruits_dev" = {
      "connection_name" = "fruits-dev-8zfj-rg-connection"
      "scope" = tostring(null)
    }
    "fruits_prod" = {
      "connection_name" = "fruits-prod-8zfj-rg-connection"
      "scope" = tostring(null)
    }
    "infra_shared" = {
      "connection_name" = "infra-shared-8zfj-rg-connection"
      "scope" = tostring(null)
    }
    "veggies_dev" = {
      "connection_name" = "veggies-dev-8zfj-rg-connection"
      "scope" = tostring(null)
    }
    "veggies_prod" = {
      "connection_name" = "veggies-prod-8zfj-rg-connection"
      "scope" = tostring(null)
    }
  },
]
service_principals = [
  "fruits-dev-8zfj-ci-sp",
  "fruits-prod-8zfj-ci-sp",
  "infra-shared-8zfj-ci-sp",
  "veggies-dev-8zfj-ci-sp",
  "veggies-prod-8zfj-ci-sp",
]
```
