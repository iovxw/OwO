{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from windows import HWND, HGDIOBJ

from glib import gint, gpointer, gboolean

from gobject import GType

template gdk_win32_cursor*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, win32_cursor_get_type(), Win32CursorObj))

template gdk_win32_cursor_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, win32_cursor_get_type(), Win32CursorClass))

template gdk_is_win32_cursor*(obj: expr): expr = 
  (g_type_check_instance_type(obj, win32_cursor_get_type()))

template gdk_is_win32_cursor_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, win32_cursor_get_type()))

template gdk_win32_cursor_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, win32_cursor_get_type(), Win32CursorClass))

type 
  Win32Cursor* =  ptr Win32CursorObj
  Win32CursorPtr* = ptr Win32CursorObj
  Win32CursorObj* = CursorObj
proc win32_cursor_get_type*(): GType {.
    importc: "gdk_win32_cursor_get_type", libgdk.}

type 
  Win32Display* =  ptr Win32DisplayObj
  Win32DisplayPtr* = ptr Win32DisplayObj
  Win32DisplayObj* = DisplayObj
template gdk_win32_display*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, win32_display_get_type(), Win32DisplayObj))

template gdk_win32_display_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, win32_display_get_type(), 
                           Win32DisplayClass))

template gdk_is_win32_display*(obj: expr): expr = 
  (g_type_check_instance_type(obj, win32_display_get_type()))

template gdk_is_win32_display_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, win32_display_get_type()))

template gdk_win32_display_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, win32_display_get_type(), 
                             Win32DisplayClass))

proc win32_display_get_type*(): GType {.
    importc: "gdk_win32_display_get_type", libgdk.}

type 
  Win32DisplayManager* =  ptr Win32DisplayManagerObj
  Win32DisplayManagerPtr* = ptr Win32DisplayManagerObj
  Win32DisplayManagerObj* = DisplayManagerObj
template gdk_win32_display_manager*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, win32_display_manager_get_type(), 
                              Win32DisplayManagerObj))

template gdk_win32_display_manager_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, win32_display_manager_get_type(), 
                           Win32DisplayManagerClass))

template gdk_is_win32_display_manager*(obj: expr): expr = 
  (g_type_check_instance_type(obj, win32_display_manager_get_type()))

template gdk_is_win32_display_manager_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, win32_display_manager_get_type()))

template gdk_win32_display_manager_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, win32_display_manager_get_type(), 
                             Win32DisplayManagerClass))

proc win32_display_manager_get_type*(): GType {.
    importc: "gdk_win32_display_manager_get_type", libgdk.}

template gdk_win32_drag_context*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, win32_drag_context_get_type(), 
                              Win32DragContextObj))

template gdk_win32_drag_context_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, win32_drag_context_get_type(), 
                           Win32DragContextClass))

template gdk_is_win32_drag_context*(obj: expr): expr = 
  (g_type_check_instance_type(obj, win32_drag_context_get_type()))

template gdk_is_win32_drag_context_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, win32_drag_context_get_type()))

template gdk_win32_drag_context_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, win32_drag_context_get_type(), 
                             Win32DragContextClass))

type 
  Win32DragContext* =  ptr Win32DragContextObj
  Win32DragContextPtr* = ptr Win32DragContextObj
  Win32DragContextObj* = DragContextObj
proc win32_drag_context_get_type*(): GType {.
    importc: "gdk_win32_drag_context_get_type", libgdk.}

type 
  Win32Keymap* =  ptr Win32KeymapObj
  Win32KeymapPtr* = ptr Win32KeymapObj
  Win32KeymapObj* = KeymapObj
template gdk_win32_keymap*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, win32_keymap_get_type(), Win32KeymapObj))

template gdk_win32_keymap_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, win32_keymap_get_type(), Win32KeymapClass))

template gdk_is_win32_keymap*(obj: expr): expr = 
  (g_type_check_instance_type(obj, win32_keymap_get_type()))

template gdk_is_win32_keymap_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, win32_keymap_get_type()))

template gdk_win32_keymap_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, win32_keymap_get_type(), Win32KeymapClass))

