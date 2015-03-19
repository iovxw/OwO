{.deadCodeElim: on.}

from glib import gpointer, guchar, gboolean, GQuark, guint8, guint, gint, gsize, guint32, gfloat
from gobject import GObject, GType, GObjectObj, GObjectClassObj
from gio import GInputStream, GOutputStream, GCancellable, GAsyncResult, GAsyncReadyCallback

when defined(windows):
  const LIB_PIXBUF = "libgdk_pixbuf-2.0-0.dll"
elif defined(macosx):
  const LIB_PIXBUF = "libgdk_pixbuf-2.0.0.dylib"
else: 
  const LIB_PIXBUF = "libgdk_pixbuf-2.0.so"

{.pragma: libpixbuf, cdecl, dynlib: LIB_PIXBUF.}

const
  DISABLE_DEPRECATED* = false
  ENABLE_BACKEND* = true

type
  GModule = object # dummy object -- GIO module is still missing...

type 
  AlphaMode* {.size: sizeof(cint), pure.} = enum 
    BILEVEL, FULL
type 
  GdkColorspace* {.size: sizeof(cint), pure.} = enum 
    RGB
type 
  GdkPixbuf* =  ptr GdkPixbufObj
  GdkPixbufPtr* = ptr GdkPixbufObj
  GdkPixbufObj* = object 
  
template gdk_pixbuf*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, get_type(), GdkPixbufObj))

template gdk_is_pixbuf*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, get_type()))

type 
  DestroyNotify* = proc (pixels: ptr guchar; data: gpointer) {.cdecl.}
type 
  Error* {.size: sizeof(cint), pure.} = enum 
    CORRUPT_IMAGE, INSUFFICIENT_MEMORY, 
    BAD_OPTION, UNKNOWN_TYPE, 
    UNSUPPORTED_OPERATION, FAILED
proc error_quark*(): GQuark {.importc: "gdk_pixbuf_error_quark", 
    libpixbuf.}
proc get_type*(): GType {.importc: "gdk_pixbuf_get_type", 
                                     libpixbuf.}
when not DISABLE_DEPRECATED: 
  proc `ref`*(pixbuf: GdkPixbuf): GdkPixbuf {.
      importc: "gdk_pixbuf_ref", libpixbuf.}
  proc unref*(pixbuf: GdkPixbuf) {.importc: "gdk_pixbuf_unref", 
      libpixbuf.}
proc get_colorspace*(pixbuf: GdkPixbuf): GdkColorspace {.
    importc: "gdk_pixbuf_get_colorspace", libpixbuf.}
proc colorspace*(pixbuf: GdkPixbuf): GdkColorspace {.
    importc: "gdk_pixbuf_get_colorspace", libpixbuf.}
proc get_n_channels*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_n_channels", libpixbuf.}
proc n_channels*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_n_channels", libpixbuf.}
proc get_has_alpha*(pixbuf: GdkPixbuf): gboolean {.
    importc: "gdk_pixbuf_get_has_alpha", libpixbuf.}
proc has_alpha*(pixbuf: GdkPixbuf): gboolean {.
    importc: "gdk_pixbuf_get_has_alpha", libpixbuf.}
proc get_bits_per_sample*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_bits_per_sample", libpixbuf.}
proc bits_per_sample*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_bits_per_sample", libpixbuf.}
proc get_pixels*(pixbuf: GdkPixbuf): ptr guchar {.
    importc: "gdk_pixbuf_get_pixels", libpixbuf.}
proc pixels*(pixbuf: GdkPixbuf): ptr guchar {.
    importc: "gdk_pixbuf_get_pixels", libpixbuf.}
proc get_width*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_width", libpixbuf.}
proc width*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_width", libpixbuf.}
proc get_height*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_height", libpixbuf.}
proc height*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_height", libpixbuf.}
proc get_rowstride*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_rowstride", libpixbuf.}
proc rowstride*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_rowstride", libpixbuf.}
proc get_byte_length*(pixbuf: GdkPixbuf): gsize {.
    importc: "gdk_pixbuf_get_byte_length", libpixbuf.}
proc byte_length*(pixbuf: GdkPixbuf): gsize {.
    importc: "gdk_pixbuf_get_byte_length", libpixbuf.}
proc get_pixels_with_length*(pixbuf: GdkPixbuf; 
    length: ptr guint): ptr guchar {.importc: "gdk_pixbuf_get_pixels_with_length", 
                                     libpixbuf.}
proc pixels_with_length*(pixbuf: GdkPixbuf; 
    length: ptr guint): ptr guchar {.importc: "gdk_pixbuf_get_pixels_with_length", 
                                     libpixbuf.}
proc read_pixels*(pixbuf: GdkPixbuf): ptr guint8 {.
    importc: "gdk_pixbuf_read_pixels", libpixbuf.}
proc read_pixel_bytes*(pixbuf: GdkPixbuf): glib.GBytes {.
    importc: "gdk_pixbuf_read_pixel_bytes", libpixbuf.}
proc new*(colorspace: GdkColorspace; has_alpha: gboolean; 
                     bits_per_sample: cint; width: cint; height: cint): GdkPixbuf {.
    importc: "gdk_pixbuf_new", libpixbuf.}
proc copy*(pixbuf: GdkPixbuf): GdkPixbuf {.
    importc: "gdk_pixbuf_copy", libpixbuf.}
proc new_subpixbuf*(src_pixbuf: GdkPixbuf; src_x: cint; 
                               src_y: cint; width: cint; height: cint): GdkPixbuf {.
    importc: "gdk_pixbuf_new_subpixbuf", libpixbuf.}
