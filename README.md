# PowershellDSC.DotNet462
A DSC configuation for installing .NET 4.6.2

Usage in ARM template:

```json
    {
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "name": "[concat(parameters('vmName'),'/dscExtension'))]",
      "apiVersion": "2015-05-01-preview",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "[concat('Microsoft.Compute/virtualMachines/', parameters('vmName'))]"
      ],
      "properties": {
        "publisher": "Microsoft.Powershell",
        "type": "DSC",
        "typeHandlerVersion": "2.19",
        "autoUpgradeMinorVersion": true,
        "settings": {
          "ModulesUrl": "",
          "ConfigurationFunction": "DotNet462.ps1\DotNet462"
        },
        "protectedSettings": null
      }
    }
```
