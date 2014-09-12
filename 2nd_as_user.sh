#!/bin/bash

# $ source THIS_FILE

export GOPATH=$HOME/.golang
go get github.com/motemen/ghq
go get github.com/peco/peco/cmd/peco

export PATH=PATH:$GOPATH/bin 

