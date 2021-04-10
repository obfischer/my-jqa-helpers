#!/usr/bin/env bash

# See https://stackoverflow.com/questions/59895/
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${script_dir}/colors.sh
source ${script_dir}/projects.sh

for subproject in ${subprojects[*]}
do
    echo
    echo "${GREEN}###${RESET}"
    echo "${GREEN}### Configuring Git $subproject via ${RESET}"
    echo "${GREEN}###${RESET}"
    echo

    pushd ${subproject}
    configure-git-private || exit 1
    popd
done


