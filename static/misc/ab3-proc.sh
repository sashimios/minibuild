### Overwrite some functions
abdie() {
	diag_print_backtrace
	echo -e "\e[1;31mautobuild encountered an error and couldn't continue.\e[0m" 1>&2
	echo -e "${1-Look at the stacktrace to see what happened.}" 1>&2
	echo "------------------------------autobuild ${ABVERSION:-3}------------------------------" 1>&2
	echo -e "Go to ‘\e[1mhttps://github.com/sashimios/minibuild\e[0m’ for more information on this error." 1>&2
	if ((AB_DBG)); then
		read -n 1 -p "AUTOBUILD_DEBUG: CONTINUE? (Y/N)" -t 5 AB_DBGRUN || AB_DBGRUN=false
		bool $AB_DBGRUN && abwarn "Forced AUTOBUILD_DIE continue." && return 0 || abdbg "AUTOBUILD_DIE EXIT - NO_CONTINUE"
	fi
	exit "${2-1}"
}



ab3_proc_list="
#00-python_defines.sh
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

### Iterate through all...
for proc in $ab3_proc_list; do
    if [[ "$proc" != '#'* ]]; then
        log_info "Entering proc: $proc"
        source "$MINIBUILD_DIR/legacy-ab3/proc/$proc"
    fi
done
