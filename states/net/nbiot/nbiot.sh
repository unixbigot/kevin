#!/bin/sh

while true; do
    ifconfig ppp0 >/dev/null

    if [ $? -eq 0 ]; then
        #echo "Connection up, reconnect not required..."
	true;
    else
	if pgrep -f "pppd call nbiot"
	then
	    echo "Existing pppd is present, do nothing"
	else
            echo "Connection down, reconnecting..."
            pon nbiot
	fi
    fi

    sleep 10
done	
