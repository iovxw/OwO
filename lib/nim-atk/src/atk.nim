{.deadCodeElim: on.}

when defined(windows):
  const LIB_ATK = "libatk-1.0-0.dll"
elif defined(macosx):
  const LIB_ATK = "libatk-1.0(|-0).dylib"
else:
  const LIB_ATK = "libatk-1.0.so(|.0)"

{.pragma: libatk, cdecl, dynlib: LIB_ATK.}

from glib import guint64, GSListObj, gboolean, gint, guint, guint16, guint32, gpointer, gdouble, gunichar

from gobject import GValue, GValueObj, GSignalEmissionHook, GType, GObject, GObjectObj, GObjectClassObj, GTypeInterfaceObj

type
  StateType* {.size: sizeof(cint), pure.} = enum
    INVALID, ACTIVE, ARMED, BUSY,
    CHECKED, DEFUNCT, EDITABLE,
    ENABLED, EXPANDABLE, EXPANDED,
    FOCUSABLE, FOCUSED, HORIZONTAL,
    ICONIFIED, MODAL, MULTI_LINE,
    MULTISELECTABLE, OPAQUE, PRESSED,
    RESIZABLE, SELECTABLE, SELECTED,
    SENSITIVE, SHOWING, SINGLE_LINE,
    STALE, TRANSIENT, VERTICAL,
    VISIBLE, MANAGES_DESCENDANTS, INDETERMINATE,
    TRUNCATED, REQUIRED, INVALID_ENTRY,
    SUPPORTS_AUTOCOMPLETION, SELECTABLE_TEXT,
    DEFAULT, ANIMATED, VISITED,
    CHECKABLE, HAS_POPUP, HAS_TOOLTIP,
    READ_ONLY, LAST_DEFINED
  State* = guint64
proc state_type_register*(name: cstring): StateType {.
    importc: "atk_state_type_register", libatk.}
proc get_name*(`type`: StateType): cstring {.
    importc: "atk_state_type_get_name", libatk.}
proc name*(`type`: StateType): cstring {.
    importc: "atk_state_type_get_name", libatk.}
proc state_type_for_name*(name: cstring): StateType {.
    importc: "atk_state_type_for_name", libatk.}

type
  RelationType* {.size: sizeof(cint), pure.} = enum
    NULL = 0, CONTROLLED_BY,
    CONTROLLER_FOR, LABEL_FOR,
    LABELLED_BY, MEMBER_OF,
    NODE_CHILD_OF, FLOWS_TO,
    FLOWS_FROM, SUBWINDOW_OF, EMBEDS,
    EMBEDDED_BY, POPUP_FOR,
    PARENT_WINDOW_OF, DESCRIBED_BY,
    DESCRIPTION_FOR, NODE_PARENT_OF,
    LAST_DEFINED

type
  Role* {.size: sizeof(cint), pure.} = enum
    INVALID = 0, ACCEL_LABEL, ALERT,
    ANIMATION, ARROW, CALENDAR, CANVAS,
    CHECK_BOX, CHECK_MENU_ITEM, COLOR_CHOOSER,
    COLUMN_HEADER, COMBO_BOX, DATE_EDITOR,
    DESKTOP_ICON, DESKTOP_FRAME, DIAL,
    DIALOG, DIRECTORY_PANE, DRAWING_AREA,
    FILE_CHOOSER, FILLER, FONT_CHOOSER,
    FRAME, GLASS_PANE, HTML_CONTAINER,
    ICON, IMAGE, INTERNAL_FRAME, LABEL,
    LAYERED_PANE, LIST, LIST_ITEM, MENU,
    MENU_BAR, MENU_ITEM, OPTION_PANE,
    PAGE_TAB, PAGE_TAB_LIST, PANEL,
    PASSWORD_TEXT, POPUP_MENU, PROGRESS_BAR,
    PUSH_BUTTON, RADIO_BUTTON, RADIO_MENU_ITEM,
    ROOT_PANE, ROW_HEADER, SCROLL_BAR,
    SCROLL_PANE, SEPARATOR, SLIDER,
    SPLIT_PANE, SPIN_BUTTON, STATUSBAR,
    TABLE, TABLE_CELL, TABLE_COLUMN_HEADER,
    TABLE_ROW_HEADER, TEAR_OFF_MENU_ITEM, TERMINAL,
    TEXT, TOGGLE_BUTTON, TOOL_BAR,
    TOOL_TIP, TREE, TREE_TABLE, UNKNOWN,
    VIEWPORT, WINDOW, HEADER, FOOTER,
    PARAGRAPH, RULER, APPLICATION,
    AUTOCOMPLETE, EDITBAR, EMBEDDED,
    ENTRY, CHART, CAPTION, DOCUMENT_FRAME,
    HEADING, PAGE, SECTION,
    REDUNDANT_OBJECT, FORM, LINK,
    INPUT_METHOD_WINDOW, TABLE_ROW, TREE_ITEM,
    DOCUMENT_SPREADSHEET, DOCUMENT_PRESENTATION,
    DOCUMENT_TEXT, DOCUMENT_WEB, DOCUMENT_EMAIL,
    COMMENT, LIST_BOX, GROUPING,
    IMAGE_MAP, NOTIFICATION, INFO_BAR,
    LEVEL_BAR, TITLE_BAR, BLOCK_QUOTE,
    AUDIO, VIDEO, DEFINITION, ARTICLE,
    LANDMARK, LOG, MARQUEE, MATH,
    RATING, TIMER, DESCRIPTION_LIST,
    DESCRIPTION_TERM, DESCRIPTION_VALUE, `STATIC`
    MATH_FRACTION, MATH_ROOT, SUBSCRIPT,
    SUPERSCRIPT, LAST_DEFINED
type
  Layer* {.size: sizeof(cint), pure.} = enum
    INVALID, BACKGROUND, CANVAS,
    WIDGET, MDI, POPUP, OVERLAY,
    WINDOW
type
  AttributeSet* =  ptr AttributeSetObj
  AttributeSetPtr* = ptr AttributeSetObj
  AttributeSetObj* = glib.GSListObj
type
  Attribute* =  ptr AttributeObj
  AttributePtr* = ptr AttributeObj
  AttributeObj* = object
    name*: cstring
    value*: cstring

template atk_object*(obj: expr): expr =
  (g_type_check_instance_cast(obj, object_get_type(), ObjectObj))

template atk_object_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, object_get_type(), ObjectClassObj))

template atk_is_object*(obj: expr): expr =
  (g_type_check_instance_type(obj, object_get_type()))

template atk_is_object_class*(klass: expr): expr =
  (g_type_check_class_type(klass, object_get_type()))

template atk_object_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, object_get_type(), ObjectClassObj))

template atk_is_implementor*(obj: expr): expr =
  g_type_check_instance_type(obj, implementor_get_type())

template atk_implementor*(obj: expr): expr =
  g_type_check_instance_cast(obj, implementor_get_type(), ImplementorObj)

template atk_implementor_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, implementor_get_type(),
                                 ImplementorIfaceObj))

type
  Implementor* =  ptr ImplementorObj
  ImplementorPtr* = ptr ImplementorObj
  ImplementorObj* = object
 
type
  PropertyValues* =  ptr PropertyValuesObj
  PropertyValuesPtr* = ptr PropertyValuesObj
  PropertyValuesObj* = object
    property_name*: cstring
    old_value*: gobject.GValueObj
    new_value*: gobject.GValueObj

type
  RelationSet* =  ptr RelationSetObj
  RelationSetPtr* = ptr RelationSetObj
  RelationSetObj*{.final.} = object of GObjectObj
    relations*: glib.GPtrArray
type
  Object* =  ptr ObjectObj
  ObjectPtr* = ptr ObjectObj
  ObjectObj* = object of GObjectObj
    description*: cstring
    name*: cstring
    accessible_parent*: Object
    role*: Role
    relation_set*: RelationSet
    layer*: Layer
type
  Function* = proc (user_data: gpointer): gboolean {.cdecl.}
type
  PropertyChangeHandler* = proc (obj: Object;
                                    vals: PropertyValues) {.cdecl.}

type
  StateSet* =  ptr StateSetObj
  StateSetPtr* = ptr StateSetObj
  StateSetObj*{.final.} = object of GObjectObj
type
  ObjectClass* =  ptr ObjectClassObj
  ObjectClassPtr* = ptr ObjectClassObj
  ObjectClassObj* = object of GObjectClassObj
    get_name*: proc (accessible: Object): cstring {.cdecl.}
    get_description*: proc (accessible: Object): cstring {.cdecl.}
    get_parent*: proc (accessible: Object): Object {.cdecl.}
    get_n_children*: proc (accessible: Object): gint {.cdecl.}
    ref_child*: proc (accessible: Object; i: gint): Object {.cdecl.}
    get_index_in_parent*: proc (accessible: Object): gint {.cdecl.}
    ref_relation_set*: proc (accessible: Object): RelationSet {.cdecl.}
    get_role*: proc (accessible: Object): Role {.cdecl.}
    get_layer*: proc (accessible: Object): Layer {.cdecl.}
    get_mdi_zorder*: proc (accessible: Object): gint {.cdecl.}
    ref_state_set*: proc (accessible: Object): StateSet {.cdecl.}
    set_name*: proc (accessible: Object; name: cstring) {.cdecl.}
    set_description*: proc (accessible: Object; description: cstring) {.cdecl.}
    set_parent*: proc (accessible: Object; parent: Object) {.cdecl.}
    set_role*: proc (accessible: Object; role: Role) {.cdecl.}
    connect_property_change_handler*: proc (accessible: Object;
        handler: ptr PropertyChangeHandler): guint {.cdecl.}
    remove_property_change_handler*: proc (accessible: Object;
        handler_id: guint) {.cdecl.}
    initialize*: proc (accessible: Object; data: gpointer) {.cdecl.}
    children_changed*: proc (accessible: Object; change_index: guint;
                             changed_child: gpointer) {.cdecl.}
    focus_event*: proc (accessible: Object; focus_in: gboolean) {.cdecl.}
    property_change*: proc (accessible: Object;
                            values: PropertyValues) {.cdecl.}
    state_change*: proc (accessible: Object; name: cstring;
                         state_set: gboolean) {.cdecl.}
    visible_data_changed*: proc (accessible: Object) {.cdecl.}
    active_descendant_changed*: proc (accessible: Object;
                                      child: var gpointer) {.cdecl.}
    get_attributes*: proc (accessible: Object): AttributeSet {.cdecl.}
    get_object_locale*: proc (accessible: Object): cstring {.cdecl.}
    pad01*: Function

proc object_get_type*(): GType {.importc: "atk_object_get_type",
                                     libatk.}
type
  ImplementorIface* =  ptr ImplementorIfaceObj
  ImplementorIfacePtr* = ptr ImplementorIfaceObj
  ImplementorIfaceObj*{.final.} = object of GTypeInterfaceObj
    ref_accessible*: proc (implementor: Implementor): Object {.cdecl.}

proc implementor_get_type*(): GType {.importc: "atk_implementor_get_type",
    libatk.}
proc ref_accessible*(implementor: Implementor): Object {.
    importc: "atk_implementor_ref_accessible", libatk.}
proc get_name*(accessible: Object): cstring {.
    importc: "atk_object_get_name", libatk.}
proc name*(accessible: Object): cstring {.
    importc: "atk_object_get_name", libatk.}
proc get_description*(accessible: Object): cstring {.
    importc: "atk_object_get_description", libatk.}
proc description*(accessible: Object): cstring {.
    importc: "atk_object_get_description", libatk.}
proc get_parent*(accessible: Object): Object {.
    importc: "atk_object_get_parent", libatk.}
proc parent*(accessible: Object): Object {.
    importc: "atk_object_get_parent", libatk.}
proc peek_parent*(accessible: Object): Object {.
    importc: "atk_object_peek_parent", libatk.}
proc get_n_accessible_children*(accessible: Object): gint {.
    importc: "atk_object_get_n_accessible_children", libatk.}
proc n_accessible_children*(accessible: Object): gint {.
    importc: "atk_object_get_n_accessible_children", libatk.}
proc ref_accessible_child*(accessible: Object; i: gint): Object {.
    importc: "atk_object_ref_accessible_child", libatk.}
proc ref_relation_set*(accessible: Object): RelationSet {.
    importc: "atk_object_ref_relation_set", libatk.}
proc get_role*(accessible: Object): Role {.
    importc: "atk_object_get_role", libatk.}
proc role*(accessible: Object): Role {.
    importc: "atk_object_get_role", libatk.}
proc get_layer*(accessible: Object): Layer {.
    importc: "atk_object_get_layer", libatk.}
proc layer*(accessible: Object): Layer {.
    importc: "atk_object_get_layer", libatk.}
proc get_mdi_zorder*(accessible: Object): gint {.
    importc: "atk_object_get_mdi_zorder", libatk.}
proc mdi_zorder*(accessible: Object): gint {.
    importc: "atk_object_get_mdi_zorder", libatk.}
proc get_attributes*(accessible: Object): AttributeSet {.
    importc: "atk_object_get_attributes", libatk.}
proc attributes*(accessible: Object): AttributeSet {.
    importc: "atk_object_get_attributes", libatk.}
proc ref_state_set*(accessible: Object): StateSet {.
    importc: "atk_object_ref_state_set", libatk.}
proc get_index_in_parent*(accessible: Object): gint {.
    importc: "atk_object_get_index_in_parent", libatk.}
proc index_in_parent*(accessible: Object): gint {.
    importc: "atk_object_get_index_in_parent", libatk.}
proc set_name*(accessible: Object; name: cstring) {.
    importc: "atk_object_set_name", libatk.}
proc `name=`*(accessible: Object; name: cstring) {.
    importc: "atk_object_set_name", libatk.}
proc set_description*(accessible: Object;
                                 description: cstring) {.
    importc: "atk_object_set_description", libatk.}
proc `description=`*(accessible: Object;
                                 description: cstring) {.
    importc: "atk_object_set_description", libatk.}
proc set_parent*(accessible: Object; parent: Object) {.
    importc: "atk_object_set_parent", libatk.}
proc `parent=`*(accessible: Object; parent: Object) {.
    importc: "atk_object_set_parent", libatk.}
proc set_role*(accessible: Object; role: Role) {.
    importc: "atk_object_set_role", libatk.}
proc `role=`*(accessible: Object; role: Role) {.
    importc: "atk_object_set_role", libatk.}
proc connect_property_change_handler*(accessible: Object;
    handler: ptr PropertyChangeHandler): guint {.
    importc: "atk_object_connect_property_change_handler", libatk.}
proc remove_property_change_handler*(accessible: Object;
    handler_id: guint) {.importc: "atk_object_remove_property_change_handler",
                         libatk.}
proc notify_state_change*(accessible: Object;
                                     state: State; value: gboolean) {.
    importc: "atk_object_notify_state_change", libatk.}
proc initialize*(accessible: Object; data: gpointer) {.
    importc: "atk_object_initialize", libatk.}
proc get_name*(role: Role): cstring {.
    importc: "atk_role_get_name", libatk.}
proc name*(role: Role): cstring {.
    importc: "atk_role_get_name", libatk.}
proc role_for_name*(name: cstring): Role {.
    importc: "atk_role_for_name", libatk.}
proc add_relationship*(`object`: Object;
                                  relationship: RelationType;
                                  target: Object): gboolean {.
    importc: "atk_object_add_relationship", libatk.}
proc remove_relationship*(`object`: Object;
                                     relationship: RelationType;
                                     target: Object): gboolean {.
    importc: "atk_object_remove_relationship", libatk.}
proc get_localized_name*(role: Role): cstring {.
    importc: "atk_role_get_localized_name", libatk.}
proc localized_name*(role: Role): cstring {.
    importc: "atk_role_get_localized_name", libatk.}
proc role_register*(name: cstring): Role {.
    importc: "atk_role_register", libatk.}
proc get_object_locale*(accessible: Object): cstring {.
    importc: "atk_object_get_object_locale", libatk.}
proc object_locale*(accessible: Object): cstring {.
    importc: "atk_object_get_object_locale", libatk.}

template atk_is_action*(obj: expr): expr =
  g_type_check_instance_type(obj, action_get_type())

template atk_action*(obj: expr): expr =
  g_type_check_instance_cast(obj, action_get_type(), ActionObj)

template atk_action_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, action_get_type(), ActionIfaceObj))

type
  Action* =  ptr ActionObj
  ActionPtr* = ptr ActionObj
  ActionObj* = object
 
type
  ActionIface* =  ptr ActionIfaceObj
  ActionIfacePtr* = ptr ActionIfaceObj
  ActionIfaceObj*{.final.} = object of GTypeInterfaceObj
    do_action*: proc (action: Action; i: gint): gboolean {.cdecl.}
    get_n_actions*: proc (action: Action): gint {.cdecl.}
    get_description*: proc (action: Action; i: gint): cstring {.cdecl.}
    get_name*: proc (action: Action; i: gint): cstring {.cdecl.}
    get_keybinding*: proc (action: Action; i: gint): cstring {.cdecl.}
    set_description*: proc (action: Action; i: gint; desc: cstring): gboolean {.cdecl.}
    get_localized_name*: proc (action: Action; i: gint): cstring {.cdecl.}

proc action_get_type*(): GType {.importc: "atk_action_get_type",
                                     libatk.}
