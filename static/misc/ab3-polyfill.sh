### Local preparation
ARCH="$(uname -m)"
[[ "$ABHOST" == x86_64 ]] && ABHOST=amd64
[[ "$ARCH" == x86_64 ]] && ARCH=amd64



### Borrowed code
BUILD_START(){ true; }
BUILD_READY(){ true; }
BUILD_FINAL(){ true; }





# Basic environment declarations
export ABVERSION=3
export ABSET=/etc/autobuild
if [ ! "$AB" ]; then
	export AB=$(cat "$ABSET/prefix" || dirname "$(readlink -e "$0")")
fi
export ABBLPREFIX=$AB/lib
export ABBUILD ABHOST ABTARGET
# compat 1.x and fallback
: "${ABBUILD=$ARCH}" "${ABHOST=${CROSS:-$ABBUILD}}" "${ABTARGET=$ABHOST}"

# For consistency of build output
export LANG=C.UTF-8

# Behavior
((AB_NOISY)) && set -xv
((AB_SELF)) && AB=$(dirname "$(readlink -e "$0")")
