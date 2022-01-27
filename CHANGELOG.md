# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [0.4.0](https://github.com/Azure/devops-governance/compare/v0.3.0...v0.4.0) (2022-01-27)


### Features

* **aad:** add owners to application objects [#49](https://github.com/Azure/devops-governance/issues/49) ([712e236](https://github.com/Azure/devops-governance/commit/712e2362d91a84794c2b3c8ceb18a6e7652a0af7))
* **azuread-provider:** upgrade to v2 [#49](https://github.com/Azure/devops-governance/issues/49) ([fd7a1e6](https://github.com/Azure/devops-governance/commit/fd7a1e6152532e50512e2b731b3833901355bc71))
* **ci-cd:** enable automation for multiple environments ([#27](https://github.com/Azure/devops-governance/issues/27)) ([54fb1ce](https://github.com/Azure/devops-governance/commit/54fb1cefebf8b0a01f345f0fad3c7c378af8932c))
* **devops:** mask tenant and user principal ids ([c8b43c9](https://github.com/Azure/devops-governance/commit/c8b43c954782e788b41d0cebbb81630a4b713c96))
* **pipelines:** more debugging output, update docs ([#42](https://github.com/Azure/devops-governance/issues/42)) ([c02d2d0](https://github.com/Azure/devops-governance/commit/c02d2d09097fcb2cb1357d085f2c157143574309))
* **terraform:** enable local deployment, closes [#35](https://github.com/Azure/devops-governance/issues/35) ([#44](https://github.com/Azure/devops-governance/issues/44)) ([7322197](https://github.com/Azure/devops-governance/commit/7322197f56a1589409c0b67ad5cedc95369b91d7))


### Bug Fixes

* **pipeline:** load kv based on branch in scheduled drift detection ([#31](https://github.com/Azure/devops-governance/issues/31)) ([65f7bb4](https://github.com/Azure/devops-governance/commit/65f7bb449547b226f79f0483669976c6d28d33d7))
* **pipeline:** scheduled drift detection ([#28](https://github.com/Azure/devops-governance/issues/28)) ([3e4906b](https://github.com/Azure/devops-governance/commit/3e4906bcb5ef8f6d7342aca983429fb9815e000a))
* **pipeline-debug:** backticks in bash is command substitution ([#32](https://github.com/Azure/devops-governance/issues/32)) ([f5c5002](https://github.com/Azure/devops-governance/commit/f5c50025abb5326e52c2f9fa15c1428fc0b6f697))
* **pipelines:** readonly property does not exist for var groups ([#43](https://github.com/Azure/devops-governance/issues/43)) ([1582aff](https://github.com/Azure/devops-governance/commit/1582aff254a30c5349b0a2c40ec3f23fed037213))
* **pipelines:** remove broken bash step, clean up vars ([#39](https://github.com/Azure/devops-governance/issues/39)) ([7ba5c65](https://github.com/Azure/devops-governance/commit/7ba5c659eed6b542b886d88509a0e4d58df5d34a))
* **pipelines:** var group conditioal must use compile time syntax ([#40](https://github.com/Azure/devops-governance/issues/40)) ([8045ea4](https://github.com/Azure/devops-governance/commit/8045ea4f2ae54a71bb74adf2d64790eec0567324))

## [0.3.0](https://github.com/Azure/devops-governance/compare/v0.2.0...v0.3.0) (2021-06-14)


### Features

* **concept:** remove drafts, link to now published official AAC and CAF docs, closes [#24](https://github.com/Azure/devops-governance/issues/24) ([d2f14b2](https://github.com/Azure/devops-governance/commit/d2f14b2882c2cb1deeefd22d642a1f2ebd25c2a6))
* **docs-terraform:** update for clarity ([16cd300](https://github.com/Azure/devops-governance/commit/16cd3009649c23a048d43516ce7155376961560d))
* **naming:** clean up variable name and output schema, improve conventions ([fcff295](https://github.com/Azure/devops-governance/commit/fcff295a57bbe9a17f4b116771eeaa2be2311a3c))
* **terraform:** default to local backend for lower barrier to entry ([2a2ab95](https://github.com/Azure/devops-governance/commit/2a2ab950941dabdca29c9909d7fd6092e64d46e3))
* **terraform:** simplify for single plan and deploy, use Key Vault RBAC instead of access policies [#22](https://github.com/Azure/devops-governance/issues/22) ([c2d3d95](https://github.com/Azure/devops-governance/commit/c2d3d9570e7aa7d2d7cc37fa0ba412a33709d050))


### Bug Fixes

* ado permissions errors by specifying dependency, closes [#24](https://github.com/Azure/devops-governance/issues/24) ([f4c68eb](https://github.com/Azure/devops-governance/commit/f4c68ebee224481fbb120d8e7cdf2a3d491aeaf5))

## [0.2.0](https://github.com/Azure/devops-governance/compare/v0.1.0...v0.2.0) (2021-03-19)

### Updates and Fixes

* **concept:** update and newer end-to-end overview graphic ([ee1167a](https://github.com/Azure/devops-governance/commit/ee1167ad31dd920acbbf57c8ff6a1af14a6fc34d))
* **permissions:** use admin aad group for project admins ([#7](https://github.com/Azure/devops-governance/issues/7)) ([c0bece4](https://github.com/Azure/devops-governance/commit/c0bece4eda56d7f353a78da05bee5c13244f1a94))
* **roles:** introduce 3rd AAD group for total devs, admins, and all, [#12](https://github.com/Azure/devops-governance/issues/12) ([02524a6](https://github.com/Azure/devops-governance/commit/02524a6399c4e444b519aa1ab8b72e55c5081d0c))

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
