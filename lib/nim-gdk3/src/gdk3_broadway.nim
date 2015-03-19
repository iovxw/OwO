{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from glib import guint8, guint32, guint64, gint, gint32, gboolean

from cairo import Surface, Region

from gobject import GType

from gio import GOutputStream

type # broadway dummy objects
  BroadwayBuffer* = object
  BroadwayServer* = object
  BroadwayOutput* = object

type 
  BroadwayDisplay* =  ptr BroadwayDisplayObj
  BroadwayDisplayPtr* = ptr BroadwayDisplayObj
  BroadwayDisplayObj* = DisplayObj
template gdk_broadway_display*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, broadway_display_get_type(), 
                              BroadwayDisplayObj))

template gdk_broadway_display_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, broadway_display_get_type(), 
                           BroadwayDisplayClass))

template gdk_is_broadway_display*(obj: expr): expr = 
  (g_type_check_instance_type(obj, broadway_display_get_type()))

template gdk_is_broadway_display_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, broadway_display_get_type()))

template gdk_broadway_display_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, broadway_display_get_type(), 
                             BroadwayDisplayClass))

proc broadway_display_get_type*(): GType {.
    importc: "gdk_broadway_display_get_type", libgdk.}
proc show_keyboard*(display: BroadwayDisplay) {.
    importc: "gdk_broadway_display_show_keyboard", libgdk.}
proc hide_keyboard*(display: BroadwayDisplay) {.
    importc: "gdk_broadway_display_hide_keyboard", libgdk.}

template gdk_broadway_window*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, broadway_window_get_type(), 
                              BroadwayWindowObj))

template gdk_broadway_window_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, broadway_window_get_type(), 
                           BroadwayWindowClass))

template gdk_is_broadway_window*(obj: expr): expr = 
  (g_type_check_instance_type(obj, broadway_window_get_type()))

template gdk_is_broadway_window_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, broadway_window_get_type()))

template gdk_broadway_window_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, broadway_window_get_type(), 
                             BroadwayWindowClass))

type 
  BroadwayWindow* =  ptr BroadwayWindowObj
  BroadwayWindowPtr* = ptr BroadwayWindowObj
  BroadwayWindowObj* = WindowObj
proc broadway_window_get_type*(): GType {.
    importc: "gdk_broadway_window_get_type", libgdk.}
proc broadway_get_last_seen_time*(window: Window): guint32 {.
    importc: "gdk_broadway_get_last_seen_time", libgdk.}

template gdk_broadway_cursor*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, broadway_cursor_get_type(), 
                              BroadwayCursorObj))

template gdk_broadway_cursor_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, broadway_cursor_get_type(), 
                           BroadwayCursorClass))

template gdk_is_broadway_cursor*(obj: expr): expr = 
  (g_type_check_instance_type(obj, broadway_cursor_get_type()))

template gdk_is_broadway_cursor_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, broadway_cursor_get_type()))

template gdk_broadway_cursor_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, broadway_cursor_get_type(), 
                             BroadwayCursorClass))

type 
  BroadwayCursor* =  ptr BroadwayCursorObj
  BroadwayCursorPtr* = ptr BroadwayCursorObj
  BroadwayCursorObj* = CursorObj
proc broadway_cursor_get_type*(): GType {.
    importc: "gdk_broadway_cursor_get_type", libgdk.}

template gdk_broadway_visual*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, broadway_visual_get_type(), 
                              BroadwayVisualObj))

template gdk_broadway_visual_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, broadway_visual_get_type(), 
                           BroadwayVisualClass))

template gdk_is_broadway_visual*(obj: expr): expr = 
  (g_type_check_instance_type(obj, broadway_visual_get_type()))

template gdk_is_broadway_visual_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, broadway_visual_get_type()))

template gdk_broadway_visual_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, broadway_visual_get_type(), 
                             BroadwayVisualClass))

type 
  BroadwayVisual* =  ptr BroadwayVisualObj
  BroadwayVisualPtr* = ptr BroadwayVisualObj
  BroadwayVisualObj* = VisualObj
