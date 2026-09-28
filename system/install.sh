#!/bin/sh
set -eu
cd "$(dirname "$0")"

sudo cp -r --backup=numbered -v etc/. /etc/

if [ -d etc/acpi ]; then
    sudo sed -i "s/__USER__/$(id -un)/g; s#__UID__#$(id -u)#g" /etc/acpi/mute-debounced.sh /etc/acpi/events/*
    sudo chmod +x /etc/acpi/mute-debounced.sh
    if systemctl list-unit-files acpid.service >/dev/null 2>&1; then
        sudo systemctl restart acpid
    else
        echo "acpid is not installed; skipped restart"
    fi
else
    echo "no etc/acpi in repo; skipped acpid setup"
fi

echo "done"
