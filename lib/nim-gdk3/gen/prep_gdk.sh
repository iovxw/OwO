#!/bin/bash
# S. Salewski, 26-MAY-2014 (initial release, GDK 3.12)
# S. Salewski, 08-MAR-2015
# Generate GTK3 bindings for Nim -- this is for GDK headers 3.15.6
# we try to process all headers, including win32, wayland, quartz, broadway and mir
# currently I can test only with x11
#
gtk3_dir="/home/stefan/Downloads/gtk+-3.15.6" # have currently only 3.14 lib installed!
final="final.h" # the input file for c2nim
list="list.txt"
wdir="tmp_gdk"

# GdkColor is from deprecated...
targets='x11 deprecated win32 wayland quartz mir broadway' # I can test only x11 currently!
all_t=". ${targets}"

rm -rf $wdir # start from scratch
mkdir $wdir
cd $wdir
cp -r $gtk3_dir/gdk .
cd gdk

# I think for 3.15 we have all -- for newer headers we may investigate the generated list
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

# order matters.
cat gdk.h x11/gdkx.h win32/gdkwin32.h wayland/gdkwayland.h quartz/gdkquartz.h mir/gdkmir.h broadway/gdkbroadway.h  > all.h

cd ..

touch windows.h # empty dummy headers to make cpp happy
touch commctrl.h
touch wayland-client.h
mkdir AppKit
touch AppKit/AppKit.h
mkdir mir_toolkit
touch mir_toolkit/mir_client_library.h

# cpp run with all headers to determine order
echo "cat \\" > $list
echo 'gdkkeysyms.h \' >> $list # we need this also
echo 'gdkintl.h \' >> $list

cpp -I. `pkg-config --cflags gtk+-3.0` gdk/all.h $final

rm windows.h  commctrl.h wayland-client.h 
rm -r AppKit
rm -r mir_toolkit

# extract file names and push names to list
grep ssalewski $final | sed 's/_ssalewski;/ \\/' >> $list

# add remaining missing headers
# for now we put all at the bottom and do manually ordering if necessary
echo 'broadway/broadway-buffer.h \' >> $list
echo 'broadway/broadway-protocol.h \' >> $list
echo 'broadway/broadway-output.h \' >> $list
echo 'broadway/broadway-server.h \' >> $list
echo 'mir/gdkmir.h \' >> $list
#echo 'broadway/gdkbroadway-server.h \' >> $list # private

# may we need these?
#gdkversionmacros.h
#keyname-table.h

sed -i '/gdkprivate\.h/d' $list # included by quartz backend

i=`uniq -d $list | wc -l`
if [ $i != 0 ]; then echo 'list contains duplicates!'; exit; fi;

# now we work again with original headers
rm -rf gdk
cp -r $gtk3_dir/gdk . 

sed -i "s/#define GDK_PRIORITY_EVENTS (G_PRIORITY_DEFAULT)//" gdk/gdkmain.h # redefinition

# insert for each header file its name as first line
for j in $all_t ; do
  for i in gdk/${j}/*.h; do
    sed -i "1i/* file: $i */" $i
    sed -i "1i#define headerfilename \"$i\"" $i # marker for splitting
  done
done

cd gdk
bash ../$list > ../$final
cd ..

# insert empty dummy #def statements for strange macros
# we restrict use of wildcards in sed/perl patterns to limit risc of damage something!
for i in 2 4 6 8 10 12 14 16 ; do
  sed -i "1i#def GDK_AVAILABLE_IN_3_$i\n#def GDK_DEPRECATED_IN_3_$i\n#def GDK_DEPRECATED_IN_3_${i}_FOR(x)" $final
done

sed -i "1i#def G_BEGIN_DECLS" $final
sed -i "1i#def G_END_DECLS" $final

sed -i "1i#def GDK_AVAILABLE_IN_ALL" $final
sed -i "1i#def GDK_DEPRECATED_IN_3_0" $final
sed -i "1i#def GDK_DEPRECATED_IN_3_0_FOR(x)" $final
sed -i "1i#def G_GNUC_CONST" $final
sed -i "1i#def GDK_THREADS_DEPRECATED" $final
sed -i "1i#def G_GNUC_WARN_UNUSED_RESULT" $final
sed -i "1i#def G_GNUC_NULL_TERMINATED" $final

# insert () after name, so it is a template, not a const
sed -i 's/#define GDK_NONE            _GDK_MAKE_ATOM (0)/#define GDK_NONE()            _GDK_MAKE_ATOM (0)/' $final
sed -i 's/#define GDK_SELECTION_PRIMARY 		_GDK_MAKE_ATOM (1)/#define GDK_SELECTION_PRIMARY() 		_GDK_MAKE_ATOM (1)/' $final
sed -i 's/#define GDK_SELECTION_SECONDARY 	_GDK_MAKE_ATOM (2)/#define GDK_SELECTION_SECONDARY() 	_GDK_MAKE_ATOM (2)/' $final
sed -i 's/#define GDK_SELECTION_CLIPBOARD 	_GDK_MAKE_ATOM (69)/#define GDK_SELECTION_CLIPBOARD() 	_GDK_MAKE_ATOM (69)/' $final
sed -i 's/#define GDK_TARGET_BITMAP 		_GDK_MAKE_ATOM (5)/#define GDK_TARGET_BITMAP() 		_GDK_MAKE_ATOM (5)/' $final
sed -i 's/#define GDK_TARGET_COLORMAP 		_GDK_MAKE_ATOM (7)/#define GDK_TARGET_COLORMAP() 		_GDK_MAKE_ATOM (7)/' $final
sed -i 's/#define GDK_TARGET_DRAWABLE 		_GDK_MAKE_ATOM (17)/#define GDK_TARGET_DRAWABLE() 		_GDK_MAKE_ATOM (17)/' $final
sed -i 's/#define GDK_TARGET_PIXMAP 		_GDK_MAKE_ATOM (20)/#define GDK_TARGET_PIXMAP() 		_GDK_MAKE_ATOM (20)/' $final
sed -i 's/#define GDK_TARGET_STRING 		_GDK_MAKE_ATOM (31)/#define GDK_TARGET_STRING() 		_GDK_MAKE_ATOM (31)/' $final
sed -i 's/#define GDK_SELECTION_TYPE_ATOM 	_GDK_MAKE_ATOM (4)/#define GDK_SELECTION_TYPE_ATOM() 	_GDK_MAKE_ATOM (4)/' $final
sed -i 's/#define GDK_SELECTION_TYPE_BITMAP 	_GDK_MAKE_ATOM (5)/#define GDK_SELECTION_TYPE_BITMAP() 	_GDK_MAKE_ATOM (5)/' $final
sed -i 's/#define GDK_SELECTION_TYPE_COLORMAP 	_GDK_MAKE_ATOM (7)/#define GDK_SELECTION_TYPE_COLORMAP() 	_GDK_MAKE_ATOM (7)/' $final
sed -i 's/#define GDK_SELECTION_TYPE_DRAWABLE 	_GDK_MAKE_ATOM (17)/#define GDK_SELECTION_TYPE_DRAWABLE() 	_GDK_MAKE_ATOM (17)/' $final
sed -i 's/#define GDK_SELECTION_TYPE_INTEGER 	_GDK_MAKE_ATOM (19)/#define GDK_SELECTION_TYPE_INTEGER() 	_GDK_MAKE_ATOM (19)/' $final
sed -i 's/#define GDK_SELECTION_TYPE_PIXMAP 	_GDK_MAKE_ATOM (20)/#define GDK_SELECTION_TYPE_PIXMAP() 	_GDK_MAKE_ATOM (20)/' $final
sed -i 's/#define GDK_SELECTION_TYPE_WINDOW 	_GDK_MAKE_ATOM (33)/#define GDK_SELECTION_TYPE_WINDOW() 	_GDK_MAKE_ATOM (33)/' $final
sed -i 's/#define GDK_SELECTION_TYPE_STRING 	_GDK_MAKE_ATOM (31)/#define GDK_SELECTION_TYPE_STRING() 	_GDK_MAKE_ATOM (31)/' $final

