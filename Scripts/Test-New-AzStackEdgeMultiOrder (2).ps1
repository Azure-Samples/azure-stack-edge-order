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
    [parameter(Mandatory = $false, HelpMessage = "Input the subscription id.")]
    [String] $SubscriptionId = "db4e2fdb-6d80-4e6e-b7cd-736098270664"

    [parameter(Mandatory = $false, HelpMessage = "Input the name of the resource group where order will get created.")]
    [string] $ResourceGroupName = "myasepgpurg"

    [parameter(Mandatory = $false, HelpMessage = "Input the location for the device.")]
    [string] $Location = "centraluseuap"    
    
    [parameter(Mandatory = $false, HelpMessage = "Number of orders to be created.")]
    [string] $OrderCount = "2"
    
    [parameter(Mandatory = $false, HelpMessage = "Input the name of the device.")]
    [string] $DeviceName = "myasegpu1"

    [parameter(Mandatory = $false, HelpMessage = "Input the contact person's name.")]
    [string] $ContactPerson = "Gus Poland"

    [parameter(Mandatory = $false, HelpMessage = "Input the name of the company.")]
    [string] $CompanyName = "Contoso"

    [parameter(Mandatory = $false, HelpMessage = "Input the phone number of contact person.")]
    [string] $Phone = "4085555555"

    [parameter(Mandatory = $false, HelpMessage = "Input the email of contact person.")]
    [string] $Email = "gus@contoso.com"

    [parameter(Mandatory = $false, HelpMessage = "Input the address for delivery.")]
    [string] $AddressLine1 = "1020 Enterprise Way"

    [parameter(Mandatory = $false, HelpMessage = "Input the postal code for device delivery.")]
    [string] $PostalCode = "94089"

    [parameter(Mandatory = $false, HelpMessage = "Input the city for device delivery.")]
    [string] $City - "Sunnyvale"

    [parameter(Mandatory = $false, HelpMessage = "Input the state for device delivery.")]
    [string] $State = "California"

    [parameter(Mandatory = $false, HelpMessage = "Input the country for device delivery.")]
    [string] $Country = "United States"

    [parameter(Mandatory = $false, HelpMessage = "Use value as Edge for FPGA device and GPU for GPU device.")]
    [string] $Sku = "GPU"

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