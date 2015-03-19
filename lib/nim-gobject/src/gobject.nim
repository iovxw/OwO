{.deadCodeElim: on.}

# import glib

# we may carefully check imported symbols
from glib import gint8, guint8, guint16, guint32, gint64, guint64, gint, guint, glong, gulong, gchar, guchar, gboolean,
  gfloat, gdouble, gpointer, gconstpointer, gunichar, gsize, GList, GSList, GQuark, GData, GSource, GVariant,
  GVariantType, GCompareFunc, GDuplicateFunc, GCompareDataFunc, GDestroyNotify, guintwith32bitatleast, g_clear_pointer

# Note: Not all gobject C macros are available in Nim yet.
# Some are converted by c2nim to templates, some manually to procs.
# Most of these should be not necessary for Nim programmers.
# We may have to add more and to test and fix some, or remove unnecessary ones completely...

when defined(windows): 
  const LIB_GOBJ* = "libgobject-2.0-0.dll"
elif defined(macosx):
  const LIB_GOBJ* = "libgobject-2.0.dylib"
else: 
  const LIB_GOBJ* = "libgobject-2.0.so(|.0)"

{.pragma: libgobj, cdecl, dynlib: LIB_GOBJ.}

const 
  G_TYPE_FUNDAMENTAL_SHIFT* = 2
# when GLIB_SIZEOF_SIZE_T != GLIB_SIZEOF_LONG or not defined(cplusplus): 
when sizeof(csize) != sizeof(clong) or not defined(cpp): 
  type 
    GType* = csize
else: 
  type 
    GType* = gulong
template g_type_make_fundamental*(x: expr): expr = 
  (GType(x shl G_TYPE_FUNDAMENTAL_SHIFT))
const 
  G_TYPE_FUNDAMENTAL_MAX* = (255 shl G_TYPE_FUNDAMENTAL_SHIFT)
const 
  G_TYPE_INVALID* = g_type_make_fundamental(0)
const 
  G_TYPE_NONE* = g_type_make_fundamental(1)
const 
  G_TYPE_INTERF* = g_type_make_fundamental(2)
const 
  G_TYPE_CHAR* = g_type_make_fundamental(3)
const 
  G_TYPE_UCHAR* = g_type_make_fundamental(4)
const 
  G_TYPE_BOOLEAN* = g_type_make_fundamental(5)
const 
  G_TYPE_INT* = g_type_make_fundamental(6)
const 
  G_TYPE_UINT* = g_type_make_fundamental(7)
const 
  G_TYPE_LONG* = g_type_make_fundamental(8)
const 
  G_TYPE_ULONG* = g_type_make_fundamental(9)
const 
  G_TYPE_INT64* = g_type_make_fundamental(10)
const 
  G_TYPE_UINT64* = g_type_make_fundamental(11)
const 
  G_TYPE_ENUM* = g_type_make_fundamental(12)
const 
  G_TYPE_FLAG* = g_type_make_fundamental(13)
const 
  G_TYPE_FLOAT* = g_type_make_fundamental(14)
const 
  G_TYPE_DOUBLE* = g_type_make_fundamental(15)
const 
  G_TYPE_STRING* = g_type_make_fundamental(16)
const 
  G_TYPE_POINTER* = g_type_make_fundamental(17)
const 
  G_TYPE_BOXED* = g_type_make_fundamental(18)
const 
  G_TYPE_PARAM* = g_type_make_fundamental(19)
const 
  G_TYPE_OBJECT* = g_type_make_fundamental(20)
const 
  G_TYPE_VARIANT* = g_type_make_fundamental(21)
const 
  G_TYPE_RESERVED_GLIB_FIRST* = 22
const 
  G_TYPE_RESERVED_GLIB_LAST* = 31
const 
  G_TYPE_RESERVED_BSE_FIRST* = 32
const 
  G_TYPE_RESERVED_BSE_LAST* = 48
const 
  G_TYPE_RESERVED_USER_FIRST* = 49
template g_type_is_fundamental*(`type`: expr): expr = 
  (`type` <= G_TYPE_FUNDAMENTAL_MAX)

template g_type_is_derived*(`type`: expr): expr = 
  (`type` > G_TYPE_FUNDAMENTAL_MAX)

template g_type_is_interface*(`type`: expr): expr = 
  (fundamental(`type`) == G_TYPE_INTERF)

template g_type_is_classed*(`type`: expr): expr = 
  (test_flags(`type`, GTypeFundamentalFlags.CLASSED))

template g_type_is_instantiatable*(`type`: expr): expr = 
  (test_flags(`type`, GTypeFundamentalFlags.INSTANTIATABLE))

template g_type_is_derivable*(`type`: expr): expr = 
  (test_flags(`type`, GTypeFundamentalFlags.DERIVABLE))

template g_type_is_deep_derivable*(`type`: expr): expr = 
  (test_flags(`type`, GTypeFundamentalFlags.DEEP_DERIVABLE))

template g_type_is_abstract*(`type`: expr): expr = 
  (test_flags(`type`, GTypeFlags.ABSTRACT))

template g_type_is_value_abstract*(`type`: expr): expr = 
  (test_flags(`type`, GTypeFlags.VALUE_ABSTRACT))

template g_type_is_value_type*(`type`: expr): expr = 
  (check_is_value_type(`type`))

template g_type_has_value_table*(`type`: expr): expr = 
  (value_table_peek(`type`) != nil)
type
  GTypeCValue* = ptr GTypeCValueObj
  GTypeCValuePtr* = ptr GTypeCValueObj
  GTypeCValueObj* = object  {.union.}
  
  GTypePlugin* =  ptr GTypePluginObj
  GTypePluginPtr* = ptr GTypePluginObj
  GTypePluginObj* = object 
  
type 
  GTypeClass* =  ptr GTypeClassObj
  GTypeClassPtr* = ptr GTypeClassObj
  GTypeClassObj{.inheritable, pure.} = object 
    g_type*: GType

type 
  GTypeInstance* =  ptr GTypeInstanceObj
  GTypeInstancePtr* = ptr GTypeInstanceObj
  GTypeInstanceObj{.inheritable, pure.} = object 
    g_class*: GTypeClass

type 
  GTypeInterface* =  ptr GTypeInterfaceObj
  GTypeInterfacePtr* = ptr GTypeInterfaceObj
  GTypeInterfaceObj*{.inheritable, pure.} = object 
    g_type*: GType
    g_instance_type*: GType

type 
  GTypeQuery* =  ptr GTypeQueryObj
  GTypeQueryPtr* = ptr GTypeQueryObj
  GTypeQueryObj* = object 
    `type`*: GType
    type_name*: cstring
    class_size*: guint
    instance_size*: guint

template g_type_check_instance*(instance: expr): expr = 
  (g_type_chi(cast[GTypeInstance](instance)))

template g_type_check_instance_cast*(instance, g_type, c_type: expr): expr = 
  (g_type_cic(instance, g_type, c_type))

template g_type_check_instance_type*(instance, g_type: expr): expr = 
  (g_type_cit(instance, g_type))

template g_type_check_instance_fundamental_type*(instance, g_type: expr): expr = 
  (g_type_cift(instance, g_type))

template g_type_instance_get_class*(instance, g_type, c_type: expr): expr = 
  (g_type_igc(instance, g_type, c_type))

template g_type_instance_get_interface*(instance, g_type, c_type: expr): expr = 
  (g_type_igi(instance, g_type, c_type))

template g_type_check_class_cast*(g_class, g_type, c_type: expr): expr = 
  (g_type_ccc(g_class, g_type, c_type))

template g_type_check_class_type*(g_class, g_type: expr): expr = 
  (g_type_cct(g_class, g_type))

template g_type_check_value*(value: expr): expr = 
  (g_type_chv(value))

template g_type_check_value_type*(value, g_type: expr): expr = 
  (g_type_cvh(value, g_type))

template g_type_from_instance*(instance: expr): expr = 
  (g_type_from_class((cast[GTypeInstance](instance)).g_class))

template g_type_from_class*(g_class: expr): expr = 
  ((cast[GTypeClass](g_class)).g_type)

template g_type_from_interface*(g_iface: expr): expr = 
  ((cast[GTypeInterface](g_iface)).g_type)

template g_type_instance_get_private*(instance, g_type, c_type: expr): expr = 
  (cast[ptr c_type](g_type_instance_get_private(
      cast[GTypeInstance](instance), g_type)))

template g_type_class_get_private*(klass, g_type, c_type: expr): expr = 
  (cast[ptr c_type](g_type_class_get_private(cast[GTypeClass](klass), 
      (g_type))))

type 
  GTypeDebugFlags* {.size: sizeof(cint), pure.} = enum 
    NONE = 0, OBJECTS = 1 shl 0, 
    SIGNALS = 1 shl 1, MASK = 0x00000003
proc g_type_init*() {.importc: "g_type_init", libgobj.}
proc g_type_init_with_debug_flags*(debug_flags: GTypeDebugFlags) {.
    importc: "g_type_init_with_debug_flags", libgobj.}
proc name*(`type`: GType): cstring {.importc: "g_type_name", 
    libgobj.}
proc qname*(`type`: GType): GQuark {.importc: "g_type_qname", libgobj.}
proc g_type_from_name*(name: cstring): GType {.importc: "g_type_from_name", 
    libgobj.}
proc parent*(`type`: GType): GType {.importc: "g_type_parent", 
    libgobj.}
proc depth*(`type`: GType): guint {.importc: "g_type_depth", libgobj.}
proc next_base*(leaf_type: GType; root_type: GType): GType {.
    importc: "g_type_next_base", libgobj.}
proc is_a*(`type`: GType; is_a_type: GType): gboolean {.
    importc: "g_type_is_a", libgobj.}
proc class_ref*(`type`: GType): gpointer {.importc: "g_type_class_ref", 
    libgobj.}
proc class_peek*(`type`: GType): gpointer {.importc: "g_type_class_peek", 
    libgobj.}
proc class_peek_static*(`type`: GType): gpointer {.
    importc: "g_type_class_peek_static", libgobj.}
proc g_type_class_unref*(g_class: gpointer) {.importc: "g_type_class_unref", 
    libgobj.}
proc g_type_class_peek_parent*(g_class: gpointer): gpointer {.
    importc: "g_type_class_peek_parent", libgobj.}
proc g_type_interface_peek*(instance_class: gpointer; iface_type: GType): gpointer {.
    importc: "g_type_interface_peek", libgobj.}
proc g_type_interface_peek_parent*(g_iface: gpointer): gpointer {.
    importc: "g_type_interface_peek_parent", libgobj.}
proc default_interface_ref*(g_type: GType): gpointer {.
    importc: "g_type_default_interface_ref", libgobj.}
proc default_interface_peek*(g_type: GType): gpointer {.
    importc: "g_type_default_interface_peek", libgobj.}
proc g_type_default_interface_unref*(g_iface: gpointer) {.
    importc: "g_type_default_interface_unref", libgobj.}
proc children*(`type`: GType; n_children: ptr guint): ptr GType {.
    importc: "g_type_children", libgobj.}
proc interfaces*(`type`: GType; n_interfaces: ptr guint): ptr GType {.
    importc: "g_type_interfaces", libgobj.}
proc set_qdata*(`type`: GType; quark: GQuark; data: gpointer) {.
    importc: "g_type_set_qdata", libgobj.}
proc `qdata=`*(`type`: GType; quark: GQuark; data: gpointer) {.
    importc: "g_type_set_qdata", libgobj.}
proc get_qdata*(`type`: GType; quark: GQuark): gpointer {.
    importc: "g_type_get_qdata", libgobj.}
proc qdata*(`type`: GType; quark: GQuark): gpointer {.
    importc: "g_type_get_qdata", libgobj.}
proc query*(`type`: GType; query: GTypeQuery) {.
    importc: "g_type_query", libgobj.}
type 
  GBaseInitFunc* = proc (g_class: gpointer) {.cdecl.}
type 
  GBaseFinalizeFunc* = proc (g_class: gpointer) {.cdecl.}
type 
  GClassInitFunc* = proc (g_class: gpointer; class_data: gpointer) {.cdecl.}
type 
  GClassFinalizeFunc* = proc (g_class: gpointer; class_data: gpointer) {.cdecl.}
type 
  GInstanceInitFunc* = proc (instance: GTypeInstance; g_class: gpointer) {.cdecl.}
type 
  GInterfaceInitFunc* = proc (g_iface: gpointer; iface_data: gpointer) {.cdecl.}
type 
  GInterfaceFinalizeFunc* = proc (g_iface: gpointer; iface_data: gpointer) {.cdecl.}
type 
  GTypeClassCacheFunc* = proc (cache_data: gpointer; g_class: GTypeClass): gboolean {.cdecl.}
type 
  GTypeInterfaceCheckFunc* = proc (check_data: gpointer; g_iface: gpointer) {.cdecl.}
type 
  GTypeFundamentalFlags* {.size: sizeof(cint), pure.} = enum 
    CLASSED = 1 shl 0, INSTANTIATABLE = 1 shl 1, 
    DERIVABLE = 1 shl 2, DEEP_DERIVABLE = 1 shl 3
type 
  GTypeFlags* {.size: sizeof(cint), pure.} = enum 
    ABSTRACT = 1 shl 4, VALUE_ABSTRACT = 1 shl 5

type 
  GTypeFundamentalInfo* =  ptr GTypeFundamentalInfoObj
  GTypeFundamentalInfoPtr* = ptr GTypeFundamentalInfoObj
  GTypeFundamentalInfoObj* = object 
    type_flags*: GTypeFundamentalFlags

type 
  GInterfaceInfo* =  ptr GInterfaceInfoObj
  GInterfaceInfoPtr* = ptr GInterfaceInfoObj
  GInterfaceInfoObj* = object 
    interface_init*: GInterfaceInitFunc
    interface_finalize*: GInterfaceFinalizeFunc
    interface_data*: gpointer

type 
  INNER_C_UNION_9535112928135225662* = object  {.union.}
    v_int*: gint
    v_uint*: guint
    v_long*: glong
    v_ulong*: gulong
    v_int64*: gint64
    v_uint64*: guint64
    v_float*: gfloat
    v_double*: gdouble
    v_pointer*: gpointer

type 
  GValue* =  ptr GValueObj
  GValuePtr* = ptr GValueObj
  GValueObj* = object 
    g_type*: GType
    data*: array[2, INNER_C_UNION_9535112928135225662]
type 
  GTypeValueTable* =  ptr GTypeValueTableObj
  GTypeValueTablePtr* = ptr GTypeValueTableObj
  GTypeValueTableObj* = object 
    value_init*: proc (value: GValue) {.cdecl.}
    value_free*: proc (value: GValue) {.cdecl.}
    value_copy*: proc (src_value: GValue; dest_value: GValue) {.cdecl.}
    value_peek_pointer*: proc (value: GValue): gpointer {.cdecl.}
    collect_format*: cstring
    collect_value*: proc (value: GValue; n_collect_values: guint; 
                          collect_values: GTypeCValue; 
                          collect_flags: guint): cstring {.cdecl.}
    lcopy_format*: cstring
    lcopy_value*: proc (value: GValue; n_collect_values: guint; 
                        collect_values: GTypeCValue; collect_flags: guint): cstring {.cdecl.}
type 
  GTypeInfo* =  ptr GTypeInfoObj
  GTypeInfoPtr* = ptr GTypeInfoObj
  GTypeInfoObj* = object 
    class_size*: guint16
    base_init*: GBaseInitFunc
    base_finalize*: GBaseFinalizeFunc
    class_init*: GClassInitFunc
    class_finalize*: GClassFinalizeFunc
    class_data*: gconstpointer
    instance_size*: guint16
    n_preallocs*: guint16
    instance_init*: GInstanceInitFunc
    value_table*: GTypeValueTable

proc register_static*(parent_type: GType; type_name: cstring; 
                             info: GTypeInfo; flags: GTypeFlags): GType {.
    importc: "g_type_register_static", libgobj.}
proc register_static_simple*(parent_type: GType; type_name: cstring; 
                                    class_size: guint; 
                                    class_init: GClassInitFunc; 
                                    instance_size: guint; 
                                    instance_init: GInstanceInitFunc; 
                                    flags: GTypeFlags): GType {.
    importc: "g_type_register_static_simple", libgobj.}
proc register_dynamic*(parent_type: GType; type_name: cstring; 
                              plugin: GTypePlugin; flags: GTypeFlags): GType {.
    importc: "g_type_register_dynamic", libgobj.}
proc register_fundamental*(type_id: GType; type_name: cstring; 
                                  info: GTypeInfo; 
                                  finfo: GTypeFundamentalInfo; 
                                  flags: GTypeFlags): GType {.
    importc: "g_type_register_fundamental", libgobj.}
proc add_interface_static*(instance_type: GType; interface_type: GType; 
                                  info: GInterfaceInfo) {.
    importc: "g_type_add_interface_static", libgobj.}
proc add_interface_dynamic*(instance_type: GType; 
                                   interface_type: GType; 
                                   plugin: GTypePlugin) {.
    importc: "g_type_add_interface_dynamic", libgobj.}
proc interface_add_prerequisite*(interface_type: GType; 
    prerequisite_type: GType) {.importc: "g_type_interface_add_prerequisite", 
                                libgobj.}
proc interface_prerequisites*(interface_type: GType; 
                                     n_prerequisites: ptr guint): ptr GType {.
    importc: "g_type_interface_prerequisites", libgobj.}
proc g_type_class_add_private*(g_class: gpointer; private_size: gsize) {.
    importc: "g_type_class_add_private", libgobj.}
proc add_instance_private*(class_type: GType; private_size: gsize): gint {.
    importc: "g_type_add_instance_private", libgobj.}
proc get_private*(instance: GTypeInstance; 
                                  private_type: GType): gpointer {.
    importc: "g_type_instance_get_private", libgobj.}
proc private*(instance: GTypeInstance; 
                                  private_type: GType): gpointer {.
    importc: "g_type_instance_get_private", libgobj.}
proc g_type_class_adjust_private_offset*(g_class: gpointer; 
    private_size_or_offset: ptr gint) {.
    importc: "g_type_class_adjust_private_offset", libgobj.}
proc add_class_private*(class_type: GType; private_size: gsize) {.
    importc: "g_type_add_class_private", libgobj.}
