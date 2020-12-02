# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## 0.1.0 (2020-12-02)


### Initial Release

#### Governance Model

- **Azure AD (AAD)**
  - create demo AAD groups used for RBAC across ARM and Azure DevOps
- **Azure Resource Manager (ARM)**
  - Deploys different deployment environments to different Resource Groups (for convenience. See [README.md](./README.md) for details.)
- **Azure DevOps (AzDO)** 
  - Bootstrap organization with projects
  - Setup Service Connections
  - Apply RBAC

#### Sample Project Features

- Includes Azure Pipelines
  - Terraform code quality checks
  - automated and scheduled configuration drift detection - results are posted to GitHub Pull Requests.
  - automated deployments
- Documentation with detailed explanations: 
  - [CONCEPT.md](./CONCEPT.md)
  - [TERRAFORM.md](./TERRAFORM.md)
  - [azure-pipelines/README.md](./azure-pipelines/README.md)

#### Linked Git Commits

Note: initial release did not follow strictly to [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) standard. Those that did are left here for reference.

* **aad-groups:** for demo org team structure ([314f52c](https://github.com/Azure-Samples/devops-governance/commit/314f52cea2d6f6a1b8cafbb87f981bc561e26ede))
* **azure-devops:** create projects and respective service connections to ARM resources ([7c1f8d9](https://github.com/Azure-Samples/devops-governance/commit/7c1f8d943e76392d700d059758d2f464479545cb))
* **rbac:** key vault data plane access example ([455a5df](https://github.com/Azure-Samples/devops-governance/commit/455a5dfaa7473dfdbd06855647c9ff457b534cf1))
* **setup:** setup.azcli for blob account for terraform statefile, [#1](https://github.com/Azure-Samples/devops-governance/issues/1) ([5afe3ee](https://github.com/Azure-Samples/devops-governance/commit/5afe3ee4cd547bb4bdb02202256e46b5d631eed0))