# we use perl for multiline text replacement -- generally $i is replaced by $j
# we use large blocks even for small fixes, so we can better verify substitution and prevent
# unwanted replacements

# we have no bitfields for Nim currently
i="\
struct _GdkEventKey
{
  GdkEventType type;
  GdkWindow *window;
  gint8 send_event;
  guint32 time;
  guint state;
  guint keyval;
  gint length;
  gchar *string;
  guint16 hardware_keycode;
  guint8 group;
  guint is_modifier : 1;
};
"
j="\
struct _GdkEventKey
{
  GdkEventType type;
  GdkWindow *window;
  gint8 send_event;
  guint32 time;
  guint state;
  guint keyval;
  gint length;
  gchar *string;
  guint16 hardware_keycode;
  guint8 group;
  guint is_modifier;
};
"
perl -0777 -p -i -e "s/\Q$i\E/$j/s" $final

# caution, that may replace too large blocks!!!
#perl -0777 -p -i -e 's/#if !?defined.*?error.*?#endif//sg' $final
perl -0777 -p -i -e "s/#if !?defined.*?\n#error.*?\n#endif//g" $final

i='#if defined(GDK_COMPILATION) || defined(GTK_COMPILATION)
#define GDK_THREADS_DEPRECATED _GDK_EXTERN
#else
#define GDK_THREADS_DEPRECATED GDK_DEPRECATED_IN_3_6
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

sed  -i "s/(object)/(obj)/g" $final # name is used in macros, but object is keyword

# add missing {} for struct
sed -i 's/typedef struct _GdkGLContext          GdkGLContext;/typedef struct _GdkGLContext{} GdkGLContext;/g' $final
sed -i 's/typedef struct _GdkVisual             GdkVisual;/typedef struct _GdkVisual{} GdkVisual;/g' $final
sed -i 's/typedef struct _GdkDevice             GdkDevice;/typedef struct _GdkDevice {}GdkDevice;/g' $final
sed -i 's/typedef struct _GdkWindow             GdkWindow;/typedef struct _GdkWindow{} GdkWindow;/g' $final
sed -i 's/typedef struct _GdkScreen             GdkScreen;/typedef struct _GdkScreen{} GdkScreen;/g' $final
sed -i 's/typedef struct _GdkDisplay            GdkDisplay;/typedef struct _GdkDisplay{} GdkDisplay;/g' $final
sed -i 's/typedef struct _GdkCursor             GdkCursor;/typedef struct _GdkCursor{} GdkCursor;/g' $final
sed -i 's/typedef struct _GdkDragContext        GdkDragContext;/typedef struct _GdkDragContext{} GdkDragContext;/g' $final
sed -i 's/typedef struct _GdkAppLaunchContext   GdkAppLaunchContext;/typedef struct _GdkAppLaunchContext{} GdkAppLaunchContext;/g' $final
sed -i 's/typedef struct _GdkDeviceManager      GdkDeviceManager;/typedef struct _GdkDeviceManager{} GdkDeviceManager;/g' $final
sed -i 's/typedef struct _GdkDisplayManager     GdkDisplayManager;/typedef struct _GdkDisplayManager{} GdkDisplayManager;/g' $final
sed -i 's/typedef struct _GdkKeymap             GdkKeymap;/typedef struct _GdkKeymap{} GdkKeymap;/g' $final
sed -i 's/typedef struct _GdkEventSequence    GdkEventSequence;/typedef struct _GdkEventSequence{} GdkEventSequence;/g' $final
sed -i 's/typedef struct _GdkFrameTimings GdkFrameTimings;/typedef struct _GdkFrameTimings{} GdkFrameTimings;/g' $final
sed -i 's/typedef struct _GdkFrameClock              GdkFrameClock;/typedef struct _GdkFrameClock{} GdkFrameClock;/g' $final
sed -i 's/typedef struct _GdkX11DeviceManagerCore GdkX11DeviceManagerCore;/typedef struct _GdkX11DeviceManagerCore{} GdkX11DeviceManagerCore;/g' $final
sed -i 's/typedef struct _GdkX11DeviceManagerCoreClass GdkX11DeviceManagerCoreClass;/typedef struct _GdkX11DeviceManagerCoreClass{} GdkX11DeviceManagerCoreClass;/g' $final
sed -i 's/typedef struct _GdkX11DeviceManagerXI2 GdkX11DeviceManagerXI2;/typedef struct _GdkX11DeviceManagerXI2{} GdkX11DeviceManagerXI2;/g' $final
sed -i 's/typedef struct _GdkX11DeviceManagerXI2Class GdkX11DeviceManagerXI2Class;/typedef struct _GdkX11DeviceManagerXI2Class{} GdkX11DeviceManagerXI2Class;/g' $final

ruby ../fix_.rb $final

# header for Nim module
i='#ifdef __INCREASE_TMP_INDENT__
#ifdef C2NIM
#  dynlib lib
#endif
#endif
'
perl -0777 -p -i -e "s/^/$i/" $final

