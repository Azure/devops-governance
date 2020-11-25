# Concept - Multi-tier Governance

### Abstract

When developing a governance model for your organization, it is important to remember that Azure Resource Management (ARM) is only _one_ way to manage resources. 

When introducing automation via CI/CD pipelines, be aware that the Role Based Access Control (RBAC) model must be applied at **multiple layers**. This code sample deploys many of these layers and show how they can be configured together in a unified governance model. 

![End to End Governance](./images/e2e-governance-scm-to-arm.svg)

## Example Use Case, Business Requirements

This demo is open source and intended to be used as a **Teaching Tool** for organizations who are new to DevOps and need to create a governance model for deploying to Azure. Please read this carefully to understand the decisions behind the 

Any governance model must be tied to the organization's business rules, which are reflected in any technical implementation of access controls. This example model uses a fictitious company with common requirements:

- The organization has many vertical business units, e.g. "fruits" and "vegetables", which operate largely independently.
- Every team has a subset of developers called "admins" with elevated privileges.
- Every team has 2 environments
  - Production - only admins have elevated privileges
  - Non-production - all developers have elevated privileges (to encourage experimentation and innovation)
- Every application should implement DevOps, not just continuous integration (CI) but also (CD), i.e. deployments can be automatically triggered via changes to the git repository.
- There is a central IT team, specializing in cloud infrastructure that manages shared services used by business units. This team is called [Cloud Center of Excellence](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) in Microsoft's [Cloud Adoption Framework (CAF)](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework) terminology.
- The organization started with an isolated project model to accelerate the journey to the cloud. But now they are exploring options to break silos and encourage collaboration by creating the "collaboration" and "supermarket" projects.

## Azure Active Directory (AAD)

Azure Active Directory is central identity provider and will be leveraged on both Azure DevOps and ARM layers. The overlapping triangles illustrate common pattern of leveraging [Additive Permissions](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview#multiple-role-assignments).

In this example, each business domain has 2 AAD groups: a general group and a subset for admins only.

<img src="./images/aad-groups.svg" alt="" width="400">

### Roles

The groups are assigned the following built-in roles in Azure and AzureDevOps. In both products, administrators are given elevated privileges. 

| Group Name | ARM Role | Azure DevOps Role |
|:--|:--|:--|
| `fruits` | Contributor | Contributor |
| `fruits-admins` | Owner | Project Administrators |
| `veggies` | Contributor | Contributor |
| `veggies-admins` | Owner | Project Administrators |

In most cases, an `Owner` or `Project Administrator` has additional permissions to configure the product that can change the governance model. 

## Azure Environments & Service Connections

As a general security best practice, logical environments will have a governance boundary. Per Microsoft's Cloud Adoption Framework (CAF), this is usually an Azure Subscription. (TODO: link to CAF. Do not debate here)

### How to Secure Environments in Azure DevOps

#### Not Via Environments

Azure DevOps has an "Environments" feature that allows you to secure Virtual Machines (VMs) and Kubernetes Namespaces. This example does **not** use environments because when creating [pipelines as Code](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops#security), this mechanism is no longer a security boundary. Environments, however, are still useful for [deployment histories](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops#deployment-history-within-environments) and auditing purposes.

#### Via Service Connections

A service connection is essentially a service principal. Just as you have a service principal per environment, you will have a service connection per environment, e.g. DEV vs PROD.

<img src="./images/ado-service-connections-environments.svg">


-----



## Multi-tier Governance 

When developing a governance model for your organization, it is important to remember that Azure Resource Management (ARM) is only _one_ way to manage resources. When introducing automation via CI/CD pipelines, the Role Based Access Control (RBAC) model must be applied at multiple layers, including:

![End to End Governance](./images/e2e-governance-scm-to-arm.svg)

| Tier | Responsibility | Description |
|:--|:--|:--|
| **Pull Requests** | User | Engineers should peer review their work especially the Pipeline code. |
| **Branch Protection** | [Shared](https://docs.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility) | Configure [Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops) or [GitHub](https://docs.github.com/en/free-pro-team@latest/github/administering-a-repository/about-protected-branches) to reject changes that do not meet certain standards, e.g. CI checks and peer reviews (via pull requests). |
| **Pipeline as Code** | User | A build server will happily delete your production environment the pipeline code instructs it to. Prevent this using a combination of pull requests and branch protection rules. |
| **[Service Connections](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml)** | [Shared](https://docs.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility) | Configure Azure DevOps to restrict access to these credentials. |
| **Azure Resources** | [Shared](https://docs.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility) | Configure RBAC in the Azure Resource Manager. |