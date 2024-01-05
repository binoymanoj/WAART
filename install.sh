#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

# Install aquatone
# echo "[*] Installing aquatone..."
# go get github.com/michenriksen/aquatone

# Ensure the required tools are installed
echo "[*] Checking and installing required tools..."

tools=("figlet" "nmap" "theHarvester" "wig" "whatweb" "dirb" "nikto" "ffuf" "gobuster" "sublist3r" "amass" "nuclei" "eyewitness" "httprobe")

for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "[*] Installing $tool..."
        apt-get install -y "$tool"  # Package manager changes upon system. This command works for Debian-based systems. Modify for other package managers
    fi
done

# Display completion message
echo "[*] WAART tool dependencies have been installed successfully!"
