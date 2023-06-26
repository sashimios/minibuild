#!/bin/bash



BIN_TARGETS="spm spm-maint diel"

case $1 in
    import_legacy_ab3)
        rsync -avx --delete /home/neruthes/EWS/AOSC/autobuild3/ legacy-ab3/
        rsync -avx legacy-ab3-overwrite/ legacy-ab3/
        rm -rfv legacy-ab3/.{git,githubwiki,gitmodules}
        ;;
    install_local)
        dirlist="static legacy-ab3"
        for subdir in $dirlist; do
            sudo rsync -av --delete --mkpath "$subdir/" "/usr/local/lib/minibuild/$subdir/"
        done
        ;;
    easy)
        bash "$0" import_legacy_ab3
        bash "$0" install_local
        ;;
esac
