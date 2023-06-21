#!/bin/bash

function src_unpack() {
    log_info "Entering 'src_unpack'"
    cd "$MASTER_DIR/work"
    for tar in "$MASTER_DIR"/fetch/*.tar*; do
        tar -pxvf "$tar"
    done
}

function real_build() {
    log_info "Entering 'real_build'"
    cd "$MASTER_DIR/work"
    cd $(ls | head -n1)
    # echo "============================"
    # pwd
    # echo "============================"
    # ls
    # echo "============================"
    # ls *
    # echo "============================"
    ./configure $AUTOTOOLS_AFTER
    if [[ -z "$MAKE_STAGES" ]]; then
        for s in $MAKE_STAGES; do
            make $s
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


