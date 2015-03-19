import cairo
from windows import HDC, LOGFONTW, HFONT
const CAIRO_HAS_WIN32_FONT = true
include "cairo_pragma.nim"
proc create*(hdc: HDC): Surface {.
    importc: "cairo_win32_surface_create", libcairo.}
proc printing_surface_create*(hdc: HDC): Surface {.
    importc: "cairo_win32_printing_surface_create", libcairo.}
proc create_with_ddb*(hdc: HDC; format: Format; 
    width: cint; height: cint): Surface {.
    importc: "cairo_win32_surface_create_with_ddb", libcairo.}
proc create_with_dib*(format: Format; 
    width: cint; height: cint): Surface {.
    importc: "cairo_win32_surface_create_with_dib", libcairo.}
proc get_dc*(surface: Surface): HDC {.
    importc: "cairo_win32_surface_get_dc", libcairo.}
proc get_image*(surface: Surface): Surface {.
    importc: "cairo_win32_surface_get_image", libcairo.}
when CAIRO_HAS_WIN32_FONT: 
  proc font_face_create_for_logfontw*(logfont: ptr LOGFONTW): Font_face {.
      importc: "cairo_win32_font_face_create_for_logfontw", libcairo.}
  proc font_face_create_for_hfont*(font: HFONT): Font_face {.
      importc: "cairo_win32_font_face_create_for_hfont", libcairo.}
  proc font_face_create_for_logfontw_hfont*(
      logfont: ptr LOGFONTW; font: HFONT): Font_face {.
      importc: "cairo_win32_font_face_create_for_logfontw_hfont", 
      libcairo.}
  proc select_font*(
      scaled_font: Scaled_font; hdc: HDC): Status {.
      importc: "cairo_win32_scaled_font_select_font", libcairo.}
  proc done_font*(
      scaled_font: Scaled_font) {.
      importc: "cairo_win32_scaled_font_done_font", libcairo.}
  proc get_metrics_factor*(
      scaled_font: Scaled_font): cdouble {.
      importc: "cairo_win32_scaled_font_get_metrics_factor", libcairo.}
  proc get_logical_to_device*(
      scaled_font: Scaled_font; 
      logical_to_device: Matrix) {.
      importc: "cairo_win32_scaled_font_get_logical_to_device", libcairo.}
  proc get_device_to_logical*(
      scaled_font: Scaled_font; 
      device_to_logical: Matrix) {.
      importc: "cairo_win32_scaled_font_get_device_to_logical", libcairo.}


