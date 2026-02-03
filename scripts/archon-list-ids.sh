#!/bin/bash
# List all DIDs in local Archon wallet

set -e

export ARCHON_CONFIG_DIR="$HOME/.config/hex/archon"
# Passphrase must be set in environment (never hardcode!)
if [ -z "$ARCHON_PASSPHRASE" ]; then
    echo "Error: ARCHON_PASSPHRASE environment variable not set" >&2
    exit 1
fi

cd "$ARCHON_CONFIG_DIR" || exit 1

echo "Local Archon DIDs:"
echo "---"
npx @didcid/keymaster list-ids
