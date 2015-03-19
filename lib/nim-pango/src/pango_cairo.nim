{.deadCodeElim: on.}
import pango
from cairo import Context, Font_type, Font_options, Scaled_Font
from glib import gboolean, gpointer, GDestroyNotify
from gobject import GType
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}

type 
  CairoFont* =  ptr CairoFontObj
  CairoFontPtr* = ptr CairoFontObj
  CairoFontObj* = object 
  
template pango_cairo_font*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, cairo_font_get_type(), CairoFontObj))

template pango_is_cairo_font*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, cairo_font_get_type()))

type 
  CairoFontMap* =  ptr CairoFontMapObj
  CairoFontMapPtr* = ptr CairoFontMapObj
  CairoFontMapObj* = object 
  
template pango_cairo_font_map*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, cairo_font_map_get_type(), 
                              CairoFontMapObj))

template pango_is_cairo_font_map*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, cairo_font_map_get_type()))

type 
  CairoShapeRendererFunc* = proc (cr: cairo.Context; 
      attr: AttrShape; do_path: gboolean; data: gpointer) {.cdecl.}
proc cairo_font_map_get_type*(): GType {.
    importc: "pango_cairo_font_map_get_type", libpango.}
proc cairo_font_map_new*(): FontMap {.
    importc: "pango_cairo_font_map_new", libpango.}
proc cairo_font_map_new_for_font_type*(fonttype: cairo.Font_type): FontMap {.
    importc: "pango_cairo_font_map_new_for_font_type", libpango.}
proc cairo_font_map_get_default*(): FontMap {.
    importc: "pango_cairo_font_map_get_default", libpango.}
proc set_default*(fontmap: CairoFontMap) {.
    importc: "pango_cairo_font_map_set_default", libpango.}
proc `default=`*(fontmap: CairoFontMap) {.
    importc: "pango_cairo_font_map_set_default", libpango.}
proc get_font_type*(fontmap: CairoFontMap): cairo.Font_type {.
    importc: "pango_cairo_font_map_get_font_type", libpango.}
proc font_type*(fontmap: CairoFontMap): cairo.Font_type {.
    importc: "pango_cairo_font_map_get_font_type", libpango.}
proc set_resolution*(fontmap: CairoFontMap; 
    dpi: cdouble) {.importc: "pango_cairo_font_map_set_resolution", 
                    libpango.}
proc `resolution=`*(fontmap: CairoFontMap; 
    dpi: cdouble) {.importc: "pango_cairo_font_map_set_resolution", 
                    libpango.}
proc get_resolution*(fontmap: CairoFontMap): cdouble {.
    importc: "pango_cairo_font_map_get_resolution", libpango.}
proc resolution*(fontmap: CairoFontMap): cdouble {.
    importc: "pango_cairo_font_map_get_resolution", libpango.}
when not DISABLE_DEPRECATED: 
  proc create_context*(fontmap: CairoFontMap): pango.Context {.
      importc: "pango_cairo_font_map_create_context", libpango.}
proc cairo_font_get_type*(): GType {.
    importc: "pango_cairo_font_get_type", libpango.}
proc get_scaled_font*(font: CairoFont): cairo.Scaled_font {.
    importc: "pango_cairo_font_get_scaled_font", libpango.}
proc scaled_font*(font: CairoFont): cairo.Scaled_font {.
    importc: "pango_cairo_font_get_scaled_font", libpango.}
proc update_context*(cr: cairo.Context; context: pango.Context) {.
    importc: "pango_cairo_update_context", libpango.}
proc cairo_context_set_font_options*(context: pango.Context; 
    options: cairo.Font_options) {.
    importc: "pango_cairo_context_set_font_options", libpango.}
proc cairo_context_get_font_options*(context: pango.Context): cairo.Font_options {.
    importc: "pango_cairo_context_get_font_options", libpango.}
proc cairo_context_set_resolution*(context: pango.Context; 
    dpi: cdouble) {.importc: "pango_cairo_context_set_resolution", libpango.}
proc cairo_context_get_resolution*(context: pango.Context): cdouble {.
    importc: "pango_cairo_context_get_resolution", libpango.}
proc cairo_context_set_shape_renderer*(context: pango.Context; 
    `func`: CairoShapeRendererFunc; data: gpointer; dnotify: GDestroyNotify) {.
    importc: "pango_cairo_context_set_shape_renderer", libpango.}
proc cairo_context_get_shape_renderer*(context: pango.Context; 
    data: ptr gpointer): CairoShapeRendererFunc {.
    importc: "pango_cairo_context_get_shape_renderer", libpango.}
proc create_context*(cr: cairo.Context): pango.Context {.
    importc: "pango_cairo_create_context", libpango.}
proc create_layout*(cr: cairo.Context): Layout {.
    importc: "pango_cairo_create_layout", libpango.}
proc update_layout*(cr: cairo.Context; layout: Layout) {.
    importc: "pango_cairo_update_layout", libpango.}
proc show_glyph_string*(cr: cairo.Context; font: Font; 
                                    glyphs: GlyphString) {.
    importc: "pango_cairo_show_glyph_string", libpango.}
proc show_glyph_item*(cr: cairo.Context; text: cstring; 
                                  glyph_item: GlyphItem) {.
    importc: "pango_cairo_show_glyph_item", libpango.}
proc show_layout_line*(cr: cairo.Context; line: LayoutLine) {.
    importc: "pango_cairo_show_layout_line", libpango.}
proc show_layout*(cr: cairo.Context; layout: Layout) {.
    importc: "pango_cairo_show_layout", libpango.}
proc show_error_underline*(cr: cairo.Context; x: cdouble; 
    y: cdouble; width: cdouble; height: cdouble) {.
    importc: "pango_cairo_show_error_underline", libpango.}
proc glyph_string_path*(cr: cairo.Context; font: Font; 
                                    glyphs: GlyphString) {.
    importc: "pango_cairo_glyph_string_path", libpango.}
proc layout_line_path*(cr: cairo.Context; line: LayoutLine) {.
    importc: "pango_cairo_layout_line_path", libpango.}
proc layout_path*(cr: cairo.Context; layout: Layout) {.
    importc: "pango_cairo_layout_path", libpango.}
proc error_underline_path*(cr: cairo.Context; x: cdouble; 
    y: cdouble; width: cdouble; height: cdouble) {.
    importc: "pango_cairo_error_underline_path", libpango.}
