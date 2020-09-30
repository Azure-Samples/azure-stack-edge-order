<#
.DESCRIPTION
    This script creates multiple orders for Azure Stack Edge device.
    
    Prerequisites: This script requires the Azure PowerShell. For more information, refer https://docs.microsoft.com/powershell/azure/.
    ----------------------------
    ----------------------------   

        To pass all the parameter value in the script, change the value of Mandatory to false and pass the value as shown in example below.
    
    [parameter(Mandatory = $false, HelpMessage = "Input the subscription id.")]
    [String] $SubscriptionId = "1222121"


.PARAMS
    SubscriptionId: Input the Azure Account Subscription Id.
    ResourceGroupName: Input the Azure Resource Group Name.
    Location: Input the location of device.
    OrderCount: Number of orders to be created.
    DeviceName: Input the name of the device.
    ContactPerson: Input the name of the contact person.
    CompanyName: Input the name of the company.
    Phone: Input the phone number of contact person.
    Email: Input the user email.
    AddressLine1: Input the adress for the delivery of the device.
    PostalCode: Input the postal code for the delivery of the devie.
    City: Input the city for the delivery of the device.
    State: Input the state for device delivery.
    Country: Input the country for device delivery.
    SKU: Use value as Edge for FPGA device and GPU for GPU device.
#>

param(
    [parameter(Mandatory = $true, HelpMessage = "Input the subscription id.")]
    [String] $SubscriptionId,

    [parameter(Mandatory = $true, HelpMessage = "Input the name of the resource group where order will get created.")]
    [string] $ResourceGroupName,

    [parameter(Mandatory = $true, HelpMessage = "Input the location for the device.")]
    [string] $Location,
    
    [parameter(Mandatory = $true, HelpMessage = "Number of orders to be created.")]
    [string] $OrderCount,
    
    [parameter(Mandatory = $true, HelpMessage = "Input the name of the device.")]
    [string] $DeviceName,

    [parameter(Mandatory = $true, HelpMessage = "Input the contact person's name.")]
    [string] $ContactPerson,

    [parameter(Mandatory = $true, HelpMessage = "Input the name of the company.")]
    [string] $CompanyName,

    [parameter(Mandatory = $true, HelpMessage = "Input the phone number of contact person.")]
    [string] $Phone,

    [parameter(Mandatory = $true, HelpMessage = "Input the email of contact person.")]
    [string] $Email,

    [parameter(Mandatory = $true, HelpMessage = "Input the address for delivery.")]
    [string] $AddressLine1,

    [parameter(Mandatory = $true, HelpMessage = "Input the postal code for device delivery.")]
    [string] $PostalCode,

    [parameter(Mandatory = $true, HelpMessage = "Input the city for device delivery.")]
    [string] $City,

    [parameter(Mandatory = $true, HelpMessage = "Input the state for device delivery.")]
    [string] $State,

    [parameter(Mandatory = $true, HelpMessage = "Input the country for device delivery.")]
    [string] $Country,

    [parameter(Mandatory = $true, HelpMessage = "Use value as Edge for FPGA device and GPU for GPU device.")]
    [string] $Sku

)

function ValidateInputs() {

    $subs = Get-AzSubscription
    if (!$subs.Id.Contains($SubscriptionId)) { 
        throw [System.ArgumentException] "Subscription Id provided does not exists in current account."
    }

}




# Print method
Function PrettyWriter($Content, $Color = "Yellow") { 
    Write-Host $Content -Foregroundcolor $Color 
}

#Connect to Azure
#Connect-AzAccount

#Set Context
$subs = Get-AzSubscription | where Id -Eq $SubscriptionId
if ($subs.length -eq 0) {
    throw [System.ArgumentException] "$SubscriptionId does not exists in current account."
} 
else {
    PrettyWriter "Setting context"
    Set-AzContext -SubscriptionId $SubscriptionId
}

#Configure Device
$resGrp = Get-AzResourceGroup | where ResourceGroupName -Eq $ResourceGroupName
if ($subs.length -eq 0) {
    throw [System.ArgumentException] "$ResourceGroupName, was not found in the Azure account provided."
} 
else {
    $result = @()
    for ($i = 0; $i -lt $OrderCount; $i++) { 
        
        try {
            
            $deviceDetails = Get-AzStackEdgeDevice -ResourceGroupName $ResourceGroupName -DeviceName $DeviceName"-"$i -ErrorAction SilentlyContinue
            if(!$deviceDetails)
            {
                
                New-AzStackEdgeDevice -ResourceGroupName $ResourceGroupName -Name $DeviceName"-"$i  -Location $Location -Sku $Sku
                #Use Sku Parameter value as Edge for FPGA device and GPU for GPU device.
                
                #Create Order
                New-AzStackEdgeOrder -ResourceGroupName $ResourceGroupName -DeviceName $DeviceName"-"$i -ContactPerson $ContactPerson  -CompanyName $CompanyName -Phone $Phone -Email $Email -AddressLine1 $AddressLine1 -PostalCode $PostalCode -City $City -State $State -Country $Country
                
                $result += $DeviceName+"-"+$i+" resource created and order placed successfully"
            }
            else {
                $result += $DeviceName+"-"+$i+" resource already exists"
            }
            
        }
        catch {
            
            $device = Get-AzStackEdgeDevice -ResourceGroupName $ResourceGroupName -Name $DeviceName"-"$i
            if ($device) {
            
                Remove-AzStackEdgeDevice -DeviceObject $device
            }

            $order = Get-AzStackEdgeOrder -ResourceGroupName $ResourceGroupName -DeviceName $DeviceName"-"$i
            if ($order) {
            
                Remove-AzStackEdgeOrder -DeviceObject $order
            }
            $result += $DeviceName+"-"+$i+" resource creation failed"
            
        }
    }
    PrettyWriter "Script execution successful."
    PrettyWriter "----------------------------"
    $result
    
}	