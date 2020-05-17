#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

make -f $ROOT_DIR/mk/check-module.mk MODULE=$1