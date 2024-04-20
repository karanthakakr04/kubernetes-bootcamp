<#
.SYNOPSIS
    Installs kind (Kubernetes in Docker) on Windows.

.DESCRIPTION
    This script provides options to install kind on Windows using either Chocolatey or from the release binaries.
    It also tests the installation by checking the kind version.

.NOTES
    - The script requires administrative privileges to run.
    - The script downloads the latest release of kind from the official GitHub repository.
    - The Chocolatey installation option requires Chocolatey to be installed on the system.
    - The release binary version of kind may change in the future. Update the $kindVersion variable if needed.

.LINK
    https://github.com/your-repo/Install-Kind
#>

# Function to install kind using Chocolatey
function Install-KindWithChocolatey {
    Write-Host "Installing kind using Chocolatey..."
    choco install kind
}

# Function to install kind from release binaries
function Install-KindFromReleaseBinaries {
    Write-Host "Installing kind from release binaries..."

    # Download the latest kind release
    $kindVersion = "v0.22.0"  # Update this version if a newer release is available
    $kindUrl = "https://github.com/kubernetes-sigs/kind/releases/download/$kindVersion/kind-windows-amd64"
    Invoke-WebRequest -Uri $kindUrl -OutFile "kind.exe"

    # Add kind to PATH
    $kindPath = (Get-Location).Path
    $env:PATH += ";$kindPath"
}

# Function to test kind installation
function Test-KindInstallation {
    Write-Host "Testing kind installation..."
    kind version
}

# Prompt user for installation method
Write-Host "Select the installation method for kind:"
Write-Host "1. Chocolatey"
Write-Host "2. Release Binaries"
$choice = Read-Host "Enter your choice (1-2)"

# Install kind based on user's choice
switch ($choice) {
    "1" { Install-KindWithChocolatey }
    "2" { Install-KindFromReleaseBinaries }
    default {
        Write-Host "Invalid choice. Exiting script."
        exit
    }
}

# Test kind installation
Test-KindInstallation

Write-Host "kind installation completed successfully!"