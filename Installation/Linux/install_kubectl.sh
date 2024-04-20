#!/bin/bash

# Function to check if the script is running with sudo privileges
check_sudo() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run with sudo privileges. Exiting..."
        exit 1
    fi
}

# Function to install kubectl using curl
install_kubectl_with_curl() {
    echo "Installing kubectl using curl..."

    # Determine the architecture
    case $(uname -m) in
        x86_64)
            arch="amd64"
            ;;
        arm64)
            arch="arm64"
            ;;
        *)
            echo "Unsupported architecture. Exiting..."
            exit 1
            ;;
    esac

    # Download the latest kubectl release
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${arch}/kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${arch}/kubectl.sha256"

    # Validate the binary
    echo "$(<kubectl.sha256) kubectl" | sha256sum --check
    if [[ $? -ne 0 ]]; then
        echo "kubectl binary validation failed. Exiting..."
        rm kubectl kubectl.sha256
        exit 1
    fi

    # Install kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # Clean up
    rm kubectl kubectl.sha256

    echo "kubectl installed successfully using curl."
}

# Function to install kubectl using native package management
install_kubectl_with_package_manager() {
    case $1 in
        debian|ubuntu)
            echo "Installing kubectl on Debian/Ubuntu..."
            sudo apt-get update
            sudo apt-get install -y apt-transport-https ca-certificates curl
            curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
            echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
            sudo apt-get update
            sudo apt-get install -y kubectl
            ;;
        centos|redhat|fedora)
            echo "Installing kubectl on CentOS/RHEL/Fedora..."
            cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
            sudo yum install -y kubectl
            ;;
        suse)
            echo "Installing kubectl on SUSE..."
            sudo zypper addrepo -G https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64 kubernetes
            sudo zypper install -y kubectl
            ;;
        *)
            echo "Unsupported Linux distribution. Exiting..."
            exit 1
            ;;
    esac

    echo "kubectl installed successfully using package manager."
}

# Function to detect the Linux distribution
detect_distribution() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case $ID in
            debian|ubuntu)
                echo "debian"
                ;;
            centos|rhel|fedora)
                echo "redhat"
                ;;
            sles|opensuse-leap|opensuse-tumbleweed)
                echo "suse"
                ;;
            *)
                echo "unknown"
                ;;
        esac
    else
        echo "unknown"
    fi
}

# Function to prompt user for installation method and install kubectl
install_kubectl() {
    echo "Select the installation method for kubectl:"
    echo "1. curl"
    echo "2. Package Manager"
    read -p "Enter your choice (1-2): " choice

    case $choice in
        1)
            install_kubectl_with_curl
            ;;
        2)
            distro=$(detect_distribution)
            if [[ $distro == "unknown" ]]; then
                echo "Unable to detect Linux distribution. Exiting..."
                exit 1
            fi
            install_kubectl_with_package_manager $distro
            ;;
        *)
            echo "Invalid choice. Exiting..."
            exit 1
            ;;
    esac
}

# Function to test kubectl installation
test_kubectl_installation() {
    if ! command -v kubectl &> /dev/null; then
        echo "kubectl is not installed. Exiting..."
        exit 1
    fi

    echo "Testing kubectl installation..."
    kubectl version --client
}

# Main script
check_sudo
install_kubectl
test_kubectl_installation

echo "kubectl installation completed successfully!"