perl -0777 -p -i -e 's/\n#ifdef GDK_COMPILATION\n#else\n(.*?;\n)#endif\n/\1/g' $final

ruby ../fix_gtk_type.rb final.h BROADWAY_
mv gtk_type_sedlist broadway_sedlist
ruby ../fix_gtk_type.rb final.h GDK_
c2nim096 --skipcomments --skipinclude $final
sed -i -f gtk_type_sedlist final.nim
sed -i -f broadway_sedlist final.nim

perl -0777 -p -i -e "s~([=:] proc \(.*?\)(?:: (?:ptr )?\w+)?)~\1 {.cdecl.}~sg" final.nim

# we use our own defined pragma
sed -i "s/\bdynlib: lib\b/libgdk/g" final.nim

ruby ../remdef.rb final.nim

# stange name without H, so we delete it nanually...
i='when not(defined(__BROADWAY_BUFFER__)): 
  const 
    __BROADWAY_BUFFER__* = true
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim
i='when not(defined(__BROADWAY_SERVER__)): 
  const 
    __BROADWAY_SERVER__* = true
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

i='const 
  headerfilename* = '
perl -0777 -p -i -e "s~\Q$i\E~  ### ~sg" final.nim

sed -i '1d' final.nim
sed -i 's/^  //' final.nim

i=' {.deadCodeElim: on.}'
j='{.deadCodeElim: on.}

when defined(windows): 
  const LIB_GDK* = "libgdk-win32-3.0-0.dll"
elif defined(gtk_quartz):
  #const LIB_GDK* = "libgdk-quartz-3.0.dylib"
  const LIB_GDK* = "libgdk-3.0.dylib"
elif defined(macosx):
  const LIB_GDK* = "libgdk-x11-3.0.dylib"
else: 
  const LIB_GDK* = "libgdk-3.so(|.0)"

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import
  glib, gobject, gdk_pixbuf, pango, cairo,
  x, xlib, windows

#type # missing objects
#  _GdkDisplayManagerClass* = object

const
  GDK_MULTIDEVICE_SAFE = true
  ENABLE_NLS = false
  #INSIDE_GDK_WIN32 = false
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

sed  -i 's/\bPixbuf\b/GdkPixbuf/g' final.nim
sed  -i 's/\bPangoDirection\b/pango.Direction/g' final.nim

sed  -i 's/  GdkRectangle\* = cairo_rectangle_int_t/  GdkRectangle* = object /' final.nim

ruby ../glib_fix_proc.rb final.nim
ruby ../glib_fix_T.rb final.nim gdk3 Gdk

sed  -i 's/GDK_OWNERSHIP_/GDK_GRAB_OWNERSHIP_/g' final.nim
ruby ../glib_fix_enum_prefix.rb final.nim

sed  -i 's/  GdkRectangleObj\* = object /  GdkRectangleObj* = cairo_rectangle_int_t/' final.nim

sed  -i "s/GDK_KEY_/KEY_/g" final.nim

# Fix this:
# KEY_a* =
# KEY_A* =
# But first fix triples
# KEY_ETH* =
# KEY_Eth* =
# KEY_eth* =
# KEY_THORN* =
# KEY_Thorn* =
# KEY_thorn* =
# KEY_CH* =
# KEY_C_H* =
# KEY_Ch* =
# KEY_C_h* =
# KEY_ch* =
# KEY_c_h* =

sed  -i "s/  KEY_Eth\* =/  KEY_CAP_Eth\* =/" final.nim
sed  -i "s/  KEY_ETH\* =/  KEY_CAPITAL_ETH\* =/" final.nim
sed  -i "s/  KEY_Thorn\* =/  KEY_CAP_Thorn\* =/" final.nim
sed  -i "s/  KEY_THORN\* =/  KEY_CAPITAL_THORN\* =/" final.nim
sed  -i "s/  KEY_CH\* =/  KEY_CAPITAL_C_CAPITAL_H\* =/" final.nim
sed  -i "s/  KEY_Ch\* =/  KEY_CAPITAL_C_h\* =/" final.nim
sed  -i "s/  KEY_C_H\* =/  KEY_CAPITAL_C_UNDERSCORE_CAPITAL_H\* =/" final.nim
sed  -i "s/  KEY_C_h\* =/  KEY_CAPITAL_C_UNDERSCORE_h\* =/" final.nim
sed  -i "s/  KEY_c_h\* =/  KEY_c_UNDERSCORE_h\* =/" final.nim

grep '^  KEY' final.nim | sed 's/\* =.*/\* =/g' | sort -r > temp0.txt

uniq -d -i temp0.txt > temp1.txt

sed -i 's/^/grep -i -o -m 1 "/' temp1.txt

sed -i 's/\* =$/\\* =" temp0.txt >> temp2.txt/' temp1.txt

bash temp1.txt

sed -i 's/  KEY_\(.*\)\* =/s%  KEY_\1\\\* =%  KEY_CAPITAL_\1\\\* =%/' temp2.txt

sed -i -f temp2.txt final.nim

rm temp?.txt

i="\
  const 
    __GDKQUARTZ_H_INSIDE__* = true
"
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='type 
  GdkEventType* {.size: sizeof(cint), pure.} = enum 
    NOTHING = - 1, DELETE = 0, DESTROY = 1, EXPOSE = 2, 
    MOTION_NOTIFY = 3, BUTTON_PRESS = 4, 2BUTTON_PRESS = 5, 
    DOUBLE_BUTTON_PRESS = 2BUTTON_PRESS, 3BUTTON_PRESS = 6, 
    TRIPLE_BUTTON_PRESS = 3BUTTON_PRESS, BUTTON_RELEASE = 7, 
    KEY_PRESS = 8, KEY_RELEASE = 9, ENTER_NOTIFY = 10, 
    LEAVE_NOTIFY = 11, FOCUS_CHANGE = 12, CONFIGURE = 13, 
    MAP = 14, UNMAP = 15, PROPERTY_NOTIFY = 16, 
    SELECTION_CLEAR = 17, SELECTION_REQUEST = 18, 
    SELECTION_NOTIFY = 19, PROXIMITY_IN = 20, PROXIMITY_OUT = 21, 
    DRAG_ENTER = 22, DRAG_LEAVE = 23, DRAG_MOTION = 24, 
    DRAG_STATUS = 25, DROP_START = 26, DROP_FINISHED = 27, 
    CLIENT_EVENT = 28, VISIBILITY_NOTIFY = 29, SCROLL = 31, 
    WINDOW_STATE = 32, SETTING = 33, OWNER_CHANGE = 34, 
    GRAB_BROKEN = 35, DAMAGE = 36, TOUCH_BEGIN = 37, 
    TOUCH_UPDATE = 38, TOUCH_END = 39, TOUCH_CANCEL = 40, 
    EVENT_LAST
