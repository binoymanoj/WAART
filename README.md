# Bard - Automated Web Recon Tool

Bard is a simple Bash script designed for basic automated web reconnaissance during penetration testing. It includes options for performing various reconnaissance tasks on a specified target.

## Features
- Basic web reconnaissance using customizable commands.
- Command-line options for ease of use.
- Help menu for quick reference.

## Usage

### Prerequisites
- Bash shell
- Required reconnaissance tools (e.g., curl, nmap, nikto, dirb, etc.)

### Installation
1. Download the `bard.sh` script.
2. Make the script executable: `chmod +x bard.sh`

### Options
- `-h, --help`: Show the help menu.
- `-s, --scan`: Perform basic web reconnaissance.

### Examples
1. Perform basic web reconnaissance:
   ```bash
   ./bard.sh example.com
   ```