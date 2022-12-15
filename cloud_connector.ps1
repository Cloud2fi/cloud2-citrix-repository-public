<#
    .SYNOPSIS
        Downloads and configures Citrix Cloud Connector application.
#>

Param (
    [string]$customerName,
    [string]$clientId,
    [string]$clientSecret,
    [string]$resourceLocationId
)

# Force use of TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Folders
if (Test-Path -Path "c:\temp") {
} else { New-Item -ItemType Directory c:\temp }

# Download Citrix Cloud Connector installer
Invoke-WebRequest "https://downloads.cloud.com/cloudconnector/connector/cwcconnector.exe" -OutFile "C:\temp\cwcconnector.exe"

# Create JSON file used by Cloud Connector installer
New-Object -TypeName PSCustomObject -Property @{customerName=$customerName;clientId=$clientId;clientSecret=$clientSecret;resourceLocationId=$resourceLocationId;acceptTermsOfService="true"} | ConvertTo-Json | Out-File "C:\temp\cwcconnector.json" 

# Install Citrix Cloud Connector using JSON parameters file
C:\temp\cwcconnector.exe /q /ParametersFilePath:c:\temp\cwcconnector.json

# Cleanup created files
Remove-Item -Path c:\temp\cwcconnector.json
Remove-Item -Path c:\temp\cwcconnector.exe
