#!/bin/bash

target="$1"
secdir="${2:-../cloudfoundry/secure}"
secfile="concourse-secrets.yml.gpg"
secrets="${secdir}/${secfile}"

if [ ! -f "${secrets}" ]
then
    echo -e 1>&2 "$0: Failed to find the secrets file ${secrets}\n\tPlease specify the correct directory holding \"${secfile}\"."
    exit 1
fi

fly -t "$target" set-pipeline -p stampy-check -c stampy-check.yaml \
    -l <(gpg -d --no-tty "${secrets}" 2> /dev/null)
