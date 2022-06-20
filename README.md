# WTax GitHub Actions Workflows

This repository contains [reusable workflows for GitHub Actions](https://docs.github.com/en/actions/using-workflows/reusing-workflows).
As GitHub only allows reusable workflows to be in public repositories, this repository is public. Therefore, make sure 
not to commit any sensitive information to this repository: all sensitive information (i.e. passwords, keys, etc.) are 
to be passed in as secrets to the reusable workflow.

## Workflows

| Name                      | Description                                                          |
|---------------------------|----------------------------------------------------------------------|
| `build-maven-project.yml` | Builds a Maven project, runs Sonar, and archives the build artifacts |
| `maven-release.yml`       | Releases a Maven project to a Maven repository                       |

## Usage

### `build-maven-project.yml`

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

### `maven-release.yml`

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
