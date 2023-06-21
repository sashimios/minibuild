#!/bin/bash

#
# Minibuild - gen-deb.sh
#
# This is the entry script for genrating deb artifact.
# Should be invoked by Diel.
#

### Load shared library
libs_list="/usr/bin/spm-bash.lib.sh /usr/local/bin/spm-bash.lib.sh"
for src in $libs_list; do
    [[ -e "$src" ]] && source "$src"
done





source "$spec_path"
source "$(dirname "$spec_path")"/autobuild/defines
if [[ -z "$REL" ]]; then
    REL=0
fi



log_info "Writing meta info into '$MASTER_DIR/output/DEBIAN/control'"
cat "$1" > "$MASTER_DIR/output/DEBIAN/control"
