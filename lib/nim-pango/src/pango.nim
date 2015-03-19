{.deadCodeElim: on.}

# Note: Not all pango C macros are available in Nim yet.
# Some are converted by c2nim to templates, some manually to procs.
# Most of these should be not necessary for Nim programmers.
# We may have to add more and to test and fix some, or remove unnecessary ones completely...
# pango-color-table.h and pango-script-lang-table.h is currently not included.

from glib import guint8, guint16, gint32, guint32, gint, guint, gushort, gulong, gchar, guchar, gunichar, gdouble,
  gboolean, gpointer, gconstpointer, GList, GSList, GString, GError, GDestroyNotify, GMarkupParseContext, G_MAXUINT

from gobject import GObjectObj, GObjectClassObj, GType, GTypeModule,
  g_type_check_class_type, g_type_check_class_cast, g_type_check_instance_cast, g_type_check_instance_type

when defined(windows): 
  const LIB_PANGO* = "libpango-1.0-0.dll"
elif defined(macosx):
  const LIB_PANGO* = "libpango-1.0.dylib"
else: 
  const LIB_PANGO* = "libpango-1.0.so.0"

{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}

const
  DISABLE_DEPRECATED* = false
  ENABLE_BACKEND* = true
  ENABLE_ENGINE* = true

const 
  VERSION_MAJOR* = 1
  VERSION_MINOR* = 36
  VERSION_MICRO* = 8
  VERSION_STRING* = "1.36.8"

type 
  Coverage* =  ptr CoverageObj
  CoveragePtr* = ptr CoverageObj
  CoverageObj* = object 
  
type 
  CoverageLevel* {.size: sizeof(cint), pure.} = enum 
    NONE, FALLBACK, APPROXIMATE, 
    EXACT
proc coverage_new*(): Coverage {.importc: "pango_coverage_new", 
    libpango.}
proc `ref`*(coverage: Coverage): Coverage {.
    importc: "pango_coverage_ref", libpango.}
proc unref*(coverage: Coverage) {.
    importc: "pango_coverage_unref", libpango.}
proc copy*(coverage: Coverage): Coverage {.
    importc: "pango_coverage_copy", libpango.}
proc get*(coverage: Coverage; index: cint): CoverageLevel {.
    importc: "pango_coverage_get", libpango.}
proc set*(coverage: Coverage; index: cint; 
                         level: CoverageLevel) {.
    importc: "pango_coverage_set", libpango.}
proc max*(coverage: Coverage; other: Coverage) {.
    importc: "pango_coverage_max", libpango.}
proc to_bytes*(coverage: Coverage; 
                              bytes: var ptr guchar; n_bytes: var cint) {.
    importc: "pango_coverage_to_bytes", libpango.}
proc coverage_from_bytes*(bytes: ptr guchar; n_bytes: cint): Coverage {.
    importc: "pango_coverage_from_bytes", libpango.}

type 
  Glyph* = guint32
type 
  GlyphUnit* = gint32
type 
  GlyphGeometry* =  ptr GlyphGeometryObj
  GlyphGeometryPtr* = ptr GlyphGeometryObj
  GlyphGeometryObj* = object 
    width*: GlyphUnit
    x_offset*: GlyphUnit
    y_offset*: GlyphUnit

type 
  GlyphVisAttr* =  ptr GlyphVisAttrObj
  GlyphVisAttrPtr* = ptr GlyphVisAttrObj
  GlyphVisAttrObj* = object 
    bitfield0PangoGlyphVisAttr*: guint

type 
  GlyphInfo* =  ptr GlyphInfoObj
  GlyphInfoPtr* = ptr GlyphInfoObj
  GlyphInfoObj* = object 
    glyph*: Glyph
    geometry*: GlyphGeometryObj
    attr*: GlyphVisAttrObj

type 
  GlyphString* =  ptr GlyphStringObj
  GlyphStringPtr* = ptr GlyphStringObj
  GlyphStringObj* = object 
    num_glyphs*: gint
    glyphs*: GlyphInfo
    log_clusters*: var gint
    space*: gint
const 
  SCALE* = 1024
template pango_pixels*(d: expr): expr = 
  ((int(d) + 512) shr 10)

template pango_pixels_floor*(d: expr): expr = 
  ((int(d)) shr 10)

template pango_pixels_ceil*(d: expr): expr = 
  ((int(d) + 1023) shr 10)

template pango_units_round*(d: expr): expr = 
  ((d + (SCALE shr 1)) and not (SCALE - 1))

proc units_from_double*(d: cdouble): cint {.
    importc: "pango_units_from_double", libpango.}
proc units_to_double*(i: cint): cdouble {.
    importc: "pango_units_to_double", libpango.}
type 
  Rectangle* =  ptr RectangleObj
  RectanglePtr* = ptr RectangleObj
  RectangleObj* = object 
    x*: cint
    y*: cint
    width*: cint
    height*: cint
converter PRO2PCP(o: var RectangleObj): Rectangle =
  addr(o)

template pango_ascent*(rect: expr): expr = 
  (- (rect).y)

template pango_descent*(rect: expr): expr = 
  (rect.y + (rect).height)

template pango_lbearing*(rect: expr): expr = 
  (rect.x)

template pango_rbearing*(rect: expr): expr = 
  (rect.x + (rect).width)

proc extents_to_pixels*(inclusive: Rectangle; 
                              nearest: Rectangle) {.
    importc: "pango_extents_to_pixels", libpango.}

type 
  Matrix* =  ptr MatrixObj
  MatrixPtr* = ptr MatrixObj
  MatrixObj* = object 
    xx*: cdouble
    xy*: cdouble
    yx*: cdouble
    yy*: cdouble
    x0*: cdouble
    y0*: cdouble
converter PMO2PMP(o: var MatrixObj): Matrix =
  addr(o)
type 
  Gravity* {.size: sizeof(cint), pure.} = enum 
    SOUTH, EAST, NORTH, 
    WEST, AUTO
type 
  GravityHint* {.size: sizeof(cint), pure.} = enum 
    NATURAL, STRONG, 
    LINE
template pango_gravity_is_vertical*(gravity: expr): expr = 
  (gravity == GRAVITY_EAST or (gravity) == GRAVITY_WEST)

template pango_gravity_is_improper*(gravity: expr): expr = 
  (gravity == GRAVITY_WEST or (gravity) == GRAVITY_NORTH)

proc to_rotation*(gravity: Gravity): cdouble {.
    importc: "pango_gravity_to_rotation", libpango.}
proc gravity_get_for_matrix*(matrix: Matrix): Gravity {.
    importc: "pango_gravity_get_for_matrix", libpango.}

proc matrix_get_type*(): GType {.importc: "pango_matrix_get_type", 
    libpango.}
proc copy*(matrix: Matrix): Matrix {.
    importc: "pango_matrix_copy", libpango.}
proc free*(matrix: Matrix) {.
    importc: "pango_matrix_free", libpango.}
proc translate*(matrix: Matrix; tx: cdouble; ty: cdouble) {.
    importc: "pango_matrix_translate", libpango.}
proc scale*(matrix: Matrix; scale_x: cdouble; 
                         scale_y: cdouble) {.importc: "pango_matrix_scale", 
    libpango.}
proc rotate*(matrix: Matrix; degrees: cdouble) {.
    importc: "pango_matrix_rotate", libpango.}
proc concat*(matrix: Matrix; new_matrix: Matrix) {.
    importc: "pango_matrix_concat", libpango.}
proc transform_point*(matrix: Matrix; x: var cdouble; 
                                   y: var cdouble) {.
    importc: "pango_matrix_transform_point", libpango.}
proc transform_distance*(matrix: Matrix; 
                                      dx: var cdouble; dy: var cdouble) {.
    importc: "pango_matrix_transform_distance", libpango.}
proc transform_rectangle*(matrix: Matrix; 
    rect: Rectangle) {.importc: "pango_matrix_transform_rectangle", 
                                libpango.}
proc transform_pixel_rectangle*(matrix: Matrix; 
    rect: Rectangle) {.importc: "pango_matrix_transform_pixel_rectangle", 
                                libpango.}
proc get_font_scale_factor*(matrix: Matrix): cdouble {.
    importc: "pango_matrix_get_font_scale_factor", libpango.}
proc font_scale_factor*(matrix: Matrix): cdouble {.
    importc: "pango_matrix_get_font_scale_factor", libpango.}

type 
  ScriptIter* =  ptr ScriptIterObj
  ScriptIterPtr* = ptr ScriptIterObj
  ScriptIterObj* = object 
  
type 
  Script* {.size: sizeof(cint), pure.} = enum 
    INVALID_CODE = - 1, COMMON = 0, 
    INHERITED, ARABIC, ARMENIAN, 
    BENGALI, BOPOMOFO, CHEROKEE, 
    COPTIC, CYRILLIC, DESERET, 
    DEVANAGARI, ETHIOPIC, GEORGIAN, 
    GOTHIC, GREEK, GUJARATI, 
    GURMUKHI, HAN, HANGUL, 
    HEBREW, HIRAGANA, KANNADA, 
    KATAKANA, KHMER, LAO, 
    LATIN, MALAYALAM, MONGOLIAN, 
    MYANMAR, OGHAM, OLD_ITALIC, 
    ORIYA, RUNIC, SINHALA, 
    SYRIAC, TAMIL, TELUGU, 
    THAANA, THAI, TIBETAN, 
    CANADIAN_ABORIGINAL, YI, TAGALOG, 
    HANUNOO, BUHID, TAGBANWA, 
    BRAILLE, CYPRIOT, LIMBU, 
    OSMANYA, SHAVIAN, LINEAR_B, 
    TAI_LE, UGARITIC, NEW_TAI_LUE, 
    BUGINESE, GLAGOLITIC, TIFINAGH, 
    SYLOTI_NAGRI, OLD_PERSIAN, 
    KHAROSHTHI, UNKNOWN, BALINESE, 
    CUNEIFORM, PHOENICIAN, PHAGS_PA, 
    NKO, KAYAH_LI, LEPCHA, 
    REJANG, SUNDANESE, SAURASHTRA, 
    CHAM, OL_CHIKI, VAI, 
    CARIAN, LYCIAN, LYDIAN, 
    BATAK, BRAHMI, MANDAIC, 
    CHAKMA, MEROITIC_CURSIVE, 
    MEROITIC_HIEROGLYPHS, MIAO, 
    SHARADA, SORA_SOMPENG, TAKRI
proc gravity_get_for_script*(script: Script; 
                                   base_gravity: Gravity; 
                                   hint: GravityHint): Gravity {.
    importc: "pango_gravity_get_for_script", libpango.}
proc gravity_get_for_script_and_width*(script: Script; 
    wide: gboolean; base_gravity: Gravity; hint: GravityHint): Gravity {.
    importc: "pango_gravity_get_for_script_and_width", libpango.}
proc script_for_unichar*(ch: gunichar): Script {.
    importc: "pango_script_for_unichar", libpango.}
proc script_iter_new*(text: cstring; length: cint): ScriptIter {.
    importc: "pango_script_iter_new", libpango.}
proc get_range*(iter: ScriptIter; 
                                  start: cstringArray; `end`: cstringArray; 
                                  script: ptr Script) {.
    importc: "pango_script_iter_get_range", libpango.}
proc next*(iter: ScriptIter): gboolean {.
    importc: "pango_script_iter_next", libpango.}
proc free*(iter: ScriptIter) {.
    importc: "pango_script_iter_free", libpango.}
type 
  Language* =  ptr LanguageObj
  LanguagePtr* = ptr LanguageObj
  LanguageObj* = object 
proc get_sample_language*(script: Script): Language {.
    importc: "pango_script_get_sample_language", libpango.}
proc sample_language*(script: Script): Language {.
    importc: "pango_script_get_sample_language", libpango.}

  
proc language_get_type*(): GType {.importc: "pango_language_get_type", 
    libpango.}
proc language_from_string*(language: cstring): Language {.
    importc: "pango_language_from_string", libpango.}
proc to_string*(language: Language): cstring {.
    importc: "pango_language_to_string", libpango.}
template pango_language_to_string*(language: expr): expr = 
  (cast[cstring](language))

proc get_sample_string*(language: Language): cstring {.
    importc: "pango_language_get_sample_string", libpango.}

proc sample_string*(language: Language): cstring {.
    importc: "pango_language_get_sample_string", libpango.}
proc language_get_default*(): Language {.
    importc: "pango_language_get_default", libpango.}
proc matches*(language: Language; range_list: cstring): gboolean {.
    importc: "pango_language_matches", libpango.}
proc includes_script*(language: Language; 
                                     script: Script): gboolean {.
    importc: "pango_language_includes_script", libpango.}
proc get_scripts*(language: Language; 
                                 num_scripts: var cint): ptr Script {.
    importc: "pango_language_get_scripts", libpango.}
proc scripts*(language: Language; 
                                 num_scripts: var cint): ptr Script {.
    importc: "pango_language_get_scripts", libpango.}

type 
  BidiType* {.size: sizeof(cint), pure.} = enum 
    L, LRE, LRO, 
    R, AL, RLE, 
    RLO, PDF, EN, 
    ES, ET, AN, 
    CS, NSM, BN, 
    B, S, WS, 
    ON
