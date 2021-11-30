# Modern Data Warehousing with Terraform and Microsoft Azure

This repo demonstrates how to deliver a Modern Data Warehouse using Azure and Terraform. 

![terraform and Azure logos against a purple background](/img/1.jpeg)

## Prerequisites

- An Azure Subscription
- An Azure DevOps Organisation
- [Visual Studio Community Edition](https://visualstudio.microsoft.com/vs/community/) with [SQL Server Data Tools (SSDT)](https://visualstudio.microsoft.com/vs/features/ssdt/)
- `git`, `az`, and `terraform` installed in your local development environment.

## Architecture overview

![Architecture diagram of what this repository delivers. A shared resources (Azure storage for Terraform state), and development and test resource groups that contain an Azure Data Lake Storage account, Azure Synapse workspace, dedicated SQL pool, and key vault, with arrows between the development and test resource groups and the Azure DevOps logo to show the CI/CD capability to promote artefacts between environments.](/img/2.png)

_NB: This example focuses on orchestration of data movement and transformation with the Synapse Workspace. yaml templates are included to deliver similar functionality using Azure Data Factory (see `./.ado/templates/jobs/adf-*.yml`), but are not used in this example._

The above diagram shows a high level architecture of the services that are defined in the Terraform scripts, and the CI/CD process that you can implement using the yaml scripts in the `.ado` folder. The development and test environments are deployed from the same `.tf` files, using [Terraform workspaces](https://www.terraform.io/docs/language/state/workspaces.html). The environments can be deployed using the Azure DevOps pipelines included, or using `terraform` in your local environment.

## Instructions for infrastructure deployment

The instructions for configuring and deploying this environment are broadly chunked into 3 parts; deployment of shared infrastructure (for [terraform state](https://www.terraform.io/docs/language/state/index.html)), configuration of Azure DevOps, and then deployment of the infrastructure itself.

### Deployment of shared infrastructure

1. Import this repository into a new Azure DevOps repo in your organisation. [Instructions for doing this are available in the docs](https://docs.microsoft.com/en-us/Azure/devops/repos/git/import-git-repository?view=Azure-devops).
1. Open your terminal and clone the repo from your Azure DevOps repo to your local development environment using `git clone`.
1. Run `az login` to authenticate to Azure, and select the subscription you want to deploy these resources into with [`az account set`](https://docs.microsoft.com/en-us/cli/Azure/account?view=Azure-cli-latest#az_account_set)
1. `cd` into the `./sharedinfra` directory 
1. Open the `storage.tf` file and update the shared storage account name (line 2)
1. Deploy the shared resources for the terraform state by running `terraform init` to initialize your terraform environment, `terraform plan` to see what will be deployed, and `terraform apply` to deploy the shared resources. 

This will deploy:

- a resource group to hold these shared resources
- a storage account which will be used to store the terraform state files
- a Key Vault which will hold secrets to access the storage account
- a Service Principal to be used to deploy the infrastructure via the Azure DevOps pipeline
- an Active Directory Group which will be used to manage access into the Synapse Workspace

### Configuration of Azure DevOps

1. Navigate to your Azure DevOps project and click "Pipelines", then add a new pipeline by clicking "New Pipeline"
1. Choose "Azure Repos Git YAML", then select the repo in your project. Choose "Existing Azure Pipelines YAML file, leave branch as `main` and select `/.ado/terraform-status-check.yml`.
1. Save the pipeline. Run through the above steps 4 more times to create the other 4 pipelines (`terraform-plan`, `terraform-apply`, `synapse-ci` and `synapse-cd`).
1. Navigate to Pipelines > Library > + Add New Variable Group. Give name your variable group `mdw-shared-westeurope-01`. Select the `Link secrets from an Azure key vault as variables` toggle, and then select the Key Vault deployed as part of the shared infrastructure in the `Deployment of shared infrastructure` steps.
1. Under Variables, click `Add +`. Select all the secrets in the vault with the checkboxes, and click ok.
1. Click Save.
1. Navigate to Repos > Branches. On the `main` branch, click _More options_ (this is an elipsis on the right hand side when you hover over the branch) and select _Branch policies_.
1. Click the + on the _build validation_ section. Select your `terraform-status-check` pipeline as the build pipeline. Type `/iac/*` into the path filter (this means that this will only be required for changes to our data platform infrastructure). Set trigger to automatic, Policy requirement as required, and for build to expire _Immediately when main is updated_. Click save.
1. Finally, create a Service connection in your Azure DevOps Project using the service principal created in the previous step. Navigate to Project settings > Service connections. Create a new `Azure Resource Manager` service connection, using **Service Principal (Manual)**. Scope it to the subscription you will be using the for the deployment (insert `id` and `name` values from the [publish settings file](https://ms.portal.azure.com/#blade/Microsoft_Azure_ClassicResources/PublishingProfileBlade) you can access for your subscription). Input the service principal id, key, and tenant from the terraform output from the previous step. You can view these again by running `terraform output` in the `./sharedinfra` directory if needed. Take a note of the service connection name - you will need this in the next step to update the pipelines to make use of this service connection.

### Edit pipeline templates

1. Return to your local version of the repo. Create a new working branch with `git checkout -b <branch-name>`. Open the repo in your text editor of choice and make the following changes:

    File | Change
    ------ | ------
    `./iac/backend.tf`   | Update the `Azure_rm` backend `storage_account_name` on line 4, to the name of the shared infrastructure storage account you deployed in the previous step.
    `terraform-apply.yml` | Update the `project` and `pipeline` on line 32 and 33. `project` should be the name of your Azure DevOps project. Pipeline should be the pipeline id of your `terraform-plan` pipeline (you can get these by opening the pipeline in your web browser and looking at the URL - e.g. `https://dev.azure.com/<organisation>/<project>/_build?definitionId=<pipline id>`).
    `synapse-ci.yml` | Update the repository name on line 10. Format is `projectname/reponame`.
    `synapse-cd.yml` | Update the `project` (project name) and `pipeline` (pipeline id for the `synapse-ci` pipeline) variables on lines 17 and 19. _Note the empty variable for `devWorkspaceName` on line 21 - we will come back and update this once the infrastructure has been deployed_. Update the `serviceConnection` parameter with the service connection name that you created in the earlier steps.

1. Commit the changes to your branch and push the changes to your Azure DevOps repo. Open a pull request from your development branch to the `main` branch. This should trigger the `terraform-status-check` pipeline set up in earlier steps. Wait for the status check to pass, then when successful, Approve the PR and merge to `main`.

### Deploy the infrastructure

You can now deploy the development infrastructure from the DevOps pipeline

1. Open the `terraform-plan` pipeline and manually trigger the pipeline, selecting `dev` as the parameter. This will deploy the infrastructure for your dev environment. 
1. To deploy the test environment, manually trigger the `terraform-status-check` pipeline, selecting `test` as the parameter. This initializes the terraform state file in the remote storage. After this has run, open the `terraform-plan` pipeline and manually trigger the pipeline, selecting `test` as the parameter. This will deploy the test environment.

### Final config and setup

There are two additional steps you need to complete to finish the environment setup:

1. _Link the development Synapse workspace with your DevOps repo_. As per [Synapse DevOps best practice](https://docs.microsoft.com/en-us/azure/synapse-analytics/cicd/source-control#best-practices-for-git-integration), you should only integrate your development workspace with your git repo. [Follow these instructions in the docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/cicd/source-control#connect-with-azure-devops-git) to link your repo to the Synapse workspace.
1. _Update the CD pipeline for Synapse artefacts with the name of the dev workspace_. As discussed earlier in this README, the Synapse CD template needs to reference the development workspace name in the artefacts as part of the deployment process. 
    1. Navigate to your development resource group and note the synapse workspace name.
    1. Create a new branch on your local version of the repo and add the dev workspace name to line 21 of the `synapse-cd.yml` file.
    1. Commit, push and merge the changes with your main branch via PR.

## Working with the environment

You now have a working set of infrastructure and associated pipelines to manage changes to your environment. 

_TODO: author steps for demonstration of adding functionality into the Synapse environment_.

## Contents

### `.ado/`

Contains sample yaml pipelines for use in Azure DevOps for CI/CD of ADF and Synapse artefacts.

### `iac/`

Contains Terraform for the infrastructure.

### `sql/`

Contains SSDT project that manages and maintains Synapse data model.

## Know limitations

- Variables for the CI/CD pipelines need to be manually updated in the pipelines instances on import.
- These templates do not implement best practice wrt network security. This is beyond the scope of this example.
