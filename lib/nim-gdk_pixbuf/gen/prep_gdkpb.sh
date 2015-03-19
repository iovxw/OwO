#!/bin/bash
# S. Salewski, 08-MAR-2015
# generate gdk-pixbuf bindings for Nim -- this is for gdk-pixbuf headers 2.31.2
#
gdkpb_dir="/home/stefan/Downloads/gdk-pixbuf-2.31.2"
final="final.h" # the input file for c2nim
list="list.txt"
wdir="tmp_gdkpb"

targets=''
all_t=". ${targets}"

rm -rf $wdir # start from scratch
mkdir $wdir
cd $wdir
cp -r $gdkpb_dir/gdk-pixbuf .
cd gdk-pixbuf

#echo 'we may miss these headers -- please check:'
#for i in $all_t ; do
#  grep -c DECL ${i}/*.h | grep h:0
#done

# we insert in each header a marker with the filename
# may fail if G_BEGIN_DECLS macro is missing in a header
for j in $all_t ; do
  for i in ${j}/*.h; do
    sed -i "/^G_BEGIN_DECLS/a${i}_ssalewski;" $i
  done
done

cat gdk-pixbuf.h > all.h

cd ..

# cpp run with all headers to determine order
echo "cat \\" > $list

cpp -I. `pkg-config --cflags gtk+-3.0` gdk-pixbuf/all.h $final

# extract file names and push names to list
grep ssalewski $final | sed 's/_ssalewski;/ \\/' >> $list

i=`uniq -d $list | wc -l`
if [ $i != 0 ]; then echo 'list contains duplicates!'; exit; fi;

# now we work again with original headers
rm -rf gdk-pixbuf
cp -r $gdkpb_dir/gdk-pixbuf . 

# insert for each header file its name as first line
for j in $all_t ; do
  for i in gdk-pixbuf/${j}/*.h; do
    sed -i "1i/* file: $i */" $i
    sed -i "1i#define headerfilename \"$i\"" $i # marker for splitting
  done
done
cd gdk-pixbuf
  bash ../$list > ../$final
cd ..

sed -i "1i#def G_BEGIN_DECLS" $final
sed -i "1i#def G_END_DECLS" $final
sed -i "1i#def G_DEPRECATED" $final
sed -i "1i#def G_GNUC_CONST" $final
sed -i "1i#def G_DEPRECATED_FOR(i)" $final
sed -i "1i#def G_GNUC_NULL_TERMINATED" $final
sed -i "s/\o14//g" $final

# add missing {} for struct
sed -i 's/typedef struct _GdkPixbuf GdkPixbuf;/typedef struct _GdkPixbuf{} GdkPixbuf;/g' $final
sed -i 's/typedef struct _GdkPixbufSimpleAnim GdkPixbufSimpleAnim;/typedef struct _GdkPixbufSimpleAnim{} GdkPixbufSimpleAnim;/g' $final

ruby ../fix_.rb $final

i='
#ifdef __INCREASE_TMP_INDENT__
#ifdef C2NIM
#  dynlib lib
#endif
#endif
'
perl -0777 -p -i -e "s/^/$i/" $final

sed -i '/#define GDK_PIXBUF_ERROR gdk_pixbuf_error_quark ()/d' $final
ruby ../fix_gtk_type.rb final.h GDK_
#sed -i 's/gchar\s*\*\*/char **/g' $final
c2nim096 --skipcomments --skipinclude $final
sed -i -f gtk_type_sedlist final.nim

sed -i 's/\btype: /`type`: /g' final.nim

i='const 
  headerfilename* = '
perl -0777 -p -i -e "s~\Q$i\E~  ### ~sg" final.nim

# we use our own defined pragma
sed -i "s/\bdynlib: lib\b/libpixbuf/g" final.nim

ruby ../remdef.rb final.nim

sed -i '1d' final.nim
sed -i 's/^  //' final.nim

i=' {.deadCodeElim: on.}
'
j='{.deadCodeElim: on.}

import glib
import gobject

when defined(windows):
  const LIB_PIXBUF = "libgdk_pixbuf-2.0-0.dll"
