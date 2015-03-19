{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from glib import gint, guint, guint32, guchar, gboolean

from gobject import GType

from x import TCursor

from xlib import TDisplay, TScreen, TVisual

template gdk_x11_app_launch_context*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, x11_app_launch_context_get_type(), 
                              X11AppLaunchContextObj))

template gdk_x11_app_launch_context_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, x11_app_launch_context_get_type(), 
                           X11AppLaunchContextClass))

template gdk_is_x11_app_launch_context*(obj: expr): expr = 
  (g_type_check_instance_type(obj, x11_app_launch_context_get_type()))

template gdk_is_x11_app_launch_context_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, x11_app_launch_context_get_type()))

template gdk_x11_app_launch_context_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, x11_app_launch_context_get_type(), 
                             X11AppLaunchContextClass))

type 
  X11AppLaunchContext* =  ptr X11AppLaunchContextObj
  X11AppLaunchContextPtr* = ptr X11AppLaunchContextObj
  X11AppLaunchContextObj* = AppLaunchContextObj
proc x11_app_launch_context_get_type*(): GType {.
    importc: "gdk_x11_app_launch_context_get_type", libgdk.}

template gdk_x11_cursor*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, x11_cursor_get_type(), X11CursorObj))

template gdk_x11_cursor_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, x11_cursor_get_type(), X11CursorClass))

template gdk_is_x11_cursor*(obj: expr): expr = 
  (g_type_check_instance_type(obj, x11_cursor_get_type()))

template gdk_is_x11_cursor_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, x11_cursor_get_type()))

template gdk_x11_cursor_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, x11_cursor_get_type(), X11CursorClass))

type 
  X11Cursor* =  ptr X11CursorObj
  X11CursorPtr* = ptr X11CursorObj
  X11CursorObj* = CursorObj
proc x11_cursor_get_type*(): GType {.importc: "gdk_x11_cursor_get_type", 
    libgdk.}
proc x11_cursor_get_xdisplay*(cursor: Cursor): ptr xlib.TDisplay {.
    importc: "gdk_x11_cursor_get_xdisplay", libgdk.}
proc x11_cursor_get_xcursor*(cursor: Cursor): x.TCursor {.
    importc: "gdk_x11_cursor_get_xcursor", libgdk.}
template gdk_cursor_xdisplay*(cursor: expr): expr = 
  (x11_cursor_get_xdisplay(cursor))

template gdk_cursor_xcursor*(cursor: expr): expr = 
  (x11_cursor_get_xcursor(cursor))

proc x11_device_get_id*(device: Device): gint {.
    importc: "gdk_x11_device_get_id", libgdk.}

template gdk_x11_device_core*(o: expr): expr = 
  (g_type_check_instance_cast(o, x11_device_core_get_type(), X11DeviceCore))

template gdk_x11_device_core_class*(c: expr): expr = 
  (g_type_check_class_cast(c, x11_device_core_get_type(), 
                           X11DeviceCoreClass))

template gdk_is_x11_device_core*(o: expr): expr = 
  (g_type_check_instance_type(o, x11_device_core_get_type()))

template gdk_is_x11_device_core_class*(c: expr): expr = 
  (g_type_check_class_type(c, x11_device_core_get_type()))

template gdk_x11_device_core_get_class*(o: expr): expr = 
  (g_type_instance_get_class(o, x11_device_core_get_type(), 
                             X11DeviceCoreClass))

proc x11_device_core_get_type*(): GType {.
    importc: "gdk_x11_device_core_get_type", libgdk.}

template gdk_x11_device_xi2*(o: expr): expr = 
  (g_type_check_instance_cast(o, x11_device_xi2_get_type(), X11DeviceXI2))

template gdk_x11_device_xi2_class*(c: expr): expr = 
  (g_type_check_class_cast(c, x11_device_xi2_get_type(), X11DeviceXI2Class))

template gdk_is_x11_device_xi2*(o: expr): expr = 
  (g_type_check_instance_type(o, x11_device_xi2_get_type()))

