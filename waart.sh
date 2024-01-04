#!/bin/bash

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

        # Creating a directory for storing all Results
        mkdir WAART_results
        cd WAART_results

        # Introduction to the TOOL
        figlet WAART
        echo -e "WAART - Web Application Automated Recon Tool \n"
        sleep 1
        echo -e "Automated Recon Tool by Binoy Manoj \n"
        sleep 2
        echo -e "[*] Performing Reconnaissance on $1... \n"

        # Get the URL and storing it in domain_waart.txt file
        if [ -n "$URL" ]; then
            DOMAIN_FILE="domain.txt"
            echo "$URL" > "$DOMAIN_FILE"
            echo "[*] Domain stored in $DOMAIN_FILE"
        else
            echo "Error: Unable to retrieve the URL."
        fi

        # Removing the protocols like http & https and storing it in domain_wop_waart.txt file
        if [ -n "$DOMAIN_FILE" ]; then
            DOMAIN_FILE_WITHOUT_PROTOCOL="domain_wop.txt"
            sed 's/^https\?:\/\///; s/\/$//' "$DOMAIN_FILE" > "$DOMAIN_FILE_WITHOUT_PROTOCOL"
            echo "[*] Domain without protocol stored in $DOMAIN_FILE_WITHOUT_PROTOCOL"
        else
            echo "Error: Unable to retrieve the Domain File."
        fi

        DOMAIN=$(cat "$DOMAIN_FILE")
        DOMAIN_WOP=$(cat "$DOMAIN_FILE_WITHOUT_PROTOCOL") 

        # Ping the URL to obtain the IP address and storing the ip in ip_address_waarp.txt file
        IP_ADDR=$(ping -c 1 "$DOMAIN_WOP" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
        
        if [ -n "$IP_ADDR" ]; then
            IP_ADDR_FILE="ip_address.txt"
            echo "$IP_ADDR" > "$IP_ADDR_FILE"
            echo -e "[*] IP address stored in $IP_ADDR_FILE \n"
        else
            echo "Error: Unable to retrieve the IP address."
        fi

        # Recon starts here...

        # 1. Perform basic Nmap scan
        if [ -n "$IP_ADDR" ]; then
            echo "[*] Performing basic Nmap scan on $IP_ADDR..."
            # x-terminal-emulator -e "bash -c 'nmap -p- -sV "$IP_ADDR" | tee -a nmap_scan_results/$DOMAIN_WOP.txt; echo Nmap scan completed; read -p PressEnter'"
            nmap -p- -sV "$IP_ADDR" | tee -a nmap_$DOMAIN_WOP.txt
            echo -e "\n [*] Nmap scan results stored in nmap_$DOMAIN_WOP.txt \n"  
        else
            echo "Error: Unable to retrieve the IP address for Nmap Scan."
        fi

        # 2. Perform Vuln Nmap scan
        if [ -n "$IP_ADDR" ]; then
            echo "[*] Performing Vuln Nmap scan on $IP_ADDR..."
            nmap --script=vuln "$IP_ADDR" | tee -a nmap_vuln_$DOMAIN_WOP.txt
            echo 
            echo -e "[*] Nmap scan results stored in nmap_vuln_$DOMAIN_WOP.txt \n"  
        else
            echo "Error: Unable to retrieve the IP address for Nmap Vuln Scan."
        fi

        # 3. Perform Nuclei scan
        if [ -n "$DOMAIN_FILE" ]; then
            echo "[*] Performing Nuclei scan on $DOMAIN"
            nuclei -l $DOMAIN_FILE | tee -a nuclei_$DOMAIN_WOP.txt
            # wait
            echo -e "[*] Nuclei scan results stored in nuclei_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for Nuclei Scan."
        fi

        # 4. Perform theHarvester scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing theHarvester scan on $DOMAIN ..."
            theHarvester -d $DOMAIN -b all | tee -a harvester_$DOMAIN_WOP.txt
            echo -e "[*] theHarvester scan results stored in theHarvester_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for theHarvester Scan."
        fi

        # 5. Perform wig scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing wig scan on $DOMAIN ..."
            wig -d $DOMAIN | tee -a wig_$DOMAIN_WOP.txt
            echo -e "[*] wig scan results stored in wig_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for wig Scan."
        fi

        # 6. Perform whatweb scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing whatweb scan on $DOMAIN ..."
            whatweb $DOMAIN | tee -a whatweb_$DOMAIN_WOP.txt
            echo -e "[*] whatweb scan results stored in whatweb_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for whatweb Scan."
        fi

        # 7. Perform dirb scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing dirb scan on $DOMAIN ..."
            dirb $DOMAIN -w | tee -a dirb_$DOMAIN_WOP.txt
            echo -e "[*] dirb scan results stored in dirb_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for dirb Scan."
        fi

        # 8. Perform nikto scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing nikto scan on $DOMAIN ..."
            nikto -h $DOMAIN | tee -a nikto_$DOMAIN_WOP.txt
            echo -e "[*] nikto scan results stored in nikto_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for nikto Scan."
        fi

        # 9. Perform ffuf scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing ffuf scan on $DOMAIN ..."
            ffuf -w /usr/share/wordlists/dirb/common.txt -u "$DOMAIN/FUZZ" | tee -a ffuf_$DOMAIN_WOP.txt
            echo -e "[*] ffuf scan results stored in ffuf_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for ffuf Scan."
        fi

        # 10. Perform gobuster scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing gobuster scan on $DOMAIN ..."
            # gobuster dir -u "$DOMAIN" -w /usr/share/wordlists/dirb/common.txt | tee -a gobuster_$DOMAIN_WOP.txt
            gobuster dir -u "$DOMAIN" -w /usr/share/wordlists/dirb/common.txt > "gobuster_$DOMAIN_WOP.txt"
            echo -e "[*] gobuster scan results stored in gobuster_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for gobuster Scan."
        fi

        # 11. Perform httprobe scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing httprobe scan on $DOMAIN ..."
            cat "gobuster_$DOMAIN_WOP.txt" | grep -oP "(?<=^$target)[^/]*" | sort -u | httprobe > "httprobe_$DOMAIN_WOP.txt"
            echo -e "[*] httprobe scan results stored in httprobe_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for httprobe Scan."
        fi

        # 12. Perform sublist3r scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing sublist3r scan on $DOMAIN ..."
            sublist3r -d "$DOMAIN" | tee -a sublist3r_$DOMAIN_WOP.txt
            echo -e "[*] sublist3r scan results stored in sublist3r_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for sublist3r Scan."
        fi

        # 13. Perform amass scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing amass scan on $DOMAIN ..."
            amass enum -d "$DOMAIN" | tee -a amass_$DOMAIN_WOP.txt
            echo -e "[*] amass scan results stored in amass_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for amass Scan."
        fi

        # 14. Perform aquatone scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing aquatone scan on $DOMAIN ..."
            cat "httprobe_$DOMAIN_WOP.txt" | aquatone -out "aquatone_results"
            echo -e "[*] aquatone scan results stored in aquatone_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for aquatone Scan."
        fi

        # 15. Perform eyewitness scan
        if [ -n "$DOMAIN" ]; then
            echo "[*] Performing eyewitness scan on $DOMAIN ..."
            eyewitness -f "httprobe_$DOMAIN_WOP.txt" --no-prompt -d "eyewitness_results"
            echo -e "[*] eyewitness scan results stored in eyewitness_$DOMAIN_WOP.txt \n" 
        else
            echo "Error: Unable to retrieve the Domain for eyewitness Scan."
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
