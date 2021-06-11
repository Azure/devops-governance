# Terraform

How to deploy this example in your own Azure account(s).

## Disclaimer - not for production

This code is NOT meant to be used for production. While great efforts were taken for code quality and best practices, certain decisions were made for convenience. For example, this demo uses resource groups to separate environments. In practice, however, [Azure subscriptions are a better choice](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/govern/guides/standard/#governance-best-practices) per Microsoft's [Cloud Adoption Framework (CAF)](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework).

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

> ⚠️ Please consider carefully which Azure AD tenant you will use and read the Terraform documentation carefully about configuring the required elevated privileges.

- **Azure AD Tenant (non-production)**  
  If you have a non-production tenant, use it because the following service principal is very privileged. 

- **User or Service Principal**   
  with elevated privileges so that it can manage Azure Active Directory. [Follow these steps per Terraform documentation](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration) to properly configure your Service Principal.
  
- **Required Permissions on AD**  
  - Directory Role: [Azure AD Provider on Terraform](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration#method-1-directory-roles-recommended) recommends assigning the `Global Administrator` role to the security principal (user or service) in order to manage users, groups and applications.
  
  - API Permissions: if instead of using a role, you can also add the grant access to the following permissions:
    - `Application.ReadWrite.All`
    - `Directory.ReadWrite.All`

### 4) Azure DevOps Organization

- **DevOps Organization**  
  Create a [new organization](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization?view=azure-devops) just for this demo.

- **Personal Access Token (PAT)**  
  [Create a PAT](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page) and give it _full access_ to the newly created Azure DevOps organization.
  

## Terraform 

### Login

Make sure you are authenticated to Azure. 

- If you are deploying from a local machine, use `az login`
- If you are deploying from a headless agent, [authenticate using a service principal and client secret](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret) as described in the Terrform documentation.

### Configure Environment

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

### terraform init

#### From local computer (recommended)

Assuming you are logged in with `az login`, just run

```
terraform init 
```

Then continue to [Create Deployment Plan &rarr;](##create-deployment-plan)

#### Configure Azure Backend for Terraform (optional)

If you're configuring for a headless CI/CD agent or just want to try using remote backend for terraform state, please follow these additional steps.

It is preferred to use the Azure CLI. See [setup.azcli](./setup.azcli) for full commands.

| Step in Azure Portal | [Azure CLI](./setup.azcli)|
|:--|:--|
| [Create a storage account*](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal) | `az storage account create …`  |
| [Create Blob container](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction#containers) | `az storage container create …` |
| [Generate SAS token](https://docs.microsoft.com/en-us/rest/api/storageservices/delegate-access-with-shared-access-signature) for this storage account | `az storage account generate-sas …` | 

*Don't forget to [disable public read access](https://docs.microsoft.com/en-us/azure/storage/blobs/anonymous-read-access-configure?tabs=portal) - otherwise everyone can read your credentials!

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
terraform init -backend=true -backend-config=./backend.hcl
```


### Create Deployment Plan

See what resources Terraform will create and save plan to a file

```
terraform plan -out demo.tfplan
```

### Finally Deploy

If you are satisfied with the plan (it does not unexpectedly change or destroy resources), then deploy it with

```
terraform apply demo.tfplan
```

Please see [azure-pipelines/README.md](./azure-pipelines/README.md) for additional technical implementation details.

## Example Output

If it works, you will see something like the output below, which you can also find in the [Pipeline Build Results](https://dev.azure.com/julie-msft/e2e-governance-demo/_build/latest?definitionId=27&branchName=release) for this project. 

```
aad_groups = [
  {
    "fruits" = {
      "id" = "9a52fe9f-a477-4d84-a80c-e832fb05421d"
      "members" = []
      "name" = "demo-fruits-u6t7"
      "object_id" = "9a52fe9f-a477-4d84-a80c-e832fb05421d"
      "owners" = []
      "prevent_duplicate_names" = true
    }
    "fruits_admins" = {
      "id" = "396ce2dc-879b-43f9-985e-4ddee6d631ce"
      "members" = []
      "name" = "demo-fruits-admins-u6t7"
      "object_id" = "396ce2dc-879b-43f9-985e-4ddee6d631ce"
      "owners" = []
      "prevent_duplicate_names" = true
    }
    "infra" = {
      "id" = "12ef9c1a-67c1-49d0-acc2-759ebd2b9fce"
      "members" = []
      "name" = "demo-infra-u6t7"
      "object_id" = "12ef9c1a-67c1-49d0-acc2-759ebd2b9fce"
      "owners" = []
      "prevent_duplicate_names" = true
    }
    "infra_admins" = {
      "id" = "db89444f-1ca0-4a5b-8121-25da32e306c7"
      "members" = []
      "name" = "demo-infra-admins-u6t7"
      "object_id" = "db89444f-1ca0-4a5b-8121-25da32e306c7"
      "owners" = []
      "prevent_duplicate_names" = true
    }
    "veggies" = {
      "id" = "60ba1ec0-2f8c-487b-bb7f-ec41442c7ed8"
      "members" = []
      "name" = "demo-veggies-u6t7"
      "object_id" = "60ba1ec0-2f8c-487b-bb7f-ec41442c7ed8"
      "owners" = []
      "prevent_duplicate_names" = true
    }
    "veggies_admins" = {
      "id" = "862c9ab4-0b5d-4175-aa3a-f9a6bb79cfe1"
      "members" = []
      "name" = "demo-veggies-admins-u6t7"
      "object_id" = "862c9ab4-0b5d-4175-aa3a-f9a6bb79cfe1"
      "owners" = []
      "prevent_duplicate_names" = true
    }
  },
]
azure_devops_collaboration_permissions = {
  "fruits" = {
    "azure_devops_groups" = {
      "admins" = {
        "origin" = "aad"
        "principal_name" = "[TEAM FOUNDATION]\\demo-fruits-admins-u6t7"
        "project_id" = "a4a4cd1b-c0cb-43c6-af5a-35526ed3ae28"
        "project_role" = "Project Administrators"
        "subject_kind" = "group"
      }
      "contributors" = {
        "origin" = "aad"
        "principal_name" = "[TEAM FOUNDATION]\\demo-fruits-u6t7"
        "project_id" = "a4a4cd1b-c0cb-43c6-af5a-35526ed3ae28"
        "project_role" = "Contributors"
        "subject_kind" = "group"
      }
    }
  }
  "veggies" = {
    "azure_devops_groups" = {
      "admins" = {
        "origin" = "aad"
        "principal_name" = "[TEAM FOUNDATION]\\demo-veggies-admins-u6t7"
        "project_id" = "a4a4cd1b-c0cb-43c6-af5a-35526ed3ae28"
        "project_role" = "Project Administrators"
        "subject_kind" = "group"
      }
      "contributors" = {
        "origin" = "aad"
        "principal_name" = "[TEAM FOUNDATION]\\demo-veggies-u6t7"
        "project_id" = "a4a4cd1b-c0cb-43c6-af5a-35526ed3ae28"
        "project_role" = "Contributors"
        "subject_kind" = "group"
      }
    }
  }
}
azure_devops_projects = [
  {
    "proj_fruits" = {
      "description" = "Demo using AAD groups"
      "features" = {
        "artifacts" = "disabled"
        "boards" = "disabled"
        "pipelines" = "enabled"
        "repositories" = "enabled"
        "testplans" = "disabled"
      }
      "id" = "d0a51b5e-1f7a-4716-a2d2-70863a860431"
      "process_template_id" = "adcc42ab-9882-485e-a3ed-7678f01f66bc"
      "project_name" = "project-fruits"
      "version_control" = "Git"
      "visibility" = "private"
      "work_item_template" = "Agile"
    }
    "proj_infra" = {
      "description" = "Central IT managed stuff"
      "features" = {
        "artifacts" = "disabled"
        "boards" = "disabled"
        "pipelines" = "enabled"
        "repositories" = "enabled"
        "testplans" = "disabled"
      }
      "id" = "3b8e050e-47a2-47ff-8007-ca2eb0c66591"
      "process_template_id" = "adcc42ab-9882-485e-a3ed-7678f01f66bc"
      "project_name" = "central-it"
      "version_control" = "Git"
      "visibility" = "private"
      "work_item_template" = "Agile"
    }
    "proj_veggies" = {
      "description" = "Demo using AAD groups"
      "features" = {
        "artifacts" = "disabled"
        "boards" = "disabled"
        "pipelines" = "enabled"
        "repositories" = "enabled"
        "testplans" = "disabled"
      }
      "id" = "a86cc45e-615d-4d06-8fab-422e3c1767be"
      "process_template_id" = "adcc42ab-9882-485e-a3ed-7678f01f66bc"
      "project_name" = "project-veggies"
      "version_control" = "Git"
      "visibility" = "private"
      "work_item_template" = "Agile"
    }
  },
]
azure_devops_standard_permissions = [
  {
    "proj_fruits" = {
      "azure_devops_groups" = {
        "admins" = {
          "origin" = "aad"
          "principal_name" = "[TEAM FOUNDATION]\\demo-fruits-admins-u6t7"
          "project_id" = "d0a51b5e-1f7a-4716-a2d2-70863a860431"
          "project_role" = "Project Administrators"
          "subject_kind" = "group"
        }
        "contributors" = {
          "origin" = "aad"
          "principal_name" = "[TEAM FOUNDATION]\\demo-fruits-u6t7"
          "project_id" = "d0a51b5e-1f7a-4716-a2d2-70863a860431"
          "project_role" = "Contributors"
          "subject_kind" = "group"
        }
      }
    }
    "proj_infra" = {
      "azure_devops_groups" = {
        "admins" = {
          "origin" = "aad"
          "principal_name" = "[TEAM FOUNDATION]\\demo-infra-admins-u6t7"
          "project_id" = "3b8e050e-47a2-47ff-8007-ca2eb0c66591"
          "project_role" = "Project Administrators"
          "subject_kind" = "group"
        }
        "contributors" = {
          "origin" = "aad"
          "principal_name" = "[TEAM FOUNDATION]\\demo-infra-u6t7"
          "project_id" = "3b8e050e-47a2-47ff-8007-ca2eb0c66591"
          "project_role" = "Contributors"
          "subject_kind" = "group"
        }
      }
    }
    "proj_veggies" = {
      "azure_devops_groups" = {
        "admins" = {
          "origin" = "aad"
          "principal_name" = "[TEAM FOUNDATION]\\demo-veggies-admins-u6t7"
          "project_id" = "a86cc45e-615d-4d06-8fab-422e3c1767be"
          "project_role" = "Project Administrators"
          "subject_kind" = "group"
        }
        "contributors" = {
          "origin" = "aad"
          "principal_name" = "[TEAM FOUNDATION]\\demo-veggies-u6t7"
          "project_id" = "a86cc45e-615d-4d06-8fab-422e3c1767be"
          "project_role" = "Contributors"
          "subject_kind" = "group"
        }
      }
    }
  },
]
azure_devops_supermarket_permissions = {
  "fruits" = {
    "azure_devops_groups" = {
      "admins" = {
        "origin" = "aad"
        "principal_name" = "[TEAM FOUNDATION]\\demo-fruits-admins-u6t7"
        "project_id" = "d6a03f47-0f52-4d83-bf49-8c90787c1e5c"
        "project_role" = "Project Administrators"
        "subject_kind" = "group"
      }
      "contributors" = {
        "origin" = "aad"
        "principal_name" = "[TEAM FOUNDATION]\\demo-fruits-u6t7"
        "project_id" = "d6a03f47-0f52-4d83-bf49-8c90787c1e5c"
        "project_role" = "Contributors"
        "subject_kind" = "group"
      }
    }
  }
  "veggies" = {
    "azure_devops_groups" = {
      "admins" = {
        "origin" = "aad"
        "principal_name" = "[TEAM FOUNDATION]\\demo-veggies-admins-u6t7"
        "project_id" = "d6a03f47-0f52-4d83-bf49-8c90787c1e5c"
        "project_role" = "Project Administrators"
        "subject_kind" = "group"
      }
      "contributors" = {
        "origin" = "aad"
        "principal_name" = "[TEAM FOUNDATION]\\demo-veggies-u6t7"
        "project_id" = "d6a03f47-0f52-4d83-bf49-8c90787c1e5c"
        "project_role" = "Contributors"
        "subject_kind" = "group"
      }
    }
  }
}
workspaces = [
  {
    "fru_dev" = {
      "key_vault" = "fruits-dev-u6t7-kv"
      "resource_group_name" = "fruits-dev-u6t7-rg"
      "service_principals" = [
        {
          "application_id" = "583ba581-51a4-40d0-9a28-dae99b926b43"
          "client_secret" = "See 'workspace-sp-secret' in Key Vault 'fruits-dev-u6t7-kv'"
          "display_name" = "fruits-dev-u6t7-rg-sp"
          "object_id" = "dd6b5754-8345-4444-a831-7d8d0cd89dea"
        },
        {
          "application_id" = "96c3130a-d26e-46c4-935d-a2c071600b78"
          "client_secret" = "See 'kv-reader-sp-secret' in Key Vault 'fruits-dev-u6t7-kv'"
          "display_name" = "fruits-dev-u6t7-kv-reader-sp"
          "object_id" = "5a30608f-6cc3-4a04-9491-81703ed0d2eb"
        },
      ]
      "storage_account" = "fruitsdevu6t7"
    }
    "fru_prod" = {
      "key_vault" = "fruits-prod-u6t7-kv"
      "resource_group_name" = "fruits-prod-u6t7-rg"
      "service_principals" = [
        {
          "application_id" = "22e7e800-a89f-4d4a-8bcb-a613119ce07c"
          "client_secret" = "See 'workspace-sp-secret' in Key Vault 'fruits-prod-u6t7-kv'"
          "display_name" = "fruits-prod-u6t7-rg-sp"
          "object_id" = "61590dec-2216-4473-8ed8-506b2261c04e"
        },
        {
          "application_id" = "fefac536-9b39-4bf9-9301-80301593aa19"
          "client_secret" = "See 'kv-reader-sp-secret' in Key Vault 'fruits-prod-u6t7-kv'"
          "display_name" = "fruits-prod-u6t7-kv-reader-sp"
          "object_id" = "1139bfbc-7489-4d30-8711-f5571d9d4356"
        },
      ]
      "storage_account" = "fruitsprodu6t7"
    }
    "shared" = {
      "key_vault" = "infra-shared-u6t7-kv"
      "resource_group_name" = "infra-shared-u6t7-rg"
      "service_principals" = [
        {
          "application_id" = "d6f7ee48-67b3-49a0-b4f2-698e1f5880ef"
          "client_secret" = "See 'workspace-sp-secret' in Key Vault 'infra-shared-u6t7-kv'"
          "display_name" = "infra-shared-u6t7-rg-sp"
          "object_id" = "d45dca1f-1e2a-4d03-87ee-d05b663db4ff"
        },
        {
          "application_id" = "346a0b41-3df0-4f6a-8521-a11a72be5bc3"
          "client_secret" = "See 'kv-reader-sp-secret' in Key Vault 'infra-shared-u6t7-kv'"
          "display_name" = "infra-shared-u6t7-kv-reader-sp"
          "object_id" = "329c3250-2224-481f-8fc5-9dfc6af68a0a"
        },
      ]
      "storage_account" = "infrasharedu6t7"
    }
    "veg_dev" = {
      "key_vault" = "veggies-dev-u6t7-kv"
      "resource_group_name" = "veggies-dev-u6t7-rg"
      "service_principals" = [
        {
          "application_id" = "63f16519-ed4f-4a2b-aa19-8b33332b05a4"
          "client_secret" = "See 'workspace-sp-secret' in Key Vault 'veggies-dev-u6t7-kv'"
          "display_name" = "veggies-dev-u6t7-rg-sp"
          "object_id" = "cec7d874-7bb2-47fd-8515-36f4503990e1"
        },
        {
          "application_id" = "8584b07b-ffac-475c-bda2-28a401fa5856"
          "client_secret" = "See 'kv-reader-sp-secret' in Key Vault 'veggies-dev-u6t7-kv'"
          "display_name" = "veggies-dev-u6t7-kv-reader-sp"
          "object_id" = "c48961d4-8f2f-4852-bdd9-3d9213c4c5e1"
        },
      ]
      "storage_account" = "veggiesdevu6t7"
    }
    "veg_prod" = {
      "key_vault" = "veggies-prod-u6t7-kv"
      "resource_group_name" = "veggies-prod-u6t7-rg"
      "service_principals" = [
        {
          "application_id" = "74e682cc-c2bb-4af7-a865-e86d93dae688"
          "client_secret" = "See 'workspace-sp-secret' in Key Vault 'veggies-prod-u6t7-kv'"
          "display_name" = "veggies-prod-u6t7-rg-sp"
          "object_id" = "5768c787-f9b8-4ada-8d4c-3867831504fc"
        },
        {
          "application_id" = "0e4c05e9-06a2-4da8-93d6-b411f4f62b46"
          "client_secret" = "See 'kv-reader-sp-secret' in Key Vault 'veggies-prod-u6t7-kv'"
          "display_name" = "veggies-prod-u6t7-kv-reader-sp"
          "object_id" = "bafe8427-b135-4e07-b20f-b4d14777a8f2"
        },
      ]
      "storage_account" = "veggiesprodu6t7"
    }
  },
]
```

Note also that no secrets are outputted, just where to go find them afterwards, e.g. `See 'kv-reader-sp-secret' in Key Vault 'fruits-dev-u6t7-kv'`

