{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from glib import guint, gunichar

from gobject import GType

from gdk_pixbuf import GdkPixbuf

type # macosx quartz dummy objects
  NSString* = object
  NSImage* = object
  NSEvent* = object
  NSWindow* = object
  NSView* = object
  id* = culong 

type 
  OSXVersion* {.size: sizeof(cint), pure.} = enum 
    UNSUPPORTED = 0, MIN = 4, LEOPARD = 5, 
    SNOW_LEOPARD = 6, LION = 7, MOUNTAIN_LION = 8, 
    NEW = 99
const 
  OSX_TIGER = OSXVersion.MIN
  OSX_CURRENT = OSXVersion.MOUNTAIN_LION
proc quartz_osx_version*(): OSXVersion {.
    importc: "gdk_quartz_osx_version", libgdk.}
proc quartz_pasteboard_type_to_atom_libgtk_only*(`type`: ptr NSString): Atom {.
    importc: "gdk_quartz_pasteboard_type_to_atom_libgtk_only", libgdk.}
proc quartz_target_to_pasteboard_type_libgtk_only*(target: cstring): ptr NSString {.
    importc: "gdk_quartz_target_to_pasteboard_type_libgtk_only", libgdk.}
proc quartz_atom_to_pasteboard_type_libgtk_only*(atom: Atom): ptr NSString {.
    importc: "gdk_quartz_atom_to_pasteboard_type_libgtk_only", libgdk.}

template gdk_quartz_cursor*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, quartz_cursor_get_type(), QuartzCursorObj))

template gdk_quartz_cursor_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, quartz_cursor_get_type(), 
                           QuartzCursorClass))

template gdk_is_quartz_cursor*(obj: expr): expr = 
  (g_type_check_instance_type(obj, quartz_cursor_get_type()))

template gdk_is_quartz_cursor_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, quartz_cursor_get_type()))

template gdk_quartz_cursor_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, quartz_cursor_get_type(), 
                             QuartzCursorClass))

type 
  QuartzCursor* =  ptr QuartzCursorObj
  QuartzCursorPtr* = ptr QuartzCursorObj
  QuartzCursorObj* = CursorObj
proc quartz_cursor_get_type*(): GType {.
    importc: "gdk_quartz_cursor_get_type", libgdk.}

template gdk_quartz_device_core*(o: expr): expr = 
  (g_type_check_instance_cast(o, quartz_device_core_get_type(), 
                              QuartzDeviceCore))

template gdk_quartz_device_core_class*(c: expr): expr = 
  (g_type_check_class_cast(c, quartz_device_core_get_type(), 
                           QuartzDeviceCoreClass))

template gdk_is_quartz_device_core*(o: expr): expr = 
  (g_type_check_instance_type(o, quartz_device_core_get_type()))

template gdk_is_quartz_device_core_class*(c: expr): expr = 
  (g_type_check_class_type(c, quartz_device_core_get_type()))

template gdk_quartz_device_core_get_class*(o: expr): expr = 
  (g_type_instance_get_class(o, quartz_device_core_get_type(), 
                             QuartzDeviceCoreClass))

proc quartz_device_core_get_type*(): GType {.
    importc: "gdk_quartz_device_core_get_type", libgdk.}

template gdk_quartz_device_manager_core*(o: expr): expr = 
  (g_type_check_instance_cast(o, quartz_device_manager_core_get_type(), 
                              QuartzDeviceManagerCore))

template gdk_quartz_device_manager_core_class*(c: expr): expr = 
  (g_type_check_class_cast(c, quartz_device_manager_core_get_type(), 
                           QuartzDeviceManagerCoreClass))

template gdk_is_quartz_device_manager_core*(o: expr): expr = 
  (g_type_check_instance_type(o, quartz_device_manager_core_get_type()))

template gdk_is_quartz_device_manager_core_class*(c: expr): expr = 
  (g_type_check_class_type(c, quartz_device_manager_core_get_type()))

template gdk_quartz_device_manager_core_get_class*(o: expr): expr = 
  (g_type_instance_get_class(o, quartz_device_manager_core_get_type(), 
                             QuartzDeviceManagerCoreClass))

proc quartz_device_manager_core_get_type*(): GType {.
    importc: "gdk_quartz_device_manager_core_get_type", libgdk.}

template gdk_quartz_display*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, quartz_display_get_type(), QuartzDisplayObj))

template gdk_quartz_display_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, quartz_display_get_type(), 
                           QuartzDisplayClass))

template gdk_is_quartz_display*(obj: expr): expr = 
  (g_type_check_instance_type(obj, quartz_display_get_type()))

template gdk_is_quartz_display_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, quartz_display_get_type()))

template gdk_quartz_display_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, quartz_display_get_type(), 
                             QuartzDisplayClass))

type 
  QuartzDisplay* =  ptr QuartzDisplayObj
  QuartzDisplayPtr* = ptr QuartzDisplayObj
  QuartzDisplayObj* = DisplayObj
proc quartz_display_get_type*(): GType {.
    importc: "gdk_quartz_display_get_type", libgdk.}

template gdk_quartz_display_manager*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, quartz_display_manager_get_type(), 
                              QuartzDisplayManagerObj))

type 
  QuartzDisplayManager* =  ptr QuartzDisplayManagerObj
  QuartzDisplayManagerPtr* = ptr QuartzDisplayManagerObj
  QuartzDisplayManagerObj* = DisplayManagerObj
  QuartzDisplayManagerClass* = DisplayManagerClass