proc bidi_type_for_unichar*(ch: gunichar): BidiType {.
    importc: "pango_bidi_type_for_unichar", libpango.}
type 
  Direction* {.size: sizeof(cint), pure.} = enum 
    LTR, RTL, TTB_LTR, 
    TTB_RTL, WEAK_LTR, 
    WEAK_RTL, NEUTRAL
proc unichar_direction*(ch: gunichar): Direction {.
    importc: "pango_unichar_direction", libpango.}
proc find_base_dir*(text: cstring; length: gint): Direction {.
    importc: "pango_find_base_dir", libpango.}
when not DISABLE_DEPRECATED: 
  proc get_mirror_char*(ch: gunichar; mirrored_ch: var gunichar): gboolean {.
      importc: "pango_get_mirror_char", libpango.}

type 
  FontDescription* =  ptr FontDescriptionObj
  FontDescriptionPtr* = ptr FontDescriptionObj
  FontDescriptionObj* = object 
  
when ENABLE_ENGINE: 
  type 
    Engine* =  ptr EngineObj
    EnginePtr* = ptr EngineObj
    EngineObj* = object of GObjectObj
  type 
    EngineShape* =  ptr EngineShapeObj
    EngineShapePtr* = ptr EngineShapeObj
    EngineShapeObj*{.final.} = object of EngineObj
    EngineLang* =  ptr EngineLangObj
    EngineLangPtr* = ptr EngineLangObj
    EngineLangObj*{.final.} = object of EngineObj
else:
  type 
    EngineShape* =  ptr EngineShapeObj
    EngineShapePtr* = ptr EngineShapeObj
    EngineShapeObj* = object 
  type 
    Engine* =  ptr EngineObj
    EnginePtr* = ptr EngineObj
    EngineObj* = object 
  type 
    EngineLang* =  ptr EngineLangObj
    EngineLangPtr* = ptr EngineLangObj
    EngineLangObj* = object 

when ENABLE_BACKEND: 
  type 
    Font* =  ptr FontObj
    FontPtr* = ptr FontObj
    FontObj* = object of GObjectObj
  type 
    FontMap* =  ptr FontMapObj
    FontMapPtr* = ptr FontMapObj
    FontMapObj* = object of GObjectObj
else:
  type 
    Font* =  ptr FontObj
    FontPtr* = ptr FontObj
    FontObj* = object 
  type 
    FontMap* =  ptr FontMapObj
    FontMapPtr* = ptr FontMapObj
    FontMapObj* = object 

type 
  Analysis* =  ptr AnalysisObj
  AnalysisPtr* = ptr AnalysisObj
  AnalysisObj* = object 
    shape_engine*: EngineShape
    lang_engine*: EngineLang
    font*: Font
    level*: guint8
    gravity*: guint8
    flags*: guint8
    script*: guint8
    language*: Language
    extra_attrs*: glib.GSList
type 
  LogAttr* =  ptr LogAttrObj
  LogAttrPtr* = ptr LogAttrObj
  LogAttrObj* = object 
    bitfield0PangoLogAttr*: guint

type 
  Style* {.size: sizeof(cint), pure.} = enum 
    NORMAL, OBLIQUE, ITALIC
type 
  Variant* {.size: sizeof(cint), pure.} = enum 
    NORMAL, SMALL_CAPS
type 
  Weight* {.size: sizeof(cint), pure.} = enum 
    THIN = 100, ULTRALIGHT = 200, 
    LIGHT = 300, SEMILIGHT = 350, 
    BOOK = 380, NORMAL = 400, 
    MEDIUM = 500, SEMIBOLD = 600, 
    BOLD = 700, ULTRABOLD = 800, 
    HEAVY = 900, ULTRAHEAVY = 1000
type 
  Stretch* {.size: sizeof(cint), pure.} = enum 
    ULTRA_CONDENSED, EXTRA_CONDENSED, 
    CONDENSED, SEMI_CONDENSED, 
    NORMAL, SEMI_EXPANDED, EXPANDED, 
    EXTRA_EXPANDED, ULTRA_EXPANDED
type 
  FontMask* {.size: sizeof(cint), pure.} = enum 
    FAMILY = 1 shl 0, STYLE = 1 shl 1, 
    VARIANT = 1 shl 2, WEIGHT = 1 shl 3, 
    STRETCH = 1 shl 4, SIZE = 1 shl 5, 
    GRAVITY = 1 shl 6
const 
  SCALE_XX_SMALL* = cdouble(0.5787037037036999)
  SCALE_X_SMALL* = cdouble(0.6444444444444)
  SCALE_SMALL* = cdouble(0.8333333333333)
  SCALE_MEDIUM* = cdouble(1.0)
  SCALE_LARGE* = cdouble(1.2)
  SCALE_X_LARGE* = cdouble(1.4399999999999)
  SCALE_XX_LARGE* = cdouble(1.728)
when ENABLE_BACKEND: 
  type 
    FontMetrics* =  ptr FontMetricsObj
    FontMetricsPtr* = ptr FontMetricsObj
    FontMetricsObj* = object 
      ref_count*: guint
      ascent*: cint
      descent*: cint
      approximate_char_width*: cint
      approximate_digit_width*: cint
      underline_position*: cint
      underline_thickness*: cint
      strikethrough_position*: cint
      strikethrough_thickness*: cint
  proc font_metrics_new*(): FontMetrics {.
      importc: "pango_font_metrics_new", libpango.}
else:
  type
    FontMetrics* =  ptr FontMetricsObj
    FontMetricsPtr* = ptr FontMetricsObj
    FontMetricsObj* = object 
proc font_description_get_type*(): GType {.
    importc: "pango_font_description_get_type", libpango.}
proc font_description_new*(): FontDescription {.
    importc: "pango_font_description_new", libpango.}
proc copy*(desc: FontDescription): FontDescription {.
    importc: "pango_font_description_copy", libpango.}
proc copy_static*(desc: FontDescription): FontDescription {.
    importc: "pango_font_description_copy_static", libpango.}
proc hash*(desc: FontDescription): guint {.
    importc: "pango_font_description_hash", libpango.}
proc equal*(desc1: FontDescription; 
                                   desc2: FontDescription): gboolean {.
    importc: "pango_font_description_equal", libpango.}
proc free*(desc: FontDescription) {.
    importc: "pango_font_description_free", libpango.}
proc font_descriptions_free*(descs: var FontDescription; 
                                   n_descs: cint) {.
    importc: "pango_font_descriptions_free", libpango.}
proc set_family*(desc: FontDescription; 
    family: cstring) {.importc: "pango_font_description_set_family", 
                       libpango.}
proc `family=`*(desc: FontDescription; 
    family: cstring) {.importc: "pango_font_description_set_family", 
                       libpango.}
proc set_family_static*(desc: FontDescription; 
    family: cstring) {.importc: "pango_font_description_set_family_static", 
                       libpango.}
proc `family_static=`*(desc: FontDescription; 
    family: cstring) {.importc: "pango_font_description_set_family_static", 
                       libpango.}
proc get_family*(desc: FontDescription): cstring {.
    importc: "pango_font_description_get_family", libpango.}
proc family*(desc: FontDescription): cstring {.
    importc: "pango_font_description_get_family", libpango.}
proc set_style*(desc: FontDescription; 
    style: Style) {.importc: "pango_font_description_set_style", 
                         libpango.}
proc `style=`*(desc: FontDescription; 
    style: Style) {.importc: "pango_font_description_set_style", 
                         libpango.}
proc get_style*(desc: FontDescription): Style {.
    importc: "pango_font_description_get_style", libpango.}
proc style*(desc: FontDescription): Style {.
    importc: "pango_font_description_get_style", libpango.}
proc set_variant*(desc: FontDescription; 
    variant: Variant) {.importc: "pango_font_description_set_variant", 
                             libpango.}
proc `variant=`*(desc: FontDescription; 
    variant: Variant) {.importc: "pango_font_description_set_variant", 
                             libpango.}
proc get_variant*(desc: FontDescription): Variant {.
    importc: "pango_font_description_get_variant", libpango.}
proc variant*(desc: FontDescription): Variant {.
    importc: "pango_font_description_get_variant", libpango.}
proc set_weight*(desc: FontDescription; 
    weight: Weight) {.importc: "pango_font_description_set_weight", 
                           libpango.}
proc `weight=`*(desc: FontDescription; 
    weight: Weight) {.importc: "pango_font_description_set_weight", 
                           libpango.}
proc get_weight*(desc: FontDescription): Weight {.
    importc: "pango_font_description_get_weight", libpango.}
proc weight*(desc: FontDescription): Weight {.
    importc: "pango_font_description_get_weight", libpango.}
proc set_stretch*(desc: FontDescription; 
    stretch: Stretch) {.importc: "pango_font_description_set_stretch", 
                             libpango.}
proc `stretch=`*(desc: FontDescription; 
    stretch: Stretch) {.importc: "pango_font_description_set_stretch", 
                             libpango.}
proc get_stretch*(desc: FontDescription): Stretch {.
    importc: "pango_font_description_get_stretch", libpango.}
proc stretch*(desc: FontDescription): Stretch {.
    importc: "pango_font_description_get_stretch", libpango.}
proc set_size*(desc: FontDescription; 
                                      size: gint) {.
    importc: "pango_font_description_set_size", libpango.}
proc `size=`*(desc: FontDescription; 
                                      size: gint) {.
    importc: "pango_font_description_set_size", libpango.}
proc get_size*(desc: FontDescription): gint {.
    importc: "pango_font_description_get_size", libpango.}
proc size*(desc: FontDescription): gint {.
    importc: "pango_font_description_get_size", libpango.}
proc set_absolute_size*(desc: FontDescription; 
    size: cdouble) {.importc: "pango_font_description_set_absolute_size", 
                     libpango.}
proc `absolute_size=`*(desc: FontDescription; 
    size: cdouble) {.importc: "pango_font_description_set_absolute_size", 
                     libpango.}
proc get_size_is_absolute*(
    desc: FontDescription): gboolean {.
    importc: "pango_font_description_get_size_is_absolute", libpango.}
proc size_is_absolute*(
    desc: FontDescription): gboolean {.
    importc: "pango_font_description_get_size_is_absolute", libpango.}
proc set_gravity*(desc: FontDescription; 
    gravity: Gravity) {.importc: "pango_font_description_set_gravity", 
                             libpango.}
proc `gravity=`*(desc: FontDescription; 
    gravity: Gravity) {.importc: "pango_font_description_set_gravity", 
                             libpango.}
proc get_gravity*(desc: FontDescription): Gravity {.
    importc: "pango_font_description_get_gravity", libpango.}
proc gravity*(desc: FontDescription): Gravity {.
    importc: "pango_font_description_get_gravity", libpango.}
proc get_set_fields*(desc: FontDescription): FontMask {.
    importc: "pango_font_description_get_set_fields", libpango.}
proc set_fields*(desc: FontDescription): FontMask {.
    importc: "pango_font_description_get_set_fields", libpango.}
proc unset_fields*(desc: FontDescription; 
    to_unset: FontMask) {.importc: "pango_font_description_unset_fields", 
                               libpango.}
proc merge*(desc: FontDescription; 
                                   desc_to_merge: FontDescription; 
                                   replace_existing: gboolean) {.
    importc: "pango_font_description_merge", libpango.}
proc merge_static*(desc: FontDescription; 
    desc_to_merge: FontDescription; replace_existing: gboolean) {.
    importc: "pango_font_description_merge_static", libpango.}
proc better_match*(desc: FontDescription; 
    old_match: FontDescription; new_match: FontDescription): gboolean {.
    importc: "pango_font_description_better_match", libpango.}
proc font_description_from_string*(str: cstring): FontDescription {.
    importc: "pango_font_description_from_string", libpango.}
proc to_string*(desc: FontDescription): cstring {.
    importc: "pango_font_description_to_string", libpango.}
proc to_filename*(desc: FontDescription): cstring {.
    importc: "pango_font_description_to_filename", libpango.}
proc font_metrics_get_type*(): GType {.
    importc: "pango_font_metrics_get_type", libpango.}
proc `ref`*(metrics: FontMetrics): FontMetrics {.
    importc: "pango_font_metrics_ref", libpango.}
proc unref*(metrics: FontMetrics) {.
    importc: "pango_font_metrics_unref", libpango.}