when defined(windows): 
  const
    NEW_FROM_FILE_LIBNAME = "gdk_pixbuf_new_from_file_utf8"
    NEW_FROM_FILE_AT_SIZE_LIBNAME = "gdk_pixbuf_new_from_file_at_size_utf8"
    NEW_FROM_FILE_AT_SCALE_LIBNAME = "gdk_pixbuf_new_from_file_at_scale_utf8"
else:
  const
    NEW_FROM_FILE_LIBNAME = "gdk_pixbuf_new_from_file"
    NEW_FROM_FILE_AT_SIZE_LIBNAME = "gdk_pixbuf_new_from_file_at_size"
    NEW_FROM_FILE_AT_SCALE_LIBNAME = "gdk_pixbuf_new_from_file_at_scale"

proc new_from_file*(filename: cstring; error: var glib.GError): GdkPixbuf {.
    importc: NEW_FROM_FILE_LIBNAME, libpixbuf.}
proc new_from_file_at_size*(filename: cstring; width: cint; 
    height: cint; error: var glib.GError): GdkPixbuf {.
    importc: NEW_FROM_FILE_AT_SIZE_LIBNAME, libpixbuf.}
proc new_from_file_at_scale*(filename: cstring; width: cint; 
    height: cint; preserve_aspect_ratio: gboolean; error: var glib.GError): GdkPixbuf {.
    importc: NEW_FROM_FILE_AT_SCALE_LIBNAME, libpixbuf.}

when defined(windows): 
  const
    NEW_FROM_FILE_UTF8* = new_from_file
    NEW_FROM_FILE_AT_SIZE_UTF8* = new_from_file_at_size
    NEW_FROM_FILE_AT_SCALE_UTF8* = new_from_file_at_scale
