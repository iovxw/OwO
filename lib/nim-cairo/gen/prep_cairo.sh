#!/bin/bash
# S. Salewski, 21-FEB-2015
# Generate Cairo bindings for Nim -- this is for Cairo headers 1.14
#
# TODO: I think set_dash() is wrong
# TODO: Maybe we should define different surface types, i.e. image surface, pdf sorface... 

cairo_dir="/home/stefan/Downloads/cairo-1.14.0/"
final="final.h" # the input file for c2nim

h=`pwd`
cd  $cairo_dir/src
cat cairo.h cairo-pdf.h cairo-ps.h cairo-svg.h cairo-xml.h cairo-script.h cairo-skia.h cairo-drm.h cairo-tee.h cairo-xlib.h cairo-win32.h cairo-gl.h > $h/final.h

cd $h

sed -i "1i#def CAIRO_BEGIN_DECLS" $final
sed -i "1i#def CAIRO_END_DECLS" $final
sed -i "1i#def cairo_public" $final

# delete a few constructs which c2nim does not really like -- guess we will not miss them
i="\
#ifdef  __cplusplus
# define CAIRO_BEGIN_DECLS  extern \"C\" {
# define CAIRO_END_DECLS    }
#else
# define CAIRO_BEGIN_DECLS
# define CAIRO_END_DECLS
#endif

#ifndef cairo_public
# if defined (_MSC_VER) && ! defined (CAIRO_WIN32_STATIC_BUILD)
#  define cairo_public __declspec(dllimport)
# else
#  define cairo_public
# endif
#endif
"
perl -0777 -p -i -e "s/\Q$i\E//s" $final
i="\
#define CAIRO_VERSION CAIRO_VERSION_ENCODE(	\\
	CAIRO_VERSION_MAJOR,			\\
	CAIRO_VERSION_MINOR,			\\
	CAIRO_VERSION_MICRO)
"
perl -0777 -p -i -e "s/\Q$i\E//s" $final
i="\
#define CAIRO_VERSION_STRINGIZE_(major, minor, micro)	\\
	#major\".\"#minor\".\"#micro
#define CAIRO_VERSION_STRINGIZE(major, minor, micro)	\\
	CAIRO_VERSION_STRINGIZE_(major, minor, micro)

#define CAIRO_VERSION_STRING CAIRO_VERSION_STRINGIZE(	\\
	CAIRO_VERSION_MAJOR,				\\
	CAIRO_VERSION_MINOR,				\\
	CAIRO_VERSION_MICRO)
"
perl -0777 -p -i -e "s/\Q$i\E//s" $final

# c2nim wants the {} for structs
sed  -i "s/typedef struct _cairo_surface/typedef struct _cairo_surface {}/g" $final
sed  -i "s/typedef struct _cairo_device/typedef struct _cairo_device {}/g" $final
sed  -i "s/typedef struct _cairo_pattern/typedef struct _cairo_pattern {}/g" $final
sed  -i "s/typedef struct _cairo_scaled_font/typedef struct _cairo_scaled_font {}/g" $final
sed  -i "s/typedef struct _cairo_font_face/typedef struct _cairo_font_face {}/g" $final
sed  -i "s/typedef struct _cairo_font_options/typedef struct _cairo_font_options {}/g" $final
sed  -i "s/typedef struct _cairo_region/typedef struct _cairo_region {}/g" $final
sed  -i "s/typedef struct _cairo cairo_t;/typedef struct _cairo {} cairo_t;/g" $final

ruby fix_.rb $final

i='
#ifdef __INCREASE_TMP_INDENT__
#ifdef C2NIM
#  dynlib lib
#endif
#endif
'
perl -0777 -p -i -e "s/^/$i/" $final

c2nim097 --skipcomments --skipinclude $final

# remove unneeded when statemants
ruby remdef.rb final.nim

sed -i '1d' final.nim
sed -i 's/^  //' final.nim
sed -i 's/^else: $//' final.nim
sed -i '2i\  CAIRO_HAS_PNG_FUNCTIONS = true' final.nim
sed -i '2i\  CAIRO_HAS_PDF_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_PS_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_SVG_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_XML_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_SCRIPT_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_SKIA_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_DRM_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_TEE_SURFACE = true' final.nim
sed -i '2iconst ' final.nim

