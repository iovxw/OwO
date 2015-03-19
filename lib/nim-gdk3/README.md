nim-gdk3
========

Nim GDK3 wrapper

Automatically generated from latest header files of GDK 3.15.6

This gdk3.nim uses new types names without P, T prefix but with
Ptr and Obj suffix -- most used type (ptr) is available without
suffix.

API of 3.15.6 should be nearly identical to upcoming stable 3.16. 

This module uses a few symbols of Wayland and Broadway which
are not yet available.
These symbols are currently defined in gdk3.nim as opaque dummy
objects, which should not really reduce the usability of this module.

To generate the wrapper files: cd into gen directory, make sure path
to gdk3 source directory containing C header files is correct in
file prep_gdk.sh. Then execute command "bash prep_gdk.sh".
This script executes a few tiny Ruby scripts, so you should ensure
that Ruby is installed on your computer -- perl also.

You need c2nim 0.9.6 to run the script!
