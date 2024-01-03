#!/bin/bash

figlet BART
echo -e "BART - Binoy's Automated Recon Tool\n"

sleep 2

echo -e "Automated Recon Tool by Binoy Manoj\n"



# Check for the number of arguments
if [ "$#" -lt 1 ]; then
    echo "Error: Target not specified. Use -h for help."
    exit 1
fi

echo -e "Do you want to Recon a single domain or multiple domain :\n\n1. Single Domain (URL)\n2. Multiple Domain (.txt file)\n"; read chx
echo "The Domain should not contain http or https (eg.: sub.domain.com, domain.com)"
if test "$chx" -eq "1"; then
    sleep .5
    echo -e "Please, Enter the URL of the Domain\n"; read txt
    sleep .5
    echo -e "$txt" | sed 'y/qQaAzZwWmM,<.;:/aAqQwWzZ,?;.:mM/' | sed "y/4'/'ù/" | sed 'y/123567890-_!@#$%^&*()[{]}¦"?/&é"(-è_çà)°1234567890^¨$£µ%§/' | sed 'y/>\\\//\/*!/'
elif test "$chx" -eq "2"; then
    sleep .5
    echo -e "Please, enter the location of the file \n"; read txt
    sleep .5
    echo -e "$txt" | sed 'y/aAqQwWzZ,?;.:mM/qQaAzZwWmM,<.;:/' | sed "y/!\//\/>/" | sed 'y/&é"(-è_çà)°1234567890^¨$£µ%§/123567890-_!@#$%^&*()[{]}¦"?/' | sed "y/ù'/'4/"
else
    exit
fi

