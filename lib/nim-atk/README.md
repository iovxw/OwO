nim-atk
=======

Nim ATK wrapper

Automatically generated from latest header files of glib/atk 2.15.4
to be used with GDK3/GTK3

This atk.nim uses new types names without P, T prefix but with
Ptr and Obj suffix -- most used type (ptr) is available without
suffix.

This module should be more or less backward compatible to the initial
atk module shipped with Nimrod up to 0.9.6.

Atk may be used in conjunction with GDK3 and GTK3.

To generate the wrapper files: cd into gen directory, make sure path
to atk source directory containing C header files is correct in
file prep-atk.sh. Then execute command "bash prep-atk.sh".
This script executes a few tiny Ruby scripts, so you should ensure
that Ruby is installed on your computer. (Perl also.)

Script works with c2nim 0.9.7

