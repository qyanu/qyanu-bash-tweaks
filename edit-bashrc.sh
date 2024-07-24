#!/bin/bash
set -eu -o pipefail

FILETOEDIT="$1"

marker="qyanu-bash-tweaks"

if [[ ! -r "$FILETOEDIT" ]]; then
    echo "ERROR: cannot find file to edit: $FILETOEDIT" >&2
    exit 1
fi


begin_marker_rex="## BEGIN: ${marker}"
end_marker_rex="## END: ${marker}"

# ensure begin marker exists
if ! grep -qPe "${begin_marker_rex}" "${FILETOEDIT}"; then
    echo "## BEGIN: ${marker}" >> "${FILETOEDIT}"
fi

# ensure an end marker after the begin marker
if ! sed -n -re "/${begin_marker_rex}/,/${end_marker_rex}/ p" \
    "${FILETOEDIT}" \
    | grep -qPe "${end_marker_rex}";
then
    sed -rf <(cat <<EOF
/${begin_marker_rex}/ {
    a ## END: ${marker}
}
EOF
    ) \
    -i "${FILETOEDIT}"
fi

# replace contents between markers with new contents
sed -rf <(cat <<EOF
/${begin_marker_rex}/,/${end_marker_rex}/ {
    //!d
    /${begin_marker_rex}/ {
        p
        e cat
        d
    }
}
EOF
    ) \
    -i "${FILETOEDIT}" \
    < <(cat <<EOF
. /etc/profile.d/qyanu-bash-aliases.sh
. /etc/profile.d/qyanu-bash-prompt.sh
EOF
    )