template gdk_is_x11_device_xi2_class*(c: expr): expr = 
  (g_type_check_class_type(c, x11_device_xi2_get_type()))

template gdk_x11_device_xi2_get_class*(o: expr): expr = 
  (g_type_instance_get_class(o, x11_device_xi2_get_type(), 
                             X11DeviceXI2Class))

proc x11_device_xi2_get_type*(): GType {.
    importc: "gdk_x11_device_xi2_get_type", libgdk.}

proc x11_device_manager_lookup*(device_manager: DeviceManager; 
                                    device_id: gint): Device {.
    importc: "gdk_x11_device_manager_lookup", libgdk.}

template gdk_x11_device_manager_core*(o: expr): expr = 
  (g_type_check_instance_cast(o, x11_device_manager_core_get_type(), 
                              X11DeviceManagerCoreObj))

template gdk_x11_device_manager_core_class*(c: expr): expr = 
  (g_type_check_class_cast(c, x11_device_manager_core_get_type(), 
                           X11DeviceManagerCoreClassObj))

template gdk_is_x11_device_manager_core*(o: expr): expr = 
  (g_type_check_instance_type(o, x11_device_manager_core_get_type()))

template gdk_is_x11_device_manager_core_class*(c: expr): expr = 
  (g_type_check_class_type(c, x11_device_manager_core_get_type()))

template gdk_x11_device_manager_core_get_class*(o: expr): expr = 
  (g_type_instance_get_class(o, x11_device_manager_core_get_type(), 
                             X11DeviceManagerCoreClassObj))

type 
  X11DeviceManagerCore* =  ptr X11DeviceManagerCoreObj
  X11DeviceManagerCorePtr* = ptr X11DeviceManagerCoreObj
  X11DeviceManagerCoreObj* = object 
  
  X11DeviceManagerCoreClass* =  ptr X11DeviceManagerCoreClassObj
  X11DeviceManagerCoreClassPtr* = ptr X11DeviceManagerCoreClassObj
  X11DeviceManagerCoreClassObj* = object 
  
proc x11_device_manager_core_get_type*(): GType {.
    importc: "gdk_x11_device_manager_core_get_type", libgdk.}

template gdk_x11_device_manager_xi2*(o: expr): expr = 
  (g_type_check_instance_cast(o, x11_device_manager_xi2_get_type(), 
                              X11DeviceManagerXI2Obj))

template gdk_x11_device_manager_xi2_class*(c: expr): expr = 
  (g_type_check_class_cast(c, x11_device_manager_xi2_get_type(), 
                           X11DeviceManagerXI2ClassObj))

template gdk_is_x11_device_manager_xi2*(o: expr): expr = 
  (g_type_check_instance_type(o, x11_device_manager_xi2_get_type()))

template gdk_is_x11_device_manager_xi2_class*(c: expr): expr = 
  (g_type_check_class_type(c, x11_device_manager_xi2_get_type()))

template gdk_x11_device_manager_xi2_get_class*(o: expr): expr = 
  (g_type_instance_get_class(o, x11_device_manager_xi2_get_type(), 
                             X11DeviceManagerXI2ClassObj))

type 
  X11DeviceManagerXI2* =  ptr X11DeviceManagerXI2Obj
  X11DeviceManagerXI2Ptr* = ptr X11DeviceManagerXI2Obj
  X11DeviceManagerXI2Obj* = object 
  
  X11DeviceManagerXI2Class* =  ptr X11DeviceManagerXI2ClassObj
  X11DeviceManagerXI2ClassPtr* = ptr X11DeviceManagerXI2ClassObj
  X11DeviceManagerXI2ClassObj* = object 
  
proc x11_device_manager_xi2_get_type*(): GType {.
    importc: "gdk_x11_device_manager_xi2_get_type", libgdk.}

type 
  X11Display* =  ptr X11DisplayObj
  X11DisplayPtr* = ptr X11DisplayObj
  X11DisplayObj* = DisplayObj
template gdk_x11_display*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, x11_display_get_type(), X11DisplayObj))

