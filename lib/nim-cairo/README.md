nim-cairo
=========

Nim cairo wrapper

Automatically generated from latest header files of cairo 1.14

This cairo.nim uses new types names without P, T prefix but with
Ptr and Obj suffix -- most used type (ptr) is available without
suffix.

Main module is cairo.nim, which contains also PDF, SVG and other
stuff not depending on other modules.

Xlib, win32, GL is supported by cairo_xlib.nim, cairo_win32.nim
and cairo_gl.nim (still untested.)

Other backends like xcb, ft, quartz are still unsupported because
imported wrappers are still unavailable.

These modules should be backward compatible to the initial
cairo modules shipped with Nimrod up to 0.9.6 -- cairo_ft.nim
is not available because there seems to exist no freetype wrapper.

To generate the wrapper files: cd into gen directory, make sure path
to cairo source directory containing C header files is correct in
file prep_cairo.sh. Then execute command "bash prep_cairo.sh".
This script executes a few tiny Ruby scripts, so you should ensure
that Ruby is installed on your computer -- perl also.

Script works with latest c2nim 0.9.7!

