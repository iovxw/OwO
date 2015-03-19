#!/bin/bash
# S. Salewski, 05-MAR-2015
# Generate ATK bindings for Nim -- this is for latest atk 2.15.4
#
atk_dir="/home/stefan/Downloads/atk-2.15.4"
final="final.h" # the input file for c2nim
list="list.txt"
wdir="tmp"

targets=''
all_t=". ${targets}"

rm -rf $wdir # start from scratch
mkdir $wdir
cd $wdir
cp -r $atk_dir/atk .
cd atk

# check already done for atk 2.15.4...
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

cat atk.h > all.h

cd ..

# cpp run with all headers to determine order
echo "cat \\" > $list

cpp -I. `pkg-config --cflags gtk+-3.0` atk/all.h $final

# extract file names and push names to list
grep ssalewski $final | sed 's/_ssalewski;/ \\/' >> $list

# maybe add remaining missing headers

i=`uniq -d $list | wc -l`
if [ $i != 0 ]; then echo 'list contains duplicates!'; exit; fi;

# now we work again with original headers
rm -rf atk
cp -r $atk_dir/atk . 

# insert for each header file its name as first line
for j in $all_t ; do
  for i in atk/${j}/*.h; do
    sed -i "1i/* file: $i */" $i
    sed -i "1i#define headerfilename \"$i\"" $i # marker for splitting
  done
done
cd atk
  bash ../$list > ../$final
cd ..

# delete strange macros (define these as empty ones for c2nim)
sed -i "1i#def G_BEGIN_DECLS" $final
sed -i "1i#def G_END_DECLS" $final
sed -i "1i#def ATK_AVAILABLE_IN_2_2" $final
sed -i "1i#def ATK_AVAILABLE_IN_2_8" $final
sed -i "1i#def ATK_AVAILABLE_IN_2_10" $final
sed -i "1i#def ATK_AVAILABLE_IN_2_12" $final
sed -i "1i#def ATK_AVAILABLE_IN_ALL" $final
sed -i "1i#def ATK_DEPRECATED_FOR(x)" $final
sed -i "1i#def ATK_DEPRECATED_IN_2_10" $final
sed -i "1i#def ATK_DEPRECATED_IN_2_12" $final
sed -i "1i#def ATK_DEPRECATED_IN_2_8_FOR(x)" $final
sed -i "1i#def ATK_DEPRECATED_IN_2_10_FOR(x)" $final
sed -i "1i#def ATK_DEPRECATED_IN_2_12_FOR(x)" $final
sed -i "1i#def ATK_DEPRECATED" $final

# we should not need these macros
sed -i '/#define ATK_DEFINE_TYPE(TN, t_n, T_P)			       ATK_DEFINE_TYPE_EXTENDED (TN, t_n, T_P, 0, {})/d' $final
sed -i '/#define ATK_DEFINE_TYPE_WITH_CODE(TN, t_n, T_P, _C_)	      _ATK_DEFINE_TYPE_EXTENDED_BEGIN (TN, t_n, T_P, 0) {_C_;} _ATK_DEFINE_TYPE_EXTENDED_END()/d' $final
sed -i '/#define ATK_DEFINE_ABSTRACT_TYPE(TN, t_n, T_P)		       ATK_DEFINE_TYPE_EXTENDED (TN, t_n, T_P, G_TYPE_FLAG_ABSTRACT, {})/d' $final
sed -i '/#define ATK_DEFINE_ABSTRACT_TYPE_WITH_CODE(TN, t_n, T_P, _C_) _ATK_DEFINE_TYPE_EXTENDED_BEGIN (TN, t_n, T_P, G_TYPE_FLAG_ABSTRACT) {_C_;} _ATK_DEFINE_TYPE_EXTENDED_END()/d' $final
sed -i '/#define ATK_DEFINE_TYPE_EXTENDED(TN, t_n, T_P, _f_, _C_)      _ATK_DEFINE_TYPE_EXTENDED_BEGIN (TN, t_n, T_P, _f_) {_C_;} _ATK_DEFINE_TYPE_EXTENDED_END()/d' $final