proc broadway_visual_get_type*(): GType {.
    importc: "gdk_broadway_visual_get_type", libgdk.}

proc broadway_buffer_create*(width: cint; height: cint; data: var guint8; 
                             stride: cint): ptr BroadwayBuffer {.
    importc: "broadway_buffer_create", libgdk.}
proc destroy*(buffer: ptr BroadwayBuffer) {.
    importc: "broadway_buffer_destroy", libgdk.}
proc encode*(buffer: ptr BroadwayBuffer; 
                             prev: ptr BroadwayBuffer; dest: glib.GString) {.
    importc: "broadway_buffer_encode", libgdk.}
proc get_width*(buffer: ptr BroadwayBuffer): cint {.
    importc: "broadway_buffer_get_width", libgdk.}
proc width*(buffer: ptr BroadwayBuffer): cint {.
    importc: "broadway_buffer_get_width", libgdk.}
proc get_height*(buffer: ptr BroadwayBuffer): cint {.
    importc: "broadway_buffer_get_height", libgdk.}
proc height*(buffer: ptr BroadwayBuffer): cint {.
    importc: "broadway_buffer_get_height", libgdk.}

type 
  BroadwayRect* =  ptr BroadwayRectObj
  BroadwayRectPtr* = ptr BroadwayRectObj
  BroadwayRectObj* = object 
    x*: gint32
    y*: gint32
    width*: gint32
    height*: gint32

  BroadwayEventType* {.size: sizeof(cint), pure.} = enum 
    BUTTON_RELEASE = 'B',
    KEY_RELEASE = 'K',
    DELETE_NOTIFY = 'W', 
    BUTTON_PRESS = 'b', 
    SCREEN_SIZE_CHANGED = 'd',
    ENTER = 'e',
    FOCUS = 'f'
    GRAB_NOTIFY = 'g', 
    KEY_PRESS = 'k', 
    LEAVE = 'l', 
    POINTER_MOVE = 'm',
    SCROLL = 's',
    TOUCH = 't', 
    UNGRAB_NOTIFY = 'u',
    CONFIGURE_NOTIFY = 'w', 
  BroadwayOpType* {.size: sizeof(cint), pure.} = enum 
    DISCONNECTED = 'D', 
    HIDE_SURFACE = 'H',
    AUTH_OK = 'L',
    LOWER_SURFACE = 'R',
    SHOW_SURFACE = 'S', 
    PUT_BUFFER = 'b',
    DESTROY_SURFACE = 'd', 
    GRAB_POINTER = 'g',
    PUT_RGB = 'i',
    SET_SHOW_KEYBOARD = 'k'
    REQUEST_AUTH = 'l', 
    MOVE_RESIZE = 'm',
    SET_TRANSIENT_FOR = 'p', 
    RAISE_SURFACE = 'r', 
    NEW_SURFACE = 's',
    UNGRAB_POINTER = 'u', 
  BroadwayInputBaseMsg* =  ptr BroadwayInputBaseMsgObj
  BroadwayInputBaseMsgPtr* = ptr BroadwayInputBaseMsgObj
  BroadwayInputBaseMsgObj{.inheritable, pure.} = object
    `type`*: guint32
    serial*: guint32
    time*: guint64

  BroadwayInputPointerMsg* =  ptr BroadwayInputPointerMsgObj
  BroadwayInputPointerMsgPtr* = ptr BroadwayInputPointerMsgObj
  BroadwayInputPointerMsgObj*{.final.} = object of BroadwayInputBaseMsgObj
    mouse_window_id*: guint32
    event_window_id*: guint32
    root_x*: gint32
    root_y*: gint32
    win_x*: gint32
    win_y*: gint32
    state*: guint32

  BroadwayInputCrossingMsg* =  ptr BroadwayInputCrossingMsgObj
  BroadwayInputCrossingMsgPtr* = ptr BroadwayInputCrossingMsgObj
  BroadwayInputCrossingMsgObj* = object 
    pointer*: BroadwayInputPointerMsgObj
    mode*: guint32

  BroadwayInputButtonMsg* =  ptr BroadwayInputButtonMsgObj
  BroadwayInputButtonMsgPtr* = ptr BroadwayInputButtonMsgObj
  BroadwayInputButtonMsgObj* = object 
    pointer*: BroadwayInputPointerMsgObj
    button*: guint32

  BroadwayInputScrollMsg* =  ptr BroadwayInputScrollMsgObj
  BroadwayInputScrollMsgPtr* = ptr BroadwayInputScrollMsgObj
  BroadwayInputScrollMsgObj* = object 
    pointer*: BroadwayInputPointerMsgObj
    dir*: gint32

  BroadwayInputTouchMsg* =  ptr BroadwayInputTouchMsgObj
  BroadwayInputTouchMsgPtr* = ptr BroadwayInputTouchMsgObj
  BroadwayInputTouchMsgObj*{.final.} = object of BroadwayInputBaseMsgObj
    touch_type*: guint32
    event_window_id*: guint32
    sequence_id*: guint32
    is_emulated*: guint32
    root_x*: gint32
    root_y*: gint32
    win_x*: gint32
    win_y*: gint32
    state*: guint32

  BroadwayInputKeyMsg* =  ptr BroadwayInputKeyMsgObj
  BroadwayInputKeyMsgPtr* = ptr BroadwayInputKeyMsgObj
  BroadwayInputKeyMsgObj*{.final.} = object of BroadwayInputBaseMsgObj
    window_id*: guint32
    state*: guint32
    key*: gint32

  BroadwayInputGrabReply* =  ptr BroadwayInputGrabReplyObj
  BroadwayInputGrabReplyPtr* = ptr BroadwayInputGrabReplyObj
  BroadwayInputGrabReplyObj*{.final.} = object of BroadwayInputBaseMsgObj
    res*: gint32

  BroadwayInputConfigureNotify* =  ptr BroadwayInputConfigureNotifyObj
  BroadwayInputConfigureNotifyPtr* = ptr BroadwayInputConfigureNotifyObj
  BroadwayInputConfigureNotifyObj*{.final.} = object of BroadwayInputBaseMsgObj
    id*: gint32
    x*: gint32
    y*: gint32
    width*: gint32
    height*: gint32

  BroadwayInputScreenResizeNotify* =  ptr BroadwayInputScreenResizeNotifyObj
  BroadwayInputScreenResizeNotifyPtr* = ptr BroadwayInputScreenResizeNotifyObj
  BroadwayInputScreenResizeNotifyObj*{.final.} = object of BroadwayInputBaseMsgObj
    width*: guint32
    height*: guint32

  BroadwayInputDeleteNotify* =  ptr BroadwayInputDeleteNotifyObj
  BroadwayInputDeleteNotifyPtr* = ptr BroadwayInputDeleteNotifyObj
  BroadwayInputDeleteNotifyObj*{.final.} = object of BroadwayInputBaseMsgObj
    id*: gint32

  BroadwayInputFocusMsg* =  ptr BroadwayInputFocusMsgObj
  BroadwayInputFocusMsgPtr* = ptr BroadwayInputFocusMsgObj
  BroadwayInputFocusMsgObj*{.final.} = object of BroadwayInputBaseMsgObj
    new_id*: gint32
    old_id*: gint32

  BroadwayInputMsg* =  ptr BroadwayInputMsgObj
  BroadwayInputMsgPtr* = ptr BroadwayInputMsgObj
  BroadwayInputMsgObj* = object  {.union.}
    base*: BroadwayInputBaseMsgObj
    pointer*: BroadwayInputPointerMsgObj
    crossing*: BroadwayInputCrossingMsgObj
    button*: BroadwayInputButtonMsgObj
    scroll*: BroadwayInputScrollMsgObj
    touch*: BroadwayInputTouchMsgObj
    key*: BroadwayInputKeyMsgObj
    grab_reply*: BroadwayInputGrabReplyObj
    configure_notify*: BroadwayInputConfigureNotifyObj
    delete_notify*: BroadwayInputDeleteNotifyObj
    screen_resize_notify*: BroadwayInputScreenResizeNotifyObj
    focus*: BroadwayInputFocusMsgObj

  BroadwayRequestType* {.size: sizeof(cint), pure.} = enum 
    NEW_WINDOW, FLUSH, 
    SYNC, QUERY_MOUSE, 
    DESTROY_WINDOW, SHOW_WINDOW, 
    HIDE_WINDOW, SET_TRANSIENT_FOR, 
    UPDATE, MOVE_RESIZE, 
    GRAB_POINTER, UNGRAB_POINTER, 
    FOCUS_WINDOW, SET_SHOW_KEYBOARD
  BroadwayRequestBase* =  ptr BroadwayRequestBaseObj
  BroadwayRequestBasePtr* = ptr BroadwayRequestBaseObj
  BroadwayRequestBaseObj{.inheritable, pure.} = object
    size*: guint32
    serial*: guint32
    `type`*: guint32

  BroadwayRequestFlush* =  ptr BroadwayRequestFlushObj
  BroadwayRequestFlushPtr* = ptr BroadwayRequestFlushObj
  BroadwayRequestFlushObj* = BroadwayRequestBaseObj
  BroadwayRequestSync* =  ptr BroadwayRequestSyncObj
  BroadwayRequestSyncPtr* = ptr BroadwayRequestSyncObj
  BroadwayRequestSyncObj* = BroadwayRequestBaseObj
  BroadwayRequestQueryMouse* =  ptr BroadwayRequestQueryMouseObj
  BroadwayRequestQueryMousePtr* = ptr BroadwayRequestQueryMouseObj
  BroadwayRequestQueryMouseObj* = BroadwayRequestBaseObj
  BroadwayRequestDestroyWindow* =  ptr BroadwayRequestDestroyWindowObj
  BroadwayRequestDestroyWindowPtr* = ptr BroadwayRequestDestroyWindowObj
  BroadwayRequestDestroyWindowObj*{.final.} = object of BroadwayRequestBaseObj
    id*: guint32

  BroadwayRequestShowWindow* =  ptr BroadwayRequestShowWindowObj
  BroadwayRequestShowWindowPtr* = ptr BroadwayRequestShowWindowObj
  BroadwayRequestShowWindowObj* = BroadwayRequestDestroyWindowObj
  BroadwayRequestHideWindow* =  ptr BroadwayRequestHideWindowObj
  BroadwayRequestHideWindowPtr* = ptr BroadwayRequestHideWindowObj
  BroadwayRequestHideWindowObj* = BroadwayRequestDestroyWindowObj
  BroadwayRequestFocusWindow* =  ptr BroadwayRequestFocusWindowObj
  BroadwayRequestFocusWindowPtr* = ptr BroadwayRequestFocusWindowObj
  BroadwayRequestFocusWindowObj* = BroadwayRequestDestroyWindowObj
  BroadwayRequestSetTransientFor* =  ptr BroadwayRequestSetTransientForObj
  BroadwayRequestSetTransientForPtr* = ptr BroadwayRequestSetTransientForObj
  BroadwayRequestSetTransientForObj*{.final.} = object of BroadwayRequestBaseObj
    id*: guint32
    parent*: guint32

  BroadwayRequestTranslate* =  ptr BroadwayRequestTranslateObj
  BroadwayRequestTranslatePtr* = ptr BroadwayRequestTranslateObj
  BroadwayRequestTranslateObj*{.final.} = object of BroadwayRequestBaseObj
    id*: guint32
    dx*: gint32
    dy*: gint32
    n_rects*: guint32
    rects*: array[1, BroadwayRectObj]

  BroadwayRequestUpdate* =  ptr BroadwayRequestUpdateObj
  BroadwayRequestUpdatePtr* = ptr BroadwayRequestUpdateObj
  BroadwayRequestUpdateObj*{.final.} = object of BroadwayRequestBaseObj
    id*: guint32
    name*: array[36, char]
    width*: guint32
    height*: guint32

  BroadwayRequestGrabPointer* =  ptr BroadwayRequestGrabPointerObj
  BroadwayRequestGrabPointerPtr* = ptr BroadwayRequestGrabPointerObj
  BroadwayRequestGrabPointerObj*{.final.} = object of BroadwayRequestBaseObj
    id*: guint32
    owner_events*: guint32
    event_mask*: guint32
    time: guint32

  BroadwayRequestUngrabPointer* =  ptr BroadwayRequestUngrabPointerObj
  BroadwayRequestUngrabPointerPtr* = ptr BroadwayRequestUngrabPointerObj
  BroadwayRequestUngrabPointerObj*{.final.} = object of BroadwayRequestBaseObj
    time: guint32

  BroadwayRequestNewWindow* =  ptr BroadwayRequestNewWindowObj
  BroadwayRequestNewWindowPtr* = ptr BroadwayRequestNewWindowObj
  BroadwayRequestNewWindowObj*{.final.} = object of BroadwayRequestBaseObj
    x*: gint32
    y*: gint32
    width*: guint32
    height*: guint32
    is_temp*: guint32

  BroadwayRequestMoveResize* =  ptr BroadwayRequestMoveResizeObj
  BroadwayRequestMoveResizePtr* = ptr BroadwayRequestMoveResizeObj
  BroadwayRequestMoveResizeObj*{.final.} = object of BroadwayRequestBaseObj
    id*: guint32
    with_move*: guint32
    x*: gint32
    y*: gint32
    width*: guint32
    height*: guint32

  BroadwayRequestSetShowKeyboard* =  ptr BroadwayRequestSetShowKeyboardObj
  BroadwayRequestSetShowKeyboardPtr* = ptr BroadwayRequestSetShowKeyboardObj
  BroadwayRequestSetShowKeyboardObj*{.final.} = object of BroadwayRequestBaseObj
    show_keyboard*: guint32

  BroadwayRequest* =  ptr BroadwayRequestObj
  BroadwayRequestPtr* = ptr BroadwayRequestObj
  BroadwayRequestObj* = object  {.union.}
    base*: BroadwayRequestBaseObj
    new_window*: BroadwayRequestNewWindowObj
    flush*: BroadwayRequestFlushObj
    sync*: BroadwayRequestSyncObj
    query_mouse*: BroadwayRequestQueryMouseObj
    destroy_window*: BroadwayRequestDestroyWindowObj
    show_window*: BroadwayRequestShowWindowObj
    hide_window*: BroadwayRequestHideWindowObj
    set_transient_for*: BroadwayRequestSetTransientForObj
    update*: BroadwayRequestUpdateObj
    move_resize*: BroadwayRequestMoveResizeObj
    grab_pointer*: BroadwayRequestGrabPointerObj
    ungrab_pointer*: BroadwayRequestUngrabPointerObj
    translate*: BroadwayRequestTranslateObj
    focus_window*: BroadwayRequestFocusWindowObj
    set_show_keyboard*: BroadwayRequestSetShowKeyboardObj

  BroadwayReplyType* {.size: sizeof(cint), pure.} = enum 
    EVENT, SYNC, QUERY_MOUSE, 
    NEW_WINDOW, GRAB_POINTER, 
    UNGRAB_POINTER
  BroadwayReplyBase* =  ptr BroadwayReplyBaseObj
  BroadwayReplyBasePtr* = ptr BroadwayReplyBaseObj
  BroadwayReplyBaseObj{.inheritable, pure.} = object
    size*: guint32
    in_reply_to*: guint32
    `type`*: guint32

  BroadwayReplySync* =  ptr BroadwayReplySyncObj
  BroadwayReplySyncPtr* = ptr BroadwayReplySyncObj
  BroadwayReplySyncObj* = BroadwayReplyBaseObj
  BroadwayReplyNewWindow* =  ptr BroadwayReplyNewWindowObj
  BroadwayReplyNewWindowPtr* = ptr BroadwayReplyNewWindowObj
  BroadwayReplyNewWindowObj*{.final.} = object of BroadwayReplyBaseObj
    id*: guint32

  BroadwayReplyGrabPointer* =  ptr BroadwayReplyGrabPointerObj
  BroadwayReplyGrabPointerPtr* = ptr BroadwayReplyGrabPointerObj
  BroadwayReplyGrabPointerObj*{.final.} = object of BroadwayReplyBaseObj
    status*: guint32

  BroadwayReplyUngrabPointer* =  ptr BroadwayReplyUngrabPointerObj
  BroadwayReplyUngrabPointerPtr* = ptr BroadwayReplyUngrabPointerObj
  BroadwayReplyUngrabPointerObj* = BroadwayReplyGrabPointerObj
  BroadwayReplyQueryMouse* =  ptr BroadwayReplyQueryMouseObj
  BroadwayReplyQueryMousePtr* = ptr BroadwayReplyQueryMouseObj
  BroadwayReplyQueryMouseObj*{.final.} = object of BroadwayReplyBaseObj
    toplevel*: guint32
    root_x*: gint32
    root_y*: gint32
    mask*: guint32

  BroadwayReplyEvent* =  ptr BroadwayReplyEventObj
  BroadwayReplyEventPtr* = ptr BroadwayReplyEventObj
  BroadwayReplyEventObj*{.final.} = object of BroadwayReplyBaseObj
    msg*: BroadwayInputMsgObj

  BroadwayReply* =  ptr BroadwayReplyObj
  BroadwayReplyPtr* = ptr BroadwayReplyObj
  BroadwayReplyObj* = object  {.union.}
    base*: BroadwayReplyBaseObj
    event*: BroadwayReplyEventObj
    query_mouse*: BroadwayReplyQueryMouseObj
    new_window*: BroadwayReplyNewWindowObj
    grab_pointer*: BroadwayReplyGrabPointerObj
    ungrab_pointer*: BroadwayReplyUngrabPointerObj

