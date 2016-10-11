#!/usr/bin/env bash

CURRENT_SHELL=$(echo $SHELL |tr '/' ' '|awk '{print $NF}')
ZSH_LOCATION=$(which zsh)

if [ "$CURRENT_SHELL" != "zsh" ] && [ "$ZSH_LOCATION" != "" ]; then
  chsh -s "$ZSH_LOCATION"
fi;

if [ "$(which brew)" == "" ]; then
  echo "Installing brew"
  BREW_INSTALLER=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)
  yes|/usr/bin/ruby -e "$BREW_INSTALLER"
fi;

brew update

if [ "$(which rcup)" == "" ]; then
  echo "Installing dotfile manager"
  brew tap thoughtbot/formulae
  brew install rcm
fi;

echo "Creating dotfile symlinks"
rcup `pwd`/rcrc

if [ "$(which fasd)" == "" ]; then
  echo "Installing fasd"
  brew install fasd
fi;

if [ "$(which ag)" == "" ]; then
  echo "Installing silver searcher"
  brew install ag
fi;

if [ ! -d "$HOME/.zprezto" ]; then
  echo "Installing zprezto zsh additions"
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"
  ZSH_CONFIGS="$HOME/.zsh/configs"
  if [ ! -d "$ZSH_CONFIGS" ]; then
    mkdir -p "$ZSH_CONFIGS"
  fi
  for rcfile in $(ls $HOME/.zprezto/runcoms/*|grep -v README); do
    ZTARGET="$ZSH_CONFIGS/$(echo $rcfile |tr '/' ' '|awk '{print $NF}').local"
    if [ ! -f "$ZTARGET" ]; then
      ln -s "$rcfile" "$ZTARGET"
    fi
  done
fi