proc new_from_resource*(resource_path: cstring; 
                                   error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_resource", libpixbuf.}
proc new_from_resource_at_scale*(resource_path: cstring; 
    width: cint; height: cint; preserve_aspect_ratio: gboolean; 
    error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_resource_at_scale", libpixbuf.}
proc new_from_data*(data: ptr guchar; colorspace: GdkColorspace; 
                               has_alpha: gboolean; bits_per_sample: cint; 
                               width: cint; height: cint; rowstride: cint; 
                               destroy_fn: DestroyNotify; 
                               destroy_fn_data: gpointer): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_data", libpixbuf.}
proc new_from_bytes*(data: glib.GBytes; colorspace: GdkColorspace; 
                                has_alpha: gboolean; bits_per_sample: cint; 
                                width: cint; height: cint; rowstride: cint): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_bytes", libpixbuf.}
proc new_from_xpm_data*(data: cstringArray): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_xpm_data", libpixbuf.}
when not DISABLE_DEPRECATED: 
  proc new_from_inline*(data_length: gint; data: ptr guint8; 
                                   copy_pixels: gboolean; 
                                   error: var glib.GError): GdkPixbuf {.
      importc: "gdk_pixbuf_new_from_inline", libpixbuf.}
proc fill*(pixbuf: GdkPixbuf; pixel: guint32) {.
    importc: "gdk_pixbuf_fill", libpixbuf.}
when defined(windows): 
  const 
    SAVE_LIBNAME = "gdk_pixbuf_save_utf8"
    SAVEV_LIBNAME = "gdk_pixbuf_savev_utf8"
else:
  const 
    SAVE_LIBNAME = "gdk_pixbuf_save"
    SAVEV_LIBNAME = "gdk_pixbuf_savev"

proc save*(pixbuf: GdkPixbuf; filename: cstring; `type`: cstring; 
                      error: var glib.GError): gboolean {.varargs, 
    importc: SAVE_LIBNAME, libpixbuf.}
proc savev*(pixbuf: GdkPixbuf; filename: cstring; 
                       `type`: cstring; option_keys: cstringArray; 
                       option_values: cstringArray; error: var glib.GError): gboolean {.
    importc:  SAVEV_LIBNAME, libpixbuf.}

when defined(windows): 
  const 
    SAVE_UTF8* = save
    SAVEV_UTF8* = savev
type 
  SaveFunc* = proc (buf: cstring; count: gsize; 
                             error: var glib.GError; data: gpointer): gboolean {.cdecl.}
proc save_to_callback*(pixbuf: GdkPixbuf; 
                                  save_func: SaveFunc; 
                                  user_data: gpointer; `type`: cstring; 
                                  error: var glib.GError): gboolean {.varargs, 
    importc: "gdk_pixbuf_save_to_callback", libpixbuf.}
proc save_to_callbackv*(pixbuf: GdkPixbuf; 
                                   save_func: SaveFunc; 
                                   user_data: gpointer; `type`: cstring; 
                                   option_keys: cstringArray; 
                                   option_values: cstringArray; 
                                   error: var glib.GError): gboolean {.
    importc: "gdk_pixbuf_save_to_callbackv", libpixbuf.}
proc save_to_buffer*(pixbuf: GdkPixbuf; buffer: cstringArray; 
                                buffer_size: var gsize; `type`: cstring; 
                                error: var glib.GError): gboolean {.varargs, 
    importc: "gdk_pixbuf_save_to_buffer", libpixbuf.}
proc save_to_bufferv*(pixbuf: GdkPixbuf; buffer: cstringArray; 
                                 buffer_size: var gsize; `type`: cstring; 
                                 option_keys: cstringArray; 
                                 option_values: cstringArray; 
                                 error: var glib.GError): gboolean {.
    importc: "gdk_pixbuf_save_to_bufferv", libpixbuf.}
proc new_from_stream*(stream: gio.GInputStream; 
                                 cancellable: gio.GCancellable; 
                                 error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_stream", libpixbuf.}
proc new_from_stream_async*(stream: gio.GInputStream; 
    cancellable: gio.GCancellable; callback: GAsyncReadyCallback; 
    user_data: gpointer) {.importc: "gdk_pixbuf_new_from_stream_async", 
                           libpixbuf.}
proc new_from_stream_finish*(async_result: gio.GAsyncResult; 
    error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_stream_finish", libpixbuf.}
proc new_from_stream_at_scale*(stream: gio.GInputStream; 
    width: gint; height: gint; preserve_aspect_ratio: gboolean; 
    cancellable: gio.GCancellable; error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_stream_at_scale", libpixbuf.}
proc new_from_stream_at_scale_async*(stream: gio.GInputStream; 
    width: gint; height: gint; preserve_aspect_ratio: gboolean; 
    cancellable: gio.GCancellable; callback: GAsyncReadyCallback; 
    user_data: gpointer) {.importc: "gdk_pixbuf_new_from_stream_at_scale_async", 
                           libpixbuf.}
proc save_to_stream*(pixbuf: GdkPixbuf; 
                                stream: gio.GOutputStream; `type`: cstring; 
                                cancellable: gio.GCancellable; 
                                error: var glib.GError): gboolean {.varargs, 
    importc: "gdk_pixbuf_save_to_stream", libpixbuf.}
proc save_to_stream_async*(pixbuf: GdkPixbuf; 
                                      stream: gio.GOutputStream; 
                                      `type`: cstring; 
                                      cancellable: gio.GCancellable; 
                                      callback: GAsyncReadyCallback; 
                                      user_data: gpointer) {.varargs, 
    importc: "gdk_pixbuf_save_to_stream_async", libpixbuf.}
proc save_to_stream_finish*(async_result: gio.GAsyncResult; 
    error: var glib.GError): gboolean {.
    importc: "gdk_pixbuf_save_to_stream_finish", libpixbuf.}
proc add_alpha*(pixbuf: GdkPixbuf; substitute_color: gboolean; 
                           r: guchar; g: guchar; b: guchar): GdkPixbuf {.
    importc: "gdk_pixbuf_add_alpha", libpixbuf.}
proc copy_area*(src_pixbuf: GdkPixbuf; src_x: cint; 
                           src_y: cint; width: cint; height: cint; 
                           dest_pixbuf: GdkPixbuf; dest_x: cint; 
                           dest_y: cint) {.importc: "gdk_pixbuf_copy_area", 
    libpixbuf.}
proc saturate_and_pixelate*(src: GdkPixbuf; 
    dest: GdkPixbuf; saturation: gfloat; pixelate: gboolean) {.
    importc: "gdk_pixbuf_saturate_and_pixelate", libpixbuf.}
proc apply_embedded_orientation*(src: GdkPixbuf): GdkPixbuf {.
    importc: "gdk_pixbuf_apply_embedded_orientation", libpixbuf.}
proc get_option*(pixbuf: GdkPixbuf; key: cstring): cstring {.
    importc: "gdk_pixbuf_get_option", libpixbuf.}
proc option*(pixbuf: GdkPixbuf; key: cstring): cstring {.
    importc: "gdk_pixbuf_get_option", libpixbuf.}
proc get_options*(pixbuf: GdkPixbuf): glib.GHashTable {.
    importc: "gdk_pixbuf_get_options", libpixbuf.}
proc options*(pixbuf: GdkPixbuf): glib.GHashTable {.
    importc: "gdk_pixbuf_get_options", libpixbuf.}

type 
  GdkInterpType* {.size: sizeof(cint), pure.} = enum 
    NEAREST, TILES, BILINEAR, 
    HYPER
type 
  Rotation* {.size: sizeof(cint), pure.} = enum 
    ROTATE_NONE = 0, ROTATE_COUNTERCLOCKWISE = 90, 
    ROTATE_UPSIDEDOWN = 180, ROTATE_CLOCKWISE = 270
proc scale*(src: GdkPixbuf; dest: GdkPixbuf; dest_x: cint; 
                       dest_y: cint; dest_width: cint; dest_height: cint; 
                       offset_x: cdouble; offset_y: cdouble; scale_x: cdouble; 
                       scale_y: cdouble; interp_type: GdkInterpType) {.
    importc: "gdk_pixbuf_scale", libpixbuf.}
proc composite*(src: GdkPixbuf; dest: GdkPixbuf; 
                           dest_x: cint; dest_y: cint; dest_width: cint; 
                           dest_height: cint; offset_x: cdouble; 
                           offset_y: cdouble; scale_x: cdouble; 
                           scale_y: cdouble; interp_type: GdkInterpType; 
                           overall_alpha: cint) {.
    importc: "gdk_pixbuf_composite", libpixbuf.}
proc composite_color*(src: GdkPixbuf; dest: GdkPixbuf; 
                                 dest_x: cint; dest_y: cint; dest_width: cint; 
                                 dest_height: cint; offset_x: cdouble; 
                                 offset_y: cdouble; scale_x: cdouble; 
                                 scale_y: cdouble; interp_type: GdkInterpType; 
                                 overall_alpha: cint; check_x: cint; 
                                 check_y: cint; check_size: cint; 
                                 color1: guint32; color2: guint32) {.
    importc: "gdk_pixbuf_composite_color", libpixbuf.}
proc scale_simple*(src: GdkPixbuf; dest_width: cint; 
                              dest_height: cint; interp_type: GdkInterpType): GdkPixbuf {.
    importc: "gdk_pixbuf_scale_simple", libpixbuf.}
proc composite_color_simple*(src: GdkPixbuf; dest_width: cint; 
    dest_height: cint; interp_type: GdkInterpType; overall_alpha: cint; 
    check_size: cint; color1: guint32; color2: guint32): GdkPixbuf {.
    importc: "gdk_pixbuf_composite_color_simple", libpixbuf.}
proc rotate_simple*(src: GdkPixbuf; angle: Rotation): GdkPixbuf {.
    importc: "gdk_pixbuf_rotate_simple", libpixbuf.}
proc flip*(src: GdkPixbuf; horizontal: gboolean): GdkPixbuf {.
    importc: "gdk_pixbuf_flip", libpixbuf.}

when ENABLE_BACKEND: 
  type 
    Animation* =  ptr AnimationObj
    AnimationPtr* = ptr AnimationObj
    AnimationObj*{.final.} = object of GObjectObj
  type 
    AnimationIter* =  ptr AnimationIterObj
    AnimationIterPtr* = ptr AnimationIterObj
    AnimationIterObj*{.final.} = object of GObjectObj
else:
  type 
    Animation* =  ptr AnimationObj
    AnimationPtr* = ptr AnimationObj
    AnimationObj* = object 
  type 
    AnimationIter* =  ptr AnimationIterObj
    AnimationIterPtr* = ptr AnimationIterObj
    AnimationIterObj* = object 
template gdk_pixbuf_animation*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, animation_get_type(), 
                              AnimationObj))

template gdk_is_pixbuf_animation*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, animation_get_type()))

template gdk_pixbuf_animation_iter*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, animation_iter_get_type(), 
                              AnimationIterObj))