proc get_ascent*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_ascent", libpango.}
proc ascent*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_ascent", libpango.}
proc get_descent*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_descent", libpango.}
proc descent*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_descent", libpango.}
proc get_approximate_char_width*(
    metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_approximate_char_width", libpango.}
proc approximate_char_width*(
    metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_approximate_char_width", libpango.}
proc get_approximate_digit_width*(
    metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_approximate_digit_width", libpango.}
proc approximate_digit_width*(
    metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_approximate_digit_width", libpango.}
proc get_underline_position*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_underline_position", libpango.}
proc underline_position*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_underline_position", libpango.}
proc get_underline_thickness*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_underline_thickness", libpango.}
proc underline_thickness*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_underline_thickness", libpango.}
proc get_strikethrough_position*(
    metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_strikethrough_position", libpango.}
proc strikethrough_position*(
    metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_strikethrough_position", libpango.}
proc get_strikethrough_thickness*(
    metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_strikethrough_thickness", libpango.}
proc strikethrough_thickness*(
    metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_strikethrough_thickness", libpango.}

when ENABLE_BACKEND: 
  template pango_font_family_class*(klass: expr): expr = 
    (g_type_check_class_cast(klass, font_family_get_type(), 
                             FontFamilyClassObj))

  template pango_is_font_family_class*(klass: expr): expr = 
    (g_type_check_class_type(klass, font_family_get_type()))

  template pango_font_family_get_class*(obj: expr): expr = 
    (g_type_instance_get_class(obj, font_family_get_type(), 
                               FontFamilyClassObj))

  type 
    FontFace* =  ptr FontFaceObj
    FontFacePtr* = ptr FontFaceObj
    FontFaceObj*{.final.} = object of GObjectObj
  type 
    FontFamily* =  ptr FontFamilyObj
    FontFamilyPtr* = ptr FontFamilyObj
    FontFamilyObj*{.final.} = object of GObjectObj

  type 
    FontFamilyClass* =  ptr FontFamilyClassObj
    FontFamilyClassPtr* = ptr FontFamilyClassObj
    FontFamilyClassObj*{.final.} = object of GObjectClassObj
      list_faces*: proc (family: FontFamily; 
                         faces: var ptr FontFace; n_faces: var cint) {.cdecl.}
      get_name*: proc (family: FontFamily): cstring {.cdecl.}
      is_monospace*: proc (family: FontFamily): gboolean {.cdecl.}
      pango_reserved02: proc () {.cdecl.}
      pango_reserved03: proc () {.cdecl.}
      pango_reserved04: proc () {.cdecl.}
else:
  type 
    FontFace* =  ptr FontFaceObj
    FontFacePtr* = ptr FontFaceObj
    FontFaceObj*{.final.} = object of GObjectObj
  type 
    FontFamily* =  ptr FontFamilyObj
    FontFamilyPtr* = ptr FontFamilyObj
    FontFamilyObj* = object 

when ENABLE_BACKEND: 
  template pango_font_face_class*(klass: expr): expr = 
    (g_type_check_class_cast(klass, font_face_get_type(), FontFaceClassObj))

  template pango_is_font_face_class*(klass: expr): expr = 
    (g_type_check_class_type(klass, font_face_get_type()))

  template pango_font_face_get_class*(obj: expr): expr = 
    (g_type_instance_get_class(obj, font_face_get_type(), FontFaceClassObj))

  type 
    FontFaceClass* =  ptr FontFaceClassObj
    FontFaceClassPtr* = ptr FontFaceClassObj
    FontFaceClassObj*{.final.} = object of GObjectClassObj
      get_face_name*: proc (face: FontFace): cstring {.cdecl.}
      describe*: proc (face: FontFace): FontDescription {.cdecl.}
      list_sizes*: proc (face: FontFace; sizes: var ptr cint; 
                         n_sizes: var cint) {.cdecl.}
      is_synthesized*: proc (face: FontFace): gboolean {.cdecl.}
      pango_reserved03: proc () {.cdecl.}
      pango_reserved04: proc () {.cdecl.}

template pango_font_family*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, font_family_get_type(), 
                              FontFamilyObj))

template pango_is_font_family*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, font_family_get_type()))

proc font_family_get_type*(): GType {.
    importc: "pango_font_family_get_type", libpango.}
proc list_faces*(family: FontFamily; 
                                   faces: var ptr FontFace; 
                                   n_faces: var cint) {.
    importc: "pango_font_family_list_faces", libpango.}
proc get_name*(family: FontFamily): cstring {.
    importc: "pango_font_family_get_name", libpango.}
proc name*(family: FontFamily): cstring {.
    importc: "pango_font_family_get_name", libpango.}
proc is_monospace*(family: FontFamily): gboolean {.
    importc: "pango_font_family_is_monospace", libpango.}

template pango_font_face*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, font_face_get_type(), FontFaceObj))

template pango_is_font_face*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, font_face_get_type()))

proc font_face_get_type*(): GType {.importc: "pango_font_face_get_type", 
    libpango.}
proc describe*(face: FontFace): FontDescription {.
    importc: "pango_font_face_describe", libpango.}
proc get_face_name*(face: FontFace): cstring {.
    importc: "pango_font_face_get_face_name", libpango.}
proc face_name*(face: FontFace): cstring {.
    importc: "pango_font_face_get_face_name", libpango.}
proc list_sizes*(face: FontFace; sizes: var ptr cint; 
                                 n_sizes: var cint) {.
    importc: "pango_font_face_list_sizes", libpango.}
proc is_synthesized*(face: FontFace): gboolean {.
    importc: "pango_font_face_is_synthesized", libpango.}
when ENABLE_ENGINE: 
  const 
    RENDER_TYPE_NONE* = "RenderNone"
  template pango_engine*(`object`: expr): expr = 
    (g_type_check_instance_cast(`object`, engine_get_type(), EngineObj))

  template pango_is_engine*(`object`: expr): expr = 
    (g_type_check_instance_type(`object`, engine_get_type()))

  template pango_engine_class*(klass: expr): expr = 
    (g_type_check_class_cast(klass, engine_get_type(), EngineClassObj))

  template pango_is_engine_class*(klass: expr): expr = 
    (g_type_check_class_type(klass, engine_get_type()))

  template pango_engine_get_class*(obj: expr): expr = 
    (g_type_instance_get_class(obj, engine_get_type(), EngineClassObj))

  type 
    EngineClass* =  ptr EngineClassObj
    EngineClassPtr* = ptr EngineClassObj
    EngineClassObj* = object of GObjectClassObj

  proc engine_get_type*(): GType {.importc: "pango_engine_get_type", 
      libpango.}
  const 
    ENGINE_TYPE_LANG* = "EngineLangObj"
  template pango_engine_lang*(`object`: expr): expr = 
    (g_type_check_instance_cast(`object`, engine_lang_get_type(), 
                                EngineLangObj))

  template pango_is_engine_lang*(`object`: expr): expr = 
    (g_type_check_instance_type(`object`, engine_lang_get_type()))

  template pango_engine_lang_class*(klass: expr): expr = 
    (g_type_check_class_cast(klass, engine_lang_get_type(), 
                             EngineLangClassObj))

  template pango_is_engine_lang_class*(klass: expr): expr = 
    (g_type_check_class_type(klass, engine_lang_get_type()))

  template pango_engine_lang_get_class*(obj: expr): expr = 
    (g_type_instance_get_class(obj, engine_lang_get_type(), 
                               EngineLangClassObj))

  type 
    EngineLangClass* =  ptr EngineLangClassObj
    EngineLangClassPtr* = ptr EngineLangClassObj
    EngineLangClassObj*{.final.} = object of EngineClassObj
      script_break*: proc (engine: EngineLang; text: cstring; 
                           len: cint; analysis: Analysis; 
                           attrs: LogAttr; attrs_len: cint) {.cdecl.}

  proc engine_lang_get_type*(): GType {.
      importc: "pango_engine_lang_get_type", libpango.}
  const 
    ENGINE_TYPE_SHAPE* = "EngineShapeObj"
  template pango_engine_shape*(`object`: expr): expr = 
    (g_type_check_instance_cast(`object`, engine_shape_get_type(), 
                                EngineShapeObj))

  template pango_is_engine_shape*(`object`: expr): expr = 
    (g_type_check_instance_type(`object`, engine_shape_get_type()))

  template pango_engine_shape_class*(klass: expr): expr = 
    (g_type_check_class_cast(klass, engine_shape_get_type(), 
                             Engine_ShapeClass))

  template pango_is_engine_shape_class*(klass: expr): expr = 
    (g_type_check_class_type(klass, engine_shape_get_type()))

  template pango_engine_shape_get_class*(obj: expr): expr = 
    (g_type_instance_get_class(obj, engine_shape_get_type(), 
                               EngineShapeClassObj))

  type 
    EngineShapeClass* =  ptr EngineShapeClassObj
    EngineShapeClassPtr* = ptr EngineShapeClassObj
    EngineShapeClassObj*{.final.} = object of EngineClassObj
      script_shape*: proc (engine: EngineShape; font: Font; 
                           item_text: cstring; item_length: cuint; 
                           analysis: Analysis; 
                           glyphs: GlyphString; 
                           paragraph_text: cstring; paragraph_length: cuint) {.cdecl.}
      covers*: proc (engine: EngineShape; font: Font; 
                     language: Language; wc: gunichar): CoverageLevel {.cdecl.}

  proc engine_shape_get_type*(): GType {.
      importc: "pango_engine_shape_get_type", libpango.}
  type 
    EngineScriptInfo* =  ptr EngineScriptInfoObj
    EngineScriptInfoPtr* = ptr EngineScriptInfoObj
    EngineScriptInfoObj* = object 
      script*: Script
      langs*: cstring

  type 
    EngineInfo* =  ptr EngineInfoObj
    EngineInfoPtr* = ptr EngineInfoObj
    EngineInfoObj* = object 
      id*: cstring
      engine_type*: cstring
      render_type*: cstring
      scripts*: EngineScriptInfo
      n_scripts*: gint

  proc script_engine_list*(engines: var EngineInfo; 
                           n_engines: var cint) {.
      importc: "script_engine_list", libpango.}
  proc script_engine_init*(module: gobject.GTypeModule) {.
      importc: "script_engine_init", libpango.}
  proc script_engine_exit*() {.importc: "script_engine_exit", libpango.}
  proc script_engine_create*(id: cstring): Engine {.
      importc: "script_engine_create", libpango.}

when ENABLE_BACKEND: 
  template pango_font_class*(klass: expr): expr = 
    (g_type_check_class_cast(klass, font_get_type(), FontClassObj))

  template pango_is_font_class*(klass: expr): expr = 
    (g_type_check_class_type(klass, font_get_type()))

  template pango_font_get_class*(obj: expr): expr = 
    (g_type_instance_get_class(obj, font_get_type(), FontClassObj))

  type 
    FontClass* =  ptr FontClassObj
    FontClassPtr* = ptr FontClassObj
    FontClassObj* = object of GObjectClassObj
      describe*: proc (font: Font): FontDescription {.cdecl.}
      get_coverage*: proc (font: Font; lang: Language): Coverage {.cdecl.}
      find_shaper*: proc (font: Font; lang: Language; 
                          ch: guint32): EngineShape {.cdecl.}
      get_glyph_extents*: proc (font: Font; glyph: Glyph; 
                                ink_rect: Rectangle; 
                                logical_rect: Rectangle) {.cdecl.}
      get_metrics*: proc (font: Font; language: Language): FontMetrics {.cdecl.}
      get_font_map*: proc (font: Font): FontMap {.cdecl.}
      describe_absolute*: proc (font: Font): FontDescription {.cdecl.}
      pango_reserved01: proc () {.cdecl.}
      pango_reserved02: proc () {.cdecl.}

  const 
    UNKNOWN_GLYPH_WIDTH* = 10
    UNKNOWN_GLYPH_HEIGHT* = 14

template pango_font*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, font_get_type(), FontObj))

template pango_is_font*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, font_get_type()))

proc font_get_type*(): GType {.importc: "pango_font_get_type", 
                                     libpango.}
proc describe*(font: Font): FontDescription {.
    importc: "pango_font_describe", libpango.}
proc describe_with_absolute_size*(font: Font): FontDescription {.
    importc: "pango_font_describe_with_absolute_size", libpango.}
proc get_coverage*(font: Font; language: Language): Coverage {.
    importc: "pango_font_get_coverage", libpango.}
proc coverage*(font: Font; language: Language): Coverage {.
    importc: "pango_font_get_coverage", libpango.}
proc find_shaper*(font: Font; language: Language; 
                             ch: guint32): EngineShape {.
    importc: "pango_font_find_shaper", libpango.}
proc get_metrics*(font: Font; language: Language): FontMetrics {.
    importc: "pango_font_get_metrics", libpango.}
proc metrics*(font: Font; language: Language): FontMetrics {.
    importc: "pango_font_get_metrics", libpango.}
proc get_glyph_extents*(font: Font; glyph: Glyph; 
                                   ink_rect: var RectangleObj; 
                                   logical_rect: var RectangleObj) {.
    importc: "pango_font_get_glyph_extents", libpango.}
proc get_font_map*(font: Font): FontMap {.
    importc: "pango_font_get_font_map", libpango.}
proc font_map*(font: Font): FontMap {.
    importc: "pango_font_get_font_map", libpango.}
const 
  GLYPH_EMPTY* = Glyph(0x0FFFFFFF)
  GLYPH_INVALID_INPUT* = Glyph(0xFFFFFFFF)
  GLYPH_UNKNOWN_FLAG* = Glyph(0x10000000)
template pango_get_unknown_glyph*(wc: expr): expr = 
  (Glyph(wc) or GLYPH_UNKNOWN_FLAG)