type 
  BroadwayWSOpCode* {.size: sizeof(cint), pure.} = enum 
    CONTINUATION = 0, TEXT = 1, 
    BINARY = 2, CNX_CLOSE = 8, 
    CNX_PING = 9, CNX_PONG = 0xA
proc broadway_output_new*(`out`: gio.GOutputStream; serial: guint32): ptr BroadwayOutput {.
    importc: "broadway_output_new", libgdk.}
proc free*(output: ptr BroadwayOutput) {.
    importc: "broadway_output_free", libgdk.}
proc flush*(output: ptr BroadwayOutput): cint {.
    importc: "broadway_output_flush", libgdk.}
proc has_error*(output: ptr BroadwayOutput): cint {.
    importc: "broadway_output_has_error", libgdk.}
proc set_next_serial*(output: ptr BroadwayOutput; 
                                      serial: guint32) {.
    importc: "broadway_output_set_next_serial", libgdk.}
proc `next_serial=`*(output: ptr BroadwayOutput; 
                                      serial: guint32) {.
    importc: "broadway_output_set_next_serial", libgdk.}
proc get_next_serial*(output: ptr BroadwayOutput): guint32 {.
    importc: "broadway_output_get_next_serial", libgdk.}
proc next_serial*(output: ptr BroadwayOutput): guint32 {.
    importc: "broadway_output_get_next_serial", libgdk.}