proc do_action*(action: Action; i: gint): gboolean {.
    importc: "atk_action_do_action", libatk.}
proc get_n_actions*(action: Action): gint {.
    importc: "atk_action_get_n_actions", libatk.}
proc n_actions*(action: Action): gint {.
    importc: "atk_action_get_n_actions", libatk.}
proc get_description*(action: Action; i: gint): cstring {.
    importc: "atk_action_get_description", libatk.}
proc description*(action: Action; i: gint): cstring {.
    importc: "atk_action_get_description", libatk.}
proc get_name*(action: Action; i: gint): cstring {.
    importc: "atk_action_get_name", libatk.}
proc name*(action: Action; i: gint): cstring {.
    importc: "atk_action_get_name", libatk.}
proc get_keybinding*(action: Action; i: gint): cstring {.
    importc: "atk_action_get_keybinding", libatk.}
proc keybinding*(action: Action; i: gint): cstring {.
    importc: "atk_action_get_keybinding", libatk.}
proc set_description*(action: Action; i: gint; desc: cstring): gboolean {.
    importc: "atk_action_set_description", libatk.}
proc get_localized_name*(action: Action; i: gint): cstring {.
    importc: "atk_action_get_localized_name", libatk.}
proc localized_name*(action: Action; i: gint): cstring {.
    importc: "atk_action_get_localized_name", libatk.}

template atk_is_util*(obj: expr): expr =
  g_type_check_instance_type(obj, util_get_type())

template atk_util*(obj: expr): expr =
  g_type_check_instance_cast(obj, util_get_type(), UtilObj)

template atk_util_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, util_get_type(), UtilClassObj))

template atk_is_util_class*(klass: expr): expr =
  (g_type_check_class_type(klass, util_get_type()))

template atk_util_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, util_get_type(), UtilClassObj))

type
  EventListener* = proc (obj: Object) {.cdecl.}
type
  EventListenerInit* = proc () {.cdecl.}
type
  KeyEventStruct* =  ptr KeyEventStructObj
  KeyEventStructPtr* = ptr KeyEventStructObj
  KeyEventStructObj* = object
    `type`*: gint
    state*: guint
    keyval*: guint
    length*: gint
    string*: cstring
    keycode*: guint16
    timestamp*: guint32
type
  KeySnoopFunc* = proc (event: KeyEventStruct; user_data: gpointer): gint {.cdecl.}

type
  KeyEventType* {.size: sizeof(cint), pure.} = enum
    PRESS, RELEASE, LAST_DEFINED
type
  Util* =  ptr UtilObj
  UtilPtr* = ptr UtilObj
  UtilObj*{.final.} = object of GObjectObj

type
  UtilClass* =  ptr UtilClassObj
  UtilClassPtr* = ptr UtilClassObj
  UtilClassObj*{.final.} = object of GObjectClassObj
    add_global_event_listener*: proc (listener: GSignalEmissionHook;
                                      event_type: cstring): guint {.cdecl.}
    remove_global_event_listener*: proc (listener_id: guint) {.cdecl.}
    add_key_event_listener*: proc (listener: KeySnoopFunc; data: gpointer): guint {.cdecl.}
    remove_key_event_listener*: proc (listener_id: guint) {.cdecl.}
    get_root*: proc (): Object {.cdecl.}
    get_toolkit_name*: proc (): cstring {.cdecl.}
    get_toolkit_version*: proc (): cstring {.cdecl.}

proc util_get_type*(): GType {.importc: "atk_util_get_type", libatk.}
type
  CoordType* {.size: sizeof(cint), pure.} = enum
    XY_SCREEN, XY_WINDOW
proc add_focus_tracker*(focus_tracker: EventListener): guint {.
    importc: "atk_add_focus_tracker", libatk.}
proc remove_focus_tracker*(tracker_id: guint) {.
    importc: "atk_remove_focus_tracker", libatk.}
proc focus_tracker_init*(init: EventListenerInit) {.
    importc: "atk_focus_tracker_init", libatk.}
proc focus_tracker_notify*(`object`: Object) {.
    importc: "atk_focus_tracker_notify", libatk.}
proc add_global_event_listener*(listener: GSignalEmissionHook;
                                    event_type: cstring): guint {.
    importc: "atk_add_global_event_listener", libatk.}
proc remove_global_event_listener*(listener_id: guint) {.
    importc: "atk_remove_global_event_listener", libatk.}
proc add_key_event_listener*(listener: KeySnoopFunc; data: gpointer): guint {.
    importc: "atk_add_key_event_listener", libatk.}
proc remove_key_event_listener*(listener_id: guint) {.
    importc: "atk_remove_key_event_listener", libatk.}
proc get_root*(): Object {.importc: "atk_get_root", libatk.}
proc get_focus_object*(): Object {.importc: "atk_get_focus_object",
    libatk.}
proc get_toolkit_name*(): cstring {.importc: "atk_get_toolkit_name",
    libatk.}
proc get_toolkit_version*(): cstring {.importc: "atk_get_toolkit_version",
    libatk.}
proc get_version*(): cstring {.importc: "atk_get_version", libatk.}

template atk_is_component*(obj: expr): expr =
  g_type_check_instance_type(obj, component_get_type())

template atk_component*(obj: expr): expr =
  g_type_check_instance_cast(obj, component_get_type(), ComponentObj)

template atk_component_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, component_get_type(), ComponentIfaceObj))

type
  Component* =  ptr ComponentObj
  ComponentPtr* = ptr ComponentObj
  ComponentObj* = object
 
type
  FocusHandler* = proc (`object`: Object; focus_in: gboolean) {.cdecl.}
type
  Rectangle* =  ptr RectangleObj
  RectanglePtr* = ptr RectangleObj
  RectangleObj* = object
    x*: gint
    y*: gint
    width*: gint
    height*: gint

proc rectangle_get_type*(): GType {.importc: "atk_rectangle_get_type",
    libatk.}
type
  ComponentIface* =  ptr ComponentIfaceObj
  ComponentIfacePtr* = ptr ComponentIfaceObj
  ComponentIfaceObj*{.final.} = object of GTypeInterfaceObj
    add_focus_handler*: proc (component: Component;
                              handler: FocusHandler): guint {.cdecl.}
    contains*: proc (component: Component; x: gint; y: gint;
                     coord_type: CoordType): gboolean {.cdecl.}
    ref_accessible_at_point*: proc (component: Component; x: gint;
                                    y: gint; coord_type: CoordType): Object {.cdecl.}
    get_extents*: proc (component: Component; x: var gint; y: var gint;
                        width: var gint; height: var gint;
                        coord_type: CoordType) {.cdecl.}
    get_position*: proc (component: Component; x: var gint;
                         y: var gint; coord_type: CoordType) {.cdecl.}
    get_size*: proc (component: Component; width: var gint;
                     height: var gint) {.cdecl.}
    grab_focus*: proc (component: Component): gboolean {.cdecl.}
    remove_focus_handler*: proc (component: Component;
                                 handler_id: guint) {.cdecl.}
    set_extents*: proc (component: Component; x: gint; y: gint;
                        width: gint; height: gint; coord_type: CoordType): gboolean {.cdecl.}
    set_position*: proc (component: Component; x: gint; y: gint;
                         coord_type: CoordType): gboolean {.cdecl.}
    set_size*: proc (component: Component; width: gint; height: gint): gboolean {.cdecl.}
    get_layer*: proc (component: Component): Layer {.cdecl.}
    get_mdi_zorder*: proc (component: Component): gint {.cdecl.}
    bounds_changed*: proc (component: Component;
                           bounds: Rectangle) {.cdecl.}
    get_alpha*: proc (component: Component): gdouble {.cdecl.}

proc component_get_type*(): GType {.importc: "atk_component_get_type",
    libatk.}
proc add_focus_handler*(component: Component;
                                      handler: FocusHandler): guint {.
    importc: "atk_component_add_focus_handler", libatk.}
proc contains*(component: Component; x: gint; y: gint;
                             coord_type: CoordType): gboolean {.
    importc: "atk_component_contains", libatk.}
proc ref_accessible_at_point*(component: Component;
    x: gint; y: gint; coord_type: CoordType): Object {.
    importc: "atk_component_ref_accessible_at_point", libatk.}
proc get_extents*(component: Component; x: var gint;
                                y: var gint; width: var gint;
                                height: var gint; coord_type: CoordType) {.
    importc: "atk_component_get_extents", libatk.}
proc get_position*(component: Component; x: var gint;
                                 y: var gint; coord_type: CoordType) {.
    importc: "atk_component_get_position", libatk.}
proc get_size*(component: Component; width: var gint;
                             height: var gint) {.
    importc: "atk_component_get_size", libatk.}
proc get_layer*(component: Component): Layer {.
    importc: "atk_component_get_layer", libatk.}
proc layer*(component: Component): Layer {.
    importc: "atk_component_get_layer", libatk.}
proc get_mdi_zorder*(component: Component): gint {.
    importc: "atk_component_get_mdi_zorder", libatk.}
proc mdi_zorder*(component: Component): gint {.
    importc: "atk_component_get_mdi_zorder", libatk.}
proc grab_focus*(component: Component): gboolean {.
    importc: "atk_component_grab_focus", libatk.}
proc remove_focus_handler*(component: Component;
    handler_id: guint) {.importc: "atk_component_remove_focus_handler",
                         libatk.}
proc set_extents*(component: Component; x: gint; y: gint;
                                width: gint; height: gint;
                                coord_type: CoordType): gboolean {.
    importc: "atk_component_set_extents", libatk.}
proc set_position*(component: Component; x: gint;
                                 y: gint; coord_type: CoordType): gboolean {.
    importc: "atk_component_set_position", libatk.}
proc set_size*(component: Component; width: gint;
                             height: gint): gboolean {.
    importc: "atk_component_set_size", libatk.}
proc get_alpha*(component: Component): gdouble {.
    importc: "atk_component_get_alpha", libatk.}
proc alpha*(component: Component): gdouble {.
    importc: "atk_component_get_alpha", libatk.}

template atk_is_document*(obj: expr): expr =
  g_type_check_instance_type(obj, document_get_type())

template atk_document*(obj: expr): expr =
  g_type_check_instance_cast(obj, document_get_type(), DocumentObj)

template atk_document_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, document_get_type(), DocumentIfaceObj))

type
  Document* =  ptr DocumentObj
  DocumentPtr* = ptr DocumentObj
  DocumentObj* = object
 
type
  DocumentIface* =  ptr DocumentIfaceObj
  DocumentIfacePtr* = ptr DocumentIfaceObj
  DocumentIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_document_type*: proc (document: Document): cstring {.cdecl.}
    get_document*: proc (document: Document): gpointer {.cdecl.}
    get_document_locale*: proc (document: Document): cstring {.cdecl.}
    get_document_attributes*: proc (document: Document): AttributeSet {.cdecl.}
    get_document_attribute_value*: proc (document: Document;
        attribute_name: cstring): cstring {.cdecl.}
    set_document_attribute*: proc (document: Document;
                                   attribute_name: cstring;
                                   attribute_value: cstring): gboolean {.cdecl.}
    get_current_page_number*: proc (document: Document): gint {.cdecl.}
    get_page_count*: proc (document: Document): gint {.cdecl.}

proc document_get_type*(): GType {.importc: "atk_document_get_type",
    libatk.}
proc get_document_type*(document: Document): cstring {.
    importc: "atk_document_get_document_type", libatk.}
proc document_type*(document: Document): cstring {.
    importc: "atk_document_get_document_type", libatk.}
proc get_document*(document: Document): gpointer {.
    importc: "atk_document_get_document", libatk.}
proc document*(document: Document): gpointer {.
    importc: "atk_document_get_document", libatk.}
proc get_locale*(document: Document): cstring {.
    importc: "atk_document_get_locale", libatk.}
proc locale*(document: Document): cstring {.
    importc: "atk_document_get_locale", libatk.}
proc get_attributes*(document: Document): AttributeSet {.
    importc: "atk_document_get_attributes", libatk.}
proc attributes*(document: Document): AttributeSet {.
    importc: "atk_document_get_attributes", libatk.}
proc get_attribute_value*(document: Document;
    attribute_name: cstring): cstring {.
    importc: "atk_document_get_attribute_value", libatk.}
proc attribute_value*(document: Document;
    attribute_name: cstring): cstring {.
    importc: "atk_document_get_attribute_value", libatk.}
proc set_attribute_value*(document: Document;
    attribute_name: cstring; attribute_value: cstring): gboolean {.
    importc: "atk_document_set_attribute_value", libatk.}
proc get_current_page_number*(document: Document): gint {.
    importc: "atk_document_get_current_page_number", libatk.}
proc current_page_number*(document: Document): gint {.
    importc: "atk_document_get_current_page_number", libatk.}
proc get_page_count*(document: Document): gint {.
    importc: "atk_document_get_page_count", libatk.}
proc page_count*(document: Document): gint {.
    importc: "atk_document_get_page_count", libatk.}

type
  TextAttribute* {.size: sizeof(cint), pure.} = enum
    INVALID = 0, LEFT_MARGIN,
    RIGHT_MARGIN, INDENT, INVISIBLE,
    EDITABLE, PIXELS_ABOVE_LINES,
    PIXELS_BELOW_LINES, PIXELS_INSIDE_WRAP,
    BG_FULL_HEIGHT, RISE, UNDERLINE,
    STRIKETHROUGH, SIZE, SCALE,
    WEIGHT, LANGUAGE, FAMILY_NAME,
    BG_COLOR, FG_COLOR, BG_STIPPLE,
    FG_STIPPLE, WRAP_MODE,
    DIRECTION, JUSTIFICATION,
    STRETCH, VARIANT, STYLE,
    LAST_DEFINED
proc text_attribute_register*(name: cstring): TextAttribute {.
    importc: "atk_text_attribute_register", libatk.}
template atk_is_text*(obj: expr): expr =
  g_type_check_instance_type(obj, text_get_type())

template atk_text*(obj: expr): expr =
  g_type_check_instance_cast(obj, text_get_type(), TextObj)

template atk_text_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, text_get_type(), TextIfaceObj))

type
  Text* =  ptr TextObj
  TextPtr* = ptr TextObj
  TextObj* = object
 
type
  TextBoundary* {.size: sizeof(cint), pure.} = enum
    CHAR, WORD_START,
    WORD_END, SENTENCE_START,
    SENTENCE_END, LINE_START,
    LINE_END
type
  TextGranularity* {.size: sizeof(cint), pure.} = enum
    CHAR, WORD,
    SENTENCE, LINE,
    PARAGRAPH
type
  TextRectangle* =  ptr TextRectangleObj
  TextRectanglePtr* = ptr TextRectangleObj
  TextRectangleObj* = object
    x*: gint
    y*: gint
    width*: gint
    height*: gint

type
  TextRange* =  ptr TextRangeObj
  TextRangePtr* = ptr TextRangeObj
  TextRangeObj* = object
    bounds*: TextRectangleObj
    start_offset*: gint
    end_offset*: gint
    content*: cstring

proc text_range_get_type*(): GType {.importc: "atk_text_range_get_type",
    libatk.}
type
  TextClipType* {.size: sizeof(cint), pure.} = enum
    NONE, MIN, MAX,
    BOTH
type
  TextIface* =  ptr TextIfaceObj
  TextIfacePtr* = ptr TextIfaceObj
  TextIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_text*: proc (text: Text; start_offset: gint; end_offset: gint): cstring {.cdecl.}
    get_text_after_offset*: proc (text: Text; offset: gint;
                                  boundary_type: TextBoundary;
                                  start_offset: var gint; end_offset: var gint): cstring {.cdecl.}
    get_text_at_offset*: proc (text: Text; offset: gint;
                               boundary_type: TextBoundary;
                               start_offset: var gint; end_offset: var gint): cstring {.cdecl.}
    get_character_at_offset*: proc (text: Text; offset: gint): gunichar {.cdecl.}
    get_text_before_offset*: proc (text: Text; offset: gint;
                                   boundary_type: TextBoundary;
                                   start_offset: var gint;
                                   end_offset: var gint): cstring {.cdecl.}
    get_caret_offset*: proc (text: Text): gint {.cdecl.}
    get_run_attributes*: proc (text: Text; offset: gint;
                               start_offset: var gint; end_offset: var gint): AttributeSet {.cdecl.}
    get_default_attributes*: proc (text: Text): AttributeSet {.cdecl.}
    get_character_extents*: proc (text: Text; offset: gint;
                                  x: var gint; y: var gint; width: var gint;
                                  height: var gint; coords: CoordType) {.cdecl.}
    get_character_count*: proc (text: Text): gint {.cdecl.}
    get_offset_at_point*: proc (text: Text; x: gint; y: gint;
                                coords: CoordType): gint {.cdecl.}
    get_n_selections*: proc (text: Text): gint {.cdecl.}
    get_selection*: proc (text: Text; selection_num: gint;
                          start_offset: var gint; end_offset: var gint): cstring {.cdecl.}
    add_selection*: proc (text: Text; start_offset: gint;
                          end_offset: gint): gboolean {.cdecl.}
    remove_selection*: proc (text: Text; selection_num: gint): gboolean {.cdecl.}
    set_selection*: proc (text: Text; selection_num: gint;
                          start_offset: gint; end_offset: gint): gboolean {.cdecl.}
    set_caret_offset*: proc (text: Text; offset: gint): gboolean {.cdecl.}
    text_changed*: proc (text: Text; position: gint; length: gint) {.cdecl.}
    text_caret_moved*: proc (text: Text; location: gint) {.cdecl.}
    text_selection_changed*: proc (text: Text) {.cdecl.}
    text_attributes_changed*: proc (text: Text) {.cdecl.}
    get_range_extents*: proc (text: Text; start_offset: gint;
                              end_offset: gint; coord_type: CoordType;
                              rect: TextRectangle) {.cdecl.}
    get_bounded_ranges*: proc (text: Text; rect: TextRectangle;
                               coord_type: CoordType;
                               x_clip_type: TextClipType;
                               y_clip_type: TextClipType): ptr TextRange {.cdecl.}
    get_string_at_offset*: proc (text: Text; offset: gint;
                                 granularity: TextGranularity;
                                 start_offset: var gint; end_offset: var gint): cstring {.cdecl.}

