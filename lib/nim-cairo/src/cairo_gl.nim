import cairo
# from opengl import
include "cairo_pragma.nim"
const
  CAIRO_HAS_GLX_FUNCTIONS = false
  CAIRO_HAS_WGL_FUNCTIONS = false
  CAIRO_HAS_EGL_FUNCTIONS = false
proc gl_surface_create*(device: Device; 
                              content: Content; width: cint; 
                              height: cint): Surface {.
    importc: "cairo_gl_surface_create", libcairo.}
proc gl_surface_create_for_texture*(
    abstract_device: Device; content: Content; 
    tex: cuint; width: cint; height: cint): Surface {.
    importc: "cairo_gl_surface_create_for_texture", libcairo.}
proc gl_surface_set_size*(surface: Surface; width: cint; 
                                height: cint) {.
    importc: "cairo_gl_surface_set_size", libcairo.}
proc gl_surface_get_width*(abstract_surface: Surface): cint {.
    importc: "cairo_gl_surface_get_width", libcairo.}
proc gl_surface_get_height*(abstract_surface: Surface): cint {.
    importc: "cairo_gl_surface_get_height", libcairo.}
proc gl_surface_swapbuffers*(surface: Surface) {.
    importc: "cairo_gl_surface_swapbuffers", libcairo.}
proc gl_device_set_thread_aware*(device: Device; 
    thread_aware: cairo_bool_t) {.importc: "cairo_gl_device_set_thread_aware", 
                                  libcairo.}
when CAIRO_HAS_GLX_FUNCTIONS: 
  proc glx_device_create*(dpy: ptr Display; gl_ctx: GLXContext): Device {.
      importc: "cairo_glx_device_create", libcairo.}
  proc glx_device_get_display*(device: Device): ptr Display {.
      importc: "cairo_glx_device_get_display", libcairo.}
  proc glx_device_get_context*(device: Device): GLXContext {.
      importc: "cairo_glx_device_get_context", libcairo.}
  proc gl_surface_create_for_window*(device: Device; 
      win: Window; width: cint; height: cint): Surface {.
      importc: "cairo_gl_surface_create_for_window", libcairo.}
when CAIRO_HAS_WGL_FUNCTIONS: 
  proc wgl_device_create*(rc: HGLRC): Device {.
      importc: "cairo_wgl_device_create", libcairo.}
  proc wgl_device_get_context*(device: Device): HGLRC {.
      importc: "cairo_wgl_device_get_context", libcairo.}
  proc gl_surface_create_for_dc*(device: Device; dc: HDC; 
      width: cint; height: cint): Surface {.
      importc: "cairo_gl_surface_create_for_dc", libcairo.}
when CAIRO_HAS_EGL_FUNCTIONS: 
  proc egl_device_create*(dpy: EGLDisplay; egl: EGLContext): Device {.
      importc: "cairo_egl_device_create", libcairo.}
  proc gl_surface_create_for_egl*(device: Device; 
      egl: EGLSurface; width: cint; height: cint): Surface {.
      importc: "cairo_gl_surface_create_for_egl", libcairo.}
  proc egl_device_get_display*(device: Device): EGLDisplay {.
      importc: "cairo_egl_device_get_display", libcairo.}
  proc egl_device_get_context*(device: Device): EGLSurface {.
      importc: "cairo_egl_device_get_context", libcairo.}

