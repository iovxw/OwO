#!/bin/bash
# S. Salewski, 17-FEB-2015
# generate gobject bindings for Nim -- this is for glib headers 2.42.1
#
glib_dir="/home/stefan/Downloads/glib-2.42.1"
final="final.h" # the input file for c2nim
list="list.txt"
wdir="tmp_gobj"

targets=''
all_t=". ${targets}"

rm -rf $wdir # start from scratch
mkdir $wdir
cd $wdir
cp -r $glib_dir/gobject .
cd gobject

# indeed we missed ...
echo 'we may miss these headers -- please check:'
for i in $all_t ; do
  grep -c DECL ${i}/*.h | grep h:0
done

# we insert in each header a marker with the filename
# may fail if G_BEGIN_DECLS macro is missing in a header
for j in $all_t ; do
  for i in ${j}/*.h; do
    sed -i "/^G_BEGIN_DECLS/a${i}_ssalewski;" $i
  done
done

# caution: main file glib-object is in directory glib
cd ..
cat $glib_dir/glib/glib-object.h > all.h

# cpp run with all headers to determine order
echo "cat \\" > $list

cpp -I. `pkg-config --cflags gtk+-3.0` all.h $final

# extract file names and push names to list
grep ssalewski $final | sed 's/_ssalewski;/ \\/' >> $list

i=`uniq -d $list | wc -l`
if [ $i != 0 ]; then echo 'list contains duplicates!'; exit; fi;

# now we work again with original headers
rm -rf gobject
cp -r $glib_dir/gobject . 

# insert for each header file its name as first line
for j in $all_t ; do
  for i in gobject/${j}/*.h; do
    sed -i "1i/* file: $i */" $i
  done
done
cd gobject
  bash ../$list > ../$final
cd ..

# delete strange macros (define as empty)
# we restrict use of wildcards to limit risc of damage something!
for i in 30 34 36 38 40 42 ; do
  sed -i "1i#def GLIB_AVAILABLE_IN_2_$i" $final
done

sed -i "1i#def GLIB_DEPRECATED_IN_2_32_FOR(x)" $final
sed -i "1i#def GLIB_DEPRECATED_IN_2_36" $final
sed -i "1i#def GLIB_DEPRECATED" $final
sed -i "1i#def G_BEGIN_DECLS" $final
sed -i "1i#def G_END_DECLS" $final
sed -i "1i#def GLIB_DEPRECATED_FOR(i)" $final
sed -i "1i#def GLIB_AVAILABLE_IN_ALL" $final
sed -i "1i#def G_GNUC_CONST" $final
sed -i "1i#def G_GNUC_PURE" $final
sed -i "1i#def G_GNUC_NULL_TERMINATED" $final

# complicated macros -- we will care when we really should need them...
# maybe expanding by cpp preprocessor first and then manually converting to Nim?
sed -i '/#define G_DEFINE_TYPE(TN, t_n, T_P)			    G_DEFINE_TYPE_EXTENDED (TN, t_n, T_P, 0, {})/d' $final
sed -i '/#define G_DEFINE_TYPE_WITH_CODE(TN, t_n, T_P, _C_)	    _G_DEFINE_TYPE_EXTENDED_BEGIN (TN, t_n, T_P, 0) {_C_;} _G_DEFINE_TYPE_EXTENDED_END()/d' $final
sed -i '/#define G_DEFINE_ABSTRACT_TYPE(TN, t_n, T_P)		    G_DEFINE_TYPE_EXTENDED (TN, t_n, T_P, G_TYPE_FLAG_ABSTRACT, {})/d' $final
sed -i '/#define G_DEFINE_ABSTRACT_TYPE_WITH_CODE(TN, t_n, T_P, _C_) _G_DEFINE_TYPE_EXTENDED_BEGIN (TN, t_n, T_P, G_TYPE_FLAG_ABSTRACT) {_C_;} _G_DEFINE_TYPE_EXTENDED_END()/d' $final
sed -i '/#define G_DEFINE_TYPE_EXTENDED(TN, t_n, T_P, _f_, _C_)	    _G_DEFINE_TYPE_EXTENDED_BEGIN (TN, t_n, T_P, _f_) {_C_;} _G_DEFINE_TYPE_EXTENDED_END()/d' $final
sed -i '/#define G_DEFINE_INTERFACE(TN, t_n, T_P)		    G_DEFINE_INTERFACE_WITH_CODE(TN, t_n, T_P, ;)/d' $final
sed -i '/#define G_DEFINE_INTERFACE_WITH_CODE(TN, t_n, T_P, _C_)     _G_DEFINE_INTERFACE_EXTENDED_BEGIN(TN, t_n, T_P) {_C_;} _G_DEFINE_INTERFACE_EXTENDED_END()/d' $final

sed -i "s/#if     GLIB_SIZEOF_SIZE_T != GLIB_SIZEOF_LONG || !defined __cplusplus/#if GLIB_SIZEOF_SIZE_T != GLIB_SIZEOF_LONG || !defined(__cplusplus)/g" $final