i='#define _ATK_DEFINE_TYPE_EXTENDED_BEGIN(TypeName, type_name, TYPE, flags) \
\
static void     type_name##_init              (TypeName        *self); \
static void     type_name##_class_init        (TypeName##Class *klass); \
static gpointer type_name##_parent_class = NULL; \
static void     type_name##_class_intern_init (gpointer klass) \
{ \
  type_name##_parent_class = g_type_class_peek_parent (klass); \
  type_name##_class_init ((TypeName##Class*) klass); \
} \
\
ATK_AVAILABLE_IN_ALL \
GType \
type_name##_get_type (void) \
{ \
  static volatile gsize g_define_type_id__volatile = 0; \
  if (g_once_init_enter (&g_define_type_id__volatile))  \
    { \
      AtkObjectFactory *factory; \
      GType derived_type; \
      GTypeQuery query; \
      GType derived_atk_type; \
      GType g_define_type_id; \
\
      /* Figure out the size of the class and instance we are deriving from */ \
      derived_type = g_type_parent (TYPE); \
      factory = atk_registry_get_factory (atk_get_default_registry (), \
                                          derived_type); \
      derived_atk_type = atk_object_factory_get_accessible_type (factory); \
      g_type_query (derived_atk_type, &query); \
\
      g_define_type_id = \
        g_type_register_static_simple (derived_atk_type, \
                                       g_intern_static_string (#TypeName), \
                                       query.class_size, \
                                       (GClassInitFunc) type_name##_class_intern_init, \
                                       query.instance_size, \
                                       (GInstanceInitFunc) type_name##_init, \
                                       (GTypeFlags) flags); \
      { /* custom code follows */
#define _ATK_DEFINE_TYPE_EXTENDED_END()	\
        /* following custom code */	\
      }					\
      g_once_init_leave (&g_define_type_id__volatile, g_define_type_id); \
    }					\
  return g_define_type_id__volatile;	\
} /* closes type_name##_get_type() */
'
perl -0777 -p -i -e "s%\Q$i\E%%s" $final

i='#ifndef ATK_VAR
#  ifdef G_PLATFORM_WIN32
#    ifdef ATK_STATIC_COMPILATION
#      define ATK_VAR extern
#    else /* !ATK_STATIC_COMPILATION */
#      ifdef ATK_COMPILATION
#        ifdef DLL_EXPORT
#          define ATK_VAR _ATK_EXTERN
#        else /* !DLL_EXPORT */
#          define ATK_VAR extern
#        endif /* !DLL_EXPORT */
#      else /* !ATK_COMPILATION */
#        define ATK_VAR extern __declspec(dllimport)
#      endif /* !ATK_COMPILATION */
#    endif /* !ATK_STATIC_COMPILATION */
#  else /* !G_PLATFORM_WIN32 */
#    define ATK_VAR _ATK_EXTERN
#  endif /* !G_PLATFORM_WIN32 */
#endif /* ATK_VAR */
'
perl -0777 -p -i -e "s%\Q$i\E%%s" $final
sed -i '/ATK_VAR AtkMisc \*atk_misc_instance;/d' $final

i='#if defined(ATK_DISABLE_SINGLE_INCLUDES) && !defined (__ATK_H_INSIDE__) && !defined (ATK_COMPILATION)
#error "Only <atk/atk.h> can be included directly."
#endif
'
perl -0777 -p -i -e "s%\Q$i\E%%sg" $final