proc text_get_type*(): GType {.importc: "atk_text_get_type", libatk.}
proc get_text*(text: Text; start_offset: gint;
                        end_offset: gint): cstring {.
    importc: "atk_text_get_text", libatk.}
proc text*(text: Text; start_offset: gint;
                        end_offset: gint): cstring {.
    importc: "atk_text_get_text", libatk.}
proc get_character_at_offset*(text: Text; offset: gint): gunichar {.
    importc: "atk_text_get_character_at_offset", libatk.}
proc character_at_offset*(text: Text; offset: gint): gunichar {.
    importc: "atk_text_get_character_at_offset", libatk.}
proc get_text_after_offset*(text: Text; offset: gint;
                                     boundary_type: TextBoundary;
                                     start_offset: var gint;
                                     end_offset: var gint): cstring {.
    importc: "atk_text_get_text_after_offset", libatk.}
proc text_after_offset*(text: Text; offset: gint;
                                     boundary_type: TextBoundary;
                                     start_offset: var gint;
                                     end_offset: var gint): cstring {.
    importc: "atk_text_get_text_after_offset", libatk.}
proc get_text_at_offset*(text: Text; offset: gint;
                                  boundary_type: TextBoundary;
                                  start_offset: var gint; end_offset: var gint): cstring {.
    importc: "atk_text_get_text_at_offset", libatk.}
proc text_at_offset*(text: Text; offset: gint;
                                  boundary_type: TextBoundary;
                                  start_offset: var gint; end_offset: var gint): cstring {.
    importc: "atk_text_get_text_at_offset", libatk.}
proc get_text_before_offset*(text: Text; offset: gint;
                                      boundary_type: TextBoundary;
                                      start_offset: var gint;
                                      end_offset: var gint): cstring {.
    importc: "atk_text_get_text_before_offset", libatk.}
proc text_before_offset*(text: Text; offset: gint;
                                      boundary_type: TextBoundary;
                                      start_offset: var gint;
                                      end_offset: var gint): cstring {.
    importc: "atk_text_get_text_before_offset", libatk.}
proc get_string_at_offset*(text: Text; offset: gint;
                                    granularity: TextGranularity;
                                    start_offset: var gint;
                                    end_offset: var gint): cstring {.
    importc: "atk_text_get_string_at_offset", libatk.}
proc string_at_offset*(text: Text; offset: gint;
                                    granularity: TextGranularity;
                                    start_offset: var gint;
                                    end_offset: var gint): cstring {.
    importc: "atk_text_get_string_at_offset", libatk.}
proc get_caret_offset*(text: Text): gint {.
    importc: "atk_text_get_caret_offset", libatk.}
proc caret_offset*(text: Text): gint {.
    importc: "atk_text_get_caret_offset", libatk.}
proc get_character_extents*(text: Text; offset: gint;
                                     x: var gint; y: var gint;
                                     width: var gint; height: var gint;
                                     coords: CoordType) {.
    importc: "atk_text_get_character_extents", libatk.}
proc get_run_attributes*(text: Text; offset: gint;
                                  start_offset: var gint; end_offset: var gint): AttributeSet {.
    importc: "atk_text_get_run_attributes", libatk.}
proc run_attributes*(text: Text; offset: gint;
                                  start_offset: var gint; end_offset: var gint): AttributeSet {.
    importc: "atk_text_get_run_attributes", libatk.}
proc get_default_attributes*(text: Text): AttributeSet {.
    importc: "atk_text_get_default_attributes", libatk.}
proc default_attributes*(text: Text): AttributeSet {.
    importc: "atk_text_get_default_attributes", libatk.}
proc get_character_count*(text: Text): gint {.
    importc: "atk_text_get_character_count", libatk.}
proc character_count*(text: Text): gint {.
    importc: "atk_text_get_character_count", libatk.}
proc get_offset_at_point*(text: Text; x: gint; y: gint;
                                   coords: CoordType): gint {.
    importc: "atk_text_get_offset_at_point", libatk.}
proc offset_at_point*(text: Text; x: gint; y: gint;
                                   coords: CoordType): gint {.
    importc: "atk_text_get_offset_at_point", libatk.}
proc get_n_selections*(text: Text): gint {.
    importc: "atk_text_get_n_selections", libatk.}
proc n_selections*(text: Text): gint {.
    importc: "atk_text_get_n_selections", libatk.}
proc get_selection*(text: Text; selection_num: gint;
                             start_offset: var gint; end_offset: var gint): cstring {.
    importc: "atk_text_get_selection", libatk.}
proc selection*(text: Text; selection_num: gint;
                             start_offset: var gint; end_offset: var gint): cstring {.
    importc: "atk_text_get_selection", libatk.}
proc add_selection*(text: Text; start_offset: gint;
                             end_offset: gint): gboolean {.
    importc: "atk_text_add_selection", libatk.}
proc remove_selection*(text: Text; selection_num: gint): gboolean {.
    importc: "atk_text_remove_selection", libatk.}
proc set_selection*(text: Text; selection_num: gint;
                             start_offset: gint; end_offset: gint): gboolean {.
    importc: "atk_text_set_selection", libatk.}
proc set_caret_offset*(text: Text; offset: gint): gboolean {.
    importc: "atk_text_set_caret_offset", libatk.}
proc get_range_extents*(text: Text; start_offset: gint;
                                 end_offset: gint; coord_type: CoordType;
                                 rect: var TextRectangleObj) {.
    importc: "atk_text_get_range_extents", libatk.}
proc get_bounded_ranges*(text: Text;
                                  rect: TextRectangle;
                                  coord_type: CoordType;
                                  x_clip_type: TextClipType;
                                  y_clip_type: TextClipType): ptr TextRange {.
    importc: "atk_text_get_bounded_ranges", libatk.}
proc bounded_ranges*(text: Text;
                                  rect: TextRectangle;
                                  coord_type: CoordType;
                                  x_clip_type: TextClipType;
                                  y_clip_type: TextClipType): ptr TextRange {.
    importc: "atk_text_get_bounded_ranges", libatk.}
proc text_free_ranges*(ranges: var TextRange) {.
    importc: "atk_text_free_ranges", libatk.}
proc free*(attrib_set: AttributeSet) {.
    importc: "atk_attribute_set_free", libatk.}
proc get_name*(attr: TextAttribute): cstring {.
    importc: "atk_text_attribute_get_name", libatk.}
proc name*(attr: TextAttribute): cstring {.
    importc: "atk_text_attribute_get_name", libatk.}
proc text_attribute_for_name*(name: cstring): TextAttribute {.
    importc: "atk_text_attribute_for_name", libatk.}
proc get_value*(attr: TextAttribute; index: gint): cstring {.
    importc: "atk_text_attribute_get_value", libatk.}
proc value*(attr: TextAttribute; index: gint): cstring {.
    importc: "atk_text_attribute_get_value", libatk.}

template atk_is_editable_text*(obj: expr): expr =
  g_type_check_instance_type(obj, editable_text_get_type())

template atk_editable_text*(obj: expr): expr =
  g_type_check_instance_cast(obj, editable_text_get_type(), EditableTextObj)

template atk_editable_text_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, editable_text_get_type(),
                                 EditableTextIfaceObj))

type
  EditableText* =  ptr EditableTextObj
  EditableTextPtr* = ptr EditableTextObj
  EditableTextObj* = object
 
type
  EditableTextIface* =  ptr EditableTextIfaceObj
  EditableTextIfacePtr* = ptr EditableTextIfaceObj
  EditableTextIfaceObj*{.final.} = object of GTypeInterfaceObj
    set_run_attributes*: proc (text: EditableText;
                               attrib_set: AttributeSet;
                               start_offset: gint; end_offset: gint): gboolean {.cdecl.}
    set_text_contents*: proc (text: EditableText; string: cstring) {.cdecl.}
    insert_text*: proc (text: EditableText; string: cstring;
                        length: gint; position: var gint) {.cdecl.}
    copy_text*: proc (text: EditableText; start_pos: gint;
                      end_pos: gint) {.cdecl.}
    cut_text*: proc (text: EditableText; start_pos: gint; end_pos: gint) {.cdecl.}
    delete_text*: proc (text: EditableText; start_pos: gint;
                        end_pos: gint) {.cdecl.}
    paste_text*: proc (text: EditableText; position: gint) {.cdecl.}

proc editable_text_get_type*(): GType {.
    importc: "atk_editable_text_get_type", libatk.}
proc set_run_attributes*(text: EditableText;
    attrib_set: AttributeSet; start_offset: gint; end_offset: gint): gboolean {.
    importc: "atk_editable_text_set_run_attributes", libatk.}
proc set_text_contents*(text: EditableText;
    string: cstring) {.importc: "atk_editable_text_set_text_contents",
                       libatk.}
proc `text_contents=`*(text: EditableText;
    string: cstring) {.importc: "atk_editable_text_set_text_contents",
                       libatk.}
proc insert_text*(text: EditableText;
                                    string: cstring; length: gint;
                                    position: var gint) {.
    importc: "atk_editable_text_insert_text", libatk.}
proc copy_text*(text: EditableText; start_pos: gint;
                                  end_pos: gint) {.
    importc: "atk_editable_text_copy_text", libatk.}
proc cut_text*(text: EditableText; start_pos: gint;
                                 end_pos: gint) {.
    importc: "atk_editable_text_cut_text", libatk.}
proc delete_text*(text: EditableText;
                                    start_pos: gint; end_pos: gint) {.
    importc: "atk_editable_text_delete_text", libatk.}
proc paste_text*(text: EditableText; position: gint) {.
    importc: "atk_editable_text_paste_text", libatk.}

proc hyperlink_state_flags_get_type*(): GType {.
    importc: "atk_hyperlink_state_flags_get_type", libatk.}
proc role_get_type*(): GType {.importc: "atk_role_get_type", libatk.}
proc layer_get_type*(): GType {.importc: "atk_layer_get_type", libatk.}
proc relation_type_get_type*(): GType {.
    importc: "atk_relation_type_get_type", libatk.}
proc state_type_get_type*(): GType {.importc: "atk_state_type_get_type",
    libatk.}
proc text_attribute_get_type*(): GType {.
    importc: "atk_text_attribute_get_type", libatk.}
proc text_boundary_get_type*(): GType {.
    importc: "atk_text_boundary_get_type", libatk.}
proc text_granularity_get_type*(): GType {.
    importc: "atk_text_granularity_get_type", libatk.}
proc text_clip_type_get_type*(): GType {.
    importc: "atk_text_clip_type_get_type", libatk.}
proc key_event_type_get_type*(): GType {.
    importc: "atk_key_event_type_get_type", libatk.}
proc coord_type_get_type*(): GType {.importc: "atk_coord_type_get_type",
    libatk.}
proc value_type_get_type*(): GType {.importc: "atk_value_type_get_type",
    libatk.}

template atk_gobject_accessible*(obj: expr): expr =
  (g_type_check_instance_cast(obj, gobject_accessible_get_type(),
                              GObjectAccessibleObj))

template atk_gobject_accessible_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, gobject_accessible_get_type(),
                           GObjectAccessibleClassObj))

template atk_is_gobject_accessible*(obj: expr): expr =
  (g_type_check_instance_type(obj, gobject_accessible_get_type()))

template atk_is_gobject_accessible_class*(klass: expr): expr =
  (g_type_check_class_type(klass, gobject_accessible_get_type()))

template atk_gobject_accessible_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, gobject_accessible_get_type(),
                             GObjectAccessibleClassObj))

type
  GObjectAccessible* =  ptr GObjectAccessibleObj
  GObjectAccessiblePtr* = ptr GObjectAccessibleObj
  GObjectAccessibleObj*{.final.} = object of ObjectObj

proc gobject_accessible_get_type*(): GType {.
    importc: "atk_gobject_accessible_get_type", libatk.}
type
  GObjectAccessibleClass* =  ptr GObjectAccessibleClassObj
  GObjectAccessibleClassPtr* = ptr GObjectAccessibleClassObj
  GObjectAccessibleClassObj*{.final.} = object of ObjectClassObj
    pad1*: Function
    pad2*: Function

proc gobject_accessible_for_object*(obj: GObject): Object {.
    importc: "atk_gobject_accessible_for_object", libatk.}
proc gobject_accessible_get_object*(obj: GObjectAccessible): GObject {.
    importc: "atk_gobject_accessible_get_object", libatk.}

type
  HyperlinkStateFlags* {.size: sizeof(cint), pure.} = enum
    IS_INLINE = 1 shl 0
template atk_hyperlink*(obj: expr): expr =
  (g_type_check_instance_cast(obj, hyperlink_get_type(), HyperlinkObj))

template atk_hyperlink_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, hyperlink_get_type(), HyperlinkClassObj))

template atk_is_hyperlink*(obj: expr): expr =
  (g_type_check_instance_type(obj, hyperlink_get_type()))

template atk_is_hyperlink_class*(klass: expr): expr =
  (g_type_check_class_type(klass, hyperlink_get_type()))

template atk_hyperlink_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, hyperlink_get_type(), HyperlinkClassObj))

type
  Hyperlink* =  ptr HyperlinkObj
  HyperlinkPtr* = ptr HyperlinkObj
  HyperlinkObj*{.final.} = object of GObjectObj

type
  HyperlinkClass* =  ptr HyperlinkClassObj
  HyperlinkClassPtr* = ptr HyperlinkClassObj
  HyperlinkClassObj*{.final.} = object of GObjectClassObj
    get_uri*: proc (link: Hyperlink; i: gint): cstring {.cdecl.}
    get_object*: proc (link: Hyperlink; i: gint): Object {.cdecl.}
    get_end_index*: proc (link: Hyperlink): gint {.cdecl.}
    get_start_index*: proc (link: Hyperlink): gint {.cdecl.}
    is_valid*: proc (link: Hyperlink): gboolean {.cdecl.}
    get_n_anchors*: proc (link: Hyperlink): gint {.cdecl.}
    link_state*: proc (link: Hyperlink): guint {.cdecl.}
    is_selected_link*: proc (link: Hyperlink): gboolean {.cdecl.}
    link_activated*: proc (link: Hyperlink) {.cdecl.}
    pad1*: Function

proc hyperlink_get_type*(): GType {.importc: "atk_hyperlink_get_type",
    libatk.}
proc get_uri*(link: Hyperlink; i: gint): cstring {.
    importc: "atk_hyperlink_get_uri", libatk.}
proc uri*(link: Hyperlink; i: gint): cstring {.
    importc: "atk_hyperlink_get_uri", libatk.}
proc get_object*(link: Hyperlink; i: gint): Object {.
    importc: "atk_hyperlink_get_object", libatk.}
proc `object`*(link: Hyperlink; i: gint): Object {.
    importc: "atk_hyperlink_get_object", libatk.}
proc get_end_index*(link: Hyperlink): gint {.
    importc: "atk_hyperlink_get_end_index", libatk.}
proc end_index*(link: Hyperlink): gint {.
    importc: "atk_hyperlink_get_end_index", libatk.}
proc get_start_index*(link: Hyperlink): gint {.
    importc: "atk_hyperlink_get_start_index", libatk.}
proc start_index*(link: Hyperlink): gint {.
    importc: "atk_hyperlink_get_start_index", libatk.}
proc is_valid*(link: Hyperlink): gboolean {.
    importc: "atk_hyperlink_is_valid", libatk.}
proc is_inline*(link: Hyperlink): gboolean {.
    importc: "atk_hyperlink_is_inline", libatk.}
proc get_n_anchors*(link: Hyperlink): gint {.
    importc: "atk_hyperlink_get_n_anchors", libatk.}
proc n_anchors*(link: Hyperlink): gint {.
    importc: "atk_hyperlink_get_n_anchors", libatk.}
proc is_selected_link*(link: Hyperlink): gboolean {.
    importc: "atk_hyperlink_is_selected_link", libatk.}

template atk_is_hyperlink_impl*(obj: expr): expr =
  g_type_check_instance_type(obj, hyperlink_impl_get_type())

template atk_hyperlink_impl*(obj: expr): expr =
  g_type_check_instance_cast(obj, hyperlink_impl_get_type(), HyperlinkImplObj)

template atk_hyperlink_impl_get_iface*(obj: expr): expr =
  g_type_instance_get_interface(obj, hyperlink_impl_get_type(),
                                HyperlinkImplIfaceObj)