# delete some strange macros
i='#define G_ADD_PRIVATE(TypeName) { \
  TypeName##_private_offset = \
    g_type_add_instance_private (g_define_type_id, sizeof (TypeName##Private)); \
}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#define G_PRIVATE_OFFSET(TypeName, field) \
  (TypeName##_private_offset + (G_STRUCT_OFFSET (TypeName##Private, field)))
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#if GLIB_VERSION_MAX_ALLOWED >= GLIB_VERSION_2_38
#define _G_DEFINE_TYPE_EXTENDED_CLASS_INIT(TypeName, type_name) \
static void     type_name##_class_intern_init (gpointer klass) \
{ \
  type_name##_parent_class = g_type_class_peek_parent (klass); \
  if (TypeName##_private_offset != 0) \
    g_type_class_adjust_private_offset (klass, &TypeName##_private_offset); \
  type_name##_class_init ((TypeName##Class*) klass); \
}

#else
#define _G_DEFINE_TYPE_EXTENDED_CLASS_INIT(TypeName, type_name) \
static void     type_name##_class_intern_init (gpointer klass) \
{ \
  type_name##_parent_class = g_type_class_peek_parent (klass); \
  type_name##_class_init ((TypeName##Class*) klass); \
}
#endif /* GLIB_VERSION_MAX_ALLOWED >= GLIB_VERSION_2_38 */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#define _G_DEFINE_TYPE_EXTENDED_BEGIN(TypeName, type_name, TYPE_PARENT, flags) \
\
static void     type_name##_init              (TypeName        *self); \
static void     type_name##_class_init        (TypeName##Class *klass); \
static gpointer type_name##_parent_class = NULL; \
static gint     TypeName##_private_offset; \
\
_G_DEFINE_TYPE_EXTENDED_CLASS_INIT(TypeName, type_name) \
\
G_GNUC_UNUSED \
static inline gpointer \
type_name##_get_instance_private (TypeName *self) \
{ \
  return (G_STRUCT_MEMBER_P (self, TypeName##_private_offset)); \
} \
\
GType \
type_name##_get_type (void) \
{ \
  static volatile gsize g_define_type_id__volatile = 0; \
  if (g_once_init_enter (&g_define_type_id__volatile))  \
    { \
      GType g_define_type_id = \
        g_type_register_static_simple (TYPE_PARENT, \
                                       g_intern_static_string (#TypeName), \
                                       sizeof (TypeName##Class), \
                                       (GClassInitFunc) type_name##_class_intern_init, \
                                       sizeof (TypeName), \
                                       (GInstanceInitFunc) type_name##_init, \
                                       (GTypeFlags) flags); \
      { /* custom code follows */
#define _G_DEFINE_TYPE_EXTENDED_END()	\
        /* following custom code */	\
      }					\
      g_once_init_leave (&g_define_type_id__volatile, g_define_type_id); \
    }					\
  return g_define_type_id__volatile;	\
} /* closes type_name##_get_type() */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#define _G_DEFINE_INTERFACE_EXTENDED_BEGIN(TypeName, type_name, TYPE_PREREQ) \
\
static void     type_name##_default_init        (TypeName##Interface *klass); \
\
GType \
type_name##_get_type (void) \
{ \
  static volatile gsize g_define_type_id__volatile = 0; \
  if (g_once_init_enter (&g_define_type_id__volatile))  \
    { \
      GType g_define_type_id = \
        g_type_register_static_simple (G_TYPE_INTERFACE, \
                                       g_intern_static_string (#TypeName), \
                                       sizeof (TypeName##Interface), \
                                       (GClassInitFunc)type_name##_default_init, \
                                       0, \
                                       (GInstanceInitFunc)NULL, \
                                       (GTypeFlags) 0); \
      if (TYPE_PREREQ) \
        g_type_interface_add_prerequisite (g_define_type_id, TYPE_PREREQ); \
      { /* custom code follows */
#define _G_DEFINE_INTERFACE_EXTENDED_END()	\
        /* following custom code */		\
      }						\
      g_once_init_leave (&g_define_type_id__volatile, g_define_type_id); \
    }						\
  return g_define_type_id__volatile;			\
} /* closes type_name##_get_type() */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

sed -i '/#define G_DEFINE_BOXED_TYPE(TypeName, type_name, copy_func, free_func) G_DEFINE_BOXED_TYPE_WITH_CODE (TypeName, type_name, copy_func, free_func, {})/d' $final
sed -i '/#define G_DEFINE_BOXED_TYPE_WITH_CODE(TypeName, type_name, copy_func, free_func, _C_) _G_DEFINE_BOXED_TYPE_BEGIN (TypeName, type_name, copy_func, free_func) {_C_;} _G_DEFINE_TYPE_EXTENDED_END()/d' $final

i='#if !defined (__cplusplus) && (__GNUC__ > 2 || (__GNUC__ == 2 && __GNUC_MINOR__ >= 7)) && !(defined (__APPLE__) && defined (__ppc64__))
#define _G_DEFINE_BOXED_TYPE_BEGIN(TypeName, type_name, copy_func, free_func) \
GType \
type_name##_get_type (void) \
{ \
  static volatile gsize g_define_type_id__volatile = 0; \
  if (g_once_init_enter (&g_define_type_id__volatile))  \
    { \
      GType (* _g_register_boxed) \
        (const gchar *, \
         union \
           { \
             TypeName * (*do_copy_type) (TypeName *); \
             TypeName * (*do_const_copy_type) (const TypeName *); \
             GBoxedCopyFunc do_copy_boxed; \
           } __attribute__((__transparent_union__)), \
         union \
           { \
             void (* do_free_type) (TypeName *); \
             GBoxedFreeFunc do_free_boxed; \
           } __attribute__((__transparent_union__)) \
        ) = g_boxed_type_register_static; \
      GType g_define_type_id = \
        _g_register_boxed (g_intern_static_string (#TypeName), copy_func, free_func); \
      { /* custom code follows */
#else
#define _G_DEFINE_BOXED_TYPE_BEGIN(TypeName, type_name, copy_func, free_func) \
GType \
type_name##_get_type (void) \
{ \
  static volatile gsize g_define_type_id__volatile = 0; \
  if (g_once_init_enter (&g_define_type_id__volatile))  \
    { \
      GType g_define_type_id = \
        g_boxed_type_register_static (g_intern_static_string (#TypeName), \
                                      (GBoxedCopyFunc) copy_func, \
                                      (GBoxedFreeFunc) free_func); \
      { /* custom code follows */
#endif /* __GNUC__ */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

sed -i '/#define G_DEFINE_POINTER_TYPE(TypeName, type_name) G_DEFINE_POINTER_TYPE_WITH_CODE (TypeName, type_name, {})/d' $final
sed -i '/#define G_DEFINE_POINTER_TYPE_WITH_CODE(TypeName, type_name, _C_) _G_DEFINE_POINTER_TYPE_BEGIN (TypeName, type_name) {_C_;} _G_DEFINE_TYPE_EXTENDED_END()/d' $final

i='#define _G_DEFINE_POINTER_TYPE_BEGIN(TypeName, type_name) \
GType \
type_name##_get_type (void) \
{ \
  static volatile gsize g_define_type_id__volatile = 0; \
  if (g_once_init_enter (&g_define_type_id__volatile))  \
    { \
      GType g_define_type_id = \
        g_pointer_type_register_static (g_intern_static_string (#TypeName)); \
      { /* custom code follows */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='
#ifdef	__GNUC__
#  define _G_TYPE_CIT(ip, gt)             (G_GNUC_EXTENSION ({ \
  GTypeInstance *__inst = (GTypeInstance*) ip; GType __t = gt; gboolean __r; \
  if (!__inst) \
    __r = FALSE; \
  else if (__inst->g_class && __inst->g_class->g_type == __t) \
    __r = TRUE; \
  else \
    __r = g_type_check_instance_is_a (__inst, __t); \
  __r; \
}))
#  define _G_TYPE_CCT(cp, gt)             (G_GNUC_EXTENSION ({ \
  GTypeClass *__class = (GTypeClass*) cp; GType __t = gt; gboolean __r; \
  if (!__class) \
    __r = FALSE; \
  else if (__class->g_type == __t) \
    __r = TRUE; \
  else \
    __r = g_type_check_class_is_a (__class, __t); \
  __r; \
}))
#  define _G_TYPE_CVH(vl, gt)             (G_GNUC_EXTENSION ({ \
  GValue *__val = (GValue*) vl; GType __t = gt; gboolean __r; \
  if (!__val) \
    __r = FALSE; \
  else if (__val->g_type == __t)		\
    __r = TRUE; \
  else \
    __r = g_type_check_value_holds (__val, __t); \
  __r; \
}))
#else  /* !__GNUC__ */
#  define _G_TYPE_CIT(ip, gt)             (g_type_check_instance_is_a ((GTypeInstance*) ip, gt))
#  define _G_TYPE_CCT(cp, gt)             (g_type_check_class_is_a ((GTypeClass*) cp, gt))
#  define _G_TYPE_CVH(vl, gt)             (g_type_check_value_holds ((GValue*) vl, gt))
#endif /* !__GNUC__ */
'
j='
#  define _G_TYPE_CIT(ip, gt)             (g_type_check_instance_is_a ((GTypeInstance*) ip, gt))
#  define _G_TYPE_CCT(cp, gt)             (g_type_check_class_is_a ((GTypeClass*) cp, gt))
#  define _G_TYPE_CVH(vl, gt)             (g_type_check_value_holds ((GValue*) vl, gt))
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

sed -i '/#define G_VALUE_INIT  { 0, { { 0 } } }/d' $final

i='#ifndef G_DISABLE_DEPRECATED
  G_PARAM_PRIVATE	      = G_PARAM_STATIC_NAME,
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

# we have no bitfield support in Nim yet...
i='struct _GClosure
{
  /*< private >*/
  volatile      	guint	 ref_count : 15;
  /* meta_marshal is not used anymore but must be zero for historical reasons
     as it was exposed in the G_CLOSURE_N_NOTIFIERS macro */
  volatile       	guint	 meta_marshal_nouse : 1;
  volatile       	guint	 n_guards : 1;
  volatile       	guint	 n_fnotifiers : 2;	/* finalization notifiers */
  volatile       	guint	 n_inotifiers : 8;	/* invalidation notifiers */
  volatile       	guint	 in_inotify : 1;
  volatile       	guint	 floating : 1;
  /*< protected >*/
  volatile         	guint	 derivative_flag : 1;
  /*< public >*/
  volatile       	guint	 in_marshal : 1;
  volatile       	guint	 is_invalid : 1;

  /*< private >*/	void   (*marshal)  (GClosure       *closure,
					    GValue /*out*/ *return_value,
					    guint           n_param_values,
					    const GValue   *param_values,
					    gpointer        invocation_hint,
					    gpointer	    marshal_data);
  /*< protected >*/	gpointer data;

  /*< private >*/	GClosureNotifyData *notifiers;

  /* invariants/constrains:
   * - ->marshal and ->data are _invalid_ as soon as ->is_invalid==TRUE
   * - invocation of all inotifiers occours prior to fnotifiers
   * - order of inotifiers is random
   *   inotifiers may _not_ free/invalidate parameter values (e.g. ->data)
   * - order of fnotifiers is random
   * - each notifier may only be removed before or during its invocation
   * - reference counting may only happen prior to fnotify invocation
   *   (in that sense, fnotifiers are really finalization handlers)
   */
};
'
j='struct _GClosure
{
  /*< private >*/
  volatile      	guintwith32bitatleast bitfield0GClosure;

  /*< private >*/	void   (*marshal)  (GClosure       *closure,
					    GValue /*out*/ *return_value,
					    guint           n_param_values,
					    const GValue   *param_values,
					    gpointer        invocation_hint,
					    gpointer	    marshal_data);
  /*< protected >*/	gpointer data;

  /*< private >*/	GClosureNotifyData *notifiers;

};
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

sed -i "/GLIB_DEPRECATED_FOR('G_TYPE_VARIANT')/d" $final

i='
#define G_OBJECT_WARN_INVALID_PSPEC(object, pname, property_id, pspec) \
G_STMT_START { \
  GObject *_glib__object = (GObject*) (object); \
  GParamSpec *_glib__pspec = (GParamSpec*) (pspec); \
  guint _glib__property_id = (property_id); \
  g_warning ("%s: invalid %s id %u for \"%s\" of type '\''%s'\'' in '\''%s'\''", \
             G_STRLOC, \
             (pname), \
             _glib__property_id, \
             _glib__pspec->name, \
             g_type_name (G_PARAM_SPEC_TYPE (_glib__pspec)), \
             G_OBJECT_TYPE_NAME (_glib__object)); \
} G_STMT_END
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='struct _GParamSpecString
{
  GParamSpec    parent_instance;
  
  gchar        *default_value;
  gchar        *cset_first;
  gchar        *cset_nth;
  gchar         substitutor;
  guint         null_fold_if_empty : 1;
  guint         ensure_non_null : 1;
};
'
j='struct _GParamSpecString
{
  GParamSpec    parent_instance;
  
  gchar        *default_value;
  gchar        *cset_first;
  gchar        *cset_nth;
  gchar         substitutor;
  guint         bitfield0GParamSpecString;
};
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef GOBJECT_VAR
#  ifdef G_PLATFORM_WIN32
#    ifdef GOBJECT_STATIC_COMPILATION
#      define GOBJECT_VAR extern
#    else /* !GOBJECT_STATIC_COMPILATION */
#      ifdef GOBJECT_COMPILATION
#        ifdef DLL_EXPORT
#          define GOBJECT_VAR __declspec(dllexport)
#        else /* !DLL_EXPORT */
#          define GOBJECT_VAR extern
#        endif /* !DLL_EXPORT */
#      else /* !GOBJECT_COMPILATION */
#        define GOBJECT_VAR extern __declspec(dllimport)
#      endif /* !GOBJECT_COMPILATION */
#    endif /* !GOBJECT_STATIC_COMPILATION */
#  else /* !G_PLATFORM_WIN32 */
#    define GOBJECT_VAR _GLIB_EXTERN
#  endif /* !G_PLATFORM_WIN32 */
#endif /* GOBJECT_VAR */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

sed -i "/GOBJECT_VAR GType \*g_param_spec_types;/d" $final
sed -i "/#define G_DEFINE_DYNAMIC_TYPE(TN, t_n, T_P)          G_DEFINE_DYNAMIC_TYPE_EXTENDED (TN, t_n, T_P, 0, {})/d" $final

i='#define G_DEFINE_DYNAMIC_TYPE_EXTENDED(TypeName, type_name, TYPE_PARENT, flags, CODE) \
static void     type_name##_init              (TypeName        *self); \
static void     type_name##_class_init        (TypeName##Class *klass); \
static void     type_name##_class_finalize    (TypeName##Class *klass); \
static gpointer type_name##_parent_class = NULL; \
static GType    type_name##_type_id = 0; \
static gint     TypeName##_private_offset; \
\
_G_DEFINE_TYPE_EXTENDED_CLASS_INIT(TypeName, type_name) \
\
static inline gpointer \
type_name##_get_instance_private (TypeName *self) \
{ \
  return (G_STRUCT_MEMBER_P (self, TypeName##_private_offset)); \
} \
\
GType \
type_name##_get_type (void) \
{ \
  return type_name##_type_id; \
} \
static void \
type_name##_register_type (GTypeModule *type_module) \
{ \
  GType g_define_type_id G_GNUC_UNUSED; \
  const GTypeInfo g_define_type_info = { \
    sizeof (TypeName##Class), \
    (GBaseInitFunc) NULL, \
    (GBaseFinalizeFunc) NULL, \
    (GClassInitFunc) type_name##_class_intern_init, \
    (GClassFinalizeFunc) type_name##_class_finalize, \
    NULL,   /* class_data */ \
    sizeof (TypeName), \
    0,      /* n_preallocs */ \
    (GInstanceInitFunc) type_name##_init, \
    NULL    /* value_table */ \
  }; \
  type_name##_type_id = g_type_module_register_type (type_module, \
						     TYPE_PARENT, \
						     #TypeName, \
						     &g_define_type_info, \
						     (GTypeFlags) flags); \
  g_define_type_id = type_name##_type_id; \
  { CODE ; } \
}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#define G_ADD_PRIVATE_DYNAMIC(TypeName)         { \
  TypeName##_private_offset = sizeof (TypeName##Private); \
}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

# insert missing {}
sed -i 's/typedef union  _GTypeCValue             GTypeCValue;/typedef union _GTypeCValue {} GTypeCValue;/g' $final
sed -i 's/typedef struct _GTypePlugin             GTypePlugin;/typedef struct _GTypePlugin {} GTypePlugin;/g' $final
sed -i 's/typedef struct _GParamSpecPool  GParamSpecPool;/typedef struct _GParamSpecPool {} GParamSpecPool;/g' $final
sed -i 's/typedef struct _GBinding        GBinding;/typedef struct _GBinding {} GBinding;/g' $final

sed -i "/extern GTypeDebugFlags			_g_type_debug_flags;/d" $final

ruby ../fix_.rb $final

#i='first_line_salewski'
#sed -i "1i#def $i" $final
i='
#ifdef __INCREASE_TMP_INDENT__
#ifdef C2NIM
#  dynlib lib
#endif
#endif
'
#perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" $final
#
perl -0777 -p -i -e "s/^/$i/" $final

ruby ../fix_gtk_type.rb final.h G_
c2nim096 --skipcomments --skipinclude $final
sed -i -f gtk_type_sedlist final.nim

sed -i 's/(type: /(`type`: /g' final.nim
sed -i 's/(type)/(`type`)/g' final.nim
sed -i 's/ type\*:/ `type`*:/g' final.nim
sed -i 's/ type:/ `type`:/g' final.nim

# we use our own defined pragma
sed -i "s/\bdynlib: lib\b/libgobj/g" final.nim

ruby ../remdef.rb final.nim

i='  when not defined(__GLIB_GOBJECT_H_INSIDE__) and
      not defined(GOBJECT_COMPILATION): 
'
perl -0777 -p -i -e "s~\Q$i\E~~sg" final.nim

sed -i '1d' final.nim
sed -i 's/^  //' final.nim

i=' {.deadCodeElim: on.}
'
j='{.deadCodeElim: on.}

# Note: Not all gobject C macros are available in Nim yet.
# Some are converted by c2nim to templates, some manually to procs.
# Most of these should be not necessary for Nim programmers.
# We may have to add more and to test and fix some, or remove unnecessary ones completely...

when defined(windows): 
  const LIB_GOBJ* = "libgobject-2.0-0.dll"
elif defined(macosx):
  const LIB_GOBJ* = "libgobject-2.0.dylib"
else: 
  const LIB_GOBJ* = "libgobject-2.0.so(|.0)"

{.pragma: libgobj, cdecl, dynlib: LIB_GOBJ.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='when not defined(__GLIB_GOBJECT_H_INSIDE__) and
    not defined(GOBJECT_COMPILATION) and not defined(GLIB_COMPILATION): 
when defined(__GI_SCANNER__): 
  type 
    GType* = gsize
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

i='template G_TYPE_FUNDAMENTAL*(`type`: expr): expr = 
  (g_type_fundamental(`type`))

const 
  G_TYPE_FUNDAMENTAL_MAX* = (255 shl G_TYPE_FUNDAMENTAL_SHIFT)
const 
  G_TYPE_INVALID* = G_TYPE_MAKE_FUNDAMENTAL(0)
const 
  G_TYPE_NONE* = G_TYPE_MAKE_FUNDAMENTAL(1)
const 
  G_TYPE_INTERFACE* = G_TYPE_MAKE_FUNDAMENTAL(2)
const 
  G_TYPE_CHAR* = G_TYPE_MAKE_FUNDAMENTAL(3)
const 
  G_TYPE_UCHAR* = G_TYPE_MAKE_FUNDAMENTAL(4)
const 
  G_TYPE_BOOLEAN* = G_TYPE_MAKE_FUNDAMENTAL(5)
const 
  G_TYPE_INT* = G_TYPE_MAKE_FUNDAMENTAL(6)
const 
  G_TYPE_UINT* = G_TYPE_MAKE_FUNDAMENTAL(7)
const 
  G_TYPE_LONG* = G_TYPE_MAKE_FUNDAMENTAL(8)
const 
  G_TYPE_ULONG* = G_TYPE_MAKE_FUNDAMENTAL(9)
const 
  G_TYPE_INT64* = G_TYPE_MAKE_FUNDAMENTAL(10)
const 
  G_TYPE_UINT64* = G_TYPE_MAKE_FUNDAMENTAL(11)
const 
  G_TYPE_ENUM* = G_TYPE_MAKE_FUNDAMENTAL(12)
const 
  G_TYPE_FLAGS* = G_TYPE_MAKE_FUNDAMENTAL(13)
const 
  G_TYPE_FLOAT* = G_TYPE_MAKE_FUNDAMENTAL(14)
const 
  G_TYPE_DOUBLE* = G_TYPE_MAKE_FUNDAMENTAL(15)
const 
  G_TYPE_STRING* = G_TYPE_MAKE_FUNDAMENTAL(16)
const 
  G_TYPE_POINTER* = G_TYPE_MAKE_FUNDAMENTAL(17)
const 
  G_TYPE_BOXED* = G_TYPE_MAKE_FUNDAMENTAL(18)
const 
  G_TYPE_PARAM* = G_TYPE_MAKE_FUNDAMENTAL(19)
const 
  G_TYPE_OBJECT* = G_TYPE_MAKE_FUNDAMENTAL(20)
const 
  G_TYPE_VARIANT* = G_TYPE_MAKE_FUNDAMENTAL(21)
const 
  G_TYPE_FUNDAMENTAL_SHIFT* = (2)
template G_TYPE_MAKE_FUNDAMENTAL*(x: expr): expr = 
  ((GType)((x) shl G_TYPE_FUNDAMENTAL_SHIFT))

const 
  G_TYPE_RESERVED_GLIB_FIRST* = (22)
const 
  G_TYPE_RESERVED_GLIB_LAST* = (31)
const 
  G_TYPE_RESERVED_BSE_FIRST* = (32)
const 
  G_TYPE_RESERVED_BSE_LAST* = (48)
const 
  G_TYPE_RESERVED_USER_FIRST* = (49)
template G_TYPE_IS_FUNDAMENTAL*(`type`: expr): expr = 
  ((`type`) <= G_TYPE_FUNDAMENTAL_MAX)

template G_TYPE_IS_DERIVED*(`type`: expr): expr = 
  ((`type`) > G_TYPE_FUNDAMENTAL_MAX)

template G_TYPE_IS_INTERFACE*(`type`: expr): expr = 
  (G_TYPE_FUNDAMENTAL(`type`) == G_TYPE_INTERFACE)

template G_TYPE_IS_CLASSED*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_CLASSED))

template G_TYPE_IS_INSTANTIATABLE*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_INSTANTIATABLE))

template G_TYPE_IS_DERIVABLE*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_DERIVABLE))

template G_TYPE_IS_DEEP_DERIVABLE*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_DEEP_DERIVABLE))

template G_TYPE_IS_ABSTRACT*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_ABSTRACT))

