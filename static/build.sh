#!/bin/bash

#
# Minibuild - build.sh
#
# This is the entry script for building.
# Should be invoked by Diel.
#

### Load shared library
libs_list="/usr/bin/spm-bash.lib.sh /usr/local/bin/spm-bash.lib.sh"
for src in $libs_list; do
    [[ -e "$src" ]] && source "$src"
done


### Constant variables
export MINIBUILD_DIR="/usr/local/lib/minibuild"  # Prefer manual installation
[[ ! -d "$MINIBUILD_DIR" ]] && export MINIBUILD_DIR="/usr/lib/minibuild"  # Fallback to distro-provided installation



for src in "$MINIBUILD_DIR/static/ab3lib/"*.sh; do
    source "$src"
done





### Load configuration
CONF=/etc/diel/make.conf
[[ -e $CONF ]] && source $CONF

cd "$MASTER_DIR"
export DESTDIR="$MASTER_DIR/output"


### Load package metadata
source "$spec_path"  # Security implications...
source "$(dirname "$spec_path")"/autobuild/defines
[[ -e "$(dirname "$spec_path")"/dbuild.sh ]] && source "$(dirname "$spec_path")"/dbuild.sh
log_info "Ready to build package $pkg_id"

### Load class-specific functions
[[ -z "$DIEL_CLASS" ]] && DIEL_CLASS=std
if [[ "$DIEL_CLASS" == "special" ]] || [[ -e "$MASTER_DIR/meta/autobuild/build" ]]; then
    source "$(dirname "$spec_path")"/dbuild.sh
else
    source "/usr/local/lib/minibuild/static/class/$DIEL_CLASS.sh"
fi

### Use defined functions
cd "$MASTER_DIR/work"
start_building || die "Package-specific building script failed"

### Preparation works for the next stage
mkdir -p "$MASTER_DIR/output/DEBIAN"
