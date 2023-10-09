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

To optimize your development environment you can use the open source tool [Gitpod CLI](https://www.gitpod.io/docs/introduction/getting-started). It allows you to reproduce the Cloud Development Environment (CDE) through the use of customizable ["workspaces"](https://www.gitpod.io/docs/configure/workspaces), ephemeral development environments.

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

To address the Terraform CLI GPG deprecation issues and efficiently install the cli considering the additional steps we created a bash scirpt. The bash script:
              -   Keeps the Gitpod Task File ([gitpod.yml](.gitpod.yml)) tidy.
              -   Makes it easier to debug and execute homebrew macOS X Terraform CLI install.
              -   Allows for better portability for other project that need to install Terraform CLI.

## Considerations
### Shebang Considerations

On Linux, a Shebang (#!), pronounced Sha-bang, is a special line at the beginning of a script that tells the OS which program to use to run the script. eg. `#!/bin/bash`. It's the first line of the script and starts with `#!` followed by the program's path. 

ChatGBT recommended this format for bash: `#!/usr/bin/env bash` for 1) portability for different OS distributions and to 2) search the user's PATH for the bash executable

More info on Shebang [here](https://en.wikipedia.org/wiki/Shebang_(Unix))

### Execution Considerations 

#### GitPod Lifecycle (Before, Init, Command)

Be mindful when using `init` because the script will not rerun if we restart an existing workspace.
See Gitpod Tasks [documentation](https://www.gitpod.io/docs/configure/workspaces/tasks) for more information.
- This is why one of the changes we made to the Gitpod Task File ([gitpod.yml](.gitpod.yml)) was replacing `init` with `before`.

When executing the bash script we can use the `./` shorthand notation to execute the bash script eg. `./bin/install_terraform_cli` instead of `source`. 

If we are using a script however in the gitpod.yml we need to point the script to a program to interpret it eg. `source ./bin/install_terraform_cli`

### Linux Permissions Considerations

In order to make our bash scripts executable we need to change Linux permissions for the file to be executable at the user mode. For more info on changing linux permissions see [this](https://en.wikipedia.org/wiki/Chmod).

```sh
chomd u+x ./bin/install_terraform_cli
```
alternatively:
```sh
chmodn 744 ./bin/install_terraform_cli
```
### Working with Environment Variables (Env Vars)

#### Bash Commands

`env` - to list all env vars
`env | grep VARIABLE` - set a variable in terminal

#### Setting and Unsetting Env Vars

`export VARIABLE= 'value'` - set a variable 
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

#### Scoping of Env Vars

When you open a new bash terminal in VSCode it will not be aware of env vars set in another window. To persist env vars across all future terminals. You need to set env vars in your bash profile. eg. `.bash_profile`

#### Persisting Env Vars in Gitpod 

Gitpod has default env vars set for every workspace. To set new env vars in Gitpod and have them persist across all your future workspaces follow this, please see [this](https://www.gitpod.io/docs/configure/projects/environment-variables).

`env | grep GITPOD` - lists all default Gitpod env vars
`gp env VARIABLE` - set a variable in gitpod
`echo VARIABLE` - (create a new workspace to view newly set env vars

### AWS CLI Installation

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our aws credentials are configured correctly by running the following AWS CLI command: 
```sh
aws sts get-caller-identity
```

If it is successful you should see a json payload return: 

```json
{"UserId": "AIXAU7JXXLKQXXXCXXC5",
    "Account": "335370644609",
    "Arn": "arn:aws:iam::342100630177:user/terraform-beginner-bootcamp"
}
```
Use `aws configure` when you are on a local computer and when in a cloud developer environement you'll want to set your env vars.

### Create an new AWS IAM user

We'll need to generate AWS CLI credentials from an IAM user in order to use the AWS CLI. To create a new user please follow these instructions [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)

## Terraform Basics

### Terraform Registry 

Terraform sources their providers and modules from the Terraform registroy which is located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** are a logical abstraction of an upstream API. They are responsible for understanding API interactions and exposing resources.
- **Modules** are self-contained packages of Terraform configurations that are managed as a group. They make larger amounts of terraform code modular, portable and shareable.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

## Terraform Console 

We can see a list of all the Terraform commands by typing `terraform`

#### Terraform Init 

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

#### Terraform Plan 

`terraform plan`

This wll generate out a changeset about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outputting 

#### Terraform Apply 

Ths will run a plan and pass the changeset to be executed by terraform. Apply should prompt 'yes' or 'no'.

To automatically approve an apply we can provide the auto approve flag eg. `terraform apply --auto-approve`

## Terraform Lock Files

`.terraform.lock.hcl` contains the lock versioning for the providers or modules that should be used with this project 

The Terraform Lock File **should be commited** to your Version Control System (VSC) eg. Github

### Terraform State Files

`.terraform.tfstate` contains informations about the current state of your infrastructure. This file **should not be commited** to your VCS. This file can contain sensitive data. If you lose this file, you lose knowing the state of your infrastructure. 

`.tefraform.tfstate.backup` is the previous state file's state.

### Terraform Directory 

`.terraform` directory contains binaries of terraform provders.