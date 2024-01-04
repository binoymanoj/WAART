# WAART - Web Application Automated Recon Tool

Waart is a simple Bash script designed for basic automated web reconnaissance during penetration testing. It includes options for performing various reconnaissance tasks on a specified target(s).

## Features
- Basic web reconnaissance using customizable commands.
- Command-line options for ease of use.
- Help menu for quick reference.

## Usage

### Installation
1. clone the repository
   ```bash
   git clone https://github.com/binoymanoj/WAART.git
   ```
2. go to WAART repository
   ```bash
   cd WAART
   ```
3. Make the script executable and run
   ```bash
   chmod +x install.sh && sudo ./install.sh
   ```

### Options
- `-h, --help`: Show the help menu.
- `-t, --target`: // need to update this section !important

### Examples
1. Perform reconnaissance on one target:
   ```bash
   waart https://example.com
   ```
   or
   ```bash
   waart -t https://example.com
   ```
2. Perform reconnaissance on multiple target:
   ```bash
   waart -l domains.txt
   ```