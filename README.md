---
title: Create multiple orders in Azure Stack Edge using scripts
description: Batch-create orders in Azure Stack Edge by starting from scratch or cloning an existing order using Azure PowerShell.
services: databox
author: v-dalc

ms.service: databox
ms.subservice: pod
ms.topic: sample
ms.date: 10/08/2020
ms.author: alkohli

# Customer intent: As an IT admin, I want to quickly create multiple orders in Azure Stack Edge using familiar PowerShell cmdlets.
---

# Create multiple orders in Azure Stack Edge using Azure PowerShell

Use the `New-AzStackEdgeMultiOrder.ps1` script to create multiple orders in Azure Stack Edge from scratch or by copying an existing order.
<!--Use these two scripts to create multiple orders in Azure Stack Edge from scratch or by cloning an existing order.-->

## Prerequisites

Before you begin, make sure you have:

- Windows client
- Azure subscription to use for your Azure Stack Edge resources
- Resource group to use to manage the resources
- Azure PowerShell
- `New-AzStackEdgeMultiOrder.ps1` script stored in a convenient location
<!--- Scripts - New-AzStackEdgeMultiOrder.ps1 and New-AzStackEdge-Clone-MultiOrder.ps1 - in a convenient location-->

### Install Azure PowerShell

1. Install PowerShell v6 or later. For guidance, see [Install Azure PowerShell](/powershell/azure/install-az-ps?view=azps-4.7.0).

2. Install the Az.Resources and Az.StackEdge modules in PowerShell. You will need to run PowerShell as Administrator.

   1. If AzureRM is installed, uninstall it:

      ```powershell
      PS C:\> Uninstall-AzureRm
      ```

   1. Install the Az.Resources and Az.StackEdge modules:

      ```powershell
      PS C:\> Install-Module Az.Resources
      PS C:\> Install-Module Az.StackEdge
      ```

      > [!NOTE]
      > If AzureRM is installed, you'll need to uninstall it.

### Download the script

