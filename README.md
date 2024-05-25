# Welcome to my PowerShell Config!

This repository sets up a powerful and visually appealing PowerShell environment, including automatic updating.
Features:
- Latest PowerShell (v7): Ensure top performance and features.
- Custom Themes: Choose from Catppuccin themes like frappe, latte, macchiato, and mocha.
- Prompt Enhancement: install Oh My Posh with the robbyrussel theme
- Python Management: Setup and manage Anaconda.
- Custom Fonts: Install Hack Nerd Font for easily readable text and icon display.
- Automatic Updating: Profile config performs automatic updates buy syncing with the github repo.

## Setup Guide

This guide will help you set up your PowerShell profile with the latest version of PowerShell, a custom theme, and various useful tools.

### Install the Newest Version of PowerShell

Ensure you have PowerShell 7 installed. You can install it using `winget`:

1. **Search for PowerShell:**
    ```powershell
    winget search Microsoft.PowerShell
    ```

    Output:
    ```
    Name               Id                           Version   Source
    -----------------------------------------------------------------
    PowerShell         Microsoft.PowerShell         7.4.2.0   winget
    PowerShell Preview Microsoft.PowerShell.Preview 7.5.0.2   winget
    ```

2. **Install PowerShell:**
    ```powershell
    winget install --id Microsoft.Powershell --source winget
    ```

#### Or Upgrading PowerShell

For best results when upgrading, use the same install method you used when you first installed PowerShell. You can determine the install method by checking the value of `$PSHOME`.

- **Instructions on Upgrading:**  
  [Microsoft Documentation](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4#install-powershell-using-winget-recommended)

- **Check if Upgrade is Available:**
    ```powershell
    winget list --name PowerShell --upgrade-available
    ```

### Initial Setup Using Settings GUI

1. Right-click a new PowerShell window and select **Settings**.
2. Make PowerShell 7 the default.
3. Set PowerShell to open in maximized mode.

### Catppuccin Theme
Open the [Catppucin windows terminal github repo](https://github.com/catppuccin/windows-terminal) and follow these instructions:

1. Launch Windows Terminal.
2. Open the Settings panel (`Ctrl + ,`).
3. Select **Open JSON file** at the bottom left corner (`Ctrl + Shift + ,`).
4. Choose your flavour (frappe, latte, macchiato, mocha).
5. Copy the contents of `flavour.json` (e.g., `frappe.json`) into the opened JSON file under `"schemes"`.
6. Copy the contents of `flavourTheme.json` (e.g., `frappeTheme.json`) into the opened JSON file under `"themes"`.
7. Save and exit.
8. In the Settings panel under **Profiles**, select the profile you want to apply the theme to. Defaults will apply the theme to all profiles.
9. Select **Appearance**.
10. Choose your Catppuccin flavor in the **Color scheme** drop-down menu.
11. Click on **Save**, enjoy!

### Oh My Posh

Install `oh-my-posh` using `winget`:

```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
```

### Hack nerd font
1. shallow clone the `ryanoasis/nerd-font` repo
```powershell
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts
```
2. Open the downloaded folder and run:
```powershell
.\install.ps1 Hack
```
3. Open the widows terminal settings and set the Hack nerd font as the default font



### Load and Setup Configurations
Clone the repository for your PowerShell profile:

1. Open powershell and run
```powershell
cd ([System.IO.Path]::GetDirectoryName($PROFILE))
git clone https://github.com/lwidm/powershell-profile
```
2. Create a symbolic lin
    - Open powershell in administrator mode
    - Run:
```powershell
cd ([System.IO.Path]::GetDirectoryName($PROFILE))
New-Item -ItemType SymbolicLink -Path Microsoft.PowerShell_profile.ps1 -Target .\powershell-profile\Microsoft.PowerShell_profile.ps1
```
3. Conda setup
    1. Install anaconda from the [official anaconda website](https://www.anaconda.com/download).
    2. During installation, make sure to add conda to your system PATH.
        - you can either do this using the installation gui or manually.
        - the binaries are usually located at
            - C:\Users\lukas\anaconda3\Scripts
            - C:\Users\lukas\anaconda3\Library\
    3. initialize anaconda by obening PowerShell and running:
```powershell
conda init
```
    4. close and reopen PowerShell
    5. Create, activate and test whether conda environment is working. Open PowerShell and run
```powershell
conda create -n testENv
conda activate testEnv
conda info --envs
```

## Setting Up Neovim on powershell

### 1. Install Neovim
First, install Neovim by following the official installation instructions from the [Neovim GitHub repository](https://github.com/neovim/neovim/blob/master/README.md). Make sure to choose the Windows-specific instructions.

### 2. Install node.js (npm) and add it to path
1. Download the pre-built installer for Node.js from the [official Node.js website](https://nodejs.org/en/download/prebuilt-installer).
2. Run the installer and follow the installation instructions.
3. Add Node.js to your system PATH. You can do this during the installation process or manually by modifying your environment variables.
    (For me the binary files are located at `C:\Program Files\nodejs`)

### 3. Install Rust (cargo) and add it to path
1. Install Rust by following the instructions on the [official Rust website](https://doc.rust-lang.org/cargo/getting-started/installation.html).
2. During installation, you might need to install C++ tools from Visual Studio. If prompted, follow the instructions to install the necessary components.

### 4. Install GNU Make using GnuWin32
1. Download the GnuWin32 package for Make from [here](https://gnuwin32.sourceforge.net/packages/make.htm).
2. Install Make by running the installer.
3. Add Make to your system PATH. The default installation path is usually `C:\Program Files (x86)\GnuWin32\bin`.

### 5. Set Up Anaconda in PowerShell
if you already setup anaconda this step isn't necessary
1. Install anaconda from the [official anaconda website](https://www.anaconda.com/download).
2. During installation, make sure to add conda to your system PATH.
    - you can either do this using the installation gui or manually.
    - the binaries are usually located at
        - C:\Users\lukas\anaconda3\Scripts
        - C:\Users\lukas\anaconda3\Library\
3. Open PowerShell and run the following command to set the execution policy to unrestricted:
```powershell
    Set-ExecutionPolicy Unrestricted
```
4. initialize anaconda by obening PowerShell and running
```powershell
conda init
```
5. close and reopen PowerShell
6. Create, activate and test whether conda environment is working. Open PowerShell and run
```powershell
conda create -n testENv
conda activate testEnv
conda info --envs
```
