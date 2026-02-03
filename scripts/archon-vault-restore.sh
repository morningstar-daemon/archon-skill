#!/bin/bash
# Restore file from Archon vault
# Usage: archon-vault-restore.sh <vault-name> <item-name> <output-path>

set -e

# Detect platform and set appropriate commands
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/detect-platform.sh"

VAULT_NAME="${1:?Usage: $0 <vault-name> <item-name> <output-path>}"
ITEM_NAME="${2:?}"
OUTPUT_PATH="${3:?}"

# Passphrase must be set in environment (never hardcode!)
if [ -z "$ARCHON_PASSPHRASE" ]; then
    echo "Error: ARCHON_PASSPHRASE environment variable not set" >&2
    exit 1
fi

export ARCHON_CONFIG_DIR="${ARCHON_CONFIG_DIR:-$HOME/.config/hex/archon}"

cd "$ARCHON_CONFIG_DIR" || exit 1

echo "Restoring from vault: $VAULT_NAME"
echo "  Item: $ITEM_NAME"
echo "  Output: $OUTPUT_PATH"

keymaster get-vault-item "$VAULT_NAME" "$ITEM_NAME" "$OUTPUT_PATH"

if [ -f "$OUTPUT_PATH" ]; then
    FILESIZE=$($STAT_SIZE "$OUTPUT_PATH")
    CHECKSUM=$($CHECKSUM_CMD "$OUTPUT_PATH" | awk '{print $1}')
    echo "✓ Restored successfully"
    echo "  Size: $FILESIZE bytes"
    echo "  SHA256: $CHECKSUM"
else
    echo "✗ Restore failed" >&2
    exit 1
fi
