# create-sfdx-package.yml

**Source:** [create-sfdx-package.yml](../.github/workflows/create-sfdx-package.yml)

## Usage

```yaml
jobs:
  build:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/create-sfdx-package.yml@main
    with:
      source-directory: ${{ inputs.source-directory }}
      promote: ${{ inputs.promote }}
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

## Inputs and secrets

| Name                         | Input / secret | Type      | Description                                                                                                                                                                                                                         | Default                                                                               |
|------------------------------|----------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| `source-directory`           | Input          | `string`  | Directory containing the main source of the project. Usually force-app, but can be something else. This is used to determine which entry in packageDirectories in sfdx-project.json is the main one. Defaults to force-app.         | force-app                                                                             |
| `sonar-url`                  | Input          | `string`  | URL of the Sonar server to use for analyzing the code. If omitted, the WTax Sonar server at sonar.wtax.co will be used. The `sonar-login` secret should hold a valid access token or username:password combination for this server. | https://sonar.wtax.co                                                                 |
| `sonar-login`                | Secret         | `string`  | Access token or username:password combination for the Sonar server specified in the `sonar-url` input. If not specified, Sonar analysis will not run.                                                                               |
| `installation-key-encrypted` | Input          | `string`  | Ansible Vault-encrypted installation key to protect the package version with (this should be encrypted using ansible-vault encrypt, NOT ansible-vault encrypt_string!)                                                              | \<\<the WTax default package installation key>>                                       |
| `promote`                    | Input          | `boolean` | Whether to promote the package version to released after creating it.                                                                                                                                                               |                                                                                       |
| `instance-url`               | Input          | `string`  | Salesforce instance URL to log in to as Dev Hub org                                                                                                                                                                                 | https://wtax.my.salesforce.com                                                        |
| `client-id`                  | Input          | `string`  | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the Dev Hub org                                                                                                               | 3H7cm0QedwevwtVKpSJ4PXeI7kvPanBgB3qK0sBU06E5MSMka3xqeg9JETRkx8Z8PQxuZkUvlMJH10MQ8A9uw |
| `jwt-key-encrypted`          | Input          | `string`  | Path to an Ansible Vault-encrypted file containing the private key to connect to the Dev Hub org with using the JWT flow                                                                                                            | \<\<key for the connected app identified by client-id>>                               |
| `username`                   | Input          | `string`  | Username of Salesforce user to authenticate as; must have permission to create scratch orgs                                                                                                                                         | admin@wtax.prod                                                                       |
| `ansible-vault-password`     | Secret         | `string`  | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                             |                                                                                       |

## Outputs

| Name                     | Type     | Description                                                                    |
|--------------------------|----------|--------------------------------------------------------------------------------|
| `package`                | `string` | The name of the package within which the new package version was created       |
| `package-version-id`     | `string` | The Salesforce id (“subscriber package version ID”) of the new package version |
| `package-version-number` | `string` | The semantic version number major.minor.patch.build of the new package version |

## Jobs

This workflow has one job:
- **package** - creates an SFDX package from the source code in `source-directory`

## Notes

This workflow [supports `packageInstallationKeys` in `sfdx-project.json`](packageInstallationKeys.md).