template G_TYPE_IS_VALUE_ABSTRACT*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_VALUE_ABSTRACT))

template G_TYPE_IS_VALUE_TYPE*(`type`: expr): expr = 
  (g_type_check_is_value_type(`type`))

template G_TYPE_HAS_VALUE_TABLE*(`type`: expr): expr = 
  (g_type_value_table_peek(`type`) != nil)

when GLIB_SIZEOF_SIZE_T != GLIB_SIZEOF_LONG or not defined(__cplusplus): 
  type 
    GType* = gsize
else: 
  type 
    GType* = gulong
'
j='const 
  G_TYPE_FUNDAMENTAL_SHIFT* = (2)
# when GLIB_SIZEOF_SIZE_T != GLIB_SIZEOF_LONG or not defined(__cplusplus): 
when sizeof(csize) != sizeof(clong) or not defined(cpp): 
  type 
    GType* = csize
else: 
  type 
    GType* = gulong
template G_TYPE_FUNDAMENTAL*(`type`: expr): expr = 
  (g_type_fundamental(`type`))
template G_TYPE_MAKE_FUNDAMENTAL*(x: expr): expr = 
  ((GType)((x) shl G_TYPE_FUNDAMENTAL_SHIFT))
const 
  G_TYPE_FUNDAMENTAL_MAX* = (255 shl G_TYPE_FUNDAMENTAL_SHIFT)
