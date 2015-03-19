nim-gtk3
========

Nim GTK3 wrapper

Automatically generated from latest header files of GTK 3.15.6

This gtk3.nim uses new types names without P, T prefix but with
Ptr and Obj suffix -- most used type (ptr) is available without
suffix.

API of 3.15.6 should be nearly identical to upcoming stable 3.16. 

To generate the wrapper files: cd into gen directory, make sure path
to gtk3 source directory containing C header files is correct in
file prep_gtk.sh. Then execute command "bash prep_gtk.sh".
This script executes a few tiny Ruby scripts, so you should ensure
that Ruby is installed on your computer -- perl also.

Currently the generator script needs c2nim 0.9.6!

