nim-glib
========

Nim glib wrapper

Automatically generated from latest stable header files of glib 2.42.1
to  be used with GDK3/GTK3

This glib.nim uses new types names without P, T prefix but with
Ptr and Obj suffix -- most used type (ptr) is available without
suffix.

GObject and GModule is not included here, they are separate smaller
modules.

These modules should be more or less backward compatible to the initial
glib2 modules shipped with Nimrod up to 0.9.6.

Generally glib is not used from Nim directly, but it is, together with
GObject, Cairo and Pango the foundation for GDK3 and GTK3.

To generate the wrapper files: cd into gen directory, make sure path
to glib source directory containing C header files is correct in
file prep-glib.sh. Then execute command "bash prep-glib.sh".
This script executes a few tiny Ruby scripts, so you should ensure
that Ruby is installed on your computer. (Perl also.)

Script works only with c2nim 0.9.6!

