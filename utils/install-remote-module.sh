#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ "$#" -eq 1 ]; then
    GIT_OWNER="biosphere-switch"
    GIT_REPO=$1
elif [ "$#" -eq 2 ]; then
    GIT_OWNER=$1
    GIT_REPO=$2
else
    echo "Invalid parameters"
    exit
fi

URL=https://github.com/$GIT_OWNER/$GIT_REPO
echo "Cloning '$URL'..."

MODULE_TEMP_DIR=$ROOT_DIR/remote-tmp/$GIT_REPO
rm -rf $MODULE_TEMP_DIR
mkdir -p $MODULE_TEMP_DIR

# Clone from GitHub
git clone --recurse-submodules $URL $MODULE_TEMP_DIR
if [ $? -ne 0 ]; then
    rm -rf $MODULE_TEMP_DIR
    echo "Could not access remote module - is git installed?"
    exit
fi

# Build the module (make build)
make build -C $MODULE_TEMP_DIR
if [ $? -ne 0 ]; then
    rm -rf $MODULE_TEMP_DIR
    echo "Could not build module"
    exit
fi

# Install the module
make install -C $MODULE_TEMP_DIR
if [ $? -ne 0 ]; then
    rm -rf $MODULE_TEMP_DIR
    echo "Could not install module"
    exit
fi

rm -rf $MODULE_TEMP_DIR