proc new_surface*(output: ptr BroadwayOutput; id: cint; 
                                  x: cint; y: cint; w: cint; h: cint; 
                                  is_temp: gboolean) {.
    importc: "broadway_output_new_surface", libgdk.}
proc disconnected*(output: ptr BroadwayOutput) {.
    importc: "broadway_output_disconnected", libgdk.}
proc show_surface*(output: ptr BroadwayOutput; id: cint) {.
    importc: "broadway_output_show_surface", libgdk.}
proc hide_surface*(output: ptr BroadwayOutput; id: cint) {.
    importc: "broadway_output_hide_surface", libgdk.}
proc raise_surface*(output: ptr BroadwayOutput; id: cint) {.
    importc: "broadway_output_raise_surface", libgdk.}
proc lower_surface*(output: ptr BroadwayOutput; id: cint) {.
    importc: "broadway_output_lower_surface", libgdk.}
proc destroy_surface*(output: ptr BroadwayOutput; id: cint) {.
    importc: "broadway_output_destroy_surface", libgdk.}
proc move_resize_surface*(output: ptr BroadwayOutput; 
    id: cint; has_pos: gboolean; x: cint; y: cint; has_size: gboolean; 
    w: cint; h: cint) {.importc: "broadway_output_move_resize_surface", 
                        libgdk.}
