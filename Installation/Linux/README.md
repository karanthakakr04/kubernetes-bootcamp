# Kubernetes Tools Installation Scripts (Linux)

This repository contains shell scripts to automate the installation of `kubectl` and `kind` on Linux systems.

## Prerequisites

Before running the installation scripts, ensure that you have the following prerequisites installed on your Linux system:

- Docker: `kubectl` and `kind` rely on Docker to function properly. Make sure you have Docker installed and running on your machine. You can install Docker by following the official documentation for your Linux distribution.

## Scripts

### install_kubectl.sh

This script automates the installation of `kubectl`, the command-line tool for interacting with Kubernetes clusters. It provides multiple installation options based on your Linux distribution:

- Debian/Ubuntu: Installs `kubectl` using `apt` package manager.
- CentOS/RHEL/Fedora: Installs `kubectl` using `yum` package manager.
- SUSE: Installs `kubectl` using `zypper` package manager.

The script also supports installing `kubectl` using `curl` if package managers are not available or preferred.

### install_kind.sh

This script automates the installation of `kind` (Kubernetes IN Docker), a tool for running local Kubernetes clusters using Docker containers as nodes. It detects your system architecture (AMD64 or ARM64) and installs the appropriate `kind` binary.

The script prompts you to specify the desired version of `kind` to install, with a default version of `v0.22.0`.

## Usage

1. Clone this repository to your local machine or download the desired script(s).

2. Open a terminal with administrative privileges.

3. Navigate to the directory where the script(s) are located.

4. Make the script(s) executable:
   - To make `install_kubectl.sh` executable, run:

     ```bash
     chmod +x install_kubectl.sh
     ```

   - To make `install_kind.sh` executable, run:

     ```bash
     chmod +x install_kind.sh
     ```

5. Run the desired script:
   - To install `kubectl`, run:

     ```bash
     sudo ./install_kubectl.sh
     ```

   - To install `kind`, run:

     ```bash
     sudo ./install_kind.sh
     ```

6. Follow the prompts and provide the necessary information when asked.

7. Wait for the installation to complete. The script will display the progress and any relevant information.

8. Once the installation is finished, you can start using `kubectl` and `kind` to interact with Kubernetes clusters.

## What are kubectl and kind?

- `kubectl` is the command-line tool for interacting with Kubernetes clusters. It allows you to deploy applications, manage cluster resources, and perform various operations on Kubernetes objects.

- `kind` (Kubernetes IN Docker) is a tool that lets you run local Kubernetes clusters using Docker containers as nodes. It simplifies the process of creating and managing local Kubernetes environments for development and testing purposes.

By using `kubectl` and `kind` together, you can easily create and interact with local Kubernetes clusters on your Linux machine, enabling you to develop, test, and learn Kubernetes without the need for a remote cluster.

## Notes

- The scripts are designed to work on common Linux distributions, including Debian/Ubuntu, CentOS/RHEL/Fedora, and SUSE. If you are using a different distribution, you may need to modify the package manager commands accordingly.
- The scripts assume that you have internet connectivity to download the necessary files.
- If you encounter any issues or have questions, please refer to the official documentation of `kubectl` and `kind` or seek support from the respective communities.

Happy Kubernetes learning and experimentation!
