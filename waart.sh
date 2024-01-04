#!/bin/bash

# sed 's/^https\?:\/\///; s/\/$//' domainswithhttp.txt > newfile.txt

show_help() {
    echo "WAART - Automated Web Recon Tool"
    echo
    echo "Usage: ./waart.sh [OPTIONS] TARGET"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help menu"
    echo "  -u, --url      Perform reconnaissance on single target"
    echo "  -l, --list     Perform reconnaissance on multiple targets"
    echo 
    echo "Examples:"
    echo "  ./waart.sh -u https://domain.com/"
    echo "  ./waart.sh -l domains.txt"
}

perform_recon() {

    figlet WAART
    echo -e "WAART - Web Application Automated Recon Tool \n"

    sleep 1

    echo -e "Automated Recon Tool by Binoy Manoj\n"

    sleep 2

    echo "Performing Reconnaissance on $1..."
    # Add your reconnaissance commands here
    # Example: curl, nmap, nikto, dirb, etc.

    
}

if [ "$#" -lt 1 ]; then
    echo "Error: Target not specified. Use -h for help."
    exit 1
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -u|--url)
            perform_recon "$2"
            exit 0
            ;;
        -t|--target)
            perform_recon "$2"
            exit 0
            ;;
        *)
            TARGET="$1"
            ;;
    esac
    shift
done

# checking if any targets is specified
if [ -z "$TARGET" ]; then
    echo "Error: Target not specified. Use -h for help."
    exit 1
fi

# Perform default reconnaissance if no options are specified
perform_recon "$TARGET"