'
j='type 
  GdkEventType* {.size: sizeof(cint), pure.} = enum 
    NOTHING = - 1, DELETE = 0, DESTROY = 1, EXPOSE = 2, 
    MOTION_NOTIFY = 3, BUTTON_PRESS = 4, BUTTON2_PRESS = 5, 
    BUTTON3_PRESS = 6, 
    BUTTON_RELEASE = 7, 
    KEY_PRESS = 8, KEY_RELEASE = 9, ENTER_NOTIFY = 10, 
    LEAVE_NOTIFY = 11, FOCUS_CHANGE = 12, CONFIGURE = 13, 
    MAP = 14, UNMAP = 15, PROPERTY_NOTIFY = 16, 
    SELECTION_CLEAR = 17, SELECTION_REQUEST = 18, 
    SELECTION_NOTIFY = 19, PROXIMITY_IN = 20, PROXIMITY_OUT = 21, 
    DRAG_ENTER = 22, DRAG_LEAVE = 23, DRAG_MOTION = 24, 
    DRAG_STATUS = 25, DROP_START = 26, DROP_FINISHED = 27, 
    CLIENT_EVENT = 28, VISIBILITY_NOTIFY = 29, SCROLL = 31, 
    WINDOW_STATE = 32, SETTING = 33, OWNER_CHANGE = 34, 
    GRAB_BROKEN = 35, DAMAGE = 36, TOUCH_BEGIN = 37, 
    TOUCH_UPDATE = 38, TOUCH_END = 39, TOUCH_CANCEL = 40, 
    EVENT_LAST
const
  DOUBLE_BUTTON_PRESS = GdkEventType.BUTTON2_PRESS
  TRIPLE_BUTTON_PRESS = GdkEventType.BUTTON3_PRESS
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

sed  -i "s/template P_\*(String: expr)/template P_UNDERSCORE\*(String: expr)/g" final.nim
sed  -i "s/GdkAtom\* = ptr _GdkAtom/GdkAtom\* = ptr object/g" final.nim

ruby ../underscorefix.rb final.nim
sed -i "s/\(^\s*proc \)gdk_/\1/g" final.nim

# do not export priv and reserved
sed -i "s/\( priv[0-9]\?[0-9]\?[0-9]\?\)\*: /\1: /g" final.nim
sed -i "s/\(reserved[0-9]\?[0-9]\?[0-9]\?\)\*: /\1: /g" final.nim

sed -i -f ../glib_sedlist final.nim
sed -i -f ../gobject_sedlist final.nim
sed -i -f ../cairo_sedlist final.nim
sed -i -f ../pango_sedlist final.nim
sed -i -f ../gdk_pixbuf_sedlist final.nim
sed -i -f ../gio_sedlist final.nim

ruby ../fix_template.rb final.nim

i='type 
  GdkGLProfile* {.size: sizeof(cint), pure.} = enum 
    DEFAULT, 3_2_CORE
'
j='type 
  GdkGLProfile* {.size: sizeof(cint), pure.} = enum 
    DEFAULT, GL_3_2_CORE
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

sed -i "s/\bFALSE\b/G&/g" final.nim
sed -i "s/\bTRUE\b/G&/g" final.nim

sed -i "s/  GdkXEvent\* = nil/  GdkXEvent* = proc () {.cdecl.}/g" final.nim

i='type 
  GdkEventFunc* = proc (event: GdkEvent; data: gpointer) {.cdecl.}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim
j='type 
  GdkFilterFunc* = proc (xevent: ptr GdkXEvent; event: GdkEvent; 
                         data: gpointer): GdkFilterReturn {.cdecl.}
'
perl -0777 -p -i -e "s~\Q$j\E~~s" final.nim
k='type 
  GdkEvent* =  ptr GdkEventObj
  GdkEventPtr* = ptr GdkEventObj
  GdkEventObj* = object  {.union.}
    type*: GdkEventType
    any*: GdkEventAnyObj
    expose*: GdkEventExposeObj
    visibility*: GdkEventVisibilityObj
    motion*: GdkEventMotionObj
    button*: GdkEventButtonObj
    touch*: GdkEventTouchObj
    scroll*: GdkEventScrollObj
    key*: GdkEventKeyObj
    crossing*: GdkEventCrossingObj
    focus_change*: GdkEventFocusObj
    configure*: GdkEventConfigureObj
    property*: GdkEventPropertyObj
    selection*: GdkEventSelectionObj
    owner_change*: GdkEventOwnerChangeObj
    proximity*: GdkEventProximityObj
    dnd*: GdkEventDNDObj
    window_state*: GdkEventWindowStateObj
    setting*: GdkEventSettingObj
    grab_broken*: GdkEventGrabBrokenObj
'

perl -0777 -p -i -e "s~\Q$k\E~$k$i$j~s" final.nim

sed -i 's/\bout: /`out`: /g' final.nim
sed -i 's/\bin\*: /`in`\*: /g' final.nim
sed -i 's/\bproc raise\b/proc `raise`/g' final.nim

sed -i 's/\bptr: /`ptr`: /g' final.nim
sed -i 's/\btype: /`type`: /g' final.nim
sed -i 's/\btype\*: /`type`\*: /g' final.nim

sed -i 's/^proc ref\*(/proc `ref`\*(/g' final.nim

sed -i 's/\bfunc\(\)\*/`func`\1\*/' final.nim
sed -i 's/\bfunc\(\):/`func`\1:/' final.nim

sed -i 's/\bcairo_content_t\b/cairo.Content/' final.nim
sed -i 's/\bcairo_format_t\b/cairo.Format/' final.nim
sed -i 's/\bXID\b/x.TXID/' final.nim
sed -i 's/\bVisualID\b/x.TVisualID/' final.nim
sed -i 's/\bVisual\b/xlib.TVisual/' final.nim
sed -i 's/\bScreen\b/xlib.TScreen/' final.nim
sed -i 's/\bWindow\b/x.TWindow/' final.nim
sed -i 's/\bCursor\b/x.TCursor/' final.nim
sed -i 's/\bDisplay\b/xlib.TDisplay/' final.nim
sed -i 's/\bAtom\b/x.TAtom/' final.nim