proc get_private*(klass: GTypeClass; private_type: GType): gpointer {.
    importc: "g_type_class_get_private", libgobj.}
proc private*(klass: GTypeClass; private_type: GType): gpointer {.
    importc: "g_type_class_get_private", libgobj.}
proc g_type_class_get_instance_private_offset*(g_class: gpointer): gint {.
    importc: "g_type_class_get_instance_private_offset", libgobj.}
proc ensure*(`type`: GType) {.importc: "g_type_ensure", libgobj.}
proc g_type_get_type_registration_serial*(): guint {.
    importc: "g_type_get_type_registration_serial", libgobj.}
template g_define_type_with_private*(TN, t_n, T_P: expr): expr = 
  G_DEFINE_TYPE_EXTENDED(TN, t_n, T_P, 0, G_ADD_PRIVATE(TN))

template g_define_abstract_type_with_private*(TN, t_n, T_P: expr): expr = 
  G_DEFINE_TYPE_EXTENDED(TN, t_n, T_P, GTypeFlags.ABSTRACT, G_ADD_PRIVATE(TN))

template g_implement_interface*(TYPE_IFACE, iface_init: expr): stmt = 
  var g_implement_interface_info: GInterfaceInfoObj = [
      cast[GInterfaceInitFunc](iface_init), nil, nil]
  g_type_add_interface_static(g_define_type_id, TYPE_IFACE, 
                              addr(g_implement_interface_info))

template g_private_field_p*(TypeName, inst, field_name: expr): expr = 
  G_STRUCT_MEMBER_P(inst, G_PRIVATE_OFFSET(TypeName, field_name))

template g_private_field*(TypeName, inst, field_type, field_name: expr): expr = 
  G_STRUCT_MEMBER(field_type, inst, G_PRIVATE_OFFSET(TypeName, field_name))

proc get_plugin*(`type`: GType): GTypePlugin {.
    importc: "g_type_get_plugin", libgobj.}

proc plugin*(`type`: GType): GTypePlugin {.
    importc: "g_type_get_plugin", libgobj.}
proc interface_get_plugin*(instance_type: GType; interface_type: GType): GTypePlugin {.
    importc: "g_type_interface_get_plugin", libgobj.}
proc g_type_fundamental_next*(): GType {.importc: "g_type_fundamental_next", 
    libgobj.}
proc fundamental*(type_id: GType): GType {.
    importc: "g_type_fundamental", libgobj.}
proc create_instance*(`type`: GType): GTypeInstance {.
    importc: "g_type_create_instance", libgobj.}
proc g_type_free_instance*(instance: GTypeInstance) {.
    importc: "g_type_free_instance", libgobj.}
proc g_type_add_class_cache_func*(cache_data: gpointer; 
                                  cache_func: GTypeClassCacheFunc) {.
    importc: "g_type_add_class_cache_func", libgobj.}
proc g_type_remove_class_cache_func*(cache_data: gpointer; 
                                     cache_func: GTypeClassCacheFunc) {.
    importc: "g_type_remove_class_cache_func", libgobj.}
proc g_type_class_unref_uncached*(g_class: gpointer) {.
    importc: "g_type_class_unref_uncached", libgobj.}
proc g_type_add_interface_check*(check_data: gpointer; 
                                 check_func: GTypeInterfaceCheckFunc) {.
    importc: "g_type_add_interface_check", libgobj.}
proc g_type_remove_interface_check*(check_data: gpointer; 
                                    check_func: GTypeInterfaceCheckFunc) {.
    importc: "g_type_remove_interface_check", libgobj.}
proc value_table_peek*(`type`: GType): GTypeValueTable {.
    importc: "g_type_value_table_peek", libgobj.}
proc g_type_check_instance*(instance: GTypeInstance): gboolean {.
    importc: "g_type_check_instance", libgobj.}
proc g_type_check_instance_cast*(instance: GTypeInstance; 
                                 iface_type: GType): GTypeInstance {.
    importc: "g_type_check_instance_cast", libgobj.}
proc g_type_check_instance_is_a*(instance: GTypeInstance; 
                                 iface_type: GType): gboolean {.
    importc: "g_type_check_instance_is_a", libgobj.}
proc g_type_check_instance_is_fundamentally_a*(instance: GTypeInstance; 
    fundamental_type: GType): gboolean {.
    importc: "g_type_check_instance_is_fundamentally_a", libgobj.}
proc g_type_check_class_cast*(g_class: GTypeClass; is_a_type: GType): GTypeClass {.
    importc: "g_type_check_class_cast", libgobj.}
proc g_type_check_class_is_a*(g_class: GTypeClass; is_a_type: GType): gboolean {.
    importc: "g_type_check_class_is_a", libgobj.}
proc check_is_value_type*(`type`: GType): gboolean {.
    importc: "g_type_check_is_value_type", libgobj.}
proc g_type_check_value*(value: GValue): gboolean {.
    importc: "g_type_check_value", libgobj.}
proc g_type_check_value_holds*(value: GValue; `type`: GType): gboolean {.
    importc: "g_type_check_value_holds", libgobj.}
proc test_flags*(`type`: GType; flags: guint): gboolean {.
    importc: "g_type_test_flags", libgobj.}
proc g_type_name_from_instance*(instance: GTypeInstance): cstring {.
    importc: "g_type_name_from_instance", libgobj.}
proc g_type_name_from_class*(g_class: GTypeClass): cstring {.
    importc: "g_type_name_from_class", libgobj.}
when true: # when not(defined(G_DISABLE_CAST_CHECKS)): 
  template g_type_cic*(ip, gt, ct: expr): expr = 
    (cast[ptr ct](g_type_check_instance_cast(cast[GTypeInstance](ip), gt)))

  template g_type_ccc*(cp, gt, ct: expr): expr = 
    (cast[ptr ct](g_type_check_class_cast(cast[GTypeClass](cp), gt)))

else: 
  template g_type_cic*(ip, gt, ct: expr): expr = 
    (cast[ptr ct](ip))

  template g_type_ccc*(cp, gt, ct: expr): expr = 
    (cast[ptr ct](cp))

template g_type_chi*(ip: expr): expr = 
  (g_type_check_instance(cast[GTypeInstance](ip)))

template g_type_chv*(vl: expr): expr = 
  (g_type_check_value(cast[GValue](vl)))

template g_type_igc*(ip, gt, ct: expr): expr = 
  (cast[ptr ct](((cast[GTypeInstance](ip)).g_class)))

template g_type_igi*(ip, gt, ct: expr): expr = 
  (cast[ptr ct](g_type_interface_peek((cast[GTypeInstance](ip)).g_class, 
                                      gt)))

template g_type_cift(ip, ft: expr): expr = 
  (g_type_check_instance_is_fundamentally_a(cast[GTypeInstance](ip), ft))

template g_type_cit*(ip, gt: expr): expr = 
  (g_type_check_instance_is_a(cast[GTypeInstance](ip), gt))

template g_type_cct*(cp, gt: expr): expr = 
  (g_type_check_class_is_a(cast[GTypeClass](cp), gt))

template g_type_cvh*(vl, gt: expr): expr = 
  (g_type_check_value_holds(cast[GValue](vl), gt))

const 
  G_TYPE_FLAG_RESERVED_ID_BIT* = (GType(1 shl 0))

template g_type_is_value*(`type`: expr): expr = 
  (check_is_value_type(`type`))

template g_is_value*(value: expr): expr = 
  (g_type_check_value(value))

template g_value_type*(value: expr): expr = 
  ((cast[GValue](value)).g_type)

template g_value_type_name*(value: expr): expr = 
  (name(g_value_type(value)))

template g_value_holds*(value, `type`: expr): expr = 
  (g_type_check_value_type(value, `type`))

type 
  GValueTransform* = proc (src_value: GValue; dest_value: GValue) {.cdecl.}

proc init*(value: GValue; g_type: GType): GValue {.
    importc: "g_value_init", libgobj.}
proc copy*(src_value: GValue; dest_value: GValue) {.
    importc: "g_value_copy", libgobj.}
proc reset*(value: GValue): GValue {.importc: "g_value_reset", 
    libgobj.}
proc unset*(value: GValue) {.importc: "g_value_unset", libgobj.}
proc set_instance*(value: GValue; instance: gpointer) {.
    importc: "g_value_set_instance", libgobj.}
proc `instance=`*(value: GValue; instance: gpointer) {.
    importc: "g_value_set_instance", libgobj.}
proc init_from_instance*(value: GValue; instance: gpointer) {.
    importc: "g_value_init_from_instance", libgobj.}
proc fits_pointer*(value: GValue): gboolean {.
    importc: "g_value_fits_pointer", libgobj.}
proc peek_pointer*(value: GValue): gpointer {.
    importc: "g_value_peek_pointer", libgobj.}
proc g_value_type_compatible*(src_type: GType; dest_type: GType): gboolean {.
    importc: "g_value_type_compatible", libgobj.}
proc g_value_type_transformable*(src_type: GType; dest_type: GType): gboolean {.
    importc: "g_value_type_transformable", libgobj.}
proc transform*(src_value: GValue; dest_value: GValue): gboolean {.
    importc: "g_value_transform", libgobj.}
proc g_value_register_transform_func*(src_type: GType; dest_type: GType; 
                                      transform_func: GValueTransform) {.
    importc: "g_value_register_transform_func", libgobj.}
const 
  G_VALUE_NOCOPY_CONTENTS* = (1 shl 27)

template g_type_is_param*(`type`: expr): expr = 
  (fundamental(`type`) == G_TYPE_PARAM)

template g_param_spec*(pspec: expr): expr = 
  (g_type_check_instance_cast(pspec, G_TYPE_PARAM, GParamSpecObj))

when true: #when GLIB_VERSION_MAX_ALLOWED >= GLIB_VERSION_2_42: 
  template g_is_param_spec*(pspec: expr): expr = 
    (g_type_check_instance_fundamental_type(pspec, G_TYPE_PARAM))

else: 
  template g_is_param_spec*(pspec: expr): expr = 
    (g_type_check_instance_type(pspec, G_TYPE_PARAM))

template g_param_spec_class*(pclass: expr): expr = 
  (g_type_check_class_cast(pclass, G_TYPE_PARAM, GParamSpecClassObj))

template g_is_param_spec_class*(pclass: expr): expr = 
  (g_type_check_class_type(pclass, G_TYPE_PARAM))

template g_param_spec_get_class*(pspec: expr): expr = 
  (g_type_instance_get_class(pspec, G_TYPE_PARAM, GParamSpecClassObj))

template g_param_spec_type*(pspec: expr): expr = 
  (g_type_from_instance(pspec))

template g_param_spec_type_name*(pspec: expr): expr = 
  (name(g_param_spec_type(pspec)))

template g_param_spec_value_type*(pspec: expr): expr = 
  (g_param_spec(pspec).value_type)

template g_value_holds_param*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_PARAM))

type 
  GParamFlags* {.size: sizeof(cint), pure.} = enum 
    READABLE = 1 shl 0, WRITABLE = 1 shl 1, 
    CONSTRUCT = 1 shl 2, CONSTRUCT_ONLY = 1 shl 3, 
    LAX_VALIDATION = 1 shl 4, STATIC_NAME = 1 shl 5, 
    STATIC_NICK = 1 shl 6, STATIC_BLURB = 1 shl 7, 
    EXPLICIT_NOTIFY = 1 shl 30, DEPRECATED = 1 shl 31
const 
  G_PARAM_STATIC_STRINGS* = (
    GParamFlags.STATIC_NAME.ord or GParamFlags.STATIC_NICK.ord or GParamFlags.STATIC_BLURB.ord)
  G_PARAM_READWRITE = (GParamFlags.READABLE.ord or GParamFlags.WRITABLE.ord) 
const 
  G_PARAM_MASK* = 0x000000FF
const 
  G_PARAM_USER_SHIFT* = 8
type 
  GParamSpecPool* =  ptr GParamSpecPoolObj
  GParamSpecPoolPtr* = ptr GParamSpecPoolObj
  GParamSpecPoolObj* = object 
  
type 
  GParamSpec* =  ptr GParamSpecObj
  GParamSpecPtr* = ptr GParamSpecObj
  GParamSpecObj* = object of GTypeInstanceObj
    name*: cstring
    flags*: GParamFlags
    value_type*: GType
    owner_type*: GType
    nick: cstring
    blurb: cstring
    qdata*: GData
    ref_count*: guint
    param_id*: guint

type 
  GParamSpecClass* =  ptr GParamSpecClassObj
  GParamSpecClassPtr* = ptr GParamSpecClassObj
  GParamSpecClassObj*{.final.} = object of GTypeClassObj
    value_type*: GType
    finalize*: proc (pspec: GParamSpec) {.cdecl.}
    value_set_default*: proc (pspec: GParamSpec; value: GValue) {.cdecl.}
    value_validate*: proc (pspec: GParamSpec; value: GValue): gboolean {.cdecl.}
    values_cmp*: proc (pspec: GParamSpec; value1: GValue; 
                       value2: GValue): gint {.cdecl.}
    dummy: array[4, gpointer]

type 
  GParameter* =  ptr GParameterObj
  GParameterPtr* = ptr GParameterObj
  GParameterObj* = object 
    name*: cstring
    value*: GValueObj

proc `ref`*(pspec: GParamSpec): GParamSpec {.
    importc: "g_param_spec_ref", libgobj.}
proc unref*(pspec: GParamSpec) {.
    importc: "g_param_spec_unref", libgobj.}
proc sink*(pspec: GParamSpec) {.importc: "g_param_spec_sink", 
    libgobj.}
proc ref_sink*(pspec: GParamSpec): GParamSpec {.
    importc: "g_param_spec_ref_sink", libgobj.}
proc get_qdata*(pspec: GParamSpec; quark: GQuark): gpointer {.
    importc: "g_param_spec_get_qdata", libgobj.}
proc qdata*(pspec: GParamSpec; quark: GQuark): gpointer {.
    importc: "g_param_spec_get_qdata", libgobj.}
proc set_qdata*(pspec: GParamSpec; quark: GQuark; 
                             data: gpointer) {.
    importc: "g_param_spec_set_qdata", libgobj.}
proc `qdata=`*(pspec: GParamSpec; quark: GQuark; 
                             data: gpointer) {.
    importc: "g_param_spec_set_qdata", libgobj.}
proc set_qdata_full*(pspec: GParamSpec; quark: GQuark; 
                                  data: gpointer; destroy: GDestroyNotify) {.
    importc: "g_param_spec_set_qdata_full", libgobj.}
proc `qdata_full=`*(pspec: GParamSpec; quark: GQuark; 
                                  data: gpointer; destroy: GDestroyNotify) {.
    importc: "g_param_spec_set_qdata_full", libgobj.}
proc steal_qdata*(pspec: GParamSpec; quark: GQuark): gpointer {.
    importc: "g_param_spec_steal_qdata", libgobj.}
proc get_redirect_target*(pspec: GParamSpec): GParamSpec {.
    importc: "g_param_spec_get_redirect_target", libgobj.}
proc redirect_target*(pspec: GParamSpec): GParamSpec {.
    importc: "g_param_spec_get_redirect_target", libgobj.}
proc value_set_default*(pspec: GParamSpec; value: GValue) {.
    importc: "g_param_value_set_default", libgobj.}
proc value_defaults*(pspec: GParamSpec; value: GValue): gboolean {.
    importc: "g_param_value_defaults", libgobj.}
proc value_validate*(pspec: GParamSpec; value: GValue): gboolean {.
    importc: "g_param_value_validate", libgobj.}
proc value_convert*(pspec: GParamSpec; src_value: GValue; 
                            dest_value: GValue; 
                            strict_validation: gboolean): gboolean {.
    importc: "g_param_value_convert", libgobj.}
proc values_cmp*(pspec: GParamSpec; value1: GValue; 
                         value2: GValue): gint {.
    importc: "g_param_values_cmp", libgobj.}
proc get_name*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_name", libgobj.}
proc name*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_name", libgobj.}
proc get_nick*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_nick", libgobj.}
proc nick*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_nick", libgobj.}
proc get_blurb*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_blurb", libgobj.}
proc blurb*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_blurb", libgobj.}
proc set_param*(value: GValue; param: GParamSpec) {.
    importc: "g_value_set_param", libgobj.}
proc `param=`*(value: GValue; param: GParamSpec) {.
    importc: "g_value_set_param", libgobj.}
proc get_param*(value: GValue): GParamSpec {.
    importc: "g_value_get_param", libgobj.}
proc param*(value: GValue): GParamSpec {.
    importc: "g_value_get_param", libgobj.}
proc dup_param*(value: GValue): GParamSpec {.
    importc: "g_value_dup_param", libgobj.}
proc take_param*(value: GValue; param: GParamSpec) {.
    importc: "g_value_take_param", libgobj.}
proc set_param_take_ownership*(value: GValue; 
    param: GParamSpec) {.importc: "g_value_set_param_take_ownership", 
                             libgobj.}
proc `param_take_ownership=`*(value: GValue; 
    param: GParamSpec) {.importc: "g_value_set_param_take_ownership", 
                             libgobj.}
proc get_default_value*(param: GParamSpec): GValue {.
    importc: "g_param_spec_get_default_value", libgobj.}
proc default_value*(param: GParamSpec): GValue {.
    importc: "g_param_spec_get_default_value", libgobj.}
type 
  GParamSpecTypeInfo* =  ptr GParamSpecTypeInfoObj
  GParamSpecTypeInfoPtr* = ptr GParamSpecTypeInfoObj
  GParamSpecTypeInfoObj* = object 
    instance_size*: guint16
    n_preallocs*: guint16
    instance_init*: proc (pspec: GParamSpec) {.cdecl.}
    value_type*: GType
    finalize*: proc (pspec: GParamSpec) {.cdecl.}
    value_set_default*: proc (pspec: GParamSpec; value: GValue) {.cdecl.}
    value_validate*: proc (pspec: GParamSpec; value: GValue): gboolean {.cdecl.}
    values_cmp*: proc (pspec: GParamSpec; value1: GValue; 
                       value2: GValue): gint {.cdecl.}

proc g_param_type_register_static*(name: cstring; 
                                   pspec_info: GParamSpecTypeInfo): GType {.
    importc: "g_param_type_register_static", libgobj.}