const 
  G_TYPE_INVALID* = G_TYPE_MAKE_FUNDAMENTAL(0)
const 
  G_TYPE_NONE* = G_TYPE_MAKE_FUNDAMENTAL(1)
const 
  G_TYPE_INTERF* = G_TYPE_MAKE_FUNDAMENTAL(2)
const 
  G_TYPE_CHAR* = G_TYPE_MAKE_FUNDAMENTAL(3)
const 
  G_TYPE_UCHAR* = G_TYPE_MAKE_FUNDAMENTAL(4)
const 
  G_TYPE_BOOLEAN* = G_TYPE_MAKE_FUNDAMENTAL(5)
const 
  G_TYPE_INT* = G_TYPE_MAKE_FUNDAMENTAL(6)
const 
  G_TYPE_UINT* = G_TYPE_MAKE_FUNDAMENTAL(7)
const 
  G_TYPE_LONG* = G_TYPE_MAKE_FUNDAMENTAL(8)
const 
  G_TYPE_ULONG* = G_TYPE_MAKE_FUNDAMENTAL(9)
const 
  G_TYPE_INT64* = G_TYPE_MAKE_FUNDAMENTAL(10)
const 
  G_TYPE_UINT64* = G_TYPE_MAKE_FUNDAMENTAL(11)
const 
  G_TYPE_ENUM* = G_TYPE_MAKE_FUNDAMENTAL(12)
const 
  G_TYPE_FLAG* = G_TYPE_MAKE_FUNDAMENTAL(13)
const 
  G_TYPE_FLOAT* = G_TYPE_MAKE_FUNDAMENTAL(14)
const 
  G_TYPE_DOUBLE* = G_TYPE_MAKE_FUNDAMENTAL(15)
const 
  G_TYPE_STRING* = G_TYPE_MAKE_FUNDAMENTAL(16)
const 
  G_TYPE_POINTER* = G_TYPE_MAKE_FUNDAMENTAL(17)
const 
  G_TYPE_BOXED* = G_TYPE_MAKE_FUNDAMENTAL(18)
const 
  G_TYPE_PARAM* = G_TYPE_MAKE_FUNDAMENTAL(19)
const 
  G_TYPE_OBJECT* = G_TYPE_MAKE_FUNDAMENTAL(20)
const 
  G_TYPE_VARIANT* = G_TYPE_MAKE_FUNDAMENTAL(21)
const 
  G_TYPE_RESERVED_GLIB_FIRST* = (22)
const 
  G_TYPE_RESERVED_GLIB_LAST* = (31)
const 
  G_TYPE_RESERVED_BSE_FIRST* = (32)
const 
  G_TYPE_RESERVED_BSE_LAST* = (48)
const 
  G_TYPE_RESERVED_USER_FIRST* = (49)
template G_TYPE_IS_FUNDAMENTAL*(`type`: expr): expr = 
  ((`type`) <= G_TYPE_FUNDAMENTAL_MAX)

template G_TYPE_IS_DERIVED*(`type`: expr): expr = 
  ((`type`) > G_TYPE_FUNDAMENTAL_MAX)

template G_TYPE_IS_INTERFACE*(`type`: expr): expr = 
  (G_TYPE_FUNDAMENTAL(`type`) == G_TYPE_INTERFACE)

template G_TYPE_IS_CLASSED*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_CLASSED))

template G_TYPE_IS_INSTANTIATABLE*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_INSTANTIATABLE))

template G_TYPE_IS_DERIVABLE*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_DERIVABLE))

template G_TYPE_IS_DEEP_DERIVABLE*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_DEEP_DERIVABLE))

template G_TYPE_IS_ABSTRACT*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_ABSTRACT))

