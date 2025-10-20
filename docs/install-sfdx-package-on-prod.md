# install-sfdx-package-on-prod.yml

**Source:** [install-sfdx-package-on-prod.yml](../.github/workflows/install-sfdx-package-on-prod.yml)

## Usage

```yaml
jobs:
  build:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/install-sfdx-package.yml-on-prod@main
    with:
      source-directory: ${{ inputs.source-directory }}
      version-number: ${{ inputs.version-number }}
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

## Inputs and secrets

| Name                     | Input / secret | Type     | Description                                                                                                                                                                                                                                                                                                                                        | Default                                                                                |
|--------------------------|----------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------|
| `package`                | Input          | `string` | Id of the package version to install. Must start with 04t. Either this or `version-number` must be specified.                                                                                                                                                                                                                                      |                                                                                        |
| `version-number`         | Input          | `string` | Version number of the package version to install, specified as major.minor.patch, without the build number, e.g. 1.0.1. Either this or `package` must be specified. The build number will be determined by finding a released package with the given major, minor, and patch versions. `version-number` is ignored if `package` is also specified. |                                                                                        |
| `source-directory`       | Input          | `string` | Directory containing the main source of the project. Usually force-app, but can be something else. This is used to determine which entry in packageDirectories in sfdx-project.json is the main one. Defaults to force-app.                                                                                                                        |                                                                                        |
| `instance-url`           | Input          | `string` | Salesforce instance URL of the target org.                                                                                                                                                                                                                                                                                                         | https://test.salesforce.com                                                            |
| `client-id`              | Input          | `string` | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the target org                                                                                                                                                                                                                               | <<the client ID for the Continuous Integration connected app on the prod org>>         |
| `username`               | Input          | `string` | Username of Salesforce user to authenticate as on the target org. Must have permission to install packages.                                                                                                                                                                                                                                        | admin@wtax.prod                                                                        |
| `jwt-key-encrypted`      | Input          | `string` | Ansible Vault-encrypted private key to connect to the target org with using the JWT flow (this should be encrypted using ansible-vault encrypt, NOT ansible-vault encrypt_string!)                                                                                                                                                                 | <<the encrypted JWT key for the Continuous Integration connected app on the prod org>> |
| `environment`            | Input          | `string` | The name of a GitHub deployment environment in the repository that determines which deployment protection rules, such as reviews, will apply to this deployment.                                                                                                                                                                                   |                                                                                        |
| `ansible-vault-password` | Secret         | `string` | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                                                                                                                                            |                                                                                        |

## Jobs

This workflow has one job:
- **install-package-on-prod** - calls the `install-sfdx-package.yml` workflow with sensible defaults for the inputs to deploy to the production org
