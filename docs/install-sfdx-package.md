# install-sfdx-package.yml

**Source:** [install-sfdx-package.yml](../.github/workflows/install-sfdx-package.yml)

## Usage

```yaml
jobs:
  build:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/install-sfdx-package.yml@testing
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
| `instance-url`               | Input          | `string` | Salesforce instance URL of the target org                                                                                                                                                                                                                                                                                                          |                                                                                       |
| `client-id`                  | Input          | `string` | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the target org                                                                                                                                                                                                                               |                                                                                       |
| `username`                   | Input          | `string` | Username of Salesforce user to authenticate as on the target org. Must have permission to install packages.                                                                                                                                                                                                                                        |                                                                                       |
| `jwt-key-encrypted`          | Input          | `string` | Ansible Vault-encrypted private key to connect to the target org with using the JWT flow (this should be encrypted using ansible-vault encrypt, NOT ansible-vault encrypt_string!)                                                                                                                                                                 |                                                                                       |
| `devhub-instance-url`        | Input          | `string` | Salesforce instance URL to log in to as Dev Hub org                                                                                                                                                                                                                                                                                                | https://wtax.my.salesforce.com                                                        |
| `devhub-client-id`           | Input          | `string` | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the Dev Hub org                                                                                                                                                                                                                              | 3H7cm0QedwevwtVKpSJ4PXeI7kvPanBgB3qK0sBU06E5MSMka3xqeg9JETRkx8Z8PQxuZkUvlMJH10MQ8A9uw |
| `devhub-username`            | Input          | `string` | Username of Salesforce user to authenticate as; must have permission to create scratch orgs                                                                                                                                                                                                                                                        | admin@wtax.prod                                                                       |
| `devhub-jwt-key-encrypted`   | Input          | `string` | Path to an Ansible Vault-encrypted file containing the private key to connect to the Dev Hub org with using the JWT flow                                                                                                                                                                                                                           | <<key for the connected app identified by client-id>>                                 |
| `environment`                | Input          | `string` | The name of a GitHub deployment environment in the repository that determines which deployment protection rules, such as reviews, will apply to this deployment.                                                                                                                                                                                   |                                                                                       |
| `ansible-vault-password`     | Secret         | `string` | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                                                                                                                                            |                                                                                       |

## Jobs

This workflow has one job:
- **install-package** - installs an SFDX package on a target org using information from the source project to determine the package id

### install-package

1. Does a sparse checkout of the project, only checking out the `sfdx-project.json` file and the `deploy` directory
   (if it exists).
2. Connects to the DevHub org (using the `devhub-instance-url`, `devhub-username`, `devhub-client-id`, and 
   `devhub-jwt-key-encrypted` inputs), and to the target org (using the `instance-url`, `username`, `client-id`, and
   `jwt-key-encrypted` inputs) using JWT authentication.
3. Finds the package version on the DevHub org using either the `package` input as a package version id, if specified,
   or, otherwise, using the package id from the project's `sfdx-project.json` and the package version number from the 
   `version-number` input. This workflow will only ever install released (also called promoted) package versions, and
   since only one package build can be promoted for the same (major, minor, patch) triplet, the build number must be
   omitted from the `version-number` input, e.g. `1.0.1`. So the version number is incomplete, and the workflow will
   find the build number of the released package version with the given major, minor, and patch numbers to construct a
   complete `major.minor.patch.build` version number, e.g. `1.0.1.2`.
4. Installs the package version onto the target org, compiling only Apex classes and triggers in the package (as
   opposed to _all_ Apex on the target org).
5. Runs any post-install scripts present in the `deploy/hooks/post-deploy` directory, in alphabetical order. The 
   script files must have a `.sh` extension and will always be run through Bash regardless of what shebang line, 
   if any, is present at the start of the file. The scripts run in the same environment as the workflow, so they
   can call the Salesforce CLI using either the `dev-hub` org alias to refer to the DevHub org, or the `target-org`
   org alias to refer to the target org on which the package version was installed. 
   **NB:  These scripts run with the permissions of the user specified using the `username` (or `devhub-username` 
   for the DevHub org) input. This user will likely have administrative permissions, since these are required to install 
   a package. So these scripts should be peer-reviewed carefully before allowing this workflow to run them.**