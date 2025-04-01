# prepare-sfdx-scratch-org-pool.yml

**Source:** [prepare-sfdx-scratch-org-pool.yml](../.github/workflows/prepare-sfdx-scratch-org-pool.yml)

## Usage

```yaml
jobs:
  deploy:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/prepare-sfdx-scratch-org-pool.yml@testing
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

## Inputs and secrets

| Name                     | Input / secret | Type     | Description                                                                                                                                                                         | Default                                                                               |
|--------------------------|----------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| `instance-url`            | Input          | `string` | Salesforce instance URL to deploy to ("the target org")                                                                                                                            | https://login.salesforce.com                                                          |
| `sfdx-auth-url-encrypted` | Input          | `string` | Ansible Vault encrypted SFDX auth url                                                                                                                                              | (auth url for admin@wtax.prod)                                                                        |
| `ansible-vault-password` | Secret         | `string` | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                             |                                                                                       |

## Jobs

This workflow has one job:
- **prepare** - prepares a scratch org pool.

## Notes

This workflow [supports `packageInstallationKeys` in `sfdx-project.json`](packageInstallationKeys.md).