template gdk_is_pixbuf_animation_iter*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, animation_iter_get_type()))

proc animation_get_type*(): GType {.
    importc: "gdk_pixbuf_animation_get_type", libpixbuf.}
when defined(windows): 
  proc animation_new_from_file*(filename: cstring; 
      error: var glib.GError): Animation {.
      importc: "gdk_pixbuf_animation_new_from_file_utf8", libpixbuf.}
  const 
    ANIMATION_NEW_FROM_FILE_UTF8* = animation_new_from_file
else:
  proc animation_new_from_file*(filename: cstring; 
      error: var glib.GError): Animation {.
      importc: "gdk_pixbuf_animation_new_from_file", libpixbuf.}
proc animation_new_from_stream*(stream: gio.GInputStream; 
    cancellable: gio.GCancellable; error: var glib.GError): Animation {.
    importc: "gdk_pixbuf_animation_new_from_stream", libpixbuf.}
proc animation_new_from_stream_async*(stream: gio.GInputStream; 
    cancellable: gio.GCancellable; callback: GAsyncReadyCallback; 
    user_data: gpointer) {.importc: "gdk_pixbuf_animation_new_from_stream_async", 
                           libpixbuf.}
proc animation_new_from_stream_finish*(
    async_result: gio.GAsyncResult; error: var glib.GError): Animation {.
    importc: "gdk_pixbuf_animation_new_from_stream_finish", libpixbuf.}
proc animation_new_from_resource*(resource_path: cstring; 
    error: var glib.GError): Animation {.
    importc: "gdk_pixbuf_animation_new_from_resource", libpixbuf.}
when not DISABLE_DEPRECATED: 
  proc `ref`*(animation: Animation): Animation {.
      importc: "gdk_pixbuf_animation_ref", libpixbuf.}
  proc unref*(animation: Animation) {.
      importc: "gdk_pixbuf_animation_unref", libpixbuf.}
proc get_width*(animation: Animation): cint {.
    importc: "gdk_pixbuf_animation_get_width", libpixbuf.}
proc width*(animation: Animation): cint {.
    importc: "gdk_pixbuf_animation_get_width", libpixbuf.}
proc get_height*(animation: Animation): cint {.
    importc: "gdk_pixbuf_animation_get_height", libpixbuf.}
proc height*(animation: Animation): cint {.
    importc: "gdk_pixbuf_animation_get_height", libpixbuf.}
proc is_static_image*(animation: Animation): gboolean {.
    importc: "gdk_pixbuf_animation_is_static_image", libpixbuf.}
proc get_static_image*(animation: Animation): GdkPixbuf {.
    importc: "gdk_pixbuf_animation_get_static_image", libpixbuf.}
proc static_image*(animation: Animation): GdkPixbuf {.
    importc: "gdk_pixbuf_animation_get_static_image", libpixbuf.}
proc get_iter*(animation: Animation; 
                                    start_time: glib.GTimeVal): AnimationIter {.
    importc: "gdk_pixbuf_animation_get_iter", libpixbuf.}
proc iter*(animation: Animation; 
                                    start_time: glib.GTimeVal): AnimationIter {.
    importc: "gdk_pixbuf_animation_get_iter", libpixbuf.}
proc animation_iter_get_type*(): GType {.
    importc: "gdk_pixbuf_animation_iter_get_type", libpixbuf.}
proc get_delay_time*(
    iter: AnimationIter): cint {.
    importc: "gdk_pixbuf_animation_iter_get_delay_time", libpixbuf.}
proc delay_time*(
    iter: AnimationIter): cint {.
    importc: "gdk_pixbuf_animation_iter_get_delay_time", libpixbuf.}
proc get_pixbuf*(iter: AnimationIter): GdkPixbuf {.
    importc: "gdk_pixbuf_animation_iter_get_pixbuf", libpixbuf.}
proc pixbuf*(iter: AnimationIter): GdkPixbuf {.
    importc: "gdk_pixbuf_animation_iter_get_pixbuf", libpixbuf.}
proc on_currently_loading_frame*(
    iter: AnimationIter): gboolean {.
    importc: "gdk_pixbuf_animation_iter_on_currently_loading_frame", 
    libpixbuf.}
proc advance*(iter: AnimationIter; 
    current_time: glib.GTimeVal): gboolean {.
    importc: "gdk_pixbuf_animation_iter_advance", libpixbuf.}
