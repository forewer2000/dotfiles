#!/bin/bash
set -e

VIMDIR="$HOME/.vim"
PATHOGEN_URL="https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"

declare -A vim_plugins
vim_plugins[COMMANDT]="git://git.wincent.com/command-t.git"
vim_plugins[SUPERTAB]="https://github.com/ervandew/supertab.git"
vim_plugins[SYNTASTIC]="https://github.com/scrooloose/syntastic.git"
vim_plugins[TABULAR]="https://github.com/godlygeek/tabular.git"
vim_plugins[TMUX_VIM]="https://github.com/sdt/tmux-vim.git"
vim_plugins[VIM_SOLARIZED]="https://github.com/altercation/vim-colors-solarized.git"
vim_plugins[VIM_FUGITIVE]="https://github.com/tpope/vim-fugitive.git"
vim_plugins[POWER_LINE]="https://github.com/Lokaltog/vim-powerline.git"
vim_plugins[VIM_SURROUND]="https://github.com/tpope/vim-surround.git"
vim_plugins[FLAKE8]="https://github.com/nvie/vim-flake8.git"

IR_BLACK_COLOR="https://raw.github.com/forewer2000/dotfiles/master/colors/ir_black.vim"
VIM_RC_FILE="https://raw.github.com/forewer2000/dotfiles/master/.vimrc"

echo "Installing vim for user: $USER"
echo "Home directory: $HOME"


if [ ! -d $VIMDIR ]; then
    echo "Creating directory $VIMDIR"
    mkdir $VIMDIR || {
        echo "Can't create directory $VIMDIR"
        exit 1
    }
fi

chmod 755 $VIMDIR || {
    echo "You don't have access to .vim directory"
    exit 1 
}

# Check if git exists

type git  >/dev/null 2>&1 || { 
    echo "Install git first. (sudo apt-get install git)"
    exit 1
}


# Check if curl exists

type curl  >/dev/null 2>&1 || { 
    echo "Install curl first. (sudo apt-get install curl)"
    exit 1
}

function install_pathogen() { 
    mkdir -p "$VIMDIR/autoload" "$VIMDIR/bundle" || {
         echo "Can't create directory for pathogen install"
         exit 1
    }

    curl -Sso ~/.vim/autoload/pathogen.vim $PATHOGEN_URL || {
         echo "Cannot download pathohen from $PATHOGEN_URL"
         exit 1 
    }
}

install_pathogen

function install_bundles() {
    # Clone all plugin repos

    (
    cd "$VIMDIR/bundle/"
    for i in "${!vim_plugins[@]}"
    do
        echo "Installing bundle: $i"
        git clone "${vim_plugins[$i]}" >/dev/null 2>&1  || {
        echo "Cannot clone url $i or already cloned"
    }
    done
    )
}

install_bundles

function configure_commandt() {
    (
        cd "$VIMDIR/bundle/command-t/ruby/command-t/"
        type ruby  >/dev/null 2>&1 || { 
            echo "No ruby => no command-t. (sudo apt-get install ruby)"
            return
        }
        ruby extconf.rb >/dev/null 2>&1 || {
            echo &2
            echo "You may install ruby-dev. (sudo apt-get install ruby-dev)"
            return
        }
        make
    )
}

configure_commandt

function configure_colors() {

     mkdir -p "$VIMDIR/colors" || {
         echo "Cannot create $VIMDIR/colors"
         return
     }
     curl -s -o "$VIMDIR/colors/ir_black.vim" $IR_BLACK_COLOR || {
         echo "Cannot download ir_black.vim from $IR_BLACK_COLOR" 
         return
     }
}

configure_colors


function flake8_deps() {
    pip install flake8
}

flake8_deps


function install_vimrc() {
   curl -s -o "$HOME/.vimrc" $VIM_RC_FILE || {
       echo "Cannot download .vimrc from $VIM_RC_FILE"
       return
   }
}

install_vimrc



