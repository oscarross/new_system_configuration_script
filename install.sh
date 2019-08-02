#!/usr/bin/env bash

# Important - install this before another
IMPORTANT_CASK=(
    dropbox
    iterm2
    java8
    slack
    spotify
    visual-studio-code
    # istat-menus
)

BREWS=(
    autoconf # to ruby
    bash
    bash-snippets
    # "bash-snippets --without-all-tools --with-weather" #NOT WORK
    coreutils
    ffmpeg
    findutils
    git
    git-extras
    git-flow
    git-lfs
    httpie
    imagemagick
    m-cli
    mackup
    mas
    moreutils
    nano
    python
    python3
    ruby
    "rbenv ruby-build"
    shellcheck
    "sh-syntax-highlighting"
    thefuck
    youtube-dl
    "wget --with-iri"
)

CASKS=(
    android-platform-tools
    android-studio
    cleanmymac
    dash
    db-browser-for-sqlite
    firefox
    google-drive
    handbrake #The open source video transcoder
    macdown
    sourcetree
    spectacle
    transmission
    vlc
    wwdc
    # tunnelbear
    # gpgtools
)

PIPS=(
    pip
    # ohmu
    # pythonpy
)

GEMS=(
    cocoapods
    fastlane
    travis
    # bundler # Ruby on Rails
)

VCCODE_EXTENSIONS=(
    2gua.rainbow-brackets
    coenraads.bracket-pair-colorizer-2
    eamodio.gitlens
    fabiospampinato.vscode-todo-plus
    foxundermoon.shell-format
    hookyqr.beautify
    mohsen1.prettify-json
    pkief.material-icon-theme
    pnp.polacode
    rebornix.ruby
    stevemoser.xcode-keybindings
    tyriar.sort-lines
)

FONTS=(
	font-hack
	font-hack-nerd-font
    font-clear-sans
    font-hack-nerd-font-mono
    font-mono
    font-noto-mono-for-powerline
    font-roboto
    font-roboto-mono-for-powerline
    font-robotomono-nerd-font-mono
)

#gpg_key='3E219504'

GIT_EMAIL='YOUR_EMAIL'
GIT_NAME='YOUR_NAME'

GIT_CONFIGS=(
    "user.name ${GIT_NAME}"
    "user.email ${GIT_EMAIL}"
    "core.editor code --wait"
    "color.status always"
    "color.ui auto"
    "code.editor code --wait"
    "merge.tool sourcetree"
    "diff.tool vscode"
    "difftool.prompt false"
    "credential.helper osxkeychain"
    "difftool.sourcetree.cmd code --wait --diff $LOCAL $REMOTE"
    "mergetool.sourcetree.cmd code --wait --diff $MERGED"
    "mergetool.sourcetree.trustExitCode true"

#    "merge.ff false"
#    "pull.rebase true"
#    "push.default simple"
#    "rebase.autostash true"
#    "rerere.autoUpdate true"
#    "remote.origin.prune true"
#    "rerere.enabled true"
#    "user.signingkey ${gpg_key}"
)

######################################## End of configuration  ########################################
set +e
set -x

function log {
    echo "🔵 $1"
}

function logError {
    echo "❌ $1"
}

function install {
    cmd=$1
    shift
    for pkg in "$@";
    do
        exec="$cmd $pkg"
        log "Executing: $exec"
        if ${exec} ; then
            log "Installed $pkg"
        else
            logError "Failed to execute: $exec"
            exit 1
    fi
    done
}

function brewInstallOrUpgrade {
    if brew ls --versions "$1" >/dev/null; then
        if (brew outdated | grep "$1" > /dev/null); then
            log "Upgrading already installed package $1 ..."
            brew upgrade "$1"
        else
            log "Latest $1 is already installed"
        fi
    else
        brew install "$1"
    fi
}

    # sudo -v # Ask for the administrator password upfront
    # # Keep-alive: update existing `sudo` time stamp until script has finished
    # while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [[ $(command -v brew) == "" ]]; then
    log "Install Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    log "Update Homebrew"
    brew update
    brew upgrade
    brew doctor
fi

export HOMEBREW_NO_AUTO_UPDATE=1

log "Install important software ..."
brew tap caskroom/versions
install 'brew cask install' "${IMPORTANT_CASK[@]}"

log "Install BREWS"
install 'brewInstallOrUpgrade' "${BREWS[@]}"
brew link --overwrite ruby

log "Configurating GIT"
for CONFIG in "${GIT_CONFIGS[@]}"
do
   git config --global ${CONFIG}
done

#if [[ -z "${CI}" ]]; then
#    gpg --keyserver hkp://pgp.mit.edu --recv ${gpg_key}
#    log "Export key to Github"
#    ssh-keygen -t rsa -b 4096 -C ${git_email}
#    pbcopy < ~/.ssh/id_rsa.pub
#    open https://github.com/settings/ssh/new
#fi

log "Install CASKS"
install 'brew cask install' "${CASKS[@]}"

log "Install PIPS"
install 'pip3 install --upgrade' "${PIPS[@]}"

log "Install GEMS"
echo 'gem: --no-document' >> ~/.gemrc # TODO: sprawdzić co to 
install 'gem install' "${GEMS[@]}"
install 'code --install-extension' "${VCCODE_EXTENSIONS[@]}"

log "Install FONTS"
brew tap caskroom/fonts
install 'brew cask install' "${FONTS[@]}"

log "Update packages"
pip3 install --upgrade pip setuptools wheel
m update install all

if [[ -z "${CI}" ]]; then
    log "Install software from App Store"
    mas list
fi

log "Cleanup"
brew cleanup
brew cask cleanup

# Setup mac system
m finder showhiddenfiles YES
m finder showextensions YES

echo "Run [mackup restore] after DropBox has done syncing ..."
echo "Done!"