sed -i 's/  GDK_OSX_TIGER = GDK_OSX_MIN/  GDK_OSX_TIGER = GdkOSXVersion.OSX_MIN/' final.nim
sed -i 's/  GDK_OSX_CURRENT = GDK_OSX_MOUNTAIN_LION/  GDK_OSX_CURRENT = GdkOSXVersion.OSX_MOUNTAIN_LION/' final.nim

i="  BroadwayEventType* {.size: sizeof(cint), pure.} = enum 
    ENTER = 'e', LEAVE = 'l', 
    POINTER_MOVE = 'm', BUTTON_PRESS = 'b', 
    BUTTON_RELEASE = 'B', TOUCH = 't', 
    SCROLL = 's', KEY_PRESS = 'k', 
    KEY_RELEASE = 'K', GRAB_NOTIFY = 'g', 
    UNGRAB_NOTIFY = 'u', CONFIGURE_NOTIFY = 'w', 
    DELETE_NOTIFY = 'W', 
    SCREEN_SIZE_CHANGED = 'd', FOCUS = 'f'
  BroadwayOpType* {.size: sizeof(cint), pure.} = enum 
    GRAB_POINTER = 'g', UNGRAB_POINTER = 'u', 
    NEW_SURFACE = 's', SHOW_SURFACE = 'S', 
    HIDE_SURFACE = 'H', RAISE_SURFACE = 'r', 
    LOWER_SURFACE = 'R', DESTROY_SURFACE = 'd', 
    MOVE_RESIZE = 'm', SET_TRANSIENT_FOR = 'p', 
    PUT_RGB = 'i', REQUEST_AUTH = 'l', 
    AUTH_OK = 'L', DISCONNECTED = 'D', 
    PUT_BUFFER = 'b', SET_SHOW_KEYBOARD = 'k'
"
j="
  BroadwayEventType* {.size: sizeof(cint), pure.} = enum 
    BUTTON_RELEASE = 'B',
    KEY_RELEASE = 'K',
    DELETE_NOTIFY = 'W', 
    BUTTON_PRESS = 'b', 
    SCREEN_SIZE_CHANGED = 'd',
    ENTER = 'e',
    FOCUS = 'f'
    GRAB_NOTIFY = 'g', 
    KEY_PRESS = 'k', 
    LEAVE = 'l', 
    POINTER_MOVE = 'm',
    SCROLL = 's',
    TOUCH = 't', 
    UNGRAB_NOTIFY = 'u',
    CONFIGURE_NOTIFY = 'w', 
  BroadwayOpType* {.size: sizeof(cint), pure.} = enum 
    DISCONNECTED = 'D', 
    HIDE_SURFACE = 'H',
    AUTH_OK = 'L',
    LOWER_SURFACE = 'R',
    SHOW_SURFACE = 'S', 
    PUT_BUFFER = 'b',
    DESTROY_SURFACE = 'd', 
    GRAB_POINTER = 'g',
    PUT_RGB = 'i',
    SET_SHOW_KEYBOARD = 'k'
    REQUEST_AUTH = 'l', 
    MOVE_RESIZE = 'm',
    SET_TRANSIENT_FOR = 'p', 
    RAISE_SURFACE = 'r', 
    NEW_SURFACE = 's',
    UNGRAB_POINTER = 'u', 
"
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='import
  glib, gobject, gdk_pixbuf, pango, cairo,
  x, xlib, windows
'
j='from glib import gint, gint8, gint16, gint32, gint64, guint, guint8, guint16, guint32, guint64, gulong, gshort, gchar, guchar, gdouble,
  gunichar, gboolean, gpointer, gconstpointer, GFALSE, GTRUE, G_PRIORITY_DEFAULT, G_PRIORITY_HIGH_IDLE, GDestroyNotify, GQuark, GSourceFunc

from gobject import GObject, GType, GValue, GCallback, GObjectClassObj

from gio import GIcon#, GOutputStream 

from gdk_pixbuf import GdkPixbuf

from cairo import Context, Font_options

from pango import LayoutLine, Layout, Context, Direction
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

# generate procs without get_ and set_ prefix
perl -0777 -p -i -e "s/(\n\s*)(proc set_)(\w+)(\*\([^}]*\) {[^}]*})/\$&\1proc \`\3=\`\4/sg" final.nim
perl -0777 -p -i -e "s/(\n\s*)(proc get_)(\w+)(\*\([^}]*\): \w[^}]*})/\$&\1proc \3\4/sg" final.nim

i='when defined(INSIDE_GDK_WIN32): 
  template gdk_window_hwnd*(win: expr): expr = 
    (GDK_WINDOW_IMPL_WIN32(win.impl).handle)

else: 
  template gdk_window_hwnd*(d: expr): expr = 
    (gdk_win32_window_get_handle(d))

when not(defined(WM_XBUTTONDOWN)): 
  const 
    WM_XBUTTONDOWN* = 0x0000020B
when not(defined(WM_XBUTTONUP)): 
  const 
    WM_XBUTTONUP* = 0x0000020C
when not(defined(get_xbutton_wparam)): 
  template get_xbutton_wparam*(w: expr): expr = 
    (HIWORD(w))

when not(defined(XBUTTON1)): 
  const 
    XBUTTON1* = 1
when not(defined(XBUTTON2)): 
  const 
    XBUTTON2* = 2
'
j='# when defined(INSIDE_GDK_WIN32): 
#template gdk_window_hwnd*(win: expr): expr = 
#  (GDK_WINDOW_IMPL_WIN32(win.impl).handle)

# else: 
template gdk_window_hwnd*(d: expr): expr = 
  (gdk_win32_window_get_handle(d))

# when not(defined(WM_XBUTTONDOWN)): 
const 
  WM_XBUTTONDOWN* = 0x0000020B
# when not(defined(WM_XBUTTONUP)): 
const 
  WM_XBUTTONUP* = 0x0000020C
# when not(defined(get_xbutton_wparam)): 
template get_xbutton_wparam*(w: expr): expr = 
  (HIWORD(w))

# when not(defined(XBUTTON1)): 
const 
  XBUTTON1* = 1
# when not(defined(XBUTTON2)): 
const 
  XBUTTON2* = 2
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='when not(defined(STRICT)): 
  const 
    STRICT* = true
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

i='when defined(INSIDE_GDK_WIN32) or defined(GDK_COMPILATION) or
    defined(GTK_COMPILATION):
