{.deadCodeElim: on.}
import pango
from glib import gpointer, GSList, guint, guint32, gunichar, gconstpointer, gboolean, GDestroyNotify
from gobject import GType, GObjectObj, GObjectClassObj
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  FT_Face = ptr object # dummy objects!
  FcPattern = object
  FcCharSet = object

template pango_fc_font*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, fc_font_get_type(), FcFontObj))

template pango_is_fc_font*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, fc_font_get_type()))

when ENABLE_ENGINE or ENABLE_BACKEND: 
  const 
    RENDER_TYPE_FC* = "RenderFc"
  when ENABLE_BACKEND: 
    template pango_fc_font_class*(klass: expr): expr = 
      (g_type_check_class_cast(klass, fc_font_get_type(), FcFontClassObj))

    template pango_is_fc_font_class*(klass: expr): expr = 
      (g_type_check_class_type(klass, fc_font_get_type()))

    template pango_fc_font_get_class*(obj: expr): expr = 
      (g_type_instance_get_class(obj, fc_font_get_type(), FcFontClassObj))

    type 
      FcFont* =  ptr FcFontObj
      FcFontPtr* = ptr FcFontObj
      FcFontObj*{.final.} = object of FontObj
        font_pattern*: ptr FcPattern
        fontmap*: FontMap
        priv*: gpointer
        matrix*: MatrixObj
        description*: FontDescription
        metrics_by_lang*: glib.GSList
        bitfield0PangoFcFont*: guint

    type 
      FcFontClass* =  ptr FcFontClassObj
      FcFontClassPtr* = ptr FcFontClassObj
      FcFontClassObj*{.final.} = object of FontClassObj
        lock_face*: proc (font: FcFont): FT_Face {.cdecl.}
        unlock_face*: proc (font: FcFont) {.cdecl.}
        has_char*: proc (font: FcFont; wc: gunichar): gboolean {.cdecl.}
        get_glyph*: proc (font: FcFont; wc: gunichar): guint {.cdecl.}
        get_unknown_glyph*: proc (font: FcFont; wc: gunichar): Glyph {.cdecl.}
        shutdown*: proc (font: FcFont) {.cdecl.}
        pango_reserved1: proc () {.cdecl.}
        pango_reserved2: proc () {.cdecl.}
        pango_reserved3: proc () {.cdecl.}
        pango_reserved4: proc () {.cdecl.}

  proc has_char*(font: FcFont; wc: gunichar): gboolean {.
      importc: "pango_fc_font_has_char", libpango.}
  proc get_glyph*(font: FcFont; wc: gunichar): guint {.
      importc: "pango_fc_font_get_glyph", libpango.}
  proc glyph*(font: FcFont; wc: gunichar): guint {.
      importc: "pango_fc_font_get_glyph", libpango.}
  when not DISABLE_DEPRECATED: 
    proc get_unknown_glyph*(font: FcFont; wc: gunichar): Glyph {.
        importc: "pango_fc_font_get_unknown_glyph", libpango.}
    proc unknown_glyph*(font: FcFont; wc: gunichar): Glyph {.
        importc: "pango_fc_font_get_unknown_glyph", libpango.}
    proc kern_glyphs*(font: FcFont; 
                                    glyphs: GlyphString) {.
        importc: "pango_fc_font_kern_glyphs", libpango.}
proc fc_font_get_type*(): GType {.importc: "pango_fc_font_get_type", 
    libpango.}
proc lock_face*(font: FcFont): FT_Face {.
    importc: "pango_fc_font_lock_face", libpango.}
proc unlock_face*(font: FcFont) {.
    importc: "pango_fc_font_unlock_face", libpango.}

template pango_fc_decoder*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, fc_decoder_get_type(), FcDecoderObj))

template pango_is_fc_decoder*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, fc_decoder_get_type()))

template pango_fc_decoder_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, fc_decoder_get_type(), FcDecoderClassObj))

template pango_is_fc_decoder_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, fc_decoder_get_type()))

template pango_fc_decoder_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, fc_decoder_get_type(), FcDecoderClassObj))

type 
  FcDecoder* =  ptr FcDecoderObj
  FcDecoderPtr* = ptr FcDecoderObj
  FcDecoderObj*{.final.} = object of GObjectObj

