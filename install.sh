#!/bin/bash

vim_dir="$HOME/.config/vim"
if [ ! -d "$vim_dir" ]; then
    touch "$vim_dir"
fi

mv * "$vim_dir"
tee -a $HOME/.bashrc | tee -a $HOME/.zshrc > /dev/null << EOF
export MYVIMRC="$vim_dir/vimrc"
alias vim="vim -u $MYVIMRC"
EOF


