 {.deadCodeElim: on.}
include "cairo_pragma.nim"
const 
  CAIRO_HAS_TEE_SURFACE = true
  CAIRO_HAS_DRM_SURFACE = true
  CAIRO_HAS_SKIA_SURFACE = true
  CAIRO_HAS_SCRIPT_SURFACE = true
  CAIRO_HAS_XML_SURFACE = true
  CAIRO_HAS_SVG_SURFACE = true
  CAIRO_HAS_PS_SURFACE = true
  CAIRO_HAS_PDF_SURFACE = true
  CAIRO_HAS_PNG_FUNCTIONS = true

template cairo_version_encode*(major, minor, micro: expr): expr = 
  ((major * 10000) + (minor * 100) + (micro * 1))

proc cairo_version*(): cint {.importc: "cairo_version", libcairo.}
proc cairo_version_string*(): cstring {.importc: "cairo_version_string", 
    libcairo.}
type
  cairo_bool_t* = distinct cint

# we should not need these constants often, because we have converters to and from Nim bool
const
  CAIRO_FALSE* = cairo_bool_t(0)
  CAIRO_TRUE* = cairo_bool_t(1)

converter cbool*(nimbool: bool):cairo_bool_t =
  ord(nimbool).cairo_bool_t

converter toBool*(cbool: cairo_bool_t): bool =
  int(cbool) != 0

type 
  Context* =  ptr ContextObj
  ContextPtr* = ptr ContextObj
  ContextObj* = object 
  
type 
  Surface* =  ptr SurfaceObj
  SurfacePtr* = ptr SurfaceObj
  SurfaceObj* = object 
  
type 
  Device* =  ptr DeviceObj
  DevicePtr* = ptr DeviceObj
  DeviceObj* = object 
  
type 
  Matrix* =  ptr MatrixObj
  MatrixPtr* = ptr MatrixObj
  MatrixObj* = object 
    xx*: cdouble
    yx*: cdouble
    xy*: cdouble
    yy*: cdouble
    x0*: cdouble
    y0*: cdouble

converter matrixobj2matrix(m: var MatrixObj): Matrix =
  addr(m)
type 
  Pattern* =  ptr PatternObj
  PatternPtr* = ptr PatternObj
  PatternObj* = object 
  
type 
  cairo_destroy_func_t* = proc (data: pointer) {.cdecl.}
type 
  User_data_key* =  ptr User_data_keyObj
  User_data_keyPtr* = ptr User_data_keyObj
  User_data_keyObj* = object 
    unused: cint

type 
  Status* {.size: sizeof(cint), pure.} = enum 
    SUCCESS = 0, NO_MEMORY, 
    INVALID_RESTORE, INVALID_POP_GROUP, 
    NO_CURRENT_POINT, INVALID_MATRIX, 
    INVALID_STATUS, NULL_POINTER, 
    INVALID_STRING, INVALID_PATH_DATA, 
    READ_ERROR, WRITE_ERROR, 
    SURFACE_FINISHED, SURFACE_TYPE_MISMATCH, 
    PATTERN_TYPE_MISMATCH, INVALID_CONTENT, 
    INVALID_FORMAT, INVALID_VISUAL, 
    FILE_NOT_FOUND, INVALID_DASH, 
    INVALID_DSC_COMMENT, INVALID_INDEX, 
    CLIP_NOT_REPRESENTABLE, TEMP_FILE_ERROR, 
    INVALID_STRIDE, FONT_TYPE_MISMATCH, 
    USER_FONT_IMMUTABLE, USER_FONT_ERROR, 
    NEGATIVE_COUNT, INVALID_CLUSTERS, 
    INVALID_SLANT, INVALID_WEIGHT, 
    INVALID_SIZE, USER_FONT_NOT_IMPLEMENTED, 
    DEVICE_TYPE_MISMATCH, DEVICE_ERROR, 
    INVALID_MESH_CONSTRUCTION, DEVICE_FINISHED, 
    JBIG2_GLOBAL_MISSING, LAST_STATUS
type 
  Content* {.size: sizeof(cint), pure.} = enum 
    COLOR = 0x1000, ALPHA = 0x2000, 
    COLOR_ALPHA = 0x3000
type 
  Format* {.size: sizeof(cint), pure.} = enum 
    INVALID = - 1, ARGB32 = 0, 
    RGB24 = 1, A8 = 2, A1 = 3, 
    RGB16_565 = 4, RGB30 = 5
type 
  cairo_write_func_t* = proc (closure: pointer; data: ptr cuchar; 
                              length: cuint): Status {.cdecl.}
type 
  cairo_read_func_t* = proc (closure: pointer; data: ptr cuchar; length: cuint): Status {.cdecl.}
type 
  Rectangle_int* =  ptr Rectangle_intObj
  Rectangle_intPtr* = ptr Rectangle_intObj
  Rectangle_intObj* = object 
    x*: cint
    y*: cint
    width*: cint
    height*: cint

proc create*(target: Surface): Context {.
    importc: "cairo_create", libcairo.}
proc reference*(cr: Context): Context {.
    importc: "cairo_reference", libcairo.}
proc destroy*(cr: Context) {.importc: "cairo_destroy", libcairo.}
proc get_reference_count*(cr: Context): cuint {.
    importc: "cairo_get_reference_count", libcairo.}
proc reference_count*(cr: Context): cuint {.
    importc: "cairo_get_reference_count", libcairo.}
proc get_user_data*(cr: Context; key: User_data_key): pointer {.
    importc: "cairo_get_user_data", libcairo.}
proc user_data*(cr: Context; key: User_data_key): pointer {.
    importc: "cairo_get_user_data", libcairo.}
proc set_user_data*(cr: Context; key: User_data_key; 
                          user_data: pointer; destroy: cairo_destroy_func_t): Status {.
    importc: "cairo_set_user_data", libcairo.}
proc save*(cr: Context) {.importc: "cairo_save", libcairo.}
proc restore*(cr: Context) {.importc: "cairo_restore", libcairo.}
proc push_group*(cr: Context) {.importc: "cairo_push_group", 
    libcairo.}
proc push_group_with_content*(cr: Context; content: Content) {.
    importc: "cairo_push_group_with_content", libcairo.}
proc pop_group*(cr: Context): Pattern {.
    importc: "cairo_pop_group", libcairo.}
proc pop_group_to_source*(cr: Context) {.
    importc: "cairo_pop_group_to_source", libcairo.}
type 
  Operator* {.size: sizeof(cint), pure.} = enum 
    CLEAR, SOURCE, OVER, 
    `IN`, `OUT`, ATOP, 
    DEST, DEST_OVER, DEST_IN, 
    DEST_OUT, DEST_ATOP, XOR, 
    ADD, SATURATE, MULTIPLY, 
    SCREEN, OVERLAY, DARKEN, 
    LIGHTEN, COLOR_DODGE, 
    COLOR_BURN, HARD_LIGHT, 
    SOFT_LIGHT, DIFFERENCE, 
    EXCLUSION, HSL_HUE, 
    HSL_SATURATION, HSL_COLOR, 
    HSL_LUMINOSITY
proc set_operator*(cr: Context; op: Operator) {.
    importc: "cairo_set_operator", libcairo.}
proc `operator=`*(cr: Context; op: Operator) {.
    importc: "cairo_set_operator", libcairo.}
proc set_source*(cr: Context; source: Pattern) {.
    importc: "cairo_set_source", libcairo.}
proc `source=`*(cr: Context; source: Pattern) {.
    importc: "cairo_set_source", libcairo.}
proc set_source_rgb*(cr: Context; red: cdouble; green: cdouble; 
                           blue: cdouble) {.importc: "cairo_set_source_rgb", 
    libcairo.}
proc `source_rgb=`*(cr: Context; red: cdouble; green: cdouble; 
                           blue: cdouble) {.importc: "cairo_set_source_rgb", 
    libcairo.}
proc set_source_rgba*(cr: Context; red: cdouble; green: cdouble; 
                            blue: cdouble; alpha: cdouble) {.
    importc: "cairo_set_source_rgba", libcairo.}
proc `source_rgba=`*(cr: Context; red: cdouble; green: cdouble; 
                            blue: cdouble; alpha: cdouble) {.
    importc: "cairo_set_source_rgba", libcairo.}
proc set_source_surface*(cr: Context; surface: Surface; 
                               x: cdouble; y: cdouble) {.
    importc: "cairo_set_source_surface", libcairo.}
proc `source_surface=`*(cr: Context; surface: Surface; 
                               x: cdouble; y: cdouble) {.
    importc: "cairo_set_source_surface", libcairo.}
proc set_tolerance*(cr: Context; tolerance: cdouble) {.
    importc: "cairo_set_tolerance", libcairo.}
proc `tolerance=`*(cr: Context; tolerance: cdouble) {.
    importc: "cairo_set_tolerance", libcairo.}
type 
  Antialias* {.size: sizeof(cint), pure.} = enum 
    DEFAULT, NONE, GRAY, 
    SUBPIXEL, FAST, GOOD, 
    BEST
proc set_antialias*(cr: Context; antialias: Antialias) {.
    importc: "cairo_set_antialias", libcairo.}
proc `antialias=`*(cr: Context; antialias: Antialias) {.
    importc: "cairo_set_antialias", libcairo.}
type 
  Fill_rule* {.size: sizeof(cint), pure.} = enum 
    WINDING, EVEN_ODD
proc set_fill_rule*(cr: Context; fill_rule: Fill_rule) {.
    importc: "cairo_set_fill_rule", libcairo.}
proc `fill_rule=`*(cr: Context; fill_rule: Fill_rule) {.
    importc: "cairo_set_fill_rule", libcairo.}
proc set_line_width*(cr: Context; width: cdouble) {.
    importc: "cairo_set_line_width", libcairo.}
proc `line_width=`*(cr: Context; width: cdouble) {.
    importc: "cairo_set_line_width", libcairo.}
type 
  Line_cap* {.size: sizeof(cint), pure.} = enum 
    BUTT, ROUND, SQUARE
proc set_line_cap*(cr: Context; line_cap: Line_cap) {.
    importc: "cairo_set_line_cap", libcairo.}
proc `line_cap=`*(cr: Context; line_cap: Line_cap) {.
    importc: "cairo_set_line_cap", libcairo.}
type 
  Line_join* {.size: sizeof(cint), pure.} = enum 
    MITER, ROUND, BEVEL
proc set_line_join*(cr: Context; line_join: Line_join) {.
    importc: "cairo_set_line_join", libcairo.}
proc `line_join=`*(cr: Context; line_join: Line_join) {.
    importc: "cairo_set_line_join", libcairo.}
proc set_dash*(cr: Context; dashes: var cdouble; num_dashes: cint; 
                     offset: cdouble) {.importc: "cairo_set_dash", libcairo.}
proc `dash=`*(cr: Context; dashes: var cdouble; num_dashes: cint; 
                     offset: cdouble) {.importc: "cairo_set_dash", libcairo.}
proc set_miter_limit*(cr: Context; limit: cdouble) {.
    importc: "cairo_set_miter_limit", libcairo.}
proc `miter_limit=`*(cr: Context; limit: cdouble) {.
    importc: "cairo_set_miter_limit", libcairo.}
proc translate*(cr: Context; tx: cdouble; ty: cdouble) {.
    importc: "cairo_translate", libcairo.}
proc scale*(cr: Context; sx: cdouble; sy: cdouble) {.
    importc: "cairo_scale", libcairo.}
proc rotate*(cr: Context; angle: cdouble) {.importc: "cairo_rotate", 
    libcairo.}
proc transform*(cr: Context; matrix: Matrix) {.
    importc: "cairo_transform", libcairo.}
proc set_matrix*(cr: Context; matrix: Matrix) {.
    importc: "cairo_set_matrix", libcairo.}
proc `matrix=`*(cr: Context; matrix: Matrix) {.
    importc: "cairo_set_matrix", libcairo.}
proc identity_matrix*(cr: Context) {.
    importc: "cairo_identity_matrix", libcairo.}
proc user_to_device*(cr: Context; x: var cdouble; y: var cdouble) {.
    importc: "cairo_user_to_device", libcairo.}
proc user_to_device_distance*(cr: Context; dx: var cdouble; 
                                    dy: var cdouble) {.
    importc: "cairo_user_to_device_distance", libcairo.}
proc device_to_user*(cr: Context; x: var cdouble; y: var cdouble) {.
    importc: "cairo_device_to_user", libcairo.}
proc device_to_user_distance*(cr: Context; dx: var cdouble; 
                                    dy: var cdouble) {.
    importc: "cairo_device_to_user_distance", libcairo.}
proc new_path*(cr: Context) {.importc: "cairo_new_path", libcairo.}
proc move_to*(cr: Context; x: cdouble; y: cdouble) {.
    importc: "cairo_move_to", libcairo.}
proc new_sub_path*(cr: Context) {.importc: "cairo_new_sub_path", 
    libcairo.}
proc line_to*(cr: Context; x: cdouble; y: cdouble) {.
    importc: "cairo_line_to", libcairo.}
proc curve_to*(cr: Context; x1: cdouble; y1: cdouble; x2: cdouble; 
                     y2: cdouble; x3: cdouble; y3: cdouble) {.
    importc: "cairo_curve_to", libcairo.}
proc arc*(cr: Context; xc: cdouble; yc: cdouble; radius: cdouble; 
                angle1: cdouble; angle2: cdouble) {.importc: "cairo_arc", 
    libcairo.}
proc arc_negative*(cr: Context; xc: cdouble; yc: cdouble; 
                         radius: cdouble; angle1: cdouble; angle2: cdouble) {.
    importc: "cairo_arc_negative", libcairo.}
proc rel_move_to*(cr: Context; dx: cdouble; dy: cdouble) {.
    importc: "cairo_rel_move_to", libcairo.}
proc rel_line_to*(cr: Context; dx: cdouble; dy: cdouble) {.
    importc: "cairo_rel_line_to", libcairo.}
proc rel_curve_to*(cr: Context; dx1: cdouble; dy1: cdouble; 
                         dx2: cdouble; dy2: cdouble; dx3: cdouble; 
                         dy3: cdouble) {.importc: "cairo_rel_curve_to", 
    libcairo.}
