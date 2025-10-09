# deploy-sfdx-project-to-developer.yml

**Source:** [deploy-sfdx-project-to-developer.yml](../.github/workflows/deploy-sfdx-project-to-developer.yml)

## Usage

```yaml
jobs:
  deploy:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/deploy-sfdx-project-to-developer.yml@testing
    with:
      run-tests: ${{ inputs.run-tests == null || inputs.run-tests }}
      environment: developer
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

## Inputs and secrets

| Name                                   | Input / secret | Type      | Description                                                                                                                                                                                                                         | Default                                                                               |
|----------------------------------------|----------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| `sonar-url`                            | Input          | `string`  | URL of the Sonar server to use for analyzing the code. If omitted, the WTax Sonar server at sonar.wtax.co will be used. The `sonar-login` secret should hold a valid access token or username:password combination for this server. | https://sonar.wtax.co                                                                 |
| `sonar-login`                          | Secret         | `string`  | Access token or username:password combination for the Sonar server specified in the `sonar-url` input.                                                                                                                              |                                                                                       |
| `instance-url`                         | Input          | `string`  | Salesforce instance URL to deploy to ("the target org")                                                                                                                                                                             | https://login.salesforce.com                                                          |
| `client-id`                            | Input          | `string`  | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the target org                                                                                                                | 3MVG9mVMtbWMH6luwQZnh1UwupxQxoca6H4Yu0gvsxQS7_yo6HdV00CFOw60m0aJFr6FvvHx9CwsTjg5Ybi_T |
| `jwt-key-encrypted`                    | Input          | `string`  | Ansible Vault-encrypted private key to connect to the Dev Hub org with using the JWT flow (this should be encrypted using ansible-vault encrypt, NOT ansible-vault encrypt_string!)                                                 | <<key for the connected app identified by client-id>>                                 |
| `username`                             | Input          | `string`  | Username of Salesforce user to authenticate as; must have permission to depoy metadata                                                                                                                                              | admin@wtax.prod.developer                                                             |
| `run-tests`                            | Input          | `boolean` | Whether to run tests as part of the deployment. This is required when deploying to a production org.                                                                                                                                | true                                                                                  |
| `destructive-changes-after-deployment` | Input          | `boolean` | Instruct Salesforce to apply destructive changes (i.e. deletes) after the deployment. This is the default. In some cases you may want to apply destructive changes before deploying. In that case, set this input to false.         | true                                                                                  |
| `environment`                          | Input          | `string`  | The name of a GitHub deployment environment in the repository that determines which deployment protection rules, such as reviews, will apply to this deployment.                                                                    |                                                                                       |
| `metadata-artifact`                    | Input          | `string`  | The name of a previously uploaded artifact containing the metadata to deploy. If omitted, the workflow generates one automatically. If set, `deletes-artifact` and `test-classes-artifact` must also be specified.                                                                      |
| `test-classes-artifact`                | Input          | `string`  | The name of a previously uploaded artifact containing a test-classes.txt file with the names of Apex test classes in the metadata, one class per line. If omitted, the workflow generates one automatically. If set, `metadata-artifact` and `deletes-artifact` must also be specified. |
| `deletes-artifact`                     | Input          | `string`  | The name of a previously uploaded artifact containing a deletes.csv file with metadata to delete. If omitted, the workflow generates one automatically. If set, `metadata-artifact` and `test-classes-artifact` must also be specified.                                                 |
| `ansible-vault-password`               | Secret         | `string`  | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                             |                                                                                       |

## Jobs

This workflow has on jobs:
- **deploy** - calls the `deploy-sfdx-project.yml` workflow with sensible defaults for the inputs to deploy to the `developer` sandbox

