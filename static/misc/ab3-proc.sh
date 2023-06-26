### Overwrite some functions
abdie() {
	diag_print_backtrace
	echo -e "\e[1;31mautobuild encountered an error and couldn't continue.\e[0m" 1>&2
	echo -e "${1-Look at the stacktrace to see what happened.}" 1>&2
	echo "------------------------------autobuild ${ABVERSION:-3}------------------------------" 1>&2
	echo -e "Go to ‘ \e[1mhttps://github.com/sashimios/minibuild\e[0m ’ for more information on this error." 1>&2
	if ((AB_DBG)); then
		read -n 1 -p "AUTOBUILD_DEBUG: CONTINUE? (Y/N)" -t 5 AB_DBGRUN || AB_DBGRUN=false
		bool $AB_DBGRUN && abwarn "Forced AUTOBUILD_DIE continue." && return 0 || abdbg "AUTOBUILD_DIE EXIT - NO_CONTINUE"
	fi
	exit "${2-1}"
}



ab3_proc_list="
00-python_defines.sh
#10-core_defines.sh
10-env-setup.sh
#10-qa_pre_build.sh
11-cleanup.sh
11-pm_deps.sh
11-preproc.sh
12-arch_compiler.sh
12-arch_flags.sh
12-parallel.sh
20-build_funcs.sh
30-build_probe.sh
35-build_env_src.sh
36-ld_switch.patch
40-patch.sh
50-build_exec.sh
51-filter.sh
60-licenses.sh
61-conffiles.sh
70-scripts.sh
#75-qa_post_build.sh
#80-pm_pack.sh
#90-pm_install.sh
#99-pm_archive.sh
"


### Note: Loading default config erases existing package info
log_info source "$MINIBUILD_DIR/legacy-ab3/etc/autobuild/ab3_defcfg.sh"
source "$MINIBUILD_DIR/legacy-ab3/etc/autobuild/ab3_defcfg.sh"

### Get package info again
source "$MASTER_DIR/meta/spec"
source "$MASTER_DIR/meta/autobuild/defines"




### Alternative: 10-core_defines.sh
function altproc-10-core_defines() {
    abrequire arch
    . "$AB/arch/_common.sh"
    . "$AB/arch/${ABHOST//\//_}.sh" # Also load overlay configuration.
    BUILD=${ARCH_TARGET["$ABBUILD"]}
    HOST=${ARCH_TARGET["$ABHOST"]}

    [[ ${ABHOST%%\/*} != $FAIL_ARCH ]] ||
        abdie "This package cannot be built for $FAIL_ARCH, e.g. $ABHOST."

    if ! bool $ABSTRIP && bool $ABSPLITDBG; then
        abwarn "QA: ELF stripping is turned OFF."
        abwarn "    Won't package debug symbols as they are shipped in ELF themselves."
        ABSPLITDBG=0
    fi

    if [[ $ABHOST == noarch ]]; then
        abinfo "Architecture-agnostic (noarch) package detected, disabling -dbg package split ..."
        ABSPLITDBG=0
    fi

    arch_initcross
    # PKGREL Parameter, pkg and rpm friendly
    # Test used for those who wants to override.
    # TODO foreport verlint
    # TODO verlint backwriting when ((!PROGDEFINE)).
    # TODO automate $PKG* namespace and remove abbs `spec`
    if [ ! "$PKGREL" ]; then
        PKGVER=$(echo $PKGVER| rev | cut -d - -f 2- | rev)
        PKGREL=$(echo $PKGVER | rev | cut -d - -f 1 | rev)
        if [ "$PKGREL" == "$PKGVER" ] || [ ! "$PKGREL" ]; then PKGREL=0; fi;
    fi

    # Programmable modules should be put here.
    arch_loadfile functions

    export `cat $AB/exportvars/*`

    export PYTHON=/usr/bin/python2
}


### Iterate through all...
cd "$SRCDIR"
altproc-10-core_defines

alias python=python2
export python

# function make() {
#     echo make "$@"
#     $(which make) "$@"
# }
# export -f make

for proc in $ab3_proc_list; do
    if [[ "$proc" != '#'* ]]; then
        log_info "Entering proc: $proc"
        source "$MINIBUILD_DIR/legacy-ab3/proc/$proc"
    fi
done
log_info ls "$MASTER_DIR/work/"*"/abdist/"
ls "$MASTER_DIR/work/"*"/abdist/"
ls "$PKGDIR"
rsync -avp --delete --mkpath "$PKGDIR/" "$MASTER_DIR/output/"




### Extra stuff...
log_info "var LDFLAGS_COMMON: $LDFLAGS_COMMON"
