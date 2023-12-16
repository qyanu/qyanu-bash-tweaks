#!/bin/bash
##
# upload the latest package to webpage qyanu.net/software
##
set -eu
MYDIR="$(test -L "$0" \
    && echo "$(dirname -- "$(realpath -- "$(dirname -- "$0")/$(readlink -- "$0")")")" \
    || echo "$(realpath -- "$(dirname -- "$0")")")"
umask 077

cd "${MYDIR}/.."

PACKAGE="$(dpkg-parsechangelog -S Source)"
VERSION="$(dpkg-parsechangelog -S Version)"


# need variable "OPERATIONS_BASEDIR"
. "${MYDIR}/.env"

if [[ -z "${OPERATIONS_BASEDIR}" ]]; then
    echo "need variable OPERATIONS_BASEDIR in environment or .env file!" >&2
    exit 1
fi


# check that the package to upload is complete
files=(
    "../${PACKAGE}_${VERSION}.tar.xz"
    "../${PACKAGE}_${VERSION}_all.deb"
    "../${PACKAGE}_${VERSION}.dsc"
    )
for file in "${files[@]}"; do
    if [[ ! -r "${file}" ]]; then
        echo "ERROR: missing or not readable: $file" >&2
        exit 1
    fi
done

# and also separately sign the .deb file if not already done
if [[ ! -f "../${PACKAGE}_${VERSION}_all.deb.sig" ]];
then
    gpg --detach-sign --armor \
        --output "../${PACKAGE}_${VERSION}_all.deb.sig" \
        "../${PACKAGE}_${VERSION}_all.deb"
fi
files+=("../${PACKAGE}_${VERSION}_all.deb.sig")


# verify all the signatures against the latest set of trusted keys
# in order to be sure that everything is in order before uploading
# it to the qyanu.net/software homepage
dscverify \
    --no-default-keyrings \
    --keyring "${HOME}/.gnupg/qyanu-net-software-trustedkeys.kbx" \
    "../${PACKAGE}_${VERSION}_amd64.changes"
dscverify \
    --no-default-keyrings \
    --keyring "${HOME}/.gnupg/qyanu-net-software-trustedkeys.kbx" \
    "../${PACKAGE}_${VERSION}.dsc"
# Note: check if gnupg reports a valid signature by any of the keys
# in the set of trusted keys. this also mitigates the case, where the
# above gpg --detach-sign 
gpg --verify \
    --no-default-keyring \
    --keyring "${HOME}/.gnupg/qyanu-net-software-trustedkeys.kbx" \
    --status-fd 1 \
    "../${PACKAGE}_${VERSION}_all.deb.sig" \
    "../${PACKAGE}_${VERSION}_all.deb" \
    | grep -Pe "^\[GNUPG:\] VALIDSIG "



# actually upload the files
install --mode=a=rX,u+w \
    --verbose \
    -t "${OPERATIONS_BASEDIR}/source/_packages/${PACKAGE}/" \
    "${files[@]}" \
    #

##
# edit the html portion of the qyanu.net/software homepage in order
# to reference now the new files
##
(
    cd "${OPERATIONS_BASEDIR}"
)
(
    cd "${OPERATIONS_BASEDIR}"
    sed -r \
        -e "s/${PACKAGE}_([0-9]+\.){3}/${PACKAGE}_${VERSION}./g" \
        -e "s/${PACKAGE}_([0-9]+\.){2}[0-9]+_/${PACKAGE}_${VERSION}_/g" \
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
