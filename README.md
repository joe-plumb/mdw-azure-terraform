

# Modern Data Warehousing with Terraform and Microsoft Azure
This repo demonstrates how to deliver a Modern Data Warehouse using Azure and Terraform. 

![terraform and azure logos against a purple background](/img/1.jpeg)

## Prerequisites
- An Azure Subscription
- An Azure DevOps Organisation
- [Visual Studio Community Edition](https://visualstudio.microsoft.com/vs/community/) with [SQL Server Data Tools (SSDT)](https://visualstudio.microsoft.com/vs/features/ssdt/)
- `git`, `az`, and `terraform` installed in your local development environment.

## Instructions for `/iac` deployment
1. Import this repository into a new Azure DevOps repo in your organisation. [Instructions for doing this are available in the docs](https://docs.microsoft.com/en-us/azure/devops/repos/git/import-git-repository?view=azure-devops).
1. Open your terminal and clone the repo from your Azure DevOps repo to your local development environment using `git clone`.
1. Run `az login` to authenticate to Azure, and select the subscription you want to deploy these resources into with [`az account set`](https://docs.microsoft.com/en-us/cli/azure/account?view=azure-cli-latest#az_account_set)
1. `cd` into the `mdw-azure-terraform/iac/shared` directory 
1. Open the `main.tf` file and update the shared storage account name (line 27)
1. Deploy the shared resources for the terraform state by running `terraform init` to initialize your terraform environment, `terraform plan` to see what will be deployed, and `terraform apply` to deploy the shared resources.
1. Open the `main.tf` file in `../dev` and `../test`, and update the `azure_rm` backend `storage_account_name` on line 10.
1. Update the `vsts_configuration` block in `dev/main.tf` to point to your new Azure Repo. This is the repository reference that will be attached to your Data Factory instance.
1. Deploy the development and test environments by running `tf init`, `tf plan`, `tf apply` in the `dev` and `test` folders.
1. The ADF artefacts will need to be updated with details of the resources you have just deployed. In order to do this, in your local environment:
    1. Rename the `adf/factory/adf-mdw-dev-westeurope-01.json` and update the `value` with the name of the ADF that was deployed in your dev environment
    1. Also update the URLs in the `adf/linkedService/*.json` files to point to the services in your development environment
    1. Commit and push these changes to your Azure DevOps repository.

## Contents
### `.ado/`
Contains sample yaml pipelines for use in Azure DevOps for CI/CD of ADF and Synapse artefacts

### `iac/`
Contains Terraform deployment for the environments.

### `synapse/`
Contains SSDT project that mananges and maintains Synapse data model.

### `adf/`
Contains sample Azure Data Factory artefacts.

## Know limitations
- These templates do not implement best practice wrt network security. This is beyond the scope of this example.
- There is no automated deployment or update of the infrastructure. 