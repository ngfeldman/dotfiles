#!/bin/bash
set -e

cd $(dirname "${BASH_SOURCE[0]}")
DIRNAME=$(pwd)
HOMEDIR=$(echo $HOME)  # in case this doesn't work later I guess...

function confirm_overwrite_if_exists {
    if [ -f "$1" ]; then
        yn=""
        while true; do
            if [ "${yn}" == "y" ]; then
		echo "deleting $1"
                rm "$1"
		return 0
            fi
	    if [ "${yn}" == "n" ]; then
                return 1
            fi
            printf "overwrite $1? [yn]: "
	    read yn
        done
    fi
    return 0
}

echo "Downloading external resources..."
mkdir -p downloaded
wget -O downloaded/git-completion.bash \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
wget -O downloaded/git-completion.zsh \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh


echo "Compiling config files..."
mkdir -p compiled

# stupidly relying on lines starting with '#' being a comment in all cases
for filename in $(ls all/); do
    sourcepath="${DIRNAME}/all/${filename}"
    destpath="${DIRNAME}/compiled/${filename}"
    echo "copying ${sourcepath} to ${destpath}"
    echo "# This file was initially generated by ${DIRNAME}/install.sh" > "${destpath}"
    echo "# Try diffing this file against ${destpath} to see what changes have been made" >> "${destpath}"
    echo "# to this file since the last time that script was run." >> "${destpath}"
    echo "" >> "${destpath}"
    cat "${sourcepath}" >> "${destpath}"
done

echo
echo "Installing config files..."

sourcepath="${DIRNAME}/compiled/gitconfig"
destpath="${HOMEDIR}/.gitconfig"
confirm_overwrite_if_exists "${destpath}" \
    && echo "copying ${sourcepath} to ${destpath}" \
    && cp "${sourcepath}" "${destpath}" \
    || echo "skipped copying ${sourcepath} to ${destpath}"

sourcepath="${DIRNAME}/compiled/sshconfig"
destpath="${HOMEDIR}/.ssh/config"
confirm_overwrite_if_exists "${destpath}" \
    && echo "copying ${sourcepath} to ${destpath}" \
    && cp "${sourcepath}" "${destpath}" \
    || echo "skipped copying ${sourcepath} to ${destpath}"

sourcepath="${DIRNAME}/compiled/zshrc"
destpath="${HOMEDIR}/.zshrc"
confirm_overwrite_if_exists "${destpath}" \
    && echo "copying ${sourcepath} to ${destpath}" \
    && cp "${sourcepath}" "${destpath}" \
    || echo "skipped copying ${sourcepath} to ${destpath}"

mkdir -p "${HOMEDIR}/.zsh"
sourcepath="${DIRNAME}/downloaded/git-completion.bash"
destpath="${HOMEDIR}/.zsh/git-completion.bash"
confirm_overwrite_if_exists "${destpath}" \
    && echo "copying ${sourcepath} to ${destpath}" \
    && cp "${sourcepath}" "${destpath}" \
    || echo "skipped copying ${sourcepath} to ${destpath}"
sourcepath="${DIRNAME}/downloaded/git-completion.zsh"
destpath="${HOMEDIR}/.zsh/git-completion.zsh"
confirm_overwrite_if_exists "${destpath}" \
    && echo "copying ${sourcepath} to ${destpath}" \
    && cp "${sourcepath}" "${destpath}" \
    || echo "skipped copying ${sourcepath} to ${destpath}"

echo "Done!"
