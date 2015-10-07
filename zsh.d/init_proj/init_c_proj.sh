#!/bin/bash
if [ $(basename $0) = $(basename $BASH_SOURCE) ]; then
  echo "$(basename $BASH_SOURCE) should not be called directly" > /dev/stderr
  exit 1
fi

# do nothing if directory is dirty
if [ $(ls | wc -l) -ne 0 ]; then
  echo "directory is dirty" > /dev/stderr
  exit 2
fi

# initialize c project
mkdir bin src include
cp $templates_dir/c/Makefile .