# this is generated by find_opaque_structs.rb
sed -i 's/typedef struct _AtkImplementor            AtkImplementor;/typedef struct _AtkImplementor{} AtkImplementor;/' final.h
sed -i 's/typedef struct _AtkAction AtkAction;/typedef struct _AtkAction{} AtkAction;/' final.h
sed -i 's/typedef struct _AtkComponent AtkComponent;/typedef struct _AtkComponent{} AtkComponent;/' final.h
sed -i 's/typedef struct _AtkDocument AtkDocument;/typedef struct _AtkDocument{} AtkDocument;/' final.h
sed -i 's/typedef struct _AtkText AtkText;/typedef struct _AtkText{} AtkText;/' final.h
sed -i 's/typedef struct _AtkEditableText AtkEditableText;/typedef struct _AtkEditableText{} AtkEditableText;/' final.h
sed -i 's/typedef struct _AtkHyperlinkImpl AtkHyperlinkImpl;/typedef struct _AtkHyperlinkImpl{} AtkHyperlinkImpl;/' final.h
sed -i 's/typedef struct _AtkHypertext AtkHypertext;/typedef struct _AtkHypertext{} AtkHypertext;/' final.h
sed -i 's/typedef struct _AtkImage AtkImage;/typedef struct _AtkImage{} AtkImage;/' final.h
sed -i 's/typedef struct _AtkRange AtkRange;/typedef struct _AtkRange{} AtkRange;/' final.h
sed -i 's/typedef struct _AtkSelection AtkSelection;/typedef struct _AtkSelection{} AtkSelection;/' final.h
sed -i 's/typedef struct _AtkStreamableContent AtkStreamableContent;/typedef struct _AtkStreamableContent{} AtkStreamableContent;/' final.h
sed -i 's/typedef struct _AtkTable AtkTable;/typedef struct _AtkTable{} AtkTable;/' final.h
sed -i 's/typedef struct _AtkTableCell AtkTableCell;/typedef struct _AtkTableCell{} AtkTableCell;/' final.h
sed -i 's/typedef struct _AtkValue AtkValue;/typedef struct _AtkValue{} AtkValue;/' final.h
sed -i 's/typedef struct _AtkWindow AtkWindow;/typedef struct _AtkWindow{} AtkWindow;/' final.h

ruby ../fix_.rb $final

# header for Nim module
i='#ifdef __INCREASE_TMP_INDENT__
#ifdef C2NIM
#  dynlib lib
#endif
#endif
'
perl -0777 -p -i -e "s/^/$i/" $final

ruby ../fix_gtk_type.rb final.h ATK_

i='#ifndef _TYPEDEF_ATK_ACTION_
#define _TYPEDEF_ATK_ACTION_
typedef struct _AtkAction{} AtkAction;
#endif
'
j='typedef struct _AtkAction{} AtkAction;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_UTIL_
#define _TYPEDEF_ATK_UTIL_
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#ifndef _TYPEDEF_ATK_COMPONENT_
#define _TYPEDEF_ATK_COMPONENT_
typedef struct _AtkComponent{} AtkComponent;
#endif
'
j='typedef struct _AtkComponent{} AtkComponent;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_DOCUMENT_
#define _TYPEDEF_ATK_DOCUMENT_
typedef struct _AtkDocument{} AtkDocument;
#endif
'
j='typedef struct _AtkDocument{} AtkDocument;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_TEXT_
#define _TYPEDEF_ATK_TEXT_
typedef struct _AtkText{} AtkText;
#endif
'
j='typedef struct _AtkText{} AtkText;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_EDITABLE_TEXT_
#define _TYPEDEF_ATK_EDITABLE_TEXT_
typedef struct _AtkEditableText{} AtkEditableText;
#endif
'
j='typedef struct _AtkEditableText{} AtkEditableText;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_HYPERLINK_IMPL_
#define _TYPEDEF_ATK_HYPERLINK_IMPL__

/**
 * AtkHyperlinkImpl:
 *
 * A queryable interface which allows AtkHyperlink instances
 * associated with an AtkObject to be obtained.  AtkHyperlinkImpl
 * corresponds to AT-SPI'\''s Hyperlink interface, and differs from
 * AtkHyperlink in that AtkHyperlink is an object type, rather than an
 * interface, and thus cannot be directly queried. FTW
 */
