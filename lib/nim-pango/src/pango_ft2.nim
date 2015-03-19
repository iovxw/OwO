{.deadCodeElim: on.}
import pango
from glib import gpointer, gint, GDestroyNotify
from gobject import GType
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  FT_Face = ptr object # dummy objects!
  FcPattern = object
  FT_Bitmap = object

when not DISABLE_DEPRECATED: 
  const 
    RENDER_TYPE_FT2* = "RenderFT2"
template pango_ft2_font_map*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, ft2_font_map_get_type(), 
                              FT2FontMapObj))

template pango_ft2_is_font_map*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, ft2_font_map_get_type()))

type 
  FT2FontMap* =  ptr FT2FontMapObj
  FT2FontMapPtr* = ptr FT2FontMapObj
  FT2FontMapObj* = object 
  
type 
  FT2SubstituteFunc* = proc (pattern: ptr FcPattern; data: gpointer) {.cdecl.}
proc ft2_render*(bitmap: ptr FT_Bitmap; font: Font; 
                       glyphs: GlyphString; x: gint; y: gint) {.
    importc: "pango_ft2_render", libpango.}
proc ft2_render_transformed*(bitmap: ptr FT_Bitmap; 
                                   matrix: Matrix; 
                                   font: Font; 
                                   glyphs: GlyphString; x: cint; 
                                   y: cint) {.
    importc: "pango_ft2_render_transformed", libpango.}
proc ft2_render_layout_line*(bitmap: ptr FT_Bitmap; 
                                   line: LayoutLine; x: cint; y: cint) {.
    importc: "pango_ft2_render_layout_line", libpango.}
proc ft2_render_layout_line_subpixel*(bitmap: ptr FT_Bitmap; 
    line: LayoutLine; x: cint; y: cint) {.
    importc: "pango_ft2_render_layout_line_subpixel", libpango.}
proc ft2_render_layout*(bitmap: ptr FT_Bitmap; layout: Layout; 
                              x: cint; y: cint) {.
    importc: "pango_ft2_render_layout", libpango.}
proc ft2_render_layout_subpixel*(bitmap: ptr FT_Bitmap; 
    layout: Layout; x: cint; y: cint) {.
    importc: "pango_ft2_render_layout_subpixel", libpango.}
proc ft2_font_map_get_type*(): GType {.
    importc: "pango_ft2_font_map_get_type", libpango.}
proc ft2_font_map_new*(): FontMap {.
    importc: "pango_ft2_font_map_new", libpango.}
proc ft2_font_map_set_resolution*(fontmap: FT2FontMap; 
    dpi_x: cdouble; dpi_y: cdouble) {.importc: "pango_ft2_font_map_set_resolution", 
                                      libpango.}
proc ft2_font_map_set_default_substitute*(fontmap: FT2FontMap; 
    `func`: FT2SubstituteFunc; data: gpointer; notify: GDestroyNotify) {.
    importc: "pango_ft2_font_map_set_default_substitute", libpango.}
proc ft2_font_map_substitute_changed*(fontmap: FT2FontMap) {.
    importc: "pango_ft2_font_map_substitute_changed", libpango.}
when not DISABLE_DEPRECATED: 
  proc ft2_font_map_create_context*(fontmap: FT2FontMap): Context {.
      importc: "pango_ft2_font_map_create_context", libpango.}
when not DISABLE_DEPRECATED: 
  proc ft2_get_context*(dpi_x: cdouble; dpi_y: cdouble): Context {.
      importc: "pango_ft2_get_context", libpango.}
  proc ft2_font_map_for_display*(): FontMap {.
      importc: "pango_ft2_font_map_for_display", libpango.}
  proc ft2_shutdown_display*() {.importc: "pango_ft2_shutdown_display", 
      libpango.}
  proc ft2_get_unknown_glyph*(font: Font): Glyph {.
      importc: "pango_ft2_get_unknown_glyph", libpango.}
  proc ft2_font_get_kerning*(font: Font; left: Glyph; 
                                   right: Glyph): cint {.
      importc: "pango_ft2_font_get_kerning", libpango.}
  proc ft2_font_get_face*(font: Font): FT_Face {.
      importc: "pango_ft2_font_get_face", libpango.}
  proc ft2_font_get_coverage*(font: Font; 
                                    language: Language): Coverage {.
      importc: "pango_ft2_font_get_coverage", libpango.}