proc rectangle*(cr: Context; x: cdouble; y: cdouble; width: cdouble; 
                      height: cdouble) {.importc: "cairo_rectangle", 
    libcairo.}
proc close_path*(cr: Context) {.importc: "cairo_close_path", 
    libcairo.}
proc path_extents*(cr: Context; x1: var cdouble; y1: var cdouble; 
                         x2: var cdouble; y2: var cdouble) {.
    importc: "cairo_path_extents", libcairo.}
proc paint*(cr: Context) {.importc: "cairo_paint", libcairo.}
proc paint_with_alpha*(cr: Context; alpha: cdouble) {.
    importc: "cairo_paint_with_alpha", libcairo.}
proc paint*(cr: Context; alpha: cdouble) {.
    importc: "cairo_paint_with_alpha", libcairo.}
proc mask*(cr: Context; pattern: Pattern) {.
    importc: "cairo_mask", libcairo.}
proc mask_surface*(cr: Context; surface: Surface; 
                         surface_x: cdouble; surface_y: cdouble) {.
    importc: "cairo_mask_surface", libcairo.}
proc stroke*(cr: Context) {.importc: "cairo_stroke", libcairo.}
proc stroke_preserve*(cr: Context) {.
    importc: "cairo_stroke_preserve", libcairo.}
proc fill*(cr: Context) {.importc: "cairo_fill", libcairo.}
proc fill_preserve*(cr: Context) {.importc: "cairo_fill_preserve", 
    libcairo.}
proc copy_page*(cr: Context) {.importc: "cairo_copy_page", 
    libcairo.}
proc show_page*(cr: Context) {.importc: "cairo_show_page", 
    libcairo.}
proc in_stroke*(cr: Context; x: cdouble; y: cdouble): cairo_bool_t {.
    importc: "cairo_in_stroke", libcairo.}
proc in_fill*(cr: Context; x: cdouble; y: cdouble): cairo_bool_t {.
    importc: "cairo_in_fill", libcairo.}
proc in_clip*(cr: Context; x: cdouble; y: cdouble): cairo_bool_t {.
    importc: "cairo_in_clip", libcairo.}
proc stroke_extents*(cr: Context; x1: var cdouble; y1: var cdouble; 
                           x2: var cdouble; y2: var cdouble) {.
    importc: "cairo_stroke_extents", libcairo.}
proc fill_extents*(cr: Context; x1: var cdouble; y1: var cdouble; 
                         x2: var cdouble; y2: var cdouble) {.
    importc: "cairo_fill_extents", libcairo.}
proc reset_clip*(cr: Context) {.importc: "cairo_reset_clip", 
    libcairo.}
proc clip*(cr: Context) {.importc: "cairo_clip", libcairo.}
proc clip_preserve*(cr: Context) {.importc: "cairo_clip_preserve", 
    libcairo.}
proc clip_extents*(cr: Context; x1: var cdouble; y1: var cdouble; 
                         x2: var cdouble; y2: var cdouble) {.
    importc: "cairo_clip_extents", libcairo.}
type 
  Rectangle* =  ptr RectangleObj
  RectanglePtr* = ptr RectangleObj
  RectangleObj* = object 
    x*: cdouble
    y*: cdouble
    width*: cdouble
    height*: cdouble

type 
  Rectangle_list* =  ptr Rectangle_listObj
  Rectangle_listPtr* = ptr Rectangle_listObj
  Rectangle_listObj* = object 
    status*: Status
    rectangles*: Rectangle
    num_rectangles*: cint

proc copy_clip_rectangle_list*(cr: Context): Rectangle_list {.
    importc: "cairo_copy_clip_rectangle_list", libcairo.}
proc destroy*(rectangle_list: Rectangle_list) {.
    importc: "cairo_rectangle_list_destroy", libcairo.}
type 
  Scaled_font* =  ptr Scaled_fontObj
  Scaled_fontPtr* = ptr Scaled_fontObj
  Scaled_fontObj* = object 
  
type 
  Font_face* =  ptr Font_faceObj
  Font_facePtr* = ptr Font_faceObj
  Font_faceObj* = object 
  
type 
  Glyph* =  ptr GlyphObj
  GlyphPtr* = ptr GlyphObj
  GlyphObj* = object 
    index*: culong
    x*: cdouble
    y*: cdouble

proc glyph_allocate*(num_glyphs: cint): Glyph {.
    importc: "cairo_glyph_allocate", libcairo.}
proc free*(glyphs: Glyph) {.
    importc: "cairo_glyph_free", libcairo.}
type 
  Text_cluster* =  ptr Text_clusterObj
  Text_clusterPtr* = ptr Text_clusterObj
  Text_clusterObj* = object 
    num_bytes*: cint
    num_glyphs*: cint

proc text_cluster_allocate*(num_clusters: cint): Text_cluster {.
    importc: "cairo_text_cluster_allocate", libcairo.}
proc free*(clusters: Text_cluster) {.
    importc: "cairo_text_cluster_free", libcairo.}
type 
  Text_cluster_flags* {.size: sizeof(cint), pure.} = enum 
    BACKWARD = 0x1
type 
  Text_extents* =  ptr Text_extentsObj
  Text_extentsPtr* = ptr Text_extentsObj
  Text_extentsObj* = object 
    x_bearing*: cdouble
    y_bearing*: cdouble
    width*: cdouble
    height*: cdouble
    x_advance*: cdouble
    y_advance*: cdouble

type 
  Font_extents* =  ptr Font_extentsObj
  Font_extentsPtr* = ptr Font_extentsObj
  Font_extentsObj* = object 
    ascent*: cdouble
    descent*: cdouble
    height*: cdouble
    max_x_advance*: cdouble
    max_y_advance*: cdouble

type 
  Font_slant* {.size: sizeof(cint), pure.} = enum 
    NORMAL, ITALIC, OBLIQUE
type 
  Font_weight* {.size: sizeof(cint), pure.} = enum 
    NORMAL, BOLD
type 
  Subpixel_order* {.size: sizeof(cint), pure.} = enum 
    DEFAULT, RGB, 
    BGR, VRGB, 
    VBGR
type 
  Hint_style* {.size: sizeof(cint), pure.} = enum 
    DEFAULT, NONE, SLIGHT, 
    MEDIUM, FULL
type 
  Hint_metrics* {.size: sizeof(cint), pure.} = enum 
    DEFAULT, OFF, ON
type 
  Font_options* =  ptr Font_optionsObj
  Font_optionsPtr* = ptr Font_optionsObj
  Font_optionsObj* = object 
  
proc font_options_create*(): Font_options {.
    importc: "cairo_font_options_create", libcairo.}
proc copy*(original: Font_options): Font_options {.
    importc: "cairo_font_options_copy", libcairo.}
proc destroy*(options: Font_options) {.
    importc: "cairo_font_options_destroy", libcairo.}
proc status*(options: Font_options): Status {.
    importc: "cairo_font_options_status", libcairo.}
proc merge*(options: Font_options; 
                               other: Font_options) {.
    importc: "cairo_font_options_merge", libcairo.}
proc equal*(options: Font_options; 
                               other: Font_options): cairo_bool_t {.
    importc: "cairo_font_options_equal", libcairo.}
proc hash*(options: Font_options): culong {.
    importc: "cairo_font_options_hash", libcairo.}
proc set_antialias*(options: Font_options; 
    antialias: Antialias) {.importc: "cairo_font_options_set_antialias", 
                                    libcairo.}
proc `antialias=`*(options: Font_options; 
    antialias: Antialias) {.importc: "cairo_font_options_set_antialias", 
                                    libcairo.}
proc get_antialias*(options: Font_options): Antialias {.
    importc: "cairo_font_options_get_antialias", libcairo.}
proc antialias*(options: Font_options): Antialias {.
    importc: "cairo_font_options_get_antialias", libcairo.}
proc set_subpixel_order*(options: Font_options; 
    subpixel_order: Subpixel_order) {.
    importc: "cairo_font_options_set_subpixel_order", libcairo.}
proc `subpixel_order=`*(options: Font_options; 
    subpixel_order: Subpixel_order) {.
    importc: "cairo_font_options_set_subpixel_order", libcairo.}
proc get_subpixel_order*(options: Font_options): Subpixel_order {.
    importc: "cairo_font_options_get_subpixel_order", libcairo.}
proc subpixel_order*(options: Font_options): Subpixel_order {.
    importc: "cairo_font_options_get_subpixel_order", libcairo.}
proc set_hint_style*(options: Font_options; 
    hint_style: Hint_style) {.importc: "cairo_font_options_set_hint_style", 
                                      libcairo.}
proc `hint_style=`*(options: Font_options; 
    hint_style: Hint_style) {.importc: "cairo_font_options_set_hint_style", 
                                      libcairo.}
proc get_hint_style*(options: Font_options): Hint_style {.
    importc: "cairo_font_options_get_hint_style", libcairo.}
proc hint_style*(options: Font_options): Hint_style {.
    importc: "cairo_font_options_get_hint_style", libcairo.}
proc set_hint_metrics*(options: Font_options; 
    hint_metrics: Hint_metrics) {.
    importc: "cairo_font_options_set_hint_metrics", libcairo.}
proc `hint_metrics=`*(options: Font_options; 
    hint_metrics: Hint_metrics) {.
    importc: "cairo_font_options_set_hint_metrics", libcairo.}
proc get_hint_metrics*(options: Font_options): Hint_metrics {.
    importc: "cairo_font_options_get_hint_metrics", libcairo.}
proc hint_metrics*(options: Font_options): Hint_metrics {.
    importc: "cairo_font_options_get_hint_metrics", libcairo.}
proc select_font_face*(cr: Context; family: cstring; 
                             slant: Font_slant; 
                             weight: Font_weight) {.
    importc: "cairo_select_font_face", libcairo.}
proc set_font_size*(cr: Context; size: cdouble) {.
    importc: "cairo_set_font_size", libcairo.}
proc `font_size=`*(cr: Context; size: cdouble) {.
    importc: "cairo_set_font_size", libcairo.}
proc set_font_matrix*(cr: Context; matrix: Matrix) {.
    importc: "cairo_set_font_matrix", libcairo.}
proc `font_matrix=`*(cr: Context; matrix: Matrix) {.
    importc: "cairo_set_font_matrix", libcairo.}
proc get_font_matrix*(cr: Context; matrix: var MatrixObj) {.
    importc: "cairo_get_font_matrix", libcairo.}
proc set_font_options*(cr: Context; 
                             options: Font_options) {.
    importc: "cairo_set_font_options", libcairo.}
proc `font_options=`*(cr: Context; 
                             options: Font_options) {.
    importc: "cairo_set_font_options", libcairo.}
proc get_font_options*(cr: Context; 
                             options: Font_options) {.
    importc: "cairo_get_font_options", libcairo.}
proc set_font_face*(cr: Context; font_face: Font_face) {.
    importc: "cairo_set_font_face", libcairo.}
proc `font_face=`*(cr: Context; font_face: Font_face) {.
    importc: "cairo_set_font_face", libcairo.}
proc get_font_face*(cr: Context): Font_face {.
    importc: "cairo_get_font_face", libcairo.}
proc font_face*(cr: Context): Font_face {.
    importc: "cairo_get_font_face", libcairo.}
proc set_scaled_font*(cr: Context; 
                            scaled_font: Scaled_font) {.
    importc: "cairo_set_scaled_font", libcairo.}
proc `scaled_font=`*(cr: Context; 
                            scaled_font: Scaled_font) {.
    importc: "cairo_set_scaled_font", libcairo.}
proc get_scaled_font*(cr: Context): Scaled_font {.
    importc: "cairo_get_scaled_font", libcairo.}
proc scaled_font*(cr: Context): Scaled_font {.
    importc: "cairo_get_scaled_font", libcairo.}
proc show_text*(cr: Context; utf8: cstring) {.
    importc: "cairo_show_text", libcairo.}
proc show_glyphs*(cr: Context; glyphs: Glyph; 
                        num_glyphs: cint) {.importc: "cairo_show_glyphs", 
    libcairo.}
proc show_text_glyphs*(cr: Context; utf8: cstring; utf8_len: cint; 
                             glyphs: Glyph; num_glyphs: cint; 
                             clusters: Text_cluster; 
                             num_clusters: cint; 
                             cluster_flags: Text_cluster_flags) {.
    importc: "cairo_show_text_glyphs", libcairo.}
proc text_path*(cr: Context; utf8: cstring) {.
    importc: "cairo_text_path", libcairo.}
proc glyph_path*(cr: Context; glyphs: Glyph; 
                       num_glyphs: cint) {.importc: "cairo_glyph_path", 
    libcairo.}
proc text_extents*(cr: Context; utf8: cstring; 
                         extents: Text_extents) {.
    importc: "cairo_text_extents", libcairo.}
proc glyph_extents*(cr: Context; glyphs: Glyph; 
                          num_glyphs: cint; extents: Text_extents) {.
    importc: "cairo_glyph_extents", libcairo.}
proc font_extents*(cr: Context; extents: Font_extents) {.
    importc: "cairo_font_extents", libcairo.}
proc reference*(font_face: Font_face): Font_face {.
    importc: "cairo_font_face_reference", libcairo.}
proc destroy*(font_face: Font_face) {.
    importc: "cairo_font_face_destroy", libcairo.}
proc get_reference_count*(font_face: Font_face): cuint {.
    importc: "cairo_font_face_get_reference_count", libcairo.}
proc reference_count*(font_face: Font_face): cuint {.
    importc: "cairo_font_face_get_reference_count", libcairo.}
proc status*(font_face: Font_face): Status {.
    importc: "cairo_font_face_status", libcairo.}
type 
  Font_type* {.size: sizeof(cint), pure.} = enum 
    TOY, FT, WIN32, 
    QUARTZ, USER
proc get_type*(font_face: Font_face): Font_type {.
    importc: "cairo_font_face_get_type", libcairo.}
proc `type`*(font_face: Font_face): Font_type {.
    importc: "cairo_font_face_get_type", libcairo.}
proc get_user_data*(font_face: Font_face; 
                                    key: User_data_key): pointer {.
    importc: "cairo_font_face_get_user_data", libcairo.}
proc user_data*(font_face: Font_face; 
                                    key: User_data_key): pointer {.
    importc: "cairo_font_face_get_user_data", libcairo.}