when ENABLE_BACKEND: 
  template gdk_pixbuf_animation_class*(klass: expr): expr = 
    (g_type_check_class_cast(klass, animation_get_type(), 
                             AnimationClassObj))

  template gdk_is_pixbuf_animation_class*(klass: expr): expr = 
    (g_type_check_class_type(klass, animation_get_type()))

  template gdk_pixbuf_animation_get_class*(obj: expr): expr = 
    (g_type_instance_get_class(obj, animation_get_type(), 
                               AnimationClassObj))

  type 
    AnimationClass* =  ptr AnimationClassObj
    AnimationClassPtr* = ptr AnimationClassObj
    AnimationClassObj*{.final.} = object of GObjectClassObj
      is_static_image*: proc (anim: Animation): gboolean {.cdecl.}
      get_static_image*: proc (anim: Animation): GdkPixbuf {.cdecl.}
      get_size*: proc (anim: Animation; width: var cint; 
                       height: var cint) {.cdecl.}
      get_iter*: proc (anim: Animation; start_time: glib.GTimeVal): AnimationIter {.cdecl.}

  template gdk_pixbuf_animation_iter_class*(klass: expr): expr = 
    (g_type_check_class_cast(klass, animation_iter_get_type(), 
                             AnimationIterClassObj))

  template gdk_is_pixbuf_animation_iter_class*(klass: expr): expr = 
    (g_type_check_class_type(klass, animation_iter_get_type()))

  template gdk_pixbuf_animation_iter_get_class*(obj: expr): expr = 
    (g_type_instance_get_class(obj, animation_iter_get_type(), 
                               AnimationIterClassObj))

  type 
    AnimationIterClass* =  ptr AnimationIterClassObj
    AnimationIterClassPtr* = ptr AnimationIterClassObj
    AnimationIterClassObj*{.final.} = object of GObjectClassObj
      get_delay_time*: proc (iter: AnimationIter): cint {.cdecl.}
      get_pixbuf*: proc (iter: AnimationIter): GdkPixbuf {.cdecl.}
      on_currently_loading_frame*: proc (iter: AnimationIter): gboolean {.cdecl.}
      advance*: proc (iter: AnimationIter; 
                      current_time: glib.GTimeVal): gboolean {.cdecl.}

  proc non_anim_get_type*(): GType {.
      importc: "gdk_pixbuf_non_anim_get_type", libpixbuf.}
  proc non_anim_new*(pixbuf: GdkPixbuf): Animation {.
      importc: "gdk_pixbuf_non_anim_new", libpixbuf.}

type 
  SimpleAnim* =  ptr SimpleAnimObj
  SimpleAnimPtr* = ptr SimpleAnimObj
  SimpleAnimObj* = object 
  
template gdk_pixbuf_simple_anim*(`object`: expr): expr = 
  (g_type_check_instance_cast(`object`, simple_anim_get_type(), 
                              SimpleAnimObj))

template gdk_is_pixbuf_simple_anim*(`object`: expr): expr = 
  (g_type_check_instance_type(`object`, simple_anim_get_type()))

template gdk_pixbuf_simple_anim_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, simple_anim_get_type(), 
                           SimpleAnimClass))

template gdk_is_pixbuf_simple_anim_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, simple_anim_get_type()))

template gdk_pixbuf_simple_anim_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, simple_anim_get_type(), 
                             SimpleAnimClass))

proc simple_anim_get_type*(): GType {.
    importc: "gdk_pixbuf_simple_anim_get_type", libpixbuf.}
proc simple_anim_iter_get_type*(): GType {.
    importc: "gdk_pixbuf_simple_anim_iter_get_type", libpixbuf.}
proc simple_anim_new*(width: gint; height: gint; rate: gfloat): SimpleAnim {.
    importc: "gdk_pixbuf_simple_anim_new", libpixbuf.}
proc add_frame*(animation: SimpleAnim; 
    pixbuf: GdkPixbuf) {.importc: "gdk_pixbuf_simple_anim_add_frame", 
                             libpixbuf.}
proc set_loop*(animation: SimpleAnim; 
                                      loop: gboolean) {.
    importc: "gdk_pixbuf_simple_anim_set_loop", libpixbuf.}
proc `loop=`*(animation: SimpleAnim; 
                                      loop: gboolean) {.
    importc: "gdk_pixbuf_simple_anim_set_loop", libpixbuf.}
proc get_loop*(animation: SimpleAnim): gboolean {.
    importc: "gdk_pixbuf_simple_anim_get_loop", libpixbuf.}
proc loop*(animation: SimpleAnim): gboolean {.
    importc: "gdk_pixbuf_simple_anim_get_loop", libpixbuf.}

