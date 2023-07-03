# WTax GitHub Actions Workflows

This repository contains [reusable workflows for GitHub Actions](https://docs.github.com/en/actions/using-workflows/reusing-workflows).
As GitHub only allows reusable workflows to be in public repositories, this repository is public. Therefore, make sure 
not to commit any sensitive information to this repository: all sensitive information (i.e. passwords, keys, etc.) are 
to be passed in as secrets to the reusable workflow.

## Workflows

| Name                                                                   | Description                                                                 |
|------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| [`build-maven-project.yml`](.github/workflows/build-maven-project.yml) | Builds a Maven project, runs Sonar, and archives the build artifacts        |
| [`maven-release.yml`](.github/workflows/maven-release.yml)             | Releases a Maven project to a Maven repository                              |
| [`deploy-java-app.yml`](.github/workflows/deploy-java-app.yml)         | Deploys an executable JAR to an application server                          |
| [`build-sfdx-project.yml`](.github/workflows/build-sfdx-project.yml)   | Deploys source from a Salesforce DX project to a scratch org and runs tests |
| [`deploy-sfdx-project.yml`](.github/workflows/deploy-sfdx-project.yml) | Deploys an SFDX project's metadata to an org                                |


## Usage

### [`build-maven-project.yml`](.github/workflows/build-maven-project.yml)

```yaml
jobs:
  build-maven-project:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/build-maven-project.yml@1.0
    with:
      sonar-url: https://sonar.wtax.co
      maven-repository-url: https://nexus.wtax.co/repository/maven-public/
      maven-repository-username: github
      jdk-version: 17
    secrets:
      maven-repository-password: ${{ secrets.NEXUS_PASSWORD }}
      sonar-login: ${{ secrets.SONAR_TOKEN }}
```

#### Inputs and secrets

| Name                        | Input / secret | Type     | Description                                                                                                                                                                                                                                                                                                                                   | Default                                        |
|-----------------------------|----------------|----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|
| `sonar-url`                 | Input          | `string` | URL of the Sonar server to use for analyzing the code. If omitted, the WTax Sonar server at sonar.wtax.co will be used. The `sonar-login` secret should hold a valid access token or username:password combination for this server.                                                                                                           | https://sonar.wtax.co                          |
| `sonar-login`               | Secret         | `string` | Access token or username:password combination for the Sonar server specified in the `sonar-url` input.                                                                                                                                                                                                                                        |                                                |
| `maven-repository-url`      | Input          | `string` | URL of a Maven repository to use for retrieving artifacts that are not on Maven Central. If omitted, the maven-public repository on the WTax Nexus server at nexus.wtax.co will be used. The `maven-repository-username` input should hold a valid username for this server and the `maven-repository-password` a valid (encrypted) password. | https://nexus.wtax.co/repository/maven-public/ |
| `maven-repository-username` | Input          | `string` | The username used to authenticate to the Maven repository specified in the `maven-repository-url` input.                                                                                                                                                                                                                                      | github                                         |
| `maven-repository-password` | Secret         | `string` | Password for the Maven repository specified in the `maven-repository-url` corresponding to the `maven-repository-username`.                                                                                                                                                                                                                   |                                                |
| `jdk-version`               | Input          | `string` | Version of the Zulu JDK to use to build the project. If omitted, defaults to 17.                                                                                                                                                                                                                                                              | 17                                             |

#### Jobs

This workflow has one job:
- **build** - builds a Maven project, runs Sonar, and archives the build artifacts


### [`maven-release.yml`](.github/workflows/maven-release.yml)

```yaml
jobs:
  release:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/maven-release.yml@1.0
    with:
      release-version: ${{ inputs.release-version }}
      skip-prepare: ${{ inputs.release-version }}
      maven-repository-url: https://nexus.wtax.co/repository/maven-public/
      maven-releases-repository-id: nexus-releases
      maven-repository-username: github
      jdk-version: 17
    secrets:
      maven-repository-password: ${{ secrets.NEXUS_PASSWORD }}
```

#### Inputs and secrets

| Name                           | Input / secret | Type      | Description                                                                                                                                                                                                                                                                                                                                   | Default                                        |
|--------------------------------|----------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|
| `release-version`              | Input          | `string`  | The version number for the release. This will be used to rewrite the POM file and create the release tag. The `release-version` input must be provided when `skip-prepare` is `true`. Otherwise it can be left blank in which case the release version will be determined from the top-level POM file's current SNAPSHOT version.             |                                                |
| `skip-prepare`                 | Input          | `boolean` | Whether to skip prepare. This assumes a releasable version has already been tagged in version control with `release/v<release-version>` and the `perform_release` job can be run directly. The `release-version` input must be provided when `skip-prepare` is `true`.                                                                        | false                                          |
| `maven-repository-url`         | Input          | `string`  | URL of a Maven repository to use for retrieving artifacts that are not on Maven Central. If omitted, the maven-public repository on the WTax Nexus server at nexus.wtax.co will be used. The `maven-repository-username` input should hold a valid username for this server and the `maven-repository-password` a valid (encrypted) password. | https://nexus.wtax.co/repository/maven-public/ |
| `maven-releases-repository-id` | Input          | `string`  | ID of the Maven repository defined in the project's POM to which the artifact is to be released. This is used to generate the correct server entry holding the username and password for the repository in the Maven `settings.xml`.                                                                                                          | nexus-releases                                 |
| `maven-repository-username`    | Input          | `string`  | The username used to authenticate to the Maven repository specified in the `maven-repository-url` input as well as the Maven repository referenced by `maven-releases-repository-id`.                                                                                                                                                         | github                                         |
| `maven-repository-password`    | Secret         | `string`  | Password for the Maven repository specified in the `maven-repository-url` as well as the Maven repository referenced by `maven-releases-repository-id`, corresponding to the `maven-repository-username`.                                                                                                                                     |                                                |
| `jdk-version`                  | Input          | `string`  | Version of the Zulu JDK to use to build the project. If omitted, defaults to 17.                                                                                                                                                                                                                                                              | 17                                             |

#### Jobs

This workflow has two jobs:
- **prepare_release** - prepares the release, assigning a release version and tagging the project in version control as `release/v<x.y.z>` where `<x.y.z>` is the release version.
- **perform_release** - performs the release of the previously prepared release


### [`deploy-java-app.yml`](.github/workflows/deploy-java-app.yml)

```yaml
jobs:
  release:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/deploy-java-app.yml@1.0
    with:
      boot-jar: nexus-releases
      known_hosts: "app01.wtax.co,108.128.232.168 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPY2ffHZudZ/Hi0oXvEGxULMJ3UjukNvPOg2Q1KgG5IE4iOlGCAbx+h0PTNmmTSsoiK7q9O+x61FSHyvzUY/NyA="
      ansible-playbook: deploy.yml
      ansible-inventory: inventory/prod.yml
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
      ssh-private-key: ${{ secrets.PROD_SSH_PRIVATE_KEY }}
```

#### Inputs and secrets

| Name                     | Input / secret | Type     | Description                                                                                                                                                                                                                                           | Default    |
|--------------------------|----------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------|
| `boot-jar`               | Input          | `string` | The path to the executable JAR to deploy, e.g. wtax-my-service-1.0.0-SNAPSHOT.jar. This must be an artifact that was archived in a previous job in this workflow. The JAR path will be passed to the Ansible playbook via `-e boot_jar=<<boot-jar>>`. |            |
| `known_hosts`            | Input          | `string` | The line or lines to be added to the `.ssh/known_hosts` file on the runner machine so that the public key of the remote host can be verified when connecting to detect possible man-in-the-middle attacks.                                            |            |
| `ansible-playbook`       | Input          | `string` | The Ansible playbook to run, relative to the deploy directory. This playbook should take a variable `boot_jar` defining the executable JAR to deploy. Defaults to deploy.yml.                                                                         | deploy.yml |
| `ansible-inventory`      | Input          | `string` | The Ansible inventory to run the playbook against, relative to the deploy directory.                                                                                                                                                                  |            |
| `ansible-vault-password` | Secret         | `string` | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory.                                                                                               |            |
| `ssh-private-key`        | Secret         | `string` | SSH private key to be used to connect to remote hosts to deploy the application there. The corresponding public key must have been added to the remote host's `authorized_keys` file.                                                                 |            |

#### Jobs

This workflow has one jobs:
- **deploy** - runs the Ansible playbook to deploy the Java app to the application server(s) in the inventory


### [`maven-release.yml`](.github/workflows/maven-release.yml)

```yaml
jobs:
  release:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/maven-release.yml@1.0
    with:
      release-version: ${{ inputs.release-version }}
      skip-prepare: ${{ inputs.release-version }}
      maven-repository-url: https://nexus.wtax.co/repository/maven-public/
      maven-releases-repository-id: nexus-releases
      maven-repository-username: github
      jdk-version: 17
    secrets:
      maven-repository-password: ${{ secrets.NEXUS_PASSWORD }}
```

#### Inputs and secrets

| Name                           | Input / secret | Type      | Description                                                                                                                                                                                                                                                                                                                                   | Default                                        |
|--------------------------------|----------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|
| `release-version`              | Input          | `string`  | The version number for the release. This will be used to rewrite the POM file and create the release tag. The `release-version` input must be provided when `skip-prepare` is `true`. Otherwise it can be left blank in which case the release version will be determined from the top-level POM file's current SNAPSHOT version.             |                                                |
| `skip-prepare`                 | Input          | `boolean` | Whether to skip prepare. This assumes a releasable version has already been tagged in version control with `release/v<release-version>` and the `perform_release` job can be run directly. The `release-version` input must be provided when `skip-prepare` is `true`.                                                                        | false                                          |
| `maven-repository-url`         | Input          | `string`  | URL of a Maven repository to use for retrieving artifacts that are not on Maven Central. If omitted, the maven-public repository on the WTax Nexus server at nexus.wtax.co will be used. The `maven-repository-username` input should hold a valid username for this server and the `maven-repository-password` a valid (encrypted) password. | https://nexus.wtax.co/repository/maven-public/ |
| `maven-releases-repository-id` | Input          | `string`  | ID of the Maven repository defined in the project's POM to which the artifact is to be released. This is used to generate the correct server entry holding the username and password for the repository in the Maven `settings.xml`.                                                                                                          | nexus-releases                                 |
| `maven-repository-username`    | Input          | `string`  | The username used to authenticate to the Maven repository specified in the `maven-repository-url` input as well as the Maven repository referenced by `maven-releases-repository-id`.                                                                                                                                                         | github                                         |
| `maven-repository-password`    | Secret         | `string`  | Password for the Maven repository specified in the `maven-repository-url` as well as the Maven repository referenced by `maven-releases-repository-id`, corresponding to the `maven-repository-username`.                                                                                                                                     |                                                |
| `jdk-version`                  | Input          | `string`  | Version of the Zulu JDK to use to build the project. If omitted, defaults to 17.                                                                                                                                                                                                                                                              | 17                                             |

#### Jobs

This workflow has two jobs:
- **prepare_release** - prepares the release, assigning a release version and tagging the project in version control as `release/v<x.y.z>` where `<x.y.z>` is the release version.
- **perform_release** - performs the release of the previously prepared release


### [`build-sfdx-project.yml`](.github/workflows/build-sfdx-project.yml)

```yaml
jobs:
  build:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/build-sfdx-project.yml@1.0
    with:
      client-id: 3H7cm0QedwevwtVKpSJ4PXeI7kvPanBgB3qK0sBU06E5MSMka3xqeg9JETRkx8Z8PQxuZkUvlMJH10MQ8A9uw
      jwt-key-file: deploy/env/prod/key.pem
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

#### Inputs and secrets

| Name                     | Input / secret | Type     | Description                                                                                                                                             | Default                                                                               |
|--------------------------|----------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| `instance-url`           | Input          | `string` | Salesforce instance URL to log in to as Dev Hub org                                                                                                     | https://wtax.my.salesforce.com                                                        |
| `client-id`              | Input          | `string` | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the Dev Hub org                                   | 3H7cm0QedwevwtVKpSJ4PXeI7kvPanBgB3qK0sBU06E5MSMka3xqeg9JETRkx8Z8PQxuZkUvlMJH10MQ8A9uw |
| `username`               | Input          | `string` | Username of Salesforce user to authenticate as; must have permission to create scratch orgs                                                             | admin@wtax.prod                                                                       |
| `jwt-key-file`           | Input          | `string` | Path to an Ansible Vault-encrypted file containing the private key to connect to the Dev Hub org with using the JWT flow                                | deploy/environments/prod/wtax-prod.key                                                |
| `ansible-vault-password` | Secret         | `string` | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory. |                                                                                       |

#### Jobs

This workflow has one jobs:
- **build** - deploys source from a Salesforce DX project to a scratch org and runs tests


### [`deploy-sfdx-project.yml`](.github/workflows/deploy-sfdx-project.yml)

```yaml
jobs:
  build:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/deploy-sfdx-project.yml@1.0
    with:
      instance-url: https://login.salesforce.com
      client-id: 3H7cm0QedwevwtVKpSJ4PXeI7kvPanBgB3qK0sBU06E5MSMka3xqeg9JETRkx8Z8PQxuZkUvlMJH10MQ8A9uw
      username: admin@wtax.prod
      jwt-key-file: deploy/env/prod/key.pem
      run-tests: true
    secrets:
      ansible-vault-password: ${{ secrets.VAULT_PASSWORD }}
```

#### Inputs and secrets

| Name                     | Input / secret | Type      | Description                                                                                                                                             | Default |
|--------------------------|----------------|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------|---------|
| `instance-url`           | Input          | `string`  | Salesforce instance URL to deploy to ("the target org")                                                                                                 |         |
| `client-id`              | Input          | `string`  | OAuth client ID (sometimes called consumer key) of the connected app on Salesforce used to connect to the target org                                    |         |
| `username`               | Input          | `string`  | Username of Salesforce user to authenticate as; must have permission to depoy metadata                                                                  |         |
| `jwt-key-file`           | Input          | `string`  | Path to an Ansible Vault-encrypted file containing the private key to connect to the target org with using the JWT flow                                 |         |
| `run-tests`              | Input          | `boolean` | Whether to run tests as part of the deployment. This is required when deploying to a production org.                                                    |         |
| `ansible-vault-password` | Secret         | `string`  | Password to be used to decrypt values encrypted by Ansible Vault. Can be omitted if no Ansible Vault encrypted values are in the playbook or inventory. |         |

#### Jobs

This workflow has two jobs:
- **build** - converts source to metadata and packages in a ZIP file that is then archived
- **deploy** - downloads an archived metadata ZIP file, connects to a Salesforce org, and deploys the metadata to the org

