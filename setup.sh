#!/bin/bash
# My Emacs Config setup script

TIME="$(date +%Y-%M-%d_%H_%M_%S)"
STEP=0

function check_old
{
    if [ -L "$HOME/$1" ]; then
        echo "Found old $1 symlink, unlinking"
        unlink "$HOME/$1"
        return
    fi
    if [ -f "$HOME/$1" ] || [ -d "$HOME/$1" ]; then
        echo "Found old $1, archiving to '$HOME/$1.old.$TIME'"
        mv -v "$HOME/$1" "$HOME/$1.old.$TIME"
        return
    fi
}

function step { let "STEP++"; echo "[$STEP/4] $1..."; }

step 'Checking existing config'

check_old ".emacs"
check_old ".emacs.d"

step 'Installing new config'

SCRIPT_DIR=$(dirname $(readlink -f "$BASH_SOURCE"))

ln -sv "$SCRIPT_DIR/emacs_init" "$HOME/.emacs" &&
ln -sv $SCRIPT_DIR "$HOME/.emacs.d" &&

step 'Installing packages (this may take a while)' &&
emacs &&
echo 'Done.' && EXIT_CODE=0 || echo 'An Error occured.' && EXIT_CODE=1

exit $EXIT_CODE
