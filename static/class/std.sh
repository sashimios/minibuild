#!/bin/bash

function src_unpack() {
    log_info "Entering 'src_unpack'"
    cd "$MASTER_DIR/work"
    for tar in "$MASTER_DIR"/fetch/*.tar*; do
        tar -pxf "$tar"
    done
}

function real_build() {
    log_info "Entering 'real_build'"
    cd "$MASTER_DIR/work"
    if [[ -d "$SUBDIR" ]]; then
        cd "$SUBDIR"
    else
        cd $(ls | head -n1)
    fi
    ./configure $AUTOTOOLS_AFTER
    if [[ -z "$MAKE_TARGETS" ]]; then
        for target in $MAKE_TARGETS; do
            make "$target"
        done
    else
        make all
    fi
    make install DESTDIR="$MASTER_DIR/output" || die "Cannot run 'make install'. Permission problem?"
}

### Entry function
function start_building() {
    src_unpack
    real_build
}


