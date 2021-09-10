#!/bin/bash
set -eu -o pipefail
MYDIR="$(realpath "$(dirname "$0")")"

#
# upload the latest package to qyanu.net/software
#
PACKAGE=qyanu-bash-tweaks


# need variable "OPERATIONS_BASEDIR"
# need variable "USER"
# need variable "GROUP"
. "$MYDIR/.env"


# check validity of existing checksums
(
    cd "$OPERATIONS_BASEDIR/source/_packages"
    gpg --decrypt SHA256SUM.signed \
        | sha256sum --check
)


# add new package to webpage
cd "$MYDIR/.."

VERSION="$(<./VERSION)"


make package

install -o "$USER" -g "$GROUP" --mode=a=rX,u+w \
    -t "$OPERATIONS_BASEDIR/source/_packages/${PACKAGE}/" \
    "${PACKAGE}_${VERSION}.tar.bz2"

(
    cd "$OPERATIONS_BASEDIR/source/_packages/${PACKAGE}"
    rm -f SHA256SUM SHA256SUM.signed
    find . -type f \! -name "SHA256SUM*" -printf "%P\\0" \
        | sort -z \
        | xargs -0 sha256sum --binary \
        > SHA256SUM
    gpg --clearsign --output SHA256SUM.signed SHA256SUM
    chown "${USER}:${GROUP}" SHA256SUM.signed SHA256SUM
    chmod a=rX,u+w SHA256SUM.signed SHA256SUM
)
(
    cd "$OPERATIONS_BASEDIR"
    sed -re "s/${PACKAGE}_([0-9]+\.){3}/${PACKAGE}_${VERSION}./g" \
        -i "source/${PACKAGE}/index.rst"
    git diff HEAD
    read -p "accept and commit changes? (Ctrl+C to abort, any key to continue)"
    git add -A
    git commit -m "publish ${PACKAGE} v${VERSION}"
    make clean html
    git add -A
    git commit -m 'exec `make clean html`'
    bash support/sync-to-live.sh
)
