#!/bin/bash
set -eu -o pipefail

FILETOEDIT="$1"

marker="qyanu-bash-tweaks"

if [[ ! -r "$FILETOEDIT" ]]; then
    echo "ERROR: cannot find file to edit: $FILETOEDIT" >&2
    exit 1
fi
}

sed -r \
  -e "/^## BEGIN: ${marker}/,/^## END: ${marker}/d" \
  -i "$FILETOEDIT"
(
echo "## BEGIN: ${marker}"
echo . /etc/profile.d/qyanu-bash-aliases.sh
echo . /etc/profile.d/qyanu-bash-prompt.sh
echo "## END: ${marker}"
) | tee -a "$FILETOEDIT"