proc set_transient_for*(output: ptr BroadwayOutput; id: cint; 
    parent_id: cint) {.importc: "broadway_output_set_transient_for", 
                       libgdk.}
proc `transient_for=`*(output: ptr BroadwayOutput; id: cint; 
    parent_id: cint) {.importc: "broadway_output_set_transient_for", 
                       libgdk.}
proc put_buffer*(output: ptr BroadwayOutput; id: cint; 
                                 prev_buffer: ptr BroadwayBuffer; 
                                 buffer: ptr BroadwayBuffer) {.
    importc: "broadway_output_put_buffer", libgdk.}
proc grab_pointer*(output: ptr BroadwayOutput; id: cint; 
                                   owner_event: gboolean) {.
    importc: "broadway_output_grab_pointer", libgdk.}
proc ungrab_pointer*(output: ptr BroadwayOutput): guint32 {.
    importc: "broadway_output_ungrab_pointer", libgdk.}
proc pong*(output: ptr BroadwayOutput) {.
    importc: "broadway_output_pong", libgdk.}
proc set_show_keyboard*(output: ptr BroadwayOutput; 
    show: gboolean) {.importc: "broadway_output_set_show_keyboard", 
                      libgdk.}
proc `show_keyboard=`*(output: ptr BroadwayOutput; 
    show: gboolean) {.importc: "broadway_output_set_show_keyboard", 
                      libgdk.}