elif defined(macosx):
  const LIB_PIXBUF = "libgdk_pixbuf-2.0.0.dylib"
else: 
  const LIB_PIXBUF = "libgdk_pixbuf-2.0.so"

{.pragma: libpixbuf, cdecl, dynlib: LIB_PIXBUF.}

const
  GDK_PIXBUF_DISABLE_DEPRECATED* = false
  GDK_PIXBUF_ENABLE_BACKEND* = true

type
  GModule = object # dummy object -- GIO module is still missing...
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='when defined(GDK_PIXBUF_DISABLE_SINGLE_INCLUDES) and
    not defined(GDK_PIXBUF_H_INSIDE) and
    not defined(GDK_PIXBUF_COMPILATION):'
perl -0777 -p -i -e "s~\Q$i\E~~sg" final.nim

ruby ../underscorefix.rb final.nim

sed -i 's/(object:/(`object`:/' final.nim
sed -i 's/(object)/(`object`)/' final.nim

i='  type 
    GdkPixbufAnimation* = object 
      parent_instance*: GObject
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

i='  type 
    GdkPixbufAnimationIter* = object 
      parent_instance*: GObject
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

j='template GDK_PIXBUF_ANIMATION*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_CAST((`object`), animation_get_type(), 
                              GdkPixbufAnimation))
'
i='when defined(GDK_PIXBUF_ENABLE_BACKEND): 
  type 
    GdkPixbufAnimation* = object 
      parent_instance*: GObject
  type 
    GdkPixbufAnimationIter* = object 
      parent_instance*: GObject
else:
  type 
    GdkPixbufAnimation* = object 
  type 
    GdkPixbufAnimationIter* = object 
'

perl -0777 -p -i -e "s~\Q$j\E~$i$j~s" final.nim

