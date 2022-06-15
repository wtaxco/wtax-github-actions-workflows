# WTax GitHub Actions Workflows

This repository contains [reusable workflows for GitHub Actions](https://docs.github.com/en/actions/using-workflows/reusing-workflows).
As GitHub only allows reusable workflows to be in public repositories, this repository is public. Therefore, make sure 
not to commit any sensitive information to this repository: all sensitive information (i.e. passwords, keys, etc.) are 
to be passed in as secrets to the reusable workflow.

## Workflows

| Name                      | Description                                                          |
|---------------------------|----------------------------------------------------------------------|
| `build-maven-project.yml` | Builds a Maven project, runs Sonar, and archives the build artifacts |
|                           |                                                                      |

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

