#!/usr/bin/env bash

# See https://stackoverflow.com/questions/59895/
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${script_dir}/colors.sh
source ${script_dir}/projects.sh

BASEDIR="${HOME}/jqaquick"
SUFFIX=`date -u +"%Y-%m-%d-%H-%M-%S"`
TARGET="${BASEDIR}/${SUFFIX}"

mkdir -p ${TARGET}

pushd ${TARGET}

for subproject in ${subprojects[*]}
do
    echo
    echo "${GREEN}###${RESET}"
    echo "${GREEN}### Cloning $subproject${RESET} into ${TARGET}/${subproject}"
    echo "${GREEN}###${RESET}"
    echo

    git clone \
        -o gh \
        git@github.com:jqassistant/${subproject} \
        ${TARGET}/${subproject}

done

jqconfiguregit.sh

popd

