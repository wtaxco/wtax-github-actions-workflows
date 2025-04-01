# deploy-sfdx-project.yml

**Source:** [deploy-sfdx-project.yml](../.github/workflows/deploy-sfdx-project.yml)

## Usage

```yaml
jobs:
  deploy:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/deploy-sfdx-project.yml@testing
    with:
      instance-url: https://login.salesforce.com
      client-id: 3H7cm0QedwevwtVKpSJ4PXeI7kvPanBgB3qK0sBU06E5MSMka3xqeg9JETRkx8Z8PQxuZkUvlMJH10MQ8A9uw
      jwt-key-encrypted: |
          $ANSIBLE_VAULT;1.1;AES256
          66626465343266336363626261646563303431326135373036343333386238323761373165346138
          3164353437346165666439306165663635373364366233630a313361333534363735356665383262
          63376636336462613066636.......
      username: admin@wtax.prod
      run-tests: true
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

## Inputs and secrets

| Name                                   | Input / secret | Type      | Description                                                                                                                                                                                                                 | Default |
|----------------------------------------|----------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|
| `sonar-url`                            | Input          | `string`  | URL of the Sonar server to use for analyzing the code. If omitted, no Sonar analysis is run.                                                                                                                                |         |
| `sonar-login`                          | Secret         | `string`  | Access token or username:password combination for the Sonar server specified in the `sonar-url` input.                                                                                                                      |         |
| `instance-url`                         | Input          | `string`  | Salesforce instance URL to deploy to ("the target org")                                                                                                                                                                     |         |
| `client-id`                            | Input          | `string`  | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the target org                                                                                                        |         |
| `jwt-key-encrypted`                    | Input          | `string`  | Ansible Vault-encrypted private key to connect to the target org with using the JWT flow (this should be encrypted using ansible-vault encrypt, NOT ansible-vault encrypt_string!)                                          |         |
| `username`                             | Input          | `string`  | Username of Salesforce user to authenticate as; must have permission to depoy metadata                                                                                                                                      |         |
| `run-tests`                            | Input          | `boolean` | Whether to run tests as part of the deployment. This is required when deploying to a production org.                                                                                                                        |         |
| `destructive-changes-after-deployment` | Input          | `boolean` | Instruct Salesforce to apply destructive changes (i.e. deletes) after the deployment. This is the default. In some cases you may want to apply destructive changes before deploying. In that case, set this input to false. | true    |
| `ansible-vault-password`               | Secret         | `string`  | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                     |         |

## Jobs

This workflow has two jobs:
- **build** - converts source to metadata and packages in a ZIP file that is then archived
- **deploy** - downloads an archived metadata ZIP file, connects to a Salesforce org, and deploys the metadata to the org

