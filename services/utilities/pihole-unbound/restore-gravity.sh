#!/bin/bash

# Restore Pi-hole gravity database from adlists.txt
# This script should be run from inside the pihole container

set -e

echo "Starting Pi-hole gravity restore process..."

# Check if we're running inside the pihole container
if [ ! -f "/etc/pihole/setupVars.conf" ]; then
    echo "Error: This script must be run from inside the pihole container"
    echo "Usage: docker exec pihole /restore-gravity.sh"
    exit 1
fi

# Check if adlists.txt exists
if [ ! -f "/etc/pihole/adlists.txt" ]; then
    echo "Error: /etc/pihole/adlists.txt not found"
    echo "Please ensure adlists.txt is present in the container"
    exit 1
fi

echo "Stopping Pi-hole DNS service..."
pihole disable

echo "Clearing existing gravity database..."
sqlite3 /etc/pihole/gravity.db "DELETE FROM adlist;"

echo "Importing adlists from adlists.txt..."
if [ -s "/etc/pihole/adlists.txt" ]; then
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
            echo "Adding adlist: $line"
            sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (address, enabled, comment) VALUES ('$line', 1, 'Added via restore-gravity.sh');"
        fi
    done < /etc/pihole/adlists.txt
else
    echo "Warning: adlists.txt is empty"
fi

echo "Regenerating gravity database..."
pihole -g

echo "Enabling Pi-hole DNS service..."
pihole enable

echo "Gravity restore completed successfully!"
echo "Current adlists count: $(sqlite3 /etc/pihole/gravity.db 'SELECT COUNT(*) FROM adlist;')"
echo "Current domains blocked: $(sqlite3 /etc/pihole/gravity.db 'SELECT COUNT(*) FROM gravity;')"