proc win32_keymap_get_type*(): GType {.
    importc: "gdk_win32_keymap_get_type", libgdk.}

template gdk_win32_screen*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, win32_screen_get_type(), Win32ScreenObj))

template gdk_win32_screen_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, win32_screen_get_type(), Win32ScreenClass))

template gdk_is_win32_screen*(obj: expr): expr = 
  (g_type_check_instance_type(obj, win32_screen_get_type()))

template gdk_is_win32_screen_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, win32_screen_get_type()))

template gdk_win32_screen_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, win32_screen_get_type(), Win32ScreenClass))

type 
  Win32Screen* =  ptr Win32ScreenObj
  Win32ScreenPtr* = ptr Win32ScreenObj
  Win32ScreenObj* = ScreenObj
proc win32_screen_get_type*(): GType {.
    importc: "gdk_win32_screen_get_type", libgdk.}

template gdk_win32_window*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, win32_window_get_type(), Win32WindowObj))

template gdk_win32_window_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, win32_window_get_type(), Win32WindowClass))

template gdk_is_win32_window*(obj: expr): expr = 
  (g_type_check_instance_type(obj, win32_window_get_type()))

template gdk_is_win32_window_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, win32_window_get_type()))

template gdk_win32_window_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, win32_window_get_type(), Win32WindowClass))

type 
  Win32Window* =  ptr Win32WindowObj
  Win32WindowPtr* = ptr Win32WindowObj
  Win32WindowObj* = WindowObj
proc win32_window_get_type*(): GType {.
    importc: "gdk_win32_window_get_type", libgdk.}

# when INSIDE_GDK_WIN32: # when defined(INSIDE_GDK_WIN32): 
#template gdk_window_hwnd*(win: expr): expr = 
#  (WINDOW_IMPL_WIN32(win.impl).handle)

# else: 
template gdk_window_hwnd*(d: expr): expr = 
  (gdk_win32_window_get_handle(d))

# when not(defined(WM_XBUTTONDOWN)): 
const 
  WM_XBUTTONDOWN* = 0x20B
# when not(defined(WM_XBUTTONUP)): 
const 
  WM_XBUTTONUP* = 0x20C
# when not(defined(get_xbutton_wparam)): 
template get_xbutton_wparam*(w: expr): expr = 
  (HIWORD(w))

# when not(defined(XBUTTON1)): 
const 
  XBUTTON1* = 1
# when not(defined(XBUTTON2)): 
const 
  XBUTTON2* = 2
proc win32_window_is_win32*(window: Window): gboolean {.
    importc: "gdk_win32_window_is_win32", libgdk.}
proc win32_window_get_impl_hwnd*(window: Window): HWND {.
    importc: "gdk_win32_window_get_impl_hwnd", libgdk.}
proc win32_handle_table_lookup*(handle: HWND): gpointer {.
    importc: "gdk_win32_handle_table_lookup", libgdk.}
proc win32_window_get_handle*(window: Window): HGDIOBJ {.
    importc: "gdk_win32_window_get_handle", libgdk.}
proc win32_selection_add_targets*(owner: Window; 
                                      selection: Atom; n_targets: gint; 
                                      targets: var Atom) {.
    importc: "gdk_win32_selection_add_targets", libgdk.}
proc win32_window_foreign_new_for_display*(display: Display; 
    anid: HWND): Window {.importc: "gdk_win32_window_foreign_new_for_display", 
                                 libgdk.}
proc win32_window_lookup_for_display*(display: Display; anid: HWND): Window {.
    importc: "gdk_win32_window_lookup_for_display", libgdk.}

template gdk_win32_gl_context*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, win32_gl_context_get_type(), 
                              Win32GLContext))

template gdk_win32_is_gl_context*(obj: expr): expr = 
  (g_type_check_instance_type(obj, win32_gl_context_get_type()))

proc win32_gl_context_get_type*(): GType {.
    importc: "gdk_win32_gl_context_get_type", libgdk.}
proc win32_display_get_wgl_version*(display: Display; 
    major: var gint; minor: var gint): gboolean {.
    importc: "gdk_win32_display_get_wgl_version", libgdk.}