typedef struct AtkHyperlinkImpl{} AtkHyperlinkImpl;
#endif
'
j='typedef struct AtkHyperlinkImpl{} AtkHyperlinkImpl;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_HYPERTEXT_
#define _TYPEDEF_ATK_HYPERTEXT_
typedef struct _AtkHypertext{} AtkHypertext;
#endif
'
j='typedef struct _AtkHypertext{} AtkHypertext;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_IMAGE_
#define _TYPEDEF_ATK_IMAGE_
typedef struct _AtkImage{} AtkImage;
#endif
'
j='typedef struct _AtkImage{} AtkImage;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_SELECTION_
#define _TYPEDEF_ATK_SELECTION_
typedef struct _AtkSelection{} AtkSelection;
#endif
'
j='typedef struct _AtkSelection{} AtkSelection;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_TABLE_CELL_
#define _TYPEDEF_ATK_TABLE_CELL_
typedef struct _AtkTableCell{} AtkTableCell;
#endif
'
j='typedef struct _AtkTableCell{} AtkTableCell;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_STREAMABLE_CONTENT
#define _TYPEDEF_ATK_STREAMABLE_CONTENT
typedef struct _AtkStreamableContent{} AtkStreamableContent;
#endif
'
j='typedef struct _AtkStreamableContent{} AtkStreamableContent;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_TABLE_
#define _TYPEDEF_ATK_TABLE_
typedef struct _AtkTable{} AtkTable;
#endif
'
j='typedef struct _AtkTable{} AtkTable;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef _TYPEDEF_ATK_MISC_
#define _TYPEDEF_ATK_MISC_
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#ifndef _TYPEDEF_ATK_VALUE_
#define _TYPEDEF_ATK_VALUE__
typedef struct _AtkValue{} AtkValue;
#endif
'
j='typedef struct _AtkValue{} AtkValue;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

sed -i 's/\bgchar\b/char/g' $final
c2nim097 --skipcomments --skipinclude $final

sed -i -f gtk_type_sedlist final.nim

#perl -0777 -p -i -e "s~([=:] proc \(.*?\)(?:: (?:ptr )?\w+)?)~\1 {.cdecl.}~sg" final.nim
perl -0777 -p -i -e "s~([=:] proc \(.*?\)(?:: (?:ptr ){0,2}\w+)?)~\1 {.cdecl.}~sg" final.nim

# we use our own defined pragma
sed -i "s/\bdynlib: lib\b/libatk/g" final.nim

ruby ../remdef.rb final.nim

i='const 
  headerfilename* = '
perl -0777 -p -i -e "s~\Q$i\E~  ### ~sg" final.nim

sed -i '1d' final.nim
sed -i 's/^  //' final.nim

i=' {.deadCodeElim: on.}'
j='{.deadCodeElim: on.}

when defined(windows):
  const LIB_ATK = "libatk-1.0-0.dll"
elif defined(macosx):
  const LIB_ATK = "libatk-1.0(|-0).dylib"
else:
  const LIB_ATK = "libatk-1.0.so(|.0)"

{.pragma: libatk, cdecl, dynlib: LIB_ATK.}

IMPORTLIST

'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

#ruby ../fix_new.rb final.nim

sed -i 's/  AtkAttributeSet\* = GSList/  AtkAttributeSet* = object /' final.nim
ruby ../glib_fix_T.rb final.nim atk Atk
sed -i 's/  AtkAttributeSetObj\* = object /  AtkAttributeSetObj* = GSList/' final.nim

sed -i 's/\*: var /*: ptr /g' final.nim
sed -i 's/): var /): ptr /g' final.nim

ruby ../glib_fix_proc.rb final.nim

perl -0777 -p -i -e "s/(\n\s*)(proc )(\w+)(\*\([^}]*va_list[^}]*\)[^}]*{[^}]*})/\ndiscard \"\"\"\$&\n\"\"\"/sg" final.nim

sed -i 's/\bproc ref\b/proc `ref`/g' final.nim
sed -i 's/\bproc object\b/proc `object`/g' final.nim
sed -i 's/\bproc export\b/proc `export`/g' final.nim
sed -i 's/\bproc bind\b/proc `bind`/g' final.nim
sed -i 's/\bproc block\b/proc `block`/g' final.nim

