# Initial GitHub.com connectivity check with 1 second timeout
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

# Define the content to set the execution policy and initialize conda
# Set execution policy to Unrestricted
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force

# Function to check if Conda is installed
function Test-CondaInstalled {
    try {
        conda --version > $null 2>&1
        return $true
    } catch {
        return $false
    }
}

# Check if Conda is installed
if (-not (Test-CondaInstalled)) {
    Write-Host 'Conda is not installed. Please install Conda from https://docs.conda.io/en/latest/miniconda.html' -ForegroundColor Yellow
}

# Import Modules and External Profiles
# Ensure Terminal-Icons module is installed before importing
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons

# Check for Profile Updates
function Update-Profile {
    if (-not $global:canConnectToGitHub) {
        Write-Host "Skipping profile update check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
        return
    }

    try {
        $url = "https://raw.githubusercontent.com/lwidm/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
        $oldhash = Get-FileHash $PROFILE
        Invoke-RestMethod $url -OutFile "$env:temp/Microsoft.PowerShell_profile.ps1"
        $newhash = Get-FileHash "$env:temp/Microsoft.PowerShell_profile.ps1"
        if ($newhash.Hash -ne $oldhash.Hash) {
            $sourcePath = "$env:temp/Microsoft.PowerShell_profile.ps1"
            $destinationDir = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($PROFILE), "powershell-profile")
            $destinationPath = [System.IO.Path]::Combine($destinationDir, "Microsoft.PowerShell_profile.ps1")

            Copy-Item -Path $sourcePath -Destination $destinationPath -Force
            Write-Host "Profile has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
        }
    } catch {
        Write-Error "Unable to check for $profile updates"
    } finally {
        Remove-Item "$env:temp/Microsoft.PowerShell_profile.ps1" -ErrorAction SilentlyContinue
    }
}
Update-Profile

$profile_path = ([System.IO.Path]::GetDirectoryName($PROFILE))
$theme_path = "$profile_path/powershell-profile/oh-my-posh_themes/robbyrussel_lwidm.omp.json"
oh-my-posh init pwsh --config $theme_path | Invoke-Expression
# oh-my-posh init pwsh --config https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/robbyrussell.omp.json | Invoke-Expression

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
} else {
    Write-Host "zoxide command not found. Attempting to install via winget..."
    try {
        winget install -e --id ajeetdsouza.zoxide
        Write-Host "zoxide installed successfully. Initializing..."
        Invoke-Expression (& { (zoxide init powershell | Out-String) })
    } catch {
        Write-Error "Failed to install zoxide. Error: $_"
    }
}

New-Alias -Name ll -Value ls
New-Alias -Name which -Value Get-Command

# create equivalent of sudo command in linux
function sudo {
    param(
        [string]$command
    )
    Start-Process powershell -ArgumentList "-Command $command" -Verb RunAs
}
