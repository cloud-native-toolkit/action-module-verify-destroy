# GitHub Action: Verify terraform destroy module

This action verifies Terraform modules

This action will attempt to remove an already applied terraform state. The action performs filtering of the resources in the state to prevent deletion of resources, if they exist. The filtered resources are:

* `module.dev_cluster`
* `module.dev_software_olm` 
* `module.dev_tools_namespace`

The action will also remove any contents of `.tmp` from the workspace directory, so any resources (e.g. files) that will be needed during terraform destroy should not be placed in that directory.


## Inputs

### `clusterId`

**Required** The identifier of the cluster onto which the module should be deployed. This value will be used
along with configBaseUrl to look up the `terraform.tfvars` containing the configuration for the test run.

### `configBaseUrl`

**Optional** The base url where the terraform.tfvars file can be found for the clusterId. Expected to resolve to `{configBaseUrl}/{clusterId}/terraform.tfvars`. Defaults
to `https://raw.githubusercontent.com/ibm-garage-cloud/action-module-verify/main/env`

### `validateDeployScript`

**Optional** Additional, custom script to validate deployment environment. If not provided only the general validation will be performed,
which is sufficient in most cases.

### `testStagesDir`

**Optional** The directory where the test stages are located. Defaults to `test/stages` (e.g. the action expects to find 
a folder containing setup terraform modules in `${testStagesDir}` in the root of the Git repo).

### `testModuleDir`

**Optional** The directory where the current module will be copied for execution in the validation process. Defaults to `module` (the terraform module in the `${testStagesDir}` that tests
the module in the Git repo should refer to this directory, e.g. `source = "./module"`).

### `workspace`

***Optional** The directory where the terraform workspace should be created. Defaults to `/tmp/workspace`.

## Environment variables

### `TF_VAR_*`

**Optional** Any variable needed by the the terraform scripts can be provided as an environment variable by adding the prefix `TF_VAR_`

### Additional environment variables

Additional environment variables can be provided to the terraform modules and verification scripts by providing them in a `.env` file 
in the root of the repository. Some variables that can be provided to the verification scripts are:

- `CONSOLE_LINK_NAME` - the name of the ConsoleLink resource that will be created on OpenShift 4.x clusters. If not provided then the validation logic will
not check for the existence of a ConsoleLink

## Example usage

```yaml
uses: cloud-native-toolkit/action-module-verify-destroy@main
with:
  clusterId: ${{ matrix.platform }}
env:
  TF_VAR_ibmcloud_api_key: ${{ secrets.IBMCLOUD_API_KEY }}
  IBMCLOUD_API_KEY: ${{ secrets.IBMCLOUD_API_KEY }}
```