when ENABLE_BACKEND: 
  type 
    ModuleSizeFunc* = proc (width: var gint; height: var gint; 
                                     user_data: gpointer) {.cdecl.}
  type 
    ModulePreparedFunc* = proc (pixbuf: GdkPixbuf; 
        anim: Animation; user_data: gpointer) {.cdecl.}
  type 
    ModuleUpdatedFunc* = proc (pixbuf: GdkPixbuf; x: cint; 
        y: cint; width: cint; height: cint; user_data: gpointer) {.cdecl.}
  type 
    ModulePattern* =  ptr ModulePatternObj
    ModulePatternPtr* = ptr ModulePatternObj
    ModulePatternObj* = object 
      prefix*: cstring
      mask*: cstring
      relevance*: cint

  type 
    Format* =  ptr FormatObj
    FormatPtr* = ptr FormatObj
    FormatObj* = object 
      name*: cstring
      signature*: ModulePattern
      domain*: cstring
      description*: cstring
      mime_types*: cstringArray
      extensions*: cstringArray
      flags*: guint32
      disabled*: gboolean
      license*: cstring

  type 
    Module* =  ptr ModuleObj
    ModulePtr* = ptr ModuleObj
    ModuleObj* = object 
      module_name*: cstring
      module_path*: cstring
      module*: ptr GModule
      info*: Format
      load*: proc (f: ptr FILE; error: var glib.GError): GdkPixbuf {.cdecl.}
      load_xpm_data*: proc (data: cstringArray): GdkPixbuf {.cdecl.}
      begin_load*: proc (size_func: ModuleSizeFunc; 
                         prepare_func: ModulePreparedFunc; 
                         update_func: ModuleUpdatedFunc; 
                         user_data: gpointer; error: var glib.GError): gpointer {.cdecl.}
      stop_load*: proc (context: gpointer; error: var glib.GError): gboolean {.cdecl.}
      load_increment*: proc (context: gpointer; buf: ptr guchar; size: guint; 
                             error: var glib.GError): gboolean {.cdecl.}
      load_animation*: proc (f: ptr FILE; error: var glib.GError): Animation {.cdecl.}
      save*: proc (f: ptr FILE; pixbuf: GdkPixbuf; 
                   param_keys: cstringArray; param_values: cstringArray; 
                   error: var glib.GError): gboolean {.cdecl.}
      save_to_callback*: proc (save_func: SaveFunc; 
                               user_data: gpointer; pixbuf: GdkPixbuf; 
                               option_keys: cstringArray; 
                               option_values: cstringArray; 
                               error: var glib.GError): gboolean {.cdecl.}
      reserved1: proc () {.cdecl.}
      reserved2: proc () {.cdecl.}
      reserved3: proc () {.cdecl.}
      reserved4: proc () {.cdecl.}
      reserved5: proc () {.cdecl.}

  type 
    ModuleFillVtableFunc* = proc (module: Module) {.cdecl.}
  type 
    ModuleFillInfoFunc* = proc (info: Format) {.cdecl.}
  type 
    FormatFlags* {.size: sizeof(cint), pure.} = enum 
      WRITABLE = 1 shl 0, 
      SCALABLE = 1 shl 1, 
      THREADSAFE = 1 shl 2
  proc set_option*(pixbuf: GdkPixbuf; key: cstring; 
                              value: cstring): gboolean {.
      importc: "gdk_pixbuf_set_option", libpixbuf.}
else:
  type 
    Format* =  ptr FormatObj
    FormatPtr* = ptr FormatObj
    FormatObj* = object 
proc format_get_type*(): GType {.
    importc: "gdk_pixbuf_format_get_type", libpixbuf.}
proc get_formats*(): glib.GSList {.
    importc: "gdk_pixbuf_get_formats", libpixbuf.}
proc get_name*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_name", libpixbuf.}
proc name*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_name", libpixbuf.}
proc get_description*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_description", libpixbuf.}
proc description*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_description", libpixbuf.}
proc get_mime_types*(format: Format): cstringArray {.
    importc: "gdk_pixbuf_format_get_mime_types", libpixbuf.}
proc mime_types*(format: Format): cstringArray {.
    importc: "gdk_pixbuf_format_get_mime_types", libpixbuf.}
proc get_extensions*(format: Format): cstringArray {.
    importc: "gdk_pixbuf_format_get_extensions", libpixbuf.}
proc extensions*(format: Format): cstringArray {.
    importc: "gdk_pixbuf_format_get_extensions", libpixbuf.}
proc is_writable*(format: Format): gboolean {.
    importc: "gdk_pixbuf_format_is_writable", libpixbuf.}
proc is_scalable*(format: Format): gboolean {.
    importc: "gdk_pixbuf_format_is_scalable", libpixbuf.}
proc is_disabled*(format: Format): gboolean {.
    importc: "gdk_pixbuf_format_is_disabled", libpixbuf.}
proc set_disabled*(format: Format; 
                                     disabled: gboolean) {.
    importc: "gdk_pixbuf_format_set_disabled", libpixbuf.}
proc `disabled=`*(format: Format; 
                                     disabled: gboolean) {.
    importc: "gdk_pixbuf_format_set_disabled", libpixbuf.}
proc get_license*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_license", libpixbuf.}
proc license*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_license", libpixbuf.}
proc get_file_info*(filename: cstring; width: var gint; 
                               height: var gint): Format {.
    importc: "gdk_pixbuf_get_file_info", libpixbuf.}
proc get_file_info_async*(filename: cstring; 
                                     cancellable: gio.GCancellable; 
                                     callback: GAsyncReadyCallback; 
                                     user_data: gpointer) {.
    importc: "gdk_pixbuf_get_file_info_async", libpixbuf.}
proc get_file_info_finish*(async_result: gio.GAsyncResult; 
                                      width: var gint; height: var gint; 
                                      error: var glib.GError): Format {.
    importc: "gdk_pixbuf_get_file_info_finish", libpixbuf.}
proc copy*(format: Format): Format {.
    importc: "gdk_pixbuf_format_copy", libpixbuf.}
proc free*(format: Format) {.
    importc: "gdk_pixbuf_format_free", libpixbuf.}

template gdk_pixbuf_loader*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, loader_get_type(), LoaderObj))

template gdk_pixbuf_loader_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, loader_get_type(), 
                           LoaderClassObj))

template gdk_is_pixbuf_loader*(obj: expr): expr = 
  (g_type_check_instance_type(obj, loader_get_type()))

template gdk_is_pixbuf_loader_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, loader_get_type()))

template gdk_pixbuf_loader_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, loader_get_type(), 
                             LoaderClassObj))

type 
  Loader* =  ptr LoaderObj
  LoaderPtr* = ptr LoaderObj
  LoaderObj*{.final.} = object of GObjectObj
    priv*: gpointer

type 
  LoaderClass* =  ptr LoaderClassObj
  LoaderClassPtr* = ptr LoaderClassObj
  LoaderClassObj*{.final.} = object of GObjectClassObj
    size_prepared*: proc (loader: Loader; width: cint; 
                          height: cint) {.cdecl.}
    area_prepared*: proc (loader: Loader) {.cdecl.}
    area_updated*: proc (loader: Loader; x: cint; y: cint; 
                         width: cint; height: cint) {.cdecl.}
    closed*: proc (loader: Loader) {.cdecl.}

