{.deadCodeElim: on.}
import pango
from glib import gint, gunichar, gboolean
from windows import HDC, HFONT, PLOGFONTA, LOGFONTW
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}

const 
  RENDER_TYPE_WIN32* = "RenderWin32"
when not DISABLE_DEPRECATED: 
  proc win32_get_context*(): Context {.
      importc: "pango_win32_get_context", libpango.}
proc win32_render*(hdc: HDC; font: Font; 
                         glyphs: GlyphString; x: gint; y: gint) {.
    importc: "pango_win32_render", libpango.}
proc win32_render_layout_line*(hdc: HDC; line: LayoutLine; 
                                     x: cint; y: cint) {.
    importc: "pango_win32_render_layout_line", libpango.}
proc win32_render_layout*(hdc: HDC; layout: Layout; x: cint; 
                                y: cint) {.
    importc: "pango_win32_render_layout", libpango.}
proc win32_render_transformed*(hdc: HDC; matrix: Matrix; 
                                     font: Font; 
                                     glyphs: GlyphString; x: cint; 
                                     y: cint) {.
    importc: "pango_win32_render_transformed", libpango.}
when ENABLE_ENGINE: 
  when not DISABLE_DEPRECATED: 
    proc win32_get_unknown_glyph*(font: Font; wc: gunichar): Glyph {.
        importc: "pango_win32_get_unknown_glyph", libpango.}
  proc win32_font_get_glyph_index*(font: Font; wc: gunichar): gint {.
      importc: "pango_win32_font_get_glyph_index", libpango.}
  proc win32_get_dc*(): HDC {.importc: "pango_win32_get_dc", libpango.}
  proc win32_get_debug_flag*(): gboolean {.
      importc: "pango_win32_get_debug_flag", libpango.}
  proc win32_font_select_font*(font: Font; hdc: HDC): gboolean {.
      importc: "pango_win32_font_select_font", libpango.}
  proc win32_font_done_font*(font: Font) {.
      importc: "pango_win32_font_done_font", libpango.}
  proc win32_font_get_metrics_factor*(font: Font): cdouble {.
      importc: "pango_win32_font_get_metrics_factor", libpango.}
type 
  Win32FontCache* =  ptr Win32FontCacheObj
  Win32FontCachePtr* = ptr Win32FontCacheObj
  Win32FontCacheObj* = object 
  
proc win32_font_cache_new*(): Win32FontCache {.
    importc: "pango_win32_font_cache_new", libpango.}
proc win32_font_cache_free*(cache: Win32FontCache) {.
    importc: "pango_win32_font_cache_free", libpango.}
proc win32_font_cache_load*(cache: Win32FontCache; 
                                  logfont: PLOGFONTA): HFONT {.
    importc: "pango_win32_font_cache_load", libpango.}
proc win32_font_cache_loadw*(cache: Win32FontCache; 
                                   logfont: ptr LOGFONTW): HFONT {.
    importc: "pango_win32_font_cache_loadw", libpango.}
proc win32_font_cache_unload*(cache: Win32FontCache; 
                                    hfont: HFONT) {.
    importc: "pango_win32_font_cache_unload", libpango.}
proc win32_font_map_for_display*(): FontMap {.
    importc: "pango_win32_font_map_for_display", libpango.}
proc win32_shutdown_display*() {.
    importc: "pango_win32_shutdown_display", libpango.}
proc win32_font_map_get_font_cache*(font_map: FontMap): Win32FontCache {.
    importc: "pango_win32_font_map_get_font_cache", libpango.}
proc win32_font_logfont*(font: Font): PLOGFONTA {.
    importc: "pango_win32_font_logfont", libpango.}
proc win32_font_logfontw*(font: Font): ptr LOGFONTW {.
    importc: "pango_win32_font_logfontw", libpango.}
proc win32_font_description_from_logfont*(lfp: PLOGFONTA): FontDescription {.
    importc: "pango_win32_font_description_from_logfont", libpango.}
proc win32_font_description_from_logfontw*(lfp: ptr LOGFONTW): FontDescription {.
    importc: "pango_win32_font_description_from_logfontw", libpango.}
