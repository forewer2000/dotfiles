#!/bin/bash
set -e
if [ "$(whoami)" != "root" ]; then
    echo "You need to run with sudo on your user."
    exit 1
fi

USER_HOME=$(eval echo ~${SUDO_USER})

echo "USER HOME IS $USER_HOME"

VIMDIR="$USER_HOME/.vim"
PATHOGEN_URL="https://raw.github.com/nendre/vim-pathogen/master/autoload/pathogen.vim"

declare -A vim_plugins
vim_plugins[COMMANDT]="https://github.com/nendre/command-t.git"
vim_plugins[SUPERTAB]="https://github.com/nendre/supertab.git"
vim_plugins[SYNTASTIC]="https://github.com/nendre/syntastic.git"
vim_plugins[TABULAR]="https://github.com/nendre/tabular.git"
vim_plugins[TMUX_VIM]="https://github.com/nendre/tmux-vim.git"
vim_plugins[VIM_SOLARIZED]="https://github.com/nendre/vim-colors-solarized.git"
vim_plugins[VIM_FUGITIVE]="https://github.com/nendre/vim-fugitive.git"
vim_plugins[POWER_LINE]="https://github.com/nendre/vim-powerline.git"
vim_plugins[VIM_SURROUND]="https://github.com/nendre/vim-surround.git"
vim_plugins[FLAKE8]="https://github.com/nendre/vim-flake8.git"

IR_BLACK_COLOR="https://raw.github.com/forewer2000/dotfiles/master/colors/ir_black.vim"
GARY_COLOR="https://raw.github.com/nendre/dotfiles/master/.vim/colors/grb256.vim"
VIM_RC_FILE="https://raw.github.com/forewer2000/dotfiles/master/.vimrc"

echo "Installing vim for user: $SUDO_USER"
echo "Home directory: $USER_HOME"


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

    curl -Sso $USER_HOME/.vim/autoload/pathogen.vim $PATHOGEN_URL || {
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

     curl -s -o "$VIMDIR/colors/grb256.vim" $IR_BLACK_COLOR || {
         echo "Cannot download grb256.vim from $IR_BLACK_COLOR" 
         return
     }
}

configure_colors


function flake8_deps() {
    pip install flake8 || {
        echo "An error occoured, cannot install flake8"
        return
    }
}

flake8_deps


function install_vimrc() {
   curl -s -o "$USER_HOME/.vimrc" $VIM_RC_FILE || {
       echo "Cannot download .vimrc from $VIM_RC_FILE"
       return
   }
}

install_vimrc

chown $SUDO_USER:$SUDO_USER $USER_HOME/.vimrc
chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.vim/