proc set_user_data*(font_face: Font_face; 
                                    key: User_data_key; 
                                    user_data: pointer; 
                                    destroy: cairo_destroy_func_t): Status {.
    importc: "cairo_font_face_set_user_data", libcairo.}
proc scaled_font_create*(font_face: Font_face; 
                               font_matrix: Matrix; 
                               ctm: Matrix; 
                               options: Font_options): Scaled_font {.
    importc: "cairo_scaled_font_create", libcairo.}
proc reference*(scaled_font: Scaled_font): Scaled_font {.
    importc: "cairo_scaled_font_reference", libcairo.}
proc destroy*(scaled_font: Scaled_font) {.
    importc: "cairo_scaled_font_destroy", libcairo.}
proc get_reference_count*(
    scaled_font: Scaled_font): cuint {.
    importc: "cairo_scaled_font_get_reference_count", libcairo.}
proc reference_count*(
    scaled_font: Scaled_font): cuint {.
    importc: "cairo_scaled_font_get_reference_count", libcairo.}
proc status*(scaled_font: Scaled_font): Status {.
    importc: "cairo_scaled_font_status", libcairo.}
proc get_type*(scaled_font: Scaled_font): Font_type {.
    importc: "cairo_scaled_font_get_type", libcairo.}
proc `type`*(scaled_font: Scaled_font): Font_type {.
    importc: "cairo_scaled_font_get_type", libcairo.}
proc get_user_data*(scaled_font: Scaled_font; 
                                      key: User_data_key): pointer {.
    importc: "cairo_scaled_font_get_user_data", libcairo.}
proc user_data*(scaled_font: Scaled_font; 
                                      key: User_data_key): pointer {.
    importc: "cairo_scaled_font_get_user_data", libcairo.}
proc set_user_data*(scaled_font: Scaled_font; 
                                      key: User_data_key; 
                                      user_data: pointer; 
                                      destroy: cairo_destroy_func_t): Status {.
    importc: "cairo_scaled_font_set_user_data", libcairo.}
proc extents*(scaled_font: Scaled_font; 
                                extents: Font_extents) {.
    importc: "cairo_scaled_font_extents", libcairo.}
proc text_extents*(scaled_font: Scaled_font; 
                                     utf8: cstring; 
                                     extents: Text_extents) {.
    importc: "cairo_scaled_font_text_extents", libcairo.}
proc glyph_extents*(scaled_font: Scaled_font; 
                                      glyphs: Glyph; 
                                      num_glyphs: cint; 
                                      extents: Text_extents) {.
    importc: "cairo_scaled_font_glyph_extents", libcairo.}
proc text_to_glyphs*(scaled_font: Scaled_font; 
    x: cdouble; y: cdouble; utf8: cstring; utf8_len: cint; 
    glyphs: var Glyph; num_glyphs: var cint; 
    clusters: var Text_cluster; num_clusters: var cint; 
    cluster_flags: ptr Text_cluster_flags): Status {.
    importc: "cairo_scaled_font_text_to_glyphs", libcairo.}
proc get_font_face*(scaled_font: Scaled_font): Font_face {.
    importc: "cairo_scaled_font_get_font_face", libcairo.}
proc font_face*(scaled_font: Scaled_font): Font_face {.
    importc: "cairo_scaled_font_get_font_face", libcairo.}
proc get_font_matrix*(scaled_font: Scaled_font; 
    font_matrix: var MatrixObj) {.
    importc: "cairo_scaled_font_get_font_matrix", libcairo.}
proc get_ctm*(scaled_font: Scaled_font; 
                                ctm: var MatrixObj) {.
    importc: "cairo_scaled_font_get_ctm", libcairo.}
proc get_scale_matrix*(scaled_font: Scaled_font; 
    scale_matrix: var MatrixObj) {.
    importc: "cairo_scaled_font_get_scale_matrix", libcairo.}
proc get_font_options*(scaled_font: Scaled_font; 
    options: Font_options) {.
    importc: "cairo_scaled_font_get_font_options", libcairo.}
proc toy_font_face_create*(family: cstring; slant: Font_slant; 
                                 weight: Font_weight): Font_face {.
    importc: "cairo_toy_font_face_create", libcairo.}
proc toy_font_face_get_family*(font_face: Font_face): cstring {.
    importc: "cairo_toy_font_face_get_family", libcairo.}
proc toy_font_face_get_slant*(font_face: Font_face): Font_slant {.
    importc: "cairo_toy_font_face_get_slant", libcairo.}
proc toy_font_face_get_weight*(font_face: Font_face): Font_weight {.
    importc: "cairo_toy_font_face_get_weight", libcairo.}
proc user_font_face_create*(): Font_face {.
    importc: "cairo_user_font_face_create", libcairo.}
type 
  cairo_user_scaled_font_init_func_t* = proc (
      scaled_font: Scaled_font; cr: Context; 
      extents: Font_extents): Status {.cdecl.}
type 
  cairo_user_scaled_font_render_glyph_func_t* = proc (
      scaled_font: Scaled_font; glyph: culong; cr: Context; 
      extents: Text_extents): Status {.cdecl.}
type 
  cairo_user_scaled_font_text_to_glyphs_func_t* = proc (
      scaled_font: Scaled_font; utf8: cstring; utf8_len: cint; 
      glyphs: var Glyph; num_glyphs: var cint; 
      clusters: var Text_cluster; num_clusters: var cint; 
      cluster_flags: ptr Text_cluster_flags): Status {.cdecl.}
type 
  cairo_user_scaled_font_unicode_to_glyph_func_t* = proc (
      scaled_font: Scaled_font; unicode: culong; 
      glyph_index: ptr culong): Status {.cdecl.}
proc user_font_face_set_init_func*(font_face: Font_face; 
    init_func: cairo_user_scaled_font_init_func_t) {.
    importc: "cairo_user_font_face_set_init_func", libcairo.}
proc user_font_face_set_render_glyph_func*(
    font_face: Font_face; 
    render_glyph_func: cairo_user_scaled_font_render_glyph_func_t) {.
    importc: "cairo_user_font_face_set_render_glyph_func", libcairo.}
proc user_font_face_set_text_to_glyphs_func*(
    font_face: Font_face; 
    text_to_glyphs_func: cairo_user_scaled_font_text_to_glyphs_func_t) {.
    importc: "cairo_user_font_face_set_text_to_glyphs_func", libcairo.}
proc user_font_face_set_unicode_to_glyph_func*(
    font_face: Font_face; 
    unicode_to_glyph_func: cairo_user_scaled_font_unicode_to_glyph_func_t) {.
    importc: "cairo_user_font_face_set_unicode_to_glyph_func", libcairo.}
proc user_font_face_get_init_func*(font_face: Font_face): cairo_user_scaled_font_init_func_t {.
    importc: "cairo_user_font_face_get_init_func", libcairo.}
proc user_font_face_get_render_glyph_func*(
    font_face: Font_face): cairo_user_scaled_font_render_glyph_func_t {.
    importc: "cairo_user_font_face_get_render_glyph_func", libcairo.}
proc user_font_face_get_text_to_glyphs_func*(
    font_face: Font_face): cairo_user_scaled_font_text_to_glyphs_func_t {.
    importc: "cairo_user_font_face_get_text_to_glyphs_func", libcairo.}
proc user_font_face_get_unicode_to_glyph_func*(
    font_face: Font_face): cairo_user_scaled_font_unicode_to_glyph_func_t {.
    importc: "cairo_user_font_face_get_unicode_to_glyph_func", libcairo.}
proc get_operator*(cr: Context): Operator {.
    importc: "cairo_get_operator", libcairo.}
proc operator*(cr: Context): Operator {.
    importc: "cairo_get_operator", libcairo.}
proc get_source*(cr: Context): Pattern {.
    importc: "cairo_get_source", libcairo.}
proc source*(cr: Context): Pattern {.
    importc: "cairo_get_source", libcairo.}
proc get_tolerance*(cr: Context): cdouble {.
    importc: "cairo_get_tolerance", libcairo.}
proc tolerance*(cr: Context): cdouble {.
    importc: "cairo_get_tolerance", libcairo.}
proc get_antialias*(cr: Context): Antialias {.
    importc: "cairo_get_antialias", libcairo.}
proc antialias*(cr: Context): Antialias {.
    importc: "cairo_get_antialias", libcairo.}
proc has_current_point*(cr: Context): cairo_bool_t {.
    importc: "cairo_has_current_point", libcairo.}
proc get_current_point*(cr: Context; x: var cdouble; y: var cdouble) {.
    importc: "cairo_get_current_point", libcairo.}
proc get_fill_rule*(cr: Context): Fill_rule {.
    importc: "cairo_get_fill_rule", libcairo.}
proc fill_rule*(cr: Context): Fill_rule {.
    importc: "cairo_get_fill_rule", libcairo.}
proc get_line_width*(cr: Context): cdouble {.
    importc: "cairo_get_line_width", libcairo.}
proc line_width*(cr: Context): cdouble {.
    importc: "cairo_get_line_width", libcairo.}
proc get_line_cap*(cr: Context): Line_cap {.
    importc: "cairo_get_line_cap", libcairo.}
proc line_cap*(cr: Context): Line_cap {.
    importc: "cairo_get_line_cap", libcairo.}
proc get_line_join*(cr: Context): Line_join {.
    importc: "cairo_get_line_join", libcairo.}
proc line_join*(cr: Context): Line_join {.
    importc: "cairo_get_line_join", libcairo.}
proc get_miter_limit*(cr: Context): cdouble {.
    importc: "cairo_get_miter_limit", libcairo.}
proc miter_limit*(cr: Context): cdouble {.
    importc: "cairo_get_miter_limit", libcairo.}
proc get_dash_count*(cr: Context): cint {.
    importc: "cairo_get_dash_count", libcairo.}
proc dash_count*(cr: Context): cint {.
    importc: "cairo_get_dash_count", libcairo.}
proc get_dash*(cr: Context; dashes: var cdouble; offset: var cdouble) {.
    importc: "cairo_get_dash", libcairo.}
proc get_matrix*(cr: Context; matrix: var MatrixObj) {.
    importc: "cairo_get_matrix", libcairo.}
proc get_target*(cr: Context): Surface {.
    importc: "cairo_get_target", libcairo.}
proc target*(cr: Context): Surface {.
    importc: "cairo_get_target", libcairo.}
proc get_group_target*(cr: Context): Surface {.
    importc: "cairo_get_group_target", libcairo.}
proc group_target*(cr: Context): Surface {.
    importc: "cairo_get_group_target", libcairo.}
type 
  Path_data_type* {.size: sizeof(cint), pure.} = enum 
    MOVE_TO, LINE_TO, CURVE_TO, 
    CLOSE_PATH
type 
  INNER_C_STRUCT_8375053358596942140* = object 
    `type`*: Path_data_type
    length*: cint

type 
  INNER_C_STRUCT_8517552675393270686* = object 
    x*: cdouble
    y*: cdouble

type 
  cairo_path_data_t* = object  {.union.}
    header*: INNER_C_STRUCT_8375053358596942140
    point*: INNER_C_STRUCT_8517552675393270686

type 
  Path* =  ptr PathObj
  PathPtr* = ptr PathObj
  PathObj* = object 
    status*: Status
    data*: ptr cairo_path_data_t
    num_data*: cint

proc copy_path*(cr: Context): Path {.
    importc: "cairo_copy_path", libcairo.}
proc copy_path_flat*(cr: Context): Path {.
    importc: "cairo_copy_path_flat", libcairo.}
proc append_path*(cr: Context; path: Path) {.
    importc: "cairo_append_path", libcairo.}
proc destroy*(path: Path) {.
    importc: "cairo_path_destroy", libcairo.}
proc status*(cr: Context): Status {.importc: "cairo_status", 
    libcairo.}
proc to_string*(status: Status): cstring {.
    importc: "cairo_status_to_string", libcairo.}
proc reference*(device: Device): Device {.
    importc: "cairo_device_reference", libcairo.}
type 
  Device_type* {.size: sizeof(cint), pure.} = enum 
    INVALID = - 1, DRM, 
    GL, SCRIPT, XCB, 
    XLIB, XML, COGL, 
    WIN32
proc get_type*(device: Device): Device_type {.
    importc: "cairo_device_get_type", libcairo.}
proc `type`*(device: Device): Device_type {.
    importc: "cairo_device_get_type", libcairo.}
proc status*(device: Device): Status {.
    importc: "cairo_device_status", libcairo.}
proc acquire*(device: Device): Status {.
    importc: "cairo_device_acquire", libcairo.}
proc release*(device: Device) {.
    importc: "cairo_device_release", libcairo.}
proc flush*(device: Device) {.
    importc: "cairo_device_flush", libcairo.}
proc finish*(device: Device) {.
    importc: "cairo_device_finish", libcairo.}
proc destroy*(device: Device) {.
    importc: "cairo_device_destroy", libcairo.}
proc get_reference_count*(device: Device): cuint {.
    importc: "cairo_device_get_reference_count", libcairo.}
proc reference_count*(device: Device): cuint {.
    importc: "cairo_device_get_reference_count", libcairo.}
proc get_user_data*(device: Device; 
                                 key: User_data_key): pointer {.
    importc: "cairo_device_get_user_data", libcairo.}
proc user_data*(device: Device; 
                                 key: User_data_key): pointer {.
    importc: "cairo_device_get_user_data", libcairo.}
proc set_user_data*(device: Device; 
                                 key: User_data_key; 
                                 user_data: pointer; 
                                 destroy: cairo_destroy_func_t): Status {.
    importc: "cairo_device_set_user_data", libcairo.}
proc create_similar*(other: Surface; 
                                   content: Content; width: cint; 
                                   height: cint): Surface {.
    importc: "cairo_surface_create_similar", libcairo.}
proc create_similar_image*(other: Surface; 
    format: Format; width: cint; height: cint): Surface {.
    importc: "cairo_surface_create_similar_image", libcairo.}
proc map_to_image*(surface: Surface; 
                                 extents: Rectangle_int): Surface {.
    importc: "cairo_surface_map_to_image", libcairo.}
proc unmap_image*(surface: Surface; 
                                image: Surface) {.
    importc: "cairo_surface_unmap_image", libcairo.}