proc broadway_events_got_input*(message: BroadwayInputMsg; 
                                client_id: gint32) {.
    importc: "broadway_events_got_input", libgdk.}
template broadway_server*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, server_get_type(), BroadwayServer))

template broadway_server_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, server_get_type(), BroadwayServerClass))

template broadway_is_server*(obj: expr): expr = 
  (g_type_check_instance_type(obj, server_get_type()))

template broadway_is_server_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, server_get_type()))

template broadway_server_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, server_get_type(), BroadwayServerClass))

proc broadway_server_new*(address: cstring; port: cint; ssl_cert: cstring; 
                          ssl_key: cstring; error: var glib.GError): ptr BroadwayServer {.
    importc: "broadway_server_new", libgdk.}
proc broadway_server_on_unix_socket_new*(address: cstring; 
    error: var glib.GError): ptr BroadwayServer {.
    importc: "broadway_server_on_unix_socket_new", libgdk.}
proc has_client*(server: ptr BroadwayServer): gboolean {.
    importc: "broadway_server_has_client", libgdk.}
proc flush*(server: ptr BroadwayServer) {.
    importc: "broadway_server_flush", libgdk.}
proc sync*(server: ptr BroadwayServer) {.
    importc: "broadway_server_sync", libgdk.}
proc get_screen_size*(server: ptr BroadwayServer; 
                                      width: var guint32; height: var guint32) {.
    importc: "broadway_server_get_screen_size", libgdk.}