proc loader_get_type*(): GType {.
    importc: "gdk_pixbuf_loader_get_type", libpixbuf.}
proc loader_new*(): Loader {.
    importc: "gdk_pixbuf_loader_new", libpixbuf.}
proc loader_new_with_type*(image_type: cstring; 
                                      error: var glib.GError): Loader {.
    importc: "gdk_pixbuf_loader_new_with_type", libpixbuf.}
proc loader_new_with_mime_type*(mime_type: cstring; 
    error: var glib.GError): Loader {.
    importc: "gdk_pixbuf_loader_new_with_mime_type", libpixbuf.}
proc set_size*(loader: Loader; width: cint; 
                                 height: cint) {.
    importc: "gdk_pixbuf_loader_set_size", libpixbuf.}
proc `size=`*(loader: Loader; width: cint; 
                                 height: cint) {.
    importc: "gdk_pixbuf_loader_set_size", libpixbuf.}
proc write*(loader: Loader; buf: ptr guchar; 
                              count: gsize; error: var glib.GError): gboolean {.
    importc: "gdk_pixbuf_loader_write", libpixbuf.}
proc write_bytes*(loader: Loader; 
                                    buffer: glib.GBytes; error: var glib.GError): gboolean {.
    importc: "gdk_pixbuf_loader_write_bytes", libpixbuf.}
proc get_pixbuf*(loader: Loader): GdkPixbuf {.
    importc: "gdk_pixbuf_loader_get_pixbuf", libpixbuf.}
proc pixbuf*(loader: Loader): GdkPixbuf {.
    importc: "gdk_pixbuf_loader_get_pixbuf", libpixbuf.}
proc get_animation*(loader: Loader): Animation {.
    importc: "gdk_pixbuf_loader_get_animation", libpixbuf.}
proc animation*(loader: Loader): Animation {.
    importc: "gdk_pixbuf_loader_get_animation", libpixbuf.}
proc close*(loader: Loader; 
                              error: var glib.GError): gboolean {.
    importc: "gdk_pixbuf_loader_close", libpixbuf.}
proc get_format*(loader: Loader): Format {.
    importc: "gdk_pixbuf_loader_get_format", libpixbuf.}