template G_TYPE_IS_VALUE_ABSTRACT*(`type`: expr): expr = 
  (g_type_test_flags((`type`), G_TYPE_FLAG_VALUE_ABSTRACT))

template G_TYPE_IS_VALUE_TYPE*(`type`: expr): expr = 
  (g_type_check_is_value_type(`type`))

template G_TYPE_HAS_VALUE_TABLE*(`type`: expr): expr = 
  (g_type_value_table_peek(`type`) != nil)
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

ruby ../underscorefix.rb final.nim

i='type 
  INNER_C_UNION_9538328901571658375* = object  {.union.}
    v_int*: gint
    v_uint*: guint
    v_long*: glong
    v_ulong*: gulong
    v_int64*: gint64
    v_uint64*: guint64
    v_float*: gfloat
    v_double*: gdouble
    v_pointer*: gpointer

type 
  GValue* = object 
    g_type*: GType
    data*: array[2, INNER_C_UNION_9538328901571658375]
'
i='type 
  INNER_C_UNION_9535112928135225662* = object  {.union.}
    v_int*: gint
    v_uint*: guint
    v_long*: glong
    v_ulong*: gulong
    v_int64*: gint64
    v_uint64*: guint64
    v_float*: gfloat
    v_double*: gdouble
    v_pointer*: gpointer

type 
  GValue* = object 
    g_type*: GType
    data*: array[2, INNER_C_UNION_9535112928135225662]
'
#exit
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim
j='type 
  GTypeValueTable* = object 
'
perl -0777 -p -i -e "s~\Q$j\E~$i$j~s" final.nim

i='type 
  GTypeInfo* = object 
    class_size*: guint16
    base_init*: GBaseInitFunc
    base_finalize*: GBaseFinalizeFunc
    class_init*: GClassInitFunc
    class_finalize*: GClassFinalizeFunc
    class_data*: gconstpointer
    instance_size*: guint16
    n_preallocs*: guint16
    instance_init*: GInstanceInitFunc
    value_table*: ptr GTypeValueTable
'

j='type 
  GTypeValueTable* = object 
    value_init*: proc (value: ptr GValue)
    value_free*: proc (value: ptr GValue)
    value_copy*: proc (src_value: ptr GValue; dest_value: ptr GValue)
    value_peek_pointer*: proc (value: ptr GValue): gpointer
    collect_format*: ptr gchar
    collect_value*: proc (value: ptr GValue; n_collect_values: guint; 
                          collect_values: ptr GTypeCValue; 
                          collect_flags: guint): ptr gchar
    lcopy_format*: ptr gchar
    lcopy_value*: proc (value: ptr GValue; n_collect_values: guint; 
                        collect_values: ptr GTypeCValue; collect_flags: guint): ptr gchar
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim
perl -0777 -p -i -e "s~\Q$j\E~$j$i~s" final.nim

i='type 
  GParamFlags* {.size: sizeof(cint).} = enum 
    G_PARAM_READABLE = 1 shl 0, G_PARAM_WRITABLE = 1 shl 1, 
    G_PARAM_READWRITE = (G_PARAM_READABLE or G_PARAM_WRITABLE), 
    G_PARAM_CONSTRUCT = 1 shl 2, G_PARAM_CONSTRUCT_ONLY = 1 shl 3, 
    G_PARAM_LAX_VALIDATION = 1 shl 4, G_PARAM_STATIC_NAME = 1 shl 5, 
    G_PARAM_STATIC_NICK = 1 shl 6, G_PARAM_STATIC_BLURB = 1 shl 7, 
    G_PARAM_EXPLICIT_NOTIFY = 1 shl 30, G_PARAM_DEPRECATED = 1 shl 31
const 
  G_PARAM_STATIC_STRINGS* = (
    G_PARAM_STATIC_NAME or G_PARAM_STATIC_NICK or G_PARAM_STATIC_BLURB)
'
j='type 
  GParamFlags* {.size: sizeof(cint).} = enum 
    G_PARAM_READABLE = 1 shl 0, G_PARAM_WRITABLE = 1 shl 1, 
    G_PARAM_CONSTRUCT = 1 shl 2, G_PARAM_CONSTRUCT_ONLY = 1 shl 3, 
    G_PARAM_LAX_VALIDATION = 1 shl 4, G_PARAM_STATIC_NAME = 1 shl 5, 
    G_PARAM_STATIC_NICK = 1 shl 6, G_PARAM_STATIC_BLURB = 1 shl 7, 
    G_PARAM_EXPLICIT_NOTIFY = 1 shl 30, G_PARAM_DEPRECATED = 1 shl 31
const 
  G_PARAM_STATIC_STRINGS* = (
    GParamFlags.STATIC_NAME.ord or GParamFlags.STATIC_NICK.ord or GParamFlags.STATIC_BLURB.ord)
  G_PARAM_READWRITE = (GParamFlags.READABLE.ord or GParamFlags.WRITABLE.ord) 
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

ruby ../fix_template.rb final.nim

i='type 
  GClosureNotify* = proc (data: gpointer; closure: ptr GClosure)
type 
  GClosureMarshal* = proc (closure: ptr GClosure; return_value: ptr GValue; 
                           n_param_values: guint; param_values: ptr GValue; 
                           invocation_hint: gpointer; marshal_data: gpointer)
  GVaClosureMarshal* = proc (closure: ptr GClosure; return_value: ptr GValue; 
                             instance: gpointer; args: va_list; 
                             marshal_data: gpointer; n_params: cint; 
                             param_types: ptr GType)
type 
  GClosureNotifyData* = object 
    data*: gpointer
    notify*: GClosureNotify

type 
  GClosure* = object 
    bitfield0GClosure*: guintwith32bitatleast
    marshal*: proc (closure: ptr GClosure; return_value: ptr GValue; 
                    n_param_values: guint; param_values: ptr GValue; 
                    invocation_hint: gpointer; marshal_data: gpointer)
    data*: gpointer
    notifiers*: ptr GClosureNotifyData

type 
'
j='type 
  GClosureNotifyData* = object 
    data*: gpointer
    notify*: GClosureNotify
 
  GClosure* = object 
    bitfield0GClosure*: guintwith32bitatleast
    marshal*: proc (closure: ptr GClosure; return_value: ptr GValue; 
                    n_param_values: guint; param_values: ptr GValue; 
                    invocation_hint: gpointer; marshal_data: gpointer)
    data*: gpointer
    notifiers*: ptr GClosureNotifyData
 
  GClosureNotify* = proc (data: gpointer; closure: ptr GClosure)

type 
  GClosureMarshal* = proc (closure: ptr GClosure; return_value: ptr GValue; 
                           n_param_values: guint; param_values: ptr GValue; 
                           invocation_hint: gpointer; marshal_data: gpointer)
  GVaClosureMarshal* = proc (closure: ptr GClosure; return_value: ptr GValue; 
                             instance: gpointer; args: va_list; 
                             marshal_data: gpointer; n_params: cint; 
                             param_types: ptr GType)

type 
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='  GVaClosureMarshal* = proc (closure: ptr GClosure; return_value: ptr GValue; 
                             instance: gpointer; args: va_list; 
                             marshal_data: gpointer; n_params: cint; 
                             param_types: ptr GType)
'
j='discard """ GVaClosureMarshal* = proc (closure: ptr GClosure; return_value: ptr GValue; 
                             instance: gpointer; args: va_list; 
                             marshal_data: gpointer; n_params: cint; 
                             param_types: ptr GType) """
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

perl -p -i -e '$/ = "proc "; s/^\w+\*.*va_list.*}/discard """"$&"""\n/s' final.nim
sed -i 's/^proc discard """/\ndiscard """ proc /g' final.nim

sed -i 's/^proc g_cclosure_marshal_VOID__/proc g_cclosure_marshal_VOID_/g' final.nim
sed -i 's/proc g_cclosure_marshal_BOOLEAN__FLAGS\*(closure: ptr GClosure;/proc g_cclosure_marshal_BOOLEAN_FLAGS*(closure: ptr GClosure;/g' final.nim
sed -i 's/proc g_cclosure_marshal_STRING__OBJECT_POINTER\*(closure: ptr GClosure;/proc g_cclosure_marshal_STRING_OBJECT_POINTER*(closure: ptr GClosure;/g' final.nim
sed -i 's/proc g_cclosure_marshal_BOOLEAN__BOXED_BOXED\*(closure: ptr GClosure;/proc g_cclosure_marshal_BOOLEAN_BOXED_BOXED*(closure: ptr GClosure;/g' final.nim
sed -i 's/  g_cclosure_marshal_BOOL__FLAGS\* = g_cclosure_marshal_BOOLEAN__FLAGS/  g_cclosure_marshal_BOOL_FLAGS* = g_cclosure_marshal_BOOLEAN_FLAGS/g' final.nim
sed -i 's/  g_cclosure_marshal_BOOL__BOXED_BOXED\* = g_cclosure_marshal_BOOLEAN__BOXED_BOXED/  g_cclosure_marshal_BOOL_BOXED_BOXED* = g_cclosure_marshal_BOOLEAN_BOXED_BOXED/g' final.nim