type
  HyperlinkImpl* =  ptr HyperlinkImplObj
  HyperlinkImplPtr* = ptr HyperlinkImplObj
  HyperlinkImplObj* = object
 
type
  HyperlinkImplIface* =  ptr HyperlinkImplIfaceObj
  HyperlinkImplIfacePtr* = ptr HyperlinkImplIfaceObj
  HyperlinkImplIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_hyperlink*: proc (impl: HyperlinkImpl): Hyperlink {.cdecl.}

proc hyperlink_impl_get_type*(): GType {.
    importc: "atk_hyperlink_impl_get_type", libatk.}
proc get_hyperlink*(impl: HyperlinkImpl): Hyperlink {.
    importc: "atk_hyperlink_impl_get_hyperlink", libatk.}
proc hyperlink*(impl: HyperlinkImpl): Hyperlink {.
    importc: "atk_hyperlink_impl_get_hyperlink", libatk.}

template atk_is_hypertext*(obj: expr): expr =
  g_type_check_instance_type(obj, hypertext_get_type())

template atk_hypertext*(obj: expr): expr =
  g_type_check_instance_cast(obj, hypertext_get_type(), HypertextObj)

template atk_hypertext_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, hypertext_get_type(), HypertextIfaceObj))

type
  Hypertext* =  ptr HypertextObj
  HypertextPtr* = ptr HypertextObj
  HypertextObj* = object
 
type
  HypertextIface* =  ptr HypertextIfaceObj
  HypertextIfacePtr* = ptr HypertextIfaceObj
  HypertextIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_link*: proc (hypertext: Hypertext; link_index: gint): Hyperlink {.cdecl.}
    get_n_links*: proc (hypertext: Hypertext): gint {.cdecl.}
    get_link_index*: proc (hypertext: Hypertext; char_index: gint): gint {.cdecl.}
    link_selected*: proc (hypertext: Hypertext; link_index: gint) {.cdecl.}

proc hypertext_get_type*(): GType {.importc: "atk_hypertext_get_type",
    libatk.}
proc get_link*(hypertext: Hypertext; link_index: gint): Hyperlink {.
    importc: "atk_hypertext_get_link", libatk.}
proc link*(hypertext: Hypertext; link_index: gint): Hyperlink {.
    importc: "atk_hypertext_get_link", libatk.}
proc get_n_links*(hypertext: Hypertext): gint {.
    importc: "atk_hypertext_get_n_links", libatk.}
proc n_links*(hypertext: Hypertext): gint {.
    importc: "atk_hypertext_get_n_links", libatk.}
proc get_link_index*(hypertext: Hypertext;
                                   char_index: gint): gint {.
    importc: "atk_hypertext_get_link_index", libatk.}
proc link_index*(hypertext: Hypertext;
                                   char_index: gint): gint {.
    importc: "atk_hypertext_get_link_index", libatk.}

template atk_is_image*(obj: expr): expr =
  g_type_check_instance_type(obj, image_get_type())

template atk_image*(obj: expr): expr =
  g_type_check_instance_cast(obj, image_get_type(), ImageObj)

template atk_image_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, image_get_type(), ImageIfaceObj))

type
  Image* =  ptr ImageObj
  ImagePtr* = ptr ImageObj
  ImageObj* = object
 
type
  ImageIface* =  ptr ImageIfaceObj
  ImageIfacePtr* = ptr ImageIfaceObj
  ImageIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_image_position*: proc (image: Image; x: var gint; y: var gint;
                               coord_type: CoordType) {.cdecl.}
    get_image_description*: proc (image: Image): cstring {.cdecl.}
    get_image_size*: proc (image: Image; width: var gint;
                           height: var gint) {.cdecl.}
    set_image_description*: proc (image: Image; description: cstring): gboolean {.cdecl.}
    get_image_locale*: proc (image: Image): cstring {.cdecl.}

proc image_get_type*(): GType {.importc: "atk_image_get_type", libatk.}
proc get_image_description*(image: Image): cstring {.
    importc: "atk_image_get_image_description", libatk.}
proc image_description*(image: Image): cstring {.
    importc: "atk_image_get_image_description", libatk.}
proc get_image_size*(image: Image; width: var gint;
                               height: var gint) {.
    importc: "atk_image_get_image_size", libatk.}
proc set_image_description*(image: Image;
                                      description: cstring): gboolean {.
    importc: "atk_image_set_image_description", libatk.}
proc get_image_position*(image: Image; x: var gint;
                                   y: var gint; coord_type: CoordType) {.
    importc: "atk_image_get_image_position", libatk.}
proc get_image_locale*(image: Image): cstring {.
    importc: "atk_image_get_image_locale", libatk.}
proc image_locale*(image: Image): cstring {.
    importc: "atk_image_get_image_locale", libatk.}

template atk_no_op_object*(obj: expr): expr =
  (g_type_check_instance_cast(obj, no_op_object_get_type(), NoOpObjectObj))

template atk_no_op_object_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, no_op_object_get_type(), NoOpObjectClassObj))

template atk_is_no_op_object*(obj: expr): expr =
  (g_type_check_instance_type(obj, no_op_object_get_type()))

template atk_is_no_op_object_class*(klass: expr): expr =
  (g_type_check_class_type(klass, no_op_object_get_type()))

template atk_no_op_object_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, no_op_object_get_type(), NoOpObjectClassObj))

type
  NoOpObject* =  ptr NoOpObjectObj
  NoOpObjectPtr* = ptr NoOpObjectObj
  NoOpObjectObj*{.final.} = object of ObjectObj

proc no_op_object_get_type*(): GType {.
    importc: "atk_no_op_object_get_type", libatk.}
type
  NoOpObjectClass* =  ptr NoOpObjectClassObj
  NoOpObjectClassPtr* = ptr NoOpObjectClassObj
  NoOpObjectClassObj*{.final.} = object of ObjectClassObj

proc no_op_object_new*(obj: GObject): Object {.
    importc: "atk_no_op_object_new", libatk.}

template atk_object_factory*(obj: expr): expr =
  (g_type_check_instance_cast(obj, object_factory_get_type(), ObjectFactoryObj))

template atk_object_factory_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, object_factory_get_type(),
                           ObjectFactoryClassObj))

template atk_is_object_factory*(obj: expr): expr =
  (g_type_check_instance_type(obj, object_factory_get_type()))

template atk_is_object_factory_class*(klass: expr): expr =
  (g_type_check_class_type(klass, object_factory_get_type()))

template atk_object_factory_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, object_factory_get_type(),
                             ObjectFactoryClassObj))

type
  ObjectFactory* =  ptr ObjectFactoryObj
  ObjectFactoryPtr* = ptr ObjectFactoryObj
  ObjectFactoryObj* = object of GObjectObj

type
  ObjectFactoryClass* =  ptr ObjectFactoryClassObj
  ObjectFactoryClassPtr* = ptr ObjectFactoryClassObj
  ObjectFactoryClassObj* = object of GObjectClassObj
    create_accessible*: proc (obj: GObject): Object {.cdecl.}
    invalidate*: proc (factory: ObjectFactory) {.cdecl.}
    get_accessible_type*: proc (): GType {.cdecl.}
    pad1*: Function
    pad2*: Function

proc object_factory_get_type*(): GType {.
    importc: "atk_object_factory_get_type", libatk.}
proc create_accessible*(factory: ObjectFactory;
    obj: GObject): Object {.
    importc: "atk_object_factory_create_accessible", libatk.}
proc invalidate*(factory: ObjectFactory) {.
    importc: "atk_object_factory_invalidate", libatk.}
proc get_accessible_type*(factory: ObjectFactory): GType {.
    importc: "atk_object_factory_get_accessible_type", libatk.}
proc accessible_type*(factory: ObjectFactory): GType {.
    importc: "atk_object_factory_get_accessible_type", libatk.}

template atk_no_op_object_factory*(obj: expr): expr =
  (g_type_check_instance_cast(obj, no_op_object_factory_get_type(),
                              NoOpObjectFactoryObj))

template atk_no_op_object_factory_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, no_op_object_factory_get_type(),
                           NoOpObjectFactoryClassObj))

template atk_is_no_op_object_factory*(obj: expr): expr =
  (g_type_check_instance_type(obj, no_op_object_factory_get_type()))

template atk_is_no_op_object_factory_class*(klass: expr): expr =
  (g_type_check_class_type(klass, no_op_object_factory_get_type()))

template atk_no_op_object_factory_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, no_op_object_factory_get_type(),
                             NoOpObjectFactoryClassObj))

type
  NoOpObjectFactory* =  ptr NoOpObjectFactoryObj
  NoOpObjectFactoryPtr* = ptr NoOpObjectFactoryObj
  NoOpObjectFactoryObj*{.final.} = object of ObjectFactoryObj

type
  NoOpObjectFactoryClass* =  ptr NoOpObjectFactoryClassObj
  NoOpObjectFactoryClassPtr* = ptr NoOpObjectFactoryClassObj
  NoOpObjectFactoryClassObj*{.final.} = object of ObjectFactoryClassObj

proc no_op_object_factory_get_type*(): GType {.
    importc: "atk_no_op_object_factory_get_type", libatk.}
proc no_op_object_factory_new*(): ObjectFactory {.
    importc: "atk_no_op_object_factory_new", libatk.}

template atk_plug*(obj: expr): expr =
  (g_type_check_instance_cast(obj, plug_get_type(), PlugObj))

template atk_is_plug*(obj: expr): expr =
  (g_type_check_instance_type(obj, plug_get_type()))

template atk_plug_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, plug_get_type(), PlugClassObj))

template atk_is_plug_class*(klass: expr): expr =
  (g_type_check_class_type(klass, plug_get_type()))

template atk_plug_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, plug_get_type(), PlugClassObj))

type
  Plug* =  ptr PlugObj
  PlugPtr* = ptr PlugObj
  PlugObj*{.final.} = object of ObjectObj

proc plug_get_type*(): GType {.importc: "atk_plug_get_type", libatk.}
type
  PlugClass* =  ptr PlugClassObj
  PlugClassPtr* = ptr PlugClassObj
  PlugClassObj*{.final.} = object of ObjectClassObj
    get_object_id*: proc (obj: Plug): cstring {.cdecl.}

proc plug_new*(): Object {.importc: "atk_plug_new", libatk.}
proc get_id*(plug: Plug): cstring {.
    importc: "atk_plug_get_id", libatk.}
proc id*(plug: Plug): cstring {.
    importc: "atk_plug_get_id", libatk.}

type
  Range* =  ptr RangeObj
  RangePtr* = ptr RangeObj
  RangeObj* = object
 
proc range_get_type*(): GType {.importc: "atk_range_get_type", libatk.}
proc copy*(src: Range): Range {.
    importc: "atk_range_copy", libatk.}
proc free*(range: Range) {.importc: "atk_range_free",
    libatk.}
proc get_lower_limit*(range: Range): gdouble {.
    importc: "atk_range_get_lower_limit", libatk.}
proc lower_limit*(range: Range): gdouble {.
    importc: "atk_range_get_lower_limit", libatk.}
proc get_upper_limit*(range: Range): gdouble {.
    importc: "atk_range_get_upper_limit", libatk.}
proc upper_limit*(range: Range): gdouble {.
    importc: "atk_range_get_upper_limit", libatk.}
proc get_description*(range: Range): cstring {.
    importc: "atk_range_get_description", libatk.}
proc description*(range: Range): cstring {.
    importc: "atk_range_get_description", libatk.}
proc range_new*(lower_limit: gdouble; upper_limit: gdouble;
                    description: cstring): Range {.
    importc: "atk_range_new", libatk.}

template atk_registry*(obj: expr): expr =
  (g_type_check_instance_cast(obj, registry_get_type(), RegistryObj))

template atk_registry_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, registry_get_type(), RegistryClassObj))

template atk_is_registry*(obj: expr): expr =
  (g_type_check_instance_type(obj, registry_get_type()))

template atk_is_registry_class*(klass: expr): expr =
  (g_type_check_class_type(klass, registry_get_type()))

template atk_registry_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, registry_get_type(), RegistryClassObj))

type
  Registry* =  ptr RegistryObj
  RegistryPtr* = ptr RegistryObj
  RegistryObj*{.final.} = object of GObjectObj
    factory_type_registry*: glib.GHashTable
    factory_singleton_cache*: glib.GHashTable

type
  RegistryClass* =  ptr RegistryClassObj
  RegistryClassPtr* = ptr RegistryClassObj
  RegistryClassObj*{.final.} = object of GObjectClassObj

proc registry_get_type*(): GType {.importc: "atk_registry_get_type",
    libatk.}
proc set_factory_type*(registry: Registry; `type`: GType;
                                    factory_type: GType) {.
    importc: "atk_registry_set_factory_type", libatk.}
proc `factory_type=`*(registry: Registry; `type`: GType;
                                    factory_type: GType) {.
    importc: "atk_registry_set_factory_type", libatk.}
proc get_factory_type*(registry: Registry; `type`: GType): GType {.
    importc: "atk_registry_get_factory_type", libatk.}
proc factory_type*(registry: Registry; `type`: GType): GType {.
    importc: "atk_registry_get_factory_type", libatk.}
proc get_factory*(registry: Registry; `type`: GType): ObjectFactory {.
    importc: "atk_registry_get_factory", libatk.}
proc factory*(registry: Registry; `type`: GType): ObjectFactory {.
    importc: "atk_registry_get_factory", libatk.}
proc get_default_registry*(): Registry {.
    importc: "atk_get_default_registry", libatk.}

template atk_relation*(obj: expr): expr =
  (g_type_check_instance_cast(obj, relation_get_type(), RelationObj))

template atk_relation_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, relation_get_type(), RelationClassObj))

template atk_is_relation*(obj: expr): expr =
  (g_type_check_instance_type(obj, relation_get_type()))

template atk_is_relation_class*(klass: expr): expr =
  (g_type_check_class_type(klass, relation_get_type()))

template atk_relation_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, relation_get_type(), RelationClassObj))

type
  Relation* =  ptr RelationObj
  RelationPtr* = ptr RelationObj
  RelationObj*{.final.} = object of GObjectObj
    target*: glib.GPtrArray
    relationship*: RelationType

type
  RelationClass* =  ptr RelationClassObj
  RelationClassPtr* = ptr RelationClassObj
  RelationClassObj*{.final.} = object of GObjectClassObj

proc relation_get_type*(): GType {.importc: "atk_relation_get_type",
    libatk.}
proc relation_type_register*(name: cstring): RelationType {.
    importc: "atk_relation_type_register", libatk.}
proc get_name*(`type`: RelationType): cstring {.
    importc: "atk_relation_type_get_name", libatk.}
proc name*(`type`: RelationType): cstring {.
    importc: "atk_relation_type_get_name", libatk.}
proc relation_type_for_name*(name: cstring): RelationType {.
    importc: "atk_relation_type_for_name", libatk.}
proc relation_new*(targets: var Object; n_targets: gint;
                       relationship: RelationType): Relation {.
    importc: "atk_relation_new", libatk.}
proc get_relation_type*(relation: Relation): RelationType {.
    importc: "atk_relation_get_relation_type", libatk.}
proc relation_type*(relation: Relation): RelationType {.
    importc: "atk_relation_get_relation_type", libatk.}
proc get_target*(relation: Relation): glib.GPtrArray {.
    importc: "atk_relation_get_target", libatk.}
proc target*(relation: Relation): glib.GPtrArray {.
    importc: "atk_relation_get_target", libatk.}
proc add_target*(relation: Relation; target: Object) {.
    importc: "atk_relation_add_target", libatk.}
proc remove_target*(relation: Relation;
                                 target: Object): gboolean {.
    importc: "atk_relation_remove_target", libatk.}

template atk_relation_set*(obj: expr): expr =
  (g_type_check_instance_cast(obj, relation_set_get_type(), RelationSetObj))

template atk_relation_set_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, relation_set_get_type(), RelationSetClassObj))

template atk_is_relation_set*(obj: expr): expr =
  (g_type_check_instance_type(obj, relation_set_get_type()))

template atk_is_relation_set_class*(klass: expr): expr =
  (g_type_check_class_type(klass, relation_set_get_type()))

template atk_relation_set_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, relation_set_get_type(), RelationSetClassObj))

type
  RelationSetClass* =  ptr RelationSetClassObj
  RelationSetClassPtr* = ptr RelationSetClassObj
  RelationSetClassObj*{.final.} = object of GObjectClassObj
    pad1*: Function
    pad2*: Function

proc relation_set_get_type*(): GType {.
    importc: "atk_relation_set_get_type", libatk.}
proc relation_set_new*(): RelationSet {.
    importc: "atk_relation_set_new", libatk.}
proc contains*(set: RelationSet;
                                relationship: RelationType): gboolean {.
    importc: "atk_relation_set_contains", libatk.}
proc contains_target*(set: RelationSet;
    relationship: RelationType; target: Object): gboolean {.
    importc: "atk_relation_set_contains_target", libatk.}
proc remove*(set: RelationSet;
                              relation: Relation) {.
    importc: "atk_relation_set_remove", libatk.}
proc add*(set: RelationSet; relation: Relation) {.
    importc: "atk_relation_set_add", libatk.}
