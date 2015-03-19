import cairo
from x import TDrawable, TPixmap
from xlib import PDisplay, PScreen, PVisual
include "cairo_pragma.nim"
proc create*(dpy: PDisplay; drawable: TDrawable; 
                                visual: PVisual; width: cint; 
                                height: cint): Surface {.
    importc: "cairo_xlib_surface_create", libcairo.}
proc create_for_bitmap*(dpy: PDisplay; bitmap: TPixmap; 
    screen: PScreen; width: cint; height: cint): Surface {.
    importc: "cairo_xlib_surface_create_for_bitmap", libcairo.}
proc set_size*(surface: Surface; width: cint; 
                                  height: cint) {.
    importc: "cairo_xlib_surface_set_size", libcairo.}
proc set_drawable*(surface: Surface; 
    drawable: TDrawable; width: cint; height: cint) {.
    importc: "cairo_xlib_surface_set_drawable", libcairo.}
proc get_display*(surface: Surface): PDisplay {.
    importc: "cairo_xlib_surface_get_display", libcairo.}
proc get_drawable*(surface: Surface): TDrawable {.
    importc: "cairo_xlib_surface_get_drawable", libcairo.}
proc get_screen*(surface: Surface): PScreen {.
    importc: "cairo_xlib_surface_get_screen", libcairo.}
proc get_visual*(surface: Surface): PVisual {.
    importc: "cairo_xlib_surface_get_visual", libcairo.}
proc get_depth*(surface: Surface): cint {.
    importc: "cairo_xlib_surface_get_depth", libcairo.}
proc get_width*(surface: Surface): cint {.
    importc: "cairo_xlib_surface_get_width", libcairo.}
proc get_height*(surface: Surface): cint {.
    importc: "cairo_xlib_surface_get_height", libcairo.}
proc debug_cap_xrender_version*(
    device: Device; major_version: cint; minor_version: cint) {.
    importc: "cairo_xlib_device_debug_cap_xrender_version", libcairo.}
proc debug_set_precision*(device: Device; 
    precision: cint) {.importc: "cairo_xlib_device_debug_set_precision", 
                       libcairo.}
proc debug_get_precision*(device: Device): cint {.
    importc: "cairo_xlib_device_debug_get_precision", libcairo.}


