# deploy-sfdx-project-to-uat.yml

**Source:** [deploy-sfdx-project-to-uat.yml](../.github/workflows/deploy-sfdx-project-to-uat.yml)

## Usage

```yaml
jobs:
  deploy:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/deploy-sfdx-project-to-uat.yml@main
    with:
      run-tests: ${{ inputs.run-tests == null || inputs.run-tests }}
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

## Inputs and secrets

| Name                                   | Input / secret | Type      | Description                                                                                                                                                                                                                 | Default                                                                               |
|----------------------------------------|----------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| `instance-url`                         | Input          | `string`  | Salesforce instance URL to deploy to ("the target org")                                                                                                                                                                     | https://test.salesforce.com                                                           |
| `client-id`                            | Input          | `string`  | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the target org                                                                                                        | 3MVG9hYFI5K4tx6Rji0DdwHNZZW5sYC_Yjf_JZwrEwAbMh0VE3EqlGYkw..nk5TrrCzvIjXCS0a5u08AO5qrt |
| `jwt-key-encrypted`                    | Input          | `string`  | Ansible Vault-encrypted private key to connect to the Dev Hub org with using the JWT flow (this should be encrypted using ansible-vault encrypt, NOT ansible-vault encrypt_string!)                                         | <<key for the connected app identified by client-id>>                                 |
| `username`                             | Input          | `string`  | Username of Salesforce user to authenticate as; must have permission to depoy metadata                                                                                                                                      | admin@wtax.prod.uat                                                                   |
| `run-tests`                            | Input          | `boolean` | Whether to run tests as part of the deployment. This is required when deploying to a production org.                                                                                                                        | true                                                                                  |
| `destructive-changes-after-deployment` | Input          | `boolean` | Instruct Salesforce to apply destructive changes (i.e. deletes) after the deployment. This is the default. In some cases you may want to apply destructive changes before deploying. In that case, set this input to false. | true                                                                                  |
| `ansible-vault-password`               | Secret         | `string`  | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                     |                                                                                       |

## Jobs

This workflow has on jobs:
- **deploy** - calls the `deploy-sfdx-project.yml` workflow with sensible defaults for the inputs to deploy to the `uat` sandbox