sed -i 's/\bATK_TEXT_ATTR_/ATK_TEXT_ATTRIBUTE_/g' final.nim
ruby ../glib_fix_enum_prefix.rb final.nim

# procs starting with underscore should be privat
perl -0777 -p -i -e "s~proc _\w+\*?\(.*?\}~~sg" final.nim

ruby ../underscorefix.rb final.nim

sed -i -f ../glib_sedlist final.nim
sed -i -f ../gobject_sedlist final.nim

ruby ../fix_template.rb final.nim
ruby ../fix_object_of.rb final.nim

i='
from glib import guint64, GSListObj, gboolean, gint, guint, guint16, guint32, gpointer, gdouble, gunichar

from gobject import GValue, GValueObj, GSignalEmissionHook, GType, GObject, GObjectObj, GObjectClassObj, GTypeInterfaceObj
'
perl -0777 -p -i -e "s%IMPORTLIST%$i%s" final.nim

i='type 
  AtkFunction* = proc (user_data: gpointer): gboolean {.cdecl.}
type 
  AtkPropertyChangeHandler* = proc (obj: AtkObject; 
                                    vals: AtkPropertyValues) {.cdecl.}
'
j='type 
  AtkRelationSet* =  ptr AtkRelationSetObj
  AtkRelationSetPtr* = ptr AtkRelationSetObj
  AtkRelationSetObj*{.final.} = object of gobject.GObjectObj
    relations*: glib.GPtrArray
'
k='type 
  AtkObject* =  ptr AtkObjectObj
  AtkObjectPtr* = ptr AtkObjectObj
  AtkObjectObj*{.final.} = object of gobject.GObjectObj
    description*: cstring
    name*: cstring
    accessible_parent*: AtkObject
    role*: AtkRole
    relation_set*: AtkRelationSet
    layer*: AtkLayer
'
perl -0777 -p -i -e "s%\Q$j\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$k\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$i\E%$j$k$i%s" final.nim

i='type 
  AtkObjectClass* =  ptr AtkObjectClassObj
'
j='type 
  AtkStateSet* =  ptr AtkStateSetObj
  AtkStateSetPtr* = ptr AtkStateSetObj
  AtkStateSetObj*{.final.} = object of gobject.GObjectObj
'
perl -0777 -p -i -e "s%\Q$j\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$i\E%$j$i%s" final.nim

i='type 
  AtkKeySnoopFunc* = proc (event: AtkKeyEventStruct; user_data: gpointer): gint {.cdecl.}
'
j='type 
  AtkKeyEventStruct* =  ptr AtkKeyEventStructObj
  AtkKeyEventStructPtr* = ptr AtkKeyEventStructObj
  AtkKeyEventStructObj* = object 
    `type`*: gint
    state*: guint
    keyval*: guint
    length*: gint
    string*: cstring
    keycode*: guint16
    timestamp*: guint32
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$j\E%$j$i%s" final.nim

sed -i 's/  AtkObjectObj\*{\.final\.} = object of gobject\.GObjectObj/  AtkObjectObj* = object of gobject.GObjectObj/' final.nim
sed -i 's/  AtkObjectClassObj\*{\.final\.} = object of gobject\.GObjectClassObj/  AtkObjectClassObj* = object of gobject.GObjectClassObj/' final.nim
sed -i 's/  AtkObjectFactoryObj\*{\.final\.} = object of gobject\.GObjectObj/  AtkObjectFactoryObj* = object of gobject.GObjectObj/' final.nim
sed -i 's/  AtkObjectFactoryClassObj\*{\.final\.} = object of gobject\.GObjectClassObj/  AtkObjectFactoryClassObj* = object of gobject.GObjectClassObj/' final.nim

perl -0777 -p -i -e "s%\Q    pad1*: AtkFunction\E%    pad01*: AtkFunction%s" final.nim

#ruby ../fix_reserved.rb final.nim

# do not export priv and reserved
sed -i "s/\( priv[0-9]\?[0-9]\?[0-9]\?\)\*: /\1: /g" final.nim
sed -i "s/\(reserved[0-9]\?[0-9]\?[0-9]\?\)\*: /\1: /g" final.nim

