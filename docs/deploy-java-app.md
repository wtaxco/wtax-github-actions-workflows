# deploy-java-app.yml

**Source:** [deploy-java-app.yml](../.github/workflows/deploy-java-app.yml)

## Usage

```yaml
jobs:
  release:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/deploy-java-app.yml@testing
    with:
      boot-jar: nexus-releases
      known_hosts: "app01.wtax.co,108.128.232.168 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPY2ffHZudZ/Hi0oXvEGxULMJ3UjukNvPOg2Q1KgG5IE4iOlGCAbx+h0PTNmmTSsoiK7q9O+x61FSHyvzUY/NyA="
      ansible-playbook: deploy.yml
      ansible-inventory: inventory/prod.yml
      environment: dev
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
      ssh-private-key: ${{ secrets.PROD_SSH_PRIVATE_KEY }}
```

## Inputs and secrets

| Name                     | Input / secret | Type     | Description                                                                                                                                                                                                                                           | Default    |
|--------------------------|----------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------|
| `boot-jar`               | Input          | `string` | The path to the executable JAR to deploy, e.g. wtax-my-service-1.0.0-SNAPSHOT.jar. This must be an artifact that was archived in a previous job in this workflow. The JAR path will be passed to the Ansible playbook via `-e boot_jar=<<boot-jar>>`. |            |
| `known_hosts`            | Input          | `string` | The line or lines to be added to the `.ssh/known_hosts` file on the runner machine so that the public key of the remote host can be verified when connecting to detect possible man-in-the-middle attacks.                                            |            |
| `ansible-playbook`       | Input          | `string` | The Ansible playbook to run, relative to the deploy directory. This playbook should take a variable `boot_jar` defining the executable JAR to deploy. Defaults to deploy.yml.                                                                         | deploy.yml |
| `ansible-inventory`      | Input          | `string` | The Ansible inventory to run the playbook against, relative to the deploy directory.                                                                                                                                                                  |            |
| `environment`            | Input          | `string` | The name of a GitHub deployment environment in the repository that determines which deployment protection rules, such as reviews, will apply to this deployment.                                                                                      |            |
| `ansible-vault-password` | Secret         | `string` | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                                               |            |
| `ssh-private-key`        | Secret         | `string` | SSH private key to be used to connect to remote hosts to deploy the application there. The corresponding public key must have been added to the remote host's `authorized_keys` file.                                                                 |            |

## Jobs

This workflow has one jobs:
- **deploy** - runs the Ansible playbook to deploy the Java app to the application server(s) in the inventory

