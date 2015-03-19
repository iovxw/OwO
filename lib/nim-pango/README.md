nim-pango
=========

Nim pango wrapper

Automatically generated from latest header files of pango 1.36.8

This pango.nim uses new types names without P, T prefix but with
Ptr and Obj suffix -- most used type (ptr) is available without
suffix.

Main module is pango.nim, which depends only on glib and gobject.
pango-cairo.nim depends on cairo.nim, pango-win32.nim depends on
windows.nim. The other submodules may depend on x.nim, xlib.nim or
may also depent on other, currently non existing wrappers like xft
or font-config. So they use some plain dummy objects and may not
fully work yet. 

Currently I do not provide the deprecated symbols with T/P
prefixes -- many submodules and some compile time switches
(when ...) makes it difficult to provide T/P aliases. Generally
we should not need many symbols from pango, so updating your
code should be not too much work.

To generate the wrapper files: cd into gen directory, make sure path
to pango source directory containing C header files is correct in
file prep_pango.sh. Then execute command "bash prep_pango.sh".
This script executes a few tiny Ruby scripts, so you should ensure
that Ruby is installed on your computer -- Perl also.