template gdk_x11_display_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, x11_display_get_type(), X11DisplayClass))

template gdk_is_x11_display*(obj: expr): expr = 
  (g_type_check_instance_type(obj, x11_display_get_type()))

template gdk_is_x11_display_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, x11_display_get_type()))

template gdk_x11_display_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, x11_display_get_type(), X11DisplayClass))

proc x11_display_get_type*(): GType {.importc: "gdk_x11_display_get_type", 
    libgdk.}
proc x11_display_get_xdisplay*(display: Display): ptr xlib.TDisplay {.
    importc: "gdk_x11_display_get_xdisplay", libgdk.}
template gdk_display_xdisplay*(display: expr): expr = 
  (x11_display_get_xdisplay(display))

proc x11_display_get_user_time*(display: Display): guint32 {.
    importc: "gdk_x11_display_get_user_time", libgdk.}
proc x11_display_get_startup_notification_id*(display: Display): cstring {.
    importc: "gdk_x11_display_get_startup_notification_id", libgdk.}
proc x11_display_set_startup_notification_id*(display: Display; 
    startup_id: cstring) {.importc: "gdk_x11_display_set_startup_notification_id", 
                             libgdk.}
proc x11_display_set_cursor_theme*(display: Display; 
    theme: cstring; size: gint) {.importc: "gdk_x11_display_set_cursor_theme", 
                                    libgdk.}
proc x11_display_broadcast_startup_message*(display: Display; 
    message_type: cstring) {.varargs, importc: "gdk_x11_display_broadcast_startup_message", 
                             libgdk.}
proc x11_lookup_xdisplay*(xdisplay: ptr xlib.TDisplay): Display {.
    importc: "gdk_x11_lookup_xdisplay", libgdk.}
proc x11_display_grab*(display: Display) {.
    importc: "gdk_x11_display_grab", libgdk.}
proc x11_display_ungrab*(display: Display) {.
    importc: "gdk_x11_display_ungrab", libgdk.}
proc x11_display_set_window_scale*(display: Display; scale: gint) {.
    importc: "gdk_x11_display_set_window_scale", libgdk.}
proc x11_display_error_trap_push*(display: Display) {.
    importc: "gdk_x11_display_error_trap_push", libgdk.}
proc x11_display_error_trap_pop*(display: Display): gint {.
    importc: "gdk_x11_display_error_trap_pop", libgdk.}
proc x11_display_error_trap_pop_ignored*(display: Display) {.
    importc: "gdk_x11_display_error_trap_pop_ignored", libgdk.}
proc x11_register_standard_event_type*(display: Display; 
    event_base: gint; n_events: gint) {.
    importc: "gdk_x11_register_standard_event_type", libgdk.}
proc x11_set_sm_client_id*(sm_client_id: cstring) {.
    importc: "gdk_x11_set_sm_client_id", libgdk.}

type 
  X11DisplayManager* =  ptr X11DisplayManagerObj
  X11DisplayManagerPtr* = ptr X11DisplayManagerObj
  X11DisplayManagerObj* = DisplayManagerObj
template gdk_x11_display_manager*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, x11_display_manager_get_type(), 
                              X11DisplayManagerObj))

template gdk_x11_display_manager_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, x11_display_manager_get_type(), 
                           X11DisplayManagerClass))

template gdk_is_x11_display_manager*(obj: expr): expr = 
  (g_type_check_instance_type(obj, x11_display_manager_get_type()))

template gdk_is_x11_display_manager_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, x11_display_manager_get_type()))

template gdk_x11_display_manager_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, x11_display_manager_get_type(), 
                             X11DisplayManagerClass))

proc x11_display_manager_get_type*(): GType {.
    importc: "gdk_x11_display_manager_get_type", libgdk.}

template gdk_x11_drag_context*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, x11_drag_context_get_type(), 
                              X11DragContextObj))

template gdk_x11_drag_context_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, x11_drag_context_get_type(), 
                           X11DragContextClass))

