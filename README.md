# Terraform 101: A Beginner's Guide 2023

Configuring your environment to start working with Terraform.

## Overview 
### Semantic Versioning

This project uses semantic versioning for its tagging. See
[semver.org](https://smver.org/) for more info.

The general format:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Prerequisites

### Gitpod

To optimize your developement environment you can use the open source tool [Gitpod CLI](https://www.gitpod.io/docs/introduction/getting-started). It allows you to reproduce the Cloud Development Environment (CDE) through the use of customizable ["workspaces"](https://www.gitpod.io/docs/configure/workspaces), ephemeral development environments.

#### Gitpod CLI

All Gitpod workspaces include a CLI (gp). For more info see the [Gitpod CLI Reference Doc](https://www.gitpod.io/docs/references/gitpod-cli).

### Install the Terraform CLI

1) Check your Linux Distribution. See [How To Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/).
   - Your version of Linux affects the type of commands you can run.
    - This project is built against Ubuntu. Example of checking Linux OS Version:

          ```
          cat /etc/os-release
          ```
      eg. Output:

          ```
          PRETTY_NAME="Ubuntu 22.04.3 LTS"
          NAME="Ubuntu"
          VERSION_ID="22.04"
          VERSION="22.04.3 LTS (Jammy Jellyfish)"
          VERSION_CODENAME=jammy
          ID=ubuntu
          ID_LIKE=debian
          HOME_URL="https://www.ubuntu.com/"
          SUPPORT_URL="https://help.ubuntu.com/"
          BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
          PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
          UBUNTU_CODENAME=jammy
          ```

3) Refer to the latest [Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) instructions.
    - Alternatively: You can use the bash script here: [./bin/install_terraform_cli](./bin/install_terraform_cli) to install terraform using homebrew macOS X.

## Refactoring into Bash Scripts

To address the Terraform CLI GPG deprication issues and efficiently install the cli considering the additional steps we created a bash scirpt. The bash script:
              -   Keeps the Gitpod Task File ([gitpod.yml](.gitpod.yml)) tidy.
              -   Makes it easier to debug and execute homebrew macOS X Terraform CLI install.
              -   Allows for better portability for other project that need to install Terraform CLI.

## Considerations
### Shebang Considerations

On Linux, a Shebang (#!), pronounced Sha-bang, is a special line at the beginning of a script that tells the OS which program to use to run the script. eg. `#!/bin/bash`. It's the first line of the script and starts with `#!` followed by the program's path. 

ChatGBT recommended this format for bash: `#!/usr/bin/env bash` for 1) protability for different OS distributions and to 2) search the user's PATH for the bash executable

More info on Shebang [here](https://en.wikipedia.org/wiki/Shebang_(Unix))

### Execution Considerations 

#### GitPod Lifecycle (Before, Init, Command

Be mindful when using `init` because the script will not rerun if we restart an existing workspace.
See Gitpod Tasks [documentation](https://www.gitpod.io/docs/configure/workspaces/tasks) for more information.
- This is why one of the changes we made to the Gitpod Task File ([gitpod.yml](.gitpod.yml)) was replaceing `init` with `before`.

When executing the bash script we can use the `./` shorthand notation to execute the bash script eg. `./bin/install_terraform_cli` instead of `source`. 

If we are using a script however in the gitpod.yml we need to point the script to a program to interpret it eg. `source ./bin/install_terraform_cli`

### Linux Permissions Considerations

In order to make our bash scripts executable we need to change Linux permissions for the file to be executable at the user mode. For more info on changing linux permisisons see [this](https://en.wikipedia.org/wiki/Chmod).

```sh
chomd u+x ./bin/install_terraform_cli
```
alternatively:
```sh
chmodn 744 ./bin/install_terraform_cli
```
### Working with Environment Variables (Env Vars)

Set en vars in bash profile.

#### Bash Commands

`env` - to list all env vars
`env | grep VARIABLE` - set a varaible inline

#### Setting and Unsetting Env Vars

`export VARIABLE= 'value'` - set a varaible 
`unset VARIABLE` - unset a variable

To temporarily set an env var, run the following command:

```sh
VARIABLE='value' ./bin/print_message
```

Within a bash script we can set an env without writing `export`:

```sh
#!/usr/bin/env bash

VARIABLE='value'

echo $VARIABLE
```
#### Printing Vars

We can print an env var using echo eg. `echo $VARIABLE`

#### Scoping of ENv Vars

When you open a new bash terminal in VSCode it will not be aware of env vars set in another window. To persist env vars across all furture terminals. You need to set env vars in your bash profile. eg. `.bash_profile`

#### Persisting Env Vars in Gitpod 

Gitpod has default env vars set for every workspace. To set new env vars in Gitpod and have them persist across all your future workspaces follow this, please see [this](https://www.gitpod.io/docs/configure/projects/environment-variables).

`env | grep GITPOD` - lists all default Gitpod env vars
`gp env VARIABLE` - set a varaible in gitpod
`echo VARIABLE` - (create a new workspace to view newly set env vars

