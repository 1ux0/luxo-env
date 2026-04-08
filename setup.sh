#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# script flags
NO_VIM=false
NO_BIN=false
NO_HASKELL=false
NO_JS=false
NO_PYTHON=false
NO_ZSH=false
NO_GIT=false
SKIP_SIGNED_COMMITS=false

show_help() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --no-vim               Skip Vim setup."
  echo "  --no-bin               Skip Binary setup."
  echo "  --no-haskell           Skip Haskell setup."
  echo "  --no-js                Skip JavaScript setup."
  echo "  --no-python            Skip Python setup."
  echo "  --no-zsh               Skip Zsh setup."
  echo "  --no-git               Skip Git setup."
  echo "  --skip-signed-commits  Skip GPG signed commits setup."
  echo "  -h, --help             Show this help message and exit."
  exit 0
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --no-vim) NO_VIM=true ;;
    --no-bin) NO_BIN=true ;;
    --no-haskell) NO_HASKELL=true ;;
    --no-js) NO_JS=true ;;
    --no-python) NO_PYTHON=true ;;
    --no-zsh) NO_ZSH=true ;;
    --no-git) NO_GIT=true ;;
    --skip-signed-commits) SKIP_SIGNED_COMMITS=true ;;
    -h|--help) show_help ;;
    --) shift; break ;; # End of options
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

echo "
  _
 | |_   ___  _____
 | | | | \ \/ / _ \
 | | |_| |>  < (_) |
 |_|\__,_/_/\_\___/  .ai
"

if ! command -v brew >/dev/null 2>&1;
then
  print_yellow "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

print_blue "Updating Homebrew..."
brew update

print_blue "Installing Homebrew base packages..."

brew install gnupg \
  pinentry-mac \
  httpie

print_green "Done"

if [[ "${NO_GIT}" == false ]];
then
  if [[ "${SKIP_SIGNED_COMMITS}" == true ]];
  then
    "$SCRIPT_DIR/git-setup.sh" --skip-signed-commits
  else
    "$SCRIPT_DIR/git-setup.sh"
  fi
else
  echo "Skipping Git setup."
fi

if [[ "${NO_ZSH}" == false ]];
then
  "$SCRIPT_DIR/zsh-setup.sh"
else
  echo "Skipping Zsh setup."
fi

if [[ "${NO_PYTHON}" == false ]];
then
  "$SCRIPT_DIR/python-setup.sh"
else
  echo "Skipping Python setup."
fi

if [[ "${NO_JS}" == false ]];
then
  "$SCRIPT_DIR/js-setup.sh"
else
  echo "Skipping JavaScript setup."
fi

if [[ "${NO_HASKELL}" == false ]];
then
  "$SCRIPT_DIR/haskell-setup.sh"
else
  echo "Skipping Haskell setup."
fi

if [[ "${NO_VIM}" == false ]];
then
  "$SCRIPT_DIR/vim-setup.sh"
else
  echo "Skipping Vim setup."
fi

if [[ "${NO_BIN}" == false ]];
then
  "$SCRIPT_DIR/bin-setup.sh"
else
  echo "Skipping Local binary setup."
fi

echo "Setting key repeat on hold instead of special char..."
defaults write -g ApplePressAndHoldEnabled -bool false

print_green "Setup complete 🤝"
exec zsh
