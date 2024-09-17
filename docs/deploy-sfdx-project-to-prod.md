# deploy-sfdx-project-to-prod.yml

**Source:** [deploy-sfdx-project-to-prod.yml](../.github/workflows/deploy-sfdx-project-to-prod.yml)

## Usage

```yaml
jobs:
  deploy:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/deploy-sfdx-project-to-prod.yml@main
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

#### Inputs and secrets

| Name                                   | Input / secret | Type      | Description                                                                                                                                                                                                                 | Default                                                                               |
|----------------------------------------|----------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| `instance-url`                         | Input          | `string`  | Salesforce instance URL to deploy to ("the target org")                                                                                                                                                                     | https://login.salesforce.com                                                          |
| `client-id`                            | Input          | `string`  | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the target org                                                                                                        | 3H7cm0QedwevwtVKpSJ4PXeI7kvPanBgB3qK0sBU06E5MSMka3xqeg9JETRkx8Z8PQxuZkUvlMJH10MQ8A9uw |
| `jwt-key-encrypted`                    | Input          | `string`  | Ansible Vault-encrypted private key to connect to the Dev Hub org with using the JWT flow (this should be encrypted using ansible-vault encrypt, NOT ansible-vault encrypt_string!)                                         | <<key for the connected app identified by client-id>>                                 |
| `username`                             | Input          | `string`  | Username of Salesforce user to authenticate as; must have permission to depoy metadata                                                                                                                                      | admin@wtax.prod                                                                       |
| `destructive-changes-after-deployment` | Input          | `boolean` | Instruct Salesforce to apply destructive changes (i.e. deletes) after the deployment. This is the default. In some cases you may want to apply destructive changes before deploying. In that case, set this input to false. | true                                                                                  |
| `ansible-vault-password`               | Secret         | `string`  | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                     |                                                                                       |

#### Jobs

This workflow has one job:
- **deploy** - calls the `deploy-sfdx-project.yml` workflow with sensible defaults for the inputs to deploy to the production org
