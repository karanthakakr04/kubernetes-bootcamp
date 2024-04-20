<#
.SYNOPSIS
    Installs and sets up kubectl on Windows 10 and Windows 11 machines.

.DESCRIPTION
    This script provides multiple options to install kubectl on Windows 10 and Windows 11 machines.
    It supports installation using curl, winget, Chocolatey, or Scoop package managers.
    After installation, it tests the kubectl installation and configuration, and offers optional setup steps.

.NOTES
    - The script currently uses kubectl version 1.29.3. This version may change in the future.
      Make sure to update the version variable if needed.
    - The script requires administrative privileges to run.

.LINK
    https://github.com/your-repo/Install-Kubectl
#>

# Function to install kubectl using curl
function Install-KubectlWithCurl {
    Write-Host "Installing kubectl using curl..."
    
    # Download the latest kubectl release
    $kubectlVersion = "v1.29.3"  # Update this version if needed
    $kubectlUrl = "https://dl.k8s.io/release/$kubectlVersion/bin/windows/amd64/kubectl.exe"
    Invoke-WebRequest -Uri $kubectlUrl -OutFile "kubectl.exe"
    
    # Validate the binary (optional)
    $kubectlChecksumUrl = "https://dl.k8s.io/$kubectlVersion/bin/windows/amd64/kubectl.exe.sha256"
    $expectedChecksum = (Invoke-WebRequest -Uri $kubectlChecksumUrl).Content.Trim()
    $actualChecksum = (Get-FileHash -Path "kubectl.exe" -Algorithm SHA256).Hash.ToLower()
    
    if ($expectedChecksum -eq $actualChecksum) {
        Write-Host "kubectl binary checksum validation succeeded."
    } else {
        Write-Host "kubectl binary checksum validation failed. Please verify the downloaded file."
    }
    
    # Add kubectl to PATH
    $kubectlPath = (Get-Location).Path
    $env:PATH += ";$kubectlPath"
}

# Function to install kubectl using winget
function Install-KubectlWithWinget {
    Write-Host "Installing kubectl using winget..."
    winget install -e --id Kubernetes.kubectl
}

# Function to install kubectl using Chocolatey
function Install-KubectlWithChocolatey {
    Write-Host "Installing kubectl using Chocolatey..."
    choco install kubernetes-cli
}

# Function to install kubectl using Scoop
function Install-KubectlWithScoop {
    Write-Host "Installing kubectl using Scoop..."
    scoop install kubectl
}

# Function to test kubectl installation
function Test-KubectlInstallation {
    Write-Host "Testing kubectl installation..."
    kubectl version --client
}

# Function to test kubectl configuration
function Test-KubectlConfiguration {
    Write-Host "Testing kubectl configuration..."
    kubectl cluster-info
    kubectl config view
}

# Function to invoke optional setup
function Invoke-OptionalSetup {
    Write-Host "Invoking optional setup..."
    
    # Enable shell autocompletion
    Write-Host "Enabling shell autocompletion..."
    kubectl completion powershell | Out-String | Invoke-Expression
    
    # Install kubectl convert plugin
    Write-Host "Installing kubectl convert plugin..."
    $kubectlConvertVersion = "v1.29.3"  # Update this version if needed
    $kubectlConvertUrl = "https://dl.k8s.io/release/$kubectlConvertVersion/bin/windows/amd64/kubectl-convert.exe"
    Invoke-WebRequest -Uri $kubectlConvertUrl -OutFile "kubectl-convert.exe"
    
    # Validate the kubectl-convert binary (optional)
    $kubectlConvertChecksumUrl = "https://dl.k8s.io/$kubectlConvertVersion/bin/windows/amd64/kubectl-convert.exe.sha256"
    $expectedChecksum = (Invoke-WebRequest -Uri $kubectlConvertChecksumUrl).Content.Trim()
    $actualChecksum = (Get-FileHash -Path "kubectl-convert.exe" -Algorithm SHA256).Hash.ToLower()
    
    if ($expectedChecksum -eq $actualChecksum) {
        Write-Host "kubectl-convert binary checksum validation succeeded."
    } else {
        Write-Host "kubectl-convert binary checksum validation failed. Please verify the downloaded file."
    }
    
    # Add kubectl-convert to PATH
    $kubectlConvertPath = (Get-Location).Path
    $env:PATH += ";$kubectlConvertPath"
    
    # Test kubectl convert plugin installation
    Write-Host "Testing kubectl convert plugin installation..."
    kubectl convert --help
    
    # Clean up installation files
    Remove-Item "kubectl-convert.exe"
}

# Prompt user for installation method
Write-Host "Select the installation method for kubectl:"
Write-Host "1. curl"
Write-Host "2. winget"
Write-Host "3. Chocolatey"
Write-Host "4. Scoop"
$choice = Read-Host "Enter your choice (1-4)"

# Install kubectl based on user's choice
switch ($choice) {
    "1" { Install-KubectlWithCurl }
    "2" { Install-KubectlWithWinget }
    "3" { Install-KubectlWithChocolatey }
    "4" { Install-KubectlWithScoop }
    default {
        Write-Host "Invalid choice. Exiting script."
        exit
    }
}

# Test kubectl installation
Test-KubectlInstallation

# Test kubectl configuration
Test-KubectlConfiguration

# Prompt user for optional setup
$performOptionalSetup = Read-Host "Do you want to invoke optional setup? (Y/N)"

if ($performOptionalSetup -eq "Y" -or $performOptionalSetup -eq "y") {
    # Invoke optional setup
    Invoke-OptionalSetup
}

Write-Host "kubectl installation and setup completed successfully!"