template gdk_is_x11_drag_context*(obj: expr): expr = 
  (g_type_check_instance_type(obj, x11_drag_context_get_type()))

template gdk_is_x11_drag_context_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, x11_drag_context_get_type()))

template gdk_x11_drag_context_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, x11_drag_context_get_type(), 
                             X11DragContextClass))

type 
  X11DragContext* =  ptr X11DragContextObj
  X11DragContextPtr* = ptr X11DragContextObj
  X11DragContextObj* = DragContextObj
proc x11_drag_context_get_type*(): GType {.
    importc: "gdk_x11_drag_context_get_type", libgdk.}

template gdk_x11_gl_context*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, x11_gl_context_get_type(), X11GLContext))

template gdk_x11_is_gl_context*(obj: expr): expr = 
  (g_type_check_instance_type(obj, x11_gl_context_get_type()))

proc x11_gl_context_get_type*(): GType {.
    importc: "gdk_x11_gl_context_get_type", libgdk.}
proc x11_display_get_glx_version*(display: Display; 
                                      major: var gint; minor: var gint): gboolean {.
    importc: "gdk_x11_display_get_glx_version", libgdk.}

type 
  X11Keymap* =  ptr X11KeymapObj
  X11KeymapPtr* = ptr X11KeymapObj
  X11KeymapObj* = KeymapObj
template gdk_x11_keymap*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, x11_keymap_get_type(), X11KeymapObj))

template gdk_x11_keymap_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, x11_keymap_get_type(), X11KeymapClass))

template gdk_is_x11_keymap*(obj: expr): expr = 
  (g_type_check_instance_type(obj, x11_keymap_get_type()))

template gdk_is_x11_keymap_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, x11_keymap_get_type()))

template gdk_x11_keymap_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, x11_keymap_get_type(), X11KeymapClass))

proc x11_keymap_get_type*(): GType {.importc: "gdk_x11_keymap_get_type", 
    libgdk.}
proc x11_keymap_get_group_for_state*(keymap: Keymap; state: guint): gint {.
    importc: "gdk_x11_keymap_get_group_for_state", libgdk.}
proc x11_keymap_key_is_modifier*(keymap: Keymap; keycode: guint): gboolean {.
    importc: "gdk_x11_keymap_key_is_modifier", libgdk.}

proc x11_atom_to_xatom_for_display*(display: Display; atom: Atom): x.TAtom {.
    importc: "gdk_x11_atom_to_xatom_for_display", libgdk.}
proc x11_xatom_to_atom_for_display*(display: Display; xatom: x.TAtom): Atom {.
    importc: "gdk_x11_xatom_to_atom_for_display", libgdk.}
proc x11_get_xatom_by_name_for_display*(display: Display; 
    atom_name: cstring): x.TAtom {.importc: "gdk_x11_get_xatom_by_name_for_display", 
                                  libgdk.}
proc x11_get_xatom_name_for_display*(display: Display; xatom: x.TAtom): cstring {.
    importc: "gdk_x11_get_xatom_name_for_display", libgdk.}
proc x11_atom_to_xatom*(atom: Atom): x.TAtom {.
    importc: "gdk_x11_atom_to_xatom", libgdk.}
proc x11_xatom_to_atom*(xatom: x.TAtom): Atom {.
    importc: "gdk_x11_xatom_to_atom", libgdk.}
proc x11_get_xatom_by_name*(atom_name: cstring): x.TAtom {.
    importc: "gdk_x11_get_xatom_by_name", libgdk.}
proc x11_get_xatom_name*(xatom: x.TAtom): cstring {.
    importc: "gdk_x11_get_xatom_name", libgdk.}

template gdk_x11_screen*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, x11_screen_get_type(), X11ScreenObj))

template gdk_x11_screen_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, x11_screen_get_type(), X11ScreenClass))

template gdk_is_x11_screen*(obj: expr): expr = 
  (g_type_check_instance_type(obj, x11_screen_get_type()))

template gdk_is_x11_screen_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, x11_screen_get_type()))

