# vh-shared-infrastructure
space for sharedservice infrastructure for the VH project


### Adding ADO Librarys to Key Vault

#### Create a ADO Variable

1. Go to the ADO Library and edit `vh-key-vault-vars` group
2. Add a new variable with the value in the format of an array of object. Call the variable the name of the key vault plus `-secrets` <br/>
**You must have at least two secrets to add in the object**
3. Format your value as
```json
[
    {
        "name": "NotifyConfiguration--secret-name", # Key Vault Secret
        "value": "$(secret-test-ba)" # Key Vault Value
    }
]
```

#### Updating a ADO Variable

1. Go to the ADO Library and edit `vh-key-vault-vars` group
2. Copy out the current value and format to JSON.
3. Add your secret as per the above.

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
$sj_obj = $($env:scheduler_jobs_secrets) | ConvertFrom-Json
$secrets_obj = $sj_obj
if ($null -ne $secrets_obj) {
    $scheduler_jobs_secrets = [pscustomobject]@{
        "key_vault_name" = "vh-scheduler-jobs"
        "secrets"        = $secrets_obj
    }
    $all_secrets += $scheduler_jobs_secrets
}
```