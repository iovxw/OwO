nim-gdk_pixbuf
==============

Nim gdk-pixbuf wrapper

Automatically generated from latest header files of gdk-pixbuf 2.31.2

This gdk_pixbuf.nim uses new types names without P, T prefix but with
Ptr and Obj suffix -- most used type (ptr) is available without
suffix.

To generate the wrapper files: cd into gen directory, make sure path
to gdk-pixbuf source directory containing C header files is correct in
file prep_gdkpb.sh. Then execute command "bash prep_gdkpb.sh".
This script executes a few tiny Ruby scripts, so you should ensure
that Ruby is installed on your computer -- perl also.

