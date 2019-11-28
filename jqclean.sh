#!/usr/bin/env bash

# See https://stackoverflow.com/questions/59895/
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${script_dir}/colors.sh
source ${script_dir}/projects.sh

for subproject in ${subprojects[*]}
do
    echo
    echo "${GREEN}###${RESET}"
    echo "${GREEN}### Cleaning $subproject${RESET}"
    echo "${GREEN}###${RESET}"
    echo

    pushd ~/code/jqa/${subproject}

    if [[ -z "$@" ]]; then
        ( mvn clean ) || exit 1
    else
        ( mvn $@ ) || exit 1
    fi
    popd
done


