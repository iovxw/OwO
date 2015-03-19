#!/bin/bash
# S. Salewski, 21-FEB-2015
# generate glib bindings for Nim -- this is for glib headers 2.42.1
# this does not cover gobject and gmodule, they are in separate modules
#
glib_dir="/home/stefan/Downloads/glib-2.42.1"
final="final.h" # the input file for c2nim
list="list.txt"
wdir="tmp_glib"

targets=''
all_t=". ${targets}"

rm -rf $wdir # start from scratch
mkdir $wdir
cd $wdir
cp -r $glib_dir/glib .
cd glib

# indeed we missed gversionmacros.h and valgrind.h -- but do we need them?
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

cat glib.h > all.h

cd ..

# cpp run with all headers to determine order
echo "cat \\" > $list

cpp -I. `pkg-config --cflags gtk+-3.0` glib/all.h $final

# may we need this?
#echo 'gversionmacros.h \' >> $list

# extract file names and push names to list
grep ssalewski $final | sed 's/_ssalewski;/ \\/' >> $list

# strange macros -- we should not need them
sed -i '/gatomic.h/d' $list

i=`uniq -d $list | wc -l`
if [ $i != 0 ]; then echo 'list contains duplicates!'; exit; fi;

# now we work again with original headers
rm -rf glib
cp -r $glib_dir/glib . 

# insert for each header file its name as first line
for j in $all_t ; do
  for i in glib/${j}/*.h; do
    sed -i "1i/* file: $i */" $i
  done
done
cd glib
  bash ../$list > ../$final
cd ..

# delete strange macros (define as empty)
# we restrict use of wildcards to limit risc of damage something!
for i in 28 30 32 34 36 38 40 ; do
  sed -i "1i#def GLIB_AVAILABLE_IN_2_$i\n#def GLIB_DEPRECATED_IN_2_${i}_FOR(x)" $final
done

sed -i "1i#def GLIB_DEPRECATED_IN_2_30" $final
sed -i "1i#def GLIB_DEPRECATED_IN_2_34" $final
sed -i "1i#def GLIB_DEPRECATED" $final
sed -i "1i#def G_INLINE_FUNC" $final
sed -i "1i#def G_BEGIN_DECLS" $final
sed -i "1i#def G_END_DECLS" $final
sed -i "1i#def GLIB_DEPRECATED_FOR(i)" $final
sed -i "1i#def GLIB_AVAILABLE_IN_ALL" $final
sed -i "1i#def G_GNUC_WARN_UNUSED_RESULT" $final
sed -i "1i#def G_ANALYZER_NORETURN" $final
sed -i "1i#def G_GNUC_NORETURN" $final
sed -i "1i#def G_LIKELY" $final
sed -i "1i#def G_GNUC_PRINTF(i,j)" $final
sed -i "1i#def G_GNUC_MALLOC" $final
sed -i "1i#def G_GNUC_CONST" $final
sed -i "1i#def G_GNUC_PURE" $final
sed -i "1i#def G_UNLIKELY" $final
sed -i "1i#def G_GNUC_NULL_TERMINATED" $final
sed -i "1i#def G_GNUC_ALLOC_SIZE(i)" $final
sed -i "1i#def G_GNUC_FORMAT(i)" $final
sed -i "1i#def G_GNUC_ALLOC_SIZE2(i, j)" $final

# we should not need this for Nim, so delete it
# next is long, so mark begin/end and use sed to delete
i='/* Arch specific stuff for speed
 */
#if defined (__GNUC__) && (__GNUC__ >= 2) && defined (__OPTIMIZE__)

#  if __GNUC__ >= 4 && defined (__GNUC_MINOR__) && __GNUC_MINOR__ >= 3
#    define GUINT32_SWAP_LE_BE(val) ((guint32) __builtin_bswap32 ((gint32) (val)))
#    define GUINT64_SWAP_LE_BE(val) ((guint64) __builtin_bswap64 ((gint64) (val)))
#  endif

#  if defined (__i386__)
'
perl -0777 -p -i -e "s~\Q$i\E~\nSalewskiDelStart\n~s" $final
i='#    ifndef GUINT64_SWAP_LE_BE
#      define GUINT64_SWAP_LE_BE(val) (GUINT64_SWAP_LE_BE_CONSTANT (val))
#    endif
#  endif
#else /* generic */
#  define GUINT16_SWAP_LE_BE(val) (GUINT16_SWAP_LE_BE_CONSTANT (val))
#  define GUINT32_SWAP_LE_BE(val) (GUINT32_SWAP_LE_BE_CONSTANT (val))
#  define GUINT64_SWAP_LE_BE(val) (GUINT64_SWAP_LE_BE_CONSTANT (val))
#endif /* generic */
'
perl -0777 -p -i -e "s~\Q$i\E~\nSalewskiDelEnd\n~s" $final
sed -i '/SalewskiDelStart/,/SalewskiDelEnd/d' $final

