#!/bin/bash



BIN_TARGETS="spm spm-maint diel"

case $1 in
    install_local)
        sudo rsync -av --delete --mkpath static/ /usr/local/lib/minibuild/static/
        ;;
    easy)
        bash "$0" install_local
        ;;
esac
