### Local preparation
ARCH="$(uname -m)"



### Borrowed code
BUILD_START(){ true; }
BUILD_READY(){ true; }
BUILD_FINAL(){ true; }


: "${ABBUILD=$ARCH}" "${ABHOST=${CROSS:-$ABBUILD}}" "${ABTARGET=$ABHOST}"

[[ "$ABHOST" == x86_64 ]] && ABHOST=amd64