proc quartz_display_manager_get_type*(): GType {.
    importc: "gdk_quartz_display_manager_get_type", libgdk.}

template gdk_quartz_drag_context*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, quartz_drag_context_get_type(), 
                              QuartzDragContextObj))

template gdk_quartz_drag_context_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, quartz_drag_context_get_type(), 
                           QuartzDragContextClass))

template gdk_is_quartz_drag_context*(obj: expr): expr = 
  (g_type_check_instance_type(obj, quartz_drag_context_get_type()))

template gdk_is_quartz_drag_context_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, quartz_drag_context_get_type()))

template gdk_quartz_drag_context_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, quartz_drag_context_get_type(), 
                             QuartzDragContextClass))

type 
  QuartzDragContext* =  ptr QuartzDragContextObj
  QuartzDragContextPtr* = ptr QuartzDragContextObj
  QuartzDragContextObj* = DragContextObj
proc quartz_drag_context_get_type*(): GType {.
    importc: "gdk_quartz_drag_context_get_type", libgdk.}
proc quartz_drag_context_get_dragging_info_libgtk_only*(
    context: DragContext): id {.
    importc: "gdk_quartz_drag_context_get_dragging_info_libgtk_only", 
    libgdk.}

template gdk_quartz_keymap*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, quartz_keymap_get_type(), QuartzKeymapObj))

template gdk_quartz_keymap_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, quartz_keymap_get_type(), 
                           QuartzKeymapClass))

template gdk_is_quartz_keymap*(obj: expr): expr = 
  (g_type_check_instance_type(obj, quartz_keymap_get_type()))

template gdk_is_quartz_keymap_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, quartz_keymap_get_type()))

template gdk_quartz_keymap_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, quartz_keymap_get_type(), 
                             QuartzKeymapClass))

type 
  QuartzKeymap* =  ptr QuartzKeymapObj
  QuartzKeymapPtr* = ptr QuartzKeymapObj
  QuartzKeymapObj* = KeymapObj
proc quartz_keymap_get_type*(): GType {.
    importc: "gdk_quartz_keymap_get_type", libgdk.}

template gdk_quartz_screen*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, quartz_screen_get_type(), QuartzScreenObj))

template gdk_quartz_screen_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, quartz_screen_get_type(), 
                           QuartzScreenClass))

template gdk_is_quartz_screen*(obj: expr): expr = 
  (g_type_check_instance_type(obj, quartz_screen_get_type()))

template gdk_is_quartz_screen_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, quartz_screen_get_type()))

template gdk_quartz_screen_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, quartz_screen_get_type(), 
                             QuartzScreenClass))

type 
  QuartzScreen* =  ptr QuartzScreenObj
  QuartzScreenPtr* = ptr QuartzScreenObj
  QuartzScreenObj* = ScreenObj
proc quartz_screen_get_type*(): GType {.
    importc: "gdk_quartz_screen_get_type", libgdk.}

proc quartz_pixbuf_to_ns_image_libgtk_only*(pixbuf: gdk_pixbuf.GdkPixbuf): ptr NSImage {.
    importc: "gdk_quartz_pixbuf_to_ns_image_libgtk_only", libgdk.}
proc quartz_event_get_nsevent*(event: Event): ptr NSEvent {.
    importc: "gdk_quartz_event_get_nsevent", libgdk.}
proc quartz_get_key_equivalent*(key: guint): gunichar {.
    importc: "gdk_quartz_get_key_equivalent", libgdk.}

template gdk_quartz_visual*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, quartz_visual_get_type(), QuartzVisualObj))

template gdk_quartz_visual_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, quartz_visual_get_type(), 
                           QuartzVisualClass))

template gdk_is_quartz_visual*(obj: expr): expr = 
  (g_type_check_instance_type(obj, quartz_visual_get_type()))

template gdk_is_quartz_visual_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, quartz_visual_get_type()))

template gdk_quartz_visual_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, quartz_visual_get_type(), 
                             QuartzVisualClass))

type 
  QuartzVisual* =  ptr QuartzVisualObj
  QuartzVisualPtr* = ptr QuartzVisualObj
  QuartzVisualObj* = VisualObj
proc quartz_visual_get_type*(): GType {.
    importc: "gdk_quartz_visual_get_type", libgdk.}

template gdk_quartz_window*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, quartz_window_get_type(), QuartzWindowObj))

template gdk_quartz_window_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, quartz_window_get_type(), 
                           QuartzWindowClass))

template gdk_is_quartz_window*(obj: expr): expr = 
  (g_type_check_instance_type(obj, quartz_window_get_type()))

template gdk_is_quartz_window_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, quartz_window_get_type()))

template gdk_quartz_window_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, quartz_window_get_type(), 
                             QuartzWindowClass))

type 
  QuartzWindow* =  ptr QuartzWindowObj
  QuartzWindowPtr* = ptr QuartzWindowObj
  QuartzWindowObj* = WindowObj
proc quartz_window_get_type*(): GType {.
    importc: "gdk_quartz_window_get_type", libgdk.}
proc quartz_window_get_nswindow*(window: Window): ptr NSWindow {.
    importc: "gdk_quartz_window_get_nswindow", libgdk.}
proc quartz_window_get_nsview*(window: Window): ptr NSView {.
    importc: "gdk_quartz_window_get_nsview", libgdk.}