i='type 
  cairo_bool_t* = cint
'
j='type
  cairo_bool_t* = distinct cint

# we should not need these constants often, because we have converters to and from Nim bool
const
  CAIRO_FALSE* = cairo_bool_t(0)
  CAIRO_TRUE* = cairo_bool_t(1)

converter cbool*(nimbool: bool):cairo_bool_t =
  ord(nimbool).cairo_bool_t

converter toBool*(cbool: cairo_bool_t): bool =
  int(cbool) != 0

'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

# replace the cairo_t with cairo_context_t -- so finally we will get a plain Context
i=`grep -i -c cairo_context_t final.nim` 
if [ $i != 0 ]; then echo 'Error: file contains symbol context_t already!'; exit; fi;

# fix types, enums and long proc names
ruby cairo_fix_proc.rb final.nim
sed  -i "s/\bcairo_t\b/cairo_context_t/g" final.nim # caution -- execute after cairo_fix_proc.rb
ruby fix_template.rb final.nim
ruby cairo_fix_T.rb final.nim cairo
ruby cairo_fix_enum_prefix.rb final.nim

# generate procs without get_ and set_ prefix
perl -0777 -p -i -e "s/(\n\s*)(proc set_)(\w+)(\*\([^}]*\) {[^}]*})/\$&\1proc \`\3=\`\4/sg" final.nim
perl -0777 -p -i -e "s/(\n\s*)(proc get_)(\w+)(\*\([^}]*\): \w[^}]*})/\$&\1proc \3\4/sg" final.nim

sed -i 's/\bproc type\b/proc `type`/g' final.nim

# xor is an operatur in nim
sed  -i "s/proc xor\*(dst: Region; other: Region): Status/proc xor_op*(dst: Region; other: Region): Status/g" final.nim

# enums starting with a digit
sed  -i "s/^      1_4, 1_5/      V1_4, V1_5/g" final.nim
sed  -i "s/^      1_1, 1_2/      V1_1, V1_2/g" final.nim
sed  -i "s/unused\*: cint/unused: cint/g" final.nim
i="\
    Ps_level* {.size: sizeof(cint), pure.} = enum 
      2, 3
"
j="\
    Ps_level* {.size: sizeof(cint), pure.} = enum 
      L2, L3
"
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

#sed  -i "s/\bptr cdouble\b/var cdouble/g" final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cint)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cint)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cuint)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim

sed -i 's/: ptr var /: var ptr /g' final.nim
sed -i 's/\(0x\)0*\([0123456789ABCDEF]\)/\1\2/g' final.nim

# rename some procs explicitely
sed  -i "s/^proc cairo_create\b/proc create/g" final.nim
sed  -i "s/^proc cairo_glyph_allocate\b/proc glyph_allocate/g" final.nim
sed  -i "s/^proc cairo_text_cluster_allocate\b/proc text_cluster_allocate/g" final.nim
sed  -i "s/^proc cairo_font_options_create\b/proc font_options_create/g" final.nim
sed  -i "s/^proc cairo_scaled_font_create\b/proc scaled_font_create/g" final.nim
sed  -i "s/^proc cairo_toy_font_face_/proc toy_font_face_/g" final.nim
sed  -i "s/^proc cairo_user_font_face_/proc user_font_face_/g" final.nim
sed  -i "s/^proc cairo_status_to_string\b/proc cairo_status_to_string/g" final.nim
sed  -i "s/^proc cairo_image_surface_/proc image_surface_/g" final.nim
sed  -i "s/^proc cairo_recording_surface_/proc recording_surface_/g" final.nim
sed  -i "s/^proc cairo_raster_source_pattern_/proc raster_source_pattern_/g" final.nim
sed  -i "s/^proc cairo_pattern_create_/proc pattern_create_/g" final.nim
sed  -i "s/^proc cairo_mesh_pattern_/proc mesh_pattern_/g" final.nim
sed  -i "s/^proc cairo_region_create_/proc region_create_/g" final.nim
sed  -i "s/^proc cairo_debug_reset_static_data\b/proc debug_reset_static_data/g" final.nim
sed  -i "s/^  proc cairo_pdf_/  proc pdf_/g" final.nim
sed  -i "s/^  proc cairo_ps_/  proc ps_/g" final.nim
sed  -i "s/^  proc cairo_svg_/  proc svg_/g" final.nim
sed  -i "s/^  proc cairo_xml_/  proc xml_/g" final.nim
sed  -i "s/^  proc cairo_skia_/  proc skia_/g" final.nim
sed  -i "s/^  proc cairo_script_/  proc script_/g" final.nim
sed  -i "s/^  proc cairo_drm_/  proc drm_/g" final.nim
sed  -i "s/^  proc cairo_tee_surface_/  proc tee_surface_/g" final.nim
sed  -i "s/^proc cairo_status_to_string\b/proc status_to_string/g" final.nim
sed  -i "s/^proc cairo_format_stride_for_width\b/proc format_stride_for_width/g" final.nim
sed  -i "s/^  proc cairo_image_surface_create_from_png\b/  proc image_surface_create_from_png/g" final.nim
sed  -i "s/^  proc cairo_image_surface_create_from_png_stream\b/  proc image_surface_create_from_png_stream/g" final.nim
sed  -i "s/^proc cairo_region_create\b/proc region_create/g" final.nim

