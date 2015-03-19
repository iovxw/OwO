{.deadCodeElim: on.}

when defined(windows):
  const LIB_GIO = "libgio-2.0-0.dll"
elif defined(macosx):
  const LIB_GIO = "libgio-2.0(|-0).dylib"
else:
  const LIB_GIO = "libgio-2.0.so(|.0)"

{.pragma: libgio, cdecl, dynlib: LIB_GIO.}

from gobject import GObject, GType, GTypeInterface, GTypeInterfaceObj, GObjectClass, GCallback, GObjectObj,
  GObjectClassObj, GValue, GClosure

from glib import gpointer, gboolean, goffset, guint64, gsize, gssize, gconstpointer, guint, gint, GList, GBytes,
  GDestroyNotify, gulong, GVariantType, GVariant, GError, guchar, gint16, gint32, gint64, guint32, GOptionGroup,
  GIOCondition, GOptionFlags, GOptionArg, guint16, GQuark, GSeekType, guint8, GSourceFunc, gdouble, GCompareDataFunc,
  GSpawnChildSetupFunc

from posix import TPid, TUid

type
  pid_t = TPid
  uid_t = TUid

# from glibconfig.h.win32
const
  GLIB_SYSDEF_AF_UNIX = 1
  GLIB_SYSDEF_AF_INET = 2
  GLIB_SYSDEF_AF_INET6 = 23
  GLIB_SYSDEF_MSG_OOB = 1
  GLIB_SYSDEF_MSG_PEEK = 2
  GLIB_SYSDEF_MSG_DONTROUTE = 4

type
  GAppInfoCreateFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, NEEDS_TERMINAL = (1 shl 0),
    SUPPORTS_URIS = (1 shl 1),
    SUPPORTS_STARTUP_NOTIFICATION = (1 shl 2)
type
  GConverterFlags* {.size: sizeof(cint), pure.} = enum
    NO_FLAGS = 0, INPUT_AT_END = (1 shl 0),
    FLUSH = (1 shl 1)
type
  GConverterResult* {.size: sizeof(cint), pure.} = enum
    ERROR = 0, CONVERTED = 1,
    FINISHED = 2, FLUSHED = 3
type
  GDataStreamByteOrder* {.size: sizeof(cint), pure.} = enum
    BIG_ENDIAN,
    LITTLE_ENDIAN,
    HOST_ENDIAN
type
  GDataStreamNewlineType* {.size: sizeof(cint), pure.} = enum
    LF, CR,
    CR_LF, ANY
type
  GFileAttributeType* {.size: sizeof(cint), pure.} = enum
    INVALID = 0, STRING,
    BYTE_STRING, BOOLEAN,
    UINT32, INT32,
    UINT64, INT64,
    OBJECT, STRINGV
type
  GFileAttributeInfoFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    COPY_WITH_FILE = (1 shl 0),
    COPY_WHEN_MOVED = (1 shl 1)
type
  GFileAttributeStatus* {.size: sizeof(cint), pure.} = enum
    UNSET = 0, SET,
    ERROR_SETTING
type
  GFileQueryInfoFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    NOFOLLOW_SYMLINKS = (1 shl 0)
type
  GFileCreateFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, PRIVATE = (1 shl 0),
    REPLACE_DESTINATION = (1 shl 1)
type
  GFileMeasureFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, REPORT_ANY_ERROR = (1 shl 1),
    APPARENT_SIZE = (1 shl 2),
    NO_XDEV = (1 shl 3)
type
  GMountMountFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0
type
  GMountUnmountFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, FORCE = (1 shl 0)
type
  GDriveStartFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0
type
  GDriveStartStopType* {.size: sizeof(cint), pure.} = enum
    UNKNOWN, SHUTDOWN,
    NETWORK, MULTIDISK,
    PASSWORD
type
  GFileCopyFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, OVERWRITE = (1 shl 0),
    BACKUP = (1 shl 1), NOFOLLOW_SYMLINKS = (1 shl
        2), ALL_METADATA = (1 shl 3),
    NO_FALLBACK_FOR_MOVE = (1 shl 4),
    TARGET_DEFAULT_PERMS = (1 shl 5)
type
  GFileMonitorFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, WATCH_MOUNTS = (1 shl 0),
    SEND_MOVED = (1 shl 1),
    WATCH_HARD_LINKS = (1 shl 2)
type
  GFileType* {.size: sizeof(cint), pure.} = enum
    UNKNOWN = 0, REGULAR, DIRECTORY,
    SYMBOLIC_LINK, SPECIAL, SHORTCUT,
    MOUNTABLE
type
  GFilesystemPreviewType* {.size: sizeof(cint), pure.} = enum
    IF_ALWAYS = 0,
    IF_LOCAL, NEVER
type
  GFileMonitorEvent* {.size: sizeof(cint), pure.} = enum
    CHANGED, CHANGES_DONE_HINT,
    DELETED, CREATED,
    ATTRIBUTE_CHANGED, PRE_UNMOUNT,
    UNMOUNTED, MOVED
type
  GIOErrorEnum* {.size: sizeof(cint), pure.} = enum
    FAILED, NOT_FOUND, EXISTS,
    IS_DIRECTORY, NOT_DIRECTORY, NOT_EMPTY,
    NOT_REGULAR_FILE, NOT_SYMBOLIC_LINK,
    NOT_MOUNTABLE_FILE, FILENAME_TOO_LONG,
    INVALID_FILENAME, TOO_MANY_LINKS,
    NO_SPACE, INVALID_ARGUMENT,
    PERMISSION_DENIED, NOT_SUPPORTED,
    NOT_MOUNTED, ALREADY_MOUNTED, CLOSED,
    CANCELLED, PENDING, READ_ONLY,
    CANT_CREATE_BACKUP, WRONG_ETAG,
    TIMED_OUT, WOULD_RECURSE, BUSY,
    WOULD_BLOCK, HOST_NOT_FOUND, WOULD_MERGE,
    FAILED_HANDLED, TOO_MANY_OPEN_FILES,
    NOT_INITIALIZED, ADDRESS_IN_USE,
    PARTIAL_INPUT, INVALID_DATA, DBUS_ERROR,
    HOST_UNREACHABLE, NETWORK_UNREACHABLE,
    CONNECTION_REFUSED, PROXY_FAILED,
    PROXY_AUTH_FAILED, PROXY_NEED_AUTH,
    PROXY_NOT_ALLOWED, BROKEN_PIPE,
    NOT_CONNECTED
const
 CONNECTION_CLOSED = GIOErrorEnum.BROKEN_PIPE
type
  GAskPasswordFlags* {.size: sizeof(cint), pure.} = enum
    NEED_PASSWORD = (1 shl 0),
    NEED_USERNAME = (1 shl 1),
    NEED_DOMAIN = (1 shl 2),
    SAVING_SUPPORTED = (1 shl 3),
    ANONYMOUS_SUPPORTED = (1 shl 4)
type
  GPasswordSave* {.size: sizeof(cint), pure.} = enum
    NEVER, FOR_SESSION,
    PERMANENTLY
type
  GMountOperationResult* {.size: sizeof(cint), pure.} = enum
    HANDLED, ABORTED,
    UNHANDLED
type
  GOutputStreamSpliceFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    CLOSE_SOURCE = (1 shl 0),
    CLOSE_TARGET = (1 shl 1)
type
  GIOStreamSpliceFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, CLOSE_STREAM1 = (1 shl
        0), CLOSE_STREAM2 = (1 shl 1),
    WAIT_FOR_BOTH = (1 shl 2)
type
  GEmblemOrigin* {.size: sizeof(cint), pure.} = enum
    UNKNOWN, DEVICE,
    LIVEMETADATA, TAG
type
  GResolverError* {.size: sizeof(cint), pure.} = enum
    NOT_FOUND, TEMPORARY_FAILURE,
    INTERNAL
type
  GResolverRecordType* {.size: sizeof(cint), pure.} = enum
    SRV = 1, MX, TXT,
    SOA, NS
type
  GResourceError* {.size: sizeof(cint), pure.} = enum
    NOT_FOUND, INTERNAL
type
  GResourceFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, COMPRESSED = (1 shl 0)
type
  GResourceLookupFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0
type
  GSocketFamily* {.size: sizeof(cint), pure.} = enum
    INVALID, UNIX = GLIB_SYSDEF_AF_UNIX,
    IPV4 = GLIB_SYSDEF_AF_INET,
    IPV6 = GLIB_SYSDEF_AF_INET6
type
  GSocketType* {.size: sizeof(cint), pure.} = enum
    INVALID, STREAM, DATAGRAM,
    SEQPACKET
type
  GSocketMsgFlags* {.size: sizeof(cint), pure.} = enum
    NONE, OOB = GLIB_SYSDEF_MSG_OOB,
    PEEK = GLIB_SYSDEF_MSG_PEEK,
    DONTROUTE = GLIB_SYSDEF_MSG_DONTROUTE
type
  GSocketProtocol* {.size: sizeof(cint), pure.} = enum
    UNKNOWN = - 1, DEFAULT = 0,
    TCP = 6, UDP = 17,
    SCTP = 132
type
  GZlibCompressorFormat* {.size: sizeof(cint), pure.} = enum
    ZLIB, GZIP,
    RAW
type
  GUnixSocketAddressType* {.size: sizeof(cint), pure.} = enum
    INVALID, ANONYMOUS,
    PATH, ABSTRACT,
    ABSTRACT_PADDED
type
  GBusType* {.size: sizeof(cint), pure.} = enum
    STARTER = - 1, NONE = 0, SYSTEM = 1,
    SESSION = 2
type
  GBusNameOwnerFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    ALLOW_REPLACEMENT = (1 shl 0),
    REPLACE = (1 shl 1)
type
  GBusNameWatcherFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    AUTO_START = (1 shl 0)
type
  GDBusProxyFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    DO_NOT_LOAD_PROPERTIES = (1 shl 0),
    DO_NOT_CONNECT_SIGNALS = (1 shl 1),
    DO_NOT_AUTO_START = (1 shl 2),
    GET_INVALIDATED_PROPERTIES = (1 shl 3),
    DO_NOT_AUTO_START_AT_CONSTRUCTION = (1 shl 4)
type
  GDBusError* {.size: sizeof(cint), pure.} = enum
    FAILED, NO_MEMORY, SERVICE_UNKNOWN,
    NAME_HAS_NO_OWNER, NO_REPLY,
    IO_ERROR, BAD_ADDRESS,
    NOT_SUPPORTED, LIMITS_EXCEEDED,
    ACCESS_DENIED, AUTH_FAILED,
    NO_SERVER, TIMEOUT, NO_NETWORK,
    ADDRESS_IN_USE, DISCONNECTED,
    INVALID_ARGS, FILE_NOT_FOUND,
    FILE_EXISTS, UNKNOWN_METHOD,
    TIMED_OUT, MATCH_RULE_NOT_FOUND,
    MATCH_RULE_INVALID, SPAWN_EXEC_FAILED,
    SPAWN_FORK_FAILED, SPAWN_CHILD_EXITED,
    SPAWN_CHILD_SIGNALED, SPAWN_FAILED,
    SPAWN_SETUP_FAILED, SPAWN_CONFIG_INVALID,
    SPAWN_SERVICE_INVALID, SPAWN_SERVICE_NOT_FOUND,
    SPAWN_PERMISSIONS_INVALID, SPAWN_FILE_INVALID,
    SPAWN_NO_MEMORY, UNIX_PROCESS_ID_UNKNOWN,
    INVALID_SIGNATURE, INVALID_FILE_CONTENT,
    SELINUX_SECURITY_CONTEXT_UNKNOWN,
    ADT_AUDIT_DATA_UNKNOWN, OBJECT_PATH_IN_USE,
    UNKNOWN_OBJECT, UNKNOWN_INTERFACE,
    UNKNOWN_PROPERTY, PROPERTY_READ_ONLY
type
  GDBusConnectionFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    AUTHENTICATION_CLIENT = (1 shl 0),
    AUTHENTICATION_SERVER = (1 shl 1),
    AUTHENTICATION_ALLOW_ANONYMOUS = (1 shl 2),
    MESSAGE_BUS_CONNECTION = (1 shl 3),
    DELAY_MESSAGE_PROCESSING = (1 shl 4)
type
  GDBusCapabilityFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    UNIX_FD_PASSING = (1 shl 0)
type
  GDBusCallFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, NO_AUTO_START = (1 shl 0)
type
  GDBusMessageType* {.size: sizeof(cint), pure.} = enum
    INVALID, METHOD_CALL,
    METHOD_RETURN, ERROR,
    SIGNAL
type
  GDBusMessageFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    NO_REPLY_EXPECTED = (1 shl 0),
    NO_AUTO_START = (1 shl 1)
type
  GDBusMessageHeaderField* {.size: sizeof(cint), pure.} = enum
    INVALID, PATH,
    INTERFACE, MEMBER,
    ERROR_NAME,
    REPLY_SERIAL,
    DESTINATION,
    SENDER, SIGNATURE,
    NUM_UNIX_FDS
type
  GDBusPropertyInfoFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    READABLE = (1 shl 0),
    WRITABLE = (1 shl 1)
type
  GDBusSubtreeFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    DISPATCH_TO_UNENUMERATED_NODES = (1 shl 0)
type
  GDBusServerFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    RUN_IN_THREAD = (1 shl 0),
    AUTHENTICATION_ALLOW_ANONYMOUS = (1 shl 1)
type
  GDBusSignalFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    NO_MATCH_RULE = (1 shl 0),
    MATCH_ARG0_NAMESPACE = (1 shl 1),
    MATCH_ARG0_PATH = (1 shl 2)
type
  GDBusSendMessageFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    PRESERVE_SERIAL = (1 shl 0)
type
  GCredentialsType* {.size: sizeof(cint), pure.} = enum
    INVALID, LINUX_UCRED,
    FREEBSD_CMSGCRED,
    OPENBSD_SOCKPEERCRED, SOLARIS_UCRED,
    NETBSD_UNPCBID
type
  GDBusMessageByteOrder* {.size: sizeof(cint), pure.} = enum
    BIG_ENDIAN = 'B',
    LITTLE_ENDIAN = 'l'
type
  GApplicationFlags* {.size: sizeof(cint), pure.} = enum
    NONE, IS_SERVICE = (1 shl 0),
    IS_LAUNCHER = (1 shl 1),
    HANDLES_OPEN = (1 shl 2),
    HANDLES_COMMAND_LINE = (1 shl 3),
    SEND_ENVIRONMENT = (1 shl 4),
    NON_UNIQUE = (1 shl 5)
type
  GTlsError* {.size: sizeof(cint), pure.} = enum
    UNAVAILABLE, MISC, BAD_CERTIFICATE,
    NOT_TLS, HANDSHAKE,
    CERTIFICATE_REQUIRED, EOF
type
  GTlsCertificateFlags* {.size: sizeof(cint), pure.} = enum
    UNKNOWN_CA = (1 shl 0),
    BAD_IDENTITY = (1 shl 1),
    NOT_ACTIVATED = (1 shl 2),
    EXPIRED = (1 shl 3),
    REVOKED = (1 shl 4),
    INSECURE = (1 shl 5),
    GENERIC_ERROR = (1 shl 6),
    VALIDATE_ALL = 0x7F
type
  GTlsAuthenticationMode* {.size: sizeof(cint), pure.} = enum
    NONE, REQUESTED,
    REQUIRED
type
  GTlsRehandshakeMode* {.size: sizeof(cint), pure.} = enum
    NEVER, SAFELY,
    UNSAFELY
type
  GTlsPasswordFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, RETRY = 1 shl 1,
    MANY_TRIES = 1 shl 2, FINAL_TRY = 1 shl 3
type
  GTlsInteractionResult* {.size: sizeof(cint), pure.} = enum
    UNHANDLED, HANDLED,
    FAILED
type
  GDBusInterfaceSkeletonFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, HANDLE_METHOD_INVOCATIONS_IN_THREAD = (
        1 shl 0)
type
  GDBusObjectManagerClientFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    DO_NOT_AUTO_START = (1 shl 0)
type
  GTlsDatabaseVerifyFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0
type
  GTlsDatabaseLookupFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, KEYPAIR = 1
type
  GTlsCertificateRequestFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0
type
  GIOModuleScopeFlags* {.size: sizeof(cint), pure.} = enum
    NONE, BLOCK_DUPLICATES
type
  GSocketClientEvent* {.size: sizeof(cint), pure.} = enum
    RESOLVING, RESOLVED,
    CONNECTING, CONNECTED,
    PROXY_NEGOTIATING, PROXY_NEGOTIATED,
    TLS_HANDSHAKING, TLS_HANDSHAKED,
    COMPLETE
type
  GTestDBusFlags* {.size: sizeof(cint), pure.} = enum
    DBUS_NONE = 0
type
  GSubprocessFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, STDIN_PIPE = (1 shl 0),
    STDIN_INHERIT = (1 shl 1),
    STDOUT_PIPE = (1 shl 2),
    STDOUT_SILENCE = (1 shl 3),
    STDERR_PIPE = (1 shl 4),
    STDERR_SILENCE = (1 shl 5),
    STDERR_MERGE = (1 shl 6),
    INHERIT_FDS = (1 shl 7)
type
  GNotificationPriority* {.size: sizeof(cint), pure.} = enum
    NORMAL, LOW,
    HIGH, URGENT
type
  GNetworkConnectivity* {.size: sizeof(cint), pure.} = enum
    LOCAL = 1, LIMITED = 2,
    PORTAL = 3, FULL = 4
type
  GDBusObjectManagerClientPrivateObj = object
 
type
  GDBusObjectManagerClient* =  ptr GDBusObjectManagerClientObj
  GDBusObjectManagerClientPtr* = ptr GDBusObjectManagerClientObj
  GDBusObjectManagerClientObj*{.final.} = object of GObjectObj
    priv1: ptr GDBusObjectManagerClientPrivateObj
type
  GSocketControlMessagePrivateObj = object
 
type
  GSocketControlMessage* =  ptr GSocketControlMessageObj
  GSocketControlMessagePtr* = ptr GSocketControlMessageObj
  GSocketControlMessageObj*{.final.} = object of GObjectObj
    priv2: ptr GSocketControlMessagePrivateObj
type
  GSocketAddress* =  ptr GSocketAddressObj
  GSocketAddressPtr* = ptr GSocketAddressObj
  GSocketAddressObj* = object of GObjectObj
type
  GSocketPrivateObj = object
type
  GSocket* =  ptr GSocketObj
  GSocketPtr* = ptr GSocketObj
  GSocketObj*{.final.} = object of GObjectObj
    priv3: ptr GSocketPrivateObj
type
  GCancellablePrivateObj = object
 
type
  GCancellable* =  ptr GCancellableObj
  GCancellablePtr* = ptr GCancellableObj
  GCancellableObj*{.final.} = object of GObjectObj
    priv4: ptr GCancellablePrivateObj

type
  GAppInfo* =  ptr GAppInfoObj
  GAppInfoPtr* = ptr GAppInfoObj
  GAppInfoObj* = object
 
type
  GAsyncResult* =  ptr GAsyncResultObj
  GAsyncResultPtr* = ptr GAsyncResultObj
  GAsyncResultObj* = object
 
type
  GAsyncInitable* =  ptr GAsyncInitableObj
  GAsyncInitablePtr* = ptr GAsyncInitableObj
  GAsyncInitableObj* = object
 
  GCharsetConverter* =  ptr GCharsetConverterObj
  GCharsetConverterPtr* = ptr GCharsetConverterObj
  GCharsetConverterObj* = object
 
  GConverter* =  ptr GConverterObj
  GConverterPtr* = ptr GConverterObj
  GConverterObj* = object
 
  GSimplePermission* =  ptr GSimplePermissionObj
  GSimplePermissionPtr* = ptr GSimplePermissionObj
  GSimplePermissionObj* = object
 
  GZlibCompressor* =  ptr GZlibCompressorObj
  GZlibCompressorPtr* = ptr GZlibCompressorObj
  GZlibCompressorObj* = object
 
  GZlibDecompressor* =  ptr GZlibDecompressorObj
  GZlibDecompressorPtr* = ptr GZlibDecompressorObj
  GZlibDecompressorObj* = object
 
  GRemoteActionGroup* =  ptr GRemoteActionGroupObj
  GRemoteActionGroupPtr* = ptr GRemoteActionGroupObj
  GRemoteActionGroupObj* = object
 
  GDBusActionGroup* =  ptr GDBusActionGroupObj
  GDBusActionGroupPtr* = ptr GDBusActionGroupObj
  GDBusActionGroupObj* = object
 
  GActionMap* =  ptr GActionMapObj
  GActionMapPtr* = ptr GActionMapObj
  GActionMapObj* = object
 
  GActionGroup* =  ptr GActionGroupObj
  GActionGroupPtr* = ptr GActionGroupObj
  GActionGroupObj* = object
 
  GPropertyAction* =  ptr GPropertyActionObj
  GPropertyActionPtr* = ptr GPropertyActionObj
  GPropertyActionObj* = object
 
  GSimpleAction* =  ptr GSimpleActionObj
  GSimpleActionPtr* = ptr GSimpleActionObj
  GSimpleActionObj* = object
 
  GAction* =  ptr GActionObj
  GActionPtr* = ptr GActionObj
  GActionObj* = object
 
  GSettingsBackend* =  ptr GSettingsBackendObj
  GSettingsBackendPtr* = ptr GSettingsBackendObj
  GSettingsBackendObj* = object
 
  GNotification* =  ptr GNotificationObj
  GNotificationPtr* = ptr GNotificationObj
  GNotificationObj* = object
 
  GListModel* =  ptr GListModelObj
  GListModelPtr* = ptr GListModelObj
  GListModelObj* = object
 
  GListStore* =  ptr GListStoreObj
  GListStorePtr* = ptr GListStoreObj
  GListStoreObj* = object
 
type
  GDrive* =  ptr GDriveObj
  GDrivePtr* = ptr GDriveObj
  GDriveObj* = object
 
type
  GFile* =  ptr GFileObj
  GFilePtr* = ptr GFileObj
  GFileObj* = object
 
type
  GFileInfo* =  ptr GFileInfoObj
  GFileInfoPtr* = ptr GFileInfoObj
  GFileInfoObj* = object
 
type
  GFileAttributeMatcher* =  ptr GFileAttributeMatcherObj
  GFileAttributeMatcherPtr* = ptr GFileAttributeMatcherObj
  GFileAttributeMatcherObj* = object
 
  GFileDescriptorBased* =  ptr GFileDescriptorBasedObj
  GFileDescriptorBasedPtr* = ptr GFileDescriptorBasedObj
  GFileDescriptorBasedObj* = object
 
  GFileIcon* =  ptr GFileIconObj
  GFileIconPtr* = ptr GFileIconObj
  GFileIconObj* = object
 
  GFilenameCompleter* =  ptr GFilenameCompleterObj
  GFilenameCompleterPtr* = ptr GFilenameCompleterObj
  GFilenameCompleterObj* = object
 
  GIcon* =  ptr GIconObj
  GIconPtr* = ptr GIconObj
  GIconObj* = object
 
type
  GInitable* =  ptr GInitableObj
  GInitablePtr* = ptr GInitableObj
  GInitableObj* = object
 
  GIOModule* =  ptr GIOModuleObj
  GIOModulePtr* = ptr GIOModuleObj
  GIOModuleObj* = object
 
  GIOExtensionPoint* =  ptr GIOExtensionPointObj
  GIOExtensionPointPtr* = ptr GIOExtensionPointObj
  GIOExtensionPointObj* = object
 
  GIOExtension* =  ptr GIOExtensionObj
  GIOExtensionPtr* = ptr GIOExtensionObj
  GIOExtensionObj* = object
 
type
  GIOSchedulerJob* =  ptr GIOSchedulerJobObj
  GIOSchedulerJobPtr* = ptr GIOSchedulerJobObj
  GIOSchedulerJobObj* = object
 
  GIOStreamAdapter* =  ptr GIOStreamAdapterObj
  GIOStreamAdapterPtr* = ptr GIOStreamAdapterObj
  GIOStreamAdapterObj* = object
 
  GLoadableIcon* =  ptr GLoadableIconObj
  GLoadableIconPtr* = ptr GLoadableIconObj
  GLoadableIconObj* = object
 
type
  GBytesIcon* =  ptr GBytesIconObj
  GBytesIconPtr* = ptr GBytesIconObj
  GBytesIconObj* = object
 
type
  GMount* =  ptr GMountObj
  GMountPtr* = ptr GMountObj
  GMountObj* = object
 
type
  GNetworkMonitor* =  ptr GNetworkMonitorObj
  GNetworkMonitorPtr* = ptr GNetworkMonitorObj
  GNetworkMonitorObj* = object
 
  GSimpleIOStream* =  ptr GSimpleIOStreamObj
  GSimpleIOStreamPtr* = ptr GSimpleIOStreamObj
  GSimpleIOStreamObj* = object
 
  GPollableInputStream* =  ptr GPollableInputStreamObj
  GPollableInputStreamPtr* = ptr GPollableInputStreamObj
  GPollableInputStreamObj* = object
 
type
  GPollableOutputStream* =  ptr GPollableOutputStreamObj
  GPollableOutputStreamPtr* = ptr GPollableOutputStreamObj
  GPollableOutputStreamObj* = object
 
type
  GResource* =  ptr GResourceObj
  GResourcePtr* = ptr GResourceObj
  GResourceObj* = object
 
  GSeekable* =  ptr GSeekableObj
  GSeekablePtr* = ptr GSeekableObj
  GSeekableObj* = object
 
  GSimpleAsyncResult* =  ptr GSimpleAsyncResultObj
  GSimpleAsyncResultPtr* = ptr GSimpleAsyncResultObj
  GSimpleAsyncResultObj* = object
 
type
  GSocketConnectable* =  ptr GSocketConnectableObj
  GSocketConnectablePtr* = ptr GSocketConnectableObj
  GSocketConnectableObj* = object
 
  GSrvTarget* =  ptr GSrvTargetObj
  GSrvTargetPtr* = ptr GSrvTargetObj
  GSrvTargetObj* = object
 
  GTask* =  ptr GTaskObj
  GTaskPtr* = ptr GTaskObj
  GTaskObj* = object
 
type
  GThemedIcon* =  ptr GThemedIconObj
  GThemedIconPtr* = ptr GThemedIconObj
  GThemedIconObj* = object
 
  GTlsClientConnection* =  ptr GTlsClientConnectionObj
  GTlsClientConnectionPtr* = ptr GTlsClientConnectionObj
  GTlsClientConnectionObj* = object
 
type
  GTlsFileDatabase* =  ptr GTlsFileDatabaseObj
  GTlsFileDatabasePtr* = ptr GTlsFileDatabaseObj
  GTlsFileDatabaseObj* = object
 
  GTlsServerConnection* =  ptr GTlsServerConnectionObj
  GTlsServerConnectionPtr* = ptr GTlsServerConnectionObj
  GTlsServerConnectionObj* = object
 
type
  GProxyResolver* =  ptr GProxyResolverObj
  GProxyResolverPtr* = ptr GProxyResolverObj
  GProxyResolverObj* = object
 
  GProxy* =  ptr GProxyObj
  GProxyPtr* = ptr GProxyObj
  GProxyObj* = object
 
type
  GVolume* =  ptr GVolumeObj
  GVolumePtr* = ptr GVolumeObj
  GVolumeObj* = object
 
type
  GAsyncReadyCallback* = proc (source_object: GObject;
                               res: GAsyncResult; user_data: gpointer) {.cdecl.}
type
  GFileProgressCallback* = proc (current_num_bytes: goffset;
                                 total_num_bytes: goffset; user_data: gpointer) {.cdecl.}
type
  GFileReadMoreCallback* = proc (file_contents: cstring; file_size: goffset;
                                 callback_data: gpointer): gboolean {.cdecl.}
type
  GFileMeasureProgressCallback* = proc (reporting: gboolean;
      current_size: guint64; num_dirs: guint64; num_files: guint64;
      user_data: gpointer) {.cdecl.}
type
  GIOSchedulerJobFunc* = proc (job: GIOSchedulerJob;
                               cancellable: GCancellable;
                               user_data: gpointer): gboolean {.cdecl.}
type
  GSimpleAsyncThreadFunc* = proc (res: GSimpleAsyncResult;
                                  `object`: GObject;
                                  cancellable: GCancellable) {.cdecl.}
type
  GSocketSourceFunc* = proc (socket: GSocket; condition: GIOCondition;
                             user_data: gpointer): gboolean {.cdecl.}
type
  GInputVector* =  ptr GInputVectorObj
  GInputVectorPtr* = ptr GInputVectorObj
  GInputVectorObj* = object
    buffer*: gpointer
    size*: gsize

type
  GOutputVector* =  ptr GOutputVectorObj
  GOutputVectorPtr* = ptr GOutputVectorObj
  GOutputVectorObj* = object
    buffer*: gconstpointer
    size*: gsize

type
  GOutputMessage* =  ptr GOutputMessageObj
  GOutputMessagePtr* = ptr GOutputMessageObj
  GOutputMessageObj* = object
    address*: GSocketAddress
    vectors*: GOutputVector
    num_vectors*: guint
    bytes_sent*: guint
    control_messages*: ptr GSocketControlMessage
    num_control_messages*: guint

type
  GCredentials* =  ptr GCredentialsObj
  GCredentialsPtr* = ptr GCredentialsObj
  GCredentialsObj* = object
 
  GUnixCredentialsMessage* =  ptr GUnixCredentialsMessageObj
  GUnixCredentialsMessagePtr* = ptr GUnixCredentialsMessageObj
  GUnixCredentialsMessageObj* = object
 
  GUnixFDList* =  ptr GUnixFDListObj
  GUnixFDListPtr* = ptr GUnixFDListObj
  GUnixFDListObj* = object
 
  GDBusMessage* =  ptr GDBusMessageObj
  GDBusMessagePtr* = ptr GDBusMessageObj
  GDBusMessageObj* = object
 
  GDBusConnection* =  ptr GDBusConnectionObj
  GDBusConnectionPtr* = ptr GDBusConnectionObj
  GDBusConnectionObj* = object
 
  GDBusMethodInvocation* =  ptr GDBusMethodInvocationObj
  GDBusMethodInvocationPtr* = ptr GDBusMethodInvocationObj
  GDBusMethodInvocationObj* = object
 
  GDBusServer* =  ptr GDBusServerObj
  GDBusServerPtr* = ptr GDBusServerObj
  GDBusServerObj* = object
 
  GDBusAuthObserver* =  ptr GDBusAuthObserverObj
  GDBusAuthObserverPtr* = ptr GDBusAuthObserverObj
  GDBusAuthObserverObj* = object
 
type
  GCancellableSourceFunc* = proc (cancellable: GCancellable;
                                  user_data: gpointer): gboolean {.cdecl.}
type
  GPollableSourceFunc* = proc (pollable_stream: GObject;
                               user_data: gpointer): gboolean {.cdecl.}
  GDBusInterface* =  ptr GDBusInterfaceObj
  GDBusInterfacePtr* = ptr GDBusInterfaceObj
  GDBusInterfaceObj* = object
 
type
  GDBusObject* =  ptr GDBusObjectObj
  GDBusObjectPtr* = ptr GDBusObjectObj
  GDBusObjectObj* = object
 
type
  GDBusObjectManager* =  ptr GDBusObjectManagerObj
  GDBusObjectManagerPtr* = ptr GDBusObjectManagerObj
  GDBusObjectManagerObj* = object
 
type
  GDBusProxyTypeFunc* = proc (manager: GDBusObjectManagerClient;
                              object_path: cstring; interface_name: cstring;
                              user_data: gpointer): GType {.cdecl.}
  GTestDBus* =  ptr GTestDBusObj
  GTestDBusPtr* = ptr GTestDBusObj
  GTestDBusObj* = object
 
type
  GSubprocess* =  ptr GSubprocessObj
  GSubprocessPtr* = ptr GSubprocessObj
  GSubprocessObj* = object
 
type
  GSubprocessLauncher* =  ptr GSubprocessLauncherObj
  GSubprocessLauncherPtr* = ptr GSubprocessLauncherObj
  GSubprocessLauncherObj* = object
 

template g_action*(inst: expr): expr =
  (g_type_check_instance_cast(inst, action_get_type(), GActionObj))

template g_is_action*(inst: expr): expr =
  (g_type_check_instance_type(inst, action_get_type()))

template g_action_get_iface*(inst: expr): expr =
  (g_type_instance_get_interface(inst, action_get_type(), GActionInterfaceObj))

type
  GActionInterface* =  ptr GActionInterfaceObj
  GActionInterfacePtr* = ptr GActionInterfaceObj
  GActionInterfaceObj*{.final.} = object of GTypeInterfaceObj
    get_name*: proc (action: GAction): cstring {.cdecl.}
    get_parameter_type*: proc (action: GAction): GVariantType {.cdecl.}
    get_state_type*: proc (action: GAction): GVariantType {.cdecl.}
    get_state_hint*: proc (action: GAction): GVariant {.cdecl.}
    get_enabled*: proc (action: GAction): gboolean {.cdecl.}
    get_state*: proc (action: GAction): GVariant {.cdecl.}
    change_state*: proc (action: GAction; value: GVariant) {.cdecl.}
    activate*: proc (action: GAction; parameter: GVariant) {.cdecl.}

proc g_action_get_type*(): GType {.importc: "g_action_get_type", libgio.}
proc get_name*(action: GAction): cstring {.
    importc: "g_action_get_name", libgio.}
proc name*(action: GAction): cstring {.
    importc: "g_action_get_name", libgio.}
proc get_parameter_type*(action: GAction): GVariantType {.
    importc: "g_action_get_parameter_type", libgio.}
proc parameter_type*(action: GAction): GVariantType {.
    importc: "g_action_get_parameter_type", libgio.}
proc get_state_type*(action: GAction): GVariantType {.
    importc: "g_action_get_state_type", libgio.}
proc state_type*(action: GAction): GVariantType {.
    importc: "g_action_get_state_type", libgio.}
proc get_state_hint*(action: GAction): GVariant {.
    importc: "g_action_get_state_hint", libgio.}
proc state_hint*(action: GAction): GVariant {.
    importc: "g_action_get_state_hint", libgio.}
proc get_enabled*(action: GAction): gboolean {.
    importc: "g_action_get_enabled", libgio.}
proc enabled*(action: GAction): gboolean {.
    importc: "g_action_get_enabled", libgio.}
proc get_state*(action: GAction): GVariant {.
    importc: "g_action_get_state", libgio.}
proc state*(action: GAction): GVariant {.
    importc: "g_action_get_state", libgio.}
proc change_state*(action: GAction; value: GVariant) {.
    importc: "g_action_change_state", libgio.}
proc activate*(action: GAction; parameter: GVariant) {.
    importc: "g_action_activate", libgio.}
proc g_action_name_is_valid*(action_name: cstring): gboolean {.
    importc: "g_action_name_is_valid", libgio.}
proc g_action_parse_detailed_name*(detailed_name: cstring;
                                   action_name: cstringArray;
                                   target_value: var GVariant;
                                   error: var GError): gboolean {.
    importc: "g_action_parse_detailed_name", libgio.}
proc g_action_print_detailed_name*(action_name: cstring;
                                   target_value: GVariant): cstring {.
    importc: "g_action_print_detailed_name", libgio.}

template g_action_group*(inst: expr): expr =
  (g_type_check_instance_cast(inst, action_group_get_type(), GActionGroupObj))

template g_is_action_group*(inst: expr): expr =
  (g_type_check_instance_type(inst, action_group_get_type()))

template g_action_group_get_iface*(inst: expr): expr =
  (g_type_instance_get_interface(inst, action_group_get_type(),
                                 GActionGroupInterfaceObj))

type
  GActionGroupInterface* =  ptr GActionGroupInterfaceObj
  GActionGroupInterfacePtr* = ptr GActionGroupInterfaceObj
  GActionGroupInterfaceObj*{.final.} = object of GTypeInterfaceObj
    has_action*: proc (action_group: GActionGroup; action_name: cstring): gboolean {.cdecl.}
    list_actions*: proc (action_group: GActionGroup): cstringArray {.cdecl.}
    get_action_enabled*: proc (action_group: GActionGroup;
                               action_name: cstring): gboolean {.cdecl.}
    get_action_parameter_type*: proc (action_group: GActionGroup;
                                      action_name: cstring): GVariantType {.cdecl.}
    get_action_state_type*: proc (action_group: GActionGroup;
                                  action_name: cstring): GVariantType {.cdecl.}
    get_action_state_hint*: proc (action_group: GActionGroup;
                                  action_name: cstring): GVariant {.cdecl.}
    get_action_state*: proc (action_group: GActionGroup;
                             action_name: cstring): GVariant {.cdecl.}
    change_action_state*: proc (action_group: GActionGroup;
                                action_name: cstring; value: GVariant) {.cdecl.}
    activate_action*: proc (action_group: GActionGroup;
                            action_name: cstring; parameter: GVariant) {.cdecl.}
    action_added*: proc (action_group: GActionGroup; action_name: cstring) {.cdecl.}
    action_removed*: proc (action_group: GActionGroup;
                           action_name: cstring) {.cdecl.}
    action_enabled_changed*: proc (action_group: GActionGroup;
                                   action_name: cstring; enabled: gboolean) {.cdecl.}
    action_state_changed*: proc (action_group: GActionGroup;
                                 action_name: cstring; state: GVariant) {.cdecl.}
    query_action*: proc (action_group: GActionGroup; action_name: cstring;
                         enabled: var gboolean;
                         parameter_type: var GVariantType;
                         state_type: var GVariantType;
                         state_hint: var GVariant; state: var GVariant): gboolean {.cdecl.}

proc g_action_group_get_type*(): GType {.importc: "g_action_group_get_type",
    libgio.}
proc has_action*(action_group: GActionGroup;
                                action_name: cstring): gboolean {.
    importc: "g_action_group_has_action", libgio.}
proc list_actions*(action_group: GActionGroup): cstringArray {.
    importc: "g_action_group_list_actions", libgio.}
proc get_action_parameter_type*(action_group: GActionGroup;
    action_name: cstring): GVariantType {.
    importc: "g_action_group_get_action_parameter_type", libgio.}
proc action_parameter_type*(action_group: GActionGroup;
    action_name: cstring): GVariantType {.
    importc: "g_action_group_get_action_parameter_type", libgio.}
proc get_action_state_type*(action_group: GActionGroup;
    action_name: cstring): GVariantType {.
    importc: "g_action_group_get_action_state_type", libgio.}
proc action_state_type*(action_group: GActionGroup;
    action_name: cstring): GVariantType {.
    importc: "g_action_group_get_action_state_type", libgio.}
proc get_action_state_hint*(action_group: GActionGroup;
    action_name: cstring): GVariant {.
    importc: "g_action_group_get_action_state_hint", libgio.}
proc action_state_hint*(action_group: GActionGroup;
    action_name: cstring): GVariant {.
    importc: "g_action_group_get_action_state_hint", libgio.}
proc get_action_enabled*(action_group: GActionGroup;
    action_name: cstring): gboolean {.importc: "g_action_group_get_action_enabled",
                                      libgio.}
proc action_enabled*(action_group: GActionGroup;
    action_name: cstring): gboolean {.importc: "g_action_group_get_action_enabled",
                                      libgio.}
proc get_action_state*(action_group: GActionGroup;
                                      action_name: cstring): GVariant {.
    importc: "g_action_group_get_action_state", libgio.}
proc action_state*(action_group: GActionGroup;
                                      action_name: cstring): GVariant {.
    importc: "g_action_group_get_action_state", libgio.}
proc change_action_state*(action_group: GActionGroup;
    action_name: cstring; value: GVariant) {.
    importc: "g_action_group_change_action_state", libgio.}
proc activate_action*(action_group: GActionGroup;
                                     action_name: cstring;
                                     parameter: GVariant) {.
    importc: "g_action_group_activate_action", libgio.}
proc action_added*(action_group: GActionGroup;
                                  action_name: cstring) {.
    importc: "g_action_group_action_added", libgio.}
proc action_removed*(action_group: GActionGroup;
                                    action_name: cstring) {.
    importc: "g_action_group_action_removed", libgio.}
proc action_enabled_changed*(action_group: GActionGroup;
    action_name: cstring; enabled: gboolean) {.
    importc: "g_action_group_action_enabled_changed", libgio.}
proc action_state_changed*(action_group: GActionGroup;
    action_name: cstring; state: GVariant) {.
    importc: "g_action_group_action_state_changed", libgio.}
proc query_action*(action_group: GActionGroup;
                                  action_name: cstring; enabled: var gboolean;
                                  parameter_type: var GVariantType;
                                  state_type: var GVariantType;
                                  state_hint: var GVariant;
                                  state: var GVariant): gboolean {.
    importc: "g_action_group_query_action", libgio.}

proc export_action_group*(connection: GDBusConnection;
    object_path: cstring; action_group: GActionGroup;
    error: var GError): guint {.importc: "g_dbus_connection_export_action_group",
                                    libgio.}
proc unexport_action_group*(connection: GDBusConnection;
    export_id: guint) {.importc: "g_dbus_connection_unexport_action_group",
                        libgio.}

template g_action_map*(inst: expr): expr =
  (g_type_check_instance_cast(inst, action_map_get_type(), GActionMapObj))

template g_is_action_map*(inst: expr): expr =
  (g_type_check_instance_type(inst, action_map_get_type()))

template g_action_map_get_iface*(inst: expr): expr =
  (g_type_instance_get_interface(inst, action_map_get_type(),
                                 GActionMapInterfaceObj))

type
  GActionMapInterface* =  ptr GActionMapInterfaceObj
  GActionMapInterfacePtr* = ptr GActionMapInterfaceObj
  GActionMapInterfaceObj*{.final.} = object of GTypeInterfaceObj
    lookup_action*: proc (action_map: GActionMap; action_name: cstring): GAction {.cdecl.}
    add_action*: proc (action_map: GActionMap; action: GAction) {.cdecl.}
    remove_action*: proc (action_map: GActionMap; action_name: cstring) {.cdecl.}

type
  GActionEntry* =  ptr GActionEntryObj
  GActionEntryPtr* = ptr GActionEntryObj
  GActionEntryObj* = object
    name*: cstring
    activate*: proc (action: GSimpleAction; parameter: GVariant;
                     user_data: gpointer) {.cdecl.}
    parameter_type*: cstring
    state*: cstring
    change_state*: proc (action: GSimpleAction; value: GVariant;
                         user_data: gpointer) {.cdecl.}
    padding*: array[3, gsize]

proc g_action_map_get_type*(): GType {.importc: "g_action_map_get_type",
    libgio.}
proc lookup_action*(action_map: GActionMap;
                                 action_name: cstring): GAction {.
    importc: "g_action_map_lookup_action", libgio.}
proc add_action*(action_map: GActionMap; action: GAction) {.
    importc: "g_action_map_add_action", libgio.}
proc remove_action*(action_map: GActionMap;
                                 action_name: cstring) {.
    importc: "g_action_map_remove_action", libgio.}
proc add_action_entries*(action_map: GActionMap;
                                      entries: GActionEntry;
                                      n_entries: gint; user_data: gpointer) {.
    importc: "g_action_map_add_action_entries", libgio.}

template g_app_info*(obj: expr): expr =
  (g_type_check_instance_cast(obj, app_info_get_type(), GAppInfoObj))

template g_is_app_info*(obj: expr): expr =
  (g_type_check_instance_type(obj, app_info_get_type()))

template g_app_info_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, app_info_get_type(), GAppInfoIfaceObj))

template g_app_launch_context*(o: expr): expr =
  (g_type_check_instance_cast(o, app_launch_context_get_type(),
                              GAppLaunchContextObj))

template g_app_launch_context_class*(k: expr): expr =
  (g_type_check_class_cast(k, app_launch_context_get_type(),
                           GAppLaunchContextClassObj))

template g_is_app_launch_context*(o: expr): expr =
  (g_type_check_instance_type(o, app_launch_context_get_type()))

template g_is_app_launch_context_class*(k: expr): expr =
  (g_type_check_class_type(k, app_launch_context_get_type()))

template g_app_launch_context_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, app_launch_context_get_type(),
                             GAppLaunchContextClassObj))

type
  GAppLaunchContextPrivateObj = object
 
type
  GAppLaunchContext* =  ptr GAppLaunchContextObj
  GAppLaunchContextPtr* = ptr GAppLaunchContextObj
  GAppLaunchContextObj*{.final.} = object of GObjectObj
    priv5: ptr GAppLaunchContextPrivateObj
type
  GAppInfoIface* =  ptr GAppInfoIfaceObj
  GAppInfoIfacePtr* = ptr GAppInfoIfaceObj
  GAppInfoIfaceObj*{.final.} = object of GTypeInterfaceObj
    dup*: proc (appinfo: GAppInfo): GAppInfo {.cdecl.}
    equal*: proc (appinfo1: GAppInfo; appinfo2: GAppInfo): gboolean {.cdecl.}
    get_id*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    get_name*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    get_description*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    get_executable*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    get_icon*: proc (appinfo: GAppInfo): GIcon {.cdecl.}
    launch*: proc (appinfo: GAppInfo; files: GList;
                   launch_context: GAppLaunchContext;
                   error: var GError): gboolean {.cdecl.}
    supports_uris*: proc (appinfo: GAppInfo): gboolean {.cdecl.}
    supports_files*: proc (appinfo: GAppInfo): gboolean {.cdecl.}
    launch_uris*: proc (appinfo: GAppInfo; uris: GList;
                        launch_context: GAppLaunchContext;
                        error: var GError): gboolean {.cdecl.}
    should_show*: proc (appinfo: GAppInfo): gboolean {.cdecl.}
    set_as_default_for_type*: proc (appinfo: GAppInfo;
                                    content_type: cstring;
                                    error: var GError): gboolean {.cdecl.}
    set_as_default_for_extension*: proc (appinfo: GAppInfo;
        extension: cstring; error: var GError): gboolean {.cdecl.}
    add_supports_type*: proc (appinfo: GAppInfo; content_type: cstring;
                              error: var GError): gboolean {.cdecl.}
    can_remove_supports_type*: proc (appinfo: GAppInfo): gboolean {.cdecl.}
    remove_supports_type*: proc (appinfo: GAppInfo; content_type: cstring;
                                 error: var GError): gboolean {.cdecl.}
    can_delete*: proc (appinfo: GAppInfo): gboolean {.cdecl.}
    do_delete*: proc (appinfo: GAppInfo): gboolean {.cdecl.}
    get_commandline*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    get_display_name*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    set_as_last_used_for_type*: proc (appinfo: GAppInfo;
                                      content_type: cstring;
                                      error: var GError): gboolean {.cdecl.}
    get_supported_types*: proc (appinfo: GAppInfo): cstringArray {.cdecl.}

proc g_app_info_get_type*(): GType {.importc: "g_app_info_get_type",
                                     libgio.}
proc g_app_info_create_from_commandline*(commandline: cstring;
    application_name: cstring; flags: GAppInfoCreateFlags;
    error: var GError): GAppInfo {.
    importc: "g_app_info_create_from_commandline", libgio.}
proc dup*(appinfo: GAppInfo): GAppInfo {.
    importc: "g_app_info_dup", libgio.}
proc equal*(appinfo1: GAppInfo; appinfo2: GAppInfo): gboolean {.
    importc: "g_app_info_equal", libgio.}
proc get_id*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_id", libgio.}
proc id*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_id", libgio.}
proc get_name*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_name", libgio.}
proc name*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_name", libgio.}
proc get_display_name*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_display_name", libgio.}
proc display_name*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_display_name", libgio.}
proc get_description*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_description", libgio.}
proc description*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_description", libgio.}
proc get_executable*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_executable", libgio.}
proc executable*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_executable", libgio.}
proc get_commandline*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_commandline", libgio.}
proc commandline*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_commandline", libgio.}
proc get_icon*(appinfo: GAppInfo): GIcon {.
    importc: "g_app_info_get_icon", libgio.}
proc icon*(appinfo: GAppInfo): GIcon {.
    importc: "g_app_info_get_icon", libgio.}
proc launch*(appinfo: GAppInfo; files: GList;
                        launch_context: GAppLaunchContext;
                        error: var GError): gboolean {.
    importc: "g_app_info_launch", libgio.}
proc supports_uris*(appinfo: GAppInfo): gboolean {.
    importc: "g_app_info_supports_uris", libgio.}
proc supports_files*(appinfo: GAppInfo): gboolean {.
    importc: "g_app_info_supports_files", libgio.}
proc launch_uris*(appinfo: GAppInfo; uris: GList;
                             launch_context: GAppLaunchContext;
                             error: var GError): gboolean {.
    importc: "g_app_info_launch_uris", libgio.}
proc should_show*(appinfo: GAppInfo): gboolean {.
    importc: "g_app_info_should_show", libgio.}
proc set_as_default_for_type*(appinfo: GAppInfo;
    content_type: cstring; error: var GError): gboolean {.
    importc: "g_app_info_set_as_default_for_type", libgio.}
proc set_as_default_for_extension*(appinfo: GAppInfo;
    extension: cstring; error: var GError): gboolean {.
    importc: "g_app_info_set_as_default_for_extension", libgio.}
proc add_supports_type*(appinfo: GAppInfo;
                                   content_type: cstring;
                                   error: var GError): gboolean {.
    importc: "g_app_info_add_supports_type", libgio.}
proc can_remove_supports_type*(appinfo: GAppInfo): gboolean {.
    importc: "g_app_info_can_remove_supports_type", libgio.}
proc remove_supports_type*(appinfo: GAppInfo;
                                      content_type: cstring;
                                      error: var GError): gboolean {.
    importc: "g_app_info_remove_supports_type", libgio.}
proc get_supported_types*(appinfo: GAppInfo): cstringArray {.
    importc: "g_app_info_get_supported_types", libgio.}
proc supported_types*(appinfo: GAppInfo): cstringArray {.
    importc: "g_app_info_get_supported_types", libgio.}
proc can_delete*(appinfo: GAppInfo): gboolean {.
    importc: "g_app_info_can_delete", libgio.}
proc delete*(appinfo: GAppInfo): gboolean {.
    importc: "g_app_info_delete", libgio.}
proc set_as_last_used_for_type*(appinfo: GAppInfo;
    content_type: cstring; error: var GError): gboolean {.
    importc: "g_app_info_set_as_last_used_for_type", libgio.}
proc g_app_info_get_all*(): GList {.importc: "g_app_info_get_all",
    libgio.}
proc g_app_info_get_all_for_type*(content_type: cstring): GList {.
    importc: "g_app_info_get_all_for_type", libgio.}
proc g_app_info_get_recommended_for_type*(content_type: cstring): GList {.
    importc: "g_app_info_get_recommended_for_type", libgio.}
proc g_app_info_get_fallback_for_type*(content_type: cstring): GList {.
    importc: "g_app_info_get_fallback_for_type", libgio.}
proc g_app_info_reset_type_associations*(content_type: cstring) {.
    importc: "g_app_info_reset_type_associations", libgio.}
proc g_app_info_get_default_for_type*(content_type: cstring;
                                      must_support_uris: gboolean): GAppInfo {.
    importc: "g_app_info_get_default_for_type", libgio.}
proc g_app_info_get_default_for_uri_scheme*(uri_scheme: cstring): GAppInfo {.
    importc: "g_app_info_get_default_for_uri_scheme", libgio.}
proc g_app_info_launch_default_for_uri*(uri: cstring;
    launch_context: GAppLaunchContext; error: var GError): gboolean {.
    importc: "g_app_info_launch_default_for_uri", libgio.}

type
  GAppLaunchContextClass* =  ptr GAppLaunchContextClassObj
  GAppLaunchContextClassPtr* = ptr GAppLaunchContextClassObj
  GAppLaunchContextClassObj*{.final.} = object of GObjectClassObj
    get_display*: proc (context: GAppLaunchContext; info: GAppInfo;
                        files: GList): cstring {.cdecl.}
    get_startup_notify_id*: proc (context: GAppLaunchContext;
                                  info: GAppInfo; files: GList): cstring {.cdecl.}
    launch_failed*: proc (context: GAppLaunchContext;
                          startup_notify_id: cstring) {.cdecl.}
    launched*: proc (context: GAppLaunchContext; info: GAppInfo;
                     platform_data: GVariant) {.cdecl.}
    g_reserved11: proc () {.cdecl.}
    g_reserved12: proc () {.cdecl.}
    g_reserved13: proc () {.cdecl.}
    g_reserved14: proc () {.cdecl.}

proc g_app_launch_context_get_type*(): GType {.
    importc: "g_app_launch_context_get_type", libgio.}
proc g_app_launch_context_new*(): GAppLaunchContext {.
    importc: "g_app_launch_context_new", libgio.}
proc setenv*(context: GAppLaunchContext;
                                  variable: cstring; value: cstring) {.
    importc: "g_app_launch_context_setenv", libgio.}
proc unsetenv*(context: GAppLaunchContext;
                                    variable: cstring) {.
    importc: "g_app_launch_context_unsetenv", libgio.}
proc get_environment*(context: GAppLaunchContext): cstringArray {.
    importc: "g_app_launch_context_get_environment", libgio.}
proc environment*(context: GAppLaunchContext): cstringArray {.
    importc: "g_app_launch_context_get_environment", libgio.}
proc get_display*(context: GAppLaunchContext;
    info: GAppInfo; files: GList): cstring {.
    importc: "g_app_launch_context_get_display", libgio.}
proc display*(context: GAppLaunchContext;
    info: GAppInfo; files: GList): cstring {.
    importc: "g_app_launch_context_get_display", libgio.}
proc get_startup_notify_id*(
    context: GAppLaunchContext; info: GAppInfo; files: GList): cstring {.
    importc: "g_app_launch_context_get_startup_notify_id", libgio.}
proc startup_notify_id*(
    context: GAppLaunchContext; info: GAppInfo; files: GList): cstring {.
    importc: "g_app_launch_context_get_startup_notify_id", libgio.}
proc launch_failed*(context: GAppLaunchContext;
    startup_notify_id: cstring) {.importc: "g_app_launch_context_launch_failed",
                                  libgio.}
template g_app_info_monitor*(inst: expr): expr =
  (g_type_check_instance_cast(inst, app_info_monitor_get_type(), GAppInfoMonitorObj))

template g_is_app_info_monitor*(inst: expr): expr =
  (g_type_check_instance_type(inst, app_info_monitor_get_type()))

type
  GAppInfoMonitor* =  ptr GAppInfoMonitorObj
  GAppInfoMonitorPtr* = ptr GAppInfoMonitorObj
  GAppInfoMonitorObj* = object
 
proc g_app_info_monitor_get_type*(): GType {.
    importc: "g_app_info_monitor_get_type", libgio.}
proc g_app_info_monitor_get*(): GAppInfoMonitor {.
    importc: "g_app_info_monitor_get", libgio.}

template g_application*(inst: expr): expr =
  (g_type_check_instance_cast(inst, application_get_type(), GApplicationObj))

template g_application_class*(class: expr): expr =
  (g_type_check_class_cast(class, application_get_type(), GApplicationClassObj))

template g_is_application*(inst: expr): expr =
  (g_type_check_instance_type(inst, application_get_type()))

template g_is_application_class*(class: expr): expr =
  (g_type_check_class_type(class, application_get_type()))

template g_application_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, application_get_type(), GApplicationClassObj))

type
  GApplicationCommandLinePrivateObj = object
 
type
  GApplicationCommandLine* =  ptr GApplicationCommandLineObj
  GApplicationCommandLinePtr* = ptr GApplicationCommandLineObj
  GApplicationCommandLineObj*{.final.} = object of GObjectObj
    priv6: ptr GApplicationCommandLinePrivateObj
type
  GApplicationPrivateObj = object
 
type
  GApplication* =  ptr GApplicationObj
  GApplicationPtr* = ptr GApplicationObj
  GApplicationObj* = object of GObjectObj
    priv7: ptr GApplicationPrivateObj

type
  GApplicationClass* =  ptr GApplicationClassObj
  GApplicationClassPtr* = ptr GApplicationClassObj
  GApplicationClassObj* = object of GObjectClassObj
    startup*: proc (application: GApplication) {.cdecl.}
    activate*: proc (application: GApplication) {.cdecl.}
    open*: proc (application: GApplication; files: var GFile;
                 n_files: gint; hint: cstring) {.cdecl.}
    command_line*: proc (application: GApplication;
                         command_line: GApplicationCommandLine): cint {.cdecl.}
    local_command_line*: proc (application: GApplication;
                               arguments: ptr cstringArray;
                               exit_status: var cint): gboolean {.cdecl.}
    before_emit*: proc (application: GApplication;
                        platform_data: GVariant) {.cdecl.}
    after_emit*: proc (application: GApplication;
                       platform_data: GVariant) {.cdecl.}
    add_platform_data*: proc (application: GApplication;
                              builder: glib.GVariantBuilder) {.cdecl.}
    quit_mainloop*: proc (application: GApplication) {.cdecl.}
    run_mainloop*: proc (application: GApplication) {.cdecl.}
    shutdown*: proc (application: GApplication) {.cdecl.}
    dbus_register*: proc (application: GApplication;
                          connection: GDBusConnection;
                          object_path: cstring; error: var GError): gboolean {.cdecl.}
    dbus_unregister*: proc (application: GApplication;
                            connection: GDBusConnection;
                            object_path: cstring) {.cdecl.}
    handle_local_options*: proc (application: GApplication;
                                 options: glib.GVariantDict): gint {.cdecl.}
    padding0*: array[8, gpointer]

proc g_application_get_type*(): GType {.importc: "g_application_get_type",
    libgio.}
proc g_application_id_is_valid*(application_id: cstring): gboolean {.
    importc: "g_application_id_is_valid", libgio.}
proc g_application_new*(application_id: cstring; flags: GApplicationFlags): GApplication {.
    importc: "g_application_new", libgio.}
proc get_application_id*(application: GApplication): cstring {.
    importc: "g_application_get_application_id", libgio.}
proc application_id*(application: GApplication): cstring {.
    importc: "g_application_get_application_id", libgio.}
proc set_application_id*(application: GApplication;
    application_id: cstring) {.importc: "g_application_set_application_id",
                               libgio.}
proc `application_id=`*(application: GApplication;
    application_id: cstring) {.importc: "g_application_set_application_id",
                               libgio.}
proc get_dbus_connection*(application: GApplication): GDBusConnection {.
    importc: "g_application_get_dbus_connection", libgio.}
proc dbus_connection*(application: GApplication): GDBusConnection {.
    importc: "g_application_get_dbus_connection", libgio.}
proc get_dbus_object_path*(application: GApplication): cstring {.
    importc: "g_application_get_dbus_object_path", libgio.}
proc dbus_object_path*(application: GApplication): cstring {.
    importc: "g_application_get_dbus_object_path", libgio.}
proc get_inactivity_timeout*(application: GApplication): guint {.
    importc: "g_application_get_inactivity_timeout", libgio.}
proc inactivity_timeout*(application: GApplication): guint {.
    importc: "g_application_get_inactivity_timeout", libgio.}
proc set_inactivity_timeout*(application: GApplication;
    inactivity_timeout: guint) {.importc: "g_application_set_inactivity_timeout",
                                 libgio.}
proc `inactivity_timeout=`*(application: GApplication;
    inactivity_timeout: guint) {.importc: "g_application_set_inactivity_timeout",
                                 libgio.}
proc get_flags*(application: GApplication): GApplicationFlags {.
    importc: "g_application_get_flags", libgio.}
proc flags*(application: GApplication): GApplicationFlags {.
    importc: "g_application_get_flags", libgio.}
proc set_flags*(application: GApplication;
                              flags: GApplicationFlags) {.
    importc: "g_application_set_flags", libgio.}
proc `flags=`*(application: GApplication;
                              flags: GApplicationFlags) {.
    importc: "g_application_set_flags", libgio.}
proc get_resource_base_path*(application: GApplication): cstring {.
    importc: "g_application_get_resource_base_path", libgio.}
proc resource_base_path*(application: GApplication): cstring {.
    importc: "g_application_get_resource_base_path", libgio.}
proc set_resource_base_path*(application: GApplication;
    resource_path: cstring) {.importc: "g_application_set_resource_base_path",
                              libgio.}
proc `resource_base_path=`*(application: GApplication;
    resource_path: cstring) {.importc: "g_application_set_resource_base_path",
                              libgio.}
proc set_action_group*(application: GApplication;
                                     action_group: GActionGroup) {.
    importc: "g_application_set_action_group", libgio.}
proc `action_group=`*(application: GApplication;
                                     action_group: GActionGroup) {.
    importc: "g_application_set_action_group", libgio.}
proc add_main_option_entries*(application: GApplication;
    entries: glib.GOptionEntry) {.importc: "g_application_add_main_option_entries",
                                 libgio.}
proc add_main_option*(application: GApplication;
                                    long_name: cstring; short_name: char;
                                    flags: GOptionFlags; arg: GOptionArg;
                                    description: cstring;
                                    arg_description: cstring) {.
    importc: "g_application_add_main_option", libgio.}
proc add_option_group*(application: GApplication;
                                     group: glib.GOptionGroup) {.
    importc: "g_application_add_option_group", libgio.}
proc get_is_registered*(application: GApplication): gboolean {.
    importc: "g_application_get_is_registered", libgio.}
proc is_registered*(application: GApplication): gboolean {.
    importc: "g_application_get_is_registered", libgio.}
proc get_is_remote*(application: GApplication): gboolean {.
    importc: "g_application_get_is_remote", libgio.}
proc is_remote*(application: GApplication): gboolean {.
    importc: "g_application_get_is_remote", libgio.}
proc register*(application: GApplication;
                             cancellable: GCancellable;
                             error: var GError): gboolean {.
    importc: "g_application_register", libgio.}
proc hold*(application: GApplication) {.
    importc: "g_application_hold", libgio.}
proc release*(application: GApplication) {.
    importc: "g_application_release", libgio.}
proc activate*(application: GApplication) {.
    importc: "g_application_activate", libgio.}
proc open*(application: GApplication; files: var GFile;
                         n_files: gint; hint: cstring) {.
    importc: "g_application_open", libgio.}
proc run*(application: GApplication; argc: cint;
                        argv: cstringArray): cint {.
    importc: "g_application_run", libgio.}
proc quit*(application: GApplication) {.
    importc: "g_application_quit", libgio.}
proc g_application_get_default*(): GApplication {.
    importc: "g_application_get_default", libgio.}
proc set_default*(application: GApplication) {.
    importc: "g_application_set_default", libgio.}
proc `default=`*(application: GApplication) {.
    importc: "g_application_set_default", libgio.}
proc mark_busy*(application: GApplication) {.
    importc: "g_application_mark_busy", libgio.}
proc unmark_busy*(application: GApplication) {.
    importc: "g_application_unmark_busy", libgio.}
proc send_notification*(application: GApplication;
                                      id: cstring;
                                      notification: GNotification) {.
    importc: "g_application_send_notification", libgio.}
proc withdraw_notification*(application: GApplication;
    id: cstring) {.importc: "g_application_withdraw_notification", libgio.}
proc bind_busy_property*(application: GApplication;
    `object`: gpointer; property: cstring) {.
    importc: "g_application_bind_busy_property", libgio.}

template g_application_command_line*(inst: expr): expr =
  (g_type_check_instance_cast(inst, application_command_line_get_type(),
                              GApplicationCommandLineObj))

template g_application_command_line_class*(class: expr): expr =
  (g_type_check_class_cast(class, application_command_line_get_type(),
                           GApplicationCommandLineClassObj))

template g_is_application_command_line*(inst: expr): expr =
  (g_type_check_instance_type(inst, application_command_line_get_type()))

template g_is_application_command_line_class*(class: expr): expr =
  (g_type_check_class_type(class, application_command_line_get_type()))

template g_application_command_line_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, application_command_line_get_type(),
                             GApplicationCommandLineClassObj))

type
  GInputStreamPrivateObj = object
 
type
  GInputStream* =  ptr GInputStreamObj
  GInputStreamPtr* = ptr GInputStreamObj
  GInputStreamObj* = object of GObjectObj
    priv8: ptr GInputStreamPrivateObj
type
  GApplicationCommandLineClass* =  ptr GApplicationCommandLineClassObj
  GApplicationCommandLineClassPtr* = ptr GApplicationCommandLineClassObj
  GApplicationCommandLineClassObj*{.final.} = object of GObjectClassObj
    print_literal*: proc (cmdline: GApplicationCommandLine;
                          message: cstring) {.cdecl.}
    printerr_literal*: proc (cmdline: GApplicationCommandLine;
                             message: cstring) {.cdecl.}
    get_stdin*: proc (cmdline: GApplicationCommandLine): GInputStream {.cdecl.}
    padding*: array[11, gpointer]

proc g_application_command_line_get_type*(): GType {.
    importc: "g_application_command_line_get_type", libgio.}
proc get_arguments*(
    cmdline: GApplicationCommandLine; argc: var cint): cstringArray {.
    importc: "g_application_command_line_get_arguments", libgio.}
proc arguments*(
    cmdline: GApplicationCommandLine; argc: var cint): cstringArray {.
    importc: "g_application_command_line_get_arguments", libgio.}
proc get_options_dict*(
    cmdline: GApplicationCommandLine): glib.GVariantDict {.
    importc: "g_application_command_line_get_options_dict", libgio.}
proc options_dict*(
    cmdline: GApplicationCommandLine): glib.GVariantDict {.
    importc: "g_application_command_line_get_options_dict", libgio.}
proc get_stdin*(
    cmdline: GApplicationCommandLine): GInputStream {.
    importc: "g_application_command_line_get_stdin", libgio.}
proc stdin*(
    cmdline: GApplicationCommandLine): GInputStream {.
    importc: "g_application_command_line_get_stdin", libgio.}
proc get_environ*(
    cmdline: GApplicationCommandLine): cstringArray {.
    importc: "g_application_command_line_get_environ", libgio.}
proc environ*(
    cmdline: GApplicationCommandLine): cstringArray {.
    importc: "g_application_command_line_get_environ", libgio.}
proc getenv*(cmdline: GApplicationCommandLine;
    name: cstring): cstring {.importc: "g_application_command_line_getenv",
                              libgio.}
proc get_cwd*(cmdline: GApplicationCommandLine): cstring {.
    importc: "g_application_command_line_get_cwd", libgio.}
proc cwd*(cmdline: GApplicationCommandLine): cstring {.
    importc: "g_application_command_line_get_cwd", libgio.}
proc get_is_remote*(
    cmdline: GApplicationCommandLine): gboolean {.
    importc: "g_application_command_line_get_is_remote", libgio.}
proc is_remote*(
    cmdline: GApplicationCommandLine): gboolean {.
    importc: "g_application_command_line_get_is_remote", libgio.}
proc print*(cmdline: GApplicationCommandLine;
    format: cstring) {.varargs, importc: "g_application_command_line_print",
                       libgio.}
proc printerr*(
    cmdline: GApplicationCommandLine; format: cstring) {.varargs,
    importc: "g_application_command_line_printerr", libgio.}
proc get_exit_status*(
    cmdline: GApplicationCommandLine): cint {.
    importc: "g_application_command_line_get_exit_status", libgio.}
proc exit_status*(
    cmdline: GApplicationCommandLine): cint {.
    importc: "g_application_command_line_get_exit_status", libgio.}
proc set_exit_status*(
    cmdline: GApplicationCommandLine; exit_status: cint) {.
    importc: "g_application_command_line_set_exit_status", libgio.}
proc `exit_status=`*(
    cmdline: GApplicationCommandLine; exit_status: cint) {.
    importc: "g_application_command_line_set_exit_status", libgio.}
proc get_platform_data*(
    cmdline: GApplicationCommandLine): GVariant {.
    importc: "g_application_command_line_get_platform_data", libgio.}
proc platform_data*(
    cmdline: GApplicationCommandLine): GVariant {.
    importc: "g_application_command_line_get_platform_data", libgio.}
proc create_file_for_arg*(
    cmdline: GApplicationCommandLine; arg: cstring): GFile {.
    importc: "g_application_command_line_create_file_for_arg", libgio.}

template g_initable*(obj: expr): expr =
  (g_type_check_instance_cast(obj, initable_get_type(), GInitableObj))

template g_is_initable*(obj: expr): expr =
  (g_type_check_instance_type(obj, initable_get_type()))

template g_initable_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, initable_get_type(), GInitableIfaceObj))

template g_type_is_initable*(`type`: expr): expr =
  (g_type_is_a(`type`, initable_get_type()))

type
  GInitableIface* =  ptr GInitableIfaceObj
  GInitableIfacePtr* = ptr GInitableIfaceObj
  GInitableIfaceObj*{.final.} = object of GTypeInterfaceObj
    init*: proc (initable: GInitable; cancellable: GCancellable;
                 error: var GError): gboolean {.cdecl.}

proc g_initable_get_type*(): GType {.importc: "g_initable_get_type",
                                     libgio.}
proc init*(initable: GInitable; cancellable: GCancellable;
                      error: var GError): gboolean {.
    importc: "g_initable_init", libgio.}
proc g_initable_new*(object_type: GType; cancellable: GCancellable;
                     error: var GError; first_property_name: cstring): gpointer {.
    varargs, importc: "g_initable_new", libgio.}
proc g_initable_newv*(object_type: GType; n_parameters: guint;
                      parameters: gobject.GParameter;
                      cancellable: GCancellable; error: var GError): gpointer {.
    importc: "g_initable_newv", libgio.}
discard """
proc g_initable_new_valist*(object_type: GType; first_property_name: cstring;
                            var_args: va_list; cancellable: GCancellable;
                            error: var GError): GObject {.
    importc: "g_initable_new_valist", libgio.}
"""

template g_async_initable*(obj: expr): expr =
  (g_type_check_instance_cast(obj, async_initable_get_type(), GAsyncInitableObj))

template g_is_async_initable*(obj: expr): expr =
  (g_type_check_instance_type(obj, async_initable_get_type()))

template g_async_initable_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, async_initable_get_type(),
                                 GAsyncInitableIfaceObj))

template g_type_is_async_initable*(`type`: expr): expr =
  (g_type_is_a(`type`, async_initable_get_type()))

type
  GAsyncInitableIface* =  ptr GAsyncInitableIfaceObj
  GAsyncInitableIfacePtr* = ptr GAsyncInitableIfaceObj
  GAsyncInitableIfaceObj*{.final.} = object of GTypeInterfaceObj
    init_async*: proc (initable: GAsyncInitable; io_priority: cint;
                       cancellable: GCancellable;
                       callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    init_finish*: proc (initable: GAsyncInitable; res: GAsyncResult;
                        error: var GError): gboolean {.cdecl.}

proc g_async_initable_get_type*(): GType {.
    importc: "g_async_initable_get_type", libgio.}
proc init_async*(initable: GAsyncInitable;
                                  io_priority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  user_data: gpointer) {.
    importc: "g_async_initable_init_async", libgio.}
proc init_finish*(initable: GAsyncInitable;
                                   res: GAsyncResult;
                                   error: var GError): gboolean {.
    importc: "g_async_initable_init_finish", libgio.}
proc g_async_initable_new_async*(object_type: GType; io_priority: cint;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer;
                                 first_property_name: cstring) {.varargs,
    importc: "g_async_initable_new_async", libgio.}
proc g_async_initable_newv_async*(object_type: GType; n_parameters: guint;
                                  parameters: gobject.GParameter;
                                  io_priority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  user_data: gpointer) {.
    importc: "g_async_initable_newv_async", libgio.}
discard """
proc g_async_initable_new_valist_async*(object_type: GType;
    first_property_name: cstring; var_args: va_list; io_priority: cint;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_async_initable_new_valist_async",
                           libgio.}
"""
proc new_finish*(initable: GAsyncInitable;
                                  res: GAsyncResult; error: var GError): GObject {.
    importc: "g_async_initable_new_finish", libgio.}

template g_async_result*(obj: expr): expr =
  (g_type_check_instance_cast(obj, async_result_get_type(), GAsyncResultObj))

template g_is_async_result*(obj: expr): expr =
  (g_type_check_instance_type(obj, async_result_get_type()))

template g_async_result_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, async_result_get_type(), GAsyncResultIfaceObj))

type
  GAsyncResultIface* =  ptr GAsyncResultIfaceObj
  GAsyncResultIfacePtr* = ptr GAsyncResultIfaceObj
  GAsyncResultIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_user_data*: proc (res: GAsyncResult): gpointer {.cdecl.}
    get_source_object*: proc (res: GAsyncResult): GObject {.cdecl.}
    is_tagged*: proc (res: GAsyncResult; source_tag: gpointer): gboolean {.cdecl.}

proc g_async_result_get_type*(): GType {.importc: "g_async_result_get_type",
    libgio.}
proc get_user_data*(res: GAsyncResult): gpointer {.
    importc: "g_async_result_get_user_data", libgio.}
proc user_data*(res: GAsyncResult): gpointer {.
    importc: "g_async_result_get_user_data", libgio.}
proc get_source_object*(res: GAsyncResult): GObject {.
    importc: "g_async_result_get_source_object", libgio.}
proc source_object*(res: GAsyncResult): GObject {.
    importc: "g_async_result_get_source_object", libgio.}
proc legacy_propagate_error*(res: GAsyncResult;
    error: var GError): gboolean {.
    importc: "g_async_result_legacy_propagate_error", libgio.}
proc is_tagged*(res: GAsyncResult; source_tag: gpointer): gboolean {.
    importc: "g_async_result_is_tagged", libgio.}

template g_input_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, input_stream_get_type(), GInputStreamObj))

template g_input_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, input_stream_get_type(), GInputStreamClassObj))

template g_is_input_stream*(o: expr): expr =
  (g_type_check_instance_type(o, input_stream_get_type()))

template g_is_input_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, input_stream_get_type()))

template g_input_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, input_stream_get_type(), GInputStreamClassObj))

type
  GInputStreamClass* =  ptr GInputStreamClassObj
  GInputStreamClassPtr* = ptr GInputStreamClassObj
  GInputStreamClassObj* = object of GObjectClassObj
    read_fn*: proc (stream: GInputStream; buffer: pointer; count: gsize;
                    cancellable: GCancellable; error: var GError): gssize {.cdecl.}
    skip*: proc (stream: GInputStream; count: gsize;
                 cancellable: GCancellable; error: var GError): gssize {.cdecl.}
    close_fn*: proc (stream: GInputStream; cancellable: GCancellable;
                     error: var GError): gboolean {.cdecl.}
    read_async*: proc (stream: GInputStream; buffer: pointer;
                       count: gsize; io_priority: cint;
                       cancellable: GCancellable;
                       callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    read_finish*: proc (stream: GInputStream; result: GAsyncResult;
                        error: var GError): gssize {.cdecl.}
    skip_async*: proc (stream: GInputStream; count: gsize;
                       io_priority: cint; cancellable: GCancellable;
                       callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    skip_finish*: proc (stream: GInputStream; result: GAsyncResult;
                        error: var GError): gssize {.cdecl.}
    close_async*: proc (stream: GInputStream; io_priority: cint;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    close_finish*: proc (stream: GInputStream; result: GAsyncResult;
                         error: var GError): gboolean {.cdecl.}
    g_reserved21: proc () {.cdecl.}
    g_reserved22: proc () {.cdecl.}
    g_reserved23: proc () {.cdecl.}
    g_reserved24: proc () {.cdecl.}
    g_reserved25: proc () {.cdecl.}

proc g_input_stream_get_type*(): GType {.importc: "g_input_stream_get_type",
    libgio.}
proc read*(stream: GInputStream; buffer: pointer;
                          count: gsize; cancellable: GCancellable;
                          error: var GError): gssize {.
    importc: "g_input_stream_read", libgio.}
proc read_all*(stream: GInputStream; buffer: pointer;
                              count: gsize; bytes_read: var gsize;
                              cancellable: GCancellable;
                              error: var GError): gboolean {.
    importc: "g_input_stream_read_all", libgio.}
proc read_bytes*(stream: GInputStream; count: gsize;
                                cancellable: GCancellable;
                                error: var GError): glib.GBytes {.
    importc: "g_input_stream_read_bytes", libgio.}
proc skip*(stream: GInputStream; count: gsize;
                          cancellable: GCancellable; error: var GError): gssize {.
    importc: "g_input_stream_skip", libgio.}
proc close*(stream: GInputStream;
                           cancellable: GCancellable;
                           error: var GError): gboolean {.
    importc: "g_input_stream_close", libgio.}
proc read_async*(stream: GInputStream; buffer: pointer;
                                count: gsize; io_priority: cint;
                                cancellable: GCancellable;
                                callback: GAsyncReadyCallback;
                                user_data: gpointer) {.
    importc: "g_input_stream_read_async", libgio.}
proc read_finish*(stream: GInputStream;
                                 result: GAsyncResult;
                                 error: var GError): gssize {.
    importc: "g_input_stream_read_finish", libgio.}
proc read_all_async*(stream: GInputStream; buffer: pointer;
                                    count: gsize; io_priority: cint;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.
    importc: "g_input_stream_read_all_async", libgio.}
proc read_all_finish*(stream: GInputStream;
                                     result: GAsyncResult;
                                     bytes_read: var gsize;
                                     error: var GError): gboolean {.
    importc: "g_input_stream_read_all_finish", libgio.}
proc read_bytes_async*(stream: GInputStream; count: gsize;
                                      io_priority: cint;
                                      cancellable: GCancellable;
                                      callback: GAsyncReadyCallback;
                                      user_data: gpointer) {.
    importc: "g_input_stream_read_bytes_async", libgio.}
proc read_bytes_finish*(stream: GInputStream;
    result: GAsyncResult; error: var GError): glib.GBytes {.
    importc: "g_input_stream_read_bytes_finish", libgio.}
proc skip_async*(stream: GInputStream; count: gsize;
                                io_priority: cint;
                                cancellable: GCancellable;
                                callback: GAsyncReadyCallback;
                                user_data: gpointer) {.
    importc: "g_input_stream_skip_async", libgio.}
proc skip_finish*(stream: GInputStream;
                                 result: GAsyncResult;
                                 error: var GError): gssize {.
    importc: "g_input_stream_skip_finish", libgio.}
proc close_async*(stream: GInputStream; io_priority: cint;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.
    importc: "g_input_stream_close_async", libgio.}
proc close_finish*(stream: GInputStream;
                                  result: GAsyncResult;
                                  error: var GError): gboolean {.
    importc: "g_input_stream_close_finish", libgio.}
proc is_closed*(stream: GInputStream): gboolean {.
    importc: "g_input_stream_is_closed", libgio.}
proc has_pending*(stream: GInputStream): gboolean {.
    importc: "g_input_stream_has_pending", libgio.}
proc set_pending*(stream: GInputStream;
                                 error: var GError): gboolean {.
    importc: "g_input_stream_set_pending", libgio.}
proc clear_pending*(stream: GInputStream) {.
    importc: "g_input_stream_clear_pending", libgio.}

template g_filter_input_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, filter_input_stream_get_type(),
                              GFilterInputStreamObj))

template g_filter_input_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, filter_input_stream_get_type(),
                           GFilterInputStreamClassObj))

template g_is_filter_input_stream*(o: expr): expr =
  (g_type_check_instance_type(o, filter_input_stream_get_type()))

template g_is_filter_input_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, filter_input_stream_get_type()))

template g_filter_input_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, filter_input_stream_get_type(),
                             GFilterInputStreamClassObj))

type
  GFilterInputStream* =  ptr GFilterInputStreamObj
  GFilterInputStreamPtr* = ptr GFilterInputStreamObj
  GFilterInputStreamObj* = object of GInputStreamObj
    base_stream*: GInputStream

type
  GFilterInputStreamClass* =  ptr GFilterInputStreamClassObj
  GFilterInputStreamClassPtr* = ptr GFilterInputStreamClassObj
  GFilterInputStreamClassObj* = object of GInputStreamClassObj
    g_reserved31: proc () {.cdecl.}
    g_reserved32: proc () {.cdecl.}
    g_reserved33: proc () {.cdecl.}

proc g_filter_input_stream_get_type*(): GType {.
    importc: "g_filter_input_stream_get_type", libgio.}
proc get_base_stream*(stream: GFilterInputStream): GInputStream {.
    importc: "g_filter_input_stream_get_base_stream", libgio.}
proc base_stream*(stream: GFilterInputStream): GInputStream {.
    importc: "g_filter_input_stream_get_base_stream", libgio.}
proc get_close_base_stream*(
    stream: GFilterInputStream): gboolean {.
    importc: "g_filter_input_stream_get_close_base_stream", libgio.}
proc close_base_stream*(
    stream: GFilterInputStream): gboolean {.
    importc: "g_filter_input_stream_get_close_base_stream", libgio.}
proc set_close_base_stream*(
    stream: GFilterInputStream; close_base: gboolean) {.
    importc: "g_filter_input_stream_set_close_base_stream", libgio.}
proc `close_base_stream=`*(
    stream: GFilterInputStream; close_base: gboolean) {.
    importc: "g_filter_input_stream_set_close_base_stream", libgio.}

template g_buffered_input_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, buffered_input_stream_get_type(),
                              GBufferedInputStreamObj))

template g_buffered_input_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, buffered_input_stream_get_type(),
                           GBufferedInputStreamClassObj))

template g_is_buffered_input_stream*(o: expr): expr =
  (g_type_check_instance_type(o, buffered_input_stream_get_type()))

template g_is_buffered_input_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, buffered_input_stream_get_type()))

template g_buffered_input_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, buffered_input_stream_get_type(),
                             GBufferedInputStreamClassObj))

type
  GBufferedInputStreamPrivateObj = object
 
type
  GBufferedInputStream* =  ptr GBufferedInputStreamObj
  GBufferedInputStreamPtr* = ptr GBufferedInputStreamObj
  GBufferedInputStreamObj* = object of GFilterInputStreamObj
    priv9: ptr GBufferedInputStreamPrivateObj

type
  GBufferedInputStreamClass* =  ptr GBufferedInputStreamClassObj
  GBufferedInputStreamClassPtr* = ptr GBufferedInputStreamClassObj
  GBufferedInputStreamClassObj* = object of GFilterInputStreamClassObj
    fill*: proc (stream: GBufferedInputStream; count: gssize;
                 cancellable: GCancellable; error: var GError): gssize {.cdecl.}
    fill_async*: proc (stream: GBufferedInputStream; count: gssize;
                       io_priority: cint; cancellable: GCancellable;
                       callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    fill_finish*: proc (stream: GBufferedInputStream;
                        result: GAsyncResult; error: var GError): gssize {.cdecl.}
    g_reserved41: proc () {.cdecl.}
    g_reserved42: proc () {.cdecl.}
    g_reserved43: proc () {.cdecl.}
    g_reserved44: proc () {.cdecl.}
    g_reserved45: proc () {.cdecl.}

proc g_buffered_input_stream_get_type*(): GType {.
    importc: "g_buffered_input_stream_get_type", libgio.}
proc g_buffered_input_stream_new*(base_stream: GInputStream): GInputStream {.
    importc: "g_buffered_input_stream_new", libgio.}
proc g_buffered_input_stream_new_sized*(base_stream: GInputStream;
    size: gsize): GInputStream {.importc: "g_buffered_input_stream_new_sized",
                                     libgio.}
proc get_buffer_size*(stream: GBufferedInputStream): gsize {.
    importc: "g_buffered_input_stream_get_buffer_size", libgio.}
proc buffer_size*(stream: GBufferedInputStream): gsize {.
    importc: "g_buffered_input_stream_get_buffer_size", libgio.}
proc set_buffer_size*(
    stream: GBufferedInputStream; size: gsize) {.
    importc: "g_buffered_input_stream_set_buffer_size", libgio.}
proc `buffer_size=`*(
    stream: GBufferedInputStream; size: gsize) {.
    importc: "g_buffered_input_stream_set_buffer_size", libgio.}
proc get_available*(stream: GBufferedInputStream): gsize {.
    importc: "g_buffered_input_stream_get_available", libgio.}
proc available*(stream: GBufferedInputStream): gsize {.
    importc: "g_buffered_input_stream_get_available", libgio.}
proc peek*(stream: GBufferedInputStream;
                                   buffer: pointer; offset: gsize;
                                   count: gsize): gsize {.
    importc: "g_buffered_input_stream_peek", libgio.}
proc peek_buffer*(stream: GBufferedInputStream;
    count: var gsize): pointer {.importc: "g_buffered_input_stream_peek_buffer",
                                 libgio.}
proc fill*(stream: GBufferedInputStream;
                                   count: gssize;
                                   cancellable: GCancellable;
                                   error: var GError): gssize {.
    importc: "g_buffered_input_stream_fill", libgio.}
proc fill_async*(stream: GBufferedInputStream;
    count: gssize; io_priority: cint; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_buffered_input_stream_fill_async", libgio.}
proc fill_finish*(stream: GBufferedInputStream;
    result: GAsyncResult; error: var GError): gssize {.
    importc: "g_buffered_input_stream_fill_finish", libgio.}
proc read_byte*(stream: GBufferedInputStream;
    cancellable: GCancellable; error: var GError): cint {.
    importc: "g_buffered_input_stream_read_byte", libgio.}

template g_output_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, output_stream_get_type(), GOutputStreamObj))

template g_output_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, output_stream_get_type(), GOutputStreamClassObj))

template g_is_output_stream*(o: expr): expr =
  (g_type_check_instance_type(o, output_stream_get_type()))

template g_is_output_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, output_stream_get_type()))

template g_output_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, output_stream_get_type(), GOutputStreamClassObj))

type
  GOutputStreamPrivateObj = object
 
type
  GOutputStream* =  ptr GOutputStreamObj
  GOutputStreamPtr* = ptr GOutputStreamObj
  GOutputStreamObj* = object of GObjectObj
    priv10: ptr GOutputStreamPrivateObj

type
  GOutputStreamClass* =  ptr GOutputStreamClassObj
  GOutputStreamClassPtr* = ptr GOutputStreamClassObj
  GOutputStreamClassObj* = object of GObjectClassObj
    write_fn*: proc (stream: GOutputStream; buffer: pointer; count: gsize;
                     cancellable: GCancellable; error: var GError): gssize {.cdecl.}
    splice*: proc (stream: GOutputStream; source: GInputStream;
                   flags: GOutputStreamSpliceFlags;
                   cancellable: GCancellable; error: var GError): gssize {.cdecl.}
    flush*: proc (stream: GOutputStream; cancellable: GCancellable;
                  error: var GError): gboolean {.cdecl.}
    close_fn*: proc (stream: GOutputStream; cancellable: GCancellable;
                     error: var GError): gboolean {.cdecl.}
    write_async*: proc (stream: GOutputStream; buffer: pointer;
                        count: gsize; io_priority: cint;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    write_finish*: proc (stream: GOutputStream; result: GAsyncResult;
                         error: var GError): gssize {.cdecl.}
    splice_async*: proc (stream: GOutputStream; source: GInputStream;
                         flags: GOutputStreamSpliceFlags; io_priority: cint;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    splice_finish*: proc (stream: GOutputStream; result: GAsyncResult;
                          error: var GError): gssize {.cdecl.}
    flush_async*: proc (stream: GOutputStream; io_priority: cint;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    flush_finish*: proc (stream: GOutputStream; result: GAsyncResult;
                         error: var GError): gboolean {.cdecl.}
    close_async*: proc (stream: GOutputStream; io_priority: cint;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    close_finish*: proc (stream: GOutputStream; result: GAsyncResult;
                         error: var GError): gboolean {.cdecl.}
    g_reserved51: proc () {.cdecl.}
    g_reserved52: proc () {.cdecl.}
    g_reserved53: proc () {.cdecl.}
    g_reserved54: proc () {.cdecl.}
    g_reserved55: proc () {.cdecl.}
    g_reserved56: proc () {.cdecl.}
    g_reserved57: proc () {.cdecl.}
    g_reserved58: proc () {.cdecl.}

proc g_output_stream_get_type*(): GType {.importc: "g_output_stream_get_type",
    libgio.}
proc write*(stream: GOutputStream; buffer: pointer;
                            count: gsize; cancellable: GCancellable;
                            error: var GError): gssize {.
    importc: "g_output_stream_write", libgio.}
proc write_all*(stream: GOutputStream; buffer: pointer;
                                count: gsize; bytes_written: var gsize;
                                cancellable: GCancellable;
                                error: var GError): gboolean {.
    importc: "g_output_stream_write_all", libgio.}
proc printf*(stream: GOutputStream;
                             bytes_written: var gsize;
                             cancellable: GCancellable;
                             error: var GError; format: cstring): gboolean {.
    varargs, importc: "g_output_stream_printf", libgio.}
discard """
proc vprintf*(stream: GOutputStream;
                              bytes_written: var gsize;
                              cancellable: GCancellable;
                              error: var GError; format: cstring;
                              args: va_list): gboolean {.
    importc: "g_output_stream_vprintf", libgio.}
"""
proc write_bytes*(stream: GOutputStream;
                                  bytes: glib.GBytes;
                                  cancellable: GCancellable;
                                  error: var GError): gssize {.
    importc: "g_output_stream_write_bytes", libgio.}
proc splice*(stream: GOutputStream;
                             source: GInputStream;
                             flags: GOutputStreamSpliceFlags;
                             cancellable: GCancellable;
                             error: var GError): gssize {.
    importc: "g_output_stream_splice", libgio.}
proc flush*(stream: GOutputStream;
                            cancellable: GCancellable;
                            error: var GError): gboolean {.
    importc: "g_output_stream_flush", libgio.}
proc close*(stream: GOutputStream;
                            cancellable: GCancellable;
                            error: var GError): gboolean {.
    importc: "g_output_stream_close", libgio.}
proc write_async*(stream: GOutputStream; buffer: pointer;
                                  count: gsize; io_priority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  user_data: gpointer) {.
    importc: "g_output_stream_write_async", libgio.}
proc write_finish*(stream: GOutputStream;
                                   result: GAsyncResult;
                                   error: var GError): gssize {.
    importc: "g_output_stream_write_finish", libgio.}
proc write_all_async*(stream: GOutputStream;
                                      buffer: pointer; count: gsize;
                                      io_priority: cint;
                                      cancellable: GCancellable;
                                      callback: GAsyncReadyCallback;
                                      user_data: gpointer) {.
    importc: "g_output_stream_write_all_async", libgio.}
proc write_all_finish*(stream: GOutputStream;
    result: GAsyncResult; bytes_written: var gsize; error: var GError): gboolean {.
    importc: "g_output_stream_write_all_finish", libgio.}
proc write_bytes_async*(stream: GOutputStream;
    bytes: glib.GBytes; io_priority: cint; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_output_stream_write_bytes_async", libgio.}
proc write_bytes_finish*(stream: GOutputStream;
    result: GAsyncResult; error: var GError): gssize {.
    importc: "g_output_stream_write_bytes_finish", libgio.}
proc splice_async*(stream: GOutputStream;
                                   source: GInputStream;
                                   flags: GOutputStreamSpliceFlags;
                                   io_priority: cint;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   user_data: gpointer) {.
    importc: "g_output_stream_splice_async", libgio.}
proc splice_finish*(stream: GOutputStream;
                                    result: GAsyncResult;
                                    error: var GError): gssize {.
    importc: "g_output_stream_splice_finish", libgio.}
proc flush_async*(stream: GOutputStream;
                                  io_priority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  user_data: gpointer) {.
    importc: "g_output_stream_flush_async", libgio.}
proc flush_finish*(stream: GOutputStream;
                                   result: GAsyncResult;
                                   error: var GError): gboolean {.
    importc: "g_output_stream_flush_finish", libgio.}
proc close_async*(stream: GOutputStream;
                                  io_priority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  user_data: gpointer) {.
    importc: "g_output_stream_close_async", libgio.}
proc close_finish*(stream: GOutputStream;
                                   result: GAsyncResult;
                                   error: var GError): gboolean {.
    importc: "g_output_stream_close_finish", libgio.}
proc is_closed*(stream: GOutputStream): gboolean {.
    importc: "g_output_stream_is_closed", libgio.}
proc is_closing*(stream: GOutputStream): gboolean {.
    importc: "g_output_stream_is_closing", libgio.}
proc has_pending*(stream: GOutputStream): gboolean {.
    importc: "g_output_stream_has_pending", libgio.}
proc set_pending*(stream: GOutputStream;
                                  error: var GError): gboolean {.
    importc: "g_output_stream_set_pending", libgio.}
proc clear_pending*(stream: GOutputStream) {.
    importc: "g_output_stream_clear_pending", libgio.}

template g_filter_output_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, filter_output_stream_get_type(),
                              GFilterOutputStreamObj))

template g_filter_output_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, filter_output_stream_get_type(),
                           GFilterOutputStreamClassObj))

template g_is_filter_output_stream*(o: expr): expr =
  (g_type_check_instance_type(o, filter_output_stream_get_type()))

template g_is_filter_output_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, filter_output_stream_get_type()))

template g_filter_output_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, filter_output_stream_get_type(),
                             GFilterOutputStreamClassObj))

type
  GFilterOutputStream* =  ptr GFilterOutputStreamObj
  GFilterOutputStreamPtr* = ptr GFilterOutputStreamObj
  GFilterOutputStreamObj* = object of GOutputStreamObj
    base_stream*: GOutputStream

type
  GFilterOutputStreamClass* =  ptr GFilterOutputStreamClassObj
  GFilterOutputStreamClassPtr* = ptr GFilterOutputStreamClassObj
  GFilterOutputStreamClassObj* = object of GOutputStreamClassObj
    g_reserved61: proc () {.cdecl.}
    g_reserved62: proc () {.cdecl.}
    g_reserved63: proc () {.cdecl.}

proc g_filter_output_stream_get_type*(): GType {.
    importc: "g_filter_output_stream_get_type", libgio.}
proc get_base_stream*(stream: GFilterOutputStream): GOutputStream {.
    importc: "g_filter_output_stream_get_base_stream", libgio.}
proc base_stream*(stream: GFilterOutputStream): GOutputStream {.
    importc: "g_filter_output_stream_get_base_stream", libgio.}
proc get_close_base_stream*(
    stream: GFilterOutputStream): gboolean {.
    importc: "g_filter_output_stream_get_close_base_stream", libgio.}
proc close_base_stream*(
    stream: GFilterOutputStream): gboolean {.
    importc: "g_filter_output_stream_get_close_base_stream", libgio.}
proc set_close_base_stream*(
    stream: GFilterOutputStream; close_base: gboolean) {.
    importc: "g_filter_output_stream_set_close_base_stream", libgio.}
proc `close_base_stream=`*(
    stream: GFilterOutputStream; close_base: gboolean) {.
    importc: "g_filter_output_stream_set_close_base_stream", libgio.}

template g_buffered_output_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, buffered_output_stream_get_type(),
                              GBufferedOutputStreamObj))

template g_buffered_output_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, buffered_output_stream_get_type(),
                           GBufferedOutputStreamClassObj))

template g_is_buffered_output_stream*(o: expr): expr =
  (g_type_check_instance_type(o, buffered_output_stream_get_type()))

template g_is_buffered_output_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, buffered_output_stream_get_type()))

template g_buffered_output_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, buffered_output_stream_get_type(),
                             GBufferedOutputStreamClassObj))

type
  GBufferedOutputStreamPrivateObj = object
 
type
  GBufferedOutputStream* =  ptr GBufferedOutputStreamObj
  GBufferedOutputStreamPtr* = ptr GBufferedOutputStreamObj
  GBufferedOutputStreamObj*{.final.} = object of GFilterOutputStreamObj
    priv11: ptr GBufferedOutputStreamPrivateObj

type
  GBufferedOutputStreamClass* =  ptr GBufferedOutputStreamClassObj
  GBufferedOutputStreamClassPtr* = ptr GBufferedOutputStreamClassObj
  GBufferedOutputStreamClassObj*{.final.} = object of GFilterOutputStreamClassObj
    g_reserved71: proc () {.cdecl.}
    g_reserved72: proc () {.cdecl.}

proc g_buffered_output_stream_get_type*(): GType {.
    importc: "g_buffered_output_stream_get_type", libgio.}
proc g_buffered_output_stream_new*(base_stream: GOutputStream): GOutputStream {.
    importc: "g_buffered_output_stream_new", libgio.}
proc g_buffered_output_stream_new_sized*(base_stream: GOutputStream;
    size: gsize): GOutputStream {.importc: "g_buffered_output_stream_new_sized",
                                      libgio.}
proc get_buffer_size*(
    stream: GBufferedOutputStream): gsize {.
    importc: "g_buffered_output_stream_get_buffer_size", libgio.}
proc buffer_size*(
    stream: GBufferedOutputStream): gsize {.
    importc: "g_buffered_output_stream_get_buffer_size", libgio.}
proc set_buffer_size*(
    stream: GBufferedOutputStream; size: gsize) {.
    importc: "g_buffered_output_stream_set_buffer_size", libgio.}
proc `buffer_size=`*(
    stream: GBufferedOutputStream; size: gsize) {.
    importc: "g_buffered_output_stream_set_buffer_size", libgio.}
proc get_auto_grow*(stream: GBufferedOutputStream): gboolean {.
    importc: "g_buffered_output_stream_get_auto_grow", libgio.}
proc auto_grow*(stream: GBufferedOutputStream): gboolean {.
    importc: "g_buffered_output_stream_get_auto_grow", libgio.}
proc set_auto_grow*(
    stream: GBufferedOutputStream; auto_grow: gboolean) {.
    importc: "g_buffered_output_stream_set_auto_grow", libgio.}
proc `auto_grow=`*(
    stream: GBufferedOutputStream; auto_grow: gboolean) {.
    importc: "g_buffered_output_stream_set_auto_grow", libgio.}

template g_bytes_icon*(inst: expr): expr =
  (g_type_check_instance_cast(inst, bytes_icon_get_type(), GBytesIconObj))

template g_is_bytes_icon*(inst: expr): expr =
  (g_type_check_instance_type(inst, bytes_icon_get_type()))

proc g_bytes_icon_get_type*(): GType {.importc: "g_bytes_icon_get_type",
    libgio.}
proc icon_new*(bytes: glib.GBytes): GIcon {.
    importc: "g_bytes_icon_new", libgio.}
proc get_bytes*(icon: GBytesIcon): glib.GBytes {.
    importc: "g_bytes_icon_get_bytes", libgio.}
proc bytes*(icon: GBytesIcon): glib.GBytes {.
    importc: "g_bytes_icon_get_bytes", libgio.}

template g_cancellable*(o: expr): expr =
  (g_type_check_instance_cast(o, cancellable_get_type(), GCancellableObj))

template g_cancellable_class*(k: expr): expr =
  (g_type_check_class_cast(k, cancellable_get_type(), GCancellableClassObj))

template g_is_cancellable*(o: expr): expr =
  (g_type_check_instance_type(o, cancellable_get_type()))

template g_is_cancellable_class*(k: expr): expr =
  (g_type_check_class_type(k, cancellable_get_type()))

template g_cancellable_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, cancellable_get_type(), GCancellableClassObj))

type
  GCancellableClass* =  ptr GCancellableClassObj
  GCancellableClassPtr* = ptr GCancellableClassObj
  GCancellableClassObj*{.final.} = object of GObjectClassObj
    cancelled*: proc (cancellable: GCancellable) {.cdecl.}
    g_reserved81: proc () {.cdecl.}
    g_reserved82: proc () {.cdecl.}
    g_reserved83: proc () {.cdecl.}
    g_reserved84: proc () {.cdecl.}
    g_reserved85: proc () {.cdecl.}

proc g_cancellable_get_type*(): GType {.importc: "g_cancellable_get_type",
    libgio.}
proc g_cancellable_new*(): GCancellable {.importc: "g_cancellable_new",
    libgio.}
proc is_cancelled*(cancellable: GCancellable): gboolean {.
    importc: "g_cancellable_is_cancelled", libgio.}
proc set_error_if_cancelled*(cancellable: GCancellable;
    error: var GError): gboolean {.
    importc: "g_cancellable_set_error_if_cancelled", libgio.}
proc get_fd*(cancellable: GCancellable): cint {.
    importc: "g_cancellable_get_fd", libgio.}
proc fd*(cancellable: GCancellable): cint {.
    importc: "g_cancellable_get_fd", libgio.}
proc make_pollfd*(cancellable: GCancellable;
                                pollfd: glib.GPollFD): gboolean {.
    importc: "g_cancellable_make_pollfd", libgio.}
proc release_fd*(cancellable: GCancellable) {.
    importc: "g_cancellable_release_fd", libgio.}
proc source_new*(cancellable: GCancellable): glib.GSource {.
    importc: "g_cancellable_source_new", libgio.}
proc g_cancellable_get_current*(): GCancellable {.
    importc: "g_cancellable_get_current", libgio.}
proc push_current*(cancellable: GCancellable) {.
    importc: "g_cancellable_push_current", libgio.}
proc pop_current*(cancellable: GCancellable) {.
    importc: "g_cancellable_pop_current", libgio.}
proc reset*(cancellable: GCancellable) {.
    importc: "g_cancellable_reset", libgio.}
proc connect*(cancellable: GCancellable;
                            callback: GCallback; data: gpointer;
                            data_destroy_func: GDestroyNotify): gulong {.
    importc: "g_cancellable_connect", libgio.}
proc disconnect*(cancellable: GCancellable;
                               handler_id: gulong) {.
    importc: "g_cancellable_disconnect", libgio.}
proc cancel*(cancellable: GCancellable) {.
    importc: "g_cancellable_cancel", libgio.}

template g_converter*(obj: expr): expr =
  (g_type_check_instance_cast(obj, converter_get_type(), GConverterObj))

template g_is_converter*(obj: expr): expr =
  (g_type_check_instance_type(obj, converter_get_type()))

template g_converter_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, converter_get_type(), GConverterIfaceObj))

type
  GConverterIface* =  ptr GConverterIfaceObj
  GConverterIfacePtr* = ptr GConverterIfaceObj
  GConverterIfaceObj*{.final.} = object of GTypeInterfaceObj
    convert*: proc (`converter`: GConverter; inbuf: pointer;
                    inbuf_size: gsize; outbuf: pointer; outbuf_size: gsize;
                    flags: GConverterFlags; bytes_read: ptr gsize;
                    bytes_written: var gsize; error: var GError): GConverterResult {.cdecl.}
    reset*: proc (`converter`: GConverter) {.cdecl.}

proc g_converter_get_type*(): GType {.importc: "g_converter_get_type",
                                      libgio.}
proc convert*(`converter`: GConverter; inbuf: pointer;
                          inbuf_size: gsize; outbuf: pointer;
                          outbuf_size: gsize; flags: GConverterFlags;
                          bytes_read: ptr gsize; bytes_written: var gsize;
                          error: var GError): GConverterResult {.
    importc: "g_converter_convert", libgio.}
proc reset*(`converter`: GConverter) {.
    importc: "g_converter_reset", libgio.}

template g_charset_converter*(o: expr): expr =
  (g_type_check_instance_cast(o, charset_converter_get_type(), GCharsetConverterObj))

template g_charset_converter_class*(k: expr): expr =
  (g_type_check_class_cast(k, charset_converter_get_type(),
                           GCharsetConverterClassObj))

template g_is_charset_converter*(o: expr): expr =
  (g_type_check_instance_type(o, charset_converter_get_type()))

template g_is_charset_converter_class*(k: expr): expr =
  (g_type_check_class_type(k, charset_converter_get_type()))

template g_charset_converter_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, charset_converter_get_type(),
                             GCharsetConverterClassObj))

type
  GCharsetConverterClass* =  ptr GCharsetConverterClassObj
  GCharsetConverterClassPtr* = ptr GCharsetConverterClassObj
  GCharsetConverterClassObj*{.final.} = object of GObjectClassObj

proc g_charset_converter_get_type*(): GType {.
    importc: "g_charset_converter_get_type", libgio.}
proc g_charset_converter_new*(to_charset: cstring; from_charset: cstring;
                              error: var GError): GCharsetConverter {.
    importc: "g_charset_converter_new", libgio.}
proc set_use_fallback*(`converter`: GCharsetConverter;
    use_fallback: gboolean) {.importc: "g_charset_converter_set_use_fallback",
                              libgio.}
proc `use_fallback=`*(`converter`: GCharsetConverter;
    use_fallback: gboolean) {.importc: "g_charset_converter_set_use_fallback",
                              libgio.}
proc get_use_fallback*(`converter`: GCharsetConverter): gboolean {.
    importc: "g_charset_converter_get_use_fallback", libgio.}
proc use_fallback*(`converter`: GCharsetConverter): gboolean {.
    importc: "g_charset_converter_get_use_fallback", libgio.}
proc get_num_fallbacks*(`converter`: GCharsetConverter): guint {.
    importc: "g_charset_converter_get_num_fallbacks", libgio.}
proc num_fallbacks*(`converter`: GCharsetConverter): guint {.
    importc: "g_charset_converter_get_num_fallbacks", libgio.}

proc g_content_type_equals*(type1: cstring; type2: cstring): gboolean {.
    importc: "g_content_type_equals", libgio.}
proc g_content_type_is_a*(`type`: cstring; supertype: cstring): gboolean {.
    importc: "g_content_type_is_a", libgio.}
proc g_content_type_is_unknown*(`type`: cstring): gboolean {.
    importc: "g_content_type_is_unknown", libgio.}
proc g_content_type_get_description*(`type`: cstring): cstring {.
    importc: "g_content_type_get_description", libgio.}
proc g_content_type_get_mime_type*(`type`: cstring): cstring {.
    importc: "g_content_type_get_mime_type", libgio.}
proc g_content_type_get_icon*(`type`: cstring): GIcon {.
    importc: "g_content_type_get_icon", libgio.}
proc g_content_type_get_symbolic_icon*(`type`: cstring): GIcon {.
    importc: "g_content_type_get_symbolic_icon", libgio.}
proc g_content_type_get_generic_icon_name*(`type`: cstring): cstring {.
    importc: "g_content_type_get_generic_icon_name", libgio.}
proc g_content_type_can_be_executable*(`type`: cstring): gboolean {.
    importc: "g_content_type_can_be_executable", libgio.}
proc g_content_type_from_mime_type*(mime_type: cstring): cstring {.
    importc: "g_content_type_from_mime_type", libgio.}
proc g_content_type_guess*(filename: cstring; data: var guchar;
                           data_size: gsize; result_uncertain: var gboolean): cstring {.
    importc: "g_content_type_guess", libgio.}
proc g_content_type_guess_for_tree*(root: GFile): cstringArray {.
    importc: "g_content_type_guess_for_tree", libgio.}
proc g_content_types_get_registered*(): GList {.
    importc: "g_content_types_get_registered", libgio.}

template g_converter_input_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, converter_input_stream_get_type(),
                              GConverterInputStreamObj))

template g_converter_input_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, converter_input_stream_get_type(),
                           GConverterInputStreamClassObj))

template g_is_converter_input_stream*(o: expr): expr =
  (g_type_check_instance_type(o, converter_input_stream_get_type()))

template g_is_converter_input_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, converter_input_stream_get_type()))

template g_converter_input_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, converter_input_stream_get_type(),
                             GConverterInputStreamClassObj))

type
  GConverterInputStreamPrivateObj = object
 
type
  GConverterInputStream* =  ptr GConverterInputStreamObj
  GConverterInputStreamPtr* = ptr GConverterInputStreamObj
  GConverterInputStreamObj*{.final.} = object of GFilterInputStreamObj
    priv12: ptr GConverterInputStreamPrivateObj

type
  GConverterInputStreamClass* =  ptr GConverterInputStreamClassObj
  GConverterInputStreamClassPtr* = ptr GConverterInputStreamClassObj
  GConverterInputStreamClassObj*{.final.} = object of GFilterInputStreamClassObj
    g_reserved91: proc () {.cdecl.}
    g_reserved92: proc () {.cdecl.}
    g_reserved93: proc () {.cdecl.}
    g_reserved94: proc () {.cdecl.}
    g_reserved95: proc () {.cdecl.}

proc g_converter_input_stream_get_type*(): GType {.
    importc: "g_converter_input_stream_get_type", libgio.}
proc g_converter_input_stream_new*(base_stream: GInputStream;
                                   `converter`: GConverter): GInputStream {.
    importc: "g_converter_input_stream_new", libgio.}
proc get_converter*(
    converter_stream: GConverterInputStream): GConverter {.
    importc: "g_converter_input_stream_get_converter", libgio.}
proc `converter`*(
    converter_stream: GConverterInputStream): GConverter {.
    importc: "g_converter_input_stream_get_converter", libgio.}

template g_converter_output_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, converter_output_stream_get_type(),
                              GConverterOutputStreamObj))

template g_converter_output_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, converter_output_stream_get_type(),
                           GConverterOutputStreamClassObj))

template g_is_converter_output_stream*(o: expr): expr =
  (g_type_check_instance_type(o, converter_output_stream_get_type()))

template g_is_converter_output_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, converter_output_stream_get_type()))

template g_converter_output_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, converter_output_stream_get_type(),
                             GConverterOutputStreamClassObj))

type
  GConverterOutputStreamPrivateObj = object
 
type
  GConverterOutputStream* =  ptr GConverterOutputStreamObj
  GConverterOutputStreamPtr* = ptr GConverterOutputStreamObj
  GConverterOutputStreamObj*{.final.} = object of GFilterOutputStreamObj
    priv13: ptr GConverterOutputStreamPrivateObj

type
  GConverterOutputStreamClass* =  ptr GConverterOutputStreamClassObj
  GConverterOutputStreamClassPtr* = ptr GConverterOutputStreamClassObj
  GConverterOutputStreamClassObj*{.final.} = object of GFilterOutputStreamClassObj
    g_reserved101: proc () {.cdecl.}
    g_reserved102: proc () {.cdecl.}
    g_reserved103: proc () {.cdecl.}
    g_reserved104: proc () {.cdecl.}
    g_reserved105: proc () {.cdecl.}

proc g_converter_output_stream_get_type*(): GType {.
    importc: "g_converter_output_stream_get_type", libgio.}
proc g_converter_output_stream_new*(base_stream: GOutputStream;
                                    `converter`: GConverter): GOutputStream {.
    importc: "g_converter_output_stream_new", libgio.}
proc get_converter*(
    converter_stream: GConverterOutputStream): GConverter {.
    importc: "g_converter_output_stream_get_converter", libgio.}
proc `converter`*(
    converter_stream: GConverterOutputStream): GConverter {.
    importc: "g_converter_output_stream_get_converter", libgio.}

template g_credentials*(o: expr): expr =
  (g_type_check_instance_cast(o, credentials_get_type(), GCredentialsObj))

template g_credentials_class*(k: expr): expr =
  (g_type_check_class_cast(k, credentials_get_type(), GCredentialsClassObj))

template g_credentials_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, credentials_get_type(), GCredentialsClassObj))

template g_is_credentials*(o: expr): expr =
  (g_type_check_instance_type(o, credentials_get_type()))

template g_is_credentials_class*(k: expr): expr =
  (g_type_check_class_type(k, credentials_get_type()))

type
  GCredentialsClass* =  ptr GCredentialsClassObj
  GCredentialsClassPtr* = ptr GCredentialsClassObj
  GCredentialsClassObj* = object
 
proc g_credentials_get_type*(): GType {.importc: "g_credentials_get_type",
    libgio.}
proc g_credentials_new*(): GCredentials {.importc: "g_credentials_new",
    libgio.}
proc to_string*(credentials: GCredentials): cstring {.
    importc: "g_credentials_to_string", libgio.}
proc get_native*(credentials: GCredentials;
                               native_type: GCredentialsType): gpointer {.
    importc: "g_credentials_get_native", libgio.}
proc native*(credentials: GCredentials;
                               native_type: GCredentialsType): gpointer {.
    importc: "g_credentials_get_native", libgio.}
proc set_native*(credentials: GCredentials;
                               native_type: GCredentialsType; native: gpointer) {.
    importc: "g_credentials_set_native", libgio.}
proc `native=`*(credentials: GCredentials;
                               native_type: GCredentialsType; native: gpointer) {.
    importc: "g_credentials_set_native", libgio.}
proc is_same_user*(credentials: GCredentials;
                                 other_credentials: GCredentials;
                                 error: var GError): gboolean {.
    importc: "g_credentials_is_same_user", libgio.}
when defined(unix):
  proc get_unix_pid*(credentials: GCredentials;
                                   error: var GError): pid_t {.
      importc: "g_credentials_get_unix_pid", libgio.}
  proc unix_pid*(credentials: GCredentials;
                                   error: var GError): pid_t {.
      importc: "g_credentials_get_unix_pid", libgio.}
  proc get_unix_user*(credentials: GCredentials;
                                    error: var GError): uid_t {.
      importc: "g_credentials_get_unix_user", libgio.}
  proc unix_user*(credentials: GCredentials;
                                    error: var GError): uid_t {.
      importc: "g_credentials_get_unix_user", libgio.}
  proc set_unix_user*(credentials: GCredentials; uid: uid_t;
                                    error: var GError): gboolean {.
      importc: "g_credentials_set_unix_user", libgio.}

template g_data_input_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, data_input_stream_get_type(), GDataInputStreamObj))

template g_data_input_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, data_input_stream_get_type(),
                           GDataInputStreamClassObj))

template g_is_data_input_stream*(o: expr): expr =
  (g_type_check_instance_type(o, data_input_stream_get_type()))

template g_is_data_input_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, data_input_stream_get_type()))

template g_data_input_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, data_input_stream_get_type(),
                             GDataInputStreamClassObj))

type
  GDataInputStreamPrivateObj = object
 
type
  GDataInputStream* =  ptr GDataInputStreamObj
  GDataInputStreamPtr* = ptr GDataInputStreamObj
  GDataInputStreamObj*{.final.} = object of GBufferedInputStreamObj
    priv14: ptr GDataInputStreamPrivateObj

type
  GDataInputStreamClass* =  ptr GDataInputStreamClassObj
  GDataInputStreamClassPtr* = ptr GDataInputStreamClassObj
  GDataInputStreamClassObj*{.final.} = object of GBufferedInputStreamClassObj
    g_reserved111: proc () {.cdecl.}
    g_reserved112: proc () {.cdecl.}
    g_reserved113: proc () {.cdecl.}
    g_reserved114: proc () {.cdecl.}
    g_reserved115: proc () {.cdecl.}

proc g_data_input_stream_get_type*(): GType {.
    importc: "g_data_input_stream_get_type", libgio.}
proc g_data_input_stream_new*(base_stream: GInputStream): GDataInputStream {.
    importc: "g_data_input_stream_new", libgio.}
proc set_byte_order*(stream: GDataInputStream;
    order: GDataStreamByteOrder) {.importc: "g_data_input_stream_set_byte_order",
                                   libgio.}
proc `byte_order=`*(stream: GDataInputStream;
    order: GDataStreamByteOrder) {.importc: "g_data_input_stream_set_byte_order",
                                   libgio.}
proc get_byte_order*(stream: GDataInputStream): GDataStreamByteOrder {.
    importc: "g_data_input_stream_get_byte_order", libgio.}
proc byte_order*(stream: GDataInputStream): GDataStreamByteOrder {.
    importc: "g_data_input_stream_get_byte_order", libgio.}
proc set_newline_type*(stream: GDataInputStream;
    `type`: GDataStreamNewlineType) {.importc: "g_data_input_stream_set_newline_type",
                                      libgio.}
proc `newline_type=`*(stream: GDataInputStream;
    `type`: GDataStreamNewlineType) {.importc: "g_data_input_stream_set_newline_type",
                                      libgio.}
proc get_newline_type*(stream: GDataInputStream): GDataStreamNewlineType {.
    importc: "g_data_input_stream_get_newline_type", libgio.}
proc newline_type*(stream: GDataInputStream): GDataStreamNewlineType {.
    importc: "g_data_input_stream_get_newline_type", libgio.}
proc read_byte*(stream: GDataInputStream;
                                    cancellable: GCancellable;
                                    error: var GError): guchar {.
    importc: "g_data_input_stream_read_byte", libgio.}
proc read_int16*(stream: GDataInputStream;
                                     cancellable: GCancellable;
                                     error: var GError): gint16 {.
    importc: "g_data_input_stream_read_int16", libgio.}
proc read_uint16*(stream: GDataInputStream;
                                      cancellable: GCancellable;
                                      error: var GError): guint16 {.
    importc: "g_data_input_stream_read_uint16", libgio.}
proc read_int32*(stream: GDataInputStream;
                                     cancellable: GCancellable;
                                     error: var GError): gint32 {.
    importc: "g_data_input_stream_read_int32", libgio.}
proc read_uint32*(stream: GDataInputStream;
                                      cancellable: GCancellable;
                                      error: var GError): guint32 {.
    importc: "g_data_input_stream_read_uint32", libgio.}
proc read_int64*(stream: GDataInputStream;
                                     cancellable: GCancellable;
                                     error: var GError): gint64 {.
    importc: "g_data_input_stream_read_int64", libgio.}
proc read_uint64*(stream: GDataInputStream;
                                      cancellable: GCancellable;
                                      error: var GError): guint64 {.
    importc: "g_data_input_stream_read_uint64", libgio.}
proc read_line*(stream: GDataInputStream;
                                    length: var gsize;
                                    cancellable: GCancellable;
                                    error: var GError): cstring {.
    importc: "g_data_input_stream_read_line", libgio.}
proc read_line_utf8*(stream: GDataInputStream;
    length: var gsize; cancellable: GCancellable; error: var GError): cstring {.
    importc: "g_data_input_stream_read_line_utf8", libgio.}
proc read_line_async*(stream: GDataInputStream;
    io_priority: gint; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_data_input_stream_read_line_async", libgio.}
proc read_line_finish*(stream: GDataInputStream;
    result: GAsyncResult; length: var gsize; error: var GError): cstring {.
    importc: "g_data_input_stream_read_line_finish", libgio.}
proc read_line_finish_utf8*(stream: GDataInputStream;
    result: GAsyncResult; length: var gsize; error: var GError): cstring {.
    importc: "g_data_input_stream_read_line_finish_utf8", libgio.}
proc read_until*(stream: GDataInputStream;
                                     stop_chars: cstring; length: var gsize;
                                     cancellable: GCancellable;
                                     error: var GError): cstring {.
    importc: "g_data_input_stream_read_until", libgio.}
proc read_until_async*(stream: GDataInputStream;
    stop_chars: cstring; io_priority: gint; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_data_input_stream_read_until_async", libgio.}
proc read_until_finish*(stream: GDataInputStream;
    result: GAsyncResult; length: var gsize; error: var GError): cstring {.
    importc: "g_data_input_stream_read_until_finish", libgio.}
proc read_upto*(stream: GDataInputStream;
                                    stop_chars: cstring;
                                    stop_chars_len: gssize; length: var gsize;
                                    cancellable: GCancellable;
                                    error: var GError): cstring {.
    importc: "g_data_input_stream_read_upto", libgio.}
proc read_upto_async*(stream: GDataInputStream;
    stop_chars: cstring; stop_chars_len: gssize; io_priority: gint;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_data_input_stream_read_upto_async",
                           libgio.}
proc read_upto_finish*(stream: GDataInputStream;
    result: GAsyncResult; length: var gsize; error: var GError): cstring {.
    importc: "g_data_input_stream_read_upto_finish", libgio.}

template g_data_output_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, data_output_stream_get_type(),
                              GDataOutputStreamObj))

template g_data_output_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, data_output_stream_get_type(),
                           GDataOutputStreamClassObj))

template g_is_data_output_stream*(o: expr): expr =
  (g_type_check_instance_type(o, data_output_stream_get_type()))

template g_is_data_output_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, data_output_stream_get_type()))

template g_data_output_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, data_output_stream_get_type(),
                             GDataOutputStreamClassObj))

type
  GDataOutputStreamPrivateObj = object
 
type
  GDataOutputStream* =  ptr GDataOutputStreamObj
  GDataOutputStreamPtr* = ptr GDataOutputStreamObj
  GDataOutputStreamObj*{.final.} = object of GFilterOutputStreamObj
    priv15: ptr GDataOutputStreamPrivateObj

type
  GDataOutputStreamClass* =  ptr GDataOutputStreamClassObj
  GDataOutputStreamClassPtr* = ptr GDataOutputStreamClassObj
  GDataOutputStreamClassObj*{.final.} = object of GFilterOutputStreamClassObj
    g_reserved121: proc () {.cdecl.}
    g_reserved122: proc () {.cdecl.}
    g_reserved123: proc () {.cdecl.}
    g_reserved124: proc () {.cdecl.}
    g_reserved125: proc () {.cdecl.}

proc g_data_output_stream_get_type*(): GType {.
    importc: "g_data_output_stream_get_type", libgio.}
proc g_data_output_stream_new*(base_stream: GOutputStream): GDataOutputStream {.
    importc: "g_data_output_stream_new", libgio.}
proc set_byte_order*(stream: GDataOutputStream;
    order: GDataStreamByteOrder) {.importc: "g_data_output_stream_set_byte_order",
                                   libgio.}
proc `byte_order=`*(stream: GDataOutputStream;
    order: GDataStreamByteOrder) {.importc: "g_data_output_stream_set_byte_order",
                                   libgio.}
proc get_byte_order*(stream: GDataOutputStream): GDataStreamByteOrder {.
    importc: "g_data_output_stream_get_byte_order", libgio.}
proc byte_order*(stream: GDataOutputStream): GDataStreamByteOrder {.
    importc: "g_data_output_stream_get_byte_order", libgio.}
proc put_byte*(stream: GDataOutputStream;
                                    data: guchar;
                                    cancellable: GCancellable;
                                    error: var GError): gboolean {.
    importc: "g_data_output_stream_put_byte", libgio.}
proc put_int16*(stream: GDataOutputStream;
                                     data: gint16;
                                     cancellable: GCancellable;
                                     error: var GError): gboolean {.
    importc: "g_data_output_stream_put_int16", libgio.}
proc put_uint16*(stream: GDataOutputStream;
                                      data: guint16;
                                      cancellable: GCancellable;
                                      error: var GError): gboolean {.
    importc: "g_data_output_stream_put_uint16", libgio.}
proc put_int32*(stream: GDataOutputStream;
                                     data: gint32;
                                     cancellable: GCancellable;
                                     error: var GError): gboolean {.
    importc: "g_data_output_stream_put_int32", libgio.}
proc put_uint32*(stream: GDataOutputStream;
                                      data: guint32;
                                      cancellable: GCancellable;
                                      error: var GError): gboolean {.
    importc: "g_data_output_stream_put_uint32", libgio.}
proc put_int64*(stream: GDataOutputStream;
                                     data: gint64;
                                     cancellable: GCancellable;
                                     error: var GError): gboolean {.
    importc: "g_data_output_stream_put_int64", libgio.}
proc put_uint64*(stream: GDataOutputStream;
                                      data: guint64;
                                      cancellable: GCancellable;
                                      error: var GError): gboolean {.
    importc: "g_data_output_stream_put_uint64", libgio.}
proc put_string*(stream: GDataOutputStream;
                                      str: cstring;
                                      cancellable: GCancellable;
                                      error: var GError): gboolean {.
    importc: "g_data_output_stream_put_string", libgio.}
type
  GIOStreamPrivateObj = object
 
type
  GIOStream* =  ptr GIOStreamObj
  GIOStreamPtr* = ptr GIOStreamObj
  GIOStreamObj* = object of GObjectObj
    priv20: ptr GIOStreamPrivateObj

proc g_dbus_address_escape_value*(string: cstring): cstring {.
    importc: "g_dbus_address_escape_value", libgio.}
proc g_dbus_is_address*(string: cstring): gboolean {.
    importc: "g_dbus_is_address", libgio.}
proc g_dbus_is_supported_address*(string: cstring; error: var GError): gboolean {.
    importc: "g_dbus_is_supported_address", libgio.}
proc g_dbus_address_get_stream*(address: cstring;
                                cancellable: GCancellable;
                                callback: GAsyncReadyCallback;
                                user_data: gpointer) {.
    importc: "g_dbus_address_get_stream", libgio.}
proc g_dbus_address_get_stream_finish*(res: GAsyncResult;
    out_guid: cstringArray; error: var GError): GIOStream {.
    importc: "g_dbus_address_get_stream_finish", libgio.}
proc g_dbus_address_get_stream_sync*(address: cstring; out_guid: cstringArray;
                                     cancellable: GCancellable;
                                     error: var GError): GIOStream {.
    importc: "g_dbus_address_get_stream_sync", libgio.}
proc g_dbus_address_get_for_bus_sync*(bus_type: GBusType;
                                      cancellable: GCancellable;
                                      error: var GError): cstring {.
    importc: "g_dbus_address_get_for_bus_sync", libgio.}

template g_dbus_auth_observer*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_auth_observer_get_type(),
                              GDBusAuthObserverObj))

template g_is_dbus_auth_observer*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_auth_observer_get_type()))

proc g_dbus_auth_observer_get_type*(): GType {.
    importc: "g_dbus_auth_observer_get_type", libgio.}
proc g_dbus_auth_observer_new*(): GDBusAuthObserver {.
    importc: "g_dbus_auth_observer_new", libgio.}
proc authorize_authenticated_peer*(
    observer: GDBusAuthObserver; stream: GIOStream;
    credentials: GCredentials): gboolean {.
    importc: "g_dbus_auth_observer_authorize_authenticated_peer", libgio.}
proc allow_mechanism*(observer: GDBusAuthObserver;
    mechanism: cstring): gboolean {.importc: "g_dbus_auth_observer_allow_mechanism",
                                    libgio.}

template g_dbus_connection*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_connection_get_type(), GDBusConnectionObj))

template g_is_dbus_connection*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_connection_get_type()))

proc g_dbus_connection_get_type*(): GType {.
    importc: "g_dbus_connection_get_type", libgio.}
proc g_bus_get*(bus_type: GBusType; cancellable: GCancellable;
                callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_bus_get", libgio.}
proc g_bus_get_finish*(res: GAsyncResult; error: var GError): GDBusConnection {.
    importc: "g_bus_get_finish", libgio.}
proc g_bus_get_sync*(bus_type: GBusType; cancellable: GCancellable;
                     error: var GError): GDBusConnection {.
    importc: "g_bus_get_sync", libgio.}
proc g_dbus_connection_new*(stream: GIOStream; guid: cstring;
                            flags: GDBusConnectionFlags;
                            observer: GDBusAuthObserver;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_dbus_connection_new", libgio.}
proc g_dbus_connection_new_finish*(res: GAsyncResult;
                                   error: var GError): GDBusConnection {.
    importc: "g_dbus_connection_new_finish", libgio.}
proc g_dbus_connection_new_sync*(stream: GIOStream; guid: cstring;
                                 flags: GDBusConnectionFlags;
                                 observer: GDBusAuthObserver;
                                 cancellable: GCancellable;
                                 error: var GError): GDBusConnection {.
    importc: "g_dbus_connection_new_sync", libgio.}
proc g_dbus_connection_new_for_address*(address: cstring;
    flags: GDBusConnectionFlags; observer: GDBusAuthObserver;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_dbus_connection_new_for_address",
                           libgio.}
proc g_dbus_connection_new_for_address_finish*(res: GAsyncResult;
    error: var GError): GDBusConnection {.
    importc: "g_dbus_connection_new_for_address_finish", libgio.}
proc g_dbus_connection_new_for_address_sync*(address: cstring;
    flags: GDBusConnectionFlags; observer: GDBusAuthObserver;
    cancellable: GCancellable; error: var GError): GDBusConnection {.
    importc: "g_dbus_connection_new_for_address_sync", libgio.}
proc start_message_processing*(
    connection: GDBusConnection) {.
    importc: "g_dbus_connection_start_message_processing", libgio.}
proc is_closed*(connection: GDBusConnection): gboolean {.
    importc: "g_dbus_connection_is_closed", libgio.}
proc get_stream*(connection: GDBusConnection): GIOStream {.
    importc: "g_dbus_connection_get_stream", libgio.}
proc stream*(connection: GDBusConnection): GIOStream {.
    importc: "g_dbus_connection_get_stream", libgio.}
proc get_guid*(connection: GDBusConnection): cstring {.
    importc: "g_dbus_connection_get_guid", libgio.}
proc guid*(connection: GDBusConnection): cstring {.
    importc: "g_dbus_connection_get_guid", libgio.}
proc get_unique_name*(connection: GDBusConnection): cstring {.
    importc: "g_dbus_connection_get_unique_name", libgio.}
proc unique_name*(connection: GDBusConnection): cstring {.
    importc: "g_dbus_connection_get_unique_name", libgio.}
proc get_peer_credentials*(connection: GDBusConnection): GCredentials {.
    importc: "g_dbus_connection_get_peer_credentials", libgio.}
proc peer_credentials*(connection: GDBusConnection): GCredentials {.
    importc: "g_dbus_connection_get_peer_credentials", libgio.}
proc get_last_serial*(connection: GDBusConnection): guint32 {.
    importc: "g_dbus_connection_get_last_serial", libgio.}
proc last_serial*(connection: GDBusConnection): guint32 {.
    importc: "g_dbus_connection_get_last_serial", libgio.}
proc get_exit_on_close*(connection: GDBusConnection): gboolean {.
    importc: "g_dbus_connection_get_exit_on_close", libgio.}
proc exit_on_close*(connection: GDBusConnection): gboolean {.
    importc: "g_dbus_connection_get_exit_on_close", libgio.}
proc set_exit_on_close*(connection: GDBusConnection;
    exit_on_close: gboolean) {.importc: "g_dbus_connection_set_exit_on_close",
                               libgio.}
proc `exit_on_close=`*(connection: GDBusConnection;
    exit_on_close: gboolean) {.importc: "g_dbus_connection_set_exit_on_close",
                               libgio.}
proc get_capabilities*(connection: GDBusConnection): GDBusCapabilityFlags {.
    importc: "g_dbus_connection_get_capabilities", libgio.}
proc capabilities*(connection: GDBusConnection): GDBusCapabilityFlags {.
    importc: "g_dbus_connection_get_capabilities", libgio.}
proc close*(connection: GDBusConnection;
                              cancellable: GCancellable;
                              callback: GAsyncReadyCallback;
                              user_data: gpointer) {.
    importc: "g_dbus_connection_close", libgio.}
proc close_finish*(connection: GDBusConnection;
                                     res: GAsyncResult;
                                     error: var GError): gboolean {.
    importc: "g_dbus_connection_close_finish", libgio.}
proc close_sync*(connection: GDBusConnection;
                                   cancellable: GCancellable;
                                   error: var GError): gboolean {.
    importc: "g_dbus_connection_close_sync", libgio.}
proc flush*(connection: GDBusConnection;
                              cancellable: GCancellable;
                              callback: GAsyncReadyCallback;
                              user_data: gpointer) {.
    importc: "g_dbus_connection_flush", libgio.}
proc flush_finish*(connection: GDBusConnection;
                                     res: GAsyncResult;
                                     error: var GError): gboolean {.
    importc: "g_dbus_connection_flush_finish", libgio.}
proc flush_sync*(connection: GDBusConnection;
                                   cancellable: GCancellable;
                                   error: var GError): gboolean {.
    importc: "g_dbus_connection_flush_sync", libgio.}
proc send_message*(connection: GDBusConnection;
                                     message: GDBusMessage;
                                     flags: GDBusSendMessageFlags;
                                     out_serial: var guint32;
                                     error: var GError): gboolean {.
    importc: "g_dbus_connection_send_message", libgio.}
proc send_message_with_reply*(
    connection: GDBusConnection; message: GDBusMessage;
    flags: GDBusSendMessageFlags; timeout_msec: gint; out_serial: var guint32;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_dbus_connection_send_message_with_reply",
                           libgio.}
proc send_message_with_reply_finish*(
    connection: GDBusConnection; res: GAsyncResult;
    error: var GError): GDBusMessage {.
    importc: "g_dbus_connection_send_message_with_reply_finish", libgio.}
proc send_message_with_reply_sync*(
    connection: GDBusConnection; message: GDBusMessage;
    flags: GDBusSendMessageFlags; timeout_msec: gint; out_serial: var guint32;
    cancellable: GCancellable; error: var GError): GDBusMessage {.
    importc: "g_dbus_connection_send_message_with_reply_sync", libgio.}
proc emit_signal*(connection: GDBusConnection;
                                    destination_bus_name: cstring;
                                    object_path: cstring;
                                    interface_name: cstring;
                                    signal_name: cstring;
                                    parameters: GVariant;
                                    error: var GError): gboolean {.
    importc: "g_dbus_connection_emit_signal", libgio.}
proc call*(connection: GDBusConnection;
                             bus_name: cstring; object_path: cstring;
                             interface_name: cstring; method_name: cstring;
                             parameters: GVariant;
                             reply_type: GVariantType;
                             flags: GDBusCallFlags; timeout_msec: gint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback;
                             user_data: gpointer) {.
    importc: "g_dbus_connection_call", libgio.}
proc call_finish*(connection: GDBusConnection;
                                    res: GAsyncResult;
                                    error: var GError): GVariant {.
    importc: "g_dbus_connection_call_finish", libgio.}
proc call_sync*(connection: GDBusConnection;
                                  bus_name: cstring; object_path: cstring;
                                  interface_name: cstring;
                                  method_name: cstring;
                                  parameters: GVariant;
                                  reply_type: GVariantType;
                                  flags: GDBusCallFlags; timeout_msec: gint;
                                  cancellable: GCancellable;
                                  error: var GError): GVariant {.
    importc: "g_dbus_connection_call_sync", libgio.}
proc call_with_unix_fd_list*(
    connection: GDBusConnection; bus_name: cstring; object_path: cstring;
    interface_name: cstring; method_name: cstring; parameters: GVariant;
    reply_type: GVariantType; flags: GDBusCallFlags; timeout_msec: gint;
    fd_list: GUnixFDList; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_dbus_connection_call_with_unix_fd_list", libgio.}
proc call_with_unix_fd_list_finish*(
    connection: GDBusConnection; out_fd_list: var GUnixFDList;
    res: GAsyncResult; error: var GError): GVariant {.
    importc: "g_dbus_connection_call_with_unix_fd_list_finish", libgio.}
proc call_with_unix_fd_list_sync*(
    connection: GDBusConnection; bus_name: cstring; object_path: cstring;
    interface_name: cstring; method_name: cstring; parameters: GVariant;
    reply_type: GVariantType; flags: GDBusCallFlags; timeout_msec: gint;
    fd_list: GUnixFDList; out_fd_list: var GUnixFDList;
    cancellable: GCancellable; error: var GError): GVariant {.
    importc: "g_dbus_connection_call_with_unix_fd_list_sync", libgio.}
type
  GDBusInterfaceMethodCallFunc* = proc (connection: GDBusConnection;
      sender: cstring; object_path: cstring; interface_name: cstring;
      method_name: cstring; parameters: GVariant;
      invocation: GDBusMethodInvocation; user_data: gpointer) {.cdecl.}
type
  GDBusInterfaceGetPropertyFunc* = proc (connection: GDBusConnection;
      sender: cstring; object_path: cstring; interface_name: cstring;
      property_name: cstring; error: var GError; user_data: gpointer): GVariant {.cdecl.}
type
  GDBusInterfaceSetPropertyFunc* = proc (connection: GDBusConnection;
      sender: cstring; object_path: cstring; interface_name: cstring;
      property_name: cstring; value: GVariant; error: var GError;
      user_data: gpointer): gboolean {.cdecl.}
type
  GDBusInterfaceVTable* =  ptr GDBusInterfaceVTableObj
  GDBusInterfaceVTablePtr* = ptr GDBusInterfaceVTableObj
  GDBusInterfaceVTableObj* = object
    method_call*: GDBusInterfaceMethodCallFunc
    get_property*: GDBusInterfaceGetPropertyFunc
    set_property*: GDBusInterfaceSetPropertyFunc
    padding*: array[8, gpointer]

proc unregister_object*(connection: GDBusConnection;
    registration_id: guint): gboolean {.
    importc: "g_dbus_connection_unregister_object", libgio.}
type
  GDBusSubtreeEnumerateFunc* = proc (connection: GDBusConnection;
                                     sender: cstring; object_path: cstring;
                                     user_data: gpointer): cstringArray {.cdecl.}
type
  GDBusSubtreeDispatchFunc* = proc (connection: GDBusConnection;
                                    sender: cstring; object_path: cstring;
                                    interface_name: cstring; node: cstring;
                                    out_user_data: var gpointer;
                                    user_data: gpointer): GDBusInterfaceVTable {.cdecl.}
proc unregister_subtree*(connection: GDBusConnection;
    registration_id: guint): gboolean {.
    importc: "g_dbus_connection_unregister_subtree", libgio.}
type
  GDBusSignalCallback* = proc (connection: GDBusConnection;
                               sender_name: cstring; object_path: cstring;
                               interface_name: cstring; signal_name: cstring;
                               parameters: GVariant; user_data: gpointer) {.cdecl.}
proc signal_subscribe*(connection: GDBusConnection;
    sender: cstring; interface_name: cstring; member: cstring;
    object_path: cstring; arg0: cstring; flags: GDBusSignalFlags;
    callback: GDBusSignalCallback; user_data: gpointer;
    user_data_free_func: GDestroyNotify): guint {.
    importc: "g_dbus_connection_signal_subscribe", libgio.}
proc signal_unsubscribe*(connection: GDBusConnection;
    subscription_id: guint) {.importc: "g_dbus_connection_signal_unsubscribe",
                              libgio.}
type
  GDBusMessageFilterFunction* = proc (connection: GDBusConnection;
                                      message: GDBusMessage;
                                      incoming: gboolean; user_data: gpointer): GDBusMessage {.cdecl.}
proc add_filter*(connection: GDBusConnection;
    filter_function: GDBusMessageFilterFunction; user_data: gpointer;
                                   user_data_free_func: GDestroyNotify): guint {.
    importc: "g_dbus_connection_add_filter", libgio.}
proc remove_filter*(connection: GDBusConnection;
                                      filter_id: guint) {.
    importc: "g_dbus_connection_remove_filter", libgio.}

proc g_dbus_error_quark*(): GQuark {.importc: "g_dbus_error_quark",
                                     libgio.}
proc g_dbus_error_is_remote_error*(error: GError): gboolean {.
    importc: "g_dbus_error_is_remote_error", libgio.}
proc g_dbus_error_get_remote_error*(error: GError): cstring {.
    importc: "g_dbus_error_get_remote_error", libgio.}
proc g_dbus_error_strip_remote_error*(error: GError): gboolean {.
    importc: "g_dbus_error_strip_remote_error", libgio.}
type
  GDBusErrorEntry* =  ptr GDBusErrorEntryObj
  GDBusErrorEntryPtr* = ptr GDBusErrorEntryObj
  GDBusErrorEntryObj* = object
    error_code*: gint
    dbus_error_name*: cstring

proc g_dbus_error_register_error*(error_domain: GQuark; error_code: gint;
                                  dbus_error_name: cstring): gboolean {.
    importc: "g_dbus_error_register_error", libgio.}
proc g_dbus_error_unregister_error*(error_domain: GQuark; error_code: gint;
                                    dbus_error_name: cstring): gboolean {.
    importc: "g_dbus_error_unregister_error", libgio.}
proc g_dbus_error_register_error_domain*(error_domain_quark_name: cstring;
    quark_volatile: var gsize; entries: GDBusErrorEntry;
    num_entries: guint) {.importc: "g_dbus_error_register_error_domain",
                          libgio.}
proc g_dbus_error_new_for_dbus_error*(dbus_error_name: cstring;
                                      dbus_error_message: cstring): GError {.
    importc: "g_dbus_error_new_for_dbus_error", libgio.}
proc g_dbus_error_set_dbus_error*(error: var GError;
                                  dbus_error_name: cstring;
                                  dbus_error_message: cstring; format: cstring) {.
    varargs, importc: "g_dbus_error_set_dbus_error", libgio.}
discard """
proc g_dbus_error_set_dbus_error_valist*(error: var GError;
    dbus_error_name: cstring; dbus_error_message: cstring; format: cstring;
    var_args: va_list) {.importc: "g_dbus_error_set_dbus_error_valist",
                         libgio.}
"""
proc g_dbus_error_encode_gerror*(error: GError): cstring {.
    importc: "g_dbus_error_encode_gerror", libgio.}

type
  GDBusAnnotationInfo* =  ptr GDBusAnnotationInfoObj
  GDBusAnnotationInfoPtr* = ptr GDBusAnnotationInfoObj
  GDBusAnnotationInfoObj* = object
    ref_count*: gint
    key*: cstring
    value*: cstring
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusArgInfo* =  ptr GDBusArgInfoObj
  GDBusArgInfoPtr* = ptr GDBusArgInfoObj
  GDBusArgInfoObj* = object
    ref_count*: gint
    name*: cstring
    signature*: cstring
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusMethodInfo* =  ptr GDBusMethodInfoObj
  GDBusMethodInfoPtr* = ptr GDBusMethodInfoObj
  GDBusMethodInfoObj* = object
    ref_count*: gint
    name*: cstring
    in_args*: ptr GDBusArgInfo
    out_args*: ptr GDBusArgInfo
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusSignalInfo* =  ptr GDBusSignalInfoObj
  GDBusSignalInfoPtr* = ptr GDBusSignalInfoObj
  GDBusSignalInfoObj* = object
    ref_count*: gint
    name*: cstring
    args*: ptr GDBusArgInfo
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusPropertyInfo* =  ptr GDBusPropertyInfoObj
  GDBusPropertyInfoPtr* = ptr GDBusPropertyInfoObj
  GDBusPropertyInfoObj* = object
    ref_count*: gint
    name*: cstring
    signature*: cstring
    flags*: GDBusPropertyInfoFlags
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusInterfaceInfo* =  ptr GDBusInterfaceInfoObj
  GDBusInterfaceInfoPtr* = ptr GDBusInterfaceInfoObj
  GDBusInterfaceInfoObj* = object
    ref_count*: gint
    name*: cstring
    methods*: ptr GDBusMethodInfo
    signals*: ptr GDBusSignalInfo
    properties*: ptr GDBusPropertyInfo
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusNodeInfo* =  ptr GDBusNodeInfoObj
  GDBusNodeInfoPtr* = ptr GDBusNodeInfoObj
  GDBusNodeInfoObj* = object
    ref_count*: gint
    path*: cstring
    interfaces*: ptr GDBusInterfaceInfo
    nodes*: ptr GDBusNodeInfo
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusSubtreeIntrospectFunc* = proc (connection: GDBusConnection;
                                      sender: cstring; object_path: cstring;
                                      node: cstring; user_data: gpointer): ptr GDBusInterfaceInfo {.cdecl.}
type
  GDBusSubtreeVTable* =  ptr GDBusSubtreeVTableObj
  GDBusSubtreeVTablePtr* = ptr GDBusSubtreeVTableObj
  GDBusSubtreeVTableObj* = object
    enumerate*: GDBusSubtreeEnumerateFunc
    introspect*: GDBusSubtreeIntrospectFunc
    dispatch*: GDBusSubtreeDispatchFunc
    padding*: array[8, gpointer]

proc register_subtree*(connection: GDBusConnection;
    object_path: cstring; vtable: GDBusSubtreeVTable;
    flags: GDBusSubtreeFlags; user_data: gpointer;
    user_data_free_func: GDestroyNotify; error: var GError): guint {.
    importc: "g_dbus_connection_register_subtree", libgio.}
proc register_object*(connection: GDBusConnection;
    object_path: cstring; interface_info: GDBusInterfaceInfo;
    vtable: GDBusInterfaceVTable; user_data: gpointer;
    user_data_free_func: GDestroyNotify; error: var GError): guint {.
    importc: "g_dbus_connection_register_object", libgio.}
proc lookup*(annotations: var GDBusAnnotationInfo;
                                    name: cstring): cstring {.
    importc: "g_dbus_annotation_info_lookup", libgio.}
proc lookup_method*(info: GDBusInterfaceInfo;
    name: cstring): GDBusMethodInfo {.
    importc: "g_dbus_interface_info_lookup_method", libgio.}
proc lookup_signal*(info: GDBusInterfaceInfo;
    name: cstring): GDBusSignalInfo {.
    importc: "g_dbus_interface_info_lookup_signal", libgio.}
proc lookup_property*(info: GDBusInterfaceInfo;
    name: cstring): GDBusPropertyInfo {.
    importc: "g_dbus_interface_info_lookup_property", libgio.}
proc cache_build*(info: GDBusInterfaceInfo) {.
    importc: "g_dbus_interface_info_cache_build", libgio.}
proc cache_release*(info: GDBusInterfaceInfo) {.
    importc: "g_dbus_interface_info_cache_release", libgio.}
proc generate_xml*(info: GDBusInterfaceInfo;
    indent: guint; string_builder: glib.GString) {.
    importc: "g_dbus_interface_info_generate_xml", libgio.}
proc g_dbus_node_info_new_for_xml*(xml_data: cstring; error: var GError): GDBusNodeInfo {.
    importc: "g_dbus_node_info_new_for_xml", libgio.}
proc lookup_interface*(info: GDBusNodeInfo; name: cstring): GDBusInterfaceInfo {.
    importc: "g_dbus_node_info_lookup_interface", libgio.}
proc generate_xml*(info: GDBusNodeInfo; indent: guint;
                                    string_builder: glib.GString) {.
    importc: "g_dbus_node_info_generate_xml", libgio.}
proc `ref`*(info: GDBusNodeInfo): GDBusNodeInfo {.
    importc: "g_dbus_node_info_ref", libgio.}
proc `ref`*(info: GDBusInterfaceInfo): GDBusInterfaceInfo {.
    importc: "g_dbus_interface_info_ref", libgio.}
proc `ref`*(info: GDBusMethodInfo): GDBusMethodInfo {.
    importc: "g_dbus_method_info_ref", libgio.}
proc `ref`*(info: GDBusSignalInfo): GDBusSignalInfo {.
    importc: "g_dbus_signal_info_ref", libgio.}
proc `ref`*(info: GDBusPropertyInfo): GDBusPropertyInfo {.
    importc: "g_dbus_property_info_ref", libgio.}
proc `ref`*(info: GDBusArgInfo): GDBusArgInfo {.
    importc: "g_dbus_arg_info_ref", libgio.}
proc `ref`*(info: GDBusAnnotationInfo): GDBusAnnotationInfo {.
    importc: "g_dbus_annotation_info_ref", libgio.}
proc unref*(info: GDBusNodeInfo) {.
    importc: "g_dbus_node_info_unref", libgio.}
proc unref*(info: GDBusInterfaceInfo) {.
    importc: "g_dbus_interface_info_unref", libgio.}
proc unref*(info: GDBusMethodInfo) {.
    importc: "g_dbus_method_info_unref", libgio.}
proc unref*(info: GDBusSignalInfo) {.
    importc: "g_dbus_signal_info_unref", libgio.}
proc unref*(info: GDBusPropertyInfo) {.
    importc: "g_dbus_property_info_unref", libgio.}
proc unref*(info: GDBusArgInfo) {.
    importc: "g_dbus_arg_info_unref", libgio.}
proc unref*(info: GDBusAnnotationInfo) {.
    importc: "g_dbus_annotation_info_unref", libgio.}
proc g_dbus_node_info_get_type*(): GType {.
    importc: "g_dbus_node_info_get_type", libgio.}
proc g_dbus_interface_info_get_type*(): GType {.
    importc: "g_dbus_interface_info_get_type", libgio.}
proc g_dbus_method_info_get_type*(): GType {.
    importc: "g_dbus_method_info_get_type", libgio.}
proc g_dbus_signal_info_get_type*(): GType {.
    importc: "g_dbus_signal_info_get_type", libgio.}
proc g_dbus_property_info_get_type*(): GType {.
    importc: "g_dbus_property_info_get_type", libgio.}
proc g_dbus_arg_info_get_type*(): GType {.importc: "g_dbus_arg_info_get_type",
    libgio.}
proc g_dbus_annotation_info_get_type*(): GType {.
    importc: "g_dbus_annotation_info_get_type", libgio.}

template g_dbus_message*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_message_get_type(), GDBusMessageObj))

template g_is_dbus_message*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_message_get_type()))

proc g_dbus_message_get_type*(): GType {.importc: "g_dbus_message_get_type",
    libgio.}
proc g_dbus_message_new*(): GDBusMessage {.importc: "g_dbus_message_new",
    libgio.}
proc g_dbus_message_new_signal*(path: cstring; `interface`: cstring;
                                signal: cstring): GDBusMessage {.
    importc: "g_dbus_message_new_signal", libgio.}
proc g_dbus_message_new_method_call*(name: cstring; path: cstring;
                                     `interface`: cstring; `method`: cstring): GDBusMessage {.
    importc: "g_dbus_message_new_method_call", libgio.}
proc new_method_reply*(method_call_message: GDBusMessage): GDBusMessage {.
    importc: "g_dbus_message_new_method_reply", libgio.}
proc new_method_error*(method_call_message: GDBusMessage;
                                      error_name: cstring;
                                      error_message_format: cstring): GDBusMessage {.
    varargs, importc: "g_dbus_message_new_method_error", libgio.}
discard """
proc new_method_error_valist*(
    method_call_message: GDBusMessage; error_name: cstring;
    error_message_format: cstring; var_args: va_list): GDBusMessage {.
    importc: "g_dbus_message_new_method_error_valist", libgio.}
"""
proc new_method_error_literal*(
    method_call_message: GDBusMessage; error_name: cstring;
    error_message: cstring): GDBusMessage {.
    importc: "g_dbus_message_new_method_error_literal", libgio.}
proc print*(message: GDBusMessage; indent: guint): cstring {.
    importc: "g_dbus_message_print", libgio.}
proc get_locked*(message: GDBusMessage): gboolean {.
    importc: "g_dbus_message_get_locked", libgio.}
proc locked*(message: GDBusMessage): gboolean {.
    importc: "g_dbus_message_get_locked", libgio.}
proc lock*(message: GDBusMessage) {.
    importc: "g_dbus_message_lock", libgio.}
proc copy*(message: GDBusMessage; error: var GError): GDBusMessage {.
    importc: "g_dbus_message_copy", libgio.}
proc get_byte_order*(message: GDBusMessage): GDBusMessageByteOrder {.
    importc: "g_dbus_message_get_byte_order", libgio.}
proc byte_order*(message: GDBusMessage): GDBusMessageByteOrder {.
    importc: "g_dbus_message_get_byte_order", libgio.}
proc set_byte_order*(message: GDBusMessage;
                                    byte_order: GDBusMessageByteOrder) {.
    importc: "g_dbus_message_set_byte_order", libgio.}
proc `byte_order=`*(message: GDBusMessage;
                                    byte_order: GDBusMessageByteOrder) {.
    importc: "g_dbus_message_set_byte_order", libgio.}
proc get_message_type*(message: GDBusMessage): GDBusMessageType {.
    importc: "g_dbus_message_get_message_type", libgio.}
proc message_type*(message: GDBusMessage): GDBusMessageType {.
    importc: "g_dbus_message_get_message_type", libgio.}
proc set_message_type*(message: GDBusMessage;
                                      `type`: GDBusMessageType) {.
    importc: "g_dbus_message_set_message_type", libgio.}
proc `message_type=`*(message: GDBusMessage;
                                      `type`: GDBusMessageType) {.
    importc: "g_dbus_message_set_message_type", libgio.}
proc get_flags*(message: GDBusMessage): GDBusMessageFlags {.
    importc: "g_dbus_message_get_flags", libgio.}
proc flags*(message: GDBusMessage): GDBusMessageFlags {.
    importc: "g_dbus_message_get_flags", libgio.}
proc set_flags*(message: GDBusMessage;
                               flags: GDBusMessageFlags) {.
    importc: "g_dbus_message_set_flags", libgio.}
proc `flags=`*(message: GDBusMessage;
                               flags: GDBusMessageFlags) {.
    importc: "g_dbus_message_set_flags", libgio.}
proc get_serial*(message: GDBusMessage): guint32 {.
    importc: "g_dbus_message_get_serial", libgio.}
proc serial*(message: GDBusMessage): guint32 {.
    importc: "g_dbus_message_get_serial", libgio.}
proc set_serial*(message: GDBusMessage; serial: guint32) {.
    importc: "g_dbus_message_set_serial", libgio.}
proc `serial=`*(message: GDBusMessage; serial: guint32) {.
    importc: "g_dbus_message_set_serial", libgio.}
proc get_header*(message: GDBusMessage;
                                header_field: GDBusMessageHeaderField): GVariant {.
    importc: "g_dbus_message_get_header", libgio.}
proc header*(message: GDBusMessage;
                                header_field: GDBusMessageHeaderField): GVariant {.
    importc: "g_dbus_message_get_header", libgio.}
proc set_header*(message: GDBusMessage;
                                header_field: GDBusMessageHeaderField;
                                value: GVariant) {.
    importc: "g_dbus_message_set_header", libgio.}
proc `header=`*(message: GDBusMessage;
                                header_field: GDBusMessageHeaderField;
                                value: GVariant) {.
    importc: "g_dbus_message_set_header", libgio.}
proc get_header_fields*(message: GDBusMessage): ptr guchar {.
    importc: "g_dbus_message_get_header_fields", libgio.}
proc header_fields*(message: GDBusMessage): ptr guchar {.
    importc: "g_dbus_message_get_header_fields", libgio.}
proc get_body*(message: GDBusMessage): GVariant {.
    importc: "g_dbus_message_get_body", libgio.}
proc body*(message: GDBusMessage): GVariant {.
    importc: "g_dbus_message_get_body", libgio.}
proc set_body*(message: GDBusMessage; body: GVariant) {.
    importc: "g_dbus_message_set_body", libgio.}
proc `body=`*(message: GDBusMessage; body: GVariant) {.
    importc: "g_dbus_message_set_body", libgio.}
proc get_unix_fd_list*(message: GDBusMessage): GUnixFDList {.
    importc: "g_dbus_message_get_unix_fd_list", libgio.}
proc unix_fd_list*(message: GDBusMessage): GUnixFDList {.
    importc: "g_dbus_message_get_unix_fd_list", libgio.}
proc set_unix_fd_list*(message: GDBusMessage;
                                      fd_list: GUnixFDList) {.
    importc: "g_dbus_message_set_unix_fd_list", libgio.}
proc `unix_fd_list=`*(message: GDBusMessage;
                                      fd_list: GUnixFDList) {.
    importc: "g_dbus_message_set_unix_fd_list", libgio.}
proc get_reply_serial*(message: GDBusMessage): guint32 {.
    importc: "g_dbus_message_get_reply_serial", libgio.}
proc reply_serial*(message: GDBusMessage): guint32 {.
    importc: "g_dbus_message_get_reply_serial", libgio.}
proc set_reply_serial*(message: GDBusMessage;
                                      value: guint32) {.
    importc: "g_dbus_message_set_reply_serial", libgio.}
proc `reply_serial=`*(message: GDBusMessage;
                                      value: guint32) {.
    importc: "g_dbus_message_set_reply_serial", libgio.}
proc get_interface*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_interface", libgio.}
proc `interface`*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_interface", libgio.}
proc set_interface*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_interface", libgio.}
proc `interface=`*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_interface", libgio.}
proc get_member*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_member", libgio.}
proc member*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_member", libgio.}
proc set_member*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_member", libgio.}
proc `member=`*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_member", libgio.}
proc get_path*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_path", libgio.}
proc path*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_path", libgio.}
proc set_path*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_path", libgio.}
proc `path=`*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_path", libgio.}
proc get_sender*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_sender", libgio.}
proc sender*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_sender", libgio.}
proc set_sender*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_sender", libgio.}
proc `sender=`*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_sender", libgio.}
proc get_destination*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_destination", libgio.}
proc destination*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_destination", libgio.}
proc set_destination*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_destination", libgio.}
proc `destination=`*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_destination", libgio.}
proc get_error_name*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_error_name", libgio.}
proc error_name*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_error_name", libgio.}
proc set_error_name*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_error_name", libgio.}
proc `error_name=`*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_error_name", libgio.}
proc get_signature*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_signature", libgio.}
proc signature*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_signature", libgio.}
proc set_signature*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_signature", libgio.}
proc `signature=`*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_signature", libgio.}
proc get_num_unix_fds*(message: GDBusMessage): guint32 {.
    importc: "g_dbus_message_get_num_unix_fds", libgio.}
proc num_unix_fds*(message: GDBusMessage): guint32 {.
    importc: "g_dbus_message_get_num_unix_fds", libgio.}
proc set_num_unix_fds*(message: GDBusMessage;
                                      value: guint32) {.
    importc: "g_dbus_message_set_num_unix_fds", libgio.}
proc `num_unix_fds=`*(message: GDBusMessage;
                                      value: guint32) {.
    importc: "g_dbus_message_set_num_unix_fds", libgio.}
proc get_arg0*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_arg0", libgio.}
proc arg0*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_arg0", libgio.}
proc g_dbus_message_new_from_blob*(blob: var guchar; blob_len: gsize;
                                   capabilities: GDBusCapabilityFlags;
                                   error: var GError): GDBusMessage {.
    importc: "g_dbus_message_new_from_blob", libgio.}
proc g_dbus_message_bytes_needed*(blob: var guchar; blob_len: gsize;
                                  error: var GError): gssize {.
    importc: "g_dbus_message_bytes_needed", libgio.}
proc to_blob*(message: GDBusMessage; out_size: var gsize;
                             capabilities: GDBusCapabilityFlags;
                             error: var GError): ptr guchar {.
    importc: "g_dbus_message_to_blob", libgio.}
proc to_gerror*(message: GDBusMessage;
                               error: var GError): gboolean {.
    importc: "g_dbus_message_to_gerror", libgio.}

template g_dbus_method_invocation*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_method_invocation_get_type(),
                              GDBusMethodInvocationObj))

template g_is_dbus_method_invocation*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_method_invocation_get_type()))

proc g_dbus_method_invocation_get_type*(): GType {.
    importc: "g_dbus_method_invocation_get_type", libgio.}
proc get_sender*(
    invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_sender", libgio.}
proc sender*(
    invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_sender", libgio.}
proc get_object_path*(
    invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_object_path", libgio.}
proc object_path*(
    invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_object_path", libgio.}
proc get_interface_name*(
    invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_interface_name", libgio.}
proc interface_name*(
    invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_interface_name", libgio.}
proc get_method_name*(
    invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_method_name", libgio.}
proc method_name*(
    invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_method_name", libgio.}
proc get_method_info*(
    invocation: GDBusMethodInvocation): GDBusMethodInfo {.
    importc: "g_dbus_method_invocation_get_method_info", libgio.}
proc method_info*(
    invocation: GDBusMethodInvocation): GDBusMethodInfo {.
    importc: "g_dbus_method_invocation_get_method_info", libgio.}
proc get_property_info*(
    invocation: GDBusMethodInvocation): GDBusPropertyInfo {.
    importc: "g_dbus_method_invocation_get_property_info", libgio.}
proc property_info*(
    invocation: GDBusMethodInvocation): GDBusPropertyInfo {.
    importc: "g_dbus_method_invocation_get_property_info", libgio.}
proc get_connection*(
    invocation: GDBusMethodInvocation): GDBusConnection {.
    importc: "g_dbus_method_invocation_get_connection", libgio.}
proc connection*(
    invocation: GDBusMethodInvocation): GDBusConnection {.
    importc: "g_dbus_method_invocation_get_connection", libgio.}
proc get_message*(
    invocation: GDBusMethodInvocation): GDBusMessage {.
    importc: "g_dbus_method_invocation_get_message", libgio.}
proc message*(
    invocation: GDBusMethodInvocation): GDBusMessage {.
    importc: "g_dbus_method_invocation_get_message", libgio.}
proc get_parameters*(
    invocation: GDBusMethodInvocation): GVariant {.
    importc: "g_dbus_method_invocation_get_parameters", libgio.}
proc parameters*(
    invocation: GDBusMethodInvocation): GVariant {.
    importc: "g_dbus_method_invocation_get_parameters", libgio.}
proc get_user_data*(
    invocation: GDBusMethodInvocation): gpointer {.
    importc: "g_dbus_method_invocation_get_user_data", libgio.}
proc user_data*(
    invocation: GDBusMethodInvocation): gpointer {.
    importc: "g_dbus_method_invocation_get_user_data", libgio.}
proc return_value*(
    invocation: GDBusMethodInvocation; parameters: GVariant) {.
    importc: "g_dbus_method_invocation_return_value", libgio.}
proc return_value_with_unix_fd_list*(
    invocation: GDBusMethodInvocation; parameters: GVariant;
    fd_list: GUnixFDList) {.importc: "g_dbus_method_invocation_return_value_with_unix_fd_list",
                                libgio.}
proc return_error*(
    invocation: GDBusMethodInvocation; domain: GQuark; code: gint;
    format: cstring) {.varargs,
                       importc: "g_dbus_method_invocation_return_error",
                       libgio.}
discard """
proc return_error_valist*(
    invocation: GDBusMethodInvocation; domain: GQuark; code: gint;
    format: cstring; var_args: va_list) {.
    importc: "g_dbus_method_invocation_return_error_valist", libgio.}
"""
proc return_error_literal*(
    invocation: GDBusMethodInvocation; domain: GQuark; code: gint;
    message: cstring) {.importc: "g_dbus_method_invocation_return_error_literal",
                        libgio.}
proc return_gerror*(
    invocation: GDBusMethodInvocation; error: GError) {.
    importc: "g_dbus_method_invocation_return_gerror", libgio.}
proc take_error*(
    invocation: GDBusMethodInvocation; error: GError) {.
    importc: "g_dbus_method_invocation_take_error", libgio.}
proc return_dbus_error*(
    invocation: GDBusMethodInvocation; error_name: cstring;
    error_message: cstring) {.importc: "g_dbus_method_invocation_return_dbus_error",
                              libgio.}

type
  GBusAcquiredCallback* = proc (connection: GDBusConnection;
                                name: cstring; user_data: gpointer) {.cdecl.}
type
  GBusNameAcquiredCallback* = proc (connection: GDBusConnection;
                                    name: cstring; user_data: gpointer) {.cdecl.}
type
  GBusNameLostCallback* = proc (connection: GDBusConnection;
                                name: cstring; user_data: gpointer) {.cdecl.}
proc g_bus_own_name*(bus_type: GBusType; name: cstring;
                     flags: GBusNameOwnerFlags;
                     bus_acquired_handler: GBusAcquiredCallback;
                     name_acquired_handler: GBusNameAcquiredCallback;
                     name_lost_handler: GBusNameLostCallback;
                     user_data: gpointer; user_data_free_func: GDestroyNotify): guint {.
    importc: "g_bus_own_name", libgio.}
proc g_bus_own_name_on_connection*(connection: GDBusConnection;
                                   name: cstring; flags: GBusNameOwnerFlags;
    name_acquired_handler: GBusNameAcquiredCallback;
                                   name_lost_handler: GBusNameLostCallback;
                                   user_data: gpointer;
                                   user_data_free_func: GDestroyNotify): guint {.
    importc: "g_bus_own_name_on_connection", libgio.}
proc g_bus_own_name_with_closures*(bus_type: GBusType; name: cstring;
                                   flags: GBusNameOwnerFlags;
                                   bus_acquired_closure: GClosure;
                                   name_acquired_closure: GClosure;
                                   name_lost_closure: GClosure): guint {.
    importc: "g_bus_own_name_with_closures", libgio.}
proc g_bus_own_name_on_connection_with_closures*(
    connection: GDBusConnection; name: cstring; flags: GBusNameOwnerFlags;
    name_acquired_closure: GClosure; name_lost_closure: GClosure): guint {.
    importc: "g_bus_own_name_on_connection_with_closures", libgio.}
proc g_bus_unown_name*(owner_id: guint) {.importc: "g_bus_unown_name",
    libgio.}

type
  GBusNameAppearedCallback* = proc (connection: GDBusConnection;
                                    name: cstring; name_owner: cstring;
                                    user_data: gpointer) {.cdecl.}
type
  GBusNameVanishedCallback* = proc (connection: GDBusConnection;
                                    name: cstring; user_data: gpointer) {.cdecl.}
proc g_bus_watch_name*(bus_type: GBusType; name: cstring;
                       flags: GBusNameWatcherFlags;
                       name_appeared_handler: GBusNameAppearedCallback;
                       name_vanished_handler: GBusNameVanishedCallback;
                       user_data: gpointer;
                       user_data_free_func: GDestroyNotify): guint {.
    importc: "g_bus_watch_name", libgio.}
proc g_bus_watch_name_on_connection*(connection: GDBusConnection;
                                     name: cstring;
                                     flags: GBusNameWatcherFlags;
    name_appeared_handler: GBusNameAppearedCallback; name_vanished_handler: GBusNameVanishedCallback;
                                     user_data: gpointer;
                                     user_data_free_func: GDestroyNotify): guint {.
    importc: "g_bus_watch_name_on_connection", libgio.}
proc g_bus_watch_name_with_closures*(bus_type: GBusType; name: cstring;
                                     flags: GBusNameWatcherFlags;
                                     name_appeared_closure: GClosure;
                                     name_vanished_closure: GClosure): guint {.
    importc: "g_bus_watch_name_with_closures", libgio.}
proc g_bus_watch_name_on_connection_with_closures*(
    connection: GDBusConnection; name: cstring;
    flags: GBusNameWatcherFlags; name_appeared_closure: GClosure;
    name_vanished_closure: GClosure): guint {.
    importc: "g_bus_watch_name_on_connection_with_closures", libgio.}
proc g_bus_unwatch_name*(watcher_id: guint) {.importc: "g_bus_unwatch_name",
    libgio.}

template g_dbus_proxy*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_proxy_get_type(), GDBusProxyObj))

template g_dbus_proxy_class*(k: expr): expr =
  (g_type_check_class_cast(k, dbus_proxy_get_type(), GDBusProxyClassObj))

template g_dbus_proxy_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, dbus_proxy_get_type(), GDBusProxyClassObj))

template g_is_dbus_proxy*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_proxy_get_type()))

template g_is_dbus_proxy_class*(k: expr): expr =
  (g_type_check_class_type(k, dbus_proxy_get_type()))

type
  GDBusProxyPrivateObj = object
 
type
  GDBusProxy* =  ptr GDBusProxyObj
  GDBusProxyPtr* = ptr GDBusProxyObj
  GDBusProxyObj*{.final.} = object of GObjectObj
    priv16: ptr GDBusProxyPrivateObj

type
  GDBusProxyClass* =  ptr GDBusProxyClassObj
  GDBusProxyClassPtr* = ptr GDBusProxyClassObj
  GDBusProxyClassObj*{.final.} = object of GObjectClassObj
    g_properties_changed*: proc (proxy: GDBusProxy;
                                 changed_properties: GVariant;
                                 invalidated_properties: cstringArray) {.cdecl.}
    g_signal*: proc (proxy: GDBusProxy; sender_name: cstring;
                     signal_name: cstring; parameters: GVariant) {.cdecl.}
    padding*: array[32, gpointer]

proc g_dbus_proxy_get_type*(): GType {.importc: "g_dbus_proxy_get_type",
    libgio.}
proc g_dbus_proxy_new*(connection: GDBusConnection;
                       flags: GDBusProxyFlags; info: GDBusInterfaceInfo;
                       name: cstring; object_path: cstring;
                       interface_name: cstring; cancellable: GCancellable;
                       callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_dbus_proxy_new", libgio.}
proc g_dbus_proxy_new_finish*(res: GAsyncResult; error: var GError): GDBusProxy {.
    importc: "g_dbus_proxy_new_finish", libgio.}
proc g_dbus_proxy_new_sync*(connection: GDBusConnection;
                            flags: GDBusProxyFlags;
                            info: GDBusInterfaceInfo; name: cstring;
                            object_path: cstring; interface_name: cstring;
                            cancellable: GCancellable;
                            error: var GError): GDBusProxy {.
    importc: "g_dbus_proxy_new_sync", libgio.}
proc g_dbus_proxy_new_for_bus*(bus_type: GBusType; flags: GDBusProxyFlags;
                               info: GDBusInterfaceInfo; name: cstring;
                               object_path: cstring; interface_name: cstring;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback;
                               user_data: gpointer) {.
    importc: "g_dbus_proxy_new_for_bus", libgio.}
proc g_dbus_proxy_new_for_bus_finish*(res: GAsyncResult;
                                      error: var GError): GDBusProxy {.
    importc: "g_dbus_proxy_new_for_bus_finish", libgio.}
proc g_dbus_proxy_new_for_bus_sync*(bus_type: GBusType;
                                    flags: GDBusProxyFlags;
                                    info: GDBusInterfaceInfo;
                                    name: cstring; object_path: cstring;
                                    interface_name: cstring;
                                    cancellable: GCancellable;
                                    error: var GError): GDBusProxy {.
    importc: "g_dbus_proxy_new_for_bus_sync", libgio.}
proc get_connection*(proxy: GDBusProxy): GDBusConnection {.
    importc: "g_dbus_proxy_get_connection", libgio.}
proc connection*(proxy: GDBusProxy): GDBusConnection {.
    importc: "g_dbus_proxy_get_connection", libgio.}
proc get_flags*(proxy: GDBusProxy): GDBusProxyFlags {.
    importc: "g_dbus_proxy_get_flags", libgio.}
proc flags*(proxy: GDBusProxy): GDBusProxyFlags {.
    importc: "g_dbus_proxy_get_flags", libgio.}
proc get_name*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_name", libgio.}
proc name*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_name", libgio.}
proc get_name_owner*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_name_owner", libgio.}
proc name_owner*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_name_owner", libgio.}
proc get_object_path*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_object_path", libgio.}
proc object_path*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_object_path", libgio.}
proc get_interface_name*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_interface_name", libgio.}
proc interface_name*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_interface_name", libgio.}
proc get_default_timeout*(proxy: GDBusProxy): gint {.
    importc: "g_dbus_proxy_get_default_timeout", libgio.}
proc default_timeout*(proxy: GDBusProxy): gint {.
    importc: "g_dbus_proxy_get_default_timeout", libgio.}
proc set_default_timeout*(proxy: GDBusProxy;
    timeout_msec: gint) {.importc: "g_dbus_proxy_set_default_timeout",
                          libgio.}
proc `default_timeout=`*(proxy: GDBusProxy;
    timeout_msec: gint) {.importc: "g_dbus_proxy_set_default_timeout",
                          libgio.}
proc get_interface_info*(proxy: GDBusProxy): GDBusInterfaceInfo {.
    importc: "g_dbus_proxy_get_interface_info", libgio.}
proc interface_info*(proxy: GDBusProxy): GDBusInterfaceInfo {.
    importc: "g_dbus_proxy_get_interface_info", libgio.}
proc set_interface_info*(proxy: GDBusProxy;
                                      info: GDBusInterfaceInfo) {.
    importc: "g_dbus_proxy_set_interface_info", libgio.}
proc `interface_info=`*(proxy: GDBusProxy;
                                      info: GDBusInterfaceInfo) {.
    importc: "g_dbus_proxy_set_interface_info", libgio.}
proc get_cached_property*(proxy: GDBusProxy;
    property_name: cstring): GVariant {.
    importc: "g_dbus_proxy_get_cached_property", libgio.}
proc cached_property*(proxy: GDBusProxy;
    property_name: cstring): GVariant {.
    importc: "g_dbus_proxy_get_cached_property", libgio.}
proc set_cached_property*(proxy: GDBusProxy;
    property_name: cstring; value: GVariant) {.
    importc: "g_dbus_proxy_set_cached_property", libgio.}
proc `cached_property=`*(proxy: GDBusProxy;
    property_name: cstring; value: GVariant) {.
    importc: "g_dbus_proxy_set_cached_property", libgio.}
proc get_cached_property_names*(proxy: GDBusProxy): cstringArray {.
    importc: "g_dbus_proxy_get_cached_property_names", libgio.}
proc cached_property_names*(proxy: GDBusProxy): cstringArray {.
    importc: "g_dbus_proxy_get_cached_property_names", libgio.}
proc call*(proxy: GDBusProxy; method_name: cstring;
                        parameters: GVariant; flags: GDBusCallFlags;
                        timeout_msec: gint; cancellable: GCancellable;
                        callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_dbus_proxy_call", libgio.}
proc call_finish*(proxy: GDBusProxy; res: GAsyncResult;
                               error: var GError): GVariant {.
    importc: "g_dbus_proxy_call_finish", libgio.}
proc call_sync*(proxy: GDBusProxy; method_name: cstring;
                             parameters: GVariant; flags: GDBusCallFlags;
                             timeout_msec: gint;
                             cancellable: GCancellable;
                             error: var GError): GVariant {.
    importc: "g_dbus_proxy_call_sync", libgio.}
proc call_with_unix_fd_list*(proxy: GDBusProxy;
    method_name: cstring; parameters: GVariant; flags: GDBusCallFlags;
    timeout_msec: gint; fd_list: GUnixFDList;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_dbus_proxy_call_with_unix_fd_list",
                           libgio.}
proc call_with_unix_fd_list_finish*(proxy: GDBusProxy;
    out_fd_list: var GUnixFDList; res: GAsyncResult;
    error: var GError): GVariant {.
    importc: "g_dbus_proxy_call_with_unix_fd_list_finish", libgio.}
proc call_with_unix_fd_list_sync*(proxy: GDBusProxy;
    method_name: cstring; parameters: GVariant; flags: GDBusCallFlags;
    timeout_msec: gint; fd_list: GUnixFDList;
    out_fd_list: var GUnixFDList; cancellable: GCancellable;
    error: var GError): GVariant {.
    importc: "g_dbus_proxy_call_with_unix_fd_list_sync", libgio.}

template g_dbus_server*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_server_get_type(), GDBusServerObj))

template g_is_dbus_server*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_server_get_type()))

proc g_dbus_server_get_type*(): GType {.importc: "g_dbus_server_get_type",
    libgio.}
proc g_dbus_server_new_sync*(address: cstring; flags: GDBusServerFlags;
                             guid: cstring; observer: GDBusAuthObserver;
                             cancellable: GCancellable;
                             error: var GError): GDBusServer {.
    importc: "g_dbus_server_new_sync", libgio.}
proc get_client_address*(server: GDBusServer): cstring {.
    importc: "g_dbus_server_get_client_address", libgio.}
proc client_address*(server: GDBusServer): cstring {.
    importc: "g_dbus_server_get_client_address", libgio.}
proc get_guid*(server: GDBusServer): cstring {.
    importc: "g_dbus_server_get_guid", libgio.}
proc guid*(server: GDBusServer): cstring {.
    importc: "g_dbus_server_get_guid", libgio.}
proc get_flags*(server: GDBusServer): GDBusServerFlags {.
    importc: "g_dbus_server_get_flags", libgio.}
proc flags*(server: GDBusServer): GDBusServerFlags {.
    importc: "g_dbus_server_get_flags", libgio.}
proc start*(server: GDBusServer) {.
    importc: "g_dbus_server_start", libgio.}
proc stop*(server: GDBusServer) {.
    importc: "g_dbus_server_stop", libgio.}
proc is_active*(server: GDBusServer): gboolean {.
    importc: "g_dbus_server_is_active", libgio.}

proc g_dbus_is_guid*(string: cstring): gboolean {.importc: "g_dbus_is_guid",
    libgio.}
proc g_dbus_generate_guid*(): cstring {.importc: "g_dbus_generate_guid",
    libgio.}
proc g_dbus_is_name*(string: cstring): gboolean {.importc: "g_dbus_is_name",
    libgio.}
proc g_dbus_is_unique_name*(string: cstring): gboolean {.
    importc: "g_dbus_is_unique_name", libgio.}
proc g_dbus_is_member_name*(string: cstring): gboolean {.
    importc: "g_dbus_is_member_name", libgio.}
proc g_dbus_is_interface_name*(string: cstring): gboolean {.
    importc: "g_dbus_is_interface_name", libgio.}
proc g_dbus_gvariant_to_gvalue*(value: GVariant; out_gvalue: GValue) {.
    importc: "g_dbus_gvariant_to_gvalue", libgio.}
proc g_dbus_gvalue_to_gvariant*(gvalue: GValue; `type`: GVariantType): GVariant {.
    importc: "g_dbus_gvalue_to_gvariant", libgio.}
type
  GMountOperationPrivateObj = object
 
type
  GMountOperation* =  ptr GMountOperationObj
  GMountOperationPtr* = ptr GMountOperationObj
  GMountOperationObj* = object of GObjectObj
    priv29: ptr GMountOperationPrivateObj

template g_drive*(obj: expr): expr =
  (g_type_check_instance_cast(obj, drive_get_type(), GDriveObj))

template g_is_drive*(obj: expr): expr =
  (g_type_check_instance_type(obj, drive_get_type()))

template g_drive_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, drive_get_type(), GDriveIfaceObj))

type
  GDriveIface* =  ptr GDriveIfaceObj
  GDriveIfacePtr* = ptr GDriveIfaceObj
  GDriveIfaceObj*{.final.} = object of GTypeInterfaceObj
    changed*: proc (drive: GDrive) {.cdecl.}
    disconnected*: proc (drive: GDrive) {.cdecl.}
    eject_button*: proc (drive: GDrive) {.cdecl.}
    get_name*: proc (drive: GDrive): cstring {.cdecl.}
    get_icon*: proc (drive: GDrive): GIcon {.cdecl.}
    has_volumes*: proc (drive: GDrive): gboolean {.cdecl.}
    get_volumes*: proc (drive: GDrive): GList {.cdecl.}
    is_media_removable*: proc (drive: GDrive): gboolean {.cdecl.}
    has_media*: proc (drive: GDrive): gboolean {.cdecl.}
    is_media_check_automatic*: proc (drive: GDrive): gboolean {.cdecl.}
    can_eject*: proc (drive: GDrive): gboolean {.cdecl.}
    can_poll_for_media*: proc (drive: GDrive): gboolean {.cdecl.}
    eject*: proc (drive: GDrive; flags: GMountUnmountFlags;
                  cancellable: GCancellable;
                  callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    eject_finish*: proc (drive: GDrive; result: GAsyncResult;
                         error: var GError): gboolean {.cdecl.}
    poll_for_media*: proc (drive: GDrive; cancellable: GCancellable;
                           callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    poll_for_media_finish*: proc (drive: GDrive; result: GAsyncResult;
                                  error: var GError): gboolean {.cdecl.}
    get_identifier*: proc (drive: GDrive; kind: cstring): cstring {.cdecl.}
    enumerate_identifiers*: proc (drive: GDrive): cstringArray {.cdecl.}
    get_start_stop_type*: proc (drive: GDrive): GDriveStartStopType {.cdecl.}
    can_start*: proc (drive: GDrive): gboolean {.cdecl.}
    can_start_degraded*: proc (drive: GDrive): gboolean {.cdecl.}
    start*: proc (drive: GDrive; flags: GDriveStartFlags;
                  mount_operation: GMountOperation;
                  cancellable: GCancellable;
                  callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    start_finish*: proc (drive: GDrive; result: GAsyncResult;
                         error: var GError): gboolean {.cdecl.}
    can_stop*: proc (drive: GDrive): gboolean {.cdecl.}
    stop*: proc (drive: GDrive; flags: GMountUnmountFlags;
                 mount_operation: GMountOperation;
                 cancellable: GCancellable; callback: GAsyncReadyCallback;
                 user_data: gpointer) {.cdecl.}
    stop_finish*: proc (drive: GDrive; result: GAsyncResult;
                        error: var GError): gboolean {.cdecl.}
    stop_button*: proc (drive: GDrive) {.cdecl.}
    eject_with_operation*: proc (drive: GDrive; flags: GMountUnmountFlags;
                                 mount_operation: GMountOperation;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.cdecl.}
    eject_with_operation_finish*: proc (drive: GDrive;
        result: GAsyncResult; error: var GError): gboolean {.cdecl.}
    get_sort_key*: proc (drive: GDrive): cstring {.cdecl.}
    get_symbolic_icon*: proc (drive: GDrive): GIcon {.cdecl.}

proc g_drive_get_type*(): GType {.importc: "g_drive_get_type", libgio.}
proc get_name*(drive: GDrive): cstring {.
    importc: "g_drive_get_name", libgio.}
proc name*(drive: GDrive): cstring {.
    importc: "g_drive_get_name", libgio.}
proc get_icon*(drive: GDrive): GIcon {.
    importc: "g_drive_get_icon", libgio.}
proc icon*(drive: GDrive): GIcon {.
    importc: "g_drive_get_icon", libgio.}
proc get_symbolic_icon*(drive: GDrive): GIcon {.
    importc: "g_drive_get_symbolic_icon", libgio.}
proc symbolic_icon*(drive: GDrive): GIcon {.
    importc: "g_drive_get_symbolic_icon", libgio.}
proc has_volumes*(drive: GDrive): gboolean {.
    importc: "g_drive_has_volumes", libgio.}
proc get_volumes*(drive: GDrive): GList {.
    importc: "g_drive_get_volumes", libgio.}
proc volumes*(drive: GDrive): GList {.
    importc: "g_drive_get_volumes", libgio.}
proc is_media_removable*(drive: GDrive): gboolean {.
    importc: "g_drive_is_media_removable", libgio.}
proc has_media*(drive: GDrive): gboolean {.
    importc: "g_drive_has_media", libgio.}
proc is_media_check_automatic*(drive: GDrive): gboolean {.
    importc: "g_drive_is_media_check_automatic", libgio.}
proc can_poll_for_media*(drive: GDrive): gboolean {.
    importc: "g_drive_can_poll_for_media", libgio.}
proc can_eject*(drive: GDrive): gboolean {.
    importc: "g_drive_can_eject", libgio.}
proc eject*(drive: GDrive; flags: GMountUnmountFlags;
                    cancellable: GCancellable;
                    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_drive_eject", libgio.}
proc eject_finish*(drive: GDrive; result: GAsyncResult;
                           error: var GError): gboolean {.
    importc: "g_drive_eject_finish", libgio.}
proc poll_for_media*(drive: GDrive; cancellable: GCancellable;
                             callback: GAsyncReadyCallback;
                             user_data: gpointer) {.
    importc: "g_drive_poll_for_media", libgio.}
proc poll_for_media_finish*(drive: GDrive;
                                    result: GAsyncResult;
                                    error: var GError): gboolean {.
    importc: "g_drive_poll_for_media_finish", libgio.}
proc get_identifier*(drive: GDrive; kind: cstring): cstring {.
    importc: "g_drive_get_identifier", libgio.}
proc identifier*(drive: GDrive; kind: cstring): cstring {.
    importc: "g_drive_get_identifier", libgio.}
proc enumerate_identifiers*(drive: GDrive): cstringArray {.
    importc: "g_drive_enumerate_identifiers", libgio.}
proc get_start_stop_type*(drive: GDrive): GDriveStartStopType {.
    importc: "g_drive_get_start_stop_type", libgio.}
proc start_stop_type*(drive: GDrive): GDriveStartStopType {.
    importc: "g_drive_get_start_stop_type", libgio.}
proc can_start*(drive: GDrive): gboolean {.
    importc: "g_drive_can_start", libgio.}
proc can_start_degraded*(drive: GDrive): gboolean {.
    importc: "g_drive_can_start_degraded", libgio.}
proc start*(drive: GDrive; flags: GDriveStartFlags;
                    mount_operation: GMountOperation;
                    cancellable: GCancellable;
                    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_drive_start", libgio.}
proc start_finish*(drive: GDrive; result: GAsyncResult;
                           error: var GError): gboolean {.
    importc: "g_drive_start_finish", libgio.}
proc can_stop*(drive: GDrive): gboolean {.
    importc: "g_drive_can_stop", libgio.}
proc stop*(drive: GDrive; flags: GMountUnmountFlags;
                   mount_operation: GMountOperation;
                   cancellable: GCancellable;
                   callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_drive_stop", libgio.}
proc stop_finish*(drive: GDrive; result: GAsyncResult;
                          error: var GError): gboolean {.
    importc: "g_drive_stop_finish", libgio.}
proc eject_with_operation*(drive: GDrive;
                                   flags: GMountUnmountFlags;
                                   mount_operation: GMountOperation;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   user_data: gpointer) {.
    importc: "g_drive_eject_with_operation", libgio.}
proc eject_with_operation_finish*(drive: GDrive;
    result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_drive_eject_with_operation_finish", libgio.}
proc get_sort_key*(drive: GDrive): cstring {.
    importc: "g_drive_get_sort_key", libgio.}
proc sort_key*(drive: GDrive): cstring {.
    importc: "g_drive_get_sort_key", libgio.}

template g_icon*(obj: expr): expr =
  (g_type_check_instance_cast(obj, icon_get_type(), GIconObj))

template g_is_icon*(obj: expr): expr =
  (g_type_check_instance_type(obj, icon_get_type()))

template g_icon_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, icon_get_type(), GIconIfaceObj))

type
  GIconIface* =  ptr GIconIfaceObj
  GIconIfacePtr* = ptr GIconIfaceObj
  GIconIfaceObj*{.final.} = object of GTypeInterfaceObj
    hash*: proc (icon: GIcon): guint {.cdecl.}
    equal*: proc (icon1: GIcon; icon2: GIcon): gboolean {.cdecl.}
    to_tokens*: proc (icon: GIcon; tokens: glib.GPtrArray;
                      out_version: var gint): gboolean {.cdecl.}
    from_tokens*: proc (tokens: cstringArray; num_tokens: gint; version: gint;
                        error: var GError): GIcon {.cdecl.}
    serialize*: proc (icon: GIcon): GVariant {.cdecl.}

proc g_icon_get_type*(): GType {.importc: "g_icon_get_type", libgio.}
proc g_icon_hash*(icon: gconstpointer): guint {.importc: "g_icon_hash",
    libgio.}
proc equal*(icon1: GIcon; icon2: GIcon): gboolean {.
    importc: "g_icon_equal", libgio.}
proc to_string*(icon: GIcon): cstring {.
    importc: "g_icon_to_string", libgio.}
proc g_icon_new_for_string*(str: cstring; error: var GError): GIcon {.
    importc: "g_icon_new_for_string", libgio.}
proc serialize*(icon: GIcon): GVariant {.
    importc: "g_icon_serialize", libgio.}
proc g_icon_deserialize*(value: GVariant): GIcon {.
    importc: "g_icon_deserialize", libgio.}

template g_emblem*(o: expr): expr =
  (g_type_check_instance_cast(o, emblem_get_type(), GEmblemObj))

template g_emblem_class*(k: expr): expr =
  (g_type_check_class_cast(k, emblem_get_type(), GEmblemClassObj))

template g_is_emblem*(o: expr): expr =
  (g_type_check_instance_type(o, emblem_get_type()))

template g_is_emblem_class*(k: expr): expr =
  (g_type_check_class_type(k, emblem_get_type()))

template g_emblem_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, emblem_get_type(), GEmblemClassObj))

type
  GEmblem* =  ptr GEmblemObj
  GEmblemPtr* = ptr GEmblemObj
  GEmblemObj* = object
 
  GEmblemClass* =  ptr GEmblemClassObj
  GEmblemClassPtr* = ptr GEmblemClassObj
  GEmblemClassObj* = object
 
proc g_emblem_get_type*(): GType {.importc: "g_emblem_get_type", libgio.}
proc g_emblem_new*(icon: GIcon): GEmblem {.importc: "g_emblem_new",
    libgio.}
proc g_emblem_new_with_origin*(icon: GIcon; origin: GEmblemOrigin): GEmblem {.
    importc: "g_emblem_new_with_origin", libgio.}
proc get_icon*(emblem: GEmblem): GIcon {.
    importc: "g_emblem_get_icon", libgio.}
proc icon*(emblem: GEmblem): GIcon {.
    importc: "g_emblem_get_icon", libgio.}
proc get_origin*(emblem: GEmblem): GEmblemOrigin {.
    importc: "g_emblem_get_origin", libgio.}
proc origin*(emblem: GEmblem): GEmblemOrigin {.
    importc: "g_emblem_get_origin", libgio.}

template g_emblemed_icon*(o: expr): expr =
  (g_type_check_instance_cast(o, emblemed_icon_get_type(), GEmblemedIconObj))

template g_emblemed_icon_class*(k: expr): expr =
  (g_type_check_class_cast(k, emblemed_icon_get_type(), GEmblemedIconClassObj))

template g_is_emblemed_icon*(o: expr): expr =
  (g_type_check_instance_type(o, emblemed_icon_get_type()))

template g_is_emblemed_icon_class*(k: expr): expr =
  (g_type_check_class_type(k, emblemed_icon_get_type()))

template g_emblemed_icon_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, emblemed_icon_get_type(), GEmblemedIconClassObj))

type
  GEmblemedIconPrivateObj = object
 
type
  GEmblemedIcon* =  ptr GEmblemedIconObj
  GEmblemedIconPtr* = ptr GEmblemedIconObj
  GEmblemedIconObj* = object of GObjectObj
    priv17: ptr GEmblemedIconPrivateObj

type
  GEmblemedIconClass* =  ptr GEmblemedIconClassObj
  GEmblemedIconClassPtr* = ptr GEmblemedIconClassObj
  GEmblemedIconClassObj* = object of GObjectClassObj

proc g_emblemed_icon_get_type*(): GType {.importc: "g_emblemed_icon_get_type",
    libgio.}
proc g_emblemed_icon_new*(icon: GIcon; emblem: GEmblem): GIcon {.
    importc: "g_emblemed_icon_new", libgio.}
proc get_icon*(emblemed: GEmblemedIcon): GIcon {.
    importc: "g_emblemed_icon_get_icon", libgio.}
proc icon*(emblemed: GEmblemedIcon): GIcon {.
    importc: "g_emblemed_icon_get_icon", libgio.}
proc get_emblems*(emblemed: GEmblemedIcon): GList {.
    importc: "g_emblemed_icon_get_emblems", libgio.}
proc emblems*(emblemed: GEmblemedIcon): GList {.
    importc: "g_emblemed_icon_get_emblems", libgio.}
proc add_emblem*(emblemed: GEmblemedIcon;
                                 emblem: GEmblem) {.
    importc: "g_emblemed_icon_add_emblem", libgio.}
proc clear_emblems*(emblemed: GEmblemedIcon) {.
    importc: "g_emblemed_icon_clear_emblems", libgio.}

type
  GFileAttributeInfo* =  ptr GFileAttributeInfoObj
  GFileAttributeInfoPtr* = ptr GFileAttributeInfoObj
  GFileAttributeInfoObj* = object
    name*: cstring
    `type`*: GFileAttributeType
    flags*: GFileAttributeInfoFlags

type
  GFileAttributeInfoList* =  ptr GFileAttributeInfoListObj
  GFileAttributeInfoListPtr* = ptr GFileAttributeInfoListObj
  GFileAttributeInfoListObj* = object
    infos*: GFileAttributeInfo
    n_infos*: cint

proc g_file_attribute_info_list_get_type*(): GType {.
    importc: "g_file_attribute_info_list_get_type", libgio.}
proc g_file_attribute_info_list_new*(): GFileAttributeInfoList {.
    importc: "g_file_attribute_info_list_new", libgio.}
proc `ref`*(list: GFileAttributeInfoList): GFileAttributeInfoList {.
    importc: "g_file_attribute_info_list_ref", libgio.}
proc unref*(list: GFileAttributeInfoList) {.
    importc: "g_file_attribute_info_list_unref", libgio.}
proc dup*(list: GFileAttributeInfoList): GFileAttributeInfoList {.
    importc: "g_file_attribute_info_list_dup", libgio.}
proc lookup*(list: GFileAttributeInfoList;
    name: cstring): GFileAttributeInfo {.
    importc: "g_file_attribute_info_list_lookup", libgio.}
proc add*(list: GFileAttributeInfoList;
                                     name: cstring;
                                     `type`: GFileAttributeType;
                                     flags: GFileAttributeInfoFlags) {.
    importc: "g_file_attribute_info_list_add", libgio.}

template g_file_enumerator*(o: expr): expr =
  (g_type_check_instance_cast(o, file_enumerator_get_type(), GFileEnumeratorObj))

template g_file_enumerator_class*(k: expr): expr =
  (g_type_check_class_cast(k, file_enumerator_get_type(), GFileEnumeratorClassObj))

template g_is_file_enumerator*(o: expr): expr =
  (g_type_check_instance_type(o, file_enumerator_get_type()))

template g_is_file_enumerator_class*(k: expr): expr =
  (g_type_check_class_type(k, file_enumerator_get_type()))

template g_file_enumerator_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, file_enumerator_get_type(), GFileEnumeratorClassObj))

type
  GFileEnumeratorPrivateObj = object
 
type
  GFileEnumerator* =  ptr GFileEnumeratorObj
  GFileEnumeratorPtr* = ptr GFileEnumeratorObj
  GFileEnumeratorObj*{.final.} = object of GObjectObj
    priv18: ptr GFileEnumeratorPrivateObj

type
  GFileEnumeratorClass* =  ptr GFileEnumeratorClassObj
  GFileEnumeratorClassPtr* = ptr GFileEnumeratorClassObj
  GFileEnumeratorClassObj*{.final.} = object of GObjectClassObj
    next_file*: proc (enumerator: GFileEnumerator;
                      cancellable: GCancellable; error: var GError): GFileInfo {.cdecl.}
    close_fn*: proc (enumerator: GFileEnumerator;
                     cancellable: GCancellable; error: var GError): gboolean {.cdecl.}
    next_files_async*: proc (enumerator: GFileEnumerator; num_files: cint;
                             io_priority: cint; cancellable: GCancellable;
                             callback: GAsyncReadyCallback;
                             user_data: gpointer) {.cdecl.}
    next_files_finish*: proc (enumerator: GFileEnumerator;
                              result: GAsyncResult; error: var GError): GList {.cdecl.}
    close_async*: proc (enumerator: GFileEnumerator; io_priority: cint;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    close_finish*: proc (enumerator: GFileEnumerator;
                         result: GAsyncResult; error: var GError): gboolean {.cdecl.}
    g_reserved131: proc () {.cdecl.}
    g_reserved132: proc () {.cdecl.}
    g_reserved133: proc () {.cdecl.}
    g_reserved134: proc () {.cdecl.}
    g_reserved135: proc () {.cdecl.}
    g_reserved136: proc () {.cdecl.}
    g_reserved137: proc () {.cdecl.}

proc g_file_enumerator_get_type*(): GType {.
    importc: "g_file_enumerator_get_type", libgio.}
proc next_file*(enumerator: GFileEnumerator;
                                  cancellable: GCancellable;
                                  error: var GError): GFileInfo {.
    importc: "g_file_enumerator_next_file", libgio.}
proc close*(enumerator: GFileEnumerator;
                              cancellable: GCancellable;
                              error: var GError): gboolean {.
    importc: "g_file_enumerator_close", libgio.}
proc next_files_async*(enumerator: GFileEnumerator;
    num_files: cint; io_priority: cint; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_enumerator_next_files_async", libgio.}
proc next_files_finish*(enumerator: GFileEnumerator;
    result: GAsyncResult; error: var GError): GList {.
    importc: "g_file_enumerator_next_files_finish", libgio.}
proc close_async*(enumerator: GFileEnumerator;
                                    io_priority: cint;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.
    importc: "g_file_enumerator_close_async", libgio.}
proc close_finish*(enumerator: GFileEnumerator;
                                     result: GAsyncResult;
                                     error: var GError): gboolean {.
    importc: "g_file_enumerator_close_finish", libgio.}
proc is_closed*(enumerator: GFileEnumerator): gboolean {.
    importc: "g_file_enumerator_is_closed", libgio.}
proc has_pending*(enumerator: GFileEnumerator): gboolean {.
    importc: "g_file_enumerator_has_pending", libgio.}
proc set_pending*(enumerator: GFileEnumerator;
                                    pending: gboolean) {.
    importc: "g_file_enumerator_set_pending", libgio.}
proc `pending=`*(enumerator: GFileEnumerator;
                                    pending: gboolean) {.
    importc: "g_file_enumerator_set_pending", libgio.}
proc get_container*(enumerator: GFileEnumerator): GFile {.
    importc: "g_file_enumerator_get_container", libgio.}
proc container*(enumerator: GFileEnumerator): GFile {.
    importc: "g_file_enumerator_get_container", libgio.}
proc get_child*(enumerator: GFileEnumerator;
                                  info: GFileInfo): GFile {.
    importc: "g_file_enumerator_get_child", libgio.}
proc child*(enumerator: GFileEnumerator;
                                  info: GFileInfo): GFile {.
    importc: "g_file_enumerator_get_child", libgio.}
type
  GFileIOStreamPrivateObj = object
 
type
  GFileIOStream* =  ptr GFileIOStreamObj
  GFileIOStreamPtr* = ptr GFileIOStreamObj
  GFileIOStreamObj*{.final.} = object of GIOStreamObj
    priv21: ptr GFileIOStreamPrivateObj
type
  GFileOutputStreamPrivateObj = object
 
type
  GFileOutputStream* =  ptr GFileOutputStreamObj
  GFileOutputStreamPtr* = ptr GFileOutputStreamObj
  GFileOutputStreamObj*{.final.} = object of GOutputStreamObj
    priv23: ptr GFileOutputStreamPrivateObj
type
  GFileMonitorPrivateObj = object
 
type
  GFileMonitor* =  ptr GFileMonitorObj
  GFileMonitorPtr* = ptr GFileMonitorObj
  GFileMonitorObj*{.final.} = object of GObjectObj
    priv22: ptr GFileMonitorPrivateObj
type
  GFileInputStreamPrivateObj = object
 
type
  GFileInputStream* =  ptr GFileInputStreamObj
  GFileInputStreamPtr* = ptr GFileInputStreamObj
  GFileInputStreamObj*{.final.} = object of GInputStreamObj
    priv19: ptr GFileInputStreamPrivateObj

template g_file*(obj: expr): expr =
  (g_type_check_instance_cast(obj, file_get_type(), GFileObj))

template g_is_file*(obj: expr): expr =
  (g_type_check_instance_type(obj, file_get_type()))

template g_file_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, file_get_type(), GFileIfaceObj))

type
  GFileIface* =  ptr GFileIfaceObj
  GFileIfacePtr* = ptr GFileIfaceObj
  GFileIfaceObj*{.final.} = object of GTypeInterfaceObj
    dup*: proc (file: GFile): GFile {.cdecl.}
    hash*: proc (file: GFile): guint {.cdecl.}
    equal*: proc (file1: GFile; file2: GFile): gboolean {.cdecl.}
    is_native*: proc (file: GFile): gboolean {.cdecl.}
    has_uri_scheme*: proc (file: GFile; uri_scheme: cstring): gboolean {.cdecl.}
    get_uri_scheme*: proc (file: GFile): cstring {.cdecl.}
    get_basename*: proc (file: GFile): cstring {.cdecl.}
    get_path*: proc (file: GFile): cstring {.cdecl.}
    get_uri*: proc (file: GFile): cstring {.cdecl.}
    get_parse_name*: proc (file: GFile): cstring {.cdecl.}
    get_parent*: proc (file: GFile): GFile {.cdecl.}
    prefix_matches*: proc (prefix: GFile; file: GFile): gboolean {.cdecl.}
    get_relative_path*: proc (parent: GFile; descendant: GFile): cstring {.cdecl.}
    resolve_relative_path*: proc (file: GFile; relative_path: cstring): GFile {.cdecl.}
    get_child_for_display_name*: proc (file: GFile; display_name: cstring;
        error: var GError): GFile {.cdecl.}
    enumerate_children*: proc (file: GFile; attributes: cstring;
                               flags: GFileQueryInfoFlags;
                               cancellable: GCancellable;
                               error: var GError): GFileEnumerator {.cdecl.}
    enumerate_children_async*: proc (file: GFile; attributes: cstring;
                                     flags: GFileQueryInfoFlags;
                                     io_priority: cint;
                                     cancellable: GCancellable;
                                     callback: GAsyncReadyCallback;
                                     user_data: gpointer) {.cdecl.}
    enumerate_children_finish*: proc (file: GFile; res: GAsyncResult;
                                      error: var GError): GFileEnumerator {.cdecl.}
    query_info*: proc (file: GFile; attributes: cstring;
                       flags: GFileQueryInfoFlags;
                       cancellable: GCancellable; error: var GError): GFileInfo {.cdecl.}
    query_info_async*: proc (file: GFile; attributes: cstring;
                             flags: GFileQueryInfoFlags; io_priority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback;
                             user_data: gpointer) {.cdecl.}
    query_info_finish*: proc (file: GFile; res: GAsyncResult;
                              error: var GError): GFileInfo {.cdecl.}
    query_filesystem_info*: proc (file: GFile; attributes: cstring;
                                  cancellable: GCancellable;
                                  error: var GError): GFileInfo {.cdecl.}
    query_filesystem_info_async*: proc (file: GFile; attributes: cstring;
        io_priority: cint; cancellable: GCancellable;
        callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    query_filesystem_info_finish*: proc (file: GFile;
        res: GAsyncResult; error: var GError): GFileInfo {.cdecl.}
    find_enclosing_mount*: proc (file: GFile;
                                 cancellable: GCancellable;
                                 error: var GError): GMount {.cdecl.}
    find_enclosing_mount_async*: proc (file: GFile; io_priority: cint;
        cancellable: GCancellable; callback: GAsyncReadyCallback;
        user_data: gpointer) {.cdecl.}
    find_enclosing_mount_finish*: proc (file: GFile;
        res: GAsyncResult; error: var GError): GMount {.cdecl.}
    set_display_name*: proc (file: GFile; display_name: cstring;
                             cancellable: GCancellable;
                             error: var GError): GFile {.cdecl.}
    set_display_name_async*: proc (file: GFile; display_name: cstring;
                                   io_priority: cint;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   user_data: gpointer) {.cdecl.}
    set_display_name_finish*: proc (file: GFile; res: GAsyncResult;
                                    error: var GError): GFile {.cdecl.}
    query_settable_attributes*: proc (file: GFile;
                                      cancellable: GCancellable;
                                      error: var GError): GFileAttributeInfoList {.cdecl.}
    query_settable_attributes_async: proc () {.cdecl.}
    query_settable_attributes_finish: proc () {.cdecl.}
    query_writable_namespaces*: proc (file: GFile;
                                      cancellable: GCancellable;
                                      error: var GError): GFileAttributeInfoList {.cdecl.}
    query_writable_namespaces_async: proc () {.cdecl.}
    query_writable_namespaces_finish: proc () {.cdecl.}
    set_attribute*: proc (file: GFile; attribute: cstring;
                          `type`: GFileAttributeType; value_p: gpointer;
                          flags: GFileQueryInfoFlags;
                          cancellable: GCancellable; error: var GError): gboolean {.cdecl.}
    set_attributes_from_info*: proc (file: GFile; info: GFileInfo;
                                     flags: GFileQueryInfoFlags;
                                     cancellable: GCancellable;
                                     error: var GError): gboolean {.cdecl.}
    set_attributes_async*: proc (file: GFile; info: GFileInfo;
                                 flags: GFileQueryInfoFlags;
                                 io_priority: cint;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.cdecl.}
    set_attributes_finish*: proc (file: GFile; result: GAsyncResult;
                                  info: var GFileInfo;
                                  error: var GError): gboolean {.cdecl.}
    read_fn*: proc (file: GFile; cancellable: GCancellable;
                    error: var GError): GFileInputStream {.cdecl.}
    read_async*: proc (file: GFile; io_priority: cint;
                       cancellable: GCancellable;
                       callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    read_finish*: proc (file: GFile; res: GAsyncResult;
                        error: var GError): GFileInputStream {.cdecl.}
    append_to*: proc (file: GFile; flags: GFileCreateFlags;
                      cancellable: GCancellable; error: var GError): GFileOutputStream {.cdecl.}
    append_to_async*: proc (file: GFile; flags: GFileCreateFlags;
                            io_priority: cint; cancellable: GCancellable;
                            callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    append_to_finish*: proc (file: GFile; res: GAsyncResult;
                             error: var GError): GFileOutputStream {.cdecl.}
    create*: proc (file: GFile; flags: GFileCreateFlags;
                   cancellable: GCancellable; error: var GError): GFileOutputStream {.cdecl.}
    create_async*: proc (file: GFile; flags: GFileCreateFlags;
                         io_priority: cint; cancellable: GCancellable;
                         callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    create_finish*: proc (file: GFile; res: GAsyncResult;
                          error: var GError): GFileOutputStream {.cdecl.}
    replace*: proc (file: GFile; etag: cstring; make_backup: gboolean;
                    flags: GFileCreateFlags; cancellable: GCancellable;
                    error: var GError): GFileOutputStream {.cdecl.}
    replace_async*: proc (file: GFile; etag: cstring;
                          make_backup: gboolean; flags: GFileCreateFlags;
                          io_priority: cint; cancellable: GCancellable;
                          callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    replace_finish*: proc (file: GFile; res: GAsyncResult;
                           error: var GError): GFileOutputStream {.cdecl.}
    delete_file*: proc (file: GFile; cancellable: GCancellable;
                        error: var GError): gboolean {.cdecl.}
    delete_file_async*: proc (file: GFile; io_priority: cint;
                              cancellable: GCancellable;
                              callback: GAsyncReadyCallback;
                              user_data: gpointer) {.cdecl.}
    delete_file_finish*: proc (file: GFile; result: GAsyncResult;
                               error: var GError): gboolean {.cdecl.}
    trash*: proc (file: GFile; cancellable: GCancellable;
                  error: var GError): gboolean {.cdecl.}
    trash_async*: proc (file: GFile; io_priority: cint;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    trash_finish*: proc (file: GFile; result: GAsyncResult;
                         error: var GError): gboolean {.cdecl.}
    make_directory*: proc (file: GFile; cancellable: GCancellable;
                           error: var GError): gboolean {.cdecl.}
    make_directory_async*: proc (file: GFile; io_priority: cint;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.cdecl.}
    make_directory_finish*: proc (file: GFile; result: GAsyncResult;
                                  error: var GError): gboolean {.cdecl.}
    make_symbolic_link*: proc (file: GFile; symlink_value: cstring;
                               cancellable: GCancellable;
                               error: var GError): gboolean {.cdecl.}
    make_symbolic_link_async: proc () {.cdecl.}
    make_symbolic_link_finish: proc () {.cdecl.}
    copy*: proc (source: GFile; destination: GFile;
                 flags: GFileCopyFlags; cancellable: GCancellable;
                 progress_callback: GFileProgressCallback;
                 progress_callback_data: gpointer; error: var GError): gboolean {.cdecl.}
    copy_async*: proc (source: GFile; destination: GFile;
                       flags: GFileCopyFlags; io_priority: cint;
                       cancellable: GCancellable;
                       progress_callback: GFileProgressCallback;
                       progress_callback_data: gpointer;
                       callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    copy_finish*: proc (file: GFile; res: GAsyncResult;
                        error: var GError): gboolean {.cdecl.}
    move*: proc (source: GFile; destination: GFile;
                 flags: GFileCopyFlags; cancellable: GCancellable;
                 progress_callback: GFileProgressCallback;
                 progress_callback_data: gpointer; error: var GError): gboolean {.cdecl.}
    move_async: proc () {.cdecl.}
    move_finish: proc () {.cdecl.}
    mount_mountable*: proc (file: GFile; flags: GMountMountFlags;
                            mount_operation: GMountOperation;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    mount_mountable_finish*: proc (file: GFile; result: GAsyncResult;
                                   error: var GError): GFile {.cdecl.}
    unmount_mountable*: proc (file: GFile; flags: GMountUnmountFlags;
                              cancellable: GCancellable;
                              callback: GAsyncReadyCallback;
                              user_data: gpointer) {.cdecl.}
    unmount_mountable_finish*: proc (file: GFile;
                                     result: GAsyncResult;
                                     error: var GError): gboolean {.cdecl.}
    eject_mountable*: proc (file: GFile; flags: GMountUnmountFlags;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    eject_mountable_finish*: proc (file: GFile; result: GAsyncResult;
                                   error: var GError): gboolean {.cdecl.}
    mount_enclosing_volume*: proc (location: GFile;
                                   flags: GMountMountFlags;
                                   mount_operation: GMountOperation;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   user_data: gpointer) {.cdecl.}
    mount_enclosing_volume_finish*: proc (location: GFile;
        result: GAsyncResult; error: var GError): gboolean {.cdecl.}
    monitor_dir*: proc (file: GFile; flags: GFileMonitorFlags;
                        cancellable: GCancellable; error: var GError): GFileMonitor {.cdecl.}
    monitor_file*: proc (file: GFile; flags: GFileMonitorFlags;
                         cancellable: GCancellable; error: var GError): GFileMonitor {.cdecl.}
    open_readwrite*: proc (file: GFile; cancellable: GCancellable;
                           error: var GError): GFileIOStream {.cdecl.}
    open_readwrite_async*: proc (file: GFile; io_priority: cint;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.cdecl.}
    open_readwrite_finish*: proc (file: GFile; res: GAsyncResult;
                                  error: var GError): GFileIOStream {.cdecl.}
    create_readwrite*: proc (file: GFile; flags: GFileCreateFlags;
                             cancellable: GCancellable;
                             error: var GError): GFileIOStream {.cdecl.}
    create_readwrite_async*: proc (file: GFile; flags: GFileCreateFlags;
                                   io_priority: cint;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   user_data: gpointer) {.cdecl.}
    create_readwrite_finish*: proc (file: GFile; res: GAsyncResult;
                                    error: var GError): GFileIOStream {.cdecl.}
    replace_readwrite*: proc (file: GFile; etag: cstring;
                              make_backup: gboolean; flags: GFileCreateFlags;
                              cancellable: GCancellable;
                              error: var GError): GFileIOStream {.cdecl.}
    replace_readwrite_async*: proc (file: GFile; etag: cstring;
                                    make_backup: gboolean;
                                    flags: GFileCreateFlags;
                                    io_priority: cint;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.cdecl.}
    replace_readwrite_finish*: proc (file: GFile; res: GAsyncResult;
                                     error: var GError): GFileIOStream {.cdecl.}
    start_mountable*: proc (file: GFile; flags: GDriveStartFlags;
                            start_operation: GMountOperation;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    start_mountable_finish*: proc (file: GFile; result: GAsyncResult;
                                   error: var GError): gboolean {.cdecl.}
    stop_mountable*: proc (file: GFile; flags: GMountUnmountFlags;
                           mount_operation: GMountOperation;
                           cancellable: GCancellable;
                           callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    stop_mountable_finish*: proc (file: GFile; result: GAsyncResult;
                                  error: var GError): gboolean {.cdecl.}
    supports_thread_contexts*: gboolean
    unmount_mountable_with_operation*: proc (file: GFile;
        flags: GMountUnmountFlags; mount_operation: GMountOperation;
        cancellable: GCancellable; callback: GAsyncReadyCallback;
        user_data: gpointer) {.cdecl.}
    unmount_mountable_with_operation_finish*: proc (file: GFile;
        result: GAsyncResult; error: var GError): gboolean {.cdecl.}
    eject_mountable_with_operation*: proc (file: GFile;
        flags: GMountUnmountFlags; mount_operation: GMountOperation;
        cancellable: GCancellable; callback: GAsyncReadyCallback;
        user_data: gpointer) {.cdecl.}
    eject_mountable_with_operation_finish*: proc (file: GFile;
        result: GAsyncResult; error: var GError): gboolean {.cdecl.}
    poll_mountable*: proc (file: GFile; cancellable: GCancellable;
                           callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    poll_mountable_finish*: proc (file: GFile; result: GAsyncResult;
                                  error: var GError): gboolean {.cdecl.}
    measure_disk_usage*: proc (file: GFile; flags: GFileMeasureFlags;
                               cancellable: GCancellable;
        progress_callback: GFileMeasureProgressCallback;
                               progress_data: gpointer;
                               disk_usage: var guint64; num_dirs: var guint64;
                               num_files: var guint64; error: var GError): gboolean {.cdecl.}
    measure_disk_usage_async*: proc (file: GFile;
                                     flags: GFileMeasureFlags;
                                     io_priority: gint;
                                     cancellable: GCancellable;
        progress_callback: GFileMeasureProgressCallback;
                                     progress_data: gpointer;
                                     callback: GAsyncReadyCallback;
                                     user_data: gpointer) {.cdecl.}
    measure_disk_usage_finish*: proc (file: GFile;
                                      result: GAsyncResult;
                                      disk_usage: var guint64;
                                      num_dirs: var guint64;
                                      num_files: var guint64;
                                      error: var GError): gboolean {.cdecl.}

proc g_file_get_type*(): GType {.importc: "g_file_get_type", libgio.}
proc g_file_new_for_path*(path: cstring): GFile {.
    importc: "g_file_new_for_path", libgio.}
proc g_file_new_for_uri*(uri: cstring): GFile {.
    importc: "g_file_new_for_uri", libgio.}
proc g_file_new_for_commandline_arg*(arg: cstring): GFile {.
    importc: "g_file_new_for_commandline_arg", libgio.}
proc g_file_new_for_commandline_arg_and_cwd*(arg: cstring; cwd: cstring): GFile {.
    importc: "g_file_new_for_commandline_arg_and_cwd", libgio.}
proc g_file_new_tmp*(tmpl: cstring; iostream: var GFileIOStream;
                     error: var GError): GFile {.
    importc: "g_file_new_tmp", libgio.}
proc g_file_parse_name*(parse_name: cstring): GFile {.
    importc: "g_file_parse_name", libgio.}
proc dup*(file: GFile): GFile {.importc: "g_file_dup",
    libgio.}
proc g_file_hash*(file: gconstpointer): guint {.importc: "g_file_hash",
    libgio.}
proc equal*(file1: GFile; file2: GFile): gboolean {.
    importc: "g_file_equal", libgio.}
proc get_basename*(file: GFile): cstring {.
    importc: "g_file_get_basename", libgio.}
proc basename*(file: GFile): cstring {.
    importc: "g_file_get_basename", libgio.}
proc get_path*(file: GFile): cstring {.importc: "g_file_get_path",
    libgio.}
proc path*(file: GFile): cstring {.importc: "g_file_get_path",
    libgio.}
proc get_uri*(file: GFile): cstring {.importc: "g_file_get_uri",
    libgio.}
proc uri*(file: GFile): cstring {.importc: "g_file_get_uri",
    libgio.}
proc get_parse_name*(file: GFile): cstring {.
    importc: "g_file_get_parse_name", libgio.}
proc parse_name*(file: GFile): cstring {.
    importc: "g_file_get_parse_name", libgio.}
proc get_parent*(file: GFile): GFile {.
    importc: "g_file_get_parent", libgio.}
proc parent*(file: GFile): GFile {.
    importc: "g_file_get_parent", libgio.}
proc has_parent*(file: GFile; parent: GFile): gboolean {.
    importc: "g_file_has_parent", libgio.}
proc get_child*(file: GFile; name: cstring): GFile {.
    importc: "g_file_get_child", libgio.}
proc child*(file: GFile; name: cstring): GFile {.
    importc: "g_file_get_child", libgio.}
proc get_child_for_display_name*(file: GFile;
    display_name: cstring; error: var GError): GFile {.
    importc: "g_file_get_child_for_display_name", libgio.}
proc child_for_display_name*(file: GFile;
    display_name: cstring; error: var GError): GFile {.
    importc: "g_file_get_child_for_display_name", libgio.}
proc has_prefix*(file: GFile; prefix: GFile): gboolean {.
    importc: "g_file_has_prefix", libgio.}
proc get_relative_path*(parent: GFile; descendant: GFile): cstring {.
    importc: "g_file_get_relative_path", libgio.}
proc relative_path*(parent: GFile; descendant: GFile): cstring {.
    importc: "g_file_get_relative_path", libgio.}
proc resolve_relative_path*(file: GFile; relative_path: cstring): GFile {.
    importc: "g_file_resolve_relative_path", libgio.}
proc is_native*(file: GFile): gboolean {.
    importc: "g_file_is_native", libgio.}
proc has_uri_scheme*(file: GFile; uri_scheme: cstring): gboolean {.
    importc: "g_file_has_uri_scheme", libgio.}
proc get_uri_scheme*(file: GFile): cstring {.
    importc: "g_file_get_uri_scheme", libgio.}
proc uri_scheme*(file: GFile): cstring {.
    importc: "g_file_get_uri_scheme", libgio.}
proc read*(file: GFile; cancellable: GCancellable;
                  error: var GError): GFileInputStream {.
    importc: "g_file_read", libgio.}
proc read_async*(file: GFile; io_priority: cint;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_read_async", libgio.}
proc read_finish*(file: GFile; res: GAsyncResult;
                         error: var GError): GFileInputStream {.
    importc: "g_file_read_finish", libgio.}
proc append_to*(file: GFile; flags: GFileCreateFlags;
                       cancellable: GCancellable; error: var GError): GFileOutputStream {.
    importc: "g_file_append_to", libgio.}
proc create*(file: GFile; flags: GFileCreateFlags;
                    cancellable: GCancellable; error: var GError): GFileOutputStream {.
    importc: "g_file_create", libgio.}
proc replace*(file: GFile; etag: cstring; make_backup: gboolean;
                     flags: GFileCreateFlags; cancellable: GCancellable;
                     error: var GError): GFileOutputStream {.
    importc: "g_file_replace", libgio.}
proc append_to_async*(file: GFile; flags: GFileCreateFlags;
                             io_priority: cint; cancellable: GCancellable;
                             callback: GAsyncReadyCallback;
                             user_data: gpointer) {.
    importc: "g_file_append_to_async", libgio.}
proc append_to_finish*(file: GFile; res: GAsyncResult;
                              error: var GError): GFileOutputStream {.
    importc: "g_file_append_to_finish", libgio.}
proc create_async*(file: GFile; flags: GFileCreateFlags;
                          io_priority: cint; cancellable: GCancellable;
                          callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_create_async", libgio.}
proc create_finish*(file: GFile; res: GAsyncResult;
                           error: var GError): GFileOutputStream {.
    importc: "g_file_create_finish", libgio.}
proc replace_async*(file: GFile; etag: cstring;
                           make_backup: gboolean; flags: GFileCreateFlags;
                           io_priority: cint; cancellable: GCancellable;
                           callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_replace_async", libgio.}
proc replace_finish*(file: GFile; res: GAsyncResult;
                            error: var GError): GFileOutputStream {.
    importc: "g_file_replace_finish", libgio.}
proc open_readwrite*(file: GFile; cancellable: GCancellable;
                            error: var GError): GFileIOStream {.
    importc: "g_file_open_readwrite", libgio.}
proc open_readwrite_async*(file: GFile; io_priority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  user_data: gpointer) {.
    importc: "g_file_open_readwrite_async", libgio.}
proc open_readwrite_finish*(file: GFile; res: GAsyncResult;
                                   error: var GError): GFileIOStream {.
    importc: "g_file_open_readwrite_finish", libgio.}
proc create_readwrite*(file: GFile; flags: GFileCreateFlags;
                              cancellable: GCancellable;
                              error: var GError): GFileIOStream {.
    importc: "g_file_create_readwrite", libgio.}
proc create_readwrite_async*(file: GFile; flags: GFileCreateFlags;
                                    io_priority: cint;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.
    importc: "g_file_create_readwrite_async", libgio.}
proc create_readwrite_finish*(file: GFile; res: GAsyncResult;
                                     error: var GError): GFileIOStream {.
    importc: "g_file_create_readwrite_finish", libgio.}
proc replace_readwrite*(file: GFile; etag: cstring;
                               make_backup: gboolean; flags: GFileCreateFlags;
                               cancellable: GCancellable;
                               error: var GError): GFileIOStream {.
    importc: "g_file_replace_readwrite", libgio.}
proc replace_readwrite_async*(file: GFile; etag: cstring;
                                     make_backup: gboolean;
                                     flags: GFileCreateFlags;
                                     io_priority: cint;
                                     cancellable: GCancellable;
                                     callback: GAsyncReadyCallback;
                                     user_data: gpointer) {.
    importc: "g_file_replace_readwrite_async", libgio.}
proc replace_readwrite_finish*(file: GFile; res: GAsyncResult;
                                      error: var GError): GFileIOStream {.
    importc: "g_file_replace_readwrite_finish", libgio.}
proc query_exists*(file: GFile; cancellable: GCancellable): gboolean {.
    importc: "g_file_query_exists", libgio.}
proc query_file_type*(file: GFile; flags: GFileQueryInfoFlags;
                             cancellable: GCancellable): GFileType {.
    importc: "g_file_query_file_type", libgio.}
proc query_info*(file: GFile; attributes: cstring;
                        flags: GFileQueryInfoFlags;
                        cancellable: GCancellable; error: var GError): GFileInfo {.
    importc: "g_file_query_info", libgio.}
proc query_info_async*(file: GFile; attributes: cstring;
                              flags: GFileQueryInfoFlags; io_priority: cint;
                              cancellable: GCancellable;
                              callback: GAsyncReadyCallback;
                              user_data: gpointer) {.
    importc: "g_file_query_info_async", libgio.}
proc query_info_finish*(file: GFile; res: GAsyncResult;
                               error: var GError): GFileInfo {.
    importc: "g_file_query_info_finish", libgio.}
proc query_filesystem_info*(file: GFile; attributes: cstring;
                                   cancellable: GCancellable;
                                   error: var GError): GFileInfo {.
    importc: "g_file_query_filesystem_info", libgio.}
proc query_filesystem_info_async*(file: GFile; attributes: cstring;
    io_priority: cint; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_query_filesystem_info_async", libgio.}
proc query_filesystem_info_finish*(file: GFile;
    res: GAsyncResult; error: var GError): GFileInfo {.
    importc: "g_file_query_filesystem_info_finish", libgio.}
proc find_enclosing_mount*(file: GFile;
                                  cancellable: GCancellable;
                                  error: var GError): GMount {.
    importc: "g_file_find_enclosing_mount", libgio.}
proc find_enclosing_mount_async*(file: GFile; io_priority: cint;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_file_find_enclosing_mount_async",
                           libgio.}
proc find_enclosing_mount_finish*(file: GFile;
    res: GAsyncResult; error: var GError): GMount {.
    importc: "g_file_find_enclosing_mount_finish", libgio.}
proc enumerate_children*(file: GFile; attributes: cstring;
                                flags: GFileQueryInfoFlags;
                                cancellable: GCancellable;
                                error: var GError): GFileEnumerator {.
    importc: "g_file_enumerate_children", libgio.}
proc enumerate_children_async*(file: GFile; attributes: cstring;
                                      flags: GFileQueryInfoFlags;
                                      io_priority: cint;
                                      cancellable: GCancellable;
                                      callback: GAsyncReadyCallback;
                                      user_data: gpointer) {.
    importc: "g_file_enumerate_children_async", libgio.}
proc enumerate_children_finish*(file: GFile; res: GAsyncResult;
    error: var GError): GFileEnumerator {.
    importc: "g_file_enumerate_children_finish", libgio.}
proc set_display_name*(file: GFile; display_name: cstring;
                              cancellable: GCancellable;
                              error: var GError): GFile {.
    importc: "g_file_set_display_name", libgio.}
proc set_display_name_async*(file: GFile; display_name: cstring;
                                    io_priority: cint;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.
    importc: "g_file_set_display_name_async", libgio.}
proc `display_name_async=`*(file: GFile; display_name: cstring;
                                    io_priority: cint;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.
    importc: "g_file_set_display_name_async", libgio.}
proc set_display_name_finish*(file: GFile; res: GAsyncResult;
                                     error: var GError): GFile {.
    importc: "g_file_set_display_name_finish", libgio.}
proc delete*(file: GFile; cancellable: GCancellable;
                    error: var GError): gboolean {.
    importc: "g_file_delete", libgio.}
proc delete_async*(file: GFile; io_priority: cint;
                          cancellable: GCancellable;
                          callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_delete_async", libgio.}
proc delete_finish*(file: GFile; result: GAsyncResult;
                           error: var GError): gboolean {.
    importc: "g_file_delete_finish", libgio.}
proc trash*(file: GFile; cancellable: GCancellable;
                   error: var GError): gboolean {.importc: "g_file_trash",
    libgio.}
proc trash_async*(file: GFile; io_priority: cint;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_trash_async", libgio.}
proc trash_finish*(file: GFile; result: GAsyncResult;
                          error: var GError): gboolean {.
    importc: "g_file_trash_finish", libgio.}
proc copy*(source: GFile; destination: GFile;
                  flags: GFileCopyFlags; cancellable: GCancellable;
                  progress_callback: GFileProgressCallback;
                  progress_callback_data: gpointer; error: var GError): gboolean {.
    importc: "g_file_copy", libgio.}
proc copy_async*(source: GFile; destination: GFile;
                        flags: GFileCopyFlags; io_priority: cint;
                        cancellable: GCancellable;
                        progress_callback: GFileProgressCallback;
                        progress_callback_data: gpointer;
                        callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_copy_async", libgio.}
proc copy_finish*(file: GFile; res: GAsyncResult;
                         error: var GError): gboolean {.
    importc: "g_file_copy_finish", libgio.}
proc move*(source: GFile; destination: GFile;
                  flags: GFileCopyFlags; cancellable: GCancellable;
                  progress_callback: GFileProgressCallback;
                  progress_callback_data: gpointer; error: var GError): gboolean {.
    importc: "g_file_move", libgio.}
proc make_directory*(file: GFile; cancellable: GCancellable;
                            error: var GError): gboolean {.
    importc: "g_file_make_directory", libgio.}
proc make_directory_async*(file: GFile; io_priority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  user_data: gpointer) {.
    importc: "g_file_make_directory_async", libgio.}
proc make_directory_finish*(file: GFile; result: GAsyncResult;
                                   error: var GError): gboolean {.
    importc: "g_file_make_directory_finish", libgio.}
proc make_directory_with_parents*(file: GFile;
    cancellable: GCancellable; error: var GError): gboolean {.
    importc: "g_file_make_directory_with_parents", libgio.}
proc make_symbolic_link*(file: GFile; symlink_value: cstring;
                                cancellable: GCancellable;
                                error: var GError): gboolean {.
    importc: "g_file_make_symbolic_link", libgio.}
proc query_settable_attributes*(file: GFile;
    cancellable: GCancellable; error: var GError): GFileAttributeInfoList {.
    importc: "g_file_query_settable_attributes", libgio.}
proc query_writable_namespaces*(file: GFile;
    cancellable: GCancellable; error: var GError): GFileAttributeInfoList {.
    importc: "g_file_query_writable_namespaces", libgio.}
proc set_attribute*(file: GFile; attribute: cstring;
                           `type`: GFileAttributeType; value_p: gpointer;
                           flags: GFileQueryInfoFlags;
                           cancellable: GCancellable;
                           error: var GError): gboolean {.
    importc: "g_file_set_attribute", libgio.}
proc set_attributes_from_info*(file: GFile; info: GFileInfo;
                                      flags: GFileQueryInfoFlags;
                                      cancellable: GCancellable;
                                      error: var GError): gboolean {.
    importc: "g_file_set_attributes_from_info", libgio.}
proc set_attributes_async*(file: GFile; info: GFileInfo;
                                  flags: GFileQueryInfoFlags;
                                  io_priority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  user_data: gpointer) {.
    importc: "g_file_set_attributes_async", libgio.}
proc `attributes_async=`*(file: GFile; info: GFileInfo;
                                  flags: GFileQueryInfoFlags;
                                  io_priority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  user_data: gpointer) {.
    importc: "g_file_set_attributes_async", libgio.}
proc set_attributes_finish*(file: GFile; result: GAsyncResult;
                                   info: var GFileInfo;
                                   error: var GError): gboolean {.
    importc: "g_file_set_attributes_finish", libgio.}
proc set_attribute_string*(file: GFile; attribute: cstring;
                                  value: cstring; flags: GFileQueryInfoFlags;
                                  cancellable: GCancellable;
                                  error: var GError): gboolean {.
    importc: "g_file_set_attribute_string", libgio.}
proc set_attribute_byte_string*(file: GFile; attribute: cstring;
    value: cstring; flags: GFileQueryInfoFlags; cancellable: GCancellable;
    error: var GError): gboolean {.
    importc: "g_file_set_attribute_byte_string", libgio.}
proc set_attribute_uint32*(file: GFile; attribute: cstring;
                                  value: guint32; flags: GFileQueryInfoFlags;
                                  cancellable: GCancellable;
                                  error: var GError): gboolean {.
    importc: "g_file_set_attribute_uint32", libgio.}
proc set_attribute_int32*(file: GFile; attribute: cstring;
                                 value: gint32; flags: GFileQueryInfoFlags;
                                 cancellable: GCancellable;
                                 error: var GError): gboolean {.
    importc: "g_file_set_attribute_int32", libgio.}
proc set_attribute_uint64*(file: GFile; attribute: cstring;
                                  value: guint64; flags: GFileQueryInfoFlags;
                                  cancellable: GCancellable;
                                  error: var GError): gboolean {.
    importc: "g_file_set_attribute_uint64", libgio.}
proc set_attribute_int64*(file: GFile; attribute: cstring;
                                 value: gint64; flags: GFileQueryInfoFlags;
                                 cancellable: GCancellable;
                                 error: var GError): gboolean {.
    importc: "g_file_set_attribute_int64", libgio.}
proc mount_enclosing_volume*(location: GFile;
                                    flags: GMountMountFlags;
                                    mount_operation: GMountOperation;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.
    importc: "g_file_mount_enclosing_volume", libgio.}
proc mount_enclosing_volume_finish*(location: GFile;
    result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_file_mount_enclosing_volume_finish", libgio.}
proc mount_mountable*(file: GFile; flags: GMountMountFlags;
                             mount_operation: GMountOperation;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback;
                             user_data: gpointer) {.
    importc: "g_file_mount_mountable", libgio.}
proc mount_mountable_finish*(file: GFile; result: GAsyncResult;
                                    error: var GError): GFile {.
    importc: "g_file_mount_mountable_finish", libgio.}
proc unmount_mountable*(file: GFile; flags: GMountUnmountFlags;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback;
                               user_data: gpointer) {.
    importc: "g_file_unmount_mountable", libgio.}
proc unmount_mountable_finish*(file: GFile;
                                      result: GAsyncResult;
                                      error: var GError): gboolean {.
    importc: "g_file_unmount_mountable_finish", libgio.}
proc unmount_mountable_with_operation*(file: GFile;
    flags: GMountUnmountFlags; mount_operation: GMountOperation;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_file_unmount_mountable_with_operation",
                           libgio.}
proc unmount_mountable_with_operation_finish*(file: GFile;
    result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_file_unmount_mountable_with_operation_finish", libgio.}
proc eject_mountable*(file: GFile; flags: GMountUnmountFlags;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback;
                             user_data: gpointer) {.
    importc: "g_file_eject_mountable", libgio.}
proc eject_mountable_finish*(file: GFile; result: GAsyncResult;
                                    error: var GError): gboolean {.
    importc: "g_file_eject_mountable_finish", libgio.}
proc eject_mountable_with_operation*(file: GFile;
    flags: GMountUnmountFlags; mount_operation: GMountOperation;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_file_eject_mountable_with_operation",
                           libgio.}
proc eject_mountable_with_operation_finish*(file: GFile;
    result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_file_eject_mountable_with_operation_finish", libgio.}
proc copy_attributes*(source: GFile; destination: GFile;
                             flags: GFileCopyFlags;
                             cancellable: GCancellable;
                             error: var GError): gboolean {.
    importc: "g_file_copy_attributes", libgio.}
proc monitor_directory*(file: GFile; flags: GFileMonitorFlags;
                               cancellable: GCancellable;
                               error: var GError): GFileMonitor {.
    importc: "g_file_monitor_directory", libgio.}
proc monitor_file*(file: GFile; flags: GFileMonitorFlags;
                          cancellable: GCancellable; error: var GError): GFileMonitor {.
    importc: "g_file_monitor_file", libgio.}
proc monitor*(file: GFile; flags: GFileMonitorFlags;
                     cancellable: GCancellable; error: var GError): GFileMonitor {.
    importc: "g_file_monitor", libgio.}
proc measure_disk_usage*(file: GFile; flags: GFileMeasureFlags;
                                cancellable: GCancellable;
    progress_callback: GFileMeasureProgressCallback; progress_data: gpointer;
                                disk_usage: var guint64;
                                num_dirs: var guint64; num_files: var guint64;
                                error: var GError): gboolean {.
    importc: "g_file_measure_disk_usage", libgio.}
proc measure_disk_usage_async*(file: GFile;
                                      flags: GFileMeasureFlags;
                                      io_priority: gint;
                                      cancellable: GCancellable;
    progress_callback: GFileMeasureProgressCallback; progress_data: gpointer;
                                      callback: GAsyncReadyCallback;
                                      user_data: gpointer) {.
    importc: "g_file_measure_disk_usage_async", libgio.}
proc measure_disk_usage_finish*(file: GFile;
    result: GAsyncResult; disk_usage: var guint64; num_dirs: var guint64;
    num_files: var guint64; error: var GError): gboolean {.
    importc: "g_file_measure_disk_usage_finish", libgio.}
proc start_mountable*(file: GFile; flags: GDriveStartFlags;
                             start_operation: GMountOperation;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback;
                             user_data: gpointer) {.
    importc: "g_file_start_mountable", libgio.}
proc start_mountable_finish*(file: GFile; result: GAsyncResult;
                                    error: var GError): gboolean {.
    importc: "g_file_start_mountable_finish", libgio.}
proc stop_mountable*(file: GFile; flags: GMountUnmountFlags;
                            mount_operation: GMountOperation;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_stop_mountable", libgio.}
proc stop_mountable_finish*(file: GFile; result: GAsyncResult;
                                   error: var GError): gboolean {.
    importc: "g_file_stop_mountable_finish", libgio.}
proc poll_mountable*(file: GFile; cancellable: GCancellable;
                            callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_poll_mountable", libgio.}
proc poll_mountable_finish*(file: GFile; result: GAsyncResult;
                                   error: var GError): gboolean {.
    importc: "g_file_poll_mountable_finish", libgio.}
proc query_default_handler*(file: GFile;
                                   cancellable: GCancellable;
                                   error: var GError): GAppInfo {.
    importc: "g_file_query_default_handler", libgio.}
proc load_contents*(file: GFile; cancellable: GCancellable;
                           contents: cstringArray; length: var gsize;
                           etag_out: cstringArray; error: var GError): gboolean {.
    importc: "g_file_load_contents", libgio.}
proc load_contents_async*(file: GFile;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.
    importc: "g_file_load_contents_async", libgio.}
proc load_contents_finish*(file: GFile; res: GAsyncResult;
                                  contents: cstringArray; length: var gsize;
                                  etag_out: cstringArray;
                                  error: var GError): gboolean {.
    importc: "g_file_load_contents_finish", libgio.}
proc load_partial_contents_async*(file: GFile;
    cancellable: GCancellable; read_more_callback: GFileReadMoreCallback;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_load_partial_contents_async", libgio.}
proc load_partial_contents_finish*(file: GFile;
    res: GAsyncResult; contents: cstringArray; length: var gsize;
    etag_out: cstringArray; error: var GError): gboolean {.
    importc: "g_file_load_partial_contents_finish", libgio.}
proc replace_contents*(file: GFile; contents: cstring;
                              length: gsize; etag: cstring;
                              make_backup: gboolean; flags: GFileCreateFlags;
                              new_etag: cstringArray;
                              cancellable: GCancellable;
                              error: var GError): gboolean {.
    importc: "g_file_replace_contents", libgio.}
proc replace_contents_async*(file: GFile; contents: cstring;
                                    length: gsize; etag: cstring;
                                    make_backup: gboolean;
                                    flags: GFileCreateFlags;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.
    importc: "g_file_replace_contents_async", libgio.}
proc replace_contents_bytes_async*(file: GFile;
    contents: glib.GBytes; etag: cstring; make_backup: gboolean;
    flags: GFileCreateFlags; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_replace_contents_bytes_async", libgio.}
proc replace_contents_finish*(file: GFile; res: GAsyncResult;
                                     new_etag: cstringArray;
                                     error: var GError): gboolean {.
    importc: "g_file_replace_contents_finish", libgio.}
proc supports_thread_contexts*(file: GFile): gboolean {.
    importc: "g_file_supports_thread_contexts", libgio.}

template g_file_icon*(o: expr): expr =
  (g_type_check_instance_cast(o, file_icon_get_type(), GFileIconObj))

template g_file_icon_class*(k: expr): expr =
  (g_type_check_class_cast(k, file_icon_get_type(), GFileIconClassObj))

template g_is_file_icon*(o: expr): expr =
  (g_type_check_instance_type(o, file_icon_get_type()))

template g_is_file_icon_class*(k: expr): expr =
  (g_type_check_class_type(k, file_icon_get_type()))

template g_file_icon_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, file_icon_get_type(), GFileIconClassObj))

type
  GFileIconClass* =  ptr GFileIconClassObj
  GFileIconClassPtr* = ptr GFileIconClassObj
  GFileIconClassObj* = object
 
proc g_file_icon_get_type*(): GType {.importc: "g_file_icon_get_type",
                                      libgio.}
proc icon_new*(file: GFile): GIcon {.
    importc: "g_file_icon_new", libgio.}
proc get_file*(icon: GFileIcon): GFile {.
    importc: "g_file_icon_get_file", libgio.}
proc file*(icon: GFileIcon): GFile {.
    importc: "g_file_icon_get_file", libgio.}

template g_file_info*(o: expr): expr =
  (g_type_check_instance_cast(o, file_info_get_type(), GFileInfoObj))

template g_file_info_class*(k: expr): expr =
  (g_type_check_class_cast(k, file_info_get_type(), GFileInfoClassObj))

template g_is_file_info*(o: expr): expr =
  (g_type_check_instance_type(o, file_info_get_type()))

template g_is_file_info_class*(k: expr): expr =
  (g_type_check_class_type(k, file_info_get_type()))

template g_file_info_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, file_info_get_type(), GFileInfoClassObj))

type
  GFileInfoClass* =  ptr GFileInfoClassObj
  GFileInfoClassPtr* = ptr GFileInfoClassObj
  GFileInfoClassObj* = object
 
const
  G_FILE_ATTRIBUTE_STANDARD_TYPE* = "standard::type"
const
  G_FILE_ATTRIBUTE_STANDARD_IS_HIDDEN* = "standard::is-hidden"
const
  G_FILE_ATTRIBUTE_STANDARD_IS_BACKUP* = "standard::is-backup"
const
  G_FILE_ATTRIBUTE_STANDARD_IS_SYMLINK* = "standard::is-symlink"
const
  G_FILE_ATTRIBUTE_STANDARD_IS_VIRTUAL* = "standard::is-virtual"
const
  G_FILE_ATTRIBUTE_STANDARD_NAME* = "standard::name"
const
  G_FILE_ATTRIBUTE_STANDARD_DISPLAY_NAME* = "standard::display-name"
const
  G_FILE_ATTRIBUTE_STANDARD_EDIT_NAME* = "standard::edit-name"
const
  G_FILE_ATTRIBUTE_STANDARD_COPY_NAME* = "standard::copy-name"
const
  G_FILE_ATTRIBUTE_STANDARD_DESCRIPTION* = "standard::description"
const
  G_FILE_ATTRIBUTE_STANDARD_ICON* = "standard::icon"
const
  G_FILE_ATTRIBUTE_STANDARD_SYMBOLIC_ICON* = "standard::symbolic-icon"
const
  G_FILE_ATTRIBUTE_STANDARD_CONTENT_TYPE* = "standard::content-type"
const
  G_FILE_ATTRIBUTE_STANDARD_FAST_CONTENT_TYPE* = "standard::fast-content-type"
const
  G_FILE_ATTRIBUTE_STANDARD_SIZE* = "standard::size"
const
  G_FILE_ATTRIBUTE_STANDARD_ALLOCATED_SIZE* = "standard::allocated-size"
const
  G_FILE_ATTRIBUTE_STANDARD_SYMLINK_TARGET* = "standard::symlink-target"
const
  G_FILE_ATTRIBUTE_STANDARD_TARGET_URI* = "standard::target-uri"
const
  G_FILE_ATTRIBUTE_STANDARD_SORT_ORDER* = "standard::sort-order"
const
  G_FILE_ATTRIBUTE_ETAG_VALUE* = "etag::value"
const
  G_FILE_ATTRIBUTE_ID_FILE* = "id::file"
const
  G_FILE_ATTRIBUTE_ID_FILESYSTEM* = "id::filesystem"
const
  G_FILE_ATTRIBUTE_ACCESS_CAN_READ* = "access::can-read"
const
  G_FILE_ATTRIBUTE_ACCESS_CAN_WRITE* = "access::can-write"
const
  G_FILE_ATTRIBUTE_ACCESS_CAN_EXECUTE* = "access::can-execute"
const
  G_FILE_ATTRIBUTE_ACCESS_CAN_DELETE* = "access::can-delete"
const
  G_FILE_ATTRIBUTE_ACCESS_CAN_TRASH* = "access::can-trash"
const
  G_FILE_ATTRIBUTE_ACCESS_CAN_RENAME* = "access::can-rename"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_MOUNT* = "mountable::can-mount"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_UNMOUNT* = "mountable::can-unmount"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_EJECT* = "mountable::can-eject"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_UNIX_DEVICE* = "mountable::unix-device"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_UNIX_DEVICE_FILE* = "mountable::unix-device-file"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_HAL_UDI* = "mountable::hal-udi"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_START* = "mountable::can-start"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_START_DEGRADED* = "mountable::can-start-degraded"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_STOP* = "mountable::can-stop"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_START_STOP_TYPE* = "mountable::start-stop-type"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_POLL* = "mountable::can-poll"
const
  G_FILE_ATTRIBUTE_MOUNTABLE_IS_MEDIA_CHECK_AUTOMATIC* = "mountable::is-media-check-automatic"
const
  G_FILE_ATTRIBUTE_TIME_MODIFIED* = "time::modified"
const
  G_FILE_ATTRIBUTE_TIME_MODIFIED_USEC* = "time::modified-usec"
const
  G_FILE_ATTRIBUTE_TIME_ACCESS* = "time::access"
const
  G_FILE_ATTRIBUTE_TIME_ACCESS_USEC* = "time::access-usec"
const
  G_FILE_ATTRIBUTE_TIME_CHANGED* = "time::changed"
const
  G_FILE_ATTRIBUTE_TIME_CHANGED_USEC* = "time::changed-usec"
const
  G_FILE_ATTRIBUTE_TIME_CREATED* = "time::created"
const
  G_FILE_ATTRIBUTE_TIME_CREATED_USEC* = "time::created-usec"
const
  G_FILE_ATTRIBUTE_UNIX_DEVICE* = "unix::device"
const
  G_FILE_ATTRIBUTE_UNIX_INODE* = "unix::inode"
const
  G_FILE_ATTRIBUTE_UNIX_MODE* = "unix::mode"
const
  G_FILE_ATTRIBUTE_UNIX_NLINK* = "unix::nlink"
const
  G_FILE_ATTRIBUTE_UNIX_UID* = "unix::uid"
const
  G_FILE_ATTRIBUTE_UNIX_GID* = "unix::gid"
const
  G_FILE_ATTRIBUTE_UNIX_RDEV* = "unix::rdev"
const
  G_FILE_ATTRIBUTE_UNIX_BLOCK_SIZE* = "unix::block-size"
const
  G_FILE_ATTRIBUTE_UNIX_BLOCKS* = "unix::blocks"
const
  G_FILE_ATTRIBUTE_UNIX_IS_MOUNTPOINT* = "unix::is-mountpoint"
const
  G_FILE_ATTRIBUTE_DOS_IS_ARCHIVE* = "dos::is-archive"
const
  G_FILE_ATTRIBUTE_DOS_IS_SYSTEM* = "dos::is-system"
const
  G_FILE_ATTRIBUTE_OWNER_USER* = "owner::user"
const
  G_FILE_ATTRIBUTE_OWNER_USER_REAL* = "owner::user-real"
const
  G_FILE_ATTRIBUTE_OWNER_GROUP* = "owner::group"
const
  G_FILE_ATTRIBUTE_THUMBNAIL_PATH* = "thumbnail::path"
const
  G_FILE_ATTRIBUTE_THUMBNAILING_FAILED* = "thumbnail::failed"
const
  G_FILE_ATTRIBUTE_THUMBNAIL_IS_VALID* = "thumbnail::is-valid"
const
  G_FILE_ATTRIBUTE_PREVIEW_ICON* = "preview::icon"
const
  G_FILE_ATTRIBUTE_FILESYSTEM_SIZE* = "filesystem::size"
const
  G_FILE_ATTRIBUTE_FILESYSTEM_FREE* = "filesystem::free"
const
  G_FILE_ATTRIBUTE_FILESYSTEM_USED* = "filesystem::used"
const
  G_FILE_ATTRIBUTE_FILESYSTEM_TYPE* = "filesystem::type"
const
  G_FILE_ATTRIBUTE_FILESYSTEM_READONLY* = "filesystem::readonly"
const
  G_FILE_ATTRIBUTE_FILESYSTEM_USE_PREVIEW* = "filesystem::use-preview"
const
  G_FILE_ATTRIBUTE_GVFS_BACKEND* = "gvfs::backend"
const
  G_FILE_ATTRIBUTE_SELINUX_CONTEXT* = "selinux::context"
const
  G_FILE_ATTRIBUTE_TRASH_ITEM_COUNT* = "trash::item-count"
const
  G_FILE_ATTRIBUTE_TRASH_ORIG_PATH* = "trash::orig-path"
const
  G_FILE_ATTRIBUTE_TRASH_DELETION_DATE* = "trash::deletion-date"
proc g_file_info_get_type*(): GType {.importc: "g_file_info_get_type",
                                      libgio.}
proc g_file_info_new*(): GFileInfo {.importc: "g_file_info_new",
    libgio.}
proc dup*(other: GFileInfo): GFileInfo {.
    importc: "g_file_info_dup", libgio.}
proc copy_into*(src_info: GFileInfo; dest_info: GFileInfo) {.
    importc: "g_file_info_copy_into", libgio.}
proc has_attribute*(info: GFileInfo; attribute: cstring): gboolean {.
    importc: "g_file_info_has_attribute", libgio.}
proc has_namespace*(info: GFileInfo; name_space: cstring): gboolean {.
    importc: "g_file_info_has_namespace", libgio.}
proc list_attributes*(info: GFileInfo; name_space: cstring): cstringArray {.
    importc: "g_file_info_list_attributes", libgio.}
proc get_attribute_data*(info: GFileInfo; attribute: cstring;
                                     `type`: ptr GFileAttributeType;
                                     value_pp: var gpointer;
                                     status: ptr GFileAttributeStatus): gboolean {.
    importc: "g_file_info_get_attribute_data", libgio.}
proc attribute_data*(info: GFileInfo; attribute: cstring;
                                     `type`: ptr GFileAttributeType;
                                     value_pp: var gpointer;
                                     status: ptr GFileAttributeStatus): gboolean {.
    importc: "g_file_info_get_attribute_data", libgio.}
proc get_attribute_type*(info: GFileInfo; attribute: cstring): GFileAttributeType {.
    importc: "g_file_info_get_attribute_type", libgio.}
proc attribute_type*(info: GFileInfo; attribute: cstring): GFileAttributeType {.
    importc: "g_file_info_get_attribute_type", libgio.}
proc remove_attribute*(info: GFileInfo; attribute: cstring) {.
    importc: "g_file_info_remove_attribute", libgio.}
proc get_attribute_status*(info: GFileInfo; attribute: cstring): GFileAttributeStatus {.
    importc: "g_file_info_get_attribute_status", libgio.}
proc attribute_status*(info: GFileInfo; attribute: cstring): GFileAttributeStatus {.
    importc: "g_file_info_get_attribute_status", libgio.}
proc set_attribute_status*(info: GFileInfo;
    attribute: cstring; status: GFileAttributeStatus): gboolean {.
    importc: "g_file_info_set_attribute_status", libgio.}
proc get_attribute_as_string*(info: GFileInfo;
    attribute: cstring): cstring {.importc: "g_file_info_get_attribute_as_string",
                                   libgio.}
proc attribute_as_string*(info: GFileInfo;
    attribute: cstring): cstring {.importc: "g_file_info_get_attribute_as_string",
                                   libgio.}
proc get_attribute_string*(info: GFileInfo; attribute: cstring): cstring {.
    importc: "g_file_info_get_attribute_string", libgio.}
proc attribute_string*(info: GFileInfo; attribute: cstring): cstring {.
    importc: "g_file_info_get_attribute_string", libgio.}
proc get_attribute_byte_string*(info: GFileInfo;
    attribute: cstring): cstring {.importc: "g_file_info_get_attribute_byte_string",
                                   libgio.}
proc attribute_byte_string*(info: GFileInfo;
    attribute: cstring): cstring {.importc: "g_file_info_get_attribute_byte_string",
                                   libgio.}
proc get_attribute_boolean*(info: GFileInfo;
    attribute: cstring): gboolean {.importc: "g_file_info_get_attribute_boolean",
                                    libgio.}
proc attribute_boolean*(info: GFileInfo;
    attribute: cstring): gboolean {.importc: "g_file_info_get_attribute_boolean",
                                    libgio.}
proc get_attribute_uint32*(info: GFileInfo; attribute: cstring): guint32 {.
    importc: "g_file_info_get_attribute_uint32", libgio.}
proc attribute_uint32*(info: GFileInfo; attribute: cstring): guint32 {.
    importc: "g_file_info_get_attribute_uint32", libgio.}
proc get_attribute_int32*(info: GFileInfo; attribute: cstring): gint32 {.
    importc: "g_file_info_get_attribute_int32", libgio.}
proc attribute_int32*(info: GFileInfo; attribute: cstring): gint32 {.
    importc: "g_file_info_get_attribute_int32", libgio.}
proc get_attribute_uint64*(info: GFileInfo; attribute: cstring): guint64 {.
    importc: "g_file_info_get_attribute_uint64", libgio.}
proc attribute_uint64*(info: GFileInfo; attribute: cstring): guint64 {.
    importc: "g_file_info_get_attribute_uint64", libgio.}
proc get_attribute_int64*(info: GFileInfo; attribute: cstring): gint64 {.
    importc: "g_file_info_get_attribute_int64", libgio.}
proc attribute_int64*(info: GFileInfo; attribute: cstring): gint64 {.
    importc: "g_file_info_get_attribute_int64", libgio.}
proc get_attribute_object*(info: GFileInfo; attribute: cstring): GObject {.
    importc: "g_file_info_get_attribute_object", libgio.}
proc attribute_object*(info: GFileInfo; attribute: cstring): GObject {.
    importc: "g_file_info_get_attribute_object", libgio.}
proc get_attribute_stringv*(info: GFileInfo;
    attribute: cstring): cstringArray {.
    importc: "g_file_info_get_attribute_stringv", libgio.}
proc attribute_stringv*(info: GFileInfo;
    attribute: cstring): cstringArray {.
    importc: "g_file_info_get_attribute_stringv", libgio.}
proc set_attribute*(info: GFileInfo; attribute: cstring;
                                `type`: GFileAttributeType; value_p: gpointer) {.
    importc: "g_file_info_set_attribute", libgio.}
proc `attribute=`*(info: GFileInfo; attribute: cstring;
                                `type`: GFileAttributeType; value_p: gpointer) {.
    importc: "g_file_info_set_attribute", libgio.}
proc set_attribute_string*(info: GFileInfo;
    attribute: cstring; attr_value: cstring) {.
    importc: "g_file_info_set_attribute_string", libgio.}
proc `attribute_string=`*(info: GFileInfo;
    attribute: cstring; attr_value: cstring) {.
    importc: "g_file_info_set_attribute_string", libgio.}
proc set_attribute_byte_string*(info: GFileInfo;
    attribute: cstring; attr_value: cstring) {.
    importc: "g_file_info_set_attribute_byte_string", libgio.}
proc `attribute_byte_string=`*(info: GFileInfo;
    attribute: cstring; attr_value: cstring) {.
    importc: "g_file_info_set_attribute_byte_string", libgio.}
proc set_attribute_boolean*(info: GFileInfo;
    attribute: cstring; attr_value: gboolean) {.
    importc: "g_file_info_set_attribute_boolean", libgio.}
proc `attribute_boolean=`*(info: GFileInfo;
    attribute: cstring; attr_value: gboolean) {.
    importc: "g_file_info_set_attribute_boolean", libgio.}
proc set_attribute_uint32*(info: GFileInfo;
    attribute: cstring; attr_value: guint32) {.
    importc: "g_file_info_set_attribute_uint32", libgio.}
proc `attribute_uint32=`*(info: GFileInfo;
    attribute: cstring; attr_value: guint32) {.
    importc: "g_file_info_set_attribute_uint32", libgio.}
proc set_attribute_int32*(info: GFileInfo; attribute: cstring;
                                      attr_value: gint32) {.
    importc: "g_file_info_set_attribute_int32", libgio.}
proc `attribute_int32=`*(info: GFileInfo; attribute: cstring;
                                      attr_value: gint32) {.
    importc: "g_file_info_set_attribute_int32", libgio.}
proc set_attribute_uint64*(info: GFileInfo;
    attribute: cstring; attr_value: guint64) {.
    importc: "g_file_info_set_attribute_uint64", libgio.}
proc `attribute_uint64=`*(info: GFileInfo;
    attribute: cstring; attr_value: guint64) {.
    importc: "g_file_info_set_attribute_uint64", libgio.}
proc set_attribute_int64*(info: GFileInfo; attribute: cstring;
                                      attr_value: gint64) {.
    importc: "g_file_info_set_attribute_int64", libgio.}
proc `attribute_int64=`*(info: GFileInfo; attribute: cstring;
                                      attr_value: gint64) {.
    importc: "g_file_info_set_attribute_int64", libgio.}
proc set_attribute_object*(info: GFileInfo;
    attribute: cstring; attr_value: GObject) {.
    importc: "g_file_info_set_attribute_object", libgio.}
proc `attribute_object=`*(info: GFileInfo;
    attribute: cstring; attr_value: GObject) {.
    importc: "g_file_info_set_attribute_object", libgio.}
proc set_attribute_stringv*(info: GFileInfo;
    attribute: cstring; attr_value: cstringArray) {.
    importc: "g_file_info_set_attribute_stringv", libgio.}
proc `attribute_stringv=`*(info: GFileInfo;
    attribute: cstring; attr_value: cstringArray) {.
    importc: "g_file_info_set_attribute_stringv", libgio.}
proc clear_status*(info: GFileInfo) {.
    importc: "g_file_info_clear_status", libgio.}
proc get_deletion_date*(info: GFileInfo): glib.GDateTime {.
    importc: "g_file_info_get_deletion_date", libgio.}
proc deletion_date*(info: GFileInfo): glib.GDateTime {.
    importc: "g_file_info_get_deletion_date", libgio.}
proc get_file_type*(info: GFileInfo): GFileType {.
    importc: "g_file_info_get_file_type", libgio.}
proc file_type*(info: GFileInfo): GFileType {.
    importc: "g_file_info_get_file_type", libgio.}
proc get_is_hidden*(info: GFileInfo): gboolean {.
    importc: "g_file_info_get_is_hidden", libgio.}
proc is_hidden*(info: GFileInfo): gboolean {.
    importc: "g_file_info_get_is_hidden", libgio.}
proc get_is_backup*(info: GFileInfo): gboolean {.
    importc: "g_file_info_get_is_backup", libgio.}
proc is_backup*(info: GFileInfo): gboolean {.
    importc: "g_file_info_get_is_backup", libgio.}
proc get_is_symlink*(info: GFileInfo): gboolean {.
    importc: "g_file_info_get_is_symlink", libgio.}
proc is_symlink*(info: GFileInfo): gboolean {.
    importc: "g_file_info_get_is_symlink", libgio.}
proc get_name*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_name", libgio.}
proc name*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_name", libgio.}
proc get_display_name*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_display_name", libgio.}
proc display_name*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_display_name", libgio.}
proc get_edit_name*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_edit_name", libgio.}
proc edit_name*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_edit_name", libgio.}
proc get_icon*(info: GFileInfo): GIcon {.
    importc: "g_file_info_get_icon", libgio.}
proc icon*(info: GFileInfo): GIcon {.
    importc: "g_file_info_get_icon", libgio.}
proc get_symbolic_icon*(info: GFileInfo): GIcon {.
    importc: "g_file_info_get_symbolic_icon", libgio.}
proc symbolic_icon*(info: GFileInfo): GIcon {.
    importc: "g_file_info_get_symbolic_icon", libgio.}
proc get_content_type*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_content_type", libgio.}
proc content_type*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_content_type", libgio.}
proc get_size*(info: GFileInfo): goffset {.
    importc: "g_file_info_get_size", libgio.}
proc size*(info: GFileInfo): goffset {.
    importc: "g_file_info_get_size", libgio.}
proc get_modification_time*(info: GFileInfo;
    result: glib.GTimeVal) {.importc: "g_file_info_get_modification_time",
                            libgio.}
proc get_symlink_target*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_symlink_target", libgio.}
proc symlink_target*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_symlink_target", libgio.}
proc get_etag*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_etag", libgio.}
proc etag*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_etag", libgio.}
proc get_sort_order*(info: GFileInfo): gint32 {.
    importc: "g_file_info_get_sort_order", libgio.}
proc sort_order*(info: GFileInfo): gint32 {.
    importc: "g_file_info_get_sort_order", libgio.}
proc set_attribute_mask*(info: GFileInfo;
                                     mask: GFileAttributeMatcher) {.
    importc: "g_file_info_set_attribute_mask", libgio.}
proc `attribute_mask=`*(info: GFileInfo;
                                     mask: GFileAttributeMatcher) {.
    importc: "g_file_info_set_attribute_mask", libgio.}
proc unset_attribute_mask*(info: GFileInfo) {.
    importc: "g_file_info_unset_attribute_mask", libgio.}
proc set_file_type*(info: GFileInfo; `type`: GFileType) {.
    importc: "g_file_info_set_file_type", libgio.}
proc `file_type=`*(info: GFileInfo; `type`: GFileType) {.
    importc: "g_file_info_set_file_type", libgio.}
proc set_is_hidden*(info: GFileInfo; is_hidden: gboolean) {.
    importc: "g_file_info_set_is_hidden", libgio.}
proc `is_hidden=`*(info: GFileInfo; is_hidden: gboolean) {.
    importc: "g_file_info_set_is_hidden", libgio.}
proc set_is_symlink*(info: GFileInfo; is_symlink: gboolean) {.
    importc: "g_file_info_set_is_symlink", libgio.}
proc `is_symlink=`*(info: GFileInfo; is_symlink: gboolean) {.
    importc: "g_file_info_set_is_symlink", libgio.}
proc set_name*(info: GFileInfo; name: cstring) {.
    importc: "g_file_info_set_name", libgio.}
proc `name=`*(info: GFileInfo; name: cstring) {.
    importc: "g_file_info_set_name", libgio.}
proc set_display_name*(info: GFileInfo; display_name: cstring) {.
    importc: "g_file_info_set_display_name", libgio.}
proc `display_name=`*(info: GFileInfo; display_name: cstring) {.
    importc: "g_file_info_set_display_name", libgio.}
proc set_edit_name*(info: GFileInfo; edit_name: cstring) {.
    importc: "g_file_info_set_edit_name", libgio.}
proc `edit_name=`*(info: GFileInfo; edit_name: cstring) {.
    importc: "g_file_info_set_edit_name", libgio.}
proc set_icon*(info: GFileInfo; icon: GIcon) {.
    importc: "g_file_info_set_icon", libgio.}
proc `icon=`*(info: GFileInfo; icon: GIcon) {.
    importc: "g_file_info_set_icon", libgio.}
proc set_symbolic_icon*(info: GFileInfo; icon: GIcon) {.
    importc: "g_file_info_set_symbolic_icon", libgio.}
proc `symbolic_icon=`*(info: GFileInfo; icon: GIcon) {.
    importc: "g_file_info_set_symbolic_icon", libgio.}
proc set_content_type*(info: GFileInfo; content_type: cstring) {.
    importc: "g_file_info_set_content_type", libgio.}
proc `content_type=`*(info: GFileInfo; content_type: cstring) {.
    importc: "g_file_info_set_content_type", libgio.}
proc set_size*(info: GFileInfo; size: goffset) {.
    importc: "g_file_info_set_size", libgio.}
proc `size=`*(info: GFileInfo; size: goffset) {.
    importc: "g_file_info_set_size", libgio.}
proc set_modification_time*(info: GFileInfo;
    mtime: glib.GTimeVal) {.importc: "g_file_info_set_modification_time",
                           libgio.}
proc `modification_time=`*(info: GFileInfo;
    mtime: glib.GTimeVal) {.importc: "g_file_info_set_modification_time",
                           libgio.}
proc set_symlink_target*(info: GFileInfo;
                                     symlink_target: cstring) {.
    importc: "g_file_info_set_symlink_target", libgio.}
proc `symlink_target=`*(info: GFileInfo;
                                     symlink_target: cstring) {.
    importc: "g_file_info_set_symlink_target", libgio.}
proc set_sort_order*(info: GFileInfo; sort_order: gint32) {.
    importc: "g_file_info_set_sort_order", libgio.}
proc `sort_order=`*(info: GFileInfo; sort_order: gint32) {.
    importc: "g_file_info_set_sort_order", libgio.}
proc g_file_attribute_matcher_get_type*(): GType {.
    importc: "g_file_attribute_matcher_get_type", libgio.}
proc g_file_attribute_matcher_new*(attributes: cstring): GFileAttributeMatcher {.
    importc: "g_file_attribute_matcher_new", libgio.}
proc `ref`*(matcher: GFileAttributeMatcher): GFileAttributeMatcher {.
    importc: "g_file_attribute_matcher_ref", libgio.}
proc unref*(matcher: GFileAttributeMatcher) {.
    importc: "g_file_attribute_matcher_unref", libgio.}
proc subtract*(matcher: GFileAttributeMatcher;
    subtract: GFileAttributeMatcher): GFileAttributeMatcher {.
    importc: "g_file_attribute_matcher_subtract", libgio.}
proc matches*(matcher: GFileAttributeMatcher;
    attribute: cstring): gboolean {.importc: "g_file_attribute_matcher_matches",
                                    libgio.}
proc matches_only*(
    matcher: GFileAttributeMatcher; attribute: cstring): gboolean {.
    importc: "g_file_attribute_matcher_matches_only", libgio.}
proc enumerate_namespace*(
    matcher: GFileAttributeMatcher; ns: cstring): gboolean {.
    importc: "g_file_attribute_matcher_enumerate_namespace", libgio.}
proc enumerate_next*(
    matcher: GFileAttributeMatcher): cstring {.
    importc: "g_file_attribute_matcher_enumerate_next", libgio.}
proc to_string*(matcher: GFileAttributeMatcher): cstring {.
    importc: "g_file_attribute_matcher_to_string", libgio.}

template g_file_input_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, file_input_stream_get_type(), GFileInputStreamObj))

template g_file_input_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, file_input_stream_get_type(),
                           GFileInputStreamClassObj))

template g_is_file_input_stream*(o: expr): expr =
  (g_type_check_instance_type(o, file_input_stream_get_type()))

template g_is_file_input_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, file_input_stream_get_type()))

template g_file_input_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, file_input_stream_get_type(),
                             GFileInputStreamClassObj))

type
  GFileInputStreamClass* =  ptr GFileInputStreamClassObj
  GFileInputStreamClassPtr* = ptr GFileInputStreamClassObj
  GFileInputStreamClassObj*{.final.} = object of GInputStreamClassObj
    tell*: proc (stream: GFileInputStream): goffset {.cdecl.}
    can_seek*: proc (stream: GFileInputStream): gboolean {.cdecl.}
    seek*: proc (stream: GFileInputStream; offset: goffset;
                 `type`: GSeekType; cancellable: GCancellable;
                 error: var GError): gboolean {.cdecl.}
    query_info*: proc (stream: GFileInputStream; attributes: cstring;
                       cancellable: GCancellable; error: var GError): GFileInfo {.cdecl.}
    query_info_async*: proc (stream: GFileInputStream;
                             attributes: cstring; io_priority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback;
                             user_data: gpointer) {.cdecl.}
    query_info_finish*: proc (stream: GFileInputStream;
                              result: GAsyncResult; error: var GError): GFileInfo {.cdecl.}
    g_reserved141: proc () {.cdecl.}
    g_reserved142: proc () {.cdecl.}
    g_reserved143: proc () {.cdecl.}
    g_reserved144: proc () {.cdecl.}
    g_reserved145: proc () {.cdecl.}

proc g_file_input_stream_get_type*(): GType {.
    importc: "g_file_input_stream_get_type", libgio.}
proc query_info*(stream: GFileInputStream;
                                     attributes: cstring;
                                     cancellable: GCancellable;
                                     error: var GError): GFileInfo {.
    importc: "g_file_input_stream_query_info", libgio.}
proc query_info_async*(stream: GFileInputStream;
    attributes: cstring; io_priority: cint; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_input_stream_query_info_async", libgio.}
proc query_info_finish*(stream: GFileInputStream;
    result: GAsyncResult; error: var GError): GFileInfo {.
    importc: "g_file_input_stream_query_info_finish", libgio.}

proc g_io_error_quark*(): GQuark {.importc: "g_io_error_quark", libgio.}
proc g_io_error_from_errno*(err_no: gint): GIOErrorEnum {.
    importc: "g_io_error_from_errno", libgio.}
when defined(windows):
  proc g_io_error_from_win32_error*(error_code: gint): GIOErrorEnum {.
      importc: "g_io_error_from_win32_error", libgio.}

template g_io_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, io_stream_get_type(), GIOStreamObj))

template g_io_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, io_stream_get_type(), GIOStreamClassObj))

template g_is_io_stream*(o: expr): expr =
  (g_type_check_instance_type(o, io_stream_get_type()))

template g_is_io_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, io_stream_get_type()))

template g_io_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, io_stream_get_type(), GIOStreamClassObj))

type
  GIOStreamClass* =  ptr GIOStreamClassObj
  GIOStreamClassPtr* = ptr GIOStreamClassObj
  GIOStreamClassObj* = object of GObjectClassObj
    get_input_stream*: proc (stream: GIOStream): GInputStream {.cdecl.}
    get_output_stream*: proc (stream: GIOStream): GOutputStream {.cdecl.}
    close_fn*: proc (stream: GIOStream; cancellable: GCancellable;
                     error: var GError): gboolean {.cdecl.}
    close_async*: proc (stream: GIOStream; io_priority: cint;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    close_finish*: proc (stream: GIOStream; result: GAsyncResult;
                         error: var GError): gboolean {.cdecl.}
    g_reserved151: proc () {.cdecl.}
    g_reserved152: proc () {.cdecl.}
    g_reserved153: proc () {.cdecl.}
    g_reserved154: proc () {.cdecl.}
    g_reserved155: proc () {.cdecl.}
    g_reserved156: proc () {.cdecl.}
    g_reserved157: proc () {.cdecl.}
    g_reserved158: proc () {.cdecl.}
    g_reserved159: proc () {.cdecl.}
    g_reserved10: proc () {.cdecl.}

proc g_io_stream_get_type*(): GType {.importc: "g_io_stream_get_type",
                                      libgio.}
proc get_input_stream*(stream: GIOStream): GInputStream {.
    importc: "g_io_stream_get_input_stream", libgio.}
proc input_stream*(stream: GIOStream): GInputStream {.
    importc: "g_io_stream_get_input_stream", libgio.}
proc get_output_stream*(stream: GIOStream): GOutputStream {.
    importc: "g_io_stream_get_output_stream", libgio.}
proc output_stream*(stream: GIOStream): GOutputStream {.
    importc: "g_io_stream_get_output_stream", libgio.}
proc splice_async*(stream1: GIOStream; stream2: GIOStream;
                               flags: GIOStreamSpliceFlags; io_priority: cint;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback;
                               user_data: gpointer) {.
    importc: "g_io_stream_splice_async", libgio.}
proc g_io_stream_splice_finish*(result: GAsyncResult;
                                error: var GError): gboolean {.
    importc: "g_io_stream_splice_finish", libgio.}
proc close*(stream: GIOStream; cancellable: GCancellable;
                        error: var GError): gboolean {.
    importc: "g_io_stream_close", libgio.}
proc close_async*(stream: GIOStream; io_priority: cint;
                              cancellable: GCancellable;
                              callback: GAsyncReadyCallback;
                              user_data: gpointer) {.
    importc: "g_io_stream_close_async", libgio.}
proc close_finish*(stream: GIOStream;
                               result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_io_stream_close_finish", libgio.}
proc is_closed*(stream: GIOStream): gboolean {.
    importc: "g_io_stream_is_closed", libgio.}
proc has_pending*(stream: GIOStream): gboolean {.
    importc: "g_io_stream_has_pending", libgio.}
proc set_pending*(stream: GIOStream; error: var GError): gboolean {.
    importc: "g_io_stream_set_pending", libgio.}
proc clear_pending*(stream: GIOStream) {.
    importc: "g_io_stream_clear_pending", libgio.}

template g_file_io_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, file_io_stream_get_type(), GFileIOStreamObj))

template g_file_io_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, file_io_stream_get_type(), GFileIOStreamClassObj))

template g_is_file_io_stream*(o: expr): expr =
  (g_type_check_instance_type(o, file_io_stream_get_type()))

template g_is_file_io_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, file_io_stream_get_type()))

template g_file_io_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, file_io_stream_get_type(), GFileIOStreamClassObj))

type
  GFileIOStreamClass* =  ptr GFileIOStreamClassObj
  GFileIOStreamClassPtr* = ptr GFileIOStreamClassObj
  GFileIOStreamClassObj*{.final.} = object of GIOStreamClassObj
    tell*: proc (stream: GFileIOStream): goffset {.cdecl.}
    can_seek*: proc (stream: GFileIOStream): gboolean {.cdecl.}
    seek*: proc (stream: GFileIOStream; offset: goffset;
                 `type`: GSeekType; cancellable: GCancellable;
                 error: var GError): gboolean {.cdecl.}
    can_truncate*: proc (stream: GFileIOStream): gboolean {.cdecl.}
    truncate_fn*: proc (stream: GFileIOStream; size: goffset;
                        cancellable: GCancellable; error: var GError): gboolean {.cdecl.}
    query_info*: proc (stream: GFileIOStream; attributes: cstring;
                       cancellable: GCancellable; error: var GError): GFileInfo {.cdecl.}
    query_info_async*: proc (stream: GFileIOStream; attributes: cstring;
                             io_priority: cint; cancellable: GCancellable;
                             callback: GAsyncReadyCallback;
                             user_data: gpointer) {.cdecl.}
    query_info_finish*: proc (stream: GFileIOStream;
                              result: GAsyncResult; error: var GError): GFileInfo {.cdecl.}
    get_etag*: proc (stream: GFileIOStream): cstring {.cdecl.}
    g_reserved161: proc () {.cdecl.}
    g_reserved162: proc () {.cdecl.}
    g_reserved163: proc () {.cdecl.}
    g_reserved164: proc () {.cdecl.}
    g_reserved165: proc () {.cdecl.}

proc g_file_io_stream_get_type*(): GType {.
    importc: "g_file_io_stream_get_type", libgio.}
proc query_info*(stream: GFileIOStream;
                                  attributes: cstring;
                                  cancellable: GCancellable;
                                  error: var GError): GFileInfo {.
    importc: "g_file_io_stream_query_info", libgio.}
proc query_info_async*(stream: GFileIOStream;
    attributes: cstring; io_priority: cint; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_io_stream_query_info_async", libgio.}
proc query_info_finish*(stream: GFileIOStream;
    result: GAsyncResult; error: var GError): GFileInfo {.
    importc: "g_file_io_stream_query_info_finish", libgio.}
proc get_etag*(stream: GFileIOStream): cstring {.
    importc: "g_file_io_stream_get_etag", libgio.}
proc etag*(stream: GFileIOStream): cstring {.
    importc: "g_file_io_stream_get_etag", libgio.}

template g_file_monitor*(o: expr): expr =
  (g_type_check_instance_cast(o, file_monitor_get_type(), GFileMonitorObj))

template g_file_monitor_class*(k: expr): expr =
  (g_type_check_class_cast(k, file_monitor_get_type(), GFileMonitorClassObj))

template g_is_file_monitor*(o: expr): expr =
  (g_type_check_instance_type(o, file_monitor_get_type()))

template g_is_file_monitor_class*(k: expr): expr =
  (g_type_check_class_type(k, file_monitor_get_type()))

template g_file_monitor_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, file_monitor_get_type(), GFileMonitorClassObj))

type
  GFileMonitorClass* =  ptr GFileMonitorClassObj
  GFileMonitorClassPtr* = ptr GFileMonitorClassObj
  GFileMonitorClassObj*{.final.} = object of GObjectClassObj
    changed*: proc (monitor: GFileMonitor; file: GFile;
                    other_file: GFile; event_type: GFileMonitorEvent) {.cdecl.}
    cancel*: proc (monitor: GFileMonitor): gboolean {.cdecl.}
    g_reserved171: proc () {.cdecl.}
    g_reserved172: proc () {.cdecl.}
    g_reserved173: proc () {.cdecl.}
    g_reserved174: proc () {.cdecl.}
    g_reserved175: proc () {.cdecl.}

proc g_file_monitor_get_type*(): GType {.importc: "g_file_monitor_get_type",
    libgio.}
proc cancel*(monitor: GFileMonitor): gboolean {.
    importc: "g_file_monitor_cancel", libgio.}
proc is_cancelled*(monitor: GFileMonitor): gboolean {.
    importc: "g_file_monitor_is_cancelled", libgio.}
proc set_rate_limit*(monitor: GFileMonitor;
                                    limit_msecs: gint) {.
    importc: "g_file_monitor_set_rate_limit", libgio.}
proc `rate_limit=`*(monitor: GFileMonitor;
                                    limit_msecs: gint) {.
    importc: "g_file_monitor_set_rate_limit", libgio.}
proc emit_event*(monitor: GFileMonitor; child: GFile;
                                other_file: GFile;
                                event_type: GFileMonitorEvent) {.
    importc: "g_file_monitor_emit_event", libgio.}

template g_filename_completer*(o: expr): expr =
  (g_type_check_instance_cast(o, filename_completer_get_type(),
                              GFilenameCompleterObj))

template g_filename_completer_class*(k: expr): expr =
  (g_type_check_class_cast(k, filename_completer_get_type(),
                           GFilenameCompleterClassObj))

template g_filename_completer_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, filename_completer_get_type(),
                             GFilenameCompleterClassObj))

template g_is_filename_completer*(o: expr): expr =
  (g_type_check_instance_type(o, filename_completer_get_type()))

template g_is_filename_completer_class*(k: expr): expr =
  (g_type_check_class_type(k, filename_completer_get_type()))

type
  GFilenameCompleterClass* =  ptr GFilenameCompleterClassObj
  GFilenameCompleterClassPtr* = ptr GFilenameCompleterClassObj
  GFilenameCompleterClassObj*{.final.} = object of GObjectClassObj
    got_completion_data*: proc (filename_completer: GFilenameCompleter) {.cdecl.}
    g_reserved181: proc () {.cdecl.}
    g_reserved182: proc () {.cdecl.}
    g_reserved183: proc () {.cdecl.}

proc g_filename_completer_get_type*(): GType {.
    importc: "g_filename_completer_get_type", libgio.}
proc g_filename_completer_new*(): GFilenameCompleter {.
    importc: "g_filename_completer_new", libgio.}
proc get_completion_suffix*(
    completer: GFilenameCompleter; initial_text: cstring): cstring {.
    importc: "g_filename_completer_get_completion_suffix", libgio.}
proc completion_suffix*(
    completer: GFilenameCompleter; initial_text: cstring): cstring {.
    importc: "g_filename_completer_get_completion_suffix", libgio.}
proc get_completions*(completer: GFilenameCompleter;
    initial_text: cstring): cstringArray {.
    importc: "g_filename_completer_get_completions", libgio.}
proc completions*(completer: GFilenameCompleter;
    initial_text: cstring): cstringArray {.
    importc: "g_filename_completer_get_completions", libgio.}
proc set_dirs_only*(completer: GFilenameCompleter;
    dirs_only: gboolean) {.importc: "g_filename_completer_set_dirs_only",
                           libgio.}
proc `dirs_only=`*(completer: GFilenameCompleter;
    dirs_only: gboolean) {.importc: "g_filename_completer_set_dirs_only",
                           libgio.}

template g_file_output_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, file_output_stream_get_type(),
                              GFileOutputStreamObj))

template g_file_output_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, file_output_stream_get_type(),
                           GFileOutputStreamClassObj))

template g_is_file_output_stream*(o: expr): expr =
  (g_type_check_instance_type(o, file_output_stream_get_type()))

template g_is_file_output_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, file_output_stream_get_type()))

template g_file_output_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, file_output_stream_get_type(),
                             GFileOutputStreamClassObj))

type
  GFileOutputStreamClass* =  ptr GFileOutputStreamClassObj
  GFileOutputStreamClassPtr* = ptr GFileOutputStreamClassObj
  GFileOutputStreamClassObj*{.final.} = object of GOutputStreamClassObj
    tell*: proc (stream: GFileOutputStream): goffset {.cdecl.}
    can_seek*: proc (stream: GFileOutputStream): gboolean {.cdecl.}
    seek*: proc (stream: GFileOutputStream; offset: goffset;
                 `type`: GSeekType; cancellable: GCancellable;
                 error: var GError): gboolean {.cdecl.}
    can_truncate*: proc (stream: GFileOutputStream): gboolean {.cdecl.}
    truncate_fn*: proc (stream: GFileOutputStream; size: goffset;
                        cancellable: GCancellable; error: var GError): gboolean {.cdecl.}
    query_info*: proc (stream: GFileOutputStream; attributes: cstring;
                       cancellable: GCancellable; error: var GError): GFileInfo {.cdecl.}
    query_info_async*: proc (stream: GFileOutputStream;
                             attributes: cstring; io_priority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback;
                             user_data: gpointer) {.cdecl.}
    query_info_finish*: proc (stream: GFileOutputStream;
                              result: GAsyncResult; error: var GError): GFileInfo {.cdecl.}
    get_etag*: proc (stream: GFileOutputStream): cstring {.cdecl.}
    g_reserved191: proc () {.cdecl.}
    g_reserved192: proc () {.cdecl.}
    g_reserved193: proc () {.cdecl.}
    g_reserved194: proc () {.cdecl.}
    g_reserved195: proc () {.cdecl.}

proc g_file_output_stream_get_type*(): GType {.
    importc: "g_file_output_stream_get_type", libgio.}
proc query_info*(stream: GFileOutputStream;
                                      attributes: cstring;
                                      cancellable: GCancellable;
                                      error: var GError): GFileInfo {.
    importc: "g_file_output_stream_query_info", libgio.}
proc query_info_async*(stream: GFileOutputStream;
    attributes: cstring; io_priority: cint; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_file_output_stream_query_info_async", libgio.}
proc query_info_finish*(stream: GFileOutputStream;
    result: GAsyncResult; error: var GError): GFileInfo {.
    importc: "g_file_output_stream_query_info_finish", libgio.}
proc get_etag*(stream: GFileOutputStream): cstring {.
    importc: "g_file_output_stream_get_etag", libgio.}
proc etag*(stream: GFileOutputStream): cstring {.
    importc: "g_file_output_stream_get_etag", libgio.}

template g_inet_address*(o: expr): expr =
  (g_type_check_instance_cast(o, inet_address_get_type(), GInetAddressObj))

template g_inet_address_class*(k: expr): expr =
  (g_type_check_class_cast(k, inet_address_get_type(), GInetAddressClassObj))

template g_is_inet_address*(o: expr): expr =
  (g_type_check_instance_type(o, inet_address_get_type()))

template g_is_inet_address_class*(k: expr): expr =
  (g_type_check_class_type(k, inet_address_get_type()))

template g_inet_address_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, inet_address_get_type(), GInetAddressClassObj))

type
  GInetAddressPrivateObj = object
 
type
  GInetAddress* =  ptr GInetAddressObj
  GInetAddressPtr* = ptr GInetAddressObj
  GInetAddressObj*{.final.} = object of GObjectObj
    priv24: ptr GInetAddressPrivateObj

type
  GInetAddressClass* =  ptr GInetAddressClassObj
  GInetAddressClassPtr* = ptr GInetAddressClassObj
  GInetAddressClassObj*{.final.} = object of GObjectClassObj
    to_string*: proc (address: GInetAddress): cstring {.cdecl.}
    to_bytes*: proc (address: GInetAddress): ptr guint8 {.cdecl.}

proc g_inet_address_get_type*(): GType {.importc: "g_inet_address_get_type",
    libgio.}
proc g_inet_address_new_from_string*(string: cstring): GInetAddress {.
    importc: "g_inet_address_new_from_string", libgio.}
proc g_inet_address_new_from_bytes*(bytes: var guint8; family: GSocketFamily): GInetAddress {.
    importc: "g_inet_address_new_from_bytes", libgio.}
proc g_inet_address_new_loopback*(family: GSocketFamily): GInetAddress {.
    importc: "g_inet_address_new_loopback", libgio.}
proc g_inet_address_new_any*(family: GSocketFamily): GInetAddress {.
    importc: "g_inet_address_new_any", libgio.}
proc equal*(address: GInetAddress;
                           other_address: GInetAddress): gboolean {.
    importc: "g_inet_address_equal", libgio.}
proc to_string*(address: GInetAddress): cstring {.
    importc: "g_inet_address_to_string", libgio.}
proc to_bytes*(address: GInetAddress): ptr guint8 {.
    importc: "g_inet_address_to_bytes", libgio.}
proc get_native_size*(address: GInetAddress): gsize {.
    importc: "g_inet_address_get_native_size", libgio.}
proc native_size*(address: GInetAddress): gsize {.
    importc: "g_inet_address_get_native_size", libgio.}
proc get_family*(address: GInetAddress): GSocketFamily {.
    importc: "g_inet_address_get_family", libgio.}
proc family*(address: GInetAddress): GSocketFamily {.
    importc: "g_inet_address_get_family", libgio.}
proc get_is_any*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_any", libgio.}
proc is_any*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_any", libgio.}
proc get_is_loopback*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_loopback", libgio.}
proc is_loopback*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_loopback", libgio.}
proc get_is_link_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_link_local", libgio.}
proc is_link_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_link_local", libgio.}
proc get_is_site_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_site_local", libgio.}
proc is_site_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_site_local", libgio.}
proc get_is_multicast*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_multicast", libgio.}
proc is_multicast*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_multicast", libgio.}
proc get_is_mc_global*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_mc_global", libgio.}
proc is_mc_global*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_mc_global", libgio.}
proc get_is_mc_link_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_mc_link_local", libgio.}
proc is_mc_link_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_mc_link_local", libgio.}
proc get_is_mc_node_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_mc_node_local", libgio.}
proc is_mc_node_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_mc_node_local", libgio.}
proc get_is_mc_org_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_mc_org_local", libgio.}
proc is_mc_org_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_mc_org_local", libgio.}
proc get_is_mc_site_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_mc_site_local", libgio.}
proc is_mc_site_local*(address: GInetAddress): gboolean {.
    importc: "g_inet_address_get_is_mc_site_local", libgio.}

template g_inet_address_mask*(o: expr): expr =
  (g_type_check_instance_cast(o, inet_address_mask_get_type(), GInetAddressMaskObj))

template g_inet_address_mask_class*(k: expr): expr =
  (g_type_check_class_cast(k, inet_address_mask_get_type(),
                           GInetAddressMaskClassObj))

template g_is_inet_address_mask*(o: expr): expr =
  (g_type_check_instance_type(o, inet_address_mask_get_type()))

template g_is_inet_address_mask_class*(k: expr): expr =
  (g_type_check_class_type(k, inet_address_mask_get_type()))

template g_inet_address_mask_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, inet_address_mask_get_type(),
                             GInetAddressMaskClassObj))

type
  GInetAddressMaskPrivateObj = object
 
type
  GInetAddressMask* =  ptr GInetAddressMaskObj
  GInetAddressMaskPtr* = ptr GInetAddressMaskObj
  GInetAddressMaskObj*{.final.} = object of GObjectObj
    priv25: ptr GInetAddressMaskPrivateObj

type
  GInetAddressMaskClass* =  ptr GInetAddressMaskClassObj
  GInetAddressMaskClassPtr* = ptr GInetAddressMaskClassObj
  GInetAddressMaskClassObj*{.final.} = object of GObjectClassObj

proc g_inet_address_mask_get_type*(): GType {.
    importc: "g_inet_address_mask_get_type", libgio.}
proc mask_new*(`addr`: GInetAddress; length: guint;
                              error: var GError): GInetAddressMask {.
    importc: "g_inet_address_mask_new", libgio.}
proc g_inet_address_mask_new_from_string*(mask_string: cstring;
    error: var GError): GInetAddressMask {.
    importc: "g_inet_address_mask_new_from_string", libgio.}
proc to_string*(mask: GInetAddressMask): cstring {.
    importc: "g_inet_address_mask_to_string", libgio.}
proc get_family*(mask: GInetAddressMask): GSocketFamily {.
    importc: "g_inet_address_mask_get_family", libgio.}
proc family*(mask: GInetAddressMask): GSocketFamily {.
    importc: "g_inet_address_mask_get_family", libgio.}
proc get_address*(mask: GInetAddressMask): GInetAddress {.
    importc: "g_inet_address_mask_get_address", libgio.}
proc address*(mask: GInetAddressMask): GInetAddress {.
    importc: "g_inet_address_mask_get_address", libgio.}
proc get_length*(mask: GInetAddressMask): guint {.
    importc: "g_inet_address_mask_get_length", libgio.}
proc length*(mask: GInetAddressMask): guint {.
    importc: "g_inet_address_mask_get_length", libgio.}
proc matches*(mask: GInetAddressMask;
                                  address: GInetAddress): gboolean {.
    importc: "g_inet_address_mask_matches", libgio.}
proc equal*(mask: GInetAddressMask;
                                mask2: GInetAddressMask): gboolean {.
    importc: "g_inet_address_mask_equal", libgio.}

template g_socket_address*(o: expr): expr =
  (g_type_check_instance_cast(o, socket_address_get_type(), GSocketAddressObj))

template g_socket_address_class*(k: expr): expr =
  (g_type_check_class_cast(k, socket_address_get_type(), GSocketAddressClassObj))

template g_is_socket_address*(o: expr): expr =
  (g_type_check_instance_type(o, socket_address_get_type()))

template g_is_socket_address_class*(k: expr): expr =
  (g_type_check_class_type(k, socket_address_get_type()))

template g_socket_address_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, socket_address_get_type(), GSocketAddressClassObj))

type
  GSocketAddressClass* =  ptr GSocketAddressClassObj
  GSocketAddressClassPtr* = ptr GSocketAddressClassObj
  GSocketAddressClassObj* = object of GObjectClassObj
    get_family*: proc (address: GSocketAddress): GSocketFamily {.cdecl.}
    get_native_size*: proc (address: GSocketAddress): gssize {.cdecl.}
    to_native*: proc (address: GSocketAddress; dest: gpointer;
                      destlen: gsize; error: var GError): gboolean {.cdecl.}

proc g_socket_address_get_type*(): GType {.
    importc: "g_socket_address_get_type", libgio.}
proc get_family*(address: GSocketAddress): GSocketFamily {.
    importc: "g_socket_address_get_family", libgio.}
proc family*(address: GSocketAddress): GSocketFamily {.
    importc: "g_socket_address_get_family", libgio.}
proc g_socket_address_new_from_native*(native: gpointer; len: gsize): GSocketAddress {.
    importc: "g_socket_address_new_from_native", libgio.}
proc to_native*(address: GSocketAddress; dest: gpointer;
                                 destlen: gsize; error: var GError): gboolean {.
    importc: "g_socket_address_to_native", libgio.}
proc get_native_size*(address: GSocketAddress): gssize {.
    importc: "g_socket_address_get_native_size", libgio.}
proc native_size*(address: GSocketAddress): gssize {.
    importc: "g_socket_address_get_native_size", libgio.}

template g_inet_socket_address*(o: expr): expr =
  (g_type_check_instance_cast(o, inet_socket_address_get_type(),
                              GInetSocketAddressObj))

template g_inet_socket_address_class*(k: expr): expr =
  (g_type_check_class_cast(k, inet_socket_address_get_type(),
                           GInetSocketAddressClassObj))

template g_is_inet_socket_address*(o: expr): expr =
  (g_type_check_instance_type(o, inet_socket_address_get_type()))

template g_is_inet_socket_address_class*(k: expr): expr =
  (g_type_check_class_type(k, inet_socket_address_get_type()))

template g_inet_socket_address_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, inet_socket_address_get_type(),
                             GInetSocketAddressClassObj))

type
  GInetSocketAddressPrivateObj = object
 
type
  GInetSocketAddress* =  ptr GInetSocketAddressObj
  GInetSocketAddressPtr* = ptr GInetSocketAddressObj
  GInetSocketAddressObj* = object of GSocketAddressObj
    priv26: ptr GInetSocketAddressPrivateObj

type
  GInetSocketAddressClass* =  ptr GInetSocketAddressClassObj
  GInetSocketAddressClassPtr* = ptr GInetSocketAddressClassObj
  GInetSocketAddressClassObj* = object of GSocketAddressClassObj

proc g_inet_socket_address_get_type*(): GType {.
    importc: "g_inet_socket_address_get_type", libgio.}
proc g_inet_socket_address_new*(address: GInetAddress; port: guint16): GSocketAddress {.
    importc: "g_inet_socket_address_new", libgio.}
proc g_inet_socket_address_new_from_string*(address: cstring; port: guint): GSocketAddress {.
    importc: "g_inet_socket_address_new_from_string", libgio.}
proc get_address*(address: GInetSocketAddress): GInetAddress {.
    importc: "g_inet_socket_address_get_address", libgio.}
proc address*(address: GInetSocketAddress): GInetAddress {.
    importc: "g_inet_socket_address_get_address", libgio.}
proc get_port*(address: GInetSocketAddress): guint16 {.
    importc: "g_inet_socket_address_get_port", libgio.}
proc port*(address: GInetSocketAddress): guint16 {.
    importc: "g_inet_socket_address_get_port", libgio.}
proc get_flowinfo*(address: GInetSocketAddress): guint32 {.
    importc: "g_inet_socket_address_get_flowinfo", libgio.}
proc flowinfo*(address: GInetSocketAddress): guint32 {.
    importc: "g_inet_socket_address_get_flowinfo", libgio.}
proc get_scope_id*(address: GInetSocketAddress): guint32 {.
    importc: "g_inet_socket_address_get_scope_id", libgio.}
proc scope_id*(address: GInetSocketAddress): guint32 {.
    importc: "g_inet_socket_address_get_scope_id", libgio.}

proc g_app_info_create_flags_get_type*(): GType {.
    importc: "g_app_info_create_flags_get_type", libgio.}
proc g_converter_flags_get_type*(): GType {.
    importc: "g_converter_flags_get_type", libgio.}
proc g_converter_result_get_type*(): GType {.
    importc: "g_converter_result_get_type", libgio.}
proc g_data_stream_byte_order_get_type*(): GType {.
    importc: "g_data_stream_byte_order_get_type", libgio.}
proc g_data_stream_newline_type_get_type*(): GType {.
    importc: "g_data_stream_newline_type_get_type", libgio.}
proc g_file_attribute_type_get_type*(): GType {.
    importc: "g_file_attribute_type_get_type", libgio.}
proc g_file_attribute_info_flags_get_type*(): GType {.
    importc: "g_file_attribute_info_flags_get_type", libgio.}
proc g_file_attribute_status_get_type*(): GType {.
    importc: "g_file_attribute_status_get_type", libgio.}
proc g_file_query_info_flags_get_type*(): GType {.
    importc: "g_file_query_info_flags_get_type", libgio.}
proc g_file_create_flags_get_type*(): GType {.
    importc: "g_file_create_flags_get_type", libgio.}
proc g_file_measure_flags_get_type*(): GType {.
    importc: "g_file_measure_flags_get_type", libgio.}
proc g_mount_mount_flags_get_type*(): GType {.
    importc: "g_mount_mount_flags_get_type", libgio.}
proc g_mount_unmount_flags_get_type*(): GType {.
    importc: "g_mount_unmount_flags_get_type", libgio.}
proc g_drive_start_flags_get_type*(): GType {.
    importc: "g_drive_start_flags_get_type", libgio.}
proc g_drive_start_stop_type_get_type*(): GType {.
    importc: "g_drive_start_stop_type_get_type", libgio.}
proc g_file_copy_flags_get_type*(): GType {.
    importc: "g_file_copy_flags_get_type", libgio.}
proc g_file_monitor_flags_get_type*(): GType {.
    importc: "g_file_monitor_flags_get_type", libgio.}
proc g_file_type_get_type*(): GType {.importc: "g_file_type_get_type",
                                      libgio.}
proc g_filesystem_preview_type_get_type*(): GType {.
    importc: "g_filesystem_preview_type_get_type", libgio.}
proc g_file_monitor_event_get_type*(): GType {.
    importc: "g_file_monitor_event_get_type", libgio.}
proc g_io_error_enum_get_type*(): GType {.importc: "g_io_error_enum_get_type",
    libgio.}
proc g_ask_password_flags_get_type*(): GType {.
    importc: "g_ask_password_flags_get_type", libgio.}
proc g_password_save_get_type*(): GType {.importc: "g_password_save_get_type",
    libgio.}
proc g_mount_operation_result_get_type*(): GType {.
    importc: "g_mount_operation_result_get_type", libgio.}
proc g_output_stream_splice_flags_get_type*(): GType {.
    importc: "g_output_stream_splice_flags_get_type", libgio.}
proc g_io_stream_splice_flags_get_type*(): GType {.
    importc: "g_io_stream_splice_flags_get_type", libgio.}
proc g_emblem_origin_get_type*(): GType {.importc: "g_emblem_origin_get_type",
    libgio.}
proc g_resolver_error_get_type*(): GType {.
    importc: "g_resolver_error_get_type", libgio.}
proc g_resolver_record_type_get_type*(): GType {.
    importc: "g_resolver_record_type_get_type", libgio.}
proc g_resource_error_get_type*(): GType {.
    importc: "g_resource_error_get_type", libgio.}
proc g_resource_flags_get_type*(): GType {.
    importc: "g_resource_flags_get_type", libgio.}
proc g_resource_lookup_flags_get_type*(): GType {.
    importc: "g_resource_lookup_flags_get_type", libgio.}
proc g_socket_family_get_type*(): GType {.importc: "g_socket_family_get_type",
    libgio.}
proc g_socket_type_get_type*(): GType {.importc: "g_socket_type_get_type",
    libgio.}
proc g_socket_msg_flags_get_type*(): GType {.
    importc: "g_socket_msg_flags_get_type", libgio.}
proc g_socket_protocol_get_type*(): GType {.
    importc: "g_socket_protocol_get_type", libgio.}
proc g_zlib_compressor_format_get_type*(): GType {.
    importc: "g_zlib_compressor_format_get_type", libgio.}
proc g_unix_socket_address_type_get_type*(): GType {.
    importc: "g_unix_socket_address_type_get_type", libgio.}
proc g_bus_type_get_type*(): GType {.importc: "g_bus_type_get_type",
                                     libgio.}
proc g_bus_name_owner_flags_get_type*(): GType {.
    importc: "g_bus_name_owner_flags_get_type", libgio.}
proc g_bus_name_watcher_flags_get_type*(): GType {.
    importc: "g_bus_name_watcher_flags_get_type", libgio.}
proc g_dbus_proxy_flags_get_type*(): GType {.
    importc: "g_dbus_proxy_flags_get_type", libgio.}
proc g_dbus_error_get_type*(): GType {.importc: "g_dbus_error_get_type",
    libgio.}
proc g_dbus_connection_flags_get_type*(): GType {.
    importc: "g_dbus_connection_flags_get_type", libgio.}
proc g_dbus_capability_flags_get_type*(): GType {.
    importc: "g_dbus_capability_flags_get_type", libgio.}
proc g_dbus_call_flags_get_type*(): GType {.
    importc: "g_dbus_call_flags_get_type", libgio.}
proc g_dbus_message_type_get_type*(): GType {.
    importc: "g_dbus_message_type_get_type", libgio.}
proc g_dbus_message_flags_get_type*(): GType {.
    importc: "g_dbus_message_flags_get_type", libgio.}
proc g_dbus_message_header_field_get_type*(): GType {.
    importc: "g_dbus_message_header_field_get_type", libgio.}
proc g_dbus_property_info_flags_get_type*(): GType {.
    importc: "g_dbus_property_info_flags_get_type", libgio.}
proc g_dbus_subtree_flags_get_type*(): GType {.
    importc: "g_dbus_subtree_flags_get_type", libgio.}
proc g_dbus_server_flags_get_type*(): GType {.
    importc: "g_dbus_server_flags_get_type", libgio.}
proc g_dbus_signal_flags_get_type*(): GType {.
    importc: "g_dbus_signal_flags_get_type", libgio.}
proc g_dbus_send_message_flags_get_type*(): GType {.
    importc: "g_dbus_send_message_flags_get_type", libgio.}
proc g_credentials_type_get_type*(): GType {.
    importc: "g_credentials_type_get_type", libgio.}
proc g_dbus_message_byte_order_get_type*(): GType {.
    importc: "g_dbus_message_byte_order_get_type", libgio.}
proc g_application_flags_get_type*(): GType {.
    importc: "g_application_flags_get_type", libgio.}
proc g_tls_error_get_type*(): GType {.importc: "g_tls_error_get_type",
                                      libgio.}
proc g_tls_certificate_flags_get_type*(): GType {.
    importc: "g_tls_certificate_flags_get_type", libgio.}
proc g_tls_authentication_mode_get_type*(): GType {.
    importc: "g_tls_authentication_mode_get_type", libgio.}
proc g_tls_rehandshake_mode_get_type*(): GType {.
    importc: "g_tls_rehandshake_mode_get_type", libgio.}
proc g_tls_password_flags_get_type*(): GType {.
    importc: "g_tls_password_flags_get_type", libgio.}
proc g_tls_interaction_result_get_type*(): GType {.
    importc: "g_tls_interaction_result_get_type", libgio.}
proc g_dbus_interface_skeleton_flags_get_type*(): GType {.
    importc: "g_dbus_interface_skeleton_flags_get_type", libgio.}
proc g_dbus_object_manager_client_flags_get_type*(): GType {.
    importc: "g_dbus_object_manager_client_flags_get_type", libgio.}
proc g_tls_database_verify_flags_get_type*(): GType {.
    importc: "g_tls_database_verify_flags_get_type", libgio.}
proc g_tls_database_lookup_flags_get_type*(): GType {.
    importc: "g_tls_database_lookup_flags_get_type", libgio.}
proc g_tls_certificate_request_flags_get_type*(): GType {.
    importc: "g_tls_certificate_request_flags_get_type", libgio.}
proc g_io_module_scope_flags_get_type*(): GType {.
    importc: "g_io_module_scope_flags_get_type", libgio.}
proc g_socket_client_event_get_type*(): GType {.
    importc: "g_socket_client_event_get_type", libgio.}
proc g_test_dbus_flags_get_type*(): GType {.
    importc: "g_test_dbus_flags_get_type", libgio.}
proc g_subprocess_flags_get_type*(): GType {.
    importc: "g_subprocess_flags_get_type", libgio.}
proc g_notification_priority_get_type*(): GType {.
    importc: "g_notification_priority_get_type", libgio.}
proc g_network_connectivity_get_type*(): GType {.
    importc: "g_network_connectivity_get_type", libgio.}
proc g_settings_bind_flags_get_type*(): GType {.
    importc: "g_settings_bind_flags_get_type", libgio.}

type
  GIOModuleScope* =  ptr GIOModuleScopeObj
  GIOModuleScopePtr* = ptr GIOModuleScopeObj
  GIOModuleScopeObj* = object
 
proc g_io_module_scope_new*(flags: GIOModuleScopeFlags): GIOModuleScope {.
    importc: "g_io_module_scope_new", libgio.}
proc free*(scope: GIOModuleScope) {.
    importc: "g_io_module_scope_free", libgio.}
proc `block`*(scope: GIOModuleScope; basename: cstring) {.
    importc: "g_io_module_scope_block", libgio.}
template g_io_module*(o: expr): expr =
  (g_type_check_instance_cast(o, module_get_type(), GIOModuleObj))

template g_io_module_class*(k: expr): expr =
  (g_type_check_class_cast(k, module_get_type(), GIOModuleClassObj))

template g_io_is_module*(o: expr): expr =
  (g_type_check_instance_type(o, module_get_type()))

template g_io_is_module_class*(k: expr): expr =
  (g_type_check_class_type(k, module_get_type()))

template g_io_module_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, module_get_type(), GIOModuleClassObj))

type
  GIOModuleClass* =  ptr GIOModuleClassObj
  GIOModuleClassPtr* = ptr GIOModuleClassObj
  GIOModuleClassObj* = object
 
proc g_io_module_get_type*(): GType {.importc: "g_io_module_get_type",
                                      libgio.}
proc g_io_module_new*(filename: cstring): GIOModule {.
    importc: "g_io_module_new", libgio.}
proc g_io_modules_scan_all_in_directory*(dirname: cstring) {.
    importc: "g_io_modules_scan_all_in_directory", libgio.}
proc g_io_modules_load_all_in_directory*(dirname: cstring): GList {.
    importc: "g_io_modules_load_all_in_directory", libgio.}
proc g_io_modules_scan_all_in_directory_with_scope*(dirname: cstring;
    scope: GIOModuleScope) {.importc: "g_io_modules_scan_all_in_directory_with_scope",
                                 libgio.}
proc g_io_modules_load_all_in_directory_with_scope*(dirname: cstring;
    scope: GIOModuleScope): GList {.
    importc: "g_io_modules_load_all_in_directory_with_scope", libgio.}
proc g_io_extension_point_register*(name: cstring): GIOExtensionPoint {.
    importc: "g_io_extension_point_register", libgio.}
proc g_io_extension_point_lookup*(name: cstring): GIOExtensionPoint {.
    importc: "g_io_extension_point_lookup", libgio.}
proc set_required_type*(
    extension_point: GIOExtensionPoint; `type`: GType) {.
    importc: "g_io_extension_point_set_required_type", libgio.}
proc `required_type=`*(
    extension_point: GIOExtensionPoint; `type`: GType) {.
    importc: "g_io_extension_point_set_required_type", libgio.}
proc get_required_type*(
    extension_point: GIOExtensionPoint): GType {.
    importc: "g_io_extension_point_get_required_type", libgio.}
proc required_type*(
    extension_point: GIOExtensionPoint): GType {.
    importc: "g_io_extension_point_get_required_type", libgio.}
proc get_extensions*(
    extension_point: GIOExtensionPoint): GList {.
    importc: "g_io_extension_point_get_extensions", libgio.}
proc extensions*(
    extension_point: GIOExtensionPoint): GList {.
    importc: "g_io_extension_point_get_extensions", libgio.}
proc get_extension_by_name*(
    extension_point: GIOExtensionPoint; name: cstring): GIOExtension {.
    importc: "g_io_extension_point_get_extension_by_name", libgio.}
proc extension_by_name*(
    extension_point: GIOExtensionPoint; name: cstring): GIOExtension {.
    importc: "g_io_extension_point_get_extension_by_name", libgio.}
proc g_io_extension_point_implement*(extension_point_name: cstring;
                                     `type`: GType; extension_name: cstring;
                                     priority: gint): GIOExtension {.
    importc: "g_io_extension_point_implement", libgio.}
proc get_type*(extension: GIOExtension): GType {.
    importc: "g_io_extension_get_type", libgio.}
proc `type`*(extension: GIOExtension): GType {.
    importc: "g_io_extension_get_type", libgio.}
proc get_name*(extension: GIOExtension): cstring {.
    importc: "g_io_extension_get_name", libgio.}
proc name*(extension: GIOExtension): cstring {.
    importc: "g_io_extension_get_name", libgio.}
proc get_priority*(extension: GIOExtension): gint {.
    importc: "g_io_extension_get_priority", libgio.}
proc priority*(extension: GIOExtension): gint {.
    importc: "g_io_extension_get_priority", libgio.}
proc ref_class*(extension: GIOExtension): gobject.GTypeClass {.
    importc: "g_io_extension_ref_class", libgio.}
proc load*(module: GIOModule) {.importc: "g_io_module_load",
    libgio.}
proc unload*(module: GIOModule) {.
    importc: "g_io_module_unload", libgio.}
proc g_io_module_query*(): cstringArray {.importc: "g_io_module_query",
    libgio.}

proc g_io_scheduler_push_job*(job_func: GIOSchedulerJobFunc;
                              user_data: gpointer; notify: GDestroyNotify;
                              io_priority: gint; cancellable: GCancellable) {.
    importc: "g_io_scheduler_push_job", libgio.}
proc g_io_scheduler_cancel_all_jobs*() {.
    importc: "g_io_scheduler_cancel_all_jobs", libgio.}
proc send_to_mainloop*(job: GIOSchedulerJob;
    `func`: GSourceFunc; user_data: gpointer; notify: GDestroyNotify): gboolean {.
    importc: "g_io_scheduler_job_send_to_mainloop", libgio.}
proc send_to_mainloop_async*(job: GIOSchedulerJob;
    `func`: GSourceFunc; user_data: gpointer; notify: GDestroyNotify) {.
    importc: "g_io_scheduler_job_send_to_mainloop_async", libgio.}

template g_loadable_icon*(obj: expr): expr =
  (g_type_check_instance_cast(obj, loadable_icon_get_type(), GLoadableIconObj))

template g_is_loadable_icon*(obj: expr): expr =
  (g_type_check_instance_type(obj, loadable_icon_get_type()))

template g_loadable_icon_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, loadable_icon_get_type(),
                                 GLoadableIconIfaceObj))

type
  GLoadableIconIface* =  ptr GLoadableIconIfaceObj
  GLoadableIconIfacePtr* = ptr GLoadableIconIfaceObj
  GLoadableIconIfaceObj*{.final.} = object of GTypeInterfaceObj
    load*: proc (icon: GLoadableIcon; size: cint; `type`: cstringArray;
                 cancellable: GCancellable; error: var GError): GInputStream {.cdecl.}
    load_async*: proc (icon: GLoadableIcon; size: cint;
                       cancellable: GCancellable;
                       callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    load_finish*: proc (icon: GLoadableIcon; res: GAsyncResult;
                        `type`: cstringArray; error: var GError): GInputStream {.cdecl.}

proc g_loadable_icon_get_type*(): GType {.importc: "g_loadable_icon_get_type",
    libgio.}
proc load*(icon: GLoadableIcon; size: cint;
                           `type`: cstringArray;
                           cancellable: GCancellable;
                           error: var GError): GInputStream {.
    importc: "g_loadable_icon_load", libgio.}
proc load_async*(icon: GLoadableIcon; size: cint;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.
    importc: "g_loadable_icon_load_async", libgio.}
proc load_finish*(icon: GLoadableIcon;
                                  res: GAsyncResult; `type`: cstringArray;
                                  error: var GError): GInputStream {.
    importc: "g_loadable_icon_load_finish", libgio.}

template g_memory_input_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, memory_input_stream_get_type(),
                              GMemoryInputStreamObj))

template g_memory_input_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, memory_input_stream_get_type(),
                           GMemoryInputStreamClassObj))

template g_is_memory_input_stream*(o: expr): expr =
  (g_type_check_instance_type(o, memory_input_stream_get_type()))

template g_is_memory_input_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, memory_input_stream_get_type()))

template g_memory_input_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, memory_input_stream_get_type(),
                             GMemoryInputStreamClassObj))

type
  GMemoryInputStreamPrivateObj = object
 
type
  GMemoryInputStream* =  ptr GMemoryInputStreamObj
  GMemoryInputStreamPtr* = ptr GMemoryInputStreamObj
  GMemoryInputStreamObj*{.final.} = object of GInputStreamObj
    priv27: ptr GMemoryInputStreamPrivateObj

type
  GMemoryInputStreamClass* =  ptr GMemoryInputStreamClassObj
  GMemoryInputStreamClassPtr* = ptr GMemoryInputStreamClassObj
  GMemoryInputStreamClassObj*{.final.} = object of GInputStreamClassObj
    g_reserved201: proc () {.cdecl.}
    g_reserved202: proc () {.cdecl.}
    g_reserved203: proc () {.cdecl.}
    g_reserved204: proc () {.cdecl.}
    g_reserved205: proc () {.cdecl.}

proc g_memory_input_stream_get_type*(): GType {.
    importc: "g_memory_input_stream_get_type", libgio.}
proc g_memory_input_stream_new*(): GInputStream {.
    importc: "g_memory_input_stream_new", libgio.}
proc g_memory_input_stream_new_from_data*(data: pointer; len: gssize;
    destroy: GDestroyNotify): GInputStream {.
    importc: "g_memory_input_stream_new_from_data", libgio.}
proc g_memory_input_stream_new_from_bytes*(bytes: glib.GBytes): GInputStream {.
    importc: "g_memory_input_stream_new_from_bytes", libgio.}
proc add_data*(stream: GMemoryInputStream;
                                     data: pointer; len: gssize;
                                     destroy: GDestroyNotify) {.
    importc: "g_memory_input_stream_add_data", libgio.}
proc add_bytes*(stream: GMemoryInputStream;
                                      bytes: glib.GBytes) {.
    importc: "g_memory_input_stream_add_bytes", libgio.}

template g_memory_output_stream*(o: expr): expr =
  (g_type_check_instance_cast(o, memory_output_stream_get_type(),
                              GMemoryOutputStreamObj))

template g_memory_output_stream_class*(k: expr): expr =
  (g_type_check_class_cast(k, memory_output_stream_get_type(),
                           GMemoryOutputStreamClassObj))

template g_is_memory_output_stream*(o: expr): expr =
  (g_type_check_instance_type(o, memory_output_stream_get_type()))

template g_is_memory_output_stream_class*(k: expr): expr =
  (g_type_check_class_type(k, memory_output_stream_get_type()))

template g_memory_output_stream_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, memory_output_stream_get_type(),
                             GMemoryOutputStreamClassObj))

type
  GMemoryOutputStreamPrivateObj = object
 
type
  GMemoryOutputStream* =  ptr GMemoryOutputStreamObj
  GMemoryOutputStreamPtr* = ptr GMemoryOutputStreamObj
  GMemoryOutputStreamObj*{.final.} = object of GOutputStreamObj
    priv28: ptr GMemoryOutputStreamPrivateObj

type
  GMemoryOutputStreamClass* =  ptr GMemoryOutputStreamClassObj
  GMemoryOutputStreamClassPtr* = ptr GMemoryOutputStreamClassObj
  GMemoryOutputStreamClassObj*{.final.} = object of GOutputStreamClassObj
    g_reserved211: proc () {.cdecl.}
    g_reserved212: proc () {.cdecl.}
    g_reserved213: proc () {.cdecl.}
    g_reserved214: proc () {.cdecl.}
    g_reserved215: proc () {.cdecl.}

type
  GReallocFunc* = proc (data: gpointer; size: gsize): gpointer {.cdecl.}
proc g_memory_output_stream_get_type*(): GType {.
    importc: "g_memory_output_stream_get_type", libgio.}
proc g_memory_output_stream_new*(data: gpointer; size: gsize;
                                 realloc_function: GReallocFunc;
                                 destroy_function: GDestroyNotify): GOutputStream {.
    importc: "g_memory_output_stream_new", libgio.}
proc g_memory_output_stream_new_resizable*(): GOutputStream {.
    importc: "g_memory_output_stream_new_resizable", libgio.}
proc get_data*(ostream: GMemoryOutputStream): gpointer {.
    importc: "g_memory_output_stream_get_data", libgio.}
proc data*(ostream: GMemoryOutputStream): gpointer {.
    importc: "g_memory_output_stream_get_data", libgio.}
proc get_size*(ostream: GMemoryOutputStream): gsize {.
    importc: "g_memory_output_stream_get_size", libgio.}
proc size*(ostream: GMemoryOutputStream): gsize {.
    importc: "g_memory_output_stream_get_size", libgio.}
proc get_data_size*(ostream: GMemoryOutputStream): gsize {.
    importc: "g_memory_output_stream_get_data_size", libgio.}
proc data_size*(ostream: GMemoryOutputStream): gsize {.
    importc: "g_memory_output_stream_get_data_size", libgio.}
proc steal_data*(ostream: GMemoryOutputStream): gpointer {.
    importc: "g_memory_output_stream_steal_data", libgio.}
proc steal_as_bytes*(ostream: GMemoryOutputStream): glib.GBytes {.
    importc: "g_memory_output_stream_steal_as_bytes", libgio.}

template g_mount*(obj: expr): expr =
  (g_type_check_instance_cast(obj, mount_get_type(), GMountObj))

template g_is_mount*(obj: expr): expr =
  (g_type_check_instance_type(obj, mount_get_type()))

template g_mount_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, mount_get_type(), GMountIfaceObj))

type
  GMountIface* =  ptr GMountIfaceObj
  GMountIfacePtr* = ptr GMountIfaceObj
  GMountIfaceObj*{.final.} = object of GTypeInterfaceObj
    changed*: proc (mount: GMount) {.cdecl.}
    unmounted*: proc (mount: GMount) {.cdecl.}
    get_root*: proc (mount: GMount): GFile {.cdecl.}
    get_name*: proc (mount: GMount): cstring {.cdecl.}
    get_icon*: proc (mount: GMount): GIcon {.cdecl.}
    get_uuid*: proc (mount: GMount): cstring {.cdecl.}
    get_volume*: proc (mount: GMount): GVolume {.cdecl.}
    get_drive*: proc (mount: GMount): GDrive {.cdecl.}
    can_unmount*: proc (mount: GMount): gboolean {.cdecl.}
    can_eject*: proc (mount: GMount): gboolean {.cdecl.}
    unmount*: proc (mount: GMount; flags: GMountUnmountFlags;
                    cancellable: GCancellable;
                    callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    unmount_finish*: proc (mount: GMount; result: GAsyncResult;
                           error: var GError): gboolean {.cdecl.}
    eject*: proc (mount: GMount; flags: GMountUnmountFlags;
                  cancellable: GCancellable;
                  callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    eject_finish*: proc (mount: GMount; result: GAsyncResult;
                         error: var GError): gboolean {.cdecl.}
    remount*: proc (mount: GMount; flags: GMountMountFlags;
                    mount_operation: GMountOperation;
                    cancellable: GCancellable;
                    callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    remount_finish*: proc (mount: GMount; result: GAsyncResult;
                           error: var GError): gboolean {.cdecl.}
    guess_content_type*: proc (mount: GMount; force_rescan: gboolean;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback;
                               user_data: gpointer) {.cdecl.}
    guess_content_type_finish*: proc (mount: GMount;
                                      result: GAsyncResult;
                                      error: var GError): cstringArray {.cdecl.}
    guess_content_type_sync*: proc (mount: GMount; force_rescan: gboolean;
                                    cancellable: GCancellable;
                                    error: var GError): cstringArray {.cdecl.}
    pre_unmount*: proc (mount: GMount) {.cdecl.}
    unmount_with_operation*: proc (mount: GMount;
                                   flags: GMountUnmountFlags;
                                   mount_operation: GMountOperation;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   user_data: gpointer) {.cdecl.}
    unmount_with_operation_finish*: proc (mount: GMount;
        result: GAsyncResult; error: var GError): gboolean {.cdecl.}
    eject_with_operation*: proc (mount: GMount; flags: GMountUnmountFlags;
                                 mount_operation: GMountOperation;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.cdecl.}
    eject_with_operation_finish*: proc (mount: GMount;
        result: GAsyncResult; error: var GError): gboolean {.cdecl.}
    get_default_location*: proc (mount: GMount): GFile {.cdecl.}
    get_sort_key*: proc (mount: GMount): cstring {.cdecl.}
    get_symbolic_icon*: proc (mount: GMount): GIcon {.cdecl.}

proc g_mount_get_type*(): GType {.importc: "g_mount_get_type", libgio.}
proc get_root*(mount: GMount): GFile {.
    importc: "g_mount_get_root", libgio.}
proc root*(mount: GMount): GFile {.
    importc: "g_mount_get_root", libgio.}
proc get_default_location*(mount: GMount): GFile {.
    importc: "g_mount_get_default_location", libgio.}
proc default_location*(mount: GMount): GFile {.
    importc: "g_mount_get_default_location", libgio.}
proc get_name*(mount: GMount): cstring {.
    importc: "g_mount_get_name", libgio.}
proc name*(mount: GMount): cstring {.
    importc: "g_mount_get_name", libgio.}
proc get_icon*(mount: GMount): GIcon {.
    importc: "g_mount_get_icon", libgio.}
proc icon*(mount: GMount): GIcon {.
    importc: "g_mount_get_icon", libgio.}
proc get_symbolic_icon*(mount: GMount): GIcon {.
    importc: "g_mount_get_symbolic_icon", libgio.}
proc symbolic_icon*(mount: GMount): GIcon {.
    importc: "g_mount_get_symbolic_icon", libgio.}
proc get_uuid*(mount: GMount): cstring {.
    importc: "g_mount_get_uuid", libgio.}
proc uuid*(mount: GMount): cstring {.
    importc: "g_mount_get_uuid", libgio.}
proc get_volume*(mount: GMount): GVolume {.
    importc: "g_mount_get_volume", libgio.}
proc volume*(mount: GMount): GVolume {.
    importc: "g_mount_get_volume", libgio.}
proc get_drive*(mount: GMount): GDrive {.
    importc: "g_mount_get_drive", libgio.}
proc drive*(mount: GMount): GDrive {.
    importc: "g_mount_get_drive", libgio.}
proc can_unmount*(mount: GMount): gboolean {.
    importc: "g_mount_can_unmount", libgio.}
proc can_eject*(mount: GMount): gboolean {.
    importc: "g_mount_can_eject", libgio.}
proc unmount*(mount: GMount; flags: GMountUnmountFlags;
                      cancellable: GCancellable;
                      callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_mount_unmount", libgio.}
proc unmount_finish*(mount: GMount; result: GAsyncResult;
                             error: var GError): gboolean {.
    importc: "g_mount_unmount_finish", libgio.}
proc eject*(mount: GMount; flags: GMountUnmountFlags;
                    cancellable: GCancellable;
                    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_mount_eject", libgio.}
proc eject_finish*(mount: GMount; result: GAsyncResult;
                           error: var GError): gboolean {.
    importc: "g_mount_eject_finish", libgio.}
proc remount*(mount: GMount; flags: GMountMountFlags;
                      mount_operation: GMountOperation;
                      cancellable: GCancellable;
                      callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_mount_remount", libgio.}
proc remount_finish*(mount: GMount; result: GAsyncResult;
                             error: var GError): gboolean {.
    importc: "g_mount_remount_finish", libgio.}
proc guess_content_type*(mount: GMount; force_rescan: gboolean;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.
    importc: "g_mount_guess_content_type", libgio.}
proc guess_content_type_finish*(mount: GMount;
    result: GAsyncResult; error: var GError): cstringArray {.
    importc: "g_mount_guess_content_type_finish", libgio.}
proc guess_content_type_sync*(mount: GMount;
                                      force_rescan: gboolean;
                                      cancellable: GCancellable;
                                      error: var GError): cstringArray {.
    importc: "g_mount_guess_content_type_sync", libgio.}
proc is_shadowed*(mount: GMount): gboolean {.
    importc: "g_mount_is_shadowed", libgio.}
proc shadow*(mount: GMount) {.importc: "g_mount_shadow",
    libgio.}
proc unshadow*(mount: GMount) {.importc: "g_mount_unshadow",
    libgio.}
proc unmount_with_operation*(mount: GMount;
                                     flags: GMountUnmountFlags;
                                     mount_operation: GMountOperation;
                                     cancellable: GCancellable;
                                     callback: GAsyncReadyCallback;
                                     user_data: gpointer) {.
    importc: "g_mount_unmount_with_operation", libgio.}
proc unmount_with_operation_finish*(mount: GMount;
    result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_mount_unmount_with_operation_finish", libgio.}
proc eject_with_operation*(mount: GMount;
                                   flags: GMountUnmountFlags;
                                   mount_operation: GMountOperation;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   user_data: gpointer) {.
    importc: "g_mount_eject_with_operation", libgio.}
proc eject_with_operation_finish*(mount: GMount;
    result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_mount_eject_with_operation_finish", libgio.}
proc get_sort_key*(mount: GMount): cstring {.
    importc: "g_mount_get_sort_key", libgio.}
proc sort_key*(mount: GMount): cstring {.
    importc: "g_mount_get_sort_key", libgio.}

template g_mount_operation*(o: expr): expr =
  (g_type_check_instance_cast(o, mount_operation_get_type(), GMountOperationObj))

template g_mount_operation_class*(k: expr): expr =
  (g_type_check_class_cast(k, mount_operation_get_type(), GMountOperationClassObj))

template g_is_mount_operation*(o: expr): expr =
  (g_type_check_instance_type(o, mount_operation_get_type()))

template g_is_mount_operation_class*(k: expr): expr =
  (g_type_check_class_type(k, mount_operation_get_type()))

template g_mount_operation_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, mount_operation_get_type(), GMountOperationClassObj))

type
  GMountOperationClass* =  ptr GMountOperationClassObj
  GMountOperationClassPtr* = ptr GMountOperationClassObj
  GMountOperationClassObj* = object of GObjectClassObj
    ask_password*: proc (op: GMountOperation; message: cstring;
                         default_user: cstring; default_domain: cstring;
                         flags: GAskPasswordFlags) {.cdecl.}
    ask_question*: proc (op: GMountOperation; message: cstring;
                         choices: cstringArray) {.cdecl.}
    reply*: proc (op: GMountOperation; result: GMountOperationResult) {.cdecl.}
    aborted*: proc (op: GMountOperation) {.cdecl.}
    show_processes*: proc (op: GMountOperation; message: cstring;
                           processes: glib.GArray; choices: cstringArray) {.cdecl.}
    show_unmount_progress*: proc (op: GMountOperation; message: cstring;
                                  time_left: gint64; bytes_left: gint64) {.cdecl.}
    g_reserved221: proc () {.cdecl.}
    g_reserved222: proc () {.cdecl.}
    g_reserved223: proc () {.cdecl.}
    g_reserved224: proc () {.cdecl.}
    g_reserved225: proc () {.cdecl.}
    g_reserved226: proc () {.cdecl.}
    g_reserved227: proc () {.cdecl.}
    g_reserved228: proc () {.cdecl.}
    g_reserved229: proc () {.cdecl.}

proc g_mount_operation_get_type*(): GType {.
    importc: "g_mount_operation_get_type", libgio.}
proc g_mount_operation_new*(): GMountOperation {.
    importc: "g_mount_operation_new", libgio.}
proc get_username*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_username", libgio.}
proc username*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_username", libgio.}
proc set_username*(op: GMountOperation;
                                     username: cstring) {.
    importc: "g_mount_operation_set_username", libgio.}
proc `username=`*(op: GMountOperation;
                                     username: cstring) {.
    importc: "g_mount_operation_set_username", libgio.}
proc get_password*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_password", libgio.}
proc password*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_password", libgio.}
proc set_password*(op: GMountOperation;
                                     password: cstring) {.
    importc: "g_mount_operation_set_password", libgio.}
proc `password=`*(op: GMountOperation;
                                     password: cstring) {.
    importc: "g_mount_operation_set_password", libgio.}
proc get_anonymous*(op: GMountOperation): gboolean {.
    importc: "g_mount_operation_get_anonymous", libgio.}
proc anonymous*(op: GMountOperation): gboolean {.
    importc: "g_mount_operation_get_anonymous", libgio.}
proc set_anonymous*(op: GMountOperation;
                                      anonymous: gboolean) {.
    importc: "g_mount_operation_set_anonymous", libgio.}
proc `anonymous=`*(op: GMountOperation;
                                      anonymous: gboolean) {.
    importc: "g_mount_operation_set_anonymous", libgio.}
proc get_domain*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_domain", libgio.}
proc domain*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_domain", libgio.}
proc set_domain*(op: GMountOperation; domain: cstring) {.
    importc: "g_mount_operation_set_domain", libgio.}
proc `domain=`*(op: GMountOperation; domain: cstring) {.
    importc: "g_mount_operation_set_domain", libgio.}
proc get_password_save*(op: GMountOperation): GPasswordSave {.
    importc: "g_mount_operation_get_password_save", libgio.}
proc password_save*(op: GMountOperation): GPasswordSave {.
    importc: "g_mount_operation_get_password_save", libgio.}
proc set_password_save*(op: GMountOperation;
    save: GPasswordSave) {.importc: "g_mount_operation_set_password_save",
                           libgio.}
proc `password_save=`*(op: GMountOperation;
    save: GPasswordSave) {.importc: "g_mount_operation_set_password_save",
                           libgio.}
proc get_choice*(op: GMountOperation): cint {.
    importc: "g_mount_operation_get_choice", libgio.}
proc choice*(op: GMountOperation): cint {.
    importc: "g_mount_operation_get_choice", libgio.}
proc set_choice*(op: GMountOperation; choice: cint) {.
    importc: "g_mount_operation_set_choice", libgio.}
proc `choice=`*(op: GMountOperation; choice: cint) {.
    importc: "g_mount_operation_set_choice", libgio.}
proc reply*(op: GMountOperation;
                              result: GMountOperationResult) {.
    importc: "g_mount_operation_reply", libgio.}

template g_volume_monitor*(o: expr): expr =
  (g_type_check_instance_cast(o, volume_monitor_get_type(), GVolumeMonitorObj))

template g_volume_monitor_class*(k: expr): expr =
  (g_type_check_class_cast(k, volume_monitor_get_type(), GVolumeMonitorClassObj))

template g_volume_monitor_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, volume_monitor_get_type(), GVolumeMonitorClassObj))

template g_is_volume_monitor*(o: expr): expr =
  (g_type_check_instance_type(o, volume_monitor_get_type()))

template g_is_volume_monitor_class*(k: expr): expr =
  (g_type_check_class_type(k, volume_monitor_get_type()))

const
  G_VOLUME_MONITOR_EXTENSION_POINT_NAME* = "gio-volume-monitor"
type
  GVolumeMonitor* =  ptr GVolumeMonitorObj
  GVolumeMonitorPtr* = ptr GVolumeMonitorObj
  GVolumeMonitorObj* = object of GObjectObj
    priv30: gpointer

type
  GVolumeMonitorClass* =  ptr GVolumeMonitorClassObj
  GVolumeMonitorClassPtr* = ptr GVolumeMonitorClassObj
  GVolumeMonitorClassObj* = object of GObjectClassObj
    volume_added*: proc (volume_monitor: GVolumeMonitor;
                         volume: GVolume) {.cdecl.}
    volume_removed*: proc (volume_monitor: GVolumeMonitor;
                           volume: GVolume) {.cdecl.}
    volume_changed*: proc (volume_monitor: GVolumeMonitor;
                           volume: GVolume) {.cdecl.}
    mount_added*: proc (volume_monitor: GVolumeMonitor; mount: GMount) {.cdecl.}
    mount_removed*: proc (volume_monitor: GVolumeMonitor;
                          mount: GMount) {.cdecl.}
    mount_pre_unmount*: proc (volume_monitor: GVolumeMonitor;
                              mount: GMount) {.cdecl.}
    mount_changed*: proc (volume_monitor: GVolumeMonitor;
                          mount: GMount) {.cdecl.}
    drive_connected*: proc (volume_monitor: GVolumeMonitor;
                            drive: GDrive) {.cdecl.}
    drive_disconnected*: proc (volume_monitor: GVolumeMonitor;
                               drive: GDrive) {.cdecl.}
    drive_changed*: proc (volume_monitor: GVolumeMonitor;
                          drive: GDrive) {.cdecl.}
    is_supported*: proc (): gboolean {.cdecl.}
    get_connected_drives*: proc (volume_monitor: GVolumeMonitor): GList {.cdecl.}
    get_volumes*: proc (volume_monitor: GVolumeMonitor): GList {.cdecl.}
    get_mounts*: proc (volume_monitor: GVolumeMonitor): GList {.cdecl.}
    get_volume_for_uuid*: proc (volume_monitor: GVolumeMonitor;
                                uuid: cstring): GVolume {.cdecl.}
    get_mount_for_uuid*: proc (volume_monitor: GVolumeMonitor;
                               uuid: cstring): GMount {.cdecl.}
    adopt_orphan_mount*: proc (mount: GMount;
                               volume_monitor: GVolumeMonitor): GVolume {.cdecl.}
    drive_eject_button*: proc (volume_monitor: GVolumeMonitor;
                               drive: GDrive) {.cdecl.}
    drive_stop_button*: proc (volume_monitor: GVolumeMonitor;
                              drive: GDrive) {.cdecl.}
    g_reserved231: proc () {.cdecl.}
    g_reserved232: proc () {.cdecl.}
    g_reserved233: proc () {.cdecl.}
    g_reserved234: proc () {.cdecl.}
    g_reserved235: proc () {.cdecl.}
    g_reserved236: proc () {.cdecl.}

proc g_volume_monitor_get_type*(): GType {.
    importc: "g_volume_monitor_get_type", libgio.}
proc g_volume_monitor_get*(): GVolumeMonitor {.
    importc: "g_volume_monitor_get", libgio.}
proc get_connected_drives*(volume_monitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_connected_drives", libgio.}
proc connected_drives*(volume_monitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_connected_drives", libgio.}
proc get_volumes*(volume_monitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_volumes", libgio.}
proc volumes*(volume_monitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_volumes", libgio.}
proc get_mounts*(volume_monitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_mounts", libgio.}
proc mounts*(volume_monitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_mounts", libgio.}
proc get_volume_for_uuid*(volume_monitor: GVolumeMonitor;
    uuid: cstring): GVolume {.importc: "g_volume_monitor_get_volume_for_uuid",
                                  libgio.}
proc volume_for_uuid*(volume_monitor: GVolumeMonitor;
    uuid: cstring): GVolume {.importc: "g_volume_monitor_get_volume_for_uuid",
                                  libgio.}
proc get_mount_for_uuid*(volume_monitor: GVolumeMonitor;
    uuid: cstring): GMount {.importc: "g_volume_monitor_get_mount_for_uuid",
                                 libgio.}
proc mount_for_uuid*(volume_monitor: GVolumeMonitor;
    uuid: cstring): GMount {.importc: "g_volume_monitor_get_mount_for_uuid",
                                 libgio.}
proc g_volume_monitor_adopt_orphan_mount*(mount: GMount): GVolume {.
    importc: "g_volume_monitor_adopt_orphan_mount", libgio.}

template g_native_volume_monitor*(o: expr): expr =
  (g_type_check_instance_cast(o, native_volume_monitor_get_type(),
                              GNativeVolumeMonitorObj))

template g_native_volume_monitor_class*(k: expr): expr =
  (g_type_check_class_cast(k, native_volume_monitor_get_type(),
                           GNativeVolumeMonitorClassObj))

template g_is_native_volume_monitor*(o: expr): expr =
  (g_type_check_instance_type(o, native_volume_monitor_get_type()))

template g_is_native_volume_monitor_class*(k: expr): expr =
  (g_type_check_class_type(k, native_volume_monitor_get_type()))

const
  G_NATIVE_VOLUME_MONITOR_EXTENSION_POINT_NAME* = "gio-native-volume-monitor"
type
  GNativeVolumeMonitor* =  ptr GNativeVolumeMonitorObj
  GNativeVolumeMonitorPtr* = ptr GNativeVolumeMonitorObj
  GNativeVolumeMonitorObj*{.final.} = object of GVolumeMonitorObj

type
  GNativeVolumeMonitorClass* =  ptr GNativeVolumeMonitorClassObj
  GNativeVolumeMonitorClassPtr* = ptr GNativeVolumeMonitorClassObj
  GNativeVolumeMonitorClassObj*{.final.} = object of GVolumeMonitorClassObj
    get_mount_for_mount_path*: proc (mount_path: cstring;
                                     cancellable: GCancellable): GMount {.cdecl.}

proc g_native_volume_monitor_get_type*(): GType {.
    importc: "g_native_volume_monitor_get_type", libgio.}

template g_network_address*(o: expr): expr =
  (g_type_check_instance_cast(o, network_address_get_type(), GNetworkAddressObj))

template g_network_address_class*(k: expr): expr =
  (g_type_check_class_cast(k, network_address_get_type(), GNetworkAddressClassObj))

template g_is_network_address*(o: expr): expr =
  (g_type_check_instance_type(o, network_address_get_type()))

template g_is_network_address_class*(k: expr): expr =
  (g_type_check_class_type(k, network_address_get_type()))

template g_network_address_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, network_address_get_type(), GNetworkAddressClassObj))

type
  GNetworkAddressPrivateObj = object
 
type
  GNetworkAddress* =  ptr GNetworkAddressObj
  GNetworkAddressPtr* = ptr GNetworkAddressObj
  GNetworkAddressObj*{.final.} = object of GObjectObj
    priv31: ptr GNetworkAddressPrivateObj

type
  GNetworkAddressClass* =  ptr GNetworkAddressClassObj
  GNetworkAddressClassPtr* = ptr GNetworkAddressClassObj
  GNetworkAddressClassObj*{.final.} = object of GObjectClassObj

proc g_network_address_get_type*(): GType {.
    importc: "g_network_address_get_type", libgio.}
proc g_network_address_new*(hostname: cstring; port: guint16): GSocketConnectable {.
    importc: "g_network_address_new", libgio.}
proc g_network_address_new_loopback*(port: guint16): GSocketConnectable {.
    importc: "g_network_address_new_loopback", libgio.}
proc g_network_address_parse*(host_and_port: cstring; default_port: guint16;
                              error: var GError): GSocketConnectable {.
    importc: "g_network_address_parse", libgio.}
proc g_network_address_parse_uri*(uri: cstring; default_port: guint16;
                                  error: var GError): GSocketConnectable {.
    importc: "g_network_address_parse_uri", libgio.}
proc get_hostname*(`addr`: GNetworkAddress): cstring {.
    importc: "g_network_address_get_hostname", libgio.}
proc hostname*(`addr`: GNetworkAddress): cstring {.
    importc: "g_network_address_get_hostname", libgio.}
proc get_port*(`addr`: GNetworkAddress): guint16 {.
    importc: "g_network_address_get_port", libgio.}
proc port*(`addr`: GNetworkAddress): guint16 {.
    importc: "g_network_address_get_port", libgio.}
proc get_scheme*(`addr`: GNetworkAddress): cstring {.
    importc: "g_network_address_get_scheme", libgio.}
proc scheme*(`addr`: GNetworkAddress): cstring {.
    importc: "g_network_address_get_scheme", libgio.}

const
  G_NETWORK_MONITOR_EXTENSION_POINT_NAME* = "gio-network-monitor"
template g_network_monitor*(o: expr): expr =
  (g_type_check_instance_cast(o, network_monitor_get_type(), GNetworkMonitorObj))

template g_is_network_monitor*(o: expr): expr =
  (g_type_check_instance_type(o, network_monitor_get_type()))

template g_network_monitor_get_interface*(o: expr): expr =
  (g_type_instance_get_interface(o, network_monitor_get_type(),
                                 GNetworkMonitorInterfaceObj))

type
  GNetworkMonitorInterface* =  ptr GNetworkMonitorInterfaceObj
  GNetworkMonitorInterfacePtr* = ptr GNetworkMonitorInterfaceObj
  GNetworkMonitorInterfaceObj*{.final.} = object of GTypeInterfaceObj
    network_changed*: proc (monitor: GNetworkMonitor; available: gboolean) {.cdecl.}
    can_reach*: proc (monitor: GNetworkMonitor;
                      connectable: GSocketConnectable;
                      cancellable: GCancellable; error: var GError): gboolean {.cdecl.}
    can_reach_async*: proc (monitor: GNetworkMonitor;
                            connectable: GSocketConnectable;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    can_reach_finish*: proc (monitor: GNetworkMonitor;
                             result: GAsyncResult; error: var GError): gboolean {.cdecl.}

proc g_network_monitor_get_type*(): GType {.
    importc: "g_network_monitor_get_type", libgio.}
proc g_network_monitor_get_default*(): GNetworkMonitor {.
    importc: "g_network_monitor_get_default", libgio.}
proc get_network_available*(monitor: GNetworkMonitor): gboolean {.
    importc: "g_network_monitor_get_network_available", libgio.}
proc network_available*(monitor: GNetworkMonitor): gboolean {.
    importc: "g_network_monitor_get_network_available", libgio.}
proc get_connectivity*(monitor: GNetworkMonitor): GNetworkConnectivity {.
    importc: "g_network_monitor_get_connectivity", libgio.}
proc connectivity*(monitor: GNetworkMonitor): GNetworkConnectivity {.
    importc: "g_network_monitor_get_connectivity", libgio.}
proc can_reach*(monitor: GNetworkMonitor;
                                  connectable: GSocketConnectable;
                                  cancellable: GCancellable;
                                  error: var GError): gboolean {.
    importc: "g_network_monitor_can_reach", libgio.}
proc can_reach_async*(monitor: GNetworkMonitor;
    connectable: GSocketConnectable; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_network_monitor_can_reach_async", libgio.}
proc can_reach_finish*(monitor: GNetworkMonitor;
    result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_network_monitor_can_reach_finish", libgio.}

template g_network_service*(o: expr): expr =
  (g_type_check_instance_cast(o, network_service_get_type(), GNetworkServiceObj))

template g_network_service_class*(k: expr): expr =
  (g_type_check_class_cast(k, network_service_get_type(), GNetworkServiceClassObj))

template g_is_network_service*(o: expr): expr =
  (g_type_check_instance_type(o, network_service_get_type()))

template g_is_network_service_class*(k: expr): expr =
  (g_type_check_class_type(k, network_service_get_type()))

template g_network_service_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, network_service_get_type(), GNetworkServiceClassObj))

type
  GNetworkServicePrivateObj = object
 
type
  GNetworkService* =  ptr GNetworkServiceObj
  GNetworkServicePtr* = ptr GNetworkServiceObj
  GNetworkServiceObj*{.final.} = object of GObjectObj
    priv32: ptr GNetworkServicePrivateObj

type
  GNetworkServiceClass* =  ptr GNetworkServiceClassObj
  GNetworkServiceClassPtr* = ptr GNetworkServiceClassObj
  GNetworkServiceClassObj*{.final.} = object of GObjectClassObj

proc g_network_service_get_type*(): GType {.
    importc: "g_network_service_get_type", libgio.}
proc g_network_service_new*(service: cstring; protocol: cstring;
                            domain: cstring): GSocketConnectable {.
    importc: "g_network_service_new", libgio.}
proc get_service*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_service", libgio.}
proc service*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_service", libgio.}
proc get_protocol*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_protocol", libgio.}
proc protocol*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_protocol", libgio.}
proc get_domain*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_domain", libgio.}
proc domain*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_domain", libgio.}
proc get_scheme*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_scheme", libgio.}
proc scheme*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_scheme", libgio.}
proc set_scheme*(srv: GNetworkService; scheme: cstring) {.
    importc: "g_network_service_set_scheme", libgio.}
proc `scheme=`*(srv: GNetworkService; scheme: cstring) {.
    importc: "g_network_service_set_scheme", libgio.}

template g_permission*(inst: expr): expr =
  (g_type_check_instance_cast(inst, permission_get_type(), GPermissionObj))

template g_permission_class*(class: expr): expr =
  (g_type_check_class_cast(class, permission_get_type(), GPermissionClassObj))

template g_is_permission*(inst: expr): expr =
  (g_type_check_instance_type(inst, permission_get_type()))

template g_is_permission_class*(class: expr): expr =
  (g_type_check_class_type(class, permission_get_type()))

template g_permission_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, permission_get_type(), GPermissionClassObj))

type
  GPermissionPrivateObj = object
 
type
  GPermission* =  ptr GPermissionObj
  GPermissionPtr* = ptr GPermissionObj
  GPermissionObj*{.final.} = object of GObjectObj
    priv33: ptr GPermissionPrivateObj

type
  GPermissionClass* =  ptr GPermissionClassObj
  GPermissionClassPtr* = ptr GPermissionClassObj
  GPermissionClassObj*{.final.} = object of GObjectClassObj
    acquire*: proc (permission: GPermission;
                    cancellable: GCancellable; error: var GError): gboolean {.cdecl.}
    acquire_async*: proc (permission: GPermission;
                          cancellable: GCancellable;
                          callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    acquire_finish*: proc (permission: GPermission;
                           result: GAsyncResult; error: var GError): gboolean {.cdecl.}
    release*: proc (permission: GPermission;
                    cancellable: GCancellable; error: var GError): gboolean {.cdecl.}
    release_async*: proc (permission: GPermission;
                          cancellable: GCancellable;
                          callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    release_finish*: proc (permission: GPermission;
                           result: GAsyncResult; error: var GError): gboolean {.cdecl.}
    reserved: array[16, gpointer]

proc g_permission_get_type*(): GType {.importc: "g_permission_get_type",
    libgio.}
proc acquire*(permission: GPermission;
                           cancellable: GCancellable;
                           error: var GError): gboolean {.
    importc: "g_permission_acquire", libgio.}
proc acquire_async*(permission: GPermission;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.
    importc: "g_permission_acquire_async", libgio.}
proc acquire_finish*(permission: GPermission;
                                  result: GAsyncResult;
                                  error: var GError): gboolean {.
    importc: "g_permission_acquire_finish", libgio.}
proc release*(permission: GPermission;
                           cancellable: GCancellable;
                           error: var GError): gboolean {.
    importc: "g_permission_release", libgio.}
proc release_async*(permission: GPermission;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.
    importc: "g_permission_release_async", libgio.}
proc release_finish*(permission: GPermission;
                                  result: GAsyncResult;
                                  error: var GError): gboolean {.
    importc: "g_permission_release_finish", libgio.}
proc get_allowed*(permission: GPermission): gboolean {.
    importc: "g_permission_get_allowed", libgio.}
proc allowed*(permission: GPermission): gboolean {.
    importc: "g_permission_get_allowed", libgio.}
proc get_can_acquire*(permission: GPermission): gboolean {.
    importc: "g_permission_get_can_acquire", libgio.}
proc can_acquire*(permission: GPermission): gboolean {.
    importc: "g_permission_get_can_acquire", libgio.}
proc get_can_release*(permission: GPermission): gboolean {.
    importc: "g_permission_get_can_release", libgio.}
proc can_release*(permission: GPermission): gboolean {.
    importc: "g_permission_get_can_release", libgio.}
proc impl_update*(permission: GPermission; allowed: gboolean;
                               can_acquire: gboolean; can_release: gboolean) {.
    importc: "g_permission_impl_update", libgio.}

template g_pollable_input_stream*(obj: expr): expr =
  (g_type_check_instance_cast(obj, pollable_input_stream_get_type(),
                              GPollableInputStreamObj))

template g_is_pollable_input_stream*(obj: expr): expr =
  (g_type_check_instance_type(obj, pollable_input_stream_get_type()))

template g_pollable_input_stream_get_interface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, pollable_input_stream_get_type(),
                                 GPollableInputStreamInterfaceObj))

type
  GPollableInputStreamInterface* =  ptr GPollableInputStreamInterfaceObj
  GPollableInputStreamInterfacePtr* = ptr GPollableInputStreamInterfaceObj
  GPollableInputStreamInterfaceObj*{.final.} = object of GTypeInterfaceObj
    can_poll*: proc (stream: GPollableInputStream): gboolean {.cdecl.}
    is_readable*: proc (stream: GPollableInputStream): gboolean {.cdecl.}
    create_source*: proc (stream: GPollableInputStream;
                          cancellable: GCancellable): glib.GSource {.cdecl.}
    read_nonblocking*: proc (stream: GPollableInputStream;
                             buffer: pointer; count: gsize;
                             error: var GError): gssize {.cdecl.}

proc g_pollable_input_stream_get_type*(): GType {.
    importc: "g_pollable_input_stream_get_type", libgio.}
proc can_poll*(stream: GPollableInputStream): gboolean {.
    importc: "g_pollable_input_stream_can_poll", libgio.}
proc is_readable*(stream: GPollableInputStream): gboolean {.
    importc: "g_pollable_input_stream_is_readable", libgio.}
proc create_source*(stream: GPollableInputStream;
    cancellable: GCancellable): glib.GSource {.
    importc: "g_pollable_input_stream_create_source", libgio.}
proc read_nonblocking*(
    stream: GPollableInputStream; buffer: pointer; count: gsize;
    cancellable: GCancellable; error: var GError): gssize {.
    importc: "g_pollable_input_stream_read_nonblocking", libgio.}

template g_pollable_output_stream*(obj: expr): expr =
  (g_type_check_instance_cast(obj, pollable_output_stream_get_type(),
                              GPollableOutputStreamObj))

template g_is_pollable_output_stream*(obj: expr): expr =
  (g_type_check_instance_type(obj, pollable_output_stream_get_type()))

template g_pollable_output_stream_get_interface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, pollable_output_stream_get_type(),
                                 GPollableOutputStreamInterfaceObj))

type
  GPollableOutputStreamInterface* =  ptr GPollableOutputStreamInterfaceObj
  GPollableOutputStreamInterfacePtr* = ptr GPollableOutputStreamInterfaceObj
  GPollableOutputStreamInterfaceObj*{.final.} = object of GTypeInterfaceObj
    can_poll*: proc (stream: GPollableOutputStream): gboolean {.cdecl.}
    is_writable*: proc (stream: GPollableOutputStream): gboolean {.cdecl.}
    create_source*: proc (stream: GPollableOutputStream;
                          cancellable: GCancellable): glib.GSource {.cdecl.}
    write_nonblocking*: proc (stream: GPollableOutputStream;
                              buffer: pointer; count: gsize;
                              error: var GError): gssize {.cdecl.}

proc g_pollable_output_stream_get_type*(): GType {.
    importc: "g_pollable_output_stream_get_type", libgio.}
proc can_poll*(stream: GPollableOutputStream): gboolean {.
    importc: "g_pollable_output_stream_can_poll", libgio.}
proc is_writable*(stream: GPollableOutputStream): gboolean {.
    importc: "g_pollable_output_stream_is_writable", libgio.}
proc create_source*(
    stream: GPollableOutputStream; cancellable: GCancellable): glib.GSource {.
    importc: "g_pollable_output_stream_create_source", libgio.}
proc write_nonblocking*(
    stream: GPollableOutputStream; buffer: pointer; count: gsize;
    cancellable: GCancellable; error: var GError): gssize {.
    importc: "g_pollable_output_stream_write_nonblocking", libgio.}

proc g_pollable_source_new*(pollable_stream: GObject): glib.GSource {.
    importc: "g_pollable_source_new", libgio.}
proc g_pollable_source_new_full*(pollable_stream: gpointer;
                                 child_source: glib.GSource;
                                 cancellable: GCancellable): glib.GSource {.
    importc: "g_pollable_source_new_full", libgio.}
proc g_pollable_stream_read*(stream: GInputStream; buffer: pointer;
                             count: gsize; blocking: gboolean;
                             cancellable: GCancellable;
                             error: var GError): gssize {.
    importc: "g_pollable_stream_read", libgio.}
proc g_pollable_stream_write*(stream: GOutputStream; buffer: pointer;
                              count: gsize; blocking: gboolean;
                              cancellable: GCancellable;
                              error: var GError): gssize {.
    importc: "g_pollable_stream_write", libgio.}
proc g_pollable_stream_write_all*(stream: GOutputStream; buffer: pointer;
                                  count: gsize; blocking: gboolean;
                                  bytes_written: var gsize;
                                  cancellable: GCancellable;
                                  error: var GError): gboolean {.
    importc: "g_pollable_stream_write_all", libgio.}

template g_property_action*(inst: expr): expr =
  (g_type_check_instance_cast(inst, property_action_get_type(), GPropertyActionObj))

template g_is_property_action*(inst: expr): expr =
  (g_type_check_instance_type(inst, property_action_get_type()))

proc g_property_action_get_type*(): GType {.
    importc: "g_property_action_get_type", libgio.}
proc g_property_action_new*(name: cstring; `object`: gpointer;
                            property_name: cstring): GPropertyAction {.
    importc: "g_property_action_new", libgio.}
type
  GProxyAddressPrivateObj = object
 
type
  GProxyAddress* =  ptr GProxyAddressObj
  GProxyAddressPtr* = ptr GProxyAddressObj
  GProxyAddressObj*{.final.} = object of GInetSocketAddressObj
    priv34: ptr GProxyAddressPrivateObj

template g_proxy*(o: expr): expr =
  (g_type_check_instance_cast(o, proxy_get_type(), GProxyObj))

template g_is_proxy*(o: expr): expr =
  (g_type_check_instance_type(o, proxy_get_type()))

template g_proxy_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, proxy_get_type(), GProxyInterfaceObj))

const
  G_PROXY_EXTENSION_POINT_NAME* = "gio-proxy"
type
  GProxyInterface* =  ptr GProxyInterfaceObj
  GProxyInterfacePtr* = ptr GProxyInterfaceObj
  GProxyInterfaceObj*{.final.} = object of GTypeInterfaceObj
    connect*: proc (proxy: GProxy; connection: GIOStream;
                    proxy_address: GProxyAddress;
                    cancellable: GCancellable; error: var GError): GIOStream {.cdecl.}
    connect_async*: proc (proxy: GProxy; connection: GIOStream;
                          proxy_address: GProxyAddress;
                          cancellable: GCancellable;
                          callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    connect_finish*: proc (proxy: GProxy; result: GAsyncResult;
                           error: var GError): GIOStream {.cdecl.}
    supports_hostname*: proc (proxy: GProxy): gboolean {.cdecl.}

proc g_proxy_get_type*(): GType {.importc: "g_proxy_get_type", libgio.}
proc g_proxy_get_default_for_protocol*(protocol: cstring): GProxy {.
    importc: "g_proxy_get_default_for_protocol", libgio.}
proc connect*(proxy: GProxy; connection: GIOStream;
                      proxy_address: GProxyAddress;
                      cancellable: GCancellable; error: var GError): GIOStream {.
    importc: "g_proxy_connect", libgio.}
proc connect_async*(proxy: GProxy; connection: GIOStream;
                            proxy_address: GProxyAddress;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_proxy_connect_async", libgio.}
proc connect_finish*(proxy: GProxy; result: GAsyncResult;
                             error: var GError): GIOStream {.
    importc: "g_proxy_connect_finish", libgio.}
proc supports_hostname*(proxy: GProxy): gboolean {.
    importc: "g_proxy_supports_hostname", libgio.}

template g_proxy_address*(o: expr): expr =
  (g_type_check_instance_cast(o, proxy_address_get_type(), GProxyAddressObj))

template g_proxy_address_class*(k: expr): expr =
  (g_type_check_class_cast(k, proxy_address_get_type(), GProxyAddressClassObj))

template g_is_proxy_address*(o: expr): expr =
  (g_type_check_instance_type(o, proxy_address_get_type()))

template g_is_proxy_address_class*(k: expr): expr =
  (g_type_check_class_type(k, proxy_address_get_type()))

template g_proxy_address_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, proxy_address_get_type(), GProxyAddressClassObj))

type
  GProxyAddressClass* =  ptr GProxyAddressClassObj
  GProxyAddressClassPtr* = ptr GProxyAddressClassObj
  GProxyAddressClassObj*{.final.} = object of GInetSocketAddressClassObj

proc g_proxy_address_get_type*(): GType {.importc: "g_proxy_address_get_type",
    libgio.}
proc g_proxy_address_new*(inetaddr: GInetAddress; port: guint16;
                          protocol: cstring; dest_hostname: cstring;
                          dest_port: guint16; username: cstring;
                          password: cstring): GSocketAddress {.
    importc: "g_proxy_address_new", libgio.}
proc get_protocol*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_protocol", libgio.}
proc protocol*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_protocol", libgio.}
proc get_destination_protocol*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_destination_protocol", libgio.}
proc destination_protocol*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_destination_protocol", libgio.}
proc get_destination_hostname*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_destination_hostname", libgio.}
proc destination_hostname*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_destination_hostname", libgio.}
proc get_destination_port*(proxy: GProxyAddress): guint16 {.
    importc: "g_proxy_address_get_destination_port", libgio.}
proc destination_port*(proxy: GProxyAddress): guint16 {.
    importc: "g_proxy_address_get_destination_port", libgio.}
proc get_username*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_username", libgio.}
proc username*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_username", libgio.}
proc get_password*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_password", libgio.}
proc password*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_password", libgio.}
proc get_uri*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_uri", libgio.}
proc uri*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_uri", libgio.}

template g_socket_address_enumerator*(o: expr): expr =
  (g_type_check_instance_cast(o, socket_address_enumerator_get_type(),
                              GSocketAddressEnumeratorObj))

template g_socket_address_enumerator_class*(k: expr): expr =
  (g_type_check_class_cast(k, socket_address_enumerator_get_type(),
                           GSocketAddressEnumeratorClassObj))

template g_is_socket_address_enumerator*(o: expr): expr =
  (g_type_check_instance_type(o, socket_address_enumerator_get_type()))

template g_is_socket_address_enumerator_class*(k: expr): expr =
  (g_type_check_class_type(k, socket_address_enumerator_get_type()))

template g_socket_address_enumerator_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, socket_address_enumerator_get_type(),
                             GSocketAddressEnumeratorClassObj))

type
  GSocketAddressEnumerator* =  ptr GSocketAddressEnumeratorObj
  GSocketAddressEnumeratorPtr* = ptr GSocketAddressEnumeratorObj
  GSocketAddressEnumeratorObj* = object of GObjectObj

type
  GSocketAddressEnumeratorClass* =  ptr GSocketAddressEnumeratorClassObj
  GSocketAddressEnumeratorClassPtr* = ptr GSocketAddressEnumeratorClassObj
  GSocketAddressEnumeratorClassObj* = object of GObjectClassObj
    next*: proc (enumerator: GSocketAddressEnumerator;
                 cancellable: GCancellable; error: var GError): GSocketAddress {.cdecl.}
    next_async*: proc (enumerator: GSocketAddressEnumerator;
                       cancellable: GCancellable;
                       callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    next_finish*: proc (enumerator: GSocketAddressEnumerator;
                        result: GAsyncResult; error: var GError): GSocketAddress {.cdecl.}

proc g_socket_address_enumerator_get_type*(): GType {.
    importc: "g_socket_address_enumerator_get_type", libgio.}
proc next*(
    enumerator: GSocketAddressEnumerator; cancellable: GCancellable;
    error: var GError): GSocketAddress {.
    importc: "g_socket_address_enumerator_next", libgio.}
proc next_async*(
    enumerator: GSocketAddressEnumerator; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_socket_address_enumerator_next_async", libgio.}
proc next_finish*(
    enumerator: GSocketAddressEnumerator; result: GAsyncResult;
    error: var GError): GSocketAddress {.
    importc: "g_socket_address_enumerator_next_finish", libgio.}

template g_proxy_address_enumerator*(o: expr): expr =
  (g_type_check_instance_cast(o, proxy_address_enumerator_get_type(),
                              GProxyAddressEnumeratorObj))

template g_proxy_address_enumerator_class*(k: expr): expr =
  (g_type_check_class_cast(k, proxy_address_enumerator_get_type(),
                           GProxyAddressEnumeratorClassObj))

template g_is_proxy_address_enumerator*(o: expr): expr =
  (g_type_check_instance_type(o, proxy_address_enumerator_get_type()))

template g_is_proxy_address_enumerator_class*(k: expr): expr =
  (g_type_check_class_type(k, proxy_address_enumerator_get_type()))

template g_proxy_address_enumerator_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, proxy_address_enumerator_get_type(),
                             GProxyAddressEnumeratorClassObj))

type
  GProxyAddressEnumeratorPrivateObj = object
 
type
  GProxyAddressEnumerator* =  ptr GProxyAddressEnumeratorObj
  GProxyAddressEnumeratorPtr* = ptr GProxyAddressEnumeratorObj
  GProxyAddressEnumeratorObj*{.final.} = object of GSocketAddressEnumeratorObj
    priv35: ptr GProxyAddressEnumeratorPrivateObj

type
  GProxyAddressEnumeratorClass* =  ptr GProxyAddressEnumeratorClassObj
  GProxyAddressEnumeratorClassPtr* = ptr GProxyAddressEnumeratorClassObj
  GProxyAddressEnumeratorClassObj*{.final.} = object of GSocketAddressEnumeratorClassObj
    g_reserved241: proc () {.cdecl.}
    g_reserved242: proc () {.cdecl.}
    g_reserved243: proc () {.cdecl.}
    g_reserved244: proc () {.cdecl.}
    g_reserved245: proc () {.cdecl.}
    g_reserved246: proc () {.cdecl.}
    g_reserved247: proc () {.cdecl.}

proc g_proxy_address_enumerator_get_type*(): GType {.
    importc: "g_proxy_address_enumerator_get_type", libgio.}

template g_proxy_resolver*(o: expr): expr =
  (g_type_check_instance_cast(o, proxy_resolver_get_type(), GProxyResolverObj))

template g_is_proxy_resolver*(o: expr): expr =
  (g_type_check_instance_type(o, proxy_resolver_get_type()))

template g_proxy_resolver_get_iface*(o: expr): expr =
  (g_type_instance_get_interface(o, proxy_resolver_get_type(),
                                 GProxyResolverInterfaceObj))

const
  G_PROXY_RESOLVER_EXTENSION_POINT_NAME* = "gio-proxy-resolver"
type
  GProxyResolverInterface* =  ptr GProxyResolverInterfaceObj
  GProxyResolverInterfacePtr* = ptr GProxyResolverInterfaceObj
  GProxyResolverInterfaceObj*{.final.} = object of GTypeInterfaceObj
    is_supported*: proc (resolver: GProxyResolver): gboolean {.cdecl.}
    lookup*: proc (resolver: GProxyResolver; uri: cstring;
                   cancellable: GCancellable; error: var GError): cstringArray {.cdecl.}
    lookup_async*: proc (resolver: GProxyResolver; uri: cstring;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    lookup_finish*: proc (resolver: GProxyResolver;
                          result: GAsyncResult; error: var GError): cstringArray {.cdecl.}

proc g_proxy_resolver_get_type*(): GType {.
    importc: "g_proxy_resolver_get_type", libgio.}
proc g_proxy_resolver_get_default*(): GProxyResolver {.
    importc: "g_proxy_resolver_get_default", libgio.}
proc is_supported*(resolver: GProxyResolver): gboolean {.
    importc: "g_proxy_resolver_is_supported", libgio.}
proc lookup*(resolver: GProxyResolver; uri: cstring;
                              cancellable: GCancellable;
                              error: var GError): cstringArray {.
    importc: "g_proxy_resolver_lookup", libgio.}
proc lookup_async*(resolver: GProxyResolver;
                                    uri: cstring;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.
    importc: "g_proxy_resolver_lookup_async", libgio.}
proc lookup_finish*(resolver: GProxyResolver;
                                     result: GAsyncResult;
                                     error: var GError): cstringArray {.
    importc: "g_proxy_resolver_lookup_finish", libgio.}

template g_resolver*(o: expr): expr =
  (g_type_check_instance_cast(o, resolver_get_type(), GResolverObj))

template g_resolver_class*(k: expr): expr =
  (g_type_check_class_cast(k, resolver_get_type(), GResolverClassObj))

template g_is_resolver*(o: expr): expr =
  (g_type_check_instance_type(o, resolver_get_type()))

template g_is_resolver_class*(k: expr): expr =
  (g_type_check_class_type(k, resolver_get_type()))

template g_resolver_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, resolver_get_type(), GResolverClassObj))

type
  GResolverPrivateObj = object
 
type
  GResolver* =  ptr GResolverObj
  GResolverPtr* = ptr GResolverObj
  GResolverObj*{.final.} = object of GObjectObj
    priv36: ptr GResolverPrivateObj

type
  GResolverClass* =  ptr GResolverClassObj
  GResolverClassPtr* = ptr GResolverClassObj
  GResolverClassObj*{.final.} = object of GObjectClassObj
    reload*: proc (resolver: GResolver) {.cdecl.}
    lookup_by_name*: proc (resolver: GResolver; hostname: cstring;
                           cancellable: GCancellable;
                           error: var GError): GList {.cdecl.}
    lookup_by_name_async*: proc (resolver: GResolver; hostname: cstring;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.cdecl.}
    lookup_by_name_finish*: proc (resolver: GResolver;
                                  result: GAsyncResult;
                                  error: var GError): GList {.cdecl.}
    lookup_by_address*: proc (resolver: GResolver;
                              address: GInetAddress;
                              cancellable: GCancellable;
                              error: var GError): cstring {.cdecl.}
    lookup_by_address_async*: proc (resolver: GResolver;
                                    address: GInetAddress;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.cdecl.}
    lookup_by_address_finish*: proc (resolver: GResolver;
                                     result: GAsyncResult;
                                     error: var GError): cstring {.cdecl.}
    lookup_service*: proc (resolver: GResolver; rrname: cstring;
                           cancellable: GCancellable;
                           error: var GError): GList {.cdecl.}
    lookup_service_async*: proc (resolver: GResolver; rrname: cstring;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.cdecl.}
    lookup_service_finish*: proc (resolver: GResolver;
                                  result: GAsyncResult;
                                  error: var GError): GList {.cdecl.}
    lookup_records*: proc (resolver: GResolver; rrname: cstring;
                           record_type: GResolverRecordType;
                           cancellable: GCancellable;
                           error: var GError): GList {.cdecl.}
    lookup_records_async*: proc (resolver: GResolver; rrname: cstring;
                                 record_type: GResolverRecordType;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.cdecl.}
    lookup_records_finish*: proc (resolver: GResolver;
                                  result: GAsyncResult;
                                  error: var GError): GList {.cdecl.}
    g_reserved254: proc () {.cdecl.}
    g_reserved255: proc () {.cdecl.}
    g_reserved256: proc () {.cdecl.}

proc g_resolver_get_type*(): GType {.importc: "g_resolver_get_type",
                                     libgio.}
proc g_resolver_get_default*(): GResolver {.
    importc: "g_resolver_get_default", libgio.}
proc set_default*(resolver: GResolver) {.
    importc: "g_resolver_set_default", libgio.}
proc `default=`*(resolver: GResolver) {.
    importc: "g_resolver_set_default", libgio.}
proc lookup_by_name*(resolver: GResolver; hostname: cstring;
                                cancellable: GCancellable;
                                error: var GError): GList {.
    importc: "g_resolver_lookup_by_name", libgio.}
proc lookup_by_name_async*(resolver: GResolver;
                                      hostname: cstring;
                                      cancellable: GCancellable;
                                      callback: GAsyncReadyCallback;
                                      user_data: gpointer) {.
    importc: "g_resolver_lookup_by_name_async", libgio.}
proc lookup_by_name_finish*(resolver: GResolver;
    result: GAsyncResult; error: var GError): GList {.
    importc: "g_resolver_lookup_by_name_finish", libgio.}
proc g_resolver_free_addresses*(addresses: GList) {.
    importc: "g_resolver_free_addresses", libgio.}
proc lookup_by_address*(resolver: GResolver;
                                   address: GInetAddress;
                                   cancellable: GCancellable;
                                   error: var GError): cstring {.
    importc: "g_resolver_lookup_by_address", libgio.}
proc lookup_by_address_async*(resolver: GResolver;
    address: GInetAddress; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_resolver_lookup_by_address_async", libgio.}
proc lookup_by_address_finish*(resolver: GResolver;
    result: GAsyncResult; error: var GError): cstring {.
    importc: "g_resolver_lookup_by_address_finish", libgio.}
proc lookup_service*(resolver: GResolver; service: cstring;
                                protocol: cstring; domain: cstring;
                                cancellable: GCancellable;
                                error: var GError): GList {.
    importc: "g_resolver_lookup_service", libgio.}
proc lookup_service_async*(resolver: GResolver;
                                      service: cstring; protocol: cstring;
                                      domain: cstring;
                                      cancellable: GCancellable;
                                      callback: GAsyncReadyCallback;
                                      user_data: gpointer) {.
    importc: "g_resolver_lookup_service_async", libgio.}
proc lookup_service_finish*(resolver: GResolver;
    result: GAsyncResult; error: var GError): GList {.
    importc: "g_resolver_lookup_service_finish", libgio.}
proc lookup_records*(resolver: GResolver; rrname: cstring;
                                record_type: GResolverRecordType;
                                cancellable: GCancellable;
                                error: var GError): GList {.
    importc: "g_resolver_lookup_records", libgio.}
proc lookup_records_async*(resolver: GResolver;
                                      rrname: cstring;
                                      record_type: GResolverRecordType;
                                      cancellable: GCancellable;
                                      callback: GAsyncReadyCallback;
                                      user_data: gpointer) {.
    importc: "g_resolver_lookup_records_async", libgio.}
proc lookup_records_finish*(resolver: GResolver;
    result: GAsyncResult; error: var GError): GList {.
    importc: "g_resolver_lookup_records_finish", libgio.}
proc g_resolver_free_targets*(targets: GList) {.
    importc: "g_resolver_free_targets", libgio.}
proc g_resolver_error_quark*(): GQuark {.importc: "g_resolver_error_quark",
    libgio.}

proc g_resource_error_quark*(): GQuark {.importc: "g_resource_error_quark",
    libgio.}
type
  GStaticResource* =  ptr GStaticResourceObj
  GStaticResourcePtr* = ptr GStaticResourceObj
  GStaticResourceObj* = object
    data*: ptr guint8
    data_len*: gsize
    resource*: GResource
    next*: GStaticResource
    padding*: gpointer

proc g_resource_get_type*(): GType {.importc: "g_resource_get_type",
                                     libgio.}
proc g_resource_new_from_data*(data: glib.GBytes; error: var GError): GResource {.
    importc: "g_resource_new_from_data", libgio.}
proc `ref`*(resource: GResource): GResource {.
    importc: "g_resource_ref", libgio.}
proc unref*(resource: GResource) {.importc: "g_resource_unref",
    libgio.}
proc g_resource_load*(filename: cstring; error: var GError): GResource {.
    importc: "g_resource_load", libgio.}
proc open_stream*(resource: GResource; path: cstring;
                             lookup_flags: GResourceLookupFlags;
                             error: var GError): GInputStream {.
    importc: "g_resource_open_stream", libgio.}
proc lookup_data*(resource: GResource; path: cstring;
                             lookup_flags: GResourceLookupFlags;
                             error: var GError): glib.GBytes {.
    importc: "g_resource_lookup_data", libgio.}
proc enumerate_children*(resource: GResource; path: cstring;
                                    lookup_flags: GResourceLookupFlags;
                                    error: var GError): cstringArray {.
    importc: "g_resource_enumerate_children", libgio.}
proc get_info*(resource: GResource; path: cstring;
                          lookup_flags: GResourceLookupFlags; size: var gsize;
                          flags: var guint32; error: var GError): gboolean {.
    importc: "g_resource_get_info", libgio.}
proc info*(resource: GResource; path: cstring;
                          lookup_flags: GResourceLookupFlags; size: var gsize;
                          flags: var guint32; error: var GError): gboolean {.
    importc: "g_resource_get_info", libgio.}
proc register*(resource: GResource) {.
    importc: "g_resources_register", libgio.}
proc unregister*(resource: GResource) {.
    importc: "g_resources_unregister", libgio.}
proc g_resources_open_stream*(path: cstring;
                              lookup_flags: GResourceLookupFlags;
                              error: var GError): GInputStream {.
    importc: "g_resources_open_stream", libgio.}
proc g_resources_lookup_data*(path: cstring;
                              lookup_flags: GResourceLookupFlags;
                              error: var GError): glib.GBytes {.
    importc: "g_resources_lookup_data", libgio.}
proc g_resources_enumerate_children*(path: cstring;
                                     lookup_flags: GResourceLookupFlags;
                                     error: var GError): cstringArray {.
    importc: "g_resources_enumerate_children", libgio.}
proc g_resources_get_info*(path: cstring; lookup_flags: GResourceLookupFlags;
                           size: var gsize; flags: var guint32;
                           error: var GError): gboolean {.
    importc: "g_resources_get_info", libgio.}
proc init*(static_resource: GStaticResource) {.
    importc: "g_static_resource_init", libgio.}
proc fini*(static_resource: GStaticResource) {.
    importc: "g_static_resource_fini", libgio.}
proc get_resource*(static_resource: GStaticResource): GResource {.
    importc: "g_static_resource_get_resource", libgio.}
proc resource*(static_resource: GStaticResource): GResource {.
    importc: "g_static_resource_get_resource", libgio.}

template g_seekable*(obj: expr): expr =
  (g_type_check_instance_cast(obj, seekable_get_type(), GSeekableObj))

template g_is_seekable*(obj: expr): expr =
  (g_type_check_instance_type(obj, seekable_get_type()))

template g_seekable_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, seekable_get_type(), GSeekableIfaceObj))

type
  GSeekableIface* =  ptr GSeekableIfaceObj
  GSeekableIfacePtr* = ptr GSeekableIfaceObj
  GSeekableIfaceObj*{.final.} = object of GTypeInterfaceObj
    tell*: proc (seekable: GSeekable): goffset {.cdecl.}
    can_seek*: proc (seekable: GSeekable): gboolean {.cdecl.}
    seek*: proc (seekable: GSeekable; offset: goffset; `type`: GSeekType;
                 cancellable: GCancellable; error: var GError): gboolean {.cdecl.}
    can_truncate*: proc (seekable: GSeekable): gboolean {.cdecl.}
    truncate_fn*: proc (seekable: GSeekable; offset: goffset;
                        cancellable: GCancellable; error: var GError): gboolean {.cdecl.}

proc g_seekable_get_type*(): GType {.importc: "g_seekable_get_type",
                                     libgio.}
proc tell*(seekable: GSeekable): goffset {.
    importc: "g_seekable_tell", libgio.}
proc can_seek*(seekable: GSeekable): gboolean {.
    importc: "g_seekable_can_seek", libgio.}
proc seek*(seekable: GSeekable; offset: goffset;
                      `type`: GSeekType; cancellable: GCancellable;
                      error: var GError): gboolean {.
    importc: "g_seekable_seek", libgio.}
proc can_truncate*(seekable: GSeekable): gboolean {.
    importc: "g_seekable_can_truncate", libgio.}
proc truncate*(seekable: GSeekable; offset: goffset;
                          cancellable: GCancellable; error: var GError): gboolean {.
    importc: "g_seekable_truncate", libgio.}

type
  GSettingsSchemaSource* =  ptr GSettingsSchemaSourceObj
  GSettingsSchemaSourcePtr* = ptr GSettingsSchemaSourceObj
  GSettingsSchemaSourceObj* = object
 
  GSettingsSchema* =  ptr GSettingsSchemaObj
  GSettingsSchemaPtr* = ptr GSettingsSchemaObj
  GSettingsSchemaObj* = object
 
  GSettingsSchemaKey* =  ptr GSettingsSchemaKeyObj
  GSettingsSchemaKeyPtr* = ptr GSettingsSchemaKeyObj
  GSettingsSchemaKeyObj* = object
 
proc g_settings_schema_source_get_type*(): GType {.
    importc: "g_settings_schema_source_get_type", libgio.}
proc g_settings_schema_source_get_default*(): GSettingsSchemaSource {.
    importc: "g_settings_schema_source_get_default", libgio.}
proc `ref`*(source: GSettingsSchemaSource): GSettingsSchemaSource {.
    importc: "g_settings_schema_source_ref", libgio.}
proc unref*(source: GSettingsSchemaSource) {.
    importc: "g_settings_schema_source_unref", libgio.}
proc g_settings_schema_source_new_from_directory*(directory: cstring;
    parent: GSettingsSchemaSource; trusted: gboolean;
    error: var GError): GSettingsSchemaSource {.
    importc: "g_settings_schema_source_new_from_directory", libgio.}
proc lookup*(source: GSettingsSchemaSource;
                                      schema_id: cstring; recursive: gboolean): GSettingsSchema {.
    importc: "g_settings_schema_source_lookup", libgio.}
proc list_schemas*(source: GSettingsSchemaSource;
    recursive: gboolean; non_relocatable: ptr cstringArray;
    relocatable: ptr cstringArray) {.importc: "g_settings_schema_source_list_schemas",
                                     libgio.}
proc g_settings_schema_get_type*(): GType {.
    importc: "g_settings_schema_get_type", libgio.}
proc `ref`*(schema: GSettingsSchema): GSettingsSchema {.
    importc: "g_settings_schema_ref", libgio.}
proc unref*(schema: GSettingsSchema) {.
    importc: "g_settings_schema_unref", libgio.}
proc get_id*(schema: GSettingsSchema): cstring {.
    importc: "g_settings_schema_get_id", libgio.}
proc id*(schema: GSettingsSchema): cstring {.
    importc: "g_settings_schema_get_id", libgio.}
proc get_path*(schema: GSettingsSchema): cstring {.
    importc: "g_settings_schema_get_path", libgio.}
proc path*(schema: GSettingsSchema): cstring {.
    importc: "g_settings_schema_get_path", libgio.}
proc get_key*(schema: GSettingsSchema; name: cstring): GSettingsSchemaKey {.
    importc: "g_settings_schema_get_key", libgio.}
proc key*(schema: GSettingsSchema; name: cstring): GSettingsSchemaKey {.
    importc: "g_settings_schema_get_key", libgio.}
proc has_key*(schema: GSettingsSchema; name: cstring): gboolean {.
    importc: "g_settings_schema_has_key", libgio.}
proc list_children*(schema: GSettingsSchema): cstringArray {.
    importc: "g_settings_schema_list_children", libgio.}
proc g_settings_schema_key_get_type*(): GType {.
    importc: "g_settings_schema_key_get_type", libgio.}
proc `ref`*(key: GSettingsSchemaKey): GSettingsSchemaKey {.
    importc: "g_settings_schema_key_ref", libgio.}
proc unref*(key: GSettingsSchemaKey) {.
    importc: "g_settings_schema_key_unref", libgio.}
proc get_value_type*(key: GSettingsSchemaKey): GVariantType {.
    importc: "g_settings_schema_key_get_value_type", libgio.}
proc value_type*(key: GSettingsSchemaKey): GVariantType {.
    importc: "g_settings_schema_key_get_value_type", libgio.}
proc get_default_value*(key: GSettingsSchemaKey): GVariant {.
    importc: "g_settings_schema_key_get_default_value", libgio.}
proc default_value*(key: GSettingsSchemaKey): GVariant {.
    importc: "g_settings_schema_key_get_default_value", libgio.}
proc get_range*(key: GSettingsSchemaKey): GVariant {.
    importc: "g_settings_schema_key_get_range", libgio.}
proc range*(key: GSettingsSchemaKey): GVariant {.
    importc: "g_settings_schema_key_get_range", libgio.}
proc range_check*(key: GSettingsSchemaKey;
    value: GVariant): gboolean {.importc: "g_settings_schema_key_range_check",
                                     libgio.}
proc get_name*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_name", libgio.}
proc name*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_name", libgio.}
proc get_summary*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_summary", libgio.}
proc summary*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_summary", libgio.}
proc get_description*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_description", libgio.}
proc description*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_description", libgio.}

template g_settings*(inst: expr): expr =
  (g_type_check_instance_cast(inst, settings_get_type(), GSettingsObj))

template g_settings_class*(class: expr): expr =
  (g_type_check_class_cast(class, settings_get_type(), GSettingsClassObj))

template g_is_settings*(inst: expr): expr =
  (g_type_check_instance_type(inst, settings_get_type()))

template g_is_settings_class*(class: expr): expr =
  (g_type_check_class_type(class, settings_get_type()))

template g_settings_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, settings_get_type(), GSettingsClassObj))

type
  GSettingsPrivateObj = object
 
type
  GSettings* =  ptr GSettingsObj
  GSettingsPtr* = ptr GSettingsObj
  GSettingsObj*{.final.} = object of GObjectObj
    priv37: ptr GSettingsPrivateObj
type
  GSettingsClass* =  ptr GSettingsClassObj
  GSettingsClassPtr* = ptr GSettingsClassObj
  GSettingsClassObj*{.final.} = object of GObjectClassObj
    writable_changed*: proc (settings: GSettings; key: cstring) {.cdecl.}
    changed*: proc (settings: GSettings; key: cstring) {.cdecl.}
    writable_change_event*: proc (settings: GSettings; key: GQuark): gboolean {.cdecl.}
    change_event*: proc (settings: GSettings; keys: ptr GQuark;
                         n_keys: gint): gboolean {.cdecl.}
    padding*: array[20, gpointer]

proc g_settings_get_type*(): GType {.importc: "g_settings_get_type",
                                     libgio.}
proc g_settings_list_schemas*(): cstringArray {.
    importc: "g_settings_list_schemas", libgio.}
proc g_settings_list_relocatable_schemas*(): cstringArray {.
    importc: "g_settings_list_relocatable_schemas", libgio.}
proc g_settings_new*(schema_id: cstring): GSettings {.
    importc: "g_settings_new", libgio.}
proc g_settings_new_with_path*(schema_id: cstring; path: cstring): GSettings {.
    importc: "g_settings_new_with_path", libgio.}
proc g_settings_new_with_backend*(schema_id: cstring;
                                  backend: GSettingsBackend): GSettings {.
    importc: "g_settings_new_with_backend", libgio.}
proc g_settings_new_with_backend_and_path*(schema_id: cstring;
    backend: GSettingsBackend; path: cstring): GSettings {.
    importc: "g_settings_new_with_backend_and_path", libgio.}
proc g_settings_new_full*(schema: GSettingsSchema;
                          backend: GSettingsBackend; path: cstring): GSettings {.
    importc: "g_settings_new_full", libgio.}
proc list_children*(settings: GSettings): cstringArray {.
    importc: "g_settings_list_children", libgio.}
proc list_keys*(settings: GSettings): cstringArray {.
    importc: "g_settings_list_keys", libgio.}
proc get_range*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_range", libgio.}
proc range*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_range", libgio.}
proc range_check*(settings: GSettings; key: cstring;
                             value: GVariant): gboolean {.
    importc: "g_settings_range_check", libgio.}
proc set_value*(settings: GSettings; key: cstring;
                           value: GVariant): gboolean {.
    importc: "g_settings_set_value", libgio.}
proc get_value*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_value", libgio.}
proc value*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_value", libgio.}
proc get_user_value*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_user_value", libgio.}
proc user_value*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_user_value", libgio.}
proc get_default_value*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_default_value", libgio.}
proc default_value*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_default_value", libgio.}
proc set*(settings: GSettings; key: cstring; format: cstring): gboolean {.
    varargs, importc: "g_settings_set", libgio.}
proc get*(settings: GSettings; key: cstring; format: cstring) {.
    varargs, importc: "g_settings_get", libgio.}
proc reset*(settings: GSettings; key: cstring) {.
    importc: "g_settings_reset", libgio.}
proc get_int*(settings: GSettings; key: cstring): gint {.
    importc: "g_settings_get_int", libgio.}
proc int*(settings: GSettings; key: cstring): gint {.
    importc: "g_settings_get_int", libgio.}
proc set_int*(settings: GSettings; key: cstring; value: gint): gboolean {.
    importc: "g_settings_set_int", libgio.}
proc get_uint*(settings: GSettings; key: cstring): guint {.
    importc: "g_settings_get_uint", libgio.}
proc uint*(settings: GSettings; key: cstring): guint {.
    importc: "g_settings_get_uint", libgio.}
proc set_uint*(settings: GSettings; key: cstring; value: guint): gboolean {.
    importc: "g_settings_set_uint", libgio.}
proc get_string*(settings: GSettings; key: cstring): cstring {.
    importc: "g_settings_get_string", libgio.}
proc string*(settings: GSettings; key: cstring): cstring {.
    importc: "g_settings_get_string", libgio.}
proc set_string*(settings: GSettings; key: cstring;
                            value: cstring): gboolean {.
    importc: "g_settings_set_string", libgio.}
proc get_boolean*(settings: GSettings; key: cstring): gboolean {.
    importc: "g_settings_get_boolean", libgio.}
proc boolean*(settings: GSettings; key: cstring): gboolean {.
    importc: "g_settings_get_boolean", libgio.}
proc set_boolean*(settings: GSettings; key: cstring;
                             value: gboolean): gboolean {.
    importc: "g_settings_set_boolean", libgio.}
proc get_double*(settings: GSettings; key: cstring): gdouble {.
    importc: "g_settings_get_double", libgio.}
proc double*(settings: GSettings; key: cstring): gdouble {.
    importc: "g_settings_get_double", libgio.}
proc set_double*(settings: GSettings; key: cstring;
                            value: gdouble): gboolean {.
    importc: "g_settings_set_double", libgio.}
proc get_strv*(settings: GSettings; key: cstring): cstringArray {.
    importc: "g_settings_get_strv", libgio.}
proc strv*(settings: GSettings; key: cstring): cstringArray {.
    importc: "g_settings_get_strv", libgio.}
proc set_strv*(settings: GSettings; key: cstring;
                          value: cstringArray): gboolean {.
    importc: "g_settings_set_strv", libgio.}
proc get_enum*(settings: GSettings; key: cstring): gint {.
    importc: "g_settings_get_enum", libgio.}
proc `enum`*(settings: GSettings; key: cstring): gint {.
    importc: "g_settings_get_enum", libgio.}
proc set_enum*(settings: GSettings; key: cstring; value: gint): gboolean {.
    importc: "g_settings_set_enum", libgio.}
proc get_flags*(settings: GSettings; key: cstring): guint {.
    importc: "g_settings_get_flags", libgio.}
proc flags*(settings: GSettings; key: cstring): guint {.
    importc: "g_settings_get_flags", libgio.}
proc set_flags*(settings: GSettings; key: cstring; value: guint): gboolean {.
    importc: "g_settings_set_flags", libgio.}
proc get_child*(settings: GSettings; name: cstring): GSettings {.
    importc: "g_settings_get_child", libgio.}
proc child*(settings: GSettings; name: cstring): GSettings {.
    importc: "g_settings_get_child", libgio.}
proc is_writable*(settings: GSettings; name: cstring): gboolean {.
    importc: "g_settings_is_writable", libgio.}
proc delay*(settings: GSettings) {.importc: "g_settings_delay",
    libgio.}
proc apply*(settings: GSettings) {.importc: "g_settings_apply",
    libgio.}
proc revert*(settings: GSettings) {.
    importc: "g_settings_revert", libgio.}
proc get_has_unapplied*(settings: GSettings): gboolean {.
    importc: "g_settings_get_has_unapplied", libgio.}
proc has_unapplied*(settings: GSettings): gboolean {.
    importc: "g_settings_get_has_unapplied", libgio.}
proc g_settings_sync*() {.importc: "g_settings_sync", libgio.}
type
  GSettingsBindSetMapping* = proc (value: GValue;
                                   expected_type: GVariantType;
                                   user_data: gpointer): GVariant {.cdecl.}
type
  GSettingsBindGetMapping* = proc (value: GValue; variant: GVariant;
                                   user_data: gpointer): gboolean {.cdecl.}
type
  GSettingsGetMapping* = proc (value: GVariant; result: var gpointer;
                               user_data: gpointer): gboolean {.cdecl.}
type
  GSettingsBindFlags* {.size: sizeof(cint), pure.} = enum
    DEFAULT, GET = (1 shl 0),
    SET = (1 shl 1),
    NO_SENSITIVITY = (1 shl 2),
    GET_NO_CHANGES = (1 shl 3),
    INVERT_BOOLEAN = (1 shl 4)
proc `bind`*(settings: GSettings; key: cstring;
                      `object`: gpointer; property: cstring;
                      flags: GSettingsBindFlags) {.importc: "g_settings_bind",
    libgio.}
proc bind_with_mapping*(settings: GSettings; key: cstring;
                                   `object`: gpointer; property: cstring;
                                   flags: GSettingsBindFlags;
                                   get_mapping: GSettingsBindGetMapping;
                                   set_mapping: GSettingsBindSetMapping;
                                   user_data: gpointer;
                                   destroy: GDestroyNotify) {.
    importc: "g_settings_bind_with_mapping", libgio.}
proc bind_writable*(settings: GSettings; key: cstring;
                               `object`: gpointer; property: cstring;
                               inverted: gboolean) {.
    importc: "g_settings_bind_writable", libgio.}
proc g_settings_unbind*(`object`: gpointer; property: cstring) {.
    importc: "g_settings_unbind", libgio.}
proc create_action*(settings: GSettings; key: cstring): GAction {.
    importc: "g_settings_create_action", libgio.}
proc get_mapped*(settings: GSettings; key: cstring;
                            mapping: GSettingsGetMapping; user_data: gpointer): gpointer {.
    importc: "g_settings_get_mapped", libgio.}
proc mapped*(settings: GSettings; key: cstring;
                            mapping: GSettingsGetMapping; user_data: gpointer): gpointer {.
    importc: "g_settings_get_mapped", libgio.}

template g_simple_action*(inst: expr): expr =
  (g_type_check_instance_cast(inst, simple_action_get_type(), GSimpleActionObj))

template g_is_simple_action*(inst: expr): expr =
  (g_type_check_instance_type(inst, simple_action_get_type()))

proc g_simple_action_get_type*(): GType {.importc: "g_simple_action_get_type",
    libgio.}
proc g_simple_action_new*(name: cstring; parameter_type: GVariantType): GSimpleAction {.
    importc: "g_simple_action_new", libgio.}
proc g_simple_action_new_stateful*(name: cstring;
                                   parameter_type: GVariantType;
                                   state: GVariant): GSimpleAction {.
    importc: "g_simple_action_new_stateful", libgio.}
proc set_enabled*(simple: GSimpleAction; enabled: gboolean) {.
    importc: "g_simple_action_set_enabled", libgio.}
proc `enabled=`*(simple: GSimpleAction; enabled: gboolean) {.
    importc: "g_simple_action_set_enabled", libgio.}
proc set_state*(simple: GSimpleAction; value: GVariant) {.
    importc: "g_simple_action_set_state", libgio.}
proc `state=`*(simple: GSimpleAction; value: GVariant) {.
    importc: "g_simple_action_set_state", libgio.}
proc set_state_hint*(simple: GSimpleAction;
                                     state_hint: GVariant) {.
    importc: "g_simple_action_set_state_hint", libgio.}
proc `state_hint=`*(simple: GSimpleAction;
                                     state_hint: GVariant) {.
    importc: "g_simple_action_set_state_hint", libgio.}

template g_simple_action_group*(inst: expr): expr =
  (g_type_check_instance_cast(inst, simple_action_group_get_type(),
                              GSimpleActionGroupObj))

template g_simple_action_group_class*(class: expr): expr =
  (g_type_check_class_cast(class, simple_action_group_get_type(),
                           GSimpleActionGroupClassObj))

template g_is_simple_action_group*(inst: expr): expr =
  (g_type_check_instance_type(inst, simple_action_group_get_type()))

template g_is_simple_action_group_class*(class: expr): expr =
  (g_type_check_class_type(class, simple_action_group_get_type()))

template g_simple_action_group_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, simple_action_group_get_type(),
                             GSimpleActionGroupClassObj))

type
  GSimpleActionGroupPrivateObj = object
 
type
  GSimpleActionGroup* =  ptr GSimpleActionGroupObj
  GSimpleActionGroupPtr* = ptr GSimpleActionGroupObj
  GSimpleActionGroupObj*{.final.} = object of GObjectObj
    priv38: ptr GSimpleActionGroupPrivateObj

type
  GSimpleActionGroupClass* =  ptr GSimpleActionGroupClassObj
  GSimpleActionGroupClassPtr* = ptr GSimpleActionGroupClassObj
  GSimpleActionGroupClassObj*{.final.} = object of GObjectClassObj
    padding*: array[12, gpointer]

proc g_simple_action_group_get_type*(): GType {.
    importc: "g_simple_action_group_get_type", libgio.}
proc g_simple_action_group_new*(): GSimpleActionGroup {.
    importc: "g_simple_action_group_new", libgio.}
proc lookup*(simple: GSimpleActionGroup;
                                   action_name: cstring): GAction {.
    importc: "g_simple_action_group_lookup", libgio.}
proc insert*(simple: GSimpleActionGroup;
                                   action: GAction) {.
    importc: "g_simple_action_group_insert", libgio.}
proc remove*(simple: GSimpleActionGroup;
                                   action_name: cstring) {.
    importc: "g_simple_action_group_remove", libgio.}
proc add_entries*(simple: GSimpleActionGroup;
    entries: GActionEntry; n_entries: gint; user_data: gpointer) {.
    importc: "g_simple_action_group_add_entries", libgio.}

template g_simple_async_result*(o: expr): expr =
  (g_type_check_instance_cast(o, simple_async_result_get_type(),
                              GSimpleAsyncResultObj))

template g_simple_async_result_class*(k: expr): expr =
  (g_type_check_class_cast(k, simple_async_result_get_type(),
                           GSimpleAsyncResultClassObj))

template g_is_simple_async_result*(o: expr): expr =
  (g_type_check_instance_type(o, simple_async_result_get_type()))

template g_is_simple_async_result_class*(k: expr): expr =
  (g_type_check_class_type(k, simple_async_result_get_type()))

template g_simple_async_result_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, simple_async_result_get_type(),
                             GSimpleAsyncResultClassObj))

type
  GSimpleAsyncResultClass* =  ptr GSimpleAsyncResultClassObj
  GSimpleAsyncResultClassPtr* = ptr GSimpleAsyncResultClassObj
  GSimpleAsyncResultClassObj* = object
 
proc g_simple_async_result_get_type*(): GType {.
    importc: "g_simple_async_result_get_type", libgio.}
proc g_simple_async_result_new*(source_object: GObject;
                                callback: GAsyncReadyCallback;
                                user_data: gpointer; source_tag: gpointer): GSimpleAsyncResult {.
    importc: "g_simple_async_result_new", libgio.}
proc g_simple_async_result_new_error*(source_object: GObject;
                                      callback: GAsyncReadyCallback;
                                      user_data: gpointer; domain: GQuark;
                                      code: gint; format: cstring): GSimpleAsyncResult {.
    varargs, importc: "g_simple_async_result_new_error", libgio.}
proc g_simple_async_result_new_from_error*(source_object: GObject;
    callback: GAsyncReadyCallback; user_data: gpointer; error: GError): GSimpleAsyncResult {.
    importc: "g_simple_async_result_new_from_error", libgio.}
proc g_simple_async_result_new_take_error*(source_object: GObject;
    callback: GAsyncReadyCallback; user_data: gpointer; error: GError): GSimpleAsyncResult {.
    importc: "g_simple_async_result_new_take_error", libgio.}
proc set_op_res_gpointer*(
    simple: GSimpleAsyncResult; op_res: gpointer;
    destroy_op_res: GDestroyNotify) {.importc: "g_simple_async_result_set_op_res_gpointer",
                                      libgio.}
proc `op_res_gpointer=`*(
    simple: GSimpleAsyncResult; op_res: gpointer;
    destroy_op_res: GDestroyNotify) {.importc: "g_simple_async_result_set_op_res_gpointer",
                                      libgio.}
proc get_op_res_gpointer*(simple: GSimpleAsyncResult): gpointer {.
    importc: "g_simple_async_result_get_op_res_gpointer", libgio.}
proc op_res_gpointer*(simple: GSimpleAsyncResult): gpointer {.
    importc: "g_simple_async_result_get_op_res_gpointer", libgio.}
proc set_op_res_gssize*(simple: GSimpleAsyncResult;
    op_res: gssize) {.importc: "g_simple_async_result_set_op_res_gssize",
                      libgio.}
proc `op_res_gssize=`*(simple: GSimpleAsyncResult;
    op_res: gssize) {.importc: "g_simple_async_result_set_op_res_gssize",
                      libgio.}
proc get_op_res_gssize*(simple: GSimpleAsyncResult): gssize {.
    importc: "g_simple_async_result_get_op_res_gssize", libgio.}
proc op_res_gssize*(simple: GSimpleAsyncResult): gssize {.
    importc: "g_simple_async_result_get_op_res_gssize", libgio.}
proc set_op_res_gboolean*(
    simple: GSimpleAsyncResult; op_res: gboolean) {.
    importc: "g_simple_async_result_set_op_res_gboolean", libgio.}
proc `op_res_gboolean=`*(
    simple: GSimpleAsyncResult; op_res: gboolean) {.
    importc: "g_simple_async_result_set_op_res_gboolean", libgio.}
proc get_op_res_gboolean*(simple: GSimpleAsyncResult): gboolean {.
    importc: "g_simple_async_result_get_op_res_gboolean", libgio.}
proc op_res_gboolean*(simple: GSimpleAsyncResult): gboolean {.
    importc: "g_simple_async_result_get_op_res_gboolean", libgio.}
proc set_check_cancellable*(
    simple: GSimpleAsyncResult; check_cancellable: GCancellable) {.
    importc: "g_simple_async_result_set_check_cancellable", libgio.}
proc `check_cancellable=`*(
    simple: GSimpleAsyncResult; check_cancellable: GCancellable) {.
    importc: "g_simple_async_result_set_check_cancellable", libgio.}
proc get_source_tag*(simple: GSimpleAsyncResult): gpointer {.
    importc: "g_simple_async_result_get_source_tag", libgio.}
proc source_tag*(simple: GSimpleAsyncResult): gpointer {.
    importc: "g_simple_async_result_get_source_tag", libgio.}
proc set_handle_cancellation*(
    simple: GSimpleAsyncResult; handle_cancellation: gboolean) {.
    importc: "g_simple_async_result_set_handle_cancellation", libgio.}
proc `handle_cancellation=`*(
    simple: GSimpleAsyncResult; handle_cancellation: gboolean) {.
    importc: "g_simple_async_result_set_handle_cancellation", libgio.}
proc complete*(simple: GSimpleAsyncResult) {.
    importc: "g_simple_async_result_complete", libgio.}
proc complete_in_idle*(simple: GSimpleAsyncResult) {.
    importc: "g_simple_async_result_complete_in_idle", libgio.}
proc run_in_thread*(simple: GSimpleAsyncResult;
    `func`: GSimpleAsyncThreadFunc; io_priority: cint;
    cancellable: GCancellable) {.importc: "g_simple_async_result_run_in_thread",
                                     libgio.}
proc set_from_error*(simple: GSimpleAsyncResult;
    error: GError) {.importc: "g_simple_async_result_set_from_error",
                         libgio.}
proc `from_error=`*(simple: GSimpleAsyncResult;
    error: GError) {.importc: "g_simple_async_result_set_from_error",
                         libgio.}
proc take_error*(simple: GSimpleAsyncResult;
    error: GError) {.importc: "g_simple_async_result_take_error",
                         libgio.}
proc propagate_error*(simple: GSimpleAsyncResult;
    dest: var GError): gboolean {.importc: "g_simple_async_result_propagate_error",
                                      libgio.}
proc set_error*(simple: GSimpleAsyncResult;
                                      domain: GQuark; code: gint;
                                      format: cstring) {.varargs,
    importc: "g_simple_async_result_set_error", libgio.}
proc `error=`*(simple: GSimpleAsyncResult;
                                      domain: GQuark; code: gint;
                                      format: cstring) {.varargs,
    importc: "g_simple_async_result_set_error", libgio.}
discard """
proc set_error_va*(simple: GSimpleAsyncResult;
    domain: GQuark; code: gint; format: cstring; args: va_list) {.
    importc: "g_simple_async_result_set_error_va", libgio.}
proc `error_va=`*(simple: GSimpleAsyncResult;
    domain: GQuark; code: gint; format: cstring; args: va_list) {.
    importc: "g_simple_async_result_set_error_va", libgio.}
"""
proc g_simple_async_result_is_valid*(result: GAsyncResult;
                                     source: GObject; source_tag: gpointer): gboolean {.
    importc: "g_simple_async_result_is_valid", libgio.}
proc g_simple_async_report_error_in_idle*(`object`: GObject;
    callback: GAsyncReadyCallback; user_data: gpointer; domain: GQuark;
    code: gint; format: cstring) {.varargs, importc: "g_simple_async_report_error_in_idle",
                                   libgio.}
proc g_simple_async_report_gerror_in_idle*(`object`: GObject;
    callback: GAsyncReadyCallback; user_data: gpointer; error: GError) {.
    importc: "g_simple_async_report_gerror_in_idle", libgio.}
proc g_simple_async_report_take_gerror_in_idle*(`object`: GObject;
    callback: GAsyncReadyCallback; user_data: gpointer; error: GError) {.
    importc: "g_simple_async_report_take_gerror_in_idle", libgio.}

template g_simple_io_stream*(obj: expr): expr =
  (g_type_check_instance_cast(obj, simple_io_stream_get_type(), GSimpleIOStreamObj))

template g_is_simple_io_stream*(obj: expr): expr =
  (g_type_check_instance_type(obj, simple_io_stream_get_type()))

proc g_simple_io_stream_get_type*(): GType {.
    importc: "g_simple_io_stream_get_type", libgio.}
proc g_simple_io_stream_new*(input_stream: GInputStream;
                             output_stream: GOutputStream): GIOStream {.
    importc: "g_simple_io_stream_new", libgio.}

template g_simple_permission*(inst: expr): expr =
  (g_type_check_instance_cast(inst, simple_permission_get_type(),
                              GSimplePermissionObj))

template g_is_simple_permission*(inst: expr): expr =
  (g_type_check_instance_type(inst, simple_permission_get_type()))

proc g_simple_permission_get_type*(): GType {.
    importc: "g_simple_permission_get_type", libgio.}
proc g_simple_permission_new*(allowed: gboolean): GPermission {.
    importc: "g_simple_permission_new", libgio.}

template g_socket_client*(inst: expr): expr =
  (g_type_check_instance_cast(inst, socket_client_get_type(), GSocketClientObj))

template g_socket_client_class*(class: expr): expr =
  (g_type_check_class_cast(class, socket_client_get_type(), GSocketClientClassObj))

template g_is_socket_client*(inst: expr): expr =
  (g_type_check_instance_type(inst, socket_client_get_type()))

template g_is_socket_client_class*(class: expr): expr =
  (g_type_check_class_type(class, socket_client_get_type()))

template g_socket_client_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, socket_client_get_type(), GSocketClientClassObj))

type
  GSocketClientPrivateObj = object
 
type
  GSocketConnectionPrivateObj = object
 
type
  GSocketConnection* =  ptr GSocketConnectionObj
  GSocketConnectionPtr* = ptr GSocketConnectionObj
  GSocketConnectionObj* = object of GIOStreamObj
    priv40: ptr GSocketConnectionPrivateObj
type
  GSocketClient* =  ptr GSocketClientObj
  GSocketClientPtr* = ptr GSocketClientObj
  GSocketClientObj*{.final.} = object of GObjectObj
    priv39: ptr GSocketClientPrivateObj
type
  GSocketClientClass* =  ptr GSocketClientClassObj
  GSocketClientClassPtr* = ptr GSocketClientClassObj
  GSocketClientClassObj*{.final.} = object of GObjectClassObj
    event*: proc (client: GSocketClient; event: GSocketClientEvent;
                  connectable: GSocketConnectable;
                  connection: GIOStream) {.cdecl.}
    g_reserved261: proc () {.cdecl.}
    g_reserved262: proc () {.cdecl.}
    g_reserved263: proc () {.cdecl.}
    g_reserved264: proc () {.cdecl.}

proc g_socket_client_get_type*(): GType {.importc: "g_socket_client_get_type",
    libgio.}
proc g_socket_client_new*(): GSocketClient {.
    importc: "g_socket_client_new", libgio.}
proc get_family*(client: GSocketClient): GSocketFamily {.
    importc: "g_socket_client_get_family", libgio.}
proc family*(client: GSocketClient): GSocketFamily {.
    importc: "g_socket_client_get_family", libgio.}
proc set_family*(client: GSocketClient;
                                 family: GSocketFamily) {.
    importc: "g_socket_client_set_family", libgio.}
proc `family=`*(client: GSocketClient;
                                 family: GSocketFamily) {.
    importc: "g_socket_client_set_family", libgio.}
proc get_socket_type*(client: GSocketClient): GSocketType {.
    importc: "g_socket_client_get_socket_type", libgio.}
proc socket_type*(client: GSocketClient): GSocketType {.
    importc: "g_socket_client_get_socket_type", libgio.}
proc set_socket_type*(client: GSocketClient;
                                      `type`: GSocketType) {.
    importc: "g_socket_client_set_socket_type", libgio.}
proc `socket_type=`*(client: GSocketClient;
                                      `type`: GSocketType) {.
    importc: "g_socket_client_set_socket_type", libgio.}
proc get_protocol*(client: GSocketClient): GSocketProtocol {.
    importc: "g_socket_client_get_protocol", libgio.}
proc protocol*(client: GSocketClient): GSocketProtocol {.
    importc: "g_socket_client_get_protocol", libgio.}
proc set_protocol*(client: GSocketClient;
                                   protocol: GSocketProtocol) {.
    importc: "g_socket_client_set_protocol", libgio.}
proc `protocol=`*(client: GSocketClient;
                                   protocol: GSocketProtocol) {.
    importc: "g_socket_client_set_protocol", libgio.}
proc get_local_address*(client: GSocketClient): GSocketAddress {.
    importc: "g_socket_client_get_local_address", libgio.}
proc local_address*(client: GSocketClient): GSocketAddress {.
    importc: "g_socket_client_get_local_address", libgio.}
proc set_local_address*(client: GSocketClient;
    address: GSocketAddress) {.importc: "g_socket_client_set_local_address",
                                   libgio.}
proc `local_address=`*(client: GSocketClient;
    address: GSocketAddress) {.importc: "g_socket_client_set_local_address",
                                   libgio.}
proc get_timeout*(client: GSocketClient): guint {.
    importc: "g_socket_client_get_timeout", libgio.}
proc timeout*(client: GSocketClient): guint {.
    importc: "g_socket_client_get_timeout", libgio.}
proc set_timeout*(client: GSocketClient; timeout: guint) {.
    importc: "g_socket_client_set_timeout", libgio.}
proc `timeout=`*(client: GSocketClient; timeout: guint) {.
    importc: "g_socket_client_set_timeout", libgio.}
proc get_enable_proxy*(client: GSocketClient): gboolean {.
    importc: "g_socket_client_get_enable_proxy", libgio.}
proc enable_proxy*(client: GSocketClient): gboolean {.
    importc: "g_socket_client_get_enable_proxy", libgio.}
proc set_enable_proxy*(client: GSocketClient;
    enable: gboolean) {.importc: "g_socket_client_set_enable_proxy",
                        libgio.}
proc `enable_proxy=`*(client: GSocketClient;
    enable: gboolean) {.importc: "g_socket_client_set_enable_proxy",
                        libgio.}
proc get_tls*(client: GSocketClient): gboolean {.
    importc: "g_socket_client_get_tls", libgio.}
proc tls*(client: GSocketClient): gboolean {.
    importc: "g_socket_client_get_tls", libgio.}
proc set_tls*(client: GSocketClient; tls: gboolean) {.
    importc: "g_socket_client_set_tls", libgio.}
proc `tls=`*(client: GSocketClient; tls: gboolean) {.
    importc: "g_socket_client_set_tls", libgio.}
proc get_tls_validation_flags*(client: GSocketClient): GTlsCertificateFlags {.
    importc: "g_socket_client_get_tls_validation_flags", libgio.}
proc tls_validation_flags*(client: GSocketClient): GTlsCertificateFlags {.
    importc: "g_socket_client_get_tls_validation_flags", libgio.}
proc set_tls_validation_flags*(client: GSocketClient;
    flags: GTlsCertificateFlags) {.importc: "g_socket_client_set_tls_validation_flags",
                                   libgio.}
proc `tls_validation_flags=`*(client: GSocketClient;
    flags: GTlsCertificateFlags) {.importc: "g_socket_client_set_tls_validation_flags",
                                   libgio.}
proc get_proxy_resolver*(client: GSocketClient): GProxyResolver {.
    importc: "g_socket_client_get_proxy_resolver", libgio.}
proc proxy_resolver*(client: GSocketClient): GProxyResolver {.
    importc: "g_socket_client_get_proxy_resolver", libgio.}
proc set_proxy_resolver*(client: GSocketClient;
    proxy_resolver: GProxyResolver) {.
    importc: "g_socket_client_set_proxy_resolver", libgio.}
proc `proxy_resolver=`*(client: GSocketClient;
    proxy_resolver: GProxyResolver) {.
    importc: "g_socket_client_set_proxy_resolver", libgio.}
proc connect*(client: GSocketClient;
                              connectable: GSocketConnectable;
                              cancellable: GCancellable;
                              error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect", libgio.}
proc connect_to_host*(client: GSocketClient;
                                      host_and_port: cstring;
                                      default_port: guint16;
                                      cancellable: GCancellable;
                                      error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_host", libgio.}
proc connect_to_service*(client: GSocketClient;
    domain: cstring; service: cstring; cancellable: GCancellable;
    error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_service", libgio.}
proc connect_to_uri*(client: GSocketClient; uri: cstring;
                                     default_port: guint16;
                                     cancellable: GCancellable;
                                     error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_uri", libgio.}
proc connect_async*(client: GSocketClient;
                                    connectable: GSocketConnectable;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.
    importc: "g_socket_client_connect_async", libgio.}
proc connect_finish*(client: GSocketClient;
                                     result: GAsyncResult;
                                     error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_finish", libgio.}
proc connect_to_host_async*(client: GSocketClient;
    host_and_port: cstring; default_port: guint16;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_socket_client_connect_to_host_async",
                           libgio.}
proc connect_to_host_finish*(client: GSocketClient;
    result: GAsyncResult; error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_host_finish", libgio.}
proc connect_to_service_async*(client: GSocketClient;
    domain: cstring; service: cstring; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_socket_client_connect_to_service_async", libgio.}
proc connect_to_service_finish*(client: GSocketClient;
    result: GAsyncResult; error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_service_finish", libgio.}
proc connect_to_uri_async*(client: GSocketClient;
    uri: cstring; default_port: guint16; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_socket_client_connect_to_uri_async", libgio.}
proc connect_to_uri_finish*(client: GSocketClient;
    result: GAsyncResult; error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_uri_finish", libgio.}
proc add_application_proxy*(client: GSocketClient;
    protocol: cstring) {.importc: "g_socket_client_add_application_proxy",
                         libgio.}

template g_socket_connectable*(obj: expr): expr =
  (g_type_check_instance_cast(obj, socket_connectable_get_type(),
                              GSocketConnectableObj))

template g_is_socket_connectable*(obj: expr): expr =
  (g_type_check_instance_type(obj, socket_connectable_get_type()))

template g_socket_connectable_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, socket_connectable_get_type(),
                                 GSocketConnectableIfaceObj))

type
  GSocketConnectableIface* =  ptr GSocketConnectableIfaceObj
  GSocketConnectableIfacePtr* = ptr GSocketConnectableIfaceObj
  GSocketConnectableIfaceObj*{.final.} = object of GTypeInterfaceObj
    enumerate*: proc (connectable: GSocketConnectable): GSocketAddressEnumerator {.cdecl.}
    proxy_enumerate*: proc (connectable: GSocketConnectable): GSocketAddressEnumerator {.cdecl.}

proc g_socket_connectable_get_type*(): GType {.
    importc: "g_socket_connectable_get_type", libgio.}
proc enumerate*(connectable: GSocketConnectable): GSocketAddressEnumerator {.
    importc: "g_socket_connectable_enumerate", libgio.}
proc proxy_enumerate*(connectable: GSocketConnectable): GSocketAddressEnumerator {.
    importc: "g_socket_connectable_proxy_enumerate", libgio.}

template g_socket*(inst: expr): expr =
  (g_type_check_instance_cast(inst, socket_get_type(), GSocketObj))

template g_socket_class*(class: expr): expr =
  (g_type_check_class_cast(class, socket_get_type(), GSocketClassObj))

template g_is_socket*(inst: expr): expr =
  (g_type_check_instance_type(inst, socket_get_type()))

template g_is_socket_class*(class: expr): expr =
  (g_type_check_class_type(class, socket_get_type()))

template g_socket_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, socket_get_type(), GSocketClassObj))

 
type
  GSocketClass* =  ptr GSocketClassObj
  GSocketClassPtr* = ptr GSocketClassObj
  GSocketClassObj*{.final.} = object of GObjectClassObj
    g_reserved271: proc () {.cdecl.}
    g_reserved272: proc () {.cdecl.}
    g_reserved273: proc () {.cdecl.}
    g_reserved274: proc () {.cdecl.}
    g_reserved275: proc () {.cdecl.}
    g_reserved276: proc () {.cdecl.}
    g_reserved277: proc () {.cdecl.}
    g_reserved278: proc () {.cdecl.}
    g_reserved279: proc () {.cdecl.}
    g_reserved10: proc () {.cdecl.}

proc g_socket_get_type*(): GType {.importc: "g_socket_get_type", libgio.}
proc g_socket_new*(family: GSocketFamily; `type`: GSocketType;
                   protocol: GSocketProtocol; error: var GError): GSocket {.
    importc: "g_socket_new", libgio.}
proc g_socket_new_from_fd*(fd: gint; error: var GError): GSocket {.
    importc: "g_socket_new_from_fd", libgio.}
proc get_fd*(socket: GSocket): cint {.importc: "g_socket_get_fd",
    libgio.}
proc fd*(socket: GSocket): cint {.importc: "g_socket_get_fd",
    libgio.}
proc get_family*(socket: GSocket): GSocketFamily {.
    importc: "g_socket_get_family", libgio.}
proc family*(socket: GSocket): GSocketFamily {.
    importc: "g_socket_get_family", libgio.}
proc get_socket_type*(socket: GSocket): GSocketType {.
    importc: "g_socket_get_socket_type", libgio.}
proc socket_type*(socket: GSocket): GSocketType {.
    importc: "g_socket_get_socket_type", libgio.}
proc get_protocol*(socket: GSocket): GSocketProtocol {.
    importc: "g_socket_get_protocol", libgio.}
proc protocol*(socket: GSocket): GSocketProtocol {.
    importc: "g_socket_get_protocol", libgio.}
proc get_local_address*(socket: GSocket; error: var GError): GSocketAddress {.
    importc: "g_socket_get_local_address", libgio.}
proc local_address*(socket: GSocket; error: var GError): GSocketAddress {.
    importc: "g_socket_get_local_address", libgio.}
proc get_remote_address*(socket: GSocket; error: var GError): GSocketAddress {.
    importc: "g_socket_get_remote_address", libgio.}
proc remote_address*(socket: GSocket; error: var GError): GSocketAddress {.
    importc: "g_socket_get_remote_address", libgio.}
proc set_blocking*(socket: GSocket; blocking: gboolean) {.
    importc: "g_socket_set_blocking", libgio.}
proc `blocking=`*(socket: GSocket; blocking: gboolean) {.
    importc: "g_socket_set_blocking", libgio.}
proc get_blocking*(socket: GSocket): gboolean {.
    importc: "g_socket_get_blocking", libgio.}
proc blocking*(socket: GSocket): gboolean {.
    importc: "g_socket_get_blocking", libgio.}
proc set_keepalive*(socket: GSocket; keepalive: gboolean) {.
    importc: "g_socket_set_keepalive", libgio.}
proc `keepalive=`*(socket: GSocket; keepalive: gboolean) {.
    importc: "g_socket_set_keepalive", libgio.}
proc get_keepalive*(socket: GSocket): gboolean {.
    importc: "g_socket_get_keepalive", libgio.}
proc keepalive*(socket: GSocket): gboolean {.
    importc: "g_socket_get_keepalive", libgio.}
proc get_listen_backlog*(socket: GSocket): gint {.
    importc: "g_socket_get_listen_backlog", libgio.}
proc listen_backlog*(socket: GSocket): gint {.
    importc: "g_socket_get_listen_backlog", libgio.}
proc set_listen_backlog*(socket: GSocket; backlog: gint) {.
    importc: "g_socket_set_listen_backlog", libgio.}
proc `listen_backlog=`*(socket: GSocket; backlog: gint) {.
    importc: "g_socket_set_listen_backlog", libgio.}
proc get_timeout*(socket: GSocket): guint {.
    importc: "g_socket_get_timeout", libgio.}
proc timeout*(socket: GSocket): guint {.
    importc: "g_socket_get_timeout", libgio.}
proc set_timeout*(socket: GSocket; timeout: guint) {.
    importc: "g_socket_set_timeout", libgio.}
proc `timeout=`*(socket: GSocket; timeout: guint) {.
    importc: "g_socket_set_timeout", libgio.}
proc get_ttl*(socket: GSocket): guint {.
    importc: "g_socket_get_ttl", libgio.}
proc ttl*(socket: GSocket): guint {.
    importc: "g_socket_get_ttl", libgio.}
proc set_ttl*(socket: GSocket; ttl: guint) {.
    importc: "g_socket_set_ttl", libgio.}
proc `ttl=`*(socket: GSocket; ttl: guint) {.
    importc: "g_socket_set_ttl", libgio.}
proc get_broadcast*(socket: GSocket): gboolean {.
    importc: "g_socket_get_broadcast", libgio.}
proc broadcast*(socket: GSocket): gboolean {.
    importc: "g_socket_get_broadcast", libgio.}
proc set_broadcast*(socket: GSocket; broadcast: gboolean) {.
    importc: "g_socket_set_broadcast", libgio.}
proc `broadcast=`*(socket: GSocket; broadcast: gboolean) {.
    importc: "g_socket_set_broadcast", libgio.}
proc get_multicast_loopback*(socket: GSocket): gboolean {.
    importc: "g_socket_get_multicast_loopback", libgio.}
proc multicast_loopback*(socket: GSocket): gboolean {.
    importc: "g_socket_get_multicast_loopback", libgio.}
proc set_multicast_loopback*(socket: GSocket; loopback: gboolean) {.
    importc: "g_socket_set_multicast_loopback", libgio.}
proc `multicast_loopback=`*(socket: GSocket; loopback: gboolean) {.
    importc: "g_socket_set_multicast_loopback", libgio.}
proc get_multicast_ttl*(socket: GSocket): guint {.
    importc: "g_socket_get_multicast_ttl", libgio.}
proc multicast_ttl*(socket: GSocket): guint {.
    importc: "g_socket_get_multicast_ttl", libgio.}
proc set_multicast_ttl*(socket: GSocket; ttl: guint) {.
    importc: "g_socket_set_multicast_ttl", libgio.}
proc `multicast_ttl=`*(socket: GSocket; ttl: guint) {.
    importc: "g_socket_set_multicast_ttl", libgio.}
proc is_connected*(socket: GSocket): gboolean {.
    importc: "g_socket_is_connected", libgio.}
proc `bind`*(socket: GSocket; address: GSocketAddress;
                    allow_reuse: gboolean; error: var GError): gboolean {.
    importc: "g_socket_bind", libgio.}
proc join_multicast_group*(socket: GSocket;
                                    group: GInetAddress;
                                    source_specific: gboolean; iface: cstring;
                                    error: var GError): gboolean {.
    importc: "g_socket_join_multicast_group", libgio.}
proc leave_multicast_group*(socket: GSocket;
                                     group: GInetAddress;
                                     source_specific: gboolean;
                                     iface: cstring; error: var GError): gboolean {.
    importc: "g_socket_leave_multicast_group", libgio.}
proc connect*(socket: GSocket; address: GSocketAddress;
                       cancellable: GCancellable; error: var GError): gboolean {.
    importc: "g_socket_connect", libgio.}
proc check_connect_result*(socket: GSocket; error: var GError): gboolean {.
    importc: "g_socket_check_connect_result", libgio.}
proc get_available_bytes*(socket: GSocket): gssize {.
    importc: "g_socket_get_available_bytes", libgio.}
proc available_bytes*(socket: GSocket): gssize {.
    importc: "g_socket_get_available_bytes", libgio.}
proc condition_check*(socket: GSocket; condition: GIOCondition): GIOCondition {.
    importc: "g_socket_condition_check", libgio.}
proc condition_wait*(socket: GSocket; condition: GIOCondition;
                              cancellable: GCancellable;
                              error: var GError): gboolean {.
    importc: "g_socket_condition_wait", libgio.}
proc condition_timed_wait*(socket: GSocket;
                                    condition: GIOCondition; timeout: gint64;
                                    cancellable: GCancellable;
                                    error: var GError): gboolean {.
    importc: "g_socket_condition_timed_wait", libgio.}
proc accept*(socket: GSocket; cancellable: GCancellable;
                      error: var GError): GSocket {.
    importc: "g_socket_accept", libgio.}
proc listen*(socket: GSocket; error: var GError): gboolean {.
    importc: "g_socket_listen", libgio.}
proc receive*(socket: GSocket; buffer: cstring; size: gsize;
                       cancellable: GCancellable; error: var GError): gssize {.
    importc: "g_socket_receive", libgio.}
proc receive_from*(socket: GSocket;
                            address: var GSocketAddress; buffer: cstring;
                            size: gsize; cancellable: GCancellable;
                            error: var GError): gssize {.
    importc: "g_socket_receive_from", libgio.}
proc send*(socket: GSocket; buffer: cstring; size: gsize;
                    cancellable: GCancellable; error: var GError): gssize {.
    importc: "g_socket_send", libgio.}
proc send_to*(socket: GSocket; address: GSocketAddress;
                       buffer: cstring; size: gsize;
                       cancellable: GCancellable; error: var GError): gssize {.
    importc: "g_socket_send_to", libgio.}
proc receive_message*(socket: GSocket;
                               address: var GSocketAddress;
                               vectors: GInputVector; num_vectors: gint;
                               messages: var ptr GSocketControlMessage;
                               num_messages: var gint; flags: var gint;
                               cancellable: GCancellable;
                               error: var GError): gssize {.
    importc: "g_socket_receive_message", libgio.}
proc send_message*(socket: GSocket; address: GSocketAddress;
                            vectors: GOutputVector; num_vectors: gint;
                            messages: var GSocketControlMessage;
                            num_messages: gint; flags: gint;
                            cancellable: GCancellable;
                            error: var GError): gssize {.
    importc: "g_socket_send_message", libgio.}
proc send_messages*(socket: GSocket;
                             messages: GOutputMessage;
                             num_messages: guint; flags: gint;
                             cancellable: GCancellable;
                             error: var GError): gint {.
    importc: "g_socket_send_messages", libgio.}
proc close*(socket: GSocket; error: var GError): gboolean {.
    importc: "g_socket_close", libgio.}
proc shutdown*(socket: GSocket; shutdown_read: gboolean;
                        shutdown_write: gboolean; error: var GError): gboolean {.
    importc: "g_socket_shutdown", libgio.}
proc is_closed*(socket: GSocket): gboolean {.
    importc: "g_socket_is_closed", libgio.}
proc create_source*(socket: GSocket; condition: GIOCondition;
                             cancellable: GCancellable): glib.GSource {.
    importc: "g_socket_create_source", libgio.}
proc speaks_ipv4*(socket: GSocket): gboolean {.
    importc: "g_socket_speaks_ipv4", libgio.}
proc get_credentials*(socket: GSocket; error: var GError): GCredentials {.
    importc: "g_socket_get_credentials", libgio.}
proc credentials*(socket: GSocket; error: var GError): GCredentials {.
    importc: "g_socket_get_credentials", libgio.}
proc receive_with_blocking*(socket: GSocket; buffer: cstring;
                                     size: gsize; blocking: gboolean;
                                     cancellable: GCancellable;
                                     error: var GError): gssize {.
    importc: "g_socket_receive_with_blocking", libgio.}
proc send_with_blocking*(socket: GSocket; buffer: cstring;
                                  size: gsize; blocking: gboolean;
                                  cancellable: GCancellable;
                                  error: var GError): gssize {.
    importc: "g_socket_send_with_blocking", libgio.}
proc get_option*(socket: GSocket; level: gint; optname: gint;
                          value: var gint; error: var GError): gboolean {.
    importc: "g_socket_get_option", libgio.}
proc option*(socket: GSocket; level: gint; optname: gint;
                          value: var gint; error: var GError): gboolean {.
    importc: "g_socket_get_option", libgio.}
proc set_option*(socket: GSocket; level: gint; optname: gint;
                          value: gint; error: var GError): gboolean {.
    importc: "g_socket_set_option", libgio.}

template g_socket_connection*(inst: expr): expr =
  (g_type_check_instance_cast(inst, socket_connection_get_type(),
                              GSocketConnectionObj))

template g_socket_connection_class*(class: expr): expr =
  (g_type_check_class_cast(class, socket_connection_get_type(),
                           GSocketConnectionClassObj))

template g_is_socket_connection*(inst: expr): expr =
  (g_type_check_instance_type(inst, socket_connection_get_type()))

template g_is_socket_connection_class*(class: expr): expr =
  (g_type_check_class_type(class, socket_connection_get_type()))

template g_socket_connection_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, socket_connection_get_type(),
                             GSocketConnectionClassObj))

type
  GSocketConnectionClass* =  ptr GSocketConnectionClassObj
  GSocketConnectionClassPtr* = ptr GSocketConnectionClassObj
  GSocketConnectionClassObj* = object of GIOStreamClassObj
    g_reserved281: proc () {.cdecl.}
    g_reserved282: proc () {.cdecl.}
    g_reserved283: proc () {.cdecl.}
    g_reserved284: proc () {.cdecl.}
    g_reserved285: proc () {.cdecl.}
    g_reserved286: proc () {.cdecl.}

proc g_socket_connection_get_type*(): GType {.
    importc: "g_socket_connection_get_type", libgio.}
proc is_connected*(connection: GSocketConnection): gboolean {.
    importc: "g_socket_connection_is_connected", libgio.}
proc connect*(connection: GSocketConnection;
                                  address: GSocketAddress;
                                  cancellable: GCancellable;
                                  error: var GError): gboolean {.
    importc: "g_socket_connection_connect", libgio.}
proc connect_async*(connection: GSocketConnection;
    address: GSocketAddress; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_socket_connection_connect_async", libgio.}
proc connect_finish*(connection: GSocketConnection;
    result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_socket_connection_connect_finish", libgio.}
proc get_socket*(connection: GSocketConnection): GSocket {.
    importc: "g_socket_connection_get_socket", libgio.}
proc socket*(connection: GSocketConnection): GSocket {.
    importc: "g_socket_connection_get_socket", libgio.}
proc get_local_address*(connection: GSocketConnection;
    error: var GError): GSocketAddress {.
    importc: "g_socket_connection_get_local_address", libgio.}
proc local_address*(connection: GSocketConnection;
    error: var GError): GSocketAddress {.
    importc: "g_socket_connection_get_local_address", libgio.}
proc get_remote_address*(
    connection: GSocketConnection; error: var GError): GSocketAddress {.
    importc: "g_socket_connection_get_remote_address", libgio.}
proc remote_address*(
    connection: GSocketConnection; error: var GError): GSocketAddress {.
    importc: "g_socket_connection_get_remote_address", libgio.}
proc g_socket_connection_factory_register_type*(g_type: GType;
    family: GSocketFamily; `type`: GSocketType; protocol: gint) {.
    importc: "g_socket_connection_factory_register_type", libgio.}
proc g_socket_connection_factory_lookup_type*(family: GSocketFamily;
    `type`: GSocketType; protocol_id: gint): GType {.
    importc: "g_socket_connection_factory_lookup_type", libgio.}
proc connection_factory_create_connection*(socket: GSocket): GSocketConnection {.
    importc: "g_socket_connection_factory_create_connection", libgio.}

template g_socket_control_message*(inst: expr): expr =
  (g_type_check_instance_cast(inst, socket_control_message_get_type(),
                              GSocketControlMessageObj))

template g_socket_control_message_class*(class: expr): expr =
  (g_type_check_class_cast(class, socket_control_message_get_type(),
                           GSocketControlMessageClassObj))

template g_is_socket_control_message*(inst: expr): expr =
  (g_type_check_instance_type(inst, socket_control_message_get_type()))

template g_is_socket_control_message_class*(class: expr): expr =
  (g_type_check_class_type(class, socket_control_message_get_type()))

template g_socket_control_message_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, socket_control_message_get_type(),
                             GSocketControlMessageClassObj))

type
  GSocketControlMessageClass* =  ptr GSocketControlMessageClassObj
  GSocketControlMessageClassPtr* = ptr GSocketControlMessageClassObj
  GSocketControlMessageClassObj*{.final.} = object of GObjectClassObj
    get_size*: proc (message: GSocketControlMessage): gsize {.cdecl.}
    get_level*: proc (message: GSocketControlMessage): cint {.cdecl.}
    get_type*: proc (message: GSocketControlMessage): cint {.cdecl.}
    serialize*: proc (message: GSocketControlMessage; data: gpointer) {.cdecl.}
    deserialize*: proc (level: cint; `type`: cint; size: gsize; data: gpointer): GSocketControlMessage {.cdecl.}
    g_reserved291: proc () {.cdecl.}
    g_reserved292: proc () {.cdecl.}
    g_reserved293: proc () {.cdecl.}
    g_reserved294: proc () {.cdecl.}
    g_reserved295: proc () {.cdecl.}

proc g_socket_control_message_get_type*(): GType {.
    importc: "g_socket_control_message_get_type", libgio.}
proc get_size*(message: GSocketControlMessage): gsize {.
    importc: "g_socket_control_message_get_size", libgio.}
proc size*(message: GSocketControlMessage): gsize {.
    importc: "g_socket_control_message_get_size", libgio.}
proc get_level*(message: GSocketControlMessage): cint {.
    importc: "g_socket_control_message_get_level", libgio.}
proc level*(message: GSocketControlMessage): cint {.
    importc: "g_socket_control_message_get_level", libgio.}
proc get_msg_type*(message: GSocketControlMessage): cint {.
    importc: "g_socket_control_message_get_msg_type", libgio.}
proc msg_type*(message: GSocketControlMessage): cint {.
    importc: "g_socket_control_message_get_msg_type", libgio.}
proc serialize*(message: GSocketControlMessage;
    data: gpointer) {.importc: "g_socket_control_message_serialize",
                      libgio.}
proc g_socket_control_message_deserialize*(level: cint; `type`: cint;
    size: gsize; data: gpointer): GSocketControlMessage {.
    importc: "g_socket_control_message_deserialize", libgio.}

template g_socket_listener*(inst: expr): expr =
  (g_type_check_instance_cast(inst, socket_listener_get_type(), GSocketListenerObj))

template g_socket_listener_class*(class: expr): expr =
  (g_type_check_class_cast(class, socket_listener_get_type(),
                           GSocketListenerClassObj))

template g_is_socket_listener*(inst: expr): expr =
  (g_type_check_instance_type(inst, socket_listener_get_type()))

template g_is_socket_listener_class*(class: expr): expr =
  (g_type_check_class_type(class, socket_listener_get_type()))

template g_socket_listener_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, socket_listener_get_type(),
                             GSocketListenerClassObj))

type
  GSocketListenerPrivateObj = object
 
type
  GSocketListener* =  ptr GSocketListenerObj
  GSocketListenerPtr* = ptr GSocketListenerObj
  GSocketListenerObj* = object of GObjectObj
    priv41: ptr GSocketListenerPrivateObj
type
  GSocketListenerClass* =  ptr GSocketListenerClassObj
  GSocketListenerClassPtr* = ptr GSocketListenerClassObj
  GSocketListenerClassObj* = object of GObjectClassObj
    changed*: proc (listener: GSocketListener) {.cdecl.}
    g_reserved301: proc () {.cdecl.}
    g_reserved302: proc () {.cdecl.}
    g_reserved303: proc () {.cdecl.}
    g_reserved304: proc () {.cdecl.}
    g_reserved305: proc () {.cdecl.}
    g_reserved306: proc () {.cdecl.}

proc g_socket_listener_get_type*(): GType {.
    importc: "g_socket_listener_get_type", libgio.}
proc g_socket_listener_new*(): GSocketListener {.
    importc: "g_socket_listener_new", libgio.}
proc set_backlog*(listener: GSocketListener;
                                    listen_backlog: cint) {.
    importc: "g_socket_listener_set_backlog", libgio.}
proc `backlog=`*(listener: GSocketListener;
                                    listen_backlog: cint) {.
    importc: "g_socket_listener_set_backlog", libgio.}
proc add_socket*(listener: GSocketListener;
                                   socket: GSocket;
                                   source_object: GObject;
                                   error: var GError): gboolean {.
    importc: "g_socket_listener_add_socket", libgio.}
proc add_address*(listener: GSocketListener;
                                    address: GSocketAddress;
                                    `type`: GSocketType;
                                    protocol: GSocketProtocol;
                                    source_object: GObject;
    effective_address: var GSocketAddress; error: var GError): gboolean {.
    importc: "g_socket_listener_add_address", libgio.}
proc add_inet_port*(listener: GSocketListener;
                                      port: guint16;
                                      source_object: GObject;
                                      error: var GError): gboolean {.
    importc: "g_socket_listener_add_inet_port", libgio.}
proc add_any_inet_port*(listener: GSocketListener;
    source_object: GObject; error: var GError): guint16 {.
    importc: "g_socket_listener_add_any_inet_port", libgio.}
proc accept_socket*(listener: GSocketListener;
                                      source_object: var GObject;
                                      cancellable: GCancellable;
                                      error: var GError): GSocket {.
    importc: "g_socket_listener_accept_socket", libgio.}
proc accept_socket_async*(listener: GSocketListener;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_socket_listener_accept_socket_async",
                           libgio.}
proc accept_socket_finish*(listener: GSocketListener;
    result: GAsyncResult; source_object: var GObject;
    error: var GError): GSocket {.
    importc: "g_socket_listener_accept_socket_finish", libgio.}
proc accept*(listener: GSocketListener;
                               source_object: var GObject;
                               cancellable: GCancellable;
                               error: var GError): GSocketConnection {.
    importc: "g_socket_listener_accept", libgio.}
proc accept_async*(listener: GSocketListener;
                                     cancellable: GCancellable;
                                     callback: GAsyncReadyCallback;
                                     user_data: gpointer) {.
    importc: "g_socket_listener_accept_async", libgio.}
proc accept_finish*(listener: GSocketListener;
                                      result: GAsyncResult;
                                      source_object: var GObject;
                                      error: var GError): GSocketConnection {.
    importc: "g_socket_listener_accept_finish", libgio.}
proc close*(listener: GSocketListener) {.
    importc: "g_socket_listener_close", libgio.}

template g_socket_service*(inst: expr): expr =
  (g_type_check_instance_cast(inst, socket_service_get_type(), GSocketServiceObj))

template g_socket_service_class*(class: expr): expr =
  (g_type_check_class_cast(class, socket_service_get_type(), GSocketServiceClassObj))

template g_is_socket_service*(inst: expr): expr =
  (g_type_check_instance_type(inst, socket_service_get_type()))

template g_is_socket_service_class*(class: expr): expr =
  (g_type_check_class_type(class, socket_service_get_type()))

template g_socket_service_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, socket_service_get_type(),
                             GSocketServiceClassObj))

type
  GSocketServicePrivateObj = object
 
type
  GSocketService* =  ptr GSocketServiceObj
  GSocketServicePtr* = ptr GSocketServiceObj
  GSocketServiceObj* = object of GSocketListenerObj
    priv42: ptr GSocketServicePrivateObj
type
  GSocketServiceClass* =  ptr GSocketServiceClassObj
  GSocketServiceClassPtr* = ptr GSocketServiceClassObj
  GSocketServiceClassObj* = object of GSocketListenerClassObj
    incoming*: proc (service: GSocketService;
                     connection: GSocketConnection;
                     source_object: GObject): gboolean {.cdecl.}
    g_reserved311: proc () {.cdecl.}
    g_reserved312: proc () {.cdecl.}
    g_reserved313: proc () {.cdecl.}
    g_reserved314: proc () {.cdecl.}
    g_reserved315: proc () {.cdecl.}
    g_reserved316: proc () {.cdecl.}

proc g_socket_service_get_type*(): GType {.
    importc: "g_socket_service_get_type", libgio.}
proc g_socket_service_new*(): GSocketService {.
    importc: "g_socket_service_new", libgio.}
proc start*(service: GSocketService) {.
    importc: "g_socket_service_start", libgio.}
proc stop*(service: GSocketService) {.
    importc: "g_socket_service_stop", libgio.}
proc is_active*(service: GSocketService): gboolean {.
    importc: "g_socket_service_is_active", libgio.}

proc g_srv_target_get_type*(): GType {.importc: "g_srv_target_get_type",
    libgio.}
proc g_srv_target_new*(hostname: cstring; port: guint16; priority: guint16;
                       weight: guint16): GSrvTarget {.
    importc: "g_srv_target_new", libgio.}
proc copy*(target: GSrvTarget): GSrvTarget {.
    importc: "g_srv_target_copy", libgio.}
proc free*(target: GSrvTarget) {.
    importc: "g_srv_target_free", libgio.}
proc get_hostname*(target: GSrvTarget): cstring {.
    importc: "g_srv_target_get_hostname", libgio.}
proc hostname*(target: GSrvTarget): cstring {.
    importc: "g_srv_target_get_hostname", libgio.}
proc get_port*(target: GSrvTarget): guint16 {.
    importc: "g_srv_target_get_port", libgio.}
proc port*(target: GSrvTarget): guint16 {.
    importc: "g_srv_target_get_port", libgio.}
proc get_priority*(target: GSrvTarget): guint16 {.
    importc: "g_srv_target_get_priority", libgio.}
proc priority*(target: GSrvTarget): guint16 {.
    importc: "g_srv_target_get_priority", libgio.}
proc get_weight*(target: GSrvTarget): guint16 {.
    importc: "g_srv_target_get_weight", libgio.}
proc weight*(target: GSrvTarget): guint16 {.
    importc: "g_srv_target_get_weight", libgio.}
proc g_srv_target_list_sort*(targets: GList): GList {.
    importc: "g_srv_target_list_sort", libgio.}

template g_simple_proxy_resolver*(o: expr): expr =
  (g_type_check_instance_cast(o, simple_proxy_resolver_get_type(),
                              GSimpleProxyResolverObj))

template g_simple_proxy_resolver_class*(k: expr): expr =
  (g_type_check_class_cast(k, simple_proxy_resolver_get_type(),
                           GSimpleProxyResolverClassObj))

template g_is_simple_proxy_resolver*(o: expr): expr =
  (g_type_check_instance_type(o, simple_proxy_resolver_get_type()))

template g_is_simple_proxy_resolver_class*(k: expr): expr =
  (g_type_check_class_type(k, simple_proxy_resolver_get_type()))

template g_simple_proxy_resolver_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, simple_proxy_resolver_get_type(),
                             GSimpleProxyResolverClassObj))

type
  GSimpleProxyResolverPrivateObj = object
 
type
  GSimpleProxyResolver* =  ptr GSimpleProxyResolverObj
  GSimpleProxyResolverPtr* = ptr GSimpleProxyResolverObj
  GSimpleProxyResolverObj*{.final.} = object of GObjectObj
    priv43: ptr GSimpleProxyResolverPrivateObj

type
  GSimpleProxyResolverClass* =  ptr GSimpleProxyResolverClassObj
  GSimpleProxyResolverClassPtr* = ptr GSimpleProxyResolverClassObj
  GSimpleProxyResolverClassObj*{.final.} = object of GObjectClassObj
    g_reserved321: proc () {.cdecl.}
    g_reserved322: proc () {.cdecl.}
    g_reserved323: proc () {.cdecl.}
    g_reserved324: proc () {.cdecl.}
    g_reserved325: proc () {.cdecl.}

proc g_simple_proxy_resolver_get_type*(): GType {.
    importc: "g_simple_proxy_resolver_get_type", libgio.}
proc g_simple_proxy_resolver_new*(default_proxy: cstring;
                                  ignore_hosts: cstringArray): GProxyResolver {.
    importc: "g_simple_proxy_resolver_new", libgio.}
proc set_default_proxy*(
    resolver: GSimpleProxyResolver; default_proxy: cstring) {.
    importc: "g_simple_proxy_resolver_set_default_proxy", libgio.}
proc `default_proxy=`*(
    resolver: GSimpleProxyResolver; default_proxy: cstring) {.
    importc: "g_simple_proxy_resolver_set_default_proxy", libgio.}
proc set_ignore_hosts*(
    resolver: GSimpleProxyResolver; ignore_hosts: cstringArray) {.
    importc: "g_simple_proxy_resolver_set_ignore_hosts", libgio.}
proc `ignore_hosts=`*(
    resolver: GSimpleProxyResolver; ignore_hosts: cstringArray) {.
    importc: "g_simple_proxy_resolver_set_ignore_hosts", libgio.}
proc set_uri_proxy*(
    resolver: GSimpleProxyResolver; uri_scheme: cstring; proxy: cstring) {.
    importc: "g_simple_proxy_resolver_set_uri_proxy", libgio.}
proc `uri_proxy=`*(
    resolver: GSimpleProxyResolver; uri_scheme: cstring; proxy: cstring) {.
    importc: "g_simple_proxy_resolver_set_uri_proxy", libgio.}

template g_task*(o: expr): expr =
  (g_type_check_instance_cast(o, task_get_type(), GTaskObj))

template g_task_class*(k: expr): expr =
  (g_type_check_class_cast(k, task_get_type(), GTaskClassObj))

template g_is_task*(o: expr): expr =
  (g_type_check_instance_type(o, task_get_type()))

template g_is_task_class*(k: expr): expr =
  (g_type_check_class_type(k, task_get_type()))

template g_task_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, task_get_type(), GTaskClassObj))

type
  GTaskClass* =  ptr GTaskClassObj
  GTaskClassPtr* = ptr GTaskClassObj
  GTaskClassObj* = object
 
proc g_task_get_type*(): GType {.importc: "g_task_get_type", libgio.}
proc g_task_new*(source_object: gpointer; cancellable: GCancellable;
                 callback: GAsyncReadyCallback; callback_data: gpointer): GTask {.
    importc: "g_task_new", libgio.}
proc g_task_report_error*(source_object: gpointer;
                          callback: GAsyncReadyCallback;
                          callback_data: gpointer; source_tag: gpointer;
                          error: GError) {.importc: "g_task_report_error",
    libgio.}
proc g_task_report_new_error*(source_object: gpointer;
                              callback: GAsyncReadyCallback;
                              callback_data: gpointer; source_tag: gpointer;
                              domain: GQuark; code: gint; format: cstring) {.
    varargs, importc: "g_task_report_new_error", libgio.}
proc set_task_data*(task: GTask; task_data: gpointer;
                           task_data_destroy: GDestroyNotify) {.
    importc: "g_task_set_task_data", libgio.}
proc `task_data=`*(task: GTask; task_data: gpointer;
                           task_data_destroy: GDestroyNotify) {.
    importc: "g_task_set_task_data", libgio.}
proc set_priority*(task: GTask; priority: gint) {.
    importc: "g_task_set_priority", libgio.}
proc `priority=`*(task: GTask; priority: gint) {.
    importc: "g_task_set_priority", libgio.}
proc set_check_cancellable*(task: GTask;
                                   check_cancellable: gboolean) {.
    importc: "g_task_set_check_cancellable", libgio.}
proc `check_cancellable=`*(task: GTask;
                                   check_cancellable: gboolean) {.
    importc: "g_task_set_check_cancellable", libgio.}
proc set_source_tag*(task: GTask; source_tag: gpointer) {.
    importc: "g_task_set_source_tag", libgio.}
proc `source_tag=`*(task: GTask; source_tag: gpointer) {.
    importc: "g_task_set_source_tag", libgio.}
proc get_source_object*(task: GTask): gpointer {.
    importc: "g_task_get_source_object", libgio.}
proc source_object*(task: GTask): gpointer {.
    importc: "g_task_get_source_object", libgio.}
proc get_task_data*(task: GTask): gpointer {.
    importc: "g_task_get_task_data", libgio.}
proc task_data*(task: GTask): gpointer {.
    importc: "g_task_get_task_data", libgio.}
proc get_priority*(task: GTask): gint {.
    importc: "g_task_get_priority", libgio.}
proc priority*(task: GTask): gint {.
    importc: "g_task_get_priority", libgio.}
proc get_context*(task: GTask): glib.GMainContext {.
    importc: "g_task_get_context", libgio.}
proc context*(task: GTask): glib.GMainContext {.
    importc: "g_task_get_context", libgio.}
proc get_cancellable*(task: GTask): GCancellable {.
    importc: "g_task_get_cancellable", libgio.}
proc cancellable*(task: GTask): GCancellable {.
    importc: "g_task_get_cancellable", libgio.}
proc get_check_cancellable*(task: GTask): gboolean {.
    importc: "g_task_get_check_cancellable", libgio.}
proc check_cancellable*(task: GTask): gboolean {.
    importc: "g_task_get_check_cancellable", libgio.}
proc get_source_tag*(task: GTask): gpointer {.
    importc: "g_task_get_source_tag", libgio.}
proc source_tag*(task: GTask): gpointer {.
    importc: "g_task_get_source_tag", libgio.}
proc g_task_is_valid*(result: gpointer; source_object: gpointer): gboolean {.
    importc: "g_task_is_valid", libgio.}
type
  GTaskThreadFunc* = proc (task: GTask; source_object: gpointer;
                           task_data: gpointer; cancellable: GCancellable) {.cdecl.}
proc run_in_thread*(task: GTask; task_func: GTaskThreadFunc) {.
    importc: "g_task_run_in_thread", libgio.}
proc run_in_thread_sync*(task: GTask; task_func: GTaskThreadFunc) {.
    importc: "g_task_run_in_thread_sync", libgio.}
proc set_return_on_cancel*(task: GTask; return_on_cancel: gboolean): gboolean {.
    importc: "g_task_set_return_on_cancel", libgio.}
proc get_return_on_cancel*(task: GTask): gboolean {.
    importc: "g_task_get_return_on_cancel", libgio.}
proc return_on_cancel*(task: GTask): gboolean {.
    importc: "g_task_get_return_on_cancel", libgio.}
proc attach_source*(task: GTask; source: glib.GSource;
                           callback: GSourceFunc) {.
    importc: "g_task_attach_source", libgio.}
proc return_pointer*(task: GTask; result: gpointer;
                            result_destroy: GDestroyNotify) {.
    importc: "g_task_return_pointer", libgio.}
proc return_boolean*(task: GTask; result: gboolean) {.
    importc: "g_task_return_boolean", libgio.}
proc return_int*(task: GTask; result: gssize) {.
    importc: "g_task_return_int", libgio.}
proc return_error*(task: GTask; error: GError) {.
    importc: "g_task_return_error", libgio.}
proc return_new_error*(task: GTask; domain: GQuark; code: gint;
                              format: cstring) {.varargs,
    importc: "g_task_return_new_error", libgio.}
proc return_error_if_cancelled*(task: GTask): gboolean {.
    importc: "g_task_return_error_if_cancelled", libgio.}
proc propagate_pointer*(task: GTask; error: var GError): gpointer {.
    importc: "g_task_propagate_pointer", libgio.}
proc propagate_boolean*(task: GTask; error: var GError): gboolean {.
    importc: "g_task_propagate_boolean", libgio.}
proc propagate_int*(task: GTask; error: var GError): gssize {.
    importc: "g_task_propagate_int", libgio.}
proc had_error*(task: GTask): gboolean {.
    importc: "g_task_had_error", libgio.}

template g_subprocess*(o: expr): expr =
  (g_type_check_instance_cast(o, subprocess_get_type(), GSubprocessObj))

template g_is_subprocess*(o: expr): expr =
  (g_type_check_instance_type(o, subprocess_get_type()))

proc g_subprocess_get_type*(): GType {.importc: "g_subprocess_get_type",
    libgio.}
proc g_subprocess_new*(flags: GSubprocessFlags; error: var GError;
                       argv0: cstring): GSubprocess {.varargs,
    importc: "g_subprocess_new", libgio.}
proc g_subprocess_newv*(argv: cstringArray; flags: GSubprocessFlags;
                        error: var GError): GSubprocess {.
    importc: "g_subprocess_newv", libgio.}
proc get_stdin_pipe*(subprocess: GSubprocess): GOutputStream {.
    importc: "g_subprocess_get_stdin_pipe", libgio.}
proc stdin_pipe*(subprocess: GSubprocess): GOutputStream {.
    importc: "g_subprocess_get_stdin_pipe", libgio.}
proc get_stdout_pipe*(subprocess: GSubprocess): GInputStream {.
    importc: "g_subprocess_get_stdout_pipe", libgio.}
proc stdout_pipe*(subprocess: GSubprocess): GInputStream {.
    importc: "g_subprocess_get_stdout_pipe", libgio.}
proc get_stderr_pipe*(subprocess: GSubprocess): GInputStream {.
    importc: "g_subprocess_get_stderr_pipe", libgio.}
proc stderr_pipe*(subprocess: GSubprocess): GInputStream {.
    importc: "g_subprocess_get_stderr_pipe", libgio.}
proc get_identifier*(subprocess: GSubprocess): cstring {.
    importc: "g_subprocess_get_identifier", libgio.}
proc identifier*(subprocess: GSubprocess): cstring {.
    importc: "g_subprocess_get_identifier", libgio.}
when defined(unix):
  proc send_signal*(subprocess: GSubprocess; signal_num: gint) {.
      importc: "g_subprocess_send_signal", libgio.}
proc force_exit*(subprocess: GSubprocess) {.
    importc: "g_subprocess_force_exit", libgio.}
proc wait*(subprocess: GSubprocess;
                        cancellable: GCancellable; error: var GError): gboolean {.
    importc: "g_subprocess_wait", libgio.}
proc wait_async*(subprocess: GSubprocess;
                              cancellable: GCancellable;
                              callback: GAsyncReadyCallback;
                              user_data: gpointer) {.
    importc: "g_subprocess_wait_async", libgio.}
proc wait_finish*(subprocess: GSubprocess;
                               result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_subprocess_wait_finish", libgio.}
proc wait_check*(subprocess: GSubprocess;
                              cancellable: GCancellable;
                              error: var GError): gboolean {.
    importc: "g_subprocess_wait_check", libgio.}
proc wait_check_async*(subprocess: GSubprocess;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.
    importc: "g_subprocess_wait_check_async", libgio.}
proc wait_check_finish*(subprocess: GSubprocess;
                                     result: GAsyncResult;
                                     error: var GError): gboolean {.
    importc: "g_subprocess_wait_check_finish", libgio.}
proc get_status*(subprocess: GSubprocess): gint {.
    importc: "g_subprocess_get_status", libgio.}
proc status*(subprocess: GSubprocess): gint {.
    importc: "g_subprocess_get_status", libgio.}
proc get_successful*(subprocess: GSubprocess): gboolean {.
    importc: "g_subprocess_get_successful", libgio.}
proc successful*(subprocess: GSubprocess): gboolean {.
    importc: "g_subprocess_get_successful", libgio.}
proc get_if_exited*(subprocess: GSubprocess): gboolean {.
    importc: "g_subprocess_get_if_exited", libgio.}
proc if_exited*(subprocess: GSubprocess): gboolean {.
    importc: "g_subprocess_get_if_exited", libgio.}
proc get_exit_status*(subprocess: GSubprocess): gint {.
    importc: "g_subprocess_get_exit_status", libgio.}
proc exit_status*(subprocess: GSubprocess): gint {.
    importc: "g_subprocess_get_exit_status", libgio.}
proc get_if_signaled*(subprocess: GSubprocess): gboolean {.
    importc: "g_subprocess_get_if_signaled", libgio.}
proc if_signaled*(subprocess: GSubprocess): gboolean {.
    importc: "g_subprocess_get_if_signaled", libgio.}
proc get_term_sig*(subprocess: GSubprocess): gint {.
    importc: "g_subprocess_get_term_sig", libgio.}
proc term_sig*(subprocess: GSubprocess): gint {.
    importc: "g_subprocess_get_term_sig", libgio.}
proc communicate*(subprocess: GSubprocess;
                               stdin_buf: glib.GBytes;
                               cancellable: GCancellable;
                               stdout_buf: var glib.GBytes;
                               stderr_buf: var glib.GBytes;
                               error: var GError): gboolean {.
    importc: "g_subprocess_communicate", libgio.}
proc communicate_async*(subprocess: GSubprocess;
                                     stdin_buf: glib.GBytes;
                                     cancellable: GCancellable;
                                     callback: GAsyncReadyCallback;
                                     user_data: gpointer) {.
    importc: "g_subprocess_communicate_async", libgio.}
proc communicate_finish*(subprocess: GSubprocess;
                                      result: GAsyncResult;
                                      stdout_buf: var glib.GBytes;
                                      stderr_buf: var glib.GBytes;
                                      error: var GError): gboolean {.
    importc: "g_subprocess_communicate_finish", libgio.}
proc communicate_utf8*(subprocess: GSubprocess;
                                    stdin_buf: cstring;
                                    cancellable: GCancellable;
                                    stdout_buf: cstringArray;
                                    stderr_buf: cstringArray;
                                    error: var GError): gboolean {.
    importc: "g_subprocess_communicate_utf8", libgio.}
proc communicate_utf8_async*(subprocess: GSubprocess;
    stdin_buf: cstring; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_subprocess_communicate_utf8_async", libgio.}
proc communicate_utf8_finish*(subprocess: GSubprocess;
    result: GAsyncResult; stdout_buf: cstringArray;
    stderr_buf: cstringArray; error: var GError): gboolean {.
    importc: "g_subprocess_communicate_utf8_finish", libgio.}

template g_subprocess_launcher*(o: expr): expr =
  (g_type_check_instance_cast(o, subprocess_launcher_get_type(),
                              GSubprocessLauncherObj))

template g_is_subprocess_launcher*(o: expr): expr =
  (g_type_check_instance_type(o, subprocess_launcher_get_type()))

proc g_subprocess_launcher_get_type*(): GType {.
    importc: "g_subprocess_launcher_get_type", libgio.}
proc g_subprocess_launcher_new*(flags: GSubprocessFlags): GSubprocessLauncher {.
    importc: "g_subprocess_launcher_new", libgio.}
proc spawn*(self: GSubprocessLauncher;
                                  error: var GError; argv0: cstring): GSubprocess {.
    varargs, importc: "g_subprocess_launcher_spawn", libgio.}
proc spawnv*(self: GSubprocessLauncher;
                                   argv: cstringArray; error: var GError): GSubprocess {.
    importc: "g_subprocess_launcher_spawnv", libgio.}
proc set_environ*(self: GSubprocessLauncher;
    env: cstringArray) {.importc: "g_subprocess_launcher_set_environ",
                         libgio.}
proc `environ=`*(self: GSubprocessLauncher;
    env: cstringArray) {.importc: "g_subprocess_launcher_set_environ",
                         libgio.}
proc setenv*(self: GSubprocessLauncher;
                                   variable: cstring; value: cstring;
                                   overwrite: gboolean) {.
    importc: "g_subprocess_launcher_setenv", libgio.}
proc unsetenv*(self: GSubprocessLauncher;
                                     variable: cstring) {.
    importc: "g_subprocess_launcher_unsetenv", libgio.}
proc getenv*(self: GSubprocessLauncher;
                                   variable: cstring): cstring {.
    importc: "g_subprocess_launcher_getenv", libgio.}
proc set_cwd*(self: GSubprocessLauncher;
                                    cwd: cstring) {.
    importc: "g_subprocess_launcher_set_cwd", libgio.}
proc `cwd=`*(self: GSubprocessLauncher;
                                    cwd: cstring) {.
    importc: "g_subprocess_launcher_set_cwd", libgio.}
proc set_flags*(self: GSubprocessLauncher;
                                      flags: GSubprocessFlags) {.
    importc: "g_subprocess_launcher_set_flags", libgio.}
proc `flags=`*(self: GSubprocessLauncher;
                                      flags: GSubprocessFlags) {.
    importc: "g_subprocess_launcher_set_flags", libgio.}
when defined(unix):
  proc set_stdin_file_path*(
      self: GSubprocessLauncher; path: cstring) {.
      importc: "g_subprocess_launcher_set_stdin_file_path", libgio.}
  proc `stdin_file_path=`*(
      self: GSubprocessLauncher; path: cstring) {.
      importc: "g_subprocess_launcher_set_stdin_file_path", libgio.}
  proc take_stdin_fd*(self: GSubprocessLauncher;
      fd: gint) {.importc: "g_subprocess_launcher_take_stdin_fd", libgio.}
  proc set_stdout_file_path*(
      self: GSubprocessLauncher; path: cstring) {.
      importc: "g_subprocess_launcher_set_stdout_file_path", libgio.}
  proc `stdout_file_path=`*(
      self: GSubprocessLauncher; path: cstring) {.
      importc: "g_subprocess_launcher_set_stdout_file_path", libgio.}
  proc take_stdout_fd*(self: GSubprocessLauncher;
      fd: gint) {.importc: "g_subprocess_launcher_take_stdout_fd", libgio.}
  proc set_stderr_file_path*(
      self: GSubprocessLauncher; path: cstring) {.
      importc: "g_subprocess_launcher_set_stderr_file_path", libgio.}
  proc `stderr_file_path=`*(
      self: GSubprocessLauncher; path: cstring) {.
      importc: "g_subprocess_launcher_set_stderr_file_path", libgio.}
  proc take_stderr_fd*(self: GSubprocessLauncher;
      fd: gint) {.importc: "g_subprocess_launcher_take_stderr_fd", libgio.}
  proc take_fd*(self: GSubprocessLauncher;
                                      source_fd: gint; target_fd: gint) {.
      importc: "g_subprocess_launcher_take_fd", libgio.}
  proc set_child_setup*(self: GSubprocessLauncher;
      child_setup: GSpawnChildSetupFunc; user_data: gpointer;
      destroy_notify: GDestroyNotify) {.
      importc: "g_subprocess_launcher_set_child_setup", libgio.}
  proc `child_setup=`*(self: GSubprocessLauncher;
      child_setup: GSpawnChildSetupFunc; user_data: gpointer;
      destroy_notify: GDestroyNotify) {.
      importc: "g_subprocess_launcher_set_child_setup", libgio.}

template g_tcp_connection*(inst: expr): expr =
  (g_type_check_instance_cast(inst, tcp_connection_get_type(), GTcpConnectionObj))

template g_tcp_connection_class*(class: expr): expr =
  (g_type_check_class_cast(class, tcp_connection_get_type(), GTcpConnectionClassObj))

template g_is_tcp_connection*(inst: expr): expr =
  (g_type_check_instance_type(inst, tcp_connection_get_type()))

template g_is_tcp_connection_class*(class: expr): expr =
  (g_type_check_class_type(class, tcp_connection_get_type()))

template g_tcp_connection_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, tcp_connection_get_type(),
                             GTcpConnectionClassObj))

type
  GTcpConnectionPrivateObj = object
 
type
  GTcpConnectionClass* =  ptr GTcpConnectionClassObj
  GTcpConnectionClassPtr* = ptr GTcpConnectionClassObj
  GTcpConnectionClassObj* = object of GSocketConnectionClassObj

type
  GTcpConnection* =  ptr GTcpConnectionObj
  GTcpConnectionPtr* = ptr GTcpConnectionObj
  GTcpConnectionObj* = object of GSocketConnectionObj
    priv44: ptr GTcpConnectionPrivateObj

proc g_tcp_connection_get_type*(): GType {.
    importc: "g_tcp_connection_get_type", libgio.}
proc set_graceful_disconnect*(connection: GTcpConnection;
    graceful_disconnect: gboolean) {.importc: "g_tcp_connection_set_graceful_disconnect",
                                     libgio.}
proc `graceful_disconnect=`*(connection: GTcpConnection;
    graceful_disconnect: gboolean) {.importc: "g_tcp_connection_set_graceful_disconnect",
                                     libgio.}
proc get_graceful_disconnect*(connection: GTcpConnection): gboolean {.
    importc: "g_tcp_connection_get_graceful_disconnect", libgio.}
proc graceful_disconnect*(connection: GTcpConnection): gboolean {.
    importc: "g_tcp_connection_get_graceful_disconnect", libgio.}

template g_tcp_wrapper_connection*(inst: expr): expr =
  (g_type_check_instance_cast(inst, tcp_wrapper_connection_get_type(),
                              GTcpWrapperConnectionObj))

template g_tcp_wrapper_connection_class*(class: expr): expr =
  (g_type_check_class_cast(class, tcp_wrapper_connection_get_type(),
                           GTcpWrapperConnectionClassObj))

template g_is_tcp_wrapper_connection*(inst: expr): expr =
  (g_type_check_instance_type(inst, tcp_wrapper_connection_get_type()))

template g_is_tcp_wrapper_connection_class*(class: expr): expr =
  (g_type_check_class_type(class, tcp_wrapper_connection_get_type()))

template g_tcp_wrapper_connection_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, tcp_wrapper_connection_get_type(),
                             GTcpWrapperConnectionClassObj))

type
  GTcpWrapperConnectionPrivateObj = object
 
type
  GTcpWrapperConnectionClass* =  ptr GTcpWrapperConnectionClassObj
  GTcpWrapperConnectionClassPtr* = ptr GTcpWrapperConnectionClassObj
  GTcpWrapperConnectionClassObj*{.final.} = object of GTcpConnectionClassObj

type
  GTcpWrapperConnection* =  ptr GTcpWrapperConnectionObj
  GTcpWrapperConnectionPtr* = ptr GTcpWrapperConnectionObj
  GTcpWrapperConnectionObj*{.final.} = object of GTcpConnectionObj
    priv45: ptr GTcpWrapperConnectionPrivateObj

proc g_tcp_wrapper_connection_get_type*(): GType {.
    importc: "g_tcp_wrapper_connection_get_type", libgio.}
proc g_tcp_wrapper_connection_new*(base_io_stream: GIOStream;
                                   socket: GSocket): GSocketConnection {.
    importc: "g_tcp_wrapper_connection_new", libgio.}
proc get_base_io_stream*(
    conn: GTcpWrapperConnection): GIOStream {.
    importc: "g_tcp_wrapper_connection_get_base_io_stream", libgio.}
proc base_io_stream*(
    conn: GTcpWrapperConnection): GIOStream {.
    importc: "g_tcp_wrapper_connection_get_base_io_stream", libgio.}

template g_test_dbus*(obj: expr): expr =
  (g_type_check_instance_cast(obj, test_dbus_get_type(), GTestDBusObj))

template g_is_test_dbus*(obj: expr): expr =
  (g_type_check_instance_type(obj, test_dbus_get_type()))

proc g_test_dbus_get_type*(): GType {.importc: "g_test_dbus_get_type",
                                      libgio.}
proc g_test_dbus_new*(flags: GTestDBusFlags): GTestDBus {.
    importc: "g_test_dbus_new", libgio.}
proc g_test_dbus_get_flags*(self: GTestDBus): GTestDBusFlags {.
    importc: "g_test_dbus_get_flags", libgio.}
proc g_test_dbus_get_bus_address*(self: GTestDBus): cstring {.
    importc: "g_test_dbus_get_bus_address", libgio.}
proc g_test_dbus_add_service_dir*(self: GTestDBus; path: cstring) {.
    importc: "g_test_dbus_add_service_dir", libgio.}
proc g_test_dbus_up*(self: GTestDBus) {.importc: "g_test_dbus_up",
    libgio.}
proc g_test_dbus_stop*(self: GTestDBus) {.importc: "g_test_dbus_stop",
    libgio.}
proc g_test_dbus_down*(self: GTestDBus) {.importc: "g_test_dbus_down",
    libgio.}
proc g_test_dbus_unset*() {.importc: "g_test_dbus_unset", libgio.}

template g_themed_icon*(o: expr): expr =
  (g_type_check_instance_cast(o, themed_icon_get_type(), GThemedIconObj))

template g_themed_icon_class*(k: expr): expr =
  (g_type_check_class_cast(k, themed_icon_get_type(), GThemedIconClassObj))

template g_is_themed_icon*(o: expr): expr =
  (g_type_check_instance_type(o, themed_icon_get_type()))

template g_is_themed_icon_class*(k: expr): expr =
  (g_type_check_class_type(k, themed_icon_get_type()))

template g_themed_icon_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, themed_icon_get_type(), GThemedIconClassObj))

type
  GThemedIconClass* =  ptr GThemedIconClassObj
  GThemedIconClassPtr* = ptr GThemedIconClassObj
  GThemedIconClassObj* = object
 
proc g_themed_icon_get_type*(): GType {.importc: "g_themed_icon_get_type",
    libgio.}
proc g_themed_icon_new*(iconname: cstring): GIcon {.
    importc: "g_themed_icon_new", libgio.}
proc g_themed_icon_new_with_default_fallbacks*(iconname: cstring): GIcon {.
    importc: "g_themed_icon_new_with_default_fallbacks", libgio.}
proc g_themed_icon_new_from_names*(iconnames: cstringArray; len: cint): GIcon {.
    importc: "g_themed_icon_new_from_names", libgio.}
proc prepend_name*(icon: GThemedIcon; iconname: cstring) {.
    importc: "g_themed_icon_prepend_name", libgio.}
proc append_name*(icon: GThemedIcon; iconname: cstring) {.
    importc: "g_themed_icon_append_name", libgio.}
proc get_names*(icon: GThemedIcon): cstringArray {.
    importc: "g_themed_icon_get_names", libgio.}
proc names*(icon: GThemedIcon): cstringArray {.
    importc: "g_themed_icon_get_names", libgio.}

template g_threaded_socket_service*(inst: expr): expr =
  (g_type_check_instance_cast(inst, threaded_socket_service_get_type(),
                              GThreadedSocketServiceObj))

template g_threaded_socket_service_class*(class: expr): expr =
  (g_type_check_class_cast(class, threaded_socket_service_get_type(),
                           GThreadedSocketServiceClassObj))

template g_is_threaded_socket_service*(inst: expr): expr =
  (g_type_check_instance_type(inst, threaded_socket_service_get_type()))

template g_is_threaded_socket_service_class*(class: expr): expr =
  (g_type_check_class_type(class, threaded_socket_service_get_type()))

template g_threaded_socket_service_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, threaded_socket_service_get_type(),
                             GThreadedSocketServiceClassObj))

type
  GThreadedSocketServicePrivateObj = object
 
type
  GThreadedSocketService* =  ptr GThreadedSocketServiceObj
  GThreadedSocketServicePtr* = ptr GThreadedSocketServiceObj
  GThreadedSocketServiceObj*{.final.} = object of GSocketServiceObj
    priv46: ptr GThreadedSocketServicePrivateObj
type
  GThreadedSocketServiceClass* =  ptr GThreadedSocketServiceClassObj
  GThreadedSocketServiceClassPtr* = ptr GThreadedSocketServiceClassObj
  GThreadedSocketServiceClassObj*{.final.} = object of GSocketServiceClassObj
    run*: proc (service: GThreadedSocketService;
                connection: GSocketConnection; source_object: GObject): gboolean {.cdecl.}
    g_reserved331: proc () {.cdecl.}
    g_reserved332: proc () {.cdecl.}
    g_reserved333: proc () {.cdecl.}
    g_reserved334: proc () {.cdecl.}
    g_reserved335: proc () {.cdecl.}

proc g_threaded_socket_service_get_type*(): GType {.
    importc: "g_threaded_socket_service_get_type", libgio.}
proc g_threaded_socket_service_new*(max_threads: cint): GSocketService {.
    importc: "g_threaded_socket_service_new", libgio.}
type
  GTlsDatabasePrivateObj = object
 
type
  GTlsDatabase* =  ptr GTlsDatabaseObj
  GTlsDatabasePtr* = ptr GTlsDatabaseObj
  GTlsDatabaseObj*{.final.} = object of GObjectObj
    priv49: ptr GTlsDatabasePrivateObj

const
  G_TLS_BACKEND_EXTENSION_POINT_NAME* = "gio-tls-backend"
template g_tls_backend*(obj: expr): expr =
  (g_type_check_instance_cast(obj, tls_backend_get_type(), GTlsBackendObj))

template g_is_tls_backend*(obj: expr): expr =
  (g_type_check_instance_type(obj, tls_backend_get_type()))

template g_tls_backend_get_interface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, tls_backend_get_type(),
                                 GTlsBackendInterfaceObj))

type
  GTlsBackend* =  ptr GTlsBackendObj
  GTlsBackendPtr* = ptr GTlsBackendObj
  GTlsBackendObj* = object
 
type
  GTlsBackendInterface* =  ptr GTlsBackendInterfaceObj
  GTlsBackendInterfacePtr* = ptr GTlsBackendInterfaceObj
  GTlsBackendInterfaceObj*{.final.} = object of GTypeInterfaceObj
    supports_tls*: proc (backend: GTlsBackend): gboolean {.cdecl.}
    get_certificate_type*: proc (): GType {.cdecl.}
    get_client_connection_type*: proc (): GType {.cdecl.}
    get_server_connection_type*: proc (): GType {.cdecl.}
    get_file_database_type*: proc (): GType {.cdecl.}
    get_default_database*: proc (backend: GTlsBackend): GTlsDatabase {.cdecl.}

proc g_tls_backend_get_type*(): GType {.importc: "g_tls_backend_get_type",
    libgio.}
proc g_tls_backend_get_default*(): GTlsBackend {.
    importc: "g_tls_backend_get_default", libgio.}
proc get_default_database*(backend: GTlsBackend): GTlsDatabase {.
    importc: "g_tls_backend_get_default_database", libgio.}
proc default_database*(backend: GTlsBackend): GTlsDatabase {.
    importc: "g_tls_backend_get_default_database", libgio.}
proc supports_tls*(backend: GTlsBackend): gboolean {.
    importc: "g_tls_backend_supports_tls", libgio.}
proc get_certificate_type*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_certificate_type", libgio.}
proc certificate_type*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_certificate_type", libgio.}
proc get_client_connection_type*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_client_connection_type", libgio.}
proc client_connection_type*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_client_connection_type", libgio.}
proc get_server_connection_type*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_server_connection_type", libgio.}
proc server_connection_type*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_server_connection_type", libgio.}
proc get_file_database_type*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_file_database_type", libgio.}
proc file_database_type*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_file_database_type", libgio.}

template g_tls_certificate*(inst: expr): expr =
  (g_type_check_instance_cast(inst, tls_certificate_get_type(), GTlsCertificateObj))

template g_tls_certificate_class*(class: expr): expr =
  (g_type_check_class_cast(class, tls_certificate_get_type(),
                           GTlsCertificateClassObj))

template g_is_tls_certificate*(inst: expr): expr =
  (g_type_check_instance_type(inst, tls_certificate_get_type()))

template g_is_tls_certificate_class*(class: expr): expr =
  (g_type_check_class_type(class, tls_certificate_get_type()))

template g_tls_certificate_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, tls_certificate_get_type(),
                             GTlsCertificateClassObj))

type
  GTlsCertificatePrivateObj = object
 
type
  GTlsCertificate* =  ptr GTlsCertificateObj
  GTlsCertificatePtr* = ptr GTlsCertificateObj
  GTlsCertificateObj*{.final.} = object of GObjectObj
    priv47: ptr GTlsCertificatePrivateObj

type
  GTlsCertificateClass* =  ptr GTlsCertificateClassObj
  GTlsCertificateClassPtr* = ptr GTlsCertificateClassObj
  GTlsCertificateClassObj*{.final.} = object of GObjectClassObj
    verify*: proc (cert: GTlsCertificate;
                   identity: GSocketConnectable;
                   trusted_ca: GTlsCertificate): GTlsCertificateFlags {.cdecl.}
    padding*: array[8, gpointer]

proc g_tls_certificate_get_type*(): GType {.
    importc: "g_tls_certificate_get_type", libgio.}
proc g_tls_certificate_new_from_pem*(data: cstring; length: gssize;
                                     error: var GError): GTlsCertificate {.
    importc: "g_tls_certificate_new_from_pem", libgio.}
proc g_tls_certificate_new_from_file*(file: cstring; error: var GError): GTlsCertificate {.
    importc: "g_tls_certificate_new_from_file", libgio.}
proc g_tls_certificate_new_from_files*(cert_file: cstring; key_file: cstring;
    error: var GError): GTlsCertificate {.
    importc: "g_tls_certificate_new_from_files", libgio.}
proc g_tls_certificate_list_new_from_file*(file: cstring;
    error: var GError): GList {.
    importc: "g_tls_certificate_list_new_from_file", libgio.}
proc get_issuer*(cert: GTlsCertificate): GTlsCertificate {.
    importc: "g_tls_certificate_get_issuer", libgio.}
proc issuer*(cert: GTlsCertificate): GTlsCertificate {.
    importc: "g_tls_certificate_get_issuer", libgio.}
proc verify*(cert: GTlsCertificate;
                               identity: GSocketConnectable;
                               trusted_ca: GTlsCertificate): GTlsCertificateFlags {.
    importc: "g_tls_certificate_verify", libgio.}
proc is_same*(cert_one: GTlsCertificate;
                                cert_two: GTlsCertificate): gboolean {.
    importc: "g_tls_certificate_is_same", libgio.}
type
  GTlsInteractionPrivateObj = object
 
type
  GTlsInteraction* =  ptr GTlsInteractionObj
  GTlsInteractionPtr* = ptr GTlsInteractionObj
  GTlsInteractionObj*{.final.} = object of GObjectObj
    priv50: ptr GTlsInteractionPrivateObj

template g_tls_connection*(inst: expr): expr =
  (g_type_check_instance_cast(inst, tls_connection_get_type(), GTlsConnectionObj))

template g_tls_connection_class*(class: expr): expr =
  (g_type_check_class_cast(class, tls_connection_get_type(), GTlsConnectionClassObj))

template g_is_tls_connection*(inst: expr): expr =
  (g_type_check_instance_type(inst, tls_connection_get_type()))

template g_is_tls_connection_class*(class: expr): expr =
  (g_type_check_class_type(class, tls_connection_get_type()))

template g_tls_connection_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, tls_connection_get_type(),
                             GTlsConnectionClassObj))

type
  GTlsConnectionPrivateObj = object
 
type
  GTlsConnection* =  ptr GTlsConnectionObj
  GTlsConnectionPtr* = ptr GTlsConnectionObj
  GTlsConnectionObj*{.final.} = object of GIOStreamObj
    priv48: ptr GTlsConnectionPrivateObj

type
  GTlsConnectionClass* =  ptr GTlsConnectionClassObj
  GTlsConnectionClassPtr* = ptr GTlsConnectionClassObj
  GTlsConnectionClassObj*{.final.} = object of GIOStreamClassObj
    accept_certificate*: proc (connection: GTlsConnection;
                               peer_cert: GTlsCertificate;
                               errors: GTlsCertificateFlags): gboolean {.cdecl.}
    handshake*: proc (conn: GTlsConnection; cancellable: GCancellable;
                      error: var GError): gboolean {.cdecl.}
    handshake_async*: proc (conn: GTlsConnection; io_priority: cint;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    handshake_finish*: proc (conn: GTlsConnection;
                             result: GAsyncResult; error: var GError): gboolean {.cdecl.}
    padding*: array[8, gpointer]

proc g_tls_connection_get_type*(): GType {.
    importc: "g_tls_connection_get_type", libgio.}
proc set_use_system_certdb*(conn: GTlsConnection;
    use_system_certdb: gboolean) {.importc: "g_tls_connection_set_use_system_certdb",
                                   libgio.}
proc `use_system_certdb=`*(conn: GTlsConnection;
    use_system_certdb: gboolean) {.importc: "g_tls_connection_set_use_system_certdb",
                                   libgio.}
proc get_use_system_certdb*(conn: GTlsConnection): gboolean {.
    importc: "g_tls_connection_get_use_system_certdb", libgio.}
proc use_system_certdb*(conn: GTlsConnection): gboolean {.
    importc: "g_tls_connection_get_use_system_certdb", libgio.}
proc set_database*(conn: GTlsConnection;
                                    database: GTlsDatabase) {.
    importc: "g_tls_connection_set_database", libgio.}
proc `database=`*(conn: GTlsConnection;
                                    database: GTlsDatabase) {.
    importc: "g_tls_connection_set_database", libgio.}
proc get_database*(conn: GTlsConnection): GTlsDatabase {.
    importc: "g_tls_connection_get_database", libgio.}
proc database*(conn: GTlsConnection): GTlsDatabase {.
    importc: "g_tls_connection_get_database", libgio.}
proc set_certificate*(conn: GTlsConnection;
    certificate: GTlsCertificate) {.
    importc: "g_tls_connection_set_certificate", libgio.}
proc `certificate=`*(conn: GTlsConnection;
    certificate: GTlsCertificate) {.
    importc: "g_tls_connection_set_certificate", libgio.}
proc get_certificate*(conn: GTlsConnection): GTlsCertificate {.
    importc: "g_tls_connection_get_certificate", libgio.}
proc certificate*(conn: GTlsConnection): GTlsCertificate {.
    importc: "g_tls_connection_get_certificate", libgio.}
proc set_interaction*(conn: GTlsConnection;
    interaction: GTlsInteraction) {.
    importc: "g_tls_connection_set_interaction", libgio.}
proc `interaction=`*(conn: GTlsConnection;
    interaction: GTlsInteraction) {.
    importc: "g_tls_connection_set_interaction", libgio.}
proc get_interaction*(conn: GTlsConnection): GTlsInteraction {.
    importc: "g_tls_connection_get_interaction", libgio.}
proc interaction*(conn: GTlsConnection): GTlsInteraction {.
    importc: "g_tls_connection_get_interaction", libgio.}
proc get_peer_certificate*(conn: GTlsConnection): GTlsCertificate {.
    importc: "g_tls_connection_get_peer_certificate", libgio.}
proc peer_certificate*(conn: GTlsConnection): GTlsCertificate {.
    importc: "g_tls_connection_get_peer_certificate", libgio.}
proc get_peer_certificate_errors*(conn: GTlsConnection): GTlsCertificateFlags {.
    importc: "g_tls_connection_get_peer_certificate_errors", libgio.}
proc peer_certificate_errors*(conn: GTlsConnection): GTlsCertificateFlags {.
    importc: "g_tls_connection_get_peer_certificate_errors", libgio.}
proc set_require_close_notify*(conn: GTlsConnection;
    require_close_notify: gboolean) {.importc: "g_tls_connection_set_require_close_notify",
                                      libgio.}
proc `require_close_notify=`*(conn: GTlsConnection;
    require_close_notify: gboolean) {.importc: "g_tls_connection_set_require_close_notify",
                                      libgio.}
proc get_require_close_notify*(conn: GTlsConnection): gboolean {.
    importc: "g_tls_connection_get_require_close_notify", libgio.}
proc require_close_notify*(conn: GTlsConnection): gboolean {.
    importc: "g_tls_connection_get_require_close_notify", libgio.}
proc set_rehandshake_mode*(conn: GTlsConnection;
    mode: GTlsRehandshakeMode) {.importc: "g_tls_connection_set_rehandshake_mode",
                                 libgio.}
proc `rehandshake_mode=`*(conn: GTlsConnection;
    mode: GTlsRehandshakeMode) {.importc: "g_tls_connection_set_rehandshake_mode",
                                 libgio.}
proc get_rehandshake_mode*(conn: GTlsConnection): GTlsRehandshakeMode {.
    importc: "g_tls_connection_get_rehandshake_mode", libgio.}
proc rehandshake_mode*(conn: GTlsConnection): GTlsRehandshakeMode {.
    importc: "g_tls_connection_get_rehandshake_mode", libgio.}
proc handshake*(conn: GTlsConnection;
                                 cancellable: GCancellable;
                                 error: var GError): gboolean {.
    importc: "g_tls_connection_handshake", libgio.}
proc handshake_async*(conn: GTlsConnection;
    io_priority: cint; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_tls_connection_handshake_async", libgio.}
proc handshake_finish*(conn: GTlsConnection;
    result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_tls_connection_handshake_finish", libgio.}
proc g_tls_error_quark*(): GQuark {.importc: "g_tls_error_quark", libgio.}
proc emit_accept_certificate*(conn: GTlsConnection;
    peer_cert: GTlsCertificate; errors: GTlsCertificateFlags): gboolean {.
    importc: "g_tls_connection_emit_accept_certificate", libgio.}

template g_tls_client_connection*(inst: expr): expr =
  (g_type_check_instance_cast(inst, tls_client_connection_get_type(),
                              GTlsClientConnectionObj))

template g_is_tls_client_connection*(inst: expr): expr =
  (g_type_check_instance_type(inst, tls_client_connection_get_type()))

template g_tls_client_connection_get_interface*(inst: expr): expr =
  (g_type_instance_get_interface(inst, tls_client_connection_get_type(),
                                 GTlsClientConnectionInterfaceObj))

type
  GTlsClientConnectionInterface* =  ptr GTlsClientConnectionInterfaceObj
  GTlsClientConnectionInterfacePtr* = ptr GTlsClientConnectionInterfaceObj
  GTlsClientConnectionInterfaceObj*{.final.} = object of GTypeInterfaceObj

proc g_tls_client_connection_get_type*(): GType {.
    importc: "g_tls_client_connection_get_type", libgio.}
proc g_tls_client_connection_new*(base_io_stream: GIOStream;
                                  server_identity: GSocketConnectable;
                                  error: var GError): GIOStream {.
    importc: "g_tls_client_connection_new", libgio.}
proc get_validation_flags*(
    conn: GTlsClientConnection): GTlsCertificateFlags {.
    importc: "g_tls_client_connection_get_validation_flags", libgio.}
proc validation_flags*(
    conn: GTlsClientConnection): GTlsCertificateFlags {.
    importc: "g_tls_client_connection_get_validation_flags", libgio.}
proc set_validation_flags*(
    conn: GTlsClientConnection; flags: GTlsCertificateFlags) {.
    importc: "g_tls_client_connection_set_validation_flags", libgio.}
proc `validation_flags=`*(
    conn: GTlsClientConnection; flags: GTlsCertificateFlags) {.
    importc: "g_tls_client_connection_set_validation_flags", libgio.}
proc get_server_identity*(
    conn: GTlsClientConnection): GSocketConnectable {.
    importc: "g_tls_client_connection_get_server_identity", libgio.}
proc server_identity*(
    conn: GTlsClientConnection): GSocketConnectable {.
    importc: "g_tls_client_connection_get_server_identity", libgio.}
proc set_server_identity*(
    conn: GTlsClientConnection; identity: GSocketConnectable) {.
    importc: "g_tls_client_connection_set_server_identity", libgio.}
proc `server_identity=`*(
    conn: GTlsClientConnection; identity: GSocketConnectable) {.
    importc: "g_tls_client_connection_set_server_identity", libgio.}
proc get_use_ssl3*(conn: GTlsClientConnection): gboolean {.
    importc: "g_tls_client_connection_get_use_ssl3", libgio.}
proc use_ssl3*(conn: GTlsClientConnection): gboolean {.
    importc: "g_tls_client_connection_get_use_ssl3", libgio.}
proc set_use_ssl3*(conn: GTlsClientConnection;
    use_ssl3: gboolean) {.importc: "g_tls_client_connection_set_use_ssl3",
                          libgio.}
proc `use_ssl3=`*(conn: GTlsClientConnection;
    use_ssl3: gboolean) {.importc: "g_tls_client_connection_set_use_ssl3",
                          libgio.}
proc get_accepted_cas*(conn: GTlsClientConnection): GList {.
    importc: "g_tls_client_connection_get_accepted_cas", libgio.}
proc accepted_cas*(conn: GTlsClientConnection): GList {.
    importc: "g_tls_client_connection_get_accepted_cas", libgio.}

const
  G_TLS_DATABASE_PURPOSE_AUTHENTICATE_SERVER* = "1.3.6.1.5.5.7.3.1"
  G_TLS_DATABASE_PURPOSE_AUTHENTICATE_CLIENT* = "1.3.6.1.5.5.7.3.2"
template g_tls_database*(inst: expr): expr =
  (g_type_check_instance_cast(inst, tls_database_get_type(), GTlsDatabaseObj))

template g_tls_database_class*(class: expr): expr =
  (g_type_check_class_cast(class, tls_database_get_type(), GTlsDatabaseClassObj))

template g_is_tls_database*(inst: expr): expr =
  (g_type_check_instance_type(inst, tls_database_get_type()))

template g_is_tls_database_class*(class: expr): expr =
  (g_type_check_class_type(class, tls_database_get_type()))

template g_tls_database_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, tls_database_get_type(), GTlsDatabaseClassObj))

type
  GTlsDatabaseClass* =  ptr GTlsDatabaseClassObj
  GTlsDatabaseClassPtr* = ptr GTlsDatabaseClassObj
  GTlsDatabaseClassObj*{.final.} = object of GObjectClassObj
    verify_chain*: proc (self: GTlsDatabase; chain: GTlsCertificate;
                         purpose: cstring; identity: GSocketConnectable;
                         interaction: GTlsInteraction;
                         flags: GTlsDatabaseVerifyFlags;
                         cancellable: GCancellable; error: var GError): GTlsCertificateFlags {.cdecl.}
    verify_chain_async*: proc (self: GTlsDatabase;
                               chain: GTlsCertificate; purpose: cstring;
                               identity: GSocketConnectable;
                               interaction: GTlsInteraction;
                               flags: GTlsDatabaseVerifyFlags;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback;
                               user_data: gpointer) {.cdecl.}
    verify_chain_finish*: proc (self: GTlsDatabase;
                                result: GAsyncResult;
                                error: var GError): GTlsCertificateFlags {.cdecl.}
    create_certificate_handle*: proc (self: GTlsDatabase;
                                      certificate: GTlsCertificate): cstring {.cdecl.}
    lookup_certificate_for_handle*: proc (self: GTlsDatabase;
        handle: cstring; interaction: GTlsInteraction;
        flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
        error: var GError): GTlsCertificate {.cdecl.}
    lookup_certificate_for_handle_async*: proc (self: GTlsDatabase;
        handle: cstring; interaction: GTlsInteraction;
        flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
        callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    lookup_certificate_for_handle_finish*: proc (self: GTlsDatabase;
        result: GAsyncResult; error: var GError): GTlsCertificate {.cdecl.}
    lookup_certificate_issuer*: proc (self: GTlsDatabase;
                                      certificate: GTlsCertificate;
                                      interaction: GTlsInteraction;
                                      flags: GTlsDatabaseLookupFlags;
                                      cancellable: GCancellable;
                                      error: var GError): GTlsCertificate {.cdecl.}
    lookup_certificate_issuer_async*: proc (self: GTlsDatabase;
        certificate: GTlsCertificate; interaction: GTlsInteraction;
        flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
        callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    lookup_certificate_issuer_finish*: proc (self: GTlsDatabase;
        result: GAsyncResult; error: var GError): GTlsCertificate {.cdecl.}
    lookup_certificates_issued_by*: proc (self: GTlsDatabase;
        issuer_raw_dn: glib.GByteArray; interaction: GTlsInteraction;
        flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
        error: var GError): GList {.cdecl.}
    lookup_certificates_issued_by_async*: proc (self: GTlsDatabase;
        issuer_raw_dn: glib.GByteArray; interaction: GTlsInteraction;
        flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
        callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    lookup_certificates_issued_by_finish*: proc (self: GTlsDatabase;
        result: GAsyncResult; error: var GError): GList {.cdecl.}
    padding*: array[16, gpointer]

proc g_tls_database_get_type*(): GType {.importc: "g_tls_database_get_type",
    libgio.}
proc verify_chain*(self: GTlsDatabase;
                                  chain: GTlsCertificate;
                                  purpose: cstring;
                                  identity: GSocketConnectable;
                                  interaction: GTlsInteraction;
                                  flags: GTlsDatabaseVerifyFlags;
                                  cancellable: GCancellable;
                                  error: var GError): GTlsCertificateFlags {.
    importc: "g_tls_database_verify_chain", libgio.}
proc verify_chain_async*(self: GTlsDatabase;
    chain: GTlsCertificate; purpose: cstring;
    identity: GSocketConnectable; interaction: GTlsInteraction;
    flags: GTlsDatabaseVerifyFlags; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_tls_database_verify_chain_async", libgio.}
proc verify_chain_finish*(self: GTlsDatabase;
    result: GAsyncResult; error: var GError): GTlsCertificateFlags {.
    importc: "g_tls_database_verify_chain_finish", libgio.}
proc create_certificate_handle*(self: GTlsDatabase;
    certificate: GTlsCertificate): cstring {.
    importc: "g_tls_database_create_certificate_handle", libgio.}
proc lookup_certificate_for_handle*(self: GTlsDatabase;
    handle: cstring; interaction: GTlsInteraction;
    flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
    error: var GError): GTlsCertificate {.
    importc: "g_tls_database_lookup_certificate_for_handle", libgio.}
proc lookup_certificate_for_handle_async*(
    self: GTlsDatabase; handle: cstring; interaction: GTlsInteraction;
    flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_tls_database_lookup_certificate_for_handle_async", libgio.}
proc lookup_certificate_for_handle_finish*(
    self: GTlsDatabase; result: GAsyncResult; error: var GError): GTlsCertificate {.
    importc: "g_tls_database_lookup_certificate_for_handle_finish",
    libgio.}
proc lookup_certificate_issuer*(self: GTlsDatabase;
    certificate: GTlsCertificate; interaction: GTlsInteraction;
    flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
    error: var GError): GTlsCertificate {.
    importc: "g_tls_database_lookup_certificate_issuer", libgio.}
proc lookup_certificate_issuer_async*(self: GTlsDatabase;
    certificate: GTlsCertificate; interaction: GTlsInteraction;
    flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_tls_database_lookup_certificate_issuer_async", libgio.}
proc lookup_certificate_issuer_finish*(self: GTlsDatabase;
    result: GAsyncResult; error: var GError): GTlsCertificate {.
    importc: "g_tls_database_lookup_certificate_issuer_finish", libgio.}
proc lookup_certificates_issued_by*(self: GTlsDatabase;
    issuer_raw_dn: glib.GByteArray; interaction: GTlsInteraction;
    flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
    error: var GError): GList {.
    importc: "g_tls_database_lookup_certificates_issued_by", libgio.}
proc lookup_certificates_issued_by_async*(
    self: GTlsDatabase; issuer_raw_dn: glib.GByteArray;
    interaction: GTlsInteraction; flags: GTlsDatabaseLookupFlags;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_tls_database_lookup_certificates_issued_by_async",
                           libgio.}
proc lookup_certificates_issued_by_finish*(
    self: GTlsDatabase; result: GAsyncResult; error: var GError): GList {.
    importc: "g_tls_database_lookup_certificates_issued_by_finish",
    libgio.}

template g_tls_file_database*(inst: expr): expr =
  (g_type_check_instance_cast(inst, tls_file_database_get_type(),
                              GTlsFileDatabaseObj))

template g_is_tls_file_database*(inst: expr): expr =
  (g_type_check_instance_type(inst, tls_file_database_get_type()))

template g_tls_file_database_get_interface*(inst: expr): expr =
  (g_type_instance_get_interface(inst, tls_file_database_get_type(),
                                 GTlsFileDatabaseInterfaceObj))

type
  GTlsFileDatabaseInterface* =  ptr GTlsFileDatabaseInterfaceObj
  GTlsFileDatabaseInterfacePtr* = ptr GTlsFileDatabaseInterfaceObj
  GTlsFileDatabaseInterfaceObj*{.final.} = object of GTypeInterfaceObj
    padding*: array[8, gpointer]

proc g_tls_file_database_get_type*(): GType {.
    importc: "g_tls_file_database_get_type", libgio.}
proc g_tls_file_database_new*(anchors: cstring; error: var GError): GTlsDatabase {.
    importc: "g_tls_file_database_new", libgio.}
type
  GTlsPasswordPrivateObj = object
 
type
  GTlsPassword* =  ptr GTlsPasswordObj
  GTlsPasswordPtr* = ptr GTlsPasswordObj
  GTlsPasswordObj*{.final.} = object of GObjectObj
    priv51: ptr GTlsPasswordPrivateObj

template g_tls_interaction*(o: expr): expr =
  (g_type_check_instance_cast(o, tls_interaction_get_type(), GTlsInteractionObj))

template g_tls_interaction_class*(k: expr): expr =
  (g_type_check_class_cast(k, tls_interaction_get_type(), GTlsInteractionClassObj))

template g_is_tls_interaction*(o: expr): expr =
  (g_type_check_instance_type(o, tls_interaction_get_type()))

template g_is_tls_interaction_class*(k: expr): expr =
  (g_type_check_class_type(k, tls_interaction_get_type()))

template g_tls_interaction_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, tls_interaction_get_type(), GTlsInteractionClassObj))

type
  GTlsInteractionClass* =  ptr GTlsInteractionClassObj
  GTlsInteractionClassPtr* = ptr GTlsInteractionClassObj
  GTlsInteractionClassObj*{.final.} = object of GObjectClassObj
    ask_password*: proc (interaction: GTlsInteraction;
                         password: GTlsPassword;
                         cancellable: GCancellable; error: var GError): GTlsInteractionResult {.cdecl.}
    ask_password_async*: proc (interaction: GTlsInteraction;
                               password: GTlsPassword;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback;
                               user_data: gpointer) {.cdecl.}
    ask_password_finish*: proc (interaction: GTlsInteraction;
                                result: GAsyncResult;
                                error: var GError): GTlsInteractionResult {.cdecl.}
    request_certificate*: proc (interaction: GTlsInteraction;
                                connection: GTlsConnection;
                                flags: GTlsCertificateRequestFlags;
                                cancellable: GCancellable;
                                error: var GError): GTlsInteractionResult {.cdecl.}
    request_certificate_async*: proc (interaction: GTlsInteraction;
                                      connection: GTlsConnection;
                                      flags: GTlsCertificateRequestFlags;
                                      cancellable: GCancellable;
                                      callback: GAsyncReadyCallback;
                                      user_data: gpointer) {.cdecl.}
    request_certificate_finish*: proc (interaction: GTlsInteraction;
        result: GAsyncResult; error: var GError): GTlsInteractionResult {.cdecl.}
    padding*: array[21, gpointer]

proc g_tls_interaction_get_type*(): GType {.
    importc: "g_tls_interaction_get_type", libgio.}
proc invoke_ask_password*(interaction: GTlsInteraction;
    password: GTlsPassword; cancellable: GCancellable;
    error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_invoke_ask_password", libgio.}
proc ask_password*(interaction: GTlsInteraction;
                                     password: GTlsPassword;
                                     cancellable: GCancellable;
                                     error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_ask_password", libgio.}
proc ask_password_async*(interaction: GTlsInteraction;
    password: GTlsPassword; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_tls_interaction_ask_password_async", libgio.}
proc ask_password_finish*(interaction: GTlsInteraction;
    result: GAsyncResult; error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_ask_password_finish", libgio.}
proc invoke_request_certificate*(
    interaction: GTlsInteraction; connection: GTlsConnection;
    flags: GTlsCertificateRequestFlags; cancellable: GCancellable;
    error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_invoke_request_certificate", libgio.}
proc request_certificate*(interaction: GTlsInteraction;
    connection: GTlsConnection; flags: GTlsCertificateRequestFlags;
    cancellable: GCancellable; error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_request_certificate", libgio.}
proc request_certificate_async*(
    interaction: GTlsInteraction; connection: GTlsConnection;
    flags: GTlsCertificateRequestFlags; cancellable: GCancellable;
    callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_tls_interaction_request_certificate_async", libgio.}
proc request_certificate_finish*(
    interaction: GTlsInteraction; result: GAsyncResult;
    error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_request_certificate_finish", libgio.}

template g_tls_server_connection*(inst: expr): expr =
  (g_type_check_instance_cast(inst, tls_server_connection_get_type(),
                              GTlsServerConnectionObj))

template g_is_tls_server_connection*(inst: expr): expr =
  (g_type_check_instance_type(inst, tls_server_connection_get_type()))

template g_tls_server_connection_get_interface*(inst: expr): expr =
  (g_type_instance_get_interface(inst, tls_server_connection_get_type(),
                                 GTlsServerConnectionInterfaceObj))

type
  GTlsServerConnectionInterface* =  ptr GTlsServerConnectionInterfaceObj
  GTlsServerConnectionInterfacePtr* = ptr GTlsServerConnectionInterfaceObj
  GTlsServerConnectionInterfaceObj*{.final.} = object of GTypeInterfaceObj

proc g_tls_server_connection_get_type*(): GType {.
    importc: "g_tls_server_connection_get_type", libgio.}
proc g_tls_server_connection_new*(base_io_stream: GIOStream;
                                  certificate: GTlsCertificate;
                                  error: var GError): GIOStream {.
    importc: "g_tls_server_connection_new", libgio.}

template g_tls_password*(o: expr): expr =
  (g_type_check_instance_cast(o, tls_password_get_type(), GTlsPasswordObj))

template g_tls_password_class*(k: expr): expr =
  (g_type_check_class_cast(k, tls_password_get_type(), GTlsPasswordClassObj))

template g_is_tls_password*(o: expr): expr =
  (g_type_check_instance_type(o, tls_password_get_type()))

template g_is_tls_password_class*(k: expr): expr =
  (g_type_check_class_type(k, tls_password_get_type()))

template g_tls_password_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, tls_password_get_type(), GTlsPasswordClassObj))

type
  GTlsPasswordClass* =  ptr GTlsPasswordClassObj
  GTlsPasswordClassPtr* = ptr GTlsPasswordClassObj
  GTlsPasswordClassObj*{.final.} = object of GObjectClassObj
    get_value*: proc (password: GTlsPassword; length: var gsize): ptr guchar {.cdecl.}
    set_value*: proc (password: GTlsPassword; value: var guchar;
                      length: gssize; destroy: GDestroyNotify) {.cdecl.}
    get_default_warning*: proc (password: GTlsPassword): cstring {.cdecl.}
    padding*: array[4, gpointer]

proc g_tls_password_get_type*(): GType {.importc: "g_tls_password_get_type",
    libgio.}
proc g_tls_password_new*(flags: GTlsPasswordFlags; description: cstring): GTlsPassword {.
    importc: "g_tls_password_new", libgio.}
proc get_value*(password: GTlsPassword; length: var gsize): ptr guchar {.
    importc: "g_tls_password_get_value", libgio.}
proc value*(password: GTlsPassword; length: var gsize): ptr guchar {.
    importc: "g_tls_password_get_value", libgio.}
proc set_value*(password: GTlsPassword; value: var guchar;
                               length: gssize) {.
    importc: "g_tls_password_set_value", libgio.}
proc `value=`*(password: GTlsPassword; value: var guchar;
                               length: gssize) {.
    importc: "g_tls_password_set_value", libgio.}
proc set_value_full*(password: GTlsPassword;
                                    value: var guchar; length: gssize;
                                    destroy: GDestroyNotify) {.
    importc: "g_tls_password_set_value_full", libgio.}
proc `value_full=`*(password: GTlsPassword;
                                    value: var guchar; length: gssize;
                                    destroy: GDestroyNotify) {.
    importc: "g_tls_password_set_value_full", libgio.}
proc get_flags*(password: GTlsPassword): GTlsPasswordFlags {.
    importc: "g_tls_password_get_flags", libgio.}
proc flags*(password: GTlsPassword): GTlsPasswordFlags {.
    importc: "g_tls_password_get_flags", libgio.}
proc set_flags*(password: GTlsPassword;
                               flags: GTlsPasswordFlags) {.
    importc: "g_tls_password_set_flags", libgio.}
proc `flags=`*(password: GTlsPassword;
                               flags: GTlsPasswordFlags) {.
    importc: "g_tls_password_set_flags", libgio.}
proc get_description*(password: GTlsPassword): cstring {.
    importc: "g_tls_password_get_description", libgio.}
proc description*(password: GTlsPassword): cstring {.
    importc: "g_tls_password_get_description", libgio.}
proc set_description*(password: GTlsPassword;
                                     description: cstring) {.
    importc: "g_tls_password_set_description", libgio.}
proc `description=`*(password: GTlsPassword;
                                     description: cstring) {.
    importc: "g_tls_password_set_description", libgio.}
proc get_warning*(password: GTlsPassword): cstring {.
    importc: "g_tls_password_get_warning", libgio.}
proc warning*(password: GTlsPassword): cstring {.
    importc: "g_tls_password_get_warning", libgio.}
proc set_warning*(password: GTlsPassword; warning: cstring) {.
    importc: "g_tls_password_set_warning", libgio.}
proc `warning=`*(password: GTlsPassword; warning: cstring) {.
    importc: "g_tls_password_set_warning", libgio.}

template g_vfs*(o: expr): expr =
  (g_type_check_instance_cast(o, vfs_get_type(), GVfsObj))

template g_vfs_class*(k: expr): expr =
  (g_type_check_class_cast(k, vfs_get_type(), GVfsClassObj))

template g_vfs_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, vfs_get_type(), GVfsClassObj))

template g_is_vfs*(o: expr): expr =
  (g_type_check_instance_type(o, vfs_get_type()))

template g_is_vfs_class*(k: expr): expr =
  (g_type_check_class_type(k, vfs_get_type()))

const
  G_VFS_EXTENSION_POINT_NAME* = "gio-vfs"
type
  GVfs* =  ptr GVfsObj
  GVfsPtr* = ptr GVfsObj
  GVfsObj*{.final.} = object of GObjectObj

type
  GVfsClass* =  ptr GVfsClassObj
  GVfsClassPtr* = ptr GVfsClassObj
  GVfsClassObj*{.final.} = object of GObjectClassObj
    is_active*: proc (vfs: GVfs): gboolean {.cdecl.}
    get_file_for_path*: proc (vfs: GVfs; path: cstring): GFile {.cdecl.}
    get_file_for_uri*: proc (vfs: GVfs; uri: cstring): GFile {.cdecl.}
    get_supported_uri_schemes*: proc (vfs: GVfs): cstringArray {.cdecl.}
    parse_name*: proc (vfs: GVfs; parse_name: cstring): GFile {.cdecl.}
    local_file_add_info*: proc (vfs: GVfs; filename: cstring;
                                device: guint64;
                                attribute_matcher: GFileAttributeMatcher;
                                info: GFileInfo;
                                cancellable: GCancellable;
                                extra_data: var gpointer;
                                free_extra_data: ptr GDestroyNotify) {.cdecl.}
    add_writable_namespaces*: proc (vfs: GVfs;
                                    list: GFileAttributeInfoList) {.cdecl.}
    local_file_set_attributes*: proc (vfs: GVfs; filename: cstring;
                                      info: GFileInfo;
                                      flags: GFileQueryInfoFlags;
                                      cancellable: GCancellable;
                                      error: var GError): gboolean {.cdecl.}
    local_file_removed*: proc (vfs: GVfs; filename: cstring) {.cdecl.}
    local_file_moved*: proc (vfs: GVfs; source: cstring; dest: cstring) {.cdecl.}
    deserialize_icon*: proc (vfs: GVfs; value: GVariant): GIcon {.cdecl.}
    g_reserved341: proc () {.cdecl.}
    g_reserved342: proc () {.cdecl.}
    g_reserved343: proc () {.cdecl.}
    g_reserved344: proc () {.cdecl.}
    g_reserved345: proc () {.cdecl.}
    g_reserved346: proc () {.cdecl.}

proc g_vfs_get_type*(): GType {.importc: "g_vfs_get_type", libgio.}
proc is_active*(vfs: GVfs): gboolean {.importc: "g_vfs_is_active",
    libgio.}
proc get_file_for_path*(vfs: GVfs; path: cstring): GFile {.
    importc: "g_vfs_get_file_for_path", libgio.}
proc file_for_path*(vfs: GVfs; path: cstring): GFile {.
    importc: "g_vfs_get_file_for_path", libgio.}
proc get_file_for_uri*(vfs: GVfs; uri: cstring): GFile {.
    importc: "g_vfs_get_file_for_uri", libgio.}
proc file_for_uri*(vfs: GVfs; uri: cstring): GFile {.
    importc: "g_vfs_get_file_for_uri", libgio.}
proc get_supported_uri_schemes*(vfs: GVfs): cstringArray {.
    importc: "g_vfs_get_supported_uri_schemes", libgio.}
proc supported_uri_schemes*(vfs: GVfs): cstringArray {.
    importc: "g_vfs_get_supported_uri_schemes", libgio.}
proc parse_name*(vfs: GVfs; parse_name: cstring): GFile {.
    importc: "g_vfs_parse_name", libgio.}
proc g_vfs_get_default*(): GVfs {.importc: "g_vfs_get_default",
                                      libgio.}
proc g_vfs_get_local*(): GVfs {.importc: "g_vfs_get_local", libgio.}

const
  G_VOLUME_IDENTIFIER_KIND_HAL_UDI* = "hal-udi"
const
  G_VOLUME_IDENTIFIER_KIND_UNIX_DEVICE* = "unix-device"
const
  G_VOLUME_IDENTIFIER_KIND_LABEL* = "label"
const
  G_VOLUME_IDENTIFIER_KIND_UUID* = "uuid"
const
  G_VOLUME_IDENTIFIER_KIND_NFS_MOUNT* = "nfs-mount"
const
  G_VOLUME_IDENTIFIER_KIND_CLASS* = "class"
template g_volume*(obj: expr): expr =
  (g_type_check_instance_cast(obj, volume_get_type(), GVolumeObj))

template g_is_volume*(obj: expr): expr =
  (g_type_check_instance_type(obj, volume_get_type()))

template g_volume_get_iface*(obj: expr): expr =
  (g_type_instance_get_interface(obj, volume_get_type(), GVolumeIfaceObj))

type
  GVolumeIface* =  ptr GVolumeIfaceObj
  GVolumeIfacePtr* = ptr GVolumeIfaceObj
  GVolumeIfaceObj*{.final.} = object of GTypeInterfaceObj
    changed*: proc (volume: GVolume) {.cdecl.}
    removed*: proc (volume: GVolume) {.cdecl.}
    get_name*: proc (volume: GVolume): cstring {.cdecl.}
    get_icon*: proc (volume: GVolume): GIcon {.cdecl.}
    get_uuid*: proc (volume: GVolume): cstring {.cdecl.}
    get_drive*: proc (volume: GVolume): GDrive {.cdecl.}
    get_mount*: proc (volume: GVolume): GMount {.cdecl.}
    can_mount*: proc (volume: GVolume): gboolean {.cdecl.}
    can_eject*: proc (volume: GVolume): gboolean {.cdecl.}
    mount_fn*: proc (volume: GVolume; flags: GMountMountFlags;
                     mount_operation: GMountOperation;
                     cancellable: GCancellable;
                     callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    mount_finish*: proc (volume: GVolume; result: GAsyncResult;
                         error: var GError): gboolean {.cdecl.}
    eject*: proc (volume: GVolume; flags: GMountUnmountFlags;
                  cancellable: GCancellable;
                  callback: GAsyncReadyCallback; user_data: gpointer) {.cdecl.}
    eject_finish*: proc (volume: GVolume; result: GAsyncResult;
                         error: var GError): gboolean {.cdecl.}
    get_identifier*: proc (volume: GVolume; kind: cstring): cstring {.cdecl.}
    enumerate_identifiers*: proc (volume: GVolume): cstringArray {.cdecl.}
    should_automount*: proc (volume: GVolume): gboolean {.cdecl.}
    get_activation_root*: proc (volume: GVolume): GFile {.cdecl.}
    eject_with_operation*: proc (volume: GVolume;
                                 flags: GMountUnmountFlags;
                                 mount_operation: GMountOperation;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback;
                                 user_data: gpointer) {.cdecl.}
    eject_with_operation_finish*: proc (volume: GVolume;
        result: GAsyncResult; error: var GError): gboolean {.cdecl.}
    get_sort_key*: proc (volume: GVolume): cstring {.cdecl.}
    get_symbolic_icon*: proc (volume: GVolume): GIcon {.cdecl.}

proc g_volume_get_type*(): GType {.importc: "g_volume_get_type", libgio.}
proc get_name*(volume: GVolume): cstring {.
    importc: "g_volume_get_name", libgio.}
proc name*(volume: GVolume): cstring {.
    importc: "g_volume_get_name", libgio.}
proc get_icon*(volume: GVolume): GIcon {.
    importc: "g_volume_get_icon", libgio.}
proc icon*(volume: GVolume): GIcon {.
    importc: "g_volume_get_icon", libgio.}
proc get_symbolic_icon*(volume: GVolume): GIcon {.
    importc: "g_volume_get_symbolic_icon", libgio.}
proc symbolic_icon*(volume: GVolume): GIcon {.
    importc: "g_volume_get_symbolic_icon", libgio.}
proc get_uuid*(volume: GVolume): cstring {.
    importc: "g_volume_get_uuid", libgio.}
proc uuid*(volume: GVolume): cstring {.
    importc: "g_volume_get_uuid", libgio.}
proc get_drive*(volume: GVolume): GDrive {.
    importc: "g_volume_get_drive", libgio.}
proc drive*(volume: GVolume): GDrive {.
    importc: "g_volume_get_drive", libgio.}
proc get_mount*(volume: GVolume): GMount {.
    importc: "g_volume_get_mount", libgio.}
proc mount*(volume: GVolume): GMount {.
    importc: "g_volume_get_mount", libgio.}
proc can_mount*(volume: GVolume): gboolean {.
    importc: "g_volume_can_mount", libgio.}
proc can_eject*(volume: GVolume): gboolean {.
    importc: "g_volume_can_eject", libgio.}
proc should_automount*(volume: GVolume): gboolean {.
    importc: "g_volume_should_automount", libgio.}
proc mount*(volume: GVolume; flags: GMountMountFlags;
                     mount_operation: GMountOperation;
                     cancellable: GCancellable;
                     callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_volume_mount", libgio.}
proc mount_finish*(volume: GVolume; result: GAsyncResult;
                            error: var GError): gboolean {.
    importc: "g_volume_mount_finish", libgio.}
proc eject*(volume: GVolume; flags: GMountUnmountFlags;
                     cancellable: GCancellable;
                     callback: GAsyncReadyCallback; user_data: gpointer) {.
    importc: "g_volume_eject", libgio.}
proc eject_finish*(volume: GVolume; result: GAsyncResult;
                            error: var GError): gboolean {.
    importc: "g_volume_eject_finish", libgio.}
proc get_identifier*(volume: GVolume; kind: cstring): cstring {.
    importc: "g_volume_get_identifier", libgio.}
proc identifier*(volume: GVolume; kind: cstring): cstring {.
    importc: "g_volume_get_identifier", libgio.}
proc enumerate_identifiers*(volume: GVolume): cstringArray {.
    importc: "g_volume_enumerate_identifiers", libgio.}
proc get_activation_root*(volume: GVolume): GFile {.
    importc: "g_volume_get_activation_root", libgio.}
proc activation_root*(volume: GVolume): GFile {.
    importc: "g_volume_get_activation_root", libgio.}
proc eject_with_operation*(volume: GVolume;
                                    flags: GMountUnmountFlags;
                                    mount_operation: GMountOperation;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    user_data: gpointer) {.
    importc: "g_volume_eject_with_operation", libgio.}
proc eject_with_operation_finish*(volume: GVolume;
    result: GAsyncResult; error: var GError): gboolean {.
    importc: "g_volume_eject_with_operation_finish", libgio.}
proc get_sort_key*(volume: GVolume): cstring {.
    importc: "g_volume_get_sort_key", libgio.}
proc sort_key*(volume: GVolume): cstring {.
    importc: "g_volume_get_sort_key", libgio.}

template g_zlib_compressor*(o: expr): expr =
  (g_type_check_instance_cast(o, zlib_compressor_get_type(), GZlibCompressorObj))

template g_zlib_compressor_class*(k: expr): expr =
  (g_type_check_class_cast(k, zlib_compressor_get_type(), GZlibCompressorClassObj))

template g_is_zlib_compressor*(o: expr): expr =
  (g_type_check_instance_type(o, zlib_compressor_get_type()))

template g_is_zlib_compressor_class*(k: expr): expr =
  (g_type_check_class_type(k, zlib_compressor_get_type()))

template g_zlib_compressor_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, zlib_compressor_get_type(), GZlibCompressorClassObj))

type
  GZlibCompressorClass* =  ptr GZlibCompressorClassObj
  GZlibCompressorClassPtr* = ptr GZlibCompressorClassObj
  GZlibCompressorClassObj*{.final.} = object of GObjectClassObj

proc g_zlib_compressor_get_type*(): GType {.
    importc: "g_zlib_compressor_get_type", libgio.}
proc g_zlib_compressor_new*(format: GZlibCompressorFormat; level: cint): GZlibCompressor {.
    importc: "g_zlib_compressor_new", libgio.}
proc get_file_info*(compressor: GZlibCompressor): GFileInfo {.
    importc: "g_zlib_compressor_get_file_info", libgio.}
proc file_info*(compressor: GZlibCompressor): GFileInfo {.
    importc: "g_zlib_compressor_get_file_info", libgio.}
proc set_file_info*(compressor: GZlibCompressor;
                                      file_info: GFileInfo) {.
    importc: "g_zlib_compressor_set_file_info", libgio.}
proc `file_info=`*(compressor: GZlibCompressor;
                                      file_info: GFileInfo) {.
    importc: "g_zlib_compressor_set_file_info", libgio.}

template g_zlib_decompressor*(o: expr): expr =
  (g_type_check_instance_cast(o, zlib_decompressor_get_type(), GZlibDecompressorObj))

template g_zlib_decompressor_class*(k: expr): expr =
  (g_type_check_class_cast(k, zlib_decompressor_get_type(),
                           GZlibDecompressorClassObj))

template g_is_zlib_decompressor*(o: expr): expr =
  (g_type_check_instance_type(o, zlib_decompressor_get_type()))

template g_is_zlib_decompressor_class*(k: expr): expr =
  (g_type_check_class_type(k, zlib_decompressor_get_type()))

template g_zlib_decompressor_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, zlib_decompressor_get_type(),
                             GZlibDecompressorClassObj))

type
  GZlibDecompressorClass* =  ptr GZlibDecompressorClassObj
  GZlibDecompressorClassPtr* = ptr GZlibDecompressorClassObj
  GZlibDecompressorClassObj*{.final.} = object of GObjectClassObj

proc g_zlib_decompressor_get_type*(): GType {.
    importc: "g_zlib_decompressor_get_type", libgio.}
proc g_zlib_decompressor_new*(format: GZlibCompressorFormat): GZlibDecompressor {.
    importc: "g_zlib_decompressor_new", libgio.}
proc get_file_info*(decompressor: GZlibDecompressor): GFileInfo {.
    importc: "g_zlib_decompressor_get_file_info", libgio.}
proc file_info*(decompressor: GZlibDecompressor): GFileInfo {.
    importc: "g_zlib_decompressor_get_file_info", libgio.}

template g_dbus_interface*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_interface_get_type(), GDBusInterfaceObj))

template g_is_dbus_interface*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_interface_get_type()))

template g_dbus_interface_get_iface*(o: expr): expr =
  (g_type_instance_get_interface(o, dbus_interface_get_type(),
                                 GDBusInterfaceIfaceObj))

type
  GDBusInterfaceIface* =  ptr GDBusInterfaceIfaceObj
  GDBusInterfaceIfacePtr* = ptr GDBusInterfaceIfaceObj
  GDBusInterfaceIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_info*: proc (`interface`: GDBusInterface): GDBusInterfaceInfo {.cdecl.}
    get_object*: proc (`interface`: GDBusInterface): GDBusObject {.cdecl.}
    set_object*: proc (`interface`: GDBusInterface;
                       `object`: GDBusObject) {.cdecl.}
    dup_object*: proc (`interface`: GDBusInterface): GDBusObject {.cdecl.}

proc g_dbus_interface_get_type*(): GType {.
    importc: "g_dbus_interface_get_type", libgio.}
proc get_info*(`interface`: GDBusInterface): GDBusInterfaceInfo {.
    importc: "g_dbus_interface_get_info", libgio.}
proc info*(`interface`: GDBusInterface): GDBusInterfaceInfo {.
    importc: "g_dbus_interface_get_info", libgio.}
proc get_object*(`interface`: GDBusInterface): GDBusObject {.
    importc: "g_dbus_interface_get_object", libgio.}
proc `object`*(`interface`: GDBusInterface): GDBusObject {.
    importc: "g_dbus_interface_get_object", libgio.}
proc set_object*(`interface`: GDBusInterface;
                                  `object`: GDBusObject) {.
    importc: "g_dbus_interface_set_object", libgio.}
proc `object=`*(`interface`: GDBusInterface;
                                  `object`: GDBusObject) {.
    importc: "g_dbus_interface_set_object", libgio.}
proc dup_object*(`interface`: GDBusInterface): GDBusObject {.
    importc: "g_dbus_interface_dup_object", libgio.}

template g_dbus_interface_skeleton*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_interface_skeleton_get_type(),
                              GDBusInterfaceSkeletonObj))

template g_dbus_interface_skeleton_class*(k: expr): expr =
  (g_type_check_class_cast(k, dbus_interface_skeleton_get_type(),
                           GDBusInterfaceSkeletonClassObj))

template g_dbus_interface_skeleton_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, dbus_interface_skeleton_get_type(),
                             GDBusInterfaceSkeletonClassObj))

template g_is_dbus_interface_skeleton*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_interface_skeleton_get_type()))

template g_is_dbus_interface_skeleton_class*(k: expr): expr =
  (g_type_check_class_type(k, dbus_interface_skeleton_get_type()))

type
  GDBusInterfaceSkeletonPrivateObj = object
 
type
  GDBusInterfaceSkeleton* =  ptr GDBusInterfaceSkeletonObj
  GDBusInterfaceSkeletonPtr* = ptr GDBusInterfaceSkeletonObj
  GDBusInterfaceSkeletonObj*{.final.} = object of GObjectObj
    priv52: ptr GDBusInterfaceSkeletonPrivateObj

type
  GDBusInterfaceSkeletonClass* =  ptr GDBusInterfaceSkeletonClassObj
  GDBusInterfaceSkeletonClassPtr* = ptr GDBusInterfaceSkeletonClassObj
  GDBusInterfaceSkeletonClassObj*{.final.} = object of GObjectClassObj
    get_info*: proc (`interface`: GDBusInterfaceSkeleton): GDBusInterfaceInfo {.cdecl.}
    get_vtable*: proc (`interface`: GDBusInterfaceSkeleton): GDBusInterfaceVTable {.cdecl.}
    get_properties*: proc (`interface`: GDBusInterfaceSkeleton): GVariant {.cdecl.}
    flush*: proc (`interface`: GDBusInterfaceSkeleton) {.cdecl.}
    vfunc_padding*: array[8, gpointer]
    g_authorize_method*: proc (`interface`: GDBusInterfaceSkeleton;
                               invocation: GDBusMethodInvocation): gboolean {.cdecl.}
    signal_padding*: array[8, gpointer]

proc g_dbus_interface_skeleton_get_type*(): GType {.
    importc: "g_dbus_interface_skeleton_get_type", libgio.}
proc get_flags*(
    `interface`: GDBusInterfaceSkeleton): GDBusInterfaceSkeletonFlags {.
    importc: "g_dbus_interface_skeleton_get_flags", libgio.}
proc flags*(
    `interface`: GDBusInterfaceSkeleton): GDBusInterfaceSkeletonFlags {.
    importc: "g_dbus_interface_skeleton_get_flags", libgio.}
proc set_flags*(
    `interface`: GDBusInterfaceSkeleton;
    flags: GDBusInterfaceSkeletonFlags) {.
    importc: "g_dbus_interface_skeleton_set_flags", libgio.}
proc `flags=`*(
    `interface`: GDBusInterfaceSkeleton;
    flags: GDBusInterfaceSkeletonFlags) {.
    importc: "g_dbus_interface_skeleton_set_flags", libgio.}
proc get_info*(
    `interface`: GDBusInterfaceSkeleton): GDBusInterfaceInfo {.
    importc: "g_dbus_interface_skeleton_get_info", libgio.}
proc info*(
    `interface`: GDBusInterfaceSkeleton): GDBusInterfaceInfo {.
    importc: "g_dbus_interface_skeleton_get_info", libgio.}
proc get_vtable*(
    `interface`: GDBusInterfaceSkeleton): GDBusInterfaceVTable {.
    importc: "g_dbus_interface_skeleton_get_vtable", libgio.}
proc vtable*(
    `interface`: GDBusInterfaceSkeleton): GDBusInterfaceVTable {.
    importc: "g_dbus_interface_skeleton_get_vtable", libgio.}
proc get_properties*(
    `interface`: GDBusInterfaceSkeleton): GVariant {.
    importc: "g_dbus_interface_skeleton_get_properties", libgio.}
proc properties*(
    `interface`: GDBusInterfaceSkeleton): GVariant {.
    importc: "g_dbus_interface_skeleton_get_properties", libgio.}
proc flush*(`interface`: GDBusInterfaceSkeleton) {.
    importc: "g_dbus_interface_skeleton_flush", libgio.}
proc `export`*(
    `interface`: GDBusInterfaceSkeleton; connection: GDBusConnection;
    object_path: cstring; error: var GError): gboolean {.
    importc: "g_dbus_interface_skeleton_export", libgio.}
proc unexport*(
    `interface`: GDBusInterfaceSkeleton) {.
    importc: "g_dbus_interface_skeleton_unexport", libgio.}
proc unexport_from_connection*(
    `interface`: GDBusInterfaceSkeleton; connection: GDBusConnection) {.
    importc: "g_dbus_interface_skeleton_unexport_from_connection", libgio.}
proc get_connection*(
    `interface`: GDBusInterfaceSkeleton): GDBusConnection {.
    importc: "g_dbus_interface_skeleton_get_connection", libgio.}
proc connection*(
    `interface`: GDBusInterfaceSkeleton): GDBusConnection {.
    importc: "g_dbus_interface_skeleton_get_connection", libgio.}
proc get_connections*(
    `interface`: GDBusInterfaceSkeleton): GList {.
    importc: "g_dbus_interface_skeleton_get_connections", libgio.}
proc connections*(
    `interface`: GDBusInterfaceSkeleton): GList {.
    importc: "g_dbus_interface_skeleton_get_connections", libgio.}
proc has_connection*(
    `interface`: GDBusInterfaceSkeleton; connection: GDBusConnection): gboolean {.
    importc: "g_dbus_interface_skeleton_has_connection", libgio.}
proc get_object_path*(
    `interface`: GDBusInterfaceSkeleton): cstring {.
    importc: "g_dbus_interface_skeleton_get_object_path", libgio.}
proc object_path*(
    `interface`: GDBusInterfaceSkeleton): cstring {.
    importc: "g_dbus_interface_skeleton_get_object_path", libgio.}

template g_dbus_object*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_object_get_type(), GDBusObjectObj))

template g_is_dbus_object*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_object_get_type()))

template g_dbus_object_get_iface*(o: expr): expr =
  (g_type_instance_get_interface(o, dbus_object_get_type(), GDBusObjectIfaceObj))

type
  GDBusObjectIface* =  ptr GDBusObjectIfaceObj
  GDBusObjectIfacePtr* = ptr GDBusObjectIfaceObj
  GDBusObjectIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_object_path*: proc (`object`: GDBusObject): cstring {.cdecl.}
    get_interfaces*: proc (`object`: GDBusObject): GList {.cdecl.}
    get_interface*: proc (`object`: GDBusObject; interface_name: cstring): GDBusInterface {.cdecl.}
    interface_added*: proc (`object`: GDBusObject;
                            `interface`: GDBusInterface) {.cdecl.}
    interface_removed*: proc (`object`: GDBusObject;
                              `interface`: GDBusInterface) {.cdecl.}

proc g_dbus_object_get_type*(): GType {.importc: "g_dbus_object_get_type",
    libgio.}
proc get_object_path*(`object`: GDBusObject): cstring {.
    importc: "g_dbus_object_get_object_path", libgio.}
proc object_path*(`object`: GDBusObject): cstring {.
    importc: "g_dbus_object_get_object_path", libgio.}
proc get_interfaces*(`object`: GDBusObject): GList {.
    importc: "g_dbus_object_get_interfaces", libgio.}
proc interfaces*(`object`: GDBusObject): GList {.
    importc: "g_dbus_object_get_interfaces", libgio.}
proc get_interface*(`object`: GDBusObject;
                                  interface_name: cstring): GDBusInterface {.
    importc: "g_dbus_object_get_interface", libgio.}
proc `interface`*(`object`: GDBusObject;
                                  interface_name: cstring): GDBusInterface {.
    importc: "g_dbus_object_get_interface", libgio.}

template g_dbus_object_skeleton*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_object_skeleton_get_type(),
                              GDBusObjectSkeletonObj))

template g_dbus_object_skeleton_class*(k: expr): expr =
  (g_type_check_class_cast(k, dbus_object_skeleton_get_type(),
                           GDBusObjectSkeletonClassObj))

template g_dbus_object_skeleton_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, dbus_object_skeleton_get_type(),
                             GDBusObjectSkeletonClassObj))

template g_is_dbus_object_skeleton*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_object_skeleton_get_type()))

template g_is_dbus_object_skeleton_class*(k: expr): expr =
  (g_type_check_class_type(k, dbus_object_skeleton_get_type()))

type
  GDBusObjectSkeletonPrivateObj = object
 
type
  GDBusObjectSkeleton* =  ptr GDBusObjectSkeletonObj
  GDBusObjectSkeletonPtr* = ptr GDBusObjectSkeletonObj
  GDBusObjectSkeletonObj*{.final.} = object of GObjectObj
    priv53: ptr GDBusObjectSkeletonPrivateObj

type
  GDBusObjectSkeletonClass* =  ptr GDBusObjectSkeletonClassObj
  GDBusObjectSkeletonClassPtr* = ptr GDBusObjectSkeletonClassObj
  GDBusObjectSkeletonClassObj*{.final.} = object of GObjectClassObj
    authorize_method*: proc (`object`: GDBusObjectSkeleton;
                             `interface`: GDBusInterfaceSkeleton;
                             invocation: GDBusMethodInvocation): gboolean {.cdecl.}
    padding*: array[8, gpointer]

proc g_dbus_object_skeleton_get_type*(): GType {.
    importc: "g_dbus_object_skeleton_get_type", libgio.}
proc g_dbus_object_skeleton_new*(object_path: cstring): GDBusObjectSkeleton {.
    importc: "g_dbus_object_skeleton_new", libgio.}
proc flush*(`object`: GDBusObjectSkeleton) {.
    importc: "g_dbus_object_skeleton_flush", libgio.}
proc add_interface*(`object`: GDBusObjectSkeleton;
    `interface`: GDBusInterfaceSkeleton) {.
    importc: "g_dbus_object_skeleton_add_interface", libgio.}
proc remove_interface*(
    `object`: GDBusObjectSkeleton;
    `interface`: GDBusInterfaceSkeleton) {.
    importc: "g_dbus_object_skeleton_remove_interface", libgio.}
proc remove_interface_by_name*(
    `object`: GDBusObjectSkeleton; interface_name: cstring) {.
    importc: "g_dbus_object_skeleton_remove_interface_by_name", libgio.}
proc set_object_path*(
    `object`: GDBusObjectSkeleton; object_path: cstring) {.
    importc: "g_dbus_object_skeleton_set_object_path", libgio.}
proc `object_path=`*(
    `object`: GDBusObjectSkeleton; object_path: cstring) {.
    importc: "g_dbus_object_skeleton_set_object_path", libgio.}

template g_dbus_object_proxy*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_object_proxy_get_type(), GDBusObjectProxyObj))

template g_dbus_object_proxy_class*(k: expr): expr =
  (g_type_check_class_cast(k, dbus_object_proxy_get_type(),
                           GDBusObjectProxyClassObj))

template g_dbus_object_proxy_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, dbus_object_proxy_get_type(),
                             GDBusObjectProxyClassObj))

template g_is_dbus_object_proxy*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_object_proxy_get_type()))

template g_is_dbus_object_proxy_class*(k: expr): expr =
  (g_type_check_class_type(k, dbus_object_proxy_get_type()))

type
  GDBusObjectProxyPrivateObj = object
 
type
  GDBusObjectProxy* =  ptr GDBusObjectProxyObj
  GDBusObjectProxyPtr* = ptr GDBusObjectProxyObj
  GDBusObjectProxyObj*{.final.} = object of GObjectObj
    priv54: ptr GDBusObjectProxyPrivateObj

type
  GDBusObjectProxyClass* =  ptr GDBusObjectProxyClassObj
  GDBusObjectProxyClassPtr* = ptr GDBusObjectProxyClassObj
  GDBusObjectProxyClassObj*{.final.} = object of GObjectClassObj
    padding*: array[8, gpointer]

proc g_dbus_object_proxy_get_type*(): GType {.
    importc: "g_dbus_object_proxy_get_type", libgio.}
proc g_dbus_object_proxy_new*(connection: GDBusConnection;
                              object_path: cstring): GDBusObjectProxy {.
    importc: "g_dbus_object_proxy_new", libgio.}
proc get_connection*(proxy: GDBusObjectProxy): GDBusConnection {.
    importc: "g_dbus_object_proxy_get_connection", libgio.}
proc connection*(proxy: GDBusObjectProxy): GDBusConnection {.
    importc: "g_dbus_object_proxy_get_connection", libgio.}

template g_dbus_object_manager*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_object_manager_get_type(),
                              GDBusObjectManagerObj))

template g_is_dbus_object_manager*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_object_manager_get_type()))

template g_dbus_object_manager_get_iface*(o: expr): expr =
  (g_type_instance_get_interface(o, dbus_object_manager_get_type(),
                                 GDBusObjectManagerIfaceObj))

type
  GDBusObjectManagerIface* =  ptr GDBusObjectManagerIfaceObj
  GDBusObjectManagerIfacePtr* = ptr GDBusObjectManagerIfaceObj
  GDBusObjectManagerIfaceObj*{.final.} = object of GTypeInterfaceObj
    get_object_path*: proc (manager: GDBusObjectManager): cstring {.cdecl.}
    get_objects*: proc (manager: GDBusObjectManager): GList {.cdecl.}
    get_object*: proc (manager: GDBusObjectManager; object_path: cstring): GDBusObject {.cdecl.}
    get_interface*: proc (manager: GDBusObjectManager;
                          object_path: cstring; interface_name: cstring): GDBusInterface {.cdecl.}
    object_added*: proc (manager: GDBusObjectManager;
                         `object`: GDBusObject) {.cdecl.}
    object_removed*: proc (manager: GDBusObjectManager;
                           `object`: GDBusObject) {.cdecl.}
    interface_added*: proc (manager: GDBusObjectManager;
                            `object`: GDBusObject;
                            `interface`: GDBusInterface) {.cdecl.}
    interface_removed*: proc (manager: GDBusObjectManager;
                              `object`: GDBusObject;
                              `interface`: GDBusInterface) {.cdecl.}

proc g_dbus_object_manager_get_type*(): GType {.
    importc: "g_dbus_object_manager_get_type", libgio.}
proc get_object_path*(manager: GDBusObjectManager): cstring {.
    importc: "g_dbus_object_manager_get_object_path", libgio.}
proc object_path*(manager: GDBusObjectManager): cstring {.
    importc: "g_dbus_object_manager_get_object_path", libgio.}
proc get_objects*(manager: GDBusObjectManager): GList {.
    importc: "g_dbus_object_manager_get_objects", libgio.}
proc objects*(manager: GDBusObjectManager): GList {.
    importc: "g_dbus_object_manager_get_objects", libgio.}
proc get_object*(manager: GDBusObjectManager;
    object_path: cstring): GDBusObject {.
    importc: "g_dbus_object_manager_get_object", libgio.}
proc `object`*(manager: GDBusObjectManager;
    object_path: cstring): GDBusObject {.
    importc: "g_dbus_object_manager_get_object", libgio.}
proc get_interface*(manager: GDBusObjectManager;
    object_path: cstring; interface_name: cstring): GDBusInterface {.
    importc: "g_dbus_object_manager_get_interface", libgio.}
proc `interface`*(manager: GDBusObjectManager;
    object_path: cstring; interface_name: cstring): GDBusInterface {.
    importc: "g_dbus_object_manager_get_interface", libgio.}

template g_dbus_object_manager_client*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_object_manager_client_get_type(),
                              GDBusObjectManagerClientObj))

template g_dbus_object_manager_client_class*(k: expr): expr =
  (g_type_check_class_cast(k, dbus_object_manager_client_get_type(),
                           GDBusObjectManagerClientClassObj))

template g_dbus_object_manager_client_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, dbus_object_manager_client_get_type(),
                             GDBusObjectManagerClientClassObj))

template g_is_dbus_object_manager_client*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_object_manager_client_get_type()))

template g_is_dbus_object_manager_client_class*(k: expr): expr =
  (g_type_check_class_type(k, dbus_object_manager_client_get_type()))

type
  GDBusObjectManagerClientClass* =  ptr GDBusObjectManagerClientClassObj
  GDBusObjectManagerClientClassPtr* = ptr GDBusObjectManagerClientClassObj
  GDBusObjectManagerClientClassObj*{.final.} = object of GObjectClassObj
    interface_proxy_signal*: proc (manager: GDBusObjectManagerClient;
                                   object_proxy: GDBusObjectProxy;
                                   interface_proxy: GDBusProxy;
                                   sender_name: cstring; signal_name: cstring;
                                   parameters: GVariant) {.cdecl.}
    interface_proxy_properties_changed*: proc (
        manager: GDBusObjectManagerClient;
        object_proxy: GDBusObjectProxy; interface_proxy: GDBusProxy;
        changed_properties: GVariant; invalidated_properties: cstringArray) {.cdecl.}
    padding*: array[8, gpointer]

proc g_dbus_object_manager_client_get_type*(): GType {.
    importc: "g_dbus_object_manager_client_get_type", libgio.}
proc g_dbus_object_manager_client_new*(connection: GDBusConnection;
    flags: GDBusObjectManagerClientFlags; name: cstring; object_path: cstring;
    get_proxy_type_func: GDBusProxyTypeFunc;
    get_proxy_type_user_data: gpointer;
    get_proxy_type_destroy_notify: GDestroyNotify;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_dbus_object_manager_client_new",
                           libgio.}
proc g_dbus_object_manager_client_new_finish*(res: GAsyncResult;
    error: var GError): GDBusObjectManager {.
    importc: "g_dbus_object_manager_client_new_finish", libgio.}
proc g_dbus_object_manager_client_new_sync*(connection: GDBusConnection;
    flags: GDBusObjectManagerClientFlags; name: cstring; object_path: cstring;
    get_proxy_type_func: GDBusProxyTypeFunc;
    get_proxy_type_user_data: gpointer;
    get_proxy_type_destroy_notify: GDestroyNotify;
    cancellable: GCancellable; error: var GError): GDBusObjectManager {.
    importc: "g_dbus_object_manager_client_new_sync", libgio.}
proc g_dbus_object_manager_client_new_for_bus*(bus_type: GBusType;
    flags: GDBusObjectManagerClientFlags; name: cstring; object_path: cstring;
    get_proxy_type_func: GDBusProxyTypeFunc;
    get_proxy_type_user_data: gpointer;
    get_proxy_type_destroy_notify: GDestroyNotify;
    cancellable: GCancellable; callback: GAsyncReadyCallback;
    user_data: gpointer) {.importc: "g_dbus_object_manager_client_new_for_bus",
                           libgio.}
proc g_dbus_object_manager_client_new_for_bus_finish*(res: GAsyncResult;
    error: var GError): GDBusObjectManager {.
    importc: "g_dbus_object_manager_client_new_for_bus_finish", libgio.}
proc g_dbus_object_manager_client_new_for_bus_sync*(bus_type: GBusType;
    flags: GDBusObjectManagerClientFlags; name: cstring; object_path: cstring;
    get_proxy_type_func: GDBusProxyTypeFunc;
    get_proxy_type_user_data: gpointer;
    get_proxy_type_destroy_notify: GDestroyNotify;
    cancellable: GCancellable; error: var GError): GDBusObjectManager {.
    importc: "g_dbus_object_manager_client_new_for_bus_sync", libgio.}
proc get_connection*(
    manager: GDBusObjectManagerClient): GDBusConnection {.
    importc: "g_dbus_object_manager_client_get_connection", libgio.}
proc connection*(
    manager: GDBusObjectManagerClient): GDBusConnection {.
    importc: "g_dbus_object_manager_client_get_connection", libgio.}
proc get_flags*(
    manager: GDBusObjectManagerClient): GDBusObjectManagerClientFlags {.
    importc: "g_dbus_object_manager_client_get_flags", libgio.}
proc flags*(
    manager: GDBusObjectManagerClient): GDBusObjectManagerClientFlags {.
    importc: "g_dbus_object_manager_client_get_flags", libgio.}
proc get_name*(
    manager: GDBusObjectManagerClient): cstring {.
    importc: "g_dbus_object_manager_client_get_name", libgio.}
proc name*(
    manager: GDBusObjectManagerClient): cstring {.
    importc: "g_dbus_object_manager_client_get_name", libgio.}
proc get_name_owner*(
    manager: GDBusObjectManagerClient): cstring {.
    importc: "g_dbus_object_manager_client_get_name_owner", libgio.}
proc name_owner*(
    manager: GDBusObjectManagerClient): cstring {.
    importc: "g_dbus_object_manager_client_get_name_owner", libgio.}

template g_dbus_object_manager_server*(o: expr): expr =
  (g_type_check_instance_cast(o, dbus_object_manager_server_get_type(),
                              GDBusObjectManagerServerObj))

template g_dbus_object_manager_server_class*(k: expr): expr =
  (g_type_check_class_cast(k, dbus_object_manager_server_get_type(),
                           GDBusObjectManagerServerClassObj))

template g_dbus_object_manager_server_get_class*(o: expr): expr =
  (g_type_instance_get_class(o, dbus_object_manager_server_get_type(),
                             GDBusObjectManagerServerClassObj))

template g_is_dbus_object_manager_server*(o: expr): expr =
  (g_type_check_instance_type(o, dbus_object_manager_server_get_type()))

template g_is_dbus_object_manager_server_class*(k: expr): expr =
  (g_type_check_class_type(k, dbus_object_manager_server_get_type()))

type
  GDBusObjectManagerServerPrivateObj = object
 
type
  GDBusObjectManagerServer* =  ptr GDBusObjectManagerServerObj
  GDBusObjectManagerServerPtr* = ptr GDBusObjectManagerServerObj
  GDBusObjectManagerServerObj*{.final.} = object of GObjectObj
    priv55: ptr GDBusObjectManagerServerPrivateObj

type
  GDBusObjectManagerServerClass* =  ptr GDBusObjectManagerServerClassObj
  GDBusObjectManagerServerClassPtr* = ptr GDBusObjectManagerServerClassObj
  GDBusObjectManagerServerClassObj*{.final.} = object of GObjectClassObj
    padding*: array[8, gpointer]

proc g_dbus_object_manager_server_get_type*(): GType {.
    importc: "g_dbus_object_manager_server_get_type", libgio.}
proc g_dbus_object_manager_server_new*(object_path: cstring): GDBusObjectManagerServer {.
    importc: "g_dbus_object_manager_server_new", libgio.}
proc get_connection*(
    manager: GDBusObjectManagerServer): GDBusConnection {.
    importc: "g_dbus_object_manager_server_get_connection", libgio.}
proc connection*(
    manager: GDBusObjectManagerServer): GDBusConnection {.
    importc: "g_dbus_object_manager_server_get_connection", libgio.}
proc set_connection*(
    manager: GDBusObjectManagerServer; connection: GDBusConnection) {.
    importc: "g_dbus_object_manager_server_set_connection", libgio.}
proc `connection=`*(
    manager: GDBusObjectManagerServer; connection: GDBusConnection) {.
    importc: "g_dbus_object_manager_server_set_connection", libgio.}
proc `export`*(
    manager: GDBusObjectManagerServer; `object`: GDBusObjectSkeleton) {.
    importc: "g_dbus_object_manager_server_export", libgio.}
proc export_uniquely*(
    manager: GDBusObjectManagerServer; `object`: GDBusObjectSkeleton) {.
    importc: "g_dbus_object_manager_server_export_uniquely", libgio.}
proc is_exported*(
    manager: GDBusObjectManagerServer; `object`: GDBusObjectSkeleton): gboolean {.
    importc: "g_dbus_object_manager_server_is_exported", libgio.}
proc unexport*(
    manager: GDBusObjectManagerServer; object_path: cstring): gboolean {.
    importc: "g_dbus_object_manager_server_unexport", libgio.}

template g_dbus_action_group*(inst: expr): expr =
  (g_type_check_instance_cast(inst, dbus_action_group_get_type(),
                              GDBusActionGroupObj))

template g_dbus_action_group_class*(class: expr): expr =
  (g_type_check_class_cast(class, dbus_action_group_get_type(),
                           GDBusActionGroupClass))

template g_is_dbus_action_group*(inst: expr): expr =
  (g_type_check_instance_type(inst, dbus_action_group_get_type()))

template g_is_dbus_action_group_class*(class: expr): expr =
  (g_type_check_class_type(class, dbus_action_group_get_type()))

template g_dbus_action_group_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, dbus_action_group_get_type(),
                             GDBusActionGroupClass))

proc g_dbus_action_group_get_type*(): GType {.
    importc: "g_dbus_action_group_get_type", libgio.}
proc g_dbus_action_group_get*(connection: GDBusConnection;
                              bus_name: cstring; object_path: cstring): GDBusActionGroup {.
    importc: "g_dbus_action_group_get", libgio.}

template g_remote_action_group*(inst: expr): expr =
  (g_type_check_instance_cast(inst, remote_action_group_get_type(),
                              GRemoteActionGroupObj))

template g_is_remote_action_group*(inst: expr): expr =
  (g_type_check_instance_type(inst, remote_action_group_get_type()))

template g_remote_action_group_get_iface*(inst: expr): expr =
  (g_type_instance_get_interface(inst, remote_action_group_get_type(),
                                 GRemoteActionGroupInterfaceObj))

type
  GRemoteActionGroupInterface* =  ptr GRemoteActionGroupInterfaceObj
  GRemoteActionGroupInterfacePtr* = ptr GRemoteActionGroupInterfaceObj
  GRemoteActionGroupInterfaceObj*{.final.} = object of GTypeInterfaceObj
    activate_action_full*: proc (remote: GRemoteActionGroup;
                                 action_name: cstring;
                                 parameter: GVariant;
                                 platform_data: GVariant) {.cdecl.}
    change_action_state_full*: proc (remote: GRemoteActionGroup;
                                     action_name: cstring;
                                     value: GVariant;
                                     platform_data: GVariant) {.cdecl.}

proc g_remote_action_group_get_type*(): GType {.
    importc: "g_remote_action_group_get_type", libgio.}
proc activate_action_full*(
    remote: GRemoteActionGroup; action_name: cstring;
    parameter: GVariant; platform_data: GVariant) {.
    importc: "g_remote_action_group_activate_action_full", libgio.}
proc change_action_state_full*(
    remote: GRemoteActionGroup; action_name: cstring; value: GVariant;
    platform_data: GVariant) {.importc: "g_remote_action_group_change_action_state_full",
                                   libgio.}

type
  GMenuLinkIterPrivateObj = object
 
type
  GMenuLinkIter* =  ptr GMenuLinkIterObj
  GMenuLinkIterPtr* = ptr GMenuLinkIterObj
  GMenuLinkIterObj*{.final.} = object of GObjectObj
    priv58: ptr GMenuLinkIterPrivateObj

type
  GMenuAttributeIterPrivateObj = object
 
type
  GMenuAttributeIter* =  ptr GMenuAttributeIterObj
  GMenuAttributeIterPtr* = ptr GMenuAttributeIterObj
  GMenuAttributeIterObj*{.final.} = object of GObjectObj
    priv57: ptr GMenuAttributeIterPrivateObj

const
  G_MENU_ATTRIBUTE_ACTION* = "action"
const
  G_MENU_ATTRIBUTE_ACTION_NAMESPACE* = "action-namespace"
const
  G_MENU_ATTRIBUTE_TARGET* = "target"
const
  G_MENU_ATTRIBUTE_LABEL* = "label"
const
  G_MENU_ATTRIBUTE_ICON* = "icon"
const
  G_MENU_LINK_SUBMENU* = "submenu"
const
  G_MENU_LINK_SECTION* = "section"
template g_menu_model*(inst: expr): expr =
  (g_type_check_instance_cast(inst, menu_model_get_type(), GMenuModelObj))

template g_menu_model_class*(class: expr): expr =
  (g_type_check_class_cast(class, menu_model_get_type(), GMenuModelClassObj))

template g_is_menu_model*(inst: expr): expr =
  (g_type_check_instance_type(inst, menu_model_get_type()))

template g_is_menu_model_class*(class: expr): expr =
  (g_type_check_class_type(class, menu_model_get_type()))

template g_menu_model_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, menu_model_get_type(), GMenuModelClassObj))

type
  GMenuModelPrivateObj = object
 
type
  GMenuModel* =  ptr GMenuModelObj
  GMenuModelPtr* = ptr GMenuModelObj
  GMenuModelObj*{.final.} = object of GObjectObj
    priv56: ptr GMenuModelPrivateObj

type
  GMenuModelClass* =  ptr GMenuModelClassObj
  GMenuModelClassPtr* = ptr GMenuModelClassObj
  GMenuModelClassObj*{.final.} = object of GObjectClassObj
    is_mutable*: proc (model: GMenuModel): gboolean {.cdecl.}
    get_n_items*: proc (model: GMenuModel): gint {.cdecl.}
    get_item_attributes*: proc (model: GMenuModel; item_index: gint;
                                attributes: var glib.GHashTable) {.cdecl.}
    iterate_item_attributes*: proc (model: GMenuModel; item_index: gint): GMenuAttributeIter {.cdecl.}
    get_item_attribute_value*: proc (model: GMenuModel; item_index: gint;
                                     attribute: cstring;
                                     expected_type: GVariantType): GVariant {.cdecl.}
    get_item_links*: proc (model: GMenuModel; item_index: gint;
                           links: var glib.GHashTable) {.cdecl.}
    iterate_item_links*: proc (model: GMenuModel; item_index: gint): GMenuLinkIter {.cdecl.}
    get_item_link*: proc (model: GMenuModel; item_index: gint;
                          link: cstring): GMenuModel {.cdecl.}

proc g_menu_model_get_type*(): GType {.importc: "g_menu_model_get_type",
    libgio.}
proc is_mutable*(model: GMenuModel): gboolean {.
    importc: "g_menu_model_is_mutable", libgio.}
proc get_n_items*(model: GMenuModel): gint {.
    importc: "g_menu_model_get_n_items", libgio.}
proc n_items*(model: GMenuModel): gint {.
    importc: "g_menu_model_get_n_items", libgio.}
proc iterate_item_attributes*(model: GMenuModel;
    item_index: gint): GMenuAttributeIter {.
    importc: "g_menu_model_iterate_item_attributes", libgio.}
proc get_item_attribute_value*(model: GMenuModel;
    item_index: gint; attribute: cstring; expected_type: GVariantType): GVariant {.
    importc: "g_menu_model_get_item_attribute_value", libgio.}
proc item_attribute_value*(model: GMenuModel;
    item_index: gint; attribute: cstring; expected_type: GVariantType): GVariant {.
    importc: "g_menu_model_get_item_attribute_value", libgio.}
proc get_item_attribute*(model: GMenuModel; item_index: gint;
                                      attribute: cstring;
                                      format_string: cstring): gboolean {.
    varargs, importc: "g_menu_model_get_item_attribute", libgio.}
proc item_attribute*(model: GMenuModel; item_index: gint;
                                      attribute: cstring;
                                      format_string: cstring): gboolean {.
    varargs, importc: "g_menu_model_get_item_attribute", libgio.}
proc iterate_item_links*(model: GMenuModel; item_index: gint): GMenuLinkIter {.
    importc: "g_menu_model_iterate_item_links", libgio.}
proc get_item_link*(model: GMenuModel; item_index: gint;
                                 link: cstring): GMenuModel {.
    importc: "g_menu_model_get_item_link", libgio.}
proc item_link*(model: GMenuModel; item_index: gint;
                                 link: cstring): GMenuModel {.
    importc: "g_menu_model_get_item_link", libgio.}
proc items_changed*(model: GMenuModel; position: gint;
                                 removed: gint; added: gint) {.
    importc: "g_menu_model_items_changed", libgio.}
template g_menu_attribute_iter*(inst: expr): expr =
  (g_type_check_instance_cast(inst, menu_attribute_iter_get_type(),
                              GMenuAttributeIterObj))

template g_menu_attribute_iter_class*(class: expr): expr =
  (g_type_check_class_cast(class, menu_attribute_iter_get_type(),
                           GMenuAttributeIterClassObj))

template g_is_menu_attribute_iter*(inst: expr): expr =
  (g_type_check_instance_type(inst, menu_attribute_iter_get_type()))

template g_is_menu_attribute_iter_class*(class: expr): expr =
  (g_type_check_class_type(class, menu_attribute_iter_get_type()))

template g_menu_attribute_iter_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, menu_attribute_iter_get_type(),
                             GMenuAttributeIterClassObj))

type
  GMenuAttributeIterClass* =  ptr GMenuAttributeIterClassObj
  GMenuAttributeIterClassPtr* = ptr GMenuAttributeIterClassObj
  GMenuAttributeIterClassObj*{.final.} = object of GObjectClassObj
    get_next*: proc (iter: GMenuAttributeIter; out_name: cstringArray;
                     value: var GVariant): gboolean {.cdecl.}

proc g_menu_attribute_iter_get_type*(): GType {.
    importc: "g_menu_attribute_iter_get_type", libgio.}
proc get_next*(iter: GMenuAttributeIter;
                                     out_name: cstringArray;
                                     value: var GVariant): gboolean {.
    importc: "g_menu_attribute_iter_get_next", libgio.}
proc next*(iter: GMenuAttributeIter;
                                     out_name: cstringArray;
                                     value: var GVariant): gboolean {.
    importc: "g_menu_attribute_iter_get_next", libgio.}
proc next*(iter: GMenuAttributeIter): gboolean {.
    importc: "g_menu_attribute_iter_next", libgio.}
proc get_name*(iter: GMenuAttributeIter): cstring {.
    importc: "g_menu_attribute_iter_get_name", libgio.}
proc name*(iter: GMenuAttributeIter): cstring {.
    importc: "g_menu_attribute_iter_get_name", libgio.}
proc get_value*(iter: GMenuAttributeIter): GVariant {.
    importc: "g_menu_attribute_iter_get_value", libgio.}
proc value*(iter: GMenuAttributeIter): GVariant {.
    importc: "g_menu_attribute_iter_get_value", libgio.}
template g_menu_link_iter*(inst: expr): expr =
  (g_type_check_instance_cast(inst, menu_link_iter_get_type(), GMenuLinkIterObj))

template g_menu_link_iter_class*(class: expr): expr =
  (g_type_check_class_cast(class, menu_link_iter_get_type(), GMenuLinkIterClassObj))

template g_is_menu_link_iter*(inst: expr): expr =
  (g_type_check_instance_type(inst, menu_link_iter_get_type()))

template g_is_menu_link_iter_class*(class: expr): expr =
  (g_type_check_class_type(class, menu_link_iter_get_type()))

template g_menu_link_iter_get_class*(inst: expr): expr =
  (g_type_instance_get_class(inst, menu_link_iter_get_type(), GMenuLinkIterClassObj))

type
  GMenuLinkIterClass* =  ptr GMenuLinkIterClassObj
  GMenuLinkIterClassPtr* = ptr GMenuLinkIterClassObj
  GMenuLinkIterClassObj*{.final.} = object of GObjectClassObj
    get_next*: proc (iter: GMenuLinkIter; out_link: cstringArray;
                     value: var GMenuModel): gboolean {.cdecl.}

proc g_menu_link_iter_get_type*(): GType {.
    importc: "g_menu_link_iter_get_type", libgio.}
proc get_next*(iter: GMenuLinkIter;
                                out_link: cstringArray;
                                value: var GMenuModel): gboolean {.
    importc: "g_menu_link_iter_get_next", libgio.}
proc next*(iter: GMenuLinkIter;
                                out_link: cstringArray;
                                value: var GMenuModel): gboolean {.
    importc: "g_menu_link_iter_get_next", libgio.}
proc next*(iter: GMenuLinkIter): gboolean {.
    importc: "g_menu_link_iter_next", libgio.}
proc get_name*(iter: GMenuLinkIter): cstring {.
    importc: "g_menu_link_iter_get_name", libgio.}
proc name*(iter: GMenuLinkIter): cstring {.
    importc: "g_menu_link_iter_get_name", libgio.}
proc get_value*(iter: GMenuLinkIter): GMenuModel {.
    importc: "g_menu_link_iter_get_value", libgio.}
proc value*(iter: GMenuLinkIter): GMenuModel {.
    importc: "g_menu_link_iter_get_value", libgio.}

template g_menu*(inst: expr): expr =
  (g_type_check_instance_cast(inst, menu_get_type(), GMenuObj))

template g_is_menu*(inst: expr): expr =
  (g_type_check_instance_type(inst, menu_get_type()))

template g_menu_item*(inst: expr): expr =
  (g_type_check_instance_cast(inst, menu_item_get_type(), GMenuItemObj))

template g_is_menu_item*(inst: expr): expr =
  (g_type_check_instance_type(inst, menu_item_get_type()))

type
  GMenuItem* =  ptr GMenuItemObj
  GMenuItemPtr* = ptr GMenuItemObj
  GMenuItemObj* = object
 
  GMenu* =  ptr GMenuObj
  GMenuPtr* = ptr GMenuObj
  GMenuObj* = object
 
proc g_menu_get_type*(): GType {.importc: "g_menu_get_type", libgio.}
proc g_menu_new*(): GMenu {.importc: "g_menu_new", libgio.}
proc freeze*(menu: GMenu) {.importc: "g_menu_freeze", libgio.}
proc insert_item*(menu: GMenu; position: gint; item: GMenuItem) {.
    importc: "g_menu_insert_item", libgio.}
proc prepend_item*(menu: GMenu; item: GMenuItem) {.
    importc: "g_menu_prepend_item", libgio.}
proc append_item*(menu: GMenu; item: GMenuItem) {.
    importc: "g_menu_append_item", libgio.}
proc remove*(menu: GMenu; position: gint) {.
    importc: "g_menu_remove", libgio.}
proc remove_all*(menu: GMenu) {.importc: "g_menu_remove_all",
    libgio.}
proc insert*(menu: GMenu; position: gint; label: cstring;
                    detailed_action: cstring) {.importc: "g_menu_insert",
    libgio.}
proc prepend*(menu: GMenu; label: cstring; detailed_action: cstring) {.
    importc: "g_menu_prepend", libgio.}
proc append*(menu: GMenu; label: cstring; detailed_action: cstring) {.
    importc: "g_menu_append", libgio.}
proc insert_section*(menu: GMenu; position: gint; label: cstring;
                            section: GMenuModel) {.
    importc: "g_menu_insert_section", libgio.}
proc prepend_section*(menu: GMenu; label: cstring;
                             section: GMenuModel) {.
    importc: "g_menu_prepend_section", libgio.}
proc append_section*(menu: GMenu; label: cstring;
                            section: GMenuModel) {.
    importc: "g_menu_append_section", libgio.}
proc insert_submenu*(menu: GMenu; position: gint; label: cstring;
                            submenu: GMenuModel) {.
    importc: "g_menu_insert_submenu", libgio.}
proc prepend_submenu*(menu: GMenu; label: cstring;
                             submenu: GMenuModel) {.
    importc: "g_menu_prepend_submenu", libgio.}
proc append_submenu*(menu: GMenu; label: cstring;
                            submenu: GMenuModel) {.
    importc: "g_menu_append_submenu", libgio.}
proc g_menu_item_get_type*(): GType {.importc: "g_menu_item_get_type",
                                      libgio.}
proc g_menu_item_new*(label: cstring; detailed_action: cstring): GMenuItem {.
    importc: "g_menu_item_new", libgio.}
proc g_menu_item_new_from_model*(model: GMenuModel; item_index: gint): GMenuItem {.
    importc: "g_menu_item_new_from_model", libgio.}
proc g_menu_item_new_submenu*(label: cstring; submenu: GMenuModel): GMenuItem {.
    importc: "g_menu_item_new_submenu", libgio.}
proc g_menu_item_new_section*(label: cstring; section: GMenuModel): GMenuItem {.
    importc: "g_menu_item_new_section", libgio.}
proc get_attribute_value*(menu_item: GMenuItem;
                                      attribute: cstring;
                                      expected_type: GVariantType): GVariant {.
    importc: "g_menu_item_get_attribute_value", libgio.}
proc attribute_value*(menu_item: GMenuItem;
                                      attribute: cstring;
                                      expected_type: GVariantType): GVariant {.
    importc: "g_menu_item_get_attribute_value", libgio.}
proc get_attribute*(menu_item: GMenuItem; attribute: cstring;
                                format_string: cstring): gboolean {.varargs,
    importc: "g_menu_item_get_attribute", libgio.}
proc attribute*(menu_item: GMenuItem; attribute: cstring;
                                format_string: cstring): gboolean {.varargs,
    importc: "g_menu_item_get_attribute", libgio.}
proc get_link*(menu_item: GMenuItem; link: cstring): GMenuModel {.
    importc: "g_menu_item_get_link", libgio.}
proc link*(menu_item: GMenuItem; link: cstring): GMenuModel {.
    importc: "g_menu_item_get_link", libgio.}
proc set_attribute_value*(menu_item: GMenuItem;
                                      attribute: cstring; value: GVariant) {.
    importc: "g_menu_item_set_attribute_value", libgio.}
proc `attribute_value=`*(menu_item: GMenuItem;
                                      attribute: cstring; value: GVariant) {.
    importc: "g_menu_item_set_attribute_value", libgio.}
proc set_attribute*(menu_item: GMenuItem; attribute: cstring;
                                format_string: cstring) {.varargs,
    importc: "g_menu_item_set_attribute", libgio.}
proc `attribute=`*(menu_item: GMenuItem; attribute: cstring;
                                format_string: cstring) {.varargs,
    importc: "g_menu_item_set_attribute", libgio.}
proc set_link*(menu_item: GMenuItem; link: cstring;
                           model: GMenuModel) {.
    importc: "g_menu_item_set_link", libgio.}
proc `link=`*(menu_item: GMenuItem; link: cstring;
                           model: GMenuModel) {.
    importc: "g_menu_item_set_link", libgio.}
proc set_label*(menu_item: GMenuItem; label: cstring) {.
    importc: "g_menu_item_set_label", libgio.}
proc `label=`*(menu_item: GMenuItem; label: cstring) {.
    importc: "g_menu_item_set_label", libgio.}
proc set_submenu*(menu_item: GMenuItem;
                              submenu: GMenuModel) {.
    importc: "g_menu_item_set_submenu", libgio.}
proc `submenu=`*(menu_item: GMenuItem;
                              submenu: GMenuModel) {.
    importc: "g_menu_item_set_submenu", libgio.}
proc set_section*(menu_item: GMenuItem;
                              section: GMenuModel) {.
    importc: "g_menu_item_set_section", libgio.}
proc `section=`*(menu_item: GMenuItem;
                              section: GMenuModel) {.
    importc: "g_menu_item_set_section", libgio.}
proc set_action_and_target_value*(menu_item: GMenuItem;
    action: cstring; target_value: GVariant) {.
    importc: "g_menu_item_set_action_and_target_value", libgio.}
proc `action_and_target_value=`*(menu_item: GMenuItem;
    action: cstring; target_value: GVariant) {.
    importc: "g_menu_item_set_action_and_target_value", libgio.}
proc set_action_and_target*(menu_item: GMenuItem;
    action: cstring; format_string: cstring) {.varargs,
    importc: "g_menu_item_set_action_and_target", libgio.}
proc `action_and_target=`*(menu_item: GMenuItem;
    action: cstring; format_string: cstring) {.varargs,
    importc: "g_menu_item_set_action_and_target", libgio.}
proc set_detailed_action*(menu_item: GMenuItem;
                                      detailed_action: cstring) {.
    importc: "g_menu_item_set_detailed_action", libgio.}
proc `detailed_action=`*(menu_item: GMenuItem;
                                      detailed_action: cstring) {.
    importc: "g_menu_item_set_detailed_action", libgio.}
proc set_icon*(menu_item: GMenuItem; icon: GIcon) {.
    importc: "g_menu_item_set_icon", libgio.}
proc `icon=`*(menu_item: GMenuItem; icon: GIcon) {.
    importc: "g_menu_item_set_icon", libgio.}

proc export_menu_model*(connection: GDBusConnection;
    object_path: cstring; menu: GMenuModel; error: var GError): guint {.
    importc: "g_dbus_connection_export_menu_model", libgio.}
proc unexport_menu_model*(connection: GDBusConnection;
    export_id: guint) {.importc: "g_dbus_connection_unexport_menu_model",
                        libgio.}

template g_dbus_menu_model*(inst: expr): expr =
  (g_type_check_instance_cast(inst, dbus_menu_model_get_type(), GDBusMenuModelObj))

template g_is_dbus_menu_model*(inst: expr): expr =
  (g_type_check_instance_type(inst, dbus_menu_model_get_type()))

type
  GDBusMenuModel* =  ptr GDBusMenuModelObj
  GDBusMenuModelPtr* = ptr GDBusMenuModelObj
  GDBusMenuModelObj* = object
 
proc g_dbus_menu_model_get_type*(): GType {.
    importc: "g_dbus_menu_model_get_type", libgio.}
proc g_dbus_menu_model_get*(connection: GDBusConnection;
                            bus_name: cstring; object_path: cstring): GDBusMenuModel {.
    importc: "g_dbus_menu_model_get", libgio.}

template g_notification*(o: expr): expr =
  (g_type_check_instance_cast(o, notification_get_type(), GNotificationObj))

template g_is_notification*(o: expr): expr =
  (g_type_check_instance_type(o, notification_get_type()))

proc g_notification_get_type*(): GType {.importc: "g_notification_get_type",
    libgio.}
proc g_notification_new*(title: cstring): GNotification {.
    importc: "g_notification_new", libgio.}
proc set_title*(notification: GNotification; title: cstring) {.
    importc: "g_notification_set_title", libgio.}
proc `title=`*(notification: GNotification; title: cstring) {.
    importc: "g_notification_set_title", libgio.}
proc set_body*(notification: GNotification; body: cstring) {.
    importc: "g_notification_set_body", libgio.}
proc `body=`*(notification: GNotification; body: cstring) {.
    importc: "g_notification_set_body", libgio.}
proc set_icon*(notification: GNotification; icon: GIcon) {.
    importc: "g_notification_set_icon", libgio.}
proc `icon=`*(notification: GNotification; icon: GIcon) {.
    importc: "g_notification_set_icon", libgio.}
proc set_urgent*(notification: GNotification;
                                urgent: gboolean) {.
    importc: "g_notification_set_urgent", libgio.}
proc `urgent=`*(notification: GNotification;
                                urgent: gboolean) {.
    importc: "g_notification_set_urgent", libgio.}
proc set_priority*(notification: GNotification;
                                  priority: GNotificationPriority) {.
    importc: "g_notification_set_priority", libgio.}
proc `priority=`*(notification: GNotification;
                                  priority: GNotificationPriority) {.
    importc: "g_notification_set_priority", libgio.}
proc add_button*(notification: GNotification;
                                label: cstring; detailed_action: cstring) {.
    importc: "g_notification_add_button", libgio.}
proc add_button_with_target*(notification: GNotification;
    label: cstring; action: cstring; target_format: cstring) {.varargs,
    importc: "g_notification_add_button_with_target", libgio.}
proc add_button_with_target_value*(
    notification: GNotification; label: cstring; action: cstring;
    target: GVariant) {.importc: "g_notification_add_button_with_target_value",
                            libgio.}
proc set_default_action*(notification: GNotification;
    detailed_action: cstring) {.importc: "g_notification_set_default_action",
                                libgio.}
proc `default_action=`*(notification: GNotification;
    detailed_action: cstring) {.importc: "g_notification_set_default_action",
                                libgio.}
proc set_default_action_and_target*(
    notification: GNotification; action: cstring; target_format: cstring) {.
    varargs, importc: "g_notification_set_default_action_and_target",
    libgio.}
proc `default_action_and_target=`*(
    notification: GNotification; action: cstring; target_format: cstring) {.
    varargs, importc: "g_notification_set_default_action_and_target",
    libgio.}
proc set_default_action_and_target_value*(
    notification: GNotification; action: cstring; target: GVariant) {.
    importc: "g_notification_set_default_action_and_target_value", libgio.}
proc `default_action_and_target_value=`*(
    notification: GNotification; action: cstring; target: GVariant) {.
    importc: "g_notification_set_default_action_and_target_value", libgio.}

proc get_item_type*(list: GListModel): GType {.
    importc: "g_list_model_get_item_type", libgio.}

proc item_type*(list: GListModel): GType {.
    importc: "g_list_model_get_item_type", libgio.}
proc get_n_items*(list: GListModel): guint {.
    importc: "g_list_model_get_n_items", libgio.}
proc n_items*(list: GListModel): guint {.
    importc: "g_list_model_get_n_items", libgio.}
proc get_item*(list: GListModel; position: guint): gpointer {.
    importc: "g_list_model_get_item", libgio.}
proc item*(list: GListModel; position: guint): gpointer {.
    importc: "g_list_model_get_item", libgio.}
proc get_object*(list: GListModel; position: guint): GObject {.
    importc: "g_list_model_get_object", libgio.}
proc `object`*(list: GListModel; position: guint): GObject {.
    importc: "g_list_model_get_object", libgio.}
proc items_changed*(list: GListModel; position: guint;
                                 removed: guint; added: guint) {.
    importc: "g_list_model_items_changed", libgio.}

proc g_list_store_new*(item_type: GType): GListStore {.
    importc: "g_list_store_new", libgio.}
proc insert*(store: GListStore; position: guint;
                          item: gpointer) {.importc: "g_list_store_insert",
    libgio.}
proc insert_sorted*(store: GListStore; item: gpointer;
                                 compare_func: GCompareDataFunc;
                                 user_data: gpointer): guint {.
    importc: "g_list_store_insert_sorted", libgio.}
proc append*(store: GListStore; item: gpointer) {.
    importc: "g_list_store_append", libgio.}
proc remove*(store: GListStore; position: guint) {.
    importc: "g_list_store_remove", libgio.}
proc remove_all*(store: GListStore) {.
    importc: "g_list_store_remove_all", libgio.}
proc splice*(store: GListStore; position: guint;
                          n_removals: guint; additions: var gpointer;
                          n_additions: guint) {.
    importc: "g_list_store_splice", libgio.}
{.deprecated: [PGAppInfo: GAppInfo, TGAppInfo: GAppInfoObj].}
{.deprecated: [PGAsyncResult: GAsyncResult, TGAsyncResult: GAsyncResultObj].}
{.deprecated: [PGAsyncInitable: GAsyncInitable, TGAsyncInitable: GAsyncInitableObj].}
{.deprecated: [PGCharsetConverter: GCharsetConverter, TGCharsetConverter: GCharsetConverterObj].}
{.deprecated: [PGConverter: GConverter, TGConverter: GConverterObj].}
{.deprecated: [PGSimplePermission: GSimplePermission, TGSimplePermission: GSimplePermissionObj].}
{.deprecated: [PGZlibCompressor: GZlibCompressor, TGZlibCompressor: GZlibCompressorObj].}
{.deprecated: [PGZlibDecompressor: GZlibDecompressor, TGZlibDecompressor: GZlibDecompressorObj].}
{.deprecated: [PGRemoteActionGroup: GRemoteActionGroup, TGRemoteActionGroup: GRemoteActionGroupObj].}
{.deprecated: [PGDBusActionGroup: GDBusActionGroup, TGDBusActionGroup: GDBusActionGroupObj].}
{.deprecated: [PGActionMap: GActionMap, TGActionMap: GActionMapObj].}
{.deprecated: [PGActionGroup: GActionGroup, TGActionGroup: GActionGroupObj].}
{.deprecated: [PGPropertyAction: GPropertyAction, TGPropertyAction: GPropertyActionObj].}
{.deprecated: [PGSimpleAction: GSimpleAction, TGSimpleAction: GSimpleActionObj].}
{.deprecated: [PGAction: GAction, TGAction: GActionObj].}
{.deprecated: [PGSettingsBackend: GSettingsBackend, TGSettingsBackend: GSettingsBackendObj].}
{.deprecated: [PGNotification: GNotification, TGNotification: GNotificationObj].}
{.deprecated: [PGListModel: GListModel, TGListModel: GListModelObj].}
{.deprecated: [PGListStore: GListStore, TGListStore: GListStoreObj].}
{.deprecated: [PGDrive: GDrive, TGDrive: GDriveObj].}
{.deprecated: [PGFile: GFile, TGFile: GFileObj].}
{.deprecated: [PGFileInfo: GFileInfo, TGFileInfo: GFileInfoObj].}
{.deprecated: [PGFileAttributeMatcher: GFileAttributeMatcher, TGFileAttributeMatcher: GFileAttributeMatcherObj].}
{.deprecated: [PGFileDescriptorBased: GFileDescriptorBased, TGFileDescriptorBased: GFileDescriptorBasedObj].}
{.deprecated: [PGFileIcon: GFileIcon, TGFileIcon: GFileIconObj].}
{.deprecated: [PGFilenameCompleter: GFilenameCompleter, TGFilenameCompleter: GFilenameCompleterObj].}
{.deprecated: [PGIcon: GIcon, TGIcon: GIconObj].}
{.deprecated: [PGInitable: GInitable, TGInitable: GInitableObj].}
{.deprecated: [PGIOModule: GIOModule, TGIOModule: GIOModuleObj].}
{.deprecated: [PGIOExtensionPoint: GIOExtensionPoint, TGIOExtensionPoint: GIOExtensionPointObj].}
{.deprecated: [PGIOExtension: GIOExtension, TGIOExtension: GIOExtensionObj].}
{.deprecated: [PGIOSchedulerJob: GIOSchedulerJob, TGIOSchedulerJob: GIOSchedulerJobObj].}
{.deprecated: [PGIOStreamAdapter: GIOStreamAdapter, TGIOStreamAdapter: GIOStreamAdapterObj].}
{.deprecated: [PGLoadableIcon: GLoadableIcon, TGLoadableIcon: GLoadableIconObj].}
{.deprecated: [PGBytesIcon: GBytesIcon, TGBytesIcon: GBytesIconObj].}
{.deprecated: [PGMount: GMount, TGMount: GMountObj].}
{.deprecated: [PGNetworkMonitor: GNetworkMonitor, TGNetworkMonitor: GNetworkMonitorObj].}
{.deprecated: [PGSimpleIOStream: GSimpleIOStream, TGSimpleIOStream: GSimpleIOStreamObj].}
{.deprecated: [PGPollableInputStream: GPollableInputStream, TGPollableInputStream: GPollableInputStreamObj].}
{.deprecated: [PGPollableOutputStream: GPollableOutputStream, TGPollableOutputStream: GPollableOutputStreamObj].}
{.deprecated: [PGResource: GResource, TGResource: GResourceObj].}
{.deprecated: [PGSeekable: GSeekable, TGSeekable: GSeekableObj].}
{.deprecated: [PGSimpleAsyncResult: GSimpleAsyncResult, TGSimpleAsyncResult: GSimpleAsyncResultObj].}
{.deprecated: [PGSocketConnectable: GSocketConnectable, TGSocketConnectable: GSocketConnectableObj].}
{.deprecated: [PGSrvTarget: GSrvTarget, TGSrvTarget: GSrvTargetObj].}
{.deprecated: [PGTask: GTask, TGTask: GTaskObj].}
{.deprecated: [PGThemedIcon: GThemedIcon, TGThemedIcon: GThemedIconObj].}
{.deprecated: [PGTlsClientConnection: GTlsClientConnection, TGTlsClientConnection: GTlsClientConnectionObj].}
{.deprecated: [PGTlsFileDatabase: GTlsFileDatabase, TGTlsFileDatabase: GTlsFileDatabaseObj].}
{.deprecated: [PGTlsServerConnection: GTlsServerConnection, TGTlsServerConnection: GTlsServerConnectionObj].}
{.deprecated: [PGProxyResolver: GProxyResolver, TGProxyResolver: GProxyResolverObj].}
{.deprecated: [PGProxy: GProxy, TGProxy: GProxyObj].}
{.deprecated: [PGVolume: GVolume, TGVolume: GVolumeObj].}
{.deprecated: [PGInputVector: GInputVector, TGInputVector: GInputVectorObj].}
{.deprecated: [PGOutputVector: GOutputVector, TGOutputVector: GOutputVectorObj].}
{.deprecated: [PGOutputMessage: GOutputMessage, TGOutputMessage: GOutputMessageObj].}
{.deprecated: [PGCredentials: GCredentials, TGCredentials: GCredentialsObj].}
{.deprecated: [PGUnixCredentialsMessage: GUnixCredentialsMessage, TGUnixCredentialsMessage: GUnixCredentialsMessageObj].}
{.deprecated: [PGUnixFDList: GUnixFDList, TGUnixFDList: GUnixFDListObj].}
{.deprecated: [PGDBusMessage: GDBusMessage, TGDBusMessage: GDBusMessageObj].}
{.deprecated: [PGDBusConnection: GDBusConnection, TGDBusConnection: GDBusConnectionObj].}
{.deprecated: [PGDBusMethodInvocation: GDBusMethodInvocation, TGDBusMethodInvocation: GDBusMethodInvocationObj].}
{.deprecated: [PGDBusServer: GDBusServer, TGDBusServer: GDBusServerObj].}
{.deprecated: [PGDBusAuthObserver: GDBusAuthObserver, TGDBusAuthObserver: GDBusAuthObserverObj].}
{.deprecated: [PGDBusInterface: GDBusInterface, TGDBusInterface: GDBusInterfaceObj].}
{.deprecated: [PGDBusObject: GDBusObject, TGDBusObject: GDBusObjectObj].}
{.deprecated: [PGDBusObjectManager: GDBusObjectManager, TGDBusObjectManager: GDBusObjectManagerObj].}
{.deprecated: [PGTestDBus: GTestDBus, TGTestDBus: GTestDBusObj].}
{.deprecated: [PGSubprocess: GSubprocess, TGSubprocess: GSubprocessObj].}
{.deprecated: [PGSubprocessLauncher: GSubprocessLauncher, TGSubprocessLauncher: GSubprocessLauncherObj].}
{.deprecated: [PGActionInterface: GActionInterface, TGActionInterface: GActionInterfaceObj].}
{.deprecated: [PGActionGroupInterface: GActionGroupInterface, TGActionGroupInterface: GActionGroupInterfaceObj].}
{.deprecated: [PGActionMapInterface: GActionMapInterface, TGActionMapInterface: GActionMapInterfaceObj].}
{.deprecated: [PGActionEntry: GActionEntry, TGActionEntry: GActionEntryObj].}
{.deprecated: [PGAppInfoIface: GAppInfoIface, TGAppInfoIface: GAppInfoIfaceObj].}
{.deprecated: [PGAppLaunchContext: GAppLaunchContext, TGAppLaunchContext: GAppLaunchContextObj].}
{.deprecated: [PGAppLaunchContextClass: GAppLaunchContextClass, TGAppLaunchContextClass: GAppLaunchContextClassObj].}
{.deprecated: [PGAppInfoMonitor: GAppInfoMonitor, TGAppInfoMonitor: GAppInfoMonitorObj].}
{.deprecated: [PGApplication: GApplication, TGApplication: GApplicationObj].}
{.deprecated: [PGApplicationClass: GApplicationClass, TGApplicationClass: GApplicationClassObj].}
{.deprecated: [PGApplicationCommandLine: GApplicationCommandLine, TGApplicationCommandLine: GApplicationCommandLineObj].}
{.deprecated: [PGApplicationCommandLineClass: GApplicationCommandLineClass, TGApplicationCommandLineClass: GApplicationCommandLineClassObj].}
{.deprecated: [PGInitableIface: GInitableIface, TGInitableIface: GInitableIfaceObj].}
{.deprecated: [PGAsyncInitableIface: GAsyncInitableIface, TGAsyncInitableIface: GAsyncInitableIfaceObj].}
{.deprecated: [PGAsyncResultIface: GAsyncResultIface, TGAsyncResultIface: GAsyncResultIfaceObj].}
{.deprecated: [PGInputStream: GInputStream, TGInputStream: GInputStreamObj].}
{.deprecated: [PGInputStreamClass: GInputStreamClass, TGInputStreamClass: GInputStreamClassObj].}
{.deprecated: [PGFilterInputStream: GFilterInputStream, TGFilterInputStream: GFilterInputStreamObj].}
{.deprecated: [PGFilterInputStreamClass: GFilterInputStreamClass, TGFilterInputStreamClass: GFilterInputStreamClassObj].}
{.deprecated: [PGBufferedInputStream: GBufferedInputStream, TGBufferedInputStream: GBufferedInputStreamObj].}
{.deprecated: [PGBufferedInputStreamClass: GBufferedInputStreamClass, TGBufferedInputStreamClass: GBufferedInputStreamClassObj].}
{.deprecated: [PGOutputStream: GOutputStream, TGOutputStream: GOutputStreamObj].}
{.deprecated: [PGOutputStreamClass: GOutputStreamClass, TGOutputStreamClass: GOutputStreamClassObj].}
{.deprecated: [PGFilterOutputStream: GFilterOutputStream, TGFilterOutputStream: GFilterOutputStreamObj].}
{.deprecated: [PGFilterOutputStreamClass: GFilterOutputStreamClass, TGFilterOutputStreamClass: GFilterOutputStreamClassObj].}
{.deprecated: [PGBufferedOutputStream: GBufferedOutputStream, TGBufferedOutputStream: GBufferedOutputStreamObj].}
{.deprecated: [PGBufferedOutputStreamClass: GBufferedOutputStreamClass, TGBufferedOutputStreamClass: GBufferedOutputStreamClassObj].}
{.deprecated: [PGCancellable: GCancellable, TGCancellable: GCancellableObj].}
{.deprecated: [PGCancellableClass: GCancellableClass, TGCancellableClass: GCancellableClassObj].}
{.deprecated: [PGConverterIface: GConverterIface, TGConverterIface: GConverterIfaceObj].}
{.deprecated: [PGCharsetConverterClass: GCharsetConverterClass, TGCharsetConverterClass: GCharsetConverterClassObj].}
{.deprecated: [PGConverterInputStream: GConverterInputStream, TGConverterInputStream: GConverterInputStreamObj].}
{.deprecated: [PGConverterInputStreamClass: GConverterInputStreamClass, TGConverterInputStreamClass: GConverterInputStreamClassObj].}
{.deprecated: [PGConverterOutputStream: GConverterOutputStream, TGConverterOutputStream: GConverterOutputStreamObj].}
{.deprecated: [PGConverterOutputStreamClass: GConverterOutputStreamClass, TGConverterOutputStreamClass: GConverterOutputStreamClassObj].}
{.deprecated: [PGCredentialsClass: GCredentialsClass, TGCredentialsClass: GCredentialsClassObj].}
{.deprecated: [PGDataInputStream: GDataInputStream, TGDataInputStream: GDataInputStreamObj].}
{.deprecated: [PGDataInputStreamClass: GDataInputStreamClass, TGDataInputStreamClass: GDataInputStreamClassObj].}
{.deprecated: [PGDataOutputStream: GDataOutputStream, TGDataOutputStream: GDataOutputStreamObj].}
{.deprecated: [PGDataOutputStreamClass: GDataOutputStreamClass, TGDataOutputStreamClass: GDataOutputStreamClassObj].}
{.deprecated: [PGDBusInterfaceVTable: GDBusInterfaceVTable, TGDBusInterfaceVTable: GDBusInterfaceVTableObj].}
{.deprecated: [PGDBusSubtreeVTable: GDBusSubtreeVTable, TGDBusSubtreeVTable: GDBusSubtreeVTableObj].}
{.deprecated: [PGDBusErrorEntry: GDBusErrorEntry, TGDBusErrorEntry: GDBusErrorEntryObj].}
{.deprecated: [PGDBusAnnotationInfo: GDBusAnnotationInfo, TGDBusAnnotationInfo: GDBusAnnotationInfoObj].}
{.deprecated: [PGDBusArgInfo: GDBusArgInfo, TGDBusArgInfo: GDBusArgInfoObj].}
{.deprecated: [PGDBusMethodInfo: GDBusMethodInfo, TGDBusMethodInfo: GDBusMethodInfoObj].}
{.deprecated: [PGDBusSignalInfo: GDBusSignalInfo, TGDBusSignalInfo: GDBusSignalInfoObj].}
{.deprecated: [PGDBusPropertyInfo: GDBusPropertyInfo, TGDBusPropertyInfo: GDBusPropertyInfoObj].}
{.deprecated: [PGDBusInterfaceInfo: GDBusInterfaceInfo, TGDBusInterfaceInfo: GDBusInterfaceInfoObj].}
{.deprecated: [PGDBusNodeInfo: GDBusNodeInfo, TGDBusNodeInfo: GDBusNodeInfoObj].}
{.deprecated: [PGDBusProxy: GDBusProxy, TGDBusProxy: GDBusProxyObj].}
{.deprecated: [PGDBusProxyClass: GDBusProxyClass, TGDBusProxyClass: GDBusProxyClassObj].}
{.deprecated: [PGDriveIface: GDriveIface, TGDriveIface: GDriveIfaceObj].}
{.deprecated: [PGIconIface: GIconIface, TGIconIface: GIconIfaceObj].}
{.deprecated: [PGEmblem: GEmblem, TGEmblem: GEmblemObj].}
{.deprecated: [PGEmblemClass: GEmblemClass, TGEmblemClass: GEmblemClassObj].}
{.deprecated: [PGEmblemedIcon: GEmblemedIcon, TGEmblemedIcon: GEmblemedIconObj].}
{.deprecated: [PGEmblemedIconClass: GEmblemedIconClass, TGEmblemedIconClass: GEmblemedIconClassObj].}
{.deprecated: [PGFileAttributeInfo: GFileAttributeInfo, TGFileAttributeInfo: GFileAttributeInfoObj].}
{.deprecated: [PGFileAttributeInfoList: GFileAttributeInfoList, TGFileAttributeInfoList: GFileAttributeInfoListObj].}
{.deprecated: [PGFileEnumerator: GFileEnumerator, TGFileEnumerator: GFileEnumeratorObj].}
{.deprecated: [PGFileEnumeratorClass: GFileEnumeratorClass, TGFileEnumeratorClass: GFileEnumeratorClassObj].}
{.deprecated: [PGFileIface: GFileIface, TGFileIface: GFileIfaceObj].}
{.deprecated: [PGFileIconClass: GFileIconClass, TGFileIconClass: GFileIconClassObj].}
{.deprecated: [PGFileInfoClass: GFileInfoClass, TGFileInfoClass: GFileInfoClassObj].}
{.deprecated: [PGFileInputStream: GFileInputStream, TGFileInputStream: GFileInputStreamObj].}
{.deprecated: [PGFileInputStreamClass: GFileInputStreamClass, TGFileInputStreamClass: GFileInputStreamClassObj].}
{.deprecated: [PGIOStream: GIOStream, TGIOStream: GIOStreamObj].}
{.deprecated: [PGIOStreamClass: GIOStreamClass, TGIOStreamClass: GIOStreamClassObj].}
{.deprecated: [PGFileIOStream: GFileIOStream, TGFileIOStream: GFileIOStreamObj].}
{.deprecated: [PGFileIOStreamClass: GFileIOStreamClass, TGFileIOStreamClass: GFileIOStreamClassObj].}
{.deprecated: [PGFileMonitor: GFileMonitor, TGFileMonitor: GFileMonitorObj].}
{.deprecated: [PGFileMonitorClass: GFileMonitorClass, TGFileMonitorClass: GFileMonitorClassObj].}
{.deprecated: [PGFilenameCompleterClass: GFilenameCompleterClass, TGFilenameCompleterClass: GFilenameCompleterClassObj].}
{.deprecated: [PGFileOutputStream: GFileOutputStream, TGFileOutputStream: GFileOutputStreamObj].}
{.deprecated: [PGFileOutputStreamClass: GFileOutputStreamClass, TGFileOutputStreamClass: GFileOutputStreamClassObj].}
{.deprecated: [PGInetAddress: GInetAddress, TGInetAddress: GInetAddressObj].}
{.deprecated: [PGInetAddressClass: GInetAddressClass, TGInetAddressClass: GInetAddressClassObj].}
{.deprecated: [PGInetAddressMask: GInetAddressMask, TGInetAddressMask: GInetAddressMaskObj].}
{.deprecated: [PGInetAddressMaskClass: GInetAddressMaskClass, TGInetAddressMaskClass: GInetAddressMaskClassObj].}
{.deprecated: [PGSocketAddress: GSocketAddress, TGSocketAddress: GSocketAddressObj].}
{.deprecated: [PGSocketAddressClass: GSocketAddressClass, TGSocketAddressClass: GSocketAddressClassObj].}
{.deprecated: [PGInetSocketAddress: GInetSocketAddress, TGInetSocketAddress: GInetSocketAddressObj].}
{.deprecated: [PGInetSocketAddressClass: GInetSocketAddressClass, TGInetSocketAddressClass: GInetSocketAddressClassObj].}
{.deprecated: [PGIOModuleScope: GIOModuleScope, TGIOModuleScope: GIOModuleScopeObj].}
{.deprecated: [PGIOModuleClass: GIOModuleClass, TGIOModuleClass: GIOModuleClassObj].}
{.deprecated: [PGLoadableIconIface: GLoadableIconIface, TGLoadableIconIface: GLoadableIconIfaceObj].}
{.deprecated: [PGMemoryInputStream: GMemoryInputStream, TGMemoryInputStream: GMemoryInputStreamObj].}
{.deprecated: [PGMemoryInputStreamClass: GMemoryInputStreamClass, TGMemoryInputStreamClass: GMemoryInputStreamClassObj].}
{.deprecated: [PGMemoryOutputStream: GMemoryOutputStream, TGMemoryOutputStream: GMemoryOutputStreamObj].}
{.deprecated: [PGMemoryOutputStreamClass: GMemoryOutputStreamClass, TGMemoryOutputStreamClass: GMemoryOutputStreamClassObj].}
{.deprecated: [PGMountIface: GMountIface, TGMountIface: GMountIfaceObj].}
{.deprecated: [PGMountOperation: GMountOperation, TGMountOperation: GMountOperationObj].}
{.deprecated: [PGMountOperationClass: GMountOperationClass, TGMountOperationClass: GMountOperationClassObj].}
{.deprecated: [PGVolumeMonitor: GVolumeMonitor, TGVolumeMonitor: GVolumeMonitorObj].}
{.deprecated: [PGVolumeMonitorClass: GVolumeMonitorClass, TGVolumeMonitorClass: GVolumeMonitorClassObj].}
{.deprecated: [PGNativeVolumeMonitor: GNativeVolumeMonitor, TGNativeVolumeMonitor: GNativeVolumeMonitorObj].}
{.deprecated: [PGNativeVolumeMonitorClass: GNativeVolumeMonitorClass, TGNativeVolumeMonitorClass: GNativeVolumeMonitorClassObj].}
{.deprecated: [PGNetworkAddress: GNetworkAddress, TGNetworkAddress: GNetworkAddressObj].}
{.deprecated: [PGNetworkAddressClass: GNetworkAddressClass, TGNetworkAddressClass: GNetworkAddressClassObj].}
{.deprecated: [PGNetworkMonitorInterface: GNetworkMonitorInterface, TGNetworkMonitorInterface: GNetworkMonitorInterfaceObj].}
{.deprecated: [PGNetworkService: GNetworkService, TGNetworkService: GNetworkServiceObj].}
{.deprecated: [PGNetworkServiceClass: GNetworkServiceClass, TGNetworkServiceClass: GNetworkServiceClassObj].}
{.deprecated: [PGPermission: GPermission, TGPermission: GPermissionObj].}
{.deprecated: [PGPermissionClass: GPermissionClass, TGPermissionClass: GPermissionClassObj].}
{.deprecated: [PGPollableInputStreamInterface: GPollableInputStreamInterface, TGPollableInputStreamInterface: GPollableInputStreamInterfaceObj].}
{.deprecated: [PGPollableOutputStreamInterface: GPollableOutputStreamInterface, TGPollableOutputStreamInterface: GPollableOutputStreamInterfaceObj].}
{.deprecated: [PGProxyInterface: GProxyInterface, TGProxyInterface: GProxyInterfaceObj].}
{.deprecated: [PGProxyAddress: GProxyAddress, TGProxyAddress: GProxyAddressObj].}
{.deprecated: [PGProxyAddressClass: GProxyAddressClass, TGProxyAddressClass: GProxyAddressClassObj].}
{.deprecated: [PGSocketAddressEnumerator: GSocketAddressEnumerator, TGSocketAddressEnumerator: GSocketAddressEnumeratorObj].}
{.deprecated: [PGSocketAddressEnumeratorClass: GSocketAddressEnumeratorClass, TGSocketAddressEnumeratorClass: GSocketAddressEnumeratorClassObj].}
{.deprecated: [PGProxyAddressEnumerator: GProxyAddressEnumerator, TGProxyAddressEnumerator: GProxyAddressEnumeratorObj].}
{.deprecated: [PGProxyAddressEnumeratorClass: GProxyAddressEnumeratorClass, TGProxyAddressEnumeratorClass: GProxyAddressEnumeratorClassObj].}
{.deprecated: [PGProxyResolverInterface: GProxyResolverInterface, TGProxyResolverInterface: GProxyResolverInterfaceObj].}
{.deprecated: [PGResolver: GResolver, TGResolver: GResolverObj].}
{.deprecated: [PGResolverClass: GResolverClass, TGResolverClass: GResolverClassObj].}
{.deprecated: [PGStaticResource: GStaticResource, TGStaticResource: GStaticResourceObj].}
{.deprecated: [PGSeekableIface: GSeekableIface, TGSeekableIface: GSeekableIfaceObj].}
{.deprecated: [PGSettingsSchemaSource: GSettingsSchemaSource, TGSettingsSchemaSource: GSettingsSchemaSourceObj].}
{.deprecated: [PGSettingsSchema: GSettingsSchema, TGSettingsSchema: GSettingsSchemaObj].}
{.deprecated: [PGSettingsSchemaKey: GSettingsSchemaKey, TGSettingsSchemaKey: GSettingsSchemaKeyObj].}
{.deprecated: [PGSettingsClass: GSettingsClass, TGSettingsClass: GSettingsClassObj].}
{.deprecated: [PGSettings: GSettings, TGSettings: GSettingsObj].}
{.deprecated: [PGSimpleActionGroup: GSimpleActionGroup, TGSimpleActionGroup: GSimpleActionGroupObj].}
{.deprecated: [PGSimpleActionGroupClass: GSimpleActionGroupClass, TGSimpleActionGroupClass: GSimpleActionGroupClassObj].}
{.deprecated: [PGSimpleAsyncResultClass: GSimpleAsyncResultClass, TGSimpleAsyncResultClass: GSimpleAsyncResultClassObj].}
{.deprecated: [PGSocketClientClass: GSocketClientClass, TGSocketClientClass: GSocketClientClassObj].}
{.deprecated: [PGSocketClient: GSocketClient, TGSocketClient: GSocketClientObj].}
{.deprecated: [PGSocketConnectableIface: GSocketConnectableIface, TGSocketConnectableIface: GSocketConnectableIfaceObj].}
{.deprecated: [PGSocketClass: GSocketClass, TGSocketClass: GSocketClassObj].}
{.deprecated: [PGSocket: GSocket, TGSocket: GSocketObj].}
{.deprecated: [PGSocketConnectionClass: GSocketConnectionClass, TGSocketConnectionClass: GSocketConnectionClassObj].}
{.deprecated: [PGSocketConnection: GSocketConnection, TGSocketConnection: GSocketConnectionObj].}
{.deprecated: [PGSocketControlMessageClass: GSocketControlMessageClass, TGSocketControlMessageClass: GSocketControlMessageClassObj].}
{.deprecated: [PGSocketControlMessage: GSocketControlMessage, TGSocketControlMessage: GSocketControlMessageObj].}
{.deprecated: [PGSocketListenerClass: GSocketListenerClass, TGSocketListenerClass: GSocketListenerClassObj].}
{.deprecated: [PGSocketListener: GSocketListener, TGSocketListener: GSocketListenerObj].}
{.deprecated: [PGSocketServiceClass: GSocketServiceClass, TGSocketServiceClass: GSocketServiceClassObj].}
{.deprecated: [PGSocketService: GSocketService, TGSocketService: GSocketServiceObj].}
{.deprecated: [PGSimpleProxyResolver: GSimpleProxyResolver, TGSimpleProxyResolver: GSimpleProxyResolverObj].}
{.deprecated: [PGSimpleProxyResolverClass: GSimpleProxyResolverClass, TGSimpleProxyResolverClass: GSimpleProxyResolverClassObj].}
{.deprecated: [PGTaskClass: GTaskClass, TGTaskClass: GTaskClassObj].}
{.deprecated: [PGTcpConnectionClass: GTcpConnectionClass, TGTcpConnectionClass: GTcpConnectionClassObj].}
{.deprecated: [PGTcpConnection: GTcpConnection, TGTcpConnection: GTcpConnectionObj].}
{.deprecated: [PGTcpWrapperConnectionClass: GTcpWrapperConnectionClass, TGTcpWrapperConnectionClass: GTcpWrapperConnectionClassObj].}
{.deprecated: [PGTcpWrapperConnection: GTcpWrapperConnection, TGTcpWrapperConnection: GTcpWrapperConnectionObj].}
{.deprecated: [PGThemedIconClass: GThemedIconClass, TGThemedIconClass: GThemedIconClassObj].}
{.deprecated: [PGThreadedSocketServiceClass: GThreadedSocketServiceClass, TGThreadedSocketServiceClass: GThreadedSocketServiceClassObj].}
{.deprecated: [PGThreadedSocketService: GThreadedSocketService, TGThreadedSocketService: GThreadedSocketServiceObj].}
{.deprecated: [PGTlsBackend: GTlsBackend, TGTlsBackend: GTlsBackendObj].}
{.deprecated: [PGTlsBackendInterface: GTlsBackendInterface, TGTlsBackendInterface: GTlsBackendInterfaceObj].}
{.deprecated: [PGTlsCertificate: GTlsCertificate, TGTlsCertificate: GTlsCertificateObj].}
{.deprecated: [PGTlsCertificateClass: GTlsCertificateClass, TGTlsCertificateClass: GTlsCertificateClassObj].}
{.deprecated: [PGTlsConnection: GTlsConnection, TGTlsConnection: GTlsConnectionObj].}
{.deprecated: [PGTlsConnectionClass: GTlsConnectionClass, TGTlsConnectionClass: GTlsConnectionClassObj].}
{.deprecated: [PGTlsClientConnectionInterface: GTlsClientConnectionInterface, TGTlsClientConnectionInterface: GTlsClientConnectionInterfaceObj].}
{.deprecated: [PGTlsDatabase: GTlsDatabase, TGTlsDatabase: GTlsDatabaseObj].}
{.deprecated: [PGTlsDatabaseClass: GTlsDatabaseClass, TGTlsDatabaseClass: GTlsDatabaseClassObj].}
{.deprecated: [PGTlsFileDatabaseInterface: GTlsFileDatabaseInterface, TGTlsFileDatabaseInterface: GTlsFileDatabaseInterfaceObj].}
{.deprecated: [PGTlsInteraction: GTlsInteraction, TGTlsInteraction: GTlsInteractionObj].}
{.deprecated: [PGTlsInteractionClass: GTlsInteractionClass, TGTlsInteractionClass: GTlsInteractionClassObj].}
{.deprecated: [PGTlsServerConnectionInterface: GTlsServerConnectionInterface, TGTlsServerConnectionInterface: GTlsServerConnectionInterfaceObj].}
{.deprecated: [PGTlsPassword: GTlsPassword, TGTlsPassword: GTlsPasswordObj].}
{.deprecated: [PGTlsPasswordClass: GTlsPasswordClass, TGTlsPasswordClass: GTlsPasswordClassObj].}
{.deprecated: [PGVfs: GVfs, TGVfs: GVfsObj].}
{.deprecated: [PGVfsClass: GVfsClass, TGVfsClass: GVfsClassObj].}
{.deprecated: [PGVolumeIface: GVolumeIface, TGVolumeIface: GVolumeIfaceObj].}
{.deprecated: [PGZlibCompressorClass: GZlibCompressorClass, TGZlibCompressorClass: GZlibCompressorClassObj].}
{.deprecated: [PGZlibDecompressorClass: GZlibDecompressorClass, TGZlibDecompressorClass: GZlibDecompressorClassObj].}
{.deprecated: [PGDBusInterfaceIface: GDBusInterfaceIface, TGDBusInterfaceIface: GDBusInterfaceIfaceObj].}
{.deprecated: [PGDBusInterfaceSkeleton: GDBusInterfaceSkeleton, TGDBusInterfaceSkeleton: GDBusInterfaceSkeletonObj].}
{.deprecated: [PGDBusInterfaceSkeletonClass: GDBusInterfaceSkeletonClass, TGDBusInterfaceSkeletonClass: GDBusInterfaceSkeletonClassObj].}
{.deprecated: [PGDBusObjectIface: GDBusObjectIface, TGDBusObjectIface: GDBusObjectIfaceObj].}
{.deprecated: [PGDBusObjectSkeleton: GDBusObjectSkeleton, TGDBusObjectSkeleton: GDBusObjectSkeletonObj].}
{.deprecated: [PGDBusObjectSkeletonClass: GDBusObjectSkeletonClass, TGDBusObjectSkeletonClass: GDBusObjectSkeletonClassObj].}
{.deprecated: [PGDBusObjectProxy: GDBusObjectProxy, TGDBusObjectProxy: GDBusObjectProxyObj].}
{.deprecated: [PGDBusObjectProxyClass: GDBusObjectProxyClass, TGDBusObjectProxyClass: GDBusObjectProxyClassObj].}
{.deprecated: [PGDBusObjectManagerIface: GDBusObjectManagerIface, TGDBusObjectManagerIface: GDBusObjectManagerIfaceObj].}
{.deprecated: [PGDBusObjectManagerClient: GDBusObjectManagerClient, TGDBusObjectManagerClient: GDBusObjectManagerClientObj].}
{.deprecated: [PGDBusObjectManagerClientClass: GDBusObjectManagerClientClass, TGDBusObjectManagerClientClass: GDBusObjectManagerClientClassObj].}
{.deprecated: [PGDBusObjectManagerServer: GDBusObjectManagerServer, TGDBusObjectManagerServer: GDBusObjectManagerServerObj].}
{.deprecated: [PGDBusObjectManagerServerClass: GDBusObjectManagerServerClass, TGDBusObjectManagerServerClass: GDBusObjectManagerServerClassObj].}
{.deprecated: [PGRemoteActionGroupInterface: GRemoteActionGroupInterface, TGRemoteActionGroupInterface: GRemoteActionGroupInterfaceObj].}
{.deprecated: [PGMenuModel: GMenuModel, TGMenuModel: GMenuModelObj].}
{.deprecated: [PGMenuModelClass: GMenuModelClass, TGMenuModelClass: GMenuModelClassObj].}
{.deprecated: [PGMenuAttributeIter: GMenuAttributeIter, TGMenuAttributeIter: GMenuAttributeIterObj].}
{.deprecated: [PGMenuAttributeIterClass: GMenuAttributeIterClass, TGMenuAttributeIterClass: GMenuAttributeIterClassObj].}
{.deprecated: [PGMenuLinkIter: GMenuLinkIter, TGMenuLinkIter: GMenuLinkIterObj].}
{.deprecated: [PGMenuLinkIterClass: GMenuLinkIterClass, TGMenuLinkIterClass: GMenuLinkIterClassObj].}
{.deprecated: [PGMenuItem: GMenuItem, TGMenuItem: GMenuItemObj].}
{.deprecated: [PGMenu: GMenu, TGMenu: GMenuObj].}
{.deprecated: [PGDBusMenuModel: GDBusMenuModel, TGDBusMenuModel: GDBusMenuModelObj].}
{.deprecated: [TGAppInfoCreateFlags: GAppInfoCreateFlags].}
{.deprecated: [TGConverterFlags: GConverterFlags].}
{.deprecated: [TGConverterResult: GConverterResult].}
{.deprecated: [TGDataStreamByteOrder: GDataStreamByteOrder].}
{.deprecated: [TGDataStreamNewlineType: GDataStreamNewlineType].}
{.deprecated: [TGFileAttributeType: GFileAttributeType].}
{.deprecated: [TGFileAttributeInfoFlags: GFileAttributeInfoFlags].}
{.deprecated: [TGFileAttributeStatus: GFileAttributeStatus].}
{.deprecated: [TGFileQueryInfoFlags: GFileQueryInfoFlags].}
{.deprecated: [TGFileCreateFlags: GFileCreateFlags].}
{.deprecated: [TGFileMeasureFlags: GFileMeasureFlags].}
{.deprecated: [TGMountMountFlags: GMountMountFlags].}
{.deprecated: [TGMountUnmountFlags: GMountUnmountFlags].}
{.deprecated: [TGDriveStartFlags: GDriveStartFlags].}
{.deprecated: [TGDriveStartStopType: GDriveStartStopType].}
{.deprecated: [TGFileCopyFlags: GFileCopyFlags].}
{.deprecated: [TGFileMonitorFlags: GFileMonitorFlags].}
{.deprecated: [TGFileType: GFileType].}
{.deprecated: [TGFilesystemPreviewType: GFilesystemPreviewType].}
{.deprecated: [TGFileMonitorEvent: GFileMonitorEvent].}
{.deprecated: [TGIOErrorEnum: GIOErrorEnum].}
{.deprecated: [TGAskPasswordFlags: GAskPasswordFlags].}
{.deprecated: [TGPasswordSave: GPasswordSave].}
{.deprecated: [TGMountOperationResult: GMountOperationResult].}
{.deprecated: [TGOutputStreamSpliceFlags: GOutputStreamSpliceFlags].}
{.deprecated: [TGIOStreamSpliceFlags: GIOStreamSpliceFlags].}
{.deprecated: [TGEmblemOrigin: GEmblemOrigin].}
{.deprecated: [TGResolverError: GResolverError].}
{.deprecated: [TGResolverRecordType: GResolverRecordType].}
{.deprecated: [TGResourceError: GResourceError].}
{.deprecated: [TGResourceFlags: GResourceFlags].}
{.deprecated: [TGResourceLookupFlags: GResourceLookupFlags].}
{.deprecated: [TGSocketFamily: GSocketFamily].}
{.deprecated: [TGSocketType: GSocketType].}
{.deprecated: [TGSocketMsgFlags: GSocketMsgFlags].}
{.deprecated: [TGSocketProtocol: GSocketProtocol].}
{.deprecated: [TGZlibCompressorFormat: GZlibCompressorFormat].}
{.deprecated: [TGUnixSocketAddressType: GUnixSocketAddressType].}
{.deprecated: [TGBusType: GBusType].}
{.deprecated: [TGBusNameOwnerFlags: GBusNameOwnerFlags].}
{.deprecated: [TGBusNameWatcherFlags: GBusNameWatcherFlags].}
{.deprecated: [TGDBusProxyFlags: GDBusProxyFlags].}
{.deprecated: [TGDBusError: GDBusError].}
{.deprecated: [TGDBusConnectionFlags: GDBusConnectionFlags].}
{.deprecated: [TGDBusCapabilityFlags: GDBusCapabilityFlags].}
{.deprecated: [TGDBusCallFlags: GDBusCallFlags].}
{.deprecated: [TGDBusMessageType: GDBusMessageType].}
{.deprecated: [TGDBusMessageFlags: GDBusMessageFlags].}
{.deprecated: [TGDBusMessageHeaderField: GDBusMessageHeaderField].}
{.deprecated: [TGDBusPropertyInfoFlags: GDBusPropertyInfoFlags].}
{.deprecated: [TGDBusSubtreeFlags: GDBusSubtreeFlags].}
{.deprecated: [TGDBusServerFlags: GDBusServerFlags].}
{.deprecated: [TGDBusSignalFlags: GDBusSignalFlags].}
{.deprecated: [TGDBusSendMessageFlags: GDBusSendMessageFlags].}
{.deprecated: [TGCredentialsType: GCredentialsType].}
{.deprecated: [TGDBusMessageByteOrder: GDBusMessageByteOrder].}
{.deprecated: [TGApplicationFlags: GApplicationFlags].}
{.deprecated: [TGTlsError: GTlsError].}
{.deprecated: [TGTlsCertificateFlags: GTlsCertificateFlags].}
{.deprecated: [TGTlsAuthenticationMode: GTlsAuthenticationMode].}
{.deprecated: [TGTlsRehandshakeMode: GTlsRehandshakeMode].}
{.deprecated: [TGTlsPasswordFlags: GTlsPasswordFlags].}
{.deprecated: [TGTlsInteractionResult: GTlsInteractionResult].}
{.deprecated: [TGDBusInterfaceSkeletonFlags: GDBusInterfaceSkeletonFlags].}
{.deprecated: [TGDBusObjectManagerClientFlags: GDBusObjectManagerClientFlags].}
{.deprecated: [TGTlsDatabaseVerifyFlags: GTlsDatabaseVerifyFlags].}
{.deprecated: [TGTlsDatabaseLookupFlags: GTlsDatabaseLookupFlags].}
{.deprecated: [TGTlsCertificateRequestFlags: GTlsCertificateRequestFlags].}
{.deprecated: [TGIOModuleScopeFlags: GIOModuleScopeFlags].}
{.deprecated: [TGSocketClientEvent: GSocketClientEvent].}
{.deprecated: [TGTestDBusFlags: GTestDBusFlags].}
{.deprecated: [TGSubprocessFlags: GSubprocessFlags].}
{.deprecated: [TGNotificationPriority: GNotificationPriority].}
{.deprecated: [TGNetworkConnectivity: GNetworkConnectivity].}
{.deprecated: [TGSettingsBindFlags: GSettingsBindFlags].}
{.deprecated: [g_action_get_name: get_name].}
{.deprecated: [g_action_get_parameter_type: get_parameter_type].}
{.deprecated: [g_action_get_state_type: get_state_type].}
{.deprecated: [g_action_get_state_hint: get_state_hint].}
{.deprecated: [g_action_get_enabled: get_enabled].}
{.deprecated: [g_action_get_state: get_state].}
{.deprecated: [g_action_change_state: change_state].}
{.deprecated: [g_action_activate: activate].}
{.deprecated: [g_action_group_has_action: has_action].}
{.deprecated: [g_action_group_list_actions: list_actions].}
{.deprecated: [g_action_group_get_action_parameter_type: get_action_parameter_type].}
{.deprecated: [g_action_group_get_action_state_type: get_action_state_type].}
{.deprecated: [g_action_group_get_action_state_hint: get_action_state_hint].}
{.deprecated: [g_action_group_get_action_enabled: get_action_enabled].}
{.deprecated: [g_action_group_get_action_state: get_action_state].}
{.deprecated: [g_action_group_change_action_state: change_action_state].}
{.deprecated: [g_action_group_activate_action: activate_action].}
{.deprecated: [g_action_group_action_added: action_added].}
{.deprecated: [g_action_group_action_removed: action_removed].}
{.deprecated: [g_action_group_action_enabled_changed: action_enabled_changed].}
{.deprecated: [g_action_group_action_state_changed: action_state_changed].}
{.deprecated: [g_action_group_query_action: query_action].}
{.deprecated: [g_dbus_connection_export_action_group: export_action_group].}
{.deprecated: [g_dbus_connection_unexport_action_group: unexport_action_group].}
{.deprecated: [g_action_map_lookup_action: lookup_action].}
{.deprecated: [g_action_map_add_action: add_action].}
{.deprecated: [g_action_map_remove_action: remove_action].}
{.deprecated: [g_action_map_add_action_entries: add_action_entries].}
{.deprecated: [g_app_info_dup: dup].}
{.deprecated: [g_app_info_equal: equal].}
{.deprecated: [g_app_info_get_id: get_id].}
{.deprecated: [g_app_info_get_name: get_name].}
{.deprecated: [g_app_info_get_display_name: get_display_name].}
{.deprecated: [g_app_info_get_description: get_description].}
{.deprecated: [g_app_info_get_executable: get_executable].}
{.deprecated: [g_app_info_get_commandline: get_commandline].}
{.deprecated: [g_app_info_get_icon: get_icon].}
{.deprecated: [g_app_info_launch: launch].}
{.deprecated: [g_app_info_supports_uris: supports_uris].}
{.deprecated: [g_app_info_supports_files: supports_files].}
{.deprecated: [g_app_info_launch_uris: launch_uris].}
{.deprecated: [g_app_info_should_show: should_show].}
{.deprecated: [g_app_info_set_as_default_for_type: set_as_default_for_type].}
{.deprecated: [g_app_info_set_as_default_for_extension: set_as_default_for_extension].}
{.deprecated: [g_app_info_add_supports_type: add_supports_type].}
{.deprecated: [g_app_info_can_remove_supports_type: can_remove_supports_type].}
{.deprecated: [g_app_info_remove_supports_type: remove_supports_type].}
{.deprecated: [g_app_info_get_supported_types: get_supported_types].}
{.deprecated: [g_app_info_can_delete: can_delete].}
{.deprecated: [g_app_info_delete: delete].}
{.deprecated: [g_app_info_set_as_last_used_for_type: set_as_last_used_for_type].}
{.deprecated: [g_app_launch_context_setenv: setenv].}
{.deprecated: [g_app_launch_context_unsetenv: unsetenv].}
{.deprecated: [g_app_launch_context_get_environment: get_environment].}
{.deprecated: [g_app_launch_context_get_display: get_display].}
{.deprecated: [g_app_launch_context_get_startup_notify_id: get_startup_notify_id].}
{.deprecated: [g_app_launch_context_launch_failed: launch_failed].}
{.deprecated: [g_application_get_application_id: get_application_id].}
{.deprecated: [g_application_set_application_id: set_application_id].}
{.deprecated: [g_application_get_dbus_connection: get_dbus_connection].}
{.deprecated: [g_application_get_dbus_object_path: get_dbus_object_path].}
{.deprecated: [g_application_get_inactivity_timeout: get_inactivity_timeout].}
{.deprecated: [g_application_set_inactivity_timeout: set_inactivity_timeout].}
{.deprecated: [g_application_get_flags: get_flags].}
{.deprecated: [g_application_set_flags: set_flags].}
{.deprecated: [g_application_get_resource_base_path: get_resource_base_path].}
{.deprecated: [g_application_set_resource_base_path: set_resource_base_path].}
{.deprecated: [g_application_set_action_group: set_action_group].}
{.deprecated: [g_application_add_main_option_entries: add_main_option_entries].}
{.deprecated: [g_application_add_main_option: add_main_option].}
{.deprecated: [g_application_add_option_group: add_option_group].}
{.deprecated: [g_application_get_is_registered: get_is_registered].}
{.deprecated: [g_application_get_is_remote: get_is_remote].}
{.deprecated: [g_application_register: register].}
{.deprecated: [g_application_hold: hold].}
{.deprecated: [g_application_release: release].}
{.deprecated: [g_application_activate: activate].}
{.deprecated: [g_application_open: open].}
{.deprecated: [g_application_run: run].}
{.deprecated: [g_application_quit: quit].}
{.deprecated: [g_application_set_default: set_default].}
{.deprecated: [g_application_mark_busy: mark_busy].}
{.deprecated: [g_application_unmark_busy: unmark_busy].}
{.deprecated: [g_application_send_notification: send_notification].}
{.deprecated: [g_application_withdraw_notification: withdraw_notification].}
{.deprecated: [g_application_bind_busy_property: bind_busy_property].}
{.deprecated: [g_application_command_line_get_arguments: get_arguments].}
{.deprecated: [g_application_command_line_get_options_dict: get_options_dict].}
{.deprecated: [g_application_command_line_get_stdin: get_stdin].}
{.deprecated: [g_application_command_line_get_environ: get_environ].}
{.deprecated: [g_application_command_line_getenv: getenv].}
{.deprecated: [g_application_command_line_get_cwd: get_cwd].}
{.deprecated: [g_application_command_line_get_is_remote: get_is_remote].}
{.deprecated: [g_application_command_line_print: print].}
{.deprecated: [g_application_command_line_printerr: printerr].}
{.deprecated: [g_application_command_line_get_exit_status: get_exit_status].}
{.deprecated: [g_application_command_line_set_exit_status: set_exit_status].}
{.deprecated: [g_application_command_line_get_platform_data: get_platform_data].}
{.deprecated: [g_application_command_line_create_file_for_arg: create_file_for_arg].}
{.deprecated: [g_initable_init: init].}
{.deprecated: [g_async_initable_init_async: init_async].}
{.deprecated: [g_async_initable_init_finish: init_finish].}
{.deprecated: [g_async_initable_new_finish: new_finish].}
{.deprecated: [g_async_result_get_user_data: get_user_data].}
{.deprecated: [g_async_result_get_source_object: get_source_object].}
{.deprecated: [g_async_result_legacy_propagate_error: legacy_propagate_error].}
{.deprecated: [g_async_result_is_tagged: is_tagged].}
{.deprecated: [g_input_stream_read: read].}
{.deprecated: [g_input_stream_read_all: read_all].}
{.deprecated: [g_input_stream_read_bytes: read_bytes].}
{.deprecated: [g_input_stream_skip: skip].}
{.deprecated: [g_input_stream_close: close].}
{.deprecated: [g_input_stream_read_async: read_async].}
{.deprecated: [g_input_stream_read_finish: read_finish].}
{.deprecated: [g_input_stream_read_all_async: read_all_async].}
{.deprecated: [g_input_stream_read_all_finish: read_all_finish].}
{.deprecated: [g_input_stream_read_bytes_async: read_bytes_async].}
{.deprecated: [g_input_stream_read_bytes_finish: read_bytes_finish].}
{.deprecated: [g_input_stream_skip_async: skip_async].}
{.deprecated: [g_input_stream_skip_finish: skip_finish].}
{.deprecated: [g_input_stream_close_async: close_async].}
{.deprecated: [g_input_stream_close_finish: close_finish].}
{.deprecated: [g_input_stream_is_closed: is_closed].}
{.deprecated: [g_input_stream_has_pending: has_pending].}
{.deprecated: [g_input_stream_set_pending: set_pending].}
{.deprecated: [g_input_stream_clear_pending: clear_pending].}
{.deprecated: [g_filter_input_stream_get_base_stream: get_base_stream].}
{.deprecated: [g_filter_input_stream_get_close_base_stream: get_close_base_stream].}
{.deprecated: [g_filter_input_stream_set_close_base_stream: set_close_base_stream].}
{.deprecated: [g_buffered_input_stream_get_buffer_size: get_buffer_size].}
{.deprecated: [g_buffered_input_stream_set_buffer_size: set_buffer_size].}
{.deprecated: [g_buffered_input_stream_get_available: get_available].}
{.deprecated: [g_buffered_input_stream_peek: peek].}
{.deprecated: [g_buffered_input_stream_peek_buffer: peek_buffer].}
{.deprecated: [g_buffered_input_stream_fill: fill].}
{.deprecated: [g_buffered_input_stream_fill_async: fill_async].}
{.deprecated: [g_buffered_input_stream_fill_finish: fill_finish].}
{.deprecated: [g_buffered_input_stream_read_byte: read_byte].}
{.deprecated: [g_output_stream_write: write].}
{.deprecated: [g_output_stream_write_all: write_all].}
{.deprecated: [g_output_stream_printf: printf].}
{.deprecated: [g_output_stream_write_bytes: write_bytes].}
{.deprecated: [g_output_stream_splice: splice].}
{.deprecated: [g_output_stream_flush: flush].}
{.deprecated: [g_output_stream_close: close].}
{.deprecated: [g_output_stream_write_async: write_async].}
{.deprecated: [g_output_stream_write_finish: write_finish].}
{.deprecated: [g_output_stream_write_all_async: write_all_async].}
{.deprecated: [g_output_stream_write_all_finish: write_all_finish].}
{.deprecated: [g_output_stream_write_bytes_async: write_bytes_async].}
{.deprecated: [g_output_stream_write_bytes_finish: write_bytes_finish].}
{.deprecated: [g_output_stream_splice_async: splice_async].}
{.deprecated: [g_output_stream_splice_finish: splice_finish].}
{.deprecated: [g_output_stream_flush_async: flush_async].}
{.deprecated: [g_output_stream_flush_finish: flush_finish].}
{.deprecated: [g_output_stream_close_async: close_async].}
{.deprecated: [g_output_stream_close_finish: close_finish].}
{.deprecated: [g_output_stream_is_closed: is_closed].}
{.deprecated: [g_output_stream_is_closing: is_closing].}
{.deprecated: [g_output_stream_has_pending: has_pending].}
{.deprecated: [g_output_stream_set_pending: set_pending].}
{.deprecated: [g_output_stream_clear_pending: clear_pending].}
{.deprecated: [g_filter_output_stream_get_base_stream: get_base_stream].}
{.deprecated: [g_filter_output_stream_get_close_base_stream: get_close_base_stream].}
{.deprecated: [g_filter_output_stream_set_close_base_stream: set_close_base_stream].}
{.deprecated: [g_buffered_output_stream_get_buffer_size: get_buffer_size].}
{.deprecated: [g_buffered_output_stream_set_buffer_size: set_buffer_size].}
{.deprecated: [g_buffered_output_stream_get_auto_grow: get_auto_grow].}
{.deprecated: [g_buffered_output_stream_set_auto_grow: set_auto_grow].}
{.deprecated: [g_bytes_icon_new: icon_new].}
{.deprecated: [g_bytes_icon_get_bytes: get_bytes].}
{.deprecated: [g_cancellable_is_cancelled: is_cancelled].}
{.deprecated: [g_cancellable_set_error_if_cancelled: set_error_if_cancelled].}
{.deprecated: [g_cancellable_get_fd: get_fd].}
{.deprecated: [g_cancellable_make_pollfd: make_pollfd].}
{.deprecated: [g_cancellable_release_fd: release_fd].}
{.deprecated: [g_cancellable_source_new: source_new].}
{.deprecated: [g_cancellable_push_current: push_current].}
{.deprecated: [g_cancellable_pop_current: pop_current].}
{.deprecated: [g_cancellable_reset: reset].}
{.deprecated: [g_cancellable_connect: connect].}
{.deprecated: [g_cancellable_disconnect: disconnect].}
{.deprecated: [g_cancellable_cancel: cancel].}
{.deprecated: [g_converter_convert: convert].}
{.deprecated: [g_converter_reset: reset].}
{.deprecated: [g_charset_converter_set_use_fallback: set_use_fallback].}
{.deprecated: [g_charset_converter_get_use_fallback: get_use_fallback].}
{.deprecated: [g_charset_converter_get_num_fallbacks: get_num_fallbacks].}
{.deprecated: [g_converter_input_stream_get_converter: get_converter].}
{.deprecated: [g_converter_output_stream_get_converter: get_converter].}
{.deprecated: [g_credentials_to_string: to_string].}
{.deprecated: [g_credentials_get_native: get_native].}
{.deprecated: [g_credentials_set_native: set_native].}
{.deprecated: [g_credentials_is_same_user: is_same_user].}
{.deprecated: [g_data_input_stream_set_byte_order: set_byte_order].}
{.deprecated: [g_data_input_stream_get_byte_order: get_byte_order].}
{.deprecated: [g_data_input_stream_set_newline_type: set_newline_type].}
{.deprecated: [g_data_input_stream_get_newline_type: get_newline_type].}
{.deprecated: [g_data_input_stream_read_byte: read_byte].}
{.deprecated: [g_data_input_stream_read_int16: read_int16].}
{.deprecated: [g_data_input_stream_read_uint16: read_uint16].}
{.deprecated: [g_data_input_stream_read_int32: read_int32].}
{.deprecated: [g_data_input_stream_read_uint32: read_uint32].}
{.deprecated: [g_data_input_stream_read_int64: read_int64].}
{.deprecated: [g_data_input_stream_read_uint64: read_uint64].}
{.deprecated: [g_data_input_stream_read_line: read_line].}
{.deprecated: [g_data_input_stream_read_line_utf8: read_line_utf8].}
{.deprecated: [g_data_input_stream_read_line_async: read_line_async].}
{.deprecated: [g_data_input_stream_read_line_finish: read_line_finish].}
{.deprecated: [g_data_input_stream_read_line_finish_utf8: read_line_finish_utf8].}
{.deprecated: [g_data_input_stream_read_until: read_until].}
{.deprecated: [g_data_input_stream_read_until_async: read_until_async].}
{.deprecated: [g_data_input_stream_read_until_finish: read_until_finish].}
{.deprecated: [g_data_input_stream_read_upto: read_upto].}
{.deprecated: [g_data_input_stream_read_upto_async: read_upto_async].}
{.deprecated: [g_data_input_stream_read_upto_finish: read_upto_finish].}
{.deprecated: [g_data_output_stream_set_byte_order: set_byte_order].}
{.deprecated: [g_data_output_stream_get_byte_order: get_byte_order].}
{.deprecated: [g_data_output_stream_put_byte: put_byte].}
{.deprecated: [g_data_output_stream_put_int16: put_int16].}
{.deprecated: [g_data_output_stream_put_uint16: put_uint16].}
{.deprecated: [g_data_output_stream_put_int32: put_int32].}
{.deprecated: [g_data_output_stream_put_uint32: put_uint32].}
{.deprecated: [g_data_output_stream_put_int64: put_int64].}
{.deprecated: [g_data_output_stream_put_uint64: put_uint64].}
{.deprecated: [g_data_output_stream_put_string: put_string].}
{.deprecated: [g_dbus_auth_observer_authorize_authenticated_peer: authorize_authenticated_peer].}
{.deprecated: [g_dbus_auth_observer_allow_mechanism: allow_mechanism].}
{.deprecated: [g_dbus_connection_start_message_processing: start_message_processing].}
{.deprecated: [g_dbus_connection_is_closed: is_closed].}
{.deprecated: [g_dbus_connection_get_stream: get_stream].}
{.deprecated: [g_dbus_connection_get_guid: get_guid].}
{.deprecated: [g_dbus_connection_get_unique_name: get_unique_name].}
{.deprecated: [g_dbus_connection_get_peer_credentials: get_peer_credentials].}
{.deprecated: [g_dbus_connection_get_last_serial: get_last_serial].}
{.deprecated: [g_dbus_connection_get_exit_on_close: get_exit_on_close].}
{.deprecated: [g_dbus_connection_set_exit_on_close: set_exit_on_close].}
{.deprecated: [g_dbus_connection_get_capabilities: get_capabilities].}
{.deprecated: [g_dbus_connection_close: close].}
{.deprecated: [g_dbus_connection_close_finish: close_finish].}
{.deprecated: [g_dbus_connection_close_sync: close_sync].}
{.deprecated: [g_dbus_connection_flush: flush].}
{.deprecated: [g_dbus_connection_flush_finish: flush_finish].}
{.deprecated: [g_dbus_connection_flush_sync: flush_sync].}
{.deprecated: [g_dbus_connection_send_message: send_message].}
{.deprecated: [g_dbus_connection_send_message_with_reply: send_message_with_reply].}
{.deprecated: [g_dbus_connection_send_message_with_reply_finish: send_message_with_reply_finish].}
{.deprecated: [g_dbus_connection_send_message_with_reply_sync: send_message_with_reply_sync].}
{.deprecated: [g_dbus_connection_emit_signal: emit_signal].}
{.deprecated: [g_dbus_connection_call: call].}
{.deprecated: [g_dbus_connection_call_finish: call_finish].}
{.deprecated: [g_dbus_connection_call_sync: call_sync].}
{.deprecated: [g_dbus_connection_unregister_object: unregister_object].}
{.deprecated: [g_dbus_connection_unregister_subtree: unregister_subtree].}
{.deprecated: [g_dbus_connection_signal_subscribe: signal_subscribe].}
{.deprecated: [g_dbus_connection_signal_unsubscribe: signal_unsubscribe].}
{.deprecated: [g_dbus_connection_add_filter: add_filter].}
{.deprecated: [g_dbus_connection_remove_filter: remove_filter].}
{.deprecated: [g_dbus_connection_register_subtree: register_subtree].}
{.deprecated: [g_dbus_connection_register_object: register_object].}
{.deprecated: [g_dbus_annotation_info_lookup: lookup].}
{.deprecated: [g_dbus_interface_info_lookup_method: lookup_method].}
{.deprecated: [g_dbus_interface_info_lookup_signal: lookup_signal].}
{.deprecated: [g_dbus_interface_info_lookup_property: lookup_property].}
{.deprecated: [g_dbus_interface_info_cache_build: cache_build].}
{.deprecated: [g_dbus_interface_info_cache_release: cache_release].}
{.deprecated: [g_dbus_interface_info_generate_xml: generate_xml].}
{.deprecated: [g_dbus_node_info_lookup_interface: lookup_interface].}
{.deprecated: [g_dbus_node_info_generate_xml: generate_xml].}
{.deprecated: [g_dbus_node_info_ref: `ref`].}
{.deprecated: [g_dbus_interface_info_ref: `ref`].}
{.deprecated: [g_dbus_method_info_ref: `ref`].}
{.deprecated: [g_dbus_signal_info_ref: `ref`].}
{.deprecated: [g_dbus_property_info_ref: `ref`].}
{.deprecated: [g_dbus_arg_info_ref: `ref`].}
{.deprecated: [g_dbus_annotation_info_ref: `ref`].}
{.deprecated: [g_dbus_node_info_unref: unref].}
{.deprecated: [g_dbus_interface_info_unref: unref].}
{.deprecated: [g_dbus_method_info_unref: unref].}
{.deprecated: [g_dbus_signal_info_unref: unref].}
{.deprecated: [g_dbus_property_info_unref: unref].}
{.deprecated: [g_dbus_arg_info_unref: unref].}
{.deprecated: [g_dbus_annotation_info_unref: unref].}
{.deprecated: [g_dbus_message_new_method_reply: new_method_reply].}
{.deprecated: [g_dbus_message_new_method_error: new_method_error].}
{.deprecated: [g_dbus_message_new_method_error_literal: new_method_error_literal].}
{.deprecated: [g_dbus_message_print: print].}
{.deprecated: [g_dbus_message_get_locked: get_locked].}
{.deprecated: [g_dbus_message_lock: lock].}
{.deprecated: [g_dbus_message_copy: copy].}
{.deprecated: [g_dbus_message_get_byte_order: get_byte_order].}
{.deprecated: [g_dbus_message_set_byte_order: set_byte_order].}
{.deprecated: [g_dbus_message_get_message_type: get_message_type].}
{.deprecated: [g_dbus_message_set_message_type: set_message_type].}
{.deprecated: [g_dbus_message_get_flags: get_flags].}
{.deprecated: [g_dbus_message_set_flags: set_flags].}
{.deprecated: [g_dbus_message_get_serial: get_serial].}
{.deprecated: [g_dbus_message_set_serial: set_serial].}
{.deprecated: [g_dbus_message_get_header: get_header].}
{.deprecated: [g_dbus_message_set_header: set_header].}
{.deprecated: [g_dbus_message_get_header_fields: get_header_fields].}
{.deprecated: [g_dbus_message_get_body: get_body].}
{.deprecated: [g_dbus_message_set_body: set_body].}
{.deprecated: [g_dbus_message_get_reply_serial: get_reply_serial].}
{.deprecated: [g_dbus_message_set_reply_serial: set_reply_serial].}
{.deprecated: [g_dbus_message_get_interface: get_interface].}
{.deprecated: [g_dbus_message_set_interface: set_interface].}
{.deprecated: [g_dbus_message_get_member: get_member].}
{.deprecated: [g_dbus_message_set_member: set_member].}
{.deprecated: [g_dbus_message_get_path: get_path].}
{.deprecated: [g_dbus_message_set_path: set_path].}
{.deprecated: [g_dbus_message_get_sender: get_sender].}
{.deprecated: [g_dbus_message_set_sender: set_sender].}
{.deprecated: [g_dbus_message_get_destination: get_destination].}
{.deprecated: [g_dbus_message_set_destination: set_destination].}
{.deprecated: [g_dbus_message_get_error_name: get_error_name].}
{.deprecated: [g_dbus_message_set_error_name: set_error_name].}
{.deprecated: [g_dbus_message_get_signature: get_signature].}
{.deprecated: [g_dbus_message_set_signature: set_signature].}
{.deprecated: [g_dbus_message_get_arg0: get_arg0].}
{.deprecated: [g_dbus_message_to_blob: to_blob].}
{.deprecated: [g_dbus_message_to_gerror: to_gerror].}
{.deprecated: [g_dbus_method_invocation_get_sender: get_sender].}
{.deprecated: [g_dbus_method_invocation_get_object_path: get_object_path].}
{.deprecated: [g_dbus_method_invocation_get_interface_name: get_interface_name].}
{.deprecated: [g_dbus_method_invocation_get_method_name: get_method_name].}
{.deprecated: [g_dbus_method_invocation_get_method_info: get_method_info].}
{.deprecated: [g_dbus_method_invocation_get_property_info: get_property_info].}
{.deprecated: [g_dbus_method_invocation_get_connection: get_connection].}
{.deprecated: [g_dbus_method_invocation_get_message: get_message].}
{.deprecated: [g_dbus_method_invocation_get_parameters: get_parameters].}
{.deprecated: [g_dbus_method_invocation_get_user_data: get_user_data].}
{.deprecated: [g_dbus_method_invocation_return_value: return_value].}
{.deprecated: [g_dbus_method_invocation_return_error: return_error].}
{.deprecated: [g_dbus_method_invocation_return_error_literal: return_error_literal].}
{.deprecated: [g_dbus_method_invocation_return_gerror: return_gerror].}
{.deprecated: [g_dbus_method_invocation_take_error: take_error].}
{.deprecated: [g_dbus_method_invocation_return_dbus_error: return_dbus_error].}
{.deprecated: [g_dbus_proxy_get_connection: get_connection].}
{.deprecated: [g_dbus_proxy_get_flags: get_flags].}
{.deprecated: [g_dbus_proxy_get_name: get_name].}
{.deprecated: [g_dbus_proxy_get_name_owner: get_name_owner].}
{.deprecated: [g_dbus_proxy_get_object_path: get_object_path].}
{.deprecated: [g_dbus_proxy_get_interface_name: get_interface_name].}
{.deprecated: [g_dbus_proxy_get_default_timeout: get_default_timeout].}
{.deprecated: [g_dbus_proxy_set_default_timeout: set_default_timeout].}
{.deprecated: [g_dbus_proxy_get_interface_info: get_interface_info].}
{.deprecated: [g_dbus_proxy_set_interface_info: set_interface_info].}
{.deprecated: [g_dbus_proxy_get_cached_property: get_cached_property].}
{.deprecated: [g_dbus_proxy_set_cached_property: set_cached_property].}
{.deprecated: [g_dbus_proxy_get_cached_property_names: get_cached_property_names].}
{.deprecated: [g_dbus_proxy_call: call].}
{.deprecated: [g_dbus_proxy_call_finish: call_finish].}
{.deprecated: [g_dbus_proxy_call_sync: call_sync].}
{.deprecated: [g_dbus_server_get_client_address: get_client_address].}
{.deprecated: [g_dbus_server_get_guid: get_guid].}
{.deprecated: [g_dbus_server_get_flags: get_flags].}
{.deprecated: [g_dbus_server_start: start].}
{.deprecated: [g_dbus_server_stop: stop].}
{.deprecated: [g_dbus_server_is_active: is_active].}
{.deprecated: [g_drive_get_name: get_name].}
{.deprecated: [g_drive_get_icon: get_icon].}
{.deprecated: [g_drive_get_symbolic_icon: get_symbolic_icon].}
{.deprecated: [g_drive_has_volumes: has_volumes].}
{.deprecated: [g_drive_get_volumes: get_volumes].}
{.deprecated: [g_drive_is_media_removable: is_media_removable].}
{.deprecated: [g_drive_has_media: has_media].}
{.deprecated: [g_drive_is_media_check_automatic: is_media_check_automatic].}
{.deprecated: [g_drive_can_poll_for_media: can_poll_for_media].}
{.deprecated: [g_drive_can_eject: can_eject].}
{.deprecated: [g_drive_eject: eject].}
{.deprecated: [g_drive_eject_finish: eject_finish].}
{.deprecated: [g_drive_poll_for_media: poll_for_media].}
{.deprecated: [g_drive_poll_for_media_finish: poll_for_media_finish].}
{.deprecated: [g_drive_get_identifier: get_identifier].}
{.deprecated: [g_drive_enumerate_identifiers: enumerate_identifiers].}
{.deprecated: [g_drive_get_start_stop_type: get_start_stop_type].}
{.deprecated: [g_drive_can_start: can_start].}
{.deprecated: [g_drive_can_start_degraded: can_start_degraded].}
{.deprecated: [g_drive_start: start].}
{.deprecated: [g_drive_start_finish: start_finish].}
{.deprecated: [g_drive_can_stop: can_stop].}
{.deprecated: [g_drive_stop: stop].}
{.deprecated: [g_drive_stop_finish: stop_finish].}
{.deprecated: [g_drive_eject_with_operation: eject_with_operation].}
{.deprecated: [g_drive_eject_with_operation_finish: eject_with_operation_finish].}
{.deprecated: [g_drive_get_sort_key: get_sort_key].}
{.deprecated: [g_icon_equal: equal].}
{.deprecated: [g_icon_to_string: to_string].}
{.deprecated: [g_icon_serialize: serialize].}
{.deprecated: [g_emblem_get_icon: get_icon].}
{.deprecated: [g_emblem_get_origin: get_origin].}
{.deprecated: [g_emblemed_icon_get_icon: get_icon].}
{.deprecated: [g_emblemed_icon_get_emblems: get_emblems].}
{.deprecated: [g_emblemed_icon_add_emblem: add_emblem].}
{.deprecated: [g_emblemed_icon_clear_emblems: clear_emblems].}
{.deprecated: [g_file_attribute_info_list_ref: `ref`].}
{.deprecated: [g_file_attribute_info_list_unref: unref].}
{.deprecated: [g_file_attribute_info_list_dup: dup].}
{.deprecated: [g_file_attribute_info_list_lookup: lookup].}
{.deprecated: [g_file_attribute_info_list_add: add].}
{.deprecated: [g_file_enumerator_next_file: next_file].}
{.deprecated: [g_file_enumerator_close: close].}
{.deprecated: [g_file_enumerator_next_files_async: next_files_async].}
{.deprecated: [g_file_enumerator_next_files_finish: next_files_finish].}
{.deprecated: [g_file_enumerator_close_async: close_async].}
{.deprecated: [g_file_enumerator_close_finish: close_finish].}
{.deprecated: [g_file_enumerator_is_closed: is_closed].}
{.deprecated: [g_file_enumerator_has_pending: has_pending].}
{.deprecated: [g_file_enumerator_set_pending: set_pending].}
{.deprecated: [g_file_enumerator_get_container: get_container].}
{.deprecated: [g_file_enumerator_get_child: get_child].}
{.deprecated: [g_file_dup: dup].}
{.deprecated: [g_file_equal: equal].}
{.deprecated: [g_file_get_basename: get_basename].}
{.deprecated: [g_file_get_path: get_path].}
{.deprecated: [g_file_get_uri: get_uri].}
{.deprecated: [g_file_get_parse_name: get_parse_name].}
{.deprecated: [g_file_get_parent: get_parent].}
{.deprecated: [g_file_has_parent: has_parent].}
{.deprecated: [g_file_get_child: get_child].}
{.deprecated: [g_file_get_child_for_display_name: get_child_for_display_name].}
{.deprecated: [g_file_has_prefix: has_prefix].}
{.deprecated: [g_file_get_relative_path: get_relative_path].}
{.deprecated: [g_file_resolve_relative_path: resolve_relative_path].}
{.deprecated: [g_file_is_native: is_native].}
{.deprecated: [g_file_has_uri_scheme: has_uri_scheme].}
{.deprecated: [g_file_get_uri_scheme: get_uri_scheme].}
{.deprecated: [g_file_read: read].}
{.deprecated: [g_file_read_async: read_async].}
{.deprecated: [g_file_read_finish: read_finish].}
{.deprecated: [g_file_append_to: append_to].}
{.deprecated: [g_file_create: create].}
{.deprecated: [g_file_replace: replace].}
{.deprecated: [g_file_append_to_async: append_to_async].}
{.deprecated: [g_file_append_to_finish: append_to_finish].}
{.deprecated: [g_file_create_async: create_async].}
{.deprecated: [g_file_create_finish: create_finish].}
{.deprecated: [g_file_replace_async: replace_async].}
{.deprecated: [g_file_replace_finish: replace_finish].}
{.deprecated: [g_file_open_readwrite: open_readwrite].}
{.deprecated: [g_file_open_readwrite_async: open_readwrite_async].}
{.deprecated: [g_file_open_readwrite_finish: open_readwrite_finish].}
{.deprecated: [g_file_create_readwrite: create_readwrite].}
{.deprecated: [g_file_create_readwrite_async: create_readwrite_async].}
{.deprecated: [g_file_create_readwrite_finish: create_readwrite_finish].}
{.deprecated: [g_file_replace_readwrite: replace_readwrite].}
{.deprecated: [g_file_replace_readwrite_async: replace_readwrite_async].}
{.deprecated: [g_file_replace_readwrite_finish: replace_readwrite_finish].}
{.deprecated: [g_file_query_exists: query_exists].}
{.deprecated: [g_file_query_file_type: query_file_type].}
{.deprecated: [g_file_query_info: query_info].}
{.deprecated: [g_file_query_info_async: query_info_async].}
{.deprecated: [g_file_query_info_finish: query_info_finish].}
{.deprecated: [g_file_query_filesystem_info: query_filesystem_info].}
{.deprecated: [g_file_query_filesystem_info_async: query_filesystem_info_async].}
{.deprecated: [g_file_query_filesystem_info_finish: query_filesystem_info_finish].}
{.deprecated: [g_file_find_enclosing_mount: find_enclosing_mount].}
{.deprecated: [g_file_find_enclosing_mount_async: find_enclosing_mount_async].}
{.deprecated: [g_file_find_enclosing_mount_finish: find_enclosing_mount_finish].}
{.deprecated: [g_file_enumerate_children: enumerate_children].}
{.deprecated: [g_file_enumerate_children_async: enumerate_children_async].}
{.deprecated: [g_file_enumerate_children_finish: enumerate_children_finish].}
{.deprecated: [g_file_set_display_name: set_display_name].}
{.deprecated: [g_file_set_display_name_async: set_display_name_async].}
{.deprecated: [g_file_set_display_name_finish: set_display_name_finish].}
{.deprecated: [g_file_delete: delete].}
{.deprecated: [g_file_delete_async: delete_async].}
{.deprecated: [g_file_delete_finish: delete_finish].}
{.deprecated: [g_file_trash: trash].}
{.deprecated: [g_file_trash_async: trash_async].}
{.deprecated: [g_file_trash_finish: trash_finish].}
{.deprecated: [g_file_copy: copy].}
{.deprecated: [g_file_copy_async: copy_async].}
{.deprecated: [g_file_copy_finish: copy_finish].}
{.deprecated: [g_file_move: move].}
{.deprecated: [g_file_make_directory: make_directory].}
{.deprecated: [g_file_make_directory_async: make_directory_async].}
{.deprecated: [g_file_make_directory_finish: make_directory_finish].}
{.deprecated: [g_file_make_directory_with_parents: make_directory_with_parents].}
{.deprecated: [g_file_make_symbolic_link: make_symbolic_link].}
{.deprecated: [g_file_query_settable_attributes: query_settable_attributes].}
{.deprecated: [g_file_query_writable_namespaces: query_writable_namespaces].}
{.deprecated: [g_file_set_attribute: set_attribute].}
{.deprecated: [g_file_set_attributes_from_info: set_attributes_from_info].}
{.deprecated: [g_file_set_attributes_async: set_attributes_async].}
{.deprecated: [g_file_set_attributes_finish: set_attributes_finish].}
{.deprecated: [g_file_set_attribute_string: set_attribute_string].}
{.deprecated: [g_file_set_attribute_byte_string: set_attribute_byte_string].}
{.deprecated: [g_file_set_attribute_uint32: set_attribute_uint32].}
{.deprecated: [g_file_set_attribute_int32: set_attribute_int32].}
{.deprecated: [g_file_set_attribute_uint64: set_attribute_uint64].}
{.deprecated: [g_file_set_attribute_int64: set_attribute_int64].}
{.deprecated: [g_file_mount_enclosing_volume: mount_enclosing_volume].}
{.deprecated: [g_file_mount_enclosing_volume_finish: mount_enclosing_volume_finish].}
{.deprecated: [g_file_mount_mountable: mount_mountable].}
{.deprecated: [g_file_mount_mountable_finish: mount_mountable_finish].}
{.deprecated: [g_file_unmount_mountable: unmount_mountable].}
{.deprecated: [g_file_unmount_mountable_finish: unmount_mountable_finish].}
{.deprecated: [g_file_unmount_mountable_with_operation: unmount_mountable_with_operation].}
{.deprecated: [g_file_unmount_mountable_with_operation_finish: unmount_mountable_with_operation_finish].}
{.deprecated: [g_file_eject_mountable: eject_mountable].}
{.deprecated: [g_file_eject_mountable_finish: eject_mountable_finish].}
{.deprecated: [g_file_eject_mountable_with_operation: eject_mountable_with_operation].}
{.deprecated: [g_file_eject_mountable_with_operation_finish: eject_mountable_with_operation_finish].}
{.deprecated: [g_file_copy_attributes: copy_attributes].}
{.deprecated: [g_file_monitor_directory: monitor_directory].}
{.deprecated: [g_file_monitor_file: monitor_file].}
{.deprecated: [g_file_measure_disk_usage: measure_disk_usage].}
{.deprecated: [g_file_measure_disk_usage_async: measure_disk_usage_async].}
{.deprecated: [g_file_measure_disk_usage_finish: measure_disk_usage_finish].}
{.deprecated: [g_file_start_mountable: start_mountable].}
{.deprecated: [g_file_start_mountable_finish: start_mountable_finish].}
{.deprecated: [g_file_stop_mountable: stop_mountable].}
{.deprecated: [g_file_stop_mountable_finish: stop_mountable_finish].}
{.deprecated: [g_file_poll_mountable: poll_mountable].}
{.deprecated: [g_file_poll_mountable_finish: poll_mountable_finish].}
{.deprecated: [g_file_query_default_handler: query_default_handler].}
{.deprecated: [g_file_load_contents: load_contents].}
{.deprecated: [g_file_load_contents_async: load_contents_async].}
{.deprecated: [g_file_load_contents_finish: load_contents_finish].}
{.deprecated: [g_file_load_partial_contents_async: load_partial_contents_async].}
{.deprecated: [g_file_load_partial_contents_finish: load_partial_contents_finish].}
{.deprecated: [g_file_replace_contents: replace_contents].}
{.deprecated: [g_file_replace_contents_async: replace_contents_async].}
{.deprecated: [g_file_replace_contents_bytes_async: replace_contents_bytes_async].}
{.deprecated: [g_file_replace_contents_finish: replace_contents_finish].}
{.deprecated: [g_file_supports_thread_contexts: supports_thread_contexts].}
{.deprecated: [g_file_icon_new: icon_new].}
{.deprecated: [g_file_icon_get_file: get_file].}
{.deprecated: [g_file_info_dup: dup].}
{.deprecated: [g_file_info_copy_into: copy_into].}
{.deprecated: [g_file_info_has_attribute: has_attribute].}
{.deprecated: [g_file_info_has_namespace: has_namespace].}
{.deprecated: [g_file_info_list_attributes: list_attributes].}
{.deprecated: [g_file_info_get_attribute_data: get_attribute_data].}
{.deprecated: [g_file_info_get_attribute_type: get_attribute_type].}
{.deprecated: [g_file_info_remove_attribute: remove_attribute].}
{.deprecated: [g_file_info_get_attribute_status: get_attribute_status].}
{.deprecated: [g_file_info_set_attribute_status: set_attribute_status].}
{.deprecated: [g_file_info_get_attribute_as_string: get_attribute_as_string].}
{.deprecated: [g_file_info_get_attribute_string: get_attribute_string].}
{.deprecated: [g_file_info_get_attribute_byte_string: get_attribute_byte_string].}
{.deprecated: [g_file_info_get_attribute_boolean: get_attribute_boolean].}
{.deprecated: [g_file_info_get_attribute_uint32: get_attribute_uint32].}
{.deprecated: [g_file_info_get_attribute_int32: get_attribute_int32].}
{.deprecated: [g_file_info_get_attribute_uint64: get_attribute_uint64].}
{.deprecated: [g_file_info_get_attribute_int64: get_attribute_int64].}
{.deprecated: [g_file_info_get_attribute_object: get_attribute_object].}
{.deprecated: [g_file_info_get_attribute_stringv: get_attribute_stringv].}
{.deprecated: [g_file_info_set_attribute: set_attribute].}
{.deprecated: [g_file_info_set_attribute_string: set_attribute_string].}
{.deprecated: [g_file_info_set_attribute_byte_string: set_attribute_byte_string].}
{.deprecated: [g_file_info_set_attribute_boolean: set_attribute_boolean].}
{.deprecated: [g_file_info_set_attribute_uint32: set_attribute_uint32].}
{.deprecated: [g_file_info_set_attribute_int32: set_attribute_int32].}
{.deprecated: [g_file_info_set_attribute_uint64: set_attribute_uint64].}
{.deprecated: [g_file_info_set_attribute_int64: set_attribute_int64].}
{.deprecated: [g_file_info_set_attribute_object: set_attribute_object].}
{.deprecated: [g_file_info_set_attribute_stringv: set_attribute_stringv].}
{.deprecated: [g_file_info_clear_status: clear_status].}
{.deprecated: [g_file_info_get_deletion_date: get_deletion_date].}
{.deprecated: [g_file_info_get_file_type: get_file_type].}
{.deprecated: [g_file_info_get_is_hidden: get_is_hidden].}
{.deprecated: [g_file_info_get_is_backup: get_is_backup].}
{.deprecated: [g_file_info_get_is_symlink: get_is_symlink].}
{.deprecated: [g_file_info_get_name: get_name].}
{.deprecated: [g_file_info_get_display_name: get_display_name].}
{.deprecated: [g_file_info_get_edit_name: get_edit_name].}
{.deprecated: [g_file_info_get_icon: get_icon].}
{.deprecated: [g_file_info_get_symbolic_icon: get_symbolic_icon].}
{.deprecated: [g_file_info_get_content_type: get_content_type].}
{.deprecated: [g_file_info_get_size: get_size].}
{.deprecated: [g_file_info_get_modification_time: get_modification_time].}
{.deprecated: [g_file_info_get_symlink_target: get_symlink_target].}
{.deprecated: [g_file_info_get_etag: get_etag].}
{.deprecated: [g_file_info_get_sort_order: get_sort_order].}
{.deprecated: [g_file_info_set_attribute_mask: set_attribute_mask].}
{.deprecated: [g_file_info_unset_attribute_mask: unset_attribute_mask].}
{.deprecated: [g_file_info_set_file_type: set_file_type].}
{.deprecated: [g_file_info_set_is_hidden: set_is_hidden].}
{.deprecated: [g_file_info_set_is_symlink: set_is_symlink].}
{.deprecated: [g_file_info_set_name: set_name].}
{.deprecated: [g_file_info_set_display_name: set_display_name].}
{.deprecated: [g_file_info_set_edit_name: set_edit_name].}
{.deprecated: [g_file_info_set_icon: set_icon].}
{.deprecated: [g_file_info_set_symbolic_icon: set_symbolic_icon].}
{.deprecated: [g_file_info_set_content_type: set_content_type].}
{.deprecated: [g_file_info_set_size: set_size].}
{.deprecated: [g_file_info_set_modification_time: set_modification_time].}
{.deprecated: [g_file_info_set_symlink_target: set_symlink_target].}
{.deprecated: [g_file_info_set_sort_order: set_sort_order].}
{.deprecated: [g_file_attribute_matcher_ref: `ref`].}
{.deprecated: [g_file_attribute_matcher_unref: unref].}
{.deprecated: [g_file_attribute_matcher_subtract: subtract].}
{.deprecated: [g_file_attribute_matcher_matches: matches].}
{.deprecated: [g_file_attribute_matcher_matches_only: matches_only].}
{.deprecated: [g_file_attribute_matcher_enumerate_namespace: enumerate_namespace].}
{.deprecated: [g_file_attribute_matcher_enumerate_next: enumerate_next].}
{.deprecated: [g_file_attribute_matcher_to_string: to_string].}
{.deprecated: [g_file_input_stream_query_info: query_info].}
{.deprecated: [g_file_input_stream_query_info_async: query_info_async].}
{.deprecated: [g_file_input_stream_query_info_finish: query_info_finish].}
{.deprecated: [g_io_stream_get_input_stream: get_input_stream].}
{.deprecated: [g_io_stream_get_output_stream: get_output_stream].}
{.deprecated: [g_io_stream_splice_async: splice_async].}
{.deprecated: [g_io_stream_close: close].}
{.deprecated: [g_io_stream_close_async: close_async].}
{.deprecated: [g_io_stream_close_finish: close_finish].}
{.deprecated: [g_io_stream_is_closed: is_closed].}
{.deprecated: [g_io_stream_has_pending: has_pending].}
{.deprecated: [g_io_stream_set_pending: set_pending].}
{.deprecated: [g_io_stream_clear_pending: clear_pending].}
{.deprecated: [g_file_io_stream_query_info: query_info].}
{.deprecated: [g_file_io_stream_query_info_async: query_info_async].}
{.deprecated: [g_file_io_stream_query_info_finish: query_info_finish].}
{.deprecated: [g_file_io_stream_get_etag: get_etag].}
{.deprecated: [g_file_monitor_cancel: cancel].}
{.deprecated: [g_file_monitor_is_cancelled: is_cancelled].}
{.deprecated: [g_file_monitor_set_rate_limit: set_rate_limit].}
{.deprecated: [g_file_monitor_emit_event: emit_event].}
{.deprecated: [g_filename_completer_get_completion_suffix: get_completion_suffix].}
{.deprecated: [g_filename_completer_get_completions: get_completions].}
{.deprecated: [g_filename_completer_set_dirs_only: set_dirs_only].}
{.deprecated: [g_file_output_stream_query_info: query_info].}
{.deprecated: [g_file_output_stream_query_info_async: query_info_async].}
{.deprecated: [g_file_output_stream_query_info_finish: query_info_finish].}
{.deprecated: [g_file_output_stream_get_etag: get_etag].}
{.deprecated: [g_inet_address_equal: equal].}
{.deprecated: [g_inet_address_to_string: to_string].}
{.deprecated: [g_inet_address_to_bytes: to_bytes].}
{.deprecated: [g_inet_address_get_native_size: get_native_size].}
{.deprecated: [g_inet_address_get_family: get_family].}
{.deprecated: [g_inet_address_get_is_any: get_is_any].}
{.deprecated: [g_inet_address_get_is_loopback: get_is_loopback].}
{.deprecated: [g_inet_address_get_is_link_local: get_is_link_local].}
{.deprecated: [g_inet_address_get_is_site_local: get_is_site_local].}
{.deprecated: [g_inet_address_get_is_multicast: get_is_multicast].}
{.deprecated: [g_inet_address_get_is_mc_global: get_is_mc_global].}
{.deprecated: [g_inet_address_get_is_mc_link_local: get_is_mc_link_local].}
{.deprecated: [g_inet_address_get_is_mc_node_local: get_is_mc_node_local].}
{.deprecated: [g_inet_address_get_is_mc_org_local: get_is_mc_org_local].}
{.deprecated: [g_inet_address_get_is_mc_site_local: get_is_mc_site_local].}
{.deprecated: [g_inet_address_mask_new: mask_new].}
{.deprecated: [g_inet_address_mask_to_string: to_string].}
{.deprecated: [g_inet_address_mask_get_family: get_family].}
{.deprecated: [g_inet_address_mask_get_address: get_address].}
{.deprecated: [g_inet_address_mask_get_length: get_length].}
{.deprecated: [g_inet_address_mask_matches: matches].}
{.deprecated: [g_inet_address_mask_equal: equal].}
{.deprecated: [g_socket_address_get_family: get_family].}
{.deprecated: [g_socket_address_to_native: to_native].}
{.deprecated: [g_socket_address_get_native_size: get_native_size].}
{.deprecated: [g_inet_socket_address_get_address: get_address].}
{.deprecated: [g_inet_socket_address_get_port: get_port].}
{.deprecated: [g_inet_socket_address_get_flowinfo: get_flowinfo].}
{.deprecated: [g_inet_socket_address_get_scope_id: get_scope_id].}
{.deprecated: [g_io_module_scope_free: free].}
{.deprecated: [g_io_module_scope_block: `block`].}
{.deprecated: [g_io_extension_point_set_required_type: set_required_type].}
{.deprecated: [g_io_extension_point_get_required_type: get_required_type].}
{.deprecated: [g_io_extension_point_get_extensions: get_extensions].}
{.deprecated: [g_io_extension_point_get_extension_by_name: get_extension_by_name].}
{.deprecated: [g_io_extension_get_type: get_type].}
{.deprecated: [g_io_extension_get_name: get_name].}
{.deprecated: [g_io_extension_get_priority: get_priority].}
{.deprecated: [g_io_extension_ref_class: ref_class].}
{.deprecated: [g_io_module_load: load].}
{.deprecated: [g_io_module_unload: unload].}
{.deprecated: [g_io_scheduler_job_send_to_mainloop: send_to_mainloop].}
{.deprecated: [g_io_scheduler_job_send_to_mainloop_async: send_to_mainloop_async].}
{.deprecated: [g_loadable_icon_load: load].}
{.deprecated: [g_loadable_icon_load_async: load_async].}
{.deprecated: [g_loadable_icon_load_finish: load_finish].}
{.deprecated: [g_memory_input_stream_add_data: add_data].}
{.deprecated: [g_memory_input_stream_add_bytes: add_bytes].}
{.deprecated: [g_memory_output_stream_get_data: get_data].}
{.deprecated: [g_memory_output_stream_get_size: get_size].}
{.deprecated: [g_memory_output_stream_get_data_size: get_data_size].}
{.deprecated: [g_memory_output_stream_steal_data: steal_data].}
{.deprecated: [g_memory_output_stream_steal_as_bytes: steal_as_bytes].}
{.deprecated: [g_mount_get_root: get_root].}
{.deprecated: [g_mount_get_default_location: get_default_location].}
{.deprecated: [g_mount_get_name: get_name].}
{.deprecated: [g_mount_get_icon: get_icon].}
{.deprecated: [g_mount_get_symbolic_icon: get_symbolic_icon].}
{.deprecated: [g_mount_get_uuid: get_uuid].}
{.deprecated: [g_mount_get_volume: get_volume].}
{.deprecated: [g_mount_get_drive: get_drive].}
{.deprecated: [g_mount_can_unmount: can_unmount].}
{.deprecated: [g_mount_can_eject: can_eject].}
{.deprecated: [g_mount_unmount: unmount].}
{.deprecated: [g_mount_unmount_finish: unmount_finish].}
{.deprecated: [g_mount_eject: eject].}
{.deprecated: [g_mount_eject_finish: eject_finish].}
{.deprecated: [g_mount_remount: remount].}
{.deprecated: [g_mount_remount_finish: remount_finish].}
{.deprecated: [g_mount_guess_content_type: guess_content_type].}
{.deprecated: [g_mount_guess_content_type_finish: guess_content_type_finish].}
{.deprecated: [g_mount_guess_content_type_sync: guess_content_type_sync].}
{.deprecated: [g_mount_is_shadowed: is_shadowed].}
{.deprecated: [g_mount_shadow: shadow].}
{.deprecated: [g_mount_unshadow: unshadow].}
{.deprecated: [g_mount_unmount_with_operation: unmount_with_operation].}
{.deprecated: [g_mount_unmount_with_operation_finish: unmount_with_operation_finish].}
{.deprecated: [g_mount_eject_with_operation: eject_with_operation].}
{.deprecated: [g_mount_eject_with_operation_finish: eject_with_operation_finish].}
{.deprecated: [g_mount_get_sort_key: get_sort_key].}
{.deprecated: [g_mount_operation_get_username: get_username].}
{.deprecated: [g_mount_operation_set_username: set_username].}
{.deprecated: [g_mount_operation_get_password: get_password].}
{.deprecated: [g_mount_operation_set_password: set_password].}
{.deprecated: [g_mount_operation_get_anonymous: get_anonymous].}
{.deprecated: [g_mount_operation_set_anonymous: set_anonymous].}
{.deprecated: [g_mount_operation_get_domain: get_domain].}
{.deprecated: [g_mount_operation_set_domain: set_domain].}
{.deprecated: [g_mount_operation_get_password_save: get_password_save].}
{.deprecated: [g_mount_operation_set_password_save: set_password_save].}
{.deprecated: [g_mount_operation_get_choice: get_choice].}
{.deprecated: [g_mount_operation_set_choice: set_choice].}
{.deprecated: [g_mount_operation_reply: reply].}
{.deprecated: [g_volume_monitor_get_connected_drives: get_connected_drives].}
{.deprecated: [g_volume_monitor_get_volumes: get_volumes].}
{.deprecated: [g_volume_monitor_get_mounts: get_mounts].}
{.deprecated: [g_volume_monitor_get_volume_for_uuid: get_volume_for_uuid].}
{.deprecated: [g_volume_monitor_get_mount_for_uuid: get_mount_for_uuid].}
{.deprecated: [g_network_address_get_hostname: get_hostname].}
{.deprecated: [g_network_address_get_port: get_port].}
{.deprecated: [g_network_address_get_scheme: get_scheme].}
{.deprecated: [g_network_monitor_get_network_available: get_network_available].}
{.deprecated: [g_network_monitor_get_connectivity: get_connectivity].}
{.deprecated: [g_network_monitor_can_reach: can_reach].}
{.deprecated: [g_network_monitor_can_reach_async: can_reach_async].}
{.deprecated: [g_network_monitor_can_reach_finish: can_reach_finish].}
{.deprecated: [g_network_service_get_service: get_service].}
{.deprecated: [g_network_service_get_protocol: get_protocol].}
{.deprecated: [g_network_service_get_domain: get_domain].}
{.deprecated: [g_network_service_get_scheme: get_scheme].}
{.deprecated: [g_network_service_set_scheme: set_scheme].}
{.deprecated: [g_permission_acquire: acquire].}
{.deprecated: [g_permission_acquire_async: acquire_async].}
{.deprecated: [g_permission_acquire_finish: acquire_finish].}
{.deprecated: [g_permission_release: release].}
{.deprecated: [g_permission_release_async: release_async].}
{.deprecated: [g_permission_release_finish: release_finish].}
{.deprecated: [g_permission_get_allowed: get_allowed].}
{.deprecated: [g_permission_get_can_acquire: get_can_acquire].}
{.deprecated: [g_permission_get_can_release: get_can_release].}
{.deprecated: [g_permission_impl_update: impl_update].}
{.deprecated: [g_pollable_input_stream_can_poll: can_poll].}
{.deprecated: [g_pollable_input_stream_is_readable: is_readable].}
{.deprecated: [g_pollable_input_stream_create_source: create_source].}
{.deprecated: [g_pollable_input_stream_read_nonblocking: read_nonblocking].}
{.deprecated: [g_pollable_output_stream_can_poll: can_poll].}
{.deprecated: [g_pollable_output_stream_is_writable: is_writable].}
{.deprecated: [g_pollable_output_stream_create_source: create_source].}
{.deprecated: [g_pollable_output_stream_write_nonblocking: write_nonblocking].}
{.deprecated: [g_proxy_connect: connect].}
{.deprecated: [g_proxy_connect_async: connect_async].}
{.deprecated: [g_proxy_connect_finish: connect_finish].}
{.deprecated: [g_proxy_supports_hostname: supports_hostname].}
{.deprecated: [g_proxy_address_get_protocol: get_protocol].}
{.deprecated: [g_proxy_address_get_destination_protocol: get_destination_protocol].}
{.deprecated: [g_proxy_address_get_destination_hostname: get_destination_hostname].}
{.deprecated: [g_proxy_address_get_destination_port: get_destination_port].}
{.deprecated: [g_proxy_address_get_username: get_username].}
{.deprecated: [g_proxy_address_get_password: get_password].}
{.deprecated: [g_proxy_address_get_uri: get_uri].}
{.deprecated: [g_socket_address_enumerator_next: next].}
{.deprecated: [g_socket_address_enumerator_next_async: next_async].}
{.deprecated: [g_socket_address_enumerator_next_finish: next_finish].}
{.deprecated: [g_proxy_resolver_is_supported: is_supported].}
{.deprecated: [g_proxy_resolver_lookup: lookup].}
{.deprecated: [g_proxy_resolver_lookup_async: lookup_async].}
{.deprecated: [g_proxy_resolver_lookup_finish: lookup_finish].}
{.deprecated: [g_resolver_set_default: set_default].}
{.deprecated: [g_resolver_lookup_by_name: lookup_by_name].}
{.deprecated: [g_resolver_lookup_by_name_async: lookup_by_name_async].}
{.deprecated: [g_resolver_lookup_by_name_finish: lookup_by_name_finish].}
{.deprecated: [g_resolver_lookup_by_address: lookup_by_address].}
{.deprecated: [g_resolver_lookup_by_address_async: lookup_by_address_async].}
{.deprecated: [g_resolver_lookup_by_address_finish: lookup_by_address_finish].}
{.deprecated: [g_resolver_lookup_service: lookup_service].}
{.deprecated: [g_resolver_lookup_service_async: lookup_service_async].}
{.deprecated: [g_resolver_lookup_service_finish: lookup_service_finish].}
{.deprecated: [g_resolver_lookup_records: lookup_records].}
{.deprecated: [g_resolver_lookup_records_async: lookup_records_async].}
{.deprecated: [g_resolver_lookup_records_finish: lookup_records_finish].}
{.deprecated: [g_resource_ref: `ref`].}
{.deprecated: [g_resource_unref: unref].}
{.deprecated: [g_resource_open_stream: open_stream].}
{.deprecated: [g_resource_lookup_data: lookup_data].}
{.deprecated: [g_resource_enumerate_children: enumerate_children].}
{.deprecated: [g_resource_get_info: get_info].}
{.deprecated: [g_resources_register: register].}
{.deprecated: [g_resources_unregister: unregister].}
{.deprecated: [g_static_resource_init: init].}
{.deprecated: [g_static_resource_fini: fini].}
{.deprecated: [g_static_resource_get_resource: get_resource].}
{.deprecated: [g_seekable_tell: tell].}
{.deprecated: [g_seekable_can_seek: can_seek].}
{.deprecated: [g_seekable_seek: seek].}
{.deprecated: [g_seekable_can_truncate: can_truncate].}
{.deprecated: [g_seekable_truncate: truncate].}
{.deprecated: [g_settings_schema_source_ref: `ref`].}
{.deprecated: [g_settings_schema_source_unref: unref].}
{.deprecated: [g_settings_schema_source_lookup: lookup].}
{.deprecated: [g_settings_schema_source_list_schemas: list_schemas].}
{.deprecated: [g_settings_schema_ref: `ref`].}
{.deprecated: [g_settings_schema_unref: unref].}
{.deprecated: [g_settings_schema_get_id: get_id].}
{.deprecated: [g_settings_schema_get_path: get_path].}
{.deprecated: [g_settings_schema_get_key: get_key].}
{.deprecated: [g_settings_schema_has_key: has_key].}
{.deprecated: [g_settings_schema_list_children: list_children].}
{.deprecated: [g_settings_schema_key_ref: `ref`].}
{.deprecated: [g_settings_schema_key_unref: unref].}
{.deprecated: [g_settings_schema_key_get_value_type: get_value_type].}
{.deprecated: [g_settings_schema_key_get_default_value: get_default_value].}
{.deprecated: [g_settings_schema_key_get_range: get_range].}
{.deprecated: [g_settings_schema_key_range_check: range_check].}
{.deprecated: [g_settings_schema_key_get_name: get_name].}
{.deprecated: [g_settings_schema_key_get_summary: get_summary].}
{.deprecated: [g_settings_schema_key_get_description: get_description].}
{.deprecated: [g_settings_list_children: list_children].}
{.deprecated: [g_settings_list_keys: list_keys].}
{.deprecated: [g_settings_get_range: get_range].}
{.deprecated: [g_settings_range_check: range_check].}
{.deprecated: [g_settings_set_value: set_value].}
{.deprecated: [g_settings_get_value: get_value].}
{.deprecated: [g_settings_get_user_value: get_user_value].}
{.deprecated: [g_settings_get_default_value: get_default_value].}
{.deprecated: [g_settings_set: set].}
{.deprecated: [g_settings_get: get].}
{.deprecated: [g_settings_reset: reset].}
{.deprecated: [g_settings_get_int: get_int].}
{.deprecated: [g_settings_set_int: set_int].}
{.deprecated: [g_settings_get_uint: get_uint].}
{.deprecated: [g_settings_set_uint: set_uint].}
{.deprecated: [g_settings_get_string: get_string].}
{.deprecated: [g_settings_set_string: set_string].}
{.deprecated: [g_settings_get_boolean: get_boolean].}
{.deprecated: [g_settings_set_boolean: set_boolean].}
{.deprecated: [g_settings_get_double: get_double].}
{.deprecated: [g_settings_set_double: set_double].}
{.deprecated: [g_settings_get_strv: get_strv].}
{.deprecated: [g_settings_set_strv: set_strv].}
{.deprecated: [g_settings_get_enum: get_enum].}
{.deprecated: [g_settings_set_enum: set_enum].}
{.deprecated: [g_settings_get_flags: get_flags].}
{.deprecated: [g_settings_set_flags: set_flags].}
{.deprecated: [g_settings_get_child: get_child].}
{.deprecated: [g_settings_is_writable: is_writable].}
{.deprecated: [g_settings_delay: delay].}
{.deprecated: [g_settings_apply: apply].}
{.deprecated: [g_settings_revert: revert].}
{.deprecated: [g_settings_get_has_unapplied: get_has_unapplied].}
{.deprecated: [g_settings_bind: `bind`].}
{.deprecated: [g_settings_bind_with_mapping: bind_with_mapping].}
{.deprecated: [g_settings_bind_writable: bind_writable].}
{.deprecated: [g_settings_create_action: create_action].}
{.deprecated: [g_settings_get_mapped: get_mapped].}
{.deprecated: [g_simple_action_set_enabled: set_enabled].}
{.deprecated: [g_simple_action_set_state: set_state].}
{.deprecated: [g_simple_action_set_state_hint: set_state_hint].}
{.deprecated: [g_simple_action_group_lookup: lookup].}
{.deprecated: [g_simple_action_group_insert: insert].}
{.deprecated: [g_simple_action_group_remove: remove].}
{.deprecated: [g_simple_action_group_add_entries: add_entries].}
{.deprecated: [g_simple_async_result_set_op_res_gpointer: set_op_res_gpointer].}
{.deprecated: [g_simple_async_result_get_op_res_gpointer: get_op_res_gpointer].}
{.deprecated: [g_simple_async_result_set_op_res_gssize: set_op_res_gssize].}
{.deprecated: [g_simple_async_result_get_op_res_gssize: get_op_res_gssize].}
{.deprecated: [g_simple_async_result_set_op_res_gboolean: set_op_res_gboolean].}
{.deprecated: [g_simple_async_result_get_op_res_gboolean: get_op_res_gboolean].}
{.deprecated: [g_simple_async_result_set_check_cancellable: set_check_cancellable].}
{.deprecated: [g_simple_async_result_get_source_tag: get_source_tag].}
{.deprecated: [g_simple_async_result_set_handle_cancellation: set_handle_cancellation].}
{.deprecated: [g_simple_async_result_complete: complete].}
{.deprecated: [g_simple_async_result_complete_in_idle: complete_in_idle].}
{.deprecated: [g_simple_async_result_run_in_thread: run_in_thread].}
{.deprecated: [g_simple_async_result_set_from_error: set_from_error].}
{.deprecated: [g_simple_async_result_take_error: take_error].}
{.deprecated: [g_simple_async_result_propagate_error: propagate_error].}
{.deprecated: [g_simple_async_result_set_error: set_error].}
{.deprecated: [g_socket_client_get_family: get_family].}
{.deprecated: [g_socket_client_set_family: set_family].}
{.deprecated: [g_socket_client_get_socket_type: get_socket_type].}
{.deprecated: [g_socket_client_set_socket_type: set_socket_type].}
{.deprecated: [g_socket_client_get_protocol: get_protocol].}
{.deprecated: [g_socket_client_set_protocol: set_protocol].}
{.deprecated: [g_socket_client_get_local_address: get_local_address].}
{.deprecated: [g_socket_client_set_local_address: set_local_address].}
{.deprecated: [g_socket_client_get_timeout: get_timeout].}
{.deprecated: [g_socket_client_set_timeout: set_timeout].}
{.deprecated: [g_socket_client_get_enable_proxy: get_enable_proxy].}
{.deprecated: [g_socket_client_set_enable_proxy: set_enable_proxy].}
{.deprecated: [g_socket_client_get_tls: get_tls].}
{.deprecated: [g_socket_client_set_tls: set_tls].}
{.deprecated: [g_socket_client_get_tls_validation_flags: get_tls_validation_flags].}
{.deprecated: [g_socket_client_set_tls_validation_flags: set_tls_validation_flags].}
{.deprecated: [g_socket_client_get_proxy_resolver: get_proxy_resolver].}
{.deprecated: [g_socket_client_set_proxy_resolver: set_proxy_resolver].}
{.deprecated: [g_socket_client_connect: connect].}
{.deprecated: [g_socket_client_connect_to_host: connect_to_host].}
{.deprecated: [g_socket_client_connect_to_service: connect_to_service].}
{.deprecated: [g_socket_client_connect_to_uri: connect_to_uri].}
{.deprecated: [g_socket_client_connect_async: connect_async].}
{.deprecated: [g_socket_client_connect_finish: connect_finish].}
{.deprecated: [g_socket_client_connect_to_host_async: connect_to_host_async].}
{.deprecated: [g_socket_client_connect_to_host_finish: connect_to_host_finish].}
{.deprecated: [g_socket_client_connect_to_service_async: connect_to_service_async].}
{.deprecated: [g_socket_client_connect_to_service_finish: connect_to_service_finish].}
{.deprecated: [g_socket_client_connect_to_uri_async: connect_to_uri_async].}
{.deprecated: [g_socket_client_connect_to_uri_finish: connect_to_uri_finish].}
{.deprecated: [g_socket_client_add_application_proxy: add_application_proxy].}
{.deprecated: [g_socket_connectable_enumerate: enumerate].}
{.deprecated: [g_socket_connectable_proxy_enumerate: proxy_enumerate].}
{.deprecated: [g_socket_get_fd: get_fd].}
{.deprecated: [g_socket_get_family: get_family].}
{.deprecated: [g_socket_get_socket_type: get_socket_type].}
{.deprecated: [g_socket_get_protocol: get_protocol].}
{.deprecated: [g_socket_get_local_address: get_local_address].}
{.deprecated: [g_socket_get_remote_address: get_remote_address].}
{.deprecated: [g_socket_set_blocking: set_blocking].}
{.deprecated: [g_socket_get_blocking: get_blocking].}
{.deprecated: [g_socket_set_keepalive: set_keepalive].}
{.deprecated: [g_socket_get_keepalive: get_keepalive].}
{.deprecated: [g_socket_get_listen_backlog: get_listen_backlog].}
{.deprecated: [g_socket_set_listen_backlog: set_listen_backlog].}
{.deprecated: [g_socket_get_timeout: get_timeout].}
{.deprecated: [g_socket_set_timeout: set_timeout].}
{.deprecated: [g_socket_get_ttl: get_ttl].}
{.deprecated: [g_socket_set_ttl: set_ttl].}
{.deprecated: [g_socket_get_broadcast: get_broadcast].}
{.deprecated: [g_socket_set_broadcast: set_broadcast].}
{.deprecated: [g_socket_get_multicast_loopback: get_multicast_loopback].}
{.deprecated: [g_socket_set_multicast_loopback: set_multicast_loopback].}
{.deprecated: [g_socket_get_multicast_ttl: get_multicast_ttl].}
{.deprecated: [g_socket_set_multicast_ttl: set_multicast_ttl].}
{.deprecated: [g_socket_is_connected: is_connected].}
{.deprecated: [g_socket_bind: `bind`].}
{.deprecated: [g_socket_join_multicast_group: join_multicast_group].}
{.deprecated: [g_socket_leave_multicast_group: leave_multicast_group].}
{.deprecated: [g_socket_connect: connect].}
{.deprecated: [g_socket_check_connect_result: check_connect_result].}
{.deprecated: [g_socket_get_available_bytes: get_available_bytes].}
{.deprecated: [g_socket_condition_check: condition_check].}
{.deprecated: [g_socket_condition_wait: condition_wait].}
{.deprecated: [g_socket_condition_timed_wait: condition_timed_wait].}
{.deprecated: [g_socket_accept: accept].}
{.deprecated: [g_socket_listen: listen].}
{.deprecated: [g_socket_receive: receive].}
{.deprecated: [g_socket_receive_from: receive_from].}
{.deprecated: [g_socket_send: send].}
{.deprecated: [g_socket_send_to: send_to].}
{.deprecated: [g_socket_receive_message: receive_message].}
{.deprecated: [g_socket_send_message: send_message].}
{.deprecated: [g_socket_send_messages: send_messages].}
{.deprecated: [g_socket_close: close].}
{.deprecated: [g_socket_shutdown: shutdown].}
{.deprecated: [g_socket_is_closed: is_closed].}
{.deprecated: [g_socket_create_source: create_source].}
{.deprecated: [g_socket_speaks_ipv4: speaks_ipv4].}
{.deprecated: [g_socket_get_credentials: get_credentials].}
{.deprecated: [g_socket_receive_with_blocking: receive_with_blocking].}
{.deprecated: [g_socket_send_with_blocking: send_with_blocking].}
{.deprecated: [g_socket_get_option: get_option].}
{.deprecated: [g_socket_set_option: set_option].}
{.deprecated: [g_socket_connection_is_connected: is_connected].}
{.deprecated: [g_socket_connection_connect: connect].}
{.deprecated: [g_socket_connection_connect_async: connect_async].}
{.deprecated: [g_socket_connection_connect_finish: connect_finish].}
{.deprecated: [g_socket_connection_get_socket: get_socket].}
{.deprecated: [g_socket_connection_get_local_address: get_local_address].}
{.deprecated: [g_socket_connection_get_remote_address: get_remote_address].}
{.deprecated: [g_socket_connection_factory_create_connection: connection_factory_create_connection].}
{.deprecated: [g_socket_control_message_get_size: get_size].}
{.deprecated: [g_socket_control_message_get_level: get_level].}
{.deprecated: [g_socket_control_message_get_msg_type: get_msg_type].}
{.deprecated: [g_socket_control_message_serialize: serialize].}
{.deprecated: [g_socket_listener_set_backlog: set_backlog].}
{.deprecated: [g_socket_listener_add_socket: add_socket].}
{.deprecated: [g_socket_listener_add_address: add_address].}
{.deprecated: [g_socket_listener_add_inet_port: add_inet_port].}
{.deprecated: [g_socket_listener_add_any_inet_port: add_any_inet_port].}
{.deprecated: [g_socket_listener_accept_socket: accept_socket].}
{.deprecated: [g_socket_listener_accept_socket_async: accept_socket_async].}
{.deprecated: [g_socket_listener_accept_socket_finish: accept_socket_finish].}
{.deprecated: [g_socket_listener_accept: accept].}
{.deprecated: [g_socket_listener_accept_async: accept_async].}
{.deprecated: [g_socket_listener_accept_finish: accept_finish].}
{.deprecated: [g_socket_listener_close: close].}
{.deprecated: [g_socket_service_start: start].}
{.deprecated: [g_socket_service_stop: stop].}
{.deprecated: [g_socket_service_is_active: is_active].}
{.deprecated: [g_srv_target_copy: copy].}
{.deprecated: [g_srv_target_free: free].}
{.deprecated: [g_srv_target_get_hostname: get_hostname].}
{.deprecated: [g_srv_target_get_port: get_port].}
{.deprecated: [g_srv_target_get_priority: get_priority].}
{.deprecated: [g_srv_target_get_weight: get_weight].}
{.deprecated: [g_simple_proxy_resolver_set_default_proxy: set_default_proxy].}
{.deprecated: [g_simple_proxy_resolver_set_ignore_hosts: set_ignore_hosts].}
{.deprecated: [g_simple_proxy_resolver_set_uri_proxy: set_uri_proxy].}
{.deprecated: [g_task_set_task_data: set_task_data].}
{.deprecated: [g_task_set_priority: set_priority].}
{.deprecated: [g_task_set_check_cancellable: set_check_cancellable].}
{.deprecated: [g_task_set_source_tag: set_source_tag].}
{.deprecated: [g_task_get_source_object: get_source_object].}
{.deprecated: [g_task_get_task_data: get_task_data].}
{.deprecated: [g_task_get_priority: get_priority].}
{.deprecated: [g_task_get_context: get_context].}
{.deprecated: [g_task_get_cancellable: get_cancellable].}
{.deprecated: [g_task_get_check_cancellable: get_check_cancellable].}
{.deprecated: [g_task_get_source_tag: get_source_tag].}
{.deprecated: [g_task_run_in_thread: run_in_thread].}
{.deprecated: [g_task_run_in_thread_sync: run_in_thread_sync].}
{.deprecated: [g_task_set_return_on_cancel: set_return_on_cancel].}
{.deprecated: [g_task_get_return_on_cancel: get_return_on_cancel].}
{.deprecated: [g_task_attach_source: attach_source].}
{.deprecated: [g_task_return_pointer: return_pointer].}
{.deprecated: [g_task_return_boolean: return_boolean].}
{.deprecated: [g_task_return_int: return_int].}
{.deprecated: [g_task_return_error: return_error].}
{.deprecated: [g_task_return_new_error: return_new_error].}
{.deprecated: [g_task_return_error_if_cancelled: return_error_if_cancelled].}
{.deprecated: [g_task_propagate_pointer: propagate_pointer].}
{.deprecated: [g_task_propagate_boolean: propagate_boolean].}
{.deprecated: [g_task_propagate_int: propagate_int].}
{.deprecated: [g_task_had_error: had_error].}
{.deprecated: [g_subprocess_get_stdin_pipe: get_stdin_pipe].}
{.deprecated: [g_subprocess_get_stdout_pipe: get_stdout_pipe].}
{.deprecated: [g_subprocess_get_stderr_pipe: get_stderr_pipe].}
{.deprecated: [g_subprocess_get_identifier: get_identifier].}
{.deprecated: [g_subprocess_force_exit: force_exit].}
{.deprecated: [g_subprocess_wait: wait].}
{.deprecated: [g_subprocess_wait_async: wait_async].}
{.deprecated: [g_subprocess_wait_finish: wait_finish].}
{.deprecated: [g_subprocess_wait_check: wait_check].}
{.deprecated: [g_subprocess_wait_check_async: wait_check_async].}
{.deprecated: [g_subprocess_wait_check_finish: wait_check_finish].}
{.deprecated: [g_subprocess_get_status: get_status].}
{.deprecated: [g_subprocess_get_successful: get_successful].}
{.deprecated: [g_subprocess_get_if_exited: get_if_exited].}
{.deprecated: [g_subprocess_get_exit_status: get_exit_status].}
{.deprecated: [g_subprocess_get_if_signaled: get_if_signaled].}
{.deprecated: [g_subprocess_get_term_sig: get_term_sig].}
{.deprecated: [g_subprocess_communicate: communicate].}
{.deprecated: [g_subprocess_communicate_async: communicate_async].}
{.deprecated: [g_subprocess_communicate_finish: communicate_finish].}
{.deprecated: [g_subprocess_communicate_utf8: communicate_utf8].}
{.deprecated: [g_subprocess_communicate_utf8_async: communicate_utf8_async].}
{.deprecated: [g_subprocess_communicate_utf8_finish: communicate_utf8_finish].}
{.deprecated: [g_subprocess_launcher_spawn: spawn].}
{.deprecated: [g_subprocess_launcher_spawnv: spawnv].}
{.deprecated: [g_subprocess_launcher_set_environ: set_environ].}
{.deprecated: [g_subprocess_launcher_setenv: setenv].}
{.deprecated: [g_subprocess_launcher_unsetenv: unsetenv].}
{.deprecated: [g_subprocess_launcher_getenv: getenv].}
{.deprecated: [g_subprocess_launcher_set_cwd: set_cwd].}
{.deprecated: [g_subprocess_launcher_set_flags: set_flags].}
{.deprecated: [g_tcp_connection_set_graceful_disconnect: set_graceful_disconnect].}
{.deprecated: [g_tcp_connection_get_graceful_disconnect: get_graceful_disconnect].}
{.deprecated: [g_tcp_wrapper_connection_get_base_io_stream: get_base_io_stream].}
{.deprecated: [g_themed_icon_prepend_name: prepend_name].}
{.deprecated: [g_themed_icon_append_name: append_name].}
{.deprecated: [g_themed_icon_get_names: get_names].}
{.deprecated: [g_tls_backend_get_default_database: get_default_database].}
{.deprecated: [g_tls_backend_supports_tls: supports_tls].}
{.deprecated: [g_tls_backend_get_certificate_type: get_certificate_type].}
{.deprecated: [g_tls_backend_get_client_connection_type: get_client_connection_type].}
{.deprecated: [g_tls_backend_get_server_connection_type: get_server_connection_type].}
{.deprecated: [g_tls_backend_get_file_database_type: get_file_database_type].}
{.deprecated: [g_tls_certificate_get_issuer: get_issuer].}
{.deprecated: [g_tls_certificate_verify: verify].}
{.deprecated: [g_tls_certificate_is_same: is_same].}
{.deprecated: [g_tls_connection_set_use_system_certdb: set_use_system_certdb].}
{.deprecated: [g_tls_connection_get_use_system_certdb: get_use_system_certdb].}
{.deprecated: [g_tls_connection_set_database: set_database].}
{.deprecated: [g_tls_connection_get_database: get_database].}
{.deprecated: [g_tls_connection_set_certificate: set_certificate].}
{.deprecated: [g_tls_connection_get_certificate: get_certificate].}
{.deprecated: [g_tls_connection_set_interaction: set_interaction].}
{.deprecated: [g_tls_connection_get_interaction: get_interaction].}
{.deprecated: [g_tls_connection_get_peer_certificate: get_peer_certificate].}
{.deprecated: [g_tls_connection_get_peer_certificate_errors: get_peer_certificate_errors].}
{.deprecated: [g_tls_connection_set_require_close_notify: set_require_close_notify].}
{.deprecated: [g_tls_connection_get_require_close_notify: get_require_close_notify].}
{.deprecated: [g_tls_connection_set_rehandshake_mode: set_rehandshake_mode].}
{.deprecated: [g_tls_connection_get_rehandshake_mode: get_rehandshake_mode].}
{.deprecated: [g_tls_connection_handshake: handshake].}
{.deprecated: [g_tls_connection_handshake_async: handshake_async].}
{.deprecated: [g_tls_connection_handshake_finish: handshake_finish].}
{.deprecated: [g_tls_connection_emit_accept_certificate: emit_accept_certificate].}
{.deprecated: [g_tls_client_connection_get_validation_flags: get_validation_flags].}
{.deprecated: [g_tls_client_connection_set_validation_flags: set_validation_flags].}
{.deprecated: [g_tls_client_connection_get_server_identity: get_server_identity].}
{.deprecated: [g_tls_client_connection_set_server_identity: set_server_identity].}
{.deprecated: [g_tls_client_connection_get_use_ssl3: get_use_ssl3].}
{.deprecated: [g_tls_client_connection_set_use_ssl3: set_use_ssl3].}
{.deprecated: [g_tls_client_connection_get_accepted_cas: get_accepted_cas].}
{.deprecated: [g_tls_database_verify_chain: verify_chain].}
{.deprecated: [g_tls_database_verify_chain_async: verify_chain_async].}
{.deprecated: [g_tls_database_verify_chain_finish: verify_chain_finish].}
{.deprecated: [g_tls_database_create_certificate_handle: create_certificate_handle].}
{.deprecated: [g_tls_database_lookup_certificate_for_handle: lookup_certificate_for_handle].}
{.deprecated: [g_tls_database_lookup_certificate_for_handle_async: lookup_certificate_for_handle_async].}
{.deprecated: [g_tls_database_lookup_certificate_for_handle_finish: lookup_certificate_for_handle_finish].}
{.deprecated: [g_tls_database_lookup_certificate_issuer: lookup_certificate_issuer].}
{.deprecated: [g_tls_database_lookup_certificate_issuer_async: lookup_certificate_issuer_async].}
{.deprecated: [g_tls_database_lookup_certificate_issuer_finish: lookup_certificate_issuer_finish].}
{.deprecated: [g_tls_database_lookup_certificates_issued_by: lookup_certificates_issued_by].}
{.deprecated: [g_tls_database_lookup_certificates_issued_by_async: lookup_certificates_issued_by_async].}
{.deprecated: [g_tls_database_lookup_certificates_issued_by_finish: lookup_certificates_issued_by_finish].}
{.deprecated: [g_tls_interaction_invoke_ask_password: invoke_ask_password].}
{.deprecated: [g_tls_interaction_ask_password: ask_password].}
{.deprecated: [g_tls_interaction_ask_password_async: ask_password_async].}
{.deprecated: [g_tls_interaction_ask_password_finish: ask_password_finish].}
{.deprecated: [g_tls_interaction_invoke_request_certificate: invoke_request_certificate].}
{.deprecated: [g_tls_interaction_request_certificate: request_certificate].}
{.deprecated: [g_tls_interaction_request_certificate_async: request_certificate_async].}
{.deprecated: [g_tls_interaction_request_certificate_finish: request_certificate_finish].}
{.deprecated: [g_tls_password_get_value: get_value].}
{.deprecated: [g_tls_password_set_value: set_value].}
{.deprecated: [g_tls_password_set_value_full: set_value_full].}
{.deprecated: [g_tls_password_get_flags: get_flags].}
{.deprecated: [g_tls_password_set_flags: set_flags].}
{.deprecated: [g_tls_password_get_description: get_description].}
{.deprecated: [g_tls_password_set_description: set_description].}
{.deprecated: [g_tls_password_get_warning: get_warning].}
{.deprecated: [g_tls_password_set_warning: set_warning].}
{.deprecated: [g_vfs_is_active: is_active].}
{.deprecated: [g_vfs_get_file_for_path: get_file_for_path].}
{.deprecated: [g_vfs_get_file_for_uri: get_file_for_uri].}
{.deprecated: [g_vfs_get_supported_uri_schemes: get_supported_uri_schemes].}
{.deprecated: [g_vfs_parse_name: parse_name].}
{.deprecated: [g_volume_get_name: get_name].}
{.deprecated: [g_volume_get_icon: get_icon].}
{.deprecated: [g_volume_get_symbolic_icon: get_symbolic_icon].}
{.deprecated: [g_volume_get_uuid: get_uuid].}
{.deprecated: [g_volume_get_drive: get_drive].}
{.deprecated: [g_volume_get_mount: get_mount].}
{.deprecated: [g_volume_can_mount: can_mount].}
{.deprecated: [g_volume_can_eject: can_eject].}
{.deprecated: [g_volume_should_automount: should_automount].}
{.deprecated: [g_volume_mount: mount].}
{.deprecated: [g_volume_mount_finish: mount_finish].}
{.deprecated: [g_volume_eject: eject].}
{.deprecated: [g_volume_eject_finish: eject_finish].}
{.deprecated: [g_volume_get_identifier: get_identifier].}
{.deprecated: [g_volume_enumerate_identifiers: enumerate_identifiers].}
{.deprecated: [g_volume_get_activation_root: get_activation_root].}
{.deprecated: [g_volume_eject_with_operation: eject_with_operation].}
{.deprecated: [g_volume_eject_with_operation_finish: eject_with_operation_finish].}
{.deprecated: [g_volume_get_sort_key: get_sort_key].}
{.deprecated: [g_zlib_compressor_get_file_info: get_file_info].}
{.deprecated: [g_zlib_compressor_set_file_info: set_file_info].}
{.deprecated: [g_zlib_decompressor_get_file_info: get_file_info].}
{.deprecated: [g_dbus_interface_get_info: get_info].}
{.deprecated: [g_dbus_interface_get_object: get_object].}
{.deprecated: [g_dbus_interface_set_object: set_object].}
{.deprecated: [g_dbus_interface_dup_object: dup_object].}
{.deprecated: [g_dbus_interface_skeleton_get_flags: get_flags].}
{.deprecated: [g_dbus_interface_skeleton_set_flags: set_flags].}
{.deprecated: [g_dbus_interface_skeleton_get_info: get_info].}
{.deprecated: [g_dbus_interface_skeleton_get_vtable: get_vtable].}
{.deprecated: [g_dbus_interface_skeleton_get_properties: get_properties].}
{.deprecated: [g_dbus_interface_skeleton_flush: flush].}
{.deprecated: [g_dbus_interface_skeleton_export: `export`].}
{.deprecated: [g_dbus_interface_skeleton_unexport: unexport].}
{.deprecated: [g_dbus_interface_skeleton_unexport_from_connection: unexport_from_connection].}
{.deprecated: [g_dbus_interface_skeleton_get_connection: get_connection].}
{.deprecated: [g_dbus_interface_skeleton_get_connections: get_connections].}
{.deprecated: [g_dbus_interface_skeleton_has_connection: has_connection].}
{.deprecated: [g_dbus_interface_skeleton_get_object_path: get_object_path].}
{.deprecated: [g_dbus_object_get_object_path: get_object_path].}
{.deprecated: [g_dbus_object_get_interfaces: get_interfaces].}
{.deprecated: [g_dbus_object_get_interface: get_interface].}
{.deprecated: [g_dbus_object_skeleton_flush: flush].}
{.deprecated: [g_dbus_object_skeleton_add_interface: add_interface].}
{.deprecated: [g_dbus_object_skeleton_remove_interface: remove_interface].}
{.deprecated: [g_dbus_object_skeleton_remove_interface_by_name: remove_interface_by_name].}
{.deprecated: [g_dbus_object_skeleton_set_object_path: set_object_path].}
{.deprecated: [g_dbus_object_proxy_get_connection: get_connection].}
{.deprecated: [g_dbus_object_manager_get_object_path: get_object_path].}
{.deprecated: [g_dbus_object_manager_get_objects: get_objects].}
{.deprecated: [g_dbus_object_manager_get_object: get_object].}
{.deprecated: [g_dbus_object_manager_get_interface: get_interface].}
{.deprecated: [g_dbus_object_manager_client_get_connection: get_connection].}
{.deprecated: [g_dbus_object_manager_client_get_flags: get_flags].}
{.deprecated: [g_dbus_object_manager_client_get_name: get_name].}
{.deprecated: [g_dbus_object_manager_client_get_name_owner: get_name_owner].}
{.deprecated: [g_dbus_object_manager_server_get_connection: get_connection].}
{.deprecated: [g_dbus_object_manager_server_set_connection: set_connection].}
{.deprecated: [g_dbus_object_manager_server_export: `export`].}
{.deprecated: [g_dbus_object_manager_server_export_uniquely: export_uniquely].}
{.deprecated: [g_dbus_object_manager_server_is_exported: is_exported].}
{.deprecated: [g_dbus_object_manager_server_unexport: unexport].}
{.deprecated: [g_remote_action_group_activate_action_full: activate_action_full].}
{.deprecated: [g_remote_action_group_change_action_state_full: change_action_state_full].}
{.deprecated: [g_menu_model_is_mutable: is_mutable].}
{.deprecated: [g_menu_model_get_n_items: get_n_items].}
{.deprecated: [g_menu_model_iterate_item_attributes: iterate_item_attributes].}
{.deprecated: [g_menu_model_get_item_attribute_value: get_item_attribute_value].}
{.deprecated: [g_menu_model_get_item_attribute: get_item_attribute].}
{.deprecated: [g_menu_model_iterate_item_links: iterate_item_links].}
{.deprecated: [g_menu_model_get_item_link: get_item_link].}
{.deprecated: [g_menu_model_items_changed: items_changed].}
{.deprecated: [g_menu_attribute_iter_get_next: get_next].}
{.deprecated: [g_menu_attribute_iter_next: next].}
{.deprecated: [g_menu_attribute_iter_get_name: get_name].}
{.deprecated: [g_menu_attribute_iter_get_value: get_value].}
{.deprecated: [g_menu_link_iter_get_next: get_next].}
{.deprecated: [g_menu_link_iter_next: next].}
{.deprecated: [g_menu_link_iter_get_name: get_name].}
{.deprecated: [g_menu_link_iter_get_value: get_value].}
{.deprecated: [g_menu_freeze: freeze].}
{.deprecated: [g_menu_insert_item: insert_item].}
{.deprecated: [g_menu_prepend_item: prepend_item].}
{.deprecated: [g_menu_append_item: append_item].}
{.deprecated: [g_menu_remove: remove].}
{.deprecated: [g_menu_remove_all: remove_all].}
{.deprecated: [g_menu_insert: insert].}
{.deprecated: [g_menu_prepend: prepend].}
{.deprecated: [g_menu_append: append].}
{.deprecated: [g_menu_insert_section: insert_section].}
{.deprecated: [g_menu_prepend_section: prepend_section].}
{.deprecated: [g_menu_append_section: append_section].}
{.deprecated: [g_menu_insert_submenu: insert_submenu].}
{.deprecated: [g_menu_prepend_submenu: prepend_submenu].}
{.deprecated: [g_menu_append_submenu: append_submenu].}
{.deprecated: [g_menu_item_get_attribute_value: get_attribute_value].}
{.deprecated: [g_menu_item_get_attribute: get_attribute].}
{.deprecated: [g_menu_item_get_link: get_link].}
{.deprecated: [g_menu_item_set_attribute_value: set_attribute_value].}
{.deprecated: [g_menu_item_set_attribute: set_attribute].}
{.deprecated: [g_menu_item_set_link: set_link].}
{.deprecated: [g_menu_item_set_label: set_label].}
{.deprecated: [g_menu_item_set_submenu: set_submenu].}
{.deprecated: [g_menu_item_set_section: set_section].}
{.deprecated: [g_menu_item_set_action_and_target_value: set_action_and_target_value].}
{.deprecated: [g_menu_item_set_action_and_target: set_action_and_target].}
{.deprecated: [g_menu_item_set_detailed_action: set_detailed_action].}
{.deprecated: [g_menu_item_set_icon: set_icon].}
{.deprecated: [g_dbus_connection_export_menu_model: export_menu_model].}
{.deprecated: [g_dbus_connection_unexport_menu_model: unexport_menu_model].}
{.deprecated: [g_notification_set_title: set_title].}
{.deprecated: [g_notification_set_body: set_body].}
{.deprecated: [g_notification_set_icon: set_icon].}
{.deprecated: [g_notification_set_urgent: set_urgent].}
{.deprecated: [g_notification_set_priority: set_priority].}
{.deprecated: [g_notification_add_button: add_button].}
{.deprecated: [g_notification_add_button_with_target: add_button_with_target].}
{.deprecated: [g_notification_add_button_with_target_value: add_button_with_target_value].}
{.deprecated: [g_notification_set_default_action: set_default_action].}
{.deprecated: [g_notification_set_default_action_and_target: set_default_action_and_target].}
{.deprecated: [g_notification_set_default_action_and_target_value: set_default_action_and_target_value].}
{.deprecated: [g_list_model_get_item_type: get_item_type].}
{.deprecated: [g_list_model_get_n_items: get_n_items].}
{.deprecated: [g_list_model_get_item: get_item].}
{.deprecated: [g_list_model_get_object: get_object].}
{.deprecated: [g_list_model_items_changed: items_changed].}
{.deprecated: [g_list_store_insert: insert].}
{.deprecated: [g_list_store_insert_sorted: insert_sorted].}
{.deprecated: [g_list_store_append: append].}
{.deprecated: [g_list_store_remove: remove].}
{.deprecated: [g_list_store_remove_all: remove_all].}
{.deprecated: [g_list_store_splice: splice].}
