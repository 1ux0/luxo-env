#!/bin/bash

source color.sh

# script flags
NO_VIM=false
NO_BIN=false
NO_HASKELL=false
NO_JS=false
NO_PYTHON=false

show_help() {
	echo "Usage: $0 [OPTIONS]"
	echo ""
	echo "Options:"
	echo "  --no-vim      Skip Vim setup."
	echo "  --no-bin      Skip Binary setup."
	echo "  --no-haskell  Skip Haskell setup."
	echo "  --no-js       Skip JavaScript setup."
	echo "  --no-python   Skip Python setup."
	echo "  -h, --help    Show this help message and exit."
	exit 0
}

while [[ "$#" -gt 0 ]]; do
	case "$1" in
		--no-vim) NO_VIM=true ;;
		--no-bin) NO_BIN=true ;;
		--no-haskell) NO_HASKELL=true ;;
		--no-js) NO_JS=true ;;
		--no-python) NO_PYTHON=true ;;
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
	|_|\__,_/_/\_\___/  .env                  
	"

	if ! command -v brew >/dev/null 2>&1; 
	then 
		print_yellow "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"	
	fi

	print_blue "Updating Homebrew..."
	brew update
	sleep 3

	print_blue "Installing Homebrew base packages..."

	brew install gnupg \
		pinentry-mac \
		httpie

	print_green "Done"
	sleep 3

	./git-setup.sh
	sleep 3

#./zsh-setup.sh
sleep 3

if [[ "${NO_PYTHON}" == false ]]; 
then
	./python-setup.sh
	sleep 3
else
	echo "Skipping Python setup."
fi

if [[ "${NO_JS}" == false ]]; 
then
	./js-setup.sh
	sleep 3
else
	echo "Skipping JavaScript setup."
fi

if [[ "${NO_HASKELL}" == false ]]; 
then
	./haskell-setup.sh
	sleep 3
else
	echo "Skipping Haskell setup."
fi

if [[ "${NO_VIM}" == false ]]; 
then
	./vim-setup.sh
	sleep 3
else
	echo "Skipping Vim setup."
fi

if [[ "${NO_BIN}" == false ]]; 
then
	./bin-setup.sh
	sleep 3
else
	echo "Skipping Local binary setup."
fi

echo "Setting key repeat on hold instead of special char..."
defaults write -g ApplePressAndHoldEnabled -bool false

print_green "Setup complete 🤝"
zsh
source ~/.zshrc