# we use our own defined pragma
sed  -i "s/\bdynlib: lib\b/libcairo/g" final.nim

sed  -i "s/\bCAIRO_MIME_TYPE_/MIME_TYPE_/g" final.nim
sed  -i "s/\bFLAG_BACKWARD = 0x1/BACKWARD = 0x1/g" final.nim

perl -0777 -p -i -e "s~([=:] proc \(.*?\)(?:: \w+)?)~\1 {.cdecl.}~sg" final.nim
sed -i 's/\([,=(<>] \{0,1\}\)[(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/\1\2/g' final.nim

i='proc paint_with_alpha*(cr: Context; alpha: cdouble) {.
    importc: "cairo_paint_with_alpha", libcairo.}
'
j='proc paint*(cr: Context; alpha: cdouble) {.
    importc: "cairo_paint_with_alpha", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$i$j/s" final.nim

# some procs with get_ prefix do not return something but need var objects instead of pointers:
# vim search term for candidates: proc get_.*\n\?.*\n\?.*) {
i='proc get_font_matrix*(cr: Context; matrix: Matrix) {.
    importc: "cairo_get_font_matrix", libcairo.}
'
j='proc get_font_matrix*(cr: Context; matrix: var MatrixObj) {.
    importc: "cairo_get_font_matrix", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc get_font_matrix*(scaled_font: Scaled_font; 
    font_matrix: Matrix) {.
    importc: "cairo_scaled_font_get_font_matrix", libcairo.}
