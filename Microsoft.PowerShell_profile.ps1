# Initial GitHub.com connectivity check with 1 second timeout
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

# Set execution policy to Unrestricted
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force

# Function to check if Conda is installed
function Test-CondaInstalled {
    try {
        conda --version > `$null 2>&1
        return `$true
    } catch {
        return `$false
    }
}

# Function to install Miniconda
function Install-Conda {
    `$minicondaInstaller = 'Miniconda3-latest-Windows-x86_64.exe'
    `$minicondaUrl = 'https://repo.anaconda.com/miniconda/' + $minicondaInstaller
    `$installerPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), $minicondaInstaller)
    Invoke-WebRequest -Uri `$minicondaUrl -OutFile `$installerPath
    Start-Process `$installerPath -ArgumentList '/InstallationType=JustMe', '/RegisterPython=0', '/S', '/D=$env:LOCALAPPDATA\Continuum\miniconda3' -Wait
    Remove-Item `$installerPath -Force
    `$condaPath = [System.IO.Path]::Combine(`$env:LOCALAPPDATA, 'Continuum', 'miniconda3', 'Scripts')
    `$env:Path += ';' + `$condaPath
    & `$condaPath\conda init powershell
}

# Check if Conda is installed
if (-not (Test-CondaInstalled)) {
    Write-Host 'Conda is not installed. Installing Miniconda...' -ForegroundColor Yellow
    Install-Conda
    Write-Host 'Miniconda installed. Please restart your PowerShell session.' -ForegroundColor Green
} else {
    # Initialize Conda
    `$condaScript = & "$([System.Environment]::GetEnvironmentVariable('CONDA_PREFIX') + '\etc\profile.d\conda_hook.ps1')" | Out-String
    Invoke-Expression `$condaScript
    conda activate base
}

# Import Modules and External Profiles
# Ensure Terminal-Icons module is installed before importing
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons


Import-Module Catppuccin
$Flavor = $Catppuccin['Mocha']

function prompt {
    $(if (Test-Path variable:/PSDebugContext) { "$($Flavor.Red.Foreground())[DBG]: " }
      else { '' }) + "$($Flavor.Teal.Foreground())PS $($Flavor.Yellow.Foreground())" + $(Get-Location) +
        "$($Flavor.Green.Foreground())" + $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> ' + $($PSStyle.Reset)
}

# The following colors are used by PowerShell's formatting
# Again PS 7.2+ only
$PSStyle.Formatting.Debug = $Flavor.Sky.Foreground()
$PSStyle.Formatting.Error = $Flavor.Red.Foreground()
$PSStyle.Formatting.ErrorAccent = $Flavor.Blue.Foreground()
$PSStyle.Formatting.FormatAccent = $Flavor.Teal.Foreground()
$PSStyle.Formatting.TableHeader = $Flavor.Rosewater.Foreground()
$PSStyle.Formatting.Verbose = $Flavor.Yellow.Foreground()
$PSStyle.Formatting.Warning = $Flavor.Peach.Foreground()

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
        Write-Error "Unable to check for `$profile updates"
    } finally {
        Remove-Item "$env:temp/Microsoft.PowerShell_profile.ps1" -ErrorAction SilentlyContinue
    }
}
Update-Profile


oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/robbyrussell.omp.json | Invoke-Expression