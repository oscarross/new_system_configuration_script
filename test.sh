# #!/usr/bin/env bash

function log {
    echo "${CI}"
    if [[ -z "${CI}" ]]; then
        echo "🔵 $1"
    else
        echo "DUPA"
    fi
}

# function install {
#     cmd=$1
#     shift
#     for pkg in "$@";
#     do
#         exec="$cmd $pkg"
#         # prompt "Execute: $exec"
#         log "Executing: $exec"
#         $exec
#         if ${exec} ; then
#             echo "Installed $pkg"
#         else
#             echo "Failed to execute: $exec"
#         if [[ ! -z "${CI}" ]]; then
#             exit 1
#         fi
#     fi
#     done
# }

# function brew_install_or_upgrade {
#     if brew ls --versions "$1" >/dev/null; then
#         if (brew outdated | grep "$1" > /dev/null); then
#             echo "Upgrading already installed package $1 ..."
#             brew upgrade "$1"
#         else
#             echo "Latest $1 is already installed"
#         fi
#     else
#         brew install "$1"
#     fi
# }

# BREWS=(
#     bash
#     bash-snippets
#     # "bash-snippets --without-all-tools --with-weather" #NOT WORK
#     coreutils
#     findutils
#     ffmpeg
#     git
#     git-extras
#     git-lfs
#     git-flow
#     httpie
#     imagemagick
#     m-cli
#     mackup
#     nano
#     mas
#     moreutils
#     python
#     python3
#     ruby
#     "rbenv ruby-build"
#     shellcheck
#     stormssh
#     thefuck
#     tree
#     trash
#     "wget --with-iri"
#     "sh-syntax-highlighting"

#     #   poppler # PDF rendering library
# )

# echo "Install packages"
# install 'brew_install_or_upgrade' "${BREWS[@]}"
# brew link --overwrite ruby


if [[ $(command -v brew) == "" ]]; then
    echo "Install Homebrew"
    # ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    # if [[ -z "${CI}" ]]; then
        log
        log " 🍺 Update Homebrew"
        # brew update
        # brew upgrade
        # brew doctor
    # fi
    echo "Installed"
fi