type 
  Color* =  ptr ColorObj
  ColorPtr* = ptr ColorObj
  ColorObj* = object 
    red*: guint16
    green*: guint16
    blue*: guint16
converter PCO2PCP(o: var ColorObj): Color =
  addr(o)

proc color_get_type*(): GType {.importc: "pango_color_get_type", 
                                      libpango.}
proc copy*(src: Color): Color {.
    importc: "pango_color_copy", libpango.}
proc free*(color: Color) {.importc: "pango_color_free", 
    libpango.}
proc parse*(color: Color; spec: cstring): gboolean {.
    importc: "pango_color_parse", libpango.}
proc to_string*(color: Color): cstring {.
    importc: "pango_color_to_string", libpango.}
type 
  AttrList* =  ptr AttrListObj
  AttrListPtr* = ptr AttrListObj
  AttrListObj* = object 
  
  AttrIterator* =  ptr AttrIteratorObj
  AttrIteratorPtr* = ptr AttrIteratorObj
  AttrIteratorObj* = object 
  
type 
  AttrType* {.size: sizeof(cint), pure.} = enum 
    INVALID, LANGUAGE, FAMILY, 
    STYLE, WEIGHT, VARIANT, 
    STRETCH, SIZE, FONT_DESC, 
    FOREGROUND, BACKGROUND, UNDERLINE, 
    STRIKETHROUGH, RISE, SHAPE, 
    SCALE, FALLBACK, LETTER_SPACING, 
    UNDERLINE_COLOR, STRIKETHROUGH_COLOR, 
    ABSOLUTE_SIZE, GRAVITY, GRAVITY_HINT
type 
  Underline* {.size: sizeof(cint), pure.} = enum 
    NONE, SINGLE, DOUBLE, 
    LOW, ERROR
const 
  ATTR_INDEX_FROM_TEXT_BEGINNING* = 0
  ATTR_INDEX_TO_TEXT_END* = G_MAXUINT
type 
  Attribute* =  ptr AttributeObj
  AttributePtr* = ptr AttributeObj
  AttributeObj*{.inheritable, pure.} = object 
    klass*: AttrClass
    start_index*: guint
    end_index*: guint

  AttrFilterFunc* = proc (attribute: Attribute; 
                               user_data: gpointer): gboolean {.cdecl.}
  AttrDataCopyFunc* = proc (user_data: gconstpointer): gpointer {.cdecl.} 
  AttrClass* =  ptr AttrClassObj
  AttrClassPtr* = ptr AttrClassObj
  AttrClassObj* = object 
    `type`*: AttrType
    copy*: proc (attr: Attribute): Attribute {.cdecl.}
    destroy*: proc (attr: Attribute) {.cdecl.}
    equal*: proc (attr1: Attribute; attr2: Attribute): gboolean {.cdecl.}

type 
  AttrString* =  ptr AttrStringObj
  AttrStringPtr* = ptr AttrStringObj
  AttrStringObj*{.final.} = object of AttributeObj
    value*: cstring

type 
  AttrLanguage* =  ptr AttrLanguageObj
  AttrLanguagePtr* = ptr AttrLanguageObj
  AttrLanguageObj*{.final.} = object of AttributeObj
    value*: Language

type 
  AttrInt* =  ptr AttrIntObj
  AttrIntPtr* = ptr AttrIntObj
  AttrIntObj*{.final.} = object of AttributeObj
    value*: cint

type 
  AttrFloat* =  ptr AttrFloatObj
  AttrFloatPtr* = ptr AttrFloatObj
  AttrFloatObj*{.final.} = object of AttributeObj
    value*: cdouble

type 
  AttrColor* =  ptr AttrColorObj
  AttrColorPtr* = ptr AttrColorObj
  AttrColorObj*{.final.} = object of AttributeObj
    color*: ColorObj

type 
  AttrSize* =  ptr AttrSizeObj
  AttrSizePtr* = ptr AttrSizeObj
  AttrSizeObj*{.final.} = object of AttributeObj
    size*: cint
    bitfield0PangoAttrSize*: guint

type 
  AttrShape* =  ptr AttrShapeObj
  AttrShapePtr* = ptr AttrShapeObj
  AttrShapeObj*{.final.} = object of AttributeObj
    ink_rect*: RectangleObj
    logical_rect*: RectangleObj
    data*: gpointer
    copy_func*: AttrDataCopyFunc
    destroy_func*: GDestroyNotify

type 
  AttrFontDesc* =  ptr AttrFontDescObj
  AttrFontDescPtr* = ptr AttrFontDescObj
  AttrFontDescObj*{.final.} = object of AttributeObj
    desc*: FontDescription

proc attr_type_register*(name: cstring): AttrType {.
    importc: "pango_attr_type_register", libpango.}
proc get_name*(`type`: AttrType): cstring {.
    importc: "pango_attr_type_get_name", libpango.}
proc name*(`type`: AttrType): cstring {.
    importc: "pango_attr_type_get_name", libpango.}
proc init*(attr: Attribute; klass: AttrClass) {.
    importc: "pango_attribute_init", libpango.}
proc copy*(attr: Attribute): Attribute {.
    importc: "pango_attribute_copy", libpango.}
proc destroy*(attr: Attribute) {.
    importc: "pango_attribute_destroy", libpango.}
proc equal*(attr1: Attribute; 
                            attr2: Attribute): gboolean {.
    importc: "pango_attribute_equal", libpango.}
proc attr_language_new*(language: Language): Attribute {.
    importc: "pango_attr_language_new", libpango.}
proc attr_family_new*(family: cstring): Attribute {.
    importc: "pango_attr_family_new", libpango.}
proc attr_foreground_new*(red: guint16; green: guint16; blue: guint16): Attribute {.
    importc: "pango_attr_foreground_new", libpango.}
proc attr_background_new*(red: guint16; green: guint16; blue: guint16): Attribute {.
    importc: "pango_attr_background_new", libpango.}
proc attr_size_new*(size: cint): Attribute {.
    importc: "pango_attr_size_new", libpango.}
proc attr_size_new_absolute*(size: cint): Attribute {.
    importc: "pango_attr_size_new_absolute", libpango.}
proc attr_style_new*(style: Style): Attribute {.
    importc: "pango_attr_style_new", libpango.}
proc attr_weight_new*(weight: Weight): Attribute {.
    importc: "pango_attr_weight_new", libpango.}
proc attr_variant_new*(variant: Variant): Attribute {.
    importc: "pango_attr_variant_new", libpango.}
proc attr_stretch_new*(stretch: Stretch): Attribute {.
    importc: "pango_attr_stretch_new", libpango.}
proc attr_font_desc_new*(desc: FontDescription): Attribute {.
    importc: "pango_attr_font_desc_new", libpango.}
proc attr_underline_new*(underline: Underline): Attribute {.
    importc: "pango_attr_underline_new", libpango.}
proc attr_underline_color_new*(red: guint16; green: guint16; 
                                     blue: guint16): Attribute {.
    importc: "pango_attr_underline_color_new", libpango.}
proc attr_strikethrough_new*(strikethrough: gboolean): Attribute {.
    importc: "pango_attr_strikethrough_new", libpango.}
proc attr_strikethrough_color_new*(red: guint16; green: guint16; 
    blue: guint16): Attribute {.
    importc: "pango_attr_strikethrough_color_new", libpango.}
proc attr_rise_new*(rise: cint): Attribute {.
    importc: "pango_attr_rise_new", libpango.}
proc attr_scale_new*(scale_factor: cdouble): Attribute {.
    importc: "pango_attr_scale_new", libpango.}
proc attr_fallback_new*(enable_fallback: gboolean): Attribute {.
    importc: "pango_attr_fallback_new", libpango.}
proc attr_letter_spacing_new*(letter_spacing: cint): Attribute {.
    importc: "pango_attr_letter_spacing_new", libpango.}
proc attr_shape_new*(ink_rect: Rectangle; 
                           logical_rect: Rectangle): Attribute {.
    importc: "pango_attr_shape_new", libpango.}
proc attr_shape_new_with_data*(ink_rect: Rectangle; 
                                     logical_rect: Rectangle; 
                                     data: gpointer; 
                                     copy_func: AttrDataCopyFunc; 
                                     destroy_func: GDestroyNotify): Attribute {.
    importc: "pango_attr_shape_new_with_data", libpango.}
proc attr_gravity_new*(gravity: Gravity): Attribute {.
    importc: "pango_attr_gravity_new", libpango.}
proc attr_gravity_hint_new*(hint: GravityHint): Attribute {.
    importc: "pango_attr_gravity_hint_new", libpango.}
proc attr_list_get_type*(): GType {.importc: "pango_attr_list_get_type", 
    libpango.}
proc attr_list_new*(): AttrList {.
    importc: "pango_attr_list_new", libpango.}
proc `ref`*(list: AttrList): AttrList {.
    importc: "pango_attr_list_ref", libpango.}
proc unref*(list: AttrList) {.
    importc: "pango_attr_list_unref", libpango.}
proc copy*(list: AttrList): AttrList {.
    importc: "pango_attr_list_copy", libpango.}
proc insert*(list: AttrList; attr: Attribute) {.
    importc: "pango_attr_list_insert", libpango.}
proc insert_before*(list: AttrList; 
                                    attr: Attribute) {.
    importc: "pango_attr_list_insert_before", libpango.}
proc change*(list: AttrList; attr: Attribute) {.
    importc: "pango_attr_list_change", libpango.}
proc splice*(list: AttrList; 
                             other: AttrList; pos: gint; len: gint) {.
    importc: "pango_attr_list_splice", libpango.}
proc filter*(list: AttrList; 
                             `func`: AttrFilterFunc; data: gpointer): AttrList {.
    importc: "pango_attr_list_filter", libpango.}
proc get_iterator*(list: AttrList): AttrIterator {.
    importc: "pango_attr_list_get_iterator", libpango.}
proc `iterator`*(list: AttrList): AttrIterator {.
    importc: "pango_attr_list_get_iterator", libpango.}
proc range*(`iterator`: AttrIterator; 
                                start: var gint; `end`: var gint) {.
    importc: "pango_attr_iterator_range", libpango.}
proc next*(`iterator`: AttrIterator): gboolean {.
    importc: "pango_attr_iterator_next", libpango.}
proc copy*(`iterator`: AttrIterator): AttrIterator {.
    importc: "pango_attr_iterator_copy", libpango.}
proc destroy*(`iterator`: AttrIterator) {.
    importc: "pango_attr_iterator_destroy", libpango.}
proc get*(`iterator`: AttrIterator; 
                              `type`: AttrType): Attribute {.
    importc: "pango_attr_iterator_get", libpango.}
proc get_font*(`iterator`: AttrIterator; 
                                   desc: FontDescription; 
                                   language: var Language; 
                                   extra_attrs: var glib.GSList) {.
    importc: "pango_attr_iterator_get_font", libpango.}
proc get_attrs*(`iterator`: AttrIterator): glib.GSList {.
    importc: "pango_attr_iterator_get_attrs", libpango.}
proc attrs*(`iterator`: AttrIterator): glib.GSList {.
    importc: "pango_attr_iterator_get_attrs", libpango.}
proc parse_markup*(markup_text: cstring; length: cint; 
                         accel_marker: gunichar; 
                         attr_list: var AttrList; text: cstringArray; 
                         accel_char: var gunichar; error: var glib.GError): gboolean {.
    importc: "pango_parse_markup", libpango.}
proc markup_parser_new*(accel_marker: gunichar): glib.GMarkupParseContext {.
    importc: "pango_markup_parser_new", libpango.}
proc markup_parser_finish*(context: glib.GMarkupParseContext; 
                                 attr_list: var AttrList; 
                                 text: cstringArray; accel_char: var gunichar; 
                                 error: var glib.GError): gboolean {.
    importc: "pango_markup_parser_finish", libpango.}

proc `break`*(text: cstring; length: cint; analysis: Analysis; 
                  attrs: LogAttr; attrs_len: cint) {.
    importc: "pango_break", libpango.}
proc find_paragraph_boundary*(text: cstring; length: gint; 
                                    paragraph_delimiter_index: var gint; 
                                    next_paragraph_start: var gint) {.
    importc: "pango_find_paragraph_boundary", libpango.}
proc get_log_attrs*(text: cstring; length: cint; level: cint; 
                          language: Language; 
                          log_attrs: LogAttr; attrs_len: cint) {.
    importc: "pango_get_log_attrs", libpango.}
when ENABLE_ENGINE: 
  proc default_break*(text: cstring; length: cint; 
                            analysis: Analysis; 
                            attrs: LogAttr; attrs_len: cint) {.
      importc: "pango_default_break", libpango.}

const 
  ANALYSIS_FLAG_CENTERED_BASELINE* = (1 shl 0)
const 
  ANALYSIS_FLAG_IS_ELLIPSIS* = (1 shl 1)

type 
  Item* =  ptr ItemObj
  ItemPtr* = ptr ItemObj
  ItemObj* = object 
    offset*: gint
    length*: gint
    num_chars*: gint
    analysis*: AnalysisObj

