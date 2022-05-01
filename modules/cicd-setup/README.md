# Initial Setup for CI/CD

Many Azure Active Directory Objects including service principals require owners. To prevent errors in running future Infrastructure as Code and Azure Portal use, this script will bootstrap this initial group for you.

❗️ This is not part of the main project. Thus you must manually navigate `cd` into this directory and run. Save the `aad_superowners_group_id` output for [deploying the main project demo](https://github.com/Azure/devops-governance/blob/main/DEPLOY.md).

### Security Concerns

- Do NOT use a production subcription because this code automates Azure AD objects, which are security concerns if not managed properly.
- Be aware that "Owner" assignments are a security risk. This demo uses owner because custom roles requires an [Azure AD Premium P1 or P2 license](https://docs.microsoft.com/en-us/azure/active-directory/roles/custom-create). 
- For production scenarios, please read this project's accompanying Azure Architecture Center article about [best practices for custom "headless owner" roles](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/governance/end-to-end-governance-in-azure#3-create-a-custom-role-for-the-service-principal-used-to-access-production).

### Confirm you have required Azure AD Permissions

Most code in this project will fail without proper permissions. Per [AAD Provider for Terraform Docs](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal#api-permissions)…
  - A **Service Principal** needs one of the following *application roles* 
    - `Application.ReadWrite.All` 
    - or `Directory.ReadWrite.All`
  - A **User Principal** needs one of the following *directory roles*
    - `Application Administrator` 
    - or `Global Administrator`

### Resources created

When this Infrastructure as Code is deployed successfully…


…the following resources will be created:

- **Service Principal** named `governance-demo-github-cicd`
- **Role Assignment** of `Owner` role to service principal at current subscription scope
- New **Azure AD group** named `governance-demo-subscription-owners` with memberships
  - the current logged-in user
  - service principal created above

#### Example Terraform Output

```
aad_superowners_group_id = "73c74b2f-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
headless_owner_sp = {
  "application_id" = "89b93e8b-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  "display_name" = "governance-demo-github-cicd"
  "object_id" = "2c05b567-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

👉 Note the **aad_superowners_group_id** value `73c74b2f-xxxx-xxxx-xxxx-xxxxxxxxxxxx` which you need for this project.

## References


- Terraform Docs - [Azure AD Service Principal - Required API Permissions](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal#api-permissions)