'
j='proc get_font_matrix*(scaled_font: Scaled_font; 
    font_matrix: var MatrixObj) {.
    importc: "cairo_scaled_font_get_font_matrix", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc get_ctm*(scaled_font: Scaled_font; 
                                ctm: Matrix) {.
    importc: "cairo_scaled_font_get_ctm", libcairo.}
'
j='proc get_ctm*(scaled_font: Scaled_font; 
                                ctm: var MatrixObj) {.
    importc: "cairo_scaled_font_get_ctm", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc get_scale_matrix*(scaled_font: Scaled_font; 
    scale_matrix: Matrix) {.
    importc: "cairo_scaled_font_get_scale_matrix", libcairo.}
'
j='proc get_scale_matrix*(scaled_font: Scaled_font; 
    scale_matrix: var MatrixObj) {.
    importc: "cairo_scaled_font_get_scale_matrix", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc get_matrix*(cr: Context; matrix: Matrix) {.
    importc: "cairo_get_matrix", libcairo.}
'
j='proc get_matrix*(cr: Context; matrix: var MatrixObj) {.
    importc: "cairo_get_matrix", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc get_matrix*(pattern: Pattern; 
                               matrix: Matrix) {.
    importc: "cairo_pattern_get_matrix", libcairo.}
'
j='proc get_matrix*(pattern: Pattern; 
                               matrix: var MatrixObj) {.
    importc: "cairo_pattern_get_matrix", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc get_extents*(region: Region; 
                               extents: Rectangle_int) {.
    importc: "cairo_region_get_extents", libcairo.}
'
j='proc get_extents*(region: Region; 
                               extents: var Rectangle_intObj) {.
    importc: "cairo_region_get_extents", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc get_rectangle*(region: Region; nth: cint; 
                                 rectangle: Rectangle_int) {.
    importc: "cairo_region_get_rectangle", libcairo.}
'
j='proc get_rectangle*(region: Region; nth: cint; 
                                 rectangle: var Rectangle_intObj) {.
    importc: "cairo_region_get_rectangle", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

# allow MatrixObj as IN parameter
i='type 
  Pattern* =  ptr PatternObj
'
j='converter matrixobj2matrix(m: var MatrixObj): Matrix =
  addr(m)
'
perl -0777 -p -i -e "s/\Q$i\E/$j$i/s" final.nim

ruby gen_proc_dep.rb final.nim

# now separare the xlib, win32 and open gl submodules
csplit final.nim '/when CAIRO_HAS_GL_SURFACE or CAIRO_HAS_GLESV2_SURFACE: /'
mv xx00 final.nim
mv xx01 cairo_gl.nim
sed -i "1d" cairo_gl.nim
sed -i 's/^  //' cairo_gl.nim
sed -i '1iinclude "cairo_pragma.nim"' cairo_gl.nim
sed -i "1iimport cairo" cairo_gl.nim
sed -i "2i# from opengl import" cairo_gl.nim
sed -i '4iconst' cairo_gl.nim
sed -i '5i\  CAIRO_HAS_GLX_FUNCTIONS = false' cairo_gl.nim
sed -i '6i\  CAIRO_HAS_WGL_FUNCTIONS = false' cairo_gl.nim
sed -i '7i\  CAIRO_HAS_EGL_FUNCTIONS = false' cairo_gl.nim
sed  -i "s/proc cairo_/proc /g" cairo_gl.nim

csplit final.nim '/when CAIRO_HAS_WIN32_SURFACE: /'
mv xx00 final.nim
mv xx01 cairo_win32.nim
sed -i "1d" cairo_win32.nim
sed -i 's/^  //' cairo_win32.nim
sed -i '1iinclude "cairo_pragma.nim"' cairo_win32.nim
sed -i "1iimport cairo" cairo_win32.nim
sed -i "2ifrom windows import HDC, LOGFONTW, HFONT" cairo_win32.nim
sed -i '3iconst CAIRO_HAS_WIN32_FONT = true' cairo_win32.nim
sed  -i "s/proc cairo_win32_scaled_font_/proc /g" cairo_win32.nim
sed  -i "s/proc cairo_win32_surface_/proc /g" cairo_win32.nim
sed  -i "s/proc cairo_win32_/proc /g" cairo_win32.nim

csplit final.nim '/when CAIRO_HAS_XLIB_SURFACE: /'
mv xx00 final.nim
mv xx01 cairo_xlib.nim
sed -i "1d" cairo_xlib.nim
sed -i 's/^  //' cairo_xlib.nim
sed -i '1iinclude "cairo_pragma.nim"' cairo_xlib.nim
sed -i "1iimport cairo" cairo_xlib.nim
sed -i "2ifrom x import TDrawable, TPixmap" cairo_xlib.nim
sed -i "3ifrom xlib import PDisplay, PScreen, PVisual" cairo_xlib.nim
sed  -i "s/proc cairo_xlib_surface_/proc /g" cairo_xlib.nim
sed  -i "s/proc cairo_xlib_device_/proc /g" cairo_xlib.nim
sed  -i "s/proc cairo_xlib_/proc /g" cairo_xlib.nim
# legacy 0.9.6 xlib symbols
sed -i 's/\bptr Display\b/PDisplay/' cairo_xlib.nim
sed -i 's/\bDrawable\b/TDrawable/' cairo_xlib.nim
sed -i 's/\bptr Visual\b/PVisual/' cairo_xlib.nim
sed -i 's/\bPixmap\b/TPixmap/' cairo_xlib.nim
sed -i 's/\bptr Screen\b/PScreen/' cairo_xlib.nim

cat -s final.nim > cairo.nim
cat proc_dep_list >> cairo.nim
sed -i '2iinclude "cairo_pragma.nim"' cairo.nim
sed -i '1is/\\bcairo_t\\b/cairo_context_t/g' cairo_sedlist
sed -i '1is/\\bcairo_font_type_t\\b/cairo\.Font_type/g' cairo_sedlist
rm final.h
rm final.nim
rm proc_dep_list