i='type 
  GSignalCVaMarshaller* = GVaClosureMarshal
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc g_signal_set_va_marshaller*(signal_id: guint; instance_type: GType; 
                                 va_marshaller: GSignalCVaMarshaller) {.
    importc: "g_signal_set_va_marshaller", libgobj.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='type 
  GSignalInvocationHint* = object 
    signal_id*: guint
    detail*: GQuark
    run_type*: GSignalFlags
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim
j='type 
  GSignalCMarshaller* = GClosureMarshal
'
perl -0777 -p -i -e "s/\Q$j\E/$j$i/s" final.nim

i='type 
  GSignalInvocationHint* = object 
    signal_id*: guint
    detail*: GQuark
    run_type*: GSignalFlags
type 
  GSignalEmissionHook* = proc (ihint: ptr GSignalInvocationHint; 
                               n_param_values: guint; 
                               param_values: ptr GValue; data: gpointer): gboolean
type 
  GSignalAccumulator* = proc (ihint: ptr GSignalInvocationHint; 
                              return_accu: ptr GValue; 
                              handler_return: ptr GValue; data: gpointer): gboolean
type 
  GSignalFlags* {.size: sizeof(cint).} = enum 
    G_SIGNAL_RUN_FIRST = 1 shl 0, G_SIGNAL_RUN_LAST = 1 shl 1, 
    G_SIGNAL_RUN_CLEANUP = 1 shl 2, G_SIGNAL_NO_RECURSE = 1 shl 3, 
    G_SIGNAL_DETAILED = 1 shl 4, G_SIGNAL_ACTION = 1 shl 5, 
    G_SIGNAL_NO_HOOKS = 1 shl 6, G_SIGNAL_MUST_COLLECT = 1 shl 7, 
    G_SIGNAL_DEPRECATED = 1 shl 8
const 
'
j='type 
  GSignalFlags* {.size: sizeof(cint).} = enum 
    G_SIGNAL_RUN_FIRST = 1 shl 0, G_SIGNAL_RUN_LAST = 1 shl 1, 
    G_SIGNAL_RUN_CLEANUP = 1 shl 2, G_SIGNAL_NO_RECURSE = 1 shl 3, 
    G_SIGNAL_DETAILED = 1 shl 4, G_SIGNAL_ACTION = 1 shl 5, 
    G_SIGNAL_NO_HOOKS = 1 shl 6, G_SIGNAL_MUST_COLLECT = 1 shl 7, 
    G_SIGNAL_DEPRECATED = 1 shl 8
type 
  GSignalInvocationHint* = object 
    signal_id*: guint
    detail*: GQuark
    run_type*: GSignalFlags
type 
  GSignalEmissionHook* = proc (ihint: ptr GSignalInvocationHint; 
                               n_param_values: guint; 
                               param_values: ptr GValue; data: gpointer): gboolean
type 
  GSignalAccumulator* = proc (ihint: ptr GSignalInvocationHint; 
                              return_accu: ptr GValue; 
                              handler_return: ptr GValue; data: gpointer): gboolean
const 
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

sed -i '/when not(defined(GI_SCANNER)): /d' final.nim

sed -i 's/(object)/(`object`)/g' final.nim
sed -i 's/(object: /(`object`: /g' final.nim
sed -i 's/; object: /; `object`: /g' final.nim
sed -i 's/(object, /(`object`, /g' final.nim

i='type 
  GInitiallyUnowned* = GObject
  GInitiallyUnownedClass* = GObjectClass
type 
  GObjectGetPropertyFunc* = proc (`object`: ptr GObject; property_id: guint; 
                                  value: ptr GValue; pspec: ptr GParamSpec)
type 
  GObjectSetPropertyFunc* = proc (`object`: ptr GObject; property_id: guint; 
                                  value: ptr GValue; pspec: ptr GParamSpec)
type 
  GObjectFinalizeFunc* = proc (`object`: ptr GObject)
type 
  GWeakNotify* = proc (data: gpointer; where_the_object_was: ptr GObject)
type 
  GObject* = object 
    g_type_instance*: GTypeInstance
    ref_count*: guint
    qdata*: ptr GData

type 
  GObjectClass* = object 
    g_type_class*: GTypeClass
    construct_properties*: ptr GSList
    constructor*: proc (`type`: GType; n_construct_properties: guint; 
                        construct_properties: ptr GObjectConstructParam): ptr GObject
    set_property*: proc (`object`: ptr GObject; property_id: guint; 
                         value: ptr GValue; pspec: ptr GParamSpec)
    get_property*: proc (`object`: ptr GObject; property_id: guint; 
                         value: ptr GValue; pspec: ptr GParamSpec)
    dispose*: proc (`object`: ptr GObject)
    finalize*: proc (`object`: ptr GObject)
    dispatch_properties_changed*: proc (`object`: ptr GObject; n_pspecs: guint; 
        pspecs: ptr ptr GParamSpec)
    notify*: proc (`object`: ptr GObject; pspec: ptr GParamSpec)
    constructed*: proc (`object`: ptr GObject)
    flags*: gsize
    pdummy*: array[6, gpointer]

type 
  GObjectConstructParam* = object 
    pspec*: ptr GParamSpec
    value*: ptr GValue
'
j='
type 
  GObject* = object 
    g_type_instance*: GTypeInstance
    ref_count*: guint
    qdata*: ptr GData

type 
  GObjectClass* = object 
    g_type_class*: GTypeClass
    construct_properties*: ptr GSList
    constructor*: proc (`type`: GType; n_construct_properties: guint; 
                        construct_properties: ptr GObjectConstructParam): ptr GObject
    set_property*: proc (`object`: ptr GObject; property_id: guint; 
                         value: ptr GValue; pspec: ptr GParamSpec)
    get_property*: proc (`object`: ptr GObject; property_id: guint; 
                         value: ptr GValue; pspec: ptr GParamSpec)
    dispose*: proc (`object`: ptr GObject)
    finalize*: proc (`object`: ptr GObject)
    dispatch_properties_changed*: proc (`object`: ptr GObject; n_pspecs: guint; 
        pspecs: ptr ptr GParamSpec)
    notify*: proc (`object`: ptr GObject; pspec: ptr GParamSpec)
    constructed*: proc (`object`: ptr GObject)
    flags*: gsize
    pdummy*: array[6, gpointer]

  #type 
  GObjectConstructParam* = object 
    pspec*: ptr GParamSpec
    value*: ptr GValue

type 
  GInitiallyUnowned* = GObject
  GInitiallyUnownedClass* = GObjectClass
type 
  GObjectGetPropertyFunc* = proc (`object`: ptr GObject; property_id: guint; 
                                  value: ptr GValue; pspec: ptr GParamSpec)
type 
  GObjectSetPropertyFunc* = proc (`object`: ptr GObject; property_id: guint; 
                                  value: ptr GValue; pspec: ptr GParamSpec)
type 
  GObjectFinalizeFunc* = proc (`object`: ptr GObject)
type 
  GWeakNotify* = proc (data: gpointer; where_the_object_was: ptr GObject)
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='type 
  GEnumClass* = object 
    g_type_class*: GTypeClass
    minimum*: gint
    maximum*: gint
    n_values*: guint
    values*: ptr GEnumValue

type 
  GFlagsClass* = object 
    g_type_class*: GTypeClass
    mask*: guint
    n_values*: guint
    values*: ptr GFlagsValue

type 
  GEnumValue* = object 
    value*: gint
    value_name*: ptr gchar
    value_nick*: ptr gchar
'
j='
type 
  GEnumValue* = object 
    value*: gint
    value_name*: ptr gchar
    value_nick*: ptr gchar
type 
  GEnumClass* = object 
    g_type_class*: GTypeClass
    minimum*: gint
    maximum*: gint
    n_values*: guint
    values*: ptr GEnumValue

type 
  GFlagsClass* = object 
    g_type_class*: GTypeClass
    mask*: guint
    n_values*: guint
    values*: ptr GFlagsValue
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='type 
  GFlagsClass* = object 
    g_type_class*: GTypeClass
    mask*: guint
    n_values*: guint
    values*: ptr GFlagsValue

type 
  GFlagsValue* = object 
    value*: guint
    value_name*: ptr gchar
    value_nick*: ptr gchar
'
j='type 
  GFlagsValue* = object 
    value*: guint
    value_name*: ptr gchar
    value_nick*: ptr gchar
type 
  GFlagsClass* = object 
    g_type_class*: GTypeClass
    mask*: guint
    n_values*: guint
    values*: ptr GFlagsValue
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='const 
  G_TYPE_PARAM_CHAR* = (g_param_spec_types[0])
template g_is_param_spec_char*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_CHAR))

