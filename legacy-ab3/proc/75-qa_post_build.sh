#!/bin/bash
##qa_post_build: Execute post-build QA modules.
##@copyright GPL-2.0+
if bool $ABQA; then
	abinfo "Running post-build QA tests ..."
	for i in "$AB"/qa/post/*; do
		. "$i"
	done
fi

if [ -s "$SRCDIR"/abqawarn.log ]; then
        abwarn "QA warning(s) found, please refer to abqawarn.log ..."
fi

if [ -s "$SRCDIR"/abqaerr.log ]; then
        abdie "QA error(s) found, please refer to abqaerr.log ..."
fi
