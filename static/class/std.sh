#!/bin/bash




function real_build() {
    log_info "Entering 'real_build'"
    cd "$MASTER_DIR/work"
    if [[ -d "$SUBDIR" ]]; then
        SRCDIR="$MASTER_DIR/work/$SUBDIR"
    else
        SRCDIR="$MASTER_DIR/work/$(ls | head -n1)"
    fi
    cd "$SRCDIR"

    ### Borrowed variables from Autobuild3
    # export SRCDIR="$PWD"
    export BLDDIR="$SRCDIR/abbuild"
    export PKGDIR="$SRCDIR/abdist"
    export SYMDIR="$SRCDIR/abdist-dbg"

    ### Load default runtime config
    # source "$MINIBUILD_DIR/static/misc/ab3_defcfg.sh"

    [[ -e "$MASTER_DIR"/meta/autobuild/prepare ]] && source "$MASTER_DIR"/meta/autobuild/prepare

    ### Use a separate build dir?
    [[ -z $ABSHADOW ]] && ABSHADOW=1
    if bool "$ABSHADOW"; then
        pwd
		log_info "Creating directory for shadow build ..."
		mkdir -pv "$BLDDIR" \
			|| die "Failed to create shadow build directory: $?."
		cd "$BLDDIR" \
			|| die "Failed to enter shadow build directory: $?."
        pwd
        ../configure $AUTOTOOLS_AFTER || die "Configure phase error"
	else
        ### Build in repo root
        pwd
        ./configure $AUTOTOOLS_AFTER || die "Configure phase error"
	fi

    ### Work with Makefile
    if [[ -z "$MAKE_TARGETS" ]]; then
        for target in $MAKE_TARGETS; do
            make "$target"
        done
    else
        make all
    fi
    make install $MAKE_AFTER DESTDIR="$MASTER_DIR/output" || die "Cannot run 'make install'. Permission problem?"
}

### Entry function
function start_building() {
    real_build
}


