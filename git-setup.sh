#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/luxo.conf"

echo "== git-setup.sh =="

GIT_IGNORE_GLOBAL="${HOME}/.gitignore_global"

if ! command -v git >/dev/null 2>&1;
then 
    print_yellow "Installing git..."
    brew install git
fi 

echo "Setting git username"
git config --global user.name "${GIT_NAME}"

echo "Setting git email"
git config --global user.email "${GIT_EMAIL}"

echo "Creating global .gitignore"
if [[ ! -f ${GIT_IGNORE_GLOBAL} ]]; 
then 
    echo "Creating default global gitignore: ${GIT_IGNORE_GLOBAL}"
    cat << EOF > "${GIT_IGNORE_GLOBAL}"
*~
.DS_Store
EOF
fi

git config --global core.excludesfile "${GIT_IGNORE_GLOBAL}"
echo "Setting pull to not rebase"
git config --global pull.rebase "false"
echo "Setting credentials helper"
git config --global credential.helper "osxkeychain"
echo "Setting default branch to main"
git config --global init.defaultBranch "main"
echo "Setting default editor"
git config --global core.editor "vim"

if [[ "$1" != "--skip-signed-commits" ]];
then
    echo "Setting up signed commits"
    git config --global gpg.program "$(which gpg)"
    git config --global commit.gpgsign true

    GPG_KEY=$(gpg --list-secret-keys --with-colons 2>/dev/null | awk -F: '/^sec/{print $5; exit}')

    if [ -z "$GPG_KEY" ];
    then
        print_yellow "No GPG key found. Generating a new key..."
        gpg --quick-generate-key "${GIT_NAME} <${GIT_EMAIL}>" default default 1y
        GPG_KEY=$(gpg --list-secret-keys --keyid-format LONG | grep sec | head -1 | awk '{print $2}' | cut -d'/' -f2)
        print_green "GPG key generated: $GPG_KEY"
    fi

    git config --global user.signingkey "$GPG_KEY"
    print_yellow "GPG signing key set to: $GPG_KEY"
else
    echo "Skipping signed commits setup."
fi

print_green "Done"
