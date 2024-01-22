# promote-sfdx-package.yml

**Source:** [promote-sfdx-package.yml](../.github/workflows/install-sfdx-package.yml)

## Usage

```yaml
jobs:
  build:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/promote-sfdx-package.yml@main
    with:
      source-directory: ${{ inputs.source-directory }}
      version-number: ${{ inputs.version-number }}
      instance-url: https://test.salesforce.com
      client-id: 3MV.....................
      username: admin@my.org
      jwt-key-encrypted: |
        $ANSIBLE_VAULT;1.1;AES256
        32626165343364.............................
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

## Inputs and secrets

| Name                         | Input / secret | Type     | Description                                                                                                                                                                                                                                                                                                                                        | Default                                                                               |
|------------------------------|----------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| `package`                    | Input          | `string` | Id of the package version to install. Must start with 04t. Either this or `version-number` must be specified.                                                                                                                                                                                                                                      |                                                                                       |
| `version-number`             | Input          | `string` | Version number of the package version to install, specified as major.minor.patch, without the build number, e.g. 1.0.1. Either this or `package` must be specified. The build number will be determined by finding a released package with the given major, minor, and patch versions. `version-number` is ignored if `package` is also specified. |                                                                                       |
| `source-directory`           | Input          | `string` | Directory containing the main source of the project. Usually force-app, but can be something else. This is used to determine which entry in packageDirectories in sfdx-project.json is the main one. Defaults to force-app.                                                                                                                        | force-app                                                                             |
| `installation-key-encrypted` | Input          | `string` | Ansible Vault-encrypted installation key required to install the package version (this should be encrypted using ansible-vault encrypt, NOT ansible-vault encrypt_string!)                                                                                                                                                                         |                                                                                       |
| `instance-url`               | Input          | `string`  | Salesforce instance URL to log in to as Dev Hub org                                                                                                                                                                         | https://wtax.my.salesforce.com                                                        |
| `client-id`                  | Input          | `string`  | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the Dev Hub org                                                                                                       | 3H7cm0QedwevwtVKpSJ4PXeI7kvPanBgB3qK0sBU06E5MSMka3xqeg9JETRkx8Z8PQxuZkUvlMJH10MQ8A9uw |
| `jwt-key-encrypted`          | Input          | `string`  | Path to an Ansible Vault-encrypted file containing the private key to connect to the Dev Hub org with using the JWT flow                                                                                                    | <<key for the connected app identified by client-id>>                                 |
| `username`                   | Input          | `string`  | Username of Salesforce user to authenticate as; must have permission to create scratch orgs                                                                                                                                 | admin@wtax.prod                                                                       |
| `ansible-vault-password`     | Secret         | `string` | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                                                                                                                                            |                                                                                       |

## Jobs

This workflow has one job:
- **promote** - promotes a package version to released state
