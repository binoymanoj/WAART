#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

echo "[*] Checking and installing required tools..."

tools=("figlet" "nmap" "theHarvester" "wig" "whatweb" "dirb" "nikto" "ffuf" "gobuster" "sublist3r" "amass" "nuclei" "eyewitness" "httprobe" "joomscan" "wapiti" "wpscan" "hakrawler" "dirsearch" "assetfinder")

for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "[*] Installing $tool..."
        apt-get install -y "$tool"  # Package manager changes upon system. This command works for Debian-based systems. Modify for other package managers
    fi
done

cp waart.sh /usr/bin/waart

# Display completion message
echo "[*] WAART tool dependencies have been installed successfully!"
echo 
echo "[*] You have to download aquatone manually by:"
echo 
echo "[*] Step 1: Download the zip file from https://github.com/michenriksen/aquatone/releases"
echo 
echo "[*] Step 2: unzip the file"
echo 
echo "[*] Step 3: Move the aquatone file to bin directory by : sudo mv aquatone /usr/bin"