proc g_param_type_register_static_constant(name: cstring; 
    pspec_info: GParamSpecTypeInfo; opt_type: GType): GType {.
    importc: "_g_param_type_register_static_constant", libgobj.}
proc g_param_spec_internal*(param_type: GType; name: cstring; 
                            nick: cstring; blurb: cstring; 
                            flags: GParamFlags): gpointer {.
    importc: "g_param_spec_internal", libgobj.}
proc g_param_spec_pool_new*(type_prefixing: gboolean): GParamSpecPool {.
    importc: "g_param_spec_pool_new", libgobj.}
proc insert*(pool: GParamSpecPool; 
                               pspec: GParamSpec; owner_type: GType) {.
    importc: "g_param_spec_pool_insert", libgobj.}
proc remove*(pool: GParamSpecPool; pspec: GParamSpec) {.
    importc: "g_param_spec_pool_remove", libgobj.}
proc lookup*(pool: GParamSpecPool; 
                               param_name: cstring; owner_type: GType; 
                               walk_ancestors: gboolean): GParamSpec {.
    importc: "g_param_spec_pool_lookup", libgobj.}
proc list_owned*(pool: GParamSpecPool; owner_type: GType): GList {.
    importc: "g_param_spec_pool_list_owned", libgobj.}
proc list*(pool: GParamSpecPool; owner_type: GType; 
                             n_pspecs_p: ptr guint): ptr GParamSpec {.
    importc: "g_param_spec_pool_list", libgobj.}

template g_closure_needs_marshal*(closure: expr): expr = 
  ((cast[GClosure](closure)).marshal == nil)

template g_closure_n_notifiers*(cl: expr): expr = 
  ((cl.n_guards shl 1) + (cl).n_fnotifiers + (cl).n_inotifiers)

template g_cclosure_swap_data*(cclosure: expr): expr = 
  ((cast[GClosure](cclosure)).derivative_flag)

type 
  GCallback* = proc () {.cdecl.}

proc g_callback*(p: proc): GCallback = 
  cast[GCallback](p)
type 
  GClosureNotifyData* =  ptr GClosureNotifyDataObj
  GClosureNotifyDataPtr* = ptr GClosureNotifyDataObj
  GClosureNotifyDataObj* = object 
    data*: gpointer
    notify*: GClosureNotify
 
  GClosure* =  ptr GClosureObj
  GClosurePtr* = ptr GClosureObj
  GClosureObj{.inheritable, pure.} = object 
    bitfield0GClosure*: guintwith32bitatleast
    marshal*: proc (closure: GClosure; return_value: GValue; 
                    n_param_values: guint; param_values: GValue; 
                    invocation_hint: gpointer; marshal_data: gpointer) {.cdecl.}
    data*: gpointer
    notifiers*: GClosureNotifyData
 
  GClosureNotify* = proc (data: gpointer; closure: GClosure) {.cdecl.}

type 
  GClosureMarshal* = proc (closure: GClosure; return_value: GValue; 
                           n_param_values: guint; param_values: GValue; 
                           invocation_hint: gpointer; marshal_data: gpointer) {.cdecl.}
discard """ GVaClosureMarshal* = proc (closure: GClosure; return_value: GValue; 
                             instance: gpointer; args: va_list; 
                             marshal_data: gpointer; n_params: cint; 
                             param_types: ptr GType) {.cdecl.} """

type 
  GCClosure* =  ptr GCClosureObj
  GCClosurePtr* = ptr GCClosureObj
  GCClosureObj*{.final.} = object of GClosureObj
    callback*: gpointer

proc g_cclosure_new*(callback_func: GCallback; user_data: gpointer; 
                     destroy_data: GClosureNotify): GClosure {.
    importc: "g_cclosure_new", libgobj.}
proc g_cclosure_new_swap*(callback_func: GCallback; user_data: gpointer; 
                          destroy_data: GClosureNotify): GClosure {.
    importc: "g_cclosure_new_swap", libgobj.}
proc g_signal_type_cclosure_new*(itype: GType; struct_offset: guint): GClosure {.
    importc: "g_signal_type_cclosure_new", libgobj.}
proc `ref`*(closure: GClosure): GClosure {.
    importc: "g_closure_ref", libgobj.}
proc sink*(closure: GClosure) {.importc: "g_closure_sink", 
    libgobj.}
proc unref*(closure: GClosure) {.importc: "g_closure_unref", 
    libgobj.}
proc g_closure_new_simple*(sizeof_closure: guint; data: gpointer): GClosure {.
    importc: "g_closure_new_simple", libgobj.}
proc add_finalize_notifier*(closure: GClosure; 
                                      notify_data: gpointer; 
                                      notify_func: GClosureNotify) {.
    importc: "g_closure_add_finalize_notifier", libgobj.}
proc remove_finalize_notifier*(closure: GClosure; 
    notify_data: gpointer; notify_func: GClosureNotify) {.
    importc: "g_closure_remove_finalize_notifier", libgobj.}
proc add_invalidate_notifier*(closure: GClosure; 
    notify_data: gpointer; notify_func: GClosureNotify) {.
    importc: "g_closure_add_invalidate_notifier", libgobj.}
proc remove_invalidate_notifier*(closure: GClosure; 
    notify_data: gpointer; notify_func: GClosureNotify) {.
    importc: "g_closure_remove_invalidate_notifier", libgobj.}
proc add_marshal_guards*(closure: GClosure; 
                                   pre_marshal_data: gpointer; 
                                   pre_marshal_notify: GClosureNotify; 
                                   post_marshal_data: gpointer; 
                                   post_marshal_notify: GClosureNotify) {.
    importc: "g_closure_add_marshal_guards", libgobj.}
proc set_marshal*(closure: GClosure; marshal: GClosureMarshal) {.
    importc: "g_closure_set_marshal", libgobj.}
proc `marshal=`*(closure: GClosure; marshal: GClosureMarshal) {.
    importc: "g_closure_set_marshal", libgobj.}
proc set_meta_marshal*(closure: GClosure; 
                                 marshal_data: gpointer; 
                                 meta_marshal: GClosureMarshal) {.
    importc: "g_closure_set_meta_marshal", libgobj.}
proc `meta_marshal=`*(closure: GClosure; 
                                 marshal_data: gpointer; 
                                 meta_marshal: GClosureMarshal) {.
    importc: "g_closure_set_meta_marshal", libgobj.}
proc invalidate*(closure: GClosure) {.
    importc: "g_closure_invalidate", libgobj.}
proc invoke*(closure: GClosure; return_value: GValue; 
                       n_param_values: guint; param_values: GValue; 
                       invocation_hint: gpointer) {.
    importc: "g_closure_invoke", libgobj.}