template g_param_spec_char*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_CHAR, GParamSpecChar))

const 
  G_TYPE_PARAM_UCHAR* = (g_param_spec_types[1])
template g_is_param_spec_uchar*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_UCHAR))

template g_param_spec_uchar*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_UCHAR, GParamSpecUChar))

const 
  G_TYPE_PARAM_BOOLEAN* = (g_param_spec_types[2])
template g_is_param_spec_boolean*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_BOOLEAN))

template g_param_spec_boolean*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_BOOLEAN, GParamSpecBoolean))

const 
  G_TYPE_PARAM_INT* = (g_param_spec_types[3])
template g_is_param_spec_int*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_INT))

template g_param_spec_int*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_INT, GParamSpecInt))

const 
  G_TYPE_PARAM_UINT* = (g_param_spec_types[4])
template g_is_param_spec_uint*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_UINT))

template g_param_spec_uint*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_UINT, GParamSpecUInt))

const 
  G_TYPE_PARAM_LONG* = (g_param_spec_types[5])
template g_is_param_spec_long*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_LONG))

template g_param_spec_long*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_LONG, GParamSpecLong))

const 
  G_TYPE_PARAM_ULONG* = (g_param_spec_types[6])
template g_is_param_spec_ulong*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_ULONG))

template g_param_spec_ulong*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_ULONG, GParamSpecULong))

const 
  G_TYPE_PARAM_INT64* = (g_param_spec_types[7])
template g_is_param_spec_int64*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_INT64))

template g_param_spec_int64*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_INT64, GParamSpecInt64))
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='const 
  G_TYPE_PARAM_UINT64* = (g_param_spec_types[8])
template g_is_param_spec_uint64*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_UINT64))

template g_param_spec_uint64*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_UINT64, GParamSpecUInt64))

const 
  G_TYPE_PARAM_UNICHAR* = (g_param_spec_types[9])
template g_param_spec_unichar*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_UNICHAR, GParamSpecUnichar))

template g_is_param_spec_unichar*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_UNICHAR))

const 
  G_TYPE_PARAM_ENUM* = (g_param_spec_types[10])
template g_is_param_spec_enum*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_ENUM))

template g_param_spec_enum*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_ENUM, GParamSpecEnum))

const 
  G_TYPE_PARAM_FLAGS* = (g_param_spec_types[11])
template g_is_param_spec_flags*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_FLAGS))

template g_param_spec_flags*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_FLAGS, GParamSpecFlags))

const 
  G_TYPE_PARAM_FLOAT* = (g_param_spec_types[12])
template g_is_param_spec_float*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_FLOAT))

template g_param_spec_float*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_FLOAT, GParamSpecFloat))

const 
  G_TYPE_PARAM_DOUBLE* = (g_param_spec_types[13])
template g_is_param_spec_double*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_DOUBLE))

template g_param_spec_double*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_DOUBLE, GParamSpecDouble))

const 
  G_TYPE_PARAM_STRING* = (g_param_spec_types[14])
template g_is_param_spec_string*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_STRING))

template g_param_spec_string*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_STRING, GParamSpecString))

const 
  G_TYPE_PARAM_PARAM* = (g_param_spec_types[15])
template g_is_param_spec_param*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_PARAM))

template g_param_spec_param*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_PARAM, GParamSpecParam))

const 
  G_TYPE_PARAM_BOXED* = (g_param_spec_types[16])
template g_is_param_spec_boxed*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_BOXED))

template g_param_spec_boxed*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_BOXED, GParamSpecBoxed))

const 
  G_TYPE_PARAM_POINTER* = (g_param_spec_types[17])
template g_is_param_spec_pointer*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_POINTER))

template g_param_spec_pointer*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_POINTER, GParamSpecPointer))

const 
  G_TYPE_PARAM_VALUE_ARRAY* = (g_param_spec_types[18])
template g_is_param_spec_value_array*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_VALUE_ARRAY))

template g_param_spec_value_array*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_VALUE_ARRAY, 
                              GParamSpecValueArray))

const 
  G_TYPE_PARAM_OBJECT* = (g_param_spec_types[19])
template g_is_param_spec_object*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_OBJECT))

template g_param_spec_object*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_OBJECT, GParamSpecObject))

const 
  G_TYPE_PARAM_OVERRIDE* = (g_param_spec_types[20])
template g_is_param_spec_override*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_OVERRIDE))

template g_param_spec_override*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_OVERRIDE, 
                              GParamSpecOverride))

const 
  G_TYPE_PARAM_GTYPE* = (g_param_spec_types[21])
template g_is_param_spec_gtype*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_GTYPE))

template g_param_spec_gtype*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_GTYPE, GParamSpecGType))

const 
  G_TYPE_PARAM_VARIANT* = (g_param_spec_types[22])
template g_is_param_spec_variant*(pspec: expr): expr = 
  (g_type_check_instance_type((pspec), G_TYPE_PARAM_VARIANT))

template g_param_spec_variant*(pspec: expr): expr = 
  (g_type_check_instance_cast((pspec), G_TYPE_PARAM_VARIANT, GParamSpecVariant))
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

echo -e "\n" >>  final.nim

ruby ../glib_fix_proc.rb final.nim
ruby ../glib_fix_T.rb final.nim gobject
ruby ../glib_fix_enum_prefix.rb final.nim

# generate procs without get_ and set_ prefix
perl -0777 -p -i -e "s/(\n\s*)(proc set_)(\w+)(\*\([^}]*\) {[^}]*})/\$&\1proc \`\3=\`\4/sg" final.nim
perl -0777 -p -i -e "s/(\n\s*)(proc get_)(\w+)(\*\([^}]*\): \w[^}]*})/\$&\1proc \3\4/sg" final.nim

sed -i 's/^proc ref\*(/proc `ref`\*(/g' final.nim
sed -i 's/\(when not(defined(G_DISABLE_CAST_CHECKS)):\)/when true: # \1/g' final.nim
sed -i 's/\(\breserved[0-9]\)\*:/\1:/g' final.nim
sed -i 's/\(\bpadding\)\*:/\1:/g' final.nim
sed -i 's/ ptr gchar\b/ cstring/g' final.nim

sed -i 's/: ptr GTypeCValue;/: GTypeCValue;/g' final.nim
i='type 
  GTypeCValue* = object  {.union.}
