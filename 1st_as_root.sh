#!/bin/bash

# should be called by sudo `this script`

aptitude update
aptitude install -y emacs24 golang zsh

mkdir $HOME/.golang
export GOPATH=$HOME/.golang

