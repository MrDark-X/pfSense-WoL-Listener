#!/bin/sh

# Author: Yaswanth Surya Chalamalasetty
# Description: Listens for WoL packets on WAN interface and triggers predefined commands.

# Interfaces and config
WAN_IF="em0"        <-------    replace with ur wan interface
WOL_PORT="9"
RECEIVED_FILE="/root/received.txt"
STATUS_LOG="/root/command_status.log"

# Commands to run
run_commands() {
    timestamp=$(date)
    {
        echo "[$timestamp] WoL packet received: $1"
        echo "Executing WoL commands..."

        # Each WOL command
        wol -i 10.15.20.255 -p 9 f8:b1:56:b2:a0:b8 && echo "[+] Command 1 SUCCESS" || echo "[-] Command 1 FAILED"
        wol -i 10.15.20.255 -p 9 ec:8e:b5:71:26:9d && echo "[+] Command 2 SUCCESS" || echo "[-] Command 2 FAILED"
        wol -i 10.15.20.255 -p 9 fc:3f:db:06:33:13 && echo "[+] Command 3 SUCCESS" || echo "[-] Command 3 FAILED"
        wol -i 10.11.12.255 -p 9 04:7c:16:ba:91:0f && echo "[+] Command 4 SUCCESS" || echo "[-] Command 4 FAILED"
        wol -i 10.11.12.255 -p 9 40:c2:ba:3b:42:0d && echo "[+] Command 5 SUCCESS" || echo "[-] Command 5 FAILED"

    } > "$STATUS_LOG"
}

# Sniffing for WoL packets
tcpdump -l -i "$WAN_IF" udp port "$WOL_PORT" -n | while read -r line; do
    timestamp=$(date)
    echo "$timestamp: WoL packet received - $line" > "$RECEIVED_FILE"
    run_commands "$line"
done
