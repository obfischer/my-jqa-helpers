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
    branch=$(git branch 2>/dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/")
    javaversion=$(jenv version | cut -f 1 -d " ")

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
    then modifiedColor="${RED}";
    else modifiedColor="${GREEN}"; fi

    if [[ ${untracked} -gt 0 ]];
    then untrackedColor="${RED}";
    else untrackedColor="${GREEN}"; fi

    if [[ ${stagedChanges} == 1 ]];
    then stagedColor="${RED}";
    else stagedColor="${GREEN}"; fi

    if [[ ${stashes} -gt 0 ]];
    then stashedColor="${RED}";
    else stashedColor="${GREEN}"; fi

    printf "%50s\tStaged %4s\tModified %4s\tUntracked %4s\tStash %2s \t%s\t\tJava %s\n" \
      ${subproject} ${stagedColor}${stagedChanges}${RESET} \
      ${modifiedColor}${onlyModified}${RESET} ${untrackedColor}${untracked}${RESET} \
      ${stashedColor}${stashes}${RESET} ${branch} ${javaversion}
    popd >/dev/null
done