proc get_next_serial*(server: ptr BroadwayServer): guint32 {.
    importc: "broadway_server_get_next_serial", libgdk.}
proc next_serial*(server: ptr BroadwayServer): guint32 {.
    importc: "broadway_server_get_next_serial", libgdk.}
proc get_last_seen_time*(server: ptr BroadwayServer): guint32 {.
    importc: "broadway_server_get_last_seen_time", libgdk.}
proc last_seen_time*(server: ptr BroadwayServer): guint32 {.
    importc: "broadway_server_get_last_seen_time", libgdk.}
proc lookahead_event*(server: ptr BroadwayServer; 
                                      types: cstring): gboolean {.
    importc: "broadway_server_lookahead_event", libgdk.}
proc query_mouse*(server: ptr BroadwayServer; 
                                  toplevel: var guint32; root_x: var gint32; 
                                  root_y: var gint32; mask: var guint32) {.
    importc: "broadway_server_query_mouse", libgdk.}
proc grab_pointer*(server: ptr BroadwayServer; 
                                   client_id: gint; id: gint; 
                                   owner_events: gboolean; 
                                   event_mask: guint32; time: guint32): guint32 {.
    importc: "broadway_server_grab_pointer", libgdk.}
proc ungrab_pointer*(server: ptr BroadwayServer; 
                                     time: guint32): guint32 {.
    importc: "broadway_server_ungrab_pointer", libgdk.}
