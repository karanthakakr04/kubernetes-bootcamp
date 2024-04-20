# Kubernetes Tools Installation Scripts

This folder contains PowerShell scripts to automate the installation of `kubectl` and `kind` on Windows machines.

## Prerequisites

Before running the installation scripts, ensure that you have the following prerequisites installed on your Windows machine:

- PowerShell: The scripts are written in PowerShell and require PowerShell to be installed on your system.
- Docker: `kubectl` and `kind` rely on Docker to function properly. Make sure you have Docker installed and running on your machine.

## Scripts

### Install-Kubectl.ps1

This script automates the installation of `kubectl`, the command-line tool for interacting with Kubernetes clusters. It provides multiple installation options, including:

- Installing using curl
- Installing using winget
- Installing using Chocolatey
- Installing using Scoop

The script also verifies the `kubectl` installation and configuration, and offers optional setup steps such as enabling shell autocompletion and installing the `kubectl` convert plugin.

### Install-Kind.ps1

This script automates the installation of `kind` (Kubernetes in Docker), a tool for running local Kubernetes clusters using Docker containers as nodes. It provides options to install `kind` using either Chocolatey or from the release binaries.

The script downloads the latest release of `kind` from the official GitHub repository and adds it to the system's PATH environment variable. It also tests the `kind` installation by checking the version.

## Usage

1. Clone this repository to your local machine or download the desired script(s).

2. Open a PowerShell console with administrative privileges.

3. Navigate to the directory where the script(s) are located.

4. Run the desired script:
   - To install `kubectl`, run: `.\Install-Kubectl.ps1`
   - To install `kind`, run: `.\Install-Kind.ps1`

5. Follow the prompts and select the appropriate installation options based on your preferences.

6. Wait for the installation to complete. The script will display the progress and any relevant information.

7. Once the installation is finished, you can start using `kubectl` and `kind` to interact with Kubernetes clusters.

## What are kubectl and kind?

- `kubectl` is the command-line tool for interacting with Kubernetes clusters. It allows you to deploy applications, manage cluster resources, and perform various operations on Kubernetes objects.

- `kind` (Kubernetes in Docker) is a tool that lets you run local Kubernetes clusters using Docker containers as nodes. It simplifies the process of creating and managing local Kubernetes environments for development and testing purposes.

By using `kubectl` and `kind` together, you can easily create and interact with local Kubernetes clusters on your Windows machine, enabling you to develop, test, and learn Kubernetes without the need for a remote cluster.

## Notes

- The scripts are designed to work on Windows 10 and Windows 11 machines.
- The scripts may prompt you for administrative privileges during execution to perform certain tasks.
- The scripts download the latest versions of `kubectl` and `kind` at the time of writing. However, newer versions may be available in the future. You can update the version variables in the scripts if needed.
- If you encounter any issues or have questions, please refer to the official documentation of `kubectl` and `kind` or seek support from the respective communities.
