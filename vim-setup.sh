#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/luxo.conf"

echo "== vim-setup.sh =="

if ! command -v vim >/dev/null 2>&1;
then 
    echo "Installing vim..."
    brew install vim
fi 


if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]];
then
    echo "Adding vim plugin manager"
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs "$VIM_PLUGIN_MANAGER"
fi

print_yellow "Setting up .vimrc and overwriting if exists"

cat << EOF > "$HOME/.vimrc"
call plug#begin('~/.vim/plugged')
Plug 'ayu-theme/ayu-vim'
call plug#end()

inoremap jj <ESC>
:set number
:set showmatch
:set autowrite
:syntax on
:set wrap

set termguicolors     " enable true colors support
let ayucolor="dark"   " options: light, mirage, dark
colorscheme ayu

set autochdir
filetype indent on
set smartindent
autocmd BufNewFile *.sh normal gg=G
set backspace=indent,eol,start
EOF

# install plugins
vim +'PlugInstall --sync' +qa

print_green "Done"