proc item_get_type*(): GType {.importc: "pango_item_get_type", 
                                     libpango.}
proc item_new*(): Item {.importc: "pango_item_new", libpango.}
proc copy*(item: Item): Item {.
    importc: "pango_item_copy", libpango.}
proc free*(item: Item) {.importc: "pango_item_free", 
    libpango.}
proc split*(orig: Item; split_index: cint; 
                       split_offset: cint): Item {.
    importc: "pango_item_split", libpango.}

when ENABLE_BACKEND: 
  template pango_fontset_class*(klass: expr): expr = 
    (g_type_check_class_cast(klass, fontset_get_type(), FontsetClassObj))

  template pango_is_fontset_class*(klass: expr): expr = 
    (g_type_check_class_type(klass, fontset_get_type()))

  template pango_fontset_get_class*(obj: expr): expr = 
    (g_type_instance_get_class(obj, fontset_get_type(), FontsetClassObj))

  type 
    Fontset* =  ptr FontsetObj
    FontsetPtr* = ptr FontsetObj
    FontsetObj*{.final.} = object of GObjectObj
  type 
    FontsetForeachFunc* = proc (fontset: Fontset; 
                                   font: Font; user_data: gpointer): gboolean {.cdecl.}

  type 
    FontsetClass* =  ptr FontsetClassObj
    FontsetClassPtr* = ptr FontsetClassObj
    FontsetClassObj*{.final.} = object of GObjectClassObj
      get_font*: proc (fontset: Fontset; wc: guint): Font {.cdecl.}
      get_metrics*: proc (fontset: Fontset): FontMetrics {.cdecl.}
      get_language*: proc (fontset: Fontset): Language {.cdecl.}
      foreach*: proc (fontset: Fontset; 
                      `func`: FontsetForeachFunc; data: gpointer) {.cdecl.}
      pango_reserved01: proc () {.cdecl.}
      pango_reserved02: proc () {.cdecl.}
      pango_reserved03: proc () {.cdecl.}
      pango_reserved04: proc () {.cdecl.}

  template pango_fontset_simple*(`object`: expr): expr = 
    (g_type_check_instance_cast(`object`, fontset_simple_get_type(), 
                                FontsetSimpleObj))

  template pango_is_fontset_simple*(`object`: expr): expr = 
    (g_type_check_instance_type(`object`, fontset_simple_get_type()))

  type 
    FontsetSimple* =  ptr FontsetSimpleObj
    FontsetSimplePtr* = ptr FontsetSimpleObj
    FontsetSimpleObj* = object 
    
  proc fontset_simple_get_type*(): GType {.
      importc: "pango_fontset_simple_get_type", libpango.}
  proc fontset_simple_new*(language: Language): FontsetSimple {.
      importc: "pango_fontset_simple_new", libpango.}
  proc append*(fontset: FontsetSimple; 
                                    font: Font) {.
      importc: "pango_fontset_simple_append", libpango.}
  proc size*(fontset: FontsetSimple): cint {.
      importc: "pango_fontset_simple_size", libpango.}
else:
  type 
    Fontset* =  ptr FontsetObj
    FontsetPtr* = ptr FontsetObj
    FontsetObj* = object 
  type 
    FontsetForeachFunc* = proc (fontset: Fontset; 
                                     font: Font; user_data: gpointer): gboolean {.cdecl.}

template pango_fontset*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, fontset_get_type(), FontsetObj))

template pango_is_fontset*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, fontset_get_type()))

proc fontset_get_type*(): GType {.importc: "pango_fontset_get_type", 
    libpango.}
proc get_font*(fontset: Fontset; wc: guint): Font {.
    importc: "pango_fontset_get_font", libpango.}
proc font*(fontset: Fontset; wc: guint): Font {.
    importc: "pango_fontset_get_font", libpango.}
proc get_metrics*(fontset: Fontset): FontMetrics {.
    importc: "pango_fontset_get_metrics", libpango.}
proc metrics*(fontset: Fontset): FontMetrics {.
    importc: "pango_fontset_get_metrics", libpango.}
proc foreach*(fontset: Fontset; 
                            `func`: FontsetForeachFunc; data: gpointer) {.
    importc: "pango_fontset_foreach", libpango.}

template pango_font_map*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, font_map_get_type(), FontMapObj))

template pango_is_font_map*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, font_map_get_type()))

type 
  Context* =  ptr ContextObj
  ContextPtr* = ptr ContextObj
  ContextObj* = object 
  
proc font_map_get_type*(): GType {.importc: "pango_font_map_get_type", 
    libpango.}
proc create_context*(fontmap: FontMap): Context {.
    importc: "pango_font_map_create_context", libpango.}
proc load_font*(fontmap: FontMap; 
                               context: Context; 
                               desc: FontDescription): Font {.
    importc: "pango_font_map_load_font", libpango.}
proc load_fontset*(fontmap: FontMap; 
                                  context: Context; 
                                  desc: FontDescription; 
                                  language: Language): Fontset {.
    importc: "pango_font_map_load_fontset", libpango.}
proc list_families*(fontmap: FontMap; 
                                   families: var ptr FontFamily; 
                                   n_families: var cint) {.
    importc: "pango_font_map_list_families", libpango.}
proc get_serial*(fontmap: FontMap): guint {.
    importc: "pango_font_map_get_serial", libpango.}
proc serial*(fontmap: FontMap): guint {.
    importc: "pango_font_map_get_serial", libpango.}
proc changed*(fontmap: FontMap) {.
    importc: "pango_font_map_changed", libpango.}
when ENABLE_BACKEND: 
  template pango_font_map_class*(klass: expr): expr = 
    (g_type_check_class_cast(klass, font_map_get_type(), FontMapClassObj))

  template pango_is_font_map_class*(klass: expr): expr = 
    (g_type_check_class_type(klass, font_map_get_type()))

  template pango_font_map_get_class*(obj: expr): expr = 
    (g_type_instance_get_class(obj, font_map_get_type(), FontMapClassObj))

  type 
    FontMapClass* =  ptr FontMapClassObj
    FontMapClassPtr* = ptr FontMapClassObj
    FontMapClassObj* = object of GObjectClassObj
      load_font*: proc (fontmap: FontMap; context: Context; 
                        desc: FontDescription): Font {.cdecl.}
      list_families*: proc (fontmap: FontMap; 
                            families: var ptr FontFamily; 
                            n_families: var cint) {.cdecl.}
      load_fontset*: proc (fontmap: FontMap; 
                           context: Context; 
                           desc: FontDescription; 
                           language: Language): Fontset {.cdecl.}
      shape_engine_type*: cstring
      get_serial*: proc (fontmap: FontMap): guint {.cdecl.}
      changed*: proc (fontmap: FontMap) {.cdecl.}
      pango_reserved01: proc () {.cdecl.}
      pango_reserved02: proc () {.cdecl.}

  proc get_shape_engine_type*(fontmap: FontMap): cstring {.
      importc: "pango_font_map_get_shape_engine_type", libpango.}

  proc shape_engine_type*(fontmap: FontMap): cstring {.
      importc: "pango_font_map_get_shape_engine_type", libpango.}

template pango_context*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, context_get_type(), ContextObj))

template pango_context_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, context_get_type(), ContextClass))

template pango_is_context*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, context_get_type()))

template pango_is_context_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, context_get_type()))

template pango_context_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, context_get_type(), ContextClass))

proc context_get_type*(): GType {.importc: "pango_context_get_type", 
    libpango.}
proc context_new*(): Context {.importc: "pango_context_new", 
    libpango.}
proc changed*(context: Context) {.
    importc: "pango_context_changed", libpango.}
proc set_font_map*(context: Context; 
                                 font_map: FontMap) {.
    importc: "pango_context_set_font_map", libpango.}
proc `font_map=`*(context: Context; 
                                 font_map: FontMap) {.
    importc: "pango_context_set_font_map", libpango.}
proc get_font_map*(context: Context): FontMap {.
    importc: "pango_context_get_font_map", libpango.}
proc font_map*(context: Context): FontMap {.
    importc: "pango_context_get_font_map", libpango.}
proc get_serial*(context: Context): guint {.
    importc: "pango_context_get_serial", libpango.}
proc serial*(context: Context): guint {.
    importc: "pango_context_get_serial", libpango.}
proc list_families*(context: Context; 
                                  families: var ptr FontFamily; 
                                  n_families: var cint) {.
    importc: "pango_context_list_families", libpango.}
proc load_font*(context: Context; 
                              desc: FontDescription): Font {.
    importc: "pango_context_load_font", libpango.}
proc load_fontset*(context: Context; 
                                 desc: FontDescription; 
                                 language: Language): Fontset {.
    importc: "pango_context_load_fontset", libpango.}
proc get_metrics*(context: Context; 
                                desc: FontDescription; 
                                language: Language): FontMetrics {.
    importc: "pango_context_get_metrics", libpango.}
proc metrics*(context: Context; 
                                desc: FontDescription; 
                                language: Language): FontMetrics {.
    importc: "pango_context_get_metrics", libpango.}
proc set_font_description*(context: Context; 
    desc: FontDescription) {.importc: "pango_context_set_font_description", 
                                      libpango.}
proc `font_description=`*(context: Context; 
    desc: FontDescription) {.importc: "pango_context_set_font_description", 
                                      libpango.}
proc get_font_description*(context: Context): FontDescription {.
    importc: "pango_context_get_font_description", libpango.}
proc font_description*(context: Context): FontDescription {.
    importc: "pango_context_get_font_description", libpango.}
proc get_language*(context: Context): Language {.
    importc: "pango_context_get_language", libpango.}
proc language*(context: Context): Language {.
    importc: "pango_context_get_language", libpango.}
proc set_language*(context: Context; 
                                 language: Language) {.
    importc: "pango_context_set_language", libpango.}
proc `language=`*(context: Context; 
                                 language: Language) {.
    importc: "pango_context_set_language", libpango.}
proc set_base_dir*(context: Context; 
                                 direction: Direction) {.
    importc: "pango_context_set_base_dir", libpango.}
proc `base_dir=`*(context: Context; 
                                 direction: Direction) {.
    importc: "pango_context_set_base_dir", libpango.}
proc get_base_dir*(context: Context): Direction {.
    importc: "pango_context_get_base_dir", libpango.}
proc base_dir*(context: Context): Direction {.
    importc: "pango_context_get_base_dir", libpango.}
proc set_base_gravity*(context: Context; 
                                     gravity: Gravity) {.
    importc: "pango_context_set_base_gravity", libpango.}
proc `base_gravity=`*(context: Context; 
                                     gravity: Gravity) {.
    importc: "pango_context_set_base_gravity", libpango.}
proc get_base_gravity*(context: Context): Gravity {.
    importc: "pango_context_get_base_gravity", libpango.}
proc base_gravity*(context: Context): Gravity {.
    importc: "pango_context_get_base_gravity", libpango.}
proc get_gravity*(context: Context): Gravity {.
    importc: "pango_context_get_gravity", libpango.}
proc gravity*(context: Context): Gravity {.
    importc: "pango_context_get_gravity", libpango.}
proc set_gravity_hint*(context: Context; 
                                     hint: GravityHint) {.
    importc: "pango_context_set_gravity_hint", libpango.}
proc `gravity_hint=`*(context: Context; 
                                     hint: GravityHint) {.
    importc: "pango_context_set_gravity_hint", libpango.}
proc get_gravity_hint*(context: Context): GravityHint {.
    importc: "pango_context_get_gravity_hint", libpango.}
proc gravity_hint*(context: Context): GravityHint {.
    importc: "pango_context_get_gravity_hint", libpango.}
proc set_matrix*(context: Context; 
                               matrix: Matrix) {.
    importc: "pango_context_set_matrix", libpango.}
proc `matrix=`*(context: Context; 
                               matrix: Matrix) {.
    importc: "pango_context_set_matrix", libpango.}
proc get_matrix*(context: Context): Matrix {.
    importc: "pango_context_get_matrix", libpango.}
proc matrix*(context: Context): Matrix {.
    importc: "pango_context_get_matrix", libpango.}
proc itemize*(context: Context; text: cstring; 
                    start_index: cint; length: cint; attrs: AttrList; 
                    cached_iter: AttrIterator): glib.GList {.
    importc: "pango_itemize", libpango.}
proc itemize_with_base_dir*(context: Context; 
                                  base_dir: Direction; text: cstring; 
                                  start_index: cint; length: cint; 
                                  attrs: AttrList; 
                                  cached_iter: AttrIterator): glib.GList {.
    importc: "pango_itemize_with_base_dir", libpango.}

proc glyph_string_new*(): GlyphString {.
    importc: "pango_glyph_string_new", libpango.}
proc set_size*(string: GlyphString; new_len: gint) {.
    importc: "pango_glyph_string_set_size", libpango.}
proc `size=`*(string: GlyphString; new_len: gint) {.
    importc: "pango_glyph_string_set_size", libpango.}
proc glyph_string_get_type*(): GType {.
    importc: "pango_glyph_string_get_type", libpango.}
proc copy*(string: GlyphString): GlyphString {.
    importc: "pango_glyph_string_copy", libpango.}