i='when defined(GDK_PIXBUF_ENABLE_BACKEND): 
  type 
    GdkPixbufModuleSizeFunc* = proc (width: ptr gint; height: ptr gint; 
                                     user_data: gpointer)
  type 
    GdkPixbufModulePreparedFunc* = proc (pixbuf: ptr GdkPixbuf; 
        anim: ptr GdkPixbufAnimation; user_data: gpointer)
  type 
    GdkPixbufModuleUpdatedFunc* = proc (pixbuf: ptr GdkPixbuf; x: cint; 
        y: cint; width: cint; height: cint; user_data: gpointer)
  type 
    GdkPixbufModulePattern* = object 
      prefix*: cstring
      mask*: cstring
      relevance*: cint

  type 
    GdkPixbufModule* = object 
      module_name*: cstring
      module_path*: cstring
      module*: ptr GModule
      info*: ptr GdkPixbufFormat
      load*: proc (f: ptr FILE; error: ptr ptr GError): ptr GdkPixbuf
      load_xpm_data*: proc (data: cstringArray): ptr GdkPixbuf
      begin_load*: proc (size_func: GdkPixbufModuleSizeFunc; 
                         prepare_func: GdkPixbufModulePreparedFunc; 
                         update_func: GdkPixbufModuleUpdatedFunc; 
                         user_data: gpointer; error: ptr ptr GError): gpointer
      stop_load*: proc (context: gpointer; error: ptr ptr GError): gboolean
      load_increment*: proc (context: gpointer; buf: ptr guchar; size: guint; 
                             error: ptr ptr GError): gboolean
      load_animation*: proc (f: ptr FILE; error: ptr ptr GError): ptr GdkPixbufAnimation
      save*: proc (f: ptr FILE; pixbuf: ptr GdkPixbuf; 
                   param_keys: ptr ptr gchar; param_values: ptr ptr gchar; 
                   error: ptr ptr GError): gboolean
      save_to_callback*: proc (save_func: GdkPixbufSaveFunc; 
                               user_data: gpointer; pixbuf: ptr GdkPixbuf; 
                               option_keys: ptr ptr gchar; 
                               option_values: ptr ptr gchar; 
                               error: ptr ptr GError): gboolean
      reserved1: proc ()
      reserved2: proc ()
      reserved3: proc ()
      reserved4: proc ()
      reserved5: proc ()

  type 
    GdkPixbufModuleFillVtableFunc* = proc (module: ptr GdkPixbufModule)
  type 
    GdkPixbufModuleFillInfoFunc* = proc (info: ptr GdkPixbufFormat)
  proc gdk_pixbuf_set_option*(pixbuf: ptr GdkPixbuf; key: ptr gchar; 
                              value: ptr gchar): gboolean {.
      importc: "gdk_pixbuf_set_option", libpixbuf.}
  type 
    GdkPixbufFormatFlags* {.size: sizeof(cint).} = enum 
      GDK_PIXBUF_FORMAT_WRITABLE = 1 shl 0, 
      GDK_PIXBUF_FORMAT_SCALABLE = 1 shl 1, 
      GDK_PIXBUF_FORMAT_THREADSAFE = 1 shl 2
  type 
    GdkPixbufFormat* = object 
      name*: ptr gchar
      signature*: ptr GdkPixbufModulePattern
      domain*: ptr gchar
      description*: ptr gchar
      mime_types*: ptr ptr gchar
      extensions*: ptr ptr gchar
      flags*: guint32
      disabled*: gboolean
      license*: ptr gchar
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim
j='when defined(GDK_PIXBUF_ENABLE_BACKEND): 
  type 
    GdkPixbufModuleSizeFunc* = proc (width: ptr gint; height: ptr gint; 
                                     user_data: gpointer)
  type 
    GdkPixbufModulePreparedFunc* = proc (pixbuf: ptr GdkPixbuf; 
        anim: ptr GdkPixbufAnimation; user_data: gpointer)
  type 
    GdkPixbufModuleUpdatedFunc* = proc (pixbuf: ptr GdkPixbuf; x: cint; 
        y: cint; width: cint; height: cint; user_data: gpointer)
  type 
    GdkPixbufModulePattern* = object 
      prefix*: cstring
      mask*: cstring
      relevance*: cint

  type 
    GdkPixbufFormat* = object 
      name*: ptr gchar
      signature*: ptr GdkPixbufModulePattern
      domain*: ptr gchar
      description*: ptr gchar
      mime_types*: ptr ptr gchar
      extensions*: ptr ptr gchar
      flags*: guint32
      disabled*: gboolean
      license*: ptr gchar

  type 
    GdkPixbufModule* = object 
      module_name*: cstring
      module_path*: cstring
      module*: ptr GModule
      info*: ptr GdkPixbufFormat
      load*: proc (f: ptr FILE; error: ptr ptr GError): ptr GdkPixbuf
      load_xpm_data*: proc (data: cstringArray): ptr GdkPixbuf
      begin_load*: proc (size_func: GdkPixbufModuleSizeFunc; 
                         prepare_func: GdkPixbufModulePreparedFunc; 
                         update_func: GdkPixbufModuleUpdatedFunc; 
                         user_data: gpointer; error: ptr ptr GError): gpointer
      stop_load*: proc (context: gpointer; error: ptr ptr GError): gboolean
      load_increment*: proc (context: gpointer; buf: ptr guchar; size: guint; 
                             error: ptr ptr GError): gboolean
      load_animation*: proc (f: ptr FILE; error: ptr ptr GError): ptr GdkPixbufAnimation
      save*: proc (f: ptr FILE; pixbuf: ptr GdkPixbuf; 
                   param_keys: ptr ptr gchar; param_values: ptr ptr gchar; 
                   error: ptr ptr GError): gboolean
      save_to_callback*: proc (save_func: GdkPixbufSaveFunc; 
                               user_data: gpointer; pixbuf: ptr GdkPixbuf; 
                               option_keys: ptr ptr gchar; 
                               option_values: ptr ptr gchar; 
                               error: ptr ptr GError): gboolean
      reserved1: proc ()
      reserved2: proc ()
      reserved3: proc ()
      reserved4: proc ()
      reserved5: proc ()

  type 
    GdkPixbufModuleFillVtableFunc* = proc (module: ptr GdkPixbufModule)
  type 
    GdkPixbufModuleFillInfoFunc* = proc (info: ptr GdkPixbufFormat)
  type 
    GdkPixbufFormatFlags* {.size: sizeof(cint).} = enum 
      GDK_PIXBUF_FORMAT_WRITABLE = 1 shl 0, 
      GDK_PIXBUF_FORMAT_SCALABLE = 1 shl 1, 
      GDK_PIXBUF_FORMAT_THREADSAFE = 1 shl 2
  proc gdk_pixbuf_set_option*(pixbuf: ptr GdkPixbuf; key: ptr gchar; 
                              value: ptr gchar): gboolean {.
      importc: "gdk_pixbuf_set_option", libpixbuf.}
