#!/bin/sh
cd "$(dirname "$0")"
sudo cp -r etc/. /etc/
sudo sed -i "s/__USER__/$(whoami)/g; s#__UID__#$(id -u)#g" /etc/acpi/mute-debounced.sh /etc/acpi/events/* 2>/dev/null
sudo chmod +x /etc/acpi/mute-debounced.sh 2>/dev/null
sudo systemctl restart acpid 2>/dev/null
echo "done"
