{.deadCodeElim: on.}
import pango
from glib import gint, guint, gboolean, gpointer, gunichar, GDestroyNotify
from gobject import GType
from xlib import PDisplay
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  Picture = ptr object # dummy objects!
  FcPattern = object
  FT_Face = ptr object
  XftDraw = object
  XTrapezoid = object
  XftGlyphSpec = object
  XftFont = object
  XftColor = object

const 
  XFT_NO_COMPAT = true
type 
  XftRendererPrivateObj = object 
  
template pango_xft_renderer*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, xft_renderer_get_type(), 
                              XftRendererObj))

template pango_is_xft_renderer*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, xft_renderer_get_type()))

template pango_xft_renderer_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, xft_renderer_get_type(), 
                           XftRendererClassObj))

template pango_is_xft_renderer_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, xft_renderer_get_type()))

template pango_xft_renderer_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, xft_renderer_get_type(), 
                             XftRendererClassObj))

type 
  XftRenderer* =  ptr XftRendererObj
  XftRendererPtr* = ptr XftRendererObj
  XftRendererObj*{.final.} = object of RendererObj
    display*: PDisplay
    screen*: cint
    draw*: ptr XftDraw
    priv*: ptr XftRendererPrivateObj

type 
  XftRendererClass* =  ptr XftRendererClassObj
  XftRendererClassPtr* = ptr XftRendererClassObj
  XftRendererClassObj*{.final.} = object of RendererClassObj
    composite_trapezoids*: proc (xftrenderer: XftRenderer; 
                                 part: RenderPart; 
                                 trapezoids: ptr XTrapezoid; 
                                 n_trapezoids: cint) {.cdecl.}
    composite_glyphs*: proc (xftrenderer: XftRenderer; 
                             xft_font: ptr XftFont; glyphs: ptr XftGlyphSpec; 
                             n_glyphs: cint) {.cdecl.}

proc xft_renderer_get_type*(): GType {.
    importc: "pango_xft_renderer_get_type", libpango.}
proc xft_renderer_new*(display: PDisplay; screen: cint): Renderer {.
    importc: "pango_xft_renderer_new", libpango.}
proc set_draw*(xftrenderer: XftRenderer; 
                                  draw: ptr XftDraw) {.
    importc: "pango_xft_renderer_set_draw", libpango.}
proc `draw=`*(xftrenderer: XftRenderer; 
                                  draw: ptr XftDraw) {.
    importc: "pango_xft_renderer_set_draw", libpango.}
proc set_default_color*(xftrenderer: XftRenderer; 
    default_color: Color) {.importc: "pango_xft_renderer_set_default_color", 
                                     libpango.}
proc `default_color=`*(xftrenderer: XftRenderer; 
    default_color: Color) {.importc: "pango_xft_renderer_set_default_color", 
                                     libpango.}
proc xft_render*(draw: ptr XftDraw; color: ptr XftColor; 
                       font: Font; glyphs: GlyphString; 
                       x: gint; y: gint) {.importc: "pango_xft_render", 
    libpango.}
proc xft_picture_render*(display: PDisplay; src_picture: Picture; 
                               dest_picture: Picture; font: Font; 
                               glyphs: GlyphString; x: gint; y: gint) {.
    importc: "pango_xft_picture_render", libpango.}
proc xft_render_transformed*(draw: ptr XftDraw; color: ptr XftColor; 
                                   matrix: Matrix; 
                                   font: Font; 
                                   glyphs: GlyphString; x: cint; 
                                   y: cint) {.
    importc: "pango_xft_render_transformed", libpango.}
proc xft_render_layout_line*(draw: ptr XftDraw; color: ptr XftColor; 
                                   line: LayoutLine; x: cint; y: cint) {.
    importc: "pango_xft_render_layout_line", libpango.}
proc xft_render_layout*(draw: ptr XftDraw; color: ptr XftColor; 
                              layout: Layout; x: cint; y: cint) {.
    importc: "pango_xft_render_layout", libpango.}

when not DISABLE_DEPRECATED: 
  const 
    RENDER_TYPE_XFT* = "RenderXft"
template pango_xft_font_map*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, xft_font_map_get_type(), 
                              XftFontMap))

template pango_xft_is_font_map*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, xft_font_map_get_type()))

type 
  PangoXftFont* =  ptr PangoXftFontObj
  PangoXftFontPtr* = ptr PangoXftFontObj
  PangoXftFontObj* = object 
  
type 
  XftSubstituteFunc* = proc (pattern: ptr FcPattern; data: gpointer) {.cdecl.}
proc xft_get_font_map*(display: PDisplay; screen: cint): FontMap {.
    importc: "pango_xft_get_font_map", libpango.}
when not DISABLE_DEPRECATED: 
  proc xft_get_context*(display: PDisplay; screen: cint): Context {.
      importc: "pango_xft_get_context", libpango.}
proc xft_shutdown_display*(display: PDisplay; screen: cint) {.
    importc: "pango_xft_shutdown_display", libpango.}
proc xft_set_default_substitute*(display: PDisplay; screen: cint; 
    `func`: XftSubstituteFunc; data: gpointer; notify: GDestroyNotify) {.
    importc: "pango_xft_set_default_substitute", libpango.}
proc xft_substitute_changed*(display: PDisplay; screen: cint) {.
    importc: "pango_xft_substitute_changed", libpango.}
proc xft_font_map_get_type*(): GType {.
    importc: "pango_xft_font_map_get_type", libpango.}
template pango_xft_font*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, xft_font_get_type(), PangoXftFontObj))

template pango_xft_is_font*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, xft_font_get_type()))

proc xft_font_get_type*(): GType {.importc: "pango_xft_font_get_type", 
    libpango.}
when ENABLE_ENGINE: 
  proc xft_font_get_font*(font: Font): ptr XftFont {.
      importc: "pango_xft_font_get_font", libpango.}
  proc xft_font_get_display*(font: Font): PDisplay {.
      importc: "pango_xft_font_get_display", libpango.}
  when not DISABLE_DEPRECATED: 
    proc xft_font_lock_face*(font: Font): FT_Face {.
        importc: "pango_xft_font_lock_face", libpango.}
    proc xft_font_unlock_face*(font: Font) {.
        importc: "pango_xft_font_unlock_face", libpango.}
    proc xft_font_get_glyph*(font: Font; wc: gunichar): guint {.
        importc: "pango_xft_font_get_glyph", libpango.}
    proc xft_font_has_char*(font: Font; wc: gunichar): gboolean {.
        importc: "pango_xft_font_has_char", libpango.}
    proc xft_font_get_unknown_glyph*(font: Font; wc: gunichar): Glyph {.
        importc: "pango_xft_font_get_unknown_glyph", libpango.}
