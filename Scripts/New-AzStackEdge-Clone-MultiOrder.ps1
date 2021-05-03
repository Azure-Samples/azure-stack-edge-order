<#
.DESCRIPTION
    This script creates multiple orders for Azure Stack Edge device by cloning an existing order/resource.
    
    Prerequisites: This script requires the Azure PowerShell. For more information, refer https://docs.microsoft.com/powershell/azure/.
    ----------------------------
    ----------------------------   

    

.PARAMS
    SubscriptionId: Input the Azure Account Subscription Id.
    ResourceGroupName: Input the Azure Resource Group Name.
    Location: Input the location of device.
    OrderCount: Number of orders to be created.
    DeviceName: Input the name of the device.
    SKU: Input the exact SKU type of Azure Stack Edge that you are looking to order. 
	 Following can be the SKU types:
         Edge ---> Use this to order Azure Stack Edge Pro - FPGA
         EdgeP_Base ---> Use this to order Azure Stack Edge Pro - 1GPU
         EdgeP_High --> Use this to order Azure Stack Edge Pro - 2GPU
#>

param(
    [parameter(Mandatory = $true, HelpMessage = "Input the subscription id.")]
    [String] $SubscriptionId,

    [parameter(Mandatory = $true, HelpMessage = "Input the name of the resource group where device exists.")]
    [string] $ResourceGroupName,
    
    [parameter(Mandatory = $true, HelpMessage = "Input the name of the device to clone.")]
    [string] $DeviceName,

    [parameter(Mandatory = $true, HelpMessage = "Number of orders to be created.")]
    [string] $OrderCount,

    [parameter(Mandatory = $true, HelpMessage = "Refer PARAMS section for permissible SKU values")]
    [string] $Sku

)


function Login($SubscriptionId) {
    $context = Get-AzContext

    if (!$context -or ($context.Subscription.Id -ne $SubscriptionId)) {
        Connect-AzAccount -Subscription $SubscriptionId
    } 
    else {
        Write-Host "SubscriptionId '$SubscriptionId' already connected"
    }
}
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
            if (!$deviceDetails) {
                $DeviceDetails = Get-AzStackEdgeDevice -ResourceGroupName $ResourceGroupName -DeviceName $DeviceName -ErrorAction Stop
                PrettyWriter "Getting Device Details"

                New-AzStackEdgeDevice -ResourceGroupName $ResourceGroupName -Name $DeviceName"-"$i  -Location $DeviceDetails.EdgeDevice.Location -Sku $Sku
                New-AzStackEdgeOrder -ResourceGroupName $ResourceGroupName -DeviceName $DeviceName"-"$i -ContactPerson $orderDetails.StackEdgeOrder.ContactInformation.ContactPerson -CompanyName $orderDetails.StackEdgeOrder.ContactInformation.CompanyName -Phone $orderDetails.StackEdgeOrder.ContactInformation.Phone -Email $orderDetails.StackEdgeOrder.ContactInformation.EmailList -AddressLine1 $orderDetails.StackEdgeOrder.ShippingAddress.AddressLine1 -PostalCode $orderDetails.StackEdgeOrder.ShippingAddress.PostalCode -City $orderDetails.StackEdgeOrder.ShippingAddress.City -State $orderDetails.StackEdgeOrder.ShippingAddress.State -Country $orderDetails.StackEdgeOrder.ShippingAddress.Country
                $result += $DeviceName + "-" + $i + " resource created and order placed successfully"
            }
            else {
                $result += $DeviceName + "-" + $i + " resource already exists"
            }
        }
        catch {
            
            $device = Get-AzStackEdgeDevice -ResourceGroupName $ResourceGroupName -Name $DeviceName"-"$i -ErrorAction SilentlyContinue
            if ($device) {
            
                Remove-AzStackEdgeDevice -DeviceObject $device
            }

            $order = Get-AzStackEdgeOrder -ResourceGroupName $ResourceGroupName -DeviceName $DeviceName"-"$i -ErrorAction SilentlyContinue
            if ($order) {
            
                Remove-AzStackEdgeOrder -DeviceObject $order
            }
            $result += $DeviceName + "-" + $i + "resource creation failed"
            
        }
    }
    PrettyWriter "Script execution successful."
    PrettyWriter "----------------------------"
    $result   
}	