proc create_for_rectangle*(target: Surface; 
    x: cdouble; y: cdouble; width: cdouble; height: cdouble): Surface {.
    importc: "cairo_surface_create_for_rectangle", libcairo.}
type 
  Surface_observer_mode* {.size: sizeof(cint), pure.} = enum 
    NORMAL = 0, 
    RECORD_OPERATIONS = 0x1
proc create_observer*(target: Surface; 
                                    mode: Surface_observer_mode): Surface {.
    importc: "cairo_surface_create_observer", libcairo.}
type 
  cairo_surface_observer_callback_t* = proc (observer: Surface; 
      target: Surface; data: pointer) {.cdecl.}
proc observer_add_paint_callback*(
    abstract_surface: Surface; 
    `func`: cairo_surface_observer_callback_t; data: pointer): Status {.
    importc: "cairo_surface_observer_add_paint_callback", libcairo.}
proc observer_add_mask_callback*(
    abstract_surface: Surface; 
    `func`: cairo_surface_observer_callback_t; data: pointer): Status {.
    importc: "cairo_surface_observer_add_mask_callback", libcairo.}
proc observer_add_fill_callback*(
    abstract_surface: Surface; 
    `func`: cairo_surface_observer_callback_t; data: pointer): Status {.
    importc: "cairo_surface_observer_add_fill_callback", libcairo.}
proc observer_add_stroke_callback*(
    abstract_surface: Surface; 
    `func`: cairo_surface_observer_callback_t; data: pointer): Status {.
    importc: "cairo_surface_observer_add_stroke_callback", libcairo.}
proc observer_add_glyphs_callback*(
    abstract_surface: Surface; 
    `func`: cairo_surface_observer_callback_t; data: pointer): Status {.
    importc: "cairo_surface_observer_add_glyphs_callback", libcairo.}
proc observer_add_flush_callback*(
    abstract_surface: Surface; 
    `func`: cairo_surface_observer_callback_t; data: pointer): Status {.
    importc: "cairo_surface_observer_add_flush_callback", libcairo.}
proc observer_add_finish_callback*(
    abstract_surface: Surface; 
    `func`: cairo_surface_observer_callback_t; data: pointer): Status {.
    importc: "cairo_surface_observer_add_finish_callback", libcairo.}
proc observer_print*(surface: Surface; 
                                   write_func: cairo_write_func_t; 
                                   closure: pointer): Status {.
    importc: "cairo_surface_observer_print", libcairo.}
proc observer_elapsed*(surface: Surface): cdouble {.
    importc: "cairo_surface_observer_elapsed", libcairo.}
proc observer_print*(device: Device; 
                                  write_func: cairo_write_func_t; 
                                  closure: pointer): Status {.
    importc: "cairo_device_observer_print", libcairo.}
proc observer_elapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_elapsed", libcairo.}
proc observer_paint_elapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_paint_elapsed", libcairo.}
proc observer_mask_elapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_mask_elapsed", libcairo.}
proc observer_fill_elapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_fill_elapsed", libcairo.}
proc observer_stroke_elapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_stroke_elapsed", libcairo.}
proc observer_glyphs_elapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_glyphs_elapsed", libcairo.}
proc reference*(surface: Surface): Surface {.
    importc: "cairo_surface_reference", libcairo.}
proc finish*(surface: Surface) {.
    importc: "cairo_surface_finish", libcairo.}
proc destroy*(surface: Surface) {.
    importc: "cairo_surface_destroy", libcairo.}
proc get_device*(surface: Surface): Device {.
    importc: "cairo_surface_get_device", libcairo.}
proc device*(surface: Surface): Device {.
    importc: "cairo_surface_get_device", libcairo.}
proc get_reference_count*(surface: Surface): cuint {.
    importc: "cairo_surface_get_reference_count", libcairo.}
proc reference_count*(surface: Surface): cuint {.
    importc: "cairo_surface_get_reference_count", libcairo.}
proc status*(surface: Surface): Status {.
    importc: "cairo_surface_status", libcairo.}
type 
  Surface_type* {.size: sizeof(cint), pure.} = enum 
    IMAGE, PDF, PS, 
    XLIB, XCB, GLITZ, 
    QUARTZ, WIN32, 
    BEOS, DIRECTFB, 
    SVG, OS2, 
    WIN32_PRINTING, QUARTZ_IMAGE, 
    SCRIPT, QT, 
    RECORDING, VG, 
    GL, DRM, TEE, 
    XML, SKIA, 
    SUBSURFACE, COGL
proc get_type*(surface: Surface): Surface_type {.
    importc: "cairo_surface_get_type", libcairo.}
proc `type`*(surface: Surface): Surface_type {.
    importc: "cairo_surface_get_type", libcairo.}
proc get_content*(surface: Surface): Content {.
    importc: "cairo_surface_get_content", libcairo.}
proc content*(surface: Surface): Content {.
    importc: "cairo_surface_get_content", libcairo.}
when CAIRO_HAS_PNG_FUNCTIONS: 
  proc write_to_png*(surface: Surface; 
                                   filename: cstring): Status {.
      importc: "cairo_surface_write_to_png", libcairo.}
  proc write_to_png_stream*(surface: Surface; 
      write_func: cairo_write_func_t; closure: pointer): Status {.
      importc: "cairo_surface_write_to_png_stream", libcairo.}
proc get_user_data*(surface: Surface; 
                                  key: User_data_key): pointer {.
    importc: "cairo_surface_get_user_data", libcairo.}
proc user_data*(surface: Surface; 
                                  key: User_data_key): pointer {.
    importc: "cairo_surface_get_user_data", libcairo.}
proc set_user_data*(surface: Surface; 
                                  key: User_data_key; 
                                  user_data: pointer; 
                                  destroy: cairo_destroy_func_t): Status {.
    importc: "cairo_surface_set_user_data", libcairo.}
const 
  MIME_TYPE_JPEG* = "image/jpeg"
  MIME_TYPE_PNG* = "image/png"
  MIME_TYPE_JP2* = "image/jp2"
  MIME_TYPE_URI* = "text/x-uri"
  MIME_TYPE_UNIQUE_ID* = "application/x-cairo.uuid"
  MIME_TYPE_JBIG2* = "application/x-cairo.jbig2"
  MIME_TYPE_JBIG2_GLOBAL* = "application/x-cairo.jbig2-global"
  MIME_TYPE_JBIG2_GLOBAL_ID* = "application/x-cairo.jbig2-global-id"
proc get_mime_data*(surface: Surface; 
                                  mime_type: cstring; data: ptr ptr cuchar; 
                                  length: ptr culong) {.
    importc: "cairo_surface_get_mime_data", libcairo.}
proc set_mime_data*(surface: Surface; 
                                  mime_type: cstring; data: ptr cuchar; 
                                  length: culong; 
                                  destroy: cairo_destroy_func_t; 
                                  closure: pointer): Status {.
    importc: "cairo_surface_set_mime_data", libcairo.}
proc supports_mime_type*(surface: Surface; 
    mime_type: cstring): cairo_bool_t {.
    importc: "cairo_surface_supports_mime_type", libcairo.}
proc get_font_options*(surface: Surface; 
                                     options: Font_options) {.
    importc: "cairo_surface_get_font_options", libcairo.}
proc flush*(surface: Surface) {.
    importc: "cairo_surface_flush", libcairo.}
proc mark_dirty*(surface: Surface) {.
    importc: "cairo_surface_mark_dirty", libcairo.}
proc mark_dirty_rectangle*(surface: Surface; 
    x: cint; y: cint; width: cint; height: cint) {.
    importc: "cairo_surface_mark_dirty_rectangle", libcairo.}
proc set_device_scale*(surface: Surface; 
                                     x_scale: cdouble; y_scale: cdouble) {.
    importc: "cairo_surface_set_device_scale", libcairo.}
proc `device_scale=`*(surface: Surface; 
                                     x_scale: cdouble; y_scale: cdouble) {.
    importc: "cairo_surface_set_device_scale", libcairo.}
proc get_device_scale*(surface: Surface; 
                                     x_scale: var cdouble; 
                                     y_scale: var cdouble) {.
    importc: "cairo_surface_get_device_scale", libcairo.}
proc set_device_offset*(surface: Surface; 
                                      x_offset: cdouble; y_offset: cdouble) {.
    importc: "cairo_surface_set_device_offset", libcairo.}
proc `device_offset=`*(surface: Surface; 
                                      x_offset: cdouble; y_offset: cdouble) {.
    importc: "cairo_surface_set_device_offset", libcairo.}
proc get_device_offset*(surface: Surface; 
                                      x_offset: var cdouble; 
                                      y_offset: var cdouble) {.
    importc: "cairo_surface_get_device_offset", libcairo.}
proc set_fallback_resolution*(surface: Surface; 
    x_pixels_per_inch: cdouble; y_pixels_per_inch: cdouble) {.
    importc: "cairo_surface_set_fallback_resolution", libcairo.}
proc `fallback_resolution=`*(surface: Surface; 
    x_pixels_per_inch: cdouble; y_pixels_per_inch: cdouble) {.
    importc: "cairo_surface_set_fallback_resolution", libcairo.}
proc get_fallback_resolution*(surface: Surface; 
    x_pixels_per_inch: var cdouble; y_pixels_per_inch: var cdouble) {.
    importc: "cairo_surface_get_fallback_resolution", libcairo.}
proc copy_page*(surface: Surface) {.
    importc: "cairo_surface_copy_page", libcairo.}
proc show_page*(surface: Surface) {.
    importc: "cairo_surface_show_page", libcairo.}
proc has_show_text_glyphs*(surface: Surface): cairo_bool_t {.
    importc: "cairo_surface_has_show_text_glyphs", libcairo.}
proc image_surface_create*(format: Format; width: cint; 
                                 height: cint): Surface {.
    importc: "cairo_image_surface_create", libcairo.}
proc stride_for_width*(format: Format; width: cint): cint {.
    importc: "cairo_format_stride_for_width", libcairo.}
proc image_surface_create_for_data*(data: ptr cuchar; 
    format: Format; width: cint; height: cint; stride: cint): Surface {.
    importc: "cairo_image_surface_create_for_data", libcairo.}
proc image_surface_get_data*(surface: Surface): ptr cuchar {.
    importc: "cairo_image_surface_get_data", libcairo.}
proc image_surface_get_format*(surface: Surface): Format {.
    importc: "cairo_image_surface_get_format", libcairo.}
proc image_surface_get_width*(surface: Surface): cint {.
    importc: "cairo_image_surface_get_width", libcairo.}
proc image_surface_get_height*(surface: Surface): cint {.
    importc: "cairo_image_surface_get_height", libcairo.}
proc image_surface_get_stride*(surface: Surface): cint {.
    importc: "cairo_image_surface_get_stride", libcairo.}
when CAIRO_HAS_PNG_FUNCTIONS: 
  proc image_surface_create_from_png*(filename: cstring): Surface {.
      importc: "cairo_image_surface_create_from_png", libcairo.}
  proc image_surface_create_from_png_stream*(
      read_func: cairo_read_func_t; closure: pointer): Surface {.
      importc: "cairo_image_surface_create_from_png_stream", libcairo.}
proc recording_surface_create*(content: Content; 
                                     extents: Rectangle): Surface {.
    importc: "cairo_recording_surface_create", libcairo.}
proc recording_surface_ink_extents*(surface: Surface; 
    x0: var cdouble; y0: var cdouble; width: var cdouble; height: var cdouble) {.
    importc: "cairo_recording_surface_ink_extents", libcairo.}
proc recording_surface_get_extents*(surface: Surface; 
    extents: Rectangle): cairo_bool_t {.
    importc: "cairo_recording_surface_get_extents", libcairo.}
type 
  cairo_raster_source_acquire_func_t* = proc (pattern: Pattern; 
      callback_data: pointer; target: Surface; 
      extents: Rectangle_int): Surface {.cdecl.}
type 
  cairo_raster_source_release_func_t* = proc (pattern: Pattern; 
      callback_data: pointer; surface: Surface) {.cdecl.}
type 
  cairo_raster_source_snapshot_func_t* = proc (pattern: Pattern; 
      callback_data: pointer): Status {.cdecl.}
type 
  cairo_raster_source_copy_func_t* = proc (pattern: Pattern; 
      callback_data: pointer; other: Pattern): Status {.cdecl.}
type 
  cairo_raster_source_finish_func_t* = proc (pattern: Pattern; 
      callback_data: pointer) {.cdecl.}
proc pattern_create_raster_source*(user_data: pointer; 
    content: Content; width: cint; height: cint): Pattern {.
    importc: "cairo_pattern_create_raster_source", libcairo.}
proc raster_source_pattern_set_callback_data*(
    pattern: Pattern; data: pointer) {.
    importc: "cairo_raster_source_pattern_set_callback_data", libcairo.}
proc raster_source_pattern_get_callback_data*(
    pattern: Pattern): pointer {.
    importc: "cairo_raster_source_pattern_get_callback_data", libcairo.}
proc raster_source_pattern_set_acquire*(pattern: Pattern; 
    acquire: cairo_raster_source_acquire_func_t; 
    release: cairo_raster_source_release_func_t) {.
    importc: "cairo_raster_source_pattern_set_acquire", libcairo.}
proc raster_source_pattern_get_acquire*(pattern: Pattern; 
    acquire: ptr cairo_raster_source_acquire_func_t; 
    release: ptr cairo_raster_source_release_func_t) {.
    importc: "cairo_raster_source_pattern_get_acquire", libcairo.}
proc raster_source_pattern_set_snapshot*(pattern: Pattern; 
    snapshot: cairo_raster_source_snapshot_func_t) {.
    importc: "cairo_raster_source_pattern_set_snapshot", libcairo.}
proc raster_source_pattern_get_snapshot*(pattern: Pattern): cairo_raster_source_snapshot_func_t {.
    importc: "cairo_raster_source_pattern_get_snapshot", libcairo.}
proc raster_source_pattern_set_copy*(pattern: Pattern; 
    copy: cairo_raster_source_copy_func_t) {.
    importc: "cairo_raster_source_pattern_set_copy", libcairo.}
proc raster_source_pattern_get_copy*(pattern: Pattern): cairo_raster_source_copy_func_t {.
    importc: "cairo_raster_source_pattern_get_copy", libcairo.}
