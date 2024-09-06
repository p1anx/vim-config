#!/bin/bash

vim_dir="$HOME/.config/vim"
if [ ! -d "$vim_dir" ]; then
  mkdir "$vim_dir"
fi

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp -r * "$vim_dir"
if [ -f "$HOME/.zshrc" ]; then
  cat <<EOF | tee -a $HOME/.zshrc
export MYVIMRC="$vim_dir/vimrc"
alias vim="vim -u \$MYVIMRC"
EOF
fi

if [ -f "$HOME/.bashrc" ]; then
  cat <<EOF | tee -a $HOME/.bashrc
export MYVIMRC="$vim_dir/vimrc"
alias vim="vim -u \$MYVIMRC"
EOF
fi
echo "====================="
echo "  vim is configured"
echo "====================="