proc get_n_relations*(set: RelationSet): gint {.
    importc: "atk_relation_set_get_n_relations", libatk.}
proc n_relations*(set: RelationSet): gint {.
    importc: "atk_relation_set_get_n_relations", libatk.}
proc get_relation*(set: RelationSet; i: gint): Relation {.
    importc: "atk_relation_set_get_relation", libatk.}
proc relation*(set: RelationSet; i: gint): Relation {.
    importc: "atk_relation_set_get_relation", libatk.}
proc get_relation_by_type*(set: RelationSet;
    relationship: RelationType): Relation {.
    importc: "atk_relation_set_get_relation_by_type", libatk.}
proc relation_by_type*(set: RelationSet;
    relationship: RelationType): Relation {.
    importc: "atk_relation_set_get_relation_by_type", libatk.}
proc add_relation_by_type*(set: RelationSet;
    relationship: RelationType; target: Object) {.
    importc: "atk_relation_set_add_relation_by_type", libatk.}

template atk_is_selection*(obj: expr): expr =
  g_type_check_instance_type(obj, selection_get_type())

template atk_selection*(obj: expr): expr =
  g_type_check_instance_cast(obj, selection_get_type(), SelectionObj)

template atk_selection_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, selection_get_type(), SelectionIfaceObj))

type
  Selection* =  ptr SelectionObj
  SelectionPtr* = ptr SelectionObj
  SelectionObj* = object
 
type
  SelectionIface* =  ptr SelectionIfaceObj
  SelectionIfacePtr* = ptr SelectionIfaceObj
  SelectionIfaceObj*{.final.} = object of GTypeInterfaceObj
    add_selection*: proc (selection: Selection; i: gint): gboolean {.cdecl.}
    clear_selection*: proc (selection: Selection): gboolean {.cdecl.}
    ref_selection*: proc (selection: Selection; i: gint): Object {.cdecl.}
    get_selection_count*: proc (selection: Selection): gint {.cdecl.}
    is_child_selected*: proc (selection: Selection; i: gint): gboolean {.cdecl.}
    remove_selection*: proc (selection: Selection; i: gint): gboolean {.cdecl.}
    select_all_selection*: proc (selection: Selection): gboolean {.cdecl.}
    selection_changed*: proc (selection: Selection) {.cdecl.}

proc selection_get_type*(): GType {.importc: "atk_selection_get_type",
    libatk.}
proc add_selection*(selection: Selection; i: gint): gboolean {.
    importc: "atk_selection_add_selection", libatk.}
proc clear_selection*(selection: Selection): gboolean {.
    importc: "atk_selection_clear_selection", libatk.}
proc ref_selection*(selection: Selection; i: gint): Object {.
    importc: "atk_selection_ref_selection", libatk.}
proc get_selection_count*(selection: Selection): gint {.
    importc: "atk_selection_get_selection_count", libatk.}
proc selection_count*(selection: Selection): gint {.
    importc: "atk_selection_get_selection_count", libatk.}
proc is_child_selected*(selection: Selection; i: gint): gboolean {.
    importc: "atk_selection_is_child_selected", libatk.}
proc remove_selection*(selection: Selection; i: gint): gboolean {.
    importc: "atk_selection_remove_selection", libatk.}
proc select_all_selection*(selection: Selection): gboolean {.
    importc: "atk_selection_select_all_selection", libatk.}

template atk_socket*(obj: expr): expr =
  (g_type_check_instance_cast(obj, socket_get_type(), SocketObj))

template atk_is_socket*(obj: expr): expr =
  (g_type_check_instance_type(obj, socket_get_type()))

template atk_socket_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, socket_get_type(), SocketClassObj))

template atk_is_socket_class*(klass: expr): expr =
  (g_type_check_class_type(klass, socket_get_type()))

template atk_socket_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, socket_get_type(), SocketClassObj))

type
  Socket* =  ptr SocketObj
  SocketPtr* = ptr SocketObj
  SocketObj*{.final.} = object of ObjectObj
    embedded_plug_id*: cstring

proc socket_get_type*(): GType {.importc: "atk_socket_get_type",
                                     libatk.}
type
  SocketClass* =  ptr SocketClassObj
  SocketClassPtr* = ptr SocketClassObj
  SocketClassObj*{.final.} = object of ObjectClassObj
    embed*: proc (obj: Socket; plug_id: cstring) {.cdecl.}

proc socket_new*(): Object {.importc: "atk_socket_new", libatk.}
proc embed*(obj: Socket; plug_id: cstring) {.
    importc: "atk_socket_embed", libatk.}
proc is_occupied*(obj: Socket): gboolean {.
    importc: "atk_socket_is_occupied", libatk.}

template atk_state_set*(obj: expr): expr =
  (g_type_check_instance_cast(obj, state_set_get_type(), StateSetObj))

template atk_state_set_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, state_set_get_type(), StateSetClassObj))

template atk_is_state_set*(obj: expr): expr =
  (g_type_check_instance_type(obj, state_set_get_type()))

template atk_is_state_set_class*(klass: expr): expr =
  (g_type_check_class_type(klass, state_set_get_type()))

template atk_state_set_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, state_set_get_type(), StateSetClassObj))

type
  StateSetClass* =  ptr StateSetClassObj
  StateSetClassPtr* = ptr StateSetClassObj
  StateSetClassObj*{.final.} = object of GObjectClassObj

proc state_set_get_type*(): GType {.importc: "atk_state_set_get_type",
    libatk.}
proc state_set_new*(): StateSet {.importc: "atk_state_set_new",
    libatk.}
proc is_empty*(set: StateSet): gboolean {.
    importc: "atk_state_set_is_empty", libatk.}
proc add_state*(set: StateSet; `type`: StateType): gboolean {.
    importc: "atk_state_set_add_state", libatk.}
proc add_states*(set: StateSet; types: ptr StateType;
                               n_types: gint) {.
    importc: "atk_state_set_add_states", libatk.}
proc clear_states*(set: StateSet) {.
    importc: "atk_state_set_clear_states", libatk.}
proc contains_state*(set: StateSet; `type`: StateType): gboolean {.
    importc: "atk_state_set_contains_state", libatk.}
proc contains_states*(set: StateSet;
                                    types: ptr StateType; n_types: gint): gboolean {.
    importc: "atk_state_set_contains_states", libatk.}
proc remove_state*(set: StateSet; `type`: StateType): gboolean {.
    importc: "atk_state_set_remove_state", libatk.}
proc and_sets*(set: StateSet;
                             compare_set: StateSet): StateSet {.
    importc: "atk_state_set_and_sets", libatk.}
proc or_sets*(set: StateSet; compare_set: StateSet): StateSet {.
    importc: "atk_state_set_or_sets", libatk.}
proc xor_sets*(set: StateSet;
                             compare_set: StateSet): StateSet {.
    importc: "atk_state_set_xor_sets", libatk.}

template atk_is_streamable_content*(obj: expr): expr =
  g_type_check_instance_type(obj, streamable_content_get_type())

template atk_streamable_content*(obj: expr): expr =
  g_type_check_instance_cast(obj, streamable_content_get_type(),
                             StreamableContentObj)

template atk_streamable_content_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, streamable_content_get_type(),
                                 StreamableContentIfaceObj))

type
  StreamableContent* =  ptr StreamableContentObj
  StreamableContentPtr* = ptr StreamableContentObj
  StreamableContentObj* = object
 
type
  StreamableContentIface* =  ptr StreamableContentIfaceObj
  StreamableContentIfacePtr* = ptr StreamableContentIfaceObj
  StreamableContentIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_n_mime_types*: proc (streamable: StreamableContent): gint {.cdecl.}
    get_mime_type*: proc (streamable: StreamableContent; i: gint): cstring {.cdecl.}
    get_stream*: proc (streamable: StreamableContent;
                       mime_type: cstring): glib.GIOChannel {.cdecl.}
    get_uri*: proc (streamable: StreamableContent; mime_type: cstring): cstring {.cdecl.}
    pad1*: Function
    pad2*: Function
    pad3*: Function

proc streamable_content_get_type*(): GType {.
    importc: "atk_streamable_content_get_type", libatk.}
proc get_n_mime_types*(
    streamable: StreamableContent): gint {.
    importc: "atk_streamable_content_get_n_mime_types", libatk.}
proc n_mime_types*(
    streamable: StreamableContent): gint {.
    importc: "atk_streamable_content_get_n_mime_types", libatk.}
proc get_mime_type*(
    streamable: StreamableContent; i: gint): cstring {.
    importc: "atk_streamable_content_get_mime_type", libatk.}
proc mime_type*(
    streamable: StreamableContent; i: gint): cstring {.
    importc: "atk_streamable_content_get_mime_type", libatk.}
proc get_stream*(streamable: StreamableContent;
    mime_type: cstring): glib.GIOChannel {.
    importc: "atk_streamable_content_get_stream", libatk.}
proc stream*(streamable: StreamableContent;
    mime_type: cstring): glib.GIOChannel {.
    importc: "atk_streamable_content_get_stream", libatk.}
proc get_uri*(streamable: StreamableContent;
                                     mime_type: cstring): cstring {.
    importc: "atk_streamable_content_get_uri", libatk.}
proc uri*(streamable: StreamableContent;
                                     mime_type: cstring): cstring {.
    importc: "atk_streamable_content_get_uri", libatk.}

template atk_is_table*(obj: expr): expr =
  g_type_check_instance_type(obj, table_get_type())

template atk_table*(obj: expr): expr =
  g_type_check_instance_cast(obj, table_get_type(), TableObj)

template atk_table_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, table_get_type(), TableIfaceObj))

type
  Table* =  ptr TableObj
  TablePtr* = ptr TableObj
  TableObj* = object
 
type
  TableIface* =  ptr TableIfaceObj
  TableIfacePtr* = ptr TableIfaceObj
  TableIfaceObj*{.final.} = object of GTypeInterfaceObj
    ref_at*: proc (table: Table; row: gint; column: gint): Object {.cdecl.}
    get_index_at*: proc (table: Table; row: gint; column: gint): gint {.cdecl.}
    get_column_at_index*: proc (table: Table; index: gint): gint {.cdecl.}
    get_row_at_index*: proc (table: Table; index: gint): gint {.cdecl.}
    get_n_columns*: proc (table: Table): gint {.cdecl.}
    get_n_rows*: proc (table: Table): gint {.cdecl.}
    get_column_extent_at*: proc (table: Table; row: gint; column: gint): gint {.cdecl.}
    get_row_extent_at*: proc (table: Table; row: gint; column: gint): gint {.cdecl.}
    get_caption*: proc (table: Table): Object {.cdecl.}
    get_column_description*: proc (table: Table; column: gint): cstring {.cdecl.}
    get_column_header*: proc (table: Table; column: gint): Object {.cdecl.}
    get_row_description*: proc (table: Table; row: gint): cstring {.cdecl.}
    get_row_header*: proc (table: Table; row: gint): Object {.cdecl.}
    get_summary*: proc (table: Table): Object {.cdecl.}
    set_caption*: proc (table: Table; caption: Object) {.cdecl.}
    set_column_description*: proc (table: Table; column: gint;
                                   description: cstring) {.cdecl.}
    set_column_header*: proc (table: Table; column: gint;
                              header: Object) {.cdecl.}
    set_row_description*: proc (table: Table; row: gint;
                                description: cstring) {.cdecl.}
    set_row_header*: proc (table: Table; row: gint;
                           header: Object) {.cdecl.}
    set_summary*: proc (table: Table; accessible: Object) {.cdecl.}
    get_selected_columns*: proc (table: Table; selected: var ptr gint): gint {.cdecl.}
    get_selected_rows*: proc (table: Table; selected: var ptr gint): gint {.cdecl.}
    is_column_selected*: proc (table: Table; column: gint): gboolean {.cdecl.}
    is_row_selected*: proc (table: Table; row: gint): gboolean {.cdecl.}
    is_selected*: proc (table: Table; row: gint; column: gint): gboolean {.cdecl.}
    add_row_selection*: proc (table: Table; row: gint): gboolean {.cdecl.}
    remove_row_selection*: proc (table: Table; row: gint): gboolean {.cdecl.}
    add_column_selection*: proc (table: Table; column: gint): gboolean {.cdecl.}
    remove_column_selection*: proc (table: Table; column: gint): gboolean {.cdecl.}
    row_inserted*: proc (table: Table; row: gint; num_inserted: gint) {.cdecl.}
    column_inserted*: proc (table: Table; column: gint;
                            num_inserted: gint) {.cdecl.}
    row_deleted*: proc (table: Table; row: gint; num_deleted: gint) {.cdecl.}
    column_deleted*: proc (table: Table; column: gint;
                           num_deleted: gint) {.cdecl.}
    row_reordered*: proc (table: Table) {.cdecl.}
    column_reordered*: proc (table: Table) {.cdecl.}
    model_changed*: proc (table: Table) {.cdecl.}

proc table_get_type*(): GType {.importc: "atk_table_get_type", libatk.}
proc ref_at*(table: Table; row: gint; column: gint): Object {.
    importc: "atk_table_ref_at", libatk.}
proc get_index_at*(table: Table; row: gint; column: gint): gint {.
    importc: "atk_table_get_index_at", libatk.}
proc index_at*(table: Table; row: gint; column: gint): gint {.
    importc: "atk_table_get_index_at", libatk.}
proc get_column_at_index*(table: Table; index: gint): gint {.
    importc: "atk_table_get_column_at_index", libatk.}
proc column_at_index*(table: Table; index: gint): gint {.
    importc: "atk_table_get_column_at_index", libatk.}
proc get_row_at_index*(table: Table; index: gint): gint {.
    importc: "atk_table_get_row_at_index", libatk.}
proc row_at_index*(table: Table; index: gint): gint {.
    importc: "atk_table_get_row_at_index", libatk.}
proc get_n_columns*(table: Table): gint {.
    importc: "atk_table_get_n_columns", libatk.}
proc n_columns*(table: Table): gint {.
    importc: "atk_table_get_n_columns", libatk.}
proc get_n_rows*(table: Table): gint {.
    importc: "atk_table_get_n_rows", libatk.}
proc n_rows*(table: Table): gint {.
    importc: "atk_table_get_n_rows", libatk.}
proc get_column_extent_at*(table: Table; row: gint;
                                     column: gint): gint {.
    importc: "atk_table_get_column_extent_at", libatk.}
proc column_extent_at*(table: Table; row: gint;
                                     column: gint): gint {.
    importc: "atk_table_get_column_extent_at", libatk.}
proc get_row_extent_at*(table: Table; row: gint; column: gint): gint {.
    importc: "atk_table_get_row_extent_at", libatk.}
proc row_extent_at*(table: Table; row: gint; column: gint): gint {.
    importc: "atk_table_get_row_extent_at", libatk.}
proc get_caption*(table: Table): Object {.
    importc: "atk_table_get_caption", libatk.}
proc caption*(table: Table): Object {.
    importc: "atk_table_get_caption", libatk.}
proc get_column_description*(table: Table; column: gint): cstring {.
    importc: "atk_table_get_column_description", libatk.}
proc column_description*(table: Table; column: gint): cstring {.
    importc: "atk_table_get_column_description", libatk.}
proc get_column_header*(table: Table; column: gint): Object {.
    importc: "atk_table_get_column_header", libatk.}
proc column_header*(table: Table; column: gint): Object {.
    importc: "atk_table_get_column_header", libatk.}
proc get_row_description*(table: Table; row: gint): cstring {.
    importc: "atk_table_get_row_description", libatk.}
proc row_description*(table: Table; row: gint): cstring {.
    importc: "atk_table_get_row_description", libatk.}
proc get_row_header*(table: Table; row: gint): Object {.
    importc: "atk_table_get_row_header", libatk.}
proc row_header*(table: Table; row: gint): Object {.
    importc: "atk_table_get_row_header", libatk.}
proc get_summary*(table: Table): Object {.
    importc: "atk_table_get_summary", libatk.}
proc summary*(table: Table): Object {.
    importc: "atk_table_get_summary", libatk.}
proc set_caption*(table: Table; caption: Object) {.
    importc: "atk_table_set_caption", libatk.}
proc `caption=`*(table: Table; caption: Object) {.
    importc: "atk_table_set_caption", libatk.}
proc set_column_description*(table: Table; column: gint;
    description: cstring) {.importc: "atk_table_set_column_description",
                            libatk.}
proc `column_description=`*(table: Table; column: gint;
    description: cstring) {.importc: "atk_table_set_column_description",
                            libatk.}
proc set_column_header*(table: Table; column: gint;
                                  header: Object) {.
    importc: "atk_table_set_column_header", libatk.}
proc `column_header=`*(table: Table; column: gint;
                                  header: Object) {.
    importc: "atk_table_set_column_header", libatk.}
proc set_row_description*(table: Table; row: gint;
                                    description: cstring) {.
    importc: "atk_table_set_row_description", libatk.}
proc `row_description=`*(table: Table; row: gint;
                                    description: cstring) {.
    importc: "atk_table_set_row_description", libatk.}
proc set_row_header*(table: Table; row: gint;
                               header: Object) {.
    importc: "atk_table_set_row_header", libatk.}
proc `row_header=`*(table: Table; row: gint;
                               header: Object) {.
    importc: "atk_table_set_row_header", libatk.}