template gdk_x11_screen_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, x11_screen_get_type(), X11ScreenClass))

type 
  X11Screen* =  ptr X11ScreenObj
  X11ScreenPtr* = ptr X11ScreenObj
  X11ScreenObj* = ScreenObj
proc x11_screen_get_type*(): GType {.importc: "gdk_x11_screen_get_type", 
    libgdk.}
proc x11_screen_get_xscreen*(screen: Screen): ptr xlib.TScreen {.
    importc: "gdk_x11_screen_get_xscreen", libgdk.}
proc x11_screen_get_screen_number*(screen: Screen): cint {.
    importc: "gdk_x11_screen_get_screen_number", libgdk.}
proc x11_screen_get_window_manager_name*(screen: Screen): cstring {.
    importc: "gdk_x11_screen_get_window_manager_name", libgdk.}
proc x11_get_default_screen*(): gint {.
    importc: "gdk_x11_get_default_screen", libgdk.}
template gdk_screen_xdisplay*(screen: expr): expr = 
  (x11_display_get_xdisplay(display(screen)))

template gdk_screen_xscreen*(screen: expr): expr = 
  (x11_screen_get_xscreen(screen))

template gdk_screen_xnumber*(screen: expr): expr = 
  (x11_screen_get_screen_number(screen))

proc x11_screen_supports_net_wm_hint*(screen: Screen; 
    property: Atom): gboolean {.importc: "gdk_x11_screen_supports_net_wm_hint", 
                                   libgdk.}
proc x11_screen_get_monitor_output*(screen: Screen; 
    monitor_num: gint): x.TXID {.importc: "gdk_x11_screen_get_monitor_output", 
                              libgdk.}
proc x11_screen_get_number_of_desktops*(screen: Screen): guint32 {.
    importc: "gdk_x11_screen_get_number_of_desktops", libgdk.}
proc x11_screen_get_current_desktop*(screen: Screen): guint32 {.
    importc: "gdk_x11_screen_get_current_desktop", libgdk.}

proc x11_display_text_property_to_text_list*(display: Display; 
    encoding: Atom; format: gint; text: var guchar; length: gint; 
    list: var ptr cstring): gint {.importc: "gdk_x11_display_text_property_to_text_list", 
                                     libgdk.}
proc x11_free_text_list*(list: var cstring) {.
    importc: "gdk_x11_free_text_list", libgdk.}
proc x11_display_string_to_compound_text*(display: Display; 
    str: cstring; encoding: var Atom; format: var gint; 
    ctext: var ptr guchar; length: var gint): gint {.
    importc: "gdk_x11_display_string_to_compound_text", libgdk.}
proc x11_display_utf8_to_compound_text*(display: Display; 
    str: cstring; encoding: var Atom; format: var gint; 
    ctext: var ptr guchar; length: var gint): gboolean {.
    importc: "gdk_x11_display_utf8_to_compound_text", libgdk.}
proc x11_free_compound_text*(ctext: var guchar) {.
    importc: "gdk_x11_free_compound_text", libgdk.}

proc x11_get_default_root_xwindow*(): x.TWindow {.
    importc: "gdk_x11_get_default_root_xwindow", libgdk.}
proc x11_get_default_xdisplay*(): ptr xlib.TDisplay {.
    importc: "gdk_x11_get_default_xdisplay", libgdk.}
const gdk_root_window* = x11_get_default_root_xwindow

template gdk_xid_to_pointer*(xid: expr): expr = 
  GUINT_TO_POINTER(xid)

template gdk_pointer_to_xid*(pointer: expr): expr = 
  GPOINTER_TO_UINT(pointer)

proc x11_grab_server*() {.importc: "gdk_x11_grab_server", libgdk.}
proc x11_ungrab_server*() {.importc: "gdk_x11_ungrab_server", libgdk.}

template gdk_x11_visual*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, x11_visual_get_type(), X11VisualObj))

template gdk_x11_visual_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, x11_visual_get_type(), X11VisualClass))

