#!/usr/bin/env bash

# See https://stackoverflow.com/questions/59895/
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${script_dir}/colors.sh
source ${script_dir}/projects.sh

for subproject in ${subprojects[*]}
do
    pushd ${subproject} >/dev/null

    stagedChanges=0;
    onlyModified=0;
    untracked=$(git ls-files --other --exclude-standard | wc -l | xargs)

    # Wie viele Einträge in der Git-Stash-Hölle?
    stashes=$(git stash list | wc -l | sed -e 's/[[:space:]]//g' )

    # Änderungen hinzugefügt, ober nicht commited?
    if [[ $(git diff --staged --exit-code --quiet 2>/dev/null >&2)$? == 1 ]];
    then stagedChanges=1; fi

    # Dateien geändert, aber nicht im Staging?
    if [[ $(git diff --exit-code --quiet 2>/dev/null >&2)$? == 1 ]];
    then onlyModified=1; fi

    # Jetzt wird es bunt!

    if [[ ${onlyModified} == 1 ]];
    then modifiedToken="${txtred}M";
    else modifiedToken="${txtgrn}M"; fi

    if [[ ${untracked} -gt 0 ]];
    then untrackedToken="${txtred}U";
    else untrackedToken="${txtgrn}U"; fi

    if [[ ${stagedChanges} == 1 ]];
    then stagedToken="${txtred}S";
    else stagedToken="${txtgrn}S"; fi

    printf "%50s\tStaged %4s\tModified %4s\tUntracked %4s\tStash %2s\n" ${subproject} ${stagedChanges} ${onlyModified} ${untracked} ${stashes}
    popd >/dev/null
done


