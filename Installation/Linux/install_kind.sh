#!/bin/bash

# Function to check if the script is running with sudo privileges
check_sudo() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run with sudo privileges. Exiting..."
        exit 1
    fi
}

# Function to install kind
install_kind() {
    echo "Installing kind..."

    # Determine the architecture
    case $(uname -m) in
        x86_64)
            curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
            ;;
        aarch64)
            curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-arm64
            ;;
        *)
            echo "Unsupported architecture. Exiting..."
            exit 1
            ;;
    esac

    # Make the kind binary executable
    chmod +x ./kind

    # Move the kind binary to /usr/local/bin
    sudo mv ./kind /usr/local/bin/kind

    echo "kind installed successfully."
}

# Function to test kind installation
test_kind_installation() {
    if ! command -v kind &> /dev/null; then
        echo "kind is not installed. Exiting..."
        exit 1
    fi

    echo "Testing kind installation..."
    kind version
}

# Main script
check_sudo
install_kind
test_kind_installation

echo "kind installation completed successfully!"