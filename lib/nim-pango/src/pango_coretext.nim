{.deadCodeElim: on.}
import pango
from glib import guint, GHashTable, gpointer, gconstpointer, guint32, gdouble, gboolean
from gobject import GType
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  CTFontRef = ptr object # dummy objects!
  CTFontDescriptorRef = ptr object

template pango_core_text_font*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, core_text_font_get_type(), 
                              CoreTextFontObj))

template pango_is_core_text_font*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, core_text_font_get_type()))

when ENABLE_ENGINE or ENABLE_BACKEND: 
  const 
    RENDER_TYPE_CORE_TEXT* = "RenderCoreText"
  when ENABLE_BACKEND: 
    template pango_core_text_font_class*(klass: expr): expr = 
      (g_type_check_class_cast(klass, core_text_font_get_type(), 
                               CoreTextFontClassObj))

    template pango_is_core_text_font_class*(klass: expr): expr = 
      (g_type_check_class_type(klass, core_text_font_get_type()))

    template pango_core_text_font_get_class*(obj: expr): expr = 
      (g_type_instance_get_class(obj, core_text_font_get_type(), 
                                 CoreTextFontClassObj))

    type 
      CoreTextFontPrivateObj = object 
      
    type 
      CoreTextFont* =  ptr CoreTextFontObj
      CoreTextFontPtr* = ptr CoreTextFontObj
      CoreTextFontObj*{.final.} = object of FontObj
        priv*: ptr CoreTextFontPrivateObj

    type 
      CoreTextFontClass* =  ptr CoreTextFontClassObj
      CoreTextFontClassPtr* = ptr CoreTextFontClassObj
      CoreTextFontClassObj*{.final.} = object of FontClassObj
        pango_reserved1: proc () {.cdecl.}
        pango_reserved2: proc () {.cdecl.}
        pango_reserved3: proc () {.cdecl.}
        pango_reserved4: proc () {.cdecl.}

  proc get_ctfont*(font: CoreTextFont): CTFontRef {.
      importc: "pango_core_text_font_get_ctfont", libpango.}

  proc ctfont*(font: CoreTextFont): CTFontRef {.
      importc: "pango_core_text_font_get_ctfont", libpango.}
proc core_text_font_get_type*(): GType {.
    importc: "pango_core_text_font_get_type", libpango.}

template pango_core_text_font_map*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, core_text_font_map_get_type(), 
                              CoreTextFontMapObj))

template pango_core_text_is_font_map*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, core_text_font_map_get_type()))

template pango_core_text_font_map_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, core_text_font_map_get_type(), 
                           CoreTextFontMapClassObj))

template pango_is_core_text_font_map_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, core_text_font_map_get_type()))

template pango_core_text_font_map_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, core_text_font_map_get_type(), 
                             CoreTextFontMapClassObj))

type 
  CoreTextFace* =  ptr CoreTextFaceObj
  CoreTextFacePtr* = ptr CoreTextFaceObj
  CoreTextFaceObj* = object 
  
  CoreTextFontKey* =  ptr CoreTextFontKeyObj
  CoreTextFontKeyPtr* = ptr CoreTextFontKeyObj
  CoreTextFontKeyObj* = object 
  
type 
  CoreTextFontMap* =  ptr CoreTextFontMapObj
  CoreTextFontMapPtr* = ptr CoreTextFontMapObj
  CoreTextFontMapObj* = object of FontMapObj
    serial*: guint
    fontset_hash*: glib.GHashTable
    font_hash*: glib.GHashTable
    families*: glib.GHashTable

type 
  CoreTextFontMapClass* =  ptr CoreTextFontMapClassObj
  CoreTextFontMapClassPtr* = ptr CoreTextFontMapClassObj
  CoreTextFontMapClassObj*{.final.} = object of FontMapClassObj
    context_key_get*: proc (ctfontmap: CoreTextFontMap; 
                            context: Context): gconstpointer {.cdecl.}
    context_key_copy*: proc (ctfontmap: CoreTextFontMap; 
                             key: gconstpointer): gpointer {.cdecl.}
    context_key_free*: proc (ctfontmap: CoreTextFontMap; 
                             key: gpointer) {.cdecl.}
    context_key_hash*: proc (ctfontmap: CoreTextFontMap; 
                             key: gconstpointer): guint32 {.cdecl.}
    context_key_equal*: proc (ctfontmap: CoreTextFontMap; 
                              key_a: gconstpointer; key_b: gconstpointer): gboolean {.cdecl.}
    create_font*: proc (fontmap: CoreTextFontMap; 
                        key: CoreTextFontKey): CoreTextFont {.cdecl.}
    get_resolution*: proc (fontmap: CoreTextFontMap; 
                           context: Context): cdouble {.cdecl.}

proc core_text_font_map_get_type*(): GType {.
    importc: "pango_core_text_font_map_get_type", libpango.}
proc get_absolute_size*(key: CoreTextFontKey): cint {.
    importc: "pango_core_text_font_key_get_absolute_size", libpango.}
proc absolute_size*(key: CoreTextFontKey): cint {.
    importc: "pango_core_text_font_key_get_absolute_size", libpango.}
proc get_resolution*(key: CoreTextFontKey): cdouble {.
    importc: "pango_core_text_font_key_get_resolution", libpango.}
proc resolution*(key: CoreTextFontKey): cdouble {.
    importc: "pango_core_text_font_key_get_resolution", libpango.}
proc get_synthetic_italic*(
    key: CoreTextFontKey): gboolean {.
    importc: "pango_core_text_font_key_get_synthetic_italic", libpango.}
proc synthetic_italic*(
    key: CoreTextFontKey): gboolean {.
    importc: "pango_core_text_font_key_get_synthetic_italic", libpango.}
proc get_context_key*(key: CoreTextFontKey): gpointer {.
    importc: "pango_core_text_font_key_get_context_key", libpango.}
proc context_key*(key: CoreTextFontKey): gpointer {.
    importc: "pango_core_text_font_key_get_context_key", libpango.}
proc get_matrix*(key: CoreTextFontKey): Matrix {.
    importc: "pango_core_text_font_key_get_matrix", libpango.}
proc matrix*(key: CoreTextFontKey): Matrix {.
    importc: "pango_core_text_font_key_get_matrix", libpango.}
proc get_gravity*(key: CoreTextFontKey): Gravity {.
    importc: "pango_core_text_font_key_get_gravity", libpango.}
proc gravity*(key: CoreTextFontKey): Gravity {.
    importc: "pango_core_text_font_key_get_gravity", libpango.}
proc get_ctfontdescriptor*(
    key: CoreTextFontKey): CTFontDescriptorRef {.
    importc: "pango_core_text_font_key_get_ctfontdescriptor", libpango.}
proc ctfontdescriptor*(
    key: CoreTextFontKey): CTFontDescriptorRef {.
    importc: "pango_core_text_font_key_get_ctfontdescriptor", libpango.}

template pango_cairo_core_text_font_map*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, cairo_core_text_font_map_get_type(), 
                              CairoCoreTextFontMapObj))

template pango_is_cairo_core_text_font_map*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, cairo_core_text_font_map_get_type()))

type 
  CairoCoreTextFontMap* =  ptr CairoCoreTextFontMapObj
  CairoCoreTextFontMapPtr* = ptr CairoCoreTextFontMapObj
  CairoCoreTextFontMapObj*{.final.} = object of CoreTextFontMapObj
    serial_cairo*: guint
    dpi*: gdouble

proc cairo_core_text_font_map_get_type*(): GType {.
    importc: "pango_cairo_core_text_font_map_get_type", libpango.}
