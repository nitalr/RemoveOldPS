# RemoveOldPS
To enhance security, it is recommended to remove old PowerShell versions such as PowerShell V2.
This script is designed to remove old powershell versions (Lower then 5) that are not supporting audit configuration and AMSI protection.
If PowerShell version 3 or 4 is present, the first time the script is run, it will install the latest version of PowerShell from the official Microsoft repository. After the second script run, old versions will be removed to ensure that functionality is not broken.
