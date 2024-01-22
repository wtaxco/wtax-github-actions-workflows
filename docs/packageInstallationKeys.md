# `packageInstallationKeys`

To keep all package-related information together in the same place while making it as easy as
possible to work with installation-key-proetected packages, we've extended `sfdx-project.json`,
the project descriptor for SFDX projects, with a new attribute `packageInstallationKeys`.

## Purpose

To include installation keys for package dependencies in a secure way.

## Specification

Package installation keys can be added to a top-level property in the `sfdx-project.json` file.
This property must be called `packageInstallationKeys` and is a JSON object (map/hash/dict)
where 
- the keys are package aliases (matching the aliases in `packageAliases`)
- the values are (encrypted) installation keys for the package referred to by the package alias

For example:

```json
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true,
      "dependencies": [
        {
          "package": "apex-lang-managed-1.18.0.1"
        },
        {
          "package": "my-protected-package"
        },
        {
          "package": "other-protected-package"
        },
        {
          "package": "not-really-protected-package"
        }
      ]
    }
  ],
  "name": "my-project",
  "namespace": "",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "53.0",
  "packageAliases": {
    "apex-lang managed-1.18.0.1": "04t80000000jN1qAAE",
    "my-protected-package": "04t............",
    "other-protected-package": "04t............"
  },
  "packageInstallationKeys": {
    "my-protected-package": "ccrypt:M2tMZOgqYeUsV0LbRv9y0I3vwdXPtkv8yVmqSAlY/Rw4k/ijqJrq",
    "other-protected-package": "ccrypt:uaGU5SlXe903unaBn0AxLQ4Ia+9eh8ZOfR0Ag7uCIbuzCGbPpFm4",
    "not-really-protected-package": "plain:secret"
  }
}
```

Each value in the `packageInstallationKeys` map is an encrypted installation key that follows the
format `method:encryptedinstallationkey`, where `encryptedinstallationkey` is the
encrypted installation key, and `method` indicates how it was encrypted. 

`method` is one of:

| Name     | Description                                                                                                                                                          |
|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `plain`  | The installation key is not actually encrypted, but represented in cleartext. Not recommended.                                                                       |
| `ccrypt` | The installation key was encrypted using the Unix `ccrypt` tool, using the project's `ansible-vault-password` secret as the encryption key, and then base64 encoded. |

More methods may be added in the future if the need arises.

### `plain`

The installation key is not actually encrypted, but represented in cleartext. Not recommended.

### `ccrypt`

The installation key was encrypted using the Unix `ccrypt` tool, using the project's `ansible-vault-password` secret as 
the encryption key, and then base64 encoded.

To encrypt an installation key using this method, use the following command on a Linux command line, assuming
the `ccrypt` and `base64` programs have been installed:

```shell
echo 'installationkey' | ccencrypt -k vault-password.txt | base64
```

This is assuming that the installation key is "installationkey" and that the encryption key
has been written to a file `vault-password.txt`.

To decrypt, reverse the process:

```shell
echo 'encryptedkey' | base64 -D | ccat -k vault-password.txt
```

(Normally, decrypting is not necessary: the reusable workflows that support encrypted
package installation keys will decrypt them as needed.)