proc raster_source_pattern_set_finish*(pattern: Pattern; 
    finish: cairo_raster_source_finish_func_t) {.
    importc: "cairo_raster_source_pattern_set_finish", libcairo.}
proc raster_source_pattern_get_finish*(pattern: Pattern): cairo_raster_source_finish_func_t {.
    importc: "cairo_raster_source_pattern_get_finish", libcairo.}
proc pattern_create_rgb*(red: cdouble; green: cdouble; blue: cdouble): Pattern {.
    importc: "cairo_pattern_create_rgb", libcairo.}
proc pattern_create_rgba*(red: cdouble; green: cdouble; blue: cdouble; 
                                alpha: cdouble): Pattern {.
    importc: "cairo_pattern_create_rgba", libcairo.}
proc pattern_create_for_surface*(surface: Surface): Pattern {.
    importc: "cairo_pattern_create_for_surface", libcairo.}
proc pattern_create_linear*(x0: cdouble; y0: cdouble; x1: cdouble; 
                                  y1: cdouble): Pattern {.
    importc: "cairo_pattern_create_linear", libcairo.}
proc pattern_create_radial*(cx0: cdouble; cy0: cdouble; 
                                  radius0: cdouble; cx1: cdouble; 
                                  cy1: cdouble; radius1: cdouble): Pattern {.
    importc: "cairo_pattern_create_radial", libcairo.}
proc pattern_create_mesh*(): Pattern {.
    importc: "cairo_pattern_create_mesh", libcairo.}
proc reference*(pattern: Pattern): Pattern {.
    importc: "cairo_pattern_reference", libcairo.}
proc destroy*(pattern: Pattern) {.
    importc: "cairo_pattern_destroy", libcairo.}
proc get_reference_count*(pattern: Pattern): cuint {.
    importc: "cairo_pattern_get_reference_count", libcairo.}
proc reference_count*(pattern: Pattern): cuint {.
    importc: "cairo_pattern_get_reference_count", libcairo.}
proc status*(pattern: Pattern): Status {.
    importc: "cairo_pattern_status", libcairo.}
proc get_user_data*(pattern: Pattern; 
                                  key: User_data_key): pointer {.
    importc: "cairo_pattern_get_user_data", libcairo.}
proc user_data*(pattern: Pattern; 
                                  key: User_data_key): pointer {.
    importc: "cairo_pattern_get_user_data", libcairo.}
proc set_user_data*(pattern: Pattern; 
                                  key: User_data_key; 
                                  user_data: pointer; 
                                  destroy: cairo_destroy_func_t): Status {.
    importc: "cairo_pattern_set_user_data", libcairo.}
type 
  Pattern_type* {.size: sizeof(cint), pure.} = enum 
    SOLID, SURFACE, 
    LINEAR, RADIAL, 
    MESH, RASTER_SOURCE
proc get_type*(pattern: Pattern): Pattern_type {.
    importc: "cairo_pattern_get_type", libcairo.}
proc `type`*(pattern: Pattern): Pattern_type {.
    importc: "cairo_pattern_get_type", libcairo.}
proc add_color_stop_rgb*(pattern: Pattern; 
    offset: cdouble; red: cdouble; green: cdouble; blue: cdouble) {.
    importc: "cairo_pattern_add_color_stop_rgb", libcairo.}
proc add_color_stop_rgba*(pattern: Pattern; 
    offset: cdouble; red: cdouble; green: cdouble; blue: cdouble; 
    alpha: cdouble) {.importc: "cairo_pattern_add_color_stop_rgba", 
                      libcairo.}
proc mesh_pattern_begin_patch*(pattern: Pattern) {.
    importc: "cairo_mesh_pattern_begin_patch", libcairo.}
proc mesh_pattern_end_patch*(pattern: Pattern) {.
    importc: "cairo_mesh_pattern_end_patch", libcairo.}
proc mesh_pattern_curve_to*(pattern: Pattern; x1: cdouble; 
                                  y1: cdouble; x2: cdouble; y2: cdouble; 
                                  x3: cdouble; y3: cdouble) {.
    importc: "cairo_mesh_pattern_curve_to", libcairo.}
proc mesh_pattern_line_to*(pattern: Pattern; x: cdouble; 
                                 y: cdouble) {.
    importc: "cairo_mesh_pattern_line_to", libcairo.}
proc mesh_pattern_move_to*(pattern: Pattern; x: cdouble; 
                                 y: cdouble) {.
    importc: "cairo_mesh_pattern_move_to", libcairo.}
proc mesh_pattern_set_control_point*(pattern: Pattern; 
    point_num: cuint; x: cdouble; y: cdouble) {.
    importc: "cairo_mesh_pattern_set_control_point", libcairo.}
proc mesh_pattern_set_corner_color_rgb*(pattern: Pattern; 
    corner_num: cuint; red: cdouble; green: cdouble; blue: cdouble) {.
    importc: "cairo_mesh_pattern_set_corner_color_rgb", libcairo.}
proc mesh_pattern_set_corner_color_rgba*(pattern: Pattern; 
    corner_num: cuint; red: cdouble; green: cdouble; blue: cdouble; 
    alpha: cdouble) {.importc: "cairo_mesh_pattern_set_corner_color_rgba", 
                      libcairo.}
proc set_matrix*(pattern: Pattern; 
                               matrix: Matrix) {.
    importc: "cairo_pattern_set_matrix", libcairo.}
proc `matrix=`*(pattern: Pattern; 
                               matrix: Matrix) {.
    importc: "cairo_pattern_set_matrix", libcairo.}
proc get_matrix*(pattern: Pattern; 
                               matrix: var MatrixObj) {.
    importc: "cairo_pattern_get_matrix", libcairo.}
type 
  Extend* {.size: sizeof(cint), pure.} = enum 
    NONE, REPEAT, REFLECT, 
    PAD
proc set_extend*(pattern: Pattern; 
                               extend: Extend) {.
    importc: "cairo_pattern_set_extend", libcairo.}
proc `extend=`*(pattern: Pattern; 
                               extend: Extend) {.
    importc: "cairo_pattern_set_extend", libcairo.}
proc get_extend*(pattern: Pattern): Extend {.
    importc: "cairo_pattern_get_extend", libcairo.}
proc extend*(pattern: Pattern): Extend {.
    importc: "cairo_pattern_get_extend", libcairo.}
type 
  Filter* {.size: sizeof(cint), pure.} = enum 
    FAST, GOOD, BEST, 
    NEAREST, BILINEAR, GAUSSIAN
proc set_filter*(pattern: Pattern; 
                               filter: Filter) {.
    importc: "cairo_pattern_set_filter", libcairo.}
proc `filter=`*(pattern: Pattern; 
                               filter: Filter) {.
    importc: "cairo_pattern_set_filter", libcairo.}
proc get_filter*(pattern: Pattern): Filter {.
    importc: "cairo_pattern_get_filter", libcairo.}
proc filter*(pattern: Pattern): Filter {.
    importc: "cairo_pattern_get_filter", libcairo.}
proc get_rgba*(pattern: Pattern; red: var cdouble; 
                             green: var cdouble; blue: var cdouble; 
                             alpha: var cdouble): Status {.
    importc: "cairo_pattern_get_rgba", libcairo.}
proc rgba*(pattern: Pattern; red: var cdouble; 
                             green: var cdouble; blue: var cdouble; 
                             alpha: var cdouble): Status {.
    importc: "cairo_pattern_get_rgba", libcairo.}
proc get_surface*(pattern: Pattern; 
                                surface: var Surface): Status {.
    importc: "cairo_pattern_get_surface", libcairo.}
proc surface*(pattern: Pattern; 
                                surface: var Surface): Status {.
    importc: "cairo_pattern_get_surface", libcairo.}
proc get_color_stop_rgba*(pattern: Pattern; 
    index: cint; offset: var cdouble; red: var cdouble; green: var cdouble; 
    blue: var cdouble; alpha: var cdouble): Status {.
    importc: "cairo_pattern_get_color_stop_rgba", libcairo.}
proc color_stop_rgba*(pattern: Pattern; 
    index: cint; offset: var cdouble; red: var cdouble; green: var cdouble; 
    blue: var cdouble; alpha: var cdouble): Status {.
    importc: "cairo_pattern_get_color_stop_rgba", libcairo.}
proc get_color_stop_count*(pattern: Pattern; 
    count: var cint): Status {.
    importc: "cairo_pattern_get_color_stop_count", libcairo.}
proc color_stop_count*(pattern: Pattern; 
    count: var cint): Status {.
    importc: "cairo_pattern_get_color_stop_count", libcairo.}
proc get_linear_points*(pattern: Pattern; 
                                      x0: var cdouble; y0: var cdouble; 
                                      x1: var cdouble; y1: var cdouble): Status {.
    importc: "cairo_pattern_get_linear_points", libcairo.}
proc linear_points*(pattern: Pattern; 
                                      x0: var cdouble; y0: var cdouble; 
                                      x1: var cdouble; y1: var cdouble): Status {.
    importc: "cairo_pattern_get_linear_points", libcairo.}
proc get_radial_circles*(pattern: Pattern; 
    x0: var cdouble; y0: var cdouble; r0: var cdouble; x1: var cdouble; 
    y1: var cdouble; r1: var cdouble): Status {.
    importc: "cairo_pattern_get_radial_circles", libcairo.}
proc radial_circles*(pattern: Pattern; 
    x0: var cdouble; y0: var cdouble; r0: var cdouble; x1: var cdouble; 
    y1: var cdouble; r1: var cdouble): Status {.
    importc: "cairo_pattern_get_radial_circles", libcairo.}
proc mesh_pattern_get_patch_count*(pattern: Pattern; 
    count: var cuint): Status {.
    importc: "cairo_mesh_pattern_get_patch_count", libcairo.}
proc mesh_pattern_get_path*(pattern: Pattern; 
                                  patch_num: cuint): Path {.
    importc: "cairo_mesh_pattern_get_path", libcairo.}
proc mesh_pattern_get_corner_color_rgba*(pattern: Pattern; 
    patch_num: cuint; corner_num: cuint; red: var cdouble; green: var cdouble; 
    blue: var cdouble; alpha: var cdouble): Status {.
    importc: "cairo_mesh_pattern_get_corner_color_rgba", libcairo.}
proc mesh_pattern_get_control_point*(pattern: Pattern; 
    patch_num: cuint; point_num: cuint; x: var cdouble; y: var cdouble): Status {.
    importc: "cairo_mesh_pattern_get_control_point", libcairo.}
proc init*(matrix: Matrix; xx: cdouble; yx: cdouble; 
                        xy: cdouble; yy: cdouble; x0: cdouble; y0: cdouble) {.
    importc: "cairo_matrix_init", libcairo.}
proc init_identity*(matrix: Matrix) {.
    importc: "cairo_matrix_init_identity", libcairo.}
proc init_translate*(matrix: Matrix; tx: cdouble; 
                                  ty: cdouble) {.
    importc: "cairo_matrix_init_translate", libcairo.}
proc init_scale*(matrix: Matrix; sx: cdouble; 
                              sy: cdouble) {.
    importc: "cairo_matrix_init_scale", libcairo.}
proc init_rotate*(matrix: Matrix; radians: cdouble) {.
    importc: "cairo_matrix_init_rotate", libcairo.}
proc translate*(matrix: Matrix; tx: cdouble; 
                             ty: cdouble) {.importc: "cairo_matrix_translate", 
    libcairo.}
proc scale*(matrix: Matrix; sx: cdouble; sy: cdouble) {.
    importc: "cairo_matrix_scale", libcairo.}
proc rotate*(matrix: Matrix; radians: cdouble) {.
    importc: "cairo_matrix_rotate", libcairo.}
proc invert*(matrix: Matrix): Status {.
    importc: "cairo_matrix_invert", libcairo.}
proc multiply*(result: Matrix; a: Matrix; 
                            b: Matrix) {.
    importc: "cairo_matrix_multiply", libcairo.}
proc transform_distance*(matrix: Matrix; 
                                      dx: var cdouble; dy: var cdouble) {.
    importc: "cairo_matrix_transform_distance", libcairo.}
proc transform_point*(matrix: Matrix; x: var cdouble; 
                                   y: var cdouble) {.
    importc: "cairo_matrix_transform_point", libcairo.}
type 
  Region* =  ptr RegionObj
  RegionPtr* = ptr RegionObj
  RegionObj* = object 
  
type 
  Region_overlap* {.size: sizeof(cint), pure.} = enum 
    `IN`, `OUT`, 
    PART
proc region_create*(): Region {.
    importc: "cairo_region_create", libcairo.}
proc region_create_rectangle*(rectangle: Rectangle_int): Region {.
    importc: "cairo_region_create_rectangle", libcairo.}
proc region_create_rectangles*(rects: Rectangle_int; 
                                     count: cint): Region {.
    importc: "cairo_region_create_rectangles", libcairo.}
proc copy*(original: Region): Region {.
    importc: "cairo_region_copy", libcairo.}
proc reference*(region: Region): Region {.
    importc: "cairo_region_reference", libcairo.}
proc destroy*(region: Region) {.
    importc: "cairo_region_destroy", libcairo.}
proc equal*(a: Region; b: Region): cairo_bool_t {.
    importc: "cairo_region_equal", libcairo.}
proc status*(region: Region): Status {.
    importc: "cairo_region_status", libcairo.}
proc get_extents*(region: Region; 
                               extents: var Rectangle_intObj) {.
    importc: "cairo_region_get_extents", libcairo.}
proc num_rectangles*(region: Region): cint {.
    importc: "cairo_region_num_rectangles", libcairo.}
proc get_rectangle*(region: Region; nth: cint; 
                                 rectangle: var Rectangle_intObj) {.
    importc: "cairo_region_get_rectangle", libcairo.}
proc is_empty*(region: Region): cairo_bool_t {.
    importc: "cairo_region_is_empty", libcairo.}
proc contains_rectangle*(region: Region; 
                                      rectangle: Rectangle_int): Region_overlap {.
    importc: "cairo_region_contains_rectangle", libcairo.}
proc contains_point*(region: Region; x: cint; y: cint): cairo_bool_t {.
    importc: "cairo_region_contains_point", libcairo.}
proc translate*(region: Region; dx: cint; dy: cint) {.
    importc: "cairo_region_translate", libcairo.}
