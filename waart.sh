#!/bin/bash

# sed 's/^https\?:\/\///; s/\/$//' domainswithhttp.txt > newfile.txt

show_help() {
    echo "WAART - Automated Web Recon Tool"
    echo
    echo "Usage: waart [OPTIONS] TARGET"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help menu"
    echo "  -u, --url      Perform reconnaissance on single target"
    echo "  -l, --list     Perform reconnaissance on multiple targets"
    echo 
    echo "Examples:"
    echo "  waart -u https://domain.com/"
    echo "  waart -l domains.txt"
}

perform_recon() {

    URL="$1"
    
    # Check if the URL starts with "http://" or "https://"
    if [[ "$URL" =~ ^http:// || "$URL" =~ ^https:// ]]; then

        # Introduction to the TOOL
        figlet WAART
        echo -e "WAART - Web Application Automated Recon Tool \n"
        sleep 1
        echo -e "Automated Recon Tool by Binoy Manoj \n"
        sleep 2
        echo -e "Performing Reconnaissance on $1... \n"

        # Get the URL and storing it in domain_waart.txt file
        if [ -n "$URL" ]; then
            DOMAIN_FILE="domain_waart.txt"
            echo "$URL" > "$DOMAIN_FILE"
            echo "Domain stored in $DOMAIN_FILE"
        else
            echo "Error: Unable to retrieve the URL."
        fi

        # Removing the protocols like http & https and storing it in domain_wop_waart.txt file
        if [ -n "$DOMAIN_FILE" ]; then
            DOMAIN_FILE_WITHOUT_PROTOCOL="domain_wop_waart.txt"
            sed 's/^https\?:\/\///; s/\/$//' "$DOMAIN_FILE" > "$DOMAIN_FILE_WITHOUT_PROTOCOL"
            echo "Domain without protocol stored in $DOMAIN_FILE_WITHOUT_PROTOCOL"
        else
            echo "Error: Unable to retrieve the Domain File."
        fi

        DOMAIN_WOP=$(cat "$DOMAIN_FILE_WITHOUT_PROTOCOL") 

        # Ping the URL to obtain the IP address and storing the ip in ip_address_waarp.txt file
        IP_ADDR=$(ping -c 1 "$DOMAIN_WOP" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
        
        if [ -n "$IP_ADDR" ]; then
            IP_ADDR_FILE="ip_address_waarp.txt"
            echo "$IP_ADDR" > "$IP_ADDR_FILE"
            echo -e "IP address stored in $IP_ADDR_FILE \n"
        else
            echo "Error: Unable to retrieve the IP address."
        fi

        # Recon starts here...

        # 1. Perform basic Nmap scan
        if [ -n "$IP_ADDR" ]; then
            echo "[*] Performing basic Nmap scan on $IP_ADDR..."
            # x-terminal-emulator -e "bash -c 'nmap -p- -sV "$IP_ADDR" | tee -a nmap_scan_results/$DOMAIN_WOP.txt; echo Nmap scan completed; read -p PressEnter'"
            nmap -p- -sV "$IP_ADDR" | tee -a nmap_$DOMAIN_WOP.txt
            echo -e "Nmap scan results stored in nmap_$DOMAIN_WOP.txt \n"  
        else
            echo "Error: Unable to retrieve the IP address for Nmap Scan."
        fi

        # 2. Perform Nuclei scan
        if [ -n "$DOMAIN_FILE" ]; then
            echo "[*] Performing Nuclei scan on $DOMAIN_WOP"
            # x-terminal-emulator -e "bash -c 'nuclei -l $DOMAIN_FILE; echo Nuclei scan completed; read -p PressEnter'"
            nuclei -l $DOMAIN_FILE | tee -a nuclei_$DOMAIN_WOP.txt
            # wait
            echo -e "Nuclei scan results stored in nuclei_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for Nuclei Scan."
        fi

        # 3. Perform theHarvester scan
        if [ -n "$DOMAIN_WOP" ]; then
            echo "[*] Performing theHarvester scan on $DOMAIN_WOP ..."
            theHarvester -d $DOMAIN_WOP -b all | tee -a harvester_$DOMAIN_WOP.txt
            echo -e "theHarvester scan results stored in nuclei_scan_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for theHarvester Scan."
        fi


    else
        echo "Error: Invalid URL format. Please include 'http://' or 'https://' in the URL."
        exit 1
    fi
}

perform_target_recon() {

    URL="$1"
    
    # Check if the URL starts with "http://" or "https://"
    if [[ "$URL" =~ ^http:// || "$URL" =~ ^https:// ]]; then

        DOMAIN_FILE="domain.txt"

        echo "$URL" > "$DOMAIN_FILE"

        figlet WAART
        echo -e "WAART - Web Application Automated Recon Tool \n"

        sleep 1

        echo -e "Automated Recon Tool by Binoy Manoj\n"

        sleep 2

        echo "Performing Reconnaissance on $1..."
        # Add your reconnaissance commands here
        # Example: curl, nmap, nikto, dirb, etc.

    else
        echo "Error: Invalid URL format. Please include 'http://' or 'https://' in the URL."
        exit 1
    fi
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
            perform_target_recon "$2"
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