template gdk_is_x11_visual*(obj: expr): expr = 
  (g_type_check_instance_type(obj, x11_visual_get_type()))

template gdk_is_x11_visual_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, x11_visual_get_type()))

template gdk_x11_visual_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, x11_visual_get_type(), X11VisualClass))

type 
  X11Visual* =  ptr X11VisualObj
  X11VisualPtr* = ptr X11VisualObj
  X11VisualObj* = VisualObj
proc x11_visual_get_type*(): GType {.importc: "gdk_x11_visual_get_type", 
    libgdk.}
proc x11_visual_get_xvisual*(visual: Visual): ptr xlib.TVisual {.
    importc: "gdk_x11_visual_get_xvisual", libgdk.}
template gdk_visual_xvisual*(visual: expr): expr = 
  (x11_visual_get_xvisual(visual))

proc x11_screen_lookup_visual*(screen: Screen; xvisualid: x.TVisualID): Visual {.
    importc: "gdk_x11_screen_lookup_visual", libgdk.}

template gdk_x11_window*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, x11_window_get_type(), X11WindowObj))

template gdk_x11_window_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, x11_window_get_type(), X11WindowClass))

template gdk_is_x11_window*(obj: expr): expr = 
  (g_type_check_instance_type(obj, x11_window_get_type()))

template gdk_is_x11_window_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, x11_window_get_type()))

template gdk_x11_window_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, x11_window_get_type(), X11WindowClass))

type 
  X11Window* =  ptr X11WindowObj
  X11WindowPtr* = ptr X11WindowObj
  X11WindowObj* = WindowObj
proc x11_window_get_type*(): GType {.importc: "gdk_x11_window_get_type", 
    libgdk.}
proc x11_window_get_xid*(window: Window): x.TWindow {.
    importc: "gdk_x11_window_get_xid", libgdk.}
proc x11_window_set_user_time*(window: Window; timestamp: guint32) {.
    importc: "gdk_x11_window_set_user_time", libgdk.}
proc x11_window_set_utf8_property*(window: Window; name: cstring; 
    value: cstring) {.importc: "gdk_x11_window_set_utf8_property", 
                        libgdk.}
proc x11_window_set_theme_variant*(window: Window; variant: cstring) {.
    importc: "gdk_x11_window_set_theme_variant", libgdk.}
proc x11_window_set_frame_extents*(window: Window; left: cint; 
    right: cint; top: cint; bottom: cint) {.
    importc: "gdk_x11_window_set_frame_extents", libgdk.}
proc x11_window_set_hide_titlebar_when_maximized*(window: Window; 
    hide_titlebar_when_maximized: gboolean) {.
    importc: "gdk_x11_window_set_hide_titlebar_when_maximized", libgdk.}
proc x11_window_move_to_current_desktop*(window: Window) {.
    importc: "gdk_x11_window_move_to_current_desktop", libgdk.}
proc x11_window_get_desktop*(window: Window): guint32 {.
    importc: "gdk_x11_window_get_desktop", libgdk.}
proc x11_window_move_to_desktop*(window: Window; desktop: guint32) {.
    importc: "gdk_x11_window_move_to_desktop", libgdk.}
proc x11_window_set_frame_sync_enabled*(window: Window; 
    frame_sync_enabled: gboolean) {.importc: "gdk_x11_window_set_frame_sync_enabled", 
                                    libgdk.}
template gdk_window_xdisplay*(win: expr): expr = 
  (gdk_display_xdisplay(display(win)))

template gdk_window_xid*(win: expr): expr = 
  (x11_window_get_xid(win))

proc x11_get_server_time*(window: Window): guint32 {.
    importc: "gdk_x11_get_server_time", libgdk.}
proc x11_window_foreign_new_for_display*(display: Display; 
    window: x.TWindow): Window {.importc: "gdk_x11_window_foreign_new_for_display", 
                                     libgdk.}
proc x11_window_lookup_for_display*(display: Display; 
    window: x.TWindow): Window {.importc: "gdk_x11_window_lookup_for_display", 
                                     libgdk.}
