#!/bin/bash
set -eu -o pipefail

FILETOEDIT="$1"

marker="qyanu-bash-tweaks"

[[ -r "$FILETOEDIT" ]] || {
    echo "ERROR: cannot find file to edit: $FILETOEDIT" >&2
    exit 1
}

sed -r \
  -e "/^## BEGIN: ${marker}/,/^## END: ${marker}/d" \
  -i "$FILETOEDIT"
(
echo "## BEGIN: ${marker}"
echo . /etc/profile.d/qyanu-bash-aliases.sh
echo . /etc/profile.d/qyanu-bash-promp.sh
echo "## END: ${marker}"
) | tee -a "$FILETOEDIT"
