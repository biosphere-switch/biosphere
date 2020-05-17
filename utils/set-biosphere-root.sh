#!/bin/bash

# Remove if present
rm -f /etc/profile.d/biosphere-vars.sh

echo "Setting root variable 'BIOSPHERE_ROOT' in '/etc/profile.d/biosphere-vars.sh' to \"$1\"..."

# Set file with root path
echo "# Biosphere root directory (BIOSPHERE_ROOT)

export BIOSPHERE_ROOT=$1" >> /etc/profile.d/biosphere-vars.sh