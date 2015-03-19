{.deadCodeElim: on.}

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

type
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

type 
  gchar* = cchar
  gshort* = cshort
  glong* = clong
  gint* = cint
  guchar* = cuchar
  gushort* = cushort
  gulong* = culong
  guint* = cuint
  gfloat* = cfloat
  gdouble* = cdouble
const 
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
type 
  gpointer* = pointer
  gconstpointer* = pointer
  GCompareFunc* = proc (a: gconstpointer; b: gconstpointer): gint {.cdecl.}
  GCompareDataFunc* = proc (a: gconstpointer; b: gconstpointer; 
                            user_data: gpointer): gint {.cdecl.}
  GEqualFunc* = proc (a: gconstpointer; b: gconstpointer): gboolean {.cdecl.}
  GDestroyNotify* = proc (data: gpointer) {.cdecl.}
  GFunc* = proc (data: gpointer; user_data: gpointer) {.cdecl.}
  GHashFunc* = proc (key: gconstpointer): guint {.cdecl.}
  GHFunc* = proc (key: gpointer; value: gpointer; user_data: gpointer) {.cdecl.}
type 
  GFreeFunc* = proc (data: gpointer) {.cdecl.}
type 
  GTranslateFunc* = proc (str: cstring; data: gpointer): cstring {.cdecl.}
const 
  G_E* = 2.718281828459045
  G_LN2* = 0.6931471805599453
  G_LN10* = 2.302585092994046
  G_PI* = 3.141592653589793
  G_PI_2* = 1.570796326794897
  G_PI_4* = 0.7853981633974483
  G_SQRT2* = 1.414213562373095
const 
  G_LITTLE_ENDIAN* = 1234
  G_BIG_ENDIAN* = 4321
  G_PDP_ENDIAN* = 3412
template guint16_swap_le_be_constant*(val: expr): expr = 
  (guint16(guint16(guint16(val) shr 8) or
      (guint16)(guint16(val) shl 8)))

template guint32_swap_le_be_constant*(val: expr): expr = 
  (guint32(((guint32(val) and cast[guint32](0x000000FF)) shl 24) or
      ((guint32(val) and cast[guint32](0x0000FF00)) shl 8) or
      ((guint32(val) and cast[guint32](0x00FF0000)) shr 8) or
      ((guint32(val) and cast[guint32](0xFF000000)) shr 24)))

template guint64_swap_le_be_constant*(val: expr): expr = 
  (guint64(((guint64(val) and
      cast[guint64](G_GINT64_CONSTANT(0x00000000000000FF'i64))) shl 56) or
      ((guint64(val) and
      cast[guint64](G_GINT64_CONSTANT(0x000000000000FF00'i64))) shl 40) or
      ((guint64(val) and
      cast[guint64](G_GINT64_CONSTANT(0x0000000000FF0000'i64))) shl 24) or
      ((guint64(val) and
      cast[guint64](G_GINT64_CONSTANT(0x00000000FF000000'i64))) shl 8) or
      ((guint64(val) and
      cast[guint64](G_GINT64_CONSTANT(0x000000FF00000000'i64))) shr 8) or
      ((guint64(val) and
      cast[guint64](G_GINT64_CONSTANT(0x0000FF0000000000'i64))) shr 24) or
      ((guint64(val) and
      cast[guint64](G_GINT64_CONSTANT(0x00FF000000000000'i64))) shr 40) or
      ((guint64(val) and
      cast[guint64](G_GINT64_CONSTANT(0xFF00000000000000'i64))) shr 56)))

type 
  GTimeVal* =  ptr GTimeValObj
  GTimeValPtr* = ptr GTimeValObj
  GTimeValObj* = object 
    tv_sec*: glong
    tv_usec*: glong

type 
  GBytes* =  ptr GBytesObj
  GBytesPtr* = ptr GBytesObj
  GBytesObj* = object 
  
type 
  GArray* =  ptr GArrayObj
  GArrayPtr* = ptr GArrayObj
  GArrayObj* = object 
    data*: cstring
    len*: guint

type 
  GByteArray* =  ptr GByteArrayObj
  GByteArrayPtr* = ptr GByteArrayObj
  GByteArrayObj* = object 
    data*: ptr guint8
    len*: guint

type 
  GPtrArray* =  ptr GPtrArrayObj
  GPtrArrayPtr* = ptr GPtrArrayObj
  GPtrArrayObj* = object 
    pdata*: ptr gpointer
    len*: guint

template append_val*(a, v: expr): expr = 
  append_vals(a, addr(v), 1)

template prepend_val*(a, v: expr): expr = 
  prepend_vals(a, addr(v), 1)

template insert_val*(a, i, v: expr): expr = 
  insert_vals(a, i, addr(v), 1)

template g_array_index*(a, t, i: expr): expr = 
  ((cast[ptr t](cast[pointer](a.data)))[(i)])

proc g_array_new*(zero_terminated: gboolean; clear: gboolean; 
                  element_size: guint): GArray {.importc: "g_array_new", 
    libglib.}
proc g_array_sized_new*(zero_terminated: gboolean; clear: gboolean; 
                        element_size: guint; reserved_size: guint): GArray {.
    importc: "g_array_sized_new", libglib.}
proc free*(array: GArray; free_segment: gboolean): cstring {.
    importc: "g_array_free", libglib.}
proc `ref`*(array: GArray): GArray {.importc: "g_array_ref", 
    libglib.}
proc unref*(array: GArray) {.importc: "g_array_unref", libglib.}
proc get_element_size*(array: GArray): guint {.
    importc: "g_array_get_element_size", libglib.}
proc element_size*(array: GArray): guint {.
    importc: "g_array_get_element_size", libglib.}
proc append_vals*(array: GArray; data: gconstpointer; len: guint): GArray {.
    importc: "g_array_append_vals", libglib.}
proc prepend_vals*(array: GArray; data: gconstpointer; len: guint): GArray {.
    importc: "g_array_prepend_vals", libglib.}
proc insert_vals*(array: GArray; index: guint; 
                          data: gconstpointer; len: guint): GArray {.
    importc: "g_array_insert_vals", libglib.}
proc set_size*(array: GArray; length: guint): GArray {.
    importc: "g_array_set_size", libglib.}
proc remove_index*(array: GArray; index: guint): GArray {.
    importc: "g_array_remove_index", libglib.}
proc remove_index_fast*(array: GArray; index: guint): GArray {.
    importc: "g_array_remove_index_fast", libglib.}
proc remove_range*(array: GArray; index: guint; length: guint): GArray {.
    importc: "g_array_remove_range", libglib.}
proc sort*(array: GArray; compare_func: GCompareFunc) {.
    importc: "g_array_sort", libglib.}
proc sort_with_data*(array: GArray; 
                             compare_func: GCompareDataFunc; 
                             user_data: gpointer) {.
    importc: "g_array_sort_with_data", libglib.}
proc set_clear_func*(array: GArray; clear_func: GDestroyNotify) {.
    importc: "g_array_set_clear_func", libglib.}
proc `clear_func=`*(array: GArray; clear_func: GDestroyNotify) {.
    importc: "g_array_set_clear_func", libglib.}
template g_ptr_array_index*(array, index: expr): expr = 
  (array.pdata)[index]

proc g_ptr_array_new*(): GPtrArray {.importc: "g_ptr_array_new", 
    libglib.}
proc g_ptr_array_new_with_free_func*(element_free_func: GDestroyNotify): GPtrArray {.
    importc: "g_ptr_array_new_with_free_func", libglib.}
proc g_ptr_array_sized_new*(reserved_size: guint): GPtrArray {.
    importc: "g_ptr_array_sized_new", libglib.}
proc g_ptr_array_new_full*(reserved_size: guint; 
                           element_free_func: GDestroyNotify): GPtrArray {.
    importc: "g_ptr_array_new_full", libglib.}
proc free*(array: GPtrArray; free_seg: gboolean): ptr gpointer {.
    importc: "g_ptr_array_free", libglib.}
proc `ref`*(array: GPtrArray): GPtrArray {.
    importc: "g_ptr_array_ref", libglib.}
proc unref*(array: GPtrArray) {.importc: "g_ptr_array_unref", 
    libglib.}
proc set_free_func*(array: GPtrArray; 
                                element_free_func: GDestroyNotify) {.
    importc: "g_ptr_array_set_free_func", libglib.}
proc `free_func=`*(array: GPtrArray; 
                                element_free_func: GDestroyNotify) {.
    importc: "g_ptr_array_set_free_func", libglib.}
proc set_size*(array: GPtrArray; length: gint) {.
    importc: "g_ptr_array_set_size", libglib.}
proc `size=`*(array: GPtrArray; length: gint) {.
    importc: "g_ptr_array_set_size", libglib.}
proc remove_index*(array: GPtrArray; index: guint): gpointer {.
    importc: "g_ptr_array_remove_index", libglib.}
proc remove_index_fast*(array: GPtrArray; index: guint): gpointer {.
    importc: "g_ptr_array_remove_index_fast", libglib.}
proc remove*(array: GPtrArray; data: gpointer): gboolean {.
    importc: "g_ptr_array_remove", libglib.}
proc remove_fast*(array: GPtrArray; data: gpointer): gboolean {.
    importc: "g_ptr_array_remove_fast", libglib.}
proc remove_range*(array: GPtrArray; index: guint; 
                               length: guint): GPtrArray {.
    importc: "g_ptr_array_remove_range", libglib.}
proc add*(array: GPtrArray; data: gpointer) {.
    importc: "g_ptr_array_add", libglib.}
proc insert*(array: GPtrArray; index: gint; data: gpointer) {.
    importc: "g_ptr_array_insert", libglib.}
proc sort*(array: GPtrArray; compare_func: GCompareFunc) {.
    importc: "g_ptr_array_sort", libglib.}
proc sort_with_data*(array: GPtrArray; 
                                 compare_func: GCompareDataFunc; 
                                 user_data: gpointer) {.
    importc: "g_ptr_array_sort_with_data", libglib.}
proc foreach*(array: GPtrArray; `func`: GFunc; 
                          user_data: gpointer) {.
    importc: "g_ptr_array_foreach", libglib.}
proc g_byte_array_new*(): GByteArray {.importc: "g_byte_array_new", 
    libglib.}
proc g_byte_array_new_take*(data: ptr guint8; len: gsize): GByteArray {.
    importc: "g_byte_array_new_take", libglib.}
proc g_byte_array_sized_new*(reserved_size: guint): GByteArray {.
    importc: "g_byte_array_sized_new", libglib.}
proc free*(array: GByteArray; free_segment: gboolean): ptr guint8 {.
    importc: "g_byte_array_free", libglib.}
proc free_to_bytes*(array: GByteArray): GBytes {.
    importc: "g_byte_array_free_to_bytes", libglib.}
proc `ref`*(array: GByteArray): GByteArray {.
    importc: "g_byte_array_ref", libglib.}
proc unref*(array: GByteArray) {.
    importc: "g_byte_array_unref", libglib.}
proc append*(array: GByteArray; data: ptr guint8; len: guint): GByteArray {.
    importc: "g_byte_array_append", libglib.}
proc prepend*(array: GByteArray; data: ptr guint8; len: guint): GByteArray {.
    importc: "g_byte_array_prepend", libglib.}
proc set_size*(array: GByteArray; length: guint): GByteArray {.
    importc: "g_byte_array_set_size", libglib.}
proc remove_index*(array: GByteArray; index: guint): GByteArray {.
    importc: "g_byte_array_remove_index", libglib.}
proc remove_index_fast*(array: GByteArray; index: guint): GByteArray {.
    importc: "g_byte_array_remove_index_fast", libglib.}
proc remove_range*(array: GByteArray; index: guint; 
                                length: guint): GByteArray {.
    importc: "g_byte_array_remove_range", libglib.}
proc sort*(array: GByteArray; compare_func: GCompareFunc) {.
    importc: "g_byte_array_sort", libglib.}
proc sort_with_data*(array: GByteArray; 
                                  compare_func: GCompareDataFunc; 
                                  user_data: gpointer) {.
    importc: "g_byte_array_sort_with_data", libglib.}

type 
  GQuark* = guint32
proc g_quark_try_string*(string: cstring): GQuark {.
    importc: "g_quark_try_string", libglib.}
proc g_quark_from_static_string*(string: cstring): GQuark {.
    importc: "g_quark_from_static_string", libglib.}
proc g_quark_from_string*(string: cstring): GQuark {.
    importc: "g_quark_from_string", libglib.}
proc to_string*(quark: GQuark): cstring {.
    importc: "g_quark_to_string", libglib.}
proc g_intern_string*(string: cstring): cstring {.
    importc: "g_intern_string", libglib.}
proc g_intern_static_string*(string: cstring): cstring {.
    importc: "g_intern_static_string", libglib.}

type 
  GError* =  ptr GErrorObj
  GErrorPtr* = ptr GErrorObj
  GErrorObj* = object 
    domain*: GQuark
    code*: gint
    message*: cstring

proc g_error_new*(domain: GQuark; code: gint; format: cstring): GError {.
    varargs, importc: "g_error_new", libglib.}
proc g_error_new_literal*(domain: GQuark; code: gint; message: cstring): GError {.
    importc: "g_error_new_literal", libglib.}
when Va_List_Works:
  proc g_error_new_valist*(domain: GQuark; code: gint; format: cstring; 
                           args: va_list): GError {.
      importc: "g_error_new_valist", libglib.}
proc free*(error: GError) {.importc: "g_error_free", libglib.}
proc copy*(error: GError): GError {.importc: "g_error_copy", 
    libglib.}
proc matches*(error: GError; domain: GQuark; code: gint): gboolean {.
    importc: "g_error_matches", libglib.}
proc g_set_error*(err: var GError; domain: GQuark; code: gint; 
                  format: cstring) {.varargs, importc: "g_set_error", 
    libglib.}
proc g_set_error_literal*(err: var GError; domain: GQuark; code: gint; 
                          message: cstring) {.
    importc: "g_set_error_literal", libglib.}
proc g_propagate_error*(dest: var GError; src: GError) {.
    importc: "g_propagate_error", libglib.}
proc g_clear_error*(err: var GError) {.importc: "g_clear_error", 
    libglib.}
proc g_prefix_error*(err: var GError; format: cstring) {.varargs, 
    importc: "g_prefix_error", libglib.}
proc g_propagate_prefixed_error*(dest: var GError; src: GError; 
                                 format: cstring) {.varargs, 
    importc: "g_propagate_prefixed_error", libglib.}

proc g_thread_error_quark*(): GQuark {.importc: "g_thread_error_quark", 
    libglib.}
type 
  GThreadError* {.size: sizeof(cint), pure.} = enum 
    AGAIN
  GThreadFunc* = proc (data: gpointer): gpointer {.cdecl.}
  GThread* =  ptr GThreadObj
  GThreadPtr* = ptr GThreadObj
  GThreadObj* = object 
  
type
  GMutex* = ptr GMutexObj
  GMutexPtr* = ptr GMutexObj
  GMutexObj* = object  {.union.}
    p*: gpointer
    i*: array[2, guint]

type 
  GRWLock* =  ptr GRWLockObj
  GRWLockPtr* = ptr GRWLockObj
  GRWLockObj* = object 
    p*: gpointer
    i*: array[2, guint]

type 
  GCond* =  ptr GCondObj
  GCondPtr* = ptr GCondObj
  GCondObj* = object 
    p*: gpointer
    i*: array[2, guint]

type 
  GRecMutex* =  ptr GRecMutexObj
  GRecMutexPtr* = ptr GRecMutexObj
  GRecMutexObj* = object 
    p*: gpointer
    i*: array[2, guint]

type 
  GPrivate* =  ptr GPrivateObj
  GPrivatePtr* = ptr GPrivateObj
  GPrivateObj* = object 
    p*: gpointer
    notify*: GDestroyNotify
    future*: array[2, gpointer]

type 
  GOnceStatus* {.size: sizeof(cint), pure.} = enum 
    NOTCALLED, PROGRESS, READY
type 
  GOnce* =  ptr GOnceObj
  GOncePtr* = ptr GOnceObj
  GOnceObj* = object 
    status*: GOnceStatus
    retval*: gpointer

proc `ref`*(thread: GThread): GThread {.
    importc: "g_thread_ref", libglib.}
proc unref*(thread: GThread) {.importc: "g_thread_unref", 
    libglib.}
proc g_thread_new*(name: cstring; `func`: GThreadFunc; data: gpointer): GThread {.
    importc: "g_thread_new", libglib.}
proc g_thread_try_new*(name: cstring; `func`: GThreadFunc; data: gpointer; 
                       error: var GError): GThread {.
    importc: "g_thread_try_new", libglib.}
proc g_thread_self*(): GThread {.importc: "g_thread_self", libglib.}
proc g_thread_exit*(retval: gpointer) {.importc: "g_thread_exit", libglib.}
proc join*(thread: GThread): gpointer {.importc: "g_thread_join", 
    libglib.}
proc g_thread_yield*() {.importc: "g_thread_yield", libglib.}
proc init*(mutex: GMutex) {.importc: "g_mutex_init", libglib.}
proc clear*(mutex: GMutex) {.importc: "g_mutex_clear", libglib.}
proc lock*(mutex: GMutex) {.importc: "g_mutex_lock", libglib.}
proc trylock*(mutex: GMutex): gboolean {.
    importc: "g_mutex_trylock", libglib.}
proc unlock*(mutex: GMutex) {.importc: "g_mutex_unlock", 
    libglib.}
proc init*(rw_lock: GRWLock) {.importc: "g_rw_lock_init", 
    libglib.}
proc clear*(rw_lock: GRWLock) {.importc: "g_rw_lock_clear", 
    libglib.}
proc writer_lock*(rw_lock: GRWLock) {.
    importc: "g_rw_lock_writer_lock", libglib.}
proc writer_trylock*(rw_lock: GRWLock): gboolean {.
    importc: "g_rw_lock_writer_trylock", libglib.}
proc writer_unlock*(rw_lock: GRWLock) {.
    importc: "g_rw_lock_writer_unlock", libglib.}
proc reader_lock*(rw_lock: GRWLock) {.
    importc: "g_rw_lock_reader_lock", libglib.}
proc reader_trylock*(rw_lock: GRWLock): gboolean {.
    importc: "g_rw_lock_reader_trylock", libglib.}
proc reader_unlock*(rw_lock: GRWLock) {.
    importc: "g_rw_lock_reader_unlock", libglib.}
proc init*(rec_mutex: GRecMutex) {.
    importc: "g_rec_mutex_init", libglib.}
proc clear*(rec_mutex: GRecMutex) {.
    importc: "g_rec_mutex_clear", libglib.}
proc lock*(rec_mutex: GRecMutex) {.
    importc: "g_rec_mutex_lock", libglib.}
proc trylock*(rec_mutex: GRecMutex): gboolean {.
    importc: "g_rec_mutex_trylock", libglib.}
proc unlock*(rec_mutex: GRecMutex) {.
    importc: "g_rec_mutex_unlock", libglib.}
proc init*(cond: GCond) {.importc: "g_cond_init", libglib.}
proc clear*(cond: GCond) {.importc: "g_cond_clear", libglib.}
proc wait*(cond: GCond; mutex: GMutex) {.
    importc: "g_cond_wait", libglib.}
proc signal*(cond: GCond) {.importc: "g_cond_signal", libglib.}
proc broadcast*(cond: GCond) {.importc: "g_cond_broadcast", 
    libglib.}
proc wait_until*(cond: GCond; mutex: GMutex; end_time: gint64): gboolean {.
    importc: "g_cond_wait_until", libglib.}
proc get*(key: GPrivate): gpointer {.importc: "g_private_get", 
    libglib.}
proc set*(key: GPrivate; value: gpointer) {.
    importc: "g_private_set", libglib.}
proc replace*(key: GPrivate; value: gpointer) {.
    importc: "g_private_replace", libglib.}
proc impl*(once: GOnce; `func`: GThreadFunc; arg: gpointer): gpointer {.
    importc: "g_once_impl", libglib.}
proc g_once_init_enter*(location: pointer): gboolean {.
    importc: "g_once_init_enter", libglib.}
proc g_once_init_leave*(location: pointer; result: gsize) {.
    importc: "g_once_init_leave", libglib.}
when false: # when defined(G_ATOMIC_OP_MEMORY_BARRIER_NEEDED): 
  template g_once*(once, `func`, arg: expr): expr = 
    impl(once, `func`, arg)

else: 
  template g_once*(once, `func`, arg: expr): expr = 
    (if (once.status == G_ONCE_STATUS_READY): (once).retval else: impl(
        (once), `func`, arg))

proc g_get_num_processors*(): guint {.importc: "g_get_num_processors", 
                                      libglib.}

type 
  GAsyncQueue* =  ptr GAsyncQueueObj
  GAsyncQueuePtr* = ptr GAsyncQueueObj
  GAsyncQueueObj* = object 
  
proc g_async_queue_new*(): GAsyncQueue {.importc: "g_async_queue_new", 
    libglib.}
proc g_async_queue_new_full*(item_free_func: GDestroyNotify): GAsyncQueue {.
    importc: "g_async_queue_new_full", libglib.}
proc lock*(queue: GAsyncQueue) {.
    importc: "g_async_queue_lock", libglib.}
proc unlock*(queue: GAsyncQueue) {.
    importc: "g_async_queue_unlock", libglib.}
proc `ref`*(queue: GAsyncQueue): GAsyncQueue {.
    importc: "g_async_queue_ref", libglib.}
proc unref*(queue: GAsyncQueue) {.
    importc: "g_async_queue_unref", libglib.}
proc ref_unlocked*(queue: GAsyncQueue) {.
    importc: "g_async_queue_ref_unlocked", libglib.}
proc unref_and_unlock*(queue: GAsyncQueue) {.
    importc: "g_async_queue_unref_and_unlock", libglib.}
proc push*(queue: GAsyncQueue; data: gpointer) {.
    importc: "g_async_queue_push", libglib.}
proc push_unlocked*(queue: GAsyncQueue; data: gpointer) {.
    importc: "g_async_queue_push_unlocked", libglib.}
proc push_sorted*(queue: GAsyncQueue; data: gpointer; 
                                `func`: GCompareDataFunc; user_data: gpointer) {.
    importc: "g_async_queue_push_sorted", libglib.}
proc push_sorted_unlocked*(queue: GAsyncQueue; 
    data: gpointer; `func`: GCompareDataFunc; user_data: gpointer) {.
    importc: "g_async_queue_push_sorted_unlocked", libglib.}
proc pop*(queue: GAsyncQueue): gpointer {.
    importc: "g_async_queue_pop", libglib.}
proc pop_unlocked*(queue: GAsyncQueue): gpointer {.
    importc: "g_async_queue_pop_unlocked", libglib.}
proc try_pop*(queue: GAsyncQueue): gpointer {.
    importc: "g_async_queue_try_pop", libglib.}
proc try_pop_unlocked*(queue: GAsyncQueue): gpointer {.
    importc: "g_async_queue_try_pop_unlocked", libglib.}
proc timeout_pop*(queue: GAsyncQueue; timeout: guint64): gpointer {.
    importc: "g_async_queue_timeout_pop", libglib.}
proc timeout_pop_unlocked*(queue: GAsyncQueue; 
    timeout: guint64): gpointer {.importc: "g_async_queue_timeout_pop_unlocked", 
                                  libglib.}
proc length*(queue: GAsyncQueue): gint {.
    importc: "g_async_queue_length", libglib.}
proc length_unlocked*(queue: GAsyncQueue): gint {.
    importc: "g_async_queue_length_unlocked", libglib.}
proc sort*(queue: GAsyncQueue; `func`: GCompareDataFunc; 
                         user_data: gpointer) {.importc: "g_async_queue_sort", 
    libglib.}
proc sort_unlocked*(queue: GAsyncQueue; 
                                  `func`: GCompareDataFunc; user_data: gpointer) {.
    importc: "g_async_queue_sort_unlocked", libglib.}
proc timed_pop*(queue: GAsyncQueue; end_time: GTimeVal): gpointer {.
    importc: "g_async_queue_timed_pop", libglib.}
proc timed_pop_unlocked*(queue: GAsyncQueue; 
    end_time: GTimeVal): gpointer {.
    importc: "g_async_queue_timed_pop_unlocked", libglib.}

proc g_on_error_query*(prg_name: cstring) {.importc: "g_on_error_query", 
    libglib.}
proc g_on_error_stack_trace*(prg_name: cstring) {.
    importc: "g_on_error_stack_trace", libglib.}

proc g_base64_encode_step*(`in`: ptr guchar; len: gsize; break_lines: gboolean; 
                           `out`: cstring; state: ptr gint; save: ptr gint): gsize {.
    importc: "g_base64_encode_step", libglib.}
proc g_base64_encode_close*(break_lines: gboolean; `out`: cstring; 
                            state: ptr gint; save: ptr gint): gsize {.
    importc: "g_base64_encode_close", libglib.}
proc g_base64_encode*(data: ptr guchar; len: gsize): cstring {.
    importc: "g_base64_encode", libglib.}
proc g_base64_decode_step*(`in`: cstring; len: gsize; `out`: ptr guchar; 
                           state: ptr gint; save: ptr guint): gsize {.
    importc: "g_base64_decode_step", libglib.}
proc g_base64_decode*(text: cstring; out_len: var gsize): ptr guchar {.
    importc: "g_base64_decode", libglib.}
proc g_base64_decode_inplace*(text: cstring; out_len: var gsize): ptr guchar {.
    importc: "g_base64_decode_inplace", libglib.}

proc g_bit_lock*(address: ptr gint; lock_bit: gint) {.importc: "g_bit_lock", 
    libglib.}
proc g_bit_trylock*(address: ptr gint; lock_bit: gint): gboolean {.
    importc: "g_bit_trylock", libglib.}
proc g_bit_unlock*(address: ptr gint; lock_bit: gint) {.
    importc: "g_bit_unlock", libglib.}
proc g_pointer_bit_lock*(address: pointer; lock_bit: gint) {.
    importc: "g_pointer_bit_lock", libglib.}
proc g_pointer_bit_trylock*(address: pointer; lock_bit: gint): gboolean {.
    importc: "g_pointer_bit_trylock", libglib.}
proc g_pointer_bit_unlock*(address: pointer; lock_bit: gint) {.
    importc: "g_pointer_bit_unlock", libglib.}

type 
  GBookmarkFileError* {.size: sizeof(cint), pure.} = enum 
    INVALID_URI, INVALID_VALUE, 
    APP_NOT_REGISTERED, 
    URI_NOT_FOUND, READ, 
    UNKNOWN_ENCODING, WRITE, 
    FILE_NOT_FOUND
proc g_bookmark_file_error_quark*(): GQuark {.
    importc: "g_bookmark_file_error_quark", libglib.}
type 
  GBookmarkFile* =  ptr GBookmarkFileObj
  GBookmarkFilePtr* = ptr GBookmarkFileObj
  GBookmarkFileObj* = object 
  
proc g_bookmark_file_new*(): GBookmarkFile {.
    importc: "g_bookmark_file_new", libglib.}
proc free*(bookmark: GBookmarkFile) {.
    importc: "g_bookmark_file_free", libglib.}
proc load_from_file*(bookmark: GBookmarkFile; 
                                     filename: cstring; 
                                     error: var GError): gboolean {.
    importc: "g_bookmark_file_load_from_file", libglib.}
proc load_from_data*(bookmark: GBookmarkFile; 
                                     data: cstring; length: gsize; 
                                     error: var GError): gboolean {.
    importc: "g_bookmark_file_load_from_data", libglib.}
proc load_from_data_dirs*(bookmark: GBookmarkFile; 
    file: cstring; full_path: cstringArray; error: var GError): gboolean {.
    importc: "g_bookmark_file_load_from_data_dirs", libglib.}
proc to_data*(bookmark: GBookmarkFile; length: var gsize; 
                              error: var GError): cstring {.
    importc: "g_bookmark_file_to_data", libglib.}
proc to_file*(bookmark: GBookmarkFile; 
                              filename: cstring; error: var GError): gboolean {.
    importc: "g_bookmark_file_to_file", libglib.}
proc set_title*(bookmark: GBookmarkFile; uri: cstring; 
                                title: cstring) {.
    importc: "g_bookmark_file_set_title", libglib.}
proc `title=`*(bookmark: GBookmarkFile; uri: cstring; 
                                title: cstring) {.
    importc: "g_bookmark_file_set_title", libglib.}
proc get_title*(bookmark: GBookmarkFile; uri: cstring; 
                                error: var GError): cstring {.
    importc: "g_bookmark_file_get_title", libglib.}
proc title*(bookmark: GBookmarkFile; uri: cstring; 
                                error: var GError): cstring {.
    importc: "g_bookmark_file_get_title", libglib.}
proc set_description*(bookmark: GBookmarkFile; 
                                      uri: cstring; description: cstring) {.
    importc: "g_bookmark_file_set_description", libglib.}
proc `description=`*(bookmark: GBookmarkFile; 
                                      uri: cstring; description: cstring) {.
    importc: "g_bookmark_file_set_description", libglib.}
proc get_description*(bookmark: GBookmarkFile; 
                                      uri: cstring; error: var GError): cstring {.
    importc: "g_bookmark_file_get_description", libglib.}
proc description*(bookmark: GBookmarkFile; 
                                      uri: cstring; error: var GError): cstring {.
    importc: "g_bookmark_file_get_description", libglib.}
proc set_mime_type*(bookmark: GBookmarkFile; 
                                    uri: cstring; mime_type: cstring) {.
    importc: "g_bookmark_file_set_mime_type", libglib.}
proc `mime_type=`*(bookmark: GBookmarkFile; 
                                    uri: cstring; mime_type: cstring) {.
    importc: "g_bookmark_file_set_mime_type", libglib.}
proc get_mime_type*(bookmark: GBookmarkFile; 
                                    uri: cstring; error: var GError): cstring {.
    importc: "g_bookmark_file_get_mime_type", libglib.}
proc mime_type*(bookmark: GBookmarkFile; 
                                    uri: cstring; error: var GError): cstring {.
    importc: "g_bookmark_file_get_mime_type", libglib.}
proc set_groups*(bookmark: GBookmarkFile; uri: cstring; 
                                 groups: cstringArray; length: gsize) {.
    importc: "g_bookmark_file_set_groups", libglib.}
proc `groups=`*(bookmark: GBookmarkFile; uri: cstring; 
                                 groups: cstringArray; length: gsize) {.
    importc: "g_bookmark_file_set_groups", libglib.}
proc add_group*(bookmark: GBookmarkFile; uri: cstring; 
                                group: cstring) {.
    importc: "g_bookmark_file_add_group", libglib.}
proc has_group*(bookmark: GBookmarkFile; uri: cstring; 
                                group: cstring; error: var GError): gboolean {.
    importc: "g_bookmark_file_has_group", libglib.}
proc get_groups*(bookmark: GBookmarkFile; uri: cstring; 
                                 length: var gsize; error: var GError): cstringArray {.
    importc: "g_bookmark_file_get_groups", libglib.}
proc groups*(bookmark: GBookmarkFile; uri: cstring; 
                                 length: var gsize; error: var GError): cstringArray {.
    importc: "g_bookmark_file_get_groups", libglib.}
proc add_application*(bookmark: GBookmarkFile; 
                                      uri: cstring; name: cstring; 
                                      exec: cstring) {.
    importc: "g_bookmark_file_add_application", libglib.}
proc has_application*(bookmark: GBookmarkFile; 
                                      uri: cstring; name: cstring; 
                                      error: var GError): gboolean {.
    importc: "g_bookmark_file_has_application", libglib.}
proc get_applications*(bookmark: GBookmarkFile; 
    uri: cstring; length: var gsize; error: var GError): cstringArray {.
    importc: "g_bookmark_file_get_applications", libglib.}
proc applications*(bookmark: GBookmarkFile; 
    uri: cstring; length: var gsize; error: var GError): cstringArray {.
    importc: "g_bookmark_file_get_applications", libglib.}
proc set_app_info*(bookmark: GBookmarkFile; 
                                   uri: cstring; name: cstring; 
                                   exec: cstring; count: gint; 
                                   stamp: time_t; error: var GError): gboolean {.
    importc: "g_bookmark_file_set_app_info", libglib.}
proc get_app_info*(bookmark: GBookmarkFile; 
                                   uri: cstring; name: cstring; 
                                   exec: cstringArray; count: var guint; 
                                   stamp: ptr time_t; error: var GError): gboolean {.
    importc: "g_bookmark_file_get_app_info", libglib.}
proc app_info*(bookmark: GBookmarkFile; 
                                   uri: cstring; name: cstring; 
                                   exec: cstringArray; count: var guint; 
                                   stamp: ptr time_t; error: var GError): gboolean {.
    importc: "g_bookmark_file_get_app_info", libglib.}
proc set_is_private*(bookmark: GBookmarkFile; 
                                     uri: cstring; is_private: gboolean) {.
    importc: "g_bookmark_file_set_is_private", libglib.}
proc `is_private=`*(bookmark: GBookmarkFile; 
                                     uri: cstring; is_private: gboolean) {.
    importc: "g_bookmark_file_set_is_private", libglib.}
proc get_is_private*(bookmark: GBookmarkFile; 
                                     uri: cstring; error: var GError): gboolean {.
    importc: "g_bookmark_file_get_is_private", libglib.}
proc is_private*(bookmark: GBookmarkFile; 
                                     uri: cstring; error: var GError): gboolean {.
    importc: "g_bookmark_file_get_is_private", libglib.}
proc set_icon*(bookmark: GBookmarkFile; uri: cstring; 
                               href: cstring; mime_type: cstring) {.
    importc: "g_bookmark_file_set_icon", libglib.}
proc `icon=`*(bookmark: GBookmarkFile; uri: cstring; 
                               href: cstring; mime_type: cstring) {.
    importc: "g_bookmark_file_set_icon", libglib.}
proc get_icon*(bookmark: GBookmarkFile; uri: cstring; 
                               href: cstringArray; mime_type: cstringArray; 
                               error: var GError): gboolean {.
    importc: "g_bookmark_file_get_icon", libglib.}
proc icon*(bookmark: GBookmarkFile; uri: cstring; 
                               href: cstringArray; mime_type: cstringArray; 
                               error: var GError): gboolean {.
    importc: "g_bookmark_file_get_icon", libglib.}
proc set_added*(bookmark: GBookmarkFile; uri: cstring; 
                                added: time_t) {.
    importc: "g_bookmark_file_set_added", libglib.}
proc `added=`*(bookmark: GBookmarkFile; uri: cstring; 
                                added: time_t) {.
    importc: "g_bookmark_file_set_added", libglib.}
proc get_added*(bookmark: GBookmarkFile; uri: cstring; 
                                error: var GError): time_t {.
    importc: "g_bookmark_file_get_added", libglib.}
proc added*(bookmark: GBookmarkFile; uri: cstring; 
                                error: var GError): time_t {.
    importc: "g_bookmark_file_get_added", libglib.}
proc set_modified*(bookmark: GBookmarkFile; 
                                   uri: cstring; modified: time_t) {.
    importc: "g_bookmark_file_set_modified", libglib.}
proc `modified=`*(bookmark: GBookmarkFile; 
                                   uri: cstring; modified: time_t) {.
    importc: "g_bookmark_file_set_modified", libglib.}
proc get_modified*(bookmark: GBookmarkFile; 
                                   uri: cstring; error: var GError): time_t {.
    importc: "g_bookmark_file_get_modified", libglib.}
proc modified*(bookmark: GBookmarkFile; 
                                   uri: cstring; error: var GError): time_t {.
    importc: "g_bookmark_file_get_modified", libglib.}
proc set_visited*(bookmark: GBookmarkFile; uri: cstring; 
                                  visited: time_t) {.
    importc: "g_bookmark_file_set_visited", libglib.}
proc `visited=`*(bookmark: GBookmarkFile; uri: cstring; 
                                  visited: time_t) {.
    importc: "g_bookmark_file_set_visited", libglib.}
proc get_visited*(bookmark: GBookmarkFile; uri: cstring; 
                                  error: var GError): time_t {.
    importc: "g_bookmark_file_get_visited", libglib.}
proc visited*(bookmark: GBookmarkFile; uri: cstring; 
                                  error: var GError): time_t {.
    importc: "g_bookmark_file_get_visited", libglib.}
proc has_item*(bookmark: GBookmarkFile; uri: cstring): gboolean {.
    importc: "g_bookmark_file_has_item", libglib.}
proc get_size*(bookmark: GBookmarkFile): gint {.
    importc: "g_bookmark_file_get_size", libglib.}
proc size*(bookmark: GBookmarkFile): gint {.
    importc: "g_bookmark_file_get_size", libglib.}
proc get_uris*(bookmark: GBookmarkFile; length: var gsize): cstringArray {.
    importc: "g_bookmark_file_get_uris", libglib.}
proc uris*(bookmark: GBookmarkFile; length: var gsize): cstringArray {.
    importc: "g_bookmark_file_get_uris", libglib.}
proc remove_group*(bookmark: GBookmarkFile; 
                                   uri: cstring; group: cstring; 
                                   error: var GError): gboolean {.
    importc: "g_bookmark_file_remove_group", libglib.}
proc remove_application*(bookmark: GBookmarkFile; 
    uri: cstring; name: cstring; error: var GError): gboolean {.
    importc: "g_bookmark_file_remove_application", libglib.}
proc remove_item*(bookmark: GBookmarkFile; uri: cstring; 
                                  error: var GError): gboolean {.
    importc: "g_bookmark_file_remove_item", libglib.}
proc move_item*(bookmark: GBookmarkFile; 
                                old_uri: cstring; new_uri: cstring; 
                                error: var GError): gboolean {.
    importc: "g_bookmark_file_move_item", libglib.}

proc g_bytes_new*(data: gconstpointer; size: gsize): GBytes {.
    importc: "g_bytes_new", libglib.}
proc g_bytes_new_take*(data: gpointer; size: gsize): GBytes {.
    importc: "g_bytes_new_take", libglib.}
proc g_bytes_new_static*(data: gconstpointer; size: gsize): GBytes {.
    importc: "g_bytes_new_static", libglib.}
proc g_bytes_new_with_free_func*(data: gconstpointer; size: gsize; 
                                 free_func: GDestroyNotify; 
                                 user_data: gpointer): GBytes {.
    importc: "g_bytes_new_with_free_func", libglib.}
proc new_from_bytes*(bytes: GBytes; offset: gsize; length: gsize): GBytes {.
    importc: "g_bytes_new_from_bytes", libglib.}
proc get_data*(bytes: GBytes; size: var gsize): gconstpointer {.
    importc: "g_bytes_get_data", libglib.}
proc data*(bytes: GBytes; size: var gsize): gconstpointer {.
    importc: "g_bytes_get_data", libglib.}
proc get_size*(bytes: GBytes): gsize {.
    importc: "g_bytes_get_size", libglib.}
proc size*(bytes: GBytes): gsize {.
    importc: "g_bytes_get_size", libglib.}
proc `ref`*(bytes: GBytes): GBytes {.importc: "g_bytes_ref", 
    libglib.}
proc unref*(bytes: GBytes) {.importc: "g_bytes_unref", libglib.}
proc unref_to_data*(bytes: GBytes; size: var gsize): gpointer {.
    importc: "g_bytes_unref_to_data", libglib.}
proc unref_to_array*(bytes: GBytes): GByteArray {.
    importc: "g_bytes_unref_to_array", libglib.}
proc g_bytes_hash*(bytes: gconstpointer): guint {.importc: "g_bytes_hash", 
    libglib.}
proc g_bytes_equal*(bytes1: gconstpointer; bytes2: gconstpointer): gboolean {.
    importc: "g_bytes_equal", libglib.}
proc g_bytes_compare*(bytes1: gconstpointer; bytes2: gconstpointer): gint {.
    importc: "g_bytes_compare", libglib.}

proc g_get_charset*(charset: cstringArray): gboolean {.
    importc: "g_get_charset", libglib.}
proc g_get_codeset*(): cstring {.importc: "g_get_codeset", libglib.}
proc g_get_language_names*(): cstringArray {.importc: "g_get_language_names", 
    libglib.}
proc g_get_locale_variants*(locale: cstring): cstringArray {.
    importc: "g_get_locale_variants", libglib.}

type 
  GChecksumType* {.size: sizeof(cint), pure.} = enum 
    MD5, SHA1, SHA256, SHA512
type 
  GChecksum* =  ptr GChecksumObj
  GChecksumPtr* = ptr GChecksumObj
  GChecksumObj* = object 
  
proc get_length*(checksum_type: GChecksumType): gssize {.
    importc: "g_checksum_type_get_length", libglib.}
  
proc length*(checksum_type: GChecksumType): gssize {.
    importc: "g_checksum_type_get_length", libglib.}
proc g_checksum_new*(checksum_type: GChecksumType): GChecksum {.
    importc: "g_checksum_new", libglib.}
proc reset*(checksum: GChecksum) {.importc: "g_checksum_reset", 
    libglib.}
proc copy*(checksum: GChecksum): GChecksum {.
    importc: "g_checksum_copy", libglib.}
proc free*(checksum: GChecksum) {.importc: "g_checksum_free", 
    libglib.}
proc update*(checksum: GChecksum; data: ptr guchar; 
                        length: gssize) {.importc: "g_checksum_update", 
    libglib.}
proc get_string*(checksum: GChecksum): cstring {.
    importc: "g_checksum_get_string", libglib.}
proc get_digest*(checksum: GChecksum; buffer: ptr guint8; 
                            digest_len: var gsize) {.
    importc: "g_checksum_get_digest", libglib.}
proc g_compute_checksum_for_data*(checksum_type: GChecksumType; 
                                  data: ptr guchar; length: gsize): cstring {.
    importc: "g_compute_checksum_for_data", libglib.}
proc g_compute_checksum_for_string*(checksum_type: GChecksumType; 
                                    str: cstring; length: gssize): cstring {.
    importc: "g_compute_checksum_for_string", libglib.}
proc g_compute_checksum_for_bytes*(checksum_type: GChecksumType; 
                                   data: GBytes): cstring {.
    importc: "g_compute_checksum_for_bytes", libglib.}

type 
  GConvertError* {.size: sizeof(cint), pure.} = enum 
    NO_CONVERSION, ILLEGAL_SEQUENCE, 
    FAILED, PARTIAL_INPUT, 
    BAD_URI, NOT_ABSOLUTE_PATH, 
    NO_MEMORY
proc g_convert_error_quark*(): GQuark {.importc: "g_convert_error_quark", 
    libglib.}
type 
  GIConv* =  ptr GIConvObj
  GIConvPtr* = ptr GIConvObj
  GIConvObj* = object 
  
proc g_iconv_open*(to_codeset: cstring; from_codeset: cstring): GIConv {.
    importc: "g_iconv_open", libglib.}
proc g_iconv*(`converter`: GIConv; inbuf: cstringArray; 
              inbytes_left: var gsize; outbuf: cstringArray; 
              outbytes_left: var gsize): gsize {.importc: "g_iconv", 
    libglib.}
proc g_iconv_close*(`converter`: GIConv): gint {.importc: "g_iconv_close", 
    libglib.}
proc g_convert*(str: cstring; len: gssize; to_codeset: cstring; 
                from_codeset: cstring; bytes_read: var gsize; 
                bytes_written: var gsize; error: var GError): cstring {.
    importc: "g_convert", libglib.}
proc g_convert_with_iconv*(str: cstring; len: gssize; `converter`: GIConv; 
                           bytes_read: var gsize; bytes_written: var gsize; 
                           error: var GError): cstring {.
    importc: "g_convert_with_iconv", libglib.}
proc g_convert_with_fallback*(str: cstring; len: gssize; 
                              to_codeset: cstring; from_codeset: cstring; 
                              fallback: cstring; bytes_read: var gsize; 
                              bytes_written: var gsize; error: var GError): cstring {.
    importc: "g_convert_with_fallback", libglib.}
proc g_locale_to_utf8*(opsysstring: cstring; len: gssize; 
                       bytes_read: var gsize; bytes_written: var gsize; 
                       error: var GError): cstring {.
    importc: "g_locale_to_utf8", libglib.}
proc g_locale_from_utf8*(utf8string: cstring; len: gssize; 
                         bytes_read: var gsize; bytes_written: var gsize; 
                         error: var GError): cstring {.
    importc: "g_locale_from_utf8", libglib.}
when not defined(windows):
  proc g_filename_to_utf8*(opsysstring: cstring; len: gssize; 
                           bytes_read: var gsize; bytes_written: var gsize; 
                           error: var GError): cstring {.
      importc: "g_filename_to_utf8", libglib.}
  proc g_filename_from_utf8*(utf8string: cstring; len: gssize; 
                             bytes_read: var gsize; bytes_written: var gsize; 
                             error: var GError): cstring {.
      importc: "g_filename_from_utf8", libglib.}
  proc g_filename_from_uri*(uri: cstring; hostname: cstringArray; 
                            error: var GError): cstring {.
      importc: "g_filename_from_uri", libglib.}
  proc g_filename_to_uri*(filename: cstring; hostname: cstring; 
                          error: var GError): cstring {.
      importc: "g_filename_to_uri", libglib.}
proc g_filename_display_name*(filename: cstring): cstring {.
    importc: "g_filename_display_name", libglib.}
proc g_get_filename_charsets*(charsets: ptr cstringArray): gboolean {.
    importc: "g_get_filename_charsets", libglib.}
proc g_filename_display_basename*(filename: cstring): cstring {.
    importc: "g_filename_display_basename", libglib.}
proc g_uri_list_extract_uris*(uri_list: cstring): cstringArray {.
    importc: "g_uri_list_extract_uris", libglib.}
when defined(windows): 
  proc g_filename_to_utf8_utf8*(opsysstring: cstring; len: gssize; 
                                bytes_read: var gsize; 
                                bytes_written: var gsize; 
                                error: var GError): cstring {.
      importc: "g_filename_to_utf8_utf8", libglib.}
  proc g_filename_from_utf8_utf8*(utf8string: cstring; len: gssize; 
                                  bytes_read: var gsize; 
                                  bytes_written: var gsize; 
                                  error: var GError): cstring {.
      importc: "g_filename_from_utf8_utf8", libglib.}
  proc g_filename_from_uri_utf8*(uri: cstring; hostname: cstringArray; 
                                 error: var GError): cstring {.
      importc: "g_filename_from_uri_utf8", libglib.}
  proc g_filename_to_uri_utf8*(filename: cstring; hostname: cstring; 
                               error: var GError): cstring {.
      importc: "g_filename_to_uri_utf8", libglib.}
  const 
    g_filename_to_utf8* = g_filename_to_utf8_utf8
    g_filename_from_utf8* = g_filename_from_utf8_utf8
    g_filename_from_uri* = g_filename_from_uri_utf8
    g_filename_to_uri* = g_filename_to_uri_utf8

type 
  GData* =  ptr GDataObj
  GDataPtr* = ptr GDataObj
  GDataObj* = object 
  
  GDataForeachFunc* = proc (key_id: GQuark; data: gpointer; 
                            user_data: gpointer) {.cdecl.}
proc init*(datalist: var GData) {.importc: "g_datalist_init", 
    libglib.}
proc clear*(datalist: var GData) {.importc: "g_datalist_clear", 
    libglib.}
proc id_get_data*(datalist: var GData; key_id: GQuark): gpointer {.
    importc: "g_datalist_id_get_data", libglib.}
proc id_set_data_full*(datalist: var GData; key_id: GQuark; 
                                  data: gpointer; destroy_func: GDestroyNotify) {.
    importc: "g_datalist_id_set_data_full", libglib.}
type 
  GDuplicateFunc* = proc (data: gpointer; user_data: gpointer): gpointer {.cdecl.}
proc id_dup_data*(datalist: var GData; key_id: GQuark; 
                             dup_func: GDuplicateFunc; user_data: gpointer): gpointer {.
    importc: "g_datalist_id_dup_data", libglib.}
proc id_replace_data*(datalist: var GData; key_id: GQuark; 
                                 oldval: gpointer; newval: gpointer; 
                                 destroy: GDestroyNotify; 
                                 old_destroy: ptr GDestroyNotify): gboolean {.
    importc: "g_datalist_id_replace_data", libglib.}
proc id_remove_no_notify*(datalist: var GData; key_id: GQuark): gpointer {.
    importc: "g_datalist_id_remove_no_notify", libglib.}
proc foreach*(datalist: var GData; `func`: GDataForeachFunc; 
                         user_data: gpointer) {.importc: "g_datalist_foreach", 
    libglib.}
const 
  G_DATALIST_FLAGS_MASK* = 0x00000003
proc set_flags*(datalist: var GData; flags: guint) {.
    importc: "g_datalist_set_flags", libglib.}
proc `flags=`*(datalist: var GData; flags: guint) {.
    importc: "g_datalist_set_flags", libglib.}
proc unset_flags*(datalist: var GData; flags: guint) {.
    importc: "g_datalist_unset_flags", libglib.}
proc get_flags*(datalist: var GData): guint {.
    importc: "g_datalist_get_flags", libglib.}
proc flags*(datalist: var GData): guint {.
    importc: "g_datalist_get_flags", libglib.}
template g_datalist_id_set_data*(dl, q, d: expr): expr = 
  id_set_data_full(dl, q, d, nil)

template g_datalist_id_remove_data*(dl, q: expr): expr = 
  g_datalist_id_set_data(dl, q, nil)

template g_datalist_set_data_full*(dl, k, d, f: expr): expr = 
  id_set_data_full(dl, g_quark_from_string(k), d, f)

template g_datalist_remove_no_notify*(dl, k: expr): expr = 
  id_remove_no_notify(dl, g_quark_try_string(k))

template g_datalist_set_data*(dl, k, d: expr): expr = 
  g_datalist_set_data_full(dl, k, d, nil)

template g_datalist_remove_data*(dl, k: expr): expr = 
  g_datalist_id_set_data(dl, g_quark_try_string(k), nil)

proc g_dataset_destroy*(dataset_location: gconstpointer) {.
    importc: "g_dataset_destroy", libglib.}
proc g_dataset_id_get_data*(dataset_location: gconstpointer; key_id: GQuark): gpointer {.
    importc: "g_dataset_id_get_data", libglib.}
proc get_data*(datalist: var GData; key: cstring): gpointer {.
    importc: "g_datalist_get_data", libglib.}
proc data*(datalist: var GData; key: cstring): gpointer {.
    importc: "g_datalist_get_data", libglib.}
proc g_dataset_id_set_data_full*(dataset_location: gconstpointer; 
                                 key_id: GQuark; data: gpointer; 
                                 destroy_func: GDestroyNotify) {.
    importc: "g_dataset_id_set_data_full", libglib.}
proc g_dataset_id_remove_no_notify*(dataset_location: gconstpointer; 
                                    key_id: GQuark): gpointer {.
    importc: "g_dataset_id_remove_no_notify", libglib.}
proc g_dataset_foreach*(dataset_location: gconstpointer; 
                        `func`: GDataForeachFunc; user_data: gpointer) {.
    importc: "g_dataset_foreach", libglib.}
template g_dataset_id_set_data*(l, k, d: expr): expr = 
  g_dataset_id_set_data_full(l, k, d, nil)

template g_dataset_id_remove_data*(l, k: expr): expr = 
  g_dataset_id_set_data(l, k, nil)

template g_dataset_get_data*(l, k: expr): expr = 
  (g_dataset_id_get_data(l, g_quark_try_string(k)))

template g_dataset_set_data_full*(l, k, d, f: expr): expr = 
  g_dataset_id_set_data_full(l, g_quark_from_string(k), d, f)

template g_dataset_remove_no_notify*(l, k: expr): expr = 
  g_dataset_id_remove_no_notify(l, g_quark_try_string(k))

template g_dataset_set_data*(l, k, d: expr): expr = 
  g_dataset_set_data_full(l, k, d, nil)

template g_dataset_remove_data*(l, k: expr): expr = 
  g_dataset_id_set_data(l, g_quark_try_string(k), nil)

type 
  GTime* = gint32
  GDateYear* = guint16
  GDateDay* = guint8
type 
  GDateDMY* {.size: sizeof(cint), pure.} = enum 
    DAY = 0, MONTH = 1, YEAR = 2
type 
  GDateWeekday* {.size: sizeof(cint), pure.} = enum 
    BAD_WEEKDAY = 0, MONDAY = 1, TUESDAY = 2, 
    WEDNESDAY = 3, THURSDAY = 4, FRIDAY = 5, 
    SATURDAY = 6, SUNDAY = 7
  GDateMonth* {.size: sizeof(cint), pure.} = enum 
    BAD_MONTH = 0, JANUARY = 1, FEBRUARY = 2, 
    MARCH = 3, APRIL = 4, MAY = 5, JUNE = 6, 
    JULY = 7, AUGUST = 8, SEPTEMBER = 9, 
    OCTOBER = 10, NOVEMBER = 11, DECEMBER = 12
const 
  G_DATE_BAD_JULIAN* = 0
  G_DATE_BAD_DAY* = 0
  G_DATE_BAD_YEAR* = 0
type 
  GDate* =  ptr GDateObj
  GDatePtr* = ptr GDateObj
  GDateObj* = object 
    bitfield0GDATE*: guint64

proc g_date_new*(): GDate {.importc: "g_date_new", libglib.}
proc g_date_new_dmy*(day: GDateDay; month: GDateMonth; year: GDateYear): GDate {.
    importc: "g_date_new_dmy", libglib.}
proc g_date_new_julian*(julian_day: guint32): GDate {.
    importc: "g_date_new_julian", libglib.}
proc free*(date: GDate) {.importc: "g_date_free", libglib.}
proc valid*(date: GDate): gboolean {.importc: "g_date_valid", 
    libglib.}
proc g_date_valid_day*(day: GDateDay): gboolean {.importc: "g_date_valid_day", 
    libglib.}
proc g_date_valid_month*(month: GDateMonth): gboolean {.
    importc: "g_date_valid_month", libglib.}
proc g_date_valid_year*(year: GDateYear): gboolean {.
    importc: "g_date_valid_year", libglib.}
proc g_date_valid_weekday*(weekday: GDateWeekday): gboolean {.
    importc: "g_date_valid_weekday", libglib.}
proc g_date_valid_julian*(julian_date: guint32): gboolean {.
    importc: "g_date_valid_julian", libglib.}
proc g_date_valid_dmy*(day: GDateDay; month: GDateMonth; year: GDateYear): gboolean {.
    importc: "g_date_valid_dmy", libglib.}
proc get_weekday*(date: GDate): GDateWeekday {.
    importc: "g_date_get_weekday", libglib.}
proc weekday*(date: GDate): GDateWeekday {.
    importc: "g_date_get_weekday", libglib.}
proc get_month*(date: GDate): GDateMonth {.
    importc: "g_date_get_month", libglib.}
proc month*(date: GDate): GDateMonth {.
    importc: "g_date_get_month", libglib.}
proc get_year*(date: GDate): GDateYear {.
    importc: "g_date_get_year", libglib.}
proc year*(date: GDate): GDateYear {.
    importc: "g_date_get_year", libglib.}
proc get_day*(date: GDate): GDateDay {.importc: "g_date_get_day", 
    libglib.}
proc day*(date: GDate): GDateDay {.importc: "g_date_get_day", 
    libglib.}
proc get_julian*(date: GDate): guint32 {.
    importc: "g_date_get_julian", libglib.}
proc julian*(date: GDate): guint32 {.
    importc: "g_date_get_julian", libglib.}
proc get_day_of_year*(date: GDate): guint {.
    importc: "g_date_get_day_of_year", libglib.}
proc day_of_year*(date: GDate): guint {.
    importc: "g_date_get_day_of_year", libglib.}
proc get_monday_week_of_year*(date: GDate): guint {.
    importc: "g_date_get_monday_week_of_year", libglib.}
proc monday_week_of_year*(date: GDate): guint {.
    importc: "g_date_get_monday_week_of_year", libglib.}
proc get_sunday_week_of_year*(date: GDate): guint {.
    importc: "g_date_get_sunday_week_of_year", libglib.}
proc sunday_week_of_year*(date: GDate): guint {.
    importc: "g_date_get_sunday_week_of_year", libglib.}
proc get_iso8601_week_of_year*(date: GDate): guint {.
    importc: "g_date_get_iso8601_week_of_year", libglib.}
proc iso8601_week_of_year*(date: GDate): guint {.
    importc: "g_date_get_iso8601_week_of_year", libglib.}
proc clear*(date: GDate; n_dates: guint) {.importc: "g_date_clear", 
    libglib.}
proc set_parse*(date: GDate; str: cstring) {.
    importc: "g_date_set_parse", libglib.}
proc `parse=`*(date: GDate; str: cstring) {.
    importc: "g_date_set_parse", libglib.}
proc set_time_t*(date: GDate; timet: time_t) {.
    importc: "g_date_set_time_t", libglib.}
proc `time_t=`*(date: GDate; timet: time_t) {.
    importc: "g_date_set_time_t", libglib.}
proc set_time_val*(date: GDate; timeval: GTimeVal) {.
    importc: "g_date_set_time_val", libglib.}
proc `time_val=`*(date: GDate; timeval: GTimeVal) {.
    importc: "g_date_set_time_val", libglib.}
when not(defined(G_DISABLE_DEPRECATED)): 
  proc set_time*(date: GDate; time: GTime) {.
      importc: "g_date_set_time", libglib.}
  proc `time=`*(date: GDate; time: GTime) {.
      importc: "g_date_set_time", libglib.}
proc set_month*(date: GDate; month: GDateMonth) {.
    importc: "g_date_set_month", libglib.}
proc `month=`*(date: GDate; month: GDateMonth) {.
    importc: "g_date_set_month", libglib.}
proc set_day*(date: GDate; day: GDateDay) {.
    importc: "g_date_set_day", libglib.}
proc `day=`*(date: GDate; day: GDateDay) {.
    importc: "g_date_set_day", libglib.}
proc set_year*(date: GDate; year: GDateYear) {.
    importc: "g_date_set_year", libglib.}
proc `year=`*(date: GDate; year: GDateYear) {.
    importc: "g_date_set_year", libglib.}
proc set_dmy*(date: GDate; day: GDateDay; month: GDateMonth; 
                     y: GDateYear) {.importc: "g_date_set_dmy", libglib.}
proc `dmy=`*(date: GDate; day: GDateDay; month: GDateMonth; 
                     y: GDateYear) {.importc: "g_date_set_dmy", libglib.}
proc set_julian*(date: GDate; julian_date: guint32) {.
    importc: "g_date_set_julian", libglib.}
proc `julian=`*(date: GDate; julian_date: guint32) {.
    importc: "g_date_set_julian", libglib.}
proc is_first_of_month*(date: GDate): gboolean {.
    importc: "g_date_is_first_of_month", libglib.}
proc is_last_of_month*(date: GDate): gboolean {.
    importc: "g_date_is_last_of_month", libglib.}
proc add_days*(date: GDate; n_days: guint) {.
    importc: "g_date_add_days", libglib.}
proc subtract_days*(date: GDate; n_days: guint) {.
    importc: "g_date_subtract_days", libglib.}
proc add_months*(date: GDate; n_months: guint) {.
    importc: "g_date_add_months", libglib.}
proc subtract_months*(date: GDate; n_months: guint) {.
    importc: "g_date_subtract_months", libglib.}
proc add_years*(date: GDate; n_years: guint) {.
    importc: "g_date_add_years", libglib.}
proc subtract_years*(date: GDate; n_years: guint) {.
    importc: "g_date_subtract_years", libglib.}
proc g_date_is_leap_year*(year: GDateYear): gboolean {.
    importc: "g_date_is_leap_year", libglib.}
proc get_days_in_month*(month: GDateMonth; year: GDateYear): guint8 {.
    importc: "g_date_get_days_in_month", libglib.}
proc get_monday_weeks_in_year*(year: GDateYear): guint8 {.
    importc: "g_date_get_monday_weeks_in_year", libglib.}
proc get_sunday_weeks_in_year*(year: GDateYear): guint8 {.
    importc: "g_date_get_sunday_weeks_in_year", libglib.}
proc days_between*(date1: GDate; date2: GDate): gint {.
    importc: "g_date_days_between", libglib.}
proc compare*(lhs: GDate; rhs: GDate): gint {.
    importc: "g_date_compare", libglib.}
proc clamp*(date: GDate; min_date: GDate; max_date: GDate) {.
    importc: "g_date_clamp", libglib.}
proc order*(date1: GDate; date2: GDate) {.
    importc: "g_date_order", libglib.}
proc g_date_strftime*(s: cstring; slen: gsize; format: cstring; 
                      date: GDate): gsize {.importc: "g_date_strftime", 
    libglib.}
when not(defined(G_DISABLE_DEPRECATED)): 
  const 
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

type 
  GTimeZone* =  ptr GTimeZoneObj
  GTimeZonePtr* = ptr GTimeZoneObj
  GTimeZoneObj* = object 
  
type 
  GTimeType* {.size: sizeof(cint), pure.} = enum 
    STANDARD, DAYLIGHT, UNIVERSAL
proc g_time_zone_new*(identifier: cstring): GTimeZone {.
    importc: "g_time_zone_new", libglib.}
proc g_time_zone_new_utc*(): GTimeZone {.importc: "g_time_zone_new_utc", 
    libglib.}
proc g_time_zone_new_local*(): GTimeZone {.
    importc: "g_time_zone_new_local", libglib.}
proc `ref`*(tz: GTimeZone): GTimeZone {.
    importc: "g_time_zone_ref", libglib.}
proc unref*(tz: GTimeZone) {.importc: "g_time_zone_unref", 
    libglib.}
proc find_interval*(tz: GTimeZone; `type`: GTimeType; 
                                time: gint64): gint {.
    importc: "g_time_zone_find_interval", libglib.}
proc adjust_time*(tz: GTimeZone; `type`: GTimeType; 
                              time: ptr gint64): gint {.
    importc: "g_time_zone_adjust_time", libglib.}
proc get_abbreviation*(tz: GTimeZone; interval: gint): cstring {.
    importc: "g_time_zone_get_abbreviation", libglib.}
proc abbreviation*(tz: GTimeZone; interval: gint): cstring {.
    importc: "g_time_zone_get_abbreviation", libglib.}
proc get_offset*(tz: GTimeZone; interval: gint): gint32 {.
    importc: "g_time_zone_get_offset", libglib.}
proc offset*(tz: GTimeZone; interval: gint): gint32 {.
    importc: "g_time_zone_get_offset", libglib.}
proc is_dst*(tz: GTimeZone; interval: gint): gboolean {.
    importc: "g_time_zone_is_dst", libglib.}

const 
  G_TIME_SPAN_DAY* = (G_GINT64_CONSTANT(86400000000'i64))
const 
  G_TIME_SPAN_HOUR* = (G_GINT64_CONSTANT(3600000000'i64))
const 
  G_TIME_SPAN_MINUTE* = (G_GINT64_CONSTANT(60000000))
const 
  G_TIME_SPAN_SECOND* = (G_GINT64_CONSTANT(1000000))
const 
  G_TIME_SPAN_MILLISECOND* = (G_GINT64_CONSTANT(1000))
type 
  GTimeSpan* = gint64
type 
  GDateTime* =  ptr GDateTimeObj
  GDateTimePtr* = ptr GDateTimeObj
  GDateTimeObj* = object 
  
proc unref*(datetime: GDateTime) {.
    importc: "g_date_time_unref", libglib.}
proc `ref`*(datetime: GDateTime): GDateTime {.
    importc: "g_date_time_ref", libglib.}
proc g_date_time_new_now*(tz: GTimeZone): GDateTime {.
    importc: "g_date_time_new_now", libglib.}
proc g_date_time_new_now_local*(): GDateTime {.
    importc: "g_date_time_new_now_local", libglib.}
proc g_date_time_new_now_utc*(): GDateTime {.
    importc: "g_date_time_new_now_utc", libglib.}
proc g_date_time_new_from_unix_local*(t: gint64): GDateTime {.
    importc: "g_date_time_new_from_unix_local", libglib.}
proc g_date_time_new_from_unix_utc*(t: gint64): GDateTime {.
    importc: "g_date_time_new_from_unix_utc", libglib.}
proc g_date_time_new_from_timeval_local*(tv: GTimeVal): GDateTime {.
    importc: "g_date_time_new_from_timeval_local", libglib.}
proc g_date_time_new_from_timeval_utc*(tv: GTimeVal): GDateTime {.
    importc: "g_date_time_new_from_timeval_utc", libglib.}
proc g_date_time_new*(tz: GTimeZone; year: gint; month: gint; day: gint; 
                      hour: gint; minute: gint; seconds: gdouble): GDateTime {.
    importc: "g_date_time_new", libglib.}
proc g_date_time_new_local*(year: gint; month: gint; day: gint; hour: gint; 
                            minute: gint; seconds: gdouble): GDateTime {.
    importc: "g_date_time_new_local", libglib.}
proc g_date_time_new_utc*(year: gint; month: gint; day: gint; hour: gint; 
                          minute: gint; seconds: gdouble): GDateTime {.
    importc: "g_date_time_new_utc", libglib.}
proc add*(datetime: GDateTime; timespan: GTimeSpan): GDateTime {.
    importc: "g_date_time_add", libglib.}
proc add_years*(datetime: GDateTime; years: gint): GDateTime {.
    importc: "g_date_time_add_years", libglib.}
proc add_months*(datetime: GDateTime; months: gint): GDateTime {.
    importc: "g_date_time_add_months", libglib.}
proc add_weeks*(datetime: GDateTime; weeks: gint): GDateTime {.
    importc: "g_date_time_add_weeks", libglib.}
proc add_days*(datetime: GDateTime; days: gint): GDateTime {.
    importc: "g_date_time_add_days", libglib.}
proc add_hours*(datetime: GDateTime; hours: gint): GDateTime {.
    importc: "g_date_time_add_hours", libglib.}
proc add_minutes*(datetime: GDateTime; minutes: gint): GDateTime {.
    importc: "g_date_time_add_minutes", libglib.}
proc add_seconds*(datetime: GDateTime; seconds: gdouble): GDateTime {.
    importc: "g_date_time_add_seconds", libglib.}
proc add_full*(datetime: GDateTime; years: gint; months: gint; 
                           days: gint; hours: gint; minutes: gint; 
                           seconds: gdouble): GDateTime {.
    importc: "g_date_time_add_full", libglib.}
proc g_date_time_compare*(dt1: gconstpointer; dt2: gconstpointer): gint {.
    importc: "g_date_time_compare", libglib.}
proc difference*(`end`: GDateTime; begin: GDateTime): GTimeSpan {.
    importc: "g_date_time_difference", libglib.}
proc g_date_time_hash*(datetime: gconstpointer): guint {.
    importc: "g_date_time_hash", libglib.}
proc g_date_time_equal*(dt1: gconstpointer; dt2: gconstpointer): gboolean {.
    importc: "g_date_time_equal", libglib.}
proc get_ymd*(datetime: GDateTime; year: var gint; 
                          month: var gint; day: var gint) {.
    importc: "g_date_time_get_ymd", libglib.}
proc get_year*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_year", libglib.}
proc year*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_year", libglib.}
proc get_month*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_month", libglib.}
proc month*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_month", libglib.}
proc get_day_of_month*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_day_of_month", libglib.}
proc day_of_month*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_day_of_month", libglib.}
proc get_week_numbering_year*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_week_numbering_year", libglib.}
proc week_numbering_year*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_week_numbering_year", libglib.}
proc get_week_of_year*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_week_of_year", libglib.}
proc week_of_year*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_week_of_year", libglib.}
proc get_day_of_week*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_day_of_week", libglib.}
proc day_of_week*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_day_of_week", libglib.}
proc get_day_of_year*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_day_of_year", libglib.}
proc day_of_year*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_day_of_year", libglib.}
proc get_hour*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_hour", libglib.}
proc hour*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_hour", libglib.}
proc get_minute*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_minute", libglib.}
proc minute*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_minute", libglib.}
proc get_second*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_second", libglib.}
proc second*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_second", libglib.}
proc get_microsecond*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_microsecond", libglib.}
proc microsecond*(datetime: GDateTime): gint {.
    importc: "g_date_time_get_microsecond", libglib.}
proc get_seconds*(datetime: GDateTime): gdouble {.
    importc: "g_date_time_get_seconds", libglib.}
proc seconds*(datetime: GDateTime): gdouble {.
    importc: "g_date_time_get_seconds", libglib.}
proc to_unix*(datetime: GDateTime): gint64 {.
    importc: "g_date_time_to_unix", libglib.}
proc to_timeval*(datetime: GDateTime; tv: GTimeVal): gboolean {.
    importc: "g_date_time_to_timeval", libglib.}
proc get_utc_offset*(datetime: GDateTime): GTimeSpan {.
    importc: "g_date_time_get_utc_offset", libglib.}
proc utc_offset*(datetime: GDateTime): GTimeSpan {.
    importc: "g_date_time_get_utc_offset", libglib.}
proc get_timezone_abbreviation*(datetime: GDateTime): cstring {.
    importc: "g_date_time_get_timezone_abbreviation", libglib.}
proc timezone_abbreviation*(datetime: GDateTime): cstring {.
    importc: "g_date_time_get_timezone_abbreviation", libglib.}
proc is_daylight_savings*(datetime: GDateTime): gboolean {.
    importc: "g_date_time_is_daylight_savings", libglib.}
proc to_timezone*(datetime: GDateTime; tz: GTimeZone): GDateTime {.
    importc: "g_date_time_to_timezone", libglib.}
proc to_local*(datetime: GDateTime): GDateTime {.
    importc: "g_date_time_to_local", libglib.}
proc to_utc*(datetime: GDateTime): GDateTime {.
    importc: "g_date_time_to_utc", libglib.}
proc format*(datetime: GDateTime; format: cstring): cstring {.
    importc: "g_date_time_format", libglib.}

type 
  GDir* =  ptr GDirObj
  GDirPtr* = ptr GDirObj
  GDirObj* = object 
  

proc rewind*(dir: GDir) {.importc: "g_dir_rewind", libglib.}
proc close*(dir: GDir) {.importc: "g_dir_close", libglib.}
when defined(windows):
  proc g_dir_open_utf8*(path: cstring; flags: guint; error: var GError): GDir {.
      importc: "g_dir_open_utf8", libglib.}
  proc read_name_utf8*(dir: GDir): cstring {.
      importc: "g_dir_read_name_utf8", libglib.}
  const 
    g_dir_open* = g_dir_open_utf8
    read_name* = read_name_utf8
else:
  proc g_dir_open*(path: cstring; flags: guint; error: var GError): GDir {.
      importc: "g_dir_open", libglib.}
  proc read_name*(dir: GDir): cstring {.importc: "g_dir_read_name", 
      libglib.}

proc g_listenv*(): cstringArray {.importc: "g_listenv", libglib.}
proc g_get_environ*(): cstringArray {.importc: "g_get_environ", libglib.}
proc g_environ_getenv*(envp: cstringArray; variable: cstring): cstring {.
    importc: "g_environ_getenv", libglib.}
proc g_environ_setenv*(envp: cstringArray; variable: cstring; 
                       value: cstring; overwrite: gboolean): cstringArray {.
    importc: "g_environ_setenv", libglib.}
proc g_environ_unsetenv*(envp: cstringArray; variable: cstring): cstringArray {.
    importc: "g_environ_unsetenv", libglib.}
when defined(windows): 
  proc g_getenv_utf8*(variable: cstring): cstring {.
      importc: "g_getenv_utf8", libglib.}
  proc g_setenv_utf8*(variable: cstring; value: cstring; 
                      overwrite: gboolean): gboolean {.
      importc: "g_setenv_utf8", libglib.}
  proc g_unsetenv_utf8*(variable: cstring) {.importc: "g_unsetenv_utf8", 
      libglib.}
  const 
    g_getenv* = g_getenv_utf8
    g_setenv* = g_setenv_utf8
    g_unsetenv* = g_unsetenv_utf8
else:
  proc g_getenv*(variable: cstring): cstring {.importc: "g_getenv", 
      libglib.}
  proc g_setenv*(variable: cstring; value: cstring; overwrite: gboolean): gboolean {.
      importc: "g_setenv", libglib.}
  proc g_unsetenv*(variable: cstring) {.importc: "g_unsetenv", libglib.}

type 
  GFileError* {.size: sizeof(cint), pure.} = enum 
    EXIST, ISDIR, ACCES, 
    NAMETOOLONG, NOENT, NOTDIR, 
    NXIO, NODEV, ROFS, 
    TXTBSY, FAULT, LOOP, 
    NOSPC, NOMEM, MFILE, 
    NFILE, BADF, INVAL, 
    PIPE, AGAIN, INTR, IO, 
    PERM, NOSYS, FAILED
type 
  GFileTest* {.size: sizeof(cint), pure.} = enum 
    IS_REGULAR = 1 shl 0, IS_SYMLINK = 1 shl 1, 
    IS_DIR = 1 shl 2, IS_EXECUTABLE = 1 shl 3, 
    EXISTS = 1 shl 4
proc g_file_error_quark*(): GQuark {.importc: "g_file_error_quark", 
                                     libglib.}
proc g_file_error_from_errno*(err_no: gint): GFileError {.
    importc: "g_file_error_from_errno", libglib.}
when not defined(windows): 
  proc g_file_test*(filename: cstring; test: GFileTest): gboolean {.
      importc: "g_file_test", libglib.}
  proc g_file_get_contents*(filename: cstring; contents: cstringArray; 
                            length: var gsize; error: var GError): gboolean {.
      importc: "g_file_get_contents", libglib.}
proc g_file_set_contents*(filename: cstring; contents: cstring; 
                          length: gssize; error: var GError): gboolean {.
    importc: "g_file_set_contents", libglib.}
proc g_file_read_link*(filename: cstring; error: var GError): cstring {.
    importc: "g_file_read_link", libglib.}
proc g_mkdtemp*(tmpl: cstring): cstring {.importc: "g_mkdtemp", 
    libglib.}
proc g_mkdtemp_full*(tmpl: cstring; mode: gint): cstring {.
    importc: "g_mkdtemp_full", libglib.}
when not defined(windows): 
  proc g_mkstemp*(tmpl: cstring): gint {.importc: "g_mkstemp", libglib.}
proc g_mkstemp_full*(tmpl: cstring; flags: gint; mode: gint): gint {.
    importc: "g_mkstemp_full", libglib.}
when not defined(windows): 
  proc g_file_open_tmp*(tmpl: cstring; name_used: cstringArray; 
                        error: var GError): gint {.
      importc: "g_file_open_tmp", libglib.}
proc g_dir_make_tmp*(tmpl: cstring; error: var GError): cstring {.
    importc: "g_dir_make_tmp", libglib.}
proc g_build_path*(separator: cstring; first_element: cstring): cstring {.
    varargs, importc: "g_build_path", libglib.}
proc g_build_pathv*(separator: cstring; args: cstringArray): cstring {.
    importc: "g_build_pathv", libglib.}
proc g_build_filename*(first_element: cstring): cstring {.varargs, 
    importc: "g_build_filename", libglib.}
proc g_build_filenamev*(args: cstringArray): cstring {.
    importc: "g_build_filenamev", libglib.}
proc g_mkdir_with_parents*(pathname: cstring; mode: gint): gint {.
    importc: "g_mkdir_with_parents", libglib.}
when defined(windows): 
  const 
    G_DIR_SEPARATOR* = '\x08'
    G_DIR_SEPARATOR_S* = "\x08"
  template g_is_dir_separator*(c: expr): expr = 
    (c == G_DIR_SEPARATOR or (c) == '/')

  const 
    G_SEARCHPATH_SEPARATOR* = ';'
    G_SEARCHPATH_SEPARATOR_S* = ";"
else: 
  const 
    G_DIR_SEPARATOR* = '/'
    G_DIR_SEPARATOR_S* = "/"
  template g_is_dir_separator*(c: expr): expr = 
    (c == G_DIR_SEPARATOR)

  const 
    G_SEARCHPATH_SEPARATOR* = ':'
    G_SEARCHPATH_SEPARATOR_S* = ":"
proc g_path_is_absolute*(file_name: cstring): gboolean {.
    importc: "g_path_is_absolute", libglib.}
proc g_path_skip_root*(file_name: cstring): cstring {.
    importc: "g_path_skip_root", libglib.}
proc g_basename*(file_name: cstring): cstring {.importc: "g_basename", 
    libglib.}
when not defined(windows): 
  proc g_get_current_dir*(): cstring {.importc: "g_get_current_dir", 
      libglib.}
proc g_path_get_basename*(file_name: cstring): cstring {.
    importc: "g_path_get_basename", libglib.}
proc g_path_get_dirname*(file_name: cstring): cstring {.
    importc: "g_path_get_dirname", libglib.}
when not(defined(G_DISABLE_DEPRECATED)): 
  const 
    g_dirname* = g_path_get_dirname
when defined(windows): 
  proc g_file_test_utf8*(filename: cstring; test: GFileTest): gboolean {.
      importc: "g_file_test_utf8", libglib.}
  proc g_file_get_contents_utf8*(filename: cstring; contents: cstringArray; 
                                 length: var gsize; error: var GError): gboolean {.
      importc: "g_file_get_contents_utf8", libglib.}
  proc g_mkstemp_utf8*(tmpl: cstring): gint {.importc: "g_mkstemp_utf8", 
      libglib.}
  proc g_file_open_tmp_utf8*(tmpl: cstring; name_used: cstringArray; 
                             error: var GError): gint {.
      importc: "g_file_open_tmp_utf8", libglib.}
  proc g_get_current_dir_utf8*(): cstring {.
      importc: "g_get_current_dir_utf8", libglib.}
  const 
    g_file_test* = g_file_test_utf8
    g_file_get_contents* = g_file_get_contents_utf8
    g_mkstemp* = g_mkstemp_utf8
    g_file_open_tmp* = g_file_open_tmp_utf8
    g_get_current_dir* = g_get_current_dir_utf8

proc g_strip_context*(msgid: cstring; msgval: cstring): cstring {.
    importc: "g_strip_context", libglib.}
proc g_dgettext*(domain: cstring; msgid: cstring): cstring {.
    importc: "g_dgettext", libglib.}
proc g_dcgettext*(domain: cstring; msgid: cstring; category: gint): cstring {.
    importc: "g_dcgettext", libglib.}
proc g_dngettext*(domain: cstring; msgid: cstring; 
                  msgid_plural: cstring; n: gulong): cstring {.
    importc: "g_dngettext", libglib.}
proc g_dpgettext*(domain: cstring; msgctxtid: cstring; msgidoffset: gsize): cstring {.
    importc: "g_dpgettext", libglib.}
proc g_dpgettext2*(domain: cstring; context: cstring; msgid: cstring): cstring {.
    importc: "g_dpgettext2", libglib.}

proc g_free*(mem: gpointer) {.importc: "g_free", libglib.}
proc g_clear_pointer*(pp: ptr gpointer; destroy: GDestroyNotify) {.
    importc: "g_clear_pointer", libglib.}
proc g_malloc*(n_bytes: gsize): gpointer {.importc: "g_malloc", libglib.}
proc g_malloc0*(n_bytes: gsize): gpointer {.importc: "g_malloc0", libglib.}
proc g_realloc*(mem: gpointer; n_bytes: gsize): gpointer {.
    importc: "g_realloc", libglib.}
proc g_try_malloc*(n_bytes: gsize): gpointer {.importc: "g_try_malloc", 
    libglib.}
proc g_try_malloc0*(n_bytes: gsize): gpointer {.importc: "g_try_malloc0", 
    libglib.}
proc g_try_realloc*(mem: gpointer; n_bytes: gsize): gpointer {.
    importc: "g_try_realloc", libglib.}
proc g_malloc_n*(n_blocks: gsize; n_block_bytes: gsize): gpointer {.
    importc: "g_malloc_n", libglib.}
proc g_malloc0_n*(n_blocks: gsize; n_block_bytes: gsize): gpointer {.
    importc: "g_malloc0_n", libglib.}
proc g_realloc_n*(mem: gpointer; n_blocks: gsize; n_block_bytes: gsize): gpointer {.
    importc: "g_realloc_n", libglib.}
proc g_try_malloc_n*(n_blocks: gsize; n_block_bytes: gsize): gpointer {.
    importc: "g_try_malloc_n", libglib.}
proc g_try_malloc0_n*(n_blocks: gsize; n_block_bytes: gsize): gpointer {.
    importc: "g_try_malloc0_n", libglib.}
proc g_try_realloc_n*(mem: gpointer; n_blocks: gsize; n_block_bytes: gsize): gpointer {.
    importc: "g_try_realloc_n", libglib.}
type 
  GMemVTable* =  ptr GMemVTableObj
  GMemVTablePtr* = ptr GMemVTableObj
  GMemVTableObj* = object 
    malloc*: proc (n_bytes: gsize): gpointer {.cdecl.}
    realloc*: proc (mem: gpointer; n_bytes: gsize): gpointer {.cdecl.}
    free*: proc (mem: gpointer) {.cdecl.}
    calloc*: proc (n_blocks: gsize; n_block_bytes: gsize): gpointer {.cdecl.}
    try_malloc*: proc (n_bytes: gsize): gpointer {.cdecl.}
    try_realloc*: proc (mem: gpointer; n_bytes: gsize): gpointer {.cdecl.}

proc g_mem_set_vtable*(vtable: GMemVTable) {.importc: "g_mem_set_vtable", 
    libglib.}
proc g_mem_is_system_malloc*(): gboolean {.importc: "g_mem_is_system_malloc", 
    libglib.}
proc g_mem_profile*() {.importc: "g_mem_profile", libglib.}

type 
  GTraverseFlags* {.size: sizeof(cint), pure.} = enum 
    LEAVES = 1 shl 0, NON_LEAVES = 1 shl 1, 
    ALL = GTraverseFlags.LEAVES.ord or GTraverseFlags.NON_LEAVES.ord
const
  G_TRAVERSE_MASK = GTraverseFlags.ALL
  G_TRAVERSE_LEAFS = GTraverseFlags.LEAVES
  G_TRAVERSE_NON_LEAFS = GTraverseFlags.NON_LEAVES
type 
  GTraverseType* {.size: sizeof(cint), pure.} = enum 
    IN_ORDER, PRE_ORDER, POST_ORDER, LEVEL_ORDER
  GNodeTraverseFunc* = proc (node: GNode; data: gpointer): gboolean {.cdecl.}
  GNodeForeachFunc* = proc (node: GNode; data: gpointer) {.cdecl.}
  GCopyFunc* = proc (src: gconstpointer; data: gpointer): gpointer {.cdecl.}
  GNode* =  ptr GNodeObj
  GNodePtr* = ptr GNodeObj
  GNodeObj* = object 
    data*: gpointer
    next*: GNode
    prev*: GNode
    parent*: GNode
    children*: GNode

template g_node_is_root*(node: expr): expr = 
  ((cast[GNode](node)).parent == nil and
      (cast[GNode](node)).prev == nil and
      (cast[GNode](node)).next == nil)

template g_node_is_leaf*(node: expr): expr = 
  ((cast[GNode](node)).children == nil)

proc g_node_new*(data: gpointer): GNode {.importc: "g_node_new", 
    libglib.}
proc destroy*(root: GNode) {.importc: "g_node_destroy", libglib.}
proc unlink*(node: GNode) {.importc: "g_node_unlink", libglib.}
proc copy_deep*(node: GNode; copy_func: GCopyFunc; data: gpointer): GNode {.
    importc: "g_node_copy_deep", libglib.}
proc copy*(node: GNode): GNode {.importc: "g_node_copy", 
    libglib.}
proc insert*(parent: GNode; position: gint; node: GNode): GNode {.
    importc: "g_node_insert", libglib.}
proc insert_before*(parent: GNode; sibling: GNode; 
                           node: GNode): GNode {.
    importc: "g_node_insert_before", libglib.}
proc insert_after*(parent: GNode; sibling: GNode; 
                          node: GNode): GNode {.
    importc: "g_node_insert_after", libglib.}
proc prepend*(parent: GNode; node: GNode): GNode {.
    importc: "g_node_prepend", libglib.}
proc n_nodes*(root: GNode; flags: GTraverseFlags): guint {.
    importc: "g_node_n_nodes", libglib.}
proc get_root*(node: GNode): GNode {.
    importc: "g_node_get_root", libglib.}
proc root*(node: GNode): GNode {.
    importc: "g_node_get_root", libglib.}
proc is_ancestor*(node: GNode; descendant: GNode): gboolean {.
    importc: "g_node_is_ancestor", libglib.}
proc depth*(node: GNode): guint {.importc: "g_node_depth", 
    libglib.}
proc find*(root: GNode; order: GTraverseType; 
                  flags: GTraverseFlags; data: gpointer): GNode {.
    importc: "g_node_find", libglib.}
template g_node_append*(parent, node: expr): expr = 
  insert_before(parent, nil, node)

template g_node_insert_data*(parent, position, data: expr): expr = 
  insert(parent, position, g_node_new(data))

template g_node_insert_data_after*(parent, sibling, data: expr): expr = 
  insert_after(parent, sibling, g_node_new(data))

template g_node_insert_data_before*(parent, sibling, data: expr): expr = 
  insert_before(parent, sibling, g_node_new(data))

template g_node_prepend_data*(parent, data: expr): expr = 
  prepend(parent, g_node_new(data))

template g_node_append_data*(parent, data: expr): expr = 
  insert_before(parent, nil, g_node_new(data))

proc traverse*(root: GNode; order: GTraverseType; 
                      flags: GTraverseFlags; max_depth: gint; 
                      `func`: GNodeTraverseFunc; data: gpointer) {.
    importc: "g_node_traverse", libglib.}
proc max_height*(root: GNode): guint {.
    importc: "g_node_max_height", libglib.}
proc children_foreach*(node: GNode; flags: GTraverseFlags; 
                              `func`: GNodeForeachFunc; data: gpointer) {.
    importc: "g_node_children_foreach", libglib.}
proc reverse_children*(node: GNode) {.
    importc: "g_node_reverse_children", libglib.}
proc n_children*(node: GNode): guint {.
    importc: "g_node_n_children", libglib.}
proc nth_child*(node: GNode; n: guint): GNode {.
    importc: "g_node_nth_child", libglib.}
proc last_child*(node: GNode): GNode {.
    importc: "g_node_last_child", libglib.}
proc find_child*(node: GNode; flags: GTraverseFlags; data: gpointer): GNode {.
    importc: "g_node_find_child", libglib.}
proc child_position*(node: GNode; child: GNode): gint {.
    importc: "g_node_child_position", libglib.}
proc child_index*(node: GNode; data: gpointer): gint {.
    importc: "g_node_child_index", libglib.}
proc first_sibling*(node: GNode): GNode {.
    importc: "g_node_first_sibling", libglib.}
proc last_sibling*(node: GNode): GNode {.
    importc: "g_node_last_sibling", libglib.}
template g_node_prev_sibling*(node: expr): expr = 
  (if (node): (cast[GNode](node)).prev else: nil)

template g_node_next_sibling*(node: expr): expr = 
  (if (node): (cast[GNode](node)).next else: nil)

template g_node_first_child*(node: expr): expr = 
  (if (node): (cast[GNode](node)).children else: nil)

type 
  GList* =  ptr GListObj
  GListPtr* = ptr GListObj
  GListObj* = object 
    data*: gpointer
    next*: GList
    prev*: GList

proc g_list_alloc*(): GList {.importc: "g_list_alloc", libglib.}
proc free*(list: GList) {.importc: "g_list_free", libglib.}
proc free_1*(list: GList) {.importc: "g_list_free_1", libglib.}
proc free_full*(list: GList; free_func: GDestroyNotify) {.
    importc: "g_list_free_full", libglib.}
proc append*(list: GList; data: gpointer): GList {.
    importc: "g_list_append", libglib.}
proc prepend*(list: GList; data: gpointer): GList {.
    importc: "g_list_prepend", libglib.}
proc insert*(list: GList; data: gpointer; position: gint): GList {.
    importc: "g_list_insert", libglib.}
proc insert_sorted*(list: GList; data: gpointer; `func`: GCompareFunc): GList {.
    importc: "g_list_insert_sorted", libglib.}
proc insert_sorted_with_data*(list: GList; data: gpointer; 
                                     `func`: GCompareDataFunc; 
                                     user_data: gpointer): GList {.
    importc: "g_list_insert_sorted_with_data", libglib.}
proc insert_before*(list: GList; sibling: GList; data: gpointer): GList {.
    importc: "g_list_insert_before", libglib.}
proc concat*(list1: GList; list2: GList): GList {.
    importc: "g_list_concat", libglib.}
proc remove*(list: GList; data: gconstpointer): GList {.
    importc: "g_list_remove", libglib.}
proc remove_all*(list: GList; data: gconstpointer): GList {.
    importc: "g_list_remove_all", libglib.}
proc remove_link*(list: GList; llink: GList): GList {.
    importc: "g_list_remove_link", libglib.}
proc delete_link*(list: GList; link: GList): GList {.
    importc: "g_list_delete_link", libglib.}
proc reverse*(list: GList): GList {.importc: "g_list_reverse", 
    libglib.}
proc copy*(list: GList): GList {.importc: "g_list_copy", 
    libglib.}
proc copy_deep*(list: GList; `func`: GCopyFunc; user_data: gpointer): GList {.
    importc: "g_list_copy_deep", libglib.}
proc nth*(list: GList; n: guint): GList {.
    importc: "g_list_nth", libglib.}
proc nth_prev*(list: GList; n: guint): GList {.
    importc: "g_list_nth_prev", libglib.}
proc find*(list: GList; data: gconstpointer): GList {.
    importc: "g_list_find", libglib.}
proc find_custom*(list: GList; data: gconstpointer; 
                         `func`: GCompareFunc): GList {.
    importc: "g_list_find_custom", libglib.}
proc position*(list: GList; llink: GList): gint {.
    importc: "g_list_position", libglib.}
proc index*(list: GList; data: gconstpointer): gint {.
    importc: "g_list_index", libglib.}
proc last*(list: GList): GList {.importc: "g_list_last", 
    libglib.}
proc first*(list: GList): GList {.importc: "g_list_first", 
    libglib.}
proc length*(list: GList): guint {.importc: "g_list_length", 
    libglib.}
proc foreach*(list: GList; `func`: GFunc; user_data: gpointer) {.
    importc: "g_list_foreach", libglib.}
proc sort*(list: GList; compare_func: GCompareFunc): GList {.
    importc: "g_list_sort", libglib.}
proc sort_with_data*(list: GList; compare_func: GCompareDataFunc; 
                            user_data: gpointer): GList {.
    importc: "g_list_sort_with_data", libglib.}
proc nth_data*(list: GList; n: guint): gpointer {.
    importc: "g_list_nth_data", libglib.}
template g_list_previous*(list: expr): expr = 
  (if (list): ((cast[GList](list)).prev) else: nil)

template g_list_next*(list: expr): expr = 
  (if (list): ((cast[GList](list)).next) else: nil)

type 
  GHashTable* =  ptr GHashTableObj
  GHashTablePtr* = ptr GHashTableObj
  GHashTableObj* = object 
  
  GHRFunc* = proc (key: gpointer; value: gpointer; user_data: gpointer): gboolean {.cdecl.}
type 
  GHashTableIter* =  ptr GHashTableIterObj
  GHashTableIterPtr* = ptr GHashTableIterObj
  GHashTableIterObj* = object 
    dummy1: gpointer
    dummy2: gpointer
    dummy3: gpointer
    dummy4: cint
    dummy5: gboolean
    dummy6: gpointer

proc g_hash_table_new*(hash_func: GHashFunc; key_equal_func: GEqualFunc): GHashTable {.
    importc: "g_hash_table_new", libglib.}
proc g_hash_table_new_full*(hash_func: GHashFunc; key_equal_func: GEqualFunc; 
                            key_destroy_func: GDestroyNotify; 
                            value_destroy_func: GDestroyNotify): GHashTable {.
    importc: "g_hash_table_new_full", libglib.}
proc destroy*(hash_table: GHashTable) {.
    importc: "g_hash_table_destroy", libglib.}
proc insert*(hash_table: GHashTable; key: gpointer; 
                          value: gpointer): gboolean {.
    importc: "g_hash_table_insert", libglib.}
proc replace*(hash_table: GHashTable; key: gpointer; 
                           value: gpointer): gboolean {.
    importc: "g_hash_table_replace", libglib.}
proc add*(hash_table: GHashTable; key: gpointer): gboolean {.
    importc: "g_hash_table_add", libglib.}
proc remove*(hash_table: GHashTable; key: gconstpointer): gboolean {.
    importc: "g_hash_table_remove", libglib.}
proc remove_all*(hash_table: GHashTable) {.
    importc: "g_hash_table_remove_all", libglib.}
proc steal*(hash_table: GHashTable; key: gconstpointer): gboolean {.
    importc: "g_hash_table_steal", libglib.}
proc steal_all*(hash_table: GHashTable) {.
    importc: "g_hash_table_steal_all", libglib.}
proc lookup*(hash_table: GHashTable; key: gconstpointer): gpointer {.
    importc: "g_hash_table_lookup", libglib.}
proc contains*(hash_table: GHashTable; key: gconstpointer): gboolean {.
    importc: "g_hash_table_contains", libglib.}
proc lookup_extended*(hash_table: GHashTable; 
                                   lookup_key: gconstpointer; 
                                   orig_key: ptr gpointer; value: ptr gpointer): gboolean {.
    importc: "g_hash_table_lookup_extended", libglib.}
proc foreach*(hash_table: GHashTable; `func`: GHFunc; 
                           user_data: gpointer) {.
    importc: "g_hash_table_foreach", libglib.}
proc find*(hash_table: GHashTable; predicate: GHRFunc; 
                        user_data: gpointer): gpointer {.
    importc: "g_hash_table_find", libglib.}
proc foreach_remove*(hash_table: GHashTable; `func`: GHRFunc; 
                                  user_data: gpointer): guint {.
    importc: "g_hash_table_foreach_remove", libglib.}
proc foreach_steal*(hash_table: GHashTable; `func`: GHRFunc; 
                                 user_data: gpointer): guint {.
    importc: "g_hash_table_foreach_steal", libglib.}
proc size*(hash_table: GHashTable): guint {.
    importc: "g_hash_table_size", libglib.}
proc get_keys*(hash_table: GHashTable): GList {.
    importc: "g_hash_table_get_keys", libglib.}
proc keys*(hash_table: GHashTable): GList {.
    importc: "g_hash_table_get_keys", libglib.}
proc get_values*(hash_table: GHashTable): GList {.
    importc: "g_hash_table_get_values", libglib.}
proc values*(hash_table: GHashTable): GList {.
    importc: "g_hash_table_get_values", libglib.}
proc get_keys_as_array*(hash_table: GHashTable; 
                                     length: ptr guint): ptr gpointer {.
    importc: "g_hash_table_get_keys_as_array", libglib.}
proc keys_as_array*(hash_table: GHashTable; 
                                     length: ptr guint): ptr gpointer {.
    importc: "g_hash_table_get_keys_as_array", libglib.}
proc init*(iter: GHashTableIter; 
                             hash_table: GHashTable) {.
    importc: "g_hash_table_iter_init", libglib.}
proc next*(iter: GHashTableIter; key: ptr gpointer; 
                             value: ptr gpointer): gboolean {.
    importc: "g_hash_table_iter_next", libglib.}
proc get_hash_table*(iter: GHashTableIter): GHashTable {.
    importc: "g_hash_table_iter_get_hash_table", libglib.}
proc hash_table*(iter: GHashTableIter): GHashTable {.
    importc: "g_hash_table_iter_get_hash_table", libglib.}
proc remove*(iter: GHashTableIter) {.
    importc: "g_hash_table_iter_remove", libglib.}
proc replace*(iter: GHashTableIter; value: gpointer) {.
    importc: "g_hash_table_iter_replace", libglib.}
proc steal*(iter: GHashTableIter) {.
    importc: "g_hash_table_iter_steal", libglib.}
proc `ref`*(hash_table: GHashTable): GHashTable {.
    importc: "g_hash_table_ref", libglib.}
proc unref*(hash_table: GHashTable) {.
    importc: "g_hash_table_unref", libglib.}
when not(defined(G_DISABLE_DEPRECATED)): 
  template g_hash_table_freeze*(hash_table: expr): expr = 
    (cast[nil](0))

  template g_hash_table_thaw*(hash_table: expr): expr = 
    (cast[nil](0))

proc g_str_equal*(v1: gconstpointer; v2: gconstpointer): gboolean {.
    importc: "g_str_equal", libglib.}
proc g_str_hash*(v: gconstpointer): guint {.importc: "g_str_hash", libglib.}
proc g_int_equal*(v1: gconstpointer; v2: gconstpointer): gboolean {.
    importc: "g_int_equal", libglib.}
proc g_int_hash*(v: gconstpointer): guint {.importc: "g_int_hash", libglib.}
proc g_int64_equal*(v1: gconstpointer; v2: gconstpointer): gboolean {.
    importc: "g_int64_equal", libglib.}
proc g_int64_hash*(v: gconstpointer): guint {.importc: "g_int64_hash", 
    libglib.}
proc g_double_equal*(v1: gconstpointer; v2: gconstpointer): gboolean {.
    importc: "g_double_equal", libglib.}
proc g_double_hash*(v: gconstpointer): guint {.importc: "g_double_hash", 
    libglib.}
proc g_direct_hash*(v: gconstpointer): guint {.importc: "g_direct_hash", 
    libglib.}
proc g_direct_equal*(v1: gconstpointer; v2: gconstpointer): gboolean {.
    importc: "g_direct_equal", libglib.}

type 
  GHmac* =  ptr GHmacObj
  GHmacPtr* = ptr GHmacObj
  GHmacObj* = object 
  
proc g_hmac_new*(digest_type: GChecksumType; key: ptr guchar; key_len: gsize): GHmac {.
    importc: "g_hmac_new", libglib.}
proc copy*(hmac: GHmac): GHmac {.importc: "g_hmac_copy", 
    libglib.}
proc `ref`*(hmac: GHmac): GHmac {.importc: "g_hmac_ref", 
    libglib.}
proc unref*(hmac: GHmac) {.importc: "g_hmac_unref", libglib.}
proc update*(hmac: GHmac; data: ptr guchar; length: gssize) {.
    importc: "g_hmac_update", libglib.}
proc get_string*(hmac: GHmac): cstring {.
    importc: "g_hmac_get_string", libglib.}
proc get_digest*(hmac: GHmac; buffer: ptr guint8; 
                        digest_len: var gsize) {.importc: "g_hmac_get_digest", 
    libglib.}
proc g_compute_hmac_for_data*(digest_type: GChecksumType; key: ptr guchar; 
                              key_len: gsize; data: ptr guchar; length: gsize): cstring {.
    importc: "g_compute_hmac_for_data", libglib.}
proc g_compute_hmac_for_string*(digest_type: GChecksumType; key: ptr guchar; 
                                key_len: gsize; str: cstring; length: gssize): cstring {.
    importc: "g_compute_hmac_for_string", libglib.}

type 
  GHookCompareFunc* = proc (new_hook: GHook; sibling: GHook): gint {.cdecl.}
  GHookFindFunc* = proc (hook: GHook; data: gpointer): gboolean {.cdecl.}
  GHookMarshaller* = proc (hook: GHook; marshal_data: gpointer) {.cdecl.}
  GHookCheckMarshaller* = proc (hook: GHook; marshal_data: gpointer): gboolean {.cdecl.}
  GHookFunc* = proc (data: gpointer) {.cdecl.}
  GHookCheckFunc* = proc (data: gpointer): gboolean {.cdecl.}
  GHookFinalizeFunc* = proc (hook_list: GHookList; hook: GHook) {.cdecl.}
  GHookFlagMask* {.size: sizeof(cint), pure.} = enum 
    ACTIVE = 1 shl 0, IN_CALL = 1 shl 1, 
    MSK = 0x0000000F

  GHookList* =  ptr GHookListObj
  GHookListPtr* = ptr GHookListObj
  GHookListObj* = object 
    seq_id*: gulong
    bitfield0GHookList*: guintwith32bitatleast
    hooks*: GHook
    dummy3: gpointer
    finalize_hook*: GHookFinalizeFunc
    dummy: array[2, gpointer]

  GHook* =  ptr GHookObj
  GHookPtr* = ptr GHookObj
  GHookObj* = object 
    data*: gpointer
    next*: GHook
    prev*: GHook
    ref_count*: guint
    hook_id*: gulong
    flags*: guint
    `func`*: gpointer
    destroy*: GDestroyNotify

const 
  G_HOOK_FLAG_USER_SHIFT* = 4

template g_hook*(hook: expr): expr = 
  (cast[GHook](hook))

template g_hook_flags*(hook: expr): expr = 
  (G_HOOK(hook).flags)

template g_hook_active*(hook: expr): expr = 
  ((g_hook_flags(hook) and G_HOOK_FLAG_ACTIVE) != 0)

template g_hook_in_call*(hook: expr): expr = 
  ((g_hook_flags(hook) and G_HOOK_FLAG_IN_CALL) != 0)

template g_hook_is_valid*(hook: expr): expr = 
  (G_HOOK(hook).hook_id != 0 and
      (g_hook_flags(hook) and G_HOOK_FLAG_ACTIVE))

template g_hook_is_unlinked*(hook: expr): expr = 
  (G_HOOK(hook).next == nil and G_HOOK(hook).prev == nil and
      G_HOOK(hook).hook_id == 0 and G_HOOK(hook).ref_count == 0)

proc init*(hook_list: GHookList; hook_size: guint) {.
    importc: "g_hook_list_init", libglib.}
proc clear*(hook_list: GHookList) {.
    importc: "g_hook_list_clear", libglib.}
proc alloc*(hook_list: GHookList): GHook {.
    importc: "g_hook_alloc", libglib.}
proc free*(hook_list: GHookList; hook: GHook) {.
    importc: "g_hook_free", libglib.}
proc `ref`*(hook_list: GHookList; hook: GHook): GHook {.
    importc: "g_hook_ref", libglib.}
proc unref*(hook_list: GHookList; hook: GHook) {.
    importc: "g_hook_unref", libglib.}
proc destroy*(hook_list: GHookList; hook_id: gulong): gboolean {.
    importc: "g_hook_destroy", libglib.}
proc destroy_link*(hook_list: GHookList; hook: GHook) {.
    importc: "g_hook_destroy_link", libglib.}
proc prepend*(hook_list: GHookList; hook: GHook) {.
    importc: "g_hook_prepend", libglib.}
proc insert_before*(hook_list: GHookList; sibling: GHook; 
                           hook: GHook) {.importc: "g_hook_insert_before", 
    libglib.}
proc insert_sorted*(hook_list: GHookList; hook: GHook; 
                           `func`: GHookCompareFunc) {.
    importc: "g_hook_insert_sorted", libglib.}
proc get*(hook_list: GHookList; hook_id: gulong): GHook {.
    importc: "g_hook_get", libglib.}
proc find*(hook_list: GHookList; need_valids: gboolean; 
                  `func`: GHookFindFunc; data: gpointer): GHook {.
    importc: "g_hook_find", libglib.}
proc find_data*(hook_list: GHookList; need_valids: gboolean; 
                       data: gpointer): GHook {.
    importc: "g_hook_find_data", libglib.}
proc find_func*(hook_list: GHookList; need_valids: gboolean; 
                       `func`: gpointer): GHook {.
    importc: "g_hook_find_func", libglib.}
proc find_func_data*(hook_list: GHookList; need_valids: gboolean; 
                            `func`: gpointer; data: gpointer): GHook {.
    importc: "g_hook_find_func_data", libglib.}
proc first_valid*(hook_list: GHookList; may_be_in_call: gboolean): GHook {.
    importc: "g_hook_first_valid", libglib.}
proc next_valid*(hook_list: GHookList; hook: GHook; 
                        may_be_in_call: gboolean): GHook {.
    importc: "g_hook_next_valid", libglib.}
proc compare_ids*(new_hook: GHook; sibling: GHook): gint {.
    importc: "g_hook_compare_ids", libglib.}
template g_hook_append*(hook_list, hook: expr): expr = 
  insert_before(hook_list, nil, hook)

proc invoke*(hook_list: GHookList; may_recurse: gboolean) {.
    importc: "g_hook_list_invoke", libglib.}
proc invoke_check*(hook_list: GHookList; may_recurse: gboolean) {.
    importc: "g_hook_list_invoke_check", libglib.}
proc marshal*(hook_list: GHookList; may_recurse: gboolean; 
                          marshaller: GHookMarshaller; marshal_data: gpointer) {.
    importc: "g_hook_list_marshal", libglib.}
proc marshal_check*(hook_list: GHookList; 
                                may_recurse: gboolean; 
                                marshaller: GHookCheckMarshaller; 
                                marshal_data: gpointer) {.
    importc: "g_hook_list_marshal_check", libglib.}

proc g_hostname_is_non_ascii*(hostname: cstring): gboolean {.
    importc: "g_hostname_is_non_ascii", libglib.}
proc g_hostname_is_ascii_encoded*(hostname: cstring): gboolean {.
    importc: "g_hostname_is_ascii_encoded", libglib.}
proc g_hostname_is_ip_address*(hostname: cstring): gboolean {.
    importc: "g_hostname_is_ip_address", libglib.}
proc g_hostname_to_ascii*(hostname: cstring): cstring {.
    importc: "g_hostname_to_ascii", libglib.}
proc g_hostname_to_unicode*(hostname: cstring): cstring {.
    importc: "g_hostname_to_unicode", libglib.}

when defined(windows) and GLIB_SIZEOF_VOID_P == 8: 
  type 
    GPollFD* =  ptr GPollFDObj
    GPollFDPtr* = ptr GPollFDObj
    GPollFDObj* = object 
      fd*: gint64
      events*: gushort
      revents*: gushort

else: 
  type 
    GPollFD* =  ptr GPollFDObj
    GPollFDPtr* = ptr GPollFDObj
    GPollFDObj* = object 
      fd*: gint
      events*: gushort
      revents*: gushort
type 
  GPollFunc* = proc (ufds: GPollFD; nfsd: guint; timeout: gint): gint {.cdecl.}

when defined(windows): 
  when GLIB_SIZEOF_VOID_P == 8: 
    const 
      G_POLLFD_FORMAT* = "%#I64x"
  else: 
    const 
      G_POLLFD_FORMAT* = "%#x"
else: 
  const 
    G_POLLFD_FORMAT* = "%d"
proc g_poll*(fds: GPollFD; nfds: guint; timeout: gint): gint {.
    importc: "g_poll", libglib.}

type 
  GSList* =  ptr GSListObj
  GSListPtr* = ptr GSListObj
  GSListObj* = object 
    data*: gpointer
    next*: GSList

proc g_slist_alloc*(): GSList {.importc: "g_slist_alloc", libglib.}
proc free*(list: GSList) {.importc: "g_slist_free", libglib.}
proc free_1*(list: GSList) {.importc: "g_slist_free_1", 
    libglib.}
proc free_full*(list: GSList; free_func: GDestroyNotify) {.
    importc: "g_slist_free_full", libglib.}
proc append*(list: GSList; data: gpointer): GSList {.
    importc: "g_slist_append", libglib.}
proc prepend*(list: GSList; data: gpointer): GSList {.
    importc: "g_slist_prepend", libglib.}
proc insert*(list: GSList; data: gpointer; position: gint): GSList {.
    importc: "g_slist_insert", libglib.}
proc insert_sorted*(list: GSList; data: gpointer; 
                            `func`: GCompareFunc): GSList {.
    importc: "g_slist_insert_sorted", libglib.}
proc insert_sorted_with_data*(list: GSList; data: gpointer; 
                                      `func`: GCompareDataFunc; 
                                      user_data: gpointer): GSList {.
    importc: "g_slist_insert_sorted_with_data", libglib.}
proc insert_before*(slist: GSList; sibling: GSList; 
                            data: gpointer): GSList {.
    importc: "g_slist_insert_before", libglib.}
proc concat*(list1: GSList; list2: GSList): GSList {.
    importc: "g_slist_concat", libglib.}
proc remove*(list: GSList; data: gconstpointer): GSList {.
    importc: "g_slist_remove", libglib.}
proc remove_all*(list: GSList; data: gconstpointer): GSList {.
    importc: "g_slist_remove_all", libglib.}
proc remove_link*(list: GSList; link: GSList): GSList {.
    importc: "g_slist_remove_link", libglib.}
proc delete_link*(list: GSList; link: GSList): GSList {.
    importc: "g_slist_delete_link", libglib.}
proc reverse*(list: GSList): GSList {.
    importc: "g_slist_reverse", libglib.}
proc copy*(list: GSList): GSList {.importc: "g_slist_copy", 
    libglib.}
proc copy_deep*(list: GSList; `func`: GCopyFunc; user_data: gpointer): GSList {.
    importc: "g_slist_copy_deep", libglib.}
proc nth*(list: GSList; n: guint): GSList {.
    importc: "g_slist_nth", libglib.}
proc find*(list: GSList; data: gconstpointer): GSList {.
    importc: "g_slist_find", libglib.}
proc find_custom*(list: GSList; data: gconstpointer; 
                          `func`: GCompareFunc): GSList {.
    importc: "g_slist_find_custom", libglib.}
proc position*(list: GSList; llink: GSList): gint {.
    importc: "g_slist_position", libglib.}
proc index*(list: GSList; data: gconstpointer): gint {.
    importc: "g_slist_index", libglib.}
proc last*(list: GSList): GSList {.importc: "g_slist_last", 
    libglib.}
proc length*(list: GSList): guint {.importc: "g_slist_length", 
    libglib.}
proc foreach*(list: GSList; `func`: GFunc; user_data: gpointer) {.
    importc: "g_slist_foreach", libglib.}
proc sort*(list: GSList; compare_func: GCompareFunc): GSList {.
    importc: "g_slist_sort", libglib.}
proc sort_with_data*(list: GSList; compare_func: GCompareDataFunc; 
                             user_data: gpointer): GSList {.
    importc: "g_slist_sort_with_data", libglib.}
proc nth_data*(list: GSList; n: guint): gpointer {.
    importc: "g_slist_nth_data", libglib.}
template g_slist_next*(slist: expr): expr = 
  (if (slist): ((cast[GSList](slist)).next) else: nil)

const 
  GLIB_SYSDEF_POLLIN* = 1
  GLIB_SYSDEF_POLLOUT* = 4
  GLIB_SYSDEF_POLLPRI* = 2
  GLIB_SYSDEF_POLLHUP* = 16
  GLIB_SYSDEF_POLLERR* = 8
  GLIB_SYSDEF_POLLNVAL* = 32
type 
  GIOCondition* {.size: sizeof(cint), pure.} = enum 
    IN = GLIB_SYSDEF_POLLIN, PRI = GLIB_SYSDEF_POLLPRI, 
    OUT = GLIB_SYSDEF_POLLOUT, ERR = GLIB_SYSDEF_POLLERR, 
    HUP = GLIB_SYSDEF_POLLHUP, NVAL = GLIB_SYSDEF_POLLNVAL
type 
  GMainContext* =  ptr GMainContextObj
  GMainContextPtr* = ptr GMainContextObj
  GMainContextObj* = object 
  
type 
  GMainLoop* =  ptr GMainLoopObj
  GMainLoopPtr* = ptr GMainLoopObj
  GMainLoopObj* = object 
  
type 
  GSourcePrivate* =  ptr GSourcePrivateObj
  GSourcePrivatePtr* = ptr GSourcePrivateObj
  GSourcePrivateObj* = object 
  
type 
  GSourceFunc* = proc (user_data: gpointer): gboolean {.cdecl.}
type 
  GChildWatchFunc* = proc (pid: GPid; status: gint; user_data: gpointer) {.cdecl.}
type 
  GSource* =  ptr GSourceObj
  GSourcePtr* = ptr GSourceObj
  GSourceObj* = object 
    callback_data*: gpointer
    callback_funcs*: GSourceCallbackFuncs
    source_funcs*: GSourceFuncs
    ref_count*: guint
    context*: GMainContext
    priority*: gint
    flags*: guint
    source_id*: guint
    poll_fds*: GSList
    prev*: GSource
    next*: GSource
    name*: cstring
    priv*: GSourcePrivate

  GSourceCallbackFuncs* =  ptr GSourceCallbackFuncsObj
  GSourceCallbackFuncsPtr* = ptr GSourceCallbackFuncsObj
  GSourceCallbackFuncsObj* = object 
    `ref`*: proc (cb_data: gpointer) {.cdecl.}
    unref*: proc (cb_data: gpointer) {.cdecl.}
    get*: proc (cb_data: gpointer; source: GSource; `func`: ptr GSourceFunc; 
                data: ptr gpointer) {.cdecl.}

  GSourceDummyMarshal* = proc () {.cdecl.}
  GSourceFuncs* =  ptr GSourceFuncsObj
  GSourceFuncsPtr* = ptr GSourceFuncsObj
  GSourceFuncsObj* = object 
    prepare*: proc (source: GSource; timeout: ptr gint): gboolean {.cdecl.}
    check*: proc (source: GSource): gboolean {.cdecl.}
    dispatch*: proc (source: GSource; callback: GSourceFunc; 
                     user_data: gpointer): gboolean {.cdecl.}
    finalize*: proc (source: GSource) {.cdecl.}
    closure_callback*: GSourceFunc
    closure_marshal*: GSourceDummyMarshal

const 
  G_PRIORITY_HIGH* = - 100
const 
  G_PRIORITY_DEFAULT* = 0
const 
  G_PRIORITY_HIGH_IDLE* = 100
const 
  G_PRIORITY_DEFAULT_IDLE* = 200
const 
  G_PRIORITY_LOW* = 300
const 
  G_SOURCE_REMOVE* = GFALSE
const 
  G_SOURCE_CONTINUE* = GTRUE
proc g_main_context_new*(): GMainContext {.importc: "g_main_context_new", 
    libglib.}
proc `ref`*(context: GMainContext): GMainContext {.
    importc: "g_main_context_ref", libglib.}
proc unref*(context: GMainContext) {.
    importc: "g_main_context_unref", libglib.}
proc g_main_context_default*(): GMainContext {.
    importc: "g_main_context_default", libglib.}
proc iteration*(context: GMainContext; may_block: gboolean): gboolean {.
    importc: "g_main_context_iteration", libglib.}
proc pending*(context: GMainContext): gboolean {.
    importc: "g_main_context_pending", libglib.}
proc find_source_by_id*(context: GMainContext; 
    source_id: guint): GSource {.importc: "g_main_context_find_source_by_id", 
                                     libglib.}
proc find_source_by_user_data*(context: GMainContext; 
    user_data: gpointer): GSource {.
    importc: "g_main_context_find_source_by_user_data", libglib.}
proc find_source_by_funcs_user_data*(context: GMainContext; 
    funcs: GSourceFuncs; user_data: gpointer): GSource {.
    importc: "g_main_context_find_source_by_funcs_user_data", libglib.}
proc wakeup*(context: GMainContext) {.
    importc: "g_main_context_wakeup", libglib.}
proc acquire*(context: GMainContext): gboolean {.
    importc: "g_main_context_acquire", libglib.}
proc release*(context: GMainContext) {.
    importc: "g_main_context_release", libglib.}
proc is_owner*(context: GMainContext): gboolean {.
    importc: "g_main_context_is_owner", libglib.}
proc wait*(context: GMainContext; cond: GCond; 
                          mutex: GMutex): gboolean {.
    importc: "g_main_context_wait", libglib.}
proc prepare*(context: GMainContext; priority: ptr gint): gboolean {.
    importc: "g_main_context_prepare", libglib.}
proc query*(context: GMainContext; max_priority: gint; 
                           timeout: ptr gint; fds: GPollFD; n_fds: gint): gint {.
    importc: "g_main_context_query", libglib.}
proc check*(context: GMainContext; max_priority: gint; 
                           fds: GPollFD; n_fds: gint): gint {.
    importc: "g_main_context_check", libglib.}
proc dispatch*(context: GMainContext) {.
    importc: "g_main_context_dispatch", libglib.}
proc set_poll_func*(context: GMainContext; `func`: GPollFunc) {.
    importc: "g_main_context_set_poll_func", libglib.}
proc `poll_func=`*(context: GMainContext; `func`: GPollFunc) {.
    importc: "g_main_context_set_poll_func", libglib.}
proc get_poll_func*(context: GMainContext): GPollFunc {.
    importc: "g_main_context_get_poll_func", libglib.}
proc poll_func*(context: GMainContext): GPollFunc {.
    importc: "g_main_context_get_poll_func", libglib.}
proc add_poll*(context: GMainContext; fd: GPollFD; 
                              priority: gint) {.
    importc: "g_main_context_add_poll", libglib.}
proc remove_poll*(context: GMainContext; fd: GPollFD) {.
    importc: "g_main_context_remove_poll", libglib.}
proc g_main_depth*(): gint {.importc: "g_main_depth", libglib.}
proc g_main_current_source*(): GSource {.importc: "g_main_current_source", 
    libglib.}
proc push_thread_default*(context: GMainContext) {.
    importc: "g_main_context_push_thread_default", libglib.}
proc pop_thread_default*(context: GMainContext) {.
    importc: "g_main_context_pop_thread_default", libglib.}
proc g_main_context_get_thread_default*(): GMainContext {.
    importc: "g_main_context_get_thread_default", libglib.}
proc g_main_context_ref_thread_default*(): GMainContext {.
    importc: "g_main_context_ref_thread_default", libglib.}
proc g_main_loop_new*(context: GMainContext; is_running: gboolean): GMainLoop {.
    importc: "g_main_loop_new", libglib.}
proc run*(loop: GMainLoop) {.importc: "g_main_loop_run", 
    libglib.}
proc quit*(loop: GMainLoop) {.importc: "g_main_loop_quit", 
    libglib.}
proc `ref`*(loop: GMainLoop): GMainLoop {.
    importc: "g_main_loop_ref", libglib.}
proc unref*(loop: GMainLoop) {.importc: "g_main_loop_unref", 
    libglib.}
proc is_running*(loop: GMainLoop): gboolean {.
    importc: "g_main_loop_is_running", libglib.}
proc get_context*(loop: GMainLoop): GMainContext {.
    importc: "g_main_loop_get_context", libglib.}
proc context*(loop: GMainLoop): GMainContext {.
    importc: "g_main_loop_get_context", libglib.}
proc g_source_new*(source_funcs: GSourceFuncs; struct_size: guint): GSource {.
    importc: "g_source_new", libglib.}
proc `ref`*(source: GSource): GSource {.
    importc: "g_source_ref", libglib.}
proc unref*(source: GSource) {.importc: "g_source_unref", 
    libglib.}
proc attach*(source: GSource; context: GMainContext): guint {.
    importc: "g_source_attach", libglib.}
proc destroy*(source: GSource) {.importc: "g_source_destroy", 
    libglib.}
proc set_priority*(source: GSource; priority: gint) {.
    importc: "g_source_set_priority", libglib.}
proc `priority=`*(source: GSource; priority: gint) {.
    importc: "g_source_set_priority", libglib.}
proc get_priority*(source: GSource): gint {.
    importc: "g_source_get_priority", libglib.}
proc priority*(source: GSource): gint {.
    importc: "g_source_get_priority", libglib.}
proc set_can_recurse*(source: GSource; can_recurse: gboolean) {.
    importc: "g_source_set_can_recurse", libglib.}
proc `can_recurse=`*(source: GSource; can_recurse: gboolean) {.
    importc: "g_source_set_can_recurse", libglib.}
proc get_can_recurse*(source: GSource): gboolean {.
    importc: "g_source_get_can_recurse", libglib.}
proc can_recurse*(source: GSource): gboolean {.
    importc: "g_source_get_can_recurse", libglib.}
proc get_id*(source: GSource): guint {.
    importc: "g_source_get_id", libglib.}
proc id*(source: GSource): guint {.
    importc: "g_source_get_id", libglib.}
proc get_context*(source: GSource): GMainContext {.
    importc: "g_source_get_context", libglib.}
proc context*(source: GSource): GMainContext {.
    importc: "g_source_get_context", libglib.}
proc set_callback*(source: GSource; `func`: GSourceFunc; 
                            data: gpointer; notify: GDestroyNotify) {.
    importc: "g_source_set_callback", libglib.}
proc `callback=`*(source: GSource; `func`: GSourceFunc; 
                            data: gpointer; notify: GDestroyNotify) {.
    importc: "g_source_set_callback", libglib.}
proc set_funcs*(source: GSource; funcs: GSourceFuncs) {.
    importc: "g_source_set_funcs", libglib.}
proc `funcs=`*(source: GSource; funcs: GSourceFuncs) {.
    importc: "g_source_set_funcs", libglib.}
proc is_destroyed*(source: GSource): gboolean {.
    importc: "g_source_is_destroyed", libglib.}
proc set_name*(source: GSource; name: cstring) {.
    importc: "g_source_set_name", libglib.}
proc `name=`*(source: GSource; name: cstring) {.
    importc: "g_source_set_name", libglib.}
proc get_name*(source: GSource): cstring {.
    importc: "g_source_get_name", libglib.}
proc name*(source: GSource): cstring {.
    importc: "g_source_get_name", libglib.}
proc g_source_set_name_by_id*(tag: guint; name: cstring) {.
    importc: "g_source_set_name_by_id", libglib.}
proc set_ready_time*(source: GSource; ready_time: gint64) {.
    importc: "g_source_set_ready_time", libglib.}
proc `ready_time=`*(source: GSource; ready_time: gint64) {.
    importc: "g_source_set_ready_time", libglib.}
proc get_ready_time*(source: GSource): gint64 {.
    importc: "g_source_get_ready_time", libglib.}
proc ready_time*(source: GSource): gint64 {.
    importc: "g_source_get_ready_time", libglib.}
when defined(unix): 
  proc add_unix_fd*(source: GSource; fd: gint; 
                             events: GIOCondition): gpointer {.
      importc: "g_source_add_unix_fd", libglib.}
  proc modify_unix_fd*(source: GSource; tag: gpointer; 
                                new_events: GIOCondition) {.
      importc: "g_source_modify_unix_fd", libglib.}
  proc remove_unix_fd*(source: GSource; tag: gpointer) {.
      importc: "g_source_remove_unix_fd", libglib.}
  proc query_unix_fd*(source: GSource; tag: gpointer): GIOCondition {.
      importc: "g_source_query_unix_fd", libglib.}
proc set_callback_indirect*(source: GSource; 
                                     callback_data: gpointer; 
                                     callback_funcs: GSourceCallbackFuncs) {.
    importc: "g_source_set_callback_indirect", libglib.}
proc `callback_indirect=`*(source: GSource; 
                                     callback_data: gpointer; 
                                     callback_funcs: GSourceCallbackFuncs) {.
    importc: "g_source_set_callback_indirect", libglib.}
proc add_poll*(source: GSource; fd: GPollFD) {.
    importc: "g_source_add_poll", libglib.}
proc remove_poll*(source: GSource; fd: GPollFD) {.
    importc: "g_source_remove_poll", libglib.}
proc add_child_source*(source: GSource; child_source: GSource) {.
    importc: "g_source_add_child_source", libglib.}
proc remove_child_source*(source: GSource; 
                                   child_source: GSource) {.
    importc: "g_source_remove_child_source", libglib.}
proc get_current_time*(source: GSource; timeval: var GTimeValObj) {.
    importc: "g_source_get_current_time", libglib.}
proc get_time*(source: GSource): gint64 {.
    importc: "g_source_get_time", libglib.}
proc time*(source: GSource): gint64 {.
    importc: "g_source_get_time", libglib.}
proc g_idle_source_new*(): GSource {.importc: "g_idle_source_new", 
    libglib.}
proc g_child_watch_source_new*(pid: GPid): GSource {.
    importc: "g_child_watch_source_new", libglib.}
proc g_timeout_source_new*(interval: guint): GSource {.
    importc: "g_timeout_source_new", libglib.}
proc g_timeout_source_new_seconds*(interval: guint): GSource {.
    importc: "g_timeout_source_new_seconds", libglib.}
proc g_get_current_time*(result: GTimeVal) {.
    importc: "g_get_current_time", libglib.}
proc g_get_monotonic_time*(): gint64 {.importc: "g_get_monotonic_time", 
    libglib.}
proc g_get_real_time*(): gint64 {.importc: "g_get_real_time", libglib.}
proc g_source_remove*(tag: guint): gboolean {.importc: "g_source_remove", 
    libglib.}
proc g_source_remove_by_user_data*(user_data: gpointer): gboolean {.
    importc: "g_source_remove_by_user_data", libglib.}
proc g_source_remove_by_funcs_user_data*(funcs: GSourceFuncs; 
    user_data: gpointer): gboolean {.importc: "g_source_remove_by_funcs_user_data", 
                                     libglib.}
proc g_timeout_add_full*(priority: gint; interval: guint; 
                         function: GSourceFunc; data: gpointer; 
                         notify: GDestroyNotify): guint {.
    importc: "g_timeout_add_full", libglib.}
proc g_timeout_add*(interval: guint; function: GSourceFunc; data: gpointer): guint {.
    importc: "g_timeout_add", libglib.}
proc g_timeout_add_seconds_full*(priority: gint; interval: guint; 
                                 function: GSourceFunc; data: gpointer; 
                                 notify: GDestroyNotify): guint {.
    importc: "g_timeout_add_seconds_full", libglib.}
proc g_timeout_add_seconds*(interval: guint; function: GSourceFunc; 
                            data: gpointer): guint {.
    importc: "g_timeout_add_seconds", libglib.}
proc g_child_watch_add_full*(priority: gint; pid: GPid; 
                             function: GChildWatchFunc; data: gpointer; 
                             notify: GDestroyNotify): guint {.
    importc: "g_child_watch_add_full", libglib.}
proc g_child_watch_add*(pid: GPid; function: GChildWatchFunc; data: gpointer): guint {.
    importc: "g_child_watch_add", libglib.}
proc g_idle_add*(function: GSourceFunc; data: gpointer): guint {.
    importc: "g_idle_add", libglib.}
proc g_idle_add_full*(priority: gint; function: GSourceFunc; data: gpointer; 
                      notify: GDestroyNotify): guint {.
    importc: "g_idle_add_full", libglib.}
proc g_idle_remove_by_data*(data: gpointer): gboolean {.
    importc: "g_idle_remove_by_data", libglib.}
proc invoke_full*(context: GMainContext; priority: gint; 
                                 function: GSourceFunc; data: gpointer; 
                                 notify: GDestroyNotify) {.
    importc: "g_main_context_invoke_full", libglib.}
proc invoke*(context: GMainContext; function: GSourceFunc; 
                            data: gpointer) {.
    importc: "g_main_context_invoke", libglib.}

type 
  gunichar* = guint32
type 
  gunichar2* = guint16
type 
  GUnicodeType* {.size: sizeof(cint), pure.} = enum 
    CONTROL, FORMAT, UNASSIGNED, 
    PRIVATE_USE, SURROGATE, LOWERCASE_LETTER, 
    MODIFIER_LETTER, OTHER_LETTER, 
    TITLECASE_LETTER, UPPERCASE_LETTER, 
    SPACING_MARK, ENCLOSING_MARK, 
    NON_SPACING_MARK, DECIMAL_NUMBER, 
    LETTER_NUMBER, OTHER_NUMBER, 
    CONNECT_PUNCTUATION, DASH_PUNCTUATION, 
    CLOSE_PUNCTUATION, FINAL_PUNCTUATION, 
    INITIAL_PUNCTUATION, OTHER_PUNCTUATION, 
    OPEN_PUNCTUATION, CURRENCY_SYMBOL, 
    MODIFIER_SYMBOL, MATH_SYMBOL, OTHER_SYMBOL, 
    LINE_SEPARATOR, PARAGRAPH_SEPARATOR, 
    SPACE_SEPARATOR
when not(defined(G_DISABLE_DEPRECATED)): 
  const 
    G_UNICODE_COMBINING_MARK* = GUnicodeType.SPACING_MARK
type 
  GUnicodeBreakType* {.size: sizeof(cint), pure.} = enum 
    MANDATORY, CARRIAGE_RETURN, 
    LINE_FEED, COMBINING_MARK, 
    SURROGATE, ZERO_WIDTH_SPACE, 
    INSEPARABLE, NON_BREAKING_GLUE, 
    CONTINGENT, SPACE, AFTER, 
    BEFORE, BEFORE_AND_AFTER, 
    HYPHEN, NON_STARTER, 
    OPEN_PUNCTUATION, CLOSE_PUNCTUATION, 
    QUOTATION, EXCLAMATION, 
    IDEOGRAPHIC, NUMERIC, 
    INFIX_SEPARATOR, SYMBOL, 
    ALPHABETIC, PREFIX, 
    POSTFIX, COMPLEX_CONTEXT, 
    AMBIGUOUS, UNKNOWN, 
    NEXT_LINE, WORD_JOINER, 
    HANGUL_L_JAMO, HANGUL_V_JAMO, 
    HANGUL_T_JAMO, HANGUL_LV_SYLLABLE, 
    HANGUL_LVT_SYLLABLE, CLOSE_PARANTHESIS, 
    CONDITIONAL_JAPANESE_STARTER, 
    HEBREW_LETTER, REGIONAL_INDICATOR
type 
  GUnicodeScript* {.size: sizeof(cint), pure.} = enum 
    INVALID_CODE = - 1, COMMON = 0, 
    INHERITED, ARABIC, 
    ARMENIAN, BENGALI, 
    BOPOMOFO, CHEROKEE, 
    COPTIC, CYRILLIC, 
    DESERET, DEVANAGARI, 
    ETHIOPIC, GEORGIAN, 
    GOTHIC, GREEK, 
    GUJARATI, GURMUKHI, 
    HAN, HANGUL, HEBREW, 
    HIRAGANA, KANNADA, 
    KATAKANA, KHMER, LAO, 
    LATIN, MALAYALAM, 
    MONGOLIAN, MYANMAR, 
    OGHAM, OLD_ITALIC, 
    ORIYA, RUNIC, SINHALA, 
    SYRIAC, TAMIL, TELUGU, 
    THAANA, THAI, TIBETAN, 
    CANADIAN_ABORIGINAL, YI, 
    TAGALOG, HANUNOO, 
    BUHID, TAGBANWA, 
    BRAILLE, CYPRIOT, 
    LIMBU, OSMANYA, 
    SHAVIAN, LINEAR_B, 
    TAI_LE, UGARITIC, 
    NEW_TAI_LUE, BUGINESE, 
    GLAGOLITIC, TIFINAGH, 
    SYLOTI_NAGRI, OLD_PERSIAN, 
    KHAROSHTHI, UNKNOWN, 
    BALINESE, CUNEIFORM, 
    PHOENICIAN, PHAGS_PA, 
    NKO, KAYAH_LI, LEPCHA, 
    REJANG, SUNDANESE, 
    SAURASHTRA, CHAM, 
    OL_CHIKI, VAI, CARIAN, 
    LYCIAN, LYDIAN, 
    AVESTAN, BAMUM, 
    EGYPTIAN_HIEROGLYPHS, IMPERIAL_ARAMAIC, 
    INSCRIPTIONAL_PAHLAVI, 
    INSCRIPTIONAL_PARTHIAN, JAVANESE, 
    KAITHI, LISU, 
    MEETEI_MAYEK, OLD_SOUTH_ARABIAN, 
    OLD_TURKIC, SAMARITAN, 
    TAI_THAM, TAI_VIET, 
    BATAK, BRAHMI, MANDAIC, 
    CHAKMA, MEROITIC_CURSIVE, 
    MEROITIC_HIEROGLYPHS, MIAO, 
    SHARADA, SORA_SOMPENG, 
    TAKRI, BASSA_VAH, 
    CAUCASIAN_ALBANIAN, DUPLOYAN, 
    ELBASAN, GRANTHA, 
    KHOJKI, KHUDAWADI, 
    LINEAR_A, MAHAJANI, 
    MANICHAEAN, MENDE_KIKAKUI, 
    MODI, MRO, NABATAEAN, 
    OLD_NORTH_ARABIAN, OLD_PERMIC, 
    PAHAWH_HMONG, PALMYRENE, 
    PAU_CIN_HAU, PSALTER_PAHLAVI, 
    SIDDHAM, TIRHUTA, 
    WARANG_CITI
proc to_iso15924*(script: GUnicodeScript): guint32 {.
    importc: "g_unicode_script_to_iso15924", libglib.}
proc g_unicode_script_from_iso15924*(iso15924: guint32): GUnicodeScript {.
    importc: "g_unicode_script_from_iso15924", libglib.}
proc isalnum*(c: gunichar): gboolean {.importc: "g_unichar_isalnum", 
    libglib.}
proc isalpha*(c: gunichar): gboolean {.importc: "g_unichar_isalpha", 
    libglib.}
proc iscntrl*(c: gunichar): gboolean {.importc: "g_unichar_iscntrl", 
    libglib.}
proc isdigit*(c: gunichar): gboolean {.importc: "g_unichar_isdigit", 
    libglib.}
proc isgraph*(c: gunichar): gboolean {.importc: "g_unichar_isgraph", 
    libglib.}
proc islower*(c: gunichar): gboolean {.importc: "g_unichar_islower", 
    libglib.}
proc isprint*(c: gunichar): gboolean {.importc: "g_unichar_isprint", 
    libglib.}
proc ispunct*(c: gunichar): gboolean {.importc: "g_unichar_ispunct", 
    libglib.}
proc isspace*(c: gunichar): gboolean {.importc: "g_unichar_isspace", 
    libglib.}
proc isupper*(c: gunichar): gboolean {.importc: "g_unichar_isupper", 
    libglib.}
proc isxdigit*(c: gunichar): gboolean {.
    importc: "g_unichar_isxdigit", libglib.}
proc istitle*(c: gunichar): gboolean {.importc: "g_unichar_istitle", 
    libglib.}
proc isdefined*(c: gunichar): gboolean {.
    importc: "g_unichar_isdefined", libglib.}
proc iswide*(c: gunichar): gboolean {.importc: "g_unichar_iswide", 
    libglib.}
proc iswide_cjk*(c: gunichar): gboolean {.
    importc: "g_unichar_iswide_cjk", libglib.}
proc iszerowidth*(c: gunichar): gboolean {.
    importc: "g_unichar_iszerowidth", libglib.}
proc ismark*(c: gunichar): gboolean {.importc: "g_unichar_ismark", 
    libglib.}
proc toupper*(c: gunichar): gunichar {.importc: "g_unichar_toupper", 
    libglib.}
proc tolower*(c: gunichar): gunichar {.importc: "g_unichar_tolower", 
    libglib.}
proc totitle*(c: gunichar): gunichar {.importc: "g_unichar_totitle", 
    libglib.}
proc digit_value*(c: gunichar): gint {.
    importc: "g_unichar_digit_value", libglib.}
proc xdigit_value*(c: gunichar): gint {.
    importc: "g_unichar_xdigit_value", libglib.}
proc `type`*(c: gunichar): GUnicodeType {.importc: "g_unichar_type", 
    libglib.}
proc break_type*(c: gunichar): GUnicodeBreakType {.
    importc: "g_unichar_break_type", libglib.}
proc combining_class*(uc: gunichar): gint {.
    importc: "g_unichar_combining_class", libglib.}
proc get_mirror_char*(ch: gunichar; mirrored_ch: ptr gunichar): gboolean {.
    importc: "g_unichar_get_mirror_char", libglib.}
proc mirror_char*(ch: gunichar; mirrored_ch: ptr gunichar): gboolean {.
    importc: "g_unichar_get_mirror_char", libglib.}
proc get_script*(ch: gunichar): GUnicodeScript {.
    importc: "g_unichar_get_script", libglib.}
proc script*(ch: gunichar): GUnicodeScript {.
    importc: "g_unichar_get_script", libglib.}
proc validate*(ch: gunichar): gboolean {.
    importc: "g_unichar_validate", libglib.}
proc compose*(a: gunichar; b: gunichar; ch: ptr gunichar): gboolean {.
    importc: "g_unichar_compose", libglib.}
proc decompose*(ch: gunichar; a: ptr gunichar; b: ptr gunichar): gboolean {.
    importc: "g_unichar_decompose", libglib.}
proc fully_decompose*(ch: gunichar; compat: gboolean; 
                                result: ptr gunichar; result_len: gsize): gsize {.
    importc: "g_unichar_fully_decompose", libglib.}
const 
  G_UNICHAR_MAX_DECOMPOSITION_LENGTH* = 18
proc g_unicode_canonical_ordering*(string: ptr gunichar; len: gsize) {.
    importc: "g_unicode_canonical_ordering", libglib.}
proc g_unicode_canonical_decomposition*(ch: gunichar; result_len: var gsize): ptr gunichar {.
    importc: "g_unicode_canonical_decomposition", libglib.}
template g_utf8_next_char*(p: expr): expr = 
  cast[cstring]((p + g_utf8_skip[cast[ptr guchar](p)[]]))

proc g_utf8_get_char*(p: cstring): gunichar {.importc: "g_utf8_get_char", 
    libglib.}
proc g_utf8_get_char_validated*(p: cstring; max_len: gssize): gunichar {.
    importc: "g_utf8_get_char_validated", libglib.}
proc g_utf8_offset_to_pointer*(str: cstring; offset: glong): cstring {.
    importc: "g_utf8_offset_to_pointer", libglib.}
proc g_utf8_pointer_to_offset*(str: cstring; pos: cstring): glong {.
    importc: "g_utf8_pointer_to_offset", libglib.}
proc g_utf8_prev_char*(p: cstring): cstring {.importc: "g_utf8_prev_char", 
    libglib.}
proc g_utf8_find_next_char*(p: cstring; `end`: cstring): cstring {.
    importc: "g_utf8_find_next_char", libglib.}
proc g_utf8_find_prev_char*(str: cstring; p: cstring): cstring {.
    importc: "g_utf8_find_prev_char", libglib.}
proc g_utf8_strlen*(p: cstring; max: gssize): glong {.
    importc: "g_utf8_strlen", libglib.}
proc g_utf8_substring*(str: cstring; start_pos: glong; end_pos: glong): cstring {.
    importc: "g_utf8_substring", libglib.}
proc g_utf8_strncpy*(dest: cstring; src: cstring; n: gsize): cstring {.
    importc: "g_utf8_strncpy", libglib.}
proc g_utf8_strchr*(p: cstring; len: gssize; c: gunichar): cstring {.
    importc: "g_utf8_strchr", libglib.}
proc g_utf8_strrchr*(p: cstring; len: gssize; c: gunichar): cstring {.
    importc: "g_utf8_strrchr", libglib.}
proc g_utf8_strreverse*(str: cstring; len: gssize): cstring {.
    importc: "g_utf8_strreverse", libglib.}
proc g_utf8_to_utf16*(str: cstring; len: glong; items_read: var glong; 
                      items_written: var glong; error: var GError): ptr gunichar2 {.
    importc: "g_utf8_to_utf16", libglib.}
proc g_utf8_to_ucs4*(str: cstring; len: glong; items_read: var glong; 
                     items_written: var glong; error: var GError): ptr gunichar {.
    importc: "g_utf8_to_ucs4", libglib.}
proc g_utf8_to_ucs4_fast*(str: cstring; len: glong; items_written: var glong): ptr gunichar {.
    importc: "g_utf8_to_ucs4_fast", libglib.}
proc g_utf16_to_ucs4*(str: ptr gunichar2; len: glong; items_read: var glong; 
                      items_written: var glong; error: var GError): ptr gunichar {.
    importc: "g_utf16_to_ucs4", libglib.}
proc g_utf16_to_utf8*(str: ptr gunichar2; len: glong; items_read: var glong; 
                      items_written: var glong; error: var GError): cstring {.
    importc: "g_utf16_to_utf8", libglib.}
proc g_ucs4_to_utf16*(str: ptr gunichar; len: glong; items_read: var glong; 
                      items_written: var glong; error: var GError): ptr gunichar2 {.
    importc: "g_ucs4_to_utf16", libglib.}
proc g_ucs4_to_utf8*(str: ptr gunichar; len: glong; items_read: var glong; 
                     items_written: var glong; error: var GError): cstring {.
    importc: "g_ucs4_to_utf8", libglib.}
proc to_utf8*(c: gunichar; outbuf: cstring): gint {.
    importc: "g_unichar_to_utf8", libglib.}
proc g_utf8_validate*(str: cstring; max_len: gssize; `end`: cstringArray): gboolean {.
    importc: "g_utf8_validate", libglib.}
proc g_utf8_strup*(str: cstring; len: gssize): cstring {.
    importc: "g_utf8_strup", libglib.}
proc g_utf8_strdown*(str: cstring; len: gssize): cstring {.
    importc: "g_utf8_strdown", libglib.}
proc g_utf8_casefold*(str: cstring; len: gssize): cstring {.
    importc: "g_utf8_casefold", libglib.}
type 
  GNormalizeMode* {.size: sizeof(cint), pure.} = enum 
    DEFAULT, 
    DEFAULT_COMPOSE, 
    ALL, 
    ALL_COMPOSE
const
  G_NORMALIZE_NFD = GNormalizeMode.DEFAULT
  G_NORMALIZE_NFC = GNormalizeMode.DEFAULT_COMPOSE
  G_NORMALIZE_NFKD = GNormalizeMode.ALL
  G_NORMALIZE_NFKC = GNormalizeMode.ALL_COMPOSE
proc g_utf8_normalize*(str: cstring; len: gssize; mode: GNormalizeMode): cstring {.
    importc: "g_utf8_normalize", libglib.}
proc g_utf8_collate*(str1: cstring; str2: cstring): gint {.
    importc: "g_utf8_collate", libglib.}
proc g_utf8_collate_key*(str: cstring; len: gssize): cstring {.
    importc: "g_utf8_collate_key", libglib.}
proc g_utf8_collate_key_for_filename*(str: cstring; len: gssize): cstring {.
    importc: "g_utf8_collate_key_for_filename", libglib.}
proc g_utf8_make_valid(name: cstring): cstring {.
    importc: "_g_utf8_make_valid", libglib.}

when false: # when not defined(g_va_copy): 
  when false and # when defined(GNUC) and defined(PPC) and
      false: # (defined(CALL_SYSV) or defined(WIN32)): 
    template g_va_copy*(ap1, ap2: expr): expr = 
      (ap1[] = ap2[])

  elif defined(G_VA_COPY_AS_ARRAY): 
    template g_va_copy*(ap1, ap2: expr): expr = 
      memmove(ap1, ap2, sizeof(va_list))

  else: 
    template g_va_copy*(ap1, ap2: expr): expr = 
      (ap1 = ap2)

proc g_get_user_name*(): cstring {.importc: "g_get_user_name", libglib.}
proc g_get_real_name*(): cstring {.importc: "g_get_real_name", libglib.}
proc g_get_home_dir*(): cstring {.importc: "g_get_home_dir", libglib.}
proc g_get_tmp_dir*(): cstring {.importc: "g_get_tmp_dir", libglib.}
proc g_get_host_name*(): cstring {.importc: "g_get_host_name", libglib.}
proc g_get_prgname*(): cstring {.importc: "g_get_prgname", libglib.}
proc g_set_prgname*(prgname: cstring) {.importc: "g_set_prgname", 
    libglib.}
proc g_get_application_name*(): cstring {.importc: "g_get_application_name", 
    libglib.}
proc g_set_application_name*(application_name: cstring) {.
    importc: "g_set_application_name", libglib.}
proc g_reload_user_special_dirs_cache*() {.
    importc: "g_reload_user_special_dirs_cache", libglib.}
proc g_get_user_data_dir*(): cstring {.importc: "g_get_user_data_dir", 
    libglib.}
proc g_get_user_config_dir*(): cstring {.importc: "g_get_user_config_dir", 
    libglib.}
proc g_get_user_cache_dir*(): cstring {.importc: "g_get_user_cache_dir", 
    libglib.}
proc g_get_system_data_dirs*(): cstringArray {.
    importc: "g_get_system_data_dirs", libglib.}
when defined(windows): 
  proc g_win32_get_system_data_dirs_for_module*(address_of_function: proc () {.cdecl.}): cstringArray {.
      importc: "g_win32_get_system_data_dirs_for_module", libglib.}
when defined(windows) and false and # and defined(G_CAN_INLINE) and
    true: # not defined(cplusplus): 
  proc g_win32_get_system_data_dirs(): cstringArray {.inline.} = 
    return g_win32_get_system_data_dirs_for_module(
        cast[proc ()](addr(g_win32_get_system_data_dirs)))

  const 
    g_get_system_data_dirs* = g_win32_get_system_data_dirs
proc g_get_system_config_dirs*(): cstringArray {.
    importc: "g_get_system_config_dirs", libglib.}
proc g_get_user_runtime_dir*(): cstring {.importc: "g_get_user_runtime_dir", 
    libglib.}
type 
  GUserDirectory* {.size: sizeof(cint), pure.} = enum 
    DESKTOP, DOCUMENTS, 
    DOWNLOAD, MUSIC, 
    PICTURES, PUBLIC_SHARE, 
    TEMPLATES, VIDEOS, G_USER_N_DIRECTORIES
proc g_get_user_special_dir*(directory: GUserDirectory): cstring {.
    importc: "g_get_user_special_dir", libglib.}
type 
  GDebugKey* =  ptr GDebugKeyObj
  GDebugKeyPtr* = ptr GDebugKeyObj
  GDebugKeyObj* = object 
    key*: cstring
    value*: guint

proc g_parse_debug_string*(string: cstring; keys: GDebugKey; 
                           nkeys: guint): guint {.
    importc: "g_parse_debug_string", libglib.}
proc g_snprintf*(string: cstring; n: gulong; format: cstring): gint {.
    varargs, importc: "g_snprintf", libglib.}
when Va_List_Works:
  proc g_vsnprintf*(string: cstring; n: gulong; format: cstring; 
                    args: va_list): gint {.importc: "g_vsnprintf", libglib.}
proc g_nullify_pointer*(nullify_location: ptr gpointer) {.
    importc: "g_nullify_pointer", libglib.}
type 
  GFormatSizeFlags* {.size: sizeof(cint), pure.} = enum 
    DEFAULT = 0, LONG_FORMAT = 1 shl 0, 
    IEC_UNITS = 1 shl 1
proc g_format_size_full*(size: guint64; flags: GFormatSizeFlags): cstring {.
    importc: "g_format_size_full", libglib.}
proc g_format_size*(size: guint64): cstring {.importc: "g_format_size", 
    libglib.}
proc g_format_size_for_display*(size: goffset): cstring {.
    importc: "g_format_size_for_display", libglib.}
when not(defined(G_DISABLE_DEPRECATED)): 
  type 
    GVoidFunc* = proc () {.cdecl.}
  template atexit*(`proc`: expr): expr = 
    g_ATEXIT(proc)

  proc g_atexit*(`func`: GVoidFunc) {.importc: "g_atexit", libglib.}
  when defined(windows): 
    when false or # when (defined(MINGW_H) and not defined(STDLIB_H)) or
        false: # (defined(MSC_VER) and not defined(INC_STDLIB)): 
      proc atexit*(a2: proc () {.cdecl.}): cint {.importc: "atexit", libglib.}
    template g_atexit*(`func`: expr): expr = 
      atexit(`func`)

proc g_find_program_in_path*(program: cstring): cstring {.
    importc: "g_find_program_in_path", libglib.}
proc g_bit_nth_lsf*(mask: gulong; nth_bit: gint): gint {.
    importc: "g_bit_nth_lsf", libglib.}
proc g_bit_nth_msf*(mask: gulong; nth_bit: gint): gint {.
    importc: "g_bit_nth_msf", libglib.}
proc g_bit_storage*(number: gulong): guint {.importc: "g_bit_storage", 
    libglib.}
when false: # when defined(G_CAN_INLINE) or defined(G_UTILS_C): 
  proc g_bit_nth_lsf*(mask: gulong; nth_bit: gint): gint = 
    if (nth_bit < - 1): nth_bit = - 1
    while nth_bit < ((GLIB_SIZEOF_LONG * 8) - 1): 
      inc(nth_bit)
      if mask and (1 shl nth_bit): return nth_bit
    return - 1

  proc g_bit_nth_msf*(mask: gulong; nth_bit: gint): gint = 
    if nth_bit < 0 or (nth_bit > GLIB_SIZEOF_LONG * 8): 
      nth_bit = GLIB_SIZEOF_LONG * 8
    while nth_bit > 0: 
      dec(nth_bit)
      if mask and (1 shl nth_bit): return nth_bit
    return - 1

  proc g_bit_storage*(number: gulong): guint = 
    when false: # when defined(GNUC) and (GNUC >= 4) and defined(OPTIMIZE): 
      return if (number): ((GLIB_SIZEOF_LONG * 8 - 1) xor
          cast[guint](builtin_clzl(number))) + 1 else: 1
    else: 
      var n_bits: guint = 0
      while true: 
        inc(n_bits)
        number = number shr 1
        if not number: break 
      return n_bits

type 
  GString* =  ptr GStringObj
  GStringPtr* = ptr GStringObj
  GStringObj* = object 
    str*: cstring
    len*: gsize
    allocated_len*: gsize

proc g_string_new*(init: cstring): GString {.importc: "g_string_new", 
    libglib.}
proc g_string_new_len*(init: cstring; len: gssize): GString {.
    importc: "g_string_new_len", libglib.}
proc g_string_sized_new*(dfl_size: gsize): GString {.
    importc: "g_string_sized_new", libglib.}
proc free*(string: GString; free_segment: gboolean): cstring {.
    importc: "g_string_free", libglib.}
proc free_to_bytes*(string: GString): GBytes {.
    importc: "g_string_free_to_bytes", libglib.}
proc equal*(v: GString; v2: GString): gboolean {.
    importc: "g_string_equal", libglib.}
proc hash*(str: GString): guint {.importc: "g_string_hash", 
    libglib.}
proc assign*(string: GString; rval: cstring): GString {.
    importc: "g_string_assign", libglib.}
proc truncate*(string: GString; len: gsize): GString {.
    importc: "g_string_truncate", libglib.}
proc set_size*(string: GString; len: gsize): GString {.
    importc: "g_string_set_size", libglib.}
proc insert_len*(string: GString; pos: gssize; val: cstring; 
                          len: gssize): GString {.
    importc: "g_string_insert_len", libglib.}
proc append*(string: GString; val: cstring): GString {.
    importc: "g_string_append", libglib.}
proc append_len*(string: GString; val: cstring; len: gssize): GString {.
    importc: "g_string_append_len", libglib.}
proc append_c*(string: GString; c: gchar): GString {.
    importc: "g_string_append_c", libglib.}
proc append_unichar*(string: GString; wc: gunichar): GString {.
    importc: "g_string_append_unichar", libglib.}
proc prepend*(string: GString; val: cstring): GString {.
    importc: "g_string_prepend", libglib.}
proc prepend_c*(string: GString; c: gchar): GString {.
    importc: "g_string_prepend_c", libglib.}
proc prepend_unichar*(string: GString; wc: gunichar): GString {.
    importc: "g_string_prepend_unichar", libglib.}
proc prepend_len*(string: GString; val: cstring; len: gssize): GString {.
    importc: "g_string_prepend_len", libglib.}
proc insert*(string: GString; pos: gssize; val: cstring): GString {.
    importc: "g_string_insert", libglib.}
proc insert_c*(string: GString; pos: gssize; c: gchar): GString {.
    importc: "g_string_insert_c", libglib.}
proc insert_unichar*(string: GString; pos: gssize; wc: gunichar): GString {.
    importc: "g_string_insert_unichar", libglib.}
proc overwrite*(string: GString; pos: gsize; val: cstring): GString {.
    importc: "g_string_overwrite", libglib.}
proc overwrite_len*(string: GString; pos: gsize; val: cstring; 
                             len: gssize): GString {.
    importc: "g_string_overwrite_len", libglib.}
proc erase*(string: GString; pos: gssize; len: gssize): GString {.
    importc: "g_string_erase", libglib.}
proc ascii_down*(string: GString): GString {.
    importc: "g_string_ascii_down", libglib.}
proc ascii_up*(string: GString): GString {.
    importc: "g_string_ascii_up", libglib.}
when Va_List_Works:
  proc vprintf*(string: GString; format: cstring; args: va_list) {.
      importc: "g_string_vprintf", libglib.}
proc printf*(string: GString; format: cstring) {.varargs, 
    importc: "g_string_printf", libglib.}
when Va_List_Works:
  proc append_vprintf*(string: GString; format: cstring; 
                                args: va_list) {.
      importc: "g_string_append_vprintf", libglib.}
proc append_printf*(string: GString; format: cstring) {.
    varargs, importc: "g_string_append_printf", libglib.}
proc append_uri_escaped*(string: GString; unescaped: cstring; 
                                  reserved_chars_allowed: cstring; 
                                  allow_utf8: gboolean): GString {.
    importc: "g_string_append_uri_escaped", libglib.}
when false: # when defined(G_CAN_INLINE): 
  proc append_c_inline*(gstring: GString; c: gchar): GString {.
      inline.} = 
    if gstring.len + 1 < gstring.allocated_len: 
      gstring.str[inc(gstring.len)] = c
      gstring.str[gstring.len] = 0
    else: 
      g_string_insert_c(gstring, - 1, c)
    return gstring

  template g_string_append_c*(gstr, c: expr): expr = 
    g_string_append_c_inline(gstr, c)

proc down*(string: GString): GString {.
    importc: "g_string_down", libglib.}
proc up*(string: GString): GString {.importc: "g_string_up", 
    libglib.}
when not(defined(G_DISABLE_DEPRECATED)): 
  const 
    g_string_sprintf* = printf
    g_string_sprintfa* = append_printf

type 
  GIOError* {.size: sizeof(cint), pure.} = enum 
    NONE, AGAIN, INVAL, UNKNOWN
  GIOChannelError* {.size: sizeof(cint), pure.} = enum 
    FBIG, INVAL, IO, 
    ISDIR, NOSPC, 
    NXIO, OVERFLOW, 
    PIPE, FAILED
  GIOStatus* {.size: sizeof(cint), pure.} = enum 
    ERROR, NORMAL, EOF, AGAIN
  GSeekType* {.size: sizeof(cint), pure.} = enum 
    CUR, SET, `END`
  GIOFlags* {.size: sizeof(cint), pure.} = enum 
    APPEND = 1 shl 0, NONBLOCK = 1 shl 1, 
    SET_MASK = GIOFlags.APPEND.ord or GIOFlags.NONBLOCK.ord,
    IS_READABLE = 1 shl 2, IS_WRITABLE = 1 shl 3, 
    IS_SEEKABLE = 1 shl 4, 
    MASK = (1 shl 5) - 1
const
  G_IO_FLAGS_GET_MASK = GIOFlags.MASK
type 
  GIOChannel* =  ptr GIOChannelObj
  GIOChannelPtr* = ptr GIOChannelObj
  GIOChannelObj* = object 
    ref_count*: gint
    funcs*: GIOFuncs
    encoding*: cstring
    read_cd*: GIConv
    write_cd*: GIConv
    line_term*: cstring
    line_term_len*: guint
    buf_size*: gsize
    read_buf*: GString
    encoded_read_buf*: GString
    write_buf*: GString
    partial_write_buf*: array[6, gchar]
    bitfield0GIOChannel*: guint
    reserved1: gpointer
    reserved2: gpointer

  GIOFunc* = proc (source: GIOChannel; condition: GIOCondition; 
                   data: gpointer): gboolean {.cdecl.}
  GIOFuncs* =  ptr GIOFuncsObj
  GIOFuncsPtr* = ptr GIOFuncsObj
  GIOFuncsObj* = object 
    io_read*: proc (channel: GIOChannel; buf: cstring; count: gsize; 
                    bytes_read: var gsize; err: var GError): GIOStatus {.cdecl.}
    io_write*: proc (channel: GIOChannel; buf: cstring; count: gsize; 
                     bytes_written: var gsize; err: var GError): GIOStatus {.cdecl.}
    io_seek*: proc (channel: GIOChannel; offset: gint64; `type`: GSeekType; 
                    err: var GError): GIOStatus {.cdecl.}
    io_close*: proc (channel: GIOChannel; err: var GError): GIOStatus {.cdecl.}
    io_create_watch*: proc (channel: GIOChannel; condition: GIOCondition): GSource {.cdecl.}
    io_free*: proc (channel: GIOChannel) {.cdecl.}
    io_set_flags*: proc (channel: GIOChannel; flags: GIOFlags; 
                         err: var GError): GIOStatus {.cdecl.}
    io_get_flags*: proc (channel: GIOChannel): GIOFlags {.cdecl.}

proc init*(channel: GIOChannel) {.
    importc: "g_io_channel_init", libglib.}
proc `ref`*(channel: GIOChannel): GIOChannel {.
    importc: "g_io_channel_ref", libglib.}
proc unref*(channel: GIOChannel) {.
    importc: "g_io_channel_unref", libglib.}
proc read*(channel: GIOChannel; buf: cstring; count: gsize; 
                        bytes_read: var gsize): GIOError {.
    importc: "g_io_channel_read", libglib.}
proc write*(channel: GIOChannel; buf: cstring; 
                         count: gsize; bytes_written: var gsize): GIOError {.
    importc: "g_io_channel_write", libglib.}
proc seek*(channel: GIOChannel; offset: gint64; 
                        `type`: GSeekType): GIOError {.
    importc: "g_io_channel_seek", libglib.}
proc close*(channel: GIOChannel) {.
    importc: "g_io_channel_close", libglib.}
proc shutdown*(channel: GIOChannel; flush: gboolean; 
                            err: var GError): GIOStatus {.
    importc: "g_io_channel_shutdown", libglib.}
proc g_io_add_watch_full*(channel: GIOChannel; priority: gint; 
                          condition: GIOCondition; `func`: GIOFunc; 
                          user_data: gpointer; notify: GDestroyNotify): guint {.
    importc: "g_io_add_watch_full", libglib.}
proc g_io_create_watch*(channel: GIOChannel; condition: GIOCondition): GSource {.
    importc: "g_io_create_watch", libglib.}
proc g_io_add_watch*(channel: GIOChannel; condition: GIOCondition; 
                     `func`: GIOFunc; user_data: gpointer): guint {.
    importc: "g_io_add_watch", libglib.}
proc set_buffer_size*(channel: GIOChannel; size: gsize) {.
    importc: "g_io_channel_set_buffer_size", libglib.}
proc `buffer_size=`*(channel: GIOChannel; size: gsize) {.
    importc: "g_io_channel_set_buffer_size", libglib.}
proc get_buffer_size*(channel: GIOChannel): gsize {.
    importc: "g_io_channel_get_buffer_size", libglib.}
proc buffer_size*(channel: GIOChannel): gsize {.
    importc: "g_io_channel_get_buffer_size", libglib.}
proc get_buffer_condition*(channel: GIOChannel): GIOCondition {.
    importc: "g_io_channel_get_buffer_condition", libglib.}
proc buffer_condition*(channel: GIOChannel): GIOCondition {.
    importc: "g_io_channel_get_buffer_condition", libglib.}
proc set_flags*(channel: GIOChannel; flags: GIOFlags; 
                             error: var GError): GIOStatus {.
    importc: "g_io_channel_set_flags", libglib.}
proc get_flags*(channel: GIOChannel): GIOFlags {.
    importc: "g_io_channel_get_flags", libglib.}
proc flags*(channel: GIOChannel): GIOFlags {.
    importc: "g_io_channel_get_flags", libglib.}
proc set_line_term*(channel: GIOChannel; 
                                 line_term: cstring; length: gint) {.
    importc: "g_io_channel_set_line_term", libglib.}
proc `line_term=`*(channel: GIOChannel; 
                                 line_term: cstring; length: gint) {.
    importc: "g_io_channel_set_line_term", libglib.}
proc get_line_term*(channel: GIOChannel; length: var gint): cstring {.
    importc: "g_io_channel_get_line_term", libglib.}
proc line_term*(channel: GIOChannel; length: var gint): cstring {.
    importc: "g_io_channel_get_line_term", libglib.}
proc set_buffered*(channel: GIOChannel; buffered: gboolean) {.
    importc: "g_io_channel_set_buffered", libglib.}
proc `buffered=`*(channel: GIOChannel; buffered: gboolean) {.
    importc: "g_io_channel_set_buffered", libglib.}
proc get_buffered*(channel: GIOChannel): gboolean {.
    importc: "g_io_channel_get_buffered", libglib.}
proc buffered*(channel: GIOChannel): gboolean {.
    importc: "g_io_channel_get_buffered", libglib.}
proc set_encoding*(channel: GIOChannel; encoding: cstring; 
                                error: var GError): GIOStatus {.
    importc: "g_io_channel_set_encoding", libglib.}
proc get_encoding*(channel: GIOChannel): cstring {.
    importc: "g_io_channel_get_encoding", libglib.}
proc encoding*(channel: GIOChannel): cstring {.
    importc: "g_io_channel_get_encoding", libglib.}
proc set_close_on_unref*(channel: GIOChannel; 
                                      do_close: gboolean) {.
    importc: "g_io_channel_set_close_on_unref", libglib.}
proc `close_on_unref=`*(channel: GIOChannel; 
                                      do_close: gboolean) {.
    importc: "g_io_channel_set_close_on_unref", libglib.}
proc get_close_on_unref*(channel: GIOChannel): gboolean {.
    importc: "g_io_channel_get_close_on_unref", libglib.}
proc close_on_unref*(channel: GIOChannel): gboolean {.
    importc: "g_io_channel_get_close_on_unref", libglib.}
proc flush*(channel: GIOChannel; error: var GError): GIOStatus {.
    importc: "g_io_channel_flush", libglib.}
proc read_line*(channel: GIOChannel; 
                             str_return: cstringArray; length: var gsize; 
                             terminator_pos: ptr gsize; error: var GError): GIOStatus {.
    importc: "g_io_channel_read_line", libglib.}
proc read_line_string*(channel: GIOChannel; 
                                    buffer: GString; 
                                    terminator_pos: ptr gsize; 
                                    error: var GError): GIOStatus {.
    importc: "g_io_channel_read_line_string", libglib.}
proc read_to_end*(channel: GIOChannel; 
                               str_return: cstringArray; length: var gsize; 
                               error: var GError): GIOStatus {.
    importc: "g_io_channel_read_to_end", libglib.}
proc read_chars*(channel: GIOChannel; buf: cstring; 
                              count: gsize; bytes_read: var gsize; 
                              error: var GError): GIOStatus {.
    importc: "g_io_channel_read_chars", libglib.}
proc read_unichar*(channel: GIOChannel; 
                                thechar: ptr gunichar; error: var GError): GIOStatus {.
    importc: "g_io_channel_read_unichar", libglib.}
proc write_chars*(channel: GIOChannel; buf: cstring; 
                               count: gssize; bytes_written: var gsize; 
                               error: var GError): GIOStatus {.
    importc: "g_io_channel_write_chars", libglib.}
proc write_unichar*(channel: GIOChannel; thechar: gunichar; 
                                 error: var GError): GIOStatus {.
    importc: "g_io_channel_write_unichar", libglib.}
proc seek_position*(channel: GIOChannel; offset: gint64; 
                                 `type`: GSeekType; error: var GError): GIOStatus {.
    importc: "g_io_channel_seek_position", libglib.}
proc g_io_channel_error_quark*(): GQuark {.
    importc: "g_io_channel_error_quark", libglib.}
proc g_io_channel_error_from_errno*(en: gint): GIOChannelError {.
    importc: "g_io_channel_error_from_errno", libglib.}
proc g_io_channel_unix_new*(fd: cint): GIOChannel {.
    importc: "g_io_channel_unix_new", libglib.}
proc unix_get_fd*(channel: GIOChannel): gint {.
    importc: "g_io_channel_unix_get_fd", libglib.}
when defined(windows): 
  const 
    G_WIN32_MSG_HANDLE* = 19981206
  proc win32_make_pollfd*(channel: GIOChannel; 
      condition: GIOCondition; fd: GPollFD) {.
      importc: "g_io_channel_win32_make_pollfd", libglib.}
  proc g_io_channel_win32_poll*(fds: GPollFD; n_fds: gint; timeout: gint): gint {.
      importc: "g_io_channel_win32_poll", libglib.}
  when GLIB_SIZEOF_VOID_P == 8: 
    proc g_io_channel_win32_new_messages*(hwnd: gsize): GIOChannel {.
        importc: "g_io_channel_win32_new_messages", libglib.}
  else: 
    proc g_io_channel_win32_new_messages*(hwnd: guint): GIOChannel {.
        importc: "g_io_channel_win32_new_messages", libglib.}
  proc g_io_channel_win32_new_fd*(fd: gint): GIOChannel {.
      importc: "g_io_channel_win32_new_fd", libglib.}
  proc win32_get_fd*(channel: GIOChannel): gint {.
      importc: "g_io_channel_win32_get_fd", libglib.}
  proc g_io_channel_win32_new_socket*(socket: gint): GIOChannel {.
      importc: "g_io_channel_win32_new_socket", libglib.}
  proc g_io_channel_win32_new_stream_socket*(socket: gint): GIOChannel {.
      importc: "g_io_channel_win32_new_stream_socket", libglib.}
  proc win32_set_debug*(channel: GIOChannel; flag: gboolean) {.
      importc: "g_io_channel_win32_set_debug", libglib.}
when defined(windows): 
  proc g_io_channel_new_file_utf8*(filename: cstring; mode: cstring; 
                                   error: var GError): GIOChannel {.
      importc: "g_io_channel_new_file_utf8", libglib.}
  const 
    g_io_channel_new_file* = g_io_channel_new_file_utf8
else:
  proc g_io_channel_new_file*(filename: cstring; mode: cstring; 
                              error: var GError): GIOChannel {.
      importc: "g_io_channel_new_file", libglib.}

type 
  GKeyFileError* {.size: sizeof(cint), pure.} = enum 
    UNKNOWN_ENCODING, PARSE, 
    NOT_FOUND, KEY_NOT_FOUND, 
    GROUP_NOT_FOUND, INVALID_VALUE
proc g_key_file_error_quark*(): GQuark {.importc: "g_key_file_error_quark", 
    libglib.}
type 
  GKeyFile* =  ptr GKeyFileObj
  GKeyFilePtr* = ptr GKeyFileObj
  GKeyFileObj* = object 
  
  GKeyFileFlags* {.size: sizeof(cint), pure.} = enum 
    NONE = 0, KEEP_COMMENTS = 1 shl 0, 
    KEEP_TRANSLATIONS = 1 shl 1
proc g_key_file_new*(): GKeyFile {.importc: "g_key_file_new", libglib.}
proc `ref`*(key_file: GKeyFile): GKeyFile {.
    importc: "g_key_file_ref", libglib.}
proc unref*(key_file: GKeyFile) {.importc: "g_key_file_unref", 
    libglib.}
proc free*(key_file: GKeyFile) {.importc: "g_key_file_free", 
    libglib.}
proc set_list_separator*(key_file: GKeyFile; separator: gchar) {.
    importc: "g_key_file_set_list_separator", libglib.}
proc `list_separator=`*(key_file: GKeyFile; separator: gchar) {.
    importc: "g_key_file_set_list_separator", libglib.}
proc load_from_file*(key_file: GKeyFile; file: cstring; 
                                flags: GKeyFileFlags; error: var GError): gboolean {.
    importc: "g_key_file_load_from_file", libglib.}
proc load_from_data*(key_file: GKeyFile; data: cstring; 
                                length: gsize; flags: GKeyFileFlags; 
                                error: var GError): gboolean {.
    importc: "g_key_file_load_from_data", libglib.}
proc load_from_dirs*(key_file: GKeyFile; file: cstring; 
                                search_dirs: cstringArray; 
                                full_path: cstringArray; 
                                flags: GKeyFileFlags; error: var GError): gboolean {.
    importc: "g_key_file_load_from_dirs", libglib.}
proc load_from_data_dirs*(key_file: GKeyFile; file: cstring; 
                                     full_path: cstringArray; 
                                     flags: GKeyFileFlags; 
                                     error: var GError): gboolean {.
    importc: "g_key_file_load_from_data_dirs", libglib.}
proc to_data*(key_file: GKeyFile; length: var gsize; 
                         error: var GError): cstring {.
    importc: "g_key_file_to_data", libglib.}
proc save_to_file*(key_file: GKeyFile; filename: cstring; 
                              error: var GError): gboolean {.
    importc: "g_key_file_save_to_file", libglib.}
proc get_start_group*(key_file: GKeyFile): cstring {.
    importc: "g_key_file_get_start_group", libglib.}
proc start_group*(key_file: GKeyFile): cstring {.
    importc: "g_key_file_get_start_group", libglib.}
proc get_groups*(key_file: GKeyFile; length: var gsize): cstringArray {.
    importc: "g_key_file_get_groups", libglib.}
proc groups*(key_file: GKeyFile; length: var gsize): cstringArray {.
    importc: "g_key_file_get_groups", libglib.}
proc get_keys*(key_file: GKeyFile; group_name: cstring; 
                          length: var gsize; error: var GError): cstringArray {.
    importc: "g_key_file_get_keys", libglib.}
proc keys*(key_file: GKeyFile; group_name: cstring; 
                          length: var gsize; error: var GError): cstringArray {.
    importc: "g_key_file_get_keys", libglib.}
proc has_group*(key_file: GKeyFile; group_name: cstring): gboolean {.
    importc: "g_key_file_has_group", libglib.}
proc has_key*(key_file: GKeyFile; group_name: cstring; 
                         key: cstring; error: var GError): gboolean {.
    importc: "g_key_file_has_key", libglib.}
proc get_value*(key_file: GKeyFile; group_name: cstring; 
                           key: cstring; error: var GError): cstring {.
    importc: "g_key_file_get_value", libglib.}
proc value*(key_file: GKeyFile; group_name: cstring; 
                           key: cstring; error: var GError): cstring {.
    importc: "g_key_file_get_value", libglib.}
proc set_value*(key_file: GKeyFile; group_name: cstring; 
                           key: cstring; value: cstring) {.
    importc: "g_key_file_set_value", libglib.}
proc `value=`*(key_file: GKeyFile; group_name: cstring; 
                           key: cstring; value: cstring) {.
    importc: "g_key_file_set_value", libglib.}
proc get_string*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; error: var GError): cstring {.
    importc: "g_key_file_get_string", libglib.}
proc set_string*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; string: cstring) {.
    importc: "g_key_file_set_string", libglib.}
proc `string=`*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; string: cstring) {.
    importc: "g_key_file_set_string", libglib.}
proc get_locale_string*(key_file: GKeyFile; 
                                   group_name: cstring; key: cstring; 
                                   locale: cstring; error: var GError): cstring {.
    importc: "g_key_file_get_locale_string", libglib.}
proc locale_string*(key_file: GKeyFile; 
                                   group_name: cstring; key: cstring; 
                                   locale: cstring; error: var GError): cstring {.
    importc: "g_key_file_get_locale_string", libglib.}
proc set_locale_string*(key_file: GKeyFile; 
                                   group_name: cstring; key: cstring; 
                                   locale: cstring; string: cstring) {.
    importc: "g_key_file_set_locale_string", libglib.}
proc `locale_string=`*(key_file: GKeyFile; 
                                   group_name: cstring; key: cstring; 
                                   locale: cstring; string: cstring) {.
    importc: "g_key_file_set_locale_string", libglib.}
proc get_boolean*(key_file: GKeyFile; group_name: cstring; 
                             key: cstring; error: var GError): gboolean {.
    importc: "g_key_file_get_boolean", libglib.}
proc set_boolean*(key_file: GKeyFile; group_name: cstring; 
                             key: cstring; value: gboolean) {.
    importc: "g_key_file_set_boolean", libglib.}
proc `boolean=`*(key_file: GKeyFile; group_name: cstring; 
                             key: cstring; value: gboolean) {.
    importc: "g_key_file_set_boolean", libglib.}
proc get_integer*(key_file: GKeyFile; group_name: cstring; 
                             key: cstring; error: var GError): gint {.
    importc: "g_key_file_get_integer", libglib.}
proc set_integer*(key_file: GKeyFile; group_name: cstring; 
                             key: cstring; value: gint) {.
    importc: "g_key_file_set_integer", libglib.}
proc `integer=`*(key_file: GKeyFile; group_name: cstring; 
                             key: cstring; value: gint) {.
    importc: "g_key_file_set_integer", libglib.}
proc get_int64*(key_file: GKeyFile; group_name: cstring; 
                           key: cstring; error: var GError): gint64 {.
    importc: "g_key_file_get_int64", libglib.}
proc set_int64*(key_file: GKeyFile; group_name: cstring; 
                           key: cstring; value: gint64) {.
    importc: "g_key_file_set_int64", libglib.}
proc `int64=`*(key_file: GKeyFile; group_name: cstring; 
                           key: cstring; value: gint64) {.
    importc: "g_key_file_set_int64", libglib.}
proc get_uint64*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; error: var GError): guint64 {.
    importc: "g_key_file_get_uint64", libglib.}
proc set_uint64*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; value: guint64) {.
    importc: "g_key_file_set_uint64", libglib.}
proc `uint64=`*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; value: guint64) {.
    importc: "g_key_file_set_uint64", libglib.}
proc get_double*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; error: var GError): gdouble {.
    importc: "g_key_file_get_double", libglib.}
proc set_double*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; value: gdouble) {.
    importc: "g_key_file_set_double", libglib.}
proc `double=`*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; value: gdouble) {.
    importc: "g_key_file_set_double", libglib.}
proc get_string_list*(key_file: GKeyFile; 
                                 group_name: cstring; key: cstring; 
                                 length: var gsize; error: var GError): cstringArray {.
    importc: "g_key_file_get_string_list", libglib.}
proc string_list*(key_file: GKeyFile; 
                                 group_name: cstring; key: cstring; 
                                 length: var gsize; error: var GError): cstringArray {.
    importc: "g_key_file_get_string_list", libglib.}
proc set_string_list*(key_file: GKeyFile; 
                                 group_name: cstring; key: cstring; 
                                 list: cstringArray; length: gsize) {.
    importc: "g_key_file_set_string_list", libglib.}
proc `string_list=`*(key_file: GKeyFile; 
                                 group_name: cstring; key: cstring; 
                                 list: cstringArray; length: gsize) {.
    importc: "g_key_file_set_string_list", libglib.}
proc get_locale_string_list*(key_file: GKeyFile; 
    group_name: cstring; key: cstring; locale: cstring; 
    length: var gsize; error: var GError): cstringArray {.
    importc: "g_key_file_get_locale_string_list", libglib.}
proc locale_string_list*(key_file: GKeyFile; 
    group_name: cstring; key: cstring; locale: cstring; 
    length: var gsize; error: var GError): cstringArray {.
    importc: "g_key_file_get_locale_string_list", libglib.}
proc set_locale_string_list*(key_file: GKeyFile; 
    group_name: cstring; key: cstring; locale: cstring; 
    list: cstringArray; length: gsize) {.
    importc: "g_key_file_set_locale_string_list", libglib.}
proc `locale_string_list=`*(key_file: GKeyFile; 
    group_name: cstring; key: cstring; locale: cstring; 
    list: cstringArray; length: gsize) {.
    importc: "g_key_file_set_locale_string_list", libglib.}
proc get_boolean_list*(key_file: GKeyFile; 
                                  group_name: cstring; key: cstring; 
                                  length: var gsize; error: var GError): ptr gboolean {.
    importc: "g_key_file_get_boolean_list", libglib.}
proc boolean_list*(key_file: GKeyFile; 
                                  group_name: cstring; key: cstring; 
                                  length: var gsize; error: var GError): ptr gboolean {.
    importc: "g_key_file_get_boolean_list", libglib.}
proc set_boolean_list*(key_file: GKeyFile; 
                                  group_name: cstring; key: cstring; 
                                  list: ptr gboolean; length: gsize) {.
    importc: "g_key_file_set_boolean_list", libglib.}
proc `boolean_list=`*(key_file: GKeyFile; 
                                  group_name: cstring; key: cstring; 
                                  list: ptr gboolean; length: gsize) {.
    importc: "g_key_file_set_boolean_list", libglib.}
proc get_integer_list*(key_file: GKeyFile; 
                                  group_name: cstring; key: cstring; 
                                  length: var gsize; error: var GError): ptr gint {.
    importc: "g_key_file_get_integer_list", libglib.}
proc integer_list*(key_file: GKeyFile; 
                                  group_name: cstring; key: cstring; 
                                  length: var gsize; error: var GError): ptr gint {.
    importc: "g_key_file_get_integer_list", libglib.}
proc set_double_list*(key_file: GKeyFile; 
                                 group_name: cstring; key: cstring; 
                                 list: ptr gdouble; length: gsize) {.
    importc: "g_key_file_set_double_list", libglib.}
proc `double_list=`*(key_file: GKeyFile; 
                                 group_name: cstring; key: cstring; 
                                 list: ptr gdouble; length: gsize) {.
    importc: "g_key_file_set_double_list", libglib.}
proc get_double_list*(key_file: GKeyFile; 
                                 group_name: cstring; key: cstring; 
                                 length: var gsize; error: var GError): ptr gdouble {.
    importc: "g_key_file_get_double_list", libglib.}
proc double_list*(key_file: GKeyFile; 
                                 group_name: cstring; key: cstring; 
                                 length: var gsize; error: var GError): ptr gdouble {.
    importc: "g_key_file_get_double_list", libglib.}
proc set_integer_list*(key_file: GKeyFile; 
                                  group_name: cstring; key: cstring; 
                                  list: ptr gint; length: gsize) {.
    importc: "g_key_file_set_integer_list", libglib.}
proc `integer_list=`*(key_file: GKeyFile; 
                                  group_name: cstring; key: cstring; 
                                  list: ptr gint; length: gsize) {.
    importc: "g_key_file_set_integer_list", libglib.}
proc set_comment*(key_file: GKeyFile; group_name: cstring; 
                             key: cstring; comment: cstring; 
                             error: var GError): gboolean {.
    importc: "g_key_file_set_comment", libglib.}
proc get_comment*(key_file: GKeyFile; group_name: cstring; 
                             key: cstring; error: var GError): cstring {.
    importc: "g_key_file_get_comment", libglib.}
proc comment*(key_file: GKeyFile; group_name: cstring; 
                             key: cstring; error: var GError): cstring {.
    importc: "g_key_file_get_comment", libglib.}
proc remove_comment*(key_file: GKeyFile; group_name: cstring; 
                                key: cstring; error: var GError): gboolean {.
    importc: "g_key_file_remove_comment", libglib.}
proc remove_key*(key_file: GKeyFile; group_name: cstring; 
                            key: cstring; error: var GError): gboolean {.
    importc: "g_key_file_remove_key", libglib.}
proc remove_group*(key_file: GKeyFile; group_name: cstring; 
                              error: var GError): gboolean {.
    importc: "g_key_file_remove_group", libglib.}
const 
  G_KEY_FILE_DESKTOP_GROUP* = "Desktop Entry"
  G_KEY_FILE_DESKTOP_KEY_TYPE* = "Type"
  G_KEY_FILE_DESKTOP_KEY_VERSION* = "Version"
  G_KEY_FILE_DESKTOP_KEY_NAME* = "Name"
  G_KEY_FILE_DESKTOP_KEY_GENERIC_NAME* = "GenericName"
  G_KEY_FILE_DESKTOP_KEY_NO_DISPLAY* = "NoDisplay"
  G_KEY_FILE_DESKTOP_KEY_COMMENT* = "Comment"
  G_KEY_FILE_DESKTOP_KEY_ICON* = "Icon"
  G_KEY_FILE_DESKTOP_KEY_HIDDEN* = "Hidden"
  G_KEY_FILE_DESKTOP_KEY_ONLY_SHOW_IN* = "OnlyShowIn"
  G_KEY_FILE_DESKTOP_KEY_NOT_SHOW_IN* = "NotShowIn"
  G_KEY_FILE_DESKTOP_KEY_TRY_EXEC* = "TryExec"
  G_KEY_FILE_DESKTOP_KEY_EXEC* = "Exec"
  G_KEY_FILE_DESKTOP_KEY_PATH* = "Path"
  G_KEY_FILE_DESKTOP_KEY_TERMINAL* = "Terminal"
  G_KEY_FILE_DESKTOP_KEY_MIME_TYPE* = "MimeType"
  G_KEY_FILE_DESKTOP_KEY_CATEGORIES* = "Categories"
  G_KEY_FILE_DESKTOP_KEY_STARTUP_NOTIFY* = "StartupNotify"
  G_KEY_FILE_DESKTOP_KEY_STARTUP_WM_CLASS* = "StartupWMClass"
  G_KEY_FILE_DESKTOP_KEY_URL* = "URL"
  G_KEY_FILE_DESKTOP_KEY_DBUS_ACTIVATABLE* = "DBusActivatable"
  G_KEY_FILE_DESKTOP_KEY_ACTIONS* = "Actions"
  G_KEY_FILE_DESKTOP_TYPE_APPLICATION* = "Application"
  G_KEY_FILE_DESKTOP_TYPE_LINK* = "Link"
  G_KEY_FILE_DESKTOP_TYPE_DIRECTORY* = "Directory"

type 
  GMappedFile* =  ptr GMappedFileObj
  GMappedFilePtr* = ptr GMappedFileObj
  GMappedFileObj* = object 
  
proc g_mapped_file_new*(filename: cstring; writable: gboolean; 
                        error: var GError): GMappedFile {.
    importc: "g_mapped_file_new", libglib.}
proc g_mapped_file_new_from_fd*(fd: gint; writable: gboolean; 
                                error: var GError): GMappedFile {.
    importc: "g_mapped_file_new_from_fd", libglib.}
proc get_length*(file: GMappedFile): gsize {.
    importc: "g_mapped_file_get_length", libglib.}
proc length*(file: GMappedFile): gsize {.
    importc: "g_mapped_file_get_length", libglib.}
proc get_contents*(file: GMappedFile): cstring {.
    importc: "g_mapped_file_get_contents", libglib.}
proc contents*(file: GMappedFile): cstring {.
    importc: "g_mapped_file_get_contents", libglib.}
proc get_bytes*(file: GMappedFile): GBytes {.
    importc: "g_mapped_file_get_bytes", libglib.}
proc bytes*(file: GMappedFile): GBytes {.
    importc: "g_mapped_file_get_bytes", libglib.}
proc `ref`*(file: GMappedFile): GMappedFile {.
    importc: "g_mapped_file_ref", libglib.}
proc unref*(file: GMappedFile) {.
    importc: "g_mapped_file_unref", libglib.}
proc free*(file: GMappedFile) {.
    importc: "g_mapped_file_free", libglib.}

type 
  GMarkupError* {.size: sizeof(cint), pure.} = enum 
    BAD_UTF8, EMPTY, PARSE, 
    UNKNOWN_ELEMENT, UNKNOWN_ATTRIBUTE, 
    INVALID_CONTENT, MISSING_ATTRIBUTE
proc g_markup_error_quark*(): GQuark {.importc: "g_markup_error_quark", 
    libglib.}
type 
  GMarkupParseFlags* {.size: sizeof(cint), pure.} = enum 
    DO_NOT_USE_THIS_UNSUPPORTED_FLAG = 1 shl 0, 
    TREAT_CDATA_AS_TEXT = 1 shl 1, 
    PREFIX_ERROR_POSITION = 1 shl 2, 
    IGNORE_QUALIFIED = 1 shl 3
type 
  GMarkupParseContext* =  ptr GMarkupParseContextObj
  GMarkupParseContextPtr* = ptr GMarkupParseContextObj
  GMarkupParseContextObj* = object 
  
type 
  GMarkupParser* =  ptr GMarkupParserObj
  GMarkupParserPtr* = ptr GMarkupParserObj
  GMarkupParserObj* = object 
    start_element*: proc (context: GMarkupParseContext; 
                          element_name: cstring; 
                          attribute_names: cstringArray; 
                          attribute_values: cstringArray; 
                          user_data: gpointer; error: var GError) {.cdecl.}
    end_element*: proc (context: GMarkupParseContext; 
                        element_name: cstring; user_data: gpointer; 
                        error: var GError) {.cdecl.}
    text*: proc (context: GMarkupParseContext; text: cstring; 
                 text_len: gsize; user_data: gpointer; error: var GError) {.cdecl.}
    passthrough*: proc (context: GMarkupParseContext; 
                        passthrough_text: cstring; text_len: gsize; 
                        user_data: gpointer; error: var GError) {.cdecl.}
    error*: proc (context: GMarkupParseContext; error: GError; 
                  user_data: gpointer) {.cdecl.}

proc g_markup_parse_context_new*(parser: GMarkupParser; 
                                 flags: GMarkupParseFlags; 
                                 user_data: gpointer; 
                                 user_data_dnotify: GDestroyNotify): GMarkupParseContext {.
    importc: "g_markup_parse_context_new", libglib.}
proc `ref`*(context: GMarkupParseContext): GMarkupParseContext {.
    importc: "g_markup_parse_context_ref", libglib.}
proc unref*(context: GMarkupParseContext) {.
    importc: "g_markup_parse_context_unref", libglib.}
proc free*(context: GMarkupParseContext) {.
    importc: "g_markup_parse_context_free", libglib.}
proc parse*(context: GMarkupParseContext; 
                                   text: cstring; text_len: gssize; 
                                   error: var GError): gboolean {.
    importc: "g_markup_parse_context_parse", libglib.}
proc push*(context: GMarkupParseContext; 
                                  parser: GMarkupParser; 
                                  user_data: gpointer) {.
    importc: "g_markup_parse_context_push", libglib.}
proc pop*(context: GMarkupParseContext): gpointer {.
    importc: "g_markup_parse_context_pop", libglib.}
proc end_parse*(context: GMarkupParseContext; 
    error: var GError): gboolean {.
    importc: "g_markup_parse_context_end_parse", libglib.}
proc get_element*(context: GMarkupParseContext): cstring {.
    importc: "g_markup_parse_context_get_element", libglib.}
proc element*(context: GMarkupParseContext): cstring {.
    importc: "g_markup_parse_context_get_element", libglib.}
proc get_element_stack*(
    context: GMarkupParseContext): GSList {.
    importc: "g_markup_parse_context_get_element_stack", libglib.}
proc element_stack*(
    context: GMarkupParseContext): GSList {.
    importc: "g_markup_parse_context_get_element_stack", libglib.}
proc get_position*(context: GMarkupParseContext; 
    line_number: var gint; char_number: var gint) {.
    importc: "g_markup_parse_context_get_position", libglib.}
proc get_user_data*(context: GMarkupParseContext): gpointer {.
    importc: "g_markup_parse_context_get_user_data", libglib.}
proc user_data*(context: GMarkupParseContext): gpointer {.
    importc: "g_markup_parse_context_get_user_data", libglib.}
proc g_markup_escape_text*(text: cstring; length: gssize): cstring {.
    importc: "g_markup_escape_text", libglib.}
proc g_markup_printf_escaped*(format: cstring): cstring {.varargs, 
    importc: "g_markup_printf_escaped", libglib.}
when Va_List_Works:
  proc g_markup_vprintf_escaped*(format: cstring; args: va_list): cstring {.
      importc: "g_markup_vprintf_escaped", libglib.}
type 
  GMarkupCollectType* {.size: sizeof(cint), pure.} = enum 
    INVALID, STRING, 
    STRDUP, BOOLEAN, 
    TRISTATE, OPTIONAL = (1 shl 16)
proc g_markup_collect_attributes*(element_name: cstring; 
                                  attribute_names: cstringArray; 
                                  attribute_values: cstringArray; 
                                  error: var GError; 
                                  first_type: GMarkupCollectType; 
                                  first_attr: cstring): gboolean {.varargs, 
    importc: "g_markup_collect_attributes", libglib.}

when Va_List_Works:
  proc g_printf_string_upper_bound*(format: cstring; args: va_list): gsize {.
      importc: "g_printf_string_upper_bound", libglib.}
const 
  G_LOG_LEVEL_USER_SHIFT* = 8
type 
  GLogLevelFlags* {.size: sizeof(cint), pure.} = enum 
    MASK = not(3)
    FLAG_RECURSION = 1 shl 0, FLAG_FATAL = 1 shl 1, 
    LEVEL_ERROR = 1 shl 2,
    FATAL_MASK = (GLogLevelFlags.FLAG_RECURSION.ord or GLogLevelFlags.LEVEL_ERROR.ord)
    LEVEL_CRITICAL = 1 shl 3, 
    LEVEL_WARNING = 1 shl 4, LEVEL_MESSAGE = 1 shl 5, 
    LEVEL_INFO = 1 shl 6, LEVEL_DEBUG = 1 shl 7 
type 
  GLogFunc* = proc (log_domain: cstring; log_level: GLogLevelFlags; 
                    message: cstring; user_data: gpointer) {.cdecl.}
proc g_log_set_handler*(log_domain: cstring; log_levels: GLogLevelFlags; 
                        log_func: GLogFunc; user_data: gpointer): guint {.
    importc: "g_log_set_handler", libglib.}
proc g_log_remove_handler*(log_domain: cstring; handler_id: guint) {.
    importc: "g_log_remove_handler", libglib.}
proc g_log_default_handler*(log_domain: cstring; log_level: GLogLevelFlags; 
                            message: cstring; unused_data: gpointer) {.
    importc: "g_log_default_handler", libglib.}
proc g_log_set_default_handler*(log_func: GLogFunc; user_data: gpointer): GLogFunc {.
    importc: "g_log_set_default_handler", libglib.}
proc g_log*(log_domain: cstring; log_level: GLogLevelFlags; 
            format: cstring) {.varargs, importc: "g_log", libglib.}
when Va_List_Works:
  proc g_logv*(log_domain: cstring; log_level: GLogLevelFlags; 
               format: cstring; args: va_list) {.importc: "g_logv", 
      libglib.}
proc g_log_set_fatal_mask*(log_domain: cstring; fatal_mask: GLogLevelFlags): GLogLevelFlags {.
    importc: "g_log_set_fatal_mask", libglib.}
proc g_log_set_always_fatal*(fatal_mask: GLogLevelFlags): GLogLevelFlags {.
    importc: "g_log_set_always_fatal", libglib.}
proc g_log_fallback_handler(log_domain: cstring; 
                              log_level: GLogLevelFlags; message: cstring; 
                              unused_data: gpointer) {.
    importc: "_g_log_fallback_handler", libglib.}
proc g_return_if_fail_warning*(log_domain: cstring; pretty_function: cstring; 
                               expression: cstring) {.
    importc: "g_return_if_fail_warning", libglib.}
proc g_warn_message*(domain: cstring; file: cstring; line: cint; 
                     `func`: cstring; warnexpr: cstring) {.
    importc: "g_warn_message", libglib.}
proc g_assert_warning*(log_domain: cstring; file: cstring; line: cint; 
                       pretty_function: cstring; expression: cstring) {.
    importc: "g_assert_warning", libglib.}
when false: # when not(defined(G_LOG_DOMAIN)): 
  const 
    G_LOG_DOMAIN* = (cast[ptr gchar](0))
type 
  GPrintFunc* = proc (string: cstring) {.cdecl.}
proc g_print*(format: cstring) {.varargs, importc: "g_print", libglib.}
proc g_set_print_handler*(`func`: GPrintFunc): GPrintFunc {.
    importc: "g_set_print_handler", libglib.}
proc g_printerr*(format: cstring) {.varargs, importc: "g_printerr", 
                                      libglib.}
proc g_set_printerr_handler*(`func`: GPrintFunc): GPrintFunc {.
    importc: "g_set_printerr_handler", libglib.}

type 
  GOptionContext* =  ptr GOptionContextObj
  GOptionContextPtr* = ptr GOptionContextObj
  GOptionContextObj* = object 
  
type 
  GOptionGroup* =  ptr GOptionGroupObj
  GOptionGroupPtr* = ptr GOptionGroupObj
  GOptionGroupObj* = object 
  
type 
  GOptionFlags* {.size: sizeof(cint), pure.} = enum 
    NONE = 0, HIDDEN = 1 shl 0, 
    IN_MAIN = 1 shl 1, REVERSE = 1 shl 2, 
    NO_ARG = 1 shl 3, FILENAME = 1 shl 4, 
    OPTIONAL_ARG = 1 shl 5, NOALIAS = 1 shl 6
type 
  GOptionArg* {.size: sizeof(cint), pure.} = enum 
    NONE, STRING, INT, 
    CALLBACK, FILENAME, STRING_ARRAY, 
    FILENAME_ARRAY, DOUBLE, INT64
type 
  GOptionArgFunc* = proc (option_name: cstring; value: cstring; 
                          data: gpointer; error: var GError): gboolean {.cdecl.}
type 
  GOptionParseFunc* = proc (context: GOptionContext; 
                            group: GOptionGroup; data: gpointer; 
                            error: var GError): gboolean {.cdecl.}
type 
  GOptionErrorFunc* = proc (context: GOptionContext; 
                            group: GOptionGroup; data: gpointer; 
                            error: var GError) {.cdecl.}
type 
  GOptionError* {.size: sizeof(cint), pure.} = enum 
    UNKNOWN_OPTION, BAD_VALUE, 
    FAILED
proc g_option_error_quark*(): GQuark {.importc: "g_option_error_quark", 
    libglib.}
type 
  GOptionEntry* =  ptr GOptionEntryObj
  GOptionEntryPtr* = ptr GOptionEntryObj
  GOptionEntryObj* = object 
    long_name*: cstring
    short_name*: gchar
    flags*: gint
    arg*: GOptionArg
    arg_data*: gpointer
    description*: cstring
    arg_description*: cstring

const 
  G_OPTION_REMAINING* = ""
proc g_option_context_new*(parameter_string: cstring): GOptionContext {.
    importc: "g_option_context_new", libglib.}
proc set_summary*(context: GOptionContext; 
                                   summary: cstring) {.
    importc: "g_option_context_set_summary", libglib.}
proc `summary=`*(context: GOptionContext; 
                                   summary: cstring) {.
    importc: "g_option_context_set_summary", libglib.}
proc get_summary*(context: GOptionContext): cstring {.
    importc: "g_option_context_get_summary", libglib.}
proc summary*(context: GOptionContext): cstring {.
    importc: "g_option_context_get_summary", libglib.}
proc set_description*(context: GOptionContext; 
    description: cstring) {.importc: "g_option_context_set_description", 
                              libglib.}
proc `description=`*(context: GOptionContext; 
    description: cstring) {.importc: "g_option_context_set_description", 
                              libglib.}
proc get_description*(context: GOptionContext): cstring {.
    importc: "g_option_context_get_description", libglib.}
proc description*(context: GOptionContext): cstring {.
    importc: "g_option_context_get_description", libglib.}
proc free*(context: GOptionContext) {.
    importc: "g_option_context_free", libglib.}
proc set_help_enabled*(context: GOptionContext; 
    help_enabled: gboolean) {.importc: "g_option_context_set_help_enabled", 
                              libglib.}
proc `help_enabled=`*(context: GOptionContext; 
    help_enabled: gboolean) {.importc: "g_option_context_set_help_enabled", 
                              libglib.}
proc get_help_enabled*(context: GOptionContext): gboolean {.
    importc: "g_option_context_get_help_enabled", libglib.}
proc help_enabled*(context: GOptionContext): gboolean {.
    importc: "g_option_context_get_help_enabled", libglib.}
proc set_ignore_unknown_options*(context: GOptionContext; 
    ignore_unknown: gboolean) {.importc: "g_option_context_set_ignore_unknown_options", 
                                libglib.}
proc `ignore_unknown_options=`*(context: GOptionContext; 
    ignore_unknown: gboolean) {.importc: "g_option_context_set_ignore_unknown_options", 
                                libglib.}
proc get_ignore_unknown_options*(context: GOptionContext): gboolean {.
    importc: "g_option_context_get_ignore_unknown_options", libglib.}
proc ignore_unknown_options*(context: GOptionContext): gboolean {.
    importc: "g_option_context_get_ignore_unknown_options", libglib.}
proc add_main_entries*(context: GOptionContext; 
    entries: GOptionEntry; translation_domain: cstring) {.
    importc: "g_option_context_add_main_entries", libglib.}
proc parse*(context: GOptionContext; argc: ptr gint; 
                             argv: ptr cstringArray; error: var GError): gboolean {.
    importc: "g_option_context_parse", libglib.}
proc parse_strv*(context: GOptionContext; 
                                  arguments: ptr cstringArray; 
                                  error: var GError): gboolean {.
    importc: "g_option_context_parse_strv", libglib.}
proc set_translate_func*(context: GOptionContext; 
    `func`: GTranslateFunc; data: gpointer; destroy_notify: GDestroyNotify) {.
    importc: "g_option_context_set_translate_func", libglib.}
proc `translate_func=`*(context: GOptionContext; 
    `func`: GTranslateFunc; data: gpointer; destroy_notify: GDestroyNotify) {.
    importc: "g_option_context_set_translate_func", libglib.}
proc set_translation_domain*(context: GOptionContext; 
    domain: cstring) {.importc: "g_option_context_set_translation_domain", 
                         libglib.}
proc `translation_domain=`*(context: GOptionContext; 
    domain: cstring) {.importc: "g_option_context_set_translation_domain", 
                         libglib.}
proc add_group*(context: GOptionContext; 
                                 group: GOptionGroup) {.
    importc: "g_option_context_add_group", libglib.}
proc set_main_group*(context: GOptionContext; 
                                      group: GOptionGroup) {.
    importc: "g_option_context_set_main_group", libglib.}
proc `main_group=`*(context: GOptionContext; 
                                      group: GOptionGroup) {.
    importc: "g_option_context_set_main_group", libglib.}
proc get_main_group*(context: GOptionContext): GOptionGroup {.
    importc: "g_option_context_get_main_group", libglib.}
proc main_group*(context: GOptionContext): GOptionGroup {.
    importc: "g_option_context_get_main_group", libglib.}
proc get_help*(context: GOptionContext; 
                                main_help: gboolean; group: GOptionGroup): cstring {.
    importc: "g_option_context_get_help", libglib.}
proc help*(context: GOptionContext; 
                                main_help: gboolean; group: GOptionGroup): cstring {.
    importc: "g_option_context_get_help", libglib.}
proc g_option_group_new*(name: cstring; description: cstring; 
                         help_description: cstring; user_data: gpointer; 
                         destroy: GDestroyNotify): GOptionGroup {.
    importc: "g_option_group_new", libglib.}
proc set_parse_hooks*(group: GOptionGroup; 
                                     pre_parse_func: GOptionParseFunc; 
                                     post_parse_func: GOptionParseFunc) {.
    importc: "g_option_group_set_parse_hooks", libglib.}
proc `parse_hooks=`*(group: GOptionGroup; 
                                     pre_parse_func: GOptionParseFunc; 
                                     post_parse_func: GOptionParseFunc) {.
    importc: "g_option_group_set_parse_hooks", libglib.}
proc set_error_hook*(group: GOptionGroup; 
                                    error_func: GOptionErrorFunc) {.
    importc: "g_option_group_set_error_hook", libglib.}
proc `error_hook=`*(group: GOptionGroup; 
                                    error_func: GOptionErrorFunc) {.
    importc: "g_option_group_set_error_hook", libglib.}
proc free*(group: GOptionGroup) {.
    importc: "g_option_group_free", libglib.}
proc add_entries*(group: GOptionGroup; 
                                 entries: GOptionEntry) {.
    importc: "g_option_group_add_entries", libglib.}
proc set_translate_func*(group: GOptionGroup; 
    `func`: GTranslateFunc; data: gpointer; destroy_notify: GDestroyNotify) {.
    importc: "g_option_group_set_translate_func", libglib.}
proc `translate_func=`*(group: GOptionGroup; 
    `func`: GTranslateFunc; data: gpointer; destroy_notify: GDestroyNotify) {.
    importc: "g_option_group_set_translate_func", libglib.}
proc set_translation_domain*(group: GOptionGroup; 
    domain: cstring) {.importc: "g_option_group_set_translation_domain", 
                         libglib.}
proc `translation_domain=`*(group: GOptionGroup; 
    domain: cstring) {.importc: "g_option_group_set_translation_domain", 
                         libglib.}

type 
  GPatternSpec* =  ptr GPatternSpecObj
  GPatternSpecPtr* = ptr GPatternSpecObj
  GPatternSpecObj* = object 
  
proc g_pattern_spec_new*(pattern: cstring): GPatternSpec {.
    importc: "g_pattern_spec_new", libglib.}
proc free*(pspec: GPatternSpec) {.
    importc: "g_pattern_spec_free", libglib.}
proc equal*(pspec1: GPatternSpec; pspec2: GPatternSpec): gboolean {.
    importc: "g_pattern_spec_equal", libglib.}
proc g_pattern_match*(pspec: GPatternSpec; string_length: guint; 
                      string: cstring; string_reversed: cstring): gboolean {.
    importc: "g_pattern_match", libglib.}
proc g_pattern_match_string*(pspec: GPatternSpec; string: cstring): gboolean {.
    importc: "g_pattern_match_string", libglib.}
proc g_pattern_match_simple*(pattern: cstring; string: cstring): gboolean {.
    importc: "g_pattern_match_simple", libglib.}

proc g_spaced_primes_closest*(num: guint): guint {.
    importc: "g_spaced_primes_closest", libglib.}

proc g_qsort_with_data*(pbase: gconstpointer; total_elems: gint; size: gsize; 
                        compare_func: GCompareDataFunc; user_data: gpointer) {.
    importc: "g_qsort_with_data", libglib.}

type 
  GQueue* =  ptr GQueueObj
  GQueuePtr* = ptr GQueueObj
  GQueueObj* = object 
    head*: GList
    tail*: GList
    length*: guint

proc g_queue_new*(): GQueue {.importc: "g_queue_new", libglib.}
proc free*(queue: GQueue) {.importc: "g_queue_free", libglib.}
proc free_full*(queue: GQueue; free_func: GDestroyNotify) {.
    importc: "g_queue_free_full", libglib.}
proc init*(queue: GQueue) {.importc: "g_queue_init", libglib.}
proc clear*(queue: GQueue) {.importc: "g_queue_clear", libglib.}
proc is_empty*(queue: GQueue): gboolean {.
    importc: "g_queue_is_empty", libglib.}
proc get_length*(queue: GQueue): guint {.
    importc: "g_queue_get_length", libglib.}
proc length*(queue: GQueue): guint {.
    importc: "g_queue_get_length", libglib.}
proc reverse*(queue: GQueue) {.importc: "g_queue_reverse", 
    libglib.}
proc copy*(queue: GQueue): GQueue {.importc: "g_queue_copy", 
    libglib.}
proc foreach*(queue: GQueue; `func`: GFunc; user_data: gpointer) {.
    importc: "g_queue_foreach", libglib.}
proc find*(queue: GQueue; data: gconstpointer): GList {.
    importc: "g_queue_find", libglib.}
proc find_custom*(queue: GQueue; data: gconstpointer; 
                          `func`: GCompareFunc): GList {.
    importc: "g_queue_find_custom", libglib.}
proc sort*(queue: GQueue; compare_func: GCompareDataFunc; 
                   user_data: gpointer) {.importc: "g_queue_sort", libglib.}
proc push_head*(queue: GQueue; data: gpointer) {.
    importc: "g_queue_push_head", libglib.}
proc push_tail*(queue: GQueue; data: gpointer) {.
    importc: "g_queue_push_tail", libglib.}
proc push_nth*(queue: GQueue; data: gpointer; n: gint) {.
    importc: "g_queue_push_nth", libglib.}
proc pop_head*(queue: GQueue): gpointer {.
    importc: "g_queue_pop_head", libglib.}
proc pop_tail*(queue: GQueue): gpointer {.
    importc: "g_queue_pop_tail", libglib.}
proc pop_nth*(queue: GQueue; n: guint): gpointer {.
    importc: "g_queue_pop_nth", libglib.}
proc peek_head*(queue: GQueue): gpointer {.
    importc: "g_queue_peek_head", libglib.}
proc peek_tail*(queue: GQueue): gpointer {.
    importc: "g_queue_peek_tail", libglib.}
proc peek_nth*(queue: GQueue; n: guint): gpointer {.
    importc: "g_queue_peek_nth", libglib.}
proc index*(queue: GQueue; data: gconstpointer): gint {.
    importc: "g_queue_index", libglib.}
proc remove*(queue: GQueue; data: gconstpointer): gboolean {.
    importc: "g_queue_remove", libglib.}
proc remove_all*(queue: GQueue; data: gconstpointer): guint {.
    importc: "g_queue_remove_all", libglib.}
proc insert_before*(queue: GQueue; sibling: GList; 
                            data: gpointer) {.
    importc: "g_queue_insert_before", libglib.}
proc insert_after*(queue: GQueue; sibling: GList; 
                           data: gpointer) {.importc: "g_queue_insert_after", 
    libglib.}
proc insert_sorted*(queue: GQueue; data: gpointer; 
                            `func`: GCompareDataFunc; user_data: gpointer) {.
    importc: "g_queue_insert_sorted", libglib.}
proc push_head_link*(queue: GQueue; link: GList) {.
    importc: "g_queue_push_head_link", libglib.}
proc push_tail_link*(queue: GQueue; link: GList) {.
    importc: "g_queue_push_tail_link", libglib.}
proc push_nth_link*(queue: GQueue; n: gint; link: GList) {.
    importc: "g_queue_push_nth_link", libglib.}
proc pop_head_link*(queue: GQueue): GList {.
    importc: "g_queue_pop_head_link", libglib.}
proc pop_tail_link*(queue: GQueue): GList {.
    importc: "g_queue_pop_tail_link", libglib.}
proc pop_nth_link*(queue: GQueue; n: guint): GList {.
    importc: "g_queue_pop_nth_link", libglib.}
proc peek_head_link*(queue: GQueue): GList {.
    importc: "g_queue_peek_head_link", libglib.}
proc peek_tail_link*(queue: GQueue): GList {.
    importc: "g_queue_peek_tail_link", libglib.}
proc peek_nth_link*(queue: GQueue; n: guint): GList {.
    importc: "g_queue_peek_nth_link", libglib.}
proc link_index*(queue: GQueue; link: GList): gint {.
    importc: "g_queue_link_index", libglib.}
proc unlink*(queue: GQueue; link: GList) {.
    importc: "g_queue_unlink", libglib.}
proc delete_link*(queue: GQueue; link: GList) {.
    importc: "g_queue_delete_link", libglib.}

type 
  GRand* =  ptr GRandObj
  GRandPtr* = ptr GRandObj
  GRandObj* = object 
  
proc g_rand_new_with_seed*(seed: guint32): GRand {.
    importc: "g_rand_new_with_seed", libglib.}
proc g_rand_new_with_seed_array*(seed: ptr guint32; seed_length: guint): GRand {.
    importc: "g_rand_new_with_seed_array", libglib.}
proc g_rand_new*(): GRand {.importc: "g_rand_new", libglib.}
proc free*(rand: GRand) {.importc: "g_rand_free", libglib.}
proc copy*(rand: GRand): GRand {.importc: "g_rand_copy", 
    libglib.}
proc set_seed*(rand: GRand; seed: guint32) {.
    importc: "g_rand_set_seed", libglib.}
proc `seed=`*(rand: GRand; seed: guint32) {.
    importc: "g_rand_set_seed", libglib.}
proc set_seed_array*(rand: GRand; seed: ptr guint32; 
                            seed_length: guint) {.
    importc: "g_rand_set_seed_array", libglib.}
proc `seed_array=`*(rand: GRand; seed: ptr guint32; 
                            seed_length: guint) {.
    importc: "g_rand_set_seed_array", libglib.}
proc g_rand_int*(rand: GRand): guint32 {.importc: "g_rand_int", 
    libglib.}
proc g_rand_boolean*(rand: GRand): gboolean {.inline.} =
  #ord((g_rand_int(rand) and (1 shl 15)) != 0).gboolean
  #(g_rand_int(rand) and (1 shl 15)) shr 15
  cast[gboolean]((cast[int32](g_rand_int(rand)) and (1 shl 15)) shr 15)
proc int_range*(rand: GRand; begin: gint32; `end`: gint32): gint32 {.
    importc: "g_rand_int_range", libglib.}
proc double*(rand: GRand): gdouble {.importc: "g_rand_double", 
    libglib.}
proc double_range*(rand: GRand; begin: gdouble; `end`: gdouble): gdouble {.
    importc: "g_rand_double_range", libglib.}
proc g_random_set_seed*(seed: guint32) {.importc: "g_random_set_seed", 
    libglib.}
template g_random_boolean*(): expr = 
  ((g_random_int() and (1 shl 15)) != 0)

proc g_random_int*(): guint32 {.importc: "g_random_int", libglib.}
proc g_random_int_range*(begin: gint32; `end`: gint32): gint32 {.
    importc: "g_random_int_range", libglib.}
proc g_random_double*(): gdouble {.importc: "g_random_double", libglib.}
proc g_random_double_range*(begin: gdouble; `end`: gdouble): gdouble {.
    importc: "g_random_double_range", libglib.}

type 
  GRegexError* {.size: sizeof(cint), pure.} = enum 
    COMPILE, OPTIMIZE, REPLACE, 
    MATCH, INTERNAL, 
    STRAY_BACKSLASH = 101, 
    MISSING_CONTROL_CHAR = 102, 
    UNRECOGNIZED_ESCAPE = 103, 
    QUANTIFIERS_OUT_OF_ORDER = 104, 
    QUANTIFIER_TOO_BIG = 105, 
    UNTERMINATED_CHARACTER_CLASS = 106, 
    INVALID_ESCAPE_IN_CHARACTER_CLASS = 107, 
    RANGE_OUT_OF_ORDER = 108, 
    NOTHING_TO_REPEAT = 109, 
    UNRECOGNIZED_CHARACTER = 112, 
    POSIX_NAMED_CLASS_OUTSIDE_CLASS = 113, 
    UNMATCHED_PARENTHESIS = 114, 
    INEXISTENT_SUBPATTERN_REFERENCE = 115, 
    UNTERMINATED_COMMENT = 118, 
    EXPRESSION_TOO_LARGE = 120, 
    MEMORY_ERROR = 121, 
    VARIABLE_LENGTH_LOOKBEHIND = 125, 
    MALFORMED_CONDITION = 126, 
    TOO_MANY_CONDITIONAL_BRANCHES = 127, 
    ASSERTION_EXPECTED = 128, 
    UNKNOWN_POSIX_CLASS_NAME = 130, 
    POSIX_COLLATING_ELEMENTS_NOT_SUPPORTED = 131, 
    HEX_CODE_TOO_LARGE = 134, 
    INVALID_CONDITION = 135, 
    SINGLE_BYTE_MATCH_IN_LOOKBEHIND = 136, 
    INFINITE_LOOP = 140, 
    MISSING_SUBPATTERN_NAME_TERMINATOR = 142, 
    DUPLICATE_SUBPATTERN_NAME = 143, 
    MALFORMED_PROPERTY = 146, 
    UNKNOWN_PROPERTY = 147, 
    SUBPATTERN_NAME_TOO_LONG = 148, 
    TOO_MANY_SUBPATTERNS = 149, 
    INVALID_OCTAL_VALUE = 151, 
    TOO_MANY_BRANCHES_IN_DEFINE = 154, 
    DEFINE_REPETION = 155, 
    INCONSISTENT_NEWLINE_OPTIONS = 156, 
    MISSING_BACK_REFERENCE = 157, 
    INVALID_RELATIVE_REFERENCE = 158, 
    BACKTRACKING_CONTROL_VERB_ARGUMENT_FORBIDDEN = 159, 
    UNKNOWN_BACKTRACKING_CONTROL_VERB = 160, 
    NUMBER_TOO_BIG = 161, 
    MISSING_SUBPATTERN_NAME = 162, 
    MISSING_DIGIT = 163, 
    INVALID_DATA_CHARACTER = 164, 
    EXTRA_SUBPATTERN_NAME = 165, 
    BACKTRACKING_CONTROL_VERB_ARGUMENT_REQUIRED = 166, 
    INVALID_CONTROL_CHAR = 168, 
    MISSING_NAME = 169, 
    NOT_SUPPORTED_IN_CLASS = 171, 
    TOO_MANY_FORWARD_REFERENCES = 172, 
    NAME_TOO_LONG = 175, 
    CHARACTER_VALUE_TOO_LARGE = 176
proc g_regex_error_quark*(): GQuark {.importc: "g_regex_error_quark", 
                                      libglib.}
type 
  GRegexCompileFlags* {.size: sizeof(cint), pure.} = enum 
    CASELESS = 1 shl 0, MULTILINE = 1 shl 1, 
    DOTALL = 1 shl 2, EXTENDED = 1 shl 3, 
    ANCHORED = 1 shl 4, DOLLAR_ENDONLY = 1 shl 5, 
    UNGREEDY = 1 shl 9, RAW = 1 shl 11, 
    NO_AUTO_CAPTURE = 1 shl 12, OPTIMIZE = 1 shl 13, 
    FIRSTLINE = 1 shl 18, DUPNAMES = 1 shl 19, 
    NEWLINE_CR = 1 shl 20, NEWLINE_LF = 1 shl 21, 
    NEWLINE_CRLF = GRegexCompileFlags.NEWLINE_CR.ord or GRegexCompileFlags.NEWLINE_LF.ord, 
    NEWLINE_ANYCRLF = GRegexCompileFlags.NEWLINE_CR.ord or 1 shl 22, 
    BSR_ANYCRLF = 1 shl 23, JAVASCRIPT_COMPAT = 1 shl 25
type 
  GRegexMatchFlags* {.size: sizeof(cint), pure.} = enum 
    ANCHORED = 1 shl 4, NOTBOL = 1 shl 7, 
    NOTEOL = 1 shl 8, NOTEMPTY = 1 shl 10, 
    PARTIAL = 1 shl 15, NEWLINE_CR = 1 shl 20, 
    NEWLINE_LF = 1 shl 21, NEWLINE_CRLF = GRegexMatchFlags.NEWLINE_CR.ord or
        GRegexMatchFlags.NEWLINE_LF.ord, NEWLINE_ANY = 1 shl 22, NEWLINE_ANYCRLF = GRegexMatchFlags.NEWLINE_CR.ord or
        GRegexMatchFlags.NEWLINE_ANY.ord, BSR_ANYCRLF = 1 shl 23, 
    BSR_ANY = 1 shl 24, 
    PARTIAL_HARD = 1 shl 27, 
    NOTEMPTY_ATSTART = 1 shl 28
const
  G_REGEX_MATCH_PARTIAL_SOFT = GRegexMatchFlags.PARTIAL 
type 
  GRegex* =  ptr GRegexObj
  GRegexPtr* = ptr GRegexObj
  GRegexObj* = object 
  
type 
  GMatchInfo* =  ptr GMatchInfoObj
  GMatchInfoPtr* = ptr GMatchInfoObj
  GMatchInfoObj* = object 
  
type 
  GRegexEvalCallback* = proc (match_info: GMatchInfo; result: GString; 
                              user_data: gpointer): gboolean {.cdecl.}
proc g_regex_new*(pattern: cstring; compile_options: GRegexCompileFlags; 
                  match_options: GRegexMatchFlags; error: var GError): GRegex {.
    importc: "g_regex_new", libglib.}
proc `ref`*(regex: GRegex): GRegex {.importc: "g_regex_ref", 
    libglib.}
proc unref*(regex: GRegex) {.importc: "g_regex_unref", libglib.}
proc get_pattern*(regex: GRegex): cstring {.
    importc: "g_regex_get_pattern", libglib.}
proc pattern*(regex: GRegex): cstring {.
    importc: "g_regex_get_pattern", libglib.}
proc get_max_backref*(regex: GRegex): gint {.
    importc: "g_regex_get_max_backref", libglib.}
proc max_backref*(regex: GRegex): gint {.
    importc: "g_regex_get_max_backref", libglib.}
proc get_capture_count*(regex: GRegex): gint {.
    importc: "g_regex_get_capture_count", libglib.}
proc capture_count*(regex: GRegex): gint {.
    importc: "g_regex_get_capture_count", libglib.}
proc get_has_cr_or_lf*(regex: GRegex): gboolean {.
    importc: "g_regex_get_has_cr_or_lf", libglib.}
proc has_cr_or_lf*(regex: GRegex): gboolean {.
    importc: "g_regex_get_has_cr_or_lf", libglib.}
proc get_max_lookbehind*(regex: GRegex): gint {.
    importc: "g_regex_get_max_lookbehind", libglib.}
proc max_lookbehind*(regex: GRegex): gint {.
    importc: "g_regex_get_max_lookbehind", libglib.}
proc get_string_number*(regex: GRegex; name: cstring): gint {.
    importc: "g_regex_get_string_number", libglib.}
proc string_number*(regex: GRegex; name: cstring): gint {.
    importc: "g_regex_get_string_number", libglib.}
proc g_regex_escape_string*(string: cstring; length: gint): cstring {.
    importc: "g_regex_escape_string", libglib.}
proc g_regex_escape_nul*(string: cstring; length: gint): cstring {.
    importc: "g_regex_escape_nul", libglib.}
proc get_compile_flags*(regex: GRegex): GRegexCompileFlags {.
    importc: "g_regex_get_compile_flags", libglib.}
proc compile_flags*(regex: GRegex): GRegexCompileFlags {.
    importc: "g_regex_get_compile_flags", libglib.}
proc get_match_flags*(regex: GRegex): GRegexMatchFlags {.
    importc: "g_regex_get_match_flags", libglib.}
proc match_flags*(regex: GRegex): GRegexMatchFlags {.
    importc: "g_regex_get_match_flags", libglib.}
proc g_regex_match_simple*(pattern: cstring; string: cstring; 
                           compile_options: GRegexCompileFlags; 
                           match_options: GRegexMatchFlags): gboolean {.
    importc: "g_regex_match_simple", libglib.}
proc match*(regex: GRegex; string: cstring; 
                    match_options: GRegexMatchFlags; 
                    match_info: var GMatchInfo): gboolean {.
    importc: "g_regex_match", libglib.}
proc match_full*(regex: GRegex; string: cstring; 
                         string_len: gssize; start_position: gint; 
                         match_options: GRegexMatchFlags; 
                         match_info: var GMatchInfo; error: var GError): gboolean {.
    importc: "g_regex_match_full", libglib.}
proc match_all*(regex: GRegex; string: cstring; 
                        match_options: GRegexMatchFlags; 
                        match_info: var GMatchInfo): gboolean {.
    importc: "g_regex_match_all", libglib.}
proc match_all_full*(regex: GRegex; string: cstring; 
                             string_len: gssize; start_position: gint; 
                             match_options: GRegexMatchFlags; 
                             match_info: var GMatchInfo; 
                             error: var GError): gboolean {.
    importc: "g_regex_match_all_full", libglib.}
proc g_regex_split_simple*(pattern: cstring; string: cstring; 
                           compile_options: GRegexCompileFlags; 
                           match_options: GRegexMatchFlags): cstringArray {.
    importc: "g_regex_split_simple", libglib.}
proc split*(regex: GRegex; string: cstring; 
                    match_options: GRegexMatchFlags): cstringArray {.
    importc: "g_regex_split", libglib.}
proc split_full*(regex: GRegex; string: cstring; 
                         string_len: gssize; start_position: gint; 
                         match_options: GRegexMatchFlags; max_tokens: gint; 
                         error: var GError): cstringArray {.
    importc: "g_regex_split_full", libglib.}
proc replace*(regex: GRegex; string: cstring; 
                      string_len: gssize; start_position: gint; 
                      replacement: cstring; match_options: GRegexMatchFlags; 
                      error: var GError): cstring {.
    importc: "g_regex_replace", libglib.}
proc replace_literal*(regex: GRegex; string: cstring; 
                              string_len: gssize; start_position: gint; 
                              replacement: cstring; 
                              match_options: GRegexMatchFlags; 
                              error: var GError): cstring {.
    importc: "g_regex_replace_literal", libglib.}
proc replace_eval*(regex: GRegex; string: cstring; 
                           string_len: gssize; start_position: gint; 
                           match_options: GRegexMatchFlags; 
                           eval: GRegexEvalCallback; user_data: gpointer; 
                           error: var GError): cstring {.
    importc: "g_regex_replace_eval", libglib.}
proc g_regex_check_replacement*(replacement: cstring; 
                                has_references: var gboolean; 
                                error: var GError): gboolean {.
    importc: "g_regex_check_replacement", libglib.}
proc get_regex*(match_info: GMatchInfo): GRegex {.
    importc: "g_match_info_get_regex", libglib.}
proc regex*(match_info: GMatchInfo): GRegex {.
    importc: "g_match_info_get_regex", libglib.}
proc get_string*(match_info: GMatchInfo): cstring {.
    importc: "g_match_info_get_string", libglib.}
proc `ref`*(match_info: GMatchInfo): GMatchInfo {.
    importc: "g_match_info_ref", libglib.}
proc unref*(match_info: GMatchInfo) {.
    importc: "g_match_info_unref", libglib.}
proc free*(match_info: GMatchInfo) {.
    importc: "g_match_info_free", libglib.}
proc next*(match_info: GMatchInfo; error: var GError): gboolean {.
    importc: "g_match_info_next", libglib.}
proc matches*(match_info: GMatchInfo): gboolean {.
    importc: "g_match_info_matches", libglib.}
proc get_match_count*(match_info: GMatchInfo): gint {.
    importc: "g_match_info_get_match_count", libglib.}
proc match_count*(match_info: GMatchInfo): gint {.
    importc: "g_match_info_get_match_count", libglib.}
proc is_partial_match*(match_info: GMatchInfo): gboolean {.
    importc: "g_match_info_is_partial_match", libglib.}
proc expand_references*(match_info: GMatchInfo; 
                                     string_to_expand: cstring; 
                                     error: var GError): cstring {.
    importc: "g_match_info_expand_references", libglib.}
proc fetch*(match_info: GMatchInfo; match_num: gint): cstring {.
    importc: "g_match_info_fetch", libglib.}
proc fetch_pos*(match_info: GMatchInfo; match_num: gint; 
                             start_pos: var gint; end_pos: var gint): gboolean {.
    importc: "g_match_info_fetch_pos", libglib.}
proc fetch_named*(match_info: GMatchInfo; name: cstring): cstring {.
    importc: "g_match_info_fetch_named", libglib.}
proc fetch_named_pos*(match_info: GMatchInfo; 
                                   name: cstring; start_pos: var gint; 
                                   end_pos: var gint): gboolean {.
    importc: "g_match_info_fetch_named_pos", libglib.}
proc fetch_all*(match_info: GMatchInfo): cstringArray {.
    importc: "g_match_info_fetch_all", libglib.}

 
const 
  G_CSET_A_2_Z_U* = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  G_CSET_a_2_z_L* = "abcdefghijklmnopqrstuvwxyz"
  G_CSET_DIGITS* = "0123456789"
  G_CSET_LATINC* = "\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD8\xD9\xDA\xDB\xDC\xDD\xDE"
  G_CSET_LATINS* = "\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF"
type 
  GErrorType* {.size: sizeof(cint), pure.} = enum 
    UNKNOWN, UNEXP_EOF, UNEXP_EOF_IN_STRING, 
    UNEXP_EOF_IN_COMMENT, NON_DIGIT_IN_CONST, DIGIT_RADIX, 
    FLOAT_RADIX, FLOAT_MALFORMED
type 
  GTokenType* {.size: sizeof(cint), pure.} = enum 
    EOF = 0, LEFT_PAREN = '(', RIGHT_PAREN = ')', 
    COMMA = ',',
    EQUAL_SIGN = '=',
    LEFT_BRACE = '[', RIGHT_BRACE = ']', 
    LEFT_CURLY = '{', RIGHT_CURLY = '}', 
    NONE = 256, 
    ERROR, CHAR, BINARY, OCTAL, INT, 
    HEX, FLOAT, STRING, SYMBOL, 
    IDENTIFIER, IDENTIFIER_NULL, COMMENT_SINGLE, 
    COMMENT_MULTI, LAST
type 
  GTokenValue* = object  {.union.}
    v_symbol*: gpointer
    v_identifier*: cstring
    v_binary*: gulong
    v_octal*: gulong
    v_int*: gulong
    v_int64*: guint64
    v_float*: gdouble
    v_hex*: gulong
    v_string*: cstring
    v_comment*: cstring
    v_char*: guchar
    v_error*: guint

type 
  GScannerConfig* =  ptr GScannerConfigObj
  GScannerConfigPtr* = ptr GScannerConfigObj
  GScannerConfigObj* = object 
    cset_skip_characters*: cstring
    cset_identifier_first*: cstring
    cset_identifier_nth*: cstring
    cpair_comment_single*: cstring
    bitfield0GScannerConfig*: guintwith32bitatleast
    padding_dummy: guint

type 
  GScannerMsgFunc* = proc (scanner: GScanner; message: cstring; 
                           error: gboolean) {.cdecl.}

  GScanner* =  ptr GScannerObj
  GScannerPtr* = ptr GScannerObj
  GScannerObj* = object 
    user_data*: gpointer
    max_parse_errors*: guint
    parse_errors*: guint
    input_name*: cstring
    qdata*: GData
    config*: GScannerConfig
    token*: GTokenType
    value*: GTokenValue
    line*: guint
    position*: guint
    next_token*: GTokenType
    next_value*: GTokenValue
    next_line*: guint
    next_position*: guint
    symbol_table*: GHashTable
    input_fd*: gint
    text*: cstring
    text_end*: cstring
    buffer*: cstring
    scope_id*: guint
    msg_handler*: GScannerMsgFunc

proc g_scanner_new*(config_templ: GScannerConfig): GScanner {.
    importc: "g_scanner_new", libglib.}
proc destroy*(scanner: GScanner) {.importc: "g_scanner_destroy", 
    libglib.}
proc input_file*(scanner: GScanner; input_fd: gint) {.
    importc: "g_scanner_input_file", libglib.}
proc sync_file_offset*(scanner: GScanner) {.
    importc: "g_scanner_sync_file_offset", libglib.}
proc input_text*(scanner: GScanner; text: cstring; 
                           text_len: guint) {.importc: "g_scanner_input_text", 
    libglib.}
proc get_next_token*(scanner: GScanner): GTokenType {.
    importc: "g_scanner_get_next_token", libglib.}
proc next_token*(scanner: GScanner): GTokenType {.
    importc: "g_scanner_get_next_token", libglib.}
proc peek_next_token*(scanner: GScanner): GTokenType {.
    importc: "g_scanner_peek_next_token", libglib.}
proc cur_token*(scanner: GScanner): GTokenType {.
    importc: "g_scanner_cur_token", libglib.}
proc cur_value*(scanner: GScanner): GTokenValue {.
    importc: "g_scanner_cur_value", libglib.}
proc cur_line*(scanner: GScanner): guint {.
    importc: "g_scanner_cur_line", libglib.}
proc cur_position*(scanner: GScanner): guint {.
    importc: "g_scanner_cur_position", libglib.}
proc eof*(scanner: GScanner): gboolean {.
    importc: "g_scanner_eof", libglib.}
proc set_scope*(scanner: GScanner; scope_id: guint): guint {.
    importc: "g_scanner_set_scope", libglib.}
proc scope_add_symbol*(scanner: GScanner; scope_id: guint; 
                                 symbol: cstring; value: gpointer) {.
    importc: "g_scanner_scope_add_symbol", libglib.}
proc scope_remove_symbol*(scanner: GScanner; scope_id: guint; 
                                    symbol: cstring) {.
    importc: "g_scanner_scope_remove_symbol", libglib.}
proc scope_lookup_symbol*(scanner: GScanner; scope_id: guint; 
                                    symbol: cstring): gpointer {.
    importc: "g_scanner_scope_lookup_symbol", libglib.}
proc scope_foreach_symbol*(scanner: GScanner; scope_id: guint; 
                                     `func`: GHFunc; user_data: gpointer) {.
    importc: "g_scanner_scope_foreach_symbol", libglib.}
proc lookup_symbol*(scanner: GScanner; symbol: cstring): gpointer {.
    importc: "g_scanner_lookup_symbol", libglib.}
proc unexp_token*(scanner: GScanner; expected_token: GTokenType; 
                            identifier_spec: cstring; 
                            symbol_spec: cstring; symbol_name: cstring; 
                            message: cstring; is_error: gint) {.
    importc: "g_scanner_unexp_token", libglib.}
proc error*(scanner: GScanner; format: cstring) {.varargs, 
    importc: "g_scanner_error", libglib.}
proc warn*(scanner: GScanner; format: cstring) {.varargs, 
    importc: "g_scanner_warn", libglib.}

type 
  GSequence* =  ptr GSequenceObj
  GSequencePtr* = ptr GSequenceObj
  GSequenceObj* = object 
  
  GSequenceIter* =  ptr GSequenceIterObj
  GSequenceIterPtr* = ptr GSequenceIterObj
  GSequenceIterObj* = object 
  
  GSequenceIterCompareFunc* = proc (a: GSequenceIter; 
                                    b: GSequenceIter; data: gpointer): gint {.cdecl.}
proc g_sequence_new*(data_destroy: GDestroyNotify): GSequence {.
    importc: "g_sequence_new", libglib.}
proc free*(seq: GSequence) {.importc: "g_sequence_free", 
    libglib.}
proc get_length*(seq: GSequence): gint {.
    importc: "g_sequence_get_length", libglib.}
proc length*(seq: GSequence): gint {.
    importc: "g_sequence_get_length", libglib.}
proc foreach*(seq: GSequence; `func`: GFunc; user_data: gpointer) {.
    importc: "g_sequence_foreach", libglib.}
proc foreach_range*(begin: GSequenceIter; 
                               `end`: GSequenceIter; `func`: GFunc; 
                               user_data: gpointer) {.
    importc: "g_sequence_foreach_range", libglib.}
proc sort*(seq: GSequence; cmp_func: GCompareDataFunc; 
                      cmp_data: gpointer) {.importc: "g_sequence_sort", 
    libglib.}
proc sort_iter*(seq: GSequence; 
                           cmp_func: GSequenceIterCompareFunc; 
                           cmp_data: gpointer) {.
    importc: "g_sequence_sort_iter", libglib.}
proc get_begin_iter*(seq: GSequence): GSequenceIter {.
    importc: "g_sequence_get_begin_iter", libglib.}
proc begin_iter*(seq: GSequence): GSequenceIter {.
    importc: "g_sequence_get_begin_iter", libglib.}
proc get_end_iter*(seq: GSequence): GSequenceIter {.
    importc: "g_sequence_get_end_iter", libglib.}
proc end_iter*(seq: GSequence): GSequenceIter {.
    importc: "g_sequence_get_end_iter", libglib.}
proc get_iter_at_pos*(seq: GSequence; pos: gint): GSequenceIter {.
    importc: "g_sequence_get_iter_at_pos", libglib.}
proc iter_at_pos*(seq: GSequence; pos: gint): GSequenceIter {.
    importc: "g_sequence_get_iter_at_pos", libglib.}
proc append*(seq: GSequence; data: gpointer): GSequenceIter {.
    importc: "g_sequence_append", libglib.}
proc prepend*(seq: GSequence; data: gpointer): GSequenceIter {.
    importc: "g_sequence_prepend", libglib.}
proc insert_before*(iter: GSequenceIter; data: gpointer): GSequenceIter {.
    importc: "g_sequence_insert_before", libglib.}
proc move*(src: GSequenceIter; dest: GSequenceIter) {.
    importc: "g_sequence_move", libglib.}
proc swap*(a: GSequenceIter; b: GSequenceIter) {.
    importc: "g_sequence_swap", libglib.}
proc insert_sorted*(seq: GSequence; data: gpointer; 
                               cmp_func: GCompareDataFunc; cmp_data: gpointer): GSequenceIter {.
    importc: "g_sequence_insert_sorted", libglib.}
proc insert_sorted_iter*(seq: GSequence; data: gpointer; 
                                    iter_cmp: GSequenceIterCompareFunc; 
                                    cmp_data: gpointer): GSequenceIter {.
    importc: "g_sequence_insert_sorted_iter", libglib.}
proc sort_changed*(iter: GSequenceIter; 
                              cmp_func: GCompareDataFunc; cmp_data: gpointer) {.
    importc: "g_sequence_sort_changed", libglib.}
proc sort_changed_iter*(iter: GSequenceIter; 
                                   iter_cmp: GSequenceIterCompareFunc; 
                                   cmp_data: gpointer) {.
    importc: "g_sequence_sort_changed_iter", libglib.}
proc remove*(iter: GSequenceIter) {.
    importc: "g_sequence_remove", libglib.}
proc remove_range*(begin: GSequenceIter; `end`: GSequenceIter) {.
    importc: "g_sequence_remove_range", libglib.}
proc move_range*(dest: GSequenceIter; begin: GSequenceIter; 
                            `end`: GSequenceIter) {.
    importc: "g_sequence_move_range", libglib.}
proc search*(seq: GSequence; data: gpointer; 
                        cmp_func: GCompareDataFunc; cmp_data: gpointer): GSequenceIter {.
    importc: "g_sequence_search", libglib.}
proc search_iter*(seq: GSequence; data: gpointer; 
                             iter_cmp: GSequenceIterCompareFunc; 
                             cmp_data: gpointer): GSequenceIter {.
    importc: "g_sequence_search_iter", libglib.}
proc lookup*(seq: GSequence; data: gpointer; 
                        cmp_func: GCompareDataFunc; cmp_data: gpointer): GSequenceIter {.
    importc: "g_sequence_lookup", libglib.}
proc lookup_iter*(seq: GSequence; data: gpointer; 
                             iter_cmp: GSequenceIterCompareFunc; 
                             cmp_data: gpointer): GSequenceIter {.
    importc: "g_sequence_lookup_iter", libglib.}
proc get*(iter: GSequenceIter): gpointer {.
    importc: "g_sequence_get", libglib.}
proc set*(iter: GSequenceIter; data: gpointer) {.
    importc: "g_sequence_set", libglib.}
proc is_begin*(iter: GSequenceIter): gboolean {.
    importc: "g_sequence_iter_is_begin", libglib.}
proc is_end*(iter: GSequenceIter): gboolean {.
    importc: "g_sequence_iter_is_end", libglib.}
proc next*(iter: GSequenceIter): GSequenceIter {.
    importc: "g_sequence_iter_next", libglib.}
proc prev*(iter: GSequenceIter): GSequenceIter {.
    importc: "g_sequence_iter_prev", libglib.}
proc get_position*(iter: GSequenceIter): gint {.
    importc: "g_sequence_iter_get_position", libglib.}
proc position*(iter: GSequenceIter): gint {.
    importc: "g_sequence_iter_get_position", libglib.}
proc move*(iter: GSequenceIter; delta: gint): GSequenceIter {.
    importc: "g_sequence_iter_move", libglib.}
proc get_sequence*(iter: GSequenceIter): GSequence {.
    importc: "g_sequence_iter_get_sequence", libglib.}
proc sequence*(iter: GSequenceIter): GSequence {.
    importc: "g_sequence_iter_get_sequence", libglib.}
proc compare*(a: GSequenceIter; b: GSequenceIter): gint {.
    importc: "g_sequence_iter_compare", libglib.}
proc range_get_midpoint*(begin: GSequenceIter; 
                                    `end`: GSequenceIter): GSequenceIter {.
    importc: "g_sequence_range_get_midpoint", libglib.}

type 
  GShellError* {.size: sizeof(cint), pure.} = enum 
    BAD_QUOTING, EMPTY_STRING, 
    FAILED
proc g_shell_error_quark*(): GQuark {.importc: "g_shell_error_quark", 
                                      libglib.}
proc g_shell_quote*(unquoted_string: cstring): cstring {.
    importc: "g_shell_quote", libglib.}
proc g_shell_unquote*(quoted_string: cstring; error: var GError): cstring {.
    importc: "g_shell_unquote", libglib.}
proc g_shell_parse_argv*(command_line: cstring; argcp: ptr gint; 
                         argvp: ptr cstringArray; error: var GError): gboolean {.
    importc: "g_shell_parse_argv", libglib.}

proc g_slice_alloc*(block_size: gsize): gpointer {.importc: "g_slice_alloc", 
    libglib.}
proc g_slice_alloc0*(block_size: gsize): gpointer {.importc: "g_slice_alloc0", 
    libglib.}
proc g_slice_copy*(block_size: gsize; mem_block: gconstpointer): gpointer {.
    importc: "g_slice_copy", libglib.}
proc g_slice_free1*(block_size: gsize; mem_block: gpointer) {.
    importc: "g_slice_free1", libglib.}
proc g_slice_free_chain_with_offset*(block_size: gsize; mem_chain: gpointer; 
                                     next_offset: gsize) {.
    importc: "g_slice_free_chain_with_offset", libglib.}

type 
  GSliceConfig* {.size: sizeof(cint), pure.} = enum 
    ALWAYS_MALLOC = 1, BYPASS_MAGAZINES, 
    WORKING_SET_MSECS, COLOR_INCREMENT, 
    CHUNK_SIZES, CONTENTION_COUNTER
proc g_slice_set_config*(ckey: GSliceConfig; value: gint64) {.
    importc: "g_slice_set_config", libglib.}
proc g_slice_get_config*(ckey: GSliceConfig): gint64 {.
    importc: "g_slice_get_config", libglib.}
proc g_slice_get_config_state*(ckey: GSliceConfig; address: gint64; 
                               n_values: var guint): ptr gint64 {.
    importc: "g_slice_get_config_state", libglib.}
when false: # when defined(G_ENABLE_DEBUG): 
  proc g_slice_debug_tree_statistics*() {.
      importc: "g_slice_debug_tree_statistics", libglib.}

type 
  GSpawnError* {.size: sizeof(cint), pure.} = enum 
    FORK, READ, CHDIR, 
    ACCES, PERM, TOO_BIG, 
    NOEXEC, NAMETOOLONG, NOENT, 
    NOMEM, NOTDIR, LOOP, 
    TXTBUSY, IO, NFILE, 
    MFILE, INVAL, ISDIR, 
    LIBBAD, FAILED
type 
  GSpawnChildSetupFunc* = proc (user_data: gpointer) {.cdecl.}
type 
  GSpawnFlags* {.size: sizeof(cint), pure.} = enum 
    DEFAULT = 0, LEAVE_DESCRIPTORS_OPEN = 1 shl 0, 
    DO_NOT_REAP_CHILD = 1 shl 1, SEARCH_PATH = 1 shl 2, 
    STDOUT_TO_DEV_NULL = 1 shl 3, 
    STDERR_TO_DEV_NULL = 1 shl 4, 
    CHILD_INHERITS_STDIN = 1 shl 5, 
    FILE_AND_ARGV_ZERO = 1 shl 6, 
    SEARCH_PATH_FROM_ENVP = 1 shl 7, CLOEXEC_PIPES = 1 shl
        8
proc g_spawn_error_quark*(): GQuark {.importc: "g_spawn_error_quark", 
                                      libglib.}
proc g_spawn_exit_error_quark*(): GQuark {.
    importc: "g_spawn_exit_error_quark", libglib.}
proc g_spawn_check_exit_status*(exit_status: gint; error: var GError): gboolean {.
    importc: "g_spawn_check_exit_status", libglib.}
proc g_spawn_close_pid*(pid: GPid) {.importc: "g_spawn_close_pid", libglib.}
when defined(windows): 
  proc g_spawn_async_utf8*(working_directory: cstring; argv: cstringArray; 
                           envp: cstringArray; flags: GSpawnFlags; 
                           child_setup: GSpawnChildSetupFunc; 
                           user_data: gpointer; child_pid: ptr GPid; 
                           error: var GError): gboolean {.
      importc: "g_spawn_async_utf8", libglib.}
  proc g_spawn_async_with_pipes_utf8*(working_directory: cstring; 
                                      argv: cstringArray; 
                                      envp: cstringArray; flags: GSpawnFlags; 
                                      child_setup: GSpawnChildSetupFunc; 
                                      user_data: gpointer; 
                                      child_pid: ptr GPid; 
                                      standard_input: ptr gint; 
                                      standard_output: ptr gint; 
                                      standard_error: var gint; 
                                      error: var GError): gboolean {.
      importc: "g_spawn_async_with_pipes_utf8", libglib.}
  proc g_spawn_sync_utf8*(working_directory: cstring; argv: cstringArray; 
                          envp: cstringArray; flags: GSpawnFlags; 
                          child_setup: GSpawnChildSetupFunc; 
                          user_data: gpointer; standard_output: cstringArray; 
                          standard_error: cstringArray; 
                          exit_status: var gint; error: var GError): gboolean {.
      importc: "g_spawn_sync_utf8", libglib.}
  proc g_spawn_command_line_sync_utf8*(command_line: cstring; 
      standard_output: cstringArray; standard_error: cstringArray; 
      exit_status: var gint; error: var GError): gboolean {.
      importc: "g_spawn_command_line_sync_utf8", libglib.}
  proc g_spawn_command_line_async_utf8*(command_line: cstring; 
      error: var GError): gboolean {.
      importc: "g_spawn_command_line_async_utf8", libglib.}
  const 
    g_spawn_async* = g_spawn_async_utf8
    g_spawn_async_with_pipes* = g_spawn_async_with_pipes_utf8
    g_spawn_sync* = g_spawn_sync_utf8
    g_spawn_command_line_sync* = g_spawn_command_line_sync_utf8
    g_spawn_command_line_async* = g_spawn_command_line_async_utf8
else:
  proc g_spawn_async*(working_directory: cstring; argv: cstringArray; 
                      envp: cstringArray; flags: GSpawnFlags; 
                      child_setup: GSpawnChildSetupFunc; user_data: gpointer; 
                      child_pid: ptr GPid; error: var GError): gboolean {.
      importc: "g_spawn_async", libglib.}
  proc g_spawn_async_with_pipes*(working_directory: cstring; 
                                 argv: cstringArray; envp: cstringArray; 
                                 flags: GSpawnFlags; 
                                 child_setup: GSpawnChildSetupFunc; 
                                 user_data: gpointer; child_pid: ptr GPid; 
                                 standard_input: ptr gint; 
                                 standard_output: ptr gint; 
                                 standard_error: var gint; error: var GError): gboolean {.
      importc: "g_spawn_async_with_pipes", libglib.}
  proc g_spawn_sync*(working_directory: cstring; argv: cstringArray; 
                     envp: cstringArray; flags: GSpawnFlags; 
                     child_setup: GSpawnChildSetupFunc; user_data: gpointer; 
                     standard_output: cstringArray; 
                     standard_error: cstringArray; exit_status: var gint; 
                     error: var GError): gboolean {.importc: "g_spawn_sync", 
      libglib.}
  proc g_spawn_command_line_sync*(command_line: cstring; 
                                  standard_output: cstringArray; 
                                  standard_error: cstringArray; 
                                  exit_status: var gint; error: var GError): gboolean {.
      importc: "g_spawn_command_line_sync", libglib.}
  proc g_spawn_command_line_async*(command_line: cstring; 
                                   error: var GError): gboolean {.
      importc: "g_spawn_command_line_async", libglib.}

type 
  GAsciiType* {.size: sizeof(cint), pure.} = enum 
    ALNUM = 1 shl 0, ALPHA = 1 shl 1, CNTRL = 1 shl
        2, DIGIT = 1 shl 3, GRAPH = 1 shl 4, 
    LOWER = 1 shl 5, PRINT = 1 shl 6, PUNCT = 1 shl
        7, SPACE = 1 shl 8, UPPER = 1 shl 9, 
    XDIGIT = 1 shl 10
var g_ascii_table: array[256, int16]

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

proc g_ascii_tolower*(c: gchar): gchar {.importc: "g_ascii_tolower", 
    libglib.}
proc g_ascii_toupper*(c: gchar): gchar {.importc: "g_ascii_toupper", 
    libglib.}
proc g_ascii_digit_value*(c: gchar): gint {.importc: "g_ascii_digit_value", 
    libglib.}
proc g_ascii_xdigit_value*(c: gchar): gint {.importc: "g_ascii_xdigit_value", 
    libglib.}
const 
  G_STR_DELIMITERS* = "_-|> <."
proc g_strdelimit*(string: cstring; delimiters: cstring; 
                   new_delimiter: gchar): cstring {.importc: "g_strdelimit", 
    libglib.}
proc g_strcanon*(string: cstring; valid_chars: cstring; substitutor: gchar): cstring {.
    importc: "g_strcanon", libglib.}
proc g_strerror*(errnum: gint): cstring {.importc: "g_strerror", libglib.}
proc g_strsignal*(signum: gint): cstring {.importc: "g_strsignal", 
    libglib.}
proc g_strreverse*(string: cstring): cstring {.importc: "g_strreverse", 
    libglib.}
proc g_strlcpy*(dest: cstring; src: cstring; dest_size: gsize): gsize {.
    importc: "g_strlcpy", libglib.}
proc g_strlcat*(dest: cstring; src: cstring; dest_size: gsize): gsize {.
    importc: "g_strlcat", libglib.}
proc g_strstr_len*(haystack: cstring; haystack_len: gssize; 
                   needle: cstring): cstring {.importc: "g_strstr_len", 
    libglib.}
proc g_strrstr*(haystack: cstring; needle: cstring): cstring {.
    importc: "g_strrstr", libglib.}
proc g_strrstr_len*(haystack: cstring; haystack_len: gssize; 
                    needle: cstring): cstring {.importc: "g_strrstr_len", 
    libglib.}
proc g_str_has_suffix*(str: cstring; suffix: cstring): gboolean {.
    importc: "g_str_has_suffix", libglib.}
proc g_str_has_prefix*(str: cstring; prefix: cstring): gboolean {.
    importc: "g_str_has_prefix", libglib.}
proc g_strtod*(nptr: cstring; endptr: cstringArray): gdouble {.
    importc: "g_strtod", libglib.}
proc g_ascii_strtod*(nptr: cstring; endptr: cstringArray): gdouble {.
    importc: "g_ascii_strtod", libglib.}
proc g_ascii_strtoull*(nptr: cstring; endptr: cstringArray; base: guint): guint64 {.
    importc: "g_ascii_strtoull", libglib.}
proc g_ascii_strtoll*(nptr: cstring; endptr: cstringArray; base: guint): gint64 {.
    importc: "g_ascii_strtoll", libglib.}
const 
  G_ASCII_DTOSTR_BUF_SIZE* = (29 + 10)
proc g_ascii_dtostr*(buffer: cstring; buf_len: gint; d: gdouble): cstring {.
    importc: "g_ascii_dtostr", libglib.}
proc g_ascii_formatd*(buffer: cstring; buf_len: gint; format: cstring; 
                      d: gdouble): cstring {.importc: "g_ascii_formatd", 
    libglib.}
proc g_strchug*(string: cstring): cstring {.importc: "g_strchug", 
    libglib.}
proc g_strchomp*(string: cstring): cstring {.importc: "g_strchomp", 
    libglib.}
template g_strstrip*(string: expr): expr = 
  g_strchomp(g_strchug(string))

proc g_ascii_strcasecmp*(s1: cstring; s2: cstring): gint {.
    importc: "g_ascii_strcasecmp", libglib.}
proc g_ascii_strncasecmp*(s1: cstring; s2: cstring; n: gsize): gint {.
    importc: "g_ascii_strncasecmp", libglib.}
proc g_ascii_strdown*(str: cstring; len: gssize): cstring {.
    importc: "g_ascii_strdown", libglib.}
proc g_ascii_strup*(str: cstring; len: gssize): cstring {.
    importc: "g_ascii_strup", libglib.}
proc g_str_is_ascii*(str: cstring): gboolean {.importc: "g_str_is_ascii", 
    libglib.}
proc g_strcasecmp*(s1: cstring; s2: cstring): gint {.
    importc: "g_strcasecmp", libglib.}
proc g_strncasecmp*(s1: cstring; s2: cstring; n: guint): gint {.
    importc: "g_strncasecmp", libglib.}
proc g_strdown*(string: cstring): cstring {.importc: "g_strdown", 
    libglib.}
proc g_strup*(string: cstring): cstring {.importc: "g_strup", libglib.}
proc g_strdup*(str: cstring): cstring {.importc: "g_strdup", libglib.}
proc g_strdup_printf*(format: cstring): cstring {.varargs, 
    importc: "g_strdup_printf", libglib.}
when Va_List_Works:
  proc g_strdup_vprintf*(format: cstring; args: va_list): cstring {.
      importc: "g_strdup_vprintf", libglib.}
proc g_strndup*(str: cstring; n: gsize): cstring {.importc: "g_strndup", 
    libglib.}
proc g_strnfill*(length: gsize; fill_char: gchar): cstring {.
    importc: "g_strnfill", libglib.}
proc g_strconcat*(string1: cstring): cstring {.varargs, 
    importc: "g_strconcat", libglib.}
proc g_strjoin*(separator: cstring): cstring {.varargs, 
    importc: "g_strjoin", libglib.}
proc g_strcompress*(source: cstring): cstring {.importc: "g_strcompress", 
    libglib.}
proc g_strescape*(source: cstring; exceptions: cstring): cstring {.
    importc: "g_strescape", libglib.}
proc g_memdup*(mem: gconstpointer; byte_size: guint): gpointer {.
    importc: "g_memdup", libglib.}
proc g_strsplit*(string: cstring; delimiter: cstring; max_tokens: gint): cstringArray {.
    importc: "g_strsplit", libglib.}
proc g_strsplit_set*(string: cstring; delimiters: cstring; 
                     max_tokens: gint): cstringArray {.
    importc: "g_strsplit_set", libglib.}
proc g_strjoinv*(separator: cstring; str_array: cstringArray): cstring {.
    importc: "g_strjoinv", libglib.}
proc g_strfreev*(str_array: cstringArray) {.importc: "g_strfreev", 
    libglib.}
proc g_strdupv*(str_array: cstringArray): cstringArray {.
    importc: "g_strdupv", libglib.}
proc g_strv_length*(str_array: cstringArray): guint {.
    importc: "g_strv_length", libglib.}
proc g_stpcpy*(dest: cstring; src: cstring): cstring {.
    importc: "g_stpcpy", libglib.}
proc g_str_to_ascii*(str: cstring; from_locale: cstring): cstring {.
    importc: "g_str_to_ascii", libglib.}
proc g_str_tokenize_and_fold*(string: cstring; translit_locale: cstring; 
                              ascii_alternates: ptr cstringArray): cstringArray {.
    importc: "g_str_tokenize_and_fold", libglib.}
proc g_str_match_string*(search_term: cstring; potential_hit: cstring; 
                         accept_alternates: gboolean): gboolean {.
    importc: "g_str_match_string", libglib.}

type 
  GStringChunk* =  ptr GStringChunkObj
  GStringChunkPtr* = ptr GStringChunkObj
  GStringChunkObj* = object 
  
proc g_string_chunk_new*(size: gsize): GStringChunk {.
    importc: "g_string_chunk_new", libglib.}
proc free*(chunk: GStringChunk) {.
    importc: "g_string_chunk_free", libglib.}
proc clear*(chunk: GStringChunk) {.
    importc: "g_string_chunk_clear", libglib.}
proc insert*(chunk: GStringChunk; string: cstring): cstring {.
    importc: "g_string_chunk_insert", libglib.}
proc insert_len*(chunk: GStringChunk; string: cstring; 
                                len: gssize): cstring {.
    importc: "g_string_chunk_insert_len", libglib.}
proc insert_const*(chunk: GStringChunk; string: cstring): cstring {.
    importc: "g_string_chunk_insert_const", libglib.}

type 
  GTestCase* =  ptr GTestCaseObj
  GTestCasePtr* = ptr GTestCaseObj
  GTestCaseObj* = object 
  
  GTestSuite* =  ptr GTestSuiteObj
  GTestSuitePtr* = ptr GTestSuiteObj
  GTestSuiteObj* = object 
  
  GTestFunc* = proc () {.cdecl.}
  GTestDataFunc* = proc (user_data: gconstpointer) {.cdecl.}
  GTestFixtureFunc* = proc (fixture: gpointer; user_data: gconstpointer) {.cdecl.}
proc g_strcmp0*(str1: cstring; str2: cstring): cint {.importc: "g_strcmp0", 
    libglib.}
proc g_test_minimized_result*(minimized_quantity: cdouble; format: cstring) {.
    varargs, importc: "g_test_minimized_result", libglib.}
proc g_test_maximized_result*(maximized_quantity: cdouble; format: cstring) {.
    varargs, importc: "g_test_maximized_result", libglib.}
proc g_test_init*(argc: ptr cint; argv: ptr cstringArray) {.varargs, 
    importc: "g_test_init", libglib.}

proc g_test_subprocess*(): gboolean {.importc: "g_test_subprocess", 
                                      libglib.}
proc g_test_run*(): cint {.importc: "g_test_run", libglib.}
proc g_test_add_func*(testpath: cstring; test_func: GTestFunc) {.
    importc: "g_test_add_func", libglib.}
proc g_test_add_data_func*(testpath: cstring; test_data: gconstpointer; 
                           test_func: GTestDataFunc) {.
    importc: "g_test_add_data_func", libglib.}
proc g_test_add_data_func_full*(testpath: cstring; test_data: gpointer; 
                                test_func: GTestDataFunc; 
                                data_free_func: GDestroyNotify) {.
    importc: "g_test_add_data_func_full", libglib.}
proc g_test_fail*() {.importc: "g_test_fail", libglib.}
proc g_test_incomplete*(msg: cstring) {.importc: "g_test_incomplete", 
    libglib.}
proc g_test_skip*(msg: cstring) {.importc: "g_test_skip", libglib.}
proc g_test_failed*(): gboolean {.importc: "g_test_failed", libglib.}
proc g_test_set_nonfatal_assertions*() {.
    importc: "g_test_set_nonfatal_assertions", libglib.}
proc g_test_message*(format: cstring) {.varargs, importc: "g_test_message", 
    libglib.}
proc g_test_bug_base*(uri_pattern: cstring) {.importc: "g_test_bug_base", 
    libglib.}
proc g_test_bug*(bug_uri_snippet: cstring) {.importc: "g_test_bug", 
    libglib.}
proc g_test_timer_start*() {.importc: "g_test_timer_start", libglib.}
proc g_test_timer_elapsed*(): cdouble {.importc: "g_test_timer_elapsed", 
    libglib.}
proc g_test_timer_last*(): cdouble {.importc: "g_test_timer_last", libglib.}
proc g_test_queue_free*(gfree_pointer: gpointer) {.
    importc: "g_test_queue_free", libglib.}
proc g_test_queue_destroy*(destroy_func: GDestroyNotify; 
                           destroy_data: gpointer) {.
    importc: "g_test_queue_destroy", libglib.}
template g_test_queue_unref*(gobject: expr): expr = 
  g_test_queue_destroy(g_object_unref, gobject)

type 
  GTestTrapFlags* {.size: sizeof(cint), pure.} = enum 
    SILENCE_STDOUT = 1 shl 7, 
    SILENCE_STDERR = 1 shl 8, INHERIT_STDIN = 1 shl
        9
proc g_test_trap_fork*(usec_timeout: guint64; test_trap_flags: GTestTrapFlags): gboolean {.
    importc: "g_test_trap_fork", libglib.}
type 
  GTestSubprocessFlags* {.size: sizeof(cint), pure.} = enum 
    INHERIT_STDIN = 1 shl 0, 
    INHERIT_STDOUT = 1 shl 1, 
    INHERIT_STDERR = 1 shl 2
proc g_test_trap_subprocess*(test_path: cstring; usec_timeout: guint64; 
                             test_flags: GTestSubprocessFlags) {.
    importc: "g_test_trap_subprocess", libglib.}
proc g_test_trap_has_passed*(): gboolean {.importc: "g_test_trap_has_passed", 
    libglib.}
proc g_test_trap_reached_timeout*(): gboolean {.
    importc: "g_test_trap_reached_timeout", libglib.}
template g_test_rand_bit*(): expr = 
  (0 != (g_test_rand_int() and (1 shl 15)))

proc g_test_rand_int*(): gint32 {.importc: "g_test_rand_int", libglib.}
proc g_test_rand_int_range*(begin: gint32; `end`: gint32): gint32 {.
    importc: "g_test_rand_int_range", libglib.}
proc g_test_rand_double*(): cdouble {.importc: "g_test_rand_double", 
                                      libglib.}
proc g_test_rand_double_range*(range_start: cdouble; range_end: cdouble): cdouble {.
    importc: "g_test_rand_double_range", libglib.}
proc g_test_create_case*(test_name: cstring; data_size: gsize; 
                         test_data: gconstpointer; 
                         data_setup: GTestFixtureFunc; 
                         data_test: GTestFixtureFunc; 
                         data_teardown: GTestFixtureFunc): GTestCase {.
    importc: "g_test_create_case", libglib.}
proc g_test_create_suite*(suite_name: cstring): GTestSuite {.
    importc: "g_test_create_suite", libglib.}
proc g_test_get_root*(): GTestSuite {.importc: "g_test_get_root", 
    libglib.}
proc add*(suite: GTestSuite; test_case: GTestCase) {.
    importc: "g_test_suite_add", libglib.}
proc add_suite*(suite: GTestSuite; 
                             nestedsuite: GTestSuite) {.
    importc: "g_test_suite_add_suite", libglib.}
proc g_test_run_suite*(suite: GTestSuite): cint {.
    importc: "g_test_run_suite", libglib.}
proc g_test_trap_assertions*(domain: cstring; file: cstring; line: cint; 
                             `func`: cstring; assertion_flags: guint64; 
                             pattern: cstring) {.
    importc: "g_test_trap_assertions", libglib.}
proc g_assertion_message*(domain: cstring; file: cstring; line: cint; 
                          `func`: cstring; message: cstring) {.
    importc: "g_assertion_message", libglib.}
proc g_assertion_message_expr*(domain: cstring; file: cstring; line: cint; 
                               `func`: cstring; expr: cstring) {.
    importc: "g_assertion_message_expr", libglib.}
proc g_assertion_message_cmpstr*(domain: cstring; file: cstring; line: cint; 
                                 `func`: cstring; expr: cstring; arg1: cstring; 
                                 cmp: cstring; arg2: cstring) {.
    importc: "g_assertion_message_cmpstr", libglib.}
proc g_assertion_message_cmpnum*(domain: cstring; file: cstring; line: cint; 
                                 `func`: cstring; expr: cstring; 
                                 arg1: clongdouble; cmp: cstring; 
                                 arg2: clongdouble; numtype: char) {.
    importc: "g_assertion_message_cmpnum", libglib.}
proc g_assertion_message_error*(domain: cstring; file: cstring; line: cint; 
                                `func`: cstring; expr: cstring; 
                                error: GError; error_domain: GQuark; 
                                error_code: cint) {.
    importc: "g_assertion_message_error", libglib.}
proc g_test_add_vtable*(testpath: cstring; data_size: gsize; 
                        test_data: gconstpointer; 
                        data_setup: GTestFixtureFunc; 
                        data_test: GTestFixtureFunc; 
                        data_teardown: GTestFixtureFunc) {.
    importc: "g_test_add_vtable", libglib.}
type 
  GTestConfig* =  ptr GTestConfigObj
  GTestConfigPtr* = ptr GTestConfigObj
  GTestConfigObj* = object 
    test_initialized*: gboolean
    test_quick*: gboolean
    test_perf*: gboolean
    test_verbose*: gboolean
    test_quiet*: gboolean
    test_undefined*: gboolean

type 
  GTestLogType* {.size: sizeof(cint), pure.} = enum 
    NONE, ERROR, START_BINARY, 
    LIST_CASE, SKIP_CASE, START_CASE, 
    STOP_CASE, MIN_RESULT, MAX_RESULT, 
    MESSAGE, START_SUITE, STOP_SUITE
  GTestLogMsg* =  ptr GTestLogMsgObj
  GTestLogMsgPtr* = ptr GTestLogMsgObj
  GTestLogMsgObj* = object 
    log_type*: GTestLogType
    n_strings*: guint
    strings*: cstringArray
    n_nums*: guint
    nums*: ptr clongdouble

  GTestLogBuffer* =  ptr GTestLogBufferObj
  GTestLogBufferPtr* = ptr GTestLogBufferObj
  GTestLogBufferObj* = object 
    data*: GString
    msgs*: GSList

proc name*(log_type: GTestLogType): cstring {.
    importc: "g_test_log_type_name", libglib.}
proc g_test_log_buffer_new*(): GTestLogBuffer {.
    importc: "g_test_log_buffer_new", libglib.}
proc free*(tbuffer: GTestLogBuffer) {.
    importc: "g_test_log_buffer_free", libglib.}
proc push*(tbuffer: GTestLogBuffer; n_bytes: guint; 
                             bytes: var guint8) {.
    importc: "g_test_log_buffer_push", libglib.}
proc pop*(tbuffer: GTestLogBuffer): GTestLogMsg {.
    importc: "g_test_log_buffer_pop", libglib.}
proc free*(tmsg: GTestLogMsg) {.
    importc: "g_test_log_msg_free", libglib.}
type 
  GTestLogFatalFunc* = proc (log_domain: cstring; log_level: GLogLevelFlags; 
                             message: cstring; user_data: gpointer): gboolean {.cdecl.}
proc g_test_log_set_fatal_handler*(log_func: GTestLogFatalFunc; 
                                   user_data: gpointer) {.
    importc: "g_test_log_set_fatal_handler", libglib.}
proc g_test_expect_message*(log_domain: cstring; log_level: GLogLevelFlags; 
                            pattern: cstring) {.
    importc: "g_test_expect_message", libglib.}
proc g_test_assert_expected_messages_internal*(domain: cstring; file: cstring; 
    line: cint; `func`: cstring) {.importc: "g_test_assert_expected_messages_internal", 
                                 libglib.}
type 
  GTestFileType* {.size: sizeof(cint), pure.} = enum 
    DIST, BUILT
proc g_test_build_filename*(file_type: GTestFileType; first_path: cstring): cstring {.
    varargs, importc: "g_test_build_filename", libglib.}
proc g_test_get_dir*(file_type: GTestFileType): cstring {.
    importc: "g_test_get_dir", libglib.}
proc g_test_get_filename*(file_type: GTestFileType; first_path: cstring): cstring {.
    varargs, importc: "g_test_get_filename", libglib.}
template g_test_assert_expected_messages*(): expr = 
  g_test_assert_expected_messages_internal(G_LOG_DOMAIN, FILE, LINE, 
      G_STRFUNC)

type 
  GThreadPool* =  ptr GThreadPoolObj
  GThreadPoolPtr* = ptr GThreadPoolObj
  GThreadPoolObj* = object 
    `func`*: GFunc
    user_data*: gpointer
    exclusive*: gboolean

proc g_thread_pool_new*(`func`: GFunc; user_data: gpointer; max_threads: gint; 
                        exclusive: gboolean; error: var GError): GThreadPool {.
    importc: "g_thread_pool_new", libglib.}
proc free*(pool: GThreadPool; immediate: gboolean; 
                         wait: gboolean) {.importc: "g_thread_pool_free", 
    libglib.}
proc push*(pool: GThreadPool; data: gpointer; 
                         error: var GError): gboolean {.
    importc: "g_thread_pool_push", libglib.}
proc unprocessed*(pool: GThreadPool): guint {.
    importc: "g_thread_pool_unprocessed", libglib.}
proc set_sort_function*(pool: GThreadPool; 
                                      `func`: GCompareDataFunc; 
                                      user_data: gpointer) {.
    importc: "g_thread_pool_set_sort_function", libglib.}
proc `sort_function=`*(pool: GThreadPool; 
                                      `func`: GCompareDataFunc; 
                                      user_data: gpointer) {.
    importc: "g_thread_pool_set_sort_function", libglib.}
proc set_max_threads*(pool: GThreadPool; max_threads: gint; 
                                    error: var GError): gboolean {.
    importc: "g_thread_pool_set_max_threads", libglib.}
proc get_max_threads*(pool: GThreadPool): gint {.
    importc: "g_thread_pool_get_max_threads", libglib.}
proc max_threads*(pool: GThreadPool): gint {.
    importc: "g_thread_pool_get_max_threads", libglib.}
proc get_num_threads*(pool: GThreadPool): guint {.
    importc: "g_thread_pool_get_num_threads", libglib.}
proc num_threads*(pool: GThreadPool): guint {.
    importc: "g_thread_pool_get_num_threads", libglib.}
proc g_thread_pool_set_max_unused_threads*(max_threads: gint) {.
    importc: "g_thread_pool_set_max_unused_threads", libglib.}
proc g_thread_pool_get_max_unused_threads*(): gint {.
    importc: "g_thread_pool_get_max_unused_threads", libglib.}
proc g_thread_pool_get_num_unused_threads*(): guint {.
    importc: "g_thread_pool_get_num_unused_threads", libglib.}
proc g_thread_pool_stop_unused_threads*() {.
    importc: "g_thread_pool_stop_unused_threads", libglib.}
proc g_thread_pool_set_max_idle_time*(interval: guint) {.
    importc: "g_thread_pool_set_max_idle_time", libglib.}
proc g_thread_pool_get_max_idle_time*(): guint {.
    importc: "g_thread_pool_get_max_idle_time", libglib.}

type 
  GTimer* =  ptr GTimerObj
  GTimerPtr* = ptr GTimerObj
  GTimerObj* = object 
  
const 
  G_USEC_PER_SEC* = 1000000
proc g_timer_new*(): GTimer {.importc: "g_timer_new", libglib.}
proc destroy*(timer: GTimer) {.importc: "g_timer_destroy", 
    libglib.}
proc start*(timer: GTimer) {.importc: "g_timer_start", libglib.}
proc stop*(timer: GTimer) {.importc: "g_timer_stop", libglib.}
proc reset*(timer: GTimer) {.importc: "g_timer_reset", libglib.}
proc `continue`*(timer: GTimer) {.importc: "g_timer_continue", 
    libglib.}
proc elapsed*(timer: GTimer; microseconds: ptr gulong): gdouble {.
    importc: "g_timer_elapsed", libglib.}
proc g_usleep*(microseconds: gulong) {.importc: "g_usleep", libglib.}
proc add*(time: GTimeVal; microseconds: glong) {.
    importc: "g_time_val_add", libglib.}
proc g_time_val_from_iso8601*(iso_date: cstring; time: GTimeVal): gboolean {.
    importc: "g_time_val_from_iso8601", libglib.}
proc to_iso8601*(time: GTimeVal): cstring {.
    importc: "g_time_val_to_iso8601", libglib.}

type 
  GTrashStack* =  ptr GTrashStackObj
  GTrashStackPtr* = ptr GTrashStackObj
  GTrashStackObj* = object 
    next*: GTrashStack

proc push*(stack_p: var GTrashStack; data_p: gpointer) {.
    importc: "g_trash_stack_push", libglib.}
proc pop*(stack_p: var GTrashStack): gpointer {.
    importc: "g_trash_stack_pop", libglib.}
proc peek*(stack_p: var GTrashStack): gpointer {.
    importc: "g_trash_stack_peek", libglib.}
proc height*(stack_p: var GTrashStack): guint {.
    importc: "g_trash_stack_height", libglib.}
when false: # when defined(G_CAN_INLINE) or defined(G_TRASH_STACK_C): 
  proc push*(stack_p: var GTrashStack; data_p: gpointer) = 
    var data: GTrashStack = cast[GTrashStack](data_p)
    data.next = stack_p[]
    stack_p[] = data

  proc pop*(stack_p: var GTrashStack): gpointer = 
    var data: GTrashStack
    data = stack_p[]
    if data: 
      stack_p[] = data.next
      data.next = nil
    return data

  proc peek*(stack_p: var GTrashStack): gpointer = 
    var data: GTrashStack
    data = stack_p[]
    return data

  proc height*(stack_p: var GTrashStack): guint = 
    var data: GTrashStack
    var i: guint = 0
    data = stack_p[]
    while data: 
      inc(i)
      data = data.next
    return i

type 
  GTree* =  ptr GTreeObj
  GTreePtr* = ptr GTreeObj
  GTreeObj* = object 
  
  GTraverseFunc* = proc (key: gpointer; value: gpointer; data: gpointer): gboolean {.cdecl.}
proc g_tree_new*(key_compare_func: GCompareFunc): GTree {.
    importc: "g_tree_new", libglib.}
proc g_tree_new_with_data*(key_compare_func: GCompareDataFunc; 
                           key_compare_data: gpointer): GTree {.
    importc: "g_tree_new_with_data", libglib.}
proc g_tree_new_full*(key_compare_func: GCompareDataFunc; 
                      key_compare_data: gpointer; 
                      key_destroy_func: GDestroyNotify; 
                      value_destroy_func: GDestroyNotify): GTree {.
    importc: "g_tree_new_full", libglib.}
proc `ref`*(tree: GTree): GTree {.importc: "g_tree_ref", 
    libglib.}
proc unref*(tree: GTree) {.importc: "g_tree_unref", libglib.}
proc destroy*(tree: GTree) {.importc: "g_tree_destroy", libglib.}
proc insert*(tree: GTree; key: gpointer; value: gpointer) {.
    importc: "g_tree_insert", libglib.}
proc replace*(tree: GTree; key: gpointer; value: gpointer) {.
    importc: "g_tree_replace", libglib.}
proc remove*(tree: GTree; key: gconstpointer): gboolean {.
    importc: "g_tree_remove", libglib.}
proc steal*(tree: GTree; key: gconstpointer): gboolean {.
    importc: "g_tree_steal", libglib.}
proc lookup*(tree: GTree; key: gconstpointer): gpointer {.
    importc: "g_tree_lookup", libglib.}
proc lookup_extended*(tree: GTree; lookup_key: gconstpointer; 
                             orig_key: ptr gpointer; value: ptr gpointer): gboolean {.
    importc: "g_tree_lookup_extended", libglib.}
proc foreach*(tree: GTree; `func`: GTraverseFunc; user_data: gpointer) {.
    importc: "g_tree_foreach", libglib.}
proc traverse*(tree: GTree; traverse_func: GTraverseFunc; 
                      traverse_type: GTraverseType; user_data: gpointer) {.
    importc: "g_tree_traverse", libglib.}
proc search*(tree: GTree; search_func: GCompareFunc; 
                    user_data: gconstpointer): gpointer {.
    importc: "g_tree_search", libglib.}
proc height*(tree: GTree): gint {.importc: "g_tree_height", 
    libglib.}
proc nnodes*(tree: GTree): gint {.importc: "g_tree_nnodes", 
    libglib.}

const 
  G_URI_RESERVED_CHARS_GENERIC_DELIMITERS* = ":/?#[]@"
const 
  G_URI_RESERVED_CHARS_SUBCOMPONENT_DELIMITERS* = "!$&\'()*+,;="
proc g_uri_unescape_string*(escaped_string: cstring; 
                            illegal_characters: cstring): cstring {.
    importc: "g_uri_unescape_string", libglib.}
proc g_uri_unescape_segment*(escaped_string: cstring; 
                             escaped_string_end: cstring; 
                             illegal_characters: cstring): cstring {.
    importc: "g_uri_unescape_segment", libglib.}
proc g_uri_parse_scheme*(uri: cstring): cstring {.
    importc: "g_uri_parse_scheme", libglib.}
proc g_uri_escape_string*(unescaped: cstring; reserved_chars_allowed: cstring; 
                          allow_utf8: gboolean): cstring {.
    importc: "g_uri_escape_string", libglib.}

type 
  GVariantType* =  ptr GVariantTypeObj
  GVariantTypePtr* = ptr GVariantTypeObj
  GVariantTypeObj* = object 
  
const 
  G_VARIANT_TYPE_BOOLEAN* = (cast[GVariantType]("b"))
const 
  G_VARIANT_TYPE_BYTE* = (cast[GVariantType]("y"))
const 
  G_VARIANT_TYPE_INT16* = (cast[GVariantType]("n"))
const 
  G_VARIANT_TYPE_UINT16* = (cast[GVariantType]("q"))
const 
  G_VARIANT_TYPE_INT32* = (cast[GVariantType]("i"))
const 
  G_VARIANT_TYPE_UINT32* = (cast[GVariantType]("u"))
const 
  G_VARIANT_TYPE_INT64* = (cast[GVariantType]("x"))
const 
  G_VARIANT_TYPE_UINT64* = (cast[GVariantType]("t"))
const 
  G_VARIANT_TYPE_DOUBLE* = (cast[GVariantType]("d"))
const 
  G_VARIANT_TYPE_STRING* = (cast[GVariantType]("s"))
const 
  G_VARIANT_TYPE_OBJECT_PATH* = (cast[GVariantType]("o"))
const 
  G_VARIANT_TYPE_SIGNATURE* = (cast[GVariantType]("g"))
const 
  G_VARIANT_TYPE_VARIANT* = (cast[GVariantType]("v"))
const 
  G_VARIANT_TYPE_HANDLE* = (cast[GVariantType]("h"))
const 
  G_VARIANT_TYPE_UNIT* = (cast[GVariantType]("()"))
const 
  G_VARIANT_TYPE_ANY* = (cast[GVariantType]("*"))
const 
  G_VARIANT_TYPE_BASIC* = (cast[GVariantType]("?"))
const 
  G_VARIANT_TYPE_MAYBE* = (cast[GVariantType]("m*"))
const 
  G_VARIANT_TYPE_ARRAY* = (cast[GVariantType]("a*"))
const 
  G_VARIANT_TYPE_TUPLE* = (cast[GVariantType]("r"))
const 
  G_VARIANT_TYPE_DICT_ENTRY* = (cast[GVariantType]("{?*}"))
const 
  G_VARIANT_TYPE_DICTIONARY* = (cast[GVariantType]("a{?*}"))
const 
  G_VARIANT_TYPE_STRING_ARRAY* = (cast[GVariantType]("as"))
const 
  G_VARIANT_TYPE_OBJECT_PATH_ARRAY* = (cast[GVariantType]("ao"))
const 
  G_VARIANT_TYPE_BYTESTRING* = (cast[GVariantType]("ay"))
const 
  G_VARIANT_TYPE_BYTESTRING_ARRAY* = (cast[GVariantType]("aay"))
const 
  G_VARIANT_TYPE_VARDICT* = (cast[GVariantType]("a{sv}"))
when false: # when not(defined(G_DISABLE_CHECKS)): 
  template g_variant_type*(type_string: expr): expr = 
    (g_variant_type_checked(type_string))

else: 
  template g_variant_type*(type_string: expr): expr = 
    (cast[GVariantType](type_string))

proc g_variant_type_string_is_valid*(type_string: cstring): gboolean {.
    importc: "g_variant_type_string_is_valid", libglib.}
proc g_variant_type_string_scan*(string: cstring; limit: cstring; 
                                 endptr: cstringArray): gboolean {.
    importc: "g_variant_type_string_scan", libglib.}
proc free*(`type`: GVariantType) {.
    importc: "g_variant_type_free", libglib.}
proc copy*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_copy", libglib.}
proc g_variant_type_new*(type_string: cstring): GVariantType {.
    importc: "g_variant_type_new", libglib.}
proc get_string_length*(`type`: GVariantType): gsize {.
    importc: "g_variant_type_get_string_length", libglib.}
proc string_length*(`type`: GVariantType): gsize {.
    importc: "g_variant_type_get_string_length", libglib.}
proc peek_string*(`type`: GVariantType): cstring {.
    importc: "g_variant_type_peek_string", libglib.}
proc dup_string*(`type`: GVariantType): cstring {.
    importc: "g_variant_type_dup_string", libglib.}
proc is_definite*(`type`: GVariantType): gboolean {.
    importc: "g_variant_type_is_definite", libglib.}
proc is_container*(`type`: GVariantType): gboolean {.
    importc: "g_variant_type_is_container", libglib.}
proc is_basic*(`type`: GVariantType): gboolean {.
    importc: "g_variant_type_is_basic", libglib.}
proc is_maybe*(`type`: GVariantType): gboolean {.
    importc: "g_variant_type_is_maybe", libglib.}
proc is_array*(`type`: GVariantType): gboolean {.
    importc: "g_variant_type_is_array", libglib.}
proc is_tuple*(`type`: GVariantType): gboolean {.
    importc: "g_variant_type_is_tuple", libglib.}
proc is_dict_entry*(`type`: GVariantType): gboolean {.
    importc: "g_variant_type_is_dict_entry", libglib.}
proc is_variant*(`type`: GVariantType): gboolean {.
    importc: "g_variant_type_is_variant", libglib.}
proc g_variant_type_hash*(`type`: gconstpointer): guint {.
    importc: "g_variant_type_hash", libglib.}
proc g_variant_type_equal*(type1: gconstpointer; type2: gconstpointer): gboolean {.
    importc: "g_variant_type_equal", libglib.}
proc is_subtype_of*(`type`: GVariantType; 
                                   supertype: GVariantType): gboolean {.
    importc: "g_variant_type_is_subtype_of", libglib.}
proc element*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_element", libglib.}
proc first*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_first", libglib.}
proc next*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_next", libglib.}
proc n_items*(`type`: GVariantType): gsize {.
    importc: "g_variant_type_n_items", libglib.}
proc key*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_key", libglib.}
proc value*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_value", libglib.}
proc new_array*(element: GVariantType): GVariantType {.
    importc: "g_variant_type_new_array", libglib.}
proc new_maybe*(element: GVariantType): GVariantType {.
    importc: "g_variant_type_new_maybe", libglib.}
proc new_tuple*(items: var GVariantType; length: gint): GVariantType {.
    importc: "g_variant_type_new_tuple", libglib.}
proc new_dict_entry*(key: GVariantType; 
                                    value: GVariantType): GVariantType {.
    importc: "g_variant_type_new_dict_entry", libglib.}
proc g_variant_type_checked(a2: cstring): GVariantType {.
    importc: "g_variant_type_checked_", libglib.}

type 
  GVariant* =  ptr GVariantObj
  GVariantPtr* = ptr GVariantObj
  GVariantObj* = object 
  
  GVariantClass* {.size: sizeof(cint), pure.} = enum 
    TUPLE = '(',
    ARRAY = 'a', 
    BOOLEAN = 'b',
    DOUBLE = 'd', 
    SIGNATURE = 'g',
    HANDLE = 'h',
    INT32 = 'i',
    MAYBE = 'm',
    INT16 = 'n',
    OBJECT_PATH = 'o', 
    UINT16 = 'q', 
    STRING = 's',
    UINT64 = 't', 
    UINT32 = 'u', 
    VARIANT = 'v', 
    INT64 = 'x',
    BYTE = 'y', 
    DICT_ENTRY = '{'
proc unref*(value: GVariant) {.importc: "g_variant_unref", 
    libglib.}
proc `ref`*(value: GVariant): GVariant {.
    importc: "g_variant_ref", libglib.}
proc ref_sink*(value: GVariant): GVariant {.
    importc: "g_variant_ref_sink", libglib.}
proc is_floating*(value: GVariant): gboolean {.
    importc: "g_variant_is_floating", libglib.}
proc take_ref*(value: GVariant): GVariant {.
    importc: "g_variant_take_ref", libglib.}
proc get_type*(value: GVariant): GVariantType {.
    importc: "g_variant_get_type", libglib.}
proc `type`*(value: GVariant): GVariantType {.
    importc: "g_variant_get_type", libglib.}
proc get_type_string*(value: GVariant): cstring {.
    importc: "g_variant_get_type_string", libglib.}
proc type_string*(value: GVariant): cstring {.
    importc: "g_variant_get_type_string", libglib.}
proc is_of_type*(value: GVariant; `type`: GVariantType): gboolean {.
    importc: "g_variant_is_of_type", libglib.}
proc is_container*(value: GVariant): gboolean {.
    importc: "g_variant_is_container", libglib.}
proc classify*(value: GVariant): GVariantClass {.
    importc: "g_variant_classify", libglib.}
proc g_variant_new_boolean*(value: gboolean): GVariant {.
    importc: "g_variant_new_boolean", libglib.}
proc g_variant_new_byte*(value: guchar): GVariant {.
    importc: "g_variant_new_byte", libglib.}
proc g_variant_new_int16*(value: gint16): GVariant {.
    importc: "g_variant_new_int16", libglib.}
proc g_variant_new_uint16*(value: guint16): GVariant {.
    importc: "g_variant_new_uint16", libglib.}
proc g_variant_new_int32*(value: gint32): GVariant {.
    importc: "g_variant_new_int32", libglib.}
proc g_variant_new_uint32*(value: guint32): GVariant {.
    importc: "g_variant_new_uint32", libglib.}
proc g_variant_new_int64*(value: gint64): GVariant {.
    importc: "g_variant_new_int64", libglib.}
proc g_variant_new_uint64*(value: guint64): GVariant {.
    importc: "g_variant_new_uint64", libglib.}
proc g_variant_new_handle*(value: gint32): GVariant {.
    importc: "g_variant_new_handle", libglib.}
proc g_variant_new_double*(value: gdouble): GVariant {.
    importc: "g_variant_new_double", libglib.}
proc g_variant_new_string*(string: cstring): GVariant {.
    importc: "g_variant_new_string", libglib.}
proc g_variant_new_take_string*(string: cstring): GVariant {.
    importc: "g_variant_new_take_string", libglib.}
proc g_variant_new_printf*(format_string: cstring): GVariant {.varargs, 
    importc: "g_variant_new_printf", libglib.}
proc g_variant_new_object_path*(object_path: cstring): GVariant {.
    importc: "g_variant_new_object_path", libglib.}
proc g_variant_is_object_path*(string: cstring): gboolean {.
    importc: "g_variant_is_object_path", libglib.}
proc g_variant_new_signature*(signature: cstring): GVariant {.
    importc: "g_variant_new_signature", libglib.}
proc g_variant_is_signature*(string: cstring): gboolean {.
    importc: "g_variant_is_signature", libglib.}
proc new_variant*(value: GVariant): GVariant {.
    importc: "g_variant_new_variant", libglib.}
proc g_variant_new_strv*(strv: cstringArray; length: gssize): GVariant {.
    importc: "g_variant_new_strv", libglib.}
proc g_variant_new_objv*(strv: cstringArray; length: gssize): GVariant {.
    importc: "g_variant_new_objv", libglib.}
proc g_variant_new_bytestring*(string: cstring): GVariant {.
    importc: "g_variant_new_bytestring", libglib.}
proc g_variant_new_bytestring_array*(strv: cstringArray; length: gssize): GVariant {.
    importc: "g_variant_new_bytestring_array", libglib.}
proc g_variant_new_fixed_array*(element_type: GVariantType; 
                                elements: gconstpointer; n_elements: gsize; 
                                element_size: gsize): GVariant {.
    importc: "g_variant_new_fixed_array", libglib.}
proc get_boolean*(value: GVariant): gboolean {.
    importc: "g_variant_get_boolean", libglib.}
proc boolean*(value: GVariant): gboolean {.
    importc: "g_variant_get_boolean", libglib.}
proc get_byte*(value: GVariant): guchar {.
    importc: "g_variant_get_byte", libglib.}
proc byte*(value: GVariant): guchar {.
    importc: "g_variant_get_byte", libglib.}
proc get_int16*(value: GVariant): gint16 {.
    importc: "g_variant_get_int16", libglib.}
proc get_uint16*(value: GVariant): guint16 {.
    importc: "g_variant_get_uint16", libglib.}
proc get_int32*(value: GVariant): gint32 {.
    importc: "g_variant_get_int32", libglib.}
proc get_uint32*(value: GVariant): guint32 {.
    importc: "g_variant_get_uint32", libglib.}
proc get_int64*(value: GVariant): gint64 {.
    importc: "g_variant_get_int64", libglib.}
proc get_uint64*(value: GVariant): guint64 {.
    importc: "g_variant_get_uint64", libglib.}
proc get_handle*(value: GVariant): gint32 {.
    importc: "g_variant_get_handle", libglib.}
proc handle*(value: GVariant): gint32 {.
    importc: "g_variant_get_handle", libglib.}
proc get_double*(value: GVariant): gdouble {.
    importc: "g_variant_get_double", libglib.}
proc get_variant*(value: GVariant): GVariant {.
    importc: "g_variant_get_variant", libglib.}
proc variant*(value: GVariant): GVariant {.
    importc: "g_variant_get_variant", libglib.}
proc get_string*(value: GVariant; length: var gsize): cstring {.
    importc: "g_variant_get_string", libglib.}
proc dup_string*(value: GVariant; length: var gsize): cstring {.
    importc: "g_variant_dup_string", libglib.}
proc get_strv*(value: GVariant; length: var gsize): cstringArray {.
    importc: "g_variant_get_strv", libglib.}
proc strv*(value: GVariant; length: var gsize): cstringArray {.
    importc: "g_variant_get_strv", libglib.}
proc dup_strv*(value: GVariant; length: var gsize): cstringArray {.
    importc: "g_variant_dup_strv", libglib.}
proc get_objv*(value: GVariant; length: var gsize): cstringArray {.
    importc: "g_variant_get_objv", libglib.}
proc objv*(value: GVariant; length: var gsize): cstringArray {.
    importc: "g_variant_get_objv", libglib.}
proc dup_objv*(value: GVariant; length: var gsize): cstringArray {.
    importc: "g_variant_dup_objv", libglib.}
proc get_bytestring*(value: GVariant): cstring {.
    importc: "g_variant_get_bytestring", libglib.}
proc bytestring*(value: GVariant): cstring {.
    importc: "g_variant_get_bytestring", libglib.}
proc dup_bytestring*(value: GVariant; length: var gsize): cstring {.
    importc: "g_variant_dup_bytestring", libglib.}
proc get_bytestring_array*(value: GVariant; length: var gsize): cstringArray {.
    importc: "g_variant_get_bytestring_array", libglib.}
proc bytestring_array*(value: GVariant; length: var gsize): cstringArray {.
    importc: "g_variant_get_bytestring_array", libglib.}
proc dup_bytestring_array*(value: GVariant; length: var gsize): cstringArray {.
    importc: "g_variant_dup_bytestring_array", libglib.}
proc g_variant_new_maybe*(child_type: GVariantType; child: GVariant): GVariant {.
    importc: "g_variant_new_maybe", libglib.}
proc g_variant_new_array*(child_type: GVariantType; 
                          children: var GVariant; n_children: gsize): GVariant {.
    importc: "g_variant_new_array", libglib.}
proc new_tuple*(children: var GVariant; n_children: gsize): GVariant {.
    importc: "g_variant_new_tuple", libglib.}
proc new_dict_entry*(key: GVariant; value: GVariant): GVariant {.
    importc: "g_variant_new_dict_entry", libglib.}
proc get_maybe*(value: GVariant): GVariant {.
    importc: "g_variant_get_maybe", libglib.}
proc maybe*(value: GVariant): GVariant {.
    importc: "g_variant_get_maybe", libglib.}
proc n_children*(value: GVariant): gsize {.
    importc: "g_variant_n_children", libglib.}
proc get_child*(value: GVariant; index: gsize; 
                          format_string: cstring) {.varargs, 
    importc: "g_variant_get_child", libglib.}
proc get_child_value*(value: GVariant; index: gsize): GVariant {.
    importc: "g_variant_get_child_value", libglib.}
proc child_value*(value: GVariant; index: gsize): GVariant {.
    importc: "g_variant_get_child_value", libglib.}
proc lookup*(dictionary: GVariant; key: cstring; 
                       format_string: cstring): gboolean {.varargs, 
    importc: "g_variant_lookup", libglib.}
proc lookup_value*(dictionary: GVariant; key: cstring; 
                             expected_type: GVariantType): GVariant {.
    importc: "g_variant_lookup_value", libglib.}
proc get_fixed_array*(value: GVariant; n_elements: ptr gsize; 
                                element_size: gsize): gconstpointer {.
    importc: "g_variant_get_fixed_array", libglib.}
proc fixed_array*(value: GVariant; n_elements: ptr gsize; 
                                element_size: gsize): gconstpointer {.
    importc: "g_variant_get_fixed_array", libglib.}
proc get_size*(value: GVariant): gsize {.
    importc: "g_variant_get_size", libglib.}
proc size*(value: GVariant): gsize {.
    importc: "g_variant_get_size", libglib.}
proc get_data*(value: GVariant): gconstpointer {.
    importc: "g_variant_get_data", libglib.}
proc data*(value: GVariant): gconstpointer {.
    importc: "g_variant_get_data", libglib.}
proc get_data_as_bytes*(value: GVariant): GBytes {.
    importc: "g_variant_get_data_as_bytes", libglib.}
proc data_as_bytes*(value: GVariant): GBytes {.
    importc: "g_variant_get_data_as_bytes", libglib.}
proc store*(value: GVariant; data: gpointer) {.
    importc: "g_variant_store", libglib.}
proc print*(value: GVariant; type_annotate: gboolean): cstring {.
    importc: "g_variant_print", libglib.}
proc print_string*(value: GVariant; string: GString; 
                             type_annotate: gboolean): GString {.
    importc: "g_variant_print_string", libglib.}
proc g_variant_hash*(value: gconstpointer): guint {.importc: "g_variant_hash", 
    libglib.}
proc g_variant_equal*(one: gconstpointer; two: gconstpointer): gboolean {.
    importc: "g_variant_equal", libglib.}
proc get_normal_form*(value: GVariant): GVariant {.
    importc: "g_variant_get_normal_form", libglib.}
proc normal_form*(value: GVariant): GVariant {.
    importc: "g_variant_get_normal_form", libglib.}
proc is_normal_form*(value: GVariant): gboolean {.
    importc: "g_variant_is_normal_form", libglib.}
proc byteswap*(value: GVariant): GVariant {.
    importc: "g_variant_byteswap", libglib.}
proc g_variant_new_from_bytes*(`type`: GVariantType; bytes: GBytes; 
                               trusted: gboolean): GVariant {.
    importc: "g_variant_new_from_bytes", libglib.}
proc g_variant_new_from_data*(`type`: GVariantType; data: gconstpointer; 
                              size: gsize; trusted: gboolean; 
                              notify: GDestroyNotify; user_data: gpointer): GVariant {.
    importc: "g_variant_new_from_data", libglib.}
type 
  GVariantIter* =  ptr GVariantIterObj
  GVariantIterPtr* = ptr GVariantIterObj
  GVariantIterObj* = object 
    x*: array[16, gsize]

proc iter_new*(value: GVariant): GVariantIter {.
    importc: "g_variant_iter_new", libglib.}
proc init*(iter: GVariantIter; value: GVariant): gsize {.
    importc: "g_variant_iter_init", libglib.}
proc copy*(iter: GVariantIter): GVariantIter {.
    importc: "g_variant_iter_copy", libglib.}
proc n_children*(iter: GVariantIter): gsize {.
    importc: "g_variant_iter_n_children", libglib.}
proc free*(iter: GVariantIter) {.
    importc: "g_variant_iter_free", libglib.}
proc next_value*(iter: GVariantIter): GVariant {.
    importc: "g_variant_iter_next_value", libglib.}
proc next*(iter: GVariantIter; format_string: cstring): gboolean {.
    varargs, importc: "g_variant_iter_next", libglib.}
proc loop*(iter: GVariantIter; format_string: cstring): gboolean {.
    varargs, importc: "g_variant_iter_loop", libglib.}
type 
  GVariantBuilder* =  ptr GVariantBuilderObj
  GVariantBuilderPtr* = ptr GVariantBuilderObj
  GVariantBuilderObj* = object 
    x*: array[16, gsize]

type 
  GVariantParseError* {.size: sizeof(cint), pure.} = enum 
    FAILED, BASIC_TYPE_EXPECTED, 
    CANNOT_INFER_TYPE, 
    DEFINITE_TYPE_EXPECTED, 
    INPUT_NOT_AT_END, 
    INVALID_CHARACTER, 
    INVALID_FORMAT_STRING, 
    INVALID_OBJECT_PATH, 
    INVALID_SIGNATURE, 
    INVALID_TYPE_STRING, 
    NO_COMMON_TYPE, 
    NUMBER_OUT_OF_RANGE, 
    NUMBER_TOO_BIG, TYPE_ERROR, 
    UNEXPECTED_TOKEN, 
    UNKNOWN_KEYWORD, 
    UNTERMINATED_STRING_CONSTANT, 
    VALUE_EXPECTED
proc g_variant_parser_get_error_quark*(): GQuark {.
    importc: "g_variant_parser_get_error_quark", libglib.}
proc g_variant_parse_error_quark*(): GQuark {.
    importc: "g_variant_parse_error_quark", libglib.}
proc g_variant_builder_new*(`type`: GVariantType): GVariantBuilder {.
    importc: "g_variant_builder_new", libglib.}
proc unref*(builder: GVariantBuilder) {.
    importc: "g_variant_builder_unref", libglib.}
proc `ref`*(builder: GVariantBuilder): GVariantBuilder {.
    importc: "g_variant_builder_ref", libglib.}
proc init*(builder: GVariantBuilder; 
                             `type`: GVariantType) {.
    importc: "g_variant_builder_init", libglib.}
proc `end`*(builder: GVariantBuilder): GVariant {.
    importc: "g_variant_builder_end", libglib.}
proc clear*(builder: GVariantBuilder) {.
    importc: "g_variant_builder_clear", libglib.}
proc open*(builder: GVariantBuilder; 
                             `type`: GVariantType) {.
    importc: "g_variant_builder_open", libglib.}
proc close*(builder: GVariantBuilder) {.
    importc: "g_variant_builder_close", libglib.}
proc add_value*(builder: GVariantBuilder; 
                                  value: GVariant) {.
    importc: "g_variant_builder_add_value", libglib.}
proc add*(builder: GVariantBuilder; 
                            format_string: cstring) {.varargs, 
    importc: "g_variant_builder_add", libglib.}
proc add_parsed*(builder: GVariantBuilder; 
                                   format: cstring) {.varargs, 
    importc: "g_variant_builder_add_parsed", libglib.}
proc g_variant_new*(format_string: cstring): GVariant {.varargs, 
    importc: "g_variant_new", libglib.}
proc get*(value: GVariant; format_string: cstring) {.varargs, 
    importc: "g_variant_get", libglib.}
when Va_List_Works:
  proc g_variant_new_va*(format_string: cstring; endptr: cstringArray; 
                         app: ptr va_list): GVariant {.
      importc: "g_variant_new_va", libglib.}
  proc get_va*(value: GVariant; format_string: cstring; 
                         endptr: cstringArray; app: ptr va_list) {.
      importc: "g_variant_get_va", libglib.}
  proc check_format_string*(value: GVariant; 
                                      format_string: cstring; 
                                      copy_only: gboolean): gboolean {.
      importc: "g_variant_check_format_string", libglib.}
when Va_List_Works:
  proc g_variant_parse*(`type`: GVariantType; text: cstring; 
                        limit: cstring; endptr: cstringArray; 
                        error: var GError): GVariant {.
      importc: "g_variant_parse", libglib.}
  proc g_variant_new_parsed*(format: cstring): GVariant {.varargs, 
      importc: "g_variant_new_parsed", libglib.}
  proc g_variant_new_parsed_va*(format: cstring; app: ptr va_list): GVariant {.
      importc: "g_variant_new_parsed_va", libglib.}
proc g_variant_parse_error_print_context*(error: GError; 
    source_str: cstring): cstring {.
    importc: "g_variant_parse_error_print_context", libglib.}
proc g_variant_compare*(one: gconstpointer; two: gconstpointer): gint {.
    importc: "g_variant_compare", libglib.}
type 
  GVariantDict* =  ptr GVariantDictObj
  GVariantDictPtr* = ptr GVariantDictObj
  GVariantDictObj* = object 
    x*: array[16, gsize]

proc dict_new*(from_asv: GVariant): GVariantDict {.
    importc: "g_variant_dict_new", libglib.}
proc init*(dict: GVariantDict; from_asv: GVariant) {.
    importc: "g_variant_dict_init", libglib.}
proc lookup*(dict: GVariantDict; key: cstring; 
                            format_string: cstring): gboolean {.varargs, 
    importc: "g_variant_dict_lookup", libglib.}
proc lookup_value*(dict: GVariantDict; key: cstring; 
                                  expected_type: GVariantType): GVariant {.
    importc: "g_variant_dict_lookup_value", libglib.}
proc contains*(dict: GVariantDict; key: cstring): gboolean {.
    importc: "g_variant_dict_contains", libglib.}
proc insert*(dict: GVariantDict; key: cstring; 
                            format_string: cstring) {.varargs, 
    importc: "g_variant_dict_insert", libglib.}
proc insert_value*(dict: GVariantDict; key: cstring; 
                                  value: GVariant) {.
    importc: "g_variant_dict_insert_value", libglib.}
proc remove*(dict: GVariantDict; key: cstring): gboolean {.
    importc: "g_variant_dict_remove", libglib.}
proc clear*(dict: GVariantDict) {.
    importc: "g_variant_dict_clear", libglib.}
proc `end`*(dict: GVariantDict): GVariant {.
    importc: "g_variant_dict_end", libglib.}
proc `ref`*(dict: GVariantDict): GVariantDict {.
    importc: "g_variant_dict_ref", libglib.}
proc unref*(dict: GVariantDict) {.
    importc: "g_variant_dict_unref", libglib.}

proc glib_check_version*(required_major: guint; required_minor: guint; 
                         required_micro: guint): cstring {.
    importc: "glib_check_version", libglib.}
template glib_check_version*(major, minor, micro: expr): expr = 
  (GLIB_MAJOR_VERSION > major or
      (GLIB_MAJOR_VERSION == major and GLIB_MINOR_VERSION > minor) or
      (GLIB_MAJOR_VERSION == major and GLIB_MINOR_VERSION == minor and
      GLIB_MICRO_VERSION >= micro))

{.deprecated: [PGTimeVal: GTimeVal, TGTimeVal: GTimeValObj].}
{.deprecated: [PGBytes: GBytes, TGBytes: GBytesObj].}
{.deprecated: [PGArray: GArray, TGArray: GArrayObj].}
{.deprecated: [PGByteArray: GByteArray, TGByteArray: GByteArrayObj].}
{.deprecated: [PGPtrArray: GPtrArray, TGPtrArray: GPtrArrayObj].}
{.deprecated: [PGError: GError, TGError: GErrorObj].}
{.deprecated: [PGThread: GThread, TGThread: GThreadObj].}
{.deprecated: [PGRWLock: GRWLock, TGRWLock: GRWLockObj].}
{.deprecated: [PGCond: GCond, TGCond: GCondObj].}
{.deprecated: [PGRecMutex: GRecMutex, TGRecMutex: GRecMutexObj].}
{.deprecated: [PGPrivate: GPrivate, TGPrivate: GPrivateObj].}
{.deprecated: [PGOnce: GOnce, TGOnce: GOnceObj].}
{.deprecated: [PGAsyncQueue: GAsyncQueue, TGAsyncQueue: GAsyncQueueObj].}
{.deprecated: [PGBookmarkFile: GBookmarkFile, TGBookmarkFile: GBookmarkFileObj].}
{.deprecated: [PGChecksum: GChecksum, TGChecksum: GChecksumObj].}
{.deprecated: [PGIConv: GIConv, TGIConv: GIConvObj].}
{.deprecated: [PGData: GData, TGData: GDataObj].}
{.deprecated: [PGDate: GDate, TGDate: GDateObj].}
{.deprecated: [PGTimeZone: GTimeZone, TGTimeZone: GTimeZoneObj].}
{.deprecated: [PGDateTime: GDateTime, TGDateTime: GDateTimeObj].}
{.deprecated: [PGDir: GDir, TGDir: GDirObj].}
{.deprecated: [PGMemVTable: GMemVTable, TGMemVTable: GMemVTableObj].}
{.deprecated: [PGNode: GNode, TGNode: GNodeObj].}
{.deprecated: [PGList: GList, TGList: GListObj].}
{.deprecated: [PGHashTable: GHashTable, TGHashTable: GHashTableObj].}
{.deprecated: [PGHashTableIter: GHashTableIter, TGHashTableIter: GHashTableIterObj].}
{.deprecated: [PGHmac: GHmac, TGHmac: GHmacObj].}
{.deprecated: [PGHookList: GHookList, TGHookList: GHookListObj].}
{.deprecated: [PGHook: GHook, TGHook: GHookObj].}
{.deprecated: [PGPollFD: GPollFD, TGPollFD: GPollFDObj].}
{.deprecated: [PGSList: GSList, TGSList: GSListObj].}
{.deprecated: [PGMainContext: GMainContext, TGMainContext: GMainContextObj].}
{.deprecated: [PGMainLoop: GMainLoop, TGMainLoop: GMainLoopObj].}
{.deprecated: [PGSourcePrivate: GSourcePrivate, TGSourcePrivate: GSourcePrivateObj].}
{.deprecated: [PGSource: GSource, TGSource: GSourceObj].}
{.deprecated: [PGSourceCallbackFuncs: GSourceCallbackFuncs, TGSourceCallbackFuncs: GSourceCallbackFuncsObj].}
{.deprecated: [PGSourceFuncs: GSourceFuncs, TGSourceFuncs: GSourceFuncsObj].}
{.deprecated: [PGDebugKey: GDebugKey, TGDebugKey: GDebugKeyObj].}
{.deprecated: [PGString: GString, TGString: GStringObj].}
{.deprecated: [PGIOChannel: GIOChannel, TGIOChannel: GIOChannelObj].}
{.deprecated: [PGIOFuncs: GIOFuncs, TGIOFuncs: GIOFuncsObj].}
{.deprecated: [PGKeyFile: GKeyFile, TGKeyFile: GKeyFileObj].}
{.deprecated: [PGMappedFile: GMappedFile, TGMappedFile: GMappedFileObj].}
{.deprecated: [PGMarkupParseContext: GMarkupParseContext, TGMarkupParseContext: GMarkupParseContextObj].}
{.deprecated: [PGMarkupParser: GMarkupParser, TGMarkupParser: GMarkupParserObj].}
{.deprecated: [PGOptionContext: GOptionContext, TGOptionContext: GOptionContextObj].}
{.deprecated: [PGOptionGroup: GOptionGroup, TGOptionGroup: GOptionGroupObj].}
{.deprecated: [PGOptionEntry: GOptionEntry, TGOptionEntry: GOptionEntryObj].}
{.deprecated: [PGPatternSpec: GPatternSpec, TGPatternSpec: GPatternSpecObj].}
{.deprecated: [PGQueue: GQueue, TGQueue: GQueueObj].}
{.deprecated: [PGRand: GRand, TGRand: GRandObj].}
{.deprecated: [PGRegex: GRegex, TGRegex: GRegexObj].}
{.deprecated: [PGMatchInfo: GMatchInfo, TGMatchInfo: GMatchInfoObj].}
{.deprecated: [PGScannerConfig: GScannerConfig, TGScannerConfig: GScannerConfigObj].}
{.deprecated: [PGScanner: GScanner, TGScanner: GScannerObj].}
{.deprecated: [PGSequence: GSequence, TGSequence: GSequenceObj].}
{.deprecated: [PGSequenceIter: GSequenceIter, TGSequenceIter: GSequenceIterObj].}
{.deprecated: [PGStringChunk: GStringChunk, TGStringChunk: GStringChunkObj].}
{.deprecated: [PGTestCase: GTestCase, TGTestCase: GTestCaseObj].}
{.deprecated: [PGTestSuite: GTestSuite, TGTestSuite: GTestSuiteObj].}
{.deprecated: [PGTestConfig: GTestConfig, TGTestConfig: GTestConfigObj].}
{.deprecated: [PGTestLogMsg: GTestLogMsg, TGTestLogMsg: GTestLogMsgObj].}
{.deprecated: [PGTestLogBuffer: GTestLogBuffer, TGTestLogBuffer: GTestLogBufferObj].}
{.deprecated: [PGThreadPool: GThreadPool, TGThreadPool: GThreadPoolObj].}
{.deprecated: [PGTimer: GTimer, TGTimer: GTimerObj].}
{.deprecated: [PGTrashStack: GTrashStack, TGTrashStack: GTrashStackObj].}
{.deprecated: [PGTree: GTree, TGTree: GTreeObj].}
{.deprecated: [PGVariantType: GVariantType, TGVariantType: GVariantTypeObj].}
{.deprecated: [PGVariant: GVariant, TGVariant: GVariantObj].}
{.deprecated: [PGVariantIter: GVariantIter, TGVariantIter: GVariantIterObj].}
{.deprecated: [PGVariantBuilder: GVariantBuilder, TGVariantBuilder: GVariantBuilderObj].}
{.deprecated: [PGVariantDict: GVariantDict, TGVariantDict: GVariantDictObj].}
{.deprecated: [TGThreadError: GThreadError].}
{.deprecated: [TGOnceStatus: GOnceStatus].}
{.deprecated: [TGBookmarkFileError: GBookmarkFileError].}
{.deprecated: [TGChecksumType: GChecksumType].}
{.deprecated: [TGConvertError: GConvertError].}
{.deprecated: [TGDateDMY: GDateDMY].}
{.deprecated: [TGDateWeekday: GDateWeekday].}
{.deprecated: [TGDateMonth: GDateMonth].}
{.deprecated: [TGTimeType: GTimeType].}
{.deprecated: [TGFileError: GFileError].}
{.deprecated: [TGFileTest: GFileTest].}
{.deprecated: [TGTraverseFlags: GTraverseFlags].}
{.deprecated: [TGTraverseType: GTraverseType].}
{.deprecated: [TGHookFlagMask: GHookFlagMask].}
{.deprecated: [TGIOCondition: GIOCondition].}
{.deprecated: [TGUnicodeType: GUnicodeType].}
{.deprecated: [TGUnicodeBreakType: GUnicodeBreakType].}
{.deprecated: [TGUnicodeScript: GUnicodeScript].}
{.deprecated: [TGNormalizeMode: GNormalizeMode].}
{.deprecated: [TGUserDirectory: GUserDirectory].}
{.deprecated: [TGFormatSizeFlags: GFormatSizeFlags].}
{.deprecated: [TGIOError: GIOError].}
{.deprecated: [TGIOChannelError: GIOChannelError].}
{.deprecated: [TGIOStatus: GIOStatus].}
{.deprecated: [TGSeekType: GSeekType].}
{.deprecated: [TGIOFlags: GIOFlags].}
{.deprecated: [TGKeyFileError: GKeyFileError].}
{.deprecated: [TGKeyFileFlags: GKeyFileFlags].}
{.deprecated: [TGMarkupError: GMarkupError].}
{.deprecated: [TGMarkupParseFlags: GMarkupParseFlags].}
{.deprecated: [TGMarkupCollectType: GMarkupCollectType].}
{.deprecated: [TGLogLevelFlags: GLogLevelFlags].}
{.deprecated: [TGOptionFlags: GOptionFlags].}
{.deprecated: [TGOptionArg: GOptionArg].}
{.deprecated: [TGOptionError: GOptionError].}
{.deprecated: [TGRegexError: GRegexError].}
{.deprecated: [TGRegexCompileFlags: GRegexCompileFlags].}
{.deprecated: [TGRegexMatchFlags: GRegexMatchFlags].}
{.deprecated: [TGErrorType: GErrorType].}
{.deprecated: [TGTokenType: GTokenType].}
{.deprecated: [TGShellError: GShellError].}
{.deprecated: [TGSliceConfig: GSliceConfig].}
{.deprecated: [TGSpawnError: GSpawnError].}
{.deprecated: [TGSpawnFlags: GSpawnFlags].}
{.deprecated: [TGAsciiType: GAsciiType].}
{.deprecated: [TGTestTrapFlags: GTestTrapFlags].}
{.deprecated: [TGTestSubprocessFlags: GTestSubprocessFlags].}
{.deprecated: [TGTestLogType: GTestLogType].}
{.deprecated: [TGTestFileType: GTestFileType].}
{.deprecated: [TGVariantClass: GVariantClass].}
{.deprecated: [TGVariantParseError: GVariantParseError].}
{.deprecated: [g_array_free: free].}
{.deprecated: [g_array_ref: `ref`].}
{.deprecated: [g_array_unref: unref].}
{.deprecated: [g_array_get_element_size: get_element_size].}
{.deprecated: [g_array_append_vals: append_vals].}
{.deprecated: [g_array_prepend_vals: prepend_vals].}
{.deprecated: [g_array_insert_vals: insert_vals].}
{.deprecated: [g_array_set_size: set_size].}
{.deprecated: [g_array_remove_index: remove_index].}
{.deprecated: [g_array_remove_index_fast: remove_index_fast].}
{.deprecated: [g_array_remove_range: remove_range].}
{.deprecated: [g_array_sort: sort].}
{.deprecated: [g_array_sort_with_data: sort_with_data].}
{.deprecated: [g_array_set_clear_func: set_clear_func].}
{.deprecated: [g_ptr_array_free: free].}
{.deprecated: [g_ptr_array_ref: `ref`].}
{.deprecated: [g_ptr_array_unref: unref].}
{.deprecated: [g_ptr_array_set_free_func: set_free_func].}
{.deprecated: [g_ptr_array_set_size: set_size].}
{.deprecated: [g_ptr_array_remove_index: remove_index].}
{.deprecated: [g_ptr_array_remove_index_fast: remove_index_fast].}
{.deprecated: [g_ptr_array_remove: remove].}
{.deprecated: [g_ptr_array_remove_fast: remove_fast].}
{.deprecated: [g_ptr_array_remove_range: remove_range].}
{.deprecated: [g_ptr_array_add: add].}
{.deprecated: [g_ptr_array_insert: insert].}
{.deprecated: [g_ptr_array_sort: sort].}
{.deprecated: [g_ptr_array_sort_with_data: sort_with_data].}
{.deprecated: [g_ptr_array_foreach: foreach].}
{.deprecated: [g_byte_array_free: free].}
{.deprecated: [g_byte_array_free_to_bytes: free_to_bytes].}
{.deprecated: [g_byte_array_ref: `ref`].}
{.deprecated: [g_byte_array_unref: unref].}
{.deprecated: [g_byte_array_append: append].}
{.deprecated: [g_byte_array_prepend: prepend].}
{.deprecated: [g_byte_array_set_size: set_size].}
{.deprecated: [g_byte_array_remove_index: remove_index].}
{.deprecated: [g_byte_array_remove_index_fast: remove_index_fast].}
{.deprecated: [g_byte_array_remove_range: remove_range].}
{.deprecated: [g_byte_array_sort: sort].}
{.deprecated: [g_byte_array_sort_with_data: sort_with_data].}
{.deprecated: [g_quark_to_string: to_string].}
{.deprecated: [g_error_free: free].}
{.deprecated: [g_error_copy: copy].}
{.deprecated: [g_error_matches: matches].}
{.deprecated: [g_thread_ref: `ref`].}
{.deprecated: [g_thread_unref: unref].}
{.deprecated: [g_thread_join: join].}
{.deprecated: [g_mutex_init: init].}
{.deprecated: [g_mutex_clear: clear].}
{.deprecated: [g_mutex_lock: lock].}
{.deprecated: [g_mutex_trylock: trylock].}
{.deprecated: [g_mutex_unlock: unlock].}
{.deprecated: [g_rw_lock_init: init].}
{.deprecated: [g_rw_lock_clear: clear].}
{.deprecated: [g_rw_lock_writer_lock: writer_lock].}
{.deprecated: [g_rw_lock_writer_trylock: writer_trylock].}
{.deprecated: [g_rw_lock_writer_unlock: writer_unlock].}
{.deprecated: [g_rw_lock_reader_lock: reader_lock].}
{.deprecated: [g_rw_lock_reader_trylock: reader_trylock].}
{.deprecated: [g_rw_lock_reader_unlock: reader_unlock].}
{.deprecated: [g_rec_mutex_init: init].}
{.deprecated: [g_rec_mutex_clear: clear].}
{.deprecated: [g_rec_mutex_lock: lock].}
{.deprecated: [g_rec_mutex_trylock: trylock].}
{.deprecated: [g_rec_mutex_unlock: unlock].}
{.deprecated: [g_cond_init: init].}
{.deprecated: [g_cond_clear: clear].}
{.deprecated: [g_cond_wait: wait].}
{.deprecated: [g_cond_signal: signal].}
{.deprecated: [g_cond_broadcast: broadcast].}
{.deprecated: [g_cond_wait_until: wait_until].}
{.deprecated: [g_private_get: get].}
{.deprecated: [g_private_set: set].}
{.deprecated: [g_private_replace: replace].}
{.deprecated: [g_once_impl: impl].}
{.deprecated: [g_async_queue_lock: lock].}
{.deprecated: [g_async_queue_unlock: unlock].}
{.deprecated: [g_async_queue_ref: `ref`].}
{.deprecated: [g_async_queue_unref: unref].}
{.deprecated: [g_async_queue_ref_unlocked: ref_unlocked].}
{.deprecated: [g_async_queue_unref_and_unlock: unref_and_unlock].}
{.deprecated: [g_async_queue_push: push].}
{.deprecated: [g_async_queue_push_unlocked: push_unlocked].}
{.deprecated: [g_async_queue_push_sorted: push_sorted].}
{.deprecated: [g_async_queue_push_sorted_unlocked: push_sorted_unlocked].}
{.deprecated: [g_async_queue_pop: pop].}
{.deprecated: [g_async_queue_pop_unlocked: pop_unlocked].}
{.deprecated: [g_async_queue_try_pop: try_pop].}
{.deprecated: [g_async_queue_try_pop_unlocked: try_pop_unlocked].}
{.deprecated: [g_async_queue_timeout_pop: timeout_pop].}
{.deprecated: [g_async_queue_timeout_pop_unlocked: timeout_pop_unlocked].}
{.deprecated: [g_async_queue_length: length].}
{.deprecated: [g_async_queue_length_unlocked: length_unlocked].}
{.deprecated: [g_async_queue_sort: sort].}
{.deprecated: [g_async_queue_sort_unlocked: sort_unlocked].}
{.deprecated: [g_async_queue_timed_pop: timed_pop].}
{.deprecated: [g_async_queue_timed_pop_unlocked: timed_pop_unlocked].}
{.deprecated: [g_bookmark_file_free: free].}
{.deprecated: [g_bookmark_file_load_from_file: load_from_file].}
{.deprecated: [g_bookmark_file_load_from_data: load_from_data].}
{.deprecated: [g_bookmark_file_load_from_data_dirs: load_from_data_dirs].}
{.deprecated: [g_bookmark_file_to_data: to_data].}
{.deprecated: [g_bookmark_file_to_file: to_file].}
{.deprecated: [g_bookmark_file_set_title: set_title].}
{.deprecated: [g_bookmark_file_get_title: get_title].}
{.deprecated: [g_bookmark_file_set_description: set_description].}
{.deprecated: [g_bookmark_file_get_description: get_description].}
{.deprecated: [g_bookmark_file_set_mime_type: set_mime_type].}
{.deprecated: [g_bookmark_file_get_mime_type: get_mime_type].}
{.deprecated: [g_bookmark_file_set_groups: set_groups].}
{.deprecated: [g_bookmark_file_add_group: add_group].}
{.deprecated: [g_bookmark_file_has_group: has_group].}
{.deprecated: [g_bookmark_file_get_groups: get_groups].}
{.deprecated: [g_bookmark_file_add_application: add_application].}
{.deprecated: [g_bookmark_file_has_application: has_application].}
{.deprecated: [g_bookmark_file_get_applications: get_applications].}
{.deprecated: [g_bookmark_file_set_app_info: set_app_info].}
{.deprecated: [g_bookmark_file_get_app_info: get_app_info].}
{.deprecated: [g_bookmark_file_set_is_private: set_is_private].}
{.deprecated: [g_bookmark_file_get_is_private: get_is_private].}
{.deprecated: [g_bookmark_file_set_icon: set_icon].}
{.deprecated: [g_bookmark_file_get_icon: get_icon].}
{.deprecated: [g_bookmark_file_set_added: set_added].}
{.deprecated: [g_bookmark_file_get_added: get_added].}
{.deprecated: [g_bookmark_file_set_modified: set_modified].}
{.deprecated: [g_bookmark_file_get_modified: get_modified].}
{.deprecated: [g_bookmark_file_set_visited: set_visited].}
{.deprecated: [g_bookmark_file_get_visited: get_visited].}
{.deprecated: [g_bookmark_file_has_item: has_item].}
{.deprecated: [g_bookmark_file_get_size: get_size].}
{.deprecated: [g_bookmark_file_get_uris: get_uris].}
{.deprecated: [g_bookmark_file_remove_group: remove_group].}
{.deprecated: [g_bookmark_file_remove_application: remove_application].}
{.deprecated: [g_bookmark_file_remove_item: remove_item].}
{.deprecated: [g_bookmark_file_move_item: move_item].}
{.deprecated: [g_bytes_new_from_bytes: new_from_bytes].}
{.deprecated: [g_bytes_get_data: get_data].}
{.deprecated: [g_bytes_get_size: get_size].}
{.deprecated: [g_bytes_ref: `ref`].}
{.deprecated: [g_bytes_unref: unref].}
{.deprecated: [g_bytes_unref_to_data: unref_to_data].}
{.deprecated: [g_bytes_unref_to_array: unref_to_array].}
{.deprecated: [g_checksum_type_get_length: get_length].}
{.deprecated: [g_checksum_reset: reset].}
{.deprecated: [g_checksum_copy: copy].}
{.deprecated: [g_checksum_free: free].}
{.deprecated: [g_checksum_update: update].}
{.deprecated: [g_checksum_get_string: get_string].}
{.deprecated: [g_checksum_get_digest: get_digest].}
{.deprecated: [g_datalist_init: init].}
{.deprecated: [g_datalist_clear: clear].}
{.deprecated: [g_datalist_id_get_data: id_get_data].}
{.deprecated: [g_datalist_id_set_data_full: id_set_data_full].}
{.deprecated: [g_datalist_id_dup_data: id_dup_data].}
{.deprecated: [g_datalist_id_replace_data: id_replace_data].}
{.deprecated: [g_datalist_id_remove_no_notify: id_remove_no_notify].}
{.deprecated: [g_datalist_foreach: foreach].}
{.deprecated: [g_datalist_set_flags: set_flags].}
{.deprecated: [g_datalist_unset_flags: unset_flags].}
{.deprecated: [g_datalist_get_flags: get_flags].}
{.deprecated: [g_datalist_get_data: get_data].}
{.deprecated: [g_date_free: free].}
{.deprecated: [g_date_valid: valid].}
{.deprecated: [g_date_get_weekday: get_weekday].}
{.deprecated: [g_date_get_month: get_month].}
{.deprecated: [g_date_get_year: get_year].}
{.deprecated: [g_date_get_day: get_day].}
{.deprecated: [g_date_get_julian: get_julian].}
{.deprecated: [g_date_get_day_of_year: get_day_of_year].}
{.deprecated: [g_date_get_monday_week_of_year: get_monday_week_of_year].}
{.deprecated: [g_date_get_sunday_week_of_year: get_sunday_week_of_year].}
{.deprecated: [g_date_get_iso8601_week_of_year: get_iso8601_week_of_year].}
{.deprecated: [g_date_clear: clear].}
{.deprecated: [g_date_set_parse: set_parse].}
{.deprecated: [g_date_set_time_t: set_time_t].}
{.deprecated: [g_date_set_time_val: set_time_val].}
{.deprecated: [g_date_set_month: set_month].}
{.deprecated: [g_date_set_day: set_day].}
{.deprecated: [g_date_set_year: set_year].}
{.deprecated: [g_date_set_dmy: set_dmy].}
{.deprecated: [g_date_set_julian: set_julian].}
{.deprecated: [g_date_is_first_of_month: is_first_of_month].}
{.deprecated: [g_date_is_last_of_month: is_last_of_month].}
{.deprecated: [g_date_add_days: add_days].}
{.deprecated: [g_date_subtract_days: subtract_days].}
{.deprecated: [g_date_add_months: add_months].}
{.deprecated: [g_date_subtract_months: subtract_months].}
{.deprecated: [g_date_add_years: add_years].}
{.deprecated: [g_date_subtract_years: subtract_years].}
{.deprecated: [g_date_get_days_in_month: get_days_in_month].}
{.deprecated: [g_date_get_monday_weeks_in_year: get_monday_weeks_in_year].}
{.deprecated: [g_date_get_sunday_weeks_in_year: get_sunday_weeks_in_year].}
{.deprecated: [g_date_days_between: days_between].}
{.deprecated: [g_date_compare: compare].}
{.deprecated: [g_date_clamp: clamp].}
{.deprecated: [g_date_order: order].}
{.deprecated: [g_time_zone_ref: `ref`].}
{.deprecated: [g_time_zone_unref: unref].}
{.deprecated: [g_time_zone_find_interval: find_interval].}
{.deprecated: [g_time_zone_adjust_time: adjust_time].}
{.deprecated: [g_time_zone_get_abbreviation: get_abbreviation].}
{.deprecated: [g_time_zone_get_offset: get_offset].}
{.deprecated: [g_time_zone_is_dst: is_dst].}
{.deprecated: [g_date_time_unref: unref].}
{.deprecated: [g_date_time_ref: `ref`].}
{.deprecated: [g_date_time_add: add].}
{.deprecated: [g_date_time_add_years: add_years].}
{.deprecated: [g_date_time_add_months: add_months].}
{.deprecated: [g_date_time_add_weeks: add_weeks].}
{.deprecated: [g_date_time_add_days: add_days].}
{.deprecated: [g_date_time_add_hours: add_hours].}
{.deprecated: [g_date_time_add_minutes: add_minutes].}
{.deprecated: [g_date_time_add_seconds: add_seconds].}
{.deprecated: [g_date_time_add_full: add_full].}
{.deprecated: [g_date_time_difference: difference].}
{.deprecated: [g_date_time_get_ymd: get_ymd].}
{.deprecated: [g_date_time_get_year: get_year].}
{.deprecated: [g_date_time_get_month: get_month].}
{.deprecated: [g_date_time_get_day_of_month: get_day_of_month].}
{.deprecated: [g_date_time_get_week_numbering_year: get_week_numbering_year].}
{.deprecated: [g_date_time_get_week_of_year: get_week_of_year].}
{.deprecated: [g_date_time_get_day_of_week: get_day_of_week].}
{.deprecated: [g_date_time_get_day_of_year: get_day_of_year].}
{.deprecated: [g_date_time_get_hour: get_hour].}
{.deprecated: [g_date_time_get_minute: get_minute].}
{.deprecated: [g_date_time_get_second: get_second].}
{.deprecated: [g_date_time_get_microsecond: get_microsecond].}
{.deprecated: [g_date_time_get_seconds: get_seconds].}
{.deprecated: [g_date_time_to_unix: to_unix].}
{.deprecated: [g_date_time_to_timeval: to_timeval].}
{.deprecated: [g_date_time_get_utc_offset: get_utc_offset].}
{.deprecated: [g_date_time_get_timezone_abbreviation: get_timezone_abbreviation].}
{.deprecated: [g_date_time_is_daylight_savings: is_daylight_savings].}
{.deprecated: [g_date_time_to_timezone: to_timezone].}
{.deprecated: [g_date_time_to_local: to_local].}
{.deprecated: [g_date_time_to_utc: to_utc].}
{.deprecated: [g_date_time_format: format].}
{.deprecated: [g_dir_rewind: rewind].}
{.deprecated: [g_dir_close: close].}
{.deprecated: [g_dir_read_name: read_name].}
{.deprecated: [g_node_destroy: destroy].}
{.deprecated: [g_node_unlink: unlink].}
{.deprecated: [g_node_copy_deep: copy_deep].}
{.deprecated: [g_node_copy: copy].}
{.deprecated: [g_node_insert: insert].}
{.deprecated: [g_node_insert_before: insert_before].}
{.deprecated: [g_node_insert_after: insert_after].}
{.deprecated: [g_node_prepend: prepend].}
{.deprecated: [g_node_n_nodes: n_nodes].}
{.deprecated: [g_node_get_root: get_root].}
{.deprecated: [g_node_is_ancestor: is_ancestor].}
{.deprecated: [g_node_depth: depth].}
{.deprecated: [g_node_find: find].}
{.deprecated: [g_node_traverse: traverse].}
{.deprecated: [g_node_max_height: max_height].}
{.deprecated: [g_node_children_foreach: children_foreach].}
{.deprecated: [g_node_reverse_children: reverse_children].}
{.deprecated: [g_node_n_children: n_children].}
{.deprecated: [g_node_nth_child: nth_child].}
{.deprecated: [g_node_last_child: last_child].}
{.deprecated: [g_node_find_child: find_child].}
{.deprecated: [g_node_child_position: child_position].}
{.deprecated: [g_node_child_index: child_index].}
{.deprecated: [g_node_first_sibling: first_sibling].}
{.deprecated: [g_node_last_sibling: last_sibling].}
{.deprecated: [g_list_free: free].}
{.deprecated: [g_list_free_1: free_1].}
{.deprecated: [g_list_free_full: free_full].}
{.deprecated: [g_list_append: append].}
{.deprecated: [g_list_prepend: prepend].}
{.deprecated: [g_list_insert: insert].}
{.deprecated: [g_list_insert_sorted: insert_sorted].}
{.deprecated: [g_list_insert_sorted_with_data: insert_sorted_with_data].}
{.deprecated: [g_list_insert_before: insert_before].}
{.deprecated: [g_list_concat: concat].}
{.deprecated: [g_list_remove: remove].}
{.deprecated: [g_list_remove_all: remove_all].}
{.deprecated: [g_list_remove_link: remove_link].}
{.deprecated: [g_list_delete_link: delete_link].}
{.deprecated: [g_list_reverse: reverse].}
{.deprecated: [g_list_copy: copy].}
{.deprecated: [g_list_copy_deep: copy_deep].}
{.deprecated: [g_list_nth: nth].}
{.deprecated: [g_list_nth_prev: nth_prev].}
{.deprecated: [g_list_find: find].}
{.deprecated: [g_list_find_custom: find_custom].}
{.deprecated: [g_list_position: position].}
{.deprecated: [g_list_index: index].}
{.deprecated: [g_list_last: last].}
{.deprecated: [g_list_first: first].}
{.deprecated: [g_list_length: length].}
{.deprecated: [g_list_foreach: foreach].}
{.deprecated: [g_list_sort: sort].}
{.deprecated: [g_list_sort_with_data: sort_with_data].}
{.deprecated: [g_list_nth_data: nth_data].}
{.deprecated: [g_hash_table_destroy: destroy].}
{.deprecated: [g_hash_table_insert: insert].}
{.deprecated: [g_hash_table_replace: replace].}
{.deprecated: [g_hash_table_add: add].}
{.deprecated: [g_hash_table_remove: remove].}
{.deprecated: [g_hash_table_remove_all: remove_all].}
{.deprecated: [g_hash_table_steal: steal].}
{.deprecated: [g_hash_table_steal_all: steal_all].}
{.deprecated: [g_hash_table_lookup: lookup].}
{.deprecated: [g_hash_table_contains: contains].}
{.deprecated: [g_hash_table_lookup_extended: lookup_extended].}
{.deprecated: [g_hash_table_foreach: foreach].}
{.deprecated: [g_hash_table_find: find].}
{.deprecated: [g_hash_table_foreach_remove: foreach_remove].}
{.deprecated: [g_hash_table_foreach_steal: foreach_steal].}
{.deprecated: [g_hash_table_size: size].}
{.deprecated: [g_hash_table_get_keys: get_keys].}
{.deprecated: [g_hash_table_get_values: get_values].}
{.deprecated: [g_hash_table_get_keys_as_array: get_keys_as_array].}
{.deprecated: [g_hash_table_iter_init: init].}
{.deprecated: [g_hash_table_iter_next: next].}
{.deprecated: [g_hash_table_iter_get_hash_table: get_hash_table].}
{.deprecated: [g_hash_table_iter_remove: remove].}
{.deprecated: [g_hash_table_iter_replace: replace].}
{.deprecated: [g_hash_table_iter_steal: steal].}
{.deprecated: [g_hash_table_ref: `ref`].}
{.deprecated: [g_hash_table_unref: unref].}
{.deprecated: [g_hmac_copy: copy].}
{.deprecated: [g_hmac_ref: `ref`].}
{.deprecated: [g_hmac_unref: unref].}
{.deprecated: [g_hmac_update: update].}
{.deprecated: [g_hmac_get_string: get_string].}
{.deprecated: [g_hmac_get_digest: get_digest].}
{.deprecated: [g_hook_list_init: init].}
{.deprecated: [g_hook_list_clear: clear].}
{.deprecated: [g_hook_alloc: alloc].}
{.deprecated: [g_hook_free: free].}
{.deprecated: [g_hook_ref: `ref`].}
{.deprecated: [g_hook_unref: unref].}
{.deprecated: [g_hook_destroy: destroy].}
{.deprecated: [g_hook_destroy_link: destroy_link].}
{.deprecated: [g_hook_prepend: prepend].}
{.deprecated: [g_hook_insert_before: insert_before].}
{.deprecated: [g_hook_insert_sorted: insert_sorted].}
{.deprecated: [g_hook_get: get].}
{.deprecated: [g_hook_find: find].}
{.deprecated: [g_hook_find_data: find_data].}
{.deprecated: [g_hook_find_func: find_func].}
{.deprecated: [g_hook_find_func_data: find_func_data].}
{.deprecated: [g_hook_first_valid: first_valid].}
{.deprecated: [g_hook_next_valid: next_valid].}
{.deprecated: [g_hook_compare_ids: compare_ids].}
{.deprecated: [g_hook_list_invoke: invoke].}
{.deprecated: [g_hook_list_invoke_check: invoke_check].}
{.deprecated: [g_hook_list_marshal: marshal].}
{.deprecated: [g_hook_list_marshal_check: marshal_check].}
{.deprecated: [g_slist_free: free].}
{.deprecated: [g_slist_free_1: free_1].}
{.deprecated: [g_slist_free_full: free_full].}
{.deprecated: [g_slist_append: append].}
{.deprecated: [g_slist_prepend: prepend].}
{.deprecated: [g_slist_insert: insert].}
{.deprecated: [g_slist_insert_sorted: insert_sorted].}
{.deprecated: [g_slist_insert_sorted_with_data: insert_sorted_with_data].}
{.deprecated: [g_slist_insert_before: insert_before].}
{.deprecated: [g_slist_concat: concat].}
{.deprecated: [g_slist_remove: remove].}
{.deprecated: [g_slist_remove_all: remove_all].}
{.deprecated: [g_slist_remove_link: remove_link].}
{.deprecated: [g_slist_delete_link: delete_link].}
{.deprecated: [g_slist_reverse: reverse].}
{.deprecated: [g_slist_copy: copy].}
{.deprecated: [g_slist_copy_deep: copy_deep].}
{.deprecated: [g_slist_nth: nth].}
{.deprecated: [g_slist_find: find].}
{.deprecated: [g_slist_find_custom: find_custom].}
{.deprecated: [g_slist_position: position].}
{.deprecated: [g_slist_index: index].}
{.deprecated: [g_slist_last: last].}
{.deprecated: [g_slist_length: length].}
{.deprecated: [g_slist_foreach: foreach].}
{.deprecated: [g_slist_sort: sort].}
{.deprecated: [g_slist_sort_with_data: sort_with_data].}
{.deprecated: [g_slist_nth_data: nth_data].}
{.deprecated: [g_main_context_ref: `ref`].}
{.deprecated: [g_main_context_unref: unref].}
{.deprecated: [g_main_context_iteration: iteration].}
{.deprecated: [g_main_context_pending: pending].}
{.deprecated: [g_main_context_find_source_by_id: find_source_by_id].}
{.deprecated: [g_main_context_find_source_by_user_data: find_source_by_user_data].}
{.deprecated: [g_main_context_find_source_by_funcs_user_data: find_source_by_funcs_user_data].}
{.deprecated: [g_main_context_wakeup: wakeup].}
{.deprecated: [g_main_context_acquire: acquire].}
{.deprecated: [g_main_context_release: release].}
{.deprecated: [g_main_context_is_owner: is_owner].}
{.deprecated: [g_main_context_wait: wait].}
{.deprecated: [g_main_context_prepare: prepare].}
{.deprecated: [g_main_context_query: query].}
{.deprecated: [g_main_context_check: check].}
{.deprecated: [g_main_context_dispatch: dispatch].}
{.deprecated: [g_main_context_set_poll_func: set_poll_func].}
{.deprecated: [g_main_context_get_poll_func: get_poll_func].}
{.deprecated: [g_main_context_add_poll: add_poll].}
{.deprecated: [g_main_context_remove_poll: remove_poll].}
{.deprecated: [g_main_context_push_thread_default: push_thread_default].}
{.deprecated: [g_main_context_pop_thread_default: pop_thread_default].}
{.deprecated: [g_main_loop_run: run].}
{.deprecated: [g_main_loop_quit: quit].}
{.deprecated: [g_main_loop_ref: `ref`].}
{.deprecated: [g_main_loop_unref: unref].}
{.deprecated: [g_main_loop_is_running: is_running].}
{.deprecated: [g_main_loop_get_context: get_context].}
{.deprecated: [g_source_ref: `ref`].}
{.deprecated: [g_source_unref: unref].}
{.deprecated: [g_source_attach: attach].}
{.deprecated: [g_source_destroy: destroy].}
{.deprecated: [g_source_set_priority: set_priority].}
{.deprecated: [g_source_get_priority: get_priority].}
{.deprecated: [g_source_set_can_recurse: set_can_recurse].}
{.deprecated: [g_source_get_can_recurse: get_can_recurse].}
{.deprecated: [g_source_get_id: get_id].}
{.deprecated: [g_source_get_context: get_context].}
{.deprecated: [g_source_set_callback: set_callback].}
{.deprecated: [g_source_set_funcs: set_funcs].}
{.deprecated: [g_source_is_destroyed: is_destroyed].}
{.deprecated: [g_source_set_name: set_name].}
{.deprecated: [g_source_get_name: get_name].}
{.deprecated: [g_source_set_ready_time: set_ready_time].}
{.deprecated: [g_source_get_ready_time: get_ready_time].}
{.deprecated: [g_source_add_unix_fd: add_unix_fd].}
{.deprecated: [g_source_modify_unix_fd: modify_unix_fd].}
{.deprecated: [g_source_remove_unix_fd: remove_unix_fd].}
{.deprecated: [g_source_query_unix_fd: query_unix_fd].}
{.deprecated: [g_source_set_callback_indirect: set_callback_indirect].}
{.deprecated: [g_source_add_poll: add_poll].}
{.deprecated: [g_source_remove_poll: remove_poll].}
{.deprecated: [g_source_add_child_source: add_child_source].}
{.deprecated: [g_source_remove_child_source: remove_child_source].}
{.deprecated: [g_source_get_current_time: get_current_time].}
{.deprecated: [g_source_get_time: get_time].}
{.deprecated: [g_main_context_invoke_full: invoke_full].}
{.deprecated: [g_main_context_invoke: invoke].}
{.deprecated: [g_unicode_script_to_iso15924: to_iso15924].}
{.deprecated: [g_unichar_isalnum: isalnum].}
{.deprecated: [g_unichar_isalpha: isalpha].}
{.deprecated: [g_unichar_iscntrl: iscntrl].}
{.deprecated: [g_unichar_isdigit: isdigit].}
{.deprecated: [g_unichar_isgraph: isgraph].}
{.deprecated: [g_unichar_islower: islower].}
{.deprecated: [g_unichar_isprint: isprint].}
{.deprecated: [g_unichar_ispunct: ispunct].}
{.deprecated: [g_unichar_isspace: isspace].}
{.deprecated: [g_unichar_isupper: isupper].}
{.deprecated: [g_unichar_isxdigit: isxdigit].}
{.deprecated: [g_unichar_istitle: istitle].}
{.deprecated: [g_unichar_isdefined: isdefined].}
{.deprecated: [g_unichar_iswide: iswide].}
{.deprecated: [g_unichar_iswide_cjk: iswide_cjk].}
{.deprecated: [g_unichar_iszerowidth: iszerowidth].}
{.deprecated: [g_unichar_ismark: ismark].}
{.deprecated: [g_unichar_toupper: toupper].}
{.deprecated: [g_unichar_tolower: tolower].}
{.deprecated: [g_unichar_totitle: totitle].}
{.deprecated: [g_unichar_digit_value: digit_value].}
{.deprecated: [g_unichar_xdigit_value: xdigit_value].}
{.deprecated: [g_unichar_type: `type`].}
{.deprecated: [g_unichar_break_type: break_type].}
{.deprecated: [g_unichar_combining_class: combining_class].}
{.deprecated: [g_unichar_get_mirror_char: get_mirror_char].}
{.deprecated: [g_unichar_get_script: get_script].}
{.deprecated: [g_unichar_validate: validate].}
{.deprecated: [g_unichar_compose: compose].}
{.deprecated: [g_unichar_decompose: decompose].}
{.deprecated: [g_unichar_fully_decompose: fully_decompose].}
{.deprecated: [g_unichar_to_utf8: to_utf8].}
{.deprecated: [g_string_free: free].}
{.deprecated: [g_string_free_to_bytes: free_to_bytes].}
{.deprecated: [g_string_equal: equal].}
{.deprecated: [g_string_hash: hash].}
{.deprecated: [g_string_assign: assign].}
{.deprecated: [g_string_truncate: truncate].}
{.deprecated: [g_string_set_size: set_size].}
{.deprecated: [g_string_insert_len: insert_len].}
{.deprecated: [g_string_append: append].}
{.deprecated: [g_string_append_len: append_len].}
{.deprecated: [g_string_append_c: append_c].}
{.deprecated: [g_string_append_unichar: append_unichar].}
{.deprecated: [g_string_prepend: prepend].}
{.deprecated: [g_string_prepend_c: prepend_c].}
{.deprecated: [g_string_prepend_unichar: prepend_unichar].}
{.deprecated: [g_string_prepend_len: prepend_len].}
{.deprecated: [g_string_insert: insert].}
{.deprecated: [g_string_insert_c: insert_c].}
{.deprecated: [g_string_insert_unichar: insert_unichar].}
{.deprecated: [g_string_overwrite: overwrite].}
{.deprecated: [g_string_overwrite_len: overwrite_len].}
{.deprecated: [g_string_erase: erase].}
{.deprecated: [g_string_ascii_down: ascii_down].}
{.deprecated: [g_string_ascii_up: ascii_up].}
{.deprecated: [g_string_printf: printf].}
{.deprecated: [g_string_append_printf: append_printf].}
{.deprecated: [g_string_append_uri_escaped: append_uri_escaped].}
{.deprecated: [g_string_down: down].}
{.deprecated: [g_string_up: up].}
{.deprecated: [g_io_channel_init: init].}
{.deprecated: [g_io_channel_ref: `ref`].}
{.deprecated: [g_io_channel_unref: unref].}
{.deprecated: [g_io_channel_read: read].}
{.deprecated: [g_io_channel_write: write].}
{.deprecated: [g_io_channel_seek: seek].}
{.deprecated: [g_io_channel_close: close].}
{.deprecated: [g_io_channel_shutdown: shutdown].}
{.deprecated: [g_io_channel_set_buffer_size: set_buffer_size].}
{.deprecated: [g_io_channel_get_buffer_size: get_buffer_size].}
{.deprecated: [g_io_channel_get_buffer_condition: get_buffer_condition].}
{.deprecated: [g_io_channel_set_flags: set_flags].}
{.deprecated: [g_io_channel_get_flags: get_flags].}
{.deprecated: [g_io_channel_set_line_term: set_line_term].}
{.deprecated: [g_io_channel_get_line_term: get_line_term].}
{.deprecated: [g_io_channel_set_buffered: set_buffered].}
{.deprecated: [g_io_channel_get_buffered: get_buffered].}
{.deprecated: [g_io_channel_set_encoding: set_encoding].}
{.deprecated: [g_io_channel_get_encoding: get_encoding].}
{.deprecated: [g_io_channel_set_close_on_unref: set_close_on_unref].}
{.deprecated: [g_io_channel_get_close_on_unref: get_close_on_unref].}
{.deprecated: [g_io_channel_flush: flush].}
{.deprecated: [g_io_channel_read_line: read_line].}
{.deprecated: [g_io_channel_read_line_string: read_line_string].}
{.deprecated: [g_io_channel_read_to_end: read_to_end].}
{.deprecated: [g_io_channel_read_chars: read_chars].}
{.deprecated: [g_io_channel_read_unichar: read_unichar].}
{.deprecated: [g_io_channel_write_chars: write_chars].}
{.deprecated: [g_io_channel_write_unichar: write_unichar].}
{.deprecated: [g_io_channel_seek_position: seek_position].}
{.deprecated: [g_io_channel_unix_get_fd: unix_get_fd].}
{.deprecated: [g_key_file_ref: `ref`].}
{.deprecated: [g_key_file_unref: unref].}
{.deprecated: [g_key_file_free: free].}
{.deprecated: [g_key_file_set_list_separator: set_list_separator].}
{.deprecated: [g_key_file_load_from_file: load_from_file].}
{.deprecated: [g_key_file_load_from_data: load_from_data].}
{.deprecated: [g_key_file_load_from_dirs: load_from_dirs].}
{.deprecated: [g_key_file_load_from_data_dirs: load_from_data_dirs].}
{.deprecated: [g_key_file_to_data: to_data].}
{.deprecated: [g_key_file_save_to_file: save_to_file].}
{.deprecated: [g_key_file_get_start_group: get_start_group].}
{.deprecated: [g_key_file_get_groups: get_groups].}
{.deprecated: [g_key_file_get_keys: get_keys].}
{.deprecated: [g_key_file_has_group: has_group].}
{.deprecated: [g_key_file_has_key: has_key].}
{.deprecated: [g_key_file_get_value: get_value].}
{.deprecated: [g_key_file_set_value: set_value].}
{.deprecated: [g_key_file_get_string: get_string].}
{.deprecated: [g_key_file_set_string: set_string].}
{.deprecated: [g_key_file_get_locale_string: get_locale_string].}
{.deprecated: [g_key_file_set_locale_string: set_locale_string].}
{.deprecated: [g_key_file_get_boolean: get_boolean].}
{.deprecated: [g_key_file_set_boolean: set_boolean].}
{.deprecated: [g_key_file_get_integer: get_integer].}
{.deprecated: [g_key_file_set_integer: set_integer].}
{.deprecated: [g_key_file_get_int64: get_int64].}
{.deprecated: [g_key_file_set_int64: set_int64].}
{.deprecated: [g_key_file_get_uint64: get_uint64].}
{.deprecated: [g_key_file_set_uint64: set_uint64].}
{.deprecated: [g_key_file_get_double: get_double].}
{.deprecated: [g_key_file_set_double: set_double].}
{.deprecated: [g_key_file_get_string_list: get_string_list].}
{.deprecated: [g_key_file_set_string_list: set_string_list].}
{.deprecated: [g_key_file_get_locale_string_list: get_locale_string_list].}
{.deprecated: [g_key_file_set_locale_string_list: set_locale_string_list].}
{.deprecated: [g_key_file_get_boolean_list: get_boolean_list].}
{.deprecated: [g_key_file_set_boolean_list: set_boolean_list].}
{.deprecated: [g_key_file_get_integer_list: get_integer_list].}
{.deprecated: [g_key_file_set_double_list: set_double_list].}
{.deprecated: [g_key_file_get_double_list: get_double_list].}
{.deprecated: [g_key_file_set_integer_list: set_integer_list].}
{.deprecated: [g_key_file_set_comment: set_comment].}
{.deprecated: [g_key_file_get_comment: get_comment].}
{.deprecated: [g_key_file_remove_comment: remove_comment].}
{.deprecated: [g_key_file_remove_key: remove_key].}
{.deprecated: [g_key_file_remove_group: remove_group].}
{.deprecated: [g_mapped_file_get_length: get_length].}
{.deprecated: [g_mapped_file_get_contents: get_contents].}
{.deprecated: [g_mapped_file_get_bytes: get_bytes].}
{.deprecated: [g_mapped_file_ref: `ref`].}
{.deprecated: [g_mapped_file_unref: unref].}
{.deprecated: [g_mapped_file_free: free].}
{.deprecated: [g_markup_parse_context_ref: `ref`].}
{.deprecated: [g_markup_parse_context_unref: unref].}
{.deprecated: [g_markup_parse_context_free: free].}
{.deprecated: [g_markup_parse_context_parse: parse].}
{.deprecated: [g_markup_parse_context_push: push].}
{.deprecated: [g_markup_parse_context_pop: pop].}
{.deprecated: [g_markup_parse_context_end_parse: end_parse].}
{.deprecated: [g_markup_parse_context_get_element: get_element].}
{.deprecated: [g_markup_parse_context_get_element_stack: get_element_stack].}
{.deprecated: [g_markup_parse_context_get_position: get_position].}
{.deprecated: [g_markup_parse_context_get_user_data: get_user_data].}
{.deprecated: [g_option_context_set_summary: set_summary].}
{.deprecated: [g_option_context_get_summary: get_summary].}
{.deprecated: [g_option_context_set_description: set_description].}
{.deprecated: [g_option_context_get_description: get_description].}
{.deprecated: [g_option_context_free: free].}
{.deprecated: [g_option_context_set_help_enabled: set_help_enabled].}
{.deprecated: [g_option_context_get_help_enabled: get_help_enabled].}
{.deprecated: [g_option_context_set_ignore_unknown_options: set_ignore_unknown_options].}
{.deprecated: [g_option_context_get_ignore_unknown_options: get_ignore_unknown_options].}
{.deprecated: [g_option_context_add_main_entries: add_main_entries].}
{.deprecated: [g_option_context_parse: parse].}
{.deprecated: [g_option_context_parse_strv: parse_strv].}
{.deprecated: [g_option_context_set_translate_func: set_translate_func].}
{.deprecated: [g_option_context_set_translation_domain: set_translation_domain].}
{.deprecated: [g_option_context_add_group: add_group].}
{.deprecated: [g_option_context_set_main_group: set_main_group].}
{.deprecated: [g_option_context_get_main_group: get_main_group].}
{.deprecated: [g_option_context_get_help: get_help].}
{.deprecated: [g_option_group_set_parse_hooks: set_parse_hooks].}
{.deprecated: [g_option_group_set_error_hook: set_error_hook].}
{.deprecated: [g_option_group_free: free].}
{.deprecated: [g_option_group_add_entries: add_entries].}
{.deprecated: [g_option_group_set_translate_func: set_translate_func].}
{.deprecated: [g_option_group_set_translation_domain: set_translation_domain].}
{.deprecated: [g_pattern_spec_free: free].}
{.deprecated: [g_pattern_spec_equal: equal].}
{.deprecated: [g_queue_free: free].}
{.deprecated: [g_queue_free_full: free_full].}
{.deprecated: [g_queue_init: init].}
{.deprecated: [g_queue_clear: clear].}
{.deprecated: [g_queue_is_empty: is_empty].}
{.deprecated: [g_queue_get_length: get_length].}
{.deprecated: [g_queue_reverse: reverse].}
{.deprecated: [g_queue_copy: copy].}
{.deprecated: [g_queue_foreach: foreach].}
{.deprecated: [g_queue_find: find].}
{.deprecated: [g_queue_find_custom: find_custom].}
{.deprecated: [g_queue_sort: sort].}
{.deprecated: [g_queue_push_head: push_head].}
{.deprecated: [g_queue_push_tail: push_tail].}
{.deprecated: [g_queue_push_nth: push_nth].}
{.deprecated: [g_queue_pop_head: pop_head].}
{.deprecated: [g_queue_pop_tail: pop_tail].}
{.deprecated: [g_queue_pop_nth: pop_nth].}
{.deprecated: [g_queue_peek_head: peek_head].}
{.deprecated: [g_queue_peek_tail: peek_tail].}
{.deprecated: [g_queue_peek_nth: peek_nth].}
{.deprecated: [g_queue_index: index].}
{.deprecated: [g_queue_remove: remove].}
{.deprecated: [g_queue_remove_all: remove_all].}
{.deprecated: [g_queue_insert_before: insert_before].}
{.deprecated: [g_queue_insert_after: insert_after].}
{.deprecated: [g_queue_insert_sorted: insert_sorted].}
{.deprecated: [g_queue_push_head_link: push_head_link].}
{.deprecated: [g_queue_push_tail_link: push_tail_link].}
{.deprecated: [g_queue_push_nth_link: push_nth_link].}
{.deprecated: [g_queue_pop_head_link: pop_head_link].}
{.deprecated: [g_queue_pop_tail_link: pop_tail_link].}
{.deprecated: [g_queue_pop_nth_link: pop_nth_link].}
{.deprecated: [g_queue_peek_head_link: peek_head_link].}
{.deprecated: [g_queue_peek_tail_link: peek_tail_link].}
{.deprecated: [g_queue_peek_nth_link: peek_nth_link].}
{.deprecated: [g_queue_link_index: link_index].}
{.deprecated: [g_queue_unlink: unlink].}
{.deprecated: [g_queue_delete_link: delete_link].}
{.deprecated: [g_rand_free: free].}
{.deprecated: [g_rand_copy: copy].}
{.deprecated: [g_rand_set_seed: set_seed].}
{.deprecated: [g_rand_set_seed_array: set_seed_array].}
{.deprecated: [g_rand_int_range: int_range].}
{.deprecated: [g_rand_double: double].}
{.deprecated: [g_rand_double_range: double_range].}
{.deprecated: [g_regex_ref: `ref`].}
{.deprecated: [g_regex_unref: unref].}
{.deprecated: [g_regex_get_pattern: get_pattern].}
{.deprecated: [g_regex_get_max_backref: get_max_backref].}
{.deprecated: [g_regex_get_capture_count: get_capture_count].}
{.deprecated: [g_regex_get_has_cr_or_lf: get_has_cr_or_lf].}
{.deprecated: [g_regex_get_max_lookbehind: get_max_lookbehind].}
{.deprecated: [g_regex_get_string_number: get_string_number].}
{.deprecated: [g_regex_get_compile_flags: get_compile_flags].}
{.deprecated: [g_regex_get_match_flags: get_match_flags].}
{.deprecated: [g_regex_match: match].}
{.deprecated: [g_regex_match_full: match_full].}
{.deprecated: [g_regex_match_all: match_all].}
{.deprecated: [g_regex_match_all_full: match_all_full].}
{.deprecated: [g_regex_split: split].}
{.deprecated: [g_regex_split_full: split_full].}
{.deprecated: [g_regex_replace: replace].}
{.deprecated: [g_regex_replace_literal: replace_literal].}
{.deprecated: [g_regex_replace_eval: replace_eval].}
{.deprecated: [g_match_info_get_regex: get_regex].}
{.deprecated: [g_match_info_get_string: get_string].}
{.deprecated: [g_match_info_ref: `ref`].}
{.deprecated: [g_match_info_unref: unref].}
{.deprecated: [g_match_info_free: free].}
{.deprecated: [g_match_info_next: next].}
{.deprecated: [g_match_info_matches: matches].}
{.deprecated: [g_match_info_get_match_count: get_match_count].}
{.deprecated: [g_match_info_is_partial_match: is_partial_match].}
{.deprecated: [g_match_info_expand_references: expand_references].}
{.deprecated: [g_match_info_fetch: fetch].}
{.deprecated: [g_match_info_fetch_pos: fetch_pos].}
{.deprecated: [g_match_info_fetch_named: fetch_named].}
{.deprecated: [g_match_info_fetch_named_pos: fetch_named_pos].}
{.deprecated: [g_match_info_fetch_all: fetch_all].}
{.deprecated: [g_scanner_destroy: destroy].}
{.deprecated: [g_scanner_input_file: input_file].}
{.deprecated: [g_scanner_sync_file_offset: sync_file_offset].}
{.deprecated: [g_scanner_input_text: input_text].}
{.deprecated: [g_scanner_get_next_token: get_next_token].}
{.deprecated: [g_scanner_peek_next_token: peek_next_token].}
{.deprecated: [g_scanner_cur_token: cur_token].}
{.deprecated: [g_scanner_cur_value: cur_value].}
{.deprecated: [g_scanner_cur_line: cur_line].}
{.deprecated: [g_scanner_cur_position: cur_position].}
{.deprecated: [g_scanner_eof: eof].}
{.deprecated: [g_scanner_set_scope: set_scope].}
{.deprecated: [g_scanner_scope_add_symbol: scope_add_symbol].}
{.deprecated: [g_scanner_scope_remove_symbol: scope_remove_symbol].}
{.deprecated: [g_scanner_scope_lookup_symbol: scope_lookup_symbol].}
{.deprecated: [g_scanner_scope_foreach_symbol: scope_foreach_symbol].}
{.deprecated: [g_scanner_lookup_symbol: lookup_symbol].}
{.deprecated: [g_scanner_unexp_token: unexp_token].}
{.deprecated: [g_scanner_error: error].}
{.deprecated: [g_scanner_warn: warn].}
{.deprecated: [g_sequence_free: free].}
{.deprecated: [g_sequence_get_length: get_length].}
{.deprecated: [g_sequence_foreach: foreach].}
{.deprecated: [g_sequence_foreach_range: foreach_range].}
{.deprecated: [g_sequence_sort: sort].}
{.deprecated: [g_sequence_sort_iter: sort_iter].}
{.deprecated: [g_sequence_get_begin_iter: get_begin_iter].}
{.deprecated: [g_sequence_get_end_iter: get_end_iter].}
{.deprecated: [g_sequence_get_iter_at_pos: get_iter_at_pos].}
{.deprecated: [g_sequence_append: append].}
{.deprecated: [g_sequence_prepend: prepend].}
{.deprecated: [g_sequence_insert_before: insert_before].}
{.deprecated: [g_sequence_move: move].}
{.deprecated: [g_sequence_swap: swap].}
{.deprecated: [g_sequence_insert_sorted: insert_sorted].}
{.deprecated: [g_sequence_insert_sorted_iter: insert_sorted_iter].}
{.deprecated: [g_sequence_sort_changed: sort_changed].}
{.deprecated: [g_sequence_sort_changed_iter: sort_changed_iter].}
{.deprecated: [g_sequence_remove: remove].}
{.deprecated: [g_sequence_remove_range: remove_range].}
{.deprecated: [g_sequence_move_range: move_range].}
{.deprecated: [g_sequence_search: search].}
{.deprecated: [g_sequence_search_iter: search_iter].}
{.deprecated: [g_sequence_lookup: lookup].}
{.deprecated: [g_sequence_lookup_iter: lookup_iter].}
{.deprecated: [g_sequence_get: get].}
{.deprecated: [g_sequence_set: set].}
{.deprecated: [g_sequence_iter_is_begin: is_begin].}
{.deprecated: [g_sequence_iter_is_end: is_end].}
{.deprecated: [g_sequence_iter_next: next].}
{.deprecated: [g_sequence_iter_prev: prev].}
{.deprecated: [g_sequence_iter_get_position: get_position].}
{.deprecated: [g_sequence_iter_move: move].}
{.deprecated: [g_sequence_iter_get_sequence: get_sequence].}
{.deprecated: [g_sequence_iter_compare: compare].}
{.deprecated: [g_sequence_range_get_midpoint: range_get_midpoint].}
{.deprecated: [g_string_chunk_free: free].}
{.deprecated: [g_string_chunk_clear: clear].}
{.deprecated: [g_string_chunk_insert: insert].}
{.deprecated: [g_string_chunk_insert_len: insert_len].}
{.deprecated: [g_string_chunk_insert_const: insert_const].}
{.deprecated: [g_test_suite_add: add].}
{.deprecated: [g_test_suite_add_suite: add_suite].}
{.deprecated: [g_test_log_type_name: name].}
{.deprecated: [g_test_log_buffer_free: free].}
{.deprecated: [g_test_log_buffer_push: push].}
{.deprecated: [g_test_log_buffer_pop: pop].}
{.deprecated: [g_test_log_msg_free: free].}
{.deprecated: [g_thread_pool_free: free].}
{.deprecated: [g_thread_pool_push: push].}
{.deprecated: [g_thread_pool_unprocessed: unprocessed].}
{.deprecated: [g_thread_pool_set_sort_function: set_sort_function].}
{.deprecated: [g_thread_pool_set_max_threads: set_max_threads].}
{.deprecated: [g_thread_pool_get_max_threads: get_max_threads].}
{.deprecated: [g_thread_pool_get_num_threads: get_num_threads].}
{.deprecated: [g_timer_destroy: destroy].}
{.deprecated: [g_timer_start: start].}
{.deprecated: [g_timer_stop: stop].}
{.deprecated: [g_timer_reset: reset].}
{.deprecated: [g_timer_continue: `continue`].}
{.deprecated: [g_timer_elapsed: elapsed].}
{.deprecated: [g_time_val_add: add].}
{.deprecated: [g_time_val_to_iso8601: to_iso8601].}
{.deprecated: [g_trash_stack_push: push].}
{.deprecated: [g_trash_stack_pop: pop].}
{.deprecated: [g_trash_stack_peek: peek].}
{.deprecated: [g_trash_stack_height: height].}
{.deprecated: [g_tree_ref: `ref`].}
{.deprecated: [g_tree_unref: unref].}
{.deprecated: [g_tree_destroy: destroy].}
{.deprecated: [g_tree_insert: insert].}
{.deprecated: [g_tree_replace: replace].}
{.deprecated: [g_tree_remove: remove].}
{.deprecated: [g_tree_steal: steal].}
{.deprecated: [g_tree_lookup: lookup].}
{.deprecated: [g_tree_lookup_extended: lookup_extended].}
{.deprecated: [g_tree_foreach: foreach].}
{.deprecated: [g_tree_traverse: traverse].}
{.deprecated: [g_tree_search: search].}
{.deprecated: [g_tree_height: height].}
{.deprecated: [g_tree_nnodes: nnodes].}
{.deprecated: [g_variant_type_free: free].}
{.deprecated: [g_variant_type_copy: copy].}
{.deprecated: [g_variant_type_get_string_length: get_string_length].}
{.deprecated: [g_variant_type_peek_string: peek_string].}
{.deprecated: [g_variant_type_dup_string: dup_string].}
{.deprecated: [g_variant_type_is_definite: is_definite].}
{.deprecated: [g_variant_type_is_container: is_container].}
{.deprecated: [g_variant_type_is_basic: is_basic].}
{.deprecated: [g_variant_type_is_maybe: is_maybe].}
{.deprecated: [g_variant_type_is_array: is_array].}
{.deprecated: [g_variant_type_is_tuple: is_tuple].}
{.deprecated: [g_variant_type_is_dict_entry: is_dict_entry].}
{.deprecated: [g_variant_type_is_variant: is_variant].}
{.deprecated: [g_variant_type_is_subtype_of: is_subtype_of].}
{.deprecated: [g_variant_type_element: element].}
{.deprecated: [g_variant_type_first: first].}
{.deprecated: [g_variant_type_next: next].}
{.deprecated: [g_variant_type_n_items: n_items].}
{.deprecated: [g_variant_type_key: key].}
{.deprecated: [g_variant_type_value: value].}
{.deprecated: [g_variant_type_new_array: new_array].}
{.deprecated: [g_variant_type_new_maybe: new_maybe].}
{.deprecated: [g_variant_type_new_tuple: new_tuple].}
{.deprecated: [g_variant_type_new_dict_entry: new_dict_entry].}
{.deprecated: [g_variant_unref: unref].}
{.deprecated: [g_variant_ref: `ref`].}
{.deprecated: [g_variant_ref_sink: ref_sink].}
{.deprecated: [g_variant_is_floating: is_floating].}
{.deprecated: [g_variant_take_ref: take_ref].}
{.deprecated: [g_variant_get_type: get_type].}
{.deprecated: [g_variant_get_type_string: get_type_string].}
{.deprecated: [g_variant_is_of_type: is_of_type].}
{.deprecated: [g_variant_is_container: is_container].}
{.deprecated: [g_variant_classify: classify].}
{.deprecated: [g_variant_new_variant: new_variant].}
{.deprecated: [g_variant_get_boolean: get_boolean].}
{.deprecated: [g_variant_get_byte: get_byte].}
{.deprecated: [g_variant_get_int16: get_int16].}
{.deprecated: [g_variant_get_uint16: get_uint16].}
{.deprecated: [g_variant_get_int32: get_int32].}
{.deprecated: [g_variant_get_uint32: get_uint32].}
{.deprecated: [g_variant_get_int64: get_int64].}
{.deprecated: [g_variant_get_uint64: get_uint64].}
{.deprecated: [g_variant_get_handle: get_handle].}
{.deprecated: [g_variant_get_double: get_double].}
{.deprecated: [g_variant_get_variant: get_variant].}
{.deprecated: [g_variant_get_string: get_string].}
{.deprecated: [g_variant_dup_string: dup_string].}
{.deprecated: [g_variant_get_strv: get_strv].}
{.deprecated: [g_variant_dup_strv: dup_strv].}
{.deprecated: [g_variant_get_objv: get_objv].}
{.deprecated: [g_variant_dup_objv: dup_objv].}
{.deprecated: [g_variant_get_bytestring: get_bytestring].}
{.deprecated: [g_variant_dup_bytestring: dup_bytestring].}
{.deprecated: [g_variant_get_bytestring_array: get_bytestring_array].}
{.deprecated: [g_variant_dup_bytestring_array: dup_bytestring_array].}
{.deprecated: [g_variant_new_tuple: new_tuple].}
{.deprecated: [g_variant_new_dict_entry: new_dict_entry].}
{.deprecated: [g_variant_get_maybe: get_maybe].}
{.deprecated: [g_variant_n_children: n_children].}
{.deprecated: [g_variant_get_child: get_child].}
{.deprecated: [g_variant_get_child_value: get_child_value].}
{.deprecated: [g_variant_lookup: lookup].}
{.deprecated: [g_variant_lookup_value: lookup_value].}
{.deprecated: [g_variant_get_fixed_array: get_fixed_array].}
{.deprecated: [g_variant_get_size: get_size].}
{.deprecated: [g_variant_get_data: get_data].}
{.deprecated: [g_variant_get_data_as_bytes: get_data_as_bytes].}
{.deprecated: [g_variant_store: store].}
{.deprecated: [g_variant_print: print].}
{.deprecated: [g_variant_print_string: print_string].}
{.deprecated: [g_variant_get_normal_form: get_normal_form].}
{.deprecated: [g_variant_is_normal_form: is_normal_form].}
{.deprecated: [g_variant_byteswap: byteswap].}
{.deprecated: [g_variant_iter_new: iter_new].}
{.deprecated: [g_variant_iter_init: init].}
{.deprecated: [g_variant_iter_copy: copy].}
{.deprecated: [g_variant_iter_n_children: n_children].}
{.deprecated: [g_variant_iter_free: free].}
{.deprecated: [g_variant_iter_next_value: next_value].}
{.deprecated: [g_variant_iter_next: next].}
{.deprecated: [g_variant_iter_loop: loop].}
{.deprecated: [g_variant_builder_unref: unref].}
{.deprecated: [g_variant_builder_ref: `ref`].}
{.deprecated: [g_variant_builder_init: init].}
{.deprecated: [g_variant_builder_end: `end`].}
{.deprecated: [g_variant_builder_clear: clear].}
{.deprecated: [g_variant_builder_open: open].}
{.deprecated: [g_variant_builder_close: close].}
{.deprecated: [g_variant_builder_add_value: add_value].}
{.deprecated: [g_variant_builder_add: add].}
{.deprecated: [g_variant_builder_add_parsed: add_parsed].}
{.deprecated: [g_variant_get: get].}
{.deprecated: [g_variant_dict_new: dict_new].}
{.deprecated: [g_variant_dict_init: init].}
{.deprecated: [g_variant_dict_lookup: lookup].}
{.deprecated: [g_variant_dict_lookup_value: lookup_value].}
{.deprecated: [g_variant_dict_contains: contains].}
{.deprecated: [g_variant_dict_insert: insert].}
{.deprecated: [g_variant_dict_insert_value: insert_value].}
{.deprecated: [g_variant_dict_remove: remove].}
{.deprecated: [g_variant_dict_clear: clear].}
{.deprecated: [g_variant_dict_end: `end`].}
{.deprecated: [g_variant_dict_ref: `ref`].}
{.deprecated: [g_variant_dict_unref: unref].}