type 
  FcDecoderClass* =  ptr FcDecoderClassObj
  FcDecoderClassPtr* = ptr FcDecoderClassObj
  FcDecoderClassObj*{.final.} = object of GObjectClassObj
    get_charset*: proc (decoder: FcDecoder; fcfont: FcFont): ptr FcCharSet {.cdecl.}
    get_glyph*: proc (decoder: FcDecoder; fcfont: FcFont; 
                      wc: guint32): Glyph {.cdecl.}
    pango_reserved1: proc () {.cdecl.}
    pango_reserved2: proc () {.cdecl.}
    pango_reserved3: proc () {.cdecl.}
    pango_reserved4: proc () {.cdecl.}

proc fc_decoder_get_type*(): GType {.
    importc: "pango_fc_decoder_get_type", libpango.}
proc get_charset*(decoder: FcDecoder; 
                                   fcfont: FcFont): ptr FcCharSet {.
    importc: "pango_fc_decoder_get_charset", libpango.}
proc charset*(decoder: FcDecoder; 
                                   fcfont: FcFont): ptr FcCharSet {.
    importc: "pango_fc_decoder_get_charset", libpango.}
proc get_glyph*(decoder: FcDecoder; 
                                 fcfont: FcFont; wc: guint32): Glyph {.
    importc: "pango_fc_decoder_get_glyph", libpango.}
proc glyph*(decoder: FcDecoder; 
                                 fcfont: FcFont; wc: guint32): Glyph {.
    importc: "pango_fc_decoder_get_glyph", libpango.}

when ENABLE_BACKEND: 
  type 
    FcFontsetKey* =  ptr FcFontsetKeyObj
    FcFontsetKeyPtr* = ptr FcFontsetKeyObj
    FcFontsetKeyObj* = object 
    
  proc get_language*(key: FcFontsetKey): Language {.
      importc: "pango_fc_fontset_key_get_language", libpango.}
    
  proc language*(key: FcFontsetKey): Language {.
      importc: "pango_fc_fontset_key_get_language", libpango.}
  proc get_description*(key: FcFontsetKey): FontDescription {.
      importc: "pango_fc_fontset_key_get_description", libpango.}
  proc description*(key: FcFontsetKey): FontDescription {.
      importc: "pango_fc_fontset_key_get_description", libpango.}
  proc get_matrix*(key: FcFontsetKey): Matrix {.
      importc: "pango_fc_fontset_key_get_matrix", libpango.}
  proc matrix*(key: FcFontsetKey): Matrix {.
      importc: "pango_fc_fontset_key_get_matrix", libpango.}
  proc get_absolute_size*(key: FcFontsetKey): cdouble {.
      importc: "pango_fc_fontset_key_get_absolute_size", libpango.}
  proc absolute_size*(key: FcFontsetKey): cdouble {.
      importc: "pango_fc_fontset_key_get_absolute_size", libpango.}
  proc get_resolution*(key: FcFontsetKey): cdouble {.
      importc: "pango_fc_fontset_key_get_resolution", libpango.}
  proc resolution*(key: FcFontsetKey): cdouble {.
      importc: "pango_fc_fontset_key_get_resolution", libpango.}
  proc get_context_key*(key: FcFontsetKey): gpointer {.
      importc: "pango_fc_fontset_key_get_context_key", libpango.}
  proc context_key*(key: FcFontsetKey): gpointer {.
      importc: "pango_fc_fontset_key_get_context_key", libpango.}
  type 
    FcFontKey* =  ptr FcFontKeyObj
    FcFontKeyPtr* = ptr FcFontKeyObj
    FcFontKeyObj* = object 
    
  proc get_pattern*(key: FcFontKey): ptr FcPattern {.
      importc: "pango_fc_font_key_get_pattern", libpango.}
    
  proc pattern*(key: FcFontKey): ptr FcPattern {.
      importc: "pango_fc_font_key_get_pattern", libpango.}
  proc get_matrix*(key: FcFontKey): Matrix {.
      importc: "pango_fc_font_key_get_matrix", libpango.}
  proc matrix*(key: FcFontKey): Matrix {.
      importc: "pango_fc_font_key_get_matrix", libpango.}
  proc get_context_key*(key: FcFontKey): gpointer {.
      importc: "pango_fc_font_key_get_context_key", libpango.}
  proc context_key*(key: FcFontKey): gpointer {.
      importc: "pango_fc_font_key_get_context_key", libpango.}