proc set_summary*(table: Table; accessible: Object) {.
    importc: "atk_table_set_summary", libatk.}
proc `summary=`*(table: Table; accessible: Object) {.
    importc: "atk_table_set_summary", libatk.}
proc get_selected_columns*(table: Table;
                                     selected: var ptr gint): gint {.
    importc: "atk_table_get_selected_columns", libatk.}
proc selected_columns*(table: Table;
                                     selected: var ptr gint): gint {.
    importc: "atk_table_get_selected_columns", libatk.}
proc get_selected_rows*(table: Table; selected: var ptr gint): gint {.
    importc: "atk_table_get_selected_rows", libatk.}
proc selected_rows*(table: Table; selected: var ptr gint): gint {.
    importc: "atk_table_get_selected_rows", libatk.}
proc is_column_selected*(table: Table; column: gint): gboolean {.
    importc: "atk_table_is_column_selected", libatk.}
proc is_row_selected*(table: Table; row: gint): gboolean {.
    importc: "atk_table_is_row_selected", libatk.}
proc is_selected*(table: Table; row: gint; column: gint): gboolean {.
    importc: "atk_table_is_selected", libatk.}
proc add_row_selection*(table: Table; row: gint): gboolean {.
    importc: "atk_table_add_row_selection", libatk.}
proc remove_row_selection*(table: Table; row: gint): gboolean {.
    importc: "atk_table_remove_row_selection", libatk.}
proc add_column_selection*(table: Table; column: gint): gboolean {.
    importc: "atk_table_add_column_selection", libatk.}
proc remove_column_selection*(table: Table; column: gint): gboolean {.
    importc: "atk_table_remove_column_selection", libatk.}

template atk_is_table_cell*(obj: expr): expr =
  g_type_check_instance_type(obj, table_cell_get_type())

template atk_table_cell*(obj: expr): expr =
  g_type_check_instance_cast(obj, table_cell_get_type(), TableCellObj)

template atk_table_cell_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, table_cell_get_type(), TableCellIfaceObj))

type
  TableCell* =  ptr TableCellObj
  TableCellPtr* = ptr TableCellObj
  TableCellObj* = object
 
type
  TableCellIface* =  ptr TableCellIfaceObj
  TableCellIfacePtr* = ptr TableCellIfaceObj
  TableCellIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_column_span*: proc (cell: TableCell): gint {.cdecl.}
    get_column_header_cells*: proc (cell: TableCell): glib.GPtrArray {.cdecl.}
    get_position*: proc (cell: TableCell; row: var gint;
                         column: var gint): gboolean {.cdecl.}
    get_row_span*: proc (cell: TableCell): gint {.cdecl.}
    get_row_header_cells*: proc (cell: TableCell): glib.GPtrArray {.cdecl.}
    get_row_column_span*: proc (cell: TableCell; row: var gint;
                                column: var gint; row_span: var gint;
                                column_span: var gint): gboolean {.cdecl.}
    get_table*: proc (cell: TableCell): Object {.cdecl.}

proc table_cell_get_type*(): GType {.importc: "atk_table_cell_get_type",
    libatk.}
proc get_column_span*(cell: TableCell): gint {.
    importc: "atk_table_cell_get_column_span", libatk.}
proc column_span*(cell: TableCell): gint {.
    importc: "atk_table_cell_get_column_span", libatk.}
proc get_column_header_cells*(cell: TableCell): glib.GPtrArray {.
    importc: "atk_table_cell_get_column_header_cells", libatk.}
proc column_header_cells*(cell: TableCell): glib.GPtrArray {.
    importc: "atk_table_cell_get_column_header_cells", libatk.}
proc get_position*(cell: TableCell; row: var gint;
                                  column: var gint): gboolean {.
    importc: "atk_table_cell_get_position", libatk.}
proc position*(cell: TableCell; row: var gint;
                                  column: var gint): gboolean {.
    importc: "atk_table_cell_get_position", libatk.}
proc get_row_span*(cell: TableCell): gint {.
    importc: "atk_table_cell_get_row_span", libatk.}
proc row_span*(cell: TableCell): gint {.
    importc: "atk_table_cell_get_row_span", libatk.}
proc get_row_header_cells*(cell: TableCell): glib.GPtrArray {.
    importc: "atk_table_cell_get_row_header_cells", libatk.}
proc row_header_cells*(cell: TableCell): glib.GPtrArray {.
    importc: "atk_table_cell_get_row_header_cells", libatk.}
proc get_row_column_span*(cell: TableCell;
    row: var gint; column: var gint; row_span: var gint; column_span: var gint): gboolean {.
    importc: "atk_table_cell_get_row_column_span", libatk.}
proc row_column_span*(cell: TableCell;
    row: var gint; column: var gint; row_span: var gint; column_span: var gint): gboolean {.
    importc: "atk_table_cell_get_row_column_span", libatk.}
proc get_table*(cell: TableCell): Object {.
    importc: "atk_table_cell_get_table", libatk.}
proc table*(cell: TableCell): Object {.
    importc: "atk_table_cell_get_table", libatk.}

template atk_is_misc*(obj: expr): expr =
  g_type_check_instance_type(obj, misc_get_type())

template atk_misc*(obj: expr): expr =
  g_type_check_instance_cast(obj, misc_get_type(), MiscObj)

template atk_misc_class*(klass: expr): expr =
  (g_type_check_class_cast(klass, misc_get_type(), MiscClassObj))

template atk_is_misc_class*(klass: expr): expr =
  (g_type_check_class_type(klass, misc_get_type()))

template atk_misc_get_class*(obj: expr): expr =
  (g_type_instance_get_class(obj, misc_get_type(), MiscClassObj))

type
  Misc* =  ptr MiscObj
  MiscPtr* = ptr MiscObj
  MiscObj*{.final.} = object of GObjectObj

type
  MiscClass* =  ptr MiscClassObj
  MiscClassPtr* = ptr MiscClassObj
  MiscClassObj*{.final.} = object of GObjectClassObj
    threads_enter*: proc (misc: Misc) {.cdecl.}
    threads_leave*: proc (misc: Misc) {.cdecl.}
    vfuncs*: array[32, gpointer]

proc misc_get_type*(): GType {.importc: "atk_misc_get_type", libatk.}
proc threads_enter*(misc: Misc) {.
    importc: "atk_misc_threads_enter", libatk.}
proc threads_leave*(misc: Misc) {.
    importc: "atk_misc_threads_leave", libatk.}
proc misc_get_instance*(): Misc {.importc: "atk_misc_get_instance",
    libatk.}

template atk_is_value*(obj: expr): expr =
  g_type_check_instance_type(obj, value_get_type())

template atk_value*(obj: expr): expr =
  g_type_check_instance_cast(obj, value_get_type(), ValueObj)

template atk_value_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, value_get_type(), ValueIfaceObj))

type
  Value* =  ptr ValueObj
  ValuePtr* = ptr ValueObj
  ValueObj* = object
 
type
  ValueType* {.size: sizeof(cint), pure.} = enum
    VERY_WEAK, WEAK, ACCEPTABLE,
    STRONG, VERY_STRONG, VERY_LOW,
    LOW, MEDIUM, HIGH, VERY_HIGH,
    VERY_BAD, BAD, GOOD, VERY_GOOD,
    BEST, LAST_DEFINED
type
  ValueIface* =  ptr ValueIfaceObj
  ValueIfacePtr* = ptr ValueIfaceObj
  ValueIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_current_value*: proc (obj: Value; value: GValue) {.cdecl.}
    get_maximum_value*: proc (obj: Value; value: GValue) {.cdecl.}
    get_minimum_value*: proc (obj: Value; value: GValue) {.cdecl.}
    set_current_value*: proc (obj: Value; value: GValue): gboolean {.cdecl.}
    get_minimum_increment*: proc (obj: Value; value: GValue) {.cdecl.}
    get_value_and_text*: proc (obj: Value; value: var gdouble;
                               text: cstringArray) {.cdecl.}
    get_range*: proc (obj: Value): Range {.cdecl.}
    get_increment*: proc (obj: Value): gdouble {.cdecl.}
    get_sub_ranges*: proc (obj: Value): glib.GSList {.cdecl.}
    set_value*: proc (obj: Value; new_value: gdouble) {.cdecl.}

proc value_get_type*(): GType {.importc: "atk_value_get_type", libatk.}
proc get_current_value*(obj: Value; value: var gobject.GValueObj) {.
    importc: "atk_value_get_current_value", libatk.}
proc get_maximum_value*(obj: Value; value: var gobject.GValueObj) {.
    importc: "atk_value_get_maximum_value", libatk.}
proc get_minimum_value*(obj: Value; value: var gobject.GValueObj) {.
    importc: "atk_value_get_minimum_value", libatk.}
proc set_current_value*(obj: Value; value: GValue): gboolean {.
    importc: "atk_value_set_current_value", libatk.}
proc get_minimum_increment*(obj: Value; value: GValue) {.
    importc: "atk_value_get_minimum_increment", libatk.}
proc get_value_and_text*(obj: Value; value: var gdouble;
                                   text: cstringArray) {.
    importc: "atk_value_get_value_and_text", libatk.}
proc get_range*(obj: Value): Range {.
    importc: "atk_value_get_range", libatk.}
proc range*(obj: Value): Range {.
    importc: "atk_value_get_range", libatk.}
proc get_increment*(obj: Value): gdouble {.
    importc: "atk_value_get_increment", libatk.}
proc increment*(obj: Value): gdouble {.
    importc: "atk_value_get_increment", libatk.}
proc get_sub_ranges*(obj: Value): glib.GSList {.
    importc: "atk_value_get_sub_ranges", libatk.}
proc sub_ranges*(obj: Value): glib.GSList {.
    importc: "atk_value_get_sub_ranges", libatk.}
proc set_value*(obj: Value; new_value: gdouble) {.
    importc: "atk_value_set_value", libatk.}
proc `value=`*(obj: Value; new_value: gdouble) {.
    importc: "atk_value_set_value", libatk.}
proc get_name*(value_type: ValueType): cstring {.
    importc: "atk_value_type_get_name", libatk.}
proc name*(value_type: ValueType): cstring {.
    importc: "atk_value_type_get_name", libatk.}
proc get_localized_name*(value_type: ValueType): cstring {.
    importc: "atk_value_type_get_localized_name", libatk.}
proc localized_name*(value_type: ValueType): cstring {.
    importc: "atk_value_type_get_localized_name", libatk.}

template atk_is_window*(obj: expr): expr =
  g_type_check_instance_type(obj, window_get_type())

template atk_window*(obj: expr): expr =
  g_type_check_instance_cast(obj, window_get_type(), WindowObj)

template atk_window_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, window_get_type(), WindowIfaceObj))

type
  Window* =  ptr WindowObj
  WindowPtr* = ptr WindowObj
  WindowObj* = object
 
type
  WindowIface* =  ptr WindowIfaceObj
  WindowIfacePtr* = ptr WindowIfaceObj
  WindowIfaceObj*{.final.} = object of GTypeInterfaceObj

