# maven-release.yml

**Source:** [maven-release.yml](../.github/workflows/maven-release.yml)

## Usage

```yaml
jobs:
  release:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/maven-release.yml@main
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

## Inputs and secrets

| Name                           | Input / secret | Type      | Description                                                                                                                                                                                                                                                                                                                                   | Default                                        |
|--------------------------------|----------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|
| `release-version`              | Input          | `string`  | The version number for the release. This will be used to rewrite the POM file and create the release tag. The `release-version` input must be provided when `skip-prepare` is `true`. Otherwise it can be left blank in which case the release version will be determined from the top-level POM file's current SNAPSHOT version.             |                                                |
| `skip-prepare`                 | Input          | `boolean` | Whether to skip prepare. This assumes a releasable version has already been tagged in version control with `release/v<release-version>` and the `perform_release` job can be run directly. The `release-version` input must be provided when `skip-prepare` is `true`.                                                                        | false                                          |
| `maven-repository-url`         | Input          | `string`  | URL of a Maven repository to use for retrieving artifacts that are not on Maven Central. If omitted, the maven-public repository on the WTax Nexus server at nexus.wtax.co will be used. The `maven-repository-username` input should hold a valid username for this server and the `maven-repository-password` a valid (encrypted) password. | https://nexus.wtax.co/repository/maven-public/ |
| `maven-releases-repository-id` | Input          | `string`  | ID of the Maven repository defined in the project's POM to which the artifact is to be released. This is used to generate the correct server entry holding the username and password for the repository in the Maven `settings.xml`.                                                                                                          | nexus-releases                                 |
| `maven-repository-username`    | Input          | `string`  | The username used to authenticate to the Maven repository specified in the `maven-repository-url` input as well as the Maven repository referenced by `maven-releases-repository-id`.                                                                                                                                                         | github                                         |
| `maven-repository-password`    | Secret         | `string`  | Password for the Maven repository specified in the `maven-repository-url` as well as the Maven repository referenced by `maven-releases-repository-id`, corresponding to the `maven-repository-username`.                                                                                                                                     |                                                |
| `jdk-version`                  | Input          | `string`  | Version of the Zulu JDK to use to build the project. If omitted, defaults to 17.                                                                                                                                                                                                                                                              | 17                                             |

## Jobs

This workflow has two jobs:
- **prepare_release** - prepares the release, assigning a release version and tagging the project in version control as `release/v<x.y.z>` where `<x.y.z>` is the release version.
- **perform_release** - performs the release of the previously prepared release

