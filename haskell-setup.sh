#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

echo "== haskell-setup.sh =="

if ! command -v stack >/dev/null 2>&1;
then
    print_yellow "Installing stack w ghc..."
    curl -sSL https://get.haskellstack.org/ | sh
else
    print_yellow "stack already installed"
fi

print_green "Done"