'
j='type
  GTypeCValue* = ptr GTypeCValueObj
  GTypeCValuePtr* = ptr GTypeCValueObj
  GTypeCValueObj* = object  {.union.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='type 
  GTypeFundamentalFlags* {.size: sizeof(cint), pure.} = enum 
    FLAG_CLASSED = (1 shl 0), FLAG_INSTANTIATABLE = (1 shl 1), 
    FLAG_DERIVABLE = (1 shl 2), FLAG_DEEP_DERIVABLE = (1 shl
        3)
type 
  GTypeFlags* {.size: sizeof(cint), pure.} = enum 
    FLAG_ABSTRACT = (1 shl 4), FLAG_VALUE_ABSTRACT = (1 shl 5)
'
j='type 
  GTypeFundamentalFlags* {.size: sizeof(cint), pure.} = enum 
    CLASSED = 1 shl 0, INSTANTIATABLE = 1 shl 1, 
    DERIVABLE = 1 shl 2, DEEP_DERIVABLE = 1 shl 3
type 
  GTypeFlags* {.size: sizeof(cint), pure.} = enum 
    ABSTRACT = 1 shl 4, VALUE_ABSTRACT = 1 shl 5
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

sed -i -f ../glib_sedlist final.nim

i='{.deadCodeElim: on.}
'
j='
# import glib

# we may carefully check imported symbols
from glib import gint8, guint8, guint16, guint32, gint64, guint64, gint, guint, glong, gulong, gchar, guchar, gboolean,
  gfloat, gdouble, gpointer, gconstpointer, gunichar, gsize, GList, GSList, GQuark, GData, GSource, GVariant,
  GVariantType, GCompareFunc, GDuplicateFunc, GCompareDataFunc, GDestroyNotify, guintwith32bitatleast, g_clear_pointer
'
perl -0777 -p -i -e "s/\Q$i\E/$i$j/s" final.nim

sed -i 's/): var GParamSpec {/): ptr GParamSpec {/g' final.nim

sed -i 's/G_TYPE_FLAG_VALUE_ABSTRACT/GTypeFlags.VALUE_ABSTRACT/g' final.nim
sed -i 's/G_TYPE_FLAG_ABSTRACT/GTypeFlags.ABSTRACT/g' final.nim

sed -i 's/G_TYPE_FLAG_INSTANTIATABLE/GTypeFundamentalFlags.INSTANTIATABLE/g' final.nim
sed -i 's/G_TYPE_FLAG_DEEP_DERIVABLE/GTypeFundamentalFlags.DEEP_DERIVABLE/g' final.nim
sed -i 's/G_TYPE_FLAG_DERIVABLE/GTypeFundamentalFlags.DERIVABLE/g' final.nim
sed -i 's/G_TYPE_FLAG_CLASSED/GTypeFundamentalFlags.CLASSED/g' final.nim
sed -i 's/\bG_TYPE_FLAGS\b/G_TYPE_FLAG/g' final.nim
sed -i 's/\bG_TYPE_INTERFACE\b/G_TYPE_INTERF/g' final.nim
sed -i 's/G_CONNECT_SWAPPED/GConnectFlags.SWAPPED/g' final.nim
sed -i 's/G_CONNECT_AFTER/GConnectFlags.AFTER/g' final.nim

sed -i 's/G_SIGNAL_MATCH_FUNC or G_SIGNAL_MATCH_DATA/GSignalMatchType.FUNC.ord or GSignalMatchType.DATA.ord/g' final.nim
sed -i 's/G_SIGNAL_MATCH_DATA/GSignalMatchType.DATA/g' final.nim

sed -i 's/g_cclosure_marshal_BOOL_BOXED_BOXED\* = g_cclosure_marshal_BOOLEAN_BOXED_BOXED/marshal_BOOL_BOXED_BOXED* = marshal_BOOLEAN_BOXED_BOXED/g' final.nim
sed -i 's/g_cclosure_marshal_BOOL_FLAGS\* = g_cclosure_marshal_BOOLEAN_FLAGS/marshal_BOOL_FLAGS* = marshal_BOOLEAN_FLAGS/g' final.nim

sed -i 's/\(dummy[0-9]\{0,1\}\)\*/\1/g' final.nim
sed -i 's/\(reserved[0-9]\{0,1\}\)\*/\1/g' final.nim

sed -i 's/\([,=(] \{0,1\}\)[(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/\1\2/g' final.nim

i='template g_type_fundamental*(`type`: expr): expr = 
  (g_type_fundamental(`type`))
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim
sed -i 's/(g_type_fundamental(`type`)/(fundamental(`type`)/g' final.nim

ruby ../fix_object_of.rb final.nim

perl -0777 -p -i -e "s~([=:] proc \(.*?\)(?:: \w+)?)~\1 {.cdecl.}~sg" final.nim

# Note: I guess we should better not export inheritable objects directly?
i='  GTypeInstanceObj* = object 
    g_class*: GTypeClass
'
j='  GTypeInstanceObj{.inheritable, pure.} = object 
    g_class*: GTypeClass
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  GTypeClassObj* = object 
    g_type*: GType
'
j='  GTypeClassObj{.inheritable, pure.} = object 
    g_type*: GType
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  GClosureObj* = object 
    bitfield0GClosure*: guintwith32bitatleast
'
j='  GClosureObj{.inheritable, pure.} = object 
    bitfield0GClosure*: guintwith32bitatleast
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  GTypeInterfaceObj* = object 
    g_type*: GType
'
j='  GTypeInterfaceObj*{.inheritable, pure.} = object 
    g_type*: GType
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  GParamSpecObj* = object 
    g_type_instance*: GTypeInstanceObj
'
j='  GParamSpecObj* = object of GTypeInstanceObj
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  GParamSpecClassObj* = object 
    g_type_class*: GTypeClassObj
'
j='  GParamSpecClassObj*{.final.} = object of GTypeClassObj
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  GCClosureObj* = object 
    closure*: GClosureObj
'
j='  GCClosureObj*{.final.} = object of GClosureObj
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  GObjectObj* = object 
    g_type_instance*: GTypeInstanceObj
'
j='  GObjectObj* = object of GTypeInstanceObj
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  GObjectClassObj* = object 
    g_type_class*: GTypeClassObj
'
j='  GObjectClassObj* = object of GTypeClassObj
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  GEnumClassObj* = object 
    g_type_class*: GTypeClassObj
'
j='  GEnumClassObj*{.final.} = object of GTypeClassObj
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  GFlagsClassObj* = object 
    g_type_class*: GTypeClassObj
'
j='  GFlagsClassObj*{.final.} = object of GTypeClassObj
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  GTypePluginClassObj* = object 
    base_iface*: GTypeInterfaceObj
'
j='  GTypePluginClassObj*{.final.} = object of GTypeInterfaceObj
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='type 
  INNER_C_UNION_11069476201761933220* = object  {.union.}
    p*: gpointer

type 
  GWeakRef* =  ptr GWeakRefObj
  GWeakRefPtr* = ptr GWeakRefObj
  GWeakRefObj* = object 
    priv*: INNER_C_UNION_11069476201761933220
'
j='type 
  GWeakRef* =  ptr GWeakRefObj
  GWeakRefPtr* = ptr GWeakRefObj
  GWeakRefObj* = object 
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

# export these templates for gtk3
sed -i 's/template g_type_cic/template g_type_cic*/g' final.nim
sed -i 's/template g_type_ccc/template g_type_ccc*/g' final.nim
sed -i 's/template g_type_chi/template g_type_chi*/g' final.nim
sed -i 's/template g_type_chv/template g_type_chv*/g' final.nim
sed -i 's/template g_type_igi/template g_type_igi*/g' final.nim
sed -i 's/template g_type_cct/template g_type_cct*/g' final.nim
sed -i 's/template g_type_igc/template g_type_igc*/g' final.nim
sed -i 's/template g_type_cit/template g_type_cit*/g' final.nim
sed -i 's/template g_type_cvh/template g_type_cvh*/g' final.nim

sed -i 's/when GLIB_VERSION_MAX_ALLOWED >= GLIB_VERSION_2_42:/when true: #&/g' final.nim

i='template g_callback*(f: expr): expr = 
  (GCallback(f))

type 
  GCallback* = proc () {.cdecl.}
'
j='type 
  GCallback* = proc () {.cdecl.}

proc g_callback*(p: proc): GCallback = 
  cast[GCallback](p)
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

cat -s final.nim > gobject.nim

ruby ../gen_proc_dep.rb gobject.nim
sed -i '/{\.deprecated: \[g_type_instance_get_private/d' proc_dep_list
sed -i '/{\.deprecated: \[g_type_class_get_private/d' proc_dep_list
cat proc_dep_list >> gobject.nim

sed -i 's/\bfunc\([):,\*]\)/`func`\1/' gobject.nim
sed -i 's/ glib\./ /' gobject.nim

sed -i 's/\bproc object\b/proc `object`/g' gobject.nim
sed -i 's/\bproc enum\b/proc `enum`/g' gobject.nim

# short proc names for templates
sed -i 's/  (g_type_test_flags(`type`, GTypeF/  (test_flags(`type`, GTypeF/' gobject.nim
sed -i 's/  (g_type_value_table_peek(`type`) != nil)/  (value_table_peek(`type`) != nil)/' gobject.nim
sed -i 's/  (g_type_check_is_value_type(`type`))/  (check_is_value_type(`type`))/' gobject.nim
sed -i 's/  (g_type_name(/  (name(/' gobject.nim

rm -r gobject
rm all.h final.h final.nim list.txt proc_dep_list

exit

