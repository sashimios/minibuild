# Minibuild Documentation - Environment

This is a note for miscellaneous environment requirements.
Many of them are caused by the existing code in Autobuild3.

- The `/usr/lib/gcc/specs/*` files must be retrieved from [AOSC-Dev/aosc-os-abbs](https://github.com/AOSC-Dev/aosc-os-abbs/tree/stable/core-devel/gcc/02-compiler/overrides/usr/lib/gcc/specs).
- (Unsure) GCC must be compiled with `hardened`.