proc format*(loader: Loader): Format {.
    importc: "gdk_pixbuf_loader_get_format", libpixbuf.}
{.deprecated: [gdk_pixbuf_error_quark: error_quark].}
{.deprecated: [gdk_pixbuf_get_type: get_type].}
{.deprecated: [gdk_pixbuf_ref: `ref`].}
{.deprecated: [gdk_pixbuf_unref: unref].}
{.deprecated: [gdk_pixbuf_get_colorspace: get_colorspace].}
{.deprecated: [gdk_pixbuf_get_n_channels: get_n_channels].}
{.deprecated: [gdk_pixbuf_get_has_alpha: get_has_alpha].}
{.deprecated: [gdk_pixbuf_get_bits_per_sample: get_bits_per_sample].}
{.deprecated: [gdk_pixbuf_get_pixels: get_pixels].}
{.deprecated: [gdk_pixbuf_get_width: get_width].}
{.deprecated: [gdk_pixbuf_get_height: get_height].}
{.deprecated: [gdk_pixbuf_get_rowstride: get_rowstride].}
{.deprecated: [gdk_pixbuf_get_byte_length: get_byte_length].}
{.deprecated: [gdk_pixbuf_get_pixels_with_length: get_pixels_with_length].}
{.deprecated: [gdk_pixbuf_read_pixels: read_pixels].}
{.deprecated: [gdk_pixbuf_read_pixel_bytes: read_pixel_bytes].}
{.deprecated: [gdk_pixbuf_new: new].}
{.deprecated: [gdk_pixbuf_copy: copy].}
{.deprecated: [gdk_pixbuf_new_subpixbuf: new_subpixbuf].}
{.deprecated: [gdk_pixbuf_new_from_resource: new_from_resource].}
{.deprecated: [gdk_pixbuf_new_from_resource_at_scale: new_from_resource_at_scale].}
{.deprecated: [gdk_pixbuf_new_from_data: new_from_data].}
{.deprecated: [gdk_pixbuf_new_from_bytes: new_from_bytes].}
{.deprecated: [gdk_pixbuf_new_from_xpm_data: new_from_xpm_data].}
{.deprecated: [gdk_pixbuf_new_from_inline: new_from_inline].}
{.deprecated: [gdk_pixbuf_fill: fill].}
{.deprecated: [gdk_pixbuf_save_to_callback: save_to_callback].}
{.deprecated: [gdk_pixbuf_save_to_callbackv: save_to_callbackv].}
{.deprecated: [gdk_pixbuf_save_to_buffer: save_to_buffer].}
{.deprecated: [gdk_pixbuf_save_to_bufferv: save_to_bufferv].}
{.deprecated: [gdk_pixbuf_new_from_stream: new_from_stream].}
{.deprecated: [gdk_pixbuf_new_from_stream_async: new_from_stream_async].}
{.deprecated: [gdk_pixbuf_new_from_stream_finish: new_from_stream_finish].}
{.deprecated: [gdk_pixbuf_new_from_stream_at_scale: new_from_stream_at_scale].}
{.deprecated: [gdk_pixbuf_new_from_stream_at_scale_async: new_from_stream_at_scale_async].}
{.deprecated: [gdk_pixbuf_save_to_stream: save_to_stream].}
{.deprecated: [gdk_pixbuf_save_to_stream_async: save_to_stream_async].}
{.deprecated: [gdk_pixbuf_save_to_stream_finish: save_to_stream_finish].}
{.deprecated: [gdk_pixbuf_add_alpha: add_alpha].}
{.deprecated: [gdk_pixbuf_copy_area: copy_area].}
{.deprecated: [gdk_pixbuf_saturate_and_pixelate: saturate_and_pixelate].}
{.deprecated: [gdk_pixbuf_apply_embedded_orientation: apply_embedded_orientation].}
{.deprecated: [gdk_pixbuf_get_option: get_option].}
{.deprecated: [gdk_pixbuf_get_options: get_options].}
{.deprecated: [gdk_pixbuf_scale: scale].}
{.deprecated: [gdk_pixbuf_composite: composite].}
{.deprecated: [gdk_pixbuf_composite_color: composite_color].}
{.deprecated: [gdk_pixbuf_scale_simple: scale_simple].}
{.deprecated: [gdk_pixbuf_composite_color_simple: composite_color_simple].}
{.deprecated: [gdk_pixbuf_rotate_simple: rotate_simple].}
{.deprecated: [gdk_pixbuf_flip: flip].}
{.deprecated: [gdk_pixbuf_animation_get_type: animation_get_type].}
{.deprecated: [gdk_pixbuf_animation_new_from_file_utf8: animation_new_from_file].}
{.deprecated: [gdk_pixbuf_animation_new_from_file: animation_new_from_file].}
{.deprecated: [gdk_pixbuf_animation_new_from_stream: animation_new_from_stream].}
{.deprecated: [gdk_pixbuf_animation_new_from_stream_async: animation_new_from_stream_async].}
{.deprecated: [gdk_pixbuf_animation_new_from_stream_finish: animation_new_from_stream_finish].}
{.deprecated: [gdk_pixbuf_animation_new_from_resource: animation_new_from_resource].}
{.deprecated: [gdk_pixbuf_animation_ref: `ref`].}
{.deprecated: [gdk_pixbuf_animation_unref: unref].}
{.deprecated: [gdk_pixbuf_animation_get_width: get_width].}
{.deprecated: [gdk_pixbuf_animation_get_height: get_height].}
{.deprecated: [gdk_pixbuf_animation_is_static_image: is_static_image].}
{.deprecated: [gdk_pixbuf_animation_get_static_image: get_static_image].}
{.deprecated: [gdk_pixbuf_animation_get_iter: get_iter].}
{.deprecated: [gdk_pixbuf_animation_iter_get_type: animation_iter_get_type].}
{.deprecated: [gdk_pixbuf_animation_iter_get_delay_time: get_delay_time].}
{.deprecated: [gdk_pixbuf_animation_iter_get_pixbuf: get_pixbuf].}
{.deprecated: [gdk_pixbuf_animation_iter_on_currently_loading_frame: on_currently_loading_frame].}
{.deprecated: [gdk_pixbuf_animation_iter_advance: advance].}
{.deprecated: [gdk_pixbuf_non_anim_get_type: non_anim_get_type].}
{.deprecated: [gdk_pixbuf_non_anim_new: non_anim_new].}
{.deprecated: [gdk_pixbuf_simple_anim_get_type: simple_anim_get_type].}
{.deprecated: [gdk_pixbuf_simple_anim_iter_get_type: simple_anim_iter_get_type].}
{.deprecated: [gdk_pixbuf_simple_anim_new: simple_anim_new].}
{.deprecated: [gdk_pixbuf_simple_anim_add_frame: add_frame].}
{.deprecated: [gdk_pixbuf_simple_anim_set_loop: set_loop].}
{.deprecated: [gdk_pixbuf_simple_anim_get_loop: get_loop].}
{.deprecated: [gdk_pixbuf_set_option: set_option].}
{.deprecated: [gdk_pixbuf_format_get_type: format_get_type].}
{.deprecated: [gdk_pixbuf_get_formats: get_formats].}
{.deprecated: [gdk_pixbuf_format_get_name: get_name].}
{.deprecated: [gdk_pixbuf_format_get_description: get_description].}
{.deprecated: [gdk_pixbuf_format_get_mime_types: get_mime_types].}
{.deprecated: [gdk_pixbuf_format_get_extensions: get_extensions].}
{.deprecated: [gdk_pixbuf_format_is_writable: is_writable].}
{.deprecated: [gdk_pixbuf_format_is_scalable: is_scalable].}
{.deprecated: [gdk_pixbuf_format_is_disabled: is_disabled].}
{.deprecated: [gdk_pixbuf_format_set_disabled: set_disabled].}
{.deprecated: [gdk_pixbuf_format_get_license: get_license].}
{.deprecated: [gdk_pixbuf_get_file_info: get_file_info].}
{.deprecated: [gdk_pixbuf_get_file_info_async: get_file_info_async].}
{.deprecated: [gdk_pixbuf_get_file_info_finish: get_file_info_finish].}
{.deprecated: [gdk_pixbuf_format_copy: copy].}
{.deprecated: [gdk_pixbuf_format_free: free].}
{.deprecated: [gdk_pixbuf_loader_get_type: loader_get_type].}
{.deprecated: [gdk_pixbuf_loader_new: loader_new].}
{.deprecated: [gdk_pixbuf_loader_new_with_type: loader_new_with_type].}
{.deprecated: [gdk_pixbuf_loader_new_with_mime_type: loader_new_with_mime_type].}
{.deprecated: [gdk_pixbuf_loader_set_size: set_size].}
{.deprecated: [gdk_pixbuf_loader_write: write].}
{.deprecated: [gdk_pixbuf_loader_write_bytes: write_bytes].}
{.deprecated: [gdk_pixbuf_loader_get_pixbuf: get_pixbuf].}
{.deprecated: [gdk_pixbuf_loader_get_animation: get_animation].}
{.deprecated: [gdk_pixbuf_loader_close: close].}
{.deprecated: [gdk_pixbuf_loader_get_format: get_format].}
