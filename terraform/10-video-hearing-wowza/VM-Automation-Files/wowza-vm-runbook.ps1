<#
.SYNOPSIS
    Control Azure VMs with an Automation Account and a User-assigned Managed Identity.
.DESCRIPTION
    Allows control over a list of Azure Virtual Machines. Runbook can Start, Stop and
    Read the status of each Virtual Machine in a list passed in as a string parameter.

.NOTES       

    Based on existing Runbooks by Pradebban Raja and Andreas Dieckmann.

.INPUTS
    Azure resource group (String)
    User-assigned Managed Identity principal_id (String)
    List of Virtual Machines to be controlled (string array)
    Action - either 'Start' or 'Stop' to control VMs 

.OUTPUTS
    Outputs the Account Id of the current context
    the start and end times of the script, as well
    as the beginning and ending status of each VM (along with errors).

#>

Param(
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $resourcegroup,    
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $mi_principal_id, 
    [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]
	[string]
    $vmlist, 
    [Parameter(Mandatory=$true)][ValidateSet("Start","Stop")] 
    [String] 
    $action,
    [Parameter(Mandatory=$true)][ValidateSet("True","False")] 
    [String] 
    $makechange
)

$day = (get-date).DayOfWeek
Write-Output "Script started at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process | Out-Null

# Connect to Azure with user-assigned managed identity
# Don't do what Microsoft say - they use Client_Id here but it needs to be
# the managed_identity_principal_id
$AzureContext = (Connect-AzAccount -Identity -AccountId $mi_principal_id).context

# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

# Separate our vmlist into an array we can iterate over
$VMssplit = $vmlist.Split(",") 
[System.Collections.ArrayList]$VMs = $VMssplit

# Loop through one or more VMs which will be passed in from the terraform as a list
# If the list is empty it will skip the block
# If 'env = prod' $makechange will be false
if ($makechange -ne "False"){
    # If it is a weekend we do not want to start the VMs
    if (($day -ne "Saturday") -or ($day -ne "Sunday")){
        # If we are Monday through Friday:
        foreach($VM in $VMs) {

            switch ($action) {
                "Start" {
                    
                        # Start the VM
                        try {
                            Write-Output "Starting VM $VM ..."
                            Start-AzVM -Name $VM -ResourceGroupName $resourcegroup -DefaultProfile $AzureContext -NoWait
                        }
                        catch {
                            $ErrorMessage = $_.Exception.message
                            Write-Error ("Error starting the VM $VM : " + $ErrorMessage)
                            Break
                        }
                }
                "Stop" {
                    # Stop the VM
                    try {
                        Write-Output "Stopping VM $VM ..."
                        Stop-AzVM -Name $VM -ResourceGroupName $resourcegroup -DefaultProfile $AzureContext -Force 
                    }
                    catch {
                        $ErrorMessage = $_.Exception.message
                        Write-Error ("Error stopping the VM $VM : " + $ErrorMessage)
                        Break
                    }
                }   
            }  # end of 'switch'

        } # end of 'for each'
    } # end of weekend check
}
foreach($VM in $VMs){
    $status = (Get-AzVM -ResourceGroupName $resourcegroup -Name $VM -Status -DefaultProfile $AzureContext).Statuses[1].Code
        Write-Output "`r`n $VM VM status: $status `r`n `r`n"
}
Write-Output "Script ended at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"