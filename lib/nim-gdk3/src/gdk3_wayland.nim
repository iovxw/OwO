{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from gobject import GType

from glib import gint

type # wayland dummy objects
  wl_seat* = object
  wl_pointer* = object
  wl_keyboard* = object
  wl_display* = object
  wl_compositor* = object
  wl_surface* = object
  xdg_shell* = object

type 
  WaylandDevice* =  ptr WaylandDeviceObj
  WaylandDevicePtr* = ptr WaylandDeviceObj
  WaylandDeviceObj* = DeviceObj
template gdk_wayland_device*(o: expr): expr = 
  (g_type_check_instance_cast(o, wayland_device_get_type(), WaylandDeviceObj))

template gdk_wayland_device_class*(c: expr): expr = 
  (g_type_check_class_cast(c, wayland_device_get_type(), WaylandDeviceClass))

template gdk_is_wayland_device*(o: expr): expr = 
  (g_type_check_instance_type(o, wayland_device_get_type()))

template gdk_is_wayland_device_class*(c: expr): expr = 
  (g_type_check_class_type(c, wayland_device_get_type()))

template gdk_wayland_device_get_class*(o: expr): expr = 
  (g_type_instance_get_class(o, wayland_device_get_type(), 
                             WaylandDeviceClass))

proc wayland_device_get_type*(): GType {.
    importc: "gdk_wayland_device_get_type", libgdk.}
proc wayland_device_get_wl_seat*(device: Device): ptr wl_seat {.
    importc: "gdk_wayland_device_get_wl_seat", libgdk.}
proc wayland_device_get_wl_pointer*(device: Device): ptr wl_pointer {.
    importc: "gdk_wayland_device_get_wl_pointer", libgdk.}
proc wayland_device_get_wl_keyboard*(device: Device): ptr wl_keyboard {.
    importc: "gdk_wayland_device_get_wl_keyboard", libgdk.}

type 
  WaylandDisplay* =  ptr WaylandDisplayObj
  WaylandDisplayPtr* = ptr WaylandDisplayObj
  WaylandDisplayObj* = DisplayObj
template gdk_wayland_display*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, wayland_display_get_type(), 
                              WaylandDisplayObj))

template gdk_wayland_display_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, wayland_display_get_type(), 
                           WaylandDisplayClass))

template gdk_is_wayland_display*(obj: expr): expr = 
  (g_type_check_instance_type(obj, wayland_display_get_type()))

template gdk_is_wayland_display_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, wayland_display_get_type()))

template gdk_wayland_display_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, wayland_display_get_type(), 
                             WaylandDisplayClass))

proc wayland_display_get_type*(): GType {.
    importc: "gdk_wayland_display_get_type", libgdk.}
proc wayland_display_get_wl_display*(display: Display): ptr wl_display {.
    importc: "gdk_wayland_display_get_wl_display", libgdk.}
proc wayland_display_get_wl_compositor*(display: Display): ptr wl_compositor {.
    importc: "gdk_wayland_display_get_wl_compositor", libgdk.}
proc wayland_display_get_xdg_shell*(display: Display): ptr xdg_shell {.
    importc: "gdk_wayland_display_get_xdg_shell", libgdk.}
proc wayland_display_set_cursor_theme*(display: Display; 
    theme: cstring; size: gint) {.importc: "gdk_wayland_display_set_cursor_theme", 
                                    libgdk.}

when false: # when defined(GTK_COMPILATION) or defined(COMPILATION): 
  const 
    gdk_wayland_selection_add_targets* = gdk_wayland_selection_add_targets_libgtk_only
  proc wayland_selection_add_targets*(window: Window; 
      selection: Atom; ntargets: guint; targets: var Atom) {.
      importc: "gdk_wayland_selection_add_targets", libgdk.}
  const 
    gdk_wayland_selection_clear_targets* = gdk_wayland_selection_clear_targets_libgtk_only
  proc wayland_selection_clear_targets*(display: Display; 
      selection: Atom) {.importc: "gdk_wayland_selection_clear_targets", 
                            libgdk.}
  const 
    gdk_wayland_drag_context_get_dnd_window* = gdk_wayland_drag_context_get_dnd_window_libgtk_only
  proc wayland_drag_context_get_dnd_window*(context: DragContext): Window {.
      importc: "gdk_wayland_drag_context_get_dnd_window", libgdk.}

type 
  WaylandWindow* =  ptr WaylandWindowObj
  WaylandWindowPtr* = ptr WaylandWindowObj
  WaylandWindowObj* = WindowObj
template gdk_wayland_window*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, wayland_window_get_type(), WaylandWindowObj))

template gdk_wayland_window_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, wayland_window_get_type(), 
                           WaylandWindowClass))

template gdk_is_wayland_window*(obj: expr): expr = 
  (g_type_check_instance_type(obj, wayland_window_get_type()))

template gdk_is_wayland_window_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, wayland_window_get_type()))

template gdk_wayland_window_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, wayland_window_get_type(), 
                             WaylandWindowClass))

proc wayland_window_get_type*(): GType {.
    importc: "gdk_wayland_window_get_type", libgdk.}
proc wayland_window_get_wl_surface*(window: Window): ptr wl_surface {.
    importc: "gdk_wayland_window_get_wl_surface", libgdk.}
proc wayland_window_set_use_custom_surface*(window: Window) {.
    importc: "gdk_wayland_window_set_use_custom_surface", libgdk.}
proc wayland_window_set_dbus_properties_libgtk_only*(
    window: Window; application_id: cstring; app_menu_path: cstring; 
    menubar_path: cstring; window_object_path: cstring; 
    application_object_path: cstring; unique_bus_name: cstring) {.
    importc: "gdk_wayland_window_set_dbus_properties_libgtk_only", libgdk.}

template gdk_wayland_gl_context*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, wayland_gl_context_get_type(), 
                              WaylandGLContext))

template gdk_wayland_is_gl_context*(obj: expr): expr = 
  (g_type_check_instance_type(obj, wayland_gl_context_get_type()))

proc wayland_gl_context_get_type*(): GType {.
    importc: "gdk_wayland_gl_context_get_type", libgdk.}
