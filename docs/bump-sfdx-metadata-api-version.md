# bump-sfdx-metadata-api-version.yml

**Source:** [bump-sfdx-metadata-api-version.yml](../.github/workflows/bump-sfdx-metadata-api-version.yml)

## Usage

To specify an API version explicitly:

```yaml
name: Bump API versions

on:
  workflow_dispatch:
    inputs:
      api-version:
        description: "API version to bump to"
        type: string
        required: true
      jira-issue:
        description: "Jira issue number to include in the commit message"
        type: string
        required: true
jobs:
  bump-api-versions:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/bump-sfdx-metadata-api-version.yml@main
    with:
      api-version: ${{ inputs.api-version }}
      jira-issue: ${{ inputs.jira-issue }}
```

To have the job find the latest Salesforce API version and use that:

```yaml
on:
  workflow_dispatch:
    inputs:
      jira-issue:
        description: "Jira issue number to include in the commit message"
        type: string
        required: true
jobs:
  bump-api-versions:
    uses: wtaxco/wtax-github-actions-workflows/.github/workflows/bump-sfdx-metadata-api-version.yml@main
    with:
      instance-url: https://wtax.my.salesforce.com
      jira-issue: ${{ inputs.jira-issue }}
```

## Inputs and secrets

| Name               | Input / secret | Type     | Description                                                                                                                                                        | Default   |
|--------------------|----------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|
| `source-directory` | Input          | `string` | Directory containing the main source of the project. Usually force-app, but can be something else. API versions will only be bumped in this directory.             | force-app |
| `instance-url`     | Input          | `string` | Salesforce instance URL of the org to get the latest API version from. Required if `api-version` is omitted or empty.                                              |           |
| `api-version`      | Input          | `string` | A Salesforce API version in the majorVersion.minorVersion format, e.g. 61.0. If omitted, the latest API version on the org indicated by instance-url will be used. |           |
| `jira-issue`       | Input          | `string` | A Jira issue number to include in the commit message                                                                                                               |           |

## Jobs

This workflow has one job:
- **bump-api-versions** - bumps the API version of all metadata files in the project's main source directory and commits and pushes the changes to the same branch the workflow was run from.
