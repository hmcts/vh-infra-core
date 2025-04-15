# vh-infra-core
Repository for the Video Hearings Core Infrastructure. 
# vh-setup
Repository for the Video Hearings variable-to-secret mappings.

### Adding ADO Librarys to Key Vault

#### Create or Update an ADO Variable

1. Go to the [vh-setup](https://github.com/hmcts/vh-setup/tree/main/keyvault-mapping) repo and update the corresponding JSON secrets file.
2. If this is for a new app, create a new file with JSON-formatted secret references, as per the existing apps, names as the corresponding Key Vault, suffixed with "-secrets".
3. Format your value as
```json
[
    {
        { "name": "NotifyConfiguration--ApiKey", "value": "$(notify-api-key)" }, # Key Vault Secret name, Key Vault Secret value
    }
]
```
4. IMPORTANT! Terraform plan will fail if there is no more than 1 secret in each mapping file, because it will be passed as an object rather than a list to the input variable.

#### Adding Library to the list

If the ADO Library you are getting secrets from is not already included then you will need to add it to the list.

Go to `pipeline-steps\ado-vars.yaml` and add the group to the top of the list.

#### Adding to the powershell

If there is a new Key Vault that is added to the Terraform then you can add a new group to the powershell.

1. Go to `pipeline-steps\ado-vars-to-tf.yaml`
2. Add in the `env` you new variable, where `{VAULT NAME}` is the vault name and `{ADO LIBRARY VAR NAME}` is the variable name from the library.

```yaml

{VAULT NAME}_secrets: $({ADO LIBRARY VAR NAME})
```
3. Add in the powershell at the bottom a new block. Replace the respective names below to your required name.

```powershell
$sj_obj = Get-Content .\vh-scheduler-jobs-secrets.json | ConvertFrom-Json
$secrets_obj = $sj_obj
if ($null -ne $secrets_obj) {
    $scheduler_jobs_secrets = [pscustomobject]@{
        "key_vault_name" = "vh-scheduler-jobs"
        "secrets"        = $secrets_obj
    }
    $all_secrets += $scheduler_jobs_secrets
}
```