{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from gobject import GType

type # unity mir dummy objects
  MirConnection* = object
  MirSurface* = object

template gdk_is_mir_display*(obj: expr): expr = 
  (g_type_check_instance_type(obj, mir_display_get_type()))

template gdk_mir_is_gl_context*(obj: expr): expr = 
  (g_type_check_instance_type(obj, mir_gl_context_get_type()))

template gdk_is_mir_window*(obj: expr): expr = 
  (g_type_check_instance_type(obj, mir_window_get_type()))

proc mir_display_get_type*(): GType {.importc: "gdk_mir_display_get_type", 
    libgdk.}
proc mir_display_get_mir_connection*(display: Display): ptr MirConnection {.
    importc: "gdk_mir_display_get_mir_connection", libgdk.}
proc mir_window_get_type*(): GType {.importc: "gdk_mir_window_get_type", 
    libgdk.}
proc mir_window_get_mir_surface*(window: Window): ptr MirSurface {.
    importc: "gdk_mir_window_get_mir_surface", libgdk.}
proc mir_gl_context_get_type*(): GType {.
    importc: "gdk_mir_gl_context_get_type", libgdk.}
