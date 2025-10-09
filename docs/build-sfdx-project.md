# build-sfdx-project.yml

**Source:** [build-sfdx-project.yml](../.github/workflows/build-sfdx-project.yml)

## Usage

```yaml
jobs:
  build:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/build-sfdx-project.yml@testing
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

## Inputs and secrets

| Name                           | Input / secret | Type      | Description                                                                                                                                                                                                                                                                                                                                | Default                                                                               |
|--------------------------------|----------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| `scratch-org-pool-name`        | Input          | `string`  | When specified, uses a scratch org from the specified scratch org to do the build on. If ommitted, creates a scratch org on-demand. Using this can speed up the build significantly as the time to create a scratch org and install packages on it is saved. Irrelevant if `run-compile-and-test` is `false`                               |                                                                                       |
| `source-directory`             | Input          | `string`  | Directory containing the main source of the project. Usually force-app, but can be something else. This is used to determine which entry in packageDirectories in sfdx-project.json is the main one. Defaults to force-app.                                                                                                                | force-app                                                                             |
| `run-tests`                    | Input          | `string`  | Whether to run the unit tests in source-directory when deploying the code in source-directory. Set to anything other than "yes" to not run tests. Irrelevant if `run-compile-and-test` is `false`.                                                                                                                                         |                                                                                       |
| `instance-url`                 | Input          | `string`  | Salesforce instance URL to log in to as Dev Hub org                                                                                                                                                                                                                                                                                        | https://wtax.my.salesforce.com                                                        |
| `client-id`                    | Input          | `string`  | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the Dev Hub org                                                                                                                                                                                                                      | 3H7cm0QedwevwtVKpSJ4PXeI7kvPanBgB3qK0sBU06E5MSMka3xqeg9JETRkx8Z8PQxuZkUvlMJH10MQ8A9uw |
| `jwt-key-encrypted`            | Input          | `string`  | Path to an Ansible Vault-encrypted file containing the private key to connect to the Dev Hub org with using the JWT flow                                                                                                                                                                                                                   | <<key for the connected app identified by client-id>>                                 |
| `username`                     | Input          | `string`  | Username of Salesforce user to authenticate as; must have permission to create scratch orgs                                                                                                                                                                                                                                                | admin@wtax.prod                                                                       |
| `delete-scratch-org-after-run` | Input          | `boolean` | Whether to delete the scratch org that the workflow creates after the workflow has ran. Highly recommended to set to true to avoid running into the active scratch org limit. Set to false if you need to inspect the scratch org after the workflow runs (but remember to delete manually in that case).                                  |                                                                                       |
| `run-compile-and-test`         | Input          | `boolean` | Whether to deploy the project to a scratch org and (if `run-tests` is `true`) run unit tests. If false, the only thing this workflow does is produce a ZIP file with the project sources converted to metadata format, a text file with the unit test classes found in the project, and a CSV file with the metadata flagged for deletion. |                                                                                       |
| `ansible-vault-password`       | Secret         | `string`  | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                                                                                                                                    |                                                                                       |

## Outputs

| Name                    | Type     | Description                                                                                                                                                     |
|-------------------------|----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `metadata-artifact`     | `string` | The name of the artifact uploaded by the workflow containing the Salesforce metadata                                                                            |
| `test-classes-artifact` | `string` | The name of the artifact uploaded by the workflow containing a single file `test-classes.txt` with the names of Apex classes in the project, one class per line |
| `deletes-artifact`      | `string` | The name of the artifact uploaded by the workflow containing a single file `deletes.csv` with the details of metadata components marked for deletion            |


## Jobs

This workflow has one jobs:
- **build** - Builds a metadata bundle from a Salesforce DX project, optionally deploying it to a scratch org and running tests

## Notes

This workflow [supports `packageInstallationKeys` in `sfdx-project.json`](packageInstallationKeys.md).