proc free*(string: GlyphString) {.
    importc: "pango_glyph_string_free", libpango.}
proc extents*(glyphs: GlyphString; 
                                 font: Font; 
                                 ink_rect: Rectangle; 
                                 logical_rect: Rectangle) {.
    importc: "pango_glyph_string_extents", libpango.}
proc get_width*(glyphs: GlyphString): cint {.
    importc: "pango_glyph_string_get_width", libpango.}
proc width*(glyphs: GlyphString): cint {.
    importc: "pango_glyph_string_get_width", libpango.}
proc extents_range*(glyphs: GlyphString; 
    start: cint; `end`: cint; font: Font; ink_rect: var RectangleObj; 
    logical_rect: var RectangleObj) {.
    importc: "pango_glyph_string_extents_range", libpango.}
proc get_logical_widths*(glyphs: GlyphString; 
    text: cstring; length: cint; embedding_level: cint; 
    logical_widths: var cint) {.importc: "pango_glyph_string_get_logical_widths", 
                                libpango.}
proc index_to_x*(glyphs: GlyphString; 
                                    text: cstring; length: cint; 
                                    analysis: Analysis; index: cint; 
                                    trailing: gboolean; x_pos: var cint) {.
    importc: "pango_glyph_string_index_to_x", libpango.}
proc x_to_index*(glyphs: GlyphString; 
                                    text: cstring; length: cint; 
                                    analysis: Analysis; x_pos: cint; 
                                    index: var cint; trailing: var cint) {.
    importc: "pango_glyph_string_x_to_index", libpango.}
proc shape*(text: cstring; length: gint; analysis: Analysis; 
                  glyphs: GlyphString) {.importc: "pango_shape", 
    libpango.}
proc shape_full*(item_text: cstring; item_length: gint; 
                       paragraph_text: cstring; paragraph_length: gint; 
                       analysis: Analysis; 
                       glyphs: GlyphString) {.
    importc: "pango_shape_full", libpango.}
proc reorder_items*(logical_items: glib.GList): glib.GList {.
    importc: "pango_reorder_items", libpango.}

proc attr_type_get_type*(): GType {.importc: "pango_attr_type_get_type", 
    libpango.}
proc underline_get_type*(): GType {.importc: "pango_underline_get_type", 
    libpango.}
proc bidi_type_get_type*(): GType {.importc: "pango_bidi_type_get_type", 
    libpango.}
proc direction_get_type*(): GType {.importc: "pango_direction_get_type", 
    libpango.}
proc coverage_level_get_type*(): GType {.
    importc: "pango_coverage_level_get_type", libpango.}
proc style_get_type*(): GType {.importc: "pango_style_get_type", 
                                      libpango.}
proc variant_get_type*(): GType {.importc: "pango_variant_get_type", 
    libpango.}
proc weight_get_type*(): GType {.importc: "pango_weight_get_type", 
    libpango.}
proc stretch_get_type*(): GType {.importc: "pango_stretch_get_type", 
    libpango.}
proc font_mask_get_type*(): GType {.importc: "pango_font_mask_get_type", 
    libpango.}
proc gravity_get_type*(): GType {.importc: "pango_gravity_get_type", 
    libpango.}
proc gravity_hint_get_type*(): GType {.
    importc: "pango_gravity_hint_get_type", libpango.}
proc alignment_get_type*(): GType {.importc: "pango_alignment_get_type", 
    libpango.}
proc wrap_mode_get_type*(): GType {.importc: "pango_wrap_mode_get_type", 
    libpango.}
proc ellipsize_mode_get_type*(): GType {.
    importc: "pango_ellipsize_mode_get_type", libpango.}
proc render_part_get_type*(): GType {.
    importc: "pango_render_part_get_type", libpango.}
proc script_get_type*(): GType {.importc: "pango_script_get_type", 
    libpango.}
proc tab_align_get_type*(): GType {.importc: "pango_tab_align_get_type", 
    libpango.}

type 
  GlyphItem* =  ptr GlyphItemObj
  GlyphItemPtr* = ptr GlyphItemObj
  GlyphItemObj* = object 
    item*: Item
    glyphs*: GlyphString

proc glyph_item_get_type*(): GType {.
    importc: "pango_glyph_item_get_type", libpango.}
proc split*(orig: GlyphItem; text: cstring; 
                             split_index: cint): GlyphItem {.
    importc: "pango_glyph_item_split", libpango.}
proc copy*(orig: GlyphItem): GlyphItem {.
    importc: "pango_glyph_item_copy", libpango.}
proc free*(glyph_item: GlyphItem) {.
    importc: "pango_glyph_item_free", libpango.}
proc apply_attrs*(glyph_item: GlyphItem; 
                                   text: cstring; list: AttrList): glib.GSList {.
    importc: "pango_glyph_item_apply_attrs", libpango.}
proc letter_space*(glyph_item: GlyphItem; 
                                    text: cstring; 
                                    log_attrs: LogAttr; 
                                    letter_spacing: cint) {.
    importc: "pango_glyph_item_letter_space", libpango.}
proc get_logical_widths*(glyph_item: GlyphItem; 
    text: cstring; logical_widths: var cint) {.
    importc: "pango_glyph_item_get_logical_widths", libpango.}
type 
  GlyphItemIter* =  ptr GlyphItemIterObj
  GlyphItemIterPtr* = ptr GlyphItemIterObj
  GlyphItemIterObj* = object 
    glyph_item*: GlyphItem
    text*: cstring
    start_glyph*: cint
    start_index*: cint
    start_char*: cint
    end_glyph*: cint
    end_index*: cint
    end_char*: cint

proc glyph_item_iter_get_type*(): GType {.
    importc: "pango_glyph_item_iter_get_type", libpango.}
proc copy*(orig: GlyphItemIter): GlyphItemIter {.
    importc: "pango_glyph_item_iter_copy", libpango.}
proc free*(iter: GlyphItemIter) {.
    importc: "pango_glyph_item_iter_free", libpango.}
proc init_start*(iter: GlyphItemIter; 
    glyph_item: GlyphItem; text: cstring): gboolean {.
    importc: "pango_glyph_item_iter_init_start", libpango.}
proc init_end*(iter: GlyphItemIter; 
                                     glyph_item: GlyphItem; 
                                     text: cstring): gboolean {.
    importc: "pango_glyph_item_iter_init_end", libpango.}
proc next_cluster*(iter: GlyphItemIter): gboolean {.
    importc: "pango_glyph_item_iter_next_cluster", libpango.}
proc prev_cluster*(iter: GlyphItemIter): gboolean {.
    importc: "pango_glyph_item_iter_prev_cluster", libpango.}

type 
  TabArray* =  ptr TabArrayObj
  TabArrayPtr* = ptr TabArrayObj
  TabArrayObj* = object 
  
type 
  TabAlign* {.size: sizeof(cint), pure.} = enum 
    LEFT
proc tab_array_new*(initial_size: gint; positions_in_pixels: gboolean): TabArray {.
    importc: "pango_tab_array_new", libpango.}
proc tab_array_new_with_positions*(size: gint; 
    positions_in_pixels: gboolean; first_alignment: TabAlign; 
    first_position: gint): TabArray {.varargs, 
    importc: "pango_tab_array_new_with_positions", libpango.}
proc tab_array_get_type*(): GType {.importc: "pango_tab_array_get_type", 
    libpango.}
proc copy*(src: TabArray): TabArray {.
    importc: "pango_tab_array_copy", libpango.}
proc free*(tab_array: TabArray) {.
    importc: "pango_tab_array_free", libpango.}
proc get_size*(tab_array: TabArray): gint {.
    importc: "pango_tab_array_get_size", libpango.}
proc size*(tab_array: TabArray): gint {.
    importc: "pango_tab_array_get_size", libpango.}
proc resize*(tab_array: TabArray; new_size: gint) {.
    importc: "pango_tab_array_resize", libpango.}
proc set_tab*(tab_array: TabArray; tab_index: gint; 
                              alignment: TabAlign; location: gint) {.
    importc: "pango_tab_array_set_tab", libpango.}
proc `tab=`*(tab_array: TabArray; tab_index: gint; 
                              alignment: TabAlign; location: gint) {.
    importc: "pango_tab_array_set_tab", libpango.}
proc get_tab*(tab_array: TabArray; tab_index: gint; 
                              alignment: ptr TabAlign; location: var gint) {.
    importc: "pango_tab_array_get_tab", libpango.}
proc get_tabs*(tab_array: TabArray; 
                               alignments: var ptr TabAlign; 
                               locations: var ptr gint) {.
    importc: "pango_tab_array_get_tabs", libpango.}
proc get_positions_in_pixels*(tab_array: TabArray): gboolean {.
    importc: "pango_tab_array_get_positions_in_pixels", libpango.}
proc positions_in_pixels*(tab_array: TabArray): gboolean {.
    importc: "pango_tab_array_get_positions_in_pixels", libpango.}

type 
  Layout* =  ptr LayoutObj
  LayoutPtr* = ptr LayoutObj
  LayoutObj* = object 
  
type 
  LayoutRun* =  ptr LayoutRunObj
  LayoutRunPtr* = ptr LayoutRunObj
  LayoutRunObj* = GlyphItemObj
type 
  Alignment* {.size: sizeof(cint), pure.} = enum 
    LEFT, CENTER, RIGHT
type 
  WrapMode* {.size: sizeof(cint), pure.} = enum 
    WORD, CHAR, WORD_CHAR
type 
  EllipsizeMode* {.size: sizeof(cint), pure.} = enum 
    NONE, START, MIDDLE, 
    `END`
type 
  LayoutLine* =  ptr LayoutLineObj
  LayoutLinePtr* = ptr LayoutLineObj
  LayoutLineObj* = object 
    layout*: Layout
    start_index*: gint
    length*: gint
    runs*: glib.GSList
    bitfield0PangoLayoutLine*: guint

template pango_layout*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, layout_get_type(), LayoutObj))

template pango_layout_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, layout_get_type(), LayoutClass))

template pango_is_layout*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, layout_get_type()))

template pango_is_layout_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, layout_get_type()))

template pango_layout_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, layout_get_type(), LayoutClass))

proc layout_get_type*(): GType {.importc: "pango_layout_get_type", 
    libpango.}
proc layout_new*(context: Context): Layout {.
    importc: "pango_layout_new", libpango.}
proc copy*(src: Layout): Layout {.
    importc: "pango_layout_copy", libpango.}
proc get_context*(layout: Layout): Context {.
    importc: "pango_layout_get_context", libpango.}
proc context*(layout: Layout): Context {.
    importc: "pango_layout_get_context", libpango.}
proc set_attributes*(layout: Layout; 
                                  attrs: AttrList) {.
    importc: "pango_layout_set_attributes", libpango.}
proc `attributes=`*(layout: Layout; 
                                  attrs: AttrList) {.
    importc: "pango_layout_set_attributes", libpango.}
proc get_attributes*(layout: Layout): AttrList {.
    importc: "pango_layout_get_attributes", libpango.}
proc attributes*(layout: Layout): AttrList {.
    importc: "pango_layout_get_attributes", libpango.}
proc set_text*(layout: Layout; text: cstring; 
                            length: cint) {.importc: "pango_layout_set_text", 
    libpango.}
proc `text=`*(layout: Layout; text: cstring; 
                            length: cint) {.importc: "pango_layout_set_text", 
    libpango.}
proc get_text*(layout: Layout): cstring {.
    importc: "pango_layout_get_text", libpango.}
proc text*(layout: Layout): cstring {.
    importc: "pango_layout_get_text", libpango.}
proc get_character_count*(layout: Layout): gint {.
    importc: "pango_layout_get_character_count", libpango.}
proc character_count*(layout: Layout): gint {.
    importc: "pango_layout_get_character_count", libpango.}
proc set_markup*(layout: Layout; markup: cstring; 
                              length: cint) {.
    importc: "pango_layout_set_markup", libpango.}
proc `markup=`*(layout: Layout; markup: cstring; 
                              length: cint) {.
    importc: "pango_layout_set_markup", libpango.}
proc set_markup_with_accel*(layout: Layout; 
    markup: cstring; length: cint; accel_marker: gunichar; 
    accel_char: var gunichar) {.importc: "pango_layout_set_markup_with_accel", 
                                libpango.}
proc `markup_with_accel=`*(layout: Layout; 
    markup: cstring; length: cint; accel_marker: gunichar; 
    accel_char: var gunichar) {.importc: "pango_layout_set_markup_with_accel", 
                                libpango.}
proc set_font_description*(layout: Layout; 
    desc: FontDescription) {.importc: "pango_layout_set_font_description", 
                                      libpango.}
proc `font_description=`*(layout: Layout; 
    desc: FontDescription) {.importc: "pango_layout_set_font_description", 
                                      libpango.}
proc get_font_description*(layout: Layout): FontDescription {.
    importc: "pango_layout_get_font_description", libpango.}
proc font_description*(layout: Layout): FontDescription {.
    importc: "pango_layout_get_font_description", libpango.}
proc set_width*(layout: Layout; width: cint) {.
    importc: "pango_layout_set_width", libpango.}