else:
  type 
    GdkPixbufFormat* = object 
'
i='proc gdk_pixbuf_format_get_type*(): GType {.
    importc: "gdk_pixbuf_format_get_type", libpixbuf.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j$i~s" final.nim

ruby ../glib_fix_proc.rb final.nim
sed -i -f ../glib_sedlist final.nim
sed -i -f ../gobject_sedlist final.nim
sed -i -f ../gio_sedlist final.nim

ruby ../fix_template.rb final.nim
#exit
#sed -i 's/\bGdkPixbuf\b/GdkPixbufGdkPixbuf/g' final.nim
ruby ../glib_fix_T.rb final.nim gdk_pixbuf GdkPixbuf
ruby ../glib_fix_enum_prefix.rb final.nim

sed -i 's/^proc ref\*(/proc `ref`\*(/g' final.nim
sed -i 's/^  proc ref\*(/  proc `ref`\*(/g' final.nim
sed -i 's/^proc end\*(/proc `end`\*(/g' final.nim
sed -i 's/^proc continue\*(/proc `continue`\*(/g' final.nim

sed -i 's/\(dummy[0-9]\?\)\*/\1/g' final.nim
sed -i 's/\(reserved[0-9]\?\)\*/\1/g' final.nim
sed -i 's/proc type\*(/proc `type`\*(/g' final.nim

sed -i 's/[(][(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/(\1/g' final.nim
sed -i 's/, [(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/, \1/g' final.nim

ruby ../fix_object_of.rb final.nim

perl -0777 -p -i -e "s~([=:] proc \(.*?\)(?:: (?:ptr )?\w+)?)~\1 {.cdecl.}~sg" final.nim
sed -i 's/\([,=(<>] \{0,1\}\)[(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/\1\2/g' final.nim
sed -i '/^ \? \?#type $/d' final.nim
sed -i 's/\bgobject\.GObjectObj\b/GObjectObj/g' final.nim
sed -i 's/\bgobject\.GObject\b/GObject/g' final.nim
sed -i 's/\bgobject\.GObjectClassObj\b/GObjectClassObj/g' final.nim

sed -i 's/ ptr gchar\b/ cstring/g' final.nim
sed -i 's/ ptr var / var ptr /g' final.nim

# the gobject lower case templates
sed -i 's/\bG_TYPE_CHECK_CLASS_TYPE\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_CHECK_CLASS_CAST\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_INSTANCE_GET_CLASS\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_CHECK_INSTANCE_CAST\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_CHECK_INSTANCE_TYPE\b/\L&/g' final.nim

sed -i 's/when not(defined(GDK_PIXBUF_DISABLE_DEPRECATED))/when not GDK_PIXBUF_DISABLE_DEPRECATED/g' final.nim
sed -i 's/when defined(GDK_PIXBUF_ENABLE_BACKEND)/when GDK_PIXBUF_ENABLE_BACKEND/g' final.nim

i='import glib
import gobject
'
j='from glib import gpointer, guchar, gboolean, GQuark, guint8, guint, gint, gsize, guint32, gfloat
from gobject import GObject, GType, GObjectObj, GObjectClassObj
from gio import GInputStream, GOutputStream, GCancellable, GAsyncResult, GAsyncReadyCallback
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='when not(defined(GTK_DOC_IGNORE)): 
  when defined(G_OS_WIN32): 
    const 
      gdk_pixbuf_new_from_file* = gdk_pixbuf_new_from_file_utf8
      gdk_pixbuf_new_from_file_at_size* = gdk_pixbuf_new_from_file_at_size_utf8
      gdk_pixbuf_new_from_file_at_scale* = gdk_pixbuf_new_from_file_at_scale_utf8
