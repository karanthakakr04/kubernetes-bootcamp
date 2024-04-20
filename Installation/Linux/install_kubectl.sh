#!/bin/bash

# Function to install kubectl using curl
install_kubectl_with_curl() {
    echo "Installing kubectl using curl..."

    # Download the latest kubectl release
    if [[ "$(uname -m)" == "x86_64" ]]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    elif [[ "$(uname -m)" == "arm64" ]]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    else
        echo "Unsupported architecture. Exiting..."
        exit 1
    fi

    # Validate the binary (optional)
    if [[ "$(uname -m)" == "x86_64" ]]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    elif [[ "$(uname -m)" == "arm64" ]]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl.sha256"
    fi
    echo "$(<kubectl.sha256) kubectl" | sha256sum --check

    # Install kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # Clean up
    rm kubectl kubectl.sha256
}

# Function to install kubectl using native package management (Debian/Ubuntu)
install_kubectl_debian() {
    echo "Installing kubectl on Debian/Ubuntu..."

    # Update the apt package index and install packages to use the Kubernetes apt repository
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl

    # Download the Google Cloud public signing key
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

    # Add the Kubernetes apt repository
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    # Update the apt package index with the new repository and install kubectl
    sudo apt-get update
    sudo apt-get install -y kubectl
}

# Function to install kubectl using native package management (Red Hat/CentOS)
install_kubectl_redhat() {
    echo "Installing kubectl on Red Hat/CentOS..."

    cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

    sudo yum install -y kubectl
}

# Function to install kubectl using native package management (SUSE)
install_kubectl_suse() {
    echo "Installing kubectl on SUSE..."

    sudo zypper addrepo -G https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64 kubernetes
    sudo zypper install -y kubectl
}

# Function to test kubectl installation
test_kubectl_installation() {
    echo "Testing kubectl installation..."
    kubectl version --client
}

# Detect the Linux distribution
if [[ -f /etc/debian_version ]]; then
    distro="debian"
elif [[ -f /etc/redhat-release ]]; then
    distro="redhat"
elif [[ -f /etc/SuSE-release ]]; then
    distro="suse"
else
    echo "Unsupported Linux distribution. Exiting..."
    exit 1
fi

# Prompt user for installation method
echo "Select the installation method for kubectl:"
echo "1. curl"
echo "2. Native package management"
read -p "Enter your choice (1-2): " install_choice

# Install kubectl based on user's choice and distribution
case $install_choice in
    1)
        install_kubectl_with_curl
        ;;
    2)
        case $distro in
            debian)
                install_kubectl_debian
                ;;
            redhat)
                install_kubectl_redhat
                ;;
            suse)
                install_kubectl_suse
                ;;
        esac
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

# Test kubectl installation
test_kubectl_installation

echo "kubectl installation completed successfully!"