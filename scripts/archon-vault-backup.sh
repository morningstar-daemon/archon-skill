#!/bin/bash
# Backup file to Archon vault
# Usage: archon-vault-backup.sh <vault-name> <file-path>

set -e

# Detect platform and set appropriate commands
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/detect-platform.sh"

VAULT_NAME="${1:?Usage: $0 <vault-name> <file-path>}"
FILE_PATH="${2:?}"

# Convert to absolute path before cd
FILE_PATH=$(realpath "$FILE_PATH")

if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File not found: $FILE_PATH" >&2
    exit 1
fi

# Passphrase must be set in environment (never hardcode!)
if [ -z "$ARCHON_PASSPHRASE" ]; then
    echo "Error: ARCHON_PASSPHRASE environment variable not set" >&2
    exit 1
fi

export ARCHON_CONFIG_DIR="${ARCHON_CONFIG_DIR:-$HOME/.config/hex/archon}"

cd "$ARCHON_CONFIG_DIR" || exit 1

FILESIZE=$($STAT_SIZE "$FILE_PATH")
CHECKSUM=$($CHECKSUM_CMD "$FILE_PATH" | awk '{print $1}')

echo "Backing up to vault: $VAULT_NAME"
echo "  File: $FILE_PATH ($FILESIZE bytes)"
echo "  SHA256: $CHECKSUM"

keymaster add-vault-item "$VAULT_NAME" "$FILE_PATH"

echo "✓ Backup complete"
