#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

echo "[*] Checking and installing required tools..."

tools=("figlet" "nmap" "theHarvester" "wig" "whatweb" "dirb" "nikto" "ffuf" "gobuster" "sublist3r" "amass" "subfinder" "nuclei" "eyewitness" "httprobe" "joomscan" "wapiti" "wpscan" "hakrawler" "dirsearch" "assetfinder" "golang-go")

failed_tools=()

for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        read -p "[*] $tool is not installed. Press Enter to install it..."
        echo "[*] Installing $tool..."
        apt-get install -y "$tool"  # Package manager changes upon system. This command works for Debian-based systems. Modify for other package managers
        # Check if the installation was successful
        if ! command -v "$tool" &> /dev/null; then
            echo "[!] Error: Installation of $tool failed. Please install it manually."
            failed_tools+=("$tool")
        else
            echo "[*] $tool installed successfully."
        fi
    else
        echo "[*] $tool is already installed."
    fi
done

if [ ${#failed_tools[@]} -gt 0 ]; then
    echo "[!] The following tools could not be installed automatically. Please install them manually:"
    for failed_tool in "${failed_tools[@]}"; do
        echo "    - $failed_tool"
    done
    exit 1
fi

# installation of subzy tool
go install -v github.com/LukaSikic/subzy@latest

sudo cp ~/go/bin/subzy /bin

# coping the tool to bin directory for accessing anywhere in the terminal
cp waart.sh /usr/bin/waart

# Display completion message
echo
echo "[*] WAART tool dependencies have been installed successfully!"
echo 
echo "[*] You have to download & install aquatone manually by:"
echo 
echo "[*] Step 1: Download the latest zip file from https://github.com/michenriksen/aquatone/releases"
echo 
echo "[*] Step 2: unzip the file"
echo 
echo "[*] Step 3: Move the aquatone file to bin directory by the following command : "
echo
echo "sudo mv ~/Downloads/aquatone /usr/bin"
