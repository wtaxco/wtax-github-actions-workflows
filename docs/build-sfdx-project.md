# build-sfdx-project.yml

**Source:** [build-sfdx-project.yml](../.github/workflows/build-sfdx-project.yml)

## Usage

```yaml
jobs:
  build:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/build-sfdx-project.yml@main
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

#### Inputs and secrets

| Name                                | Input / secret | Type     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Default                                                                               |
|-------------------------------------|----------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| `instance-url`                      | Input          | `string` | Salesforce instance URL to log in to as Dev Hub org                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | https://wtax.my.salesforce.com                                                        |
| `client-id`                         | Input          | `string` | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the Dev Hub org                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | 3H7cm0QedwevwtVKpSJ4PXeI7kvPanBgB3qK0sBU06E5MSMka3xqeg9JETRkx8Z8PQxuZkUvlMJH10MQ8A9uw |
| `jwt-key-encrypted`                 | Input          | `string` | Path to an Ansible Vault-encrypted file containing the private key to connect to the Dev Hub org with using the JWT flow                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | <<key for the connected app identified by client-id>>                                 |
| `username`                          | Input          | `string` | Username of Salesforce user to authenticate as; must have permission to create scratch orgs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | admin@wtax.prod                                                                       |
| `ansible-vault-password`            | Secret         | `string` | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |                                                                                       |
| `texei-installation-keys-encrypted` | Input          | `string` | Parameter to be passed as the value of the `--installationkeys` option of the `texei:package:dependencies:install` command. It should contain the installation keys of password-protected packages in the order in which they appear in sfdx-project.json, e.g. "1:MyPackage1Key 2: 3:MyPackage3Key". See https://github.com/texei/texei-sfdx-plugin for more information. (This should be encrypted using ansible-vault encrypt, NOT ansible-vault encrypt_string!). DEPRECATED: add installation keys to `sfdx-project.json` instead. If this parameter is provided, packages will be installed using `sf texei package dependencies install`. Otherwise, `sf dependency install` from the sfpowerscripts plugin will be used. |                                                                                       |

#### Jobs

This workflow has one jobs:
- **build** - deploys source from a Salesforce DX project to a scratch org and runs tests

## Notes

This workflow [supports `packageInstallationKeys` in `sfdx-project.json`](packageInstallationKeys.md).