# Governance on Azure Demo - from DevOps to ARM

This demo is used to illustrate end-to-end RBAC, including best practices and pitfalls based on actual customer experience. When securing your resources on Azure, you have to apply role based access control in multiple layers:

| Layer | Description |
|:--|:--|
| Infrastructure | Azure Resource Manager (ARM), e.g. Azure Portal, Azure CLI |
| CI/CD Pipelines | Azure DevOps, GitHub Actions |
| Source Code Management (SCM) | If you use automation and infrastructure as code, your defense starts here. |

### Who is this for?

This demo is targeted at organizations, small and large

- with multiple developer teams and applications
- with a central cloud ops team supporting developer teams - [Cloud Center of Excellence](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) in Microsoft speak

### Demo Results

When you run the demo, you will have the following DevOps Organization setup

<img src="./images/ado-demo-home.png" alt="" width="800">

_Credit: [icons by Smashicons](https://www.flaticon.com/authors/smashicons)_

## Prerequisites

- An Azure subscription
  - Logged in via `az login`
  - `Owner` rights on your subscription
- An Azure DevOps Organization
- Terraform

### Warning - run locally only!

⚠️  Run this *only locally* on your machine. It outputs service principal secrets, which you will need for CI/CD workflows

## Usage

### Configure Azure Backend for Terraform

#### 1. Create Storage Account

We will save our Terraform state in Azure Blob Storage

1. Create a storage account to hold Terraform state for this project. Be sure to [disable public read access](https://docs.microsoft.com/en-us/azure/storage/blobs/anonymous-read-access-configure?tabs=portal). 
1. Generate [SAS token](https://docs.microsoft.com/en-us/rest/api/storageservices/delegate-access-with-shared-access-signature) for this storage account
1. Create [Blob Storage container](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction#containers), e.g. `workspaces`, `projects`

#### 2. Configure Terraform

Create an `azure.conf` file, using `azure.conf.sample` as a template, filling in the placeholders iwth your values.

```
storage_account_name="azurestorageaccountname"
container_name="storagecontainername"
key="project.tfstate"
sas_token="?sv=2019-12-12…"
```

#### 3. Terraform Init with Config

Run `init` with our config. 

```
terraform init -backend-config=./azure.conf
```

#### 4. Happy Terraforming


```
terraform plan
terraform apply
```


## Resources

This demo was created with &hearts; by the FastTrack engineer [julie-ng](https://github.com/julie-ng) based on experience onboarding real Azure customers. Learn more about [FastTrack for Azure &rarr;](https://aka.ms/fasttrackforazure)

- Todo: add links to Microsoft Documentation

## Contributing

- Please use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) so we can continue to _automate_ the Change Log. Thank you.

## Code of Conduct

If you want to contribute, please first read the Microsoft [Code of Conduct &rarr;](./.github/CODE_OF_CONDUCT.md)


## Todo

- [ ] Save service principal secrets to Key Vault instead of outputting them
- [ ] Create custom "Terraform Contributor" role for service principal so that it can also assign RBAC. Example use case is AAD Pod Identity
- [ ] Create `.azcli` account for setting up intiial Storage container for Terraform state file
- [ ] Add instructions to run locally without remote state file
