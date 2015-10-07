#!/bin/bash

if [ $# -eq 0 ]; then
  echo "error: number of args"
  exit 1
fi

init_proj_dir=$(cd $(dirname $0)/../init_proj; pwd)
templates_dir=$init_proj_dir/templates

case $1 in
  c)
    . $init_proj_dir/init_c_proj.sh
    ;;
  *)
    echo "no such type";;
esac