'
j='when false: #when defined(INSIDE_GDK_WIN32) or defined(GDK_COMPILATION) or defined(GTK_COMPILATION):
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

sed -i 's/when defined(GTK_COMPILATION) or defined(GDK_COMPILATION):/when false: # &/g' final.nim

sed -i 's/when not(defined(GDK_MULTIDEVICE_SAFE)):/when not GDK_MULTIDEVICE_SAFE: # &/g' final.nim
sed -i 's/when defined(ENABLE_NLS):/when ENABLE_NLS: # &/g' final.nim
sed -i 's/when defined(INSIDE_GDK_WIN32):/when INSIDE_GDK_WIN32: # &/g' final.nim

i='when not(defined(NSINTEGER_DEFINED)): 
  type 
    NSInteger* = cint
    NSUInteger* = cuint
when not(defined(CGFLOAT_DEFINED)): 
  type 
    CGFloat* = cfloat
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

i='when defined(INSIDE_GDK_WIN32) or defined(GDK_COMPILATION) or
    defined(GTK_COMPILATION): 
  proc win32_icon_to_pixbuf_libgtk_only*(hicon: HICON; x_hot: ptr gdouble; 
      y_hot: ptr gdouble): gdk_pixbuf.GdkPixbuf {.
      importc: "gdk_win32_icon_to_pixbuf_libgtk_only", libgdk.}
  proc win32_pixbuf_to_hicon_libgtk_only*(pixbuf: gdk_pixbuf.GdkPixbuf): HICON {.
      importc: "gdk_win32_pixbuf_to_hicon_libgtk_only", libgdk.}
  proc win32_set_modal_dialog_libgtk_only*(window: HWND) {.
      importc: "gdk_win32_set_modal_dialog_libgtk_only", libgdk.}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

sed -i 's/\(dummy[0-9]\?\)\*/\1/g' final.nim
sed -i 's/\(reserved[0-9]\?\)\*/\1/g' final.nim

sed -i 's/[(][(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/(\1/g' final.nim
sed -i 's/, [(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/, \1/g' final.nim

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

perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( gdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( gdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( cint)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( cint)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( GdkModifierType)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( gboolean)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( GdkDragProtocol)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( GdkScrollDirection)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( cstring)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( guchar)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( gpointer)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( GdkAtom)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( GdkWMDecoration)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(\w+\*)?([(])([^)]* )(ptr)( GdkVisualType)/\1\2\3\4var\6/sg' final.nim

sed -i 's/: ptr var /: var ptr /g' final.nim
sed -i 's/\(0x\)0*\([0123456789ABCDEF]\)/\1\2/g' final.nim

ruby ../fix_object_of.rb final.nim

i='  BroadwayInputBaseMsgObj* = object 
    `type`*: guint32
'
j='  BroadwayInputBaseMsgObj{.inheritable, pure.} = object
    `type`*: guint32
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='  BroadwayReplyBaseObj* = object 
    size*: guint32
'
j='  BroadwayReplyBaseObj{.inheritable, pure.} = object
    size*: guint32
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='  BroadwayRequestBaseObj* = object 
    size*: guint32
'
j='  BroadwayRequestBaseObj{.inheritable, pure.} = object
    size*: guint32
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

fix2objof="GdkScreen GdkWindow GdkDisplay GdkDisplayManager GdkVisual GdkCursor GdkDragContext GdkGLContext GdkDevice GdkDeviceManager GdkFrameClock GdkKeymap"
for i in $fix2objof ; do
  sed -i "s/  ${i}Obj\* = object /  ${i}Obj\*{.final.} = object of GObject /g" final.nim
done

ruby ../mangler.rb final.nim GDK_
ruby ../mangler.rb final.nim Gdk

i='type 
  InputSource* {.size: sizeof(cint), pure.} = enum 
    SOURCE_MOUSE, SOURCE_PEN, SOURCE_ERASER, SOURCE_CURSOR, 
    SOURCE_KEYBOARD, SOURCE_TOUCHSCREEN, SOURCE_TOUCHPAD
type 
  InputMode* {.size: sizeof(cint), pure.} = enum 
    MODE_DISABLED, MODE_SCREEN, MODE_WINDOW
'
j='type 
  InputSource* {.size: sizeof(cint), pure.} = enum 
    MOUSE, PEN, ERASER, CURSOR, 
    KEYBOARD, TOUCHSCREEN, TOUCHPAD
type 
  InputMode* {.size: sizeof(cint), pure.} = enum 
    DISABLED, SCREEN, WINDOW
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='type 
  DragAction* {.size: sizeof(cint), pure.} = enum 
    ACTION_DEFAULT = 1 shl 0, ACTION_COPY = 1 shl 1, 
    ACTION_MOVE = 1 shl 2, ACTION_LINK = 1 shl 3, 
    ACTION_PRIVATE = 1 shl 4, ACTION_ASK = 1 shl 5
type 
  DragProtocol* {.size: sizeof(cint), pure.} = enum 
    PROTO_NONE = 0, PROTO_MOTIF, PROTO_XDND, 
    PROTO_ROOTWIN, PROTO_WIN32_DROPFILES, 
    PROTO_OLE2, PROTO_LOCAL, PROTO_WAYLAND
'
j='type 
  DragAction* {.size: sizeof(cint), pure.} = enum 
    DEFAULT = 1 shl 0, COPY = 1 shl 1, 
    MOVE = 1 shl 2, LINK = 1 shl 3, 
    PRIVATE = 1 shl 4, ASK = 1 shl 5
type 
  DragProtocol* {.size: sizeof(cint), pure.} = enum 
    NONE = 0, MOTIF, XDND, 
    ROOTWIN, WIN32_DROPFILES, 
    OLE2, LOCAL, WAYLAND
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='type 
  WindowAttributesType* {.size: sizeof(cint), pure.} = enum 
    WA_TITLE = 1 shl 1, WA_X = 1 shl 2, WA_Y = 1 shl 3, 
    WA_CURSOR = 1 shl 4, WA_VISUAL = 1 shl 5, 
    WA_WMCLASS = 1 shl 6, WA_NOREDIR = 1 shl 7, 
    WA_TYPE_HINT = 1 shl 8
type 
  WindowHints* {.size: sizeof(cint), pure.} = enum 
    HINT_POS = 1 shl 0, HINT_MIN_SIZE = 1 shl 1, 
    HINT_MAX_SIZE = 1 shl 2, HINT_BASE_SIZE = 1 shl 3, 
    HINT_ASPECT = 1 shl 4, HINT_RESIZE_INC = 1 shl 5, 
    HINT_WIN_GRAVITY = 1 shl 6, HINT_USER_POS = 1 shl 7, 
    HINT_USER_SIZE = 1 shl 8
'
j='type 
  WindowAttributesType* {.size: sizeof(cint), pure.} = enum 
    TITLE = 1 shl 1, X = 1 shl 2, Y = 1 shl 3, 
    CURSOR = 1 shl 4, VISUAL = 1 shl 5, 
    WMCLASS = 1 shl 6, NOREDIR = 1 shl 7, 
    TYPE_HINT = 1 shl 8
type 
  WindowHints* {.size: sizeof(cint), pure.} = enum 
    POS = 1 shl 0, MIN_SIZE = 1 shl 1, 
    MAX_SIZE = 1 shl 2, BASE_SIZE = 1 shl 3, 
    ASPECT = 1 shl 4, RESIZE_INC = 1 shl 5, 
    WIN_GRAVITY = 1 shl 6, USER_POS = 1 shl 7, 
    USER_SIZE = 1 shl 8
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='type 
  WMDecoration* {.size: sizeof(cint), pure.} = enum 
    DECOR_ALL = 1 shl 0, DECOR_BORDER = 1 shl 1, 
    DECOR_RESIZEH = 1 shl 2, DECOR_TITLE = 1 shl 3, 
    DECOR_MENU = 1 shl 4, DECOR_MINIMIZE = 1 shl 5, 
    DECOR_MAXIMIZE = 1 shl 6
type 
  WMFunction* {.size: sizeof(cint), pure.} = enum 
    FUNC_ALL = 1 shl 0, FUNC_RESIZE = 1 shl 1, 
    FUNC_MOVE = 1 shl 2, FUNC_MINIMIZE = 1 shl 3, 
    FUNC_MAXIMIZE = 1 shl 4, FUNC_CLOSE = 1 shl 5
'
j='type 
  WMDecoration* {.size: sizeof(cint), pure.} = enum 
    ALL = 1 shl 0, BORDER = 1 shl 1, 
    RESIZEH = 1 shl 2, TITLE = 1 shl 3, 
    MENU = 1 shl 4, MINIMIZE = 1 shl 5, 
    MAXIMIZE = 1 shl 6
type 
  WMFunction* {.size: sizeof(cint), pure.} = enum 
    ALL = 1 shl 0, RESIZE = 1 shl 1, 
    MOVE = 1 shl 2, MINIMIZE = 1 shl 3, 
    MAXIMIZE = 1 shl 4, CLOSE = 1 shl 5
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='type 
  OSXVersion* {.size: sizeof(cint), pure.} = enum 
    OSX_UNSUPPORTED = 0, OSX_MIN = 4, OSX_LEOPARD = 5, 
    OSX_SNOW_LEOPARD = 6, OSX_LION = 7, OSX_MOUNTAIN_LION = 8, 
    OSX_NEW = 99
const 
  OSX_TIGER = OSXVersion.OSX_MIN
  OSX_CURRENT = OSXVersion.OSX_MOUNTAIN_LION
'
j='type 
  OSXVersion* {.size: sizeof(cint), pure.} = enum 
    UNSUPPORTED = 0, MIN = 4, LEOPARD = 5, 
    SNOW_LEOPARD = 6, LION = 7, MOUNTAIN_LION = 8, 
    NEW = 99
const 
  OSX_TIGER = OSXVersion.MIN
  OSX_CURRENT = OSXVersion.MOUNTAIN_LION
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

sed  -i 's/\bPixbuf\b/GdkPixbuf/g' final.nim

i='const 
  GDKQUARTZ_H_INSIDE = true
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

# a few templates are calling procs -- fix names
i='template gdk_threads_enter*(): expr = 
  gdk_threads_enter()

template gdk_threads_leave*(): expr = 
  gdk_threads_leave()
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

i='template gdk_cursor_xdisplay*(cursor: expr): expr = 
  (gdk_x11_cursor_get_xdisplay(cursor))

template gdk_cursor_xcursor*(cursor: expr): expr = 
  (gdk_x11_cursor_get_xcursor(cursor))
'
j='template gdk_cursor_xdisplay*(cursor: expr): expr = 
  (x11_cursor_get_xdisplay(cursor))

template gdk_cursor_xcursor*(cursor: expr): expr = 
  (x11_cursor_get_xcursor(cursor))
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='template gdk_display_xdisplay*(display: expr): expr = 
  (gdk_x11_display_get_xdisplay(display))
'
j='template gdk_display_xdisplay*(display: expr): expr = 
  (x11_display_get_xdisplay(display))
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='template gdk_screen_xdisplay*(screen: expr): expr = 
  (gdk_x11_display_get_xdisplay(gdk_screen_get_display(screen)))

template gdk_screen_xscreen*(screen: expr): expr = 
  (gdk_x11_screen_get_xscreen(screen))

template gdk_screen_xnumber*(screen: expr): expr = 
  (gdk_x11_screen_get_screen_number(screen))
'
j='template gdk_screen_xdisplay*(screen: expr): expr = 
  (x11_display_get_xdisplay(display(screen)))

template gdk_screen_xscreen*(screen: expr): expr = 
  (x11_screen_get_xscreen(screen))

template gdk_screen_xnumber*(screen: expr): expr = 
  (x11_screen_get_screen_number(screen))
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='template gdk_root_window*(): expr = 
  (gdk_x11_get_default_root_xwindow())
'
j='const gdk_root_window* = x11_get_default_root_xwindow
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='template gdk_visual_xvisual*(visual: expr): expr = 
  (gdk_x11_visual_get_xvisual(visual))
'
j='template gdk_visual_xvisual*(visual: expr): expr = 
  (x11_visual_get_xvisual(visual))
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='template gdk_window_xdisplay*(win: expr): expr = 
  (gdk_display_xdisplay(gdk_window_get_display(win)))
'
j='template gdk_window_xdisplay*(win: expr): expr = 
  (gdk_display_xdisplay(display(win)))
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='template gdk_window_xid*(win: expr): expr = 
  (gdk_x11_window_get_xid(win))
'
j='template gdk_window_xid*(win: expr): expr = 
  (x11_window_get_xid(win))
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='const 
  GL_ERROR* = (gdk_gl_error_quark())
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

# temporary fix to be compatible with 0
i='type 
  ModifierType* {.size: sizeof(cint), pure.} = enum 
'
j='type
  ModifierType* {.size: sizeof(cint), pure.} = enum 
    NONE = 0, 
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

# some procs with get_ prefix do not return something but need var objects instead of pointers:
# vim search term for candidates: proc get_.*\n\?.*\n\?.*) {
i='proc get_monitor_geometry*(screen: Screen; 
                                      monitor_num: gint; 
                                      dest: Rectangle) {.
    importc: "gdk_screen_get_monitor_geometry", libgdk.}
proc get_monitor_workarea*(screen: Screen; 
                                      monitor_num: gint; 
                                      dest: Rectangle) {.
    importc: "gdk_screen_get_monitor_workarea", libgdk.}
'
j='proc get_monitor_geometry*(screen: Screen; 
                                      monitor_num: gint; 
                                      dest: var RectangleObj) {.
    importc: "gdk_screen_get_monitor_geometry", libgdk.}
