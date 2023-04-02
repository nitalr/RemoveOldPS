$PowerShellVersion = $PSVersionTable.PSVersion.Major

if ($PowerShellVersion -ge 5) {
    Write-Host "PowerShell version is equal or higher than 5.0: $($PSVersionTable.PSVersion)"
    Write-Host "Checking if PowerShell v2 is enabled..."

    # Check if PowerShell v2 is enabled
    $PSv2Feature = Get-WindowsOptionalFeature -Online -FeatureName 'MicrosoftWindowsPowerShellV2'

    if ($PSv2Feature.State -eq 'Enabled') {
        Write-Host "PowerShell v2 is enabled. Disabling PowerShell v2..."

        # Disable PowerShell v2
        Disable-WindowsOptionalFeature -Online -FeatureName 'MicrosoftWindowsPowerShellV2' -NoRestart
        Write-Host "PowerShell v2 has been disabled."
    } else {
        Write-Host "PowerShell v2 is not enabled."
    }
    # trying to remove old versions
    Uninstall-WindowsFeature -Name PowerShell-V2
    $oldPowerShell = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -match 'Windows PowerShell' -and $_.Version -lt '5.0' }
if ($oldPowerShell) {
    $oldPowerShell | ForEach-Object { 
        Write-Host "Uninstalling $($_.Name) Version: $($_.Version)"
        $uninstallResult = $_.Uninstall()
        if ($uninstallResult.ReturnValue -eq 0) {
            Write-Host "$($_.Name) version $($_.Version) has been uninstalled successfully."
        } else {
            Write-Host "Failed to uninstall $($_.Name) version $($_.Version). Error code: $($uninstallResult.ReturnValue)"
            }
        } 

} else {
    Write-Host "PowerShell version lower than 5 detected: $($PSVersionTable.PSVersion)"
    Write-Host "trying to install newer version"
    winget install --id Microsoft.Powershell --source winget #Online option
    # For other options please look at https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3
    Write-Host "After the next reboot the script will remove the old version"
}
