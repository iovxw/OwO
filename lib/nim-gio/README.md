nim-gio
=======

Nim GIO wrapper

Automatically generated from latest stable header files of glib/gio 2.43.90
to  be used with GTK3

This gio.nim uses new types names without P, T prefix but with
Ptr and Obj suffix -- most used type (ptr) is available without
suffix.

Generally gio is not used much from Nim directly, but it is, together with
GObject, Cairo and Pango the foundation for GDK3 and GTK3.

To generate the wrapper files: cd into gen directory, make sure path
to gio source directory containing C header files is correct in
file prep-gio.sh. Then execute command "bash prep-gio.sh".
This script executes a few tiny Ruby scripts, so you should ensure
that Ruby is installed on your computer. (Perl also.)

Script works with c2nim 0.9.7