<!--Throughout section, I converted plural "scripts" to singular "scripts" - not tracked in comments.-->1. Go to [azure-stack-edge-order in Azure Samples](https://github.com/Azure-Samples/azure-stack-edge-order).

1. Download or clone the zip file for the script.

   ![Download zip file](./azure-stack-edge-order-download-clone-scripts.png)

    Extract the files from the zip, and note where you saved the script.

    You can also clone the samples:

     ```json
     git clone https://github.com/Azure-Samples/azure-stack-edge-order.git
     ```

## Run the script

1. Open Azure PowerShell as Administrator.
1. Set your execution policy to **Unrestricted**. This is needed because the script is an unsigned script.

   ```azurepowershell
   Set-ExecutionPolicy Unrestricted
   ```

1. Change directories to the directory where you stored the script. For example:

```azurepowershell
cd scripts
```

2.  Run the script. To run `New-AzStackEdgeMultiOrder.ps1`, you would type the following:

```azurepowershell
& '.\New-AzStackEdgeMultiOrder.ps1'
```
3. With an **Unrestricted** execution policy <!--and an unsigned script?-->, you'll see the following text. Type `R` to run the script.

```azurepowershell
Security warning
Run only scripts that you trust. While scripts from the internet can be useful, this script can potentially harm your computer.
If you trust this script, use the Unblock-File cmdlet to allow the script to run without this warning message. Do you want to
run C:\scripts\New-AzStackEdgeMultiOrder.ps1?
[D] Do not run  [R] Run once  [S] Suspend  [?] Help (default is "D"): R
```

### New-AzStackEdgeMultiOrder.ps1

Use this script to create one or more orders for Azure Stack Edge at once. You can create completely new orders or copy an existing order.

#### Usage notes

You'll need to provide an Azure subscription ID, resource group, the region where the new Azure Stack Edge resources will be created and other order details. If you are copying an existing order, you will provide the device name and order information from that order.

<!--If you'd rather base your new orders on an existing order, use `New-AzStackEdge-Clone-MultiOrder.ps1` instead.-->

#### Parameter info

- `DeviceName` becomes the name for the new Azure Stack Edge orders. For example, **mydevice** becomes mydevice-0, mydevice-1, and so forth. <!--Following sentence is new.-->If you are copying an existing order, use that order name.

- `OrderCount` is the total number of orders that you want to create. If you are copying an existing order, enter the total number of orders to create. For example, if you have two copies of an existing order (say, uswest-0 and uswest-1), and you want to add three new orders, enter 5 as the `OrderCount`. The three new orders (uswest-3, uswest-4, and uswest-5) will be added to the existing orders.

- `SKU` indicates the configuration of Azure Stack Edge device to order:
  - `Edge` - Azure Stack Edge Pro - FPGA
  - `EdgeP_Base` - Azure Stack Edge Pro - 1 GPU
  - `EdgeP_High` - Azure Stack Edge Pro - 2 GPU
- `ResoureGroupName` - Enter a resource group to use with the order.

#### Sample output 1: Create new orders

The following is sample output from running `New-AzStackEdgeMultiOrder.ps1` to create two orders at the same time. This order is created from scratch. There are no existing orders with the device name.

```azurepowershell
PS C:> Set-ExecutionPolicy Unrestricted
PS C:> cd scripts
PS C:\scripts> & '.\New-AzStackEdgeMultiOrder.ps1'

Security warning
Run only scripts that you trust. While scripts from the internet can be useful, this script can potentially harm your computer.
If you trust this script, use the Unblock-File cmdlet to allow the script to run without this warning message. Do you want to
run C:\scripts\New-AzStackEdgeMultiOrder.ps1?
[D] Do not run  [R] Run once  [S] Suspend  [?] Help (default is "D"): R

cmdlet New-AzStackEdgeMultiOrder.ps1 at command pipeline position 1
Supply values for the following parameters:
(Type !? for Help.)
SubscriptionId: ab1c2def-3g45-6h7i-j8kl-901234567890
ResourceGroupName: myaseresourcegroup
Location: West Europe
OrderCount: 2
DeviceName: myasegpu1
ContactPerson: Gus Poland
CompanyName: Contoso LTD
Phone: 4085555555
Email: gusp@contoso.com
AddressLine1: 1020 Enterprise Way
PostalCode: 94089
City: Sunnyvale
State: CA
Country: USA
Sku: GPU
Setting context

Name                                     Account        SubscriptionNa Environment    TenantId
                                                        me
----                                     -------        -------------- -----------    --------
ContosoWE (ab1c2def-3g45-6h7i... gusp@con... Edge Gatewa... AzureCloud     12a345bc-6...

ResourceGroupName : myaseresourcegroup
EdgeDevice        : Microsoft.Azure.Management.DataBoxEdge.Models.DataBoxEdgeDevice
Name              : myasegpu1-0
Id                : /subscriptions/ab1c2def-3g45-6h7i-j8kl-901234567890/resourceGroups/myaseresourcegroup/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/myasegpu1-0
ExtendedInfo      :
UpdateSummary     :
Alert             :
NetworkSetting    :


ResourceGroupName : myaseresourcegroup
EdgeDevice        : Microsoft.Azure.Management.DataBoxEdge.Models.DataBoxEdgeDevice
Name              : myasegpu1-1
Id                : /subscriptions/ab1c2def-3g45-6h7i-j8kl-901234567890/resourceGroups/myaseresourcegroup/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/myasegpu1-1
ExtendedInfo      :
UpdateSummary     :
Alert             :
NetworkSetting    :

Script execution successful.
----------------------------
myasegpu1-0 resource created and order placed successfully
myasegpu1-1 resource created and order placed successfully
```

### Sample output 2: Copy an existing order

The following sample output is from running `New-AzStackEdgeMultiOrder.ps1` a second time, when two orders already exist and a total of five orders are needed. `OrderCount` was set to the total number of orders needed. The script found the existing two orders and added three more.

```azurepowershell
PS C:> cd scripts
PS C:\scripts> & '.\New-AzStackEdgeMultiOrder.ps1'

Security warning
Run only scripts that you trust. While scripts from the internet can be useful, this script can potentially harm your computer. If you trust this script, use the Unblock-File cmdlet to allow the script
 to run without this warning message. Do you want to run C:\scripts\New-AzStackEdgeMultiOrder.ps1?
[D] Do not run  [R] Run once  [S] Suspend  [?] Help (default is "D"): R

cmdlet New-AzStackEdgeMultiOrder.ps1 at command pipeline position 1
Supply values for the following parameters:
(Type !? for Help.)
SubscriptionId: ab1c2def-3g45-6h7i-j8kl-901234567890
ResourceGroupName: myaseresourcegroup
Location: West Europe
OrderCount: 5
DeviceName: myasegpu1
ContactPerson: Gus Poland
CompanyName: Contoso LTD
Phone: 4085555555
Email: gusp@contoso.com
AddressLine1: 1020 Enterprise Way
PostalCode: 94089
City: Sunnyvale
State: CA
Country: United States
Sku: GPU

Setting context

-----CUT-----CUT-----CUT-----CUT-----CUT-----

Script execution successful.
----------------------------
myasegpu1-0 resource already exists
myasegpu1-1 resource already exists
myasegpu1-2 resource created and order placed successfully
myasegpu1-3 resource created and order placed successfully
myasegpu1-4 resource created and order placed successfully
```

<!--### New-AzStackEdge-Clone-MultiOrder.ps1

This script creates one or more new orders for Azure Stack Edge devices by cloning an existing order or resource.

#### Usage notes

You'll need to provide the subscription ID, and resource group to use for the order, and the device name, to identify the order to clone.

You will set the region where the new Azure resources will be created and the configuration of Azure Stack Edge to order. Contact and address info from the existing order will be used.

#### Parameter info

- For `DeviceName`, enter the friendly name of the existing device. Order names will be based on the device name. For example, **mydevice** becomes mydevice-0, mydevice-1, and so forth.

- `OrderCount` - TK 

- `SKU` indicates the Azure Stack Edge SKU type to order:<!--Can they specify a different>
  - `Edge` - Azure Stack Edge Pro - FPGA
  - `EdgeP_Base` - Azure Stack Edge Pro - 1GPU
  - `EdgeP_High` - Azure Stack Edge Pro - 2 GPU

### Sample output

The following is sample output for three orders cloned from an existing order by running `New-AzStackEdge-Clone-MultiOrder.ps1`.

```azurepowershell
PLACEHOLDER
```-->