# generate procs without get_ and set_ prefix
perl -0777 -p -i -e "s/(\n\s*)(proc set_)(\w+)(\*\([^}]*\) {[^}]*})/\$&\1proc \`\3=\`\4/sg" final.nim
perl -0777 -p -i -e "s/(\n\s*)(proc get_)(\w+)(\*\([^}]*\): \w[^}]*})/\$&\1proc \3\4/sg" final.nim

sed -i 's/\bproc object\b/proc `object`/g' final.nim
sed -i 's/\bproc type\b/proc `type`/g' final.nim

sed -i 's/\(dummy[0-9]\{0,2\}\)\*/\1/g' final.nim
sed -i 's/\(reserved[0-9]\{0,2\}\)\*/\1/g' final.nim

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
sed -i 's/\bG_TYPE_INSTANCE_GET_INTERFACE\b/\L&/g' final.nim

sed -i 's/ptr cstring/cstringArray/g' final.nim

# yes, call multiple times!
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gfloat)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gfloat)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gboolean)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( guchar)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gpointer)/\1\2\3\4var\6/sg' final.nim

sed -i 's/: ptr var /: var ptr /g' final.nim
sed -i 's/\(0x\)0*\([0123456789ABCDEF]\)/\1\2/g' final.nim

sed -i "s/\(^\s*proc \)atk_/\1/g" final.nim

# some procs with get_ prefix do not return something but need var objects instead of pointers:
# vim search term for candidates: proc get_.*\n\?.*\n\?.*) {
i='proc get_range_extents*(text: AtkText; start_offset: gint; 
                                 end_offset: gint; coord_type: AtkCoordType; 
                                 rect: AtkTextRectangle) {.
    importc: "atk_text_get_range_extents", libatk.}
'
j='proc get_range_extents*(text: AtkText; start_offset: gint; 
                                 end_offset: gint; coord_type: AtkCoordType; 
                                 rect: var AtkTextRectangleObj) {.
    importc: "atk_text_get_range_extents", libatk.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_current_value*(obj: AtkValue; value: gobject.GValue) {.
    importc: "atk_value_get_current_value", libatk.}
'
j='proc get_current_value*(obj: AtkValue; value: var gobject.GValueObj) {.
    importc: "atk_value_get_current_value", libatk.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_maximum_value*(obj: AtkValue; value: gobject.GValue) {.
    importc: "atk_value_get_maximum_value", libatk.}
'
j='proc get_maximum_value*(obj: AtkValue; value: var gobject.GValueObj) {.
    importc: "atk_value_get_maximum_value", libatk.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_minimum_value*(obj: AtkValue; value: gobject.GValue) {.
    importc: "atk_value_get_minimum_value", libatk.}
'
j='proc get_minimum_value*(obj: AtkValue; value: var gobject.GValueObj) {.
    importc: "atk_value_get_minimum_value", libatk.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_minimum_increment*(obj: AtkValue; value: var gobject.GValueObj) {.
    importc: "atk_value_get_minimum_increment", libatk.}
'
j='proc get_minimum_increment*(obj: AtkValue; value: gobject.GValue) {.
    importc: "atk_value_get_minimum_increment", libatk.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

# remove the list with deprecated entries from main file -- we add it later again.
i='{\.deprecated: \['
csplit final.nim "/$i/"
mv xx00 final.nim
mv xx01 dep.txt

ruby ../mangler.rb final.nim Atk
#ruby ../mangler.rb final.nim ATK_

sed -i '/### "atk/d' final.nim
ruby ../gen_proc_dep.rb final.nim

cat dep.txt >> final.nim
cat proc_dep_list >> final.nim

sed -i 's/ $//g' final.nim
sed -i 's/\bgobject\.GValue\b/GValue/g' final.nim
sed -i 's/\bgobject\.GTypeInterfaceObj\b/GTypeInterfaceObj/g' final.nim

cat -s final.nim > atk.nim

rm final.h list.txt dep.txt final.nim proc_dep_list
rm -r atk

exit