proc `width=`*(layout: Layout; width: cint) {.
    importc: "pango_layout_set_width", libpango.}
proc get_width*(layout: Layout): cint {.
    importc: "pango_layout_get_width", libpango.}
proc width*(layout: Layout): cint {.
    importc: "pango_layout_get_width", libpango.}
proc set_height*(layout: Layout; height: cint) {.
    importc: "pango_layout_set_height", libpango.}
proc `height=`*(layout: Layout; height: cint) {.
    importc: "pango_layout_set_height", libpango.}
proc get_height*(layout: Layout): cint {.
    importc: "pango_layout_get_height", libpango.}
proc height*(layout: Layout): cint {.
    importc: "pango_layout_get_height", libpango.}
proc set_wrap*(layout: Layout; wrap: WrapMode) {.
    importc: "pango_layout_set_wrap", libpango.}
proc `wrap=`*(layout: Layout; wrap: WrapMode) {.
    importc: "pango_layout_set_wrap", libpango.}
proc get_wrap*(layout: Layout): WrapMode {.
    importc: "pango_layout_get_wrap", libpango.}
proc wrap*(layout: Layout): WrapMode {.
    importc: "pango_layout_get_wrap", libpango.}
proc is_wrapped*(layout: Layout): gboolean {.
    importc: "pango_layout_is_wrapped", libpango.}
proc set_indent*(layout: Layout; indent: cint) {.
    importc: "pango_layout_set_indent", libpango.}
proc `indent=`*(layout: Layout; indent: cint) {.
    importc: "pango_layout_set_indent", libpango.}
proc get_indent*(layout: Layout): cint {.
    importc: "pango_layout_get_indent", libpango.}
proc indent*(layout: Layout): cint {.
    importc: "pango_layout_get_indent", libpango.}
proc set_spacing*(layout: Layout; spacing: cint) {.
    importc: "pango_layout_set_spacing", libpango.}
proc `spacing=`*(layout: Layout; spacing: cint) {.
    importc: "pango_layout_set_spacing", libpango.}
proc get_spacing*(layout: Layout): cint {.
    importc: "pango_layout_get_spacing", libpango.}
proc spacing*(layout: Layout): cint {.
    importc: "pango_layout_get_spacing", libpango.}
proc set_justify*(layout: Layout; justify: gboolean) {.
    importc: "pango_layout_set_justify", libpango.}
proc `justify=`*(layout: Layout; justify: gboolean) {.
    importc: "pango_layout_set_justify", libpango.}
proc get_justify*(layout: Layout): gboolean {.
    importc: "pango_layout_get_justify", libpango.}
proc justify*(layout: Layout): gboolean {.
    importc: "pango_layout_get_justify", libpango.}
proc set_auto_dir*(layout: Layout; auto_dir: gboolean) {.
    importc: "pango_layout_set_auto_dir", libpango.}
proc `auto_dir=`*(layout: Layout; auto_dir: gboolean) {.
    importc: "pango_layout_set_auto_dir", libpango.}
proc get_auto_dir*(layout: Layout): gboolean {.
    importc: "pango_layout_get_auto_dir", libpango.}
proc auto_dir*(layout: Layout): gboolean {.
    importc: "pango_layout_get_auto_dir", libpango.}
proc set_alignment*(layout: Layout; 
                                 alignment: Alignment) {.
    importc: "pango_layout_set_alignment", libpango.}
proc `alignment=`*(layout: Layout; 
                                 alignment: Alignment) {.
    importc: "pango_layout_set_alignment", libpango.}
proc get_alignment*(layout: Layout): Alignment {.
    importc: "pango_layout_get_alignment", libpango.}
proc alignment*(layout: Layout): Alignment {.
    importc: "pango_layout_get_alignment", libpango.}
proc set_tabs*(layout: Layout; tabs: TabArray) {.
    importc: "pango_layout_set_tabs", libpango.}
proc `tabs=`*(layout: Layout; tabs: TabArray) {.
    importc: "pango_layout_set_tabs", libpango.}
proc get_tabs*(layout: Layout): TabArray {.
    importc: "pango_layout_get_tabs", libpango.}
proc tabs*(layout: Layout): TabArray {.
    importc: "pango_layout_get_tabs", libpango.}
proc set_single_paragraph_mode*(layout: Layout; 
    setting: gboolean) {.importc: "pango_layout_set_single_paragraph_mode", 
                         libpango.}
proc `single_paragraph_mode=`*(layout: Layout; 
    setting: gboolean) {.importc: "pango_layout_set_single_paragraph_mode", 
                         libpango.}
proc get_single_paragraph_mode*(layout: Layout): gboolean {.
    importc: "pango_layout_get_single_paragraph_mode", libpango.}
proc single_paragraph_mode*(layout: Layout): gboolean {.
    importc: "pango_layout_get_single_paragraph_mode", libpango.}
proc set_ellipsize*(layout: Layout; 
                                 ellipsize: EllipsizeMode) {.
    importc: "pango_layout_set_ellipsize", libpango.}
proc `ellipsize=`*(layout: Layout; 
                                 ellipsize: EllipsizeMode) {.
    importc: "pango_layout_set_ellipsize", libpango.}
proc get_ellipsize*(layout: Layout): EllipsizeMode {.
    importc: "pango_layout_get_ellipsize", libpango.}
proc ellipsize*(layout: Layout): EllipsizeMode {.
    importc: "pango_layout_get_ellipsize", libpango.}
proc is_ellipsized*(layout: Layout): gboolean {.
    importc: "pango_layout_is_ellipsized", libpango.}
proc get_unknown_glyphs_count*(layout: Layout): cint {.
    importc: "pango_layout_get_unknown_glyphs_count", libpango.}
proc unknown_glyphs_count*(layout: Layout): cint {.
    importc: "pango_layout_get_unknown_glyphs_count", libpango.}
proc context_changed*(layout: Layout) {.
    importc: "pango_layout_context_changed", libpango.}
proc get_serial*(layout: Layout): guint {.
    importc: "pango_layout_get_serial", libpango.}
proc serial*(layout: Layout): guint {.
    importc: "pango_layout_get_serial", libpango.}
proc get_log_attrs*(layout: Layout; 
                                 attrs: var LogAttr; 
                                 n_attrs: var gint) {.
    importc: "pango_layout_get_log_attrs", libpango.}
proc get_log_attrs_readonly*(layout: Layout; 
    n_attrs: var gint): LogAttr {.
    importc: "pango_layout_get_log_attrs_readonly", libpango.}
proc log_attrs_readonly*(layout: Layout; 
    n_attrs: var gint): LogAttr {.
    importc: "pango_layout_get_log_attrs_readonly", libpango.}
proc index_to_pos*(layout: Layout; index: cint; 
                                pos: var RectangleObj) {.
    importc: "pango_layout_index_to_pos", libpango.}
proc index_to_line_x*(layout: Layout; index: cint; 
                                   trailing: gboolean; line: var cint; 
                                   x_pos: var cint) {.
    importc: "pango_layout_index_to_line_x", libpango.}
proc get_cursor_pos*(layout: Layout; index: cint; 
                                  strong_pos: var RectangleObj; 
                                  weak_pos: var RectangleObj) {.
    importc: "pango_layout_get_cursor_pos", libpango.}
proc move_cursor_visually*(layout: Layout; 
    strong: gboolean; old_index: cint; old_trailing: cint; direction: cint; 
    new_index: var cint; new_trailing: var cint) {.
    importc: "pango_layout_move_cursor_visually", libpango.}
proc xy_to_index*(layout: Layout; x: cint; y: cint; 
                               index: var cint; trailing: var cint): gboolean {.
    importc: "pango_layout_xy_to_index", libpango.}
proc get_extents*(layout: Layout; 
                               ink_rect: var RectangleObj; 
                               logical_rect: var RectangleObj) {.
    importc: "pango_layout_get_extents", libpango.}
proc get_pixel_extents*(layout: Layout; 
                                     ink_rect: var RectangleObj; 
                                     logical_rect: var RectangleObj) {.
    importc: "pango_layout_get_pixel_extents", libpango.}
proc get_size*(layout: Layout; width: var cint; 
                            height: var cint) {.
    importc: "pango_layout_get_size", libpango.}
proc get_pixel_size*(layout: Layout; width: var cint; 
                                  height: var cint) {.
    importc: "pango_layout_get_pixel_size", libpango.}
proc get_baseline*(layout: Layout): cint {.
    importc: "pango_layout_get_baseline", libpango.}
proc baseline*(layout: Layout): cint {.
    importc: "pango_layout_get_baseline", libpango.}
proc get_line_count*(layout: Layout): cint {.
    importc: "pango_layout_get_line_count", libpango.}
proc line_count*(layout: Layout): cint {.
    importc: "pango_layout_get_line_count", libpango.}
proc get_line*(layout: Layout; line: cint): LayoutLine {.
    importc: "pango_layout_get_line", libpango.}
proc line*(layout: Layout; line: cint): LayoutLine {.
    importc: "pango_layout_get_line", libpango.}
proc get_line_readonly*(layout: Layout; line: cint): LayoutLine {.
    importc: "pango_layout_get_line_readonly", libpango.}
proc line_readonly*(layout: Layout; line: cint): LayoutLine {.
    importc: "pango_layout_get_line_readonly", libpango.}
proc get_lines*(layout: Layout): glib.GSList {.
    importc: "pango_layout_get_lines", libpango.}
proc lines*(layout: Layout): glib.GSList {.
    importc: "pango_layout_get_lines", libpango.}
proc get_lines_readonly*(layout: Layout): glib.GSList {.
    importc: "pango_layout_get_lines_readonly", libpango.}
proc lines_readonly*(layout: Layout): glib.GSList {.
    importc: "pango_layout_get_lines_readonly", libpango.}
proc layout_line_get_type*(): GType {.
    importc: "pango_layout_line_get_type", libpango.}
proc `ref`*(line: LayoutLine): LayoutLine {.
    importc: "pango_layout_line_ref", libpango.}
proc unref*(line: LayoutLine) {.
    importc: "pango_layout_line_unref", libpango.}
proc x_to_index*(line: LayoutLine; x_pos: cint; 
                                   index: var cint; trailing: var cint): gboolean {.
    importc: "pango_layout_line_x_to_index", libpango.}
proc index_to_x*(line: LayoutLine; index: cint; 
                                   trailing: gboolean; x_pos: var cint) {.
    importc: "pango_layout_line_index_to_x", libpango.}
proc get_x_ranges*(line: LayoutLine; 
                                     start_index: cint; end_index: cint; 
                                     ranges: var ptr cint; n_ranges: var cint) {.
    importc: "pango_layout_line_get_x_ranges", libpango.}
proc get_extents*(line: LayoutLine; 
                                    ink_rect: var RectangleObj; 
                                    logical_rect: var RectangleObj) {.
    importc: "pango_layout_line_get_extents", libpango.}
proc get_pixel_extents*(layout_line: LayoutLine; 
    ink_rect: var RectangleObj; logical_rect: var RectangleObj) {.
    importc: "pango_layout_line_get_pixel_extents", libpango.}
type 
  LayoutIter* =  ptr LayoutIterObj
  LayoutIterPtr* = ptr LayoutIterObj
  LayoutIterObj* = object 
  
proc layout_iter_get_type*(): GType {.
    importc: "pango_layout_iter_get_type", libpango.}
proc get_iter*(layout: Layout): LayoutIter {.
    importc: "pango_layout_get_iter", libpango.}
proc iter*(layout: Layout): LayoutIter {.
    importc: "pango_layout_get_iter", libpango.}
proc copy*(iter: LayoutIter): LayoutIter {.
    importc: "pango_layout_iter_copy", libpango.}
proc free*(iter: LayoutIter) {.
    importc: "pango_layout_iter_free", libpango.}
proc get_index*(iter: LayoutIter): cint {.
    importc: "pango_layout_iter_get_index", libpango.}
proc index*(iter: LayoutIter): cint {.
    importc: "pango_layout_iter_get_index", libpango.}
proc get_run*(iter: LayoutIter): LayoutRun {.
    importc: "pango_layout_iter_get_run", libpango.}
proc run*(iter: LayoutIter): LayoutRun {.
    importc: "pango_layout_iter_get_run", libpango.}
proc get_run_readonly*(iter: LayoutIter): LayoutRun {.
    importc: "pango_layout_iter_get_run_readonly", libpango.}
proc run_readonly*(iter: LayoutIter): LayoutRun {.
    importc: "pango_layout_iter_get_run_readonly", libpango.}
proc get_line*(iter: LayoutIter): LayoutLine {.
    importc: "pango_layout_iter_get_line", libpango.}
proc line*(iter: LayoutIter): LayoutLine {.
    importc: "pango_layout_iter_get_line", libpango.}
proc get_line_readonly*(iter: LayoutIter): LayoutLine {.
    importc: "pango_layout_iter_get_line_readonly", libpango.}
proc line_readonly*(iter: LayoutIter): LayoutLine {.
    importc: "pango_layout_iter_get_line_readonly", libpango.}
