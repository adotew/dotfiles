#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Restart Wacom Drivers
# @raycast.mode compact
# @raycast.icon ✍️
# @raycast.packageName Wacom
# @raycast.description Restart the Wacom tablet driver without sudo.

set -e
/bin/launchctl kickstart -k "gui/$(/usr/bin/id -u)/com.wacom.wacomtablet"
echo "Wacom driver restarted."