proc get_mouse_toplevel*(server: ptr BroadwayServer): gint32 {.
    importc: "broadway_server_get_mouse_toplevel", libgdk.}
proc mouse_toplevel*(server: ptr BroadwayServer): gint32 {.
    importc: "broadway_server_get_mouse_toplevel", libgdk.}
proc set_show_keyboard*(server: ptr BroadwayServer; 
    show: gboolean) {.importc: "broadway_server_set_show_keyboard", 
                      libgdk.}
proc `show_keyboard=`*(server: ptr BroadwayServer; 
    show: gboolean) {.importc: "broadway_server_set_show_keyboard", 
                      libgdk.}
proc new_window*(server: ptr BroadwayServer; x: cint; y: cint; 
                                 width: cint; height: cint; is_temp: gboolean): guint32 {.
    importc: "broadway_server_new_window", libgdk.}
proc destroy_window*(server: ptr BroadwayServer; id: gint) {.
    importc: "broadway_server_destroy_window", libgdk.}
proc window_show*(server: ptr BroadwayServer; id: gint): gboolean {.
    importc: "broadway_server_window_show", libgdk.}
proc window_hide*(server: ptr BroadwayServer; id: gint): gboolean {.
    importc: "broadway_server_window_hide", libgdk.}
proc window_raise*(server: ptr BroadwayServer; id: gint) {.
    importc: "broadway_server_window_raise", libgdk.}
proc window_lower*(server: ptr BroadwayServer; id: gint) {.
    importc: "broadway_server_window_lower", libgdk.}
proc window_set_transient_for*(server: ptr BroadwayServer; 
    id: gint; parent: gint) {.importc: "broadway_server_window_set_transient_for", 
                              libgdk.}
proc window_translate*(server: ptr BroadwayServer; id: gint; 
    area: cairo.Region; dx: gint; dy: gint): gboolean {.
    importc: "broadway_server_window_translate", libgdk.}
proc broadway_server_create_surface*(width: cint; height: cint): cairo.Surface {.
    importc: "broadway_server_create_surface", libgdk.}
proc window_update*(server: ptr BroadwayServer; id: gint; 
                                    surface: cairo.Surface) {.
    importc: "broadway_server_window_update", libgdk.}
proc window_move_resize*(server: ptr BroadwayServer; id: gint; 
    with_move: gboolean; x: cint; y: cint; width: cint; height: cint): gboolean {.
    importc: "broadway_server_window_move_resize", libgdk.}
proc focus_window*(server: ptr BroadwayServer; 
                                   new_focused_window: gint) {.
    importc: "broadway_server_focus_window", libgdk.}
proc open_surface*(server: ptr BroadwayServer; id: guint32; 
                                   name: cstring; width: cint; height: cint): cairo.Surface {.
    importc: "broadway_server_open_surface", libgdk.}
