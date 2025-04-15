# WTax GitHub Actions Workflows

This repository contains [reusable workflows for GitHub Actions](https://docs.github.com/en/actions/using-workflows/reusing-workflows).
As GitHub only allows reusable workflows to be in public repositories, this repository is public. Therefore, make sure 
not to commit any sensitive information to this repository: all sensitive information (i.e. passwords, keys, etc.) are 
to be passed in as secrets to the reusable workflow.

## Workflows

### For Maven projects

| Name                                                                                | Description                                                                                                                           |
|-------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| [build-maven-project.yml](docs/build-maven-project.md)                              | Builds a Maven project, runs Sonar, and archives the build artifacts                                                                  |
| [maven-release.yml](docs/maven-release.md)                                          | Releases a Maven project to a Maven repository                                                                                        |
| [deploy-java-app.yml](docs/deploy-java-app.md)                                      | Deploys an executable JAR to an application server                                                                                    |

### For SFDX projects

| Name                                                                                | Description                                                                                                                           |
|-------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| [build-sfdx-project.yml](docs/build-sfdx-project.md)                                | Deploys source from a Salesforce DX project to a scratch org and runs tests                                                           |
| [deploy-sfdx-project.yml](docs/deploy-sfdx-project.md)                              | Deploys an SFDX project's metadata to an org                                                                                          |
| [deploy-sfdx-project-to-developer.yml](docs/deploy-sfdx-project-to-developer.md)    | Deploys an SFDX project's metadata to the WTax developer sandbox                                                                      |
| [deploy-sfdx-project-to-portalqa.yml](docs/deploy-sfdx-project-to-portalqa.md)      | Deploys an SFDX project's metadata to the WTax portalqa sandbox                                                                       |
| [deploy-sfdx-project-to-uat.yml](docs/deploy-sfdx-project-to-uat.md)                | Deploys an SFDX project's metadata to the WTax uat sandbox                                                                            |
| [deploy-sfdx-project-to-prod.yml](docs/deploy-sfdx-project-to-prod.md)              | Deploys an SFDX project's metadata to the WTax production org                                                                         |
| [prepare-sfdx-scratch-org-pool.yml](docs/prepare-sfdx-scratch-org-pool.md)          | Prepares a pool of scratch orgs for an SFDX project                                                                                   |
| [create-sfdx-package.yml](docs/create-sfdx-package.md)                              | Creates an SFDX package from the source code in `source-directory`                                                                    |
| [promote-sfdx-package.yml](docs/promote-sfdx-package.md)                            | Promotes a package version to released state                                                                                          |
| [install-sfdx-package.yml](docs/install-sfdx-package.md)                            | Installs an SFDX package on a target org using information from the source project to determine the package id                        |
| [install-sfdx-package-on-developer.yml](docs/install-sfdx-package-on-developer.md)  | Installs an SFDX package on the WTax developer sandbox using information from the source project to determine the package id          |
| [install-sfdx-package-on-uat.yml](docs/install-sfdx-package-on-uat.md)              | Installs an SFDX package on the WTax uat sandbox using information from the source project to determine the package id                |
| [install-sfdx-package-on-prod.yml](docs/install-sfdx-package-on-prod.md)            | Installs an SFDX package on the WTax production org using information from the source project to determine the package id |
