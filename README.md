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
- An Azure DevOps Organization
- Terraform

## Usage

To run the demo, follow these steps:


1.
2.
3.

## Resources

This demo was created with &hearts; by the FastTrack engineer [julie-ng](https://github.com/julie-ng) based on experience onboarding real Azure customers. Learn more about [FastTrack for Azure &rarr;](https://aka.ms/fasttrackforazure)

- Todo: add links to Microsoft Documentation

## Contributing

- Please use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) so we can continue to _automate_ the Change Log. Thank you.

## Code of Conduct

If you want to contribute, please first read the Microsoft [Code of Conduct &rarr;](./.github/CODE_OF_CONDUCT.md)