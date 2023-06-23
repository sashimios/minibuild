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







### Extra environment variables
export TZ=UTC
export LANG=C.UTF8







### Autobuild3 compatibility layer
export AB="$MINIBUILD_DIR/legacy-ab3"
source "$MINIBUILD_DIR/static/misc/ab3-polyfill.sh"
ABMPM=dpkg  # Your main PM
ABAPMS=  # Other PMs
MTER="$USER <$USER@$HOSTNAME>"
ABINSTALL=dpkg

### Autobuild3 libraries
for src in "$MINIBUILD_DIR/legacy-ab3/lib"/{diag,base,builtins}.sh; do
    log_info "Loading legacy-ab3 library: $src"
    source "$src"
done







### Load ABTYPE support
### Note: Now we leave this problem to `ab3-proc.sh` which loads build class scripts from legacy-ab3
# for src in "$MINIBUILD_DIR/static/abtypes"/*.sh; do
#     log_info "Loading legacy-ab3 ABTYPE runtime: $src"
#     source "$src"
# done

### Determine SRCDIR
export SRCDIR="$MASTER_DIR/work"
if [[ -d "$SUBDIR" ]]; then
    export SRCDIR="$MASTER_DIR/work/$SUBDIR"
else
    export SRCDIR="$MASTER_DIR/work/$(ls | head -n1)"
fi
export BLDDIR="$SRCDIR/abbuild"
export PKGDIR="$SRCDIR/abdist"
export SYMDIR="$SRCDIR/abdist-dbg"






### Load configuration
CONF="/etc/diel/make.conf"
[[ -e $CONF ]] && source "$CONF"

cd "$MASTER_DIR"
export DESTDIR="$MASTER_DIR/output"


### Load package metadata
source "$MASTER_DIR/meta/spec"  # Security implications...
source "$MASTER_DIR/meta/autobuild/defines"
log_info "Ready to build package $pkg_id"






# ========================================================
# Enter the build procedure...
# ========================================================
source "$MINIBUILD_DIR/static/misc/ab3-proc.sh"






