﻿#Requires -Version 5.0
#Requires -Modules Az.Sql

<#
    .SYNOPSIS
        Gets one or more databases
    
    .DESCRIPTION  
        
    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module Az
        Requires Library script AzureAzLibrary.ps1

    .LINK
        https://github.com/scriptrunner/ActionPacks/blob/master/Azure        

    .Parameter AzureCredential
        The PSCredential object provides the user ID and password for organizational ID credentials, or the application ID and secret for service principal credentials

    .Parameter Tenant
        Tenant name or ID

    .Parameter DBName
        Specifies the name of the database to retrieve

    .Parameter ServerName
        Specifies the name of the server to which the database is assigned

    .Parameter ResourceGroupName
        Specifies the name of the resource group to which the database server is assigned
        
    .Parameter Properties
        List of properties to expand, comma separated e.g. Name,Location. Use * for all properties
#>

param( 
    [Parameter(Mandatory = $true)]
    [pscredential]$AzureCredential,    
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,
    [Parameter(Mandatory = $true)]
    [string]$ServerName,
    [string]$DBName,
    [ValidateSet('*','ResourceGroupName','ServerName','DatabaseName','Location','DatabaseId','Edition','CollationName','Status','CreationDate','Tags')]
    [string[]]$Properties = @('ResourceGroupName','ServerName','DatabaseName','Location','DatabaseId','Edition','CollationName','Status','CreationDate','Tags'),
    [string]$Tenant
)

Import-Module Az

try{
 #   ConnectAzure -AzureCredential $AzureCredential -Tenant $Tenant
    if($Properties -contains '*'){
        $Properties = @('*')
    }
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'ServerName' = $ServerName
                            'ResourceGroupName' = $ResourceGroupName}
    
    if([System.String]::IsNullOrWhiteSpace($DBName) -eq $false){
        $cmdArgs.Add('DatabaseName',$DBName)
    }

    $ret = Get-AzSqlDatabase @cmdArgs | Select-Object $Properties

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $ret 
    }
    else{
        Write-Output $ret
    }
}
catch{
    throw
}
finally{
 #   DisconnectAzure -Tenant $Tenant
}