i='typedef union  _GDoubleIEEE754	GDoubleIEEE754;
typedef union  _GFloatIEEE754	GFloatIEEE754;
#define G_IEEE754_FLOAT_BIAS	(127)
#define G_IEEE754_DOUBLE_BIAS	(1023)
/* multiply with base2 exponent to get base10 exponent (normal numbers) */
#define G_LOG_2_BASE_10		(0.30102999566398119521)
#if G_BYTE_ORDER == G_LITTLE_ENDIAN
union _GFloatIEEE754
{
  gfloat v_float;
  struct {
    guint mantissa : 23;
    guint biased_exponent : 8;
    guint sign : 1;
  } mpn;
};
union _GDoubleIEEE754
{
  gdouble v_double;
  struct {
    guint mantissa_low : 32;
    guint mantissa_high : 20;
    guint biased_exponent : 11;
    guint sign : 1;
  } mpn;
};
#elif G_BYTE_ORDER == G_BIG_ENDIAN
union _GFloatIEEE754
{
  gfloat v_float;
  struct {
    guint sign : 1;
    guint biased_exponent : 8;
    guint mantissa : 23;
  } mpn;
};
union _GDoubleIEEE754
{
  gdouble v_double;
  struct {
    guint sign : 1;
    guint biased_exponent : 11;
    guint mantissa_high : 20;
    guint mantissa_low : 32;
  } mpn;
};
#else /* !G_LITTLE_ENDIAN && !G_BIG_ENDIAN */
#error unknown ENDIAN type
#endif /* !G_LITTLE_ENDIAN && !G_BIG_ENDIAN */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#ifndef GLIB_VAR
#  ifdef G_PLATFORM_WIN32
#    ifdef GLIB_STATIC_COMPILATION
#      define GLIB_VAR extern
#    else /* !GLIB_STATIC_COMPILATION */
#      ifdef GLIB_COMPILATION
#        ifdef DLL_EXPORT
#          define GLIB_VAR __declspec(dllexport)
#        else /* !DLL_EXPORT */
#          define GLIB_VAR extern
#        endif /* !DLL_EXPORT */
#      else /* !GLIB_COMPILATION */
#        define GLIB_VAR extern __declspec(dllimport)
#      endif /* !GLIB_COMPILATION */
#    endif /* !GLIB_STATIC_COMPILATION */
#  else /* !G_PLATFORM_WIN32 */
#    define GLIB_VAR _GLIB_EXTERN
#  endif /* !G_PLATFORM_WIN32 */
#endif /* GLIB_VAR */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#define G_DEFINE_QUARK(QN, q_n)                                         \
GQuark                                                                  \
q_n##_quark (void)                                                      \
{                                                                       \
  static GQuark q;                                                      \
                                                                        \
  if G_UNLIKELY (q == 0)                                                \
    q = g_quark_from_static_string (#QN);                               \
                                                                        \
  return q;                                                             \
}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

sed -i '/#define G_PRIVATE_INIT(notify) { NULL, (notify), { NULL, NULL } }/d' $final
sed -i '/#define G_ONCE_INIT { G_ONCE_STATUS_NOTCALLED, NULL }/d' $final

i='#define G_LOCK_NAME(name)             g__ ## name ## _lock
#define G_LOCK_DEFINE_STATIC(name)    static G_LOCK_DEFINE (name)
#define G_LOCK_DEFINE(name)           GMutex G_LOCK_NAME (name)
#define G_LOCK_EXTERN(name)           extern GMutex G_LOCK_NAME (name)

#ifdef G_DEBUG_LOCKS
#  define G_LOCK(name)                G_STMT_START{             \
      g_log (G_LOG_DOMAIN, G_LOG_LEVEL_DEBUG,                   \
             "file %s: line %d (%s): locking: %s ",             \
             __FILE__,        __LINE__, G_STRFUNC,              \
             #name);                                            \
      g_mutex_lock (&G_LOCK_NAME (name));                       \
   }G_STMT_END
#  define G_UNLOCK(name)              G_STMT_START{             \
      g_log (G_LOG_DOMAIN, G_LOG_LEVEL_DEBUG,                   \
             "file %s: line %d (%s): unlocking: %s ",           \
             __FILE__,        __LINE__, G_STRFUNC,              \
             #name);                                            \
     g_mutex_unlock (&G_LOCK_NAME (name));                      \
   }G_STMT_END
#  define G_TRYLOCK(name)                                       \
      (g_log (G_LOG_DOMAIN, G_LOG_LEVEL_DEBUG,                  \
             "file %s: line %d (%s): try locking: %s ",         \
             __FILE__,        __LINE__, G_STRFUNC,              \
             #name), g_mutex_trylock (&G_LOCK_NAME (name)))
#else  /* !G_DEBUG_LOCKS */
#  define G_LOCK(name) g_mutex_lock       (&G_LOCK_NAME (name))
#  define G_UNLOCK(name) g_mutex_unlock   (&G_LOCK_NAME (name))
#  define G_TRYLOCK(name) g_mutex_trylock (&G_LOCK_NAME (name))
#endif /* !G_DEBUG_LOCKS */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#ifdef __GNUC__
# define g_once_init_enter(location) \
  (G_GNUC_EXTENSION ({                                               \
    G_STATIC_ASSERT (sizeof *(location) == sizeof (gpointer));       \
    (void) (0 ? (gpointer) *(location) : 0);                         \
    (!g_atomic_pointer_get (location) &&                             \
     g_once_init_enter (location));                                  \
  }))
# define g_once_init_leave(location, result) \
  (G_GNUC_EXTENSION ({                                               \
    G_STATIC_ASSERT (sizeof *(location) == sizeof (gpointer));       \
    (void) (0 ? *(location) = (result) : 0);                         \
    g_once_init_leave ((location), (gsize) (result));                \
  }))
#else
# define g_once_init_enter(location) \
  (g_once_init_enter((location)))
# define g_once_init_leave(location, result) \
  (g_once_init_leave((location), (gsize) (result)))
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

sed -i '/#  define G_BREAKPOINT()        G_STMT_START{ __asm__ __volatile__ ("int $03"); }G_STMT_END/d' $final

i='#if (defined (__i386__) || defined (__x86_64__)) && defined (__GNUC__) && __GNUC__ >= 2
#elif (defined (_MSC_VER) || defined (__DMC__)) && defined (_M_IX86)
#  define G_BREAKPOINT()        G_STMT_START{ __asm int 3h }G_STMT_END
#elif defined (_MSC_VER)
#  define G_BREAKPOINT()        G_STMT_START{ __debugbreak(); }G_STMT_END
#elif defined (__alpha__) && !defined(__osf__) && defined (__GNUC__) && __GNUC__ >= 2
#  define G_BREAKPOINT()        G_STMT_START{ __asm__ __volatile__ ("bpt"); }G_STMT_END
#else   /* !__i386__ && !__alpha__ */
#  define G_BREAKPOINT()        G_STMT_START{ raise (SIGTRAP); }G_STMT_END
#endif  /* __i386__ */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#ifdef __GNUC__

#define g_pointer_bit_lock(address, lock_bit) \
  (G_GNUC_EXTENSION ({                                                       \
    G_STATIC_ASSERT (sizeof *(address) == sizeof (gpointer));                \
    g_pointer_bit_lock ((address), (lock_bit));                              \
  }))

#define g_pointer_bit_trylock(address, lock_bit) \
  (G_GNUC_EXTENSION ({                                                       \
    G_STATIC_ASSERT (sizeof *(address) == sizeof (gpointer));                \
    g_pointer_bit_trylock ((address), (lock_bit));                           \
  }))

#define g_pointer_bit_unlock(address, lock_bit) \
  (G_GNUC_EXTENSION ({                                                       \
    G_STATIC_ASSERT (sizeof *(address) == sizeof (gpointer));                \
    g_pointer_bit_unlock ((address), (lock_bit));                            \
  }))

#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

# now we do some replacing...
i='struct _GDate
{
  guint julian_days : 32; /* julian days representation - we use a
                           *  bitfield hoping that 64 bit platforms
                           *  will pack this whole struct in one big
                           *  int
                           */

  guint julian : 1;    /* julian is valid */
  guint dmy    : 1;    /* dmy is valid */

  /* DMY representation */
  guint day    : 6;
  guint month  : 4;
  guint year   : 16;
};

'
j='struct _GDate
{
  guint64 bitfield0GDATE;
};
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#if GLIB_SIZEOF_VOID_P > GLIB_SIZEOF_LONG
/**
 * G_MEM_ALIGN:
 *
 * Indicates the number of bytes to which memory will be aligned on the
 * current platform.
 */
#  define G_MEM_ALIGN	GLIB_SIZEOF_VOID_P
#else	/* GLIB_SIZEOF_VOID_P <= GLIB_SIZEOF_LONG */
#  define G_MEM_ALIGN	GLIB_SIZEOF_LONG
#endif	/* GLIB_SIZEOF_VOID_P <= GLIB_SIZEOF_LONG */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#define g_clear_pointer(pp, destroy) \
  G_STMT_START {                                                               \
    G_STATIC_ASSERT (sizeof *(pp) == sizeof (gpointer));                       \
    /* Only one access, please */                                              \
    gpointer *_pp = (gpointer *) (pp);                                         \
    gpointer _p;                                                               \
    /* This assignment is needed to avoid a gcc warning */                     \
    GDestroyNotify _destroy = (GDestroyNotify) (destroy);                      \
                                                                               \
    _p = *_pp;                                                                 \
    if (_p) 								       \
      { 								       \
        *_pp = NULL;							       \
        _destroy (_p);                                                         \
      }                                                                        \
  } G_STMT_END
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#if defined (__GNUC__) && (__GNUC__ >= 2) && defined (__OPTIMIZE__)
#  define _G_NEW(struct_type, n_structs, func) \
	(struct_type *) (G_GNUC_EXTENSION ({			\
	  gsize __n = (gsize) (n_structs);			\
	  gsize __s = sizeof (struct_type);			\
	  gpointer __p;						\
	  if (__s == 1)						\
	    __p = g_##func (__n);				\
	  else if (__builtin_constant_p (__n) &&		\
	           (__s == 0 || __n <= G_MAXSIZE / __s))	\
	    __p = g_##func (__n * __s);				\
	  else							\
	    __p = g_##func##_n (__n, __s);			\
	  __p;							\
	}))
#  define _G_RENEW(struct_type, mem, n_structs, func) \
	(struct_type *) (G_GNUC_EXTENSION ({			\
	  gsize __n = (gsize) (n_structs);			\
	  gsize __s = sizeof (struct_type);			\
	  gpointer __p = (gpointer) (mem);			\
	  if (__s == 1)						\
	    __p = g_##func (__p, __n);				\
	  else if (__builtin_constant_p (__n) &&		\
	           (__s == 0 || __n <= G_MAXSIZE / __s))	\
	    __p = g_##func (__p, __n * __s);			\
	  else							\
	    __p = g_##func##_n (__p, __n, __s);			\
	  __p;							\
	}))

#else

/* Unoptimised version: always call the _n() function. */

#define _G_NEW(struct_type, n_structs, func) \
        ((struct_type *) g_##func##_n ((n_structs), sizeof (struct_type)))
#define _G_RENEW(struct_type, mem, n_structs, func) \
        ((struct_type *) g_##func##_n (mem, (n_structs), sizeof (struct_type)))

#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

sed -i '/#define g_new0(struct_type, n_structs)			_G_NEW (struct_type, n_structs, malloc0)/d' $final
sed -i '/#define g_new(struct_type, n_structs)			_G_NEW (struct_type, n_structs, malloc)/d' $final
sed -i '/#define g_renew(struct_type, mem, n_structs)		_G_RENEW (struct_type, mem, n_structs, realloc)/d' $final
sed -i '/#define g_try_new(struct_type, n_structs)		_G_NEW (struct_type, n_structs, try_malloc)/d' $final
sed -i '/#define g_try_new0(struct_type, n_structs)		_G_NEW (struct_type, n_structs, try_malloc0)/d' $final
sed -i '/#define g_try_renew(struct_type, mem, n_structs)	_G_RENEW (struct_type, mem, n_structs, try_realloc)/d' $final

sed -i '/^GLIB_VAR .*;/d' $final

i='struct _GHookList
{
  gulong	    seq_id;
  guint		    hook_size : 16;
  guint		    is_setup : 1;
  GHook		   *hooks;
  gpointer	    dummy3;
  GHookFinalizeFunc finalize_hook;
  gpointer	    dummy[2];
};
'
# we need at least 32 bit for the bitfield, but guint may be 64 bit
j='struct _GHookList
{
  gulong	    seq_id;
  guintwith32bitatleast bitfield0GHookList;
  GHook		   *hooks;
  gpointer	    dummy3;
  GHookFinalizeFunc finalize_hook;
  gpointer	    dummy[2];
};
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='struct _GPollFD
{
#if defined (G_OS_WIN32) && GLIB_SIZEOF_VOID_P == 8
#ifndef __GTK_DOC_IGNORE__
  gint64	fd;
#endif
#else
  gint		fd;
#endif
  gushort 	events;
  gushort 	revents;
};
'
j='#if defined (G_OS_WIN32) && GLIB_SIZEOF_VOID_P == 8
struct _GPollFD
{
  gint64	fd;
  gushort 	events;
  gushort 	revents;
};
#else
struct _GPollFD
{
  gint		fd;
  gushort 	events;
  gushort 	revents;
};
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='typedef enum /*< flags >*/
{
  G_IO_IN	GLIB_SYSDEF_POLLIN,
  G_IO_OUT	GLIB_SYSDEF_POLLOUT,
  G_IO_PRI	GLIB_SYSDEF_POLLPRI,
  G_IO_ERR	GLIB_SYSDEF_POLLERR,
  G_IO_HUP	GLIB_SYSDEF_POLLHUP,
  G_IO_NVAL	GLIB_SYSDEF_POLLNVAL
} GIOCondition;
'
j='
#define GLIB_SYSDEF_POLLIN 1
#define GLIB_SYSDEF_POLLOUT 4
#define GLIB_SYSDEF_POLLPRI 2
#define GLIB_SYSDEF_POLLHUP 16
#define GLIB_SYSDEF_POLLERR 8
#define GLIB_SYSDEF_POLLNVAL 32

typedef enum /*< flags >*/
{
  G_IO_IN	= GLIB_SYSDEF_POLLIN,
  G_IO_PRI	= GLIB_SYSDEF_POLLPRI,
  G_IO_OUT	= GLIB_SYSDEF_POLLOUT,
  G_IO_ERR	= GLIB_SYSDEF_POLLERR,
  G_IO_HUP	= GLIB_SYSDEF_POLLHUP,
  G_IO_NVAL	= GLIB_SYSDEF_POLLNVAL
} GIOCondition;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

# currently we have no support for va_list
i='GLIB_AVAILABLE_IN_ALL
GError*  g_error_new_valist    (GQuark         domain,
                                gint           code,
                                const gchar   *format,
                                va_list        args) G_GNUC_PRINTF(3, 0);
'
perl -0777 -p -i -e "s~\Q$i\E~#ifdef VALIST\n$i\n#endif\n~s" $final

i='GLIB_AVAILABLE_IN_ALL
gint                  g_vsnprintf          (gchar       *string,
					    gulong       n,
					    gchar const *format,
					    va_list      args)
					    G_GNUC_PRINTF(3, 0);
'
perl -0777 -p -i -e "s~\Q$i\E~#ifdef VALIST\n$i\n#endif\n~s" $final

i='GLIB_AVAILABLE_IN_ALL
void         g_string_vprintf           (GString         *string,
                                         const gchar     *format,
                                         va_list          args)
                                         G_GNUC_PRINTF(2, 0);
'
perl -0777 -p -i -e "s~\Q$i\E~#ifdef VALIST\n$i\n#endif\n~s" $final

i='GLIB_AVAILABLE_IN_ALL
void         g_string_append_vprintf    (GString         *string,
                                         const gchar     *format,
                                         va_list          args)
                                         G_GNUC_PRINTF(2, 0);
'
perl -0777 -p -i -e "s~\Q$i\E~#ifdef VALIST\n$i\n#endif\n~s" $final

i='GLIB_AVAILABLE_IN_ALL
gchar *g_markup_vprintf_escaped (const char *format,
				 va_list     args) G_GNUC_PRINTF(1, 0);
'
perl -0777 -p -i -e "s~\Q$i\E~#ifdef VALIST\n$i\n#endif\n~s" $final

i='GLIB_AVAILABLE_IN_ALL
gsize	g_printf_string_upper_bound (const gchar* format,
				     va_list	  args) G_GNUC_PRINTF(1, 0);
'
perl -0777 -p -i -e "s~\Q$i\E~#ifdef VALIST\n$i\n#endif\n~s" $final

i='GLIB_AVAILABLE_IN_ALL
void            g_logv                  (const gchar    *log_domain,
                                         GLogLevelFlags  log_level,
                                         const gchar    *format,
                                         va_list         args) G_GNUC_PRINTF(3, 0);
'
perl -0777 -p -i -e "s~\Q$i\E~#ifdef VALIST\n$i\n#endif\n~s" $final

i='GLIB_AVAILABLE_IN_ALL
gchar*	              g_strdup_vprintf (const gchar *format,
					va_list      args) G_GNUC_PRINTF(1, 0) G_GNUC_MALLOC;
'
perl -0777 -p -i -e "s~\Q$i\E~#ifdef VALIST\n$i\n#endif\n~s" $final

i='GLIB_AVAILABLE_IN_ALL
GVariant *                      g_variant_new_va                        (const gchar          *format_string,
                                                                         const gchar         **endptr,
                                                                         va_list              *app);
GLIB_AVAILABLE_IN_ALL
void                            g_variant_get_va                        (GVariant             *value,
                                                                         const gchar          *format_string,
                                                                         const gchar         **endptr,
                                                                         va_list              *app);
GLIB_AVAILABLE_IN_2_34
gboolean                        g_variant_check_format_string           (GVariant             *value,
                                                                         const gchar          *format_string,
                                                                         gboolean              copy_only);
'
perl -0777 -p -i -e "s~\Q$i\E~#ifdef VALIST\n$i\n#endif\n~s" $final

i='GLIB_AVAILABLE_IN_ALL
GVariant *                      g_variant_parse                         (const GVariantType   *type,
                                                                         const gchar          *text,
                                                                         const gchar          *limit,
                                                                         const gchar         **endptr,
                                                                         GError              **error);
GLIB_AVAILABLE_IN_ALL
GVariant *                      g_variant_new_parsed                    (const gchar          *format,
                                                                         ...);
GLIB_AVAILABLE_IN_ALL
GVariant *                      g_variant_new_parsed_va                 (const gchar          *format,
                                                                         va_list              *app);
'
perl -0777 -p -i -e "s~\Q$i\E~#ifdef VALIST\n$i\n#endif\n~s" $final

i="#if defined (G_HAVE_INLINE) && defined (__GNUC__) && defined (__STRICT_ANSI__)
#  undef inline
#  define inline __inline__
#elif !defined (G_HAVE_INLINE)
#  undef inline
#  if defined (G_HAVE___INLINE__)
#    define inline __inline__
#  elif defined (G_HAVE___INLINE)
#    define inline __inline
#  else /* !inline && !__inline__ && !__inline */
#    define inline  /* don't inline, then */
#  endif
#endif
#ifdef G_IMPLEMENT_INLINES
#  define G_INLINE_FUNC _GLIB_EXTERN
#  undef  G_CAN_INLINE
#elif defined (__GNUC__) 
#  define G_INLINE_FUNC static __inline __attribute__ ((unused))
#elif defined (G_CAN_INLINE) 
#  define G_INLINE_FUNC static inline
#else /* can't inline */
#  define G_INLINE_FUNC _GLIB_EXTERN
#endif /* !G_INLINE_FUNC */
"
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i="#ifndef G_DISABLE_DEPRECATED

/*
 * This macro is deprecated. This DllMain() is too complex. It is
 * recommended to write an explicit minimal DLlMain() that just saves
 * the handle to the DLL and then use that handle instead, for
 * instance passing it to
 * g_win32_get_package_installation_directory_of_module().
 *
 * On Windows, this macro defines a DllMain function that stores the
 * actual DLL name that the code being compiled will be included in.
 * STATIC should be empty or 'static'. DLL_NAME is the name of the
 * (pointer to the) char array where the DLL name will be stored. If
 * this is used, you must also include <windows.h>. If you need a more complex
 * DLL entry point function, you cannot use this.
 *
 * On non-Windows platforms, expands to nothing.
 */
"
perl -0777 -p -i -e "s~\Q$i\E~~s" $final
i='#ifndef G_PLATFORM_WIN32
# define G_WIN32_DLLMAIN_FOR_DLL_NAME(static, dll_name)
#else
# define G_WIN32_DLLMAIN_FOR_DLL_NAME(static, dll_name)			\
static char *dll_name;							\
									\
BOOL WINAPI								\
DllMain (HINSTANCE hinstDLL,						\
	 DWORD     fdwReason,						\
	 LPVOID    lpvReserved)						\
{									\
  wchar_t wcbfr[1000];							\
  char *tem;								\
  switch (fdwReason)							\
    {									\
    case DLL_PROCESS_ATTACH:						\
      GetModuleFileNameW ((HMODULE) hinstDLL, wcbfr, G_N_ELEMENTS (wcbfr)); \
      tem = g_utf16_to_utf8 (wcbfr, -1, NULL, NULL, NULL);		\
      dll_name = g_path_get_basename (tem);				\
      g_free (tem);							\
      break;								\
    }									\
									\
  return TRUE;								\
}

#endif	/* !G_DISABLE_DEPRECATED */

#endif /* G_PLATFORM_WIN32 */
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='struct _GIOChannel
{
  /*< private >*/
  gint ref_count;
  GIOFuncs *funcs;

  gchar *encoding;
  GIConv read_cd;
  GIConv write_cd;
  gchar *line_term;		/* String which indicates the end of a line of text */
  guint line_term_len;		/* So we can have null in the line term */

  gsize buf_size;
  GString *read_buf;		/* Raw data from the channel */
  GString *encoded_read_buf;    /* Channel data converted to UTF-8 */
  GString *write_buf;		/* Data ready to be written to the file */
  gchar partial_write_buf[6];	/* UTF-8 partial characters, null terminated */

  /* Group the flags together, immediately after partial_write_buf, to save memory */

  guint use_buffer     : 1;	/* The encoding uses the buffers */
  guint do_encode      : 1;	/* The encoding uses the GIConv coverters */
  guint close_on_unref : 1;	/* Close the channel on final unref */
  guint is_readable    : 1;	/* Cached GIOFlag */
  guint is_writeable   : 1;	/* ditto */
  guint is_seekable    : 1;	/* ditto */

  gpointer reserved1;	
  gpointer reserved2;	
};
'
j='struct _GIOChannel
{
  /*< private >*/
  gint ref_count;
  GIOFuncs *funcs;

  gchar *encoding;
  GIConv read_cd;
  GIConv write_cd;
  gchar *line_term;		/* String which indicates the end of a line of text */
  guint line_term_len;		/* So we can have null in the line term */

  gsize buf_size;
  GString *read_buf;		/* Raw data from the channel */
  GString *encoded_read_buf;    /* Channel data converted to UTF-8 */
  GString *write_buf;		/* Data ready to be written to the file */
  gchar partial_write_buf[6];	/* UTF-8 partial characters, null terminated */

  /* Group the flags together, immediately after partial_write_buf, to save memory */

  guint bitfield0GIOChannel;

  gpointer reserved1;	
  gpointer reserved2;	
};
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

# delete larger parts
i="#if defined(G_HAVE_ISO_VARARGS) && !G_ANALYZER_ANALYZING
/* for(;;) ; so that GCC knows that control doesn't go past g_error().
 * Put space before ending semicolon to avoid C++ build warnings.
 */
"
perl -0777 -p -i -e "s~\Q$i\E~SalewskiDelStart\n~s" $final
i="  va_end (args);
}
#endif  /* !__GNUC__ */
"
perl -0777 -p -i -e "s~\Q$i\E~SalewskiDelEnd\n~s" $final
sed -i '/SalewskiDelStart/,/SalewskiDelEnd/d' $final

i='#define g_warn_if_reached() \
  do { \
    g_warn_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, NULL); \
  } while (0)
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#define g_warn_if_fail(expr) \
  do { \
    if G_LIKELY (expr) ; \
    else g_warn_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, #expr); \
  } while (0)
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i="#ifdef G_DISABLE_CHECKS

/\*\*
 \* g_return_if_fail:
 \* \@expr: the expression to check
 \*
 \* Verifies that the expression \@expr, usually representing a precondition,
"
perl -0777 -p -i -e "s~$i~\nSalewskiDelStart\n~s" $final
i='	    __LINE__,							\
	    G_STRFUNC);							\
     return (val);			}G_STMT_END

#endif /* !G_DISABLE_CHECKS */
'
perl -0777 -p -i -e "s~\Q$i\E~\nSalewskiDelEnd\n~s" $final
sed -i '/SalewskiDelStart/,/SalewskiDelEnd/d' $final

sed -i '/#define G_QUEUE_INIT { NULL, NULL, 0 }/d' $final

i="struct	_GScannerConfig
{
  /* Character sets
   */
  gchar		*cset_skip_characters;		/* default: \" \\t\\n\" */
  gchar		*cset_identifier_first;
  gchar		*cset_identifier_nth;
  gchar		*cpair_comment_single;		/* default: \"#\\n\" */
  
  /* Should symbol lookup work case sensitive?
   */
  guint		case_sensitive : 1;
  
  /* Boolean values to be adjusted \"on the fly\"
   * to configure scanning behaviour.
   */
  guint		skip_comment_multi : 1;		/* C like comment */
  guint		skip_comment_single : 1;	/* single line comment */
  guint		scan_comment_multi : 1;		/* scan multi line comments? */
  guint		scan_identifier : 1;
  guint		scan_identifier_1char : 1;
  guint		scan_identifier_NULL : 1;
  guint		scan_symbols : 1;
  guint		scan_binary : 1;
  guint		scan_octal : 1;
  guint		scan_float : 1;
  guint		scan_hex : 1;			/* '0x0ff0' */
  guint		scan_string_sq : 1;		/* string: 'anything' */
  guint		scan_string_dq : 1;		/* string: \"\\\\-escapes!\\n\" */
  guint		numbers_2_int : 1;		/* bin, octal, hex => int */
  guint		int_2_float : 1;		/* int => G_TOKEN_FLOAT? */
  guint		identifier_2_string : 1;
  guint		char_2_token : 1;		/* return G_TOKEN_CHAR? */
  guint		symbol_2_token : 1;
  guint		scope_0_fallback : 1;		/* try scope 0 on lookups? */
  guint		store_int64 : 1; 		/* use value.v_int64 rather than v_int */

  /*< private >*/
  guint		padding_dummy;
};
"
j='struct	_GScannerConfig
{
  gchar		*cset_skip_characters;		/* default: " \\t\\n" */
  gchar		*cset_identifier_first;
  gchar		*cset_identifier_nth;
  gchar		*cpair_comment_single;		/* default: "#\\n" */
  guintwith32bitatleast bitfield0GScannerConfig;
  guint		padding_dummy;
};
'
sed -i "/\  guint\t\tscan_hex_dollar : 1;\t\t\/\* '\$0ff0' \*\//d" $final
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#ifndef G_DISABLE_DEPRECATED

/* keep downward source compatibility */
#define		g_scanner_add_symbol( scanner, symbol, value )	G_STMT_START { \
  g_scanner_scope_add_symbol ((scanner), 0, (symbol), (value)); \
} G_STMT_END
#define		g_scanner_remove_symbol( scanner, symbol )	G_STMT_START { \
  g_scanner_scope_remove_symbol ((scanner), 0, (symbol)); \
} G_STMT_END
#define		g_scanner_foreach_symbol( scanner, func, data )	G_STMT_START { \
  g_scanner_scope_foreach_symbol ((scanner), 0, (func), (data)); \
} G_STMT_END

/* The following two functions are deprecated and will be removed in
 * the next major release. They do no good. */
#define g_scanner_freeze_symbol_table(scanner) ((void)0)
#define g_scanner_thaw_symbol_table(scanner) ((void)0)

#endif /* G_DISABLE_DEPRECATED */

'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#ifndef G_DISABLE_DEPRECATED
  G_SPAWN_ERROR_2BIG = G_SPAWN_ERROR_TOO_BIG,
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#define g_assert_cmpstr(s1, cmp, s2)    do { const char *__s1 = (s1), *__s2 = (s2); \
                                             if (g_strcmp0 (__s1, __s2) cmp 0) ; else \
                                               g_assertion_message_cmpstr (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, \
                                                 #s1 " " #cmp " " #s2, __s1, #cmp, __s2); } while (0)
'
perl -0777 -p -i -e "s~\Q$i\E~\nSalewskiDelStart\n~s" $final
i='#define g_assert_not_reached()          do { g_assertion_message_expr (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, NULL); } while (0)
#define g_assert(expr)                  do { if G_LIKELY (expr) ; else \
                                               g_assertion_message_expr (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, \
                                                                         #expr); \
                                           } while (0)
#endif /* !G_DISABLE_ASSERT */
'
perl -0777 -p -i -e "s~\Q$i\E~\nSalewskiDelEnd\n~s" $final
sed -i '/SalewskiDelStart/,/SalewskiDelEnd/d' $final

i='#define g_test_add(testpath, Fixture, tdata, fsetup, ftest, fteardown) \
					G_STMT_START {			\
                                         void (*add_vtable) (const char*,       \
                                                    gsize,             \
                                                    gconstpointer,     \
                                                    void (*) (Fixture*, gconstpointer),   \
                                                    void (*) (Fixture*, gconstpointer),   \
                                                    void (*) (Fixture*, gconstpointer)) =  (void (*) (const gchar *, gsize, gconstpointer, void (*) (Fixture*, gconstpointer), void (*) (Fixture*, gconstpointer), void (*) (Fixture*, gconstpointer))) g_test_add_vtable; \
                                         add_vtable \
                                          (testpath, sizeof (Fixture), tdata, fsetup, ftest, fteardown); \
					} G_STMT_END
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#define  g_test_trap_assert_passed()                      g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 0, 0)
#define  g_test_trap_assert_failed()                      g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 1, 0)
#define  g_test_trap_assert_stdout(soutpattern)           g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 2, soutpattern)
#define  g_test_trap_assert_stdout_unmatched(soutpattern) g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 3, soutpattern)
#define  g_test_trap_assert_stderr(serrpattern)           g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 4, serrpattern)
#define  g_test_trap_assert_stderr_unmatched(serrpattern) g_test_trap_assertions (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, 5, serrpattern)
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

sed -i '/#define G_URI_RESERVED_CHARS_ALLOWED_IN_PATH_ELEMENT G_URI_RESERVED_CHARS_SUBCOMPONENT_DELIMITERS ":@"/d' $final
sed -i '/#define G_URI_RESERVED_CHARS_ALLOWED_IN_PATH G_URI_RESERVED_CHARS_ALLOWED_IN_PATH_ELEMENT "\/"/d' $final
sed -i '/#define G_URI_RESERVED_CHARS_ALLOWED_IN_USERINFO G_URI_RESERVED_CHARS_SUBCOMPONENT_DELIMITERS ":"/d' $final

# add missing {} for struct
sed -i 's/typedef struct _GThread         GThread;/typedef struct _GThread {} GThread;/g' $final
sed -i 's/typedef struct _GAsyncQueue GAsyncQueue;/typedef struct _GAsyncQueue {} GAsyncQueue;/g' $final
sed -i 's/typedef struct _GBookmarkFile GBookmarkFile;/typedef struct _GBookmarkFile {} GBookmarkFile;/g' $final
sed -i 's/typedef struct _GChecksum       GChecksum;/typedef struct _GChecksum {} GChecksum;/g' $final
sed -i 's/typedef struct _GData           GData;/typedef struct _GData {} GData;/g' $final
sed -i 's/typedef struct _GBytes          GBytes;/typedef struct _GBytes {} GBytes;/g' $final
sed -i 's/typedef struct _GTimeZone GTimeZone;/typedef struct _GTimeZone {} GTimeZone;/g' $final
sed -i 's/typedef struct _GDateTime GDateTime;/typedef struct _GDateTime {} GDateTime;/g' $final
sed -i 's/typedef struct _GDir GDir;/typedef struct _GDir {} GDir;/g' $final
sed -i 's/typedef struct _GHashTable  GHashTable;/typedef struct _GHashTable {} GHashTable;/g' $final
sed -i 's/typedef struct _GHmac       GHmac;/typedef struct _GHmac {} GHmac;/g' $final
sed -i 's/typedef struct _GMainContext            GMainContext;/typedef struct _GMainContext {} GMainContext;/g' $final
sed -i 's/typedef struct _GSourcePrivate          GSourcePrivate;/typedef struct _GSourcePrivate {} GSourcePrivate;/g' $final
sed -i 's/typedef struct _GMainLoop               GMainLoop;/typedef struct _GMainLoop {} GMainLoop;/g' $final
sed -i 's/typedef struct _GKeyFile GKeyFile;/typedef struct _GKeyFile {} GKeyFile;/g' $final
sed -i 's/typedef struct _GMappedFile GMappedFile;/typedef struct _GMappedFile {} GMappedFile;/g' $final
sed -i 's/typedef struct _GMarkupParseContext GMarkupParseContext;/typedef struct _GMarkupParseContext {} GMarkupParseContext;/g' $final
sed -i 's/typedef struct _GOptionContext GOptionContext;/typedef struct _GOptionContext {} GOptionContext;/g' $final
sed -i 's/typedef struct _GOptionGroup   GOptionGroup;/typedef struct _GOptionGroup {} GOptionGroup;/g' $final
sed -i 's/typedef struct _GPatternSpec    GPatternSpec;/typedef struct _GPatternSpec {} GPatternSpec;/g' $final
sed -i 's/typedef struct _GRand           GRand;/typedef struct _GRand {} GRand;/g' $final
sed -i 's/typedef struct _GMatchInfo	GMatchInfo;/typedef struct _GMatchInfo {}	GMatchInfo;/g' $final
sed -i 's/typedef struct _GRegex		GRegex;/typedef struct _GRegex {} GRegex;/g' $final
sed -i 's/typedef struct _GSequenceNode  GSequenceIter;/typedef struct _GSequenceIter {} GSequenceIter;/g' $final
sed -i 's/typedef struct _GSequence      GSequence;/typedef struct _GSequence {} GSequence;/g' $final
sed -i 's/typedef struct _GStringChunk GStringChunk;/typedef struct _GStringChunk {} GStringChunk;/g' $final
sed -i 's/typedef struct GTestCase  GTestCase;/typedef struct GTestCase {} GTestCase;/g' $final
sed -i 's/typedef struct GTestSuite GTestSuite;/typedef struct GTestSuite {} GTestSuite;/g' $final
sed -i 's/typedef struct _GTimer		GTimer;/typedef struct _GTimer {} GTimer;/g' $final
sed -i 's/typedef struct _GTree  GTree;/typedef struct _GTree {} GTree;/g' $final
sed -i 's/typedef struct _GVariantType GVariantType;/typedef struct _GVariantType {} GVariantType;/g' $final
sed -i 's/typedef struct _GVariant        GVariant;/typedef struct _GVariant {} GVariant;/g' $final

ruby ../fix_.rb $final

i='
#ifdef __INCREASE_TMP_INDENT__
#ifdef C2NIM
#  dynlib lib
#endif
#endif
'
perl -0777 -p -i -e "s/^/$i/" $final

i='#if !defined (__GLIB_H_INSIDE__) && !defined (__G_MAIN_H__) && !defined (GLIB_COMPILATION)
#error "Only <glib.h> can be included directly."
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#ifdef G_OS_UNIX
#include <dirent.h>
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#ifdef G_OS_UNIX
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#if (__GNUC__ >= 3 || (__GNUC__ == 2 && __GNUC_MINOR__ >= 96))
#pragma GCC system_header
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='GLIB_AVAILABLE_IN_ALL
void         g_date_to_struct_tm          (const GDate *date,
                                           struct tm   *tm);
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

# for GIConv a special notation is used in header file
i='
typedef struct _GIConv *GIConv;
'
j='
typedef struct _GICoSalewski {} GICoSalewski;
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final
sed -i "s/GIConv/GIConv*/g" $final
sed -i "s/_GICoSalewski {} GICoSalewski;/_GIConv {} GIConv;/g" $final

sed -i '/#define  g_list_free1                   g_list_free_1/d' $final
sed -i '/#define	 g_slist_free1		         g_slist_free_1/d' $final

ruby ../fix_glib_error.rb final.h G_
c2nim096 --skipcomments --skipinclude $final
#sed -i -f glib_error_sedlist final.nim # there is nothing to substitute

sed -i 's/\bend: /`end`: /g' final.nim
sed -i 's/\btype: /`type`: /g' final.nim
sed -i 's/\bconverter\b/`&`/g' final.nim

# we use our own defined pragma
sed -i "s/\bdynlib: lib\b/libglib/g" final.nim

ruby ../remdef.rb final.nim

sed -i '/^  when not defined(__GLIB_H_INSIDE__) and not defined(GLIB_COMPILATION): /d' final.nim

sed -i '1d' final.nim
sed -i 's/^  //' final.nim

# for time_t see http://stackoverflow.com/questions/471248/what-is-ultimately-a-time-t-typedef-to

i=' {.deadCodeElim: on.}
'
j='{.deadCodeElim: on.}

# Note: Not all glib C macros are available in Nim yet.
# Some are converted by c2nim to templates, some manually to procs.
# Most of these should be not necessary for Nim programmers.
# We may have to add more and to test and fix some, or remove unnecessary ones completely...

from times import Time

when defined(windows): 
  const LIB_GLIB* = "libglib-2.0-0.dll"
elif defined(macosx):
  const LIB_GLIB* = "libglib-2.0.dylib"
else: 
  const LIB_GLIB* = "libglib-2.0.so(|.0)"

{.pragma: libglib, cdecl, dynlib: LIB_GLIB.}

const
  GFALSE* = cint(0)
  GTRUE* = not GFALSE
  G_MAXUINT* = high(cuint)
  G_MAXUSHORT* = high(cushort)
  GLIB_SIZEOF_VOID_P = sizeof(pointer)
  Va_List_Works = false # NOTE: for when false: statement to disable not working va_lists procs

type
  gint8* = int8
  guint8* = uint8
  gint16* = int16
  guint16* = uint16
  gint32* = int32
  guint32* = uint32
  gint64* = int64
  guint64* = uint64
  G_GINT64_CONSTANT = int64
  gsize* = csize # really unsigned
  gssize* = csize
  time_t* = times.Time
  goffset* = int64
  GPid = cint

when sizeof(cuint) < 4:
  type guintwith32bitatleast* = cuint32
else:
  type guintwith32bitatleast* = cuint

{.warning[SmallLshouldNotBeUsed]: off.}

'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i="const 
  G_MININT8* = (cast[gint8](0x00000080))
  G_MAXINT8* = (cast[gint8](0x0000007F))
  G_MAXUINT8* = (cast[guint8](0x000000FF))
  G_MININT16* = (cast[gint16](0x00008000))
  G_MAXINT16* = (cast[gint16](0x00007FFF))
  G_MAXUINT16* = (cast[guint16](0x0000FFFF))
  G_MININT32* = (cast[gint32](0x80000000))
  G_MAXINT32* = (cast[gint32](0x7FFFFFFF))
  G_MAXUINT32* = (cast[guint32](0xFFFFFFFF))
  G_MININT64* = (cast[gint64](G_GINT64_CONSTANT(0x8000000000000000'i64)))
  G_MAXINT64* = G_GINT64_CONSTANT(0x7FFFFFFFFFFFFFFF'i64)
  G_MAXUINT64* = G_GINT64_CONSTANT(0xFFFFFFFFFFFFFFFF'i64)
"
j="const 
  G_MININT8* = gint8(0x00000080)
  G_MAXINT8* = gint8(0x0000007F)
  G_MAXUINT8* = guint8(0x000000FF)
  G_MININT16* = gint16(0x00008000)
  G_MAXINT16* = gint16(0x00007FFF)
  G_MAXUINT16* = guint16(0x0000FFFF)
  G_MININT32* = gint32(0x80000000)
  G_MAXINT32* = gint32(0x7FFFFFFF)
  G_MAXUINT32* = guint32(0xFFFFFFFF)
  G_MININT64* = G_GINT64_CONSTANT(0x8000000000000000'i64)
  G_MAXINT64* = G_GINT64_CONSTANT(0x7FFFFFFFFFFFFFFF'i64)
  G_MAXUINT64* = G_GINT64_CONSTANT(0xFFFFFFFFFFFFFFFF'i64)
"
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc g_base64_encode_step*(in: ptr guchar; len: gsize; break_lines: gboolean; 
                           out: ptr gchar; state: ptr gint; save: ptr gint): gsize {.
    importc: "g_base64_encode_step", libglib.}
proc g_base64_encode_close*(break_lines: gboolean; out: ptr gchar; 
                            state: ptr gint; save: ptr gint): gsize {.
    importc: "g_base64_encode_close", libglib.}
proc g_base64_encode*(data: ptr guchar; len: gsize): ptr gchar {.
    importc: "g_base64_encode", libglib.}
proc g_base64_decode_step*(in: ptr gchar; len: gsize; out: ptr guchar; 
                           state: ptr gint; save: ptr guint): gsize {.
    importc: "g_base64_decode_step", libglib.}
proc g_base64_decode*(text: ptr gchar; out_len: ptr gsize): ptr guchar {.
    importc: "g_base64_decode", libglib.}
'
j='proc g_base64_encode_step*(`in`: ptr guchar; len: gsize; break_lines: gboolean; 
                           `out`: ptr gchar; state: ptr gint; save: ptr gint): gsize {.
    importc: "g_base64_encode_step", libglib.}
proc g_base64_encode_close*(break_lines: gboolean; `out`: ptr gchar; 
                            state: ptr gint; save: ptr gint): gsize {.
    importc: "g_base64_encode_close", libglib.}
proc g_base64_encode*(data: ptr guchar; len: gsize): ptr gchar {.
    importc: "g_base64_encode", libglib.}
proc g_base64_decode_step*(`in`: ptr gchar; len: gsize; `out`: ptr guchar; 
                           state: ptr gint; save: ptr guint): gsize {.
    importc: "g_base64_decode_step", libglib.}
proc g_base64_decode*(text: ptr gchar; out_len: ptr gsize): ptr guchar {.
    importc: "g_base64_decode", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

ruby ../underscorefix.rb final.nim

i='type 
  GTraverseFlags* {.size: sizeof(cint).} = enum 
    G_TRAVERSE_LEAVES = 1 shl 0, G_TRAVERSE_NON_LEAVES = 1 shl 1, 
    G_TRAVERSE_ALL = G_TRAVERSE_LEAVES or G_TRAVERSE_NON_LEAVES, 
    G_TRAVERSE_MASK = 0x00000003, G_TRAVERSE_LEAFS = G_TRAVERSE_LEAVES, 
    G_TRAVERSE_NON_LEAFS = G_TRAVERSE_NON_LEAVES
'
j='type 
  GTraverseFlags* {.size: sizeof(cint).} = enum 
    G_TRAVERSE_LEAVES = 1 shl 0, G_TRAVERSE_NON_LEAVES = 1 shl 1, 
    G_TRAVERSE_ALL = GTraverseFlags.LEAVES.ord or GTraverseFlags.NON_LEAVES.ord
const
  G_TRAVERSE_MASK = GTraverseFlags.ALL
  G_TRAVERSE_LEAFS = GTraverseFlags.LEAVES
  G_TRAVERSE_NON_LEAFS = GTraverseFlags.NON_LEAVES
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='type 
  GNormalizeMode* {.size: sizeof(cint).} = enum 
    G_NORMALIZE_DEFAULT, G_NORMALIZE_NFD = G_NORMALIZE_DEFAULT, 
    G_NORMALIZE_DEFAULT_COMPOSE, 
    G_NORMALIZE_NFC = G_NORMALIZE_DEFAULT_COMPOSE, G_NORMALIZE_ALL, 
    G_NORMALIZE_NFKD = G_NORMALIZE_ALL, G_NORMALIZE_ALL_COMPOSE, 
    G_NORMALIZE_NFKC = G_NORMALIZE_ALL_COMPOSE
'
j='type 
  GNormalizeMode* {.size: sizeof(cint).} = enum 
    G_NORMALIZE_DEFAULT, 
    G_NORMALIZE_DEFAULT_COMPOSE, 
    G_NORMALIZE_ALL, 
    G_NORMALIZE_ALL_COMPOSE
const
  G_NORMALIZE_NFD = GNormalizeMode.DEFAULT
  G_NORMALIZE_NFC = GNormalizeMode.DEFAULT_COMPOSE
  G_NORMALIZE_NFKD = GNormalizeMode.ALL
  G_NORMALIZE_NFKC = GNormalizeMode.ALL_COMPOSE
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='GIOFlags* {.size: sizeof(cint).} = enum 
    G_IO_FLAG_APPEND = 1 shl 0, G_IO_FLAG_NONBLOCK = 1 shl 1, 
    G_IO_FLAG_IS_READABLE = 1 shl 2, G_IO_FLAG_IS_WRITABLE = 1 shl 3, 
    G_IO_FLAG_IS_WRITEABLE = 1 shl 3, G_IO_FLAG_IS_SEEKABLE = 1 shl 4, 
    G_IO_FLAG_MASK = (1 shl 5) - 1, G_IO_FLAG_GET_MASK = G_IO_FLAG_MASK, 
    G_IO_FLAG_SET_MASK = G_IO_FLAG_APPEND or G_IO_FLAG_NONBLOCK
'
j='GIOFlags* {.size: sizeof(cint).} = enum 
    G_IO_FLAG_APPEND = 1 shl 0, G_IO_FLAG_NONBLOCK = 1 shl 1, 
    G_IO_FLAG_SET_MASK = GIOFlags.APPEND.ord or GIOFlags.NONBLOCK.ord,
    G_IO_FLAG_IS_READABLE = 1 shl 2, G_IO_FLAG_IS_WRITABLE = 1 shl 3, 
    G_IO_FLAG_IS_SEEKABLE = 1 shl 4, 
    G_IO_FLAG_MASK = (1 shl 5) - 1
const
  G_IO_FLAG_GET_MASK = GIOFlags.MASK
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='type 
  GTraverseType* {.size: sizeof(cint).} = enum 
    G_IN_ORDER, G_PRE_ORDER, G_POST_ORDER, G_LEVEL_ORDER
  GNodeTraverseFunc* = proc (node: ptr GNode; data: gpointer): gboolean
  GNodeForeachFunc* = proc (node: ptr GNode; data: gpointer)
type 
  GCopyFunc* = proc (src: gconstpointer; data: gpointer): gpointer
type 
'
j='type 
  GTraverseType* {.size: sizeof(cint).} = enum 
    G_IN_ORDER, G_PRE_ORDER, G_POST_ORDER, G_LEVEL_ORDER
  GNodeTraverseFunc* = proc (node: ptr GNode; data: gpointer): gboolean
  GNodeForeachFunc* = proc (node: ptr GNode; data: gpointer)
#type 
  GCopyFunc* = proc (src: gconstpointer; data: gpointer): gpointer
#type 
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='type 
  GLogLevelFlags* {.size: sizeof(cint).} = enum 
    G_LOG_FLAG_RECURSION = 1 shl 0, G_LOG_FLAG_FATAL = 1 shl 1, 
    G_LOG_LEVEL_ERROR = 1 shl 2, G_LOG_LEVEL_CRITICAL = 1 shl 3, 
    G_LOG_LEVEL_WARNING = 1 shl 4, G_LOG_LEVEL_MESSAGE = 1 shl 5, 
    G_LOG_LEVEL_INFO = 1 shl 6, G_LOG_LEVEL_DEBUG = 1 shl 7, 
    G_LOG_LEVEL_MASK = not (G_LOG_FLAG_RECURSION or G_LOG_FLAG_FATAL)
const 
  G_LOG_FATAL_MASK* = (G_LOG_FLAG_RECURSION or G_LOG_LEVEL_ERROR)
'
j='type 
  GLogLevelFlags* {.size: sizeof(cint).} = enum 
    MASK = not(3)
    FLAG_RECURSION = 1 shl 0, FLAG_FATAL = 1 shl 1, 
    LEVEL_ERROR = 1 shl 2,
    FATAL_MASK = (GLogLevelFlags.FLAG_RECURSION.ord or GLogLevelFlags.LEVEL_ERROR.ord)
    LEVEL_CRITICAL = 1 shl 3, 
    LEVEL_WARNING = 1 shl 4, LEVEL_MESSAGE = 1 shl 5, 
    LEVEL_INFO = 1 shl 6, LEVEL_DEBUG = 1 shl 7 
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='    G_REGEX_NEWLINE_CRLF = G_REGEX_NEWLINE_CR or G_REGEX_NEWLINE_LF, 
    G_REGEX_NEWLINE_ANYCRLF = G_REGEX_NEWLINE_CR or 1 shl 22, 
    G_REGEX_BSR_ANYCRLF = 1 shl 23, G_REGEX_JAVASCRIPT_COMPAT = 1 shl 25
type 
  GRegexMatchFlags* {.size: sizeof(cint).} = enum 
    G_REGEX_MATCH_ANCHORED = 1 shl 4, G_REGEX_MATCH_NOTBOL = 1 shl 7, 
    G_REGEX_MATCH_NOTEOL = 1 shl 8, G_REGEX_MATCH_NOTEMPTY = 1 shl 10, 
    G_REGEX_MATCH_PARTIAL = 1 shl 15, G_REGEX_MATCH_NEWLINE_CR = 1 shl 20, 
    G_REGEX_MATCH_NEWLINE_LF = 1 shl 21, G_REGEX_MATCH_NEWLINE_CRLF = G_REGEX_MATCH_NEWLINE_CR or
        G_REGEX_MATCH_NEWLINE_LF, G_REGEX_MATCH_NEWLINE_ANY = 1 shl 22, G_REGEX_MATCH_NEWLINE_ANYCRLF = G_REGEX_MATCH_NEWLINE_CR or
        G_REGEX_MATCH_NEWLINE_ANY, G_REGEX_MATCH_BSR_ANYCRLF = 1 shl 23, 
    G_REGEX_MATCH_BSR_ANY = 1 shl 24, 
    G_REGEX_MATCH_PARTIAL_SOFT = G_REGEX_MATCH_PARTIAL, 
    G_REGEX_MATCH_PARTIAL_HARD = 1 shl 27, 
    G_REGEX_MATCH_NOTEMPTY_ATSTART = 1 shl 28
'
j='    G_REGEX_NEWLINE_CRLF = GRegexCompileFlags.NEWLINE_CR.ord or GRegexCompileFlags.NEWLINE_LF.ord, 
    G_REGEX_NEWLINE_ANYCRLF = GRegexCompileFlags.NEWLINE_CR.ord or 1 shl 22, 
    G_REGEX_BSR_ANYCRLF = 1 shl 23, G_REGEX_JAVASCRIPT_COMPAT = 1 shl 25
type 
  GRegexMatchFlags* {.size: sizeof(cint).} = enum 
    G_REGEX_MATCH_ANCHORED = 1 shl 4, G_REGEX_MATCH_NOTBOL = 1 shl 7, 
    G_REGEX_MATCH_NOTEOL = 1 shl 8, G_REGEX_MATCH_NOTEMPTY = 1 shl 10, 
    G_REGEX_MATCH_PARTIAL = 1 shl 15, G_REGEX_MATCH_NEWLINE_CR = 1 shl 20, 
    G_REGEX_MATCH_NEWLINE_LF = 1 shl 21, G_REGEX_MATCH_NEWLINE_CRLF = GRegexMatchFlags.NEWLINE_CR.ord or
        GRegexMatchFlags.NEWLINE_LF.ord, NEWLINE_ANY = 1 shl 22, NEWLINE_ANYCRLF = GRegexMatchFlags.NEWLINE_CR.ord or
        GRegexMatchFlags.NEWLINE_ANY.ord, BSR_ANYCRLF = 1 shl 23, 
    BSR_ANY = 1 shl 24, 
    PARTIAL_HARD = 1 shl 27, 
    NOTEMPTY_ATSTART = 1 shl 28
const
  G_REGEX_MATCH_PARTIAL_SOFT = GRegexMatchFlags.PARTIAL 
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i="type 
  GTokenType* {.size: sizeof(cint).} = enum 
    G_TOKEN_EOF = 0, G_TOKEN_LEFT_PAREN = '(', G_TOKEN_RIGHT_PAREN = ')', 
    G_TOKEN_LEFT_CURLY = '{', G_TOKEN_RIGHT_CURLY = '}', 
    G_TOKEN_LEFT_BRACE = '[', G_TOKEN_RIGHT_BRACE = ']', 
    G_TOKEN_EQUAL_SIGN = '=', G_TOKEN_COMMA = ',', G_TOKEN_NONE = 256, 
    G_TOKEN_ERROR, G_TOKEN_CHAR, G_TOKEN_BINARY, G_TOKEN_OCTAL, G_TOKEN_INT, 
    G_TOKEN_HEX, G_TOKEN_FLOAT, G_TOKEN_STRING, G_TOKEN_SYMBOL, 
    G_TOKEN_IDENTIFIER, G_TOKEN_IDENTIFIER_NULL, G_TOKEN_COMMENT_SINGLE, 
    G_TOKEN_COMMENT_MULTI, G_TOKEN_LAST
"
j="type 
  GTokenType* {.size: sizeof(cint).} = enum 
    G_TOKEN_EOF = 0, G_TOKEN_LEFT_PAREN = '(', G_TOKEN_RIGHT_PAREN = ')', 
    G_TOKEN_COMMA = ',',
    G_TOKEN_EQUAL_SIGN = '=',
    G_TOKEN_LEFT_BRACE = '[', G_TOKEN_RIGHT_BRACE = ']', 
    G_TOKEN_LEFT_CURLY = '{', G_TOKEN_RIGHT_CURLY = '}', 
    G_TOKEN_NONE = 256, 
    G_TOKEN_ERROR, G_TOKEN_CHAR, G_TOKEN_BINARY, G_TOKEN_OCTAL, G_TOKEN_INT, 
    G_TOKEN_HEX, G_TOKEN_FLOAT, G_TOKEN_STRING, G_TOKEN_SYMBOL, 
    G_TOKEN_IDENTIFIER, G_TOKEN_IDENTIFIER_NULL, G_TOKEN_COMMENT_SINGLE, 
    G_TOKEN_COMMENT_MULTI, G_TOKEN_LAST
"
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i="  GVariantClass* {.size: sizeof(cint).} = enum 
    G_VARIANT_CLASS_BOOLEAN = 'b', G_VARIANT_CLASS_BYTE = 'y', 
    G_VARIANT_CLASS_INT16 = 'n', G_VARIANT_CLASS_UINT16 = 'q', 
    G_VARIANT_CLASS_INT32 = 'i', G_VARIANT_CLASS_UINT32 = 'u', 
    G_VARIANT_CLASS_INT64 = 'x', G_VARIANT_CLASS_UINT64 = 't', 
    G_VARIANT_CLASS_HANDLE = 'h', G_VARIANT_CLASS_DOUBLE = 'd', 
    G_VARIANT_CLASS_STRING = 's', G_VARIANT_CLASS_OBJECT_PATH = 'o', 
    G_VARIANT_CLASS_SIGNATURE = 'g', G_VARIANT_CLASS_VARIANT = 'v', 
    G_VARIANT_CLASS_MAYBE = 'm', G_VARIANT_CLASS_ARRAY = 'a', 
    G_VARIANT_CLASS_TUPLE = '(', G_VARIANT_CLASS_DICT_ENTRY = '{'
"
j="  GVariantClass* {.size: sizeof(cint).} = enum 
    G_VARIANT_CLASS_TUPLE = '(',
    G_VARIANT_CLASS_ARRAY = 'a', 
    G_VARIANT_CLASS_BOOLEAN = 'b',
    G_VARIANT_CLASS_DOUBLE = 'd', 
    G_VARIANT_CLASS_SIGNATURE = 'g',
    G_VARIANT_CLASS_HANDLE = 'h',
    G_VARIANT_CLASS_INT32 = 'i',
    G_VARIANT_CLASS_MAYBE = 'm',
    G_VARIANT_CLASS_INT16 = 'n',
    G_VARIANT_CLASS_OBJECT_PATH = 'o', 
    G_VARIANT_CLASS_UINT16 = 'q', 
    G_VARIANT_CLASS_STRING = 's',
    G_VARIANT_CLASS_UINT64 = 't', 
    G_VARIANT_CLASS_UINT32 = 'u', 
    G_VARIANT_CLASS_VARIANT = 'v', 
    G_VARIANT_CLASS_INT64 = 'x',
    G_VARIANT_CLASS_BYTE = 'y', 
    G_VARIANT_CLASS_DICT_ENTRY = '{'
"
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='const 
  G_HOOK_FLAG_USER_SHIFT* = (4)
type 
  GHookList* = object 
    seq_id*: gulong
    bitfield0GHookList*: guintwith32bitatleast
    hooks*: ptr GHook
    dummy3*: gpointer
    finalize_hook*: GHookFinalizeFunc
    dummy*: array[2, gpointer]

type 
  GHook* = object 
    data*: gpointer
    next*: ptr GHook
    prev*: ptr GHook
    ref_count*: guint
    hook_id*: gulong
    flags*: guint
    func*: gpointer
    destroy*: GDestroyNotify

template G_HOOK*(hook: expr): expr = 
'
j='
#type 
  GHookList* = object 
    seq_id*: gulong
    bitfield0GHookList*: guintwith32bitatleast
    hooks*: ptr GHook
    dummy3*: gpointer
    finalize_hook*: GHookFinalizeFunc
    dummy*: array[2, gpointer]

#type 
  GHook* = object 
    data*: gpointer
    next*: ptr GHook
    prev*: ptr GHook
    ref_count*: guint
    hook_id*: gulong
    flags*: guint
    func*: gpointer
    destroy*: GDestroyNotify

const 
  G_HOOK_FLAG_USER_SHIFT* = 4

template g_hook*(hook: expr): expr = 
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='type 
  GPollFunc* = proc (ufds: ptr GPollFD; nfsd: guint; timeout: gint): gint
when defined(G_OS_WIN32) and GLIB_SIZEOF_VOID_P == 8: 
  type 
    GPollFD* = object 
      fd*: gint64
      events*: gushort
      revents*: gushort

else: 
  type 
    GPollFD* = object 
      fd*: gint
      events*: gushort
      revents*: gushort
'
j='
when defined(G_OS_WIN32) and GLIB_SIZEOF_VOID_P == 8: 
  type 
    GPollFD* = object 
      fd*: gint64
      events*: gushort
      revents*: gushort

else: 
  type 
    GPollFD* = object 
      fd*: gint
      events*: gushort
      revents*: gushort
type 
  GPollFunc* = proc (ufds: ptr GPollFD; nfsd: guint; timeout: gint): gint
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='type 
  GSource* = object 
    callback_data*: gpointer
    callback_funcs*: ptr GSourceCallbackFuncs
    source_funcs*: ptr GSourceFuncs
    ref_count*: guint
    context*: ptr GMainContext
    priority*: gint
    flags*: guint
    source_id*: guint
    poll_fds*: ptr GSList
    prev*: ptr GSource
    next*: ptr GSource
    name*: cstring
    priv*: ptr GSourcePrivate

type 
  GSourceCallbackFuncs* = object 
    ref*: proc (cb_data: gpointer)
    unref*: proc (cb_data: gpointer)
    get*: proc (cb_data: gpointer; source: ptr GSource; func: ptr GSourceFunc; 
                data: ptr gpointer)

type 
  GSourceDummyMarshal* = proc ()
type 
  GSourceFuncs* = object 
'
j='type 
  GSource* = object 
    callback_data*: gpointer
    callback_funcs*: ptr GSourceCallbackFuncs
    source_funcs*: ptr GSourceFuncs
    ref_count*: guint
    context*: ptr GMainContext
    priority*: gint
    flags*: guint
    source_id*: guint
    poll_fds*: ptr GSList
    prev*: ptr GSource
    next*: ptr GSource
    name*: cstring
    priv*: ptr GSourcePrivate

#type 
  GSourceCallbackFuncs* = object 
    `ref`*: proc (cb_data: gpointer)
    unref*: proc (cb_data: gpointer)
    get*: proc (cb_data: gpointer; source: ptr GSource; func: ptr GSourceFunc; 
                data: ptr gpointer)

#type 
  GSourceDummyMarshal* = proc ()
#type 
  GSourceFuncs* = object 
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

sed -i 's/    G_HOOK_FLAG_MASK = 0x0000000F/    G_HOOK_FLAG_MSK = 0x0000000F/g' final.nim
sed -i 's/  template ATEXIT\*(proc: expr): expr =/  template atexit*(`proc`: expr): expr =/g' final.nim

i='    reserved2*: gpointer

type 
  GIOFunc* = proc (source: ptr GIOChannel; condition: GIOCondition; 
                   data: gpointer): gboolean
type 
  GIOFuncs* = object 
'
j='    reserved2*: gpointer

#type 
  GIOFunc* = proc (source: ptr GIOChannel; condition: GIOCondition; 
                   data: gpointer): gboolean
#type 
  GIOFuncs* = object 
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='type 
  GScannerMsgFunc* = proc (scanner: ptr GScanner; message: ptr gchar; 
                           error: gboolean)
const 
  G_CSET_A_2_Z* = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  G_CSET_a_2_z* = "abcdefghijklmnopqrstuvwxyz"
'
j=' 
const 
  G_CSET_A_2_Z_U* = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  G_CSET_a_2_z_L* = "abcdefghijklmnopqrstuvwxyz"
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='type 
  GScanner* = object 
'
j='type 
  GScannerMsgFunc* = proc (scanner: ptr GScanner; message: ptr gchar; 
                           error: gboolean)

  GScanner* = object 
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='template g_slice_new*(`type`: expr): expr = 
  (cast[ptr type](g_slice_alloc(sizeof((type)))))

template g_slice_new0*(`type`: expr): expr = 
  (cast[ptr type](g_slice_alloc0(sizeof((type)))))

template g_slice_dup*(type, mem: expr): expr = 
  (if 1: cast[ptr type](g_slice_copy(sizeof((type)), (mem))) else: (
    (void)(cast[ptr type](0) == (mem))
    cast[ptr type](0)))

template g_slice_free*(type, mem: expr): stmt = 
while true: 
  if 1: g_slice_free1(sizeof((type)), (mem))
  else: (void)(cast[ptr type](0) == (mem))
  if not 0: break 

template g_slice_free_chain*(type, mem_chain, next: expr): stmt = 
while true: 
  if 1: 
    g_slice_free_chain_with_offset(sizeof((type)), (mem_chain), 
                                   G_STRUCT_OFFSET(type, next))
  else: 
    (void)(cast[ptr type](0) == (mem_chain))
  if not 0: break 
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc g_filename_to_utf8*(opsysstring: ptr gchar; len: gssize; 
                         bytes_read: ptr gsize; bytes_written: ptr gsize; 
                         error: ptr ptr GError): ptr gchar {.
    importc: "g_filename_to_utf8", libglib.}
proc g_filename_from_utf8*(utf8string: ptr gchar; len: gssize; 
                           bytes_read: ptr gsize; bytes_written: ptr gsize; 
                           error: ptr ptr GError): ptr gchar {.
    importc: "g_filename_from_utf8", libglib.}
proc g_filename_from_uri*(uri: ptr gchar; hostname: ptr ptr gchar; 
                          error: ptr ptr GError): ptr gchar {.
    importc: "g_filename_from_uri", libglib.}
proc g_filename_to_uri*(filename: ptr gchar; hostname: ptr gchar; 
                        error: ptr ptr GError): ptr gchar {.
    importc: "g_filename_to_uri", libglib.}
'
j='when not defined(G_OS_WIN32):
  proc g_filename_to_utf8*(opsysstring: ptr gchar; len: gssize; 
                           bytes_read: ptr gsize; bytes_written: ptr gsize; 
                           error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_to_utf8", libglib.}
  proc g_filename_from_utf8*(utf8string: ptr gchar; len: gssize; 
                             bytes_read: ptr gsize; bytes_written: ptr gsize; 
                             error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_from_utf8", libglib.}
  proc g_filename_from_uri*(uri: ptr gchar; hostname: ptr ptr gchar; 
                            error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_from_uri", libglib.}
  proc g_filename_to_uri*(filename: ptr gchar; hostname: ptr gchar; 
                          error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_to_uri", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='when defined(G_OS_WIN32): 
  const 
    g_filename_to_utf8* = g_filename_to_utf8_utf8
    g_filename_from_utf8* = g_filename_from_utf8_utf8
    g_filename_from_uri* = g_filename_from_uri_utf8
    g_filename_to_uri* = g_filename_to_uri_utf8
  proc g_filename_to_utf8_utf8*(opsysstring: ptr gchar; len: gssize; 
                                bytes_read: ptr gsize; 
                                bytes_written: ptr gsize; 
                                error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_to_utf8_utf8", libglib.}
  proc g_filename_from_utf8_utf8*(utf8string: ptr gchar; len: gssize; 
                                  bytes_read: ptr gsize; 
                                  bytes_written: ptr gsize; 
                                  error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_from_utf8_utf8", libglib.}
  proc g_filename_from_uri_utf8*(uri: ptr gchar; hostname: ptr ptr gchar; 
                                 error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_from_uri_utf8", libglib.}
  proc g_filename_to_uri_utf8*(filename: ptr gchar; hostname: ptr gchar; 
                               error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_to_uri_utf8", libglib.}
'
j='when defined(G_OS_WIN32): 
  proc g_filename_to_utf8_utf8*(opsysstring: ptr gchar; len: gssize; 
                                bytes_read: ptr gsize; 
                                bytes_written: ptr gsize; 
                                error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_to_utf8_utf8", libglib.}
  proc g_filename_from_utf8_utf8*(utf8string: ptr gchar; len: gssize; 
                                  bytes_read: ptr gsize; 
                                  bytes_written: ptr gsize; 
                                  error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_from_utf8_utf8", libglib.}
  proc g_filename_from_uri_utf8*(uri: ptr gchar; hostname: ptr ptr gchar; 
                                 error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_from_uri_utf8", libglib.}
  proc g_filename_to_uri_utf8*(filename: ptr gchar; hostname: ptr gchar; 
                               error: ptr ptr GError): ptr gchar {.
      importc: "g_filename_to_uri_utf8", libglib.}
  const 
    g_filename_to_utf8* = g_filename_to_utf8_utf8
    g_filename_from_utf8* = g_filename_from_utf8_utf8
    g_filename_from_uri* = g_filename_from_uri_utf8
    g_filename_to_uri* = g_filename_to_uri_utf8
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc g_dir_open*(path: ptr gchar; flags: guint; error: ptr ptr GError): ptr GDir {.
    importc: "g_dir_open", libglib.}
proc g_dir_read_name*(dir: ptr GDir): ptr gchar {.importc: "g_dir_read_name", 
    libglib.}
proc g_dir_rewind*(dir: ptr GDir) {.importc: "g_dir_rewind", libglib.}
proc g_dir_close*(dir: ptr GDir) {.importc: "g_dir_close", libglib.}
when defined(G_OS_WIN32): 
  const 
    g_dir_open* = g_dir_open_utf8
    g_dir_read_name* = g_dir_read_name_utf8
  proc g_dir_open_utf8*(path: ptr gchar; flags: guint; error: ptr ptr GError): ptr GDir {.
      importc: "g_dir_open_utf8", libglib.}
  proc g_dir_read_name_utf8*(dir: ptr GDir): ptr gchar {.
      importc: "g_dir_read_name_utf8", libglib.}
'
j='
proc g_dir_rewind*(dir: ptr GDir) {.importc: "g_dir_rewind", libglib.}
proc g_dir_close*(dir: ptr GDir) {.importc: "g_dir_close", libglib.}
when defined(G_OS_WIN32):
  proc g_dir_open_utf8*(path: ptr gchar; flags: guint; error: ptr ptr GError): ptr GDir {.
      importc: "g_dir_open_utf8", libglib.}
  proc g_dir_read_name_utf8*(dir: ptr GDir): ptr gchar {.
      importc: "g_dir_read_name_utf8", libglib.}
  const 
    g_dir_open* = g_dir_open_utf8
    read_name* = read_name_utf8
else:
  proc g_dir_open*(path: ptr gchar; flags: guint; error: ptr ptr GError): ptr GDir {.
      importc: "g_dir_open", libglib.}
  proc g_dir_read_name*(dir: ptr GDir): ptr gchar {.importc: "g_dir_read_name", 
      libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc g_getenv*(variable: ptr gchar): ptr gchar {.importc: "g_getenv", 
    libglib.}
proc g_setenv*(variable: ptr gchar; value: ptr gchar; overwrite: gboolean): gboolean {.
    importc: "g_setenv", libglib.}
proc g_unsetenv*(variable: ptr gchar) {.importc: "g_unsetenv", libglib.}
proc g_listenv*(): ptr ptr gchar {.importc: "g_listenv", libglib.}
proc g_get_environ*(): ptr ptr gchar {.importc: "g_get_environ", libglib.}
proc g_environ_getenv*(envp: ptr ptr gchar; variable: ptr gchar): ptr gchar {.
    importc: "g_environ_getenv", libglib.}
proc g_environ_setenv*(envp: ptr ptr gchar; variable: ptr gchar; 
                       value: ptr gchar; overwrite: gboolean): ptr ptr gchar {.
    importc: "g_environ_setenv", libglib.}
proc g_environ_unsetenv*(envp: ptr ptr gchar; variable: ptr gchar): ptr ptr gchar {.
    importc: "g_environ_unsetenv", libglib.}
when defined(G_OS_WIN32): 
  const 
    g_getenv* = g_getenv_utf8
    g_setenv* = g_setenv_utf8
    g_unsetenv* = g_unsetenv_utf8
  proc g_getenv_utf8*(variable: ptr gchar): ptr gchar {.
      importc: "g_getenv_utf8", libglib.}
  proc g_setenv_utf8*(variable: ptr gchar; value: ptr gchar; 
                      overwrite: gboolean): gboolean {.
      importc: "g_setenv_utf8", libglib.}
  proc g_unsetenv_utf8*(variable: ptr gchar) {.importc: "g_unsetenv_utf8", 
      libglib.}
'
j='proc g_listenv*(): ptr ptr gchar {.importc: "g_listenv", libglib.}
proc g_get_environ*(): ptr ptr gchar {.importc: "g_get_environ", libglib.}
proc g_environ_getenv*(envp: ptr ptr gchar; variable: ptr gchar): ptr gchar {.
    importc: "g_environ_getenv", libglib.}
proc g_environ_setenv*(envp: ptr ptr gchar; variable: ptr gchar; 
                       value: ptr gchar; overwrite: gboolean): ptr ptr gchar {.
    importc: "g_environ_setenv", libglib.}
proc g_environ_unsetenv*(envp: ptr ptr gchar; variable: ptr gchar): ptr ptr gchar {.
    importc: "g_environ_unsetenv", libglib.}
when defined(G_OS_WIN32): 
  proc g_getenv_utf8*(variable: ptr gchar): ptr gchar {.
      importc: "g_getenv_utf8", libglib.}
  proc g_setenv_utf8*(variable: ptr gchar; value: ptr gchar; 
                      overwrite: gboolean): gboolean {.
      importc: "g_setenv_utf8", libglib.}
  proc g_unsetenv_utf8*(variable: ptr gchar) {.importc: "g_unsetenv_utf8", 
      libglib.}
  const 
    g_getenv* = g_getenv_utf8
    g_setenv* = g_setenv_utf8
    g_unsetenv* = g_unsetenv_utf8
else:
  proc g_getenv*(variable: ptr gchar): ptr gchar {.importc: "g_getenv", 
      libglib.}
  proc g_setenv*(variable: ptr gchar; value: ptr gchar; overwrite: gboolean): gboolean {.
      importc: "g_setenv", libglib.}
  proc g_unsetenv*(variable: ptr gchar) {.importc: "g_unsetenv", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='when defined(G_OS_WIN32): 
  const 
    g_file_test* = g_file_test_utf8
    g_file_get_contents* = g_file_get_contents_utf8
    g_mkstemp* = g_mkstemp_utf8
    g_file_open_tmp* = g_file_open_tmp_utf8
    g_get_current_dir* = g_get_current_dir_utf8
  proc g_file_test_utf8*(filename: ptr gchar; test: GFileTest): gboolean {.
      importc: "g_file_test_utf8", libglib.}
  proc g_file_get_contents_utf8*(filename: ptr gchar; contents: ptr ptr gchar; 
                                 length: ptr gsize; error: ptr ptr GError): gboolean {.
      importc: "g_file_get_contents_utf8", libglib.}
  proc g_mkstemp_utf8*(tmpl: ptr gchar): gint {.importc: "g_mkstemp_utf8", 
      libglib.}
  proc g_file_open_tmp_utf8*(tmpl: ptr gchar; name_used: ptr ptr gchar; 
                             error: ptr ptr GError): gint {.
      importc: "g_file_open_tmp_utf8", libglib.}
  proc g_get_current_dir_utf8*(): ptr gchar {.
      importc: "g_get_current_dir_utf8", libglib.}
'
j='when defined(G_OS_WIN32): 
  proc g_file_test_utf8*(filename: ptr gchar; test: GFileTest): gboolean {.
      importc: "g_file_test_utf8", libglib.}
  proc g_file_get_contents_utf8*(filename: ptr gchar; contents: ptr ptr gchar; 
                                 length: ptr gsize; error: ptr ptr GError): gboolean {.
      importc: "g_file_get_contents_utf8", libglib.}
  proc g_mkstemp_utf8*(tmpl: ptr gchar): gint {.importc: "g_mkstemp_utf8", 
      libglib.}
  proc g_file_open_tmp_utf8*(tmpl: ptr gchar; name_used: ptr ptr gchar; 
                             error: ptr ptr GError): gint {.
      importc: "g_file_open_tmp_utf8", libglib.}
  proc g_get_current_dir_utf8*(): ptr gchar {.
      importc: "g_get_current_dir_utf8", libglib.}
  const 
    g_file_test* = g_file_test_utf8
    g_file_get_contents* = g_file_get_contents_utf8
    g_mkstemp* = g_mkstemp_utf8
    g_file_open_tmp* = g_file_open_tmp_utf8
    g_get_current_dir* = g_get_current_dir_utf8
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc g_file_test*(filename: ptr gchar; test: GFileTest): gboolean {.
    importc: "g_file_test", libglib.}
proc g_file_get_contents*(filename: ptr gchar; contents: ptr ptr gchar; 
                          length: ptr gsize; error: ptr ptr GError): gboolean {.
    importc: "g_file_get_contents", libglib.}
'
j='when not defined(G_OS_WIN32): 
  proc g_file_test*(filename: ptr gchar; test: GFileTest): gboolean {.
      importc: "g_file_test", libglib.}
  proc g_file_get_contents*(filename: ptr gchar; contents: ptr ptr gchar; 
                            length: ptr gsize; error: ptr ptr GError): gboolean {.
      importc: "g_file_get_contents", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc g_mkstemp*(tmpl: ptr gchar): gint {.importc: "g_mkstemp", libglib.}
'
j='when not defined(G_OS_WIN32): 
  proc g_mkstemp*(tmpl: ptr gchar): gint {.importc: "g_mkstemp", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc g_file_open_tmp*(tmpl: ptr gchar; name_used: ptr ptr gchar; 
                      error: ptr ptr GError): gint {.
    importc: "g_file_open_tmp", libglib.}
'
j='when not defined(G_OS_WIN32): 
  proc g_file_open_tmp*(tmpl: ptr gchar; name_used: ptr ptr gchar; 
                        error: ptr ptr GError): gint {.
      importc: "g_file_open_tmp", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc g_get_current_dir*(): ptr gchar {.importc: "g_get_current_dir", 
    libglib.}
'
j='when not defined(G_OS_WIN32): 
  proc g_get_current_dir*(): ptr gchar {.importc: "g_get_current_dir", 
      libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc g_io_channel_new_file*(filename: ptr gchar; mode: ptr gchar; 
                            error: ptr ptr GError): ptr GIOChannel {.
    importc: "g_io_channel_new_file", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='when defined(G_OS_WIN32): 
  const 
    g_io_channel_new_file* = g_io_channel_new_file_utf8
  proc g_io_channel_new_file_utf8*(filename: ptr gchar; mode: ptr gchar; 
                                   error: ptr ptr GError): ptr GIOChannel {.
      importc: "g_io_channel_new_file_utf8", libglib.}
'
j='when defined(G_OS_WIN32): 
  proc g_io_channel_new_file_utf8*(filename: ptr gchar; mode: ptr gchar; 
                                   error: ptr ptr GError): ptr GIOChannel {.
      importc: "g_io_channel_new_file_utf8", libglib.}
  const 
    g_io_channel_new_file* = g_io_channel_new_file_utf8
else:
  proc g_io_channel_new_file*(filename: ptr gchar; mode: ptr gchar; 
                              error: ptr ptr GError): ptr GIOChannel {.
      importc: "g_io_channel_new_file", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='proc g_spawn_async*(working_directory: ptr gchar; argv: ptr ptr gchar; 
                    envp: ptr ptr gchar; flags: GSpawnFlags; 
                    child_setup: GSpawnChildSetupFunc; user_data: gpointer; 
                    child_pid: ptr GPid; error: ptr ptr GError): gboolean {.
    importc: "g_spawn_async", libglib.}
proc g_spawn_async_with_pipes*(working_directory: ptr gchar; 
                               argv: ptr ptr gchar; envp: ptr ptr gchar; 
                               flags: GSpawnFlags; 
                               child_setup: GSpawnChildSetupFunc; 
                               user_data: gpointer; child_pid: ptr GPid; 
                               standard_input: ptr gint; 
                               standard_output: ptr gint; 
                               standard_error: ptr gint; error: ptr ptr GError): gboolean {.
    importc: "g_spawn_async_with_pipes", libglib.}
proc g_spawn_sync*(working_directory: ptr gchar; argv: ptr ptr gchar; 
                   envp: ptr ptr gchar; flags: GSpawnFlags; 
                   child_setup: GSpawnChildSetupFunc; user_data: gpointer; 
                   standard_output: ptr ptr gchar; 
                   standard_error: ptr ptr gchar; exit_status: ptr gint; 
                   error: ptr ptr GError): gboolean {.importc: "g_spawn_sync", 
    libglib.}
proc g_spawn_command_line_sync*(command_line: ptr gchar; 
                                standard_output: ptr ptr gchar; 
                                standard_error: ptr ptr gchar; 
                                exit_status: ptr gint; error: ptr ptr GError): gboolean {.
    importc: "g_spawn_command_line_sync", libglib.}
proc g_spawn_command_line_async*(command_line: ptr gchar; 
                                 error: ptr ptr GError): gboolean {.
    importc: "g_spawn_command_line_async", libglib.}
proc g_spawn_check_exit_status*(exit_status: gint; error: ptr ptr GError): gboolean {.
    importc: "g_spawn_check_exit_status", libglib.}
proc g_spawn_close_pid*(pid: GPid) {.importc: "g_spawn_close_pid", libglib.}
when defined(G_OS_WIN32): 
  const 
    g_spawn_async* = g_spawn_async_utf8
    g_spawn_async_with_pipes* = g_spawn_async_with_pipes_utf8
    g_spawn_sync* = g_spawn_sync_utf8
    g_spawn_command_line_sync* = g_spawn_command_line_sync_utf8
    g_spawn_command_line_async* = g_spawn_command_line_async_utf8
  proc g_spawn_async_utf8*(working_directory: ptr gchar; argv: ptr ptr gchar; 
                           envp: ptr ptr gchar; flags: GSpawnFlags; 
                           child_setup: GSpawnChildSetupFunc; 
                           user_data: gpointer; child_pid: ptr GPid; 
                           error: ptr ptr GError): gboolean {.
      importc: "g_spawn_async_utf8", libglib.}
  proc g_spawn_async_with_pipes_utf8*(working_directory: ptr gchar; 
                                      argv: ptr ptr gchar; 
                                      envp: ptr ptr gchar; flags: GSpawnFlags; 
                                      child_setup: GSpawnChildSetupFunc; 
                                      user_data: gpointer; 
                                      child_pid: ptr GPid; 
                                      standard_input: ptr gint; 
                                      standard_output: ptr gint; 
                                      standard_error: ptr gint; 
                                      error: ptr ptr GError): gboolean {.
      importc: "g_spawn_async_with_pipes_utf8", libglib.}
  proc g_spawn_sync_utf8*(working_directory: ptr gchar; argv: ptr ptr gchar; 
                          envp: ptr ptr gchar; flags: GSpawnFlags; 
                          child_setup: GSpawnChildSetupFunc; 
                          user_data: gpointer; standard_output: ptr ptr gchar; 
                          standard_error: ptr ptr gchar; 
                          exit_status: ptr gint; error: ptr ptr GError): gboolean {.
      importc: "g_spawn_sync_utf8", libglib.}
  proc g_spawn_command_line_sync_utf8*(command_line: ptr gchar; 
      standard_output: ptr ptr gchar; standard_error: ptr ptr gchar; 
      exit_status: ptr gint; error: ptr ptr GError): gboolean {.
      importc: "g_spawn_command_line_sync_utf8", libglib.}
  proc g_spawn_command_line_async_utf8*(command_line: ptr gchar; 
      error: ptr ptr GError): gboolean {.
      importc: "g_spawn_command_line_async_utf8", libglib.}
'
j='proc g_spawn_check_exit_status*(exit_status: gint; error: ptr ptr GError): gboolean {.
    importc: "g_spawn_check_exit_status", libglib.}
proc g_spawn_close_pid*(pid: GPid) {.importc: "g_spawn_close_pid", libglib.}
when defined(G_OS_WIN32): 
  proc g_spawn_async_utf8*(working_directory: ptr gchar; argv: ptr ptr gchar; 
                           envp: ptr ptr gchar; flags: GSpawnFlags; 
                           child_setup: GSpawnChildSetupFunc; 
                           user_data: gpointer; child_pid: ptr GPid; 
                           error: ptr ptr GError): gboolean {.
      importc: "g_spawn_async_utf8", libglib.}
  proc g_spawn_async_with_pipes_utf8*(working_directory: ptr gchar; 
                                      argv: ptr ptr gchar; 
                                      envp: ptr ptr gchar; flags: GSpawnFlags; 
                                      child_setup: GSpawnChildSetupFunc; 
                                      user_data: gpointer; 
                                      child_pid: ptr GPid; 
                                      standard_input: ptr gint; 
                                      standard_output: ptr gint; 
                                      standard_error: ptr gint; 
                                      error: ptr ptr GError): gboolean {.
      importc: "g_spawn_async_with_pipes_utf8", libglib.}
  proc g_spawn_sync_utf8*(working_directory: ptr gchar; argv: ptr ptr gchar; 
                          envp: ptr ptr gchar; flags: GSpawnFlags; 
                          child_setup: GSpawnChildSetupFunc; 
                          user_data: gpointer; standard_output: ptr ptr gchar; 
                          standard_error: ptr ptr gchar; 
                          exit_status: ptr gint; error: ptr ptr GError): gboolean {.
      importc: "g_spawn_sync_utf8", libglib.}
  proc g_spawn_command_line_sync_utf8*(command_line: ptr gchar; 
      standard_output: ptr ptr gchar; standard_error: ptr ptr gchar; 
      exit_status: ptr gint; error: ptr ptr GError): gboolean {.
      importc: "g_spawn_command_line_sync_utf8", libglib.}
  proc g_spawn_command_line_async_utf8*(command_line: ptr gchar; 
      error: ptr ptr GError): gboolean {.
      importc: "g_spawn_command_line_async_utf8", libglib.}
  const 
    g_spawn_async* = g_spawn_async_utf8
    g_spawn_async_with_pipes* = g_spawn_async_with_pipes_utf8
    g_spawn_sync* = g_spawn_sync_utf8
    g_spawn_command_line_sync* = g_spawn_command_line_sync_utf8
    g_spawn_command_line_async* = g_spawn_command_line_async_utf8
else:
  proc g_spawn_async*(working_directory: ptr gchar; argv: ptr ptr gchar; 
                      envp: ptr ptr gchar; flags: GSpawnFlags; 
                      child_setup: GSpawnChildSetupFunc; user_data: gpointer; 
                      child_pid: ptr GPid; error: ptr ptr GError): gboolean {.
      importc: "g_spawn_async", libglib.}
  proc g_spawn_async_with_pipes*(working_directory: ptr gchar; 
                                 argv: ptr ptr gchar; envp: ptr ptr gchar; 
                                 flags: GSpawnFlags; 
                                 child_setup: GSpawnChildSetupFunc; 
                                 user_data: gpointer; child_pid: ptr GPid; 
                                 standard_input: ptr gint; 
                                 standard_output: ptr gint; 
                                 standard_error: ptr gint; error: ptr ptr GError): gboolean {.
      importc: "g_spawn_async_with_pipes", libglib.}
  proc g_spawn_sync*(working_directory: ptr gchar; argv: ptr ptr gchar; 
                     envp: ptr ptr gchar; flags: GSpawnFlags; 
                     child_setup: GSpawnChildSetupFunc; user_data: gpointer; 
                     standard_output: ptr ptr gchar; 
                     standard_error: ptr ptr gchar; exit_status: ptr gint; 
                     error: ptr ptr GError): gboolean {.importc: "g_spawn_sync", 
      libglib.}
  proc g_spawn_command_line_sync*(command_line: ptr gchar; 
                                  standard_output: ptr ptr gchar; 
                                  standard_error: ptr ptr gchar; 
                                  exit_status: ptr gint; error: ptr ptr GError): gboolean {.
      importc: "g_spawn_command_line_sync", libglib.}
  proc g_spawn_command_line_async*(command_line: ptr gchar; 
                                   error: ptr ptr GError): gboolean {.
      importc: "g_spawn_command_line_async", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

sed -i 's/when defined(G_OS_UNIX): /when defined(unix): /g' final.nim
sed -i 's/when defined(VALIST): /when Va_List_Works:/g' final.nim

ruby ../glib_fix_proc.rb final.nim
ruby ../fix_template.rb final.nim
ruby ../glib_fix_T.rb final.nim glib
sed -i 's/ G_OPTION_FLAG_/ G_OPTION_FLAGS_/g' final.nim
sed -i 's/ G_IO_FLAG_/ G_IO_FLAGS_/g' final.nim
sed -i 's/ G_ERR_/ G_ERROR_TYPE_/g' final.nim
ruby ../glib_fix_enum_prefix.rb final.nim

# generate procs without get_ and set_ prefix
perl -0777 -p -i -e "s/(\n\s*)(proc set_)(\w+)(\*\([^}]*\) {[^}]*})/\$&\1proc \`\3=\`\4/sg" final.nim
perl -0777 -p -i -e "s/(\n\s*)(proc get_)(\w+)(\*\([^}]*\): \w[^}]*})/\$&\1proc \3\4/sg" final.nim

sed -i 's/\bproc type\b/proc `type`/g' final.nim

sed -i 's/^proc ref\*(/proc `ref`\*(/g' final.nim
sed -i 's/^proc end\*(/proc `end`\*(/g' final.nim
sed -i 's/^proc continue\*(/proc `continue`\*(/g' final.nim

i='  const 
    g_date_weekday* = g_date_get_weekday
    g_date_month* = g_date_get_month
    g_date_year* = g_date_get_year
    g_date_day* = g_date_get_day
    g_date_julian* = g_date_get_julian
    g_date_day_of_year* = g_date_get_day_of_year
    g_date_monday_week_of_year* = g_date_get_monday_week_of_year
    g_date_sunday_week_of_year* = g_date_get_sunday_week_of_year
    g_date_days_in_month* = g_date_get_days_in_month
    g_date_monday_weeks_in_year* = g_date_get_monday_weeks_in_year
    g_date_sunday_weeks_in_year* = g_date_get_sunday_weeks_in_year
'
j='  const 
    g_date_weekday* = get_weekday
    g_date_month* = get_month
    g_date_year* = get_year
    g_date_day* = get_day
    g_date_julian* = get_julian
    g_date_day_of_year* = get_day_of_year
    g_date_monday_week_of_year* = get_monday_week_of_year
    g_date_sunday_week_of_year* = get_sunday_week_of_year
    g_date_days_in_month* = get_days_in_month
    g_date_monday_weeks_in_year* = get_monday_weeks_in_year
    g_date_sunday_weeks_in_year* = get_sunday_weeks_in_year
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='  const 
    g_string_sprintf* = g_string_printf
    g_string_sprintfa* = g_string_append_printf
'
j='  const 
    g_string_sprintf* = printf
    g_string_sprintfa* = append_printf
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

sed -i 's/proc g_date_get_days_in_month\*(month/proc get_days_in_month\*(month/g' final.nim
sed -i 's/proc g_date_get_monday_weeks_in_year\*(/proc get_monday_weeks_in_year\*(/g' final.nim
sed -i 's/proc g_date_get_sunday_weeks_in_year\*(year:/proc get_sunday_weeks_in_year\*(year:/g' final.nim
sed -i 's/G_UNICODE_COMBINING_MARK\* = G_UNICODE_SPACING_MARK/G_UNICODE_COMBINING_MARK\* = GUnicodeType.SPACING_MARK/g' final.nim

sed -i 's/ ptr gchar\b/ cstring/g' final.nim
sed -i 's/ TRUE\b/ GTRUE/g' final.nim
sed -i 's/ FALSE\b/ GFALSE/g' final.nim

sed -i 's/\(when defined(G_ATOMIC_OP_MEMORY_BARRIER_NEEDED):\)/when false: # \1/g' final.nim
sed -i 's/\(when not defined(g_va_copy):\)/when false: # \1/g' final.nim
sed -i 's/\(when defined(GNUC) and defined(PPC) and\)/when false and # \1/g' final.nim
sed -i 's/\((defined(CALL_SYSV) or defined(WIN32)):\)/false: # \1/g' final.nim
sed -i 's/\(when (defined(MINGW_H) and not defined(STDLIB_H)) or\)/when false or # \1/g' final.nim
sed -i 's/\((defined(MSC_VER) and not defined(INC_STDLIB)):\)/false: # \1/g' final.nim
sed -i 's/\(when defined(GNUC) and (GNUC >= 4) and defined(OPTIMIZE):\)/when false: # \1/g' final.nim
sed -i 's/\(when defined(G_CAN_INLINE):\)/when false: # \1/g' final.nim
sed -i 's/\(when not(defined(G_LOG_DOMAIN)):\)/when false: # \1/g' final.nim
sed -i 's/\(when defined(G_ENABLE_DEBUG):\)/when false: # \1/g' final.nim
sed -i 's/\(when defined(G_CAN_INLINE) or defined(G_TRASH_STACK_C):\)/when false: # \1/g' final.nim
sed -i 's/\(when not(defined(G_DISABLE_CHECKS)):\)/when false: # \1/g' final.nim
sed -i 's/when defined(G_CAN_INLINE) or defined(G_UTILS_C):/when false: # &/g' final.nim
sed -i 's/and defined(G_CAN_INLINE) and/and false and # &/g' final.nim
sed -i 's/not defined(cplusplus):/true: # &/g' final.nim

# swap big/little endian -- we should not need these templates
i='template guint16_swap_le_pdp*(val: expr): expr = 
  ((guint16)(val))

template guint16_swap_be_pdp*(val: expr): expr = 
  (GUINT16_SWAP_LE_BE(val))

template guint32_swap_le_pdp*(val: expr): expr = 
  ((guint32)((((guint32)(val) and cast[guint32](0x0000FFFF)) shl 16) or
      (((guint32)(val) and cast[guint32](0xFFFF0000)) shr 16)))

template guint32_swap_be_pdp*(val: expr): expr = 
  ((guint32)((((guint32)(val) and cast[guint32](0x00FF00FF)) shl 8) or
      (((guint32)(val) and cast[guint32](0xFF00FF00)) shr 8)))

template gint16_from_le*(val: expr): expr = 
  (GINT16_TO_LE(val))

template guint16_from_le*(val: expr): expr = 
  (GUINT16_TO_LE(val))

template gint16_from_be*(val: expr): expr = 
  (GINT16_TO_BE(val))

template guint16_from_be*(val: expr): expr = 
  (GUINT16_TO_BE(val))

template gint32_from_le*(val: expr): expr = 
  (GINT32_TO_LE(val))

template guint32_from_le*(val: expr): expr = 
  (GUINT32_TO_LE(val))

template gint32_from_be*(val: expr): expr = 
  (GINT32_TO_BE(val))

template guint32_from_be*(val: expr): expr = 
  (GUINT32_TO_BE(val))

template gint64_from_le*(val: expr): expr = 
  (GINT64_TO_LE(val))

template guint64_from_le*(val: expr): expr = 
  (GUINT64_TO_LE(val))

template gint64_from_be*(val: expr): expr = 
  (GINT64_TO_BE(val))

template guint64_from_be*(val: expr): expr = 
  (GUINT64_TO_BE(val))

template glong_from_le*(val: expr): expr = 
  (GLONG_TO_LE(val))

template gulong_from_le*(val: expr): expr = 
  (GULONG_TO_LE(val))

template glong_from_be*(val: expr): expr = 
  (GLONG_TO_BE(val))

template gulong_from_be*(val: expr): expr = 
  (GULONG_TO_BE(val))

template gint_from_le*(val: expr): expr = 
  (GINT_TO_LE(val))

template guint_from_le*(val: expr): expr = 
  (GUINT_TO_LE(val))

template gint_from_be*(val: expr): expr = 
  (GINT_TO_BE(val))

template guint_from_be*(val: expr): expr = 
  (GUINT_TO_BE(val))

template gsize_from_le*(val: expr): expr = 
  (GSIZE_TO_LE(val))

template gssize_from_le*(val: expr): expr = 
  (GSSIZE_TO_LE(val))

template gsize_from_be*(val: expr): expr = 
  (GSIZE_TO_BE(val))

template gssize_from_be*(val: expr): expr = 
  (GSSIZE_TO_BE(val))

template g_ntohl*(val: expr): expr = 
  (guint32_from_be(val))

template g_ntohs*(val: expr): expr = 
  (guint16_from_be(val))

template g_htonl*(val: expr): expr = 
  (GUINT32_TO_BE(val))

template g_htons*(val: expr): expr = 
  (GUINT16_TO_BE(val))
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='template g_array_append_val*(a, v: expr): expr = 
  g_array_append_vals(a, addr((v)), 1)

template g_array_prepend_val*(a, v: expr): expr = 
  g_array_prepend_vals(a, addr((v)), 1)

template g_array_insert_val*(a, i, v: expr): expr = 
  g_array_insert_vals(a, i, addr((v)), 1)
'
j='template append_val*(a, v: expr): expr = 
  append_vals(a, addr((v)), 1)

template prepend_val*(a, v: expr): expr = 
  prepend_vals(a, addr((v)), 1)

template insert_val*(a, i, v: expr): expr = 
  insert_vals(a, i, addr((v)), 1)
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

sed -i 's/^proc g_rw_lock_/proc /g' final.nim
sed -i 's/ g_once_impl(/ impl(/g' final.nim
sed -i 's/^  g_node_insert_/  insert_/g' final.nim

i='template g_test_initialized*(): expr = 
  (g_test_config_vars.test_initialized)

template g_test_quick*(): expr = 
  (g_test_config_vars.test_quick)

template g_test_slow*(): expr = 
  (not g_test_config_vars.test_quick)

template g_test_thorough*(): expr = 
  (not g_test_config_vars.test_quick)

template g_test_perf*(): expr = 
  (g_test_config_vars.test_perf)

template g_test_verbose*(): expr = 
  (g_test_config_vars.test_verbose)

template g_test_quiet*(): expr = 
  (g_test_config_vars.test_quiet)

template g_test_undefined*(): expr = 
  (g_test_config_vars.test_undefined)
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='when not(defined(G_DISABLE_DEPRECATED)): 
  const 
    g_dirname* = g_path_get_dirname
when not defined(G_OS_WIN32): 
  proc g_get_current_dir*(): cstring {.importc: "g_get_current_dir", 
      libglib.}
proc g_path_get_basename*(file_name: cstring): cstring {.
    importc: "g_path_get_basename", libglib.}
proc g_path_get_dirname*(file_name: cstring): cstring {.
    importc: "g_path_get_dirname", libglib.}
'
j='when not defined(G_OS_WIN32): 
  proc g_get_current_dir*(): cstring {.importc: "g_get_current_dir", 
      libglib.}
proc g_path_get_basename*(file_name: cstring): cstring {.
    importc: "g_path_get_basename", libglib.}
proc g_path_get_dirname*(file_name: cstring): cstring {.
    importc: "g_path_get_dirname", libglib.}
when not(defined(G_DISABLE_DEPRECATED)): 
  const 
    g_dirname* = g_path_get_dirname
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

# we should add it to sed_list also
sed -i '1is/\\bptr GMutex\\b/ptttttrGMutex/g' glib_sedlist
sed -i 's/ ptr GMutex/ GMutex/g' final.nim
i='type 
  GMutex* = object  {.union.}
    p*: gpointer
    i*: array[2, guint]
'
j='type
  GMutex* = ptr GMutexObj
  GMutexPtr* = ptr GMutexObj
  GMutexObj* = object  {.union.}
    p*: gpointer
    i*: array[2, guint]
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

sed -i 's/GTokenValue* = object  {.union.}/GTokenValue* {.final, pure.} = object  {.union.}/g' final.nim
sed -i 's/ out_len: ptr gsize/ out_len: var gsize/g' final.nim
sed -i 's/ length: ptr gsize/ length: var gsize/g' final.nim
sed -i 's/ count: ptr guint/ count: var guint/g' final.nim
sed -i 's/ size: ptr gsize/ size: var gsize/g' final.nim
sed -i 's/ digest_len: ptr gsize/ digest_len: var gsize/g' final.nim
sed -i 's/ inbytes_left: ptr gsize; outbuf/ inbytes_left: var gsize; outbuf/g' final.nim
sed -i 's/ outbytes_left: ptr gsize/ outbytes_left: var gsize/g' final.nim
sed -i 's/ bytes_written: ptr gsize/ bytes_written: var gsize/g' final.nim
sed -i 's/ bytes_read: ptr gsize/ bytes_read: var gsize/g' final.nim
sed -i 's/ result_len: ptr gsize/ result_len: var gsize/g' final.nim
sed -i 's/ items_read: ptr glong/ items_read: var glong/g' final.nim
sed -i 's/ items_written: ptr glong/ items_written: var glong/g' final.nim
sed -i 's/ start_pos: ptr gint/ start_pos: var gint/g' final.nim
sed -i 's/ end_pos: ptr gint/ end_pos: var gint/g' final.nim
sed -i 's/ n_values: ptr guint/ n_values: var guint/g' final.nim
sed -i 's/ bytes: ptr guint8/ bytes: var guint8/g' final.nim
sed -i 's/ exit_status: ptr gint;/ exit_status: var gint;/g' final.nim
sed -i 's/ standard_error: ptr gint;/ standard_error: var gint;/g' final.nim
sed -i 's/ has_references: ptr gboolean/ has_references: var gboolean/g' final.nim
sed -i 's/line_number: ptr gint; char_number: ptr gint/line_number: var gint; char_number: var gint/g' final.nim
sed -i 's/ length: ptr gint/ length: var gint/g' final.nim
#sed -i 's/ ptr ptr cstring/ var ptr cstring/g' final.nim # carefully check benefit

i='proc get_ymd*(datetime: GDateTime; year: ptr gint; 
                          month: ptr gint; day: ptr gint) {.
    importc: "g_date_time_get_ymd", libglib.}
'
j='proc get_ymd*(datetime: GDateTime; year: var gint; 
                          month: var gint; day: var gint) {.
    importc: "g_date_time_get_ymd", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

sed -i 's/\(dummy[0-9]\?\)\*/\1/g' final.nim
sed -i 's/\(reserved[0-9]\?\)\*/\1/g' final.nim
sed -i 's/proc type\*(/proc `type`\*(/g' final.nim

sed -i 's/[(][(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/(\1/g' final.nim
sed -i 's/, [(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/, \1/g' final.nim

sed -i 's/when defined(G_OS_WIN32)/when defined(windows)/g' final.nim
sed -i 's/when not defined(G_OS_WIN32)/when not defined(windows)/g' final.nim

ruby ../fix_object_of.rb final.nim

perl -0777 -p -i -e "s~([=:] proc \(.*?\)(?:: \w+)?)~\1 {.cdecl.}~sg" final.nim
sed -i 's/\([,=(<>] \{0,1\}\)[(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/\1\2/g' final.nim

sed -i '/  gboolean\* = gint/d' final.nim
sed -i 's/  gchar\* = char/  gchar* = cchar/g' final.nim

i='const
  GFALSE* = cint(0)
  GTRUE* = not GFALSE
'
j='type
  gboolean* = distinct cint

# we should not need these constants often, because we have converters to and from Nim bool
const
  GFALSE* = gboolean(0)
  GTRUE* = gboolean(1)

converter gbool*(nimbool: bool): gboolean =
  ord(nimbool).gboolean

converter toBool*(gbool: gboolean): bool =
  int(gbool) != 0

const
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

sed -i '/^#type $/d' final.nim
sed -i 's/  g_datalist_id_set_data_full(dl, /  id_set_data_full(dl, /g' final.nim
sed -i 's/  g_datalist_id_remove_no_notify(dl, /  id_remove_no_notify(dl, /g' final.nim
sed -i 's/  g_node_insert(parent, /  insert(parent, /g' final.nim
sed -i 's/  g_node_prepend(parent, /  prepend(parent, /g' final.nim
sed -i 's/  g_hook_insert_before(hook_list/  insert_before(hook_list/g' final.nim

i='template g_rand_boolean*(rand: expr): expr = 
  ((g_rand_int(rand) and (1 shl 15)) != 0)

proc int*(rand: GRand): guint32 {.importc: "g_rand_int", 
    libglib.}
'
j='proc g_rand_int*(rand: GRand): guint32 {.importc: "g_rand_int", 
    libglib.}
proc g_rand_boolean*(rand: GRand): gboolean {.inline.} =
  #ord((g_rand_int(rand) and (1 shl 15)) != 0).gboolean
  #(g_rand_int(rand) and (1 shl 15)) shr 15
  cast[gboolean]((cast[int32](g_rand_int(rand)) and (1 shl 15)) shr 15)
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='        2, G_ASCII_DIGIT = 1 shl 3, G_ASCII_GRAPH = 1 shl 4, 
    G_ASCII_LOWER = 1 shl 5, G_ASCII_PRINT = 1 shl 6, G_ASCII_PUNCT = 1 shl
        7, G_ASCII_SPACE = 1 shl 8, G_ASCII_UPPER = 1 shl 9, 
    G_ASCII_XDIGIT = 1 shl 10
'
j='        2, DIGIT = 1 shl 3, GRAPH = 1 shl 4, 
    LOWER = 1 shl 5, PRINT = 1 shl 6, PUNCT = 1 shl
        7, SPACE = 1 shl 8, UPPER = 1 shl 9, 
    XDIGIT = 1 shl 10
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

i='template g_ascii_isalnum*(c: expr): expr = 
  ((g_ascii_table[(guchar)(c)] and G_ASCII_ALNUM) != 0)

template g_ascii_isalpha*(c: expr): expr = 
  ((g_ascii_table[(guchar)(c)] and G_ASCII_ALPHA) != 0)

template g_ascii_iscntrl*(c: expr): expr = 
  ((g_ascii_table[(guchar)(c)] and G_ASCII_CNTRL) != 0)

template g_ascii_isdigit*(c: expr): expr = 
  ((g_ascii_table[(guchar)(c)] and G_ASCII_DIGIT) != 0)

template g_ascii_isgraph*(c: expr): expr = 
  ((g_ascii_table[(guchar)(c)] and G_ASCII_GRAPH) != 0)

template g_ascii_islower*(c: expr): expr = 
  ((g_ascii_table[(guchar)(c)] and G_ASCII_LOWER) != 0)

template g_ascii_isprint*(c: expr): expr = 
  ((g_ascii_table[(guchar)(c)] and G_ASCII_PRINT) != 0)

template g_ascii_ispunct*(c: expr): expr = 
  ((g_ascii_table[(guchar)(c)] and G_ASCII_PUNCT) != 0)

template g_ascii_isspace*(c: expr): expr = 
  ((g_ascii_table[(guchar)(c)] and G_ASCII_SPACE) != 0)

template g_ascii_isupper*(c: expr): expr = 
  ((g_ascii_table[(guchar)(c)] and G_ASCII_UPPER) != 0)

template g_ascii_isxdigit*(c: expr): expr = 
  ((g_ascii_table[(guchar)(c)] and G_ASCII_XDIGIT) != 0)
'
j="var g_ascii_table: array[256, int16]

g_ascii_table[0..127] = [
  0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16,
  0x004'i16, 0x104'i16, 0x104'i16, 0x004'i16, 0x104'i16, 0x104'i16, 0x004'i16, 0x004'i16,
  0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16,
  0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16, 0x004'i16,
  0x140'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16,
  0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16,
  0x459'i16, 0x459'i16, 0x459'i16, 0x459'i16, 0x459'i16, 0x459'i16, 0x459'i16, 0x459'i16,
  0x459'i16, 0x459'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16,
  0x0d0'i16, 0x653'i16, 0x653'i16, 0x653'i16, 0x653'i16, 0x653'i16, 0x653'i16, 0x253'i16,
  0x253'i16, 0x253'i16, 0x253'i16, 0x253'i16, 0x253'i16, 0x253'i16, 0x253'i16, 0x253'i16,
  0x253'i16, 0x253'i16, 0x253'i16, 0x253'i16, 0x253'i16, 0x253'i16, 0x253'i16, 0x253'i16,
  0x253'i16, 0x253'i16, 0x253'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16,
  0x0d0'i16, 0x473'i16, 0x473'i16, 0x473'i16, 0x473'i16, 0x473'i16, 0x473'i16, 0x073'i16,
  0x073'i16, 0x073'i16, 0x073'i16, 0x073'i16, 0x073'i16, 0x073'i16, 0x073'i16, 0x073'i16,
  0x073'i16, 0x073'i16, 0x073'i16, 0x073'i16, 0x073'i16, 0x073'i16, 0x073'i16, 0x073'i16,
  0x073'i16, 0x073'i16, 0x073'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x0d0'i16, 0x004'i16]

proc g_ascii_isalnum*(c: guchar): bool = 
  (g_ascii_table[c.ord] and GAsciiType.ALNUM.ord) != 0

proc g_ascii_isalpha*(c: guchar): bool = 
  (g_ascii_table[c.ord] and GAsciiType.ALPHA.ord) != 0

proc g_ascii_iscntrl*(c: guchar): bool = 
  (g_ascii_table[c.ord] and GAsciiType.CNTRL.ord) != 0

proc g_ascii_isdigit*(c: guchar): bool = 
  (g_ascii_table[c.ord] and GAsciiType.DIGIT.ord) != 0

proc g_ascii_isgraph*(c: guchar): bool = 
  (g_ascii_table[c.ord] and GAsciiType.GRAPH.ord) != 0

proc g_ascii_islower*(c: guchar): bool = 
  (g_ascii_table[c.ord] and GAsciiType.LOWER.ord) != 0

proc g_ascii_isprint*(c: guchar): bool = 
  (g_ascii_table[c.ord] and GAsciiType.PRINT.ord) != 0

proc g_ascii_ispunct*(c: guchar): bool = 
  (g_ascii_table[c.ord] and GAsciiType.PUNCT.ord) != 0

proc g_ascii_isspace*(c: guchar): bool = 
  (g_ascii_table[c.ord] and GAsciiType.SPACE.ord) != 0

proc g_ascii_isupper*(c: guchar): bool = 
  (g_ascii_table[c.ord] and GAsciiType.UPPER.ord) != 0

proc g_ascii_isxdigit*(c: guchar): bool = 
  (g_ascii_table[c.ord] and GAsciiType.XDIGIT.ord) != 0
"
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

# some procs with get_ prefix do not return something but need var objects instead of pointers:
# vim search term for candidates: proc get_.*\n\?.*\n\?.*) {
i='proc get_current_time*(source: GSource; timeval: GTimeVal) {.
    importc: "g_source_get_current_time", libglib.}
'
j='proc get_current_time*(source: GSource; timeval: var GTimeValObj) {.
    importc: "g_source_get_current_time", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

# these may generate trouble
i='proc string*(checksum: GChecksum): cstring {.
    importc: "g_checksum_get_string", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc string*(hmac: GHmac): cstring {.
    importc: "g_hmac_get_string", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc string*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; error: var GError): cstring {.
    importc: "g_key_file_get_string", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc string*(match_info: GMatchInfo): cstring {.
    importc: "g_match_info_get_string", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc string*(value: GVariant; length: var gsize): cstring {.
    importc: "g_variant_get_string", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc boolean*(key_file: GKeyFile; group_name: cstring; 
                             key: cstring; error: var GError): gboolean {.
    importc: "g_key_file_get_boolean", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc integer*(key_file: GKeyFile; group_name: cstring; 
                             key: cstring; error: var GError): gint {.
    importc: "g_key_file_get_integer", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc int64*(key_file: GKeyFile; group_name: cstring; 
                           key: cstring; error: var GError): gint64 {.
    importc: "g_key_file_get_int64", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc uint64*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; error: var GError): guint64 {.
    importc: "g_key_file_get_uint64", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc double*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; error: var GError): gdouble {.
    importc: "g_key_file_get_double", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc int*(rand: GRand): guint32 {.importc: "g_rand_int", 
    libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc int16*(value: GVariant): gint16 {.
    importc: "g_variant_get_int16", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc uint16*(value: GVariant): guint16 {.
    importc: "g_variant_get_uint16", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc int32*(value: GVariant): gint32 {.
    importc: "g_variant_get_int32", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc uint32*(value: GVariant): guint32 {.
    importc: "g_variant_get_uint32", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc int64*(value: GVariant): gint64 {.
    importc: "g_variant_get_int64", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc uint64*(value: GVariant): guint64 {.
    importc: "g_variant_get_uint64", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

i='proc double*(value: GVariant): gdouble {.
    importc: "g_variant_get_double", libglib.}
'
perl -0777 -p -i -e "s/\Q$i\E//s" final.nim

sed -i 's/\bptr cstring\b/cstringArray/g' final.nim

cat -s final.nim > glib.nim

ruby ../gen_proc_dep.rb glib.nim

sed -i '/{\.deprecated: \[g_date_set_time: set_time\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[g_dir_read_name_utf8: read_name_utf8\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[g_string_vprintf: vprintf\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[g_string_append_vprintf: append_vprintf\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[g_io_channel_win32/d' proc_dep_list
sed -i '/{\.deprecated: \[g_variant_get_va: get_va\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[g_variant_check_format_string: check_format_string\]\.}/d' proc_dep_list

sed -i 's/\bfunc\([):,\*]\)/`func`\1/' glib.nim

cat proc_dep_list >> glib.nim

rm -r glib
rm final.h final.nim list.txt proc_dep_list

exit

