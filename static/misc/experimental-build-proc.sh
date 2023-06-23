# ======================================================================
# This procedure was used for experimental purposes only.
# Now we only use `ab3-proc.sh`.
# ======================================================================

### Determine ABTYPE
cd "$SRCDIR"
log_info "SRCDIR is: $PWD"

if [ -z "$ABTYPE" ]; then
    cd "$SRCDIR"
    log_info "Current PWD is: $PWD"
    ls "$MASTER_DIR"/*
	for i in $ABBUILDS; do
		# build are all plugins now.
		if build_${i}_probe; then
			export ABTYPE=$i
			break 
		fi
	done
fi
if [ -z "$ABTYPE" ]; then
    log_info "Current PWD is: $PWD"
    ls
	abdie "Cannot determine build type."
fi




### Additional variables before building
[[ -z "$MAKEOPTS" ]] && MAKEOPTS="-j$(nproc)"
export MAKEFLAGS="$MAKEFLAGS $MAKEOPTS"
log_info "MAKEFLAGS is set to: $MAKEFLAGS"

### Load `prepare` script
if [[ -e "$MASTER_DIR/meta/autobuild/prepare" ]]; then
    bash "$MASTER_DIR/meta/autobuild/prepare" || die "The package-defined 'prepare' script reported an error."
fi

### Prefer special build script
if [[ -e "$MASTER_DIR/meta/autobuild/build" ]]; then
    source "$MASTER_DIR/meta/autobuild/build" || die "The package-defined 'build' script reported an error."
    exit $?
fi

### Use defined functions
build_${ABTYPE}_build || die "Package-specific building script failed."