proc get_monitor_workarea*(screen: Screen; 
                                      monitor_num: gint; 
                                      dest: var RectangleObj) {.
    importc: "gdk_screen_get_monitor_workarea", libgdk.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_frame_extents*(window: Window; 
                                   rect: Rectangle) {.
    importc: "gdk_window_get_frame_extents", libgdk.}
'
j='proc get_frame_extents*(window: Window; 
                                   rect: var RectangleObj) {.
    importc: "gdk_window_get_frame_extents", libgdk.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

# now separate the x11, win32, wayland, broadway, quartz, mir sub-modules.
# first we remove the list with deprecated entries from main file -- we add it later again.
i='{\.deprecated: \[PGdkX11'
csplit final.nim "/$i/"

mv xx00 final.nim
i='{\.deprecated: \['
csplit final.nim "/$i/"
mv xx00 final.nim
mv xx01 dep.txt

# cut mir module
### "gdk/mir/gdkmir.h"
i='### ["]gdk[/]mir.*'
csplit final.nim "/$i/"
mv xx00 final.nim
j='{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from gobject import GType

type # unity mir dummy objects
  MirConnection* = object
  MirSurface* = object
'
perl -0777 -p -i -e "s~$i~$j~" xx01
sed -i "\~$i~d" xx01
cat -s xx01 > gdk3_mir.nim

# cut broadway module
### "gdk/broadway/gdkbroadwaydisplay.h"
i='### ["]gdk[/]broadway.*'
csplit final.nim "/$i/"
mv xx00 final.nim
j='{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from glib import guint8, guint32, guint64, gint, gint32, gboolean

from cairo import Surface, Region

from gobject import GType

from gio import GOutputStream

type # broadway dummy objects
  BroadwayBuffer* = object
  BroadwayServer* = object
  BroadwayOutput* = object
'
perl -0777 -p -i -e "s~$i~$j~" xx01
sed -i "\~$i~d" xx01
cat -s xx01 > gdk3_broadway.nim

# cut quartz module
### "gdk/quartz/gdkquartz.h"
i='### ["]gdk[/]quartz.*'
csplit final.nim "/$i/"
mv xx00 final.nim
j='{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from glib import guint, gunichar

from gobject import GType

from gdk_pixbuf import GdkPixbuf

type # macosx quartz dummy objects
  NSString* = object
  NSImage* = object
  NSEvent* = object
  NSWindow* = object
  NSView* = object
  id* = culong 
'
perl -0777 -p -i -e "s~$i~$j~" xx01
sed -i "\~$i~d" xx01
cat -s xx01 > gdk3_quartz.nim

# cut wayland module
### "gdk/wayland/gdkwaylanddevice.h"
i='### ["]gdk[/]wayland.*'
csplit final.nim "/$i/"
mv xx00 final.nim
j='{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from gobject import GType

from glib import gint

type # wayland dummy objects
  wl_seat* = object
  wl_pointer* = object
  wl_keyboard* = object
  wl_display* = object
  wl_compositor* = object
  wl_surface* = object
  xdg_shell* = object
'
perl -0777 -p -i -e "s~$i~$j~" xx01
sed -i "\~$i~d" xx01
cat -s xx01 > gdk3_wayland.nim

# cut win32 module
### "gdk/win32/gdkwin32cursor.h"
i='### ["]gdk[/]win32.*'
csplit final.nim "/$i/"
mv xx00 final.nim
j='{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from windows import HWND, HGDIOBJ

from glib import gint, gpointer, gboolean

from gobject import GType
'
perl -0777 -0777 -p -i -e "s~$i~$j~" xx01
sed -i "\~$i~d" xx01
cat -s xx01 > gdk3_win32.nim

# cut x11 module
### "gdk/x11/gdkx11applaunchcontext.h"
i='### ["]gdk[/]x11.*'
csplit final.nim "/$i/"
mv xx00 final.nim
j='{.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk3

from glib import gint, guint, guint32, guchar, gboolean

from gobject import GType

from x import TCursor

from xlib import TDisplay, TScreen, TVisual
'
perl -0777 -p -i -e "s~$i~$j~" xx01
sed -i "\~$i~d" xx01
cat -s xx01 > gdk3_x11.nim

sed -i '/### "gdk/d' final.nim

sed -i 's/ptr cstring/cstringArray/g' final.nim

ruby ../gen_proc_dep.rb final.nim

# procs depending on when statement
sed -i '/{\.deprecated: \[gdk_display_pointer_ungrab: pointer_ungrab\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_display_keyboard_ungrab: keyboard_ungrab\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_display_pointer_is_grabbed: pointer_is_grabbed\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_display_get_window_at_pointer: window_at_pointer\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_display_warp_pointer: warp_pointer\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_pointer_grab: pointer_grab\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_keyboard_grab: keyboard_grab\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_pointer_ungrab: pointer_ungrab\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_threads_enter: threads_enter\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_threads_leave: threads_leave\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_keyboard_ungrab: keyboard_ungrab\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_pointer_is_grabbed: pointer_is_grabbed\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_window_at_pointer: window_at_pointer\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_display_get_pointer: get_pointer\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_display_get_window_at_pointer: get_window_at_pointer\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gdk_window_get_pointer: get_pointer\]\.}/d' proc_dep_list
cp dep.txt dep1.txt
sed -i 's/Gdk//g' dep1.txt
cat dep1.txt >> final.nim

cp dep.txt dep1.txt
sed -i 's/PGdk/Gdk/g' dep1.txt
sed -i 's/TGdk\(\w\+\)/Gdk\1Obj/g' dep1.txt
cat dep1.txt >> final.nim

cat dep.txt >> final.nim
cat proc_dep_list >> final.nim

cat -s final.nim > gdk3.nim

exit