template pango_fc_font_map*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, fc_font_map_get_type(), FcFontMapObj))

template pango_is_fc_font_map*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, fc_font_map_get_type()))

type 
  FcFontMapPrivateObj = object 
  
when ENABLE_BACKEND: 
  template pango_fc_font_map_class*(klass: expr): expr = 
    (g_type_check_class_cast(klass, fc_font_map_get_type(), 
                             FcFontMapClassObj))

  template pango_is_fc_font_map_class*(klass: expr): expr = 
    (g_type_check_class_type(klass, fc_font_map_get_type()))

  template pango_fc_font_map_get_class*(obj: expr): expr = 
    (g_type_instance_get_class(obj, fc_font_map_get_type(), 
                               FcFontMapClassObj))

  type 
    FcFontMap* =  ptr FcFontMapObj
    FcFontMapPtr* = ptr FcFontMapObj
    FcFontMapObj*{.final.} = object of FontMapObj
      priv*: ptr FcFontMapPrivateObj

  type 
    FcFontMapClass* =  ptr FcFontMapClassObj
    FcFontMapClassPtr* = ptr FcFontMapClassObj
    FcFontMapClassObj*{.final.} = object of FontMapClassObj
      default_substitute*: proc (fontmap: FcFontMap; 
                                 pattern: ptr FcPattern) {.cdecl.}
      new_font*: proc (fontmap: FcFontMap; pattern: ptr FcPattern): FcFont {.cdecl.}
      get_resolution*: proc (fcfontmap: FcFontMap; 
                             context: Context): cdouble {.cdecl.}
      context_key_get*: proc (fcfontmap: FcFontMap; 
                              context: Context): gconstpointer {.cdecl.}
      context_key_copy*: proc (fcfontmap: FcFontMap; 
                               key: gconstpointer): gpointer {.cdecl.}
      context_key_free*: proc (fcfontmap: FcFontMap; key: gpointer) {.cdecl.}
      context_key_hash*: proc (fcfontmap: FcFontMap; 
                               key: gconstpointer): guint32 {.cdecl.}
      context_key_equal*: proc (fcfontmap: FcFontMap; 
                                key_a: gconstpointer; key_b: gconstpointer): gboolean {.cdecl.}
      fontset_key_substitute*: proc (fontmap: FcFontMap; 
                                     fontsetkey: FcFontsetKey; 
                                     pattern: ptr FcPattern) {.cdecl.}
      create_font*: proc (fontmap: FcFontMap; 
                          fontkey: FcFontKey): FcFont {.cdecl.}
      pango_reserved1: proc () {.cdecl.}
      pango_reserved2: proc () {.cdecl.}
      pango_reserved3: proc () {.cdecl.}
      pango_reserved4: proc () {.cdecl.}

  when not DISABLE_DEPRECATED: 
    proc create_context*(fcfontmap: FcFontMap): Context {.
        importc: "pango_fc_font_map_create_context", libpango.}
  proc shutdown*(fcfontmap: FcFontMap) {.
      importc: "pango_fc_font_map_shutdown", libpango.}
proc fc_font_map_get_type*(): GType {.
    importc: "pango_fc_font_map_get_type", libpango.}
proc cache_clear*(fcfontmap: FcFontMap) {.
    importc: "pango_fc_font_map_cache_clear", libpango.}
type 
  FcDecoderFindFunc* = proc (pattern: ptr FcPattern; user_data: gpointer): FcDecoder {.cdecl.}
proc add_decoder_find_func*(fcfontmap: FcFontMap; 
    findfunc: FcDecoderFindFunc; user_data: gpointer; 
    dnotify: GDestroyNotify) {.importc: "pango_fc_font_map_add_decoder_find_func", 
                               libpango.}
proc find_decoder*(fcfontmap: FcFontMap; 
                                     pattern: ptr FcPattern): FcDecoder {.
    importc: "pango_fc_font_map_find_decoder", libpango.}
proc fc_font_description_from_pattern*(pattern: ptr FcPattern; 
    include_size: gboolean): FontDescription {.
    importc: "pango_fc_font_description_from_pattern", libpango.}
const 
  FC_GRAVITY* = "pangogravity"
const 
  FC_VERSION* = "pangoversion"
const 
  FC_PRGNAME* = "prgname"
const 
  FC_FONT_FEATURES* = "fontfeatures"
