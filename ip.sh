#!/bin/bash

while read -r line;
do
        [ -z "$line" ] && break
        #ignora comentariile
        case "$line" in 
                \#*)
                        continue  
                 ;;
        esac
        dns=$(awk '/^nameserver: / {print $2}' /etc/resolv.conf)
        ip=$(echo "$line" | awk '{print $1}')
        name=$(echo "$line" | awk '{print $2}')
        check=$(nslookup $name $dns | awk '/^Address: / {print $2}' | tail -n 1)
        if [ "$ip" = "$check" ]; then 
                echo "IP Address matches" 
        else
                echo "Bogus IP for {$name} in /etc/hosts!"
        fi
done 

exit 0