proc marshal_generic*(closure: GClosure; 
                                 return_gvalue: GValue; 
                                 n_param_values: guint; 
                                 param_values: GValue; 
                                 invocation_hint: gpointer; 
                                 marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_generic", libgobj.}

discard """ proc "g_cclosure_marshal_generic_va*(closure: GClosure; 
                                    return_value: GValue; 
                                    instance: gpointer; args_list: va_list; 
                                    marshal_data: gpointer; n_params: cint; 
                                    param_types: ptr GType) {.
    importc: "g_cclosure_marshal_generic_va", libgobj.}"""

proc marshal_VOID_VOID*(closure: GClosure; 
                                    return_value: GValue; 
                                    n_param_values: guint; 
                                    param_values: GValue; 
                                    invocation_hint: gpointer; 
                                    marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__VOID", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__VOIDv*(closure: GClosure; 
                                     return_value: GValue; 
                                     instance: gpointer; args: va_list; 
                                     marshal_data: gpointer; n_params: cint; 
                                     param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__VOIDv", libgobj.}"""

proc marshal_VOID_BOOLEAN*(closure: GClosure; 
    return_value: GValue; n_param_values: guint; param_values: GValue; 
    invocation_hint: gpointer; marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__BOOLEAN", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__BOOLEANv*(closure: GClosure; 
    return_value: GValue; instance: gpointer; args: va_list; 
    marshal_data: gpointer; n_params: cint; param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__BOOLEANv", libgobj.}"""

proc marshal_VOID_CHAR*(closure: GClosure; 
                                    return_value: GValue; 
                                    n_param_values: guint; 
                                    param_values: GValue; 
                                    invocation_hint: gpointer; 
                                    marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__CHAR", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__CHARv*(closure: GClosure; 
                                     return_value: GValue; 
                                     instance: gpointer; args: va_list; 
                                     marshal_data: gpointer; n_params: cint; 
                                     param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__CHARv", libgobj.}"""

proc marshal_VOID_UCHAR*(closure: GClosure; 
                                     return_value: GValue; 
                                     n_param_values: guint; 
                                     param_values: GValue; 
                                     invocation_hint: gpointer; 
                                     marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__UCHAR", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__UCHARv*(closure: GClosure; 
                                      return_value: GValue; 
                                      instance: gpointer; args: va_list; 
                                      marshal_data: gpointer; n_params: cint; 
                                      param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__UCHARv", libgobj.}"""

proc marshal_VOID_INT*(closure: GClosure; 
                                   return_value: GValue; 
                                   n_param_values: guint; 
                                   param_values: GValue; 
                                   invocation_hint: gpointer; 
                                   marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__INT", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__INTv*(closure: GClosure; 
                                    return_value: GValue; 
                                    instance: gpointer; args: va_list; 
                                    marshal_data: gpointer; n_params: cint; 
                                    param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__INTv", libgobj.}"""

proc marshal_VOID_UINT*(closure: GClosure; 
                                    return_value: GValue; 
                                    n_param_values: guint; 
                                    param_values: GValue; 
                                    invocation_hint: gpointer; 
                                    marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__UINT", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__UINTv*(closure: GClosure; 
                                     return_value: GValue; 
                                     instance: gpointer; args: va_list; 
                                     marshal_data: gpointer; n_params: cint; 
                                     param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__UINTv", libgobj.}"""

proc marshal_VOID_LONG*(closure: GClosure; 
                                    return_value: GValue; 
                                    n_param_values: guint; 
                                    param_values: GValue; 
                                    invocation_hint: gpointer; 
                                    marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__LONG", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__LONGv*(closure: GClosure; 
                                     return_value: GValue; 
                                     instance: gpointer; args: va_list; 
                                     marshal_data: gpointer; n_params: cint; 
                                     param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__LONGv", libgobj.}"""

proc marshal_VOID_ULONG*(closure: GClosure; 
                                     return_value: GValue; 
                                     n_param_values: guint; 
                                     param_values: GValue; 
                                     invocation_hint: gpointer; 
                                     marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__ULONG", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__ULONGv*(closure: GClosure; 
                                      return_value: GValue; 
                                      instance: gpointer; args: va_list; 
                                      marshal_data: gpointer; n_params: cint; 
                                      param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__ULONGv", libgobj.}"""

proc marshal_VOID_ENUM*(closure: GClosure; 
                                    return_value: GValue; 
                                    n_param_values: guint; 
                                    param_values: GValue; 
                                    invocation_hint: gpointer; 
                                    marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__ENUM", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__ENUMv*(closure: GClosure; 
                                     return_value: GValue; 
                                     instance: gpointer; args: va_list; 
                                     marshal_data: gpointer; n_params: cint; 
                                     param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__ENUMv", libgobj.}"""

proc marshal_VOID_FLAGS*(closure: GClosure; 
                                     return_value: GValue; 
                                     n_param_values: guint; 
                                     param_values: GValue; 
                                     invocation_hint: gpointer; 
                                     marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__FLAGS", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__FLAGSv*(closure: GClosure; 
                                      return_value: GValue; 
                                      instance: gpointer; args: va_list; 
                                      marshal_data: gpointer; n_params: cint; 
                                      param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__FLAGSv", libgobj.}"""

proc marshal_VOID_FLOAT*(closure: GClosure; 
                                     return_value: GValue; 
                                     n_param_values: guint; 
                                     param_values: GValue; 
                                     invocation_hint: gpointer; 
                                     marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__FLOAT", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__FLOATv*(closure: GClosure; 
                                      return_value: GValue; 
                                      instance: gpointer; args: va_list; 
                                      marshal_data: gpointer; n_params: cint; 
                                      param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__FLOATv", libgobj.}"""

proc marshal_VOID_DOUBLE*(closure: GClosure; 
                                      return_value: GValue; 
                                      n_param_values: guint; 
                                      param_values: GValue; 
                                      invocation_hint: gpointer; 
                                      marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__DOUBLE", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__DOUBLEv*(closure: GClosure; 
    return_value: GValue; instance: gpointer; args: va_list; 
    marshal_data: gpointer; n_params: cint; param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__DOUBLEv", libgobj.}"""

proc marshal_VOID_STRING*(closure: GClosure; 
                                      return_value: GValue; 
                                      n_param_values: guint; 
                                      param_values: GValue; 
                                      invocation_hint: gpointer; 
                                      marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__STRING", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__STRINGv*(closure: GClosure; 
    return_value: GValue; instance: gpointer; args: va_list; 
    marshal_data: gpointer; n_params: cint; param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__STRINGv", libgobj.}"""

proc marshal_VOID_PARAM*(closure: GClosure; 
                                     return_value: GValue; 
                                     n_param_values: guint; 
                                     param_values: GValue; 
                                     invocation_hint: gpointer; 
                                     marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__PARAM", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__PARAMv*(closure: GClosure; 
                                      return_value: GValue; 
                                      instance: gpointer; args: va_list; 
                                      marshal_data: gpointer; n_params: cint; 
                                      param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__PARAMv", libgobj.}"""

proc marshal_VOID_BOXED*(closure: GClosure; 
                                     return_value: GValue; 
                                     n_param_values: guint; 
                                     param_values: GValue; 
                                     invocation_hint: gpointer; 
                                     marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__BOXED", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__BOXEDv*(closure: GClosure; 
                                      return_value: GValue; 
                                      instance: gpointer; args: va_list; 
                                      marshal_data: gpointer; n_params: cint; 
                                      param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__BOXEDv", libgobj.}"""

proc marshal_VOID_POINTER*(closure: GClosure; 
    return_value: GValue; n_param_values: guint; param_values: GValue; 
    invocation_hint: gpointer; marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__POINTER", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__POINTERv*(closure: GClosure; 
    return_value: GValue; instance: gpointer; args: va_list; 
    marshal_data: gpointer; n_params: cint; param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__POINTERv", libgobj.}"""

proc marshal_VOID_OBJECT*(closure: GClosure; 
                                      return_value: GValue; 
                                      n_param_values: guint; 
                                      param_values: GValue; 
                                      invocation_hint: gpointer; 
                                      marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__OBJECT", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__OBJECTv*(closure: GClosure; 
    return_value: GValue; instance: gpointer; args: va_list; 
    marshal_data: gpointer; n_params: cint; param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__OBJECTv", libgobj.}"""

proc marshal_VOID_VARIANT*(closure: GClosure; 
    return_value: GValue; n_param_values: guint; param_values: GValue; 
    invocation_hint: gpointer; marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__VARIANT", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__VARIANTv*(closure: GClosure; 
    return_value: GValue; instance: gpointer; args: va_list; 
    marshal_data: gpointer; n_params: cint; param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__VARIANTv", libgobj.}"""

proc marshal_VOID_UINT_POINTER*(closure: GClosure; 
    return_value: GValue; n_param_values: guint; param_values: GValue; 
    invocation_hint: gpointer; marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_VOID__UINT_POINTER", libgobj.}

discard """ proc "g_cclosure_marshal_VOID__UINT_POINTERv*(closure: GClosure; 
    return_value: GValue; instance: gpointer; args: va_list; 
    marshal_data: gpointer; n_params: cint; param_types: ptr GType) {.
    importc: "g_cclosure_marshal_VOID__UINT_POINTERv", libgobj.}"""

proc marshal_BOOLEAN_FLAGS*(closure: GClosure; 
    return_value: GValue; n_param_values: guint; param_values: GValue; 
    invocation_hint: gpointer; marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_BOOLEAN__FLAGS", libgobj.}

discard """ proc "g_cclosure_marshal_BOOLEAN__FLAGSv*(closure: GClosure; 
    return_value: GValue; instance: gpointer; args: va_list; 
    marshal_data: gpointer; n_params: cint; param_types: ptr GType) {.
    importc: "g_cclosure_marshal_BOOLEAN__FLAGSv", libgobj.}"""

const 
  marshal_BOOL_FLAGS* = marshal_BOOLEAN_FLAGS
proc marshal_STRING_OBJECT_POINTER*(closure: GClosure; 
    return_value: GValue; n_param_values: guint; param_values: GValue; 
    invocation_hint: gpointer; marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_STRING__OBJECT_POINTER", libgobj.}

discard """ proc "g_cclosure_marshal_STRING__OBJECT_POINTERv*(closure: GClosure; 
    return_value: GValue; instance: gpointer; args: va_list; 
    marshal_data: gpointer; n_params: cint; param_types: ptr GType) {.
    importc: "g_cclosure_marshal_STRING__OBJECT_POINTERv", libgobj.}"""

proc marshal_BOOLEAN_BOXED_BOXED*(closure: GClosure; 
    return_value: GValue; n_param_values: guint; param_values: GValue; 
    invocation_hint: gpointer; marshal_data: gpointer) {.
    importc: "g_cclosure_marshal_BOOLEAN__BOXED_BOXED", libgobj.}

discard """ proc "g_cclosure_marshal_BOOLEAN__BOXED_BOXEDv*(closure: GClosure; 
    return_value: GValue; instance: gpointer; args: va_list; 
    marshal_data: gpointer; n_params: cint; param_types: ptr GType) {.
    importc: "g_cclosure_marshal_BOOLEAN__BOXED_BOXEDv", libgobj.}"""

const 
  marshal_BOOL_BOXED_BOXED* = marshal_BOOLEAN_BOXED_BOXED

type 
  GSignalCMarshaller* = GClosureMarshal
type 
  GSignalFlags* {.size: sizeof(cint), pure.} = enum 
    RUN_FIRST = 1 shl 0, RUN_LAST = 1 shl 1, 
    RUN_CLEANUP = 1 shl 2, NO_RECURSE = 1 shl 3, 
    DETAILED = 1 shl 4, ACTION = 1 shl 5, 
    NO_HOOKS = 1 shl 6, MUST_COLLECT = 1 shl 7, 
    DEPRECATED = 1 shl 8
type 
  GSignalInvocationHint* =  ptr GSignalInvocationHintObj
  GSignalInvocationHintPtr* = ptr GSignalInvocationHintObj
  GSignalInvocationHintObj* = object 
    signal_id*: guint
    detail*: GQuark
    run_type*: GSignalFlags
type 
  GSignalEmissionHook* = proc (ihint: GSignalInvocationHint; 
                               n_param_values: guint; 
                               param_values: GValue; data: gpointer): gboolean {.cdecl.}
type 
  GSignalAccumulator* = proc (ihint: GSignalInvocationHint; 
                              return_accu: GValue; 
                              handler_return: GValue; data: gpointer): gboolean {.cdecl.}
const 
  G_SIGNAL_FLAGS_MASK* = 0x000001FF
type 
  GConnectFlags* {.size: sizeof(cint), pure.} = enum 
    AFTER = 1 shl 0, SWAPPED = 1 shl 1
type 
  GSignalMatchType* {.size: sizeof(cint), pure.} = enum 
    ID = 1 shl 0, DETAIL = 1 shl 1, 
    CLOSURE = 1 shl 2, FUNC = 1 shl 3, 
    DATA = 1 shl 4, UNBLOCKED = 1 shl 5
const 
  G_SIGNAL_MATCH_MASK* = 0x0000003F
const 
  G_SIGNAL_TYPE_STATIC_SCOPE* = G_TYPE_FLAG_RESERVED_ID_BIT

type 
  GSignalQuery* =  ptr GSignalQueryObj
  GSignalQueryPtr* = ptr GSignalQueryObj
  GSignalQueryObj* = object 
    signal_id*: guint
    signal_name*: cstring
    itype*: GType
    signal_flags*: GSignalFlags
    return_type*: GType
    n_params*: guint
    param_types*: ptr GType

proc g_signal_newv*(signal_name: cstring; itype: GType; 
                    signal_flags: GSignalFlags; class_closure: GClosure; 
                    accumulator: GSignalAccumulator; accu_data: gpointer; 
                    c_marshaller: GSignalCMarshaller; return_type: GType; 
                    n_params: guint; param_types: ptr GType): guint {.
    importc: "g_signal_newv", libgobj.}

discard """ proc "g_signal_new_valist*(signal_name: cstring; itype: GType; 
                          signal_flags: GSignalFlags; 
                          class_closure: GClosure; 
                          accumulator: GSignalAccumulator; 
                          accu_data: gpointer; 
                          c_marshaller: GSignalCMarshaller; 
                          return_type: GType; n_params: guint; args: va_list): guint {.
    importc: "g_signal_new_valist", libgobj.}"""

proc g_signal_new*(signal_name: cstring; itype: GType; 
                   signal_flags: GSignalFlags; class_offset: guint; 
                   accumulator: GSignalAccumulator; accu_data: gpointer; 
                   c_marshaller: GSignalCMarshaller; return_type: GType; 
                   n_params: guint): guint {.varargs, importc: "g_signal_new", 
    libgobj.}
proc g_signal_new_class_handler*(signal_name: cstring; itype: GType; 
                                 signal_flags: GSignalFlags; 
                                 class_handler: GCallback; 
                                 accumulator: GSignalAccumulator; 
                                 accu_data: gpointer; 
                                 c_marshaller: GSignalCMarshaller; 
                                 return_type: GType; n_params: guint): guint {.
    varargs, importc: "g_signal_new_class_handler", libgobj.}
proc g_signal_emitv*(instance_and_params: GValue; signal_id: guint; 
                     detail: GQuark; return_value: GValue) {.
    importc: "g_signal_emitv", libgobj.}

discard """ proc "g_signal_emit_valist*(instance: gpointer; signal_id: guint; 
                           detail: GQuark; var_args: va_list) {.
    importc: "g_signal_emit_valist", libgobj.}"""

proc g_signal_emit*(instance: gpointer; signal_id: guint; detail: GQuark) {.
    varargs, importc: "g_signal_emit", libgobj.}
proc g_signal_emit_by_name*(instance: gpointer; detailed_signal: cstring) {.
    varargs, importc: "g_signal_emit_by_name", libgobj.}
proc g_signal_lookup*(name: cstring; itype: GType): guint {.
    importc: "g_signal_lookup", libgobj.}
proc g_signal_name*(signal_id: guint): cstring {.importc: "g_signal_name", 
    libgobj.}
proc g_signal_query*(signal_id: guint; query: GSignalQuery) {.
    importc: "g_signal_query", libgobj.}
proc g_signal_list_ids*(itype: GType; n_ids: ptr guint): ptr guint {.
    importc: "g_signal_list_ids", libgobj.}
proc g_signal_parse_name*(detailed_signal: cstring; itype: GType; 
                          signal_id_p: ptr guint; detail_p: ptr GQuark; 
                          force_detail_quark: gboolean): gboolean {.
    importc: "g_signal_parse_name", libgobj.}
proc g_signal_get_invocation_hint*(instance: gpointer): GSignalInvocationHint {.
    importc: "g_signal_get_invocation_hint", libgobj.}
proc g_signal_stop_emission*(instance: gpointer; signal_id: guint; 
                             detail: GQuark) {.
    importc: "g_signal_stop_emission", libgobj.}
proc g_signal_stop_emission_by_name*(instance: gpointer; 
                                     detailed_signal: cstring) {.
    importc: "g_signal_stop_emission_by_name", libgobj.}
proc g_signal_add_emission_hook*(signal_id: guint; detail: GQuark; 
                                 hook_func: GSignalEmissionHook; 
                                 hook_data: gpointer; 
                                 data_destroy: GDestroyNotify): gulong {.
    importc: "g_signal_add_emission_hook", libgobj.}
proc g_signal_remove_emission_hook*(signal_id: guint; hook_id: gulong) {.
    importc: "g_signal_remove_emission_hook", libgobj.}
proc g_signal_has_handler_pending*(instance: gpointer; signal_id: guint; 
                                   detail: GQuark; may_be_blocked: gboolean): gboolean {.
    importc: "g_signal_has_handler_pending", libgobj.}
proc g_signal_connect_closure_by_id*(instance: gpointer; signal_id: guint; 
                                     detail: GQuark; closure: GClosure; 
                                     after: gboolean): gulong {.
    importc: "g_signal_connect_closure_by_id", libgobj.}
proc g_signal_connect_closure*(instance: gpointer; detailed_signal: cstring; 
                               closure: GClosure; after: gboolean): gulong {.
    importc: "g_signal_connect_closure", libgobj.}
proc g_signal_connect_data*(instance: gpointer; detailed_signal: cstring; 
                            c_handler: GCallback; data: gpointer; 
                            destroy_data: GClosureNotify; 
                            connect_flags: GConnectFlags): gulong {.
    importc: "g_signal_connect_data", libgobj.}
proc g_signal_handler_block*(instance: gpointer; handler_id: gulong) {.
    importc: "g_signal_handler_block", libgobj.}
proc g_signal_handler_unblock*(instance: gpointer; handler_id: gulong) {.
    importc: "g_signal_handler_unblock", libgobj.}
proc g_signal_handler_disconnect*(instance: gpointer; handler_id: gulong) {.
    importc: "g_signal_handler_disconnect", libgobj.}
proc g_signal_handler_is_connected*(instance: gpointer; handler_id: gulong): gboolean {.
    importc: "g_signal_handler_is_connected", libgobj.}
proc g_signal_handler_find*(instance: gpointer; mask: GSignalMatchType; 
                            signal_id: guint; detail: GQuark; 
                            closure: GClosure; `func`: gpointer; 
                            data: gpointer): gulong {.
    importc: "g_signal_handler_find", libgobj.}
proc g_signal_handlers_block_matched*(instance: gpointer; 
                                      mask: GSignalMatchType; 
                                      signal_id: guint; detail: GQuark; 
                                      closure: GClosure; `func`: gpointer; 
                                      data: gpointer): guint {.
    importc: "g_signal_handlers_block_matched", libgobj.}
proc g_signal_handlers_unblock_matched*(instance: gpointer; 
    mask: GSignalMatchType; signal_id: guint; detail: GQuark; 
    closure: GClosure; `func`: gpointer; data: gpointer): guint {.
    importc: "g_signal_handlers_unblock_matched", libgobj.}
proc g_signal_handlers_disconnect_matched*(instance: gpointer; 
    mask: GSignalMatchType; signal_id: guint; detail: GQuark; 
    closure: GClosure; `func`: gpointer; data: gpointer): guint {.
    importc: "g_signal_handlers_disconnect_matched", libgobj.}
proc g_signal_override_class_closure*(signal_id: guint; instance_type: GType; 
                                      class_closure: GClosure) {.
    importc: "g_signal_override_class_closure", libgobj.}
proc g_signal_override_class_handler*(signal_name: cstring; 
                                      instance_type: GType; 
                                      class_handler: GCallback) {.
    importc: "g_signal_override_class_handler", libgobj.}
proc g_signal_chain_from_overridden*(instance_and_params: GValue; 
                                     return_value: GValue) {.
    importc: "g_signal_chain_from_overridden", libgobj.}
proc g_signal_chain_from_overridden_handler*(instance: gpointer) {.varargs, 
    importc: "g_signal_chain_from_overridden_handler", libgobj.}
template g_signal_connect*(instance, detailed_signal, c_handler, data: expr): expr = 
  g_signal_connect_data(instance, detailed_signal, c_handler, data, 
                        nil, cast[GConnectFlags](0))

template g_signal_connect_after*(instance, detailed_signal, c_handler, data: expr): expr = 
  g_signal_connect_data(instance, detailed_signal, c_handler, data, 
                        nil, GConnectFlags.AFTER)

template g_signal_connect_swapped*(instance, detailed_signal, c_handler, data: expr): expr = 
  g_signal_connect_data(instance, detailed_signal, c_handler, data, 
                        nil, GConnectFlags.SWAPPED)

template g_signal_handlers_disconnect_by_func*(instance, `func`, data: expr): expr = 
  g_signal_handlers_disconnect_matched(instance, 
      (GSignalMatchType)(GSignalMatchType.FUNC.ord or GSignalMatchType.DATA.ord), 0, 0, 
      nil, `func`, data)

template g_signal_handlers_disconnect_by_data*(instance, data: expr): expr = 
  g_signal_handlers_disconnect_matched(instance, GSignalMatchType.DATA, 0, 0, 
      nil, nil, data)

template g_signal_handlers_block_by_func*(instance, `func`, data: expr): expr = 
  g_signal_handlers_block_matched(instance, GSignalMatchType(
      GSignalMatchType.FUNC.ord or GSignalMatchType.DATA.ord), 0, 0, nil, `func`, data)

template g_signal_handlers_unblock_by_func*(instance, `func`, data: expr): expr = 
  g_signal_handlers_unblock_matched(instance, GSignalMatchType(
      GSignalMatchType.FUNC.ord or GSignalMatchType.DATA.ord), 0, 0, nil, `func`, data)

proc g_signal_accumulator_true_handled*(ihint: GSignalInvocationHint; 
    return_accu: GValue; handler_return: GValue; dummy: gpointer): gboolean {.
    importc: "g_signal_accumulator_true_handled", libgobj.}
proc g_signal_accumulator_first_wins*(ihint: GSignalInvocationHint; 
                                      return_accu: GValue; 
                                      handler_return: GValue; 
                                      dummy: gpointer): gboolean {.
    importc: "g_signal_accumulator_first_wins", libgobj.}
proc g_signal_handlers_destroy*(instance: gpointer) {.
    importc: "g_signal_handlers_destroy", libgobj.}
proc g_signals_destroy(itype: GType) {.importc: "_g_signals_destroy", 
    libgobj.}

proc g_date_get_type*(): GType {.importc: "g_date_get_type", libgobj.}
proc g_strv_get_type*(): GType {.importc: "g_strv_get_type", libgobj.}
proc g_gstring_get_type*(): GType {.importc: "g_gstring_get_type", libgobj.}
proc g_hash_table_get_type*(): GType {.importc: "g_hash_table_get_type", 
    libgobj.}
proc g_array_get_type*(): GType {.importc: "g_array_get_type", libgobj.}
proc g_byte_array_get_type*(): GType {.importc: "g_byte_array_get_type", 
    libgobj.}
proc g_ptr_array_get_type*(): GType {.importc: "g_ptr_array_get_type", 
                                      libgobj.}
proc g_bytes_get_type*(): GType {.importc: "g_bytes_get_type", libgobj.}
proc g_variant_type_get_gtype*(): GType {.importc: "g_variant_type_get_gtype", 
    libgobj.}
proc g_regex_get_type*(): GType {.importc: "g_regex_get_type", libgobj.}
proc g_match_info_get_type*(): GType {.importc: "g_match_info_get_type", 
    libgobj.}
proc g_error_get_type*(): GType {.importc: "g_error_get_type", libgobj.}
proc g_date_time_get_type*(): GType {.importc: "g_date_time_get_type", 
                                      libgobj.}
proc g_time_zone_get_type*(): GType {.importc: "g_time_zone_get_type", 
                                      libgobj.}
proc g_io_channel_get_type*(): GType {.importc: "g_io_channel_get_type", 
    libgobj.}
proc g_io_condition_get_type*(): GType {.importc: "g_io_condition_get_type", 
    libgobj.}
proc g_variant_builder_get_type*(): GType {.
    importc: "g_variant_builder_get_type", libgobj.}
proc g_variant_dict_get_type*(): GType {.importc: "g_variant_dict_get_type", 
    libgobj.}
proc g_key_file_get_type*(): GType {.importc: "g_key_file_get_type", 
                                     libgobj.}
proc g_main_loop_get_type*(): GType {.importc: "g_main_loop_get_type", 
                                      libgobj.}
proc g_main_context_get_type*(): GType {.importc: "g_main_context_get_type", 
    libgobj.}
proc g_source_get_type*(): GType {.importc: "g_source_get_type", libgobj.}
proc g_pollfd_get_type*(): GType {.importc: "g_pollfd_get_type", libgobj.}
proc g_thread_get_type*(): GType {.importc: "g_thread_get_type", libgobj.}
proc g_checksum_get_type*(): GType {.importc: "g_checksum_get_type", 
                                     libgobj.}
proc g_markup_parse_context_get_type*(): GType {.
    importc: "g_markup_parse_context_get_type", libgobj.}
proc g_mapped_file_get_type*(): GType {.importc: "g_mapped_file_get_type", 
    libgobj.}
proc g_variant_get_gtype*(): GType {.importc: "g_variant_get_gtype", 
                                     libgobj.}
type 
  GStrv* = ptr cstring

template g_type_is_boxed*(`type`: expr): expr = 
  (fundamental(`type`) == G_TYPE_BOXED)

template g_value_holds_boxed*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_BOXED))

type 
  GBoxedCopyFunc* = proc (boxed: gpointer): gpointer {.cdecl.}
type 
  GBoxedFreeFunc* = proc (boxed: gpointer) {.cdecl.}
proc g_boxed_copy*(boxed_type: GType; src_boxed: gconstpointer): gpointer {.
    importc: "g_boxed_copy", libgobj.}
proc g_boxed_free*(boxed_type: GType; boxed: gpointer) {.
    importc: "g_boxed_free", libgobj.}
proc set_boxed*(value: GValue; v_boxed: gconstpointer) {.
    importc: "g_value_set_boxed", libgobj.}
proc `boxed=`*(value: GValue; v_boxed: gconstpointer) {.
    importc: "g_value_set_boxed", libgobj.}
proc set_static_boxed*(value: GValue; v_boxed: gconstpointer) {.
    importc: "g_value_set_static_boxed", libgobj.}
proc `static_boxed=`*(value: GValue; v_boxed: gconstpointer) {.
    importc: "g_value_set_static_boxed", libgobj.}
proc take_boxed*(value: GValue; v_boxed: gconstpointer) {.
    importc: "g_value_take_boxed", libgobj.}
proc set_boxed_take_ownership*(value: GValue; 
    v_boxed: gconstpointer) {.importc: "g_value_set_boxed_take_ownership", 
                              libgobj.}
proc `boxed_take_ownership=`*(value: GValue; 
    v_boxed: gconstpointer) {.importc: "g_value_set_boxed_take_ownership", 
                              libgobj.}
proc get_boxed*(value: GValue): gpointer {.
    importc: "g_value_get_boxed", libgobj.}
proc boxed*(value: GValue): gpointer {.
    importc: "g_value_get_boxed", libgobj.}
proc dup_boxed*(value: GValue): gpointer {.
    importc: "g_value_dup_boxed", libgobj.}
proc g_boxed_type_register_static*(name: cstring; 
                                   boxed_copy: GBoxedCopyFunc; 
                                   boxed_free: GBoxedFreeFunc): GType {.
    importc: "g_boxed_type_register_static", libgobj.}
proc g_closure_get_type*(): GType {.importc: "g_closure_get_type", libgobj.}
proc g_value_get_type*(): GType {.importc: "g_value_get_type", libgobj.}

template g_type_is_object*(`type`: expr): expr = 
  (fundamental(`type`) == G_TYPE_OBJECT)

template g_object*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, G_TYPE_OBJECT, GObjectObj))

template g_object_class*(class: expr): expr = 
  (g_type_check_class_cast(class, G_TYPE_OBJECT, GObjectClassObj))

when true: #when GLIB_VERSION_MAX_ALLOWED >= GLIB_VERSION_2_42: 
  template g_is_object*(`object`: expr): expr = 
    (g_type_check_instance_fundamental_type(`object`, G_TYPE_OBJECT))

else: 
  template g_is_object*(`object`: expr): expr = 
    (g_type_check_instance_type(`object`, G_TYPE_OBJECT))

template g_is_object_class*(class: expr): expr = 
  (g_type_check_class_type(class, G_TYPE_OBJECT))

template g_object_get_class*(`object`: expr): expr = 
  (g_type_instance_get_class(`object`, G_TYPE_OBJECT, GObjectClassObj))

template g_object_type*(`object`: expr): expr = 
  (g_type_from_instance(`object`))

template g_object_type_name*(`object`: expr): expr = 
  (name(g_object_type(`object`)))

template g_object_class_type*(class: expr): expr = 
  (g_type_from_class(class))

template g_object_class_name*(class: expr): expr = 
  (name(g_object_class_type(class)))

template g_value_holds_object*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_OBJECT))

template g_initially_unowned*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, initially_unowned_get_type(), 
                              GInitiallyUnownedObj))

template g_initially_unowned_class*(class: expr): expr = 
  (g_type_check_class_cast(class, initially_unowned_get_type(), 
                           GInitiallyUnownedClassObj))

template g_is_initially_unowned*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, initially_unowned_get_type()))

template g_is_initially_unowned_class*(class: expr): expr = 
  (g_type_check_class_type(class, initially_unowned_get_type()))

template g_initially_unowned_get_class*(`object`: expr): expr = 
  (g_type_instance_get_class(`object`, initially_unowned_get_type(), 
                             GInitiallyUnownedClassObj))

type 
  GObject* =  ptr GObjectObj
  GObjectPtr* = ptr GObjectObj
  GObjectObj* = object of GTypeInstanceObj
    ref_count*: guint
    qdata*: GData

type 
  GObjectClass* =  ptr GObjectClassObj
  GObjectClassPtr* = ptr GObjectClassObj
  GObjectClassObj* = object of GTypeClassObj
    construct_properties*: GSList
    constructor*: proc (`type`: GType; n_construct_properties: guint; 
                        construct_properties: GObjectConstructParam): GObject {.cdecl.}
    set_property*: proc (`object`: GObject; property_id: guint; 
                         value: GValue; pspec: GParamSpec) {.cdecl.}
    get_property*: proc (`object`: GObject; property_id: guint; 
                         value: GValue; pspec: GParamSpec) {.cdecl.}
    dispose*: proc (`object`: GObject) {.cdecl.}
    finalize*: proc (`object`: GObject) {.cdecl.}
    dispatch_properties_changed*: proc (`object`: GObject; n_pspecs: guint; 
        pspecs: var GParamSpec) {.cdecl.}
    notify*: proc (`object`: GObject; pspec: GParamSpec) {.cdecl.}
    constructed*: proc (`object`: GObject) {.cdecl.}
    flags*: gsize
    pdummy: array[6, gpointer]

  #type 
  GObjectConstructParam* =  ptr GObjectConstructParamObj
  GObjectConstructParamPtr* = ptr GObjectConstructParamObj
  GObjectConstructParamObj* = object 
    pspec*: GParamSpec
    value*: GValue

type 
  GInitiallyUnowned* =  ptr GInitiallyUnownedObj
  GInitiallyUnownedPtr* = ptr GInitiallyUnownedObj
  GInitiallyUnownedObj* = GObjectObj
  GInitiallyUnownedClass* =  ptr GInitiallyUnownedClassObj
  GInitiallyUnownedClassPtr* = ptr GInitiallyUnownedClassObj
  GInitiallyUnownedClassObj* = GObjectClassObj
type 
  GObjectGetPropertyFunc* = proc (`object`: GObject; property_id: guint; 
                                  value: GValue; pspec: GParamSpec) {.cdecl.}
type 
  GObjectSetPropertyFunc* = proc (`object`: GObject; property_id: guint; 
                                  value: GValue; pspec: GParamSpec) {.cdecl.}
type 
  GObjectFinalizeFunc* = proc (`object`: GObject) {.cdecl.}
type 
  GWeakNotify* = proc (data: gpointer; where_the_object_was: GObject) {.cdecl.}

proc g_initially_unowned_get_type*(): GType {.
    importc: "g_initially_unowned_get_type", libgobj.}
proc install_property*(oclass: GObjectClass; 
                                      property_id: guint; 
                                      pspec: GParamSpec) {.
    importc: "g_object_class_install_property", libgobj.}
proc find_property*(oclass: GObjectClass; 
                                   property_name: cstring): GParamSpec {.
    importc: "g_object_class_find_property", libgobj.}
proc list_properties*(oclass: GObjectClass; 
                                     n_properties: ptr guint): ptr GParamSpec {.
    importc: "g_object_class_list_properties", libgobj.}
proc override_property*(oclass: GObjectClass; 
    property_id: guint; name: cstring) {.
    importc: "g_object_class_override_property", libgobj.}
proc install_properties*(oclass: GObjectClass; 
    n_pspecs: guint; pspecs: var GParamSpec) {.
    importc: "g_object_class_install_properties", libgobj.}
proc g_object_interface_install_property*(g_iface: gpointer; 
    pspec: GParamSpec) {.importc: "g_object_interface_install_property", 
                             libgobj.}
proc g_object_interface_find_property*(g_iface: gpointer; 
    property_name: cstring): GParamSpec {.
    importc: "g_object_interface_find_property", libgobj.}
proc g_object_interface_list_properties*(g_iface: gpointer; 
    n_properties_p: ptr guint): ptr GParamSpec {.
    importc: "g_object_interface_list_properties", libgobj.}
proc g_object_get_type*(): GType {.importc: "g_object_get_type", libgobj.}
proc g_object_new*(object_type: GType; first_property_name: cstring): gpointer {.
    varargs, importc: "g_object_new", libgobj.}
proc g_object_newv*(object_type: GType; n_parameters: guint; 
                    parameters: GParameter): gpointer {.
    importc: "g_object_newv", libgobj.}

discard """ proc "g_object_new_valist*(object_type: GType; first_property_name: cstring; 
                          var_args: va_list): GObject {.
    importc: "g_object_new_valist", libgobj.}"""

proc g_object_set*(`object`: gpointer; first_property_name: cstring) {.
    varargs, importc: "g_object_set", libgobj.}
proc g_object_get*(`object`: gpointer; first_property_name: cstring) {.
    varargs, importc: "g_object_get", libgobj.}
proc g_object_connect*(`object`: gpointer; signal_spec: cstring): gpointer {.
    varargs, importc: "g_object_connect", libgobj.}
proc g_object_disconnect*(`object`: gpointer; signal_spec: cstring) {.varargs, 
    importc: "g_object_disconnect", libgobj.}

discard """ proc "g_object_set_valist*(`object`: GObject; first_property_name: cstring; 
                          var_args: va_list) {.importc: "g_object_set_valist", 
    libgobj.}"""

discard """ proc "g_object_get_valist*(`object`: GObject; first_property_name: cstring; 
                          var_args: va_list) {.importc: "g_object_get_valist", 
    libgobj.}"""

proc set_property*(`object`: GObject; property_name: cstring; 
                            value: GValue) {.
    importc: "g_object_set_property", libgobj.}

proc `property=`*(`object`: GObject; property_name: cstring; 
                            value: GValue) {.
    importc: "g_object_set_property", libgobj.}
proc get_property*(`object`: GObject; property_name: cstring; 
                            value: GValue) {.
    importc: "g_object_get_property", libgobj.}
proc freeze_notify*(`object`: GObject) {.
    importc: "g_object_freeze_notify", libgobj.}
proc notify*(`object`: GObject; property_name: cstring) {.
    importc: "g_object_notify", libgobj.}
proc notify_by_pspec*(`object`: GObject; pspec: GParamSpec) {.
    importc: "g_object_notify_by_pspec", libgobj.}
proc thaw_notify*(`object`: GObject) {.
    importc: "g_object_thaw_notify", libgobj.}
proc g_object_is_floating*(`object`: gpointer): gboolean {.
    importc: "g_object_is_floating", libgobj.}
proc g_object_ref_sink*(`object`: gpointer): gpointer {.
    importc: "g_object_ref_sink", libgobj.}
proc g_object_ref*(`object`: gpointer): gpointer {.importc: "g_object_ref", 
    libgobj.}
proc g_object_unref*(`object`: gpointer) {.importc: "g_object_unref", 
    libgobj.}
proc weak_ref*(`object`: GObject; notify: GWeakNotify; 
                        data: gpointer) {.importc: "g_object_weak_ref", 
    libgobj.}
proc weak_unref*(`object`: GObject; notify: GWeakNotify; 
                          data: gpointer) {.importc: "g_object_weak_unref", 
    libgobj.}
proc add_weak_pointer*(`object`: GObject; 
                                weak_pointer_location: ptr gpointer) {.
    importc: "g_object_add_weak_pointer", libgobj.}
proc remove_weak_pointer*(`object`: GObject; 
                                   weak_pointer_location: ptr gpointer) {.
    importc: "g_object_remove_weak_pointer", libgobj.}
type 
  GToggleNotify* = proc (data: gpointer; `object`: GObject; 
                         is_last_ref: gboolean) {.cdecl.}
proc add_toggle_ref*(`object`: GObject; notify: GToggleNotify; 
                              data: gpointer) {.
    importc: "g_object_add_toggle_ref", libgobj.}
proc remove_toggle_ref*(`object`: GObject; notify: GToggleNotify; 
                                 data: gpointer) {.
    importc: "g_object_remove_toggle_ref", libgobj.}
proc get_qdata*(`object`: GObject; quark: GQuark): gpointer {.
    importc: "g_object_get_qdata", libgobj.}
proc qdata*(`object`: GObject; quark: GQuark): gpointer {.
    importc: "g_object_get_qdata", libgobj.}
proc set_qdata*(`object`: GObject; quark: GQuark; data: gpointer) {.
    importc: "g_object_set_qdata", libgobj.}
proc `qdata=`*(`object`: GObject; quark: GQuark; data: gpointer) {.
    importc: "g_object_set_qdata", libgobj.}
proc set_qdata_full*(`object`: GObject; quark: GQuark; 
                              data: gpointer; destroy: GDestroyNotify) {.
    importc: "g_object_set_qdata_full", libgobj.}
proc `qdata_full=`*(`object`: GObject; quark: GQuark; 
                              data: gpointer; destroy: GDestroyNotify) {.
    importc: "g_object_set_qdata_full", libgobj.}
proc steal_qdata*(`object`: GObject; quark: GQuark): gpointer {.
    importc: "g_object_steal_qdata", libgobj.}
proc dup_qdata*(`object`: GObject; quark: GQuark; 
                         dup_func: GDuplicateFunc; user_data: gpointer): gpointer {.
    importc: "g_object_dup_qdata", libgobj.}
proc replace_qdata*(`object`: GObject; quark: GQuark; 
                             oldval: gpointer; newval: gpointer; 
                             destroy: GDestroyNotify; 
                             old_destroy: ptr GDestroyNotify): gboolean {.
    importc: "g_object_replace_qdata", libgobj.}
proc get_data*(`object`: GObject; key: cstring): gpointer {.
    importc: "g_object_get_data", libgobj.}
proc data*(`object`: GObject; key: cstring): gpointer {.
    importc: "g_object_get_data", libgobj.}
proc set_data*(`object`: GObject; key: cstring; data: gpointer) {.
    importc: "g_object_set_data", libgobj.}
proc `data=`*(`object`: GObject; key: cstring; data: gpointer) {.
    importc: "g_object_set_data", libgobj.}
proc set_data_full*(`object`: GObject; key: cstring; 
                             data: gpointer; destroy: GDestroyNotify) {.
    importc: "g_object_set_data_full", libgobj.}
proc `data_full=`*(`object`: GObject; key: cstring; 
                             data: gpointer; destroy: GDestroyNotify) {.
    importc: "g_object_set_data_full", libgobj.}
proc steal_data*(`object`: GObject; key: cstring): gpointer {.
    importc: "g_object_steal_data", libgobj.}
proc dup_data*(`object`: GObject; key: cstring; 
                        dup_func: GDuplicateFunc; user_data: gpointer): gpointer {.
    importc: "g_object_dup_data", libgobj.}
proc replace_data*(`object`: GObject; key: cstring; 
                            oldval: gpointer; newval: gpointer; 
                            destroy: GDestroyNotify; 
                            old_destroy: ptr GDestroyNotify): gboolean {.
    importc: "g_object_replace_data", libgobj.}
proc watch_closure*(`object`: GObject; closure: GClosure) {.
    importc: "g_object_watch_closure", libgobj.}
proc g_cclosure_new_object*(callback_func: GCallback; `object`: GObject): GClosure {.
    importc: "g_cclosure_new_object", libgobj.}
proc g_cclosure_new_object_swap*(callback_func: GCallback; `object`: GObject): GClosure {.
    importc: "g_cclosure_new_object_swap", libgobj.}
proc g_closure_new_object*(sizeof_closure: guint; `object`: GObject): GClosure {.
    importc: "g_closure_new_object", libgobj.}
proc set_object*(value: GValue; v_object: gpointer) {.
    importc: "g_value_set_object", libgobj.}
proc `object=`*(value: GValue; v_object: gpointer) {.
    importc: "g_value_set_object", libgobj.}
proc get_object*(value: GValue): gpointer {.
    importc: "g_value_get_object", libgobj.}
proc `object`*(value: GValue): gpointer {.
    importc: "g_value_get_object", libgobj.}
proc dup_object*(value: GValue): gpointer {.
    importc: "g_value_dup_object", libgobj.}
proc g_signal_connect_object*(instance: gpointer; detailed_signal: cstring; 
                              c_handler: GCallback; gobject: gpointer; 
                              connect_flags: GConnectFlags): gulong {.
    importc: "g_signal_connect_object", libgobj.}
proc force_floating*(`object`: GObject) {.
    importc: "g_object_force_floating", libgobj.}
proc run_dispose*(`object`: GObject) {.
    importc: "g_object_run_dispose", libgobj.}
proc take_object*(value: GValue; v_object: gpointer) {.
    importc: "g_value_take_object", libgobj.}
proc set_object_take_ownership*(value: GValue; v_object: gpointer) {.
    importc: "g_value_set_object_take_ownership", libgobj.}
proc `object_take_ownership=`*(value: GValue; v_object: gpointer) {.
    importc: "g_value_set_object_take_ownership", libgobj.}
proc g_object_compat_control*(what: gsize; data: gpointer): gsize {.
    importc: "g_object_compat_control", libgobj.}
template g_object_warn_invalid_property_id*(`object`, property_id, pspec: expr): expr = 
  G_OBJECT_WARN_INVALID_PSPEC(`object`, "property", property_id, pspec)

proc g_clear_object*(object_ptr: var GObject) {.importc: "g_clear_object", 
    libgobj.}
template g_clear_object*(object_ptr: expr): expr = 
  g_clear_pointer(object_ptr, g_object_unref)

type 
  INNER_C_UNION_18425212489798725345* = object  {.union.}
    p*: gpointer

type 
  GWeakRef* =  ptr GWeakRefObj
  GWeakRefPtr* = ptr GWeakRefObj
  GWeakRefObj* = object 
    priv*: INNER_C_UNION_18425212489798725345

proc init*(weak_ref: GWeakRef; `object`: gpointer) {.
    importc: "g_weak_ref_init", libgobj.}
proc clear*(weak_ref: GWeakRef) {.importc: "g_weak_ref_clear", 
    libgobj.}
proc get*(weak_ref: GWeakRef): gpointer {.
    importc: "g_weak_ref_get", libgobj.}
proc set*(weak_ref: GWeakRef; `object`: gpointer) {.
    importc: "g_weak_ref_set", libgobj.}

template g_binding*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, binding_get_type(), GBindingObj))

template g_is_binding*(obj: expr): expr = 
  (g_type_check_instance_type(obj, binding_get_type()))

type 
  GBinding* =  ptr GBindingObj
  GBindingPtr* = ptr GBindingObj
  GBindingObj* = object 
  
type 
  GBindingTransformFunc* = proc (binding: GBinding; 
                                 from_value: GValue; to_value: GValue; 
                                 user_data: gpointer): gboolean {.cdecl.}
type 
  GBindingFlags* {.size: sizeof(cint), pure.} = enum 
    DEFAULT = 0, BIDIRECTIONAL = 1 shl 0, 
    SYNC_CREATE = 1 shl 1, INVERT_BOOLEAN = 1 shl 2
proc g_binding_flags_get_type*(): GType {.importc: "g_binding_flags_get_type", 
    libgobj.}
proc g_binding_get_type*(): GType {.importc: "g_binding_get_type", libgobj.}
proc get_flags*(binding: GBinding): GBindingFlags {.
    importc: "g_binding_get_flags", libgobj.}
proc flags*(binding: GBinding): GBindingFlags {.
    importc: "g_binding_get_flags", libgobj.}
proc get_source*(binding: GBinding): GObject {.
    importc: "g_binding_get_source", libgobj.}
proc source*(binding: GBinding): GObject {.
    importc: "g_binding_get_source", libgobj.}
proc get_target*(binding: GBinding): GObject {.
    importc: "g_binding_get_target", libgobj.}
proc target*(binding: GBinding): GObject {.
    importc: "g_binding_get_target", libgobj.}
proc get_source_property*(binding: GBinding): cstring {.
    importc: "g_binding_get_source_property", libgobj.}
proc source_property*(binding: GBinding): cstring {.
    importc: "g_binding_get_source_property", libgobj.}
proc get_target_property*(binding: GBinding): cstring {.
    importc: "g_binding_get_target_property", libgobj.}
proc target_property*(binding: GBinding): cstring {.
    importc: "g_binding_get_target_property", libgobj.}
proc unbind*(binding: GBinding) {.importc: "g_binding_unbind", 
    libgobj.}
proc g_object_bind_property*(source: gpointer; source_property: cstring; 
                             target: gpointer; target_property: cstring; 
                             flags: GBindingFlags): GBinding {.
    importc: "g_object_bind_property", libgobj.}
proc g_object_bind_property_full*(source: gpointer; 
                                  source_property: cstring; 
                                  target: gpointer; 
                                  target_property: cstring; 
                                  flags: GBindingFlags; 
                                  transform_to: GBindingTransformFunc; 
                                  transform_from: GBindingTransformFunc; 
                                  user_data: gpointer; notify: GDestroyNotify): GBinding {.
    importc: "g_object_bind_property_full", libgobj.}
proc g_object_bind_property_with_closures*(source: gpointer; 
    source_property: cstring; target: gpointer; target_property: cstring; 
    flags: GBindingFlags; transform_to: GClosure; 
    transform_from: GClosure): GBinding {.
    importc: "g_object_bind_property_with_closures", libgobj.}

template g_type_is_enum*(`type`: expr): expr = 
  (fundamental(`type`) == G_TYPE_ENUM)

template g_enum_class*(class: expr): expr = 
  (g_type_check_class_cast(class, G_TYPE_ENUM, GEnumClassObj))

template g_is_enum_class*(class: expr): expr = 
  (g_type_check_class_type(class, G_TYPE_ENUM))

template g_enum_class_type*(class: expr): expr = 
  (g_type_from_class(class))

template g_enum_class_type_name*(class: expr): expr = 
  (name(g_enum_class_type(class)))

template g_type_is_flags*(`type`: expr): expr = 
  (fundamental(`type`) == G_TYPE_FLAG)

template g_flags_class*(class: expr): expr = 
  (g_type_check_class_cast(class, G_TYPE_FLAG, GFlagsClassObj))

template g_is_flags_class*(class: expr): expr = 
  (g_type_check_class_type(class, G_TYPE_FLAG))

template g_flags_class_type*(class: expr): expr = 
  (g_type_from_class(class))

template g_flags_class_type_name*(class: expr): expr = 
  (name(g_flags_class_type(class)))

template g_value_holds_enum*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_ENUM))

template g_value_holds_flags*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_FLAG))

type 
  GEnumValue* =  ptr GEnumValueObj
  GEnumValuePtr* = ptr GEnumValueObj
  GEnumValueObj* = object 
    value*: gint
    value_name*: cstring
    value_nick*: cstring
type 
  GEnumClass* =  ptr GEnumClassObj
  GEnumClassPtr* = ptr GEnumClassObj
  GEnumClassObj*{.final.} = object of GTypeClassObj
    minimum*: gint
    maximum*: gint
    n_values*: guint
    values*: GEnumValue

type 
  GFlagsValue* =  ptr GFlagsValueObj
  GFlagsValuePtr* = ptr GFlagsValueObj
  GFlagsValueObj* = object 
    value*: guint
    value_name*: cstring
    value_nick*: cstring
type 
  GFlagsClass* =  ptr GFlagsClassObj
  GFlagsClassPtr* = ptr GFlagsClassObj
  GFlagsClassObj*{.final.} = object of GTypeClassObj
    mask*: guint
    n_values*: guint
    values*: GFlagsValue

proc g_enum_get_value*(enum_class: GEnumClass; value: gint): GEnumValue {.
    importc: "g_enum_get_value", libgobj.}
proc g_enum_get_value_by_name*(enum_class: GEnumClass; name: cstring): GEnumValue {.
    importc: "g_enum_get_value_by_name", libgobj.}
proc g_enum_get_value_by_nick*(enum_class: GEnumClass; nick: cstring): GEnumValue {.
    importc: "g_enum_get_value_by_nick", libgobj.}
proc g_flags_get_first_value*(flags_class: GFlagsClass; value: guint): GFlagsValue {.
    importc: "g_flags_get_first_value", libgobj.}
proc g_flags_get_value_by_name*(flags_class: GFlagsClass; name: cstring): GFlagsValue {.
    importc: "g_flags_get_value_by_name", libgobj.}
proc g_flags_get_value_by_nick*(flags_class: GFlagsClass; nick: cstring): GFlagsValue {.
    importc: "g_flags_get_value_by_nick", libgobj.}
proc set_enum*(value: GValue; v_enum: gint) {.
    importc: "g_value_set_enum", libgobj.}
proc `enum=`*(value: GValue; v_enum: gint) {.
    importc: "g_value_set_enum", libgobj.}
proc get_enum*(value: GValue): gint {.importc: "g_value_get_enum", 
    libgobj.}
proc `enum`*(value: GValue): gint {.importc: "g_value_get_enum", 
    libgobj.}
proc set_flags*(value: GValue; v_flags: guint) {.
    importc: "g_value_set_flags", libgobj.}
proc `flags=`*(value: GValue; v_flags: guint) {.
    importc: "g_value_set_flags", libgobj.}
proc get_flags*(value: GValue): guint {.
    importc: "g_value_get_flags", libgobj.}
proc flags*(value: GValue): guint {.
    importc: "g_value_get_flags", libgobj.}
proc g_enum_register_static*(name: cstring; 
                             const_static_values: GEnumValue): GType {.
    importc: "g_enum_register_static", libgobj.}
proc g_flags_register_static*(name: cstring; 
                              const_static_values: GFlagsValue): GType {.
    importc: "g_flags_register_static", libgobj.}
proc g_enum_complete_type_info*(g_enum_type: GType; info: GTypeInfo; 
                                const_values: GEnumValue) {.
    importc: "g_enum_complete_type_info", libgobj.}
proc g_flags_complete_type_info*(g_flags_type: GType; info: GTypeInfo; 
                                 const_values: GFlagsValue) {.
    importc: "g_flags_complete_type_info", libgobj.}

type 
  GParamSpecChar* =  ptr GParamSpecCharObj
  GParamSpecCharPtr* = ptr GParamSpecCharObj
  GParamSpecCharObj*{.final.} = object of GParamSpecObj
    minimum*: gint8
    maximum*: gint8
    default_value*: gint8

type 
  GParamSpecUChar* =  ptr GParamSpecUCharObj
  GParamSpecUCharPtr* = ptr GParamSpecUCharObj
  GParamSpecUCharObj*{.final.} = object of GParamSpecObj
    minimum*: guint8
    maximum*: guint8
    default_value*: guint8

type 
  GParamSpecBoolean* =  ptr GParamSpecBooleanObj
  GParamSpecBooleanPtr* = ptr GParamSpecBooleanObj
  GParamSpecBooleanObj*{.final.} = object of GParamSpecObj
    default_value*: gboolean

type 
  GParamSpecInt* =  ptr GParamSpecIntObj
  GParamSpecIntPtr* = ptr GParamSpecIntObj
  GParamSpecIntObj*{.final.} = object of GParamSpecObj
    minimum*: gint
    maximum*: gint
    default_value*: gint

type 
  GParamSpecUInt* =  ptr GParamSpecUIntObj
  GParamSpecUIntPtr* = ptr GParamSpecUIntObj
  GParamSpecUIntObj*{.final.} = object of GParamSpecObj
    minimum*: guint
    maximum*: guint
    default_value*: guint

type 
  GParamSpecLong* =  ptr GParamSpecLongObj
  GParamSpecLongPtr* = ptr GParamSpecLongObj
  GParamSpecLongObj*{.final.} = object of GParamSpecObj
    minimum*: glong
    maximum*: glong
    default_value*: glong

type 
  GParamSpecULong* =  ptr GParamSpecULongObj
  GParamSpecULongPtr* = ptr GParamSpecULongObj
  GParamSpecULongObj*{.final.} = object of GParamSpecObj
    minimum*: gulong
    maximum*: gulong
    default_value*: gulong

type 
  GParamSpecInt64* =  ptr GParamSpecInt64Obj
  GParamSpecInt64Ptr* = ptr GParamSpecInt64Obj
  GParamSpecInt64Obj*{.final.} = object of GParamSpecObj
    minimum*: gint64
    maximum*: gint64
    default_value*: gint64

type 
  GParamSpecUInt64* =  ptr GParamSpecUInt64Obj
  GParamSpecUInt64Ptr* = ptr GParamSpecUInt64Obj
  GParamSpecUInt64Obj*{.final.} = object of GParamSpecObj
    minimum*: guint64
    maximum*: guint64
    default_value*: guint64

type 
  GParamSpecUnichar* =  ptr GParamSpecUnicharObj
  GParamSpecUnicharPtr* = ptr GParamSpecUnicharObj
  GParamSpecUnicharObj*{.final.} = object of GParamSpecObj
    default_value*: gunichar

type 
  GParamSpecEnum* =  ptr GParamSpecEnumObj
  GParamSpecEnumPtr* = ptr GParamSpecEnumObj
  GParamSpecEnumObj*{.final.} = object of GParamSpecObj
    enum_class*: GEnumClass
    default_value*: gint

type 
  GParamSpecFlags* =  ptr GParamSpecFlagsObj
  GParamSpecFlagsPtr* = ptr GParamSpecFlagsObj
  GParamSpecFlagsObj*{.final.} = object of GParamSpecObj
    flags_class*: GFlagsClass
    default_value*: guint

type 
  GParamSpecFloat* =  ptr GParamSpecFloatObj
  GParamSpecFloatPtr* = ptr GParamSpecFloatObj
  GParamSpecFloatObj*{.final.} = object of GParamSpecObj
    minimum*: gfloat
    maximum*: gfloat
    default_value*: gfloat
    epsilon*: gfloat

type 
  GParamSpecDouble* =  ptr GParamSpecDoubleObj
  GParamSpecDoublePtr* = ptr GParamSpecDoubleObj
  GParamSpecDoubleObj*{.final.} = object of GParamSpecObj
    minimum*: gdouble
    maximum*: gdouble
    default_value*: gdouble
    epsilon*: gdouble

type 
  GParamSpecString* =  ptr GParamSpecStringObj
  GParamSpecStringPtr* = ptr GParamSpecStringObj
  GParamSpecStringObj*{.final.} = object of GParamSpecObj
    default_value*: cstring
    cset_first*: cstring
    cset_nth*: cstring
    substitutor*: gchar
    bitfield0GParamSpecString*: guint

type 
  GParamSpecParam* =  ptr GParamSpecParamObj
  GParamSpecParamPtr* = ptr GParamSpecParamObj
  GParamSpecParamObj*{.final.} = object of GParamSpecObj

type 
  GParamSpecBoxed* =  ptr GParamSpecBoxedObj
  GParamSpecBoxedPtr* = ptr GParamSpecBoxedObj
  GParamSpecBoxedObj*{.final.} = object of GParamSpecObj

type 
  GParamSpecPointer* =  ptr GParamSpecPointerObj
  GParamSpecPointerPtr* = ptr GParamSpecPointerObj
  GParamSpecPointerObj*{.final.} = object of GParamSpecObj

type 
  GParamSpecValueArray* =  ptr GParamSpecValueArrayObj
  GParamSpecValueArrayPtr* = ptr GParamSpecValueArrayObj
  GParamSpecValueArrayObj*{.final.} = object of GParamSpecObj
    element_spec*: GParamSpec
    fixed_n_elements*: guint

type 
  GParamSpecObject* =  ptr GParamSpecObjectObj
  GParamSpecObjectPtr* = ptr GParamSpecObjectObj
  GParamSpecObjectObj*{.final.} = object of GParamSpecObj

type 
  GParamSpecOverride* =  ptr GParamSpecOverrideObj
  GParamSpecOverridePtr* = ptr GParamSpecOverrideObj
  GParamSpecOverrideObj*{.final.} = object of GParamSpecObj
    overridden*: GParamSpec

type 
  GParamSpecGType* =  ptr GParamSpecGTypeObj
  GParamSpecGTypePtr* = ptr GParamSpecGTypeObj
  GParamSpecGTypeObj*{.final.} = object of GParamSpecObj
    is_a_type*: GType

type 
  GParamSpecVariant* =  ptr GParamSpecVariantObj
  GParamSpecVariantPtr* = ptr GParamSpecVariantObj
  GParamSpecVariantObj*{.final.} = object of GParamSpecObj
    `type`*: GVariantType
    default_value*: GVariant
    padding: array[4, gpointer]

proc g_param_spec_char*(name: cstring; nick: cstring; blurb: cstring; 
                        minimum: gint8; maximum: gint8; default_value: gint8; 
                        flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_char", libgobj.}
proc g_param_spec_uchar*(name: cstring; nick: cstring; blurb: cstring; 
                         minimum: guint8; maximum: guint8; 
                         default_value: guint8; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_uchar", libgobj.}
proc g_param_spec_boolean*(name: cstring; nick: cstring; blurb: cstring; 
                           default_value: gboolean; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_boolean", libgobj.}
proc g_param_spec_int*(name: cstring; nick: cstring; blurb: cstring; 
                       minimum: gint; maximum: gint; default_value: gint; 
                       flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_int", libgobj.}
proc g_param_spec_uint*(name: cstring; nick: cstring; blurb: cstring; 
                        minimum: guint; maximum: guint; default_value: guint; 
                        flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_uint", libgobj.}
proc g_param_spec_long*(name: cstring; nick: cstring; blurb: cstring; 
                        minimum: glong; maximum: glong; default_value: glong; 
                        flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_long", libgobj.}
proc g_param_spec_ulong*(name: cstring; nick: cstring; blurb: cstring; 
                         minimum: gulong; maximum: gulong; 
                         default_value: gulong; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_ulong", libgobj.}
proc g_param_spec_int64*(name: cstring; nick: cstring; blurb: cstring; 
                         minimum: gint64; maximum: gint64; 
                         default_value: gint64; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_int64", libgobj.}
proc g_param_spec_uint64*(name: cstring; nick: cstring; blurb: cstring; 
                          minimum: guint64; maximum: guint64; 
                          default_value: guint64; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_uint64", libgobj.}
proc g_param_spec_unichar*(name: cstring; nick: cstring; blurb: cstring; 
                           default_value: gunichar; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_unichar", libgobj.}
proc g_param_spec_enum*(name: cstring; nick: cstring; blurb: cstring; 
                        enum_type: GType; default_value: gint; 
                        flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_enum", libgobj.}
proc g_param_spec_flags*(name: cstring; nick: cstring; blurb: cstring; 
                         flags_type: GType; default_value: guint; 
                         flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_flags", libgobj.}
proc g_param_spec_float*(name: cstring; nick: cstring; blurb: cstring; 
                         minimum: gfloat; maximum: gfloat; 
                         default_value: gfloat; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_float", libgobj.}
proc g_param_spec_double*(name: cstring; nick: cstring; blurb: cstring; 
                          minimum: gdouble; maximum: gdouble; 
                          default_value: gdouble; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_double", libgobj.}
proc g_param_spec_string*(name: cstring; nick: cstring; blurb: cstring; 
                          default_value: cstring; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_string", libgobj.}
proc g_param_spec_param*(name: cstring; nick: cstring; blurb: cstring; 
                         param_type: GType; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_param", libgobj.}
proc g_param_spec_boxed*(name: cstring; nick: cstring; blurb: cstring; 
                         boxed_type: GType; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_boxed", libgobj.}
proc g_param_spec_pointer*(name: cstring; nick: cstring; blurb: cstring; 
                           flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_pointer", libgobj.}
proc g_param_spec_value_array*(name: cstring; nick: cstring; 
                               blurb: cstring; element_spec: GParamSpec; 
                               flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_value_array", libgobj.}
proc g_param_spec_object*(name: cstring; nick: cstring; blurb: cstring; 
                          object_type: GType; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_object", libgobj.}
proc g_param_spec_override*(name: cstring; overridden: GParamSpec): GParamSpec {.
    importc: "g_param_spec_override", libgobj.}
proc g_param_spec_gtype*(name: cstring; nick: cstring; blurb: cstring; 
                         is_a_type: GType; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_gtype", libgobj.}
proc g_param_spec_variant*(name: cstring; nick: cstring; blurb: cstring; 
                           `type`: GVariantType; 
                           default_value: GVariant; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_variant", libgobj.}

proc set_closure*(source: GSource; closure: GClosure) {.
    importc: "g_source_set_closure", libgobj.}

proc `closure=`*(source: GSource; closure: GClosure) {.
    importc: "g_source_set_closure", libgobj.}
proc set_dummy_callback*(source: GSource) {.
    importc: "g_source_set_dummy_callback", libgobj.}
proc `dummy_callback=`*(source: GSource) {.
    importc: "g_source_set_dummy_callback", libgobj.}

template g_type_module*(module: expr): expr = 
  (g_type_check_instance_cast(module, type_module_get_type(), GTypeModuleObj))

template g_type_module_class*(class: expr): expr = 
  (g_type_check_class_cast(class, type_module_get_type(), GTypeModuleClassObj))

template g_is_type_module*(module: expr): expr = 
  (g_type_check_instance_type(module, type_module_get_type()))

template g_is_type_module_class*(class: expr): expr = 
  (g_type_check_class_type(class, type_module_get_type()))

template g_type_module_get_class*(module: expr): expr = 
  (g_type_instance_get_class(module, type_module_get_type(), GTypeModuleClassObj))

type 
  GTypeModule* =  ptr GTypeModuleObj
  GTypeModulePtr* = ptr GTypeModuleObj
  GTypeModuleObj*{.final.} = object of GObjectObj
    use_count*: guint
    type_infos*: GSList
    interface_infos*: GSList
    name*: cstring

type 
  GTypeModuleClass* =  ptr GTypeModuleClassObj
  GTypeModuleClassPtr* = ptr GTypeModuleClassObj
  GTypeModuleClassObj*{.final.} = object of GObjectClassObj
    load*: proc (module: GTypeModule): gboolean {.cdecl.}
    unload*: proc (module: GTypeModule) {.cdecl.}
    reserved1: proc () {.cdecl.}
    reserved2: proc () {.cdecl.}
    reserved3: proc () {.cdecl.}
    reserved4: proc () {.cdecl.}

template g_implement_interface_dynamic*(TYPE_IFACE, iface_init: expr): stmt = 
  var g_implement_interface_info: GInterfaceInfoObj = [
      cast[GInterfaceInitFunc](iface_init), nil, nil]
  g_type_module_add_interface(type_module, g_define_type_id, TYPE_IFACE, 
                              addr(g_implement_interface_info))

proc g_type_module_get_type*(): GType {.importc: "g_type_module_get_type", 
    libgobj.}
proc use*(module: GTypeModule): gboolean {.
    importc: "g_type_module_use", libgobj.}
proc unuse*(module: GTypeModule) {.
    importc: "g_type_module_unuse", libgobj.}
proc set_name*(module: GTypeModule; name: cstring) {.
    importc: "g_type_module_set_name", libgobj.}
proc `name=`*(module: GTypeModule; name: cstring) {.
    importc: "g_type_module_set_name", libgobj.}
proc register_type*(module: GTypeModule; parent_type: GType; 
                                  type_name: cstring; 
                                  type_info: GTypeInfo; flags: GTypeFlags): GType {.
    importc: "g_type_module_register_type", libgobj.}
proc add_interface*(module: GTypeModule; 
                                  instance_type: GType; interface_type: GType; 
                                  interface_info: GInterfaceInfo) {.
    importc: "g_type_module_add_interface", libgobj.}
proc register_enum*(module: GTypeModule; name: cstring; 
                                  const_static_values: GEnumValue): GType {.
    importc: "g_type_module_register_enum", libgobj.}
proc register_flags*(module: GTypeModule; name: cstring; 
                                   const_static_values: GFlagsValue): GType {.
    importc: "g_type_module_register_flags", libgobj.}

template g_type_plugin*(inst: expr): expr = 
  (g_type_check_instance_cast(inst, type_plugin_get_type(), GTypePluginObj))

template g_type_plugin_class*(vtable: expr): expr = 
  (g_type_check_class_cast(vtable, type_plugin_get_type(), GTypePluginClassObj))

template g_is_type_plugin*(inst: expr): expr = 
  (g_type_check_instance_type(inst, type_plugin_get_type()))

template g_is_type_plugin_class*(vtable: expr): expr = 
  (g_type_check_class_type(vtable, type_plugin_get_type()))

template g_type_plugin_get_class*(inst: expr): expr = 
  (g_type_instance_get_interface(inst, type_plugin_get_type(), GTypePluginClassObj))

type 
  GTypePluginUse* = proc (plugin: GTypePlugin) {.cdecl.}
type 
  GTypePluginUnuse* = proc (plugin: GTypePlugin) {.cdecl.}
type 
  GTypePluginCompleteTypeInfo* = proc (plugin: GTypePlugin; g_type: GType; 
      info: GTypeInfo; value_table: GTypeValueTable) {.cdecl.}
type 
  GTypePluginCompleteInterfaceInfo* = proc (plugin: GTypePlugin; 
      instance_type: GType; interface_type: GType; info: GInterfaceInfo) {.cdecl.}
type 
  GTypePluginClass* =  ptr GTypePluginClassObj
  GTypePluginClassPtr* = ptr GTypePluginClassObj
  GTypePluginClassObj*{.final.} = object of GTypeInterfaceObj
    use_plugin*: GTypePluginUse
    unuse_plugin*: GTypePluginUnuse
    complete_type_info*: GTypePluginCompleteTypeInfo
    complete_interface_info*: GTypePluginCompleteInterfaceInfo

proc g_type_plugin_get_type*(): GType {.importc: "g_type_plugin_get_type", 
    libgobj.}
proc use*(plugin: GTypePlugin) {.
    importc: "g_type_plugin_use", libgobj.}
proc unuse*(plugin: GTypePlugin) {.
    importc: "g_type_plugin_unuse", libgobj.}
proc complete_type_info*(plugin: GTypePlugin; g_type: GType; 
    info: GTypeInfo; value_table: GTypeValueTable) {.
    importc: "g_type_plugin_complete_type_info", libgobj.}
proc complete_interface_info*(plugin: GTypePlugin; 
    instance_type: GType; interface_type: GType; info: GInterfaceInfo) {.
    importc: "g_type_plugin_complete_interface_info", libgobj.}

type 
  GValueArray* =  ptr GValueArrayObj
  GValueArrayPtr* = ptr GValueArrayObj
  GValueArrayObj* = object 
    n_values*: guint
    values*: GValue
    n_prealloced*: guint

proc g_value_array_get_type*(): GType {.importc: "g_value_array_get_type", 
    libgobj.}
proc get_nth*(value_array: GValueArray; index: guint): GValue {.
    importc: "g_value_array_get_nth", libgobj.}
proc nth*(value_array: GValueArray; index: guint): GValue {.
    importc: "g_value_array_get_nth", libgobj.}
proc g_value_array_new*(n_prealloced: guint): GValueArray {.
    importc: "g_value_array_new", libgobj.}
proc free*(value_array: GValueArray) {.
    importc: "g_value_array_free", libgobj.}
proc copy*(value_array: GValueArray): GValueArray {.
    importc: "g_value_array_copy", libgobj.}
proc prepend*(value_array: GValueArray; value: GValue): GValueArray {.
    importc: "g_value_array_prepend", libgobj.}
proc append*(value_array: GValueArray; value: GValue): GValueArray {.
    importc: "g_value_array_append", libgobj.}
proc insert*(value_array: GValueArray; index: guint; 
                           value: GValue): GValueArray {.
    importc: "g_value_array_insert", libgobj.}
proc remove*(value_array: GValueArray; index: guint): GValueArray {.
    importc: "g_value_array_remove", libgobj.}
proc sort*(value_array: GValueArray; 
                         compare_func: GCompareFunc): GValueArray {.
    importc: "g_value_array_sort", libgobj.}
proc sort_with_data*(value_array: GValueArray; 
                                   compare_func: GCompareDataFunc; 
                                   user_data: gpointer): GValueArray {.
    importc: "g_value_array_sort_with_data", libgobj.}

template g_value_holds_char*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_CHAR))

template g_value_holds_uchar*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_UCHAR))

template g_value_holds_boolean*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_BOOLEAN))

template g_value_holds_int*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_INT))

template g_value_holds_uint*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_UINT))

template g_value_holds_long*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_LONG))

template g_value_holds_ulong*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_ULONG))

template g_value_holds_int64*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_INT64))

template g_value_holds_uint64*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_UINT64))

template g_value_holds_float*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_FLOAT))

template g_value_holds_double*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_DOUBLE))

template g_value_holds_string*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_STRING))

template g_value_holds_pointer*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_POINTER))

template g_value_holds_gtype*(value: expr): expr = 
  (g_type_check_value_type(value, gtype_get_type()))

template g_value_holds_variant*(value: expr): expr = 
  (g_type_check_value_type(value, G_TYPE_VARIANT))

proc set_char*(value: GValue; v_char: gchar) {.
    importc: "g_value_set_char", libgobj.}

proc `char=`*(value: GValue; v_char: gchar) {.
    importc: "g_value_set_char", libgobj.}
proc get_char*(value: GValue): gchar {.
    importc: "g_value_get_char", libgobj.}
proc char*(value: GValue): gchar {.
    importc: "g_value_get_char", libgobj.}
proc set_schar*(value: GValue; v_char: gint8) {.
    importc: "g_value_set_schar", libgobj.}
proc `schar=`*(value: GValue; v_char: gint8) {.
    importc: "g_value_set_schar", libgobj.}
proc get_schar*(value: GValue): gint8 {.
    importc: "g_value_get_schar", libgobj.}
proc schar*(value: GValue): gint8 {.
    importc: "g_value_get_schar", libgobj.}
proc set_uchar*(value: GValue; v_uchar: guchar) {.
    importc: "g_value_set_uchar", libgobj.}
proc `uchar=`*(value: GValue; v_uchar: guchar) {.
    importc: "g_value_set_uchar", libgobj.}
proc get_uchar*(value: GValue): guchar {.
    importc: "g_value_get_uchar", libgobj.}
proc uchar*(value: GValue): guchar {.
    importc: "g_value_get_uchar", libgobj.}
proc set_boolean*(value: GValue; v_boolean: gboolean) {.
    importc: "g_value_set_boolean", libgobj.}
proc `boolean=`*(value: GValue; v_boolean: gboolean) {.
    importc: "g_value_set_boolean", libgobj.}
proc get_boolean*(value: GValue): gboolean {.
    importc: "g_value_get_boolean", libgobj.}
proc boolean*(value: GValue): gboolean {.
    importc: "g_value_get_boolean", libgobj.}
proc set_int*(value: GValue; v_int: gint) {.
    importc: "g_value_set_int", libgobj.}
proc `int=`*(value: GValue; v_int: gint) {.
    importc: "g_value_set_int", libgobj.}
proc get_int*(value: GValue): gint {.importc: "g_value_get_int", 
    libgobj.}
proc int*(value: GValue): gint {.importc: "g_value_get_int", 
    libgobj.}
proc set_uint*(value: GValue; v_uint: guint) {.
    importc: "g_value_set_uint", libgobj.}
proc `uint=`*(value: GValue; v_uint: guint) {.
    importc: "g_value_set_uint", libgobj.}
proc get_uint*(value: GValue): guint {.
    importc: "g_value_get_uint", libgobj.}
proc uint*(value: GValue): guint {.
    importc: "g_value_get_uint", libgobj.}
proc set_long*(value: GValue; v_long: glong) {.
    importc: "g_value_set_long", libgobj.}
proc `long=`*(value: GValue; v_long: glong) {.
    importc: "g_value_set_long", libgobj.}
proc get_long*(value: GValue): glong {.
    importc: "g_value_get_long", libgobj.}
proc long*(value: GValue): glong {.
    importc: "g_value_get_long", libgobj.}
proc set_ulong*(value: GValue; v_ulong: gulong) {.
    importc: "g_value_set_ulong", libgobj.}
proc `ulong=`*(value: GValue; v_ulong: gulong) {.
    importc: "g_value_set_ulong", libgobj.}
proc get_ulong*(value: GValue): gulong {.
    importc: "g_value_get_ulong", libgobj.}
proc ulong*(value: GValue): gulong {.
    importc: "g_value_get_ulong", libgobj.}
proc set_int64*(value: GValue; v_int64: gint64) {.
    importc: "g_value_set_int64", libgobj.}
proc `int64=`*(value: GValue; v_int64: gint64) {.
    importc: "g_value_set_int64", libgobj.}
proc get_int64*(value: GValue): gint64 {.
    importc: "g_value_get_int64", libgobj.}
proc int64*(value: GValue): gint64 {.
    importc: "g_value_get_int64", libgobj.}
proc set_uint64*(value: GValue; v_uint64: guint64) {.
    importc: "g_value_set_uint64", libgobj.}
proc `uint64=`*(value: GValue; v_uint64: guint64) {.
    importc: "g_value_set_uint64", libgobj.}
proc get_uint64*(value: GValue): guint64 {.
    importc: "g_value_get_uint64", libgobj.}
proc uint64*(value: GValue): guint64 {.
    importc: "g_value_get_uint64", libgobj.}
proc set_float*(value: GValue; v_float: gfloat) {.
    importc: "g_value_set_float", libgobj.}
proc `float=`*(value: GValue; v_float: gfloat) {.
    importc: "g_value_set_float", libgobj.}
proc get_float*(value: GValue): gfloat {.
    importc: "g_value_get_float", libgobj.}
proc float*(value: GValue): gfloat {.
    importc: "g_value_get_float", libgobj.}
proc set_double*(value: GValue; v_double: gdouble) {.
    importc: "g_value_set_double", libgobj.}
proc `double=`*(value: GValue; v_double: gdouble) {.
    importc: "g_value_set_double", libgobj.}
proc get_double*(value: GValue): gdouble {.
    importc: "g_value_get_double", libgobj.}
proc double*(value: GValue): gdouble {.
    importc: "g_value_get_double", libgobj.}
proc set_string*(value: GValue; v_string: cstring) {.
    importc: "g_value_set_string", libgobj.}
proc `string=`*(value: GValue; v_string: cstring) {.
    importc: "g_value_set_string", libgobj.}
proc set_static_string*(value: GValue; v_string: cstring) {.
    importc: "g_value_set_static_string", libgobj.}
proc `static_string=`*(value: GValue; v_string: cstring) {.
    importc: "g_value_set_static_string", libgobj.}
proc get_string*(value: GValue): cstring {.
    importc: "g_value_get_string", libgobj.}
proc string*(value: GValue): cstring {.
    importc: "g_value_get_string", libgobj.}
proc dup_string*(value: GValue): cstring {.
    importc: "g_value_dup_string", libgobj.}
proc set_pointer*(value: GValue; v_pointer: gpointer) {.
    importc: "g_value_set_pointer", libgobj.}
proc `pointer=`*(value: GValue; v_pointer: gpointer) {.
    importc: "g_value_set_pointer", libgobj.}
proc get_pointer*(value: GValue): gpointer {.
    importc: "g_value_get_pointer", libgobj.}
proc pointer*(value: GValue): gpointer {.
    importc: "g_value_get_pointer", libgobj.}
proc g_gtype_get_type*(): GType {.importc: "g_gtype_get_type", libgobj.}
proc set_gtype*(value: GValue; v_gtype: GType) {.
    importc: "g_value_set_gtype", libgobj.}
proc `gtype=`*(value: GValue; v_gtype: GType) {.
    importc: "g_value_set_gtype", libgobj.}
proc get_gtype*(value: GValue): GType {.
    importc: "g_value_get_gtype", libgobj.}
proc gtype*(value: GValue): GType {.
    importc: "g_value_get_gtype", libgobj.}
proc set_variant*(value: GValue; variant: GVariant) {.
    importc: "g_value_set_variant", libgobj.}
proc `variant=`*(value: GValue; variant: GVariant) {.
    importc: "g_value_set_variant", libgobj.}
proc take_variant*(value: GValue; variant: GVariant) {.
    importc: "g_value_take_variant", libgobj.}
proc get_variant*(value: GValue): GVariant {.
    importc: "g_value_get_variant", libgobj.}
proc variant*(value: GValue): GVariant {.
    importc: "g_value_get_variant", libgobj.}
proc dup_variant*(value: GValue): GVariant {.
    importc: "g_value_dup_variant", libgobj.}
proc g_pointer_type_register_static*(name: cstring): GType {.
    importc: "g_pointer_type_register_static", libgobj.}
proc g_strdup_value_contents*(value: GValue): cstring {.
    importc: "g_strdup_value_contents", libgobj.}
proc take_string*(value: GValue; v_string: cstring) {.
    importc: "g_value_take_string", libgobj.}
proc set_string_take_ownership*(value: GValue; v_string: cstring) {.
    importc: "g_value_set_string_take_ownership", libgobj.}
proc `string_take_ownership=`*(value: GValue; v_string: cstring) {.
    importc: "g_value_set_string_take_ownership", libgobj.}
type 
  gchararray* = cstring

{.deprecated: [PGTypePlugin: GTypePlugin, TGTypePlugin: GTypePluginObj].}
{.deprecated: [PGTypeClass: GTypeClass, TGTypeClass: GTypeClassObj].}
{.deprecated: [PGTypeInstance: GTypeInstance, TGTypeInstance: GTypeInstanceObj].}
{.deprecated: [PGTypeInterface: GTypeInterface, TGTypeInterface: GTypeInterfaceObj].}
{.deprecated: [PGTypeQuery: GTypeQuery, TGTypeQuery: GTypeQueryObj].}
{.deprecated: [PGTypeFundamentalInfo: GTypeFundamentalInfo, TGTypeFundamentalInfo: GTypeFundamentalInfoObj].}
{.deprecated: [PGInterfaceInfo: GInterfaceInfo, TGInterfaceInfo: GInterfaceInfoObj].}
{.deprecated: [PGValue: GValue, TGValue: GValueObj].}
{.deprecated: [PGTypeValueTable: GTypeValueTable, TGTypeValueTable: GTypeValueTableObj].}
{.deprecated: [PGTypeInfo: GTypeInfo, TGTypeInfo: GTypeInfoObj].}
{.deprecated: [PGParamSpecPool: GParamSpecPool, TGParamSpecPool: GParamSpecPoolObj].}
{.deprecated: [PGParamSpec: GParamSpec, TGParamSpec: GParamSpecObj].}
{.deprecated: [PGParamSpecClass: GParamSpecClass, TGParamSpecClass: GParamSpecClassObj].}
{.deprecated: [PGParameter: GParameter, TGParameter: GParameterObj].}
{.deprecated: [PGParamSpecTypeInfo: GParamSpecTypeInfo, TGParamSpecTypeInfo: GParamSpecTypeInfoObj].}
{.deprecated: [PGClosureNotifyData: GClosureNotifyData, TGClosureNotifyData: GClosureNotifyDataObj].}
{.deprecated: [PGClosure: GClosure, TGClosure: GClosureObj].}
{.deprecated: [PGCClosure: GCClosure, TGCClosure: GCClosureObj].}
{.deprecated: [PGSignalInvocationHint: GSignalInvocationHint, TGSignalInvocationHint: GSignalInvocationHintObj].}
{.deprecated: [PGSignalQuery: GSignalQuery, TGSignalQuery: GSignalQueryObj].}
{.deprecated: [PGObject: GObject, TGObject: GObjectObj].}
{.deprecated: [PGObjectClass: GObjectClass, TGObjectClass: GObjectClassObj].}
{.deprecated: [PGObjectConstructParam: GObjectConstructParam, TGObjectConstructParam: GObjectConstructParamObj].}
{.deprecated: [PGWeakRef: GWeakRef, TGWeakRef: GWeakRefObj].}
{.deprecated: [PGBinding: GBinding, TGBinding: GBindingObj].}
{.deprecated: [PGEnumValue: GEnumValue, TGEnumValue: GEnumValueObj].}
{.deprecated: [PGEnumClass: GEnumClass, TGEnumClass: GEnumClassObj].}
{.deprecated: [PGFlagsValue: GFlagsValue, TGFlagsValue: GFlagsValueObj].}
{.deprecated: [PGFlagsClass: GFlagsClass, TGFlagsClass: GFlagsClassObj].}
{.deprecated: [PGParamSpecChar: GParamSpecChar, TGParamSpecChar: GParamSpecCharObj].}
{.deprecated: [PGParamSpecUChar: GParamSpecUChar, TGParamSpecUChar: GParamSpecUCharObj].}
{.deprecated: [PGParamSpecBoolean: GParamSpecBoolean, TGParamSpecBoolean: GParamSpecBooleanObj].}
{.deprecated: [PGParamSpecInt: GParamSpecInt, TGParamSpecInt: GParamSpecIntObj].}
{.deprecated: [PGParamSpecUInt: GParamSpecUInt, TGParamSpecUInt: GParamSpecUIntObj].}
{.deprecated: [PGParamSpecLong: GParamSpecLong, TGParamSpecLong: GParamSpecLongObj].}
{.deprecated: [PGParamSpecULong: GParamSpecULong, TGParamSpecULong: GParamSpecULongObj].}
{.deprecated: [PGParamSpecInt64: GParamSpecInt64, TGParamSpecInt64: GParamSpecInt64Obj].}
{.deprecated: [PGParamSpecUInt64: GParamSpecUInt64, TGParamSpecUInt64: GParamSpecUInt64Obj].}
{.deprecated: [PGParamSpecUnichar: GParamSpecUnichar, TGParamSpecUnichar: GParamSpecUnicharObj].}
{.deprecated: [PGParamSpecEnum: GParamSpecEnum, TGParamSpecEnum: GParamSpecEnumObj].}
{.deprecated: [PGParamSpecFlags: GParamSpecFlags, TGParamSpecFlags: GParamSpecFlagsObj].}
{.deprecated: [PGParamSpecFloat: GParamSpecFloat, TGParamSpecFloat: GParamSpecFloatObj].}
{.deprecated: [PGParamSpecDouble: GParamSpecDouble, TGParamSpecDouble: GParamSpecDoubleObj].}
{.deprecated: [PGParamSpecString: GParamSpecString, TGParamSpecString: GParamSpecStringObj].}
{.deprecated: [PGParamSpecParam: GParamSpecParam, TGParamSpecParam: GParamSpecParamObj].}
{.deprecated: [PGParamSpecBoxed: GParamSpecBoxed, TGParamSpecBoxed: GParamSpecBoxedObj].}
{.deprecated: [PGParamSpecPointer: GParamSpecPointer, TGParamSpecPointer: GParamSpecPointerObj].}
{.deprecated: [PGParamSpecValueArray: GParamSpecValueArray, TGParamSpecValueArray: GParamSpecValueArrayObj].}
{.deprecated: [PGParamSpecObject: GParamSpecObject, TGParamSpecObject: GParamSpecObjectObj].}
{.deprecated: [PGParamSpecOverride: GParamSpecOverride, TGParamSpecOverride: GParamSpecOverrideObj].}
{.deprecated: [PGParamSpecGType: GParamSpecGType, TGParamSpecGType: GParamSpecGTypeObj].}
{.deprecated: [PGParamSpecVariant: GParamSpecVariant, TGParamSpecVariant: GParamSpecVariantObj].}
{.deprecated: [PGTypeModule: GTypeModule, TGTypeModule: GTypeModuleObj].}
{.deprecated: [PGTypeModuleClass: GTypeModuleClass, TGTypeModuleClass: GTypeModuleClassObj].}
{.deprecated: [PGTypePluginClass: GTypePluginClass, TGTypePluginClass: GTypePluginClassObj].}
{.deprecated: [PGValueArray: GValueArray, TGValueArray: GValueArrayObj].}
{.deprecated: [PGInitiallyUnowned: GInitiallyUnowned, TGInitiallyUnowned: GInitiallyUnownedObj].}
{.deprecated: [PGInitiallyUnownedClass: GInitiallyUnownedClass, TGInitiallyUnownedClass: GInitiallyUnownedClassObj].}
{.deprecated: [TGTypeDebugFlags: GTypeDebugFlags].}
{.deprecated: [TGTypeFundamentalFlags: GTypeFundamentalFlags].}
{.deprecated: [TGTypeFlags: GTypeFlags].}
{.deprecated: [TGParamFlags: GParamFlags].}
{.deprecated: [TGSignalFlags: GSignalFlags].}
{.deprecated: [TGConnectFlags: GConnectFlags].}
{.deprecated: [TGSignalMatchType: GSignalMatchType].}
{.deprecated: [TGBindingFlags: GBindingFlags].}
{.deprecated: [g_type_name: name].}
{.deprecated: [g_type_qname: qname].}
{.deprecated: [g_type_parent: parent].}
{.deprecated: [g_type_depth: depth].}
{.deprecated: [g_type_next_base: next_base].}
{.deprecated: [g_type_is_a: is_a].}
{.deprecated: [g_type_class_ref: class_ref].}
{.deprecated: [g_type_class_peek: class_peek].}
{.deprecated: [g_type_class_peek_static: class_peek_static].}
{.deprecated: [g_type_default_interface_ref: default_interface_ref].}
{.deprecated: [g_type_default_interface_peek: default_interface_peek].}
{.deprecated: [g_type_children: children].}
{.deprecated: [g_type_interfaces: interfaces].}
{.deprecated: [g_type_set_qdata: set_qdata].}
{.deprecated: [g_type_get_qdata: get_qdata].}
{.deprecated: [g_type_query: query].}
{.deprecated: [g_type_register_static: register_static].}
{.deprecated: [g_type_register_static_simple: register_static_simple].}
{.deprecated: [g_type_register_dynamic: register_dynamic].}
{.deprecated: [g_type_register_fundamental: register_fundamental].}
{.deprecated: [g_type_add_interface_static: add_interface_static].}
{.deprecated: [g_type_add_interface_dynamic: add_interface_dynamic].}
{.deprecated: [g_type_interface_add_prerequisite: interface_add_prerequisite].}
{.deprecated: [g_type_interface_prerequisites: interface_prerequisites].}
{.deprecated: [g_type_add_instance_private: add_instance_private].}
{.deprecated: [g_type_add_class_private: add_class_private].}
{.deprecated: [g_type_ensure: ensure].}
{.deprecated: [g_type_get_plugin: get_plugin].}
{.deprecated: [g_type_interface_get_plugin: interface_get_plugin].}
{.deprecated: [g_type_fundamental: fundamental].}
{.deprecated: [g_type_create_instance: create_instance].}
{.deprecated: [g_type_value_table_peek: value_table_peek].}
{.deprecated: [g_type_check_is_value_type: check_is_value_type].}
{.deprecated: [g_type_test_flags: test_flags].}
{.deprecated: [g_value_init: init].}
{.deprecated: [g_value_copy: copy].}
{.deprecated: [g_value_reset: reset].}
{.deprecated: [g_value_unset: unset].}
{.deprecated: [g_value_set_instance: set_instance].}
{.deprecated: [g_value_init_from_instance: init_from_instance].}
{.deprecated: [g_value_fits_pointer: fits_pointer].}
{.deprecated: [g_value_peek_pointer: peek_pointer].}
{.deprecated: [g_value_transform: transform].}
{.deprecated: [g_param_spec_ref: `ref`].}
{.deprecated: [g_param_spec_unref: unref].}
{.deprecated: [g_param_spec_sink: sink].}
{.deprecated: [g_param_spec_ref_sink: ref_sink].}
{.deprecated: [g_param_spec_get_qdata: get_qdata].}
{.deprecated: [g_param_spec_set_qdata: set_qdata].}
{.deprecated: [g_param_spec_set_qdata_full: set_qdata_full].}
{.deprecated: [g_param_spec_steal_qdata: steal_qdata].}
{.deprecated: [g_param_spec_get_redirect_target: get_redirect_target].}
{.deprecated: [g_param_value_set_default: value_set_default].}
{.deprecated: [g_param_value_defaults: value_defaults].}
{.deprecated: [g_param_value_validate: value_validate].}
{.deprecated: [g_param_value_convert: value_convert].}
{.deprecated: [g_param_values_cmp: values_cmp].}
{.deprecated: [g_param_spec_get_name: get_name].}
{.deprecated: [g_param_spec_get_nick: get_nick].}
{.deprecated: [g_param_spec_get_blurb: get_blurb].}
{.deprecated: [g_value_set_param: set_param].}
{.deprecated: [g_value_get_param: get_param].}
{.deprecated: [g_value_dup_param: dup_param].}
{.deprecated: [g_value_take_param: take_param].}
{.deprecated: [g_value_set_param_take_ownership: set_param_take_ownership].}
{.deprecated: [g_param_spec_get_default_value: get_default_value].}
{.deprecated: [g_param_spec_pool_insert: insert].}
{.deprecated: [g_param_spec_pool_remove: remove].}
{.deprecated: [g_param_spec_pool_lookup: lookup].}
{.deprecated: [g_param_spec_pool_list_owned: list_owned].}
{.deprecated: [g_param_spec_pool_list: list].}
{.deprecated: [g_closure_ref: `ref`].}
{.deprecated: [g_closure_sink: sink].}
{.deprecated: [g_closure_unref: unref].}
{.deprecated: [g_closure_add_finalize_notifier: add_finalize_notifier].}
{.deprecated: [g_closure_remove_finalize_notifier: remove_finalize_notifier].}
{.deprecated: [g_closure_add_invalidate_notifier: add_invalidate_notifier].}
{.deprecated: [g_closure_remove_invalidate_notifier: remove_invalidate_notifier].}
{.deprecated: [g_closure_add_marshal_guards: add_marshal_guards].}
{.deprecated: [g_closure_set_marshal: set_marshal].}
{.deprecated: [g_closure_set_meta_marshal: set_meta_marshal].}
{.deprecated: [g_closure_invalidate: invalidate].}
{.deprecated: [g_closure_invoke: invoke].}
{.deprecated: [g_cclosure_marshal_generic: marshal_generic].}
{.deprecated: [g_cclosure_marshal_VOID_VOID: marshal_VOID_VOID].}
{.deprecated: [g_cclosure_marshal_VOID_BOOLEAN: marshal_VOID_BOOLEAN].}
{.deprecated: [g_cclosure_marshal_VOID_CHAR: marshal_VOID_CHAR].}
{.deprecated: [g_cclosure_marshal_VOID_UCHAR: marshal_VOID_UCHAR].}
{.deprecated: [g_cclosure_marshal_VOID_INT: marshal_VOID_INT].}
{.deprecated: [g_cclosure_marshal_VOID_UINT: marshal_VOID_UINT].}
{.deprecated: [g_cclosure_marshal_VOID_LONG: marshal_VOID_LONG].}
{.deprecated: [g_cclosure_marshal_VOID_ULONG: marshal_VOID_ULONG].}
{.deprecated: [g_cclosure_marshal_VOID_ENUM: marshal_VOID_ENUM].}
{.deprecated: [g_cclosure_marshal_VOID_FLAGS: marshal_VOID_FLAGS].}
{.deprecated: [g_cclosure_marshal_VOID_FLOAT: marshal_VOID_FLOAT].}
{.deprecated: [g_cclosure_marshal_VOID_DOUBLE: marshal_VOID_DOUBLE].}
{.deprecated: [g_cclosure_marshal_VOID_STRING: marshal_VOID_STRING].}
{.deprecated: [g_cclosure_marshal_VOID_PARAM: marshal_VOID_PARAM].}
{.deprecated: [g_cclosure_marshal_VOID_BOXED: marshal_VOID_BOXED].}
{.deprecated: [g_cclosure_marshal_VOID_POINTER: marshal_VOID_POINTER].}
{.deprecated: [g_cclosure_marshal_VOID_OBJECT: marshal_VOID_OBJECT].}
{.deprecated: [g_cclosure_marshal_VOID_VARIANT: marshal_VOID_VARIANT].}
{.deprecated: [g_cclosure_marshal_VOID_UINT_POINTER: marshal_VOID_UINT_POINTER].}
{.deprecated: [g_cclosure_marshal_BOOLEAN_FLAGS: marshal_BOOLEAN_FLAGS].}
{.deprecated: [g_cclosure_marshal_STRING_OBJECT_POINTER: marshal_STRING_OBJECT_POINTER].}
{.deprecated: [g_cclosure_marshal_BOOLEAN_BOXED_BOXED: marshal_BOOLEAN_BOXED_BOXED].}
{.deprecated: [g_value_set_boxed: set_boxed].}
{.deprecated: [g_value_set_static_boxed: set_static_boxed].}
{.deprecated: [g_value_take_boxed: take_boxed].}
{.deprecated: [g_value_set_boxed_take_ownership: set_boxed_take_ownership].}
{.deprecated: [g_value_get_boxed: get_boxed].}
{.deprecated: [g_value_dup_boxed: dup_boxed].}
{.deprecated: [g_object_class_install_property: install_property].}
{.deprecated: [g_object_class_find_property: find_property].}
{.deprecated: [g_object_class_list_properties: list_properties].}
{.deprecated: [g_object_class_override_property: override_property].}
{.deprecated: [g_object_class_install_properties: install_properties].}
{.deprecated: [g_object_set_property: set_property].}
{.deprecated: [g_object_get_property: get_property].}
{.deprecated: [g_object_freeze_notify: freeze_notify].}
{.deprecated: [g_object_notify: notify].}
{.deprecated: [g_object_notify_by_pspec: notify_by_pspec].}
{.deprecated: [g_object_thaw_notify: thaw_notify].}
{.deprecated: [g_object_weak_ref: weak_ref].}
{.deprecated: [g_object_weak_unref: weak_unref].}
{.deprecated: [g_object_add_weak_pointer: add_weak_pointer].}
{.deprecated: [g_object_remove_weak_pointer: remove_weak_pointer].}
{.deprecated: [g_object_add_toggle_ref: add_toggle_ref].}
{.deprecated: [g_object_remove_toggle_ref: remove_toggle_ref].}
{.deprecated: [g_object_get_qdata: get_qdata].}
{.deprecated: [g_object_set_qdata: set_qdata].}
{.deprecated: [g_object_set_qdata_full: set_qdata_full].}
{.deprecated: [g_object_steal_qdata: steal_qdata].}
{.deprecated: [g_object_dup_qdata: dup_qdata].}
{.deprecated: [g_object_replace_qdata: replace_qdata].}
{.deprecated: [g_object_get_data: get_data].}
{.deprecated: [g_object_set_data: set_data].}
{.deprecated: [g_object_set_data_full: set_data_full].}
{.deprecated: [g_object_steal_data: steal_data].}
{.deprecated: [g_object_dup_data: dup_data].}
{.deprecated: [g_object_replace_data: replace_data].}
{.deprecated: [g_object_watch_closure: watch_closure].}
{.deprecated: [g_value_set_object: set_object].}
{.deprecated: [g_value_get_object: get_object].}
{.deprecated: [g_value_dup_object: dup_object].}
{.deprecated: [g_object_force_floating: force_floating].}
{.deprecated: [g_object_run_dispose: run_dispose].}
{.deprecated: [g_value_take_object: take_object].}
{.deprecated: [g_value_set_object_take_ownership: set_object_take_ownership].}
{.deprecated: [g_weak_ref_init: init].}
{.deprecated: [g_weak_ref_clear: clear].}
{.deprecated: [g_weak_ref_get: get].}
{.deprecated: [g_weak_ref_set: set].}
{.deprecated: [g_binding_get_flags: get_flags].}
{.deprecated: [g_binding_get_source: get_source].}
{.deprecated: [g_binding_get_target: get_target].}
{.deprecated: [g_binding_get_source_property: get_source_property].}
{.deprecated: [g_binding_get_target_property: get_target_property].}
{.deprecated: [g_binding_unbind: unbind].}
{.deprecated: [g_value_set_enum: set_enum].}
{.deprecated: [g_value_get_enum: get_enum].}
{.deprecated: [g_value_set_flags: set_flags].}
{.deprecated: [g_value_get_flags: get_flags].}
{.deprecated: [g_source_set_closure: set_closure].}
{.deprecated: [g_source_set_dummy_callback: set_dummy_callback].}
{.deprecated: [g_type_module_use: use].}
{.deprecated: [g_type_module_unuse: unuse].}
{.deprecated: [g_type_module_set_name: set_name].}
{.deprecated: [g_type_module_register_type: register_type].}
{.deprecated: [g_type_module_add_interface: add_interface].}
{.deprecated: [g_type_module_register_enum: register_enum].}
{.deprecated: [g_type_module_register_flags: register_flags].}
{.deprecated: [g_type_plugin_use: use].}
{.deprecated: [g_type_plugin_unuse: unuse].}
{.deprecated: [g_type_plugin_complete_type_info: complete_type_info].}
{.deprecated: [g_type_plugin_complete_interface_info: complete_interface_info].}
{.deprecated: [g_value_array_get_nth: get_nth].}
{.deprecated: [g_value_array_free: free].}
{.deprecated: [g_value_array_copy: copy].}
{.deprecated: [g_value_array_prepend: prepend].}
{.deprecated: [g_value_array_append: append].}
{.deprecated: [g_value_array_insert: insert].}
{.deprecated: [g_value_array_remove: remove].}
{.deprecated: [g_value_array_sort: sort].}
{.deprecated: [g_value_array_sort_with_data: sort_with_data].}
{.deprecated: [g_value_set_char: set_char].}
{.deprecated: [g_value_get_char: get_char].}
{.deprecated: [g_value_set_schar: set_schar].}
{.deprecated: [g_value_get_schar: get_schar].}
{.deprecated: [g_value_set_uchar: set_uchar].}
{.deprecated: [g_value_get_uchar: get_uchar].}
{.deprecated: [g_value_set_boolean: set_boolean].}
{.deprecated: [g_value_get_boolean: get_boolean].}
{.deprecated: [g_value_set_int: set_int].}
{.deprecated: [g_value_get_int: get_int].}
{.deprecated: [g_value_set_uint: set_uint].}
{.deprecated: [g_value_get_uint: get_uint].}
{.deprecated: [g_value_set_long: set_long].}
{.deprecated: [g_value_get_long: get_long].}
{.deprecated: [g_value_set_ulong: set_ulong].}
{.deprecated: [g_value_get_ulong: get_ulong].}
{.deprecated: [g_value_set_int64: set_int64].}
{.deprecated: [g_value_get_int64: get_int64].}
{.deprecated: [g_value_set_uint64: set_uint64].}
{.deprecated: [g_value_get_uint64: get_uint64].}
{.deprecated: [g_value_set_float: set_float].}
{.deprecated: [g_value_get_float: get_float].}
{.deprecated: [g_value_set_double: set_double].}
{.deprecated: [g_value_get_double: get_double].}
{.deprecated: [g_value_set_string: set_string].}
{.deprecated: [g_value_set_static_string: set_static_string].}
{.deprecated: [g_value_get_string: get_string].}
{.deprecated: [g_value_dup_string: dup_string].}
{.deprecated: [g_value_set_pointer: set_pointer].}
{.deprecated: [g_value_get_pointer: get_pointer].}
{.deprecated: [g_value_set_gtype: set_gtype].}
{.deprecated: [g_value_get_gtype: get_gtype].}
{.deprecated: [g_value_set_variant: set_variant].}
{.deprecated: [g_value_take_variant: take_variant].}
{.deprecated: [g_value_get_variant: get_variant].}
{.deprecated: [g_value_dup_variant: dup_variant].}
{.deprecated: [g_value_take_string: take_string].}
{.deprecated: [g_value_set_string_take_ownership: set_string_take_ownership].}