proc at_last_line*(iter: LayoutIter): gboolean {.
    importc: "pango_layout_iter_at_last_line", libpango.}
proc get_layout*(iter: LayoutIter): Layout {.
    importc: "pango_layout_iter_get_layout", libpango.}
proc layout*(iter: LayoutIter): Layout {.
    importc: "pango_layout_iter_get_layout", libpango.}
proc next_char*(iter: LayoutIter): gboolean {.
    importc: "pango_layout_iter_next_char", libpango.}
proc next_cluster*(iter: LayoutIter): gboolean {.
    importc: "pango_layout_iter_next_cluster", libpango.}
proc next_run*(iter: LayoutIter): gboolean {.
    importc: "pango_layout_iter_next_run", libpango.}
proc next_line*(iter: LayoutIter): gboolean {.
    importc: "pango_layout_iter_next_line", libpango.}
proc get_char_extents*(iter: LayoutIter; 
    logical_rect: var RectangleObj) {.
    importc: "pango_layout_iter_get_char_extents", libpango.}
proc get_cluster_extents*(iter: LayoutIter; 
    ink_rect: var RectangleObj; logical_rect: var RectangleObj) {.
    importc: "pango_layout_iter_get_cluster_extents", libpango.}
proc get_run_extents*(iter: LayoutIter; 
    ink_rect: var RectangleObj; logical_rect: var RectangleObj) {.
    importc: "pango_layout_iter_get_run_extents", libpango.}
proc get_line_extents*(iter: LayoutIter; 
    ink_rect: var RectangleObj; logical_rect: var RectangleObj) {.
    importc: "pango_layout_iter_get_line_extents", libpango.}
proc get_line_yrange*(iter: LayoutIter; 
    y0: var cint; y1: var cint) {.importc: "pango_layout_iter_get_line_yrange", 
                                    libpango.}
proc get_layout_extents*(iter: LayoutIter; 
    ink_rect: var RectangleObj; logical_rect: var RectangleObj) {.
    importc: "pango_layout_iter_get_layout_extents", libpango.}
proc get_baseline*(iter: LayoutIter): cint {.
    importc: "pango_layout_iter_get_baseline", libpango.}
proc baseline*(iter: LayoutIter): cint {.
    importc: "pango_layout_iter_get_baseline", libpango.}

template pango_renderer*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, renderer_get_type(), RendererObj))

template pango_is_renderer*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, renderer_get_type()))

template pango_renderer_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, renderer_get_type(), RendererClassObj))

template pango_is_renderer_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, renderer_get_type()))

template pango_renderer_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, renderer_get_type(), RendererClassObj))

type 
  RendererPrivateObj = object 
  
type 
  RenderPart* {.size: sizeof(cint), pure.} = enum 
    FOREGROUND, BACKGROUND, 
    UNDERLINE, STRIKETHROUGH
type 
  Renderer* =  ptr RendererObj
  RendererPtr* = ptr RendererObj
  RendererObj* = object of GObjectObj
    underline*: Underline
    strikethrough*: gboolean
    active_count*: cint
    matrix*: Matrix
    priv0*: ptr RendererPrivateObj

type 
  RendererClass* =  ptr RendererClassObj
  RendererClassPtr* = ptr RendererClassObj
  RendererClassObj* = object of GObjectClassObj
    draw_glyphs*: proc (renderer: Renderer; font: Font; 
                        glyphs: GlyphString; x: cint; y: cint) {.cdecl.}
    draw_rectangle*: proc (renderer: Renderer; part: RenderPart; 
                           x: cint; y: cint; width: cint; height: cint) {.cdecl.}
    draw_error_underline*: proc (renderer: Renderer; x: cint; 
                                 y: cint; width: cint; height: cint) {.cdecl.}
    draw_shape*: proc (renderer: Renderer; attr: AttrShape; 
                       x: cint; y: cint) {.cdecl.}
    draw_trapezoid*: proc (renderer: Renderer; part: RenderPart; 
                           y1: cdouble; x11: cdouble; x21: cdouble; 
                           y2: cdouble; x12: cdouble; x22: cdouble) {.cdecl.}
    draw_glyph*: proc (renderer: Renderer; font: Font; 
                       glyph: Glyph; x: cdouble; y: cdouble) {.cdecl.}
    part_changed*: proc (renderer: Renderer; part: RenderPart) {.cdecl.}
    begin*: proc (renderer: Renderer) {.cdecl.}
    `end`*: proc (renderer: Renderer) {.cdecl.}
    prepare_run*: proc (renderer: Renderer; run: LayoutRun) {.cdecl.}
    draw_glyph_item*: proc (renderer: Renderer; text: cstring; 
                            glyph_item: GlyphItem; x: cint; y: cint) {.cdecl.}
    pango_reserved02: proc () {.cdecl.}
    pango_reserved03: proc () {.cdecl.}
    pango_reserved04: proc () {.cdecl.}

proc renderer_get_type*(): GType {.importc: "pango_renderer_get_type", 
    libpango.}
proc draw_layout*(renderer: Renderer; 
                                 layout: Layout; x: cint; y: cint) {.
    importc: "pango_renderer_draw_layout", libpango.}
proc draw_layout_line*(renderer: Renderer; 
                                      line: LayoutLine; x: cint; 
                                      y: cint) {.
    importc: "pango_renderer_draw_layout_line", libpango.}
proc draw_glyphs*(renderer: Renderer; 
                                 font: Font; 
                                 glyphs: GlyphString; x: cint; 
                                 y: cint) {.
    importc: "pango_renderer_draw_glyphs", libpango.}
proc draw_glyph_item*(renderer: Renderer; 
                                     text: cstring; 
                                     glyph_item: GlyphItem; x: cint; 
                                     y: cint) {.
    importc: "pango_renderer_draw_glyph_item", libpango.}
proc draw_rectangle*(renderer: Renderer; 
                                    part: RenderPart; x: cint; y: cint; 
                                    width: cint; height: cint) {.
    importc: "pango_renderer_draw_rectangle", libpango.}
proc draw_error_underline*(renderer: Renderer; 
    x: cint; y: cint; width: cint; height: cint) {.
    importc: "pango_renderer_draw_error_underline", libpango.}
proc draw_trapezoid*(renderer: Renderer; 
                                    part: RenderPart; y1: cdouble; 
                                    x11: cdouble; x21: cdouble; y2: cdouble; 
                                    x12: cdouble; x22: cdouble) {.
    importc: "pango_renderer_draw_trapezoid", libpango.}
proc draw_glyph*(renderer: Renderer; 
                                font: Font; glyph: Glyph; 
                                x: cdouble; y: cdouble) {.
    importc: "pango_renderer_draw_glyph", libpango.}
proc activate*(renderer: Renderer) {.
    importc: "pango_renderer_activate", libpango.}
proc deactivate*(renderer: Renderer) {.
    importc: "pango_renderer_deactivate", libpango.}
proc part_changed*(renderer: Renderer; 
                                  part: RenderPart) {.
    importc: "pango_renderer_part_changed", libpango.}
proc set_color*(renderer: Renderer; 
                               part: RenderPart; color: Color) {.
    importc: "pango_renderer_set_color", libpango.}
proc `color=`*(renderer: Renderer; 
                               part: RenderPart; color: Color) {.
    importc: "pango_renderer_set_color", libpango.}
proc get_color*(renderer: Renderer; 
                               part: RenderPart): Color {.
    importc: "pango_renderer_get_color", libpango.}
proc color*(renderer: Renderer; 
                               part: RenderPart): Color {.
    importc: "pango_renderer_get_color", libpango.}
proc set_matrix*(renderer: Renderer; 
                                matrix: Matrix) {.
    importc: "pango_renderer_set_matrix", libpango.}
proc `matrix=`*(renderer: Renderer; 
                                matrix: Matrix) {.
    importc: "pango_renderer_set_matrix", libpango.}
proc get_matrix*(renderer: Renderer): Matrix {.
    importc: "pango_renderer_get_matrix", libpango.}
proc matrix*(renderer: Renderer): Matrix {.
    importc: "pango_renderer_get_matrix", libpango.}
proc get_layout*(renderer: Renderer): Layout {.
    importc: "pango_renderer_get_layout", libpango.}
proc layout*(renderer: Renderer): Layout {.
    importc: "pango_renderer_get_layout", libpango.}
proc get_layout_line*(renderer: Renderer): LayoutLine {.
    importc: "pango_renderer_get_layout_line", libpango.}
proc layout_line*(renderer: Renderer): LayoutLine {.
    importc: "pango_renderer_get_layout_line", libpango.}

proc split_file_list*(str: cstring): cstringArray {.
    importc: "pango_split_file_list", libpango.}
proc trim_string*(str: cstring): cstring {.importc: "pango_trim_string", 
    libpango.}
proc read_line*(stream: ptr FILE; str: glib.GString): gint {.
    importc: "pango_read_line", libpango.}
proc skip_space*(pos: cstringArray): gboolean {.
    importc: "pango_skip_space", libpango.}
proc scan_word*(pos: cstringArray; `out`: glib.GString): gboolean {.
    importc: "pango_scan_word", libpango.}
proc scan_string*(pos: cstringArray; `out`: glib.GString): gboolean {.
    importc: "pango_scan_string", libpango.}
proc scan_int*(pos: cstringArray; `out`: var cint): gboolean {.
    importc: "pango_scan_int", libpango.}
when ENABLE_BACKEND: 
  proc config_key_get_system*(key: cstring): cstring {.
      importc: "pango_config_key_get_system", libpango.}
  proc config_key_get*(key: cstring): cstring {.
      importc: "pango_config_key_get", libpango.}
  proc lookup_aliases*(fontname: cstring; families: ptr cstringArray; 
                             n_families: var cint) {.
      importc: "pango_lookup_aliases", libpango.}
proc parse_enum*(`type`: GType; str: cstring; value: var cint; 
                       warn: gboolean; possible_values: cstringArray): gboolean {.
    importc: "pango_parse_enum", libpango.}
proc parse_style*(str: cstring; style: var Style; warn: gboolean): gboolean {.
    importc: "pango_parse_style", libpango.}
proc parse_variant*(str: cstring; variant: var Variant; 
                          warn: gboolean): gboolean {.
    importc: "pango_parse_variant", libpango.}
proc parse_weight*(str: cstring; weight: var Weight; warn: gboolean): gboolean {.
    importc: "pango_parse_weight", libpango.}
proc parse_stretch*(str: cstring; stretch: var Stretch; 
                          warn: gboolean): gboolean {.
    importc: "pango_parse_stretch", libpango.}
when ENABLE_BACKEND: 
  proc get_sysconf_subdirectory*(): cstring {.
      importc: "pango_get_sysconf_subdirectory", libpango.}
  proc get_lib_subdirectory*(): cstring {.
      importc: "pango_get_lib_subdirectory", libpango.}
proc quantize_line_geometry*(thickness: var cint; position: var cint) {.
    importc: "pango_quantize_line_geometry", libpango.}
proc log2vis_get_embedding_levels*(text: cstring; length: cint; 
    pbase_dir: var Direction): ptr guint8 {.
    importc: "pango_log2vis_get_embedding_levels", libpango.}
proc is_zero_width*(ch: gunichar): gboolean {.
    importc: "pango_is_zero_width", libpango.}
template pango_version_encode*(major, minor, micro: expr): expr = 
  ((major * 10000) + (minor * 100) + (micro * 1))

const 
  VERSION* = pango_version_encode(VERSION_MAJOR, 
      VERSION_MINOR, VERSION_MICRO)
template pango_version_check*(major, minor, micro: expr): expr = 
  (VERSION >= pango_version_encode(major, minor, micro))

proc version*(): cint {.importc: "pango_version", libpango.}
proc version_string*(): cstring {.importc: "pango_version_string", 
    libpango.}
proc version_check*(required_major: cint; required_minor: cint; 
                          required_micro: cint): cstring {.
    importc: "pango_version_check", libpango.}

when ENABLE_BACKEND: 
  type 
    Map* =  ptr MapObj
    MapPtr* = ptr MapObj
    MapObj* = object 
    
  type 
    IncludedModule* =  ptr IncludedModuleObj
    IncludedModulePtr* = ptr IncludedModuleObj
    IncludedModuleObj* = object 
      list*: proc (engines: var EngineInfo; n_engines: var cint) {.cdecl.}
      init*: proc (module: gobject.GTypeModule) {.cdecl.}
      exit*: proc () {.cdecl.}
      create*: proc (id: cstring): Engine {.cdecl.}

  proc find_map*(language: Language; engine_type_id: guint; 
                       render_type_id: guint): Map {.
      importc: "pango_find_map", libpango.}
  proc get_engine*(map: Map; script: Script): Engine {.
      importc: "pango_map_get_engine", libpango.}
  proc engine*(map: Map; script: Script): Engine {.
      importc: "pango_map_get_engine", libpango.}
  proc get_engines*(map: Map; script: Script; 
                              exact_engines: var glib.GSList; 
                              fallback_engines: var glib.GSList) {.
      importc: "pango_map_get_engines", libpango.}
  proc module_register*(module: IncludedModule) {.
      importc: "pango_module_register", libpango.}