proc window_get_type*(): GType {.importc: "atk_window_get_type",
                                     libatk.}
{.deprecated: [PAttributeSet: AttributeSet, TAttributeSet: AttributeSetObj].}
{.deprecated: [PAtkAttributeSet: AttributeSet, TAtkAttributeSet: AttributeSetObj].}
{.deprecated: [AtkAttributeSet: AttributeSet, AtkAttributeSetObj: AttributeSetObj].}
{.deprecated: [PAttribute: Attribute, TAttribute: AttributeObj].}
{.deprecated: [PAtkAttribute: Attribute, TAtkAttribute: AttributeObj].}
{.deprecated: [AtkAttribute: Attribute, AtkAttributeObj: AttributeObj].}
{.deprecated: [PImplementor: Implementor, TImplementor: ImplementorObj].}
{.deprecated: [PAtkImplementor: Implementor, TAtkImplementor: ImplementorObj].}
{.deprecated: [AtkImplementor: Implementor, AtkImplementorObj: ImplementorObj].}
{.deprecated: [PPropertyValues: PropertyValues, TPropertyValues: PropertyValuesObj].}
{.deprecated: [PAtkPropertyValues: PropertyValues, TAtkPropertyValues: PropertyValuesObj].}
{.deprecated: [AtkPropertyValues: PropertyValues, AtkPropertyValuesObj: PropertyValuesObj].}
{.deprecated: [PObject: Object, TObject: ObjectObj].}
{.deprecated: [PAtkObject: Object, TAtkObject: ObjectObj].}
{.deprecated: [AtkObject: Object, AtkObjectObj: ObjectObj].}
{.deprecated: [PObjectClass: ObjectClass, TObjectClass: ObjectClassObj].}
{.deprecated: [PAtkObjectClass: ObjectClass, TAtkObjectClass: ObjectClassObj].}
{.deprecated: [AtkObjectClass: ObjectClass, AtkObjectClassObj: ObjectClassObj].}
{.deprecated: [PImplementorIface: ImplementorIface, TImplementorIface: ImplementorIfaceObj].}
{.deprecated: [PAtkImplementorIface: ImplementorIface, TAtkImplementorIface: ImplementorIfaceObj].}
{.deprecated: [AtkImplementorIface: ImplementorIface, AtkImplementorIfaceObj: ImplementorIfaceObj].}
{.deprecated: [PAction: Action, TAction: ActionObj].}
{.deprecated: [PAtkAction: Action, TAtkAction: ActionObj].}
{.deprecated: [AtkAction: Action, AtkActionObj: ActionObj].}
{.deprecated: [PActionIface: ActionIface, TActionIface: ActionIfaceObj].}
{.deprecated: [PAtkActionIface: ActionIface, TAtkActionIface: ActionIfaceObj].}
{.deprecated: [AtkActionIface: ActionIface, AtkActionIfaceObj: ActionIfaceObj].}
{.deprecated: [PKeyEventStruct: KeyEventStruct, TKeyEventStruct: KeyEventStructObj].}
{.deprecated: [PAtkKeyEventStruct: KeyEventStruct, TAtkKeyEventStruct: KeyEventStructObj].}
{.deprecated: [AtkKeyEventStruct: KeyEventStruct, AtkKeyEventStructObj: KeyEventStructObj].}
{.deprecated: [PUtil: Util, TUtil: UtilObj].}
{.deprecated: [PAtkUtil: Util, TAtkUtil: UtilObj].}
{.deprecated: [AtkUtil: Util, AtkUtilObj: UtilObj].}
{.deprecated: [PUtilClass: UtilClass, TUtilClass: UtilClassObj].}
{.deprecated: [PAtkUtilClass: UtilClass, TAtkUtilClass: UtilClassObj].}
{.deprecated: [AtkUtilClass: UtilClass, AtkUtilClassObj: UtilClassObj].}
{.deprecated: [PComponent: Component, TComponent: ComponentObj].}
{.deprecated: [PAtkComponent: Component, TAtkComponent: ComponentObj].}
{.deprecated: [AtkComponent: Component, AtkComponentObj: ComponentObj].}
{.deprecated: [PRectangle: Rectangle, TRectangle: RectangleObj].}
{.deprecated: [PAtkRectangle: Rectangle, TAtkRectangle: RectangleObj].}
{.deprecated: [AtkRectangle: Rectangle, AtkRectangleObj: RectangleObj].}
{.deprecated: [PComponentIface: ComponentIface, TComponentIface: ComponentIfaceObj].}
{.deprecated: [PAtkComponentIface: ComponentIface, TAtkComponentIface: ComponentIfaceObj].}
{.deprecated: [AtkComponentIface: ComponentIface, AtkComponentIfaceObj: ComponentIfaceObj].}
{.deprecated: [PDocument: Document, TDocument: DocumentObj].}
{.deprecated: [PAtkDocument: Document, TAtkDocument: DocumentObj].}
{.deprecated: [AtkDocument: Document, AtkDocumentObj: DocumentObj].}
{.deprecated: [PDocumentIface: DocumentIface, TDocumentIface: DocumentIfaceObj].}
{.deprecated: [PAtkDocumentIface: DocumentIface, TAtkDocumentIface: DocumentIfaceObj].}
{.deprecated: [AtkDocumentIface: DocumentIface, AtkDocumentIfaceObj: DocumentIfaceObj].}
{.deprecated: [PText: Text, TText: TextObj].}
{.deprecated: [PAtkText: Text, TAtkText: TextObj].}
{.deprecated: [AtkText: Text, AtkTextObj: TextObj].}
{.deprecated: [PTextRectangle: TextRectangle, TTextRectangle: TextRectangleObj].}
{.deprecated: [PAtkTextRectangle: TextRectangle, TAtkTextRectangle: TextRectangleObj].}
{.deprecated: [AtkTextRectangle: TextRectangle, AtkTextRectangleObj: TextRectangleObj].}
{.deprecated: [PTextRange: TextRange, TTextRange: TextRangeObj].}
{.deprecated: [PAtkTextRange: TextRange, TAtkTextRange: TextRangeObj].}
{.deprecated: [AtkTextRange: TextRange, AtkTextRangeObj: TextRangeObj].}
{.deprecated: [PTextIface: TextIface, TTextIface: TextIfaceObj].}
{.deprecated: [PAtkTextIface: TextIface, TAtkTextIface: TextIfaceObj].}
{.deprecated: [AtkTextIface: TextIface, AtkTextIfaceObj: TextIfaceObj].}
{.deprecated: [PEditableText: EditableText, TEditableText: EditableTextObj].}
{.deprecated: [PAtkEditableText: EditableText, TAtkEditableText: EditableTextObj].}
{.deprecated: [AtkEditableText: EditableText, AtkEditableTextObj: EditableTextObj].}
{.deprecated: [PEditableTextIface: EditableTextIface, TEditableTextIface: EditableTextIfaceObj].}
{.deprecated: [PAtkEditableTextIface: EditableTextIface, TAtkEditableTextIface: EditableTextIfaceObj].}
{.deprecated: [AtkEditableTextIface: EditableTextIface, AtkEditableTextIfaceObj: EditableTextIfaceObj].}
{.deprecated: [PGObjectAccessible: GObjectAccessible, TGObjectAccessible: GObjectAccessibleObj].}
{.deprecated: [PAtkGObjectAccessible: GObjectAccessible, TAtkGObjectAccessible: GObjectAccessibleObj].}
{.deprecated: [AtkGObjectAccessible: GObjectAccessible, AtkGObjectAccessibleObj: GObjectAccessibleObj].}
{.deprecated: [PGObjectAccessibleClass: GObjectAccessibleClass, TGObjectAccessibleClass: GObjectAccessibleClassObj].}
{.deprecated: [PAtkGObjectAccessibleClass: GObjectAccessibleClass, TAtkGObjectAccessibleClass: GObjectAccessibleClassObj].}
{.deprecated: [AtkGObjectAccessibleClass: GObjectAccessibleClass, AtkGObjectAccessibleClassObj: GObjectAccessibleClassObj].}
{.deprecated: [PHyperlink: Hyperlink, THyperlink: HyperlinkObj].}
{.deprecated: [PAtkHyperlink: Hyperlink, TAtkHyperlink: HyperlinkObj].}
{.deprecated: [AtkHyperlink: Hyperlink, AtkHyperlinkObj: HyperlinkObj].}
{.deprecated: [PHyperlinkClass: HyperlinkClass, THyperlinkClass: HyperlinkClassObj].}
{.deprecated: [PAtkHyperlinkClass: HyperlinkClass, TAtkHyperlinkClass: HyperlinkClassObj].}
{.deprecated: [AtkHyperlinkClass: HyperlinkClass, AtkHyperlinkClassObj: HyperlinkClassObj].}
{.deprecated: [PHyperlinkImpl: HyperlinkImpl, THyperlinkImpl: HyperlinkImplObj].}
{.deprecated: [PAtkHyperlinkImpl: HyperlinkImpl, TAtkHyperlinkImpl: HyperlinkImplObj].}
{.deprecated: [AtkHyperlinkImpl: HyperlinkImpl, AtkHyperlinkImplObj: HyperlinkImplObj].}
{.deprecated: [PHyperlinkImplIface: HyperlinkImplIface, THyperlinkImplIface: HyperlinkImplIfaceObj].}
{.deprecated: [PAtkHyperlinkImplIface: HyperlinkImplIface, TAtkHyperlinkImplIface: HyperlinkImplIfaceObj].}
{.deprecated: [AtkHyperlinkImplIface: HyperlinkImplIface, AtkHyperlinkImplIfaceObj: HyperlinkImplIfaceObj].}
{.deprecated: [PHypertext: Hypertext, THypertext: HypertextObj].}
{.deprecated: [PAtkHypertext: Hypertext, TAtkHypertext: HypertextObj].}
{.deprecated: [AtkHypertext: Hypertext, AtkHypertextObj: HypertextObj].}
{.deprecated: [PHypertextIface: HypertextIface, THypertextIface: HypertextIfaceObj].}
{.deprecated: [PAtkHypertextIface: HypertextIface, TAtkHypertextIface: HypertextIfaceObj].}
{.deprecated: [AtkHypertextIface: HypertextIface, AtkHypertextIfaceObj: HypertextIfaceObj].}
{.deprecated: [PImage: Image, TImage: ImageObj].}
{.deprecated: [PAtkImage: Image, TAtkImage: ImageObj].}
{.deprecated: [AtkImage: Image, AtkImageObj: ImageObj].}
{.deprecated: [PImageIface: ImageIface, TImageIface: ImageIfaceObj].}
{.deprecated: [PAtkImageIface: ImageIface, TAtkImageIface: ImageIfaceObj].}
{.deprecated: [AtkImageIface: ImageIface, AtkImageIfaceObj: ImageIfaceObj].}
{.deprecated: [PNoOpObject: NoOpObject, TNoOpObject: NoOpObjectObj].}
{.deprecated: [PAtkNoOpObject: NoOpObject, TAtkNoOpObject: NoOpObjectObj].}
{.deprecated: [AtkNoOpObject: NoOpObject, AtkNoOpObjectObj: NoOpObjectObj].}
{.deprecated: [PNoOpObjectClass: NoOpObjectClass, TNoOpObjectClass: NoOpObjectClassObj].}
{.deprecated: [PAtkNoOpObjectClass: NoOpObjectClass, TAtkNoOpObjectClass: NoOpObjectClassObj].}
{.deprecated: [AtkNoOpObjectClass: NoOpObjectClass, AtkNoOpObjectClassObj: NoOpObjectClassObj].}
{.deprecated: [PObjectFactory: ObjectFactory, TObjectFactory: ObjectFactoryObj].}
{.deprecated: [PAtkObjectFactory: ObjectFactory, TAtkObjectFactory: ObjectFactoryObj].}
{.deprecated: [AtkObjectFactory: ObjectFactory, AtkObjectFactoryObj: ObjectFactoryObj].}
{.deprecated: [PObjectFactoryClass: ObjectFactoryClass, TObjectFactoryClass: ObjectFactoryClassObj].}
{.deprecated: [PAtkObjectFactoryClass: ObjectFactoryClass, TAtkObjectFactoryClass: ObjectFactoryClassObj].}
{.deprecated: [AtkObjectFactoryClass: ObjectFactoryClass, AtkObjectFactoryClassObj: ObjectFactoryClassObj].}
{.deprecated: [PNoOpObjectFactory: NoOpObjectFactory, TNoOpObjectFactory: NoOpObjectFactoryObj].}
{.deprecated: [PAtkNoOpObjectFactory: NoOpObjectFactory, TAtkNoOpObjectFactory: NoOpObjectFactoryObj].}
{.deprecated: [AtkNoOpObjectFactory: NoOpObjectFactory, AtkNoOpObjectFactoryObj: NoOpObjectFactoryObj].}
{.deprecated: [PNoOpObjectFactoryClass: NoOpObjectFactoryClass, TNoOpObjectFactoryClass: NoOpObjectFactoryClassObj].}
{.deprecated: [PAtkNoOpObjectFactoryClass: NoOpObjectFactoryClass, TAtkNoOpObjectFactoryClass: NoOpObjectFactoryClassObj].}
{.deprecated: [AtkNoOpObjectFactoryClass: NoOpObjectFactoryClass, AtkNoOpObjectFactoryClassObj: NoOpObjectFactoryClassObj].}
{.deprecated: [PPlug: Plug, TPlug: PlugObj].}
{.deprecated: [PAtkPlug: Plug, TAtkPlug: PlugObj].}
{.deprecated: [AtkPlug: Plug, AtkPlugObj: PlugObj].}
{.deprecated: [PPlugClass: PlugClass, TPlugClass: PlugClassObj].}
{.deprecated: [PAtkPlugClass: PlugClass, TAtkPlugClass: PlugClassObj].}
{.deprecated: [AtkPlugClass: PlugClass, AtkPlugClassObj: PlugClassObj].}
{.deprecated: [PRange: Range, TRange: RangeObj].}
{.deprecated: [PAtkRange: Range, TAtkRange: RangeObj].}
{.deprecated: [AtkRange: Range, AtkRangeObj: RangeObj].}
{.deprecated: [PRegistry: Registry, TRegistry: RegistryObj].}
{.deprecated: [PAtkRegistry: Registry, TAtkRegistry: RegistryObj].}
{.deprecated: [AtkRegistry: Registry, AtkRegistryObj: RegistryObj].}
{.deprecated: [PRegistryClass: RegistryClass, TRegistryClass: RegistryClassObj].}
{.deprecated: [PAtkRegistryClass: RegistryClass, TAtkRegistryClass: RegistryClassObj].}
{.deprecated: [AtkRegistryClass: RegistryClass, AtkRegistryClassObj: RegistryClassObj].}
{.deprecated: [PRelation: Relation, TRelation: RelationObj].}
{.deprecated: [PAtkRelation: Relation, TAtkRelation: RelationObj].}
{.deprecated: [AtkRelation: Relation, AtkRelationObj: RelationObj].}
{.deprecated: [PRelationClass: RelationClass, TRelationClass: RelationClassObj].}
{.deprecated: [PAtkRelationClass: RelationClass, TAtkRelationClass: RelationClassObj].}
{.deprecated: [AtkRelationClass: RelationClass, AtkRelationClassObj: RelationClassObj].}
{.deprecated: [PRelationSet: RelationSet, TRelationSet: RelationSetObj].}
{.deprecated: [PAtkRelationSet: RelationSet, TAtkRelationSet: RelationSetObj].}
{.deprecated: [AtkRelationSet: RelationSet, AtkRelationSetObj: RelationSetObj].}
{.deprecated: [PRelationSetClass: RelationSetClass, TRelationSetClass: RelationSetClassObj].}
{.deprecated: [PAtkRelationSetClass: RelationSetClass, TAtkRelationSetClass: RelationSetClassObj].}
{.deprecated: [AtkRelationSetClass: RelationSetClass, AtkRelationSetClassObj: RelationSetClassObj].}
{.deprecated: [PSelection: Selection, TSelection: SelectionObj].}
{.deprecated: [PAtkSelection: Selection, TAtkSelection: SelectionObj].}
{.deprecated: [AtkSelection: Selection, AtkSelectionObj: SelectionObj].}
{.deprecated: [PSelectionIface: SelectionIface, TSelectionIface: SelectionIfaceObj].}
{.deprecated: [PAtkSelectionIface: SelectionIface, TAtkSelectionIface: SelectionIfaceObj].}
{.deprecated: [AtkSelectionIface: SelectionIface, AtkSelectionIfaceObj: SelectionIfaceObj].}
{.deprecated: [PSocket: Socket, TSocket: SocketObj].}
{.deprecated: [PAtkSocket: Socket, TAtkSocket: SocketObj].}
{.deprecated: [AtkSocket: Socket, AtkSocketObj: SocketObj].}
{.deprecated: [PSocketClass: SocketClass, TSocketClass: SocketClassObj].}
{.deprecated: [PAtkSocketClass: SocketClass, TAtkSocketClass: SocketClassObj].}
{.deprecated: [AtkSocketClass: SocketClass, AtkSocketClassObj: SocketClassObj].}
{.deprecated: [PStateSet: StateSet, TStateSet: StateSetObj].}
{.deprecated: [PAtkStateSet: StateSet, TAtkStateSet: StateSetObj].}
{.deprecated: [AtkStateSet: StateSet, AtkStateSetObj: StateSetObj].}
{.deprecated: [PStateSetClass: StateSetClass, TStateSetClass: StateSetClassObj].}
{.deprecated: [PAtkStateSetClass: StateSetClass, TAtkStateSetClass: StateSetClassObj].}
{.deprecated: [AtkStateSetClass: StateSetClass, AtkStateSetClassObj: StateSetClassObj].}
{.deprecated: [PStreamableContent: StreamableContent, TStreamableContent: StreamableContentObj].}
{.deprecated: [PAtkStreamableContent: StreamableContent, TAtkStreamableContent: StreamableContentObj].}
{.deprecated: [AtkStreamableContent: StreamableContent, AtkStreamableContentObj: StreamableContentObj].}
{.deprecated: [PStreamableContentIface: StreamableContentIface, TStreamableContentIface: StreamableContentIfaceObj].}
{.deprecated: [PAtkStreamableContentIface: StreamableContentIface, TAtkStreamableContentIface: StreamableContentIfaceObj].}
{.deprecated: [AtkStreamableContentIface: StreamableContentIface, AtkStreamableContentIfaceObj: StreamableContentIfaceObj].}
{.deprecated: [PTable: Table, TTable: TableObj].}
{.deprecated: [PAtkTable: Table, TAtkTable: TableObj].}
{.deprecated: [AtkTable: Table, AtkTableObj: TableObj].}
{.deprecated: [PTableIface: TableIface, TTableIface: TableIfaceObj].}
{.deprecated: [PAtkTableIface: TableIface, TAtkTableIface: TableIfaceObj].}
{.deprecated: [AtkTableIface: TableIface, AtkTableIfaceObj: TableIfaceObj].}
{.deprecated: [PTableCell: TableCell, TTableCell: TableCellObj].}
{.deprecated: [PAtkTableCell: TableCell, TAtkTableCell: TableCellObj].}
{.deprecated: [AtkTableCell: TableCell, AtkTableCellObj: TableCellObj].}
{.deprecated: [PTableCellIface: TableCellIface, TTableCellIface: TableCellIfaceObj].}
{.deprecated: [PAtkTableCellIface: TableCellIface, TAtkTableCellIface: TableCellIfaceObj].}
{.deprecated: [AtkTableCellIface: TableCellIface, AtkTableCellIfaceObj: TableCellIfaceObj].}
{.deprecated: [PMisc: Misc, TMisc: MiscObj].}
{.deprecated: [PAtkMisc: Misc, TAtkMisc: MiscObj].}
{.deprecated: [AtkMisc: Misc, AtkMiscObj: MiscObj].}
{.deprecated: [PMiscClass: MiscClass, TMiscClass: MiscClassObj].}
{.deprecated: [PAtkMiscClass: MiscClass, TAtkMiscClass: MiscClassObj].}
{.deprecated: [AtkMiscClass: MiscClass, AtkMiscClassObj: MiscClassObj].}
{.deprecated: [PValue: Value, TValue: ValueObj].}
{.deprecated: [PAtkValue: Value, TAtkValue: ValueObj].}
{.deprecated: [AtkValue: Value, AtkValueObj: ValueObj].}
{.deprecated: [PValueIface: ValueIface, TValueIface: ValueIfaceObj].}
{.deprecated: [PAtkValueIface: ValueIface, TAtkValueIface: ValueIfaceObj].}
{.deprecated: [AtkValueIface: ValueIface, AtkValueIfaceObj: ValueIfaceObj].}
{.deprecated: [PWindow: Window, TWindow: WindowObj].}
{.deprecated: [PAtkWindow: Window, TAtkWindow: WindowObj].}
{.deprecated: [AtkWindow: Window, AtkWindowObj: WindowObj].}
{.deprecated: [PWindowIface: WindowIface, TWindowIface: WindowIfaceObj].}
{.deprecated: [PAtkWindowIface: WindowIface, TAtkWindowIface: WindowIfaceObj].}
{.deprecated: [AtkWindowIface: WindowIface, AtkWindowIfaceObj: WindowIfaceObj].}
{.deprecated: [atk_state_type_register: state_type_register].}
{.deprecated: [atk_state_type_get_name: get_name].}
{.deprecated: [atk_state_type_for_name: state_type_for_name].}
{.deprecated: [atk_object_get_type: object_get_type].}
{.deprecated: [atk_implementor_get_type: implementor_get_type].}
{.deprecated: [atk_implementor_ref_accessible: ref_accessible].}
{.deprecated: [atk_object_get_name: get_name].}
{.deprecated: [atk_object_get_description: get_description].}
{.deprecated: [atk_object_get_parent: get_parent].}
{.deprecated: [atk_object_peek_parent: peek_parent].}
{.deprecated: [atk_object_get_n_accessible_children: get_n_accessible_children].}
{.deprecated: [atk_object_ref_accessible_child: ref_accessible_child].}
{.deprecated: [atk_object_ref_relation_set: ref_relation_set].}
{.deprecated: [atk_object_get_role: get_role].}
{.deprecated: [atk_object_get_layer: get_layer].}
{.deprecated: [atk_object_get_mdi_zorder: get_mdi_zorder].}
{.deprecated: [atk_object_get_attributes: get_attributes].}
{.deprecated: [atk_object_ref_state_set: ref_state_set].}
{.deprecated: [atk_object_get_index_in_parent: get_index_in_parent].}
{.deprecated: [atk_object_set_name: set_name].}
{.deprecated: [atk_object_set_description: set_description].}
{.deprecated: [atk_object_set_parent: set_parent].}
{.deprecated: [atk_object_set_role: set_role].}
{.deprecated: [atk_object_connect_property_change_handler: connect_property_change_handler].}
{.deprecated: [atk_object_remove_property_change_handler: remove_property_change_handler].}
{.deprecated: [atk_object_notify_state_change: notify_state_change].}
{.deprecated: [atk_object_initialize: initialize].}
{.deprecated: [atk_role_get_name: get_name].}
{.deprecated: [atk_role_for_name: role_for_name].}
{.deprecated: [atk_object_add_relationship: add_relationship].}
{.deprecated: [atk_object_remove_relationship: remove_relationship].}
{.deprecated: [atk_role_get_localized_name: get_localized_name].}
{.deprecated: [atk_role_register: role_register].}
{.deprecated: [atk_object_get_object_locale: get_object_locale].}
{.deprecated: [atk_action_get_type: action_get_type].}
{.deprecated: [atk_action_do_action: do_action].}
{.deprecated: [atk_action_get_n_actions: get_n_actions].}
{.deprecated: [atk_action_get_description: get_description].}
{.deprecated: [atk_action_get_name: get_name].}
{.deprecated: [atk_action_get_keybinding: get_keybinding].}
{.deprecated: [atk_action_set_description: set_description].}
{.deprecated: [atk_action_get_localized_name: get_localized_name].}
{.deprecated: [atk_util_get_type: util_get_type].}
{.deprecated: [atk_add_focus_tracker: add_focus_tracker].}
{.deprecated: [atk_remove_focus_tracker: remove_focus_tracker].}
{.deprecated: [atk_focus_tracker_init: focus_tracker_init].}
{.deprecated: [atk_focus_tracker_notify: focus_tracker_notify].}
{.deprecated: [atk_add_global_event_listener: add_global_event_listener].}
{.deprecated: [atk_remove_global_event_listener: remove_global_event_listener].}
{.deprecated: [atk_add_key_event_listener: add_key_event_listener].}
{.deprecated: [atk_remove_key_event_listener: remove_key_event_listener].}
{.deprecated: [atk_get_root: get_root].}
{.deprecated: [atk_get_focus_object: get_focus_object].}
{.deprecated: [atk_get_toolkit_name: get_toolkit_name].}
{.deprecated: [atk_get_toolkit_version: get_toolkit_version].}
{.deprecated: [atk_get_version: get_version].}
{.deprecated: [atk_rectangle_get_type: rectangle_get_type].}
{.deprecated: [atk_component_get_type: component_get_type].}
{.deprecated: [atk_component_add_focus_handler: add_focus_handler].}
{.deprecated: [atk_component_contains: contains].}
{.deprecated: [atk_component_ref_accessible_at_point: ref_accessible_at_point].}
{.deprecated: [atk_component_get_extents: get_extents].}
{.deprecated: [atk_component_get_position: get_position].}
{.deprecated: [atk_component_get_size: get_size].}
{.deprecated: [atk_component_get_layer: get_layer].}
{.deprecated: [atk_component_get_mdi_zorder: get_mdi_zorder].}
{.deprecated: [atk_component_grab_focus: grab_focus].}
{.deprecated: [atk_component_remove_focus_handler: remove_focus_handler].}
{.deprecated: [atk_component_set_extents: set_extents].}
{.deprecated: [atk_component_set_position: set_position].}
{.deprecated: [atk_component_set_size: set_size].}
{.deprecated: [atk_component_get_alpha: get_alpha].}
{.deprecated: [atk_document_get_type: document_get_type].}
{.deprecated: [atk_document_get_document_type: get_document_type].}
{.deprecated: [atk_document_get_document: get_document].}
{.deprecated: [atk_document_get_locale: get_locale].}
{.deprecated: [atk_document_get_attributes: get_attributes].}
{.deprecated: [atk_document_get_attribute_value: get_attribute_value].}
{.deprecated: [atk_document_set_attribute_value: set_attribute_value].}
{.deprecated: [atk_document_get_current_page_number: get_current_page_number].}
{.deprecated: [atk_document_get_page_count: get_page_count].}
{.deprecated: [atk_text_attribute_register: text_attribute_register].}
{.deprecated: [atk_text_range_get_type: text_range_get_type].}
{.deprecated: [atk_text_get_type: text_get_type].}
{.deprecated: [atk_text_get_text: get_text].}
{.deprecated: [atk_text_get_character_at_offset: get_character_at_offset].}
{.deprecated: [atk_text_get_text_after_offset: get_text_after_offset].}
{.deprecated: [atk_text_get_text_at_offset: get_text_at_offset].}
{.deprecated: [atk_text_get_text_before_offset: get_text_before_offset].}
{.deprecated: [atk_text_get_string_at_offset: get_string_at_offset].}
{.deprecated: [atk_text_get_caret_offset: get_caret_offset].}
{.deprecated: [atk_text_get_character_extents: get_character_extents].}
{.deprecated: [atk_text_get_run_attributes: get_run_attributes].}
{.deprecated: [atk_text_get_default_attributes: get_default_attributes].}
{.deprecated: [atk_text_get_character_count: get_character_count].}
{.deprecated: [atk_text_get_offset_at_point: get_offset_at_point].}
{.deprecated: [atk_text_get_n_selections: get_n_selections].}
{.deprecated: [atk_text_get_selection: get_selection].}
{.deprecated: [atk_text_add_selection: add_selection].}
{.deprecated: [atk_text_remove_selection: remove_selection].}
{.deprecated: [atk_text_set_selection: set_selection].}
{.deprecated: [atk_text_set_caret_offset: set_caret_offset].}
{.deprecated: [atk_text_get_range_extents: get_range_extents].}
{.deprecated: [atk_text_get_bounded_ranges: get_bounded_ranges].}
{.deprecated: [atk_text_free_ranges: text_free_ranges].}
{.deprecated: [atk_attribute_set_free: free].}
{.deprecated: [atk_text_attribute_get_name: get_name].}
{.deprecated: [atk_text_attribute_for_name: text_attribute_for_name].}
{.deprecated: [atk_text_attribute_get_value: get_value].}
{.deprecated: [atk_editable_text_get_type: editable_text_get_type].}
{.deprecated: [atk_editable_text_set_run_attributes: set_run_attributes].}
{.deprecated: [atk_editable_text_set_text_contents: set_text_contents].}
{.deprecated: [atk_editable_text_insert_text: insert_text].}
{.deprecated: [atk_editable_text_copy_text: copy_text].}
{.deprecated: [atk_editable_text_cut_text: cut_text].}
{.deprecated: [atk_editable_text_delete_text: delete_text].}
{.deprecated: [atk_editable_text_paste_text: paste_text].}
{.deprecated: [atk_hyperlink_state_flags_get_type: hyperlink_state_flags_get_type].}
{.deprecated: [atk_role_get_type: role_get_type].}
{.deprecated: [atk_layer_get_type: layer_get_type].}
{.deprecated: [atk_relation_type_get_type: relation_type_get_type].}
{.deprecated: [atk_state_type_get_type: state_type_get_type].}
{.deprecated: [atk_text_attribute_get_type: text_attribute_get_type].}
{.deprecated: [atk_text_boundary_get_type: text_boundary_get_type].}
{.deprecated: [atk_text_granularity_get_type: text_granularity_get_type].}
{.deprecated: [atk_text_clip_type_get_type: text_clip_type_get_type].}
{.deprecated: [atk_key_event_type_get_type: key_event_type_get_type].}
{.deprecated: [atk_coord_type_get_type: coord_type_get_type].}
{.deprecated: [atk_value_type_get_type: value_type_get_type].}
{.deprecated: [atk_gobject_accessible_get_type: gobject_accessible_get_type].}
{.deprecated: [atk_gobject_accessible_for_object: gobject_accessible_for_object].}
{.deprecated: [atk_gobject_accessible_get_object: gobject_accessible_get_object].}
{.deprecated: [atk_hyperlink_get_type: hyperlink_get_type].}
{.deprecated: [atk_hyperlink_get_uri: get_uri].}
{.deprecated: [atk_hyperlink_get_object: get_object].}
{.deprecated: [atk_hyperlink_get_end_index: get_end_index].}
{.deprecated: [atk_hyperlink_get_start_index: get_start_index].}
{.deprecated: [atk_hyperlink_is_valid: is_valid].}
{.deprecated: [atk_hyperlink_is_inline: is_inline].}
{.deprecated: [atk_hyperlink_get_n_anchors: get_n_anchors].}
{.deprecated: [atk_hyperlink_is_selected_link: is_selected_link].}
{.deprecated: [atk_hyperlink_impl_get_type: hyperlink_impl_get_type].}
{.deprecated: [atk_hyperlink_impl_get_hyperlink: get_hyperlink].}
{.deprecated: [atk_hypertext_get_type: hypertext_get_type].}
{.deprecated: [atk_hypertext_get_link: get_link].}
{.deprecated: [atk_hypertext_get_n_links: get_n_links].}
{.deprecated: [atk_hypertext_get_link_index: get_link_index].}
{.deprecated: [atk_image_get_type: image_get_type].}
{.deprecated: [atk_image_get_image_description: get_image_description].}
{.deprecated: [atk_image_get_image_size: get_image_size].}
{.deprecated: [atk_image_set_image_description: set_image_description].}
{.deprecated: [atk_image_get_image_position: get_image_position].}
{.deprecated: [atk_image_get_image_locale: get_image_locale].}
{.deprecated: [atk_no_op_object_get_type: no_op_object_get_type].}
{.deprecated: [atk_no_op_object_new: no_op_object_new].}
{.deprecated: [atk_object_factory_get_type: object_factory_get_type].}
{.deprecated: [atk_object_factory_create_accessible: create_accessible].}
{.deprecated: [atk_object_factory_invalidate: invalidate].}
{.deprecated: [atk_object_factory_get_accessible_type: get_accessible_type].}
{.deprecated: [atk_no_op_object_factory_get_type: no_op_object_factory_get_type].}
{.deprecated: [atk_no_op_object_factory_new: no_op_object_factory_new].}
{.deprecated: [atk_plug_get_type: plug_get_type].}
{.deprecated: [atk_plug_new: plug_new].}
{.deprecated: [atk_plug_get_id: get_id].}
{.deprecated: [atk_range_get_type: range_get_type].}
{.deprecated: [atk_range_copy: copy].}
{.deprecated: [atk_range_free: free].}
{.deprecated: [atk_range_get_lower_limit: get_lower_limit].}
{.deprecated: [atk_range_get_upper_limit: get_upper_limit].}
{.deprecated: [atk_range_get_description: get_description].}
{.deprecated: [atk_range_new: range_new].}
{.deprecated: [atk_registry_get_type: registry_get_type].}
{.deprecated: [atk_registry_set_factory_type: set_factory_type].}
{.deprecated: [atk_registry_get_factory_type: get_factory_type].}
{.deprecated: [atk_registry_get_factory: get_factory].}
{.deprecated: [atk_get_default_registry: get_default_registry].}
{.deprecated: [atk_relation_get_type: relation_get_type].}
{.deprecated: [atk_relation_type_register: relation_type_register].}
{.deprecated: [atk_relation_type_get_name: get_name].}
{.deprecated: [atk_relation_type_for_name: relation_type_for_name].}
{.deprecated: [atk_relation_new: relation_new].}
{.deprecated: [atk_relation_get_relation_type: get_relation_type].}
{.deprecated: [atk_relation_get_target: get_target].}
{.deprecated: [atk_relation_add_target: add_target].}
{.deprecated: [atk_relation_remove_target: remove_target].}
{.deprecated: [atk_relation_set_get_type: relation_set_get_type].}
{.deprecated: [atk_relation_set_new: relation_set_new].}
{.deprecated: [atk_relation_set_contains: contains].}
{.deprecated: [atk_relation_set_contains_target: contains_target].}
{.deprecated: [atk_relation_set_remove: remove].}
{.deprecated: [atk_relation_set_add: add].}
{.deprecated: [atk_relation_set_get_n_relations: get_n_relations].}
{.deprecated: [atk_relation_set_get_relation: get_relation].}
{.deprecated: [atk_relation_set_get_relation_by_type: get_relation_by_type].}
{.deprecated: [atk_relation_set_add_relation_by_type: add_relation_by_type].}
{.deprecated: [atk_selection_get_type: selection_get_type].}
{.deprecated: [atk_selection_add_selection: add_selection].}
{.deprecated: [atk_selection_clear_selection: clear_selection].}
{.deprecated: [atk_selection_ref_selection: ref_selection].}
{.deprecated: [atk_selection_get_selection_count: get_selection_count].}
{.deprecated: [atk_selection_is_child_selected: is_child_selected].}
{.deprecated: [atk_selection_remove_selection: remove_selection].}
{.deprecated: [atk_selection_select_all_selection: select_all_selection].}
{.deprecated: [atk_socket_get_type: socket_get_type].}
{.deprecated: [atk_socket_new: socket_new].}
{.deprecated: [atk_socket_embed: embed].}
{.deprecated: [atk_socket_is_occupied: is_occupied].}
{.deprecated: [atk_state_set_get_type: state_set_get_type].}
{.deprecated: [atk_state_set_new: state_set_new].}
{.deprecated: [atk_state_set_is_empty: is_empty].}
{.deprecated: [atk_state_set_add_state: add_state].}
{.deprecated: [atk_state_set_add_states: add_states].}
{.deprecated: [atk_state_set_clear_states: clear_states].}
{.deprecated: [atk_state_set_contains_state: contains_state].}
{.deprecated: [atk_state_set_contains_states: contains_states].}
{.deprecated: [atk_state_set_remove_state: remove_state].}
{.deprecated: [atk_state_set_and_sets: and_sets].}
{.deprecated: [atk_state_set_or_sets: or_sets].}
{.deprecated: [atk_state_set_xor_sets: xor_sets].}
{.deprecated: [atk_streamable_content_get_type: streamable_content_get_type].}
{.deprecated: [atk_streamable_content_get_n_mime_types: get_n_mime_types].}
{.deprecated: [atk_streamable_content_get_mime_type: get_mime_type].}
{.deprecated: [atk_streamable_content_get_stream: get_stream].}
{.deprecated: [atk_streamable_content_get_uri: get_uri].}
{.deprecated: [atk_table_get_type: table_get_type].}
{.deprecated: [atk_table_ref_at: ref_at].}
{.deprecated: [atk_table_get_index_at: get_index_at].}
{.deprecated: [atk_table_get_column_at_index: get_column_at_index].}
{.deprecated: [atk_table_get_row_at_index: get_row_at_index].}
{.deprecated: [atk_table_get_n_columns: get_n_columns].}
{.deprecated: [atk_table_get_n_rows: get_n_rows].}
{.deprecated: [atk_table_get_column_extent_at: get_column_extent_at].}
{.deprecated: [atk_table_get_row_extent_at: get_row_extent_at].}
{.deprecated: [atk_table_get_caption: get_caption].}
{.deprecated: [atk_table_get_column_description: get_column_description].}
{.deprecated: [atk_table_get_column_header: get_column_header].}
{.deprecated: [atk_table_get_row_description: get_row_description].}
{.deprecated: [atk_table_get_row_header: get_row_header].}
{.deprecated: [atk_table_get_summary: get_summary].}
{.deprecated: [atk_table_set_caption: set_caption].}
{.deprecated: [atk_table_set_column_description: set_column_description].}
{.deprecated: [atk_table_set_column_header: set_column_header].}
{.deprecated: [atk_table_set_row_description: set_row_description].}
{.deprecated: [atk_table_set_row_header: set_row_header].}
{.deprecated: [atk_table_set_summary: set_summary].}
{.deprecated: [atk_table_get_selected_columns: get_selected_columns].}
{.deprecated: [atk_table_get_selected_rows: get_selected_rows].}
{.deprecated: [atk_table_is_column_selected: is_column_selected].}
{.deprecated: [atk_table_is_row_selected: is_row_selected].}
{.deprecated: [atk_table_is_selected: is_selected].}
{.deprecated: [atk_table_add_row_selection: add_row_selection].}
{.deprecated: [atk_table_remove_row_selection: remove_row_selection].}
{.deprecated: [atk_table_add_column_selection: add_column_selection].}
{.deprecated: [atk_table_remove_column_selection: remove_column_selection].}
{.deprecated: [atk_table_cell_get_type: table_cell_get_type].}
{.deprecated: [atk_table_cell_get_column_span: get_column_span].}
{.deprecated: [atk_table_cell_get_column_header_cells: get_column_header_cells].}
{.deprecated: [atk_table_cell_get_position: get_position].}
{.deprecated: [atk_table_cell_get_row_span: get_row_span].}
{.deprecated: [atk_table_cell_get_row_header_cells: get_row_header_cells].}
{.deprecated: [atk_table_cell_get_row_column_span: get_row_column_span].}
{.deprecated: [atk_table_cell_get_table: get_table].}
{.deprecated: [atk_misc_get_type: misc_get_type].}
{.deprecated: [atk_misc_threads_enter: threads_enter].}
{.deprecated: [atk_misc_threads_leave: threads_leave].}
{.deprecated: [atk_misc_get_instance: misc_get_instance].}
{.deprecated: [atk_value_get_type: value_get_type].}
{.deprecated: [atk_value_get_current_value: get_current_value].}
{.deprecated: [atk_value_get_maximum_value: get_maximum_value].}
{.deprecated: [atk_value_get_minimum_value: get_minimum_value].}
{.deprecated: [atk_value_set_current_value: set_current_value].}
{.deprecated: [atk_value_get_minimum_increment: get_minimum_increment].}
{.deprecated: [atk_value_get_value_and_text: get_value_and_text].}
{.deprecated: [atk_value_get_range: get_range].}
{.deprecated: [atk_value_get_increment: get_increment].}
{.deprecated: [atk_value_get_sub_ranges: get_sub_ranges].}
{.deprecated: [atk_value_set_value: set_value].}
{.deprecated: [atk_value_type_get_name: get_name].}
{.deprecated: [atk_value_type_get_localized_name: get_localized_name].}
{.deprecated: [atk_window_get_type: window_get_type].}