proc gdk_pixbuf_new_from_file*(filename: cstring; error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_file", libpixbuf.}
proc gdk_pixbuf_new_from_file_at_size*(filename: cstring; width: cint; 
    height: cint; error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_file_at_size", libpixbuf.}
proc gdk_pixbuf_new_from_file_at_scale*(filename: cstring; width: cint; 
    height: cint; preserve_aspect_ratio: gboolean; error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_file_at_scale", libpixbuf.}
'
j='when defined(G_OS_WIN32): 
  const
    GDK_PIXBUF_NEW_FROM_FILE_LIBNAME = "gdk_pixbuf_new_from_file_utf8"
    GDK_PIXBUF_NEW_FROM_FILE_AT_SIZE_LIBNAME = "gdk_pixbuf_new_from_file_at_size_utf8"
    GDK_PIXBUF_NEW_FROM_FILE_AT_SCALE_LIBNAME = "gdk_pixbuf_new_from_file_at_scale_utf8"
else:
  const
    GDK_PIXBUF_NEW_FROM_FILE_LIBNAME = "gdk_pixbuf_new_from_file"
    GDK_PIXBUF_NEW_FROM_FILE_AT_SIZE_LIBNAME = "gdk_pixbuf_new_from_file_at_size"
    GDK_PIXBUF_NEW_FROM_FILE_AT_SCALE_LIBNAME = "gdk_pixbuf_new_from_file_at_scale"

proc gdk_pixbuf_new_from_file*(filename: cstring; error: var glib.GError): GdkPixbuf {.
    importc: GDK_PIXBUF_NEW_FROM_FILE_LIBNAME, libpixbuf.}
proc gdk_pixbuf_new_from_file_at_size*(filename: cstring; width: cint; 
    height: cint; error: var glib.GError): GdkPixbuf {.
    importc: GDK_PIXBUF_NEW_FROM_FILE_AT_SIZE_LIBNAME, libpixbuf.}
proc gdk_pixbuf_new_from_file_at_scale*(filename: cstring; width: cint; 
    height: cint; preserve_aspect_ratio: gboolean; error: var glib.GError): GdkPixbuf {.
    importc: GDK_PIXBUF_NEW_FROM_FILE_AT_SCALE_LIBNAME, libpixbuf.}

when defined(G_OS_WIN32): 
  const
    GDK_PIXBUF_NEW_FROM_FILE_UTF8* = new_from_file
    GDK_PIXBUF_NEW_FROM_FILE_AT_SIZE_UTF8* = new_from_file_at_size
    GDK_PIXBUF_NEW_FROM_FILE_AT_SCALE_UTF8* = new_from_file_at_scale
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='when not(defined(GTK_DOC_IGNORE)): 
  when defined(G_OS_WIN32): 
    const 
      gdk_pixbuf_save* = gdk_pixbuf_save_utf8
      gdk_pixbuf_savev* = gdk_pixbuf_savev_utf8
proc save*(pixbuf: GdkPixbuf; filename: cstring; `type`: cstring; 
                      error: var glib.GError): gboolean {.varargs, 
    importc: "gdk_pixbuf_save", libpixbuf.}
proc savev*(pixbuf: GdkPixbuf; filename: cstring; 
                       `type`: cstring; option_keys: cstringArray; 
                       option_values: cstringArray; error: var glib.GError): gboolean {.
    importc: "gdk_pixbuf_savev", libpixbuf.}
'
j='when defined(G_OS_WIN32): 
  const 
    GDK_PIXBUF_SAVE_LIBNAME = "gdk_pixbuf_save_utf8"
    GDK_PIXBUF_SAVEV_LIBNAME = "gdk_pixbuf_savev_utf8"
else:
  const 
    GDK_PIXBUF_SAVE_LIBNAME = "gdk_pixbuf_save"
    GDK_PIXBUF_SAVEV_LIBNAME = "gdk_pixbuf_savev"

proc save*(pixbuf: GdkPixbuf; filename: cstring; `type`: cstring; 
                      error: var glib.GError): gboolean {.varargs, 
    importc: GDK_PIXBUF_SAVE_LIBNAME, libpixbuf.}
proc savev*(pixbuf: GdkPixbuf; filename: cstring; 
                       `type`: cstring; option_keys: cstringArray; 
                       option_values: cstringArray; error: var glib.GError): gboolean {.
    importc:  GDK_PIXBUF_SAVEV_LIBNAME, libpixbuf.}

when defined(G_OS_WIN32): 
  const 
    GDK_PIXBUF_SAVE_UTF8* = save
    GDK_PIXBUF_SAVEV_UTF8* = savev
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='when not(defined(GTK_DOC_IGNORE)): 
  when defined(G_OS_WIN32): 
    const 
      gdk_pixbuf_animation_new_from_file* = gdk_pixbuf_animation_new_from_file_utf8
proc gdk_pixbuf_animation_new_from_file*(filename: cstring; 
    error: var glib.GError): GdkPixbufAnimation {.
    importc: "gdk_pixbuf_animation_new_from_file", libpixbuf.}
'
j='when defined(G_OS_WIN32): 
  proc gdk_pixbuf_animation_new_from_file*(filename: cstring; 
      error: var glib.GError): GdkPixbufAnimation {.
      importc: "gdk_pixbuf_animation_new_from_file_utf8", libpixbuf.}
  const 
    ANIMATION_NEW_FROM_FILE_UTF8* = animation_new_from_file
else:
  proc gdk_pixbuf_animation_new_from_file*(filename: cstring; 
      error: var glib.GError): GdkPixbufAnimation {.
      importc: "gdk_pixbuf_animation_new_from_file", libpixbuf.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

sed -i 's/ptr cstring/cstringArray/g' final.nim

# generate procs without get_ and set_ prefix
perl -0777 -p -i -e "s/(\n\s*)(proc set_)(\w+)(\*\([^}]*\) {[^}]*})/\$&\1proc \`\3=\`\4/sg" final.nim
perl -0777 -p -i -e "s/(\n\s*)(proc get_)(\w+)(\*\([^}]*\): \w[^}]*})/\$&\1proc \3\4/sg" final.nim

perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( gsize)/\1\2\3\4var\6/sg' final.nim
#perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
#perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( GdkVisualType)/\1\2\3\4var\6/sg' final.nim

sed -i 's/\bwidth: ptr /width: var /g' final.nim
sed -i 's/\bheight: ptr /height: var /g' final.nim
sed -i 's/ buffer: ptr cstring;/ buffer: var cstring;/g' final.nim
sed -i '/### "gdk-pixbuf\/\.\/gdk-pixbuf/d' final.nim
sed -i 's/when defined(G_OS_WIN32):/when defined(windows):/g' final.nim

sed -i "s/\(^\s*proc \)gdk_pixbuf_/\1/g" final.nim
ruby ../mangler.rb final.nim GDK_PIXBUF_
sed -i 's/\bGdkPixbufObj\b/GdkXXXPixbufObj/g' final.nim
sed -i 's/\bGdkPixbufPtr\b/GdkXXXPixbufPtr/g' final.nim
sed -i 's/\bGdkPixbuf\b/GdkXXXPixbuf/g' final.nim
ruby ../mangler.rb final.nim GdkPixbuf
sed -i 's/\bGdkXXXPixbufObj\b/GdkPixbufObj/g' final.nim
sed -i 's/\bGdkXXXPixbufPtr\b/GdkPixbufPtr/g' final.nim
sed -i 's/\bGdkXXXPixbuf\b/GdkPixbuf/g' final.nim

sed -i 's/^ $//g' final.nim
cat -s final.nim > gdk_pixbuf.nim

ruby ../gen_proc_dep.rb gdk_pixbuf.nim

cat proc_dep_list >> gdk_pixbuf.nim

exit

