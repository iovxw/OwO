nim-gobject
===========

Nim glib/gobject wrapper

Automatically generated from latest stable header files of glib 2.42.1

I decided to put gobject.nim in its own module, instead of merging
with glib module. It imports some symbols from glib module.

glib/gobject 2.42 is currently the latest stable one used for GDK3/GTK3.

For this generation of Nim modules the new symbol naming scheme is used.
Now Types are not prefixed with P or T any more, but we use Ptr and Obj
suffix -- most used variant is available without prefix also. Old names
with P/T prefixes can still be used, but generate a deprecated warning.

These modules should be more or less backward compatible to the initial
glib2 modules shipped with Nimrod up to 0.9.6.

Generally glib/gobject is not used from Nim directly, but it is,
together with GModule, Cairo and Pango the foundation for GDK3 and GTK3.

To generate the wrapper files: cd into gen directory, make sure path
to glib source directory containing C header files is correct in
file prep-gobj.sh. Then execute command "bash prep-gobj.sh".
This script executes a few tiny Ruby scripts, so you should ensure
that Ruby is installed on your computer. (Perl also.)

Script does work only with c2nim 0.9.6!

