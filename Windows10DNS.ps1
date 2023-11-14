If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    $title = ''
    $question = 'This script need to Run as an Administrator in order to continue.

        Select "Yes" to Run as an Administrator

        Select "No" to not run this as an Administrator and to stop the script

        '


    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 1) {
        Write-Host 'This script need to Run as an Administrator, exiting.'
        exit
    }
    #elevate script and exit current non-elevated runtime
    Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`" $($env:LOCALAPPDATA)" -f $PSCommandPath) -Verb RunAs
    exit
}

Start-Sleep 10

#example program, this will be ran as admin
$userProfile = $args[0]

$FileUri = "https://damsdev1.github.io/DNS/DnsJumper.exe"
$Destination = "$($userProfile)\temp\dnsjumper-4.exe"

Invoke-WebRequest -Uri $FileUri -OutFile $Destination

# Start-Process -Wait $Destination
# exit