proc subtract*(dst: Region; other: Region): Status {.
    importc: "cairo_region_subtract", libcairo.}
proc subtract_rectangle*(dst: Region; 
                                      rectangle: Rectangle_int): Status {.
    importc: "cairo_region_subtract_rectangle", libcairo.}
proc intersect*(dst: Region; 
                             other: Region): Status {.
    importc: "cairo_region_intersect", libcairo.}
proc intersect_rectangle*(dst: Region; 
    rectangle: Rectangle_int): Status {.
    importc: "cairo_region_intersect_rectangle", libcairo.}
proc union*(dst: Region; other: Region): Status {.
    importc: "cairo_region_union", libcairo.}
proc union_rectangle*(dst: Region; 
                                   rectangle: Rectangle_int): Status {.
    importc: "cairo_region_union_rectangle", libcairo.}
proc xor_op*(dst: Region; other: Region): Status {.
    importc: "cairo_region_xor", libcairo.}
proc xor_rectangle*(dst: Region; 
                                 rectangle: Rectangle_int): Status {.
    importc: "cairo_region_xor_rectangle", libcairo.}
proc debug_reset_static_data*() {.
    importc: "cairo_debug_reset_static_data", libcairo.}

when CAIRO_HAS_PDF_SURFACE: 
  type 
    Pdf_version* {.size: sizeof(cint), pure.} = enum 
      V1_4, V1_5
  proc pdf_surface_create*(filename: cstring; width_in_points: cdouble; 
                                 height_in_points: cdouble): Surface {.
      importc: "cairo_pdf_surface_create", libcairo.}
  proc pdf_surface_create_for_stream*(write_func: cairo_write_func_t; 
      closure: pointer; width_in_points: cdouble; height_in_points: cdouble): Surface {.
      importc: "cairo_pdf_surface_create_for_stream", libcairo.}
  proc pdf_surface_restrict_to_version*(surface: Surface; 
      version: Pdf_version) {.importc: "cairo_pdf_surface_restrict_to_version", 
                                      libcairo.}
  proc pdf_get_versions*(versions: ptr ptr Pdf_version; 
                               num_versions: var cint) {.
      importc: "cairo_pdf_get_versions", libcairo.}
  proc to_string*(version: Pdf_version): cstring {.
      importc: "cairo_pdf_version_to_string", libcairo.}
  proc pdf_surface_set_size*(surface: Surface; 
                                   width_in_points: cdouble; 
                                   height_in_points: cdouble) {.
      importc: "cairo_pdf_surface_set_size", libcairo.}

when CAIRO_HAS_PS_SURFACE: 
  type 
    Ps_level* {.size: sizeof(cint), pure.} = enum 
      L2, L3
  proc ps_surface_create*(filename: cstring; width_in_points: cdouble; 
                                height_in_points: cdouble): Surface {.
      importc: "cairo_ps_surface_create", libcairo.}
  proc ps_surface_create_for_stream*(write_func: cairo_write_func_t; 
      closure: pointer; width_in_points: cdouble; height_in_points: cdouble): Surface {.
      importc: "cairo_ps_surface_create_for_stream", libcairo.}
  proc ps_surface_restrict_to_level*(surface: Surface; 
      level: Ps_level) {.importc: "cairo_ps_surface_restrict_to_level", 
                                 libcairo.}
  proc ps_get_levels*(levels: ptr ptr Ps_level; 
                            num_levels: var cint) {.
      importc: "cairo_ps_get_levels", libcairo.}
  proc to_string*(level: Ps_level): cstring {.
      importc: "cairo_ps_level_to_string", libcairo.}
  proc ps_surface_set_eps*(surface: Surface; 
                                 eps: cairo_bool_t) {.
      importc: "cairo_ps_surface_set_eps", libcairo.}
  proc ps_surface_get_eps*(surface: Surface): cairo_bool_t {.
      importc: "cairo_ps_surface_get_eps", libcairo.}
  proc ps_surface_set_size*(surface: Surface; 
                                  width_in_points: cdouble; 
                                  height_in_points: cdouble) {.
      importc: "cairo_ps_surface_set_size", libcairo.}
  proc ps_surface_dsc_comment*(surface: Surface; 
                                     comment: cstring) {.
      importc: "cairo_ps_surface_dsc_comment", libcairo.}
  proc ps_surface_dsc_begin_setup*(surface: Surface) {.
      importc: "cairo_ps_surface_dsc_begin_setup", libcairo.}
  proc ps_surface_dsc_begin_page_setup*(surface: Surface) {.
      importc: "cairo_ps_surface_dsc_begin_page_setup", libcairo.}

when CAIRO_HAS_SVG_SURFACE: 
  type 
    Svg_version* {.size: sizeof(cint), pure.} = enum 
      V1_1, V1_2
  proc svg_surface_create*(filename: cstring; width_in_points: cdouble; 
                                 height_in_points: cdouble): Surface {.
      importc: "cairo_svg_surface_create", libcairo.}
  proc svg_surface_create_for_stream*(write_func: cairo_write_func_t; 
      closure: pointer; width_in_points: cdouble; height_in_points: cdouble): Surface {.
      importc: "cairo_svg_surface_create_for_stream", libcairo.}
  proc svg_surface_restrict_to_version*(surface: Surface; 
      version: Svg_version) {.importc: "cairo_svg_surface_restrict_to_version", 
                                      libcairo.}
  proc svg_get_versions*(versions: ptr ptr Svg_version; 
                               num_versions: var cint) {.
      importc: "cairo_svg_get_versions", libcairo.}
  proc to_string*(version: Svg_version): cstring {.
      importc: "cairo_svg_version_to_string", libcairo.}

when CAIRO_HAS_XML_SURFACE: 
  proc xml_create*(filename: cstring): Device {.
      importc: "cairo_xml_create", libcairo.}
  proc xml_create_for_stream*(write_func: cairo_write_func_t; 
                                    closure: pointer): Device {.
      importc: "cairo_xml_create_for_stream", libcairo.}
  proc xml_surface_create*(xml: Device; 
                                 content: Content; width: cdouble; 
                                 height: cdouble): Surface {.
      importc: "cairo_xml_surface_create", libcairo.}
  proc xml_for_recording_surface*(xml: Device; 
      surface: Surface): Status {.
      importc: "cairo_xml_for_recording_surface", libcairo.}

when CAIRO_HAS_SCRIPT_SURFACE: 
  type 
    Script_mode* {.size: sizeof(cint), pure.} = enum 
      ASCII, BINARY
  proc script_create*(filename: cstring): Device {.
      importc: "cairo_script_create", libcairo.}
  proc script_create_for_stream*(write_func: cairo_write_func_t; 
      closure: pointer): Device {.
      importc: "cairo_script_create_for_stream", libcairo.}
  proc script_write_comment*(script: Device; 
                                   comment: cstring; len: cint) {.
      importc: "cairo_script_write_comment", libcairo.}
  proc script_set_mode*(script: Device; 
                              mode: Script_mode) {.
      importc: "cairo_script_set_mode", libcairo.}
  proc script_get_mode*(script: Device): Script_mode {.
      importc: "cairo_script_get_mode", libcairo.}
  proc script_surface_create*(script: Device; 
                                    content: Content; width: cdouble; 
                                    height: cdouble): Surface {.
      importc: "cairo_script_surface_create", libcairo.}
  proc script_surface_create_for_target*(script: Device; 
      target: Surface): Surface {.
      importc: "cairo_script_surface_create_for_target", libcairo.}
  proc script_from_recording_surface*(script: Device; 
      recording_surface: Surface): Status {.
      importc: "cairo_script_from_recording_surface", libcairo.}

when CAIRO_HAS_SKIA_SURFACE: 
  proc skia_surface_create*(format: Format; width: cint; 
                                  height: cint): Surface {.
      importc: "cairo_skia_surface_create", libcairo.}
  proc skia_surface_create_for_data*(data: ptr cuchar; 
      format: Format; width: cint; height: cint; stride: cint): Surface {.
      importc: "cairo_skia_surface_create_for_data", libcairo.}

when CAIRO_HAS_DRM_SURFACE: 
  type 
    udev_device* = object 
    
  proc drm_device_get*(device: ptr udev_device): Device {.
      importc: "cairo_drm_device_get", libcairo.}
  proc drm_device_get_for_fd*(fd: cint): Device {.
      importc: "cairo_drm_device_get_for_fd", libcairo.}
  proc drm_device_default*(): Device {.
      importc: "cairo_drm_device_default", libcairo.}
  proc drm_device_get_fd*(device: Device): cint {.
      importc: "cairo_drm_device_get_fd", libcairo.}
  proc drm_device_throttle*(device: Device) {.
      importc: "cairo_drm_device_throttle", libcairo.}
  proc drm_surface_create*(device: Device; 
                                 format: Format; width: cint; 
                                 height: cint): Surface {.
      importc: "cairo_drm_surface_create", libcairo.}
  proc drm_surface_create_for_name*(device: Device; 
      name: cuint; format: Format; width: cint; height: cint; 
      stride: cint): Surface {.
      importc: "cairo_drm_surface_create_for_name", libcairo.}
  proc drm_surface_create_from_cacheable_image*(
      device: Device; surface: Surface): Surface {.
      importc: "cairo_drm_surface_create_from_cacheable_image", libcairo.}
  proc drm_surface_enable_scan_out*(surface: Surface): Status {.
      importc: "cairo_drm_surface_enable_scan_out", libcairo.}
  proc drm_surface_get_handle*(surface: Surface): cuint {.
      importc: "cairo_drm_surface_get_handle", libcairo.}
  proc drm_surface_get_name*(surface: Surface): cuint {.
      importc: "cairo_drm_surface_get_name", libcairo.}
  proc drm_surface_get_format*(surface: Surface): Format {.
      importc: "cairo_drm_surface_get_format", libcairo.}
  proc drm_surface_get_width*(surface: Surface): cint {.
      importc: "cairo_drm_surface_get_width", libcairo.}
  proc drm_surface_get_height*(surface: Surface): cint {.
      importc: "cairo_drm_surface_get_height", libcairo.}
  proc drm_surface_get_stride*(surface: Surface): cint {.
      importc: "cairo_drm_surface_get_stride", libcairo.}
  proc drm_surface_map_to_image*(surface: Surface): Surface {.
      importc: "cairo_drm_surface_map_to_image", libcairo.}
  proc drm_surface_unmap*(drm_surface: Surface; 
                                image_surface: Surface) {.
      importc: "cairo_drm_surface_unmap", libcairo.}

when CAIRO_HAS_TEE_SURFACE: 
  proc tee_surface_create*(master: Surface): Surface {.
      importc: "cairo_tee_surface_create", libcairo.}
  proc tee_surface_add*(surface: Surface; 
                              target: Surface) {.
      importc: "cairo_tee_surface_add", libcairo.}
  proc tee_surface_remove*(surface: Surface; 
                                 target: Surface) {.
      importc: "cairo_tee_surface_remove", libcairo.}
  proc tee_surface_index*(surface: Surface; index: cuint): Surface {.
      importc: "cairo_tee_surface_index", libcairo.}

{.deprecated: [PContext: Context, TContext: ContextObj].}
{.deprecated: [PSurface: Surface, TSurface: SurfaceObj].}
{.deprecated: [PDevice: Device, TDevice: DeviceObj].}
{.deprecated: [PMatrix: Matrix, TMatrix: MatrixObj].}
{.deprecated: [PPattern: Pattern, TPattern: PatternObj].}
{.deprecated: [PUser_data_key: User_data_key, TUser_data_key: User_data_keyObj].}
{.deprecated: [PRectangle_int: Rectangle_int, TRectangle_int: Rectangle_intObj].}
{.deprecated: [PRectangle: Rectangle, TRectangle: RectangleObj].}
{.deprecated: [PRectangle_list: Rectangle_list, TRectangle_list: Rectangle_listObj].}
{.deprecated: [PScaled_font: Scaled_font, TScaled_font: Scaled_fontObj].}
{.deprecated: [PFont_face: Font_face, TFont_face: Font_faceObj].}
{.deprecated: [PGlyph: Glyph, TGlyph: GlyphObj].}
{.deprecated: [PText_cluster: Text_cluster, TText_cluster: Text_clusterObj].}
{.deprecated: [PText_extents: Text_extents, TText_extents: Text_extentsObj].}
{.deprecated: [PFont_extents: Font_extents, TFont_extents: Font_extentsObj].}
{.deprecated: [PFont_options: Font_options, TFont_options: Font_optionsObj].}
{.deprecated: [PPath: Path, TPath: PathObj].}
{.deprecated: [PRegion: Region, TRegion: RegionObj].}
{.deprecated: [TStatus: Status].}
{.deprecated: [TContent: Content].}
{.deprecated: [TFormat: Format].}
{.deprecated: [TOperator: Operator].}
{.deprecated: [TAntialias: Antialias].}
{.deprecated: [TFill_rule: Fill_rule].}
{.deprecated: [TLine_cap: Line_cap].}
{.deprecated: [TLine_join: Line_join].}
{.deprecated: [TText_cluster_flags: Text_cluster_flags].}
{.deprecated: [TFont_slant: Font_slant].}
{.deprecated: [TFont_weight: Font_weight].}
{.deprecated: [TSubpixel_order: Subpixel_order].}
{.deprecated: [THint_style: Hint_style].}
{.deprecated: [THint_metrics: Hint_metrics].}
{.deprecated: [TFont_type: Font_type].}
{.deprecated: [TPath_data_type: Path_data_type].}
{.deprecated: [TDevice_type: Device_type].}
{.deprecated: [TSurface_observer_mode: Surface_observer_mode].}
{.deprecated: [TSurface_type: Surface_type].}
{.deprecated: [TPattern_type: Pattern_type].}
{.deprecated: [TExtend: Extend].}
{.deprecated: [TFilter: Filter].}
{.deprecated: [TRegion_overlap: Region_overlap].}
{.deprecated: [TPdf_version: Pdf_version].}
{.deprecated: [TPs_level: Ps_level].}
{.deprecated: [TSvg_version: Svg_version].}
{.deprecated: [TScript_mode: Script_mode].}
{.deprecated: [cairo_create: create].}
{.deprecated: [cairo_reference: reference].}
{.deprecated: [cairo_destroy: destroy].}
{.deprecated: [cairo_get_reference_count: get_reference_count].}
{.deprecated: [cairo_get_user_data: get_user_data].}
{.deprecated: [cairo_set_user_data: set_user_data].}
{.deprecated: [cairo_save: save].}
{.deprecated: [cairo_restore: restore].}
{.deprecated: [cairo_push_group: push_group].}
{.deprecated: [cairo_push_group_with_content: push_group_with_content].}
{.deprecated: [cairo_pop_group: pop_group].}
{.deprecated: [cairo_pop_group_to_source: pop_group_to_source].}
{.deprecated: [cairo_set_operator: set_operator].}
{.deprecated: [cairo_set_source: set_source].}
{.deprecated: [cairo_set_source_rgb: set_source_rgb].}
{.deprecated: [cairo_set_source_rgba: set_source_rgba].}
{.deprecated: [cairo_set_source_surface: set_source_surface].}
{.deprecated: [cairo_set_tolerance: set_tolerance].}
{.deprecated: [cairo_set_antialias: set_antialias].}
{.deprecated: [cairo_set_fill_rule: set_fill_rule].}
{.deprecated: [cairo_set_line_width: set_line_width].}
{.deprecated: [cairo_set_line_cap: set_line_cap].}
{.deprecated: [cairo_set_line_join: set_line_join].}
{.deprecated: [cairo_set_dash: set_dash].}
{.deprecated: [cairo_set_miter_limit: set_miter_limit].}
{.deprecated: [cairo_translate: translate].}
{.deprecated: [cairo_scale: scale].}
{.deprecated: [cairo_rotate: rotate].}
{.deprecated: [cairo_transform: transform].}
{.deprecated: [cairo_set_matrix: set_matrix].}
{.deprecated: [cairo_identity_matrix: identity_matrix].}
{.deprecated: [cairo_user_to_device: user_to_device].}
{.deprecated: [cairo_user_to_device_distance: user_to_device_distance].}
{.deprecated: [cairo_device_to_user: device_to_user].}
{.deprecated: [cairo_device_to_user_distance: device_to_user_distance].}
{.deprecated: [cairo_new_path: new_path].}
{.deprecated: [cairo_move_to: move_to].}
{.deprecated: [cairo_new_sub_path: new_sub_path].}
{.deprecated: [cairo_line_to: line_to].}
{.deprecated: [cairo_curve_to: curve_to].}
{.deprecated: [cairo_arc: arc].}
{.deprecated: [cairo_arc_negative: arc_negative].}
{.deprecated: [cairo_rel_move_to: rel_move_to].}
{.deprecated: [cairo_rel_line_to: rel_line_to].}
{.deprecated: [cairo_rel_curve_to: rel_curve_to].}
{.deprecated: [cairo_rectangle: rectangle].}
{.deprecated: [cairo_close_path: close_path].}
{.deprecated: [cairo_path_extents: path_extents].}
{.deprecated: [cairo_paint: paint].}
{.deprecated: [cairo_paint_with_alpha: paint_with_alpha].}
{.deprecated: [cairo_mask: mask].}
{.deprecated: [cairo_mask_surface: mask_surface].}
{.deprecated: [cairo_stroke: stroke].}
{.deprecated: [cairo_stroke_preserve: stroke_preserve].}
{.deprecated: [cairo_fill: fill].}
{.deprecated: [cairo_fill_preserve: fill_preserve].}
{.deprecated: [cairo_copy_page: copy_page].}
{.deprecated: [cairo_show_page: show_page].}
{.deprecated: [cairo_in_stroke: in_stroke].}
{.deprecated: [cairo_in_fill: in_fill].}
{.deprecated: [cairo_in_clip: in_clip].}
{.deprecated: [cairo_stroke_extents: stroke_extents].}
{.deprecated: [cairo_fill_extents: fill_extents].}
{.deprecated: [cairo_reset_clip: reset_clip].}
{.deprecated: [cairo_clip: clip].}
{.deprecated: [cairo_clip_preserve: clip_preserve].}
{.deprecated: [cairo_clip_extents: clip_extents].}
{.deprecated: [cairo_copy_clip_rectangle_list: copy_clip_rectangle_list].}
{.deprecated: [cairo_rectangle_list_destroy: destroy].}
{.deprecated: [cairo_glyph_allocate: glyph_allocate].}
{.deprecated: [cairo_glyph_free: free].}
{.deprecated: [cairo_text_cluster_allocate: text_cluster_allocate].}
{.deprecated: [cairo_text_cluster_free: free].}
{.deprecated: [cairo_font_options_create: font_options_create].}
{.deprecated: [cairo_font_options_copy: copy].}
{.deprecated: [cairo_font_options_destroy: destroy].}
{.deprecated: [cairo_font_options_status: status].}
{.deprecated: [cairo_font_options_merge: merge].}
{.deprecated: [cairo_font_options_equal: equal].}
{.deprecated: [cairo_font_options_hash: hash].}
{.deprecated: [cairo_font_options_set_antialias: set_antialias].}
{.deprecated: [cairo_font_options_get_antialias: get_antialias].}
{.deprecated: [cairo_font_options_set_subpixel_order: set_subpixel_order].}
{.deprecated: [cairo_font_options_get_subpixel_order: get_subpixel_order].}
{.deprecated: [cairo_font_options_set_hint_style: set_hint_style].}
{.deprecated: [cairo_font_options_get_hint_style: get_hint_style].}
{.deprecated: [cairo_font_options_set_hint_metrics: set_hint_metrics].}
{.deprecated: [cairo_font_options_get_hint_metrics: get_hint_metrics].}
{.deprecated: [cairo_select_font_face: select_font_face].}
{.deprecated: [cairo_set_font_size: set_font_size].}
{.deprecated: [cairo_set_font_matrix: set_font_matrix].}
{.deprecated: [cairo_get_font_matrix: get_font_matrix].}
{.deprecated: [cairo_set_font_options: set_font_options].}
{.deprecated: [cairo_get_font_options: get_font_options].}
{.deprecated: [cairo_set_font_face: set_font_face].}
{.deprecated: [cairo_get_font_face: get_font_face].}
{.deprecated: [cairo_set_scaled_font: set_scaled_font].}
{.deprecated: [cairo_get_scaled_font: get_scaled_font].}
{.deprecated: [cairo_show_text: show_text].}
{.deprecated: [cairo_show_glyphs: show_glyphs].}
{.deprecated: [cairo_show_text_glyphs: show_text_glyphs].}
{.deprecated: [cairo_text_path: text_path].}
{.deprecated: [cairo_glyph_path: glyph_path].}
{.deprecated: [cairo_text_extents: text_extents].}
{.deprecated: [cairo_glyph_extents: glyph_extents].}
{.deprecated: [cairo_font_extents: font_extents].}
{.deprecated: [cairo_font_face_reference: reference].}
{.deprecated: [cairo_font_face_destroy: destroy].}
{.deprecated: [cairo_font_face_get_reference_count: get_reference_count].}
{.deprecated: [cairo_font_face_status: status].}
{.deprecated: [cairo_font_face_get_type: get_type].}
{.deprecated: [cairo_font_face_get_user_data: get_user_data].}
{.deprecated: [cairo_font_face_set_user_data: set_user_data].}
{.deprecated: [cairo_scaled_font_create: scaled_font_create].}
{.deprecated: [cairo_scaled_font_reference: reference].}
{.deprecated: [cairo_scaled_font_destroy: destroy].}
{.deprecated: [cairo_scaled_font_get_reference_count: get_reference_count].}
{.deprecated: [cairo_scaled_font_status: status].}
{.deprecated: [cairo_scaled_font_get_type: get_type].}
{.deprecated: [cairo_scaled_font_get_user_data: get_user_data].}
{.deprecated: [cairo_scaled_font_set_user_data: set_user_data].}
{.deprecated: [cairo_scaled_font_extents: extents].}
{.deprecated: [cairo_scaled_font_text_extents: text_extents].}
{.deprecated: [cairo_scaled_font_glyph_extents: glyph_extents].}
{.deprecated: [cairo_scaled_font_text_to_glyphs: text_to_glyphs].}
{.deprecated: [cairo_scaled_font_get_font_face: get_font_face].}
{.deprecated: [cairo_scaled_font_get_font_matrix: get_font_matrix].}
{.deprecated: [cairo_scaled_font_get_ctm: get_ctm].}
{.deprecated: [cairo_scaled_font_get_scale_matrix: get_scale_matrix].}
{.deprecated: [cairo_scaled_font_get_font_options: get_font_options].}
{.deprecated: [cairo_toy_font_face_create: toy_font_face_create].}
{.deprecated: [cairo_toy_font_face_get_family: toy_font_face_get_family].}
{.deprecated: [cairo_toy_font_face_get_slant: toy_font_face_get_slant].}
{.deprecated: [cairo_toy_font_face_get_weight: toy_font_face_get_weight].}
{.deprecated: [cairo_user_font_face_create: user_font_face_create].}
{.deprecated: [cairo_user_font_face_set_init_func: user_font_face_set_init_func].}
{.deprecated: [cairo_user_font_face_set_render_glyph_func: user_font_face_set_render_glyph_func].}
{.deprecated: [cairo_user_font_face_set_text_to_glyphs_func: user_font_face_set_text_to_glyphs_func].}
{.deprecated: [cairo_user_font_face_set_unicode_to_glyph_func: user_font_face_set_unicode_to_glyph_func].}
{.deprecated: [cairo_user_font_face_get_init_func: user_font_face_get_init_func].}
{.deprecated: [cairo_user_font_face_get_render_glyph_func: user_font_face_get_render_glyph_func].}
{.deprecated: [cairo_user_font_face_get_text_to_glyphs_func: user_font_face_get_text_to_glyphs_func].}
{.deprecated: [cairo_user_font_face_get_unicode_to_glyph_func: user_font_face_get_unicode_to_glyph_func].}
{.deprecated: [cairo_get_operator: get_operator].}
{.deprecated: [cairo_get_source: get_source].}
{.deprecated: [cairo_get_tolerance: get_tolerance].}
{.deprecated: [cairo_get_antialias: get_antialias].}
{.deprecated: [cairo_has_current_point: has_current_point].}
{.deprecated: [cairo_get_current_point: get_current_point].}
{.deprecated: [cairo_get_fill_rule: get_fill_rule].}
{.deprecated: [cairo_get_line_width: get_line_width].}
{.deprecated: [cairo_get_line_cap: get_line_cap].}
{.deprecated: [cairo_get_line_join: get_line_join].}
{.deprecated: [cairo_get_miter_limit: get_miter_limit].}
{.deprecated: [cairo_get_dash_count: get_dash_count].}
{.deprecated: [cairo_get_dash: get_dash].}
{.deprecated: [cairo_get_matrix: get_matrix].}
{.deprecated: [cairo_get_target: get_target].}
{.deprecated: [cairo_get_group_target: get_group_target].}
{.deprecated: [cairo_copy_path: copy_path].}
{.deprecated: [cairo_copy_path_flat: copy_path_flat].}
{.deprecated: [cairo_append_path: append_path].}
{.deprecated: [cairo_path_destroy: destroy].}
{.deprecated: [cairo_status: status].}
{.deprecated: [cairo_status_to_string: to_string].}
{.deprecated: [cairo_device_reference: reference].}
{.deprecated: [cairo_device_get_type: get_type].}
{.deprecated: [cairo_device_status: status].}
{.deprecated: [cairo_device_acquire: acquire].}
{.deprecated: [cairo_device_release: release].}
{.deprecated: [cairo_device_flush: flush].}
{.deprecated: [cairo_device_finish: finish].}
{.deprecated: [cairo_device_destroy: destroy].}
{.deprecated: [cairo_device_get_reference_count: get_reference_count].}
{.deprecated: [cairo_device_get_user_data: get_user_data].}
{.deprecated: [cairo_device_set_user_data: set_user_data].}
{.deprecated: [cairo_surface_create_similar: create_similar].}
{.deprecated: [cairo_surface_create_similar_image: create_similar_image].}
{.deprecated: [cairo_surface_map_to_image: map_to_image].}
{.deprecated: [cairo_surface_unmap_image: unmap_image].}
{.deprecated: [cairo_surface_create_for_rectangle: create_for_rectangle].}
{.deprecated: [cairo_surface_create_observer: create_observer].}
{.deprecated: [cairo_surface_observer_add_paint_callback: observer_add_paint_callback].}
{.deprecated: [cairo_surface_observer_add_mask_callback: observer_add_mask_callback].}
{.deprecated: [cairo_surface_observer_add_fill_callback: observer_add_fill_callback].}
{.deprecated: [cairo_surface_observer_add_stroke_callback: observer_add_stroke_callback].}
{.deprecated: [cairo_surface_observer_add_glyphs_callback: observer_add_glyphs_callback].}
{.deprecated: [cairo_surface_observer_add_flush_callback: observer_add_flush_callback].}
{.deprecated: [cairo_surface_observer_add_finish_callback: observer_add_finish_callback].}
{.deprecated: [cairo_surface_observer_print: observer_print].}
{.deprecated: [cairo_surface_observer_elapsed: observer_elapsed].}
{.deprecated: [cairo_device_observer_print: observer_print].}
{.deprecated: [cairo_device_observer_elapsed: observer_elapsed].}
{.deprecated: [cairo_device_observer_paint_elapsed: observer_paint_elapsed].}
{.deprecated: [cairo_device_observer_mask_elapsed: observer_mask_elapsed].}
{.deprecated: [cairo_device_observer_fill_elapsed: observer_fill_elapsed].}
{.deprecated: [cairo_device_observer_stroke_elapsed: observer_stroke_elapsed].}
{.deprecated: [cairo_device_observer_glyphs_elapsed: observer_glyphs_elapsed].}
{.deprecated: [cairo_surface_reference: reference].}
{.deprecated: [cairo_surface_finish: finish].}
{.deprecated: [cairo_surface_destroy: destroy].}
{.deprecated: [cairo_surface_get_device: get_device].}
{.deprecated: [cairo_surface_get_reference_count: get_reference_count].}
{.deprecated: [cairo_surface_status: status].}
{.deprecated: [cairo_surface_get_type: get_type].}
{.deprecated: [cairo_surface_get_content: get_content].}
{.deprecated: [cairo_surface_write_to_png: write_to_png].}
{.deprecated: [cairo_surface_write_to_png_stream: write_to_png_stream].}
{.deprecated: [cairo_surface_get_user_data: get_user_data].}
{.deprecated: [cairo_surface_set_user_data: set_user_data].}
{.deprecated: [cairo_surface_get_mime_data: get_mime_data].}
{.deprecated: [cairo_surface_set_mime_data: set_mime_data].}
{.deprecated: [cairo_surface_supports_mime_type: supports_mime_type].}
{.deprecated: [cairo_surface_get_font_options: get_font_options].}
{.deprecated: [cairo_surface_flush: flush].}
{.deprecated: [cairo_surface_mark_dirty: mark_dirty].}
{.deprecated: [cairo_surface_mark_dirty_rectangle: mark_dirty_rectangle].}
{.deprecated: [cairo_surface_set_device_scale: set_device_scale].}
{.deprecated: [cairo_surface_get_device_scale: get_device_scale].}
{.deprecated: [cairo_surface_set_device_offset: set_device_offset].}
{.deprecated: [cairo_surface_get_device_offset: get_device_offset].}
{.deprecated: [cairo_surface_set_fallback_resolution: set_fallback_resolution].}
{.deprecated: [cairo_surface_get_fallback_resolution: get_fallback_resolution].}
{.deprecated: [cairo_surface_copy_page: copy_page].}
{.deprecated: [cairo_surface_show_page: show_page].}
{.deprecated: [cairo_surface_has_show_text_glyphs: has_show_text_glyphs].}
{.deprecated: [cairo_image_surface_create: image_surface_create].}
{.deprecated: [cairo_format_stride_for_width: stride_for_width].}
{.deprecated: [cairo_image_surface_create_for_data: image_surface_create_for_data].}
{.deprecated: [cairo_image_surface_get_data: image_surface_get_data].}
{.deprecated: [cairo_image_surface_get_format: image_surface_get_format].}
{.deprecated: [cairo_image_surface_get_width: image_surface_get_width].}
{.deprecated: [cairo_image_surface_get_height: image_surface_get_height].}
{.deprecated: [cairo_image_surface_get_stride: image_surface_get_stride].}
{.deprecated: [cairo_image_surface_create_from_png: image_surface_create_from_png].}
{.deprecated: [cairo_image_surface_create_from_png_stream: image_surface_create_from_png_stream].}
{.deprecated: [cairo_recording_surface_create: recording_surface_create].}
{.deprecated: [cairo_recording_surface_ink_extents: recording_surface_ink_extents].}
{.deprecated: [cairo_recording_surface_get_extents: recording_surface_get_extents].}
{.deprecated: [cairo_pattern_create_raster_source: pattern_create_raster_source].}
{.deprecated: [cairo_raster_source_pattern_set_callback_data: raster_source_pattern_set_callback_data].}
{.deprecated: [cairo_raster_source_pattern_get_callback_data: raster_source_pattern_get_callback_data].}
{.deprecated: [cairo_raster_source_pattern_set_acquire: raster_source_pattern_set_acquire].}
{.deprecated: [cairo_raster_source_pattern_get_acquire: raster_source_pattern_get_acquire].}
{.deprecated: [cairo_raster_source_pattern_set_snapshot: raster_source_pattern_set_snapshot].}
{.deprecated: [cairo_raster_source_pattern_get_snapshot: raster_source_pattern_get_snapshot].}
{.deprecated: [cairo_raster_source_pattern_set_copy: raster_source_pattern_set_copy].}
{.deprecated: [cairo_raster_source_pattern_get_copy: raster_source_pattern_get_copy].}
{.deprecated: [cairo_raster_source_pattern_set_finish: raster_source_pattern_set_finish].}
{.deprecated: [cairo_raster_source_pattern_get_finish: raster_source_pattern_get_finish].}
{.deprecated: [cairo_pattern_create_rgb: pattern_create_rgb].}
{.deprecated: [cairo_pattern_create_rgba: pattern_create_rgba].}
{.deprecated: [cairo_pattern_create_for_surface: pattern_create_for_surface].}
{.deprecated: [cairo_pattern_create_linear: pattern_create_linear].}
{.deprecated: [cairo_pattern_create_radial: pattern_create_radial].}
{.deprecated: [cairo_pattern_create_mesh: pattern_create_mesh].}
{.deprecated: [cairo_pattern_reference: reference].}
{.deprecated: [cairo_pattern_destroy: destroy].}
{.deprecated: [cairo_pattern_get_reference_count: get_reference_count].}
{.deprecated: [cairo_pattern_status: status].}
{.deprecated: [cairo_pattern_get_user_data: get_user_data].}
{.deprecated: [cairo_pattern_set_user_data: set_user_data].}
{.deprecated: [cairo_pattern_get_type: get_type].}
{.deprecated: [cairo_pattern_add_color_stop_rgb: add_color_stop_rgb].}
{.deprecated: [cairo_pattern_add_color_stop_rgba: add_color_stop_rgba].}
{.deprecated: [cairo_mesh_pattern_begin_patch: mesh_pattern_begin_patch].}
{.deprecated: [cairo_mesh_pattern_end_patch: mesh_pattern_end_patch].}
{.deprecated: [cairo_mesh_pattern_curve_to: mesh_pattern_curve_to].}
{.deprecated: [cairo_mesh_pattern_line_to: mesh_pattern_line_to].}
{.deprecated: [cairo_mesh_pattern_move_to: mesh_pattern_move_to].}
{.deprecated: [cairo_mesh_pattern_set_control_point: mesh_pattern_set_control_point].}
{.deprecated: [cairo_mesh_pattern_set_corner_color_rgb: mesh_pattern_set_corner_color_rgb].}
{.deprecated: [cairo_mesh_pattern_set_corner_color_rgba: mesh_pattern_set_corner_color_rgba].}
{.deprecated: [cairo_pattern_set_matrix: set_matrix].}
{.deprecated: [cairo_pattern_get_matrix: get_matrix].}
{.deprecated: [cairo_pattern_set_extend: set_extend].}
{.deprecated: [cairo_pattern_get_extend: get_extend].}
{.deprecated: [cairo_pattern_set_filter: set_filter].}
{.deprecated: [cairo_pattern_get_filter: get_filter].}
{.deprecated: [cairo_pattern_get_rgba: get_rgba].}
{.deprecated: [cairo_pattern_get_surface: get_surface].}
{.deprecated: [cairo_pattern_get_color_stop_rgba: get_color_stop_rgba].}
{.deprecated: [cairo_pattern_get_color_stop_count: get_color_stop_count].}
{.deprecated: [cairo_pattern_get_linear_points: get_linear_points].}
{.deprecated: [cairo_pattern_get_radial_circles: get_radial_circles].}
{.deprecated: [cairo_mesh_pattern_get_patch_count: mesh_pattern_get_patch_count].}
{.deprecated: [cairo_mesh_pattern_get_path: mesh_pattern_get_path].}
{.deprecated: [cairo_mesh_pattern_get_corner_color_rgba: mesh_pattern_get_corner_color_rgba].}
{.deprecated: [cairo_mesh_pattern_get_control_point: mesh_pattern_get_control_point].}
{.deprecated: [cairo_matrix_init: init].}
{.deprecated: [cairo_matrix_init_identity: init_identity].}
{.deprecated: [cairo_matrix_init_translate: init_translate].}
{.deprecated: [cairo_matrix_init_scale: init_scale].}
{.deprecated: [cairo_matrix_init_rotate: init_rotate].}
{.deprecated: [cairo_matrix_translate: translate].}
{.deprecated: [cairo_matrix_scale: scale].}
{.deprecated: [cairo_matrix_rotate: rotate].}
{.deprecated: [cairo_matrix_invert: invert].}
{.deprecated: [cairo_matrix_multiply: multiply].}
{.deprecated: [cairo_matrix_transform_distance: transform_distance].}
{.deprecated: [cairo_matrix_transform_point: transform_point].}
{.deprecated: [cairo_region_create: region_create].}
{.deprecated: [cairo_region_create_rectangle: region_create_rectangle].}
{.deprecated: [cairo_region_create_rectangles: region_create_rectangles].}
{.deprecated: [cairo_region_copy: copy].}
{.deprecated: [cairo_region_reference: reference].}
{.deprecated: [cairo_region_destroy: destroy].}
{.deprecated: [cairo_region_equal: equal].}
{.deprecated: [cairo_region_status: status].}
{.deprecated: [cairo_region_get_extents: get_extents].}
{.deprecated: [cairo_region_num_rectangles: num_rectangles].}
{.deprecated: [cairo_region_get_rectangle: get_rectangle].}
{.deprecated: [cairo_region_is_empty: is_empty].}
{.deprecated: [cairo_region_contains_rectangle: contains_rectangle].}
{.deprecated: [cairo_region_contains_point: contains_point].}
{.deprecated: [cairo_region_translate: translate].}
{.deprecated: [cairo_region_subtract: subtract].}
{.deprecated: [cairo_region_subtract_rectangle: subtract_rectangle].}
{.deprecated: [cairo_region_intersect: intersect].}
{.deprecated: [cairo_region_intersect_rectangle: intersect_rectangle].}
{.deprecated: [cairo_region_union: union].}
{.deprecated: [cairo_region_union_rectangle: union_rectangle].}
{.deprecated: [cairo_region_xor: xor_op].}
{.deprecated: [cairo_region_xor_rectangle: xor_rectangle].}
{.deprecated: [cairo_debug_reset_static_data: debug_reset_static_data].}
{.deprecated: [cairo_pdf_surface_create: pdf_surface_create].}
{.deprecated: [cairo_pdf_surface_create_for_stream: pdf_surface_create_for_stream].}
{.deprecated: [cairo_pdf_surface_restrict_to_version: pdf_surface_restrict_to_version].}
{.deprecated: [cairo_pdf_get_versions: pdf_get_versions].}
{.deprecated: [cairo_pdf_version_to_string: to_string].}
{.deprecated: [cairo_pdf_surface_set_size: pdf_surface_set_size].}
{.deprecated: [cairo_ps_surface_create: ps_surface_create].}
{.deprecated: [cairo_ps_surface_create_for_stream: ps_surface_create_for_stream].}
{.deprecated: [cairo_ps_surface_restrict_to_level: ps_surface_restrict_to_level].}
{.deprecated: [cairo_ps_get_levels: ps_get_levels].}
{.deprecated: [cairo_ps_level_to_string: to_string].}
{.deprecated: [cairo_ps_surface_set_eps: ps_surface_set_eps].}
{.deprecated: [cairo_ps_surface_get_eps: ps_surface_get_eps].}
{.deprecated: [cairo_ps_surface_set_size: ps_surface_set_size].}
{.deprecated: [cairo_ps_surface_dsc_comment: ps_surface_dsc_comment].}
{.deprecated: [cairo_ps_surface_dsc_begin_setup: ps_surface_dsc_begin_setup].}
{.deprecated: [cairo_ps_surface_dsc_begin_page_setup: ps_surface_dsc_begin_page_setup].}
{.deprecated: [cairo_svg_surface_create: svg_surface_create].}
{.deprecated: [cairo_svg_surface_create_for_stream: svg_surface_create_for_stream].}
{.deprecated: [cairo_svg_surface_restrict_to_version: svg_surface_restrict_to_version].}
{.deprecated: [cairo_svg_get_versions: svg_get_versions].}
{.deprecated: [cairo_svg_version_to_string: to_string].}
{.deprecated: [cairo_xml_create: xml_create].}
{.deprecated: [cairo_xml_create_for_stream: xml_create_for_stream].}
{.deprecated: [cairo_xml_surface_create: xml_surface_create].}
{.deprecated: [cairo_xml_for_recording_surface: xml_for_recording_surface].}
{.deprecated: [cairo_script_create: script_create].}
{.deprecated: [cairo_script_create_for_stream: script_create_for_stream].}
{.deprecated: [cairo_script_write_comment: script_write_comment].}
{.deprecated: [cairo_script_set_mode: script_set_mode].}
{.deprecated: [cairo_script_get_mode: script_get_mode].}
{.deprecated: [cairo_script_surface_create: script_surface_create].}
{.deprecated: [cairo_script_surface_create_for_target: script_surface_create_for_target].}
{.deprecated: [cairo_script_from_recording_surface: script_from_recording_surface].}
{.deprecated: [cairo_skia_surface_create: skia_surface_create].}
{.deprecated: [cairo_skia_surface_create_for_data: skia_surface_create_for_data].}
{.deprecated: [cairo_drm_device_get: drm_device_get].}
{.deprecated: [cairo_drm_device_get_for_fd: drm_device_get_for_fd].}
{.deprecated: [cairo_drm_device_default: drm_device_default].}
{.deprecated: [cairo_drm_device_get_fd: drm_device_get_fd].}
{.deprecated: [cairo_drm_device_throttle: drm_device_throttle].}
{.deprecated: [cairo_drm_surface_create: drm_surface_create].}
{.deprecated: [cairo_drm_surface_create_for_name: drm_surface_create_for_name].}
{.deprecated: [cairo_drm_surface_create_from_cacheable_image: drm_surface_create_from_cacheable_image].}
{.deprecated: [cairo_drm_surface_enable_scan_out: drm_surface_enable_scan_out].}
{.deprecated: [cairo_drm_surface_get_handle: drm_surface_get_handle].}
{.deprecated: [cairo_drm_surface_get_name: drm_surface_get_name].}
{.deprecated: [cairo_drm_surface_get_format: drm_surface_get_format].}
{.deprecated: [cairo_drm_surface_get_width: drm_surface_get_width].}
{.deprecated: [cairo_drm_surface_get_height: drm_surface_get_height].}
{.deprecated: [cairo_drm_surface_get_stride: drm_surface_get_stride].}
{.deprecated: [cairo_drm_surface_map_to_image: drm_surface_map_to_image].}
{.deprecated: [cairo_drm_surface_unmap: drm_surface_unmap].}
{.deprecated: [cairo_tee_surface_create: tee_surface_create].}
{.deprecated: [cairo_tee_surface_add: tee_surface_add].}
{.deprecated: [cairo_tee_surface_remove: tee_surface_remove].}
{.deprecated: [cairo_tee_surface_index: tee_surface_index].}
