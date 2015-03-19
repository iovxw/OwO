{.deadCodeElim: on.}

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

from glib import gint, gint8, gint16, gint32, gint64, guint, guint8, guint16, guint32, guint64, gulong, gshort, gchar, guchar, gdouble,
  gunichar, gboolean, gpointer, gconstpointer, GFALSE, GTRUE, G_PRIORITY_DEFAULT, G_PRIORITY_HIGH_IDLE, GDestroyNotify, GQuark, GSourceFunc

from gobject import GObject, GType, GValue, GCallback, GObjectClassObj

from gio import GIcon#, GOutputStream 

from gdk_pixbuf import GdkPixbuf

from cairo import Context, Font_options

from pango import LayoutLine, Layout, Context, Direction

#type # missing objects
#  DisplayManagerClass = object

const
  MULTIDEVICE_SAFE = true
  ENABLE_NLS = false
  #INSIDE_GDK_WIN32 = false

const 
  KEY_VoidSymbol* = 0xFFFFFF
  KEY_BackSpace* = 0xFF08
  KEY_Tab* = 0xFF09
  KEY_Linefeed* = 0xFF0A
  KEY_Clear* = 0xFF0B
  KEY_Return* = 0xFF0D
  KEY_Pause* = 0xFF13
  KEY_Scroll_Lock* = 0xFF14
  KEY_Sys_Req* = 0xFF15
  KEY_Escape* = 0xFF1B
  KEY_Delete* = 0xFFFF
  KEY_Multi_key* = 0xFF20
  KEY_Codeinput* = 0xFF37
  KEY_SingleCandidate* = 0xFF3C
  KEY_MultipleCandidate* = 0xFF3D
  KEY_PreviousCandidate* = 0xFF3E
  KEY_Kanji* = 0xFF21
  KEY_Muhenkan* = 0xFF22
  KEY_Henkan_Mode* = 0xFF23
  KEY_Henkan* = 0xFF23
  KEY_Romaji* = 0xFF24
  KEY_Hiragana* = 0xFF25
  KEY_Katakana* = 0xFF26
  KEY_Hiragana_Katakana* = 0xFF27
  KEY_Zenkaku* = 0xFF28
  KEY_Hankaku* = 0xFF29
  KEY_Zenkaku_Hankaku* = 0xFF2A
  KEY_Touroku* = 0xFF2B
  KEY_Massyo* = 0xFF2C
  KEY_Kana_Lock* = 0xFF2D
  KEY_Kana_Shift* = 0xFF2E
  KEY_Eisu_Shift* = 0xFF2F
  KEY_Eisu_toggle* = 0xFF30
  KEY_Kanji_Bangou* = 0xFF37
  KEY_Zen_Koho* = 0xFF3D
  KEY_Mae_Koho* = 0xFF3E
  KEY_Home* = 0xFF50
  KEY_Left* = 0xFF51
  KEY_Up* = 0xFF52
  KEY_Right* = 0xFF53
  KEY_Down* = 0xFF54
  KEY_Prior* = 0xFF55
  KEY_Page_Up* = 0xFF55
  KEY_Next* = 0xFF56
  KEY_Page_Down* = 0xFF56
  KEY_End* = 0xFF57
  KEY_Begin* = 0xFF58
  KEY_Select* = 0xFF60
  KEY_Print* = 0xFF61
  KEY_Execute* = 0xFF62
  KEY_Insert* = 0xFF63
  KEY_Undo* = 0xFF65
  KEY_Redo* = 0xFF66
  KEY_Menu* = 0xFF67
  KEY_Find* = 0xFF68
  KEY_Cancel* = 0xFF69
  KEY_Help* = 0xFF6A
  KEY_Break* = 0xFF6B
  KEY_Mode_switch* = 0xFF7E
  KEY_script_switch* = 0xFF7E
  KEY_Num_Lock* = 0xFF7F
  KEY_KP_Space* = 0xFF80
  KEY_KP_Tab* = 0xFF89
  KEY_KP_Enter* = 0xFF8D
  KEY_KP_F1* = 0xFF91
  KEY_KP_F2* = 0xFF92
  KEY_KP_F3* = 0xFF93
  KEY_KP_F4* = 0xFF94
  KEY_KP_Home* = 0xFF95
  KEY_KP_Left* = 0xFF96
  KEY_KP_Up* = 0xFF97
  KEY_KP_Right* = 0xFF98
  KEY_KP_Down* = 0xFF99
  KEY_KP_Prior* = 0xFF9A
  KEY_KP_Page_Up* = 0xFF9A
  KEY_KP_Next* = 0xFF9B
  KEY_KP_Page_Down* = 0xFF9B
  KEY_KP_End* = 0xFF9C
  KEY_KP_Begin* = 0xFF9D
  KEY_KP_Insert* = 0xFF9E
  KEY_KP_Delete* = 0xFF9F
  KEY_KP_Equal* = 0xFFBD
  KEY_KP_Multiply* = 0xFFAA
  KEY_KP_Add* = 0xFFAB
  KEY_KP_Separator* = 0xFFAC
  KEY_KP_Subtract* = 0xFFAD
  KEY_KP_Decimal* = 0xFFAE
  KEY_KP_Divide* = 0xFFAF
  KEY_KP_0* = 0xFFB0
  KEY_KP_1* = 0xFFB1
  KEY_KP_2* = 0xFFB2
  KEY_KP_3* = 0xFFB3
  KEY_KP_4* = 0xFFB4
  KEY_KP_5* = 0xFFB5
  KEY_KP_6* = 0xFFB6
  KEY_KP_7* = 0xFFB7
  KEY_KP_8* = 0xFFB8
  KEY_KP_9* = 0xFFB9
  KEY_F1* = 0xFFBE
  KEY_F2* = 0xFFBF
  KEY_F3* = 0xFFC0
  KEY_F4* = 0xFFC1
  KEY_F5* = 0xFFC2
  KEY_F6* = 0xFFC3
  KEY_F7* = 0xFFC4
  KEY_F8* = 0xFFC5
  KEY_F9* = 0xFFC6
  KEY_F10* = 0xFFC7
  KEY_F11* = 0xFFC8
  KEY_L1* = 0xFFC8
  KEY_F12* = 0xFFC9
  KEY_L2* = 0xFFC9
  KEY_F13* = 0xFFCA
  KEY_L3* = 0xFFCA
  KEY_F14* = 0xFFCB
  KEY_L4* = 0xFFCB
  KEY_F15* = 0xFFCC
  KEY_L5* = 0xFFCC
  KEY_F16* = 0xFFCD
  KEY_L6* = 0xFFCD
  KEY_F17* = 0xFFCE
  KEY_L7* = 0xFFCE
  KEY_F18* = 0xFFCF
  KEY_L8* = 0xFFCF
  KEY_F19* = 0xFFD0
  KEY_L9* = 0xFFD0
  KEY_F20* = 0xFFD1
  KEY_L10* = 0xFFD1
  KEY_F21* = 0xFFD2
  KEY_R1* = 0xFFD2
  KEY_F22* = 0xFFD3
  KEY_R2* = 0xFFD3
  KEY_F23* = 0xFFD4
  KEY_R3* = 0xFFD4
  KEY_F24* = 0xFFD5
  KEY_R4* = 0xFFD5
  KEY_F25* = 0xFFD6
  KEY_R5* = 0xFFD6
  KEY_F26* = 0xFFD7
  KEY_R6* = 0xFFD7
  KEY_F27* = 0xFFD8
  KEY_R7* = 0xFFD8
  KEY_F28* = 0xFFD9
  KEY_R8* = 0xFFD9
  KEY_F29* = 0xFFDA
  KEY_R9* = 0xFFDA
  KEY_F30* = 0xFFDB
  KEY_R10* = 0xFFDB
  KEY_F31* = 0xFFDC
  KEY_R11* = 0xFFDC
  KEY_F32* = 0xFFDD
  KEY_R12* = 0xFFDD
  KEY_F33* = 0xFFDE
  KEY_R13* = 0xFFDE
  KEY_F34* = 0xFFDF
  KEY_R14* = 0xFFDF
  KEY_F35* = 0xFFE0
  KEY_R15* = 0xFFE0
  KEY_Shift_L* = 0xFFE1
  KEY_Shift_R* = 0xFFE2
  KEY_Control_L* = 0xFFE3
  KEY_Control_R* = 0xFFE4
  KEY_Caps_Lock* = 0xFFE5
  KEY_Shift_Lock* = 0xFFE6
  KEY_Meta_L* = 0xFFE7
  KEY_Meta_R* = 0xFFE8
  KEY_Alt_L* = 0xFFE9
  KEY_Alt_R* = 0xFFEA
  KEY_Super_L* = 0xFFEB
  KEY_Super_R* = 0xFFEC
  KEY_Hyper_L* = 0xFFED
  KEY_Hyper_R* = 0xFFEE
  KEY_ISO_Lock* = 0xFE01
  KEY_ISO_Level2_Latch* = 0xFE02
  KEY_ISO_Level3_Shift* = 0xFE03
  KEY_ISO_Level3_Latch* = 0xFE04
  KEY_ISO_Level3_Lock* = 0xFE05
  KEY_ISO_Level5_Shift* = 0xFE11
  KEY_ISO_Level5_Latch* = 0xFE12
  KEY_ISO_Level5_Lock* = 0xFE13
  KEY_ISO_Group_Shift* = 0xFF7E
  KEY_ISO_Group_Latch* = 0xFE06
  KEY_ISO_Group_Lock* = 0xFE07
  KEY_ISO_Next_Group* = 0xFE08
  KEY_ISO_Next_Group_Lock* = 0xFE09
  KEY_ISO_Prev_Group* = 0xFE0A
  KEY_ISO_Prev_Group_Lock* = 0xFE0B
  KEY_ISO_First_Group* = 0xFE0C
  KEY_ISO_First_Group_Lock* = 0xFE0D
  KEY_ISO_Last_Group* = 0xFE0E
  KEY_ISO_Last_Group_Lock* = 0xFE0F
  KEY_ISO_Left_Tab* = 0xFE20
  KEY_ISO_Move_Line_Up* = 0xFE21
  KEY_ISO_Move_Line_Down* = 0xFE22
  KEY_ISO_Partial_Line_Up* = 0xFE23
  KEY_ISO_Partial_Line_Down* = 0xFE24
  KEY_ISO_Partial_Space_Left* = 0xFE25
  KEY_ISO_Partial_Space_Right* = 0xFE26
  KEY_ISO_Set_Margin_Left* = 0xFE27
  KEY_ISO_Set_Margin_Right* = 0xFE28
  KEY_ISO_Release_Margin_Left* = 0xFE29
  KEY_ISO_Release_Margin_Right* = 0xFE2A
  KEY_ISO_Release_Both_Margins* = 0xFE2B
  KEY_ISO_Fast_Cursor_Left* = 0xFE2C
  KEY_ISO_Fast_Cursor_Right* = 0xFE2D
  KEY_ISO_Fast_Cursor_Up* = 0xFE2E
  KEY_ISO_Fast_Cursor_Down* = 0xFE2F
  KEY_ISO_Continuous_Underline* = 0xFE30
  KEY_ISO_Discontinuous_Underline* = 0xFE31
  KEY_ISO_Emphasize* = 0xFE32
  KEY_ISO_Center_Object* = 0xFE33
  KEY_ISO_Enter* = 0xFE34
  KEY_dead_grave* = 0xFE50
  KEY_dead_acute* = 0xFE51
  KEY_dead_circumflex* = 0xFE52
  KEY_dead_tilde* = 0xFE53
  KEY_dead_perispomeni* = 0xFE53
  KEY_dead_macron* = 0xFE54
  KEY_dead_breve* = 0xFE55
  KEY_dead_abovedot* = 0xFE56
  KEY_dead_diaeresis* = 0xFE57
  KEY_dead_abovering* = 0xFE58
  KEY_dead_doubleacute* = 0xFE59
  KEY_dead_caron* = 0xFE5A
  KEY_dead_cedilla* = 0xFE5B
  KEY_dead_ogonek* = 0xFE5C
  KEY_dead_iota* = 0xFE5D
  KEY_dead_voiced_sound* = 0xFE5E
  KEY_dead_semivoiced_sound* = 0xFE5F
  KEY_dead_belowdot* = 0xFE60
  KEY_dead_hook* = 0xFE61
  KEY_dead_horn* = 0xFE62
  KEY_dead_stroke* = 0xFE63
  KEY_dead_abovecomma* = 0xFE64
  KEY_dead_psili* = 0xFE64
  KEY_dead_abovereversedcomma* = 0xFE65
  KEY_dead_dasia* = 0xFE65
  KEY_dead_doublegrave* = 0xFE66
  KEY_dead_belowring* = 0xFE67
  KEY_dead_belowmacron* = 0xFE68
  KEY_dead_belowcircumflex* = 0xFE69
  KEY_dead_belowtilde* = 0xFE6A
  KEY_dead_belowbreve* = 0xFE6B
  KEY_dead_belowdiaeresis* = 0xFE6C
  KEY_dead_invertedbreve* = 0xFE6D
  KEY_dead_belowcomma* = 0xFE6E
  KEY_dead_currency* = 0xFE6F
  KEY_dead_a* = 0xFE80
  KEY_CAPITAL_dead_A* = 0xFE81
  KEY_dead_e* = 0xFE82
  KEY_CAPITAL_dead_E* = 0xFE83
  KEY_dead_i* = 0xFE84
  KEY_CAPITAL_dead_I* = 0xFE85
  KEY_dead_o* = 0xFE86
  KEY_CAPITAL_dead_O* = 0xFE87
  KEY_dead_u* = 0xFE88
  KEY_CAPITAL_dead_U* = 0xFE89
  KEY_dead_small_schwa* = 0xFE8A
  KEY_dead_capital_schwa* = 0xFE8B
  KEY_dead_greek* = 0xFE8C
  KEY_First_Virtual_Screen* = 0xFED0
  KEY_Prev_Virtual_Screen* = 0xFED1
  KEY_Next_Virtual_Screen* = 0xFED2
  KEY_Last_Virtual_Screen* = 0xFED4
  KEY_Terminate_Server* = 0xFED5
  KEY_AccessX_Enable* = 0xFE70
  KEY_AccessX_Feedback_Enable* = 0xFE71
  KEY_RepeatKeys_Enable* = 0xFE72
  KEY_SlowKeys_Enable* = 0xFE73
  KEY_BounceKeys_Enable* = 0xFE74
  KEY_StickyKeys_Enable* = 0xFE75
  KEY_MouseKeys_Enable* = 0xFE76
  KEY_MouseKeys_Accel_Enable* = 0xFE77
  KEY_Overlay1_Enable* = 0xFE78
  KEY_Overlay2_Enable* = 0xFE79
  KEY_AudibleBell_Enable* = 0xFE7A
  KEY_Pointer_Left* = 0xFEE0
  KEY_Pointer_Right* = 0xFEE1
  KEY_Pointer_Up* = 0xFEE2
  KEY_Pointer_Down* = 0xFEE3
  KEY_Pointer_UpLeft* = 0xFEE4
  KEY_Pointer_UpRight* = 0xFEE5
  KEY_Pointer_DownLeft* = 0xFEE6
  KEY_Pointer_DownRight* = 0xFEE7
  KEY_Pointer_Button_Dflt* = 0xFEE8
  KEY_Pointer_Button1* = 0xFEE9
  KEY_Pointer_Button2* = 0xFEEA
  KEY_Pointer_Button3* = 0xFEEB
  KEY_Pointer_Button4* = 0xFEEC
  KEY_Pointer_Button5* = 0xFEED
  KEY_Pointer_DblClick_Dflt* = 0xFEEE
  KEY_Pointer_DblClick1* = 0xFEEF
  KEY_Pointer_DblClick2* = 0xFEF0
  KEY_Pointer_DblClick3* = 0xFEF1
  KEY_Pointer_DblClick4* = 0xFEF2
  KEY_Pointer_DblClick5* = 0xFEF3
  KEY_Pointer_Drag_Dflt* = 0xFEF4
  KEY_Pointer_Drag1* = 0xFEF5
  KEY_Pointer_Drag2* = 0xFEF6
  KEY_Pointer_Drag3* = 0xFEF7
  KEY_Pointer_Drag4* = 0xFEF8
  KEY_Pointer_Drag5* = 0xFEFD
  KEY_Pointer_EnableKeys* = 0xFEF9
  KEY_Pointer_Accelerate* = 0xFEFA
  KEY_Pointer_DfltBtnNext* = 0xFEFB
  KEY_Pointer_DfltBtnPrev* = 0xFEFC
  KEY_ch* = 0xFEA0
  KEY_CAPITAL_C_h* = 0xFEA1
  KEY_CAPITAL_C_CAPITAL_H* = 0xFEA2
  KEY_c_UNDERSCORE_h* = 0xFEA3
  KEY_CAPITAL_C_UNDERSCORE_h* = 0xFEA4
  KEY_CAPITAL_C_UNDERSCORE_CAPITAL_H* = 0xFEA5
  KEY_3270_Duplicate* = 0xFD01
  KEY_3270_FieldMark* = 0xFD02
  KEY_3270_Right2* = 0xFD03
  KEY_3270_Left2* = 0xFD04
  KEY_3270_BackTab* = 0xFD05
  KEY_3270_EraseEOF* = 0xFD06
  KEY_3270_EraseInput* = 0xFD07
  KEY_3270_Reset* = 0xFD08
  KEY_3270_Quit* = 0xFD09
  KEY_3270_PA1* = 0xFD0A
  KEY_3270_PA2* = 0xFD0B
  KEY_3270_PA3* = 0xFD0C
  KEY_3270_Test* = 0xFD0D
  KEY_3270_Attn* = 0xFD0E
  KEY_3270_CursorBlink* = 0xFD0F
  KEY_3270_AltCursor* = 0xFD10
  KEY_3270_KeyClick* = 0xFD11
  KEY_3270_Jump* = 0xFD12
  KEY_3270_Ident* = 0xFD13
  KEY_3270_Rule* = 0xFD14
  KEY_3270_Copy* = 0xFD15
  KEY_3270_Play* = 0xFD16
  KEY_3270_Setup* = 0xFD17
  KEY_3270_Record* = 0xFD18
  KEY_3270_ChangeScreen* = 0xFD19
  KEY_3270_DeleteWord* = 0xFD1A
  KEY_3270_ExSelect* = 0xFD1B
  KEY_3270_CursorSelect* = 0xFD1C
  KEY_3270_PrintScreen* = 0xFD1D
  KEY_3270_Enter* = 0xFD1E
  KEY_space* = 0x20
  KEY_exclam* = 0x21
  KEY_quotedbl* = 0x22
  KEY_numbersign* = 0x23
  KEY_dollar* = 0x24
  KEY_percent* = 0x25
  KEY_ampersand* = 0x26
  KEY_apostrophe* = 0x27
  KEY_quoteright* = 0x27
  KEY_parenleft* = 0x28
  KEY_parenright* = 0x29
  KEY_asterisk* = 0x2A
  KEY_plus* = 0x2B
  KEY_comma* = 0x2C
  KEY_minus* = 0x2D
  KEY_period* = 0x2E
  KEY_slash* = 0x2F
  KEY_0* = 0x30
  KEY_1* = 0x31
  KEY_2* = 0x32
  KEY_3* = 0x33
  KEY_4* = 0x34
  KEY_5* = 0x35
  KEY_6* = 0x36
  KEY_7* = 0x37
  KEY_8* = 0x38
  KEY_9* = 0x39
  KEY_colon* = 0x3A
  KEY_semicolon* = 0x3B
  KEY_less* = 0x3C
  KEY_equal* = 0x3D
  KEY_greater* = 0x3E
  KEY_question* = 0x3F
  KEY_at* = 0x40
  KEY_CAPITAL_A* = 0x41
  KEY_CAPITAL_B* = 0x42
  KEY_CAPITAL_C* = 0x43
  KEY_CAPITAL_D* = 0x44
  KEY_CAPITAL_E* = 0x45
  KEY_CAPITAL_F* = 0x46
  KEY_CAPITAL_G* = 0x47
  KEY_CAPITAL_H* = 0x48
  KEY_CAPITAL_I* = 0x49
  KEY_CAPITAL_J* = 0x4A
  KEY_CAPITAL_K* = 0x4B
  KEY_CAPITAL_L* = 0x4C
  KEY_CAPITAL_M* = 0x4D
  KEY_CAPITAL_N* = 0x4E
  KEY_CAPITAL_O* = 0x4F
  KEY_CAPITAL_P* = 0x50
  KEY_CAPITAL_Q* = 0x51
  KEY_CAPITAL_R* = 0x52
  KEY_CAPITAL_S* = 0x53
  KEY_CAPITAL_T* = 0x54
  KEY_CAPITAL_U* = 0x55
  KEY_CAPITAL_V* = 0x56
  KEY_CAPITAL_W* = 0x57
  KEY_CAPITAL_X* = 0x58
  KEY_CAPITAL_Y* = 0x59
  KEY_CAPITAL_Z* = 0x5A
  KEY_bracketleft* = 0x5B
  KEY_backslash* = 0x5C
  KEY_bracketright* = 0x5D
  KEY_asciicircum* = 0x5E
  KEY_underscore* = 0x5F
  KEY_grave* = 0x60
  KEY_quoteleft* = 0x60
  KEY_a* = 0x61
  KEY_b* = 0x62
  KEY_c* = 0x63
  KEY_d* = 0x64
  KEY_e* = 0x65
  KEY_f* = 0x66
  KEY_g* = 0x67
  KEY_h* = 0x68
  KEY_i* = 0x69
  KEY_j* = 0x6A
  KEY_k* = 0x6B
  KEY_l* = 0x6C
  KEY_m* = 0x6D
  KEY_n* = 0x6E
  KEY_o* = 0x6F
  KEY_p* = 0x70
  KEY_q* = 0x71
  KEY_r* = 0x72
  KEY_s* = 0x73
  KEY_t* = 0x74
  KEY_u* = 0x75
  KEY_v* = 0x76
  KEY_w* = 0x77
  KEY_x* = 0x78
  KEY_y* = 0x79
  KEY_z* = 0x7A
  KEY_braceleft* = 0x7B
  KEY_bar* = 0x7C
  KEY_braceright* = 0x7D
  KEY_asciitilde* = 0x7E
  KEY_nobreakspace* = 0xA0
  KEY_exclamdown* = 0xA1
  KEY_cent* = 0xA2
  KEY_sterling* = 0xA3
  KEY_currency* = 0xA4
  KEY_yen* = 0xA5
  KEY_brokenbar* = 0xA6
  KEY_section* = 0xA7
  KEY_diaeresis* = 0xA8
  KEY_copyright* = 0xA9
  KEY_ordfeminine* = 0xAA
  KEY_guillemotleft* = 0xAB
  KEY_notsign* = 0xAC
  KEY_hyphen* = 0xAD
  KEY_registered* = 0xAE
  KEY_macron* = 0xAF
  KEY_degree* = 0xB0
  KEY_plusminus* = 0xB1
  KEY_twosuperior* = 0xB2
  KEY_threesuperior* = 0xB3
  KEY_acute* = 0xB4
  KEY_mu* = 0xB5
  KEY_paragraph* = 0xB6
  KEY_periodcentered* = 0xB7
  KEY_cedilla* = 0xB8
  KEY_onesuperior* = 0xB9
  KEY_masculine* = 0xBA
  KEY_guillemotright* = 0xBB
  KEY_onequarter* = 0xBC
  KEY_onehalf* = 0xBD
  KEY_threequarters* = 0xBE
  KEY_questiondown* = 0xBF
  KEY_CAPITAL_Agrave* = 0xC0
  KEY_CAPITAL_Aacute* = 0xC1
  KEY_CAPITAL_Acircumflex* = 0xC2
  KEY_CAPITAL_Atilde* = 0xC3
  KEY_CAPITAL_Adiaeresis* = 0xC4
  KEY_CAPITAL_Aring* = 0xC5
  KEY_CAPITAL_AE* = 0xC6
  KEY_CAPITAL_Ccedilla* = 0xC7
  KEY_CAPITAL_Egrave* = 0xC8
  KEY_CAPITAL_Eacute* = 0xC9
  KEY_CAPITAL_Ecircumflex* = 0xCA
  KEY_CAPITAL_Ediaeresis* = 0xCB
  KEY_CAPITAL_Igrave* = 0xCC
  KEY_CAPITAL_Iacute* = 0xCD
  KEY_CAPITAL_Icircumflex* = 0xCE
  KEY_CAPITAL_Idiaeresis* = 0xCF
  KEY_CAPITAL_ETH* = 0xD0
  KEY_CAP_Eth* = 0xD0
  KEY_CAPITAL_Ntilde* = 0xD1
  KEY_CAPITAL_Ograve* = 0xD2
  KEY_CAPITAL_Oacute* = 0xD3
  KEY_CAPITAL_Ocircumflex* = 0xD4
  KEY_CAPITAL_Otilde* = 0xD5
  KEY_CAPITAL_Odiaeresis* = 0xD6
  KEY_multiply* = 0xD7
  KEY_CAPITAL_Oslash* = 0xD8
  KEY_CAPITAL_Ooblique* = 0xD8
  KEY_CAPITAL_Ugrave* = 0xD9
  KEY_CAPITAL_Uacute* = 0xDA
  KEY_CAPITAL_Ucircumflex* = 0xDB
  KEY_CAPITAL_Udiaeresis* = 0xDC
  KEY_CAPITAL_Yacute* = 0xDD
  KEY_CAPITAL_THORN* = 0xDE
  KEY_CAP_Thorn* = 0xDE
  KEY_ssharp* = 0xDF
  KEY_agrave* = 0xE0
  KEY_aacute* = 0xE1
  KEY_acircumflex* = 0xE2
  KEY_atilde* = 0xE3
  KEY_adiaeresis* = 0xE4
  KEY_aring* = 0xE5
  KEY_ae* = 0xE6
  KEY_ccedilla* = 0xE7
  KEY_egrave* = 0xE8
  KEY_eacute* = 0xE9
  KEY_ecircumflex* = 0xEA
  KEY_ediaeresis* = 0xEB
  KEY_igrave* = 0xEC
  KEY_iacute* = 0xED
  KEY_icircumflex* = 0xEE
  KEY_idiaeresis* = 0xEF
  KEY_eth* = 0xF0
  KEY_ntilde* = 0xF1
  KEY_ograve* = 0xF2
  KEY_oacute* = 0xF3
  KEY_ocircumflex* = 0xF4
  KEY_otilde* = 0xF5
  KEY_odiaeresis* = 0xF6
  KEY_division* = 0xF7
  KEY_oslash* = 0xF8
  KEY_ooblique* = 0xF8
  KEY_ugrave* = 0xF9
  KEY_uacute* = 0xFA
  KEY_ucircumflex* = 0xFB
  KEY_udiaeresis* = 0xFC
  KEY_yacute* = 0xFD
  KEY_thorn* = 0xFE
  KEY_ydiaeresis* = 0xFF
  KEY_CAPITAL_Aogonek* = 0x1A1
  KEY_breve* = 0x1A2
  KEY_CAPITAL_Lstroke* = 0x1A3
  KEY_CAPITAL_Lcaron* = 0x1A5
  KEY_CAPITAL_Sacute* = 0x1A6
  KEY_CAPITAL_Scaron* = 0x1A9
  KEY_CAPITAL_Scedilla* = 0x1AA
  KEY_CAPITAL_Tcaron* = 0x1AB
  KEY_CAPITAL_Zacute* = 0x1AC
  KEY_CAPITAL_Zcaron* = 0x1AE
  KEY_CAPITAL_Zabovedot* = 0x1AF
  KEY_aogonek* = 0x1B1
  KEY_ogonek* = 0x1B2
  KEY_lstroke* = 0x1B3
  KEY_lcaron* = 0x1B5
  KEY_sacute* = 0x1B6
  KEY_caron* = 0x1B7
  KEY_scaron* = 0x1B9
  KEY_scedilla* = 0x1BA
  KEY_tcaron* = 0x1BB
  KEY_zacute* = 0x1BC
  KEY_doubleacute* = 0x1BD
  KEY_zcaron* = 0x1BE
  KEY_zabovedot* = 0x1BF
  KEY_CAPITAL_Racute* = 0x1C0
  KEY_CAPITAL_Abreve* = 0x1C3
  KEY_CAPITAL_Lacute* = 0x1C5
  KEY_CAPITAL_Cacute* = 0x1C6
  KEY_CAPITAL_Ccaron* = 0x1C8
  KEY_CAPITAL_Eogonek* = 0x1CA
  KEY_CAPITAL_Ecaron* = 0x1CC
  KEY_CAPITAL_Dcaron* = 0x1CF
  KEY_CAPITAL_Dstroke* = 0x1D0
  KEY_CAPITAL_Nacute* = 0x1D1
  KEY_CAPITAL_Ncaron* = 0x1D2
  KEY_CAPITAL_Odoubleacute* = 0x1D5
  KEY_CAPITAL_Rcaron* = 0x1D8
  KEY_CAPITAL_Uring* = 0x1D9
  KEY_CAPITAL_Udoubleacute* = 0x1DB
  KEY_CAPITAL_Tcedilla* = 0x1DE
  KEY_racute* = 0x1E0
  KEY_abreve* = 0x1E3
  KEY_lacute* = 0x1E5
  KEY_cacute* = 0x1E6
  KEY_ccaron* = 0x1E8
  KEY_eogonek* = 0x1EA
  KEY_ecaron* = 0x1EC
  KEY_dcaron* = 0x1EF
  KEY_dstroke* = 0x1F0
  KEY_nacute* = 0x1F1
  KEY_ncaron* = 0x1F2
  KEY_odoubleacute* = 0x1F5
  KEY_rcaron* = 0x1F8
  KEY_uring* = 0x1F9
  KEY_udoubleacute* = 0x1FB
  KEY_tcedilla* = 0x1FE
  KEY_abovedot* = 0x1FF
  KEY_CAPITAL_Hstroke* = 0x2A1
  KEY_CAPITAL_Hcircumflex* = 0x2A6
  KEY_Iabovedot* = 0x2A9
  KEY_CAPITAL_Gbreve* = 0x2AB
  KEY_CAPITAL_Jcircumflex* = 0x2AC
  KEY_hstroke* = 0x2B1
  KEY_hcircumflex* = 0x2B6
  KEY_idotless* = 0x2B9
  KEY_gbreve* = 0x2BB
  KEY_jcircumflex* = 0x2BC
  KEY_CAPITAL_Cabovedot* = 0x2C5
  KEY_CAPITAL_Ccircumflex* = 0x2C6
  KEY_CAPITAL_Gabovedot* = 0x2D5
  KEY_CAPITAL_Gcircumflex* = 0x2D8
  KEY_CAPITAL_Ubreve* = 0x2DD
  KEY_CAPITAL_Scircumflex* = 0x2DE
  KEY_cabovedot* = 0x2E5
  KEY_ccircumflex* = 0x2E6
  KEY_gabovedot* = 0x2F5
  KEY_gcircumflex* = 0x2F8
  KEY_ubreve* = 0x2FD
  KEY_scircumflex* = 0x2FE
  KEY_kra* = 0x3A2
  KEY_kappa* = 0x3A2
  KEY_CAPITAL_Rcedilla* = 0x3A3
  KEY_CAPITAL_Itilde* = 0x3A5
  KEY_CAPITAL_Lcedilla* = 0x3A6
  KEY_CAPITAL_Emacron* = 0x3AA
  KEY_CAPITAL_Gcedilla* = 0x3AB
  KEY_CAPITAL_Tslash* = 0x3AC
  KEY_rcedilla* = 0x3B3
  KEY_itilde* = 0x3B5
  KEY_lcedilla* = 0x3B6
  KEY_emacron* = 0x3BA
  KEY_gcedilla* = 0x3BB
  KEY_tslash* = 0x3BC
  KEY_CAPITAL_ENG* = 0x3BD
  KEY_eng* = 0x3BF
  KEY_CAPITAL_Amacron* = 0x3C0
  KEY_CAPITAL_Iogonek* = 0x3C7
  KEY_CAPITAL_Eabovedot* = 0x3CC
  KEY_CAPITAL_Imacron* = 0x3CF
  KEY_CAPITAL_Ncedilla* = 0x3D1
  KEY_CAPITAL_Omacron* = 0x3D2
  KEY_CAPITAL_Kcedilla* = 0x3D3
  KEY_CAPITAL_Uogonek* = 0x3D9
  KEY_CAPITAL_Utilde* = 0x3DD
  KEY_CAPITAL_Umacron* = 0x3DE
  KEY_amacron* = 0x3E0
  KEY_iogonek* = 0x3E7
  KEY_eabovedot* = 0x3EC
  KEY_imacron* = 0x3EF
  KEY_ncedilla* = 0x3F1
  KEY_omacron* = 0x3F2
  KEY_kcedilla* = 0x3F3
  KEY_uogonek* = 0x3F9
  KEY_utilde* = 0x3FD
  KEY_umacron* = 0x3FE
  KEY_CAPITAL_Wcircumflex* = 0x1000174
  KEY_wcircumflex* = 0x1000175
  KEY_CAPITAL_Ycircumflex* = 0x1000176
  KEY_ycircumflex* = 0x1000177
  KEY_CAPITAL_Babovedot* = 0x1001E02
  KEY_babovedot* = 0x1001E03
  KEY_CAPITAL_Dabovedot* = 0x1001E0A
  KEY_dabovedot* = 0x1001E0B
  KEY_CAPITAL_Fabovedot* = 0x1001E1E
  KEY_fabovedot* = 0x1001E1F
  KEY_CAPITAL_Mabovedot* = 0x1001E40
  KEY_mabovedot* = 0x1001E41
  KEY_CAPITAL_Pabovedot* = 0x1001E56
  KEY_pabovedot* = 0x1001E57
  KEY_CAPITAL_Sabovedot* = 0x1001E60
  KEY_sabovedot* = 0x1001E61
  KEY_CAPITAL_Tabovedot* = 0x1001E6A
  KEY_tabovedot* = 0x1001E6B
  KEY_CAPITAL_Wgrave* = 0x1001E80
  KEY_wgrave* = 0x1001E81
  KEY_CAPITAL_Wacute* = 0x1001E82
  KEY_wacute* = 0x1001E83
  KEY_CAPITAL_Wdiaeresis* = 0x1001E84
  KEY_wdiaeresis* = 0x1001E85
  KEY_CAPITAL_Ygrave* = 0x1001EF2
  KEY_ygrave* = 0x1001EF3
  KEY_CAPITAL_OE* = 0x13BC
  KEY_oe* = 0x13BD
  KEY_CAPITAL_Ydiaeresis* = 0x13BE
  KEY_overline* = 0x47E
  KEY_kana_fullstop* = 0x4A1
  KEY_kana_openingbracket* = 0x4A2
  KEY_kana_closingbracket* = 0x4A3
  KEY_kana_comma* = 0x4A4
  KEY_kana_conjunctive* = 0x4A5
  KEY_kana_middledot* = 0x4A5
  KEY_kana_WO* = 0x4A6
  KEY_kana_a* = 0x4A7
  KEY_kana_i* = 0x4A8
  KEY_kana_u* = 0x4A9
  KEY_kana_e* = 0x4AA
  KEY_kana_o* = 0x4AB
  KEY_kana_ya* = 0x4AC
  KEY_kana_yu* = 0x4AD
  KEY_kana_yo* = 0x4AE
  KEY_kana_tsu* = 0x4AF
  KEY_kana_tu* = 0x4AF
  KEY_prolongedsound* = 0x4B0
  KEY_CAPITAL_kana_A* = 0x4B1
  KEY_CAPITAL_kana_I* = 0x4B2
  KEY_CAPITAL_kana_U* = 0x4B3
  KEY_CAPITAL_kana_E* = 0x4B4
  KEY_CAPITAL_kana_O* = 0x4B5
  KEY_kana_KA* = 0x4B6
  KEY_kana_KI* = 0x4B7
  KEY_kana_KU* = 0x4B8
  KEY_kana_KE* = 0x4B9
  KEY_kana_KO* = 0x4BA
  KEY_kana_SA* = 0x4BB
  KEY_kana_SHI* = 0x4BC
  KEY_kana_SU* = 0x4BD
  KEY_kana_SE* = 0x4BE
  KEY_kana_SO* = 0x4BF
  KEY_kana_TA* = 0x4C0
  KEY_kana_CHI* = 0x4C1
  KEY_kana_TI* = 0x4C1
  KEY_CAPITAL_kana_TSU* = 0x4C2
  KEY_CAPITAL_kana_TU* = 0x4C2
  KEY_kana_TE* = 0x4C3
  KEY_kana_TO* = 0x4C4
  KEY_kana_NA* = 0x4C5
  KEY_kana_NI* = 0x4C6
  KEY_kana_NU* = 0x4C7
  KEY_kana_NE* = 0x4C8
  KEY_kana_NO* = 0x4C9
  KEY_kana_HA* = 0x4CA
  KEY_kana_HI* = 0x4CB
  KEY_kana_FU* = 0x4CC
  KEY_kana_HU* = 0x4CC
  KEY_kana_HE* = 0x4CD
  KEY_kana_HO* = 0x4CE
  KEY_kana_MA* = 0x4CF
  KEY_kana_MI* = 0x4D0
  KEY_kana_MU* = 0x4D1
  KEY_kana_ME* = 0x4D2
  KEY_kana_MO* = 0x4D3
  KEY_CAPITAL_kana_YA* = 0x4D4
  KEY_CAPITAL_kana_YU* = 0x4D5
  KEY_CAPITAL_kana_YO* = 0x4D6
  KEY_kana_RA* = 0x4D7
  KEY_kana_RI* = 0x4D8
  KEY_kana_RU* = 0x4D9
  KEY_kana_RE* = 0x4DA
  KEY_kana_RO* = 0x4DB
  KEY_kana_WA* = 0x4DC
  KEY_kana_N* = 0x4DD
  KEY_voicedsound* = 0x4DE
  KEY_semivoicedsound* = 0x4DF
  KEY_kana_switch* = 0xFF7E
  KEY_Farsi_0* = 0x10006F0
  KEY_Farsi_1* = 0x10006F1
  KEY_Farsi_2* = 0x10006F2
  KEY_Farsi_3* = 0x10006F3
  KEY_Farsi_4* = 0x10006F4
  KEY_Farsi_5* = 0x10006F5
  KEY_Farsi_6* = 0x10006F6
  KEY_Farsi_7* = 0x10006F7
  KEY_Farsi_8* = 0x10006F8
  KEY_Farsi_9* = 0x10006F9
  KEY_Arabic_percent* = 0x100066A
  KEY_Arabic_superscript_alef* = 0x1000670
  KEY_Arabic_tteh* = 0x1000679
  KEY_Arabic_peh* = 0x100067E
  KEY_Arabic_tcheh* = 0x1000686
  KEY_Arabic_ddal* = 0x1000688
  KEY_Arabic_rreh* = 0x1000691
  KEY_Arabic_comma* = 0x5AC
  KEY_Arabic_fullstop* = 0x10006D4
  KEY_Arabic_0* = 0x1000660
  KEY_Arabic_1* = 0x1000661
  KEY_Arabic_2* = 0x1000662
  KEY_Arabic_3* = 0x1000663
  KEY_Arabic_4* = 0x1000664
  KEY_Arabic_5* = 0x1000665
  KEY_Arabic_6* = 0x1000666
  KEY_Arabic_7* = 0x1000667
  KEY_Arabic_8* = 0x1000668
  KEY_Arabic_9* = 0x1000669
  KEY_Arabic_semicolon* = 0x5BB
  KEY_Arabic_question_mark* = 0x5BF
  KEY_Arabic_hamza* = 0x5C1
  KEY_Arabic_maddaonalef* = 0x5C2
  KEY_Arabic_hamzaonalef* = 0x5C3
  KEY_Arabic_hamzaonwaw* = 0x5C4
  KEY_Arabic_hamzaunderalef* = 0x5C5
  KEY_Arabic_hamzaonyeh* = 0x5C6
  KEY_Arabic_alef* = 0x5C7
  KEY_Arabic_beh* = 0x5C8
  KEY_Arabic_tehmarbuta* = 0x5C9
  KEY_Arabic_teh* = 0x5CA
  KEY_Arabic_theh* = 0x5CB
  KEY_Arabic_jeem* = 0x5CC
  KEY_Arabic_hah* = 0x5CD
  KEY_Arabic_khah* = 0x5CE
  KEY_Arabic_dal* = 0x5CF
  KEY_Arabic_thal* = 0x5D0
  KEY_Arabic_ra* = 0x5D1
  KEY_Arabic_zain* = 0x5D2
  KEY_Arabic_seen* = 0x5D3
  KEY_Arabic_sheen* = 0x5D4
  KEY_Arabic_sad* = 0x5D5
  KEY_Arabic_dad* = 0x5D6
  KEY_Arabic_tah* = 0x5D7
  KEY_Arabic_zah* = 0x5D8
  KEY_Arabic_ain* = 0x5D9
  KEY_Arabic_ghain* = 0x5DA
  KEY_Arabic_tatweel* = 0x5E0
  KEY_Arabic_feh* = 0x5E1
  KEY_Arabic_qaf* = 0x5E2
  KEY_Arabic_kaf* = 0x5E3
  KEY_Arabic_lam* = 0x5E4
  KEY_Arabic_meem* = 0x5E5
  KEY_Arabic_noon* = 0x5E6
  KEY_Arabic_ha* = 0x5E7
  KEY_Arabic_heh* = 0x5E7
  KEY_Arabic_waw* = 0x5E8
  KEY_Arabic_alefmaksura* = 0x5E9
  KEY_Arabic_yeh* = 0x5EA
  KEY_Arabic_fathatan* = 0x5EB
  KEY_Arabic_dammatan* = 0x5EC
  KEY_Arabic_kasratan* = 0x5ED
  KEY_Arabic_fatha* = 0x5EE
  KEY_Arabic_damma* = 0x5EF
  KEY_Arabic_kasra* = 0x5F0
  KEY_Arabic_shadda* = 0x5F1
  KEY_Arabic_sukun* = 0x5F2
  KEY_Arabic_madda_above* = 0x1000653
  KEY_Arabic_hamza_above* = 0x1000654
  KEY_Arabic_hamza_below* = 0x1000655
  KEY_Arabic_jeh* = 0x1000698
  KEY_Arabic_veh* = 0x10006A4
  KEY_Arabic_keheh* = 0x10006A9
  KEY_Arabic_gaf* = 0x10006AF
  KEY_Arabic_noon_ghunna* = 0x10006BA
  KEY_Arabic_heh_doachashmee* = 0x10006BE
  KEY_Farsi_yeh* = 0x10006CC
  KEY_Arabic_farsi_yeh* = 0x10006CC
  KEY_Arabic_yeh_baree* = 0x10006D2
  KEY_Arabic_heh_goal* = 0x10006C1
  KEY_Arabic_switch* = 0xFF7E
  KEY_CAPITAL_Cyrillic_GHE_bar* = 0x1000492
  KEY_Cyrillic_ghe_bar* = 0x1000493
  KEY_CAPITAL_Cyrillic_ZHE_descender* = 0x1000496
  KEY_Cyrillic_zhe_descender* = 0x1000497
  KEY_CAPITAL_Cyrillic_KA_descender* = 0x100049A
  KEY_Cyrillic_ka_descender* = 0x100049B
  KEY_CAPITAL_Cyrillic_KA_vertstroke* = 0x100049C
  KEY_Cyrillic_ka_vertstroke* = 0x100049D
  KEY_CAPITAL_Cyrillic_EN_descender* = 0x10004A2
  KEY_Cyrillic_en_descender* = 0x10004A3
  KEY_CAPITAL_Cyrillic_U_straight* = 0x10004AE
  KEY_Cyrillic_u_straight* = 0x10004AF
  KEY_CAPITAL_Cyrillic_U_straight_bar* = 0x10004B0
  KEY_Cyrillic_u_straight_bar* = 0x10004B1
  KEY_CAPITAL_Cyrillic_HA_descender* = 0x10004B2
  KEY_Cyrillic_ha_descender* = 0x10004B3
  KEY_CAPITAL_Cyrillic_CHE_descender* = 0x10004B6
  KEY_Cyrillic_che_descender* = 0x10004B7
  KEY_CAPITAL_Cyrillic_CHE_vertstroke* = 0x10004B8
  KEY_Cyrillic_che_vertstroke* = 0x10004B9
  KEY_CAPITAL_Cyrillic_SHHA* = 0x10004BA
  KEY_Cyrillic_shha* = 0x10004BB
  KEY_CAPITAL_Cyrillic_SCHWA* = 0x10004D8
  KEY_Cyrillic_schwa* = 0x10004D9
  KEY_CAPITAL_Cyrillic_I_macron* = 0x10004E2
  KEY_Cyrillic_i_macron* = 0x10004E3
  KEY_CAPITAL_Cyrillic_O_bar* = 0x10004E8
  KEY_Cyrillic_o_bar* = 0x10004E9
  KEY_CAPITAL_Cyrillic_U_macron* = 0x10004EE
  KEY_Cyrillic_u_macron* = 0x10004EF
  KEY_Serbian_dje* = 0x6A1
  KEY_Macedonia_gje* = 0x6A2
  KEY_Cyrillic_io* = 0x6A3
  KEY_Ukrainian_ie* = 0x6A4
  KEY_Ukranian_je* = 0x6A4
  KEY_Macedonia_dse* = 0x6A5
  KEY_Ukrainian_i* = 0x6A6
  KEY_Ukranian_i* = 0x6A6
  KEY_Ukrainian_yi* = 0x6A7
  KEY_Ukranian_yi* = 0x6A7
  KEY_Cyrillic_je* = 0x6A8
  KEY_Serbian_je* = 0x6A8
  KEY_Cyrillic_lje* = 0x6A9
  KEY_Serbian_lje* = 0x6A9
  KEY_Cyrillic_nje* = 0x6AA
  KEY_Serbian_nje* = 0x6AA
  KEY_Serbian_tshe* = 0x6AB
  KEY_Macedonia_kje* = 0x6AC
  KEY_Ukrainian_ghe_with_upturn* = 0x6AD
  KEY_Byelorussian_shortu* = 0x6AE
  KEY_Cyrillic_dzhe* = 0x6AF
  KEY_Serbian_dze* = 0x6AF
  KEY_numerosign* = 0x6B0
  KEY_CAPITAL_Serbian_DJE* = 0x6B1
  KEY_CAPITAL_Macedonia_GJE* = 0x6B2
  KEY_CAPITAL_Cyrillic_IO* = 0x6B3
  KEY_CAPITAL_Ukrainian_IE* = 0x6B4
  KEY_CAPITAL_Ukranian_JE* = 0x6B4
  KEY_CAPITAL_Macedonia_DSE* = 0x6B5
  KEY_CAPITAL_Ukrainian_I* = 0x6B6
  KEY_CAPITAL_Ukranian_I* = 0x6B6
  KEY_CAPITAL_Ukrainian_YI* = 0x6B7
  KEY_CAPITAL_Ukranian_YI* = 0x6B7
  KEY_CAPITAL_Cyrillic_JE* = 0x6B8
  KEY_CAPITAL_Serbian_JE* = 0x6B8
  KEY_CAPITAL_Cyrillic_LJE* = 0x6B9
  KEY_CAPITAL_Serbian_LJE* = 0x6B9
  KEY_CAPITAL_Cyrillic_NJE* = 0x6BA
  KEY_CAPITAL_Serbian_NJE* = 0x6BA
  KEY_CAPITAL_Serbian_TSHE* = 0x6BB
  KEY_CAPITAL_Macedonia_KJE* = 0x6BC
  KEY_CAPITAL_Ukrainian_GHE_WITH_UPTURN* = 0x6BD
  KEY_CAPITAL_Byelorussian_SHORTU* = 0x6BE
  KEY_CAPITAL_Cyrillic_DZHE* = 0x6BF
  KEY_CAPITAL_Serbian_DZE* = 0x6BF
  KEY_Cyrillic_yu* = 0x6C0
  KEY_Cyrillic_a* = 0x6C1
  KEY_Cyrillic_be* = 0x6C2
  KEY_Cyrillic_tse* = 0x6C3
  KEY_Cyrillic_de* = 0x6C4
  KEY_Cyrillic_ie* = 0x6C5
  KEY_Cyrillic_ef* = 0x6C6
  KEY_Cyrillic_ghe* = 0x6C7
  KEY_Cyrillic_ha* = 0x6C8
  KEY_Cyrillic_i* = 0x6C9
  KEY_Cyrillic_shorti* = 0x6CA
  KEY_Cyrillic_ka* = 0x6CB
  KEY_Cyrillic_el* = 0x6CC
  KEY_Cyrillic_em* = 0x6CD
  KEY_Cyrillic_en* = 0x6CE
  KEY_Cyrillic_o* = 0x6CF
  KEY_Cyrillic_pe* = 0x6D0
  KEY_Cyrillic_ya* = 0x6D1
  KEY_Cyrillic_er* = 0x6D2
  KEY_Cyrillic_es* = 0x6D3
  KEY_Cyrillic_te* = 0x6D4
  KEY_Cyrillic_u* = 0x6D5
  KEY_Cyrillic_zhe* = 0x6D6
  KEY_Cyrillic_ve* = 0x6D7
  KEY_Cyrillic_softsign* = 0x6D8
  KEY_Cyrillic_yeru* = 0x6D9
  KEY_Cyrillic_ze* = 0x6DA
  KEY_Cyrillic_sha* = 0x6DB
  KEY_Cyrillic_e* = 0x6DC
  KEY_Cyrillic_shcha* = 0x6DD
  KEY_Cyrillic_che* = 0x6DE
  KEY_Cyrillic_hardsign* = 0x6DF
  KEY_CAPITAL_Cyrillic_YU* = 0x6E0
  KEY_CAPITAL_Cyrillic_A* = 0x6E1
  KEY_CAPITAL_Cyrillic_BE* = 0x6E2
  KEY_CAPITAL_Cyrillic_TSE* = 0x6E3
  KEY_CAPITAL_Cyrillic_DE* = 0x6E4
  KEY_CAPITAL_Cyrillic_IE* = 0x6E5
  KEY_CAPITAL_Cyrillic_EF* = 0x6E6
  KEY_CAPITAL_Cyrillic_GHE* = 0x6E7
  KEY_CAPITAL_Cyrillic_HA* = 0x6E8
  KEY_CAPITAL_Cyrillic_I* = 0x6E9
  KEY_CAPITAL_Cyrillic_SHORTI* = 0x6EA
  KEY_CAPITAL_Cyrillic_KA* = 0x6EB
  KEY_CAPITAL_Cyrillic_EL* = 0x6EC
  KEY_CAPITAL_Cyrillic_EM* = 0x6ED
  KEY_CAPITAL_Cyrillic_EN* = 0x6EE
  KEY_CAPITAL_Cyrillic_O* = 0x6EF
  KEY_CAPITAL_Cyrillic_PE* = 0x6F0
  KEY_CAPITAL_Cyrillic_YA* = 0x6F1
  KEY_CAPITAL_Cyrillic_ER* = 0x6F2
  KEY_CAPITAL_Cyrillic_ES* = 0x6F3
  KEY_CAPITAL_Cyrillic_TE* = 0x6F4
  KEY_CAPITAL_Cyrillic_U* = 0x6F5
  KEY_CAPITAL_Cyrillic_ZHE* = 0x6F6
  KEY_CAPITAL_Cyrillic_VE* = 0x6F7
  KEY_CAPITAL_Cyrillic_SOFTSIGN* = 0x6F8
  KEY_CAPITAL_Cyrillic_YERU* = 0x6F9
  KEY_CAPITAL_Cyrillic_ZE* = 0x6FA
  KEY_CAPITAL_Cyrillic_SHA* = 0x6FB
  KEY_CAPITAL_Cyrillic_E* = 0x6FC
  KEY_CAPITAL_Cyrillic_SHCHA* = 0x6FD
  KEY_CAPITAL_Cyrillic_CHE* = 0x6FE
  KEY_CAPITAL_Cyrillic_HARDSIGN* = 0x6FF
  KEY_CAPITAL_Greek_ALPHAaccent* = 0x7A1
  KEY_CAPITAL_Greek_EPSILONaccent* = 0x7A2
  KEY_CAPITAL_Greek_ETAaccent* = 0x7A3
  KEY_CAPITAL_Greek_IOTAaccent* = 0x7A4
  KEY_CAPITAL_Greek_IOTAdieresis* = 0x7A5
  KEY_Greek_IOTAdiaeresis* = 0x7A5
  KEY_CAPITAL_Greek_OMICRONaccent* = 0x7A7
  KEY_CAPITAL_Greek_UPSILONaccent* = 0x7A8
  KEY_CAPITAL_Greek_UPSILONdieresis* = 0x7A9
  KEY_CAPITAL_Greek_OMEGAaccent* = 0x7AB
  KEY_Greek_accentdieresis* = 0x7AE
  KEY_Greek_horizbar* = 0x7AF
  KEY_Greek_alphaaccent* = 0x7B1
  KEY_Greek_epsilonaccent* = 0x7B2
  KEY_Greek_etaaccent* = 0x7B3
  KEY_Greek_iotaaccent* = 0x7B4
  KEY_Greek_iotadieresis* = 0x7B5
  KEY_Greek_iotaaccentdieresis* = 0x7B6
  KEY_Greek_omicronaccent* = 0x7B7
  KEY_Greek_upsilonaccent* = 0x7B8
  KEY_Greek_upsilondieresis* = 0x7B9
  KEY_Greek_upsilonaccentdieresis* = 0x7BA
  KEY_Greek_omegaaccent* = 0x7BB
  KEY_CAPITAL_Greek_ALPHA* = 0x7C1
  KEY_CAPITAL_Greek_BETA* = 0x7C2
  KEY_CAPITAL_Greek_GAMMA* = 0x7C3
  KEY_CAPITAL_Greek_DELTA* = 0x7C4
  KEY_CAPITAL_Greek_EPSILON* = 0x7C5
  KEY_CAPITAL_Greek_ZETA* = 0x7C6
  KEY_CAPITAL_Greek_ETA* = 0x7C7
  KEY_CAPITAL_Greek_THETA* = 0x7C8
  KEY_CAPITAL_Greek_IOTA* = 0x7C9
  KEY_CAPITAL_Greek_KAPPA* = 0x7CA
  KEY_CAPITAL_Greek_LAMDA* = 0x7CB
  KEY_CAPITAL_Greek_LAMBDA* = 0x7CB
  KEY_CAPITAL_Greek_MU* = 0x7CC
  KEY_CAPITAL_Greek_NU* = 0x7CD
  KEY_CAPITAL_Greek_XI* = 0x7CE
  KEY_CAPITAL_Greek_OMICRON* = 0x7CF
  KEY_CAPITAL_Greek_PI* = 0x7D0
  KEY_CAPITAL_Greek_RHO* = 0x7D1
  KEY_CAPITAL_Greek_SIGMA* = 0x7D2
  KEY_CAPITAL_Greek_TAU* = 0x7D4
  KEY_CAPITAL_Greek_UPSILON* = 0x7D5
  KEY_CAPITAL_Greek_PHI* = 0x7D6
  KEY_CAPITAL_Greek_CHI* = 0x7D7
  KEY_CAPITAL_Greek_PSI* = 0x7D8
  KEY_CAPITAL_Greek_OMEGA* = 0x7D9
  KEY_Greek_alpha* = 0x7E1
  KEY_Greek_beta* = 0x7E2
  KEY_Greek_gamma* = 0x7E3
  KEY_Greek_delta* = 0x7E4
  KEY_Greek_epsilon* = 0x7E5
  KEY_Greek_zeta* = 0x7E6
  KEY_Greek_eta* = 0x7E7
  KEY_Greek_theta* = 0x7E8
  KEY_Greek_iota* = 0x7E9
  KEY_Greek_kappa* = 0x7EA
  KEY_Greek_lamda* = 0x7EB
  KEY_Greek_lambda* = 0x7EB
  KEY_Greek_mu* = 0x7EC
  KEY_Greek_nu* = 0x7ED
  KEY_Greek_xi* = 0x7EE
  KEY_Greek_omicron* = 0x7EF
  KEY_Greek_pi* = 0x7F0
  KEY_Greek_rho* = 0x7F1
  KEY_Greek_sigma* = 0x7F2
  KEY_Greek_finalsmallsigma* = 0x7F3
  KEY_Greek_tau* = 0x7F4
  KEY_Greek_upsilon* = 0x7F5
  KEY_Greek_phi* = 0x7F6
  KEY_Greek_chi* = 0x7F7
  KEY_Greek_psi* = 0x7F8
  KEY_Greek_omega* = 0x7F9
  KEY_Greek_switch* = 0xFF7E
  KEY_leftradical* = 0x8A1
  KEY_topleftradical* = 0x8A2
  KEY_horizconnector* = 0x8A3
  KEY_topintegral* = 0x8A4
  KEY_botintegral* = 0x8A5
  KEY_vertconnector* = 0x8A6
  KEY_topleftsqbracket* = 0x8A7
  KEY_botleftsqbracket* = 0x8A8
  KEY_toprightsqbracket* = 0x8A9
  KEY_botrightsqbracket* = 0x8AA
  KEY_topleftparens* = 0x8AB
  KEY_botleftparens* = 0x8AC
  KEY_toprightparens* = 0x8AD
  KEY_botrightparens* = 0x8AE
  KEY_leftmiddlecurlybrace* = 0x8AF
  KEY_rightmiddlecurlybrace* = 0x8B0
  KEY_topleftsummation* = 0x8B1
  KEY_botleftsummation* = 0x8B2
  KEY_topvertsummationconnector* = 0x8B3
  KEY_botvertsummationconnector* = 0x8B4
  KEY_toprightsummation* = 0x8B5
  KEY_botrightsummation* = 0x8B6
  KEY_rightmiddlesummation* = 0x8B7
  KEY_lessthanequal* = 0x8BC
  KEY_notequal* = 0x8BD
  KEY_greaterthanequal* = 0x8BE
  KEY_integral* = 0x8BF
  KEY_therefore* = 0x8C0
  KEY_variation* = 0x8C1
  KEY_infinity* = 0x8C2
  KEY_nabla* = 0x8C5
  KEY_approximate* = 0x8C8
  KEY_similarequal* = 0x8C9
  KEY_ifonlyif* = 0x8CD
  KEY_implies* = 0x8CE
  KEY_identical* = 0x8CF
  KEY_radical* = 0x8D6
  KEY_includedin* = 0x8DA
  KEY_includes* = 0x8DB
  KEY_intersection* = 0x8DC
  KEY_union* = 0x8DD
  KEY_logicaland* = 0x8DE
  KEY_logicalor* = 0x8DF
  KEY_partialderivative* = 0x8EF
  KEY_function* = 0x8F6
  KEY_leftarrow* = 0x8FB
  KEY_uparrow* = 0x8FC
  KEY_rightarrow* = 0x8FD
  KEY_downarrow* = 0x8FE
  KEY_blank* = 0x9DF
  KEY_soliddiamond* = 0x9E0
  KEY_checkerboard* = 0x9E1
  KEY_ht* = 0x9E2
  KEY_ff* = 0x9E3
  KEY_cr* = 0x9E4
  KEY_lf* = 0x9E5
  KEY_nl* = 0x9E8
  KEY_vt* = 0x9E9
  KEY_lowrightcorner* = 0x9EA
  KEY_uprightcorner* = 0x9EB
  KEY_upleftcorner* = 0x9EC
  KEY_lowleftcorner* = 0x9ED
  KEY_crossinglines* = 0x9EE
  KEY_horizlinescan1* = 0x9EF
  KEY_horizlinescan3* = 0x9F0
  KEY_horizlinescan5* = 0x9F1
  KEY_horizlinescan7* = 0x9F2
  KEY_horizlinescan9* = 0x9F3
  KEY_leftt* = 0x9F4
  KEY_rightt* = 0x9F5
  KEY_bott* = 0x9F6
  KEY_topt* = 0x9F7
  KEY_vertbar* = 0x9F8
  KEY_emspace* = 0xAA1
  KEY_enspace* = 0xAA2
  KEY_em3space* = 0xAA3
  KEY_em4space* = 0xAA4
  KEY_digitspace* = 0xAA5
  KEY_punctspace* = 0xAA6
  KEY_thinspace* = 0xAA7
  KEY_hairspace* = 0xAA8
  KEY_emdash* = 0xAA9
  KEY_endash* = 0xAAA
  KEY_signifblank* = 0xAAC
  KEY_ellipsis* = 0xAAE
  KEY_doubbaselinedot* = 0xAAF
  KEY_onethird* = 0xAB0
  KEY_twothirds* = 0xAB1
  KEY_onefifth* = 0xAB2
  KEY_twofifths* = 0xAB3
  KEY_threefifths* = 0xAB4
  KEY_fourfifths* = 0xAB5
  KEY_onesixth* = 0xAB6
  KEY_fivesixths* = 0xAB7
  KEY_careof* = 0xAB8
  KEY_figdash* = 0xABB
  KEY_leftanglebracket* = 0xABC
  KEY_decimalpoint* = 0xABD
  KEY_rightanglebracket* = 0xABE
  KEY_marker* = 0xABF
  KEY_oneeighth* = 0xAC3
  KEY_threeeighths* = 0xAC4
  KEY_fiveeighths* = 0xAC5
  KEY_seveneighths* = 0xAC6
  KEY_trademark* = 0xAC9
  KEY_signaturemark* = 0xACA
  KEY_trademarkincircle* = 0xACB
  KEY_leftopentriangle* = 0xACC
  KEY_rightopentriangle* = 0xACD
  KEY_emopencircle* = 0xACE
  KEY_emopenrectangle* = 0xACF
  KEY_leftsinglequotemark* = 0xAD0
  KEY_rightsinglequotemark* = 0xAD1
  KEY_leftdoublequotemark* = 0xAD2
  KEY_rightdoublequotemark* = 0xAD3
  KEY_prescription* = 0xAD4
  KEY_permille* = 0xAD5
  KEY_minutes* = 0xAD6
  KEY_seconds* = 0xAD7
  KEY_latincross* = 0xAD9
  KEY_hexagram* = 0xADA
  KEY_filledrectbullet* = 0xADB
  KEY_filledlefttribullet* = 0xADC
  KEY_filledrighttribullet* = 0xADD
  KEY_emfilledcircle* = 0xADE
  KEY_emfilledrect* = 0xADF
  KEY_enopencircbullet* = 0xAE0
  KEY_enopensquarebullet* = 0xAE1
  KEY_openrectbullet* = 0xAE2
  KEY_opentribulletup* = 0xAE3
  KEY_opentribulletdown* = 0xAE4
  KEY_openstar* = 0xAE5
  KEY_enfilledcircbullet* = 0xAE6
  KEY_enfilledsqbullet* = 0xAE7
  KEY_filledtribulletup* = 0xAE8
  KEY_filledtribulletdown* = 0xAE9
  KEY_leftpointer* = 0xAEA
  KEY_rightpointer* = 0xAEB
  KEY_club* = 0xAEC
  KEY_diamond* = 0xAED
  KEY_heart* = 0xAEE
  KEY_maltesecross* = 0xAF0
  KEY_dagger* = 0xAF1
  KEY_doubledagger* = 0xAF2
  KEY_checkmark* = 0xAF3
  KEY_ballotcross* = 0xAF4
  KEY_musicalsharp* = 0xAF5
  KEY_musicalflat* = 0xAF6
  KEY_malesymbol* = 0xAF7
  KEY_femalesymbol* = 0xAF8
  KEY_telephone* = 0xAF9
  KEY_telephonerecorder* = 0xAFA
  KEY_phonographcopyright* = 0xAFB
  KEY_caret* = 0xAFC
  KEY_singlelowquotemark* = 0xAFD
  KEY_doublelowquotemark* = 0xAFE
  KEY_cursor* = 0xAFF
  KEY_leftcaret* = 0xBA3
  KEY_rightcaret* = 0xBA6
  KEY_downcaret* = 0xBA8
  KEY_upcaret* = 0xBA9
  KEY_overbar* = 0xBC0
  KEY_downtack* = 0xBC2
  KEY_upshoe* = 0xBC3
  KEY_downstile* = 0xBC4
  KEY_underbar* = 0xBC6
  KEY_jot* = 0xBCA
  KEY_quad* = 0xBCC
  KEY_uptack* = 0xBCE
  KEY_circle* = 0xBCF
  KEY_upstile* = 0xBD3
  KEY_downshoe* = 0xBD6
  KEY_rightshoe* = 0xBD8
  KEY_leftshoe* = 0xBDA
  KEY_lefttack* = 0xBDC
  KEY_righttack* = 0xBFC
  KEY_hebrew_doublelowline* = 0xCDF
  KEY_hebrew_aleph* = 0xCE0
  KEY_hebrew_bet* = 0xCE1
  KEY_hebrew_beth* = 0xCE1
  KEY_hebrew_gimel* = 0xCE2
  KEY_hebrew_gimmel* = 0xCE2
  KEY_hebrew_dalet* = 0xCE3
  KEY_hebrew_daleth* = 0xCE3
  KEY_hebrew_he* = 0xCE4
  KEY_hebrew_waw* = 0xCE5
  KEY_hebrew_zain* = 0xCE6
  KEY_hebrew_zayin* = 0xCE6
  KEY_hebrew_chet* = 0xCE7
  KEY_hebrew_het* = 0xCE7
  KEY_hebrew_tet* = 0xCE8
  KEY_hebrew_teth* = 0xCE8
  KEY_hebrew_yod* = 0xCE9
  KEY_hebrew_finalkaph* = 0xCEA
  KEY_hebrew_kaph* = 0xCEB
  KEY_hebrew_lamed* = 0xCEC
  KEY_hebrew_finalmem* = 0xCED
  KEY_hebrew_mem* = 0xCEE
  KEY_hebrew_finalnun* = 0xCEF
  KEY_hebrew_nun* = 0xCF0
  KEY_hebrew_samech* = 0xCF1
  KEY_hebrew_samekh* = 0xCF1
  KEY_hebrew_ayin* = 0xCF2
  KEY_hebrew_finalpe* = 0xCF3
  KEY_hebrew_pe* = 0xCF4
  KEY_hebrew_finalzade* = 0xCF5
  KEY_hebrew_finalzadi* = 0xCF5
  KEY_hebrew_zade* = 0xCF6
  KEY_hebrew_zadi* = 0xCF6
  KEY_hebrew_qoph* = 0xCF7
  KEY_hebrew_kuf* = 0xCF7
  KEY_hebrew_resh* = 0xCF8
  KEY_hebrew_shin* = 0xCF9
  KEY_hebrew_taw* = 0xCFA
  KEY_hebrew_taf* = 0xCFA
  KEY_Hebrew_switch* = 0xFF7E
  KEY_Thai_kokai* = 0xDA1
  KEY_Thai_khokhai* = 0xDA2
  KEY_Thai_khokhuat* = 0xDA3
  KEY_Thai_khokhwai* = 0xDA4
  KEY_Thai_khokhon* = 0xDA5
  KEY_Thai_khorakhang* = 0xDA6
  KEY_Thai_ngongu* = 0xDA7
  KEY_Thai_chochan* = 0xDA8
  KEY_Thai_choching* = 0xDA9
  KEY_Thai_chochang* = 0xDAA
  KEY_Thai_soso* = 0xDAB
  KEY_Thai_chochoe* = 0xDAC
  KEY_Thai_yoying* = 0xDAD
  KEY_Thai_dochada* = 0xDAE
  KEY_Thai_topatak* = 0xDAF
  KEY_Thai_thothan* = 0xDB0
  KEY_Thai_thonangmontho* = 0xDB1
  KEY_Thai_thophuthao* = 0xDB2
  KEY_Thai_nonen* = 0xDB3
  KEY_Thai_dodek* = 0xDB4
  KEY_Thai_totao* = 0xDB5
  KEY_Thai_thothung* = 0xDB6
  KEY_Thai_thothahan* = 0xDB7
  KEY_Thai_thothong* = 0xDB8
  KEY_Thai_nonu* = 0xDB9
  KEY_Thai_bobaimai* = 0xDBA
  KEY_Thai_popla* = 0xDBB
  KEY_Thai_phophung* = 0xDBC
  KEY_Thai_fofa* = 0xDBD
  KEY_Thai_phophan* = 0xDBE
  KEY_Thai_fofan* = 0xDBF
  KEY_Thai_phosamphao* = 0xDC0
  KEY_Thai_moma* = 0xDC1
  KEY_Thai_yoyak* = 0xDC2
  KEY_Thai_rorua* = 0xDC3
  KEY_Thai_ru* = 0xDC4
  KEY_Thai_loling* = 0xDC5
  KEY_Thai_lu* = 0xDC6
  KEY_Thai_wowaen* = 0xDC7
  KEY_Thai_sosala* = 0xDC8
  KEY_Thai_sorusi* = 0xDC9
  KEY_Thai_sosua* = 0xDCA
  KEY_Thai_hohip* = 0xDCB
  KEY_Thai_lochula* = 0xDCC
  KEY_Thai_oang* = 0xDCD
  KEY_Thai_honokhuk* = 0xDCE
  KEY_Thai_paiyannoi* = 0xDCF
  KEY_Thai_saraa* = 0xDD0
  KEY_Thai_maihanakat* = 0xDD1
  KEY_Thai_saraaa* = 0xDD2
  KEY_Thai_saraam* = 0xDD3
  KEY_Thai_sarai* = 0xDD4
  KEY_Thai_saraii* = 0xDD5
  KEY_Thai_saraue* = 0xDD6
  KEY_Thai_sarauee* = 0xDD7
  KEY_Thai_sarau* = 0xDD8
  KEY_Thai_sarauu* = 0xDD9
  KEY_Thai_phinthu* = 0xDDA
  KEY_Thai_maihanakat_maitho* = 0xDDE
  KEY_Thai_baht* = 0xDDF
  KEY_Thai_sarae* = 0xDE0
  KEY_Thai_saraae* = 0xDE1
  KEY_Thai_sarao* = 0xDE2
  KEY_Thai_saraaimaimuan* = 0xDE3
  KEY_Thai_saraaimaimalai* = 0xDE4
  KEY_Thai_lakkhangyao* = 0xDE5
  KEY_Thai_maiyamok* = 0xDE6
  KEY_Thai_maitaikhu* = 0xDE7
  KEY_Thai_maiek* = 0xDE8
  KEY_Thai_maitho* = 0xDE9
  KEY_Thai_maitri* = 0xDEA
  KEY_Thai_maichattawa* = 0xDEB
  KEY_Thai_thanthakhat* = 0xDEC
  KEY_Thai_nikhahit* = 0xDED
  KEY_Thai_leksun* = 0xDF0
  KEY_Thai_leknung* = 0xDF1
  KEY_Thai_leksong* = 0xDF2
  KEY_Thai_leksam* = 0xDF3
  KEY_Thai_leksi* = 0xDF4
  KEY_Thai_lekha* = 0xDF5
  KEY_Thai_lekhok* = 0xDF6
  KEY_Thai_lekchet* = 0xDF7
  KEY_Thai_lekpaet* = 0xDF8
  KEY_Thai_lekkao* = 0xDF9
  KEY_Hangul* = 0xFF31
  KEY_Hangul_Start* = 0xFF32
  KEY_Hangul_End* = 0xFF33
  KEY_Hangul_Hanja* = 0xFF34
  KEY_Hangul_Jamo* = 0xFF35
  KEY_Hangul_Romaja* = 0xFF36
  KEY_Hangul_Codeinput* = 0xFF37
  KEY_Hangul_Jeonja* = 0xFF38
  KEY_Hangul_Banja* = 0xFF39
  KEY_Hangul_PreHanja* = 0xFF3A
  KEY_Hangul_PostHanja* = 0xFF3B
  KEY_Hangul_SingleCandidate* = 0xFF3C
  KEY_Hangul_MultipleCandidate* = 0xFF3D
  KEY_Hangul_PreviousCandidate* = 0xFF3E
  KEY_Hangul_Special* = 0xFF3F
  KEY_Hangul_switch* = 0xFF7E
  KEY_Hangul_Kiyeog* = 0xEA1
  KEY_Hangul_SsangKiyeog* = 0xEA2
  KEY_Hangul_KiyeogSios* = 0xEA3
  KEY_Hangul_Nieun* = 0xEA4
  KEY_Hangul_NieunJieuj* = 0xEA5
  KEY_Hangul_NieunHieuh* = 0xEA6
  KEY_Hangul_Dikeud* = 0xEA7
  KEY_Hangul_SsangDikeud* = 0xEA8
  KEY_Hangul_Rieul* = 0xEA9
  KEY_Hangul_RieulKiyeog* = 0xEAA
  KEY_Hangul_RieulMieum* = 0xEAB
  KEY_Hangul_RieulPieub* = 0xEAC
  KEY_Hangul_RieulSios* = 0xEAD
  KEY_Hangul_RieulTieut* = 0xEAE
  KEY_Hangul_RieulPhieuf* = 0xEAF
  KEY_Hangul_RieulHieuh* = 0xEB0
  KEY_Hangul_Mieum* = 0xEB1
  KEY_Hangul_Pieub* = 0xEB2
  KEY_Hangul_SsangPieub* = 0xEB3
  KEY_Hangul_PieubSios* = 0xEB4
  KEY_Hangul_Sios* = 0xEB5
  KEY_Hangul_SsangSios* = 0xEB6
  KEY_Hangul_Ieung* = 0xEB7
  KEY_Hangul_Jieuj* = 0xEB8
  KEY_Hangul_SsangJieuj* = 0xEB9
  KEY_Hangul_Cieuc* = 0xEBA
  KEY_Hangul_Khieuq* = 0xEBB
  KEY_Hangul_Tieut* = 0xEBC
  KEY_Hangul_Phieuf* = 0xEBD
  KEY_Hangul_Hieuh* = 0xEBE
  KEY_Hangul_A* = 0xEBF
  KEY_Hangul_AE* = 0xEC0
  KEY_Hangul_YA* = 0xEC1
  KEY_Hangul_YAE* = 0xEC2
  KEY_Hangul_EO* = 0xEC3
  KEY_Hangul_E* = 0xEC4
  KEY_Hangul_YEO* = 0xEC5
  KEY_Hangul_YE* = 0xEC6
  KEY_Hangul_O* = 0xEC7
  KEY_Hangul_WA* = 0xEC8
  KEY_Hangul_WAE* = 0xEC9
  KEY_Hangul_OE* = 0xECA
  KEY_Hangul_YO* = 0xECB
  KEY_Hangul_U* = 0xECC
  KEY_Hangul_WEO* = 0xECD
  KEY_Hangul_WE* = 0xECE
  KEY_Hangul_WI* = 0xECF
  KEY_Hangul_YU* = 0xED0
  KEY_Hangul_EU* = 0xED1
  KEY_Hangul_YI* = 0xED2
  KEY_Hangul_I* = 0xED3
  KEY_Hangul_J_Kiyeog* = 0xED4
  KEY_Hangul_J_SsangKiyeog* = 0xED5
  KEY_Hangul_J_KiyeogSios* = 0xED6
  KEY_Hangul_J_Nieun* = 0xED7
  KEY_Hangul_J_NieunJieuj* = 0xED8
  KEY_Hangul_J_NieunHieuh* = 0xED9
  KEY_Hangul_J_Dikeud* = 0xEDA
  KEY_Hangul_J_Rieul* = 0xEDB
  KEY_Hangul_J_RieulKiyeog* = 0xEDC
  KEY_Hangul_J_RieulMieum* = 0xEDD
  KEY_Hangul_J_RieulPieub* = 0xEDE
  KEY_Hangul_J_RieulSios* = 0xEDF
  KEY_Hangul_J_RieulTieut* = 0xEE0
  KEY_Hangul_J_RieulPhieuf* = 0xEE1
  KEY_Hangul_J_RieulHieuh* = 0xEE2
  KEY_Hangul_J_Mieum* = 0xEE3
  KEY_Hangul_J_Pieub* = 0xEE4
  KEY_Hangul_J_PieubSios* = 0xEE5
  KEY_Hangul_J_Sios* = 0xEE6
  KEY_Hangul_J_SsangSios* = 0xEE7
  KEY_Hangul_J_Ieung* = 0xEE8
  KEY_Hangul_J_Jieuj* = 0xEE9
  KEY_Hangul_J_Cieuc* = 0xEEA
  KEY_Hangul_J_Khieuq* = 0xEEB
  KEY_Hangul_J_Tieut* = 0xEEC
  KEY_Hangul_J_Phieuf* = 0xEED
  KEY_Hangul_J_Hieuh* = 0xEEE
  KEY_Hangul_RieulYeorinHieuh* = 0xEEF
  KEY_Hangul_SunkyeongeumMieum* = 0xEF0
  KEY_Hangul_SunkyeongeumPieub* = 0xEF1
  KEY_Hangul_PanSios* = 0xEF2
  KEY_Hangul_KkogjiDalrinIeung* = 0xEF3
  KEY_Hangul_SunkyeongeumPhieuf* = 0xEF4
  KEY_Hangul_YeorinHieuh* = 0xEF5
  KEY_Hangul_AraeA* = 0xEF6
  KEY_Hangul_AraeAE* = 0xEF7
  KEY_Hangul_J_PanSios* = 0xEF8
  KEY_Hangul_J_KkogjiDalrinIeung* = 0xEF9
  KEY_Hangul_J_YeorinHieuh* = 0xEFA
  KEY_Korean_Won* = 0xEFF
  KEY_Armenian_ligature_ew* = 0x1000587
  KEY_Armenian_full_stop* = 0x1000589
  KEY_Armenian_verjaket* = 0x1000589
  KEY_Armenian_separation_mark* = 0x100055D
  KEY_Armenian_but* = 0x100055D
  KEY_Armenian_hyphen* = 0x100058A
  KEY_Armenian_yentamna* = 0x100058A
  KEY_Armenian_exclam* = 0x100055C
  KEY_Armenian_amanak* = 0x100055C
  KEY_Armenian_accent* = 0x100055B
  KEY_Armenian_shesht* = 0x100055B
  KEY_Armenian_question* = 0x100055E
  KEY_Armenian_paruyk* = 0x100055E
  KEY_CAPITAL_Armenian_AYB* = 0x1000531
  KEY_Armenian_ayb* = 0x1000561
  KEY_CAPITAL_Armenian_BEN* = 0x1000532
  KEY_Armenian_ben* = 0x1000562
  KEY_CAPITAL_Armenian_GIM* = 0x1000533
  KEY_Armenian_gim* = 0x1000563
  KEY_CAPITAL_Armenian_DA* = 0x1000534
  KEY_Armenian_da* = 0x1000564
  KEY_CAPITAL_Armenian_YECH* = 0x1000535
  KEY_Armenian_yech* = 0x1000565
  KEY_CAPITAL_Armenian_ZA* = 0x1000536
  KEY_Armenian_za* = 0x1000566
  KEY_CAPITAL_Armenian_E* = 0x1000537
  KEY_Armenian_e* = 0x1000567
  KEY_CAPITAL_Armenian_AT* = 0x1000538
  KEY_Armenian_at* = 0x1000568
  KEY_CAPITAL_Armenian_TO* = 0x1000539
  KEY_Armenian_to* = 0x1000569
  KEY_CAPITAL_Armenian_ZHE* = 0x100053A
  KEY_Armenian_zhe* = 0x100056A
  KEY_CAPITAL_Armenian_INI* = 0x100053B
  KEY_Armenian_ini* = 0x100056B
  KEY_CAPITAL_Armenian_LYUN* = 0x100053C
  KEY_Armenian_lyun* = 0x100056C
  KEY_CAPITAL_Armenian_KHE* = 0x100053D
  KEY_Armenian_khe* = 0x100056D
  KEY_CAPITAL_Armenian_TSA* = 0x100053E
  KEY_Armenian_tsa* = 0x100056E
  KEY_CAPITAL_Armenian_KEN* = 0x100053F
  KEY_Armenian_ken* = 0x100056F
  KEY_CAPITAL_Armenian_HO* = 0x1000540
  KEY_Armenian_ho* = 0x1000570
  KEY_CAPITAL_Armenian_DZA* = 0x1000541
  KEY_Armenian_dza* = 0x1000571
  KEY_CAPITAL_Armenian_GHAT* = 0x1000542
  KEY_Armenian_ghat* = 0x1000572
  KEY_CAPITAL_Armenian_TCHE* = 0x1000543
  KEY_Armenian_tche* = 0x1000573
  KEY_CAPITAL_Armenian_MEN* = 0x1000544
  KEY_Armenian_men* = 0x1000574
  KEY_CAPITAL_Armenian_HI* = 0x1000545
  KEY_Armenian_hi* = 0x1000575
  KEY_CAPITAL_Armenian_NU* = 0x1000546
  KEY_Armenian_nu* = 0x1000576
  KEY_CAPITAL_Armenian_SHA* = 0x1000547
  KEY_Armenian_sha* = 0x1000577
  KEY_CAPITAL_Armenian_VO* = 0x1000548
  KEY_Armenian_vo* = 0x1000578
  KEY_CAPITAL_Armenian_CHA* = 0x1000549
  KEY_Armenian_cha* = 0x1000579
  KEY_CAPITAL_Armenian_PE* = 0x100054A
  KEY_Armenian_pe* = 0x100057A
  KEY_CAPITAL_Armenian_JE* = 0x100054B
  KEY_Armenian_je* = 0x100057B
  KEY_CAPITAL_Armenian_RA* = 0x100054C
  KEY_Armenian_ra* = 0x100057C
  KEY_CAPITAL_Armenian_SE* = 0x100054D
  KEY_Armenian_se* = 0x100057D
  KEY_CAPITAL_Armenian_VEV* = 0x100054E
  KEY_Armenian_vev* = 0x100057E
  KEY_CAPITAL_Armenian_TYUN* = 0x100054F
  KEY_Armenian_tyun* = 0x100057F
  KEY_CAPITAL_Armenian_RE* = 0x1000550
  KEY_Armenian_re* = 0x1000580
  KEY_CAPITAL_Armenian_TSO* = 0x1000551
  KEY_Armenian_tso* = 0x1000581
  KEY_CAPITAL_Armenian_VYUN* = 0x1000552
  KEY_Armenian_vyun* = 0x1000582
  KEY_CAPITAL_Armenian_PYUR* = 0x1000553
  KEY_Armenian_pyur* = 0x1000583
  KEY_CAPITAL_Armenian_KE* = 0x1000554
  KEY_Armenian_ke* = 0x1000584
  KEY_CAPITAL_Armenian_O* = 0x1000555
  KEY_Armenian_o* = 0x1000585
  KEY_CAPITAL_Armenian_FE* = 0x1000556
  KEY_Armenian_fe* = 0x1000586
  KEY_Armenian_apostrophe* = 0x100055A
  KEY_Georgian_an* = 0x10010D0
  KEY_Georgian_ban* = 0x10010D1
  KEY_Georgian_gan* = 0x10010D2
  KEY_Georgian_don* = 0x10010D3
  KEY_Georgian_en* = 0x10010D4
  KEY_Georgian_vin* = 0x10010D5
  KEY_Georgian_zen* = 0x10010D6
  KEY_Georgian_tan* = 0x10010D7
  KEY_Georgian_in* = 0x10010D8
  KEY_Georgian_kan* = 0x10010D9
  KEY_Georgian_las* = 0x10010DA
  KEY_Georgian_man* = 0x10010DB
  KEY_Georgian_nar* = 0x10010DC
  KEY_Georgian_on* = 0x10010DD
  KEY_Georgian_par* = 0x10010DE
  KEY_Georgian_zhar* = 0x10010DF
  KEY_Georgian_rae* = 0x10010E0
  KEY_Georgian_san* = 0x10010E1
  KEY_Georgian_tar* = 0x10010E2
  KEY_Georgian_un* = 0x10010E3
  KEY_Georgian_phar* = 0x10010E4
  KEY_Georgian_khar* = 0x10010E5
  KEY_Georgian_ghan* = 0x10010E6
  KEY_Georgian_qar* = 0x10010E7
  KEY_Georgian_shin* = 0x10010E8
  KEY_Georgian_chin* = 0x10010E9
  KEY_Georgian_can* = 0x10010EA
  KEY_Georgian_jil* = 0x10010EB
  KEY_Georgian_cil* = 0x10010EC
  KEY_Georgian_char* = 0x10010ED
  KEY_Georgian_xan* = 0x10010EE
  KEY_Georgian_jhan* = 0x10010EF
  KEY_Georgian_hae* = 0x10010F0
  KEY_Georgian_he* = 0x10010F1
  KEY_Georgian_hie* = 0x10010F2
  KEY_Georgian_we* = 0x10010F3
  KEY_Georgian_har* = 0x10010F4
  KEY_Georgian_hoe* = 0x10010F5
  KEY_Georgian_fi* = 0x10010F6
  KEY_CAPITAL_Xabovedot* = 0x1001E8A
  KEY_CAPITAL_Ibreve* = 0x100012C
  KEY_CAPITAL_Zstroke* = 0x10001B5
  KEY_CAPITAL_Gcaron* = 0x10001E6
  KEY_CAPITAL_Ocaron* = 0x10001D1
  KEY_CAPITAL_Obarred* = 0x100019F
  KEY_xabovedot* = 0x1001E8B
  KEY_ibreve* = 0x100012D
  KEY_zstroke* = 0x10001B6
  KEY_gcaron* = 0x10001E7
  KEY_ocaron* = 0x10001D2
  KEY_obarred* = 0x1000275
  KEY_CAPITAL_SCHWA* = 0x100018F
  KEY_schwa* = 0x1000259
  KEY_CAPITAL_EZH* = 0x10001B7
  KEY_ezh* = 0x1000292
  KEY_CAPITAL_Lbelowdot* = 0x1001E36
  KEY_lbelowdot* = 0x1001E37
  KEY_CAPITAL_Abelowdot* = 0x1001EA0
  KEY_abelowdot* = 0x1001EA1
  KEY_CAPITAL_Ahook* = 0x1001EA2
  KEY_ahook* = 0x1001EA3
  KEY_CAPITAL_Acircumflexacute* = 0x1001EA4
  KEY_acircumflexacute* = 0x1001EA5
  KEY_CAPITAL_Acircumflexgrave* = 0x1001EA6
  KEY_acircumflexgrave* = 0x1001EA7
  KEY_CAPITAL_Acircumflexhook* = 0x1001EA8
  KEY_acircumflexhook* = 0x1001EA9
  KEY_CAPITAL_Acircumflextilde* = 0x1001EAA
  KEY_acircumflextilde* = 0x1001EAB
  KEY_CAPITAL_Acircumflexbelowdot* = 0x1001EAC
  KEY_acircumflexbelowdot* = 0x1001EAD
  KEY_CAPITAL_Abreveacute* = 0x1001EAE
  KEY_abreveacute* = 0x1001EAF
  KEY_CAPITAL_Abrevegrave* = 0x1001EB0
  KEY_abrevegrave* = 0x1001EB1
  KEY_CAPITAL_Abrevehook* = 0x1001EB2
  KEY_abrevehook* = 0x1001EB3
  KEY_CAPITAL_Abrevetilde* = 0x1001EB4
  KEY_abrevetilde* = 0x1001EB5
  KEY_CAPITAL_Abrevebelowdot* = 0x1001EB6
  KEY_abrevebelowdot* = 0x1001EB7
  KEY_CAPITAL_Ebelowdot* = 0x1001EB8
  KEY_ebelowdot* = 0x1001EB9
  KEY_CAPITAL_Ehook* = 0x1001EBA
  KEY_ehook* = 0x1001EBB
  KEY_CAPITAL_Etilde* = 0x1001EBC
  KEY_etilde* = 0x1001EBD
  KEY_CAPITAL_Ecircumflexacute* = 0x1001EBE
  KEY_ecircumflexacute* = 0x1001EBF
  KEY_CAPITAL_Ecircumflexgrave* = 0x1001EC0
  KEY_ecircumflexgrave* = 0x1001EC1
  KEY_CAPITAL_Ecircumflexhook* = 0x1001EC2
  KEY_ecircumflexhook* = 0x1001EC3
  KEY_CAPITAL_Ecircumflextilde* = 0x1001EC4
  KEY_ecircumflextilde* = 0x1001EC5
  KEY_CAPITAL_Ecircumflexbelowdot* = 0x1001EC6
  KEY_ecircumflexbelowdot* = 0x1001EC7
  KEY_CAPITAL_Ihook* = 0x1001EC8
  KEY_ihook* = 0x1001EC9
  KEY_CAPITAL_Ibelowdot* = 0x1001ECA
  KEY_ibelowdot* = 0x1001ECB
  KEY_CAPITAL_Obelowdot* = 0x1001ECC
  KEY_obelowdot* = 0x1001ECD
  KEY_CAPITAL_Ohook* = 0x1001ECE
  KEY_ohook* = 0x1001ECF
  KEY_CAPITAL_Ocircumflexacute* = 0x1001ED0
  KEY_ocircumflexacute* = 0x1001ED1
  KEY_CAPITAL_Ocircumflexgrave* = 0x1001ED2
  KEY_ocircumflexgrave* = 0x1001ED3
  KEY_CAPITAL_Ocircumflexhook* = 0x1001ED4
  KEY_ocircumflexhook* = 0x1001ED5
  KEY_CAPITAL_Ocircumflextilde* = 0x1001ED6
  KEY_ocircumflextilde* = 0x1001ED7
  KEY_CAPITAL_Ocircumflexbelowdot* = 0x1001ED8
  KEY_ocircumflexbelowdot* = 0x1001ED9
  KEY_CAPITAL_Ohornacute* = 0x1001EDA
  KEY_ohornacute* = 0x1001EDB
  KEY_CAPITAL_Ohorngrave* = 0x1001EDC
  KEY_ohorngrave* = 0x1001EDD
  KEY_CAPITAL_Ohornhook* = 0x1001EDE
  KEY_ohornhook* = 0x1001EDF
  KEY_CAPITAL_Ohorntilde* = 0x1001EE0
  KEY_ohorntilde* = 0x1001EE1
  KEY_CAPITAL_Ohornbelowdot* = 0x1001EE2
  KEY_ohornbelowdot* = 0x1001EE3
  KEY_CAPITAL_Ubelowdot* = 0x1001EE4
  KEY_ubelowdot* = 0x1001EE5
  KEY_CAPITAL_Uhook* = 0x1001EE6
  KEY_uhook* = 0x1001EE7
  KEY_CAPITAL_Uhornacute* = 0x1001EE8
  KEY_uhornacute* = 0x1001EE9
  KEY_CAPITAL_Uhorngrave* = 0x1001EEA
  KEY_uhorngrave* = 0x1001EEB
  KEY_CAPITAL_Uhornhook* = 0x1001EEC
  KEY_uhornhook* = 0x1001EED
  KEY_CAPITAL_Uhorntilde* = 0x1001EEE
  KEY_uhorntilde* = 0x1001EEF
  KEY_CAPITAL_Uhornbelowdot* = 0x1001EF0
  KEY_uhornbelowdot* = 0x1001EF1
  KEY_CAPITAL_Ybelowdot* = 0x1001EF4
  KEY_ybelowdot* = 0x1001EF5
  KEY_CAPITAL_Yhook* = 0x1001EF6
  KEY_yhook* = 0x1001EF7
  KEY_CAPITAL_Ytilde* = 0x1001EF8
  KEY_ytilde* = 0x1001EF9
  KEY_CAPITAL_Ohorn* = 0x10001A0
  KEY_ohorn* = 0x10001A1
  KEY_CAPITAL_Uhorn* = 0x10001AF
  KEY_uhorn* = 0x10001B0
  KEY_EcuSign* = 0x10020A0
  KEY_ColonSign* = 0x10020A1
  KEY_CruzeiroSign* = 0x10020A2
  KEY_FFrancSign* = 0x10020A3
  KEY_LiraSign* = 0x10020A4
  KEY_MillSign* = 0x10020A5
  KEY_NairaSign* = 0x10020A6
  KEY_PesetaSign* = 0x10020A7
  KEY_RupeeSign* = 0x10020A8
  KEY_WonSign* = 0x10020A9
  KEY_NewSheqelSign* = 0x10020AA
  KEY_DongSign* = 0x10020AB
  KEY_EuroSign* = 0x20AC
  KEY_zerosuperior* = 0x1002070
  KEY_foursuperior* = 0x1002074
  KEY_fivesuperior* = 0x1002075
  KEY_sixsuperior* = 0x1002076
  KEY_sevensuperior* = 0x1002077
  KEY_eightsuperior* = 0x1002078
  KEY_ninesuperior* = 0x1002079
  KEY_zerosubscript* = 0x1002080
  KEY_onesubscript* = 0x1002081
  KEY_twosubscript* = 0x1002082
  KEY_threesubscript* = 0x1002083
  KEY_foursubscript* = 0x1002084
  KEY_fivesubscript* = 0x1002085
  KEY_sixsubscript* = 0x1002086
  KEY_sevensubscript* = 0x1002087
  KEY_eightsubscript* = 0x1002088
  KEY_ninesubscript* = 0x1002089
  KEY_partdifferential* = 0x1002202
  KEY_emptyset* = 0x1002205
  KEY_elementof* = 0x1002208
  KEY_notelementof* = 0x1002209
  KEY_containsas* = 0x100220B
  KEY_squareroot* = 0x100221A
  KEY_cuberoot* = 0x100221B
  KEY_fourthroot* = 0x100221C
  KEY_dintegral* = 0x100222C
  KEY_tintegral* = 0x100222D
  KEY_because* = 0x1002235
  KEY_approxeq* = 0x1002248
  KEY_notapproxeq* = 0x1002247
  KEY_notidentical* = 0x1002262
  KEY_stricteq* = 0x1002263
  KEY_braille_dot_1* = 0xFFF1
  KEY_braille_dot_2* = 0xFFF2
  KEY_braille_dot_3* = 0xFFF3
  KEY_braille_dot_4* = 0xFFF4
  KEY_braille_dot_5* = 0xFFF5
  KEY_braille_dot_6* = 0xFFF6
  KEY_braille_dot_7* = 0xFFF7
  KEY_braille_dot_8* = 0xFFF8
  KEY_braille_dot_9* = 0xFFF9
  KEY_braille_dot_10* = 0xFFFA
  KEY_braille_blank* = 0x1002800
  KEY_braille_dots_1* = 0x1002801
  KEY_braille_dots_2* = 0x1002802
  KEY_braille_dots_12* = 0x1002803
  KEY_braille_dots_3* = 0x1002804
  KEY_braille_dots_13* = 0x1002805
  KEY_braille_dots_23* = 0x1002806
  KEY_braille_dots_123* = 0x1002807
  KEY_braille_dots_4* = 0x1002808
  KEY_braille_dots_14* = 0x1002809
  KEY_braille_dots_24* = 0x100280A
  KEY_braille_dots_124* = 0x100280B
  KEY_braille_dots_34* = 0x100280C
  KEY_braille_dots_134* = 0x100280D
  KEY_braille_dots_234* = 0x100280E
  KEY_braille_dots_1234* = 0x100280F
  KEY_braille_dots_5* = 0x1002810
  KEY_braille_dots_15* = 0x1002811
  KEY_braille_dots_25* = 0x1002812
  KEY_braille_dots_125* = 0x1002813
  KEY_braille_dots_35* = 0x1002814
  KEY_braille_dots_135* = 0x1002815
  KEY_braille_dots_235* = 0x1002816
  KEY_braille_dots_1235* = 0x1002817
  KEY_braille_dots_45* = 0x1002818
  KEY_braille_dots_145* = 0x1002819
  KEY_braille_dots_245* = 0x100281A
  KEY_braille_dots_1245* = 0x100281B
  KEY_braille_dots_345* = 0x100281C
  KEY_braille_dots_1345* = 0x100281D
  KEY_braille_dots_2345* = 0x100281E
  KEY_braille_dots_12345* = 0x100281F
  KEY_braille_dots_6* = 0x1002820
  KEY_braille_dots_16* = 0x1002821
  KEY_braille_dots_26* = 0x1002822
  KEY_braille_dots_126* = 0x1002823
  KEY_braille_dots_36* = 0x1002824
  KEY_braille_dots_136* = 0x1002825
  KEY_braille_dots_236* = 0x1002826
  KEY_braille_dots_1236* = 0x1002827
  KEY_braille_dots_46* = 0x1002828
  KEY_braille_dots_146* = 0x1002829
  KEY_braille_dots_246* = 0x100282A
  KEY_braille_dots_1246* = 0x100282B
  KEY_braille_dots_346* = 0x100282C
  KEY_braille_dots_1346* = 0x100282D
  KEY_braille_dots_2346* = 0x100282E
  KEY_braille_dots_12346* = 0x100282F
  KEY_braille_dots_56* = 0x1002830
  KEY_braille_dots_156* = 0x1002831
  KEY_braille_dots_256* = 0x1002832
  KEY_braille_dots_1256* = 0x1002833
  KEY_braille_dots_356* = 0x1002834
  KEY_braille_dots_1356* = 0x1002835
  KEY_braille_dots_2356* = 0x1002836
  KEY_braille_dots_12356* = 0x1002837
  KEY_braille_dots_456* = 0x1002838
  KEY_braille_dots_1456* = 0x1002839
  KEY_braille_dots_2456* = 0x100283A
  KEY_braille_dots_12456* = 0x100283B
  KEY_braille_dots_3456* = 0x100283C
  KEY_braille_dots_13456* = 0x100283D
  KEY_braille_dots_23456* = 0x100283E
  KEY_braille_dots_123456* = 0x100283F
  KEY_braille_dots_7* = 0x1002840
  KEY_braille_dots_17* = 0x1002841
  KEY_braille_dots_27* = 0x1002842
  KEY_braille_dots_127* = 0x1002843
  KEY_braille_dots_37* = 0x1002844
  KEY_braille_dots_137* = 0x1002845
  KEY_braille_dots_237* = 0x1002846
  KEY_braille_dots_1237* = 0x1002847
  KEY_braille_dots_47* = 0x1002848
  KEY_braille_dots_147* = 0x1002849
  KEY_braille_dots_247* = 0x100284A
  KEY_braille_dots_1247* = 0x100284B
  KEY_braille_dots_347* = 0x100284C
  KEY_braille_dots_1347* = 0x100284D
  KEY_braille_dots_2347* = 0x100284E
  KEY_braille_dots_12347* = 0x100284F
  KEY_braille_dots_57* = 0x1002850
  KEY_braille_dots_157* = 0x1002851
  KEY_braille_dots_257* = 0x1002852
  KEY_braille_dots_1257* = 0x1002853
  KEY_braille_dots_357* = 0x1002854
  KEY_braille_dots_1357* = 0x1002855
  KEY_braille_dots_2357* = 0x1002856
  KEY_braille_dots_12357* = 0x1002857
  KEY_braille_dots_457* = 0x1002858
  KEY_braille_dots_1457* = 0x1002859
  KEY_braille_dots_2457* = 0x100285A
  KEY_braille_dots_12457* = 0x100285B
  KEY_braille_dots_3457* = 0x100285C
  KEY_braille_dots_13457* = 0x100285D
  KEY_braille_dots_23457* = 0x100285E
  KEY_braille_dots_123457* = 0x100285F
  KEY_braille_dots_67* = 0x1002860
  KEY_braille_dots_167* = 0x1002861
  KEY_braille_dots_267* = 0x1002862
  KEY_braille_dots_1267* = 0x1002863
  KEY_braille_dots_367* = 0x1002864
  KEY_braille_dots_1367* = 0x1002865
  KEY_braille_dots_2367* = 0x1002866
  KEY_braille_dots_12367* = 0x1002867
  KEY_braille_dots_467* = 0x1002868
  KEY_braille_dots_1467* = 0x1002869
  KEY_braille_dots_2467* = 0x100286A
  KEY_braille_dots_12467* = 0x100286B
  KEY_braille_dots_3467* = 0x100286C
  KEY_braille_dots_13467* = 0x100286D
  KEY_braille_dots_23467* = 0x100286E
  KEY_braille_dots_123467* = 0x100286F
  KEY_braille_dots_567* = 0x1002870
  KEY_braille_dots_1567* = 0x1002871
  KEY_braille_dots_2567* = 0x1002872
  KEY_braille_dots_12567* = 0x1002873
  KEY_braille_dots_3567* = 0x1002874
  KEY_braille_dots_13567* = 0x1002875
  KEY_braille_dots_23567* = 0x1002876
  KEY_braille_dots_123567* = 0x1002877
  KEY_braille_dots_4567* = 0x1002878
  KEY_braille_dots_14567* = 0x1002879
  KEY_braille_dots_24567* = 0x100287A
  KEY_braille_dots_124567* = 0x100287B
  KEY_braille_dots_34567* = 0x100287C
  KEY_braille_dots_134567* = 0x100287D
  KEY_braille_dots_234567* = 0x100287E
  KEY_braille_dots_1234567* = 0x100287F
  KEY_braille_dots_8* = 0x1002880
  KEY_braille_dots_18* = 0x1002881
  KEY_braille_dots_28* = 0x1002882
  KEY_braille_dots_128* = 0x1002883
  KEY_braille_dots_38* = 0x1002884
  KEY_braille_dots_138* = 0x1002885
  KEY_braille_dots_238* = 0x1002886
  KEY_braille_dots_1238* = 0x1002887
  KEY_braille_dots_48* = 0x1002888
  KEY_braille_dots_148* = 0x1002889
  KEY_braille_dots_248* = 0x100288A
  KEY_braille_dots_1248* = 0x100288B
  KEY_braille_dots_348* = 0x100288C
  KEY_braille_dots_1348* = 0x100288D
  KEY_braille_dots_2348* = 0x100288E
  KEY_braille_dots_12348* = 0x100288F
  KEY_braille_dots_58* = 0x1002890
  KEY_braille_dots_158* = 0x1002891
  KEY_braille_dots_258* = 0x1002892
  KEY_braille_dots_1258* = 0x1002893
  KEY_braille_dots_358* = 0x1002894
  KEY_braille_dots_1358* = 0x1002895
  KEY_braille_dots_2358* = 0x1002896
  KEY_braille_dots_12358* = 0x1002897
  KEY_braille_dots_458* = 0x1002898
  KEY_braille_dots_1458* = 0x1002899
  KEY_braille_dots_2458* = 0x100289A
  KEY_braille_dots_12458* = 0x100289B
  KEY_braille_dots_3458* = 0x100289C
  KEY_braille_dots_13458* = 0x100289D
  KEY_braille_dots_23458* = 0x100289E
  KEY_braille_dots_123458* = 0x100289F
  KEY_braille_dots_68* = 0x10028A0
  KEY_braille_dots_168* = 0x10028A1
  KEY_braille_dots_268* = 0x10028A2
  KEY_braille_dots_1268* = 0x10028A3
  KEY_braille_dots_368* = 0x10028A4
  KEY_braille_dots_1368* = 0x10028A5
  KEY_braille_dots_2368* = 0x10028A6
  KEY_braille_dots_12368* = 0x10028A7
  KEY_braille_dots_468* = 0x10028A8
  KEY_braille_dots_1468* = 0x10028A9
  KEY_braille_dots_2468* = 0x10028AA
  KEY_braille_dots_12468* = 0x10028AB
  KEY_braille_dots_3468* = 0x10028AC
  KEY_braille_dots_13468* = 0x10028AD
  KEY_braille_dots_23468* = 0x10028AE
  KEY_braille_dots_123468* = 0x10028AF
  KEY_braille_dots_568* = 0x10028B0
  KEY_braille_dots_1568* = 0x10028B1
  KEY_braille_dots_2568* = 0x10028B2
  KEY_braille_dots_12568* = 0x10028B3
  KEY_braille_dots_3568* = 0x10028B4
  KEY_braille_dots_13568* = 0x10028B5
  KEY_braille_dots_23568* = 0x10028B6
  KEY_braille_dots_123568* = 0x10028B7
  KEY_braille_dots_4568* = 0x10028B8
  KEY_braille_dots_14568* = 0x10028B9
  KEY_braille_dots_24568* = 0x10028BA
  KEY_braille_dots_124568* = 0x10028BB
  KEY_braille_dots_34568* = 0x10028BC
  KEY_braille_dots_134568* = 0x10028BD
  KEY_braille_dots_234568* = 0x10028BE
  KEY_braille_dots_1234568* = 0x10028BF
  KEY_braille_dots_78* = 0x10028C0
  KEY_braille_dots_178* = 0x10028C1
  KEY_braille_dots_278* = 0x10028C2
  KEY_braille_dots_1278* = 0x10028C3
  KEY_braille_dots_378* = 0x10028C4
  KEY_braille_dots_1378* = 0x10028C5
  KEY_braille_dots_2378* = 0x10028C6
  KEY_braille_dots_12378* = 0x10028C7
  KEY_braille_dots_478* = 0x10028C8
  KEY_braille_dots_1478* = 0x10028C9
  KEY_braille_dots_2478* = 0x10028CA
  KEY_braille_dots_12478* = 0x10028CB
  KEY_braille_dots_3478* = 0x10028CC
  KEY_braille_dots_13478* = 0x10028CD
  KEY_braille_dots_23478* = 0x10028CE
  KEY_braille_dots_123478* = 0x10028CF
  KEY_braille_dots_578* = 0x10028D0
  KEY_braille_dots_1578* = 0x10028D1
  KEY_braille_dots_2578* = 0x10028D2
  KEY_braille_dots_12578* = 0x10028D3
  KEY_braille_dots_3578* = 0x10028D4
  KEY_braille_dots_13578* = 0x10028D5
  KEY_braille_dots_23578* = 0x10028D6
  KEY_braille_dots_123578* = 0x10028D7
  KEY_braille_dots_4578* = 0x10028D8
  KEY_braille_dots_14578* = 0x10028D9
  KEY_braille_dots_24578* = 0x10028DA
  KEY_braille_dots_124578* = 0x10028DB
  KEY_braille_dots_34578* = 0x10028DC
  KEY_braille_dots_134578* = 0x10028DD
  KEY_braille_dots_234578* = 0x10028DE
  KEY_braille_dots_1234578* = 0x10028DF
  KEY_braille_dots_678* = 0x10028E0
  KEY_braille_dots_1678* = 0x10028E1
  KEY_braille_dots_2678* = 0x10028E2
  KEY_braille_dots_12678* = 0x10028E3
  KEY_braille_dots_3678* = 0x10028E4
  KEY_braille_dots_13678* = 0x10028E5
  KEY_braille_dots_23678* = 0x10028E6
  KEY_braille_dots_123678* = 0x10028E7
  KEY_braille_dots_4678* = 0x10028E8
  KEY_braille_dots_14678* = 0x10028E9
  KEY_braille_dots_24678* = 0x10028EA
  KEY_braille_dots_124678* = 0x10028EB
  KEY_braille_dots_34678* = 0x10028EC
  KEY_braille_dots_134678* = 0x10028ED
  KEY_braille_dots_234678* = 0x10028EE
  KEY_braille_dots_1234678* = 0x10028EF
  KEY_braille_dots_5678* = 0x10028F0
  KEY_braille_dots_15678* = 0x10028F1
  KEY_braille_dots_25678* = 0x10028F2
  KEY_braille_dots_125678* = 0x10028F3
  KEY_braille_dots_35678* = 0x10028F4
  KEY_braille_dots_135678* = 0x10028F5
  KEY_braille_dots_235678* = 0x10028F6
  KEY_braille_dots_1235678* = 0x10028F7
  KEY_braille_dots_45678* = 0x10028F8
  KEY_braille_dots_145678* = 0x10028F9
  KEY_braille_dots_245678* = 0x10028FA
  KEY_braille_dots_1245678* = 0x10028FB
  KEY_braille_dots_345678* = 0x10028FC
  KEY_braille_dots_1345678* = 0x10028FD
  KEY_braille_dots_2345678* = 0x10028FE
  KEY_braille_dots_12345678* = 0x10028FF
  KEY_Sinh_ng* = 0x1000D82
  KEY_Sinh_h2* = 0x1000D83
  KEY_Sinh_a* = 0x1000D85
  KEY_Sinh_aa* = 0x1000D86
  KEY_Sinh_ae* = 0x1000D87
  KEY_Sinh_aee* = 0x1000D88
  KEY_Sinh_i* = 0x1000D89
  KEY_Sinh_ii* = 0x1000D8A
  KEY_Sinh_u* = 0x1000D8B
  KEY_Sinh_uu* = 0x1000D8C
  KEY_Sinh_ri* = 0x1000D8D
  KEY_Sinh_rii* = 0x1000D8E
  KEY_Sinh_lu* = 0x1000D8F
  KEY_Sinh_luu* = 0x1000D90
  KEY_Sinh_e* = 0x1000D91
  KEY_Sinh_ee* = 0x1000D92
  KEY_Sinh_ai* = 0x1000D93
  KEY_Sinh_o* = 0x1000D94
  KEY_Sinh_oo* = 0x1000D95
  KEY_Sinh_au* = 0x1000D96
  KEY_Sinh_ka* = 0x1000D9A
  KEY_Sinh_kha* = 0x1000D9B
  KEY_Sinh_ga* = 0x1000D9C
  KEY_Sinh_gha* = 0x1000D9D
  KEY_Sinh_ng2* = 0x1000D9E
  KEY_Sinh_nga* = 0x1000D9F
  KEY_Sinh_ca* = 0x1000DA0
  KEY_Sinh_cha* = 0x1000DA1
  KEY_Sinh_ja* = 0x1000DA2
  KEY_Sinh_jha* = 0x1000DA3
  KEY_Sinh_nya* = 0x1000DA4
  KEY_Sinh_jnya* = 0x1000DA5
  KEY_Sinh_nja* = 0x1000DA6
  KEY_Sinh_tta* = 0x1000DA7
  KEY_Sinh_ttha* = 0x1000DA8
  KEY_Sinh_dda* = 0x1000DA9
  KEY_Sinh_ddha* = 0x1000DAA
  KEY_Sinh_nna* = 0x1000DAB
  KEY_Sinh_ndda* = 0x1000DAC
  KEY_Sinh_tha* = 0x1000DAD
  KEY_Sinh_thha* = 0x1000DAE
  KEY_Sinh_dha* = 0x1000DAF
  KEY_Sinh_dhha* = 0x1000DB0
  KEY_Sinh_na* = 0x1000DB1
  KEY_Sinh_ndha* = 0x1000DB3
  KEY_Sinh_pa* = 0x1000DB4
  KEY_Sinh_pha* = 0x1000DB5
  KEY_Sinh_ba* = 0x1000DB6
  KEY_Sinh_bha* = 0x1000DB7
  KEY_Sinh_ma* = 0x1000DB8
  KEY_Sinh_mba* = 0x1000DB9
  KEY_Sinh_ya* = 0x1000DBA
  KEY_Sinh_ra* = 0x1000DBB
  KEY_Sinh_la* = 0x1000DBD
  KEY_Sinh_va* = 0x1000DC0
  KEY_Sinh_sha* = 0x1000DC1
  KEY_Sinh_ssha* = 0x1000DC2
  KEY_Sinh_sa* = 0x1000DC3
  KEY_Sinh_ha* = 0x1000DC4
  KEY_Sinh_lla* = 0x1000DC5
  KEY_Sinh_fa* = 0x1000DC6
  KEY_Sinh_al* = 0x1000DCA
  KEY_Sinh_aa2* = 0x1000DCF
  KEY_Sinh_ae2* = 0x1000DD0
  KEY_Sinh_aee2* = 0x1000DD1
  KEY_Sinh_i2* = 0x1000DD2
  KEY_Sinh_ii2* = 0x1000DD3
  KEY_Sinh_u2* = 0x1000DD4
  KEY_Sinh_uu2* = 0x1000DD6
  KEY_Sinh_ru2* = 0x1000DD8
  KEY_Sinh_e2* = 0x1000DD9
  KEY_Sinh_ee2* = 0x1000DDA
  KEY_Sinh_ai2* = 0x1000DDB
  KEY_Sinh_o2* = 0x1000DDC
  KEY_Sinh_oo2* = 0x1000DDD
  KEY_Sinh_au2* = 0x1000DDE
  KEY_Sinh_lu2* = 0x1000DDF
  KEY_Sinh_ruu2* = 0x1000DF2
  KEY_Sinh_luu2* = 0x1000DF3
  KEY_Sinh_kunddaliya* = 0x1000DF4
  KEY_ModeLock* = 0x1008FF01
  KEY_MonBrightnessUp* = 0x1008FF02
  KEY_MonBrightnessDown* = 0x1008FF03
  KEY_KbdLightOnOff* = 0x1008FF04
  KEY_KbdBrightnessUp* = 0x1008FF05
  KEY_KbdBrightnessDown* = 0x1008FF06
  KEY_Standby* = 0x1008FF10
  KEY_AudioLowerVolume* = 0x1008FF11
  KEY_AudioMute* = 0x1008FF12
  KEY_AudioRaiseVolume* = 0x1008FF13
  KEY_AudioPlay* = 0x1008FF14
  KEY_AudioStop* = 0x1008FF15
  KEY_AudioPrev* = 0x1008FF16
  KEY_AudioNext* = 0x1008FF17
  KEY_HomePage* = 0x1008FF18
  KEY_Mail* = 0x1008FF19
  KEY_Start* = 0x1008FF1A
  KEY_Search* = 0x1008FF1B
  KEY_AudioRecord* = 0x1008FF1C
  KEY_Calculator* = 0x1008FF1D
  KEY_Memo* = 0x1008FF1E
  KEY_ToDoList* = 0x1008FF1F
  KEY_Calendar* = 0x1008FF20
  KEY_PowerDown* = 0x1008FF21
  KEY_ContrastAdjust* = 0x1008FF22
  KEY_RockerUp* = 0x1008FF23
  KEY_RockerDown* = 0x1008FF24
  KEY_RockerEnter* = 0x1008FF25
  KEY_Back* = 0x1008FF26
  KEY_Forward* = 0x1008FF27
  KEY_Stop* = 0x1008FF28
  KEY_Refresh* = 0x1008FF29
  KEY_PowerOff* = 0x1008FF2A
  KEY_WakeUp* = 0x1008FF2B
  KEY_Eject* = 0x1008FF2C
  KEY_ScreenSaver* = 0x1008FF2D
  KEY_WWW* = 0x1008FF2E
  KEY_Sleep* = 0x1008FF2F
  KEY_Favorites* = 0x1008FF30
  KEY_AudioPause* = 0x1008FF31
  KEY_AudioMedia* = 0x1008FF32
  KEY_MyComputer* = 0x1008FF33
  KEY_VendorHome* = 0x1008FF34
  KEY_LightBulb* = 0x1008FF35
  KEY_Shop* = 0x1008FF36
  KEY_History* = 0x1008FF37
  KEY_OpenURL* = 0x1008FF38
  KEY_AddFavorite* = 0x1008FF39
  KEY_HotLinks* = 0x1008FF3A
  KEY_BrightnessAdjust* = 0x1008FF3B
  KEY_Finance* = 0x1008FF3C
  KEY_Community* = 0x1008FF3D
  KEY_AudioRewind* = 0x1008FF3E
  KEY_BackForward* = 0x1008FF3F
  KEY_Launch0* = 0x1008FF40
  KEY_Launch1* = 0x1008FF41
  KEY_Launch2* = 0x1008FF42
  KEY_Launch3* = 0x1008FF43
  KEY_Launch4* = 0x1008FF44
  KEY_Launch5* = 0x1008FF45
  KEY_Launch6* = 0x1008FF46
  KEY_Launch7* = 0x1008FF47
  KEY_Launch8* = 0x1008FF48
  KEY_Launch9* = 0x1008FF49
  KEY_LaunchA* = 0x1008FF4A
  KEY_LaunchB* = 0x1008FF4B
  KEY_LaunchC* = 0x1008FF4C
  KEY_LaunchD* = 0x1008FF4D
  KEY_LaunchE* = 0x1008FF4E
  KEY_LaunchF* = 0x1008FF4F
  KEY_ApplicationLeft* = 0x1008FF50
  KEY_ApplicationRight* = 0x1008FF51
  KEY_Book* = 0x1008FF52
  KEY_CD* = 0x1008FF53
  KEY_WindowClear* = 0x1008FF55
  KEY_Close* = 0x1008FF56
  KEY_Copy* = 0x1008FF57
  KEY_Cut* = 0x1008FF58
  KEY_Display* = 0x1008FF59
  KEY_DOS* = 0x1008FF5A
  KEY_Documents* = 0x1008FF5B
  KEY_Excel* = 0x1008FF5C
  KEY_Explorer* = 0x1008FF5D
  KEY_Game* = 0x1008FF5E
  KEY_Go* = 0x1008FF5F
  KEY_iTouch* = 0x1008FF60
  KEY_LogOff* = 0x1008FF61
  KEY_Market* = 0x1008FF62
  KEY_Meeting* = 0x1008FF63
  KEY_MenuKB* = 0x1008FF65
  KEY_MenuPB* = 0x1008FF66
  KEY_MySites* = 0x1008FF67
  KEY_New* = 0x1008FF68
  KEY_News* = 0x1008FF69
  KEY_OfficeHome* = 0x1008FF6A
  KEY_Open* = 0x1008FF6B
  KEY_Option* = 0x1008FF6C
  KEY_Paste* = 0x1008FF6D
  KEY_Phone* = 0x1008FF6E
  KEY_Reply* = 0x1008FF72
  KEY_Reload* = 0x1008FF73
  KEY_RotateWindows* = 0x1008FF74
  KEY_RotationPB* = 0x1008FF75
  KEY_RotationKB* = 0x1008FF76
  KEY_Save* = 0x1008FF77
  KEY_ScrollUp* = 0x1008FF78
  KEY_ScrollDown* = 0x1008FF79
  KEY_ScrollClick* = 0x1008FF7A
  KEY_Send* = 0x1008FF7B
  KEY_Spell* = 0x1008FF7C
  KEY_SplitScreen* = 0x1008FF7D
  KEY_Support* = 0x1008FF7E
  KEY_TaskPane* = 0x1008FF7F
  KEY_Terminal* = 0x1008FF80
  KEY_Tools* = 0x1008FF81
  KEY_Travel* = 0x1008FF82
  KEY_UserPB* = 0x1008FF84
  KEY_User1KB* = 0x1008FF85
  KEY_User2KB* = 0x1008FF86
  KEY_Video* = 0x1008FF87
  KEY_WheelButton* = 0x1008FF88
  KEY_Word* = 0x1008FF89
  KEY_Xfer* = 0x1008FF8A
  KEY_ZoomIn* = 0x1008FF8B
  KEY_ZoomOut* = 0x1008FF8C
  KEY_Away* = 0x1008FF8D
  KEY_Messenger* = 0x1008FF8E
  KEY_WebCam* = 0x1008FF8F
  KEY_MailForward* = 0x1008FF90
  KEY_Pictures* = 0x1008FF91
  KEY_Music* = 0x1008FF92
  KEY_Battery* = 0x1008FF93
  KEY_Bluetooth* = 0x1008FF94
  KEY_WLAN* = 0x1008FF95
  KEY_UWB* = 0x1008FF96
  KEY_AudioForward* = 0x1008FF97
  KEY_AudioRepeat* = 0x1008FF98
  KEY_AudioRandomPlay* = 0x1008FF99
  KEY_Subtitle* = 0x1008FF9A
  KEY_AudioCycleTrack* = 0x1008FF9B
  KEY_CycleAngle* = 0x1008FF9C
  KEY_FrameBack* = 0x1008FF9D
  KEY_FrameForward* = 0x1008FF9E
  KEY_Time* = 0x1008FF9F
  KEY_SelectButton* = 0x1008FFA0
  KEY_View* = 0x1008FFA1
  KEY_TopMenu* = 0x1008FFA2
  KEY_Red* = 0x1008FFA3
  KEY_Green* = 0x1008FFA4
  KEY_Yellow* = 0x1008FFA5
  KEY_Blue* = 0x1008FFA6
  KEY_Suspend* = 0x1008FFA7
  KEY_Hibernate* = 0x1008FFA8
  KEY_TouchpadToggle* = 0x1008FFA9
  KEY_TouchpadOn* = 0x1008FFB0
  KEY_TouchpadOff* = 0x1008FFB1
  KEY_AudioMicMute* = 0x1008FFB2
  KEY_Switch_VT_1* = 0x1008FE01
  KEY_Switch_VT_2* = 0x1008FE02
  KEY_Switch_VT_3* = 0x1008FE03
  KEY_Switch_VT_4* = 0x1008FE04
  KEY_Switch_VT_5* = 0x1008FE05
  KEY_Switch_VT_6* = 0x1008FE06
  KEY_Switch_VT_7* = 0x1008FE07
  KEY_Switch_VT_8* = 0x1008FE08
  KEY_Switch_VT_9* = 0x1008FE09
  KEY_Switch_VT_10* = 0x1008FE0A
  KEY_Switch_VT_11* = 0x1008FE0B
  KEY_Switch_VT_12* = 0x1008FE0C
  KEY_Ungrab* = 0x1008FE20
  KEY_ClearGrab* = 0x1008FE21
  KEY_Next_VMode* = 0x1008FE22
  KEY_Prev_VMode* = 0x1008FE23
  KEY_LogWindowTree* = 0x1008FE24
  KEY_LogGrabInfo* = 0x1008FE25

when ENABLE_NLS: # when defined(ENABLE_NLS): 
  template p_underscore*(String: expr): expr = 
    dgettext(GETTEXT_PACKAGE, "-properties", String)

else: 
  template p_underscore*(String: expr): expr = 
    (String)

const 
  CURRENT_TIME* = 0
const 
  PARENT_RELATIVE* = 1
type 
  Rectangle* =  ptr RectangleObj
  RectanglePtr* = ptr RectangleObj
  RectangleObj* = cairo.Rectangle_intObj
type 
  Atom* = ptr object
template gdk_atom_to_pointer*(atom: expr): expr = 
  (atom)

template gdk_pointer_to_atom*(`ptr`: expr): expr = 
  (Atom(ptr))

template gdk_make_atom(val: expr): expr = 
  (cast[Atom](GUINT_TO_POINTER(val)))

template gdk_none*(): expr = 
  gdk_make_atom(0)

type 
  Cursor* =  ptr CursorObj
  CursorPtr* = ptr CursorObj
  CursorObj*{.final.} = object of GObject 
  
  Visual* =  ptr VisualObj
  VisualPtr* = ptr VisualObj
  VisualObj*{.final.} = object of GObject 
  
  Device* =  ptr DeviceObj
  DevicePtr* = ptr DeviceObj
  DeviceObj*{.final.} = object of GObject 
  
  DragContext* =  ptr DragContextObj
  DragContextPtr* = ptr DragContextObj
  DragContextObj*{.final.} = object of GObject 
  
  DisplayManager* =  ptr DisplayManagerObj
  DisplayManagerPtr* = ptr DisplayManagerObj
  DisplayManagerObj*{.final.} = object of GObject 
  
  DeviceManager* =  ptr DeviceManagerObj
  DeviceManagerPtr* = ptr DeviceManagerObj
  DeviceManagerObj*{.final.} = object of GObject 
  
  Display* =  ptr DisplayObj
  DisplayPtr* = ptr DisplayObj
  DisplayObj*{.final.} = object of GObject 
  
  Screen* =  ptr ScreenObj
  ScreenPtr* = ptr ScreenObj
  ScreenObj*{.final.} = object of GObject 
  
  Window* =  ptr WindowObj
  WindowPtr* = ptr WindowObj
  WindowObj*{.final.} = object of GObject 
  
  Keymap* =  ptr KeymapObj
  KeymapPtr* = ptr KeymapObj
  KeymapObj*{.final.} = object of GObject 
  
  AppLaunchContext* =  ptr AppLaunchContextObj
  AppLaunchContextPtr* = ptr AppLaunchContextObj
  AppLaunchContextObj* = object 
  
  GLContext* =  ptr GLContextObj
  GLContextPtr* = ptr GLContextObj
  GLContextObj*{.final.} = object of GObject 
  
type 
  ByteOrder* {.size: sizeof(cint), pure.} = enum 
    LSB_FIRST, MSB_FIRST
type
  ModifierType* {.size: sizeof(cint), pure.} = enum 
    NONE = 0, 
    SHIFT_MASK = 1 shl 0, LOCK_MASK = 1 shl 1, 
    CONTROL_MASK = 1 shl 2, MOD1_MASK = 1 shl 3, 
    MOD2_MASK = 1 shl 4, MOD3_MASK = 1 shl 5, MOD4_MASK = 1 shl
        6, MOD5_MASK = 1 shl 7, BUTTON1_MASK = 1 shl 8, 
    BUTTON2_MASK = 1 shl 9, BUTTON3_MASK = 1 shl 10, 
    BUTTON4_MASK = 1 shl 11, BUTTON5_MASK = 1 shl 12, 
    MODIFIER_RESERVED_13_MASK = 1 shl 13, 
    MODIFIER_RESERVED_14_MASK = 1 shl 14, 
    MODIFIER_RESERVED_15_MASK = 1 shl 15, 
    MODIFIER_RESERVED_16_MASK = 1 shl 16, 
    MODIFIER_RESERVED_17_MASK = 1 shl 17, 
    MODIFIER_RESERVED_18_MASK = 1 shl 18, 
    MODIFIER_RESERVED_19_MASK = 1 shl 19, 
    MODIFIER_RESERVED_20_MASK = 1 shl 20, 
    MODIFIER_RESERVED_21_MASK = 1 shl 21, 
    MODIFIER_RESERVED_22_MASK = 1 shl 22, 
    MODIFIER_RESERVED_23_MASK = 1 shl 23, 
    MODIFIER_RESERVED_24_MASK = 1 shl 24, 
    MODIFIER_RESERVED_25_MASK = 1 shl 25, SUPER_MASK = 1 shl 26, 
    HYPER_MASK = 1 shl 27, META_MASK = 1 shl 28, 
    MODIFIER_RESERVED_29_MASK = 1 shl 29, RELEASE_MASK = 1 shl 30, 
    MODIFIER_MASK = 0x5C001FFF
type 
  ModifierIntent* {.size: sizeof(cint), pure.} = enum 
    PRIMARY_ACCELERATOR, CONTEXT_MENU, 
    EXTEND_SELECTION, 
    MODIFY_SELECTION, NO_TEXT_INPUT, 
    SHIFT_GROUP
  Status* {.size: sizeof(cint), pure.} = enum 
    ERROR_MEM = - 4, ERROR_FILE = - 3, ERROR_PARAM = - 2, 
    ERROR = - 1, OK = 0
type 
  GrabStatus* {.size: sizeof(cint), pure.} = enum 
    SUCCESS = 0, ALREADY_GRABBED = 1, 
    INVALID_TIME = 2, NOT_VIEWABLE = 3, FROZEN = 4, 
    FAILED = 5
type 
  GrabOwnership* {.size: sizeof(cint), pure.} = enum 
    NONE, WINDOW, APPLICATION
type 
  EventMask* {.size: sizeof(cint), pure.} = enum 
    EXPOSURE_MASK = 1 shl 1, POINTER_MOTION_MASK = 1 shl 2, 
    POINTER_MOTION_HINT_MASK = 1 shl 3, BUTTON_MOTION_MASK = 1 shl
        4, BUTTON1_MOTION_MASK = 1 shl 5, 
    BUTTON2_MOTION_MASK = 1 shl 6, BUTTON3_MOTION_MASK = 1 shl 7, 
    BUTTON_PRESS_MASK = 1 shl 8, BUTTON_RELEASE_MASK = 1 shl 9, 
    KEY_PRESS_MASK = 1 shl 10, KEY_RELEASE_MASK = 1 shl 11, 
    ENTER_NOTIFY_MASK = 1 shl 12, LEAVE_NOTIFY_MASK = 1 shl 13, 
    FOCUS_CHANGE_MASK = 1 shl 14, STRUCTURE_MASK = 1 shl 15, 
    PROPERTY_CHANGE_MASK = 1 shl 16, 
    VISIBILITY_NOTIFY_MASK = 1 shl 17, PROXIMITY_IN_MASK = 1 shl 18, 
    PROXIMITY_OUT_MASK = 1 shl 19, SUBSTRUCTURE_MASK = 1 shl 20, 
    SCROLL_MASK = 1 shl 21, TOUCH_MASK = 1 shl 22, 
    SMOOTH_SCROLL_MASK = 1 shl 23, ALL_EVENTS_MASK = 0xFFFFFE
type 
  Point* =  ptr PointObj
  PointPtr* = ptr PointObj
  PointObj* = object 
    x*: gint
    y*: gint

type 
  GLProfile* {.size: sizeof(cint), pure.} = enum 
    DEFAULT, GL_3_2_CORE
type 
  GLError* {.size: sizeof(cint), pure.} = enum 
    NOT_AVAILABLE, UNSUPPORTED_FORMAT, 
    UNSUPPORTED_PROFILE

template gdk_device*(o: expr): expr = 
  (g_type_check_instance_cast(o, device_get_type(), DeviceObj))

template gdk_is_device*(o: expr): expr = 
  (g_type_check_instance_type(o, device_get_type()))

type 
  InputSource* {.size: sizeof(cint), pure.} = enum 
    MOUSE, PEN, ERASER, CURSOR, 
    KEYBOARD, TOUCHSCREEN, TOUCHPAD
type 
  InputMode* {.size: sizeof(cint), pure.} = enum 
    DISABLED, SCREEN, WINDOW
type 
  AxisUse* {.size: sizeof(cint), pure.} = enum 
    IGNORE, X, Y, PRESSURE, 
    XTILT, YTILT, WHEEL, LAST
type 
  DeviceType* {.size: sizeof(cint), pure.} = enum 
    MASTER, SLAVE, FLOATING
const 
  MAX_TIMECOORD_AXES* = 128
type 
  TimeCoord* =  ptr TimeCoordObj
  TimeCoordPtr* = ptr TimeCoordObj
  TimeCoordObj* = object 
    time*: guint32
    axes*: array[MAX_TIMECOORD_AXES, gdouble]

proc device_get_type*(): GType {.importc: "gdk_device_get_type", 
                                     libgdk.}
proc get_name*(device: Device): cstring {.
    importc: "gdk_device_get_name", libgdk.}
proc name*(device: Device): cstring {.
    importc: "gdk_device_get_name", libgdk.}
proc get_has_cursor*(device: Device): gboolean {.
    importc: "gdk_device_get_has_cursor", libgdk.}
proc has_cursor*(device: Device): gboolean {.
    importc: "gdk_device_get_has_cursor", libgdk.}
proc get_source*(device: Device): InputSource {.
    importc: "gdk_device_get_source", libgdk.}
proc source*(device: Device): InputSource {.
    importc: "gdk_device_get_source", libgdk.}
proc get_mode*(device: Device): InputMode {.
    importc: "gdk_device_get_mode", libgdk.}
proc mode*(device: Device): InputMode {.
    importc: "gdk_device_get_mode", libgdk.}
proc set_mode*(device: Device; mode: InputMode): gboolean {.
    importc: "gdk_device_set_mode", libgdk.}
proc get_n_keys*(device: Device): gint {.
    importc: "gdk_device_get_n_keys", libgdk.}
proc n_keys*(device: Device): gint {.
    importc: "gdk_device_get_n_keys", libgdk.}
proc get_key*(device: Device; index: guint; 
                         keyval: var guint; modifiers: var ModifierType): gboolean {.
    importc: "gdk_device_get_key", libgdk.}
proc key*(device: Device; index: guint; 
                         keyval: var guint; modifiers: var ModifierType): gboolean {.
    importc: "gdk_device_get_key", libgdk.}
proc set_key*(device: Device; index: guint; keyval: guint; 
                         modifiers: ModifierType) {.
    importc: "gdk_device_set_key", libgdk.}
proc `key=`*(device: Device; index: guint; keyval: guint; 
                         modifiers: ModifierType) {.
    importc: "gdk_device_set_key", libgdk.}
proc get_axis_use*(device: Device; index: guint): AxisUse {.
    importc: "gdk_device_get_axis_use", libgdk.}
proc axis_use*(device: Device; index: guint): AxisUse {.
    importc: "gdk_device_get_axis_use", libgdk.}
proc set_axis_use*(device: Device; index: guint; 
                              use: AxisUse) {.
    importc: "gdk_device_set_axis_use", libgdk.}
proc `axis_use=`*(device: Device; index: guint; 
                              use: AxisUse) {.
    importc: "gdk_device_set_axis_use", libgdk.}
proc get_state*(device: Device; window: Window; 
                           axes: var gdouble; mask: var ModifierType) {.
    importc: "gdk_device_get_state", libgdk.}
proc get_position*(device: Device; 
                              screen: var Screen; x: var gint; 
                              y: var gint) {.
    importc: "gdk_device_get_position", libgdk.}
proc get_window_at_position*(device: Device; 
    win_x: var gint; win_y: var gint): Window {.
    importc: "gdk_device_get_window_at_position", libgdk.}
proc window_at_position*(device: Device; 
    win_x: var gint; win_y: var gint): Window {.
    importc: "gdk_device_get_window_at_position", libgdk.}
proc get_position_double*(device: Device; 
                                     screen: var Screen; 
                                     x: var gdouble; y: var gdouble) {.
    importc: "gdk_device_get_position_double", libgdk.}
proc get_window_at_position_double*(device: Device; 
    win_x: var gdouble; win_y: var gdouble): Window {.
    importc: "gdk_device_get_window_at_position_double", libgdk.}
proc window_at_position_double*(device: Device; 
    win_x: var gdouble; win_y: var gdouble): Window {.
    importc: "gdk_device_get_window_at_position_double", libgdk.}
proc get_history*(device: Device; window: Window; 
                             start: guint32; stop: guint32; 
                             events: var ptr TimeCoord; 
                             n_events: var gint): gboolean {.
    importc: "gdk_device_get_history", libgdk.}
proc history*(device: Device; window: Window; 
                             start: guint32; stop: guint32; 
                             events: var ptr TimeCoord; 
                             n_events: var gint): gboolean {.
    importc: "gdk_device_get_history", libgdk.}
proc device_free_history*(events: var TimeCoord; n_events: gint) {.
    importc: "gdk_device_free_history", libgdk.}
proc get_n_axes*(device: Device): gint {.
    importc: "gdk_device_get_n_axes", libgdk.}
proc n_axes*(device: Device): gint {.
    importc: "gdk_device_get_n_axes", libgdk.}
proc list_axes*(device: Device): glib.GList {.
    importc: "gdk_device_list_axes", libgdk.}
proc get_axis_value*(device: Device; axes: var gdouble; 
                                axis_label: Atom; value: var gdouble): gboolean {.
    importc: "gdk_device_get_axis_value", libgdk.}
proc axis_value*(device: Device; axes: var gdouble; 
                                axis_label: Atom; value: var gdouble): gboolean {.
    importc: "gdk_device_get_axis_value", libgdk.}
proc get_axis*(device: Device; axes: var gdouble; 
                          use: AxisUse; value: var gdouble): gboolean {.
    importc: "gdk_device_get_axis", libgdk.}
proc axis*(device: Device; axes: var gdouble; 
                          use: AxisUse; value: var gdouble): gboolean {.
    importc: "gdk_device_get_axis", libgdk.}
proc get_display*(device: Device): Display {.
    importc: "gdk_device_get_display", libgdk.}
proc display*(device: Device): Display {.
    importc: "gdk_device_get_display", libgdk.}
proc get_associated_device*(device: Device): Device {.
    importc: "gdk_device_get_associated_device", libgdk.}
proc associated_device*(device: Device): Device {.
    importc: "gdk_device_get_associated_device", libgdk.}
proc list_slave_devices*(device: Device): glib.GList {.
    importc: "gdk_device_list_slave_devices", libgdk.}
proc get_device_type*(device: Device): DeviceType {.
    importc: "gdk_device_get_device_type", libgdk.}
proc device_type*(device: Device): DeviceType {.
    importc: "gdk_device_get_device_type", libgdk.}
proc grab*(device: Device; window: Window; 
                      grab_ownership: GrabOwnership; 
                      owner_events: gboolean; event_mask: EventMask; 
                      cursor: Cursor; time: guint32): GrabStatus {.
    importc: "gdk_device_grab", libgdk.}
proc ungrab*(device: Device; time: guint32) {.
    importc: "gdk_device_ungrab", libgdk.}
proc warp*(device: Device; screen: Screen; x: gint; 
                      y: gint) {.importc: "gdk_device_warp", libgdk.}
proc device_grab_info_libgtk_only*(display: Display; 
    device: Device; grab_window: var Window; 
    owner_events: var gboolean): gboolean {.
    importc: "gdk_device_grab_info_libgtk_only", libgdk.}
proc get_last_event_window*(device: Device): Window {.
    importc: "gdk_device_get_last_event_window", libgdk.}
proc last_event_window*(device: Device): Window {.
    importc: "gdk_device_get_last_event_window", libgdk.}
proc get_vendor_id*(device: Device): cstring {.
    importc: "gdk_device_get_vendor_id", libgdk.}
proc vendor_id*(device: Device): cstring {.
    importc: "gdk_device_get_vendor_id", libgdk.}
proc get_product_id*(device: Device): cstring {.
    importc: "gdk_device_get_product_id", libgdk.}
proc product_id*(device: Device): cstring {.
    importc: "gdk_device_get_product_id", libgdk.}

template gdk_drag_context*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, drag_context_get_type(), DragContextObj))

template gdk_is_drag_context*(obj: expr): expr = 
  (g_type_check_instance_type(obj, drag_context_get_type()))

type 
  DragAction* {.size: sizeof(cint), pure.} = enum 
    DEFAULT = 1 shl 0, COPY = 1 shl 1, 
    MOVE = 1 shl 2, LINK = 1 shl 3, 
    PRIVATE = 1 shl 4, ASK = 1 shl 5
type 
  DragProtocol* {.size: sizeof(cint), pure.} = enum 
    NONE = 0, MOTIF, XDND, 
    ROOTWIN, WIN32_DROPFILES, 
    OLE2, LOCAL, WAYLAND
proc drag_context_get_type*(): GType {.
    importc: "gdk_drag_context_get_type", libgdk.}
proc set_device*(context: DragContext; 
                                  device: Device) {.
    importc: "gdk_drag_context_set_device", libgdk.}
proc `device=`*(context: DragContext; 
                                  device: Device) {.
    importc: "gdk_drag_context_set_device", libgdk.}
proc get_device*(context: DragContext): Device {.
    importc: "gdk_drag_context_get_device", libgdk.}
proc device*(context: DragContext): Device {.
    importc: "gdk_drag_context_get_device", libgdk.}
proc list_targets*(context: DragContext): glib.GList {.
    importc: "gdk_drag_context_list_targets", libgdk.}
proc get_actions*(context: DragContext): DragAction {.
    importc: "gdk_drag_context_get_actions", libgdk.}
proc actions*(context: DragContext): DragAction {.
    importc: "gdk_drag_context_get_actions", libgdk.}
proc get_suggested_action*(context: DragContext): DragAction {.
    importc: "gdk_drag_context_get_suggested_action", libgdk.}
proc suggested_action*(context: DragContext): DragAction {.
    importc: "gdk_drag_context_get_suggested_action", libgdk.}
proc get_selected_action*(context: DragContext): DragAction {.
    importc: "gdk_drag_context_get_selected_action", libgdk.}
proc selected_action*(context: DragContext): DragAction {.
    importc: "gdk_drag_context_get_selected_action", libgdk.}
proc get_source_window*(context: DragContext): Window {.
    importc: "gdk_drag_context_get_source_window", libgdk.}
proc source_window*(context: DragContext): Window {.
    importc: "gdk_drag_context_get_source_window", libgdk.}
proc get_dest_window*(context: DragContext): Window {.
    importc: "gdk_drag_context_get_dest_window", libgdk.}
proc dest_window*(context: DragContext): Window {.
    importc: "gdk_drag_context_get_dest_window", libgdk.}
proc get_protocol*(context: DragContext): DragProtocol {.
    importc: "gdk_drag_context_get_protocol", libgdk.}
proc protocol*(context: DragContext): DragProtocol {.
    importc: "gdk_drag_context_get_protocol", libgdk.}
proc drag_status*(context: DragContext; action: DragAction; 
                      time: guint32) {.importc: "gdk_drag_status", 
    libgdk.}
proc drop_reply*(context: DragContext; accepted: gboolean; 
                     time: guint32) {.importc: "gdk_drop_reply", libgdk.}
proc drop_finish*(context: DragContext; success: gboolean; 
                      time: guint32) {.importc: "gdk_drop_finish", 
    libgdk.}
proc drag_get_selection*(context: DragContext): Atom {.
    importc: "gdk_drag_get_selection", libgdk.}
proc drag_begin*(window: Window; targets: glib.GList): DragContext {.
    importc: "gdk_drag_begin", libgdk.}
proc drag_begin_for_device*(window: Window; device: Device; 
                                targets: glib.GList): DragContext {.
    importc: "gdk_drag_begin_for_device", libgdk.}
proc drag_find_window_for_screen*(context: DragContext; 
                                      drag_window: Window; 
                                      screen: Screen; x_root: gint; 
                                      y_root: gint; 
                                      dest_window: var Window; 
                                      protocol: var DragProtocol) {.
    importc: "gdk_drag_find_window_for_screen", libgdk.}
proc drag_motion*(context: DragContext; dest_window: Window; 
                      protocol: DragProtocol; x_root: gint; y_root: gint; 
                      suggested_action: DragAction; 
                      possible_actions: DragAction; time: guint32): gboolean {.
    importc: "gdk_drag_motion", libgdk.}
proc drag_drop*(context: DragContext; time: guint32) {.
    importc: "gdk_drag_drop", libgdk.}
proc drag_abort*(context: DragContext; time: guint32) {.
    importc: "gdk_drag_abort", libgdk.}
proc drag_drop_succeeded*(context: DragContext): gboolean {.
    importc: "gdk_drag_drop_succeeded", libgdk.}

const 
  PRIORITY_EVENTS* = G_PRIORITY_DEFAULT
const 
  PRIORITY_REDRAW* = (G_PRIORITY_HIGH_IDLE + 20)
const 
  EVENT_PROPAGATE* = GFALSE
const 
  EVENT_STOP* = GTRUE
const 
  BUTTON_PRIMARY* = 1
const 
  BUTTON_MIDDLE* = 2
const 
  BUTTON_SECONDARY* = 3
type 
  EventSequence* =  ptr EventSequenceObj
  EventSequencePtr* = ptr EventSequenceObj
  EventSequenceObj* = object 
  
type 
  XEvent* = proc () {.cdecl.}
type 
  FilterReturn* {.size: sizeof(cint), pure.} = enum 
    `CONTINUE`, TRANSLATE, REMOVE
type 
  EventType* {.size: sizeof(cint), pure.} = enum 
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
  DOUBLE_BUTTON_PRESS = EventType.BUTTON2_PRESS
  TRIPLE_BUTTON_PRESS = EventType.BUTTON3_PRESS
type 
  VisibilityState* {.size: sizeof(cint), pure.} = enum 
    UNOBSCURED, PARTIAL, 
    FULLY_OBSCURED
type 
  ScrollDirection* {.size: sizeof(cint), pure.} = enum 
    UP, DOWN, LEFT, RIGHT, 
    SMOOTH
type 
  NotifyType* {.size: sizeof(cint), pure.} = enum 
    ANCESTOR = 0, VIRTUAL = 1, INFERIOR = 2, 
    NONLINEAR = 3, NONLINEAR_VIRTUAL = 4, 
    UNKNOWN = 5
type 
  CrossingMode* {.size: sizeof(cint), pure.} = enum 
    NORMAL, GRAB, UNGRAB, 
    GTK_GRAB, GTK_UNGRAB, 
    STATE_CHANGED, TOUCH_BEGIN, 
    TOUCH_END, DEVICE_SWITCH
type 
  PropertyState* {.size: sizeof(cint), pure.} = enum 
    NEW_VALUE, DELETE
type 
  WindowState* {.size: sizeof(cint), pure.} = enum 
    WITHDRAWN = 1 shl 0, 
    ICONIFIED = 1 shl 1, 
    MAXIMIZED = 1 shl 2, STICKY = 1 shl 3, 
    FULLSCREEN = 1 shl 4, ABOVE = 1 shl 5, 
    BELOW = 1 shl 6, FOCUSED = 1 shl 7, 
    TILED = 1 shl 8
type 
  SettingAction* {.size: sizeof(cint), pure.} = enum 
    NEW, CHANGED, 
    DELETED
type 
  OwnerChange* {.size: sizeof(cint), pure.} = enum 
    NEW_OWNER, DESTROY, 
    CLOSE
type 
  EventAny* =  ptr EventAnyObj
  EventAnyPtr* = ptr EventAnyObj
  EventAnyObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8

type 
  EventExpose* =  ptr EventExposeObj
  EventExposePtr* = ptr EventExposeObj
  EventExposeObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    area*: RectangleObj
    region*: cairo.Region
    count*: gint

type 
  EventVisibility* =  ptr EventVisibilityObj
  EventVisibilityPtr* = ptr EventVisibilityObj
  EventVisibilityObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    state*: VisibilityState

type 
  EventMotion* =  ptr EventMotionObj
  EventMotionPtr* = ptr EventMotionObj
  EventMotionObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    time*: guint32
    x*: gdouble
    y*: gdouble
    axes*: ptr gdouble
    state*: guint
    is_hint*: gint16
    device*: Device
    x_root*: gdouble
    y_root*: gdouble

type 
  EventButton* =  ptr EventButtonObj
  EventButtonPtr* = ptr EventButtonObj
  EventButtonObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    time*: guint32
    x*: gdouble
    y*: gdouble
    axes*: ptr gdouble
    state*: guint
    button*: guint
    device*: Device
    x_root*: gdouble
    y_root*: gdouble

type 
  EventTouch* =  ptr EventTouchObj
  EventTouchPtr* = ptr EventTouchObj
  EventTouchObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    time*: guint32
    x*: gdouble
    y*: gdouble
    axes*: ptr gdouble
    state*: guint
    sequence*: EventSequence
    emulating_pointer*: gboolean
    device*: Device
    x_root*: gdouble
    y_root*: gdouble

type 
  EventScroll* =  ptr EventScrollObj
  EventScrollPtr* = ptr EventScrollObj
  EventScrollObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    time*: guint32
    x*: gdouble
    y*: gdouble
    state*: guint
    direction*: ScrollDirection
    device*: Device
    x_root*: gdouble
    y_root*: gdouble
    delta_x*: gdouble
    delta_y*: gdouble

type 
  EventKey* =  ptr EventKeyObj
  EventKeyPtr* = ptr EventKeyObj
  EventKeyObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    time*: guint32
    state*: guint
    keyval*: guint
    length*: gint
    string*: cstring
    hardware_keycode*: guint16
    group*: guint8
    is_modifier*: guint

type 
  EventCrossing* =  ptr EventCrossingObj
  EventCrossingPtr* = ptr EventCrossingObj
  EventCrossingObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    subwindow*: Window
    time*: guint32
    x*: gdouble
    y*: gdouble
    x_root*: gdouble
    y_root*: gdouble
    mode*: CrossingMode
    detail*: NotifyType
    focus*: gboolean
    state*: guint

type 
  EventFocus* =  ptr EventFocusObj
  EventFocusPtr* = ptr EventFocusObj
  EventFocusObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    `in`*: gint16

type 
  EventConfigure* =  ptr EventConfigureObj
  EventConfigurePtr* = ptr EventConfigureObj
  EventConfigureObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    x*: gint
    y*: gint
    width*: gint
    height*: gint

type 
  EventProperty* =  ptr EventPropertyObj
  EventPropertyPtr* = ptr EventPropertyObj
  EventPropertyObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    atom*: Atom
    time*: guint32
    state*: guint

type 
  EventSelection* =  ptr EventSelectionObj
  EventSelectionPtr* = ptr EventSelectionObj
  EventSelectionObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    selection*: Atom
    target*: Atom
    property*: Atom
    time*: guint32
    requestor*: Window

type 
  EventOwnerChange* =  ptr EventOwnerChangeObj
  EventOwnerChangePtr* = ptr EventOwnerChangeObj
  EventOwnerChangeObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    owner*: Window
    reason*: OwnerChange
    selection*: Atom
    time*: guint32
    selection_time*: guint32

type 
  EventProximity* =  ptr EventProximityObj
  EventProximityPtr* = ptr EventProximityObj
  EventProximityObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    time*: guint32
    device*: Device

type 
  EventSetting* =  ptr EventSettingObj
  EventSettingPtr* = ptr EventSettingObj
  EventSettingObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    action*: SettingAction
    name*: cstring

type 
  EventWindowState* =  ptr EventWindowStateObj
  EventWindowStatePtr* = ptr EventWindowStateObj
  EventWindowStateObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    changed_mask*: WindowState
    new_window_state*: WindowState

type 
  EventGrabBroken* =  ptr EventGrabBrokenObj
  EventGrabBrokenPtr* = ptr EventGrabBrokenObj
  EventGrabBrokenObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    keyboard*: gboolean
    implicit*: gboolean
    grab_window*: Window

type 
  EventDND* =  ptr EventDNDObj
  EventDNDPtr* = ptr EventDNDObj
  EventDNDObj* = object 
    `type`*: EventType
    window*: Window
    send_event*: gint8
    context*: DragContext
    time*: guint32
    x_root*: gshort
    y_root*: gshort

type 
  Event* =  ptr EventObj
  EventPtr* = ptr EventObj
  EventObj* = object  {.union.}
    `type`*: EventType
    any*: EventAnyObj
    expose*: EventExposeObj
    visibility*: EventVisibilityObj
    motion*: EventMotionObj
    button*: EventButtonObj
    touch*: EventTouchObj
    scroll*: EventScrollObj
    key*: EventKeyObj
    crossing*: EventCrossingObj
    focus_change*: EventFocusObj
    configure*: EventConfigureObj
    property*: EventPropertyObj
    selection*: EventSelectionObj
    owner_change*: EventOwnerChangeObj
    proximity*: EventProximityObj
    dnd*: EventDNDObj
    window_state*: EventWindowStateObj
    setting*: EventSettingObj
    grab_broken*: EventGrabBrokenObj
type 
  EventFunc* = proc (event: Event; data: gpointer) {.cdecl.}
type 
  FilterFunc* = proc (xevent: ptr XEvent; event: Event; 
                         data: gpointer): FilterReturn {.cdecl.}

proc event_get_type*(): GType {.importc: "gdk_event_get_type", libgdk.}
proc event_sequence_get_type*(): GType {.
    importc: "gdk_event_sequence_get_type", libgdk.}
proc events_pending*(): gboolean {.importc: "gdk_events_pending", 
    libgdk.}
proc event_get*(): Event {.importc: "gdk_event_get", libgdk.}
proc event_peek*(): Event {.importc: "gdk_event_peek", libgdk.}
proc put*(event: Event) {.importc: "gdk_event_put", 
    libgdk.}
proc event_new*(`type`: EventType): Event {.
    importc: "gdk_event_new", libgdk.}
proc copy*(event: Event): Event {.
    importc: "gdk_event_copy", libgdk.}
proc free*(event: Event) {.importc: "gdk_event_free", 
    libgdk.}
proc get_window*(event: Event): Window {.
    importc: "gdk_event_get_window", libgdk.}
proc window*(event: Event): Window {.
    importc: "gdk_event_get_window", libgdk.}
proc get_time*(event: Event): guint32 {.
    importc: "gdk_event_get_time", libgdk.}
proc time*(event: Event): guint32 {.
    importc: "gdk_event_get_time", libgdk.}
proc get_state*(event: Event; state: var ModifierType): gboolean {.
    importc: "gdk_event_get_state", libgdk.}
proc state*(event: Event; state: var ModifierType): gboolean {.
    importc: "gdk_event_get_state", libgdk.}
proc get_coords*(event: Event; x_win: var gdouble; 
                           y_win: var gdouble): gboolean {.
    importc: "gdk_event_get_coords", libgdk.}
proc coords*(event: Event; x_win: var gdouble; 
                           y_win: var gdouble): gboolean {.
    importc: "gdk_event_get_coords", libgdk.}
proc get_root_coords*(event: Event; x_root: var gdouble; 
                                y_root: var gdouble): gboolean {.
    importc: "gdk_event_get_root_coords", libgdk.}
proc root_coords*(event: Event; x_root: var gdouble; 
                                y_root: var gdouble): gboolean {.
    importc: "gdk_event_get_root_coords", libgdk.}
proc get_button*(event: Event; button: var guint): gboolean {.
    importc: "gdk_event_get_button", libgdk.}
proc button*(event: Event; button: var guint): gboolean {.
    importc: "gdk_event_get_button", libgdk.}
proc get_click_count*(event: Event; click_count: var guint): gboolean {.
    importc: "gdk_event_get_click_count", libgdk.}
proc click_count*(event: Event; click_count: var guint): gboolean {.
    importc: "gdk_event_get_click_count", libgdk.}
proc get_keyval*(event: Event; keyval: var guint): gboolean {.
    importc: "gdk_event_get_keyval", libgdk.}
proc keyval*(event: Event; keyval: var guint): gboolean {.
    importc: "gdk_event_get_keyval", libgdk.}
proc get_keycode*(event: Event; keycode: var guint16): gboolean {.
    importc: "gdk_event_get_keycode", libgdk.}
proc keycode*(event: Event; keycode: var guint16): gboolean {.
    importc: "gdk_event_get_keycode", libgdk.}
proc get_scroll_direction*(event: Event; 
                                     direction: var ScrollDirection): gboolean {.
    importc: "gdk_event_get_scroll_direction", libgdk.}
proc scroll_direction*(event: Event; 
                                     direction: var ScrollDirection): gboolean {.
    importc: "gdk_event_get_scroll_direction", libgdk.}
proc get_scroll_deltas*(event: Event; delta_x: var gdouble; 
                                  delta_y: var gdouble): gboolean {.
    importc: "gdk_event_get_scroll_deltas", libgdk.}
proc scroll_deltas*(event: Event; delta_x: var gdouble; 
                                  delta_y: var gdouble): gboolean {.
    importc: "gdk_event_get_scroll_deltas", libgdk.}
proc get_axis*(event: Event; axis_use: AxisUse; 
                         value: var gdouble): gboolean {.
    importc: "gdk_event_get_axis", libgdk.}
proc axis*(event: Event; axis_use: AxisUse; 
                         value: var gdouble): gboolean {.
    importc: "gdk_event_get_axis", libgdk.}
proc set_device*(event: Event; device: Device) {.
    importc: "gdk_event_set_device", libgdk.}
proc `device=`*(event: Event; device: Device) {.
    importc: "gdk_event_set_device", libgdk.}
proc get_device*(event: Event): Device {.
    importc: "gdk_event_get_device", libgdk.}
proc device*(event: Event): Device {.
    importc: "gdk_event_get_device", libgdk.}
proc set_source_device*(event: Event; device: Device) {.
    importc: "gdk_event_set_source_device", libgdk.}
proc `source_device=`*(event: Event; device: Device) {.
    importc: "gdk_event_set_source_device", libgdk.}
proc get_source_device*(event: Event): Device {.
    importc: "gdk_event_get_source_device", libgdk.}
proc source_device*(event: Event): Device {.
    importc: "gdk_event_get_source_device", libgdk.}
proc event_request_motions*(event: EventMotion) {.
    importc: "gdk_event_request_motions", libgdk.}
proc triggers_context_menu*(event: Event): gboolean {.
    importc: "gdk_event_triggers_context_menu", libgdk.}
proc events_get_distance*(event1: Event; event2: Event; 
                              distance: var gdouble): gboolean {.
    importc: "gdk_events_get_distance", libgdk.}
proc events_get_angle*(event1: Event; event2: Event; 
                           angle: var gdouble): gboolean {.
    importc: "gdk_events_get_angle", libgdk.}
proc events_get_center*(event1: Event; event2: Event; 
                            x: var gdouble; y: var gdouble): gboolean {.
    importc: "gdk_events_get_center", libgdk.}
proc event_handler_set*(`func`: EventFunc; data: gpointer; 
                            notify: GDestroyNotify) {.
    importc: "gdk_event_handler_set", libgdk.}
proc set_screen*(event: Event; screen: Screen) {.
    importc: "gdk_event_set_screen", libgdk.}
proc `screen=`*(event: Event; screen: Screen) {.
    importc: "gdk_event_set_screen", libgdk.}
proc get_screen*(event: Event): Screen {.
    importc: "gdk_event_get_screen", libgdk.}
proc screen*(event: Event): Screen {.
    importc: "gdk_event_get_screen", libgdk.}
proc get_event_sequence*(event: Event): EventSequence {.
    importc: "gdk_event_get_event_sequence", libgdk.}
proc event_sequence*(event: Event): EventSequence {.
    importc: "gdk_event_get_event_sequence", libgdk.}
proc get_event_type*(event: Event): EventType {.
    importc: "gdk_event_get_event_type", libgdk.}
proc event_type*(event: Event): EventType {.
    importc: "gdk_event_get_event_type", libgdk.}
proc set_show_events*(show_events: gboolean) {.
    importc: "gdk_set_show_events", libgdk.}
proc `show_events=`*(show_events: gboolean) {.
    importc: "gdk_set_show_events", libgdk.}
proc get_show_events*(): gboolean {.importc: "gdk_get_show_events", 
    libgdk.}
proc show_events*(): gboolean {.importc: "gdk_get_show_events", 
    libgdk.}
proc setting_get*(name: cstring; value: gobject.GValue): gboolean {.
    importc: "gdk_setting_get", libgdk.}

template gdk_device_manager*(o: expr): expr = 
  (g_type_check_instance_cast(o, device_manager_get_type(), DeviceManagerObj))

template gdk_is_device_manager*(o: expr): expr = 
  (g_type_check_instance_type(o, device_manager_get_type()))

proc device_manager_get_type*(): GType {.
    importc: "gdk_device_manager_get_type", libgdk.}
proc get_display*(device_manager: DeviceManager): Display {.
    importc: "gdk_device_manager_get_display", libgdk.}
proc display*(device_manager: DeviceManager): Display {.
    importc: "gdk_device_manager_get_display", libgdk.}
proc list_devices*(device_manager: DeviceManager; 
                                      `type`: DeviceType): glib.GList {.
    importc: "gdk_device_manager_list_devices", libgdk.}
proc get_client_pointer*(
    device_manager: DeviceManager): Device {.
    importc: "gdk_device_manager_get_client_pointer", libgdk.}
proc client_pointer*(
    device_manager: DeviceManager): Device {.
    importc: "gdk_device_manager_get_client_pointer", libgdk.}

template gdk_display*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, display_get_type(), DisplayObj))

template gdk_is_display*(obj: expr): expr = 
  (g_type_check_instance_type(obj, display_get_type()))

when not(defined(DISABLE_DEPRECATED)): 
  template gdk_display_object*(obj: expr): expr = 
    gdk_display(obj)

proc display_get_type*(): GType {.importc: "gdk_display_get_type", 
                                      libgdk.}
proc display_open*(display_name: cstring): Display {.
    importc: "gdk_display_open", libgdk.}
proc get_name*(display: Display): cstring {.
    importc: "gdk_display_get_name", libgdk.}
proc name*(display: Display): cstring {.
    importc: "gdk_display_get_name", libgdk.}
proc get_n_screens*(display: Display): gint {.
    importc: "gdk_display_get_n_screens", libgdk.}
proc n_screens*(display: Display): gint {.
    importc: "gdk_display_get_n_screens", libgdk.}
proc get_screen*(display: Display; screen_num: gint): Screen {.
    importc: "gdk_display_get_screen", libgdk.}
proc screen*(display: Display; screen_num: gint): Screen {.
    importc: "gdk_display_get_screen", libgdk.}
proc get_default_screen*(display: Display): Screen {.
    importc: "gdk_display_get_default_screen", libgdk.}
proc default_screen*(display: Display): Screen {.
    importc: "gdk_display_get_default_screen", libgdk.}
when not MULTIDEVICE_SAFE: # when not(defined(MULTIDEVICE_SAFE)): 
  proc pointer_ungrab*(display: Display; time: guint32) {.
      importc: "gdk_display_pointer_ungrab", libgdk.}
  proc keyboard_ungrab*(display: Display; time: guint32) {.
      importc: "gdk_display_keyboard_ungrab", libgdk.}
  proc pointer_is_grabbed*(display: Display): gboolean {.
      importc: "gdk_display_pointer_is_grabbed", libgdk.}
proc device_is_grabbed*(display: Display; 
                                    device: Device): gboolean {.
    importc: "gdk_display_device_is_grabbed", libgdk.}
proc beep*(display: Display) {.importc: "gdk_display_beep", 
    libgdk.}
proc sync*(display: Display) {.importc: "gdk_display_sync", 
    libgdk.}
proc flush*(display: Display) {.
    importc: "gdk_display_flush", libgdk.}
proc close*(display: Display) {.
    importc: "gdk_display_close", libgdk.}
proc is_closed*(display: Display): gboolean {.
    importc: "gdk_display_is_closed", libgdk.}
proc list_devices*(display: Display): glib.GList {.
    importc: "gdk_display_list_devices", libgdk.}
proc get_event*(display: Display): Event {.
    importc: "gdk_display_get_event", libgdk.}
proc event*(display: Display): Event {.
    importc: "gdk_display_get_event", libgdk.}
proc peek_event*(display: Display): Event {.
    importc: "gdk_display_peek_event", libgdk.}
proc put_event*(display: Display; event: Event) {.
    importc: "gdk_display_put_event", libgdk.}
proc has_pending*(display: Display): gboolean {.
    importc: "gdk_display_has_pending", libgdk.}
proc set_double_click_time*(display: Display; msec: guint) {.
    importc: "gdk_display_set_double_click_time", libgdk.}
proc `double_click_time=`*(display: Display; msec: guint) {.
    importc: "gdk_display_set_double_click_time", libgdk.}
proc set_double_click_distance*(display: Display; 
    distance: guint) {.importc: "gdk_display_set_double_click_distance", 
                       libgdk.}
proc `double_click_distance=`*(display: Display; 
    distance: guint) {.importc: "gdk_display_set_double_click_distance", 
                       libgdk.}
proc display_get_default*(): Display {.
    importc: "gdk_display_get_default", libgdk.}
when not MULTIDEVICE_SAFE: # when not(defined(MULTIDEVICE_SAFE)): 
  proc get_pointer*(display: Display; 
                                screen: var Screen; x: var gint; 
                                y: var gint; mask: var ModifierType) {.
      importc: "gdk_display_get_pointer", libgdk.}
  proc get_window_at_pointer*(display: Display; 
      win_x: var gint; win_y: var gint): Window {.
      importc: "gdk_display_get_window_at_pointer", libgdk.}
  proc window_at_pointer*(display: Display; 
      win_x: var gint; win_y: var gint): Window {.
      importc: "gdk_display_get_window_at_pointer", libgdk.}
  proc warp_pointer*(display: Display; 
                                 screen: Screen; x: gint; y: gint) {.
      importc: "gdk_display_warp_pointer", libgdk.}
proc display_open_default_libgtk_only*(): Display {.
    importc: "gdk_display_open_default_libgtk_only", libgdk.}
proc supports_cursor_alpha*(display: Display): gboolean {.
    importc: "gdk_display_supports_cursor_alpha", libgdk.}
proc supports_cursor_color*(display: Display): gboolean {.
    importc: "gdk_display_supports_cursor_color", libgdk.}
proc get_default_cursor_size*(display: Display): guint {.
    importc: "gdk_display_get_default_cursor_size", libgdk.}
proc default_cursor_size*(display: Display): guint {.
    importc: "gdk_display_get_default_cursor_size", libgdk.}
proc get_maximal_cursor_size*(display: Display; 
    width: var guint; height: var guint) {.
    importc: "gdk_display_get_maximal_cursor_size", libgdk.}
proc get_default_group*(display: Display): Window {.
    importc: "gdk_display_get_default_group", libgdk.}
proc default_group*(display: Display): Window {.
    importc: "gdk_display_get_default_group", libgdk.}
proc supports_selection_notification*(display: Display): gboolean {.
    importc: "gdk_display_supports_selection_notification", libgdk.}
proc request_selection_notification*(display: Display; 
    selection: Atom): gboolean {.importc: "gdk_display_request_selection_notification", 
                                    libgdk.}
proc supports_clipboard_persistence*(display: Display): gboolean {.
    importc: "gdk_display_supports_clipboard_persistence", libgdk.}
proc store_clipboard*(display: Display; 
                                  clipboard_window: Window; 
                                  time: guint32; targets: var Atom; 
                                  n_targets: gint) {.
    importc: "gdk_display_store_clipboard", libgdk.}
proc supports_shapes*(display: Display): gboolean {.
    importc: "gdk_display_supports_shapes", libgdk.}
proc supports_input_shapes*(display: Display): gboolean {.
    importc: "gdk_display_supports_input_shapes", libgdk.}
proc supports_composite*(display: Display): gboolean {.
    importc: "gdk_display_supports_composite", libgdk.}
proc notify_startup_complete*(display: Display; 
    startup_id: cstring) {.importc: "gdk_display_notify_startup_complete", 
                             libgdk.}
proc get_device_manager*(display: Display): DeviceManager {.
    importc: "gdk_display_get_device_manager", libgdk.}
proc device_manager*(display: Display): DeviceManager {.
    importc: "gdk_display_get_device_manager", libgdk.}
proc get_app_launch_context*(display: Display): AppLaunchContext {.
    importc: "gdk_display_get_app_launch_context", libgdk.}
proc app_launch_context*(display: Display): AppLaunchContext {.
    importc: "gdk_display_get_app_launch_context", libgdk.}

template gdk_screen*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, screen_get_type(), ScreenObj))

template gdk_is_screen*(obj: expr): expr = 
  (g_type_check_instance_type(obj, screen_get_type()))

proc screen_get_type*(): GType {.importc: "gdk_screen_get_type", 
                                     libgdk.}
proc get_system_visual*(screen: Screen): Visual {.
    importc: "gdk_screen_get_system_visual", libgdk.}
proc system_visual*(screen: Screen): Visual {.
    importc: "gdk_screen_get_system_visual", libgdk.}
proc get_rgba_visual*(screen: Screen): Visual {.
    importc: "gdk_screen_get_rgba_visual", libgdk.}
proc rgba_visual*(screen: Screen): Visual {.
    importc: "gdk_screen_get_rgba_visual", libgdk.}
proc is_composited*(screen: Screen): gboolean {.
    importc: "gdk_screen_is_composited", libgdk.}
proc get_root_window*(screen: Screen): Window {.
    importc: "gdk_screen_get_root_window", libgdk.}
proc root_window*(screen: Screen): Window {.
    importc: "gdk_screen_get_root_window", libgdk.}
proc get_display*(screen: Screen): Display {.
    importc: "gdk_screen_get_display", libgdk.}
proc display*(screen: Screen): Display {.
    importc: "gdk_screen_get_display", libgdk.}
proc get_number*(screen: Screen): gint {.
    importc: "gdk_screen_get_number", libgdk.}
proc number*(screen: Screen): gint {.
    importc: "gdk_screen_get_number", libgdk.}
proc get_width*(screen: Screen): gint {.
    importc: "gdk_screen_get_width", libgdk.}
proc width*(screen: Screen): gint {.
    importc: "gdk_screen_get_width", libgdk.}
proc get_height*(screen: Screen): gint {.
    importc: "gdk_screen_get_height", libgdk.}
proc height*(screen: Screen): gint {.
    importc: "gdk_screen_get_height", libgdk.}
proc get_width_mm*(screen: Screen): gint {.
    importc: "gdk_screen_get_width_mm", libgdk.}
proc width_mm*(screen: Screen): gint {.
    importc: "gdk_screen_get_width_mm", libgdk.}
proc get_height_mm*(screen: Screen): gint {.
    importc: "gdk_screen_get_height_mm", libgdk.}
proc height_mm*(screen: Screen): gint {.
    importc: "gdk_screen_get_height_mm", libgdk.}
proc list_visuals*(screen: Screen): glib.GList {.
    importc: "gdk_screen_list_visuals", libgdk.}
proc get_toplevel_windows*(screen: Screen): glib.GList {.
    importc: "gdk_screen_get_toplevel_windows", libgdk.}
proc toplevel_windows*(screen: Screen): glib.GList {.
    importc: "gdk_screen_get_toplevel_windows", libgdk.}
proc make_display_name*(screen: Screen): cstring {.
    importc: "gdk_screen_make_display_name", libgdk.}
proc get_n_monitors*(screen: Screen): gint {.
    importc: "gdk_screen_get_n_monitors", libgdk.}
proc n_monitors*(screen: Screen): gint {.
    importc: "gdk_screen_get_n_monitors", libgdk.}
proc get_primary_monitor*(screen: Screen): gint {.
    importc: "gdk_screen_get_primary_monitor", libgdk.}
proc primary_monitor*(screen: Screen): gint {.
    importc: "gdk_screen_get_primary_monitor", libgdk.}
proc get_monitor_geometry*(screen: Screen; 
                                      monitor_num: gint; 
                                      dest: var RectangleObj) {.
    importc: "gdk_screen_get_monitor_geometry", libgdk.}
proc get_monitor_workarea*(screen: Screen; 
                                      monitor_num: gint; 
                                      dest: var RectangleObj) {.
    importc: "gdk_screen_get_monitor_workarea", libgdk.}
proc get_monitor_at_point*(screen: Screen; x: gint; y: gint): gint {.
    importc: "gdk_screen_get_monitor_at_point", libgdk.}
proc monitor_at_point*(screen: Screen; x: gint; y: gint): gint {.
    importc: "gdk_screen_get_monitor_at_point", libgdk.}
proc get_monitor_at_window*(screen: Screen; 
    window: Window): gint {.importc: "gdk_screen_get_monitor_at_window", 
                                   libgdk.}
proc monitor_at_window*(screen: Screen; 
    window: Window): gint {.importc: "gdk_screen_get_monitor_at_window", 
                                   libgdk.}
proc get_monitor_width_mm*(screen: Screen; monitor_num: gint): gint {.
    importc: "gdk_screen_get_monitor_width_mm", libgdk.}
proc monitor_width_mm*(screen: Screen; monitor_num: gint): gint {.
    importc: "gdk_screen_get_monitor_width_mm", libgdk.}
proc get_monitor_height_mm*(screen: Screen; 
    monitor_num: gint): gint {.importc: "gdk_screen_get_monitor_height_mm", 
                               libgdk.}
proc monitor_height_mm*(screen: Screen; 
    monitor_num: gint): gint {.importc: "gdk_screen_get_monitor_height_mm", 
                               libgdk.}
proc get_monitor_plug_name*(screen: Screen; 
    monitor_num: gint): cstring {.importc: "gdk_screen_get_monitor_plug_name", 
                                    libgdk.}
proc monitor_plug_name*(screen: Screen; 
    monitor_num: gint): cstring {.importc: "gdk_screen_get_monitor_plug_name", 
                                    libgdk.}
proc get_monitor_scale_factor*(screen: Screen; 
    monitor_num: gint): gint {.importc: "gdk_screen_get_monitor_scale_factor", 
                               libgdk.}
proc monitor_scale_factor*(screen: Screen; 
    monitor_num: gint): gint {.importc: "gdk_screen_get_monitor_scale_factor", 
                               libgdk.}
proc screen_get_default*(): Screen {.
    importc: "gdk_screen_get_default", libgdk.}
proc get_setting*(screen: Screen; name: cstring; 
                             value: gobject.GValue): gboolean {.
    importc: "gdk_screen_get_setting", libgdk.}
proc setting*(screen: Screen; name: cstring; 
                             value: gobject.GValue): gboolean {.
    importc: "gdk_screen_get_setting", libgdk.}
proc set_font_options*(screen: Screen; 
                                  options: cairo.Font_options) {.
    importc: "gdk_screen_set_font_options", libgdk.}
proc `font_options=`*(screen: Screen; 
                                  options: cairo.Font_options) {.
    importc: "gdk_screen_set_font_options", libgdk.}
proc get_font_options*(screen: Screen): cairo.Font_options {.
    importc: "gdk_screen_get_font_options", libgdk.}
proc font_options*(screen: Screen): cairo.Font_options {.
    importc: "gdk_screen_get_font_options", libgdk.}
proc set_resolution*(screen: Screen; dpi: gdouble) {.
    importc: "gdk_screen_set_resolution", libgdk.}
proc `resolution=`*(screen: Screen; dpi: gdouble) {.
    importc: "gdk_screen_set_resolution", libgdk.}
proc get_resolution*(screen: Screen): gdouble {.
    importc: "gdk_screen_get_resolution", libgdk.}
proc resolution*(screen: Screen): gdouble {.
    importc: "gdk_screen_get_resolution", libgdk.}
proc get_active_window*(screen: Screen): Window {.
    importc: "gdk_screen_get_active_window", libgdk.}
proc active_window*(screen: Screen): Window {.
    importc: "gdk_screen_get_active_window", libgdk.}
proc get_window_stack*(screen: Screen): glib.GList {.
    importc: "gdk_screen_get_window_stack", libgdk.}
proc window_stack*(screen: Screen): glib.GList {.
    importc: "gdk_screen_get_window_stack", libgdk.}

template gdk_app_launch_context*(o: expr): expr = 
  (g_type_check_instance_cast(o, app_launch_context_get_type(), 
                              AppLaunchContextObj))

template gdk_is_app_launch_context*(o: expr): expr = 
  (g_type_check_instance_type(o, app_launch_context_get_type()))

proc app_launch_context_get_type*(): GType {.
    importc: "gdk_app_launch_context_get_type", libgdk.}
proc app_launch_context_new*(): AppLaunchContext {.
    importc: "gdk_app_launch_context_new", libgdk.}
proc set_display*(context: AppLaunchContext; 
    display: Display) {.importc: "gdk_app_launch_context_set_display", 
                               libgdk.}
proc `display=`*(context: AppLaunchContext; 
    display: Display) {.importc: "gdk_app_launch_context_set_display", 
                               libgdk.}
proc set_screen*(context: AppLaunchContext; 
    screen: Screen) {.importc: "gdk_app_launch_context_set_screen", 
                             libgdk.}
proc `screen=`*(context: AppLaunchContext; 
    screen: Screen) {.importc: "gdk_app_launch_context_set_screen", 
                             libgdk.}
proc set_desktop*(context: AppLaunchContext; 
    desktop: gint) {.importc: "gdk_app_launch_context_set_desktop", 
                     libgdk.}
proc `desktop=`*(context: AppLaunchContext; 
    desktop: gint) {.importc: "gdk_app_launch_context_set_desktop", 
                     libgdk.}
proc set_timestamp*(context: AppLaunchContext; 
    timestamp: guint32) {.importc: "gdk_app_launch_context_set_timestamp", 
                          libgdk.}
proc `timestamp=`*(context: AppLaunchContext; 
    timestamp: guint32) {.importc: "gdk_app_launch_context_set_timestamp", 
                          libgdk.}
proc set_icon*(context: AppLaunchContext; 
                                      icon: gio.GIcon) {.
    importc: "gdk_app_launch_context_set_icon", libgdk.}
proc `icon=`*(context: AppLaunchContext; 
                                      icon: gio.GIcon) {.
    importc: "gdk_app_launch_context_set_icon", libgdk.}
proc set_icon_name*(context: AppLaunchContext; 
    icon_name: cstring) {.importc: "gdk_app_launch_context_set_icon_name", 
                          libgdk.}
proc `icon_name=`*(context: AppLaunchContext; 
    icon_name: cstring) {.importc: "gdk_app_launch_context_set_icon_name", 
                          libgdk.}

type 
  Color* =  ptr ColorObj
  ColorPtr* = ptr ColorObj
  ColorObj* = object 
    pixel*: guint32
    red*: guint16
    green*: guint16
    blue*: guint16

proc color_get_type*(): GType {.importc: "gdk_color_get_type", libgdk.}
proc copy*(color: Color): Color {.
    importc: "gdk_color_copy", libgdk.}
proc free*(color: Color) {.importc: "gdk_color_free", 
    libgdk.}
proc hash*(color: Color): guint {.importc: "gdk_color_hash", 
    libgdk.}
proc equal*(colora: Color; colorb: Color): gboolean {.
    importc: "gdk_color_equal", libgdk.}
proc color_parse*(spec: cstring; color: Color): gboolean {.
    importc: "gdk_color_parse", libgdk.}
proc to_string*(color: Color): cstring {.
    importc: "gdk_color_to_string", libgdk.}

type 
  RGBA* =  ptr RGBAObj
  RGBAPtr* = ptr RGBAObj
  RGBAObj* = object 
    red*: gdouble
    green*: gdouble
    blue*: gdouble
    alpha*: gdouble

proc rgba_get_type*(): GType {.importc: "gdk_rgba_get_type", libgdk.}
proc copy*(rgba: RGBA): RGBA {.
    importc: "gdk_rgba_copy", libgdk.}
proc free*(rgba: RGBA) {.importc: "gdk_rgba_free", libgdk.}
proc rgba_hash*(p: gconstpointer): guint {.importc: "gdk_rgba_hash", 
    libgdk.}
proc rgba_equal*(p1: gconstpointer; p2: gconstpointer): gboolean {.
    importc: "gdk_rgba_equal", libgdk.}
proc parse*(rgba: RGBA; spec: cstring): gboolean {.
    importc: "gdk_rgba_parse", libgdk.}
proc to_string*(rgba: RGBA): cstring {.
    importc: "gdk_rgba_to_string", libgdk.}

proc pixbuf_get_from_window*(window: Window; src_x: gint; 
                                 src_y: gint; width: gint; height: gint): gdk_pixbuf.GdkPixbuf {.
    importc: "gdk_pixbuf_get_from_window", libgdk.}
proc pixbuf_get_from_surface*(surface: cairo.Surface; src_x: gint; 
                                  src_y: gint; width: gint; height: gint): gdk_pixbuf.GdkPixbuf {.
    importc: "gdk_pixbuf_get_from_surface", libgdk.}

proc cairo_create*(window: Window): cairo.Context {.
    importc: "gdk_cairo_create", libgdk.}
proc cairo_get_clip_rectangle*(cr: cairo.Context; rect: Rectangle): gboolean {.
    importc: "gdk_cairo_get_clip_rectangle", libgdk.}
proc cairo_set_source_rgba*(cr: cairo.Context; rgba: RGBA) {.
    importc: "gdk_cairo_set_source_rgba", libgdk.}
proc cairo_set_source_pixbuf*(cr: cairo.Context; pixbuf: gdk_pixbuf.GdkPixbuf; 
                                  pixbuf_x: gdouble; pixbuf_y: gdouble) {.
    importc: "gdk_cairo_set_source_pixbuf", libgdk.}
proc cairo_set_source_window*(cr: cairo.Context; window: Window; 
                                  x: gdouble; y: gdouble) {.
    importc: "gdk_cairo_set_source_window", libgdk.}
proc cairo_rectangle*(cr: cairo.Context; rectangle: Rectangle) {.
    importc: "gdk_cairo_rectangle", libgdk.}
proc cairo_region*(cr: cairo.Context; region: cairo.Region) {.
    importc: "gdk_cairo_region", libgdk.}
proc cairo_region_create_from_surface*(surface: cairo.Surface): cairo.Region {.
    importc: "gdk_cairo_region_create_from_surface", libgdk.}
proc cairo_set_source_color*(cr: cairo.Context; color: Color) {.
    importc: "gdk_cairo_set_source_color", libgdk.}
proc cairo_surface_create_from_pixbuf*(pixbuf: gdk_pixbuf.GdkPixbuf; scale: cint; 
    for_window: Window): cairo.Surface {.
    importc: "gdk_cairo_surface_create_from_pixbuf", libgdk.}
proc cairo_draw_from_gl*(cr: cairo.Context; window: Window; 
                             source: cint; source_type: cint; 
                             buffer_scale: cint; x: cint; y: cint; 
                             width: cint; height: cint) {.
    importc: "gdk_cairo_draw_from_gl", libgdk.}

template gdk_cursor*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, cursor_get_type(), CursorObj))

template gdk_is_cursor*(obj: expr): expr = 
  (g_type_check_instance_type(obj, cursor_get_type()))

type 
  CursorType* {.size: sizeof(cint), pure.} = enum 
    BLANK_CURSOR = - 2, CURSOR_IS_PIXMAP = - 1, X_CURSOR = 0, 
    ARROW = 2, BASED_ARROW_DOWN = 4, BASED_ARROW_UP = 6, 
    BOAT = 8, BOGOSITY = 10, BOTTOM_LEFT_CORNER = 12, 
    BOTTOM_RIGHT_CORNER = 14, BOTTOM_SIDE = 16, BOTTOM_TEE = 18, 
    BOX_SPIRAL = 20, CENTER_PTR = 22, CIRCLE = 24, CLOCK = 26, 
    COFFEE_MUG = 28, CROSS = 30, CROSS_REVERSE = 32, 
    CROSSHAIR = 34, DIAMOND_CROSS = 36, DOT = 38, DOTBOX = 40, 
    DOUBLE_ARROW = 42, DRAFT_LARGE = 44, DRAFT_SMALL = 46, 
    DRAPED_BOX = 48, EXCHANGE = 50, FLEUR = 52, GOBBLER = 54, 
    GUMBY = 56, HAND1 = 58, HAND2 = 60, HEART = 62, 
    ICON = 64, IRON_CROSS = 66, LEFT_PTR = 68, LEFT_SIDE = 70, 
    LEFT_TEE = 72, LEFTBUTTON = 74, LL_ANGLE = 76, 
    LR_ANGLE = 78, MAN = 80, MIDDLEBUTTON = 82, MOUSE = 84, 
    PENCIL = 86, PIRATE = 88, PLUS = 90, QUESTION_ARROW = 92, 
    RIGHT_PTR = 94, RIGHT_SIDE = 96, RIGHT_TEE = 98, 
    RIGHTBUTTON = 100, RTL_LOGO = 102, SAILBOAT = 104, 
    SB_DOWN_ARROW = 106, SB_H_DOUBLE_ARROW = 108, 
    SB_LEFT_ARROW = 110, SB_RIGHT_ARROW = 112, SB_UP_ARROW = 114, 
    SB_V_DOUBLE_ARROW = 116, SHUTTLE = 118, SIZING = 120, 
    SPIDER = 122, SPRAYCAN = 124, STAR = 126, TARGET = 128, 
    TCROSS = 130, TOP_LEFT_ARROW = 132, TOP_LEFT_CORNER = 134, 
    TOP_RIGHT_CORNER = 136, TOP_SIDE = 138, TOP_TEE = 140, 
    TREK = 142, UL_ANGLE = 144, UMBRELLA = 146, 
    UR_ANGLE = 148, WATCH = 150, XTERM = 152, LAST_CURSOR
proc cursor_get_type*(): GType {.importc: "gdk_cursor_get_type", 
                                     libgdk.}
proc cursor_new_for_display*(display: Display; 
                                 cursor_type: CursorType): Cursor {.
    importc: "gdk_cursor_new_for_display", libgdk.}
proc cursor_new*(cursor_type: CursorType): Cursor {.
    importc: "gdk_cursor_new", libgdk.}
proc cursor_new_from_pixbuf*(display: Display; 
                                 pixbuf: gdk_pixbuf.GdkPixbuf; x: gint; y: gint): Cursor {.
    importc: "gdk_cursor_new_from_pixbuf", libgdk.}
proc cursor_new_from_surface*(display: Display; 
                                  surface: cairo.Surface; x: gdouble; 
                                  y: gdouble): Cursor {.
    importc: "gdk_cursor_new_from_surface", libgdk.}
proc cursor_new_from_name*(display: Display; name: cstring): Cursor {.
    importc: "gdk_cursor_new_from_name", libgdk.}
proc get_display*(cursor: Cursor): Display {.
    importc: "gdk_cursor_get_display", libgdk.}
proc display*(cursor: Cursor): Display {.
    importc: "gdk_cursor_get_display", libgdk.}
proc `ref`*(cursor: Cursor): Cursor {.
    importc: "gdk_cursor_ref", libgdk.}
proc unref*(cursor: Cursor) {.importc: "gdk_cursor_unref", 
    libgdk.}
proc get_image*(cursor: Cursor): gdk_pixbuf.GdkPixbuf {.
    importc: "gdk_cursor_get_image", libgdk.}
proc image*(cursor: Cursor): gdk_pixbuf.GdkPixbuf {.
    importc: "gdk_cursor_get_image", libgdk.}
proc get_surface*(cursor: Cursor; x_hot: var gdouble; 
                             y_hot: var gdouble): cairo.Surface {.
    importc: "gdk_cursor_get_surface", libgdk.}
proc surface*(cursor: Cursor; x_hot: var gdouble; 
                             y_hot: var gdouble): cairo.Surface {.
    importc: "gdk_cursor_get_surface", libgdk.}
proc get_cursor_type*(cursor: Cursor): CursorType {.
    importc: "gdk_cursor_get_cursor_type", libgdk.}
proc cursor_type*(cursor: Cursor): CursorType {.
    importc: "gdk_cursor_get_cursor_type", libgdk.}

template gdk_display_manager*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, display_manager_get_type(), 
                              DisplayManagerObj))

template gdk_is_display_manager*(obj: expr): expr = 
  (g_type_check_instance_type(obj, display_manager_get_type()))

proc display_manager_get_type*(): GType {.
    importc: "gdk_display_manager_get_type", libgdk.}
proc display_manager_get*(): DisplayManager {.
    importc: "gdk_display_manager_get", libgdk.}
proc get_default_display*(manager: DisplayManager): Display {.
    importc: "gdk_display_manager_get_default_display", libgdk.}
proc default_display*(manager: DisplayManager): Display {.
    importc: "gdk_display_manager_get_default_display", libgdk.}
proc set_default_display*(manager: DisplayManager; 
    display: Display) {.importc: "gdk_display_manager_set_default_display", 
                               libgdk.}
proc `default_display=`*(manager: DisplayManager; 
    display: Display) {.importc: "gdk_display_manager_set_default_display", 
                               libgdk.}
proc list_displays*(manager: DisplayManager): glib.GSList {.
    importc: "gdk_display_manager_list_displays", libgdk.}
proc open_display*(manager: DisplayManager; 
    name: cstring): Display {.
    importc: "gdk_display_manager_open_display", libgdk.}

proc cursor_type_get_type*(): GType {.importc: "gdk_cursor_type_get_type", 
    libgdk.}
proc input_source_get_type*(): GType {.
    importc: "gdk_input_source_get_type", libgdk.}
proc input_mode_get_type*(): GType {.importc: "gdk_input_mode_get_type", 
    libgdk.}
proc axis_use_get_type*(): GType {.importc: "gdk_axis_use_get_type", 
    libgdk.}
proc device_type_get_type*(): GType {.importc: "gdk_device_type_get_type", 
    libgdk.}
proc drag_action_get_type*(): GType {.importc: "gdk_drag_action_get_type", 
    libgdk.}
proc drag_protocol_get_type*(): GType {.
    importc: "gdk_drag_protocol_get_type", libgdk.}
proc filter_return_get_type*(): GType {.
    importc: "gdk_filter_return_get_type", libgdk.}
proc event_type_get_type*(): GType {.importc: "gdk_event_type_get_type", 
    libgdk.}
proc visibility_state_get_type*(): GType {.
    importc: "gdk_visibility_state_get_type", libgdk.}
proc scroll_direction_get_type*(): GType {.
    importc: "gdk_scroll_direction_get_type", libgdk.}
proc notify_type_get_type*(): GType {.importc: "gdk_notify_type_get_type", 
    libgdk.}
proc crossing_mode_get_type*(): GType {.
    importc: "gdk_crossing_mode_get_type", libgdk.}
proc property_state_get_type*(): GType {.
    importc: "gdk_property_state_get_type", libgdk.}
proc window_state_get_type*(): GType {.
    importc: "gdk_window_state_get_type", libgdk.}
proc setting_action_get_type*(): GType {.
    importc: "gdk_setting_action_get_type", libgdk.}
proc owner_change_get_type*(): GType {.
    importc: "gdk_owner_change_get_type", libgdk.}
proc frame_clock_phase_get_type*(): GType {.
    importc: "gdk_frame_clock_phase_get_type", libgdk.}
proc prop_mode_get_type*(): GType {.importc: "gdk_prop_mode_get_type", 
    libgdk.}
proc byte_order_get_type*(): GType {.importc: "gdk_byte_order_get_type", 
    libgdk.}
proc modifier_type_get_type*(): GType {.
    importc: "gdk_modifier_type_get_type", libgdk.}
proc modifier_intent_get_type*(): GType {.
    importc: "gdk_modifier_intent_get_type", libgdk.}
proc status_get_type*(): GType {.importc: "gdk_status_get_type", 
                                     libgdk.}
proc grab_status_get_type*(): GType {.importc: "gdk_grab_status_get_type", 
    libgdk.}
proc grab_ownership_get_type*(): GType {.
    importc: "gdk_grab_ownership_get_type", libgdk.}
proc event_mask_get_type*(): GType {.importc: "gdk_event_mask_get_type", 
    libgdk.}
proc gl_profile_get_type*(): GType {.importc: "gdk_gl_profile_get_type", 
    libgdk.}
proc gl_error_get_type*(): GType {.importc: "gdk_gl_error_get_type", 
    libgdk.}
proc visual_type_get_type*(): GType {.importc: "gdk_visual_type_get_type", 
    libgdk.}
proc window_window_class_get_type*(): GType {.
    importc: "gdk_window_window_class_get_type", libgdk.}
proc window_type_get_type*(): GType {.importc: "gdk_window_type_get_type", 
    libgdk.}
proc window_attributes_type_get_type*(): GType {.
    importc: "gdk_window_attributes_type_get_type", libgdk.}
proc window_hints_get_type*(): GType {.
    importc: "gdk_window_hints_get_type", libgdk.}
proc window_type_hint_get_type*(): GType {.
    importc: "gdk_window_type_hint_get_type", libgdk.}
proc wm_decoration_get_type*(): GType {.
    importc: "gdk_wm_decoration_get_type", libgdk.}
proc wm_function_get_type*(): GType {.importc: "gdk_wm_function_get_type", 
    libgdk.}
proc gravity_get_type*(): GType {.importc: "gdk_gravity_get_type", 
                                      libgdk.}
proc window_edge_get_type*(): GType {.importc: "gdk_window_edge_get_type", 
    libgdk.}
proc fullscreen_mode_get_type*(): GType {.
    importc: "gdk_fullscreen_mode_get_type", libgdk.}

type 
  FrameTimings* =  ptr FrameTimingsObj
  FrameTimingsPtr* = ptr FrameTimingsObj
  FrameTimingsObj* = object 
  
proc frame_timings_get_type*(): GType {.
    importc: "gdk_frame_timings_get_type", libgdk.}
proc `ref`*(timings: FrameTimings): FrameTimings {.
    importc: "gdk_frame_timings_ref", libgdk.}
proc unref*(timings: FrameTimings) {.
    importc: "gdk_frame_timings_unref", libgdk.}
proc get_frame_counter*(timings: FrameTimings): gint64 {.
    importc: "gdk_frame_timings_get_frame_counter", libgdk.}
proc frame_counter*(timings: FrameTimings): gint64 {.
    importc: "gdk_frame_timings_get_frame_counter", libgdk.}
proc get_complete*(timings: FrameTimings): gboolean {.
    importc: "gdk_frame_timings_get_complete", libgdk.}
proc complete*(timings: FrameTimings): gboolean {.
    importc: "gdk_frame_timings_get_complete", libgdk.}
proc get_frame_time*(timings: FrameTimings): gint64 {.
    importc: "gdk_frame_timings_get_frame_time", libgdk.}
proc frame_time*(timings: FrameTimings): gint64 {.
    importc: "gdk_frame_timings_get_frame_time", libgdk.}
proc get_presentation_time*(timings: FrameTimings): gint64 {.
    importc: "gdk_frame_timings_get_presentation_time", libgdk.}
proc presentation_time*(timings: FrameTimings): gint64 {.
    importc: "gdk_frame_timings_get_presentation_time", libgdk.}
proc get_refresh_interval*(timings: FrameTimings): gint64 {.
    importc: "gdk_frame_timings_get_refresh_interval", libgdk.}
proc refresh_interval*(timings: FrameTimings): gint64 {.
    importc: "gdk_frame_timings_get_refresh_interval", libgdk.}
proc get_predicted_presentation_time*(
    timings: FrameTimings): gint64 {.
    importc: "gdk_frame_timings_get_predicted_presentation_time", libgdk.}
proc predicted_presentation_time*(
    timings: FrameTimings): gint64 {.
    importc: "gdk_frame_timings_get_predicted_presentation_time", libgdk.}

template gdk_frame_clock*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, frame_clock_get_type(), FrameClockObj))

template gdk_frame_clock_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, frame_clock_get_type(), FrameClockClass))

template gdk_is_frame_clock*(obj: expr): expr = 
  (g_type_check_instance_type(obj, frame_clock_get_type()))

template gdk_is_frame_clock_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, frame_clock_get_type()))

template gdk_frame_clock_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, frame_clock_get_type(), FrameClockClass))

type 
  FrameClock* =  ptr FrameClockObj
  FrameClockPtr* = ptr FrameClockObj
  FrameClockObj*{.final.} = object of GObject 
  
type 
  FrameClockPhase* {.size: sizeof(cint), pure.} = enum 
    NONE = 0, 
    FLUSH_EVENTS = 1 shl 0, 
    BEFORE_PAINT = 1 shl 1, 
    UPDATE = 1 shl 2, 
    LAYOUT = 1 shl 3, 
    PAINT = 1 shl 4, 
    RESUME_EVENTS = 1 shl 5, 
    AFTER_PAINT = 1 shl 6
proc frame_clock_get_type*(): GType {.importc: "gdk_frame_clock_get_type", 
    libgdk.}
proc get_frame_time*(frame_clock: FrameClock): gint64 {.
    importc: "gdk_frame_clock_get_frame_time", libgdk.}
proc frame_time*(frame_clock: FrameClock): gint64 {.
    importc: "gdk_frame_clock_get_frame_time", libgdk.}
proc request_phase*(frame_clock: FrameClock; 
                                    phase: FrameClockPhase) {.
    importc: "gdk_frame_clock_request_phase", libgdk.}
proc begin_updating*(frame_clock: FrameClock) {.
    importc: "gdk_frame_clock_begin_updating", libgdk.}
proc end_updating*(frame_clock: FrameClock) {.
    importc: "gdk_frame_clock_end_updating", libgdk.}
proc get_frame_counter*(frame_clock: FrameClock): gint64 {.
    importc: "gdk_frame_clock_get_frame_counter", libgdk.}
proc frame_counter*(frame_clock: FrameClock): gint64 {.
    importc: "gdk_frame_clock_get_frame_counter", libgdk.}
proc get_history_start*(frame_clock: FrameClock): gint64 {.
    importc: "gdk_frame_clock_get_history_start", libgdk.}
proc history_start*(frame_clock: FrameClock): gint64 {.
    importc: "gdk_frame_clock_get_history_start", libgdk.}
proc get_timings*(frame_clock: FrameClock; 
                                  frame_counter: gint64): FrameTimings {.
    importc: "gdk_frame_clock_get_timings", libgdk.}
proc timings*(frame_clock: FrameClock; 
                                  frame_counter: gint64): FrameTimings {.
    importc: "gdk_frame_clock_get_timings", libgdk.}
proc get_current_timings*(frame_clock: FrameClock): FrameTimings {.
    importc: "gdk_frame_clock_get_current_timings", libgdk.}
proc current_timings*(frame_clock: FrameClock): FrameTimings {.
    importc: "gdk_frame_clock_get_current_timings", libgdk.}
proc get_refresh_info*(frame_clock: FrameClock; 
    base_time: gint64; refresh_interval_return: var gint64; 
    presentation_time_return: var gint64) {.
    importc: "gdk_frame_clock_get_refresh_info", libgdk.}

template gdk_gl_context*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, gl_context_get_type(), GLContextObj))

template gdk_is_gl_context*(obj: expr): expr = 
  (g_type_check_instance_type(obj, gl_context_get_type()))

proc gl_error_quark*(): GQuark {.importc: "gdk_gl_error_quark", 
                                     libgdk.}
proc gl_context_get_type*(): GType {.importc: "gdk_gl_context_get_type", 
    libgdk.}
proc get_display*(context: GLContext): Display {.
    importc: "gdk_gl_context_get_display", libgdk.}
proc display*(context: GLContext): Display {.
    importc: "gdk_gl_context_get_display", libgdk.}
proc get_window*(context: GLContext): Window {.
    importc: "gdk_gl_context_get_window", libgdk.}
proc window*(context: GLContext): Window {.
    importc: "gdk_gl_context_get_window", libgdk.}
proc get_profile*(context: GLContext): GLProfile {.
    importc: "gdk_gl_context_get_profile", libgdk.}
proc profile*(context: GLContext): GLProfile {.
    importc: "gdk_gl_context_get_profile", libgdk.}
proc get_shared_context*(context: GLContext): GLContext {.
    importc: "gdk_gl_context_get_shared_context", libgdk.}
proc shared_context*(context: GLContext): GLContext {.
    importc: "gdk_gl_context_get_shared_context", libgdk.}
proc set_required_version*(context: GLContext; 
    major: cint; minor: cint) {.importc: "gdk_gl_context_set_required_version", 
                                libgdk.}
proc `required_version=`*(context: GLContext; 
    major: cint; minor: cint) {.importc: "gdk_gl_context_set_required_version", 
                                libgdk.}
proc get_required_version*(context: GLContext; 
    major: var cint; minor: var cint) {.
    importc: "gdk_gl_context_get_required_version", libgdk.}
proc set_debug_enabled*(context: GLContext; 
    enabled: gboolean) {.importc: "gdk_gl_context_set_debug_enabled", 
                         libgdk.}
proc `debug_enabled=`*(context: GLContext; 
    enabled: gboolean) {.importc: "gdk_gl_context_set_debug_enabled", 
                         libgdk.}
proc get_debug_enabled*(context: GLContext): gboolean {.
    importc: "gdk_gl_context_get_debug_enabled", libgdk.}
proc debug_enabled*(context: GLContext): gboolean {.
    importc: "gdk_gl_context_get_debug_enabled", libgdk.}
proc set_forward_compatible*(context: GLContext; 
    compatible: gboolean) {.importc: "gdk_gl_context_set_forward_compatible", 
                            libgdk.}
proc `forward_compatible=`*(context: GLContext; 
    compatible: gboolean) {.importc: "gdk_gl_context_set_forward_compatible", 
                            libgdk.}
proc get_forward_compatible*(context: GLContext): gboolean {.
    importc: "gdk_gl_context_get_forward_compatible", libgdk.}
proc forward_compatible*(context: GLContext): gboolean {.
    importc: "gdk_gl_context_get_forward_compatible", libgdk.}
proc realize*(context: GLContext; error: var glib.GError): gboolean {.
    importc: "gdk_gl_context_realize", libgdk.}
proc make_current*(context: GLContext) {.
    importc: "gdk_gl_context_make_current", libgdk.}
proc gl_context_get_current*(): GLContext {.
    importc: "gdk_gl_context_get_current", libgdk.}
proc gl_context_clear_current*() {.
    importc: "gdk_gl_context_clear_current", libgdk.}

type 
  KeymapKey* =  ptr KeymapKeyObj
  KeymapKeyPtr* = ptr KeymapKeyObj
  KeymapKeyObj* = object 
    keycode*: guint
    group*: gint
    level*: gint

template gdk_keymap*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, keymap_get_type(), KeymapObj))

template gdk_is_keymap*(obj: expr): expr = 
  (g_type_check_instance_type(obj, keymap_get_type()))

proc keymap_get_type*(): GType {.importc: "gdk_keymap_get_type", 
                                     libgdk.}
proc keymap_get_default*(): Keymap {.
    importc: "gdk_keymap_get_default", libgdk.}
proc keymap_get_for_display*(display: Display): Keymap {.
    importc: "gdk_keymap_get_for_display", libgdk.}
proc lookup_key*(keymap: Keymap; key: KeymapKey): guint {.
    importc: "gdk_keymap_lookup_key", libgdk.}
proc translate_keyboard_state*(keymap: Keymap; 
    hardware_keycode: guint; state: ModifierType; group: gint; 
    keyval: var guint; effective_group: var gint; level: var gint; 
    consumed_modifiers: var ModifierType): gboolean {.
    importc: "gdk_keymap_translate_keyboard_state", libgdk.}
proc get_entries_for_keyval*(keymap: Keymap; keyval: guint; 
    keys: var KeymapKey; n_keys: var gint): gboolean {.
    importc: "gdk_keymap_get_entries_for_keyval", libgdk.}
proc entries_for_keyval*(keymap: Keymap; keyval: guint; 
    keys: var KeymapKey; n_keys: var gint): gboolean {.
    importc: "gdk_keymap_get_entries_for_keyval", libgdk.}
proc get_entries_for_keycode*(keymap: Keymap; 
    hardware_keycode: guint; keys: var KeymapKey; 
    keyvals: var ptr guint; n_entries: var gint): gboolean {.
    importc: "gdk_keymap_get_entries_for_keycode", libgdk.}
proc entries_for_keycode*(keymap: Keymap; 
    hardware_keycode: guint; keys: var KeymapKey; 
    keyvals: var ptr guint; n_entries: var gint): gboolean {.
    importc: "gdk_keymap_get_entries_for_keycode", libgdk.}
proc get_direction*(keymap: Keymap): pango.Direction {.
    importc: "gdk_keymap_get_direction", libgdk.}
proc direction*(keymap: Keymap): pango.Direction {.
    importc: "gdk_keymap_get_direction", libgdk.}
proc have_bidi_layouts*(keymap: Keymap): gboolean {.
    importc: "gdk_keymap_have_bidi_layouts", libgdk.}
proc get_caps_lock_state*(keymap: Keymap): gboolean {.
    importc: "gdk_keymap_get_caps_lock_state", libgdk.}
proc caps_lock_state*(keymap: Keymap): gboolean {.
    importc: "gdk_keymap_get_caps_lock_state", libgdk.}
proc get_num_lock_state*(keymap: Keymap): gboolean {.
    importc: "gdk_keymap_get_num_lock_state", libgdk.}
proc num_lock_state*(keymap: Keymap): gboolean {.
    importc: "gdk_keymap_get_num_lock_state", libgdk.}
proc get_modifier_state*(keymap: Keymap): guint {.
    importc: "gdk_keymap_get_modifier_state", libgdk.}
proc modifier_state*(keymap: Keymap): guint {.
    importc: "gdk_keymap_get_modifier_state", libgdk.}
proc add_virtual_modifiers*(keymap: Keymap; 
    state: var ModifierType) {.importc: "gdk_keymap_add_virtual_modifiers", 
                                  libgdk.}
proc map_virtual_modifiers*(keymap: Keymap; 
    state: var ModifierType): gboolean {.
    importc: "gdk_keymap_map_virtual_modifiers", libgdk.}
proc get_modifier_mask*(keymap: Keymap; 
                                   intent: ModifierIntent): ModifierType {.
    importc: "gdk_keymap_get_modifier_mask", libgdk.}
proc modifier_mask*(keymap: Keymap; 
                                   intent: ModifierIntent): ModifierType {.
    importc: "gdk_keymap_get_modifier_mask", libgdk.}
proc keyval_name*(keyval: guint): cstring {.importc: "gdk_keyval_name", 
    libgdk.}
proc keyval_from_name*(keyval_name: cstring): guint {.
    importc: "gdk_keyval_from_name", libgdk.}
proc keyval_convert_case*(symbol: guint; lower: var guint; 
                              upper: var guint) {.
    importc: "gdk_keyval_convert_case", libgdk.}
proc keyval_to_upper*(keyval: guint): guint {.
    importc: "gdk_keyval_to_upper", libgdk.}
proc keyval_to_lower*(keyval: guint): guint {.
    importc: "gdk_keyval_to_lower", libgdk.}
proc keyval_is_upper*(keyval: guint): gboolean {.
    importc: "gdk_keyval_is_upper", libgdk.}
proc keyval_is_lower*(keyval: guint): gboolean {.
    importc: "gdk_keyval_is_lower", libgdk.}
proc keyval_to_unicode*(keyval: guint): guint32 {.
    importc: "gdk_keyval_to_unicode", libgdk.}
proc unicode_to_keyval*(wc: guint32): guint {.
    importc: "gdk_unicode_to_keyval", libgdk.}

proc parse_args*(argc: var gint; argv: var cstringArray) {.
    importc: "gdk_parse_args", libgdk.}
proc init*(argc: var gint; argv: var cstringArray) {.importc: "gdk_init", 
    libgdk.}
proc init_check*(argc: var gint; argv: var cstringArray): gboolean {.
    importc: "gdk_init_check", libgdk.}
proc add_option_entries_libgtk_only*(group: glib.GOptionGroup) {.
    importc: "gdk_add_option_entries_libgtk_only", libgdk.}
proc pre_parse_libgtk_only*() {.importc: "gdk_pre_parse_libgtk_only", 
                                    libgdk.}
proc get_program_class*(): cstring {.importc: "gdk_get_program_class", 
    libgdk.}
proc program_class*(): cstring {.importc: "gdk_get_program_class", 
    libgdk.}
proc set_program_class*(program_class: cstring) {.
    importc: "gdk_set_program_class", libgdk.}
proc `program_class=`*(program_class: cstring) {.
    importc: "gdk_set_program_class", libgdk.}
proc notify_startup_complete*() {.importc: "gdk_notify_startup_complete", 
                                      libgdk.}
proc notify_startup_complete_with_id*(startup_id: cstring) {.
    importc: "gdk_notify_startup_complete_with_id", libgdk.}
proc error_trap_push*() {.importc: "gdk_error_trap_push", libgdk.}
proc error_trap_pop*(): gint {.importc: "gdk_error_trap_pop", libgdk.}
proc error_trap_pop_ignored*() {.importc: "gdk_error_trap_pop_ignored", 
                                     libgdk.}
proc get_display_arg_name*(): cstring {.
    importc: "gdk_get_display_arg_name", libgdk.}
proc display_arg_name*(): cstring {.
    importc: "gdk_get_display_arg_name", libgdk.}
proc get_display*(): cstring {.importc: "gdk_get_display", libgdk.}
proc display*(): cstring {.importc: "gdk_get_display", libgdk.}
when not MULTIDEVICE_SAFE: # when not(defined(MULTIDEVICE_SAFE)): 
  proc pointer_grab*(window: Window; owner_events: gboolean; 
                         event_mask: EventMask; confine_to: Window; 
                         cursor: Cursor; time: guint32): GrabStatus {.
      importc: "gdk_pointer_grab", libgdk.}
  proc keyboard_grab*(window: Window; owner_events: gboolean; 
                          time: guint32): GrabStatus {.
      importc: "gdk_keyboard_grab", libgdk.}
when not MULTIDEVICE_SAFE: # when not(defined(MULTIDEVICE_SAFE)): 
  proc pointer_ungrab*(time: guint32) {.importc: "gdk_pointer_ungrab", 
      libgdk.}
  proc keyboard_ungrab*(time: guint32) {.importc: "gdk_keyboard_ungrab", 
      libgdk.}
  proc pointer_is_grabbed*(): gboolean {.
      importc: "gdk_pointer_is_grabbed", libgdk.}
proc screen_width*(): gint {.importc: "gdk_screen_width", libgdk.}
proc screen_height*(): gint {.importc: "gdk_screen_height", libgdk.}
proc screen_width_mm*(): gint {.importc: "gdk_screen_width_mm", 
                                    libgdk.}
proc screen_height_mm*(): gint {.importc: "gdk_screen_height_mm", 
                                     libgdk.}
proc set_double_click_time*(msec: guint) {.
    importc: "gdk_set_double_click_time", libgdk.}
proc `double_click_time=`*(msec: guint) {.
    importc: "gdk_set_double_click_time", libgdk.}
proc beep*() {.importc: "gdk_beep", libgdk.}
proc flush*() {.importc: "gdk_flush", libgdk.}
proc disable_multidevice*() {.importc: "gdk_disable_multidevice", 
                                  libgdk.}
proc set_allowed_backends*(backends: cstring) {.
    importc: "gdk_set_allowed_backends", libgdk.}
proc `allowed_backends=`*(backends: cstring) {.
    importc: "gdk_set_allowed_backends", libgdk.}

proc pango_context_get_for_screen*(screen: Screen): pango.Context {.
    importc: "gdk_pango_context_get_for_screen", libgdk.}
proc pango_context_get*(): pango.Context {.
    importc: "gdk_pango_context_get", libgdk.}
proc pango_layout_line_get_clip_region*(line: pango.LayoutLine; 
    x_origin: gint; y_origin: gint; index_ranges: var gint; n_ranges: gint): cairo.Region {.
    importc: "gdk_pango_layout_line_get_clip_region", libgdk.}
proc pango_layout_get_clip_region*(layout: pango.Layout; 
    x_origin: gint; y_origin: gint; index_ranges: var gint; n_ranges: gint): cairo.Region {.
    importc: "gdk_pango_layout_get_clip_region", libgdk.}

type 
  PropMode* {.size: sizeof(cint), pure.} = enum 
    REPLACE, PREPEND, APPEND
proc atom_intern*(atom_name: cstring; only_if_exists: gboolean): Atom {.
    importc: "gdk_atom_intern", libgdk.}
proc atom_intern_static_string*(atom_name: cstring): Atom {.
    importc: "gdk_atom_intern_static_string", libgdk.}
proc name*(atom: Atom): cstring {.importc: "gdk_atom_name", 
    libgdk.}
proc property_get*(window: Window; property: Atom; 
                       `type`: Atom; offset: gulong; length: gulong; 
                       pdelete: gint; actual_property_type: var Atom; 
                       actual_format: var gint; actual_length: var gint; 
                       data: var ptr guchar): gboolean {.
    importc: "gdk_property_get", libgdk.}
proc property_change*(window: Window; property: Atom; 
                          `type`: Atom; format: gint; mode: PropMode; 
                          data: var guchar; nelements: gint) {.
    importc: "gdk_property_change", libgdk.}
proc property_delete*(window: Window; property: Atom) {.
    importc: "gdk_property_delete", libgdk.}
proc text_property_to_utf8_list_for_display*(display: Display; 
    encoding: Atom; format: gint; text: var guchar; length: gint; 
    list: var cstringArray): gint {.importc: "gdk_text_property_to_utf8_list_for_display", 
                                     libgdk.}
proc utf8_to_string_target*(str: cstring): cstring {.
    importc: "gdk_utf8_to_string_target", libgdk.}

proc intersect*(src1: Rectangle; src2: Rectangle; 
                              dest: Rectangle): gboolean {.
    importc: "gdk_rectangle_intersect", libgdk.}
proc union*(src1: Rectangle; src2: Rectangle; 
                          dest: Rectangle) {.
    importc: "gdk_rectangle_union", libgdk.}
proc rectangle_get_type*(): GType {.importc: "gdk_rectangle_get_type", 
    libgdk.}

template gdk_selection_primary*(): expr = 
  gdk_make_atom(1)

template gdk_selection_secondary*(): expr = 
  gdk_make_atom(2)

template gdk_selection_clipboard*(): expr = 
  gdk_make_atom(69)

template gdk_target_bitmap*(): expr = 
  gdk_make_atom(5)

template gdk_target_colormap*(): expr = 
  gdk_make_atom(7)

template gdk_target_drawable*(): expr = 
  gdk_make_atom(17)

template gdk_target_pixmap*(): expr = 
  gdk_make_atom(20)

template gdk_target_string*(): expr = 
  gdk_make_atom(31)

template gdk_selection_type_atom*(): expr = 
  gdk_make_atom(4)

template gdk_selection_type_bitmap*(): expr = 
  gdk_make_atom(5)

template gdk_selection_type_colormap*(): expr = 
  gdk_make_atom(7)

template gdk_selection_type_drawable*(): expr = 
  gdk_make_atom(17)

template gdk_selection_type_integer*(): expr = 
  gdk_make_atom(19)

template gdk_selection_type_pixmap*(): expr = 
  gdk_make_atom(20)

template gdk_selection_type_window*(): expr = 
  gdk_make_atom(33)

template gdk_selection_type_string*(): expr = 
  gdk_make_atom(31)

proc selection_owner_set*(owner: Window; selection: Atom; 
                              time: guint32; send_event: gboolean): gboolean {.
    importc: "gdk_selection_owner_set", libgdk.}
proc selection_owner_get*(selection: Atom): Window {.
    importc: "gdk_selection_owner_get", libgdk.}
proc selection_owner_set_for_display*(display: Display; 
    owner: Window; selection: Atom; time: guint32; 
    send_event: gboolean): gboolean {.importc: "gdk_selection_owner_set_for_display", 
                                      libgdk.}
proc selection_owner_get_for_display*(display: Display; 
    selection: Atom): Window {.
    importc: "gdk_selection_owner_get_for_display", libgdk.}
proc selection_convert*(requestor: Window; selection: Atom; 
                            target: Atom; time: guint32) {.
    importc: "gdk_selection_convert", libgdk.}
proc selection_property_get*(requestor: Window; 
                                 data: var ptr guchar; prop_type: var Atom; 
                                 prop_format: var gint): gint {.
    importc: "gdk_selection_property_get", libgdk.}
proc selection_send_notify*(requestor: Window; selection: Atom; 
                                target: Atom; property: Atom; 
                                time: guint32) {.
    importc: "gdk_selection_send_notify", libgdk.}
proc selection_send_notify_for_display*(display: Display; 
    requestor: Window; selection: Atom; target: Atom; 
    property: Atom; time: guint32) {.
    importc: "gdk_selection_send_notify_for_display", libgdk.}

type 
  WindowWindowClass* {.size: sizeof(cint), pure.} = enum 
    INPUT_OUTPUT, INPUT_ONLY
type 
  WindowType* {.size: sizeof(cint), pure.} = enum 
    ROOT, TOPLEVEL, CHILD, TEMP, 
    FOREIGN, OFFSCREEN, SUBSURFACE
type 
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
type 
  WindowTypeHint* {.size: sizeof(cint), pure.} = enum 
    NORMAL, DIALOG, 
    MENU, TOOLBAR, 
    SPLASHSCREEN, UTILITY, 
    DOCK, DESKTOP, 
    DROPDOWN_MENU, POPUP_MENU, 
    TOOLTIP, NOTIFICATION, 
    COMBO, DND
type 
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
type 
  Gravity* {.size: sizeof(cint), pure.} = enum 
    NORTH_WEST = 1, NORTH, NORTH_EAST, 
    WEST, CENTER, EAST, 
    SOUTH_WEST, SOUTH, SOUTH_EAST, 
    STATIC
type 
  WindowEdge* {.size: sizeof(cint), pure.} = enum 
    NORTH_WEST, NORTH, 
    NORTH_EAST, WEST, EAST, 
    SOUTH_WEST, SOUTH, 
    SOUTH_EAST
type 
  FullscreenMode* {.size: sizeof(cint), pure.} = enum 
    ON_CURRENT_MONITOR, ON_ALL_MONITORS
type 
  WindowAttr* =  ptr WindowAttrObj
  WindowAttrPtr* = ptr WindowAttrObj
  WindowAttrObj* = object 
    title*: cstring
    event_mask*: gint
    x*: gint
    y*: gint
    width*: gint
    height*: gint
    wclass*: WindowWindowClass
    visual*: Visual
    window_type*: WindowType
    cursor*: Cursor
    wmclass_name*: cstring
    wmclass_class*: cstring
    override_redirect*: gboolean
    type_hint*: WindowTypeHint

type 
  Geometry* =  ptr GeometryObj
  GeometryPtr* = ptr GeometryObj
  GeometryObj* = object 
    min_width*: gint
    min_height*: gint
    max_width*: gint
    max_height*: gint
    base_width*: gint
    base_height*: gint
    width_inc*: gint
    height_inc*: gint
    min_aspect*: gdouble
    max_aspect*: gdouble
    win_gravity*: Gravity

template gdk_window*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, window_get_type(), WindowObj))

template gdk_window_class*(klass: expr): expr = 
  (g_type_check_class_cast(klass, window_get_type(), WindowClassObj))

template gdk_is_window*(obj: expr): expr = 
  (g_type_check_instance_type(obj, window_get_type()))

template gdk_is_window_class*(klass: expr): expr = 
  (g_type_check_class_type(klass, window_get_type()))

template gdk_window_get_class*(obj: expr): expr = 
  (g_type_instance_get_class(obj, window_get_type(), WindowClassObj))

type 
  WindowClass* =  ptr WindowClassObj
  WindowClassPtr* = ptr WindowClassObj
  WindowClassObj*{.final.} = object of GObjectClassObj
    pick_embedded_child*: proc (window: Window; x: gdouble; y: gdouble): Window {.cdecl.}
    to_embedder*: proc (window: Window; offscreen_x: gdouble; 
                        offscreen_y: gdouble; embedder_x: var gdouble; 
                        embedder_y: var gdouble) {.cdecl.}
    from_embedder*: proc (window: Window; embedder_x: gdouble; 
                          embedder_y: gdouble; offscreen_x: var gdouble; 
                          offscreen_y: var gdouble) {.cdecl.}
    create_surface*: proc (window: Window; width: gint; height: gint): cairo.Surface {.cdecl.}
    gdk_reserved1: proc () {.cdecl.}
    gdk_reserved2: proc () {.cdecl.}
    gdk_reserved3: proc () {.cdecl.}
    gdk_reserved4: proc () {.cdecl.}
    gdk_reserved5: proc () {.cdecl.}
    gdk_reserved6: proc () {.cdecl.}
    gdk_reserved7: proc () {.cdecl.}
    gdk_reserved8: proc () {.cdecl.}

proc window_get_type*(): GType {.importc: "gdk_window_get_type", 
                                     libgdk.}
proc new*(parent: Window; attributes: WindowAttr; 
                     attributes_mask: gint): Window {.
    importc: "gdk_window_new", libgdk.}
proc destroy*(window: Window) {.
    importc: "gdk_window_destroy", libgdk.}
proc get_window_type*(window: Window): WindowType {.
    importc: "gdk_window_get_window_type", libgdk.}
proc window_type*(window: Window): WindowType {.
    importc: "gdk_window_get_window_type", libgdk.}
proc is_destroyed*(window: Window): gboolean {.
    importc: "gdk_window_is_destroyed", libgdk.}
proc get_visual*(window: Window): Visual {.
    importc: "gdk_window_get_visual", libgdk.}
proc visual*(window: Window): Visual {.
    importc: "gdk_window_get_visual", libgdk.}
proc get_screen*(window: Window): Screen {.
    importc: "gdk_window_get_screen", libgdk.}
proc screen*(window: Window): Screen {.
    importc: "gdk_window_get_screen", libgdk.}
proc get_display*(window: Window): Display {.
    importc: "gdk_window_get_display", libgdk.}
proc display*(window: Window): Display {.
    importc: "gdk_window_get_display", libgdk.}
when not MULTIDEVICE_SAFE: # when not(defined(MULTIDEVICE_SAFE)): 
  proc window_at_pointer*(win_x: var gint; win_y: var gint): Window {.
      importc: "gdk_window_at_pointer", libgdk.}
proc show*(window: Window) {.importc: "gdk_window_show", 
    libgdk.}
proc hide*(window: Window) {.importc: "gdk_window_hide", 
    libgdk.}
proc withdraw*(window: Window) {.
    importc: "gdk_window_withdraw", libgdk.}
proc show_unraised*(window: Window) {.
    importc: "gdk_window_show_unraised", libgdk.}
proc move*(window: Window; x: gint; y: gint) {.
    importc: "gdk_window_move", libgdk.}
proc resize*(window: Window; width: gint; height: gint) {.
    importc: "gdk_window_resize", libgdk.}
proc move_resize*(window: Window; x: gint; y: gint; 
                             width: gint; height: gint) {.
    importc: "gdk_window_move_resize", libgdk.}
proc reparent*(window: Window; new_parent: Window; 
                          x: gint; y: gint) {.importc: "gdk_window_reparent", 
    libgdk.}
proc `raise`*(window: Window) {.importc: "gdk_window_raise", 
    libgdk.}
proc lower*(window: Window) {.importc: "gdk_window_lower", 
    libgdk.}
proc restack*(window: Window; sibling: Window; 
                         above: gboolean) {.importc: "gdk_window_restack", 
    libgdk.}
proc focus*(window: Window; timestamp: guint32) {.
    importc: "gdk_window_focus", libgdk.}
proc set_user_data*(window: Window; user_data: gpointer) {.
    importc: "gdk_window_set_user_data", libgdk.}
proc `user_data=`*(window: Window; user_data: gpointer) {.
    importc: "gdk_window_set_user_data", libgdk.}
proc set_override_redirect*(window: Window; 
    override_redirect: gboolean) {.importc: "gdk_window_set_override_redirect", 
                                   libgdk.}
proc `override_redirect=`*(window: Window; 
    override_redirect: gboolean) {.importc: "gdk_window_set_override_redirect", 
                                   libgdk.}
proc get_accept_focus*(window: Window): gboolean {.
    importc: "gdk_window_get_accept_focus", libgdk.}
proc accept_focus*(window: Window): gboolean {.
    importc: "gdk_window_get_accept_focus", libgdk.}
proc set_accept_focus*(window: Window; 
                                  accept_focus: gboolean) {.
    importc: "gdk_window_set_accept_focus", libgdk.}
proc `accept_focus=`*(window: Window; 
                                  accept_focus: gboolean) {.
    importc: "gdk_window_set_accept_focus", libgdk.}
proc get_focus_on_map*(window: Window): gboolean {.
    importc: "gdk_window_get_focus_on_map", libgdk.}
proc focus_on_map*(window: Window): gboolean {.
    importc: "gdk_window_get_focus_on_map", libgdk.}
proc set_focus_on_map*(window: Window; 
                                  focus_on_map: gboolean) {.
    importc: "gdk_window_set_focus_on_map", libgdk.}
proc `focus_on_map=`*(window: Window; 
                                  focus_on_map: gboolean) {.
    importc: "gdk_window_set_focus_on_map", libgdk.}
proc add_filter*(window: Window; function: FilterFunc; 
                            data: gpointer) {.
    importc: "gdk_window_add_filter", libgdk.}
proc remove_filter*(window: Window; function: FilterFunc; 
                               data: gpointer) {.
    importc: "gdk_window_remove_filter", libgdk.}
proc scroll*(window: Window; dx: gint; dy: gint) {.
    importc: "gdk_window_scroll", libgdk.}
proc move_region*(window: Window; 
                             region: cairo.Region; dx: gint; dy: gint) {.
    importc: "gdk_window_move_region", libgdk.}
proc ensure_native*(window: Window): gboolean {.
    importc: "gdk_window_ensure_native", libgdk.}
proc shape_combine_region*(window: Window; 
                                      shape_region: cairo.Region; 
                                      offset_x: gint; offset_y: gint) {.
    importc: "gdk_window_shape_combine_region", libgdk.}
proc set_child_shapes*(window: Window) {.
    importc: "gdk_window_set_child_shapes", libgdk.}
proc `child_shapes=`*(window: Window) {.
    importc: "gdk_window_set_child_shapes", libgdk.}
proc get_composited*(window: Window): gboolean {.
    importc: "gdk_window_get_composited", libgdk.}
proc composited*(window: Window): gboolean {.
    importc: "gdk_window_get_composited", libgdk.}
proc set_composited*(window: Window; composited: gboolean) {.
    importc: "gdk_window_set_composited", libgdk.}
proc `composited=`*(window: Window; composited: gboolean) {.
    importc: "gdk_window_set_composited", libgdk.}
proc merge_child_shapes*(window: Window) {.
    importc: "gdk_window_merge_child_shapes", libgdk.}
proc input_shape_combine_region*(window: Window; 
    shape_region: cairo.Region; offset_x: gint; offset_y: gint) {.
    importc: "gdk_window_input_shape_combine_region", libgdk.}
proc set_child_input_shapes*(window: Window) {.
    importc: "gdk_window_set_child_input_shapes", libgdk.}
proc `child_input_shapes=`*(window: Window) {.
    importc: "gdk_window_set_child_input_shapes", libgdk.}
proc merge_child_input_shapes*(window: Window) {.
    importc: "gdk_window_merge_child_input_shapes", libgdk.}
proc is_visible*(window: Window): gboolean {.
    importc: "gdk_window_is_visible", libgdk.}
proc is_viewable*(window: Window): gboolean {.
    importc: "gdk_window_is_viewable", libgdk.}
proc is_input_only*(window: Window): gboolean {.
    importc: "gdk_window_is_input_only", libgdk.}
proc is_shaped*(window: Window): gboolean {.
    importc: "gdk_window_is_shaped", libgdk.}
proc get_state*(window: Window): WindowState {.
    importc: "gdk_window_get_state", libgdk.}
proc state*(window: Window): WindowState {.
    importc: "gdk_window_get_state", libgdk.}
proc set_static_gravities*(window: Window; 
                                      use_static: gboolean): gboolean {.
    importc: "gdk_window_set_static_gravities", libgdk.}
type 
  WindowInvalidateHandlerFunc* = proc (window: Window; 
      region: cairo.Region) {.cdecl.}
proc set_invalidate_handler*(window: Window; 
    handler: WindowInvalidateHandlerFunc) {.
    importc: "gdk_window_set_invalidate_handler", libgdk.}
proc `invalidate_handler=`*(window: Window; 
    handler: WindowInvalidateHandlerFunc) {.
    importc: "gdk_window_set_invalidate_handler", libgdk.}
proc has_native*(window: Window): gboolean {.
    importc: "gdk_window_has_native", libgdk.}
proc set_type_hint*(window: Window; hint: WindowTypeHint) {.
    importc: "gdk_window_set_type_hint", libgdk.}
proc `type_hint=`*(window: Window; hint: WindowTypeHint) {.
    importc: "gdk_window_set_type_hint", libgdk.}
proc get_type_hint*(window: Window): WindowTypeHint {.
    importc: "gdk_window_get_type_hint", libgdk.}
proc type_hint*(window: Window): WindowTypeHint {.
    importc: "gdk_window_get_type_hint", libgdk.}
proc get_modal_hint*(window: Window): gboolean {.
    importc: "gdk_window_get_modal_hint", libgdk.}
proc modal_hint*(window: Window): gboolean {.
    importc: "gdk_window_get_modal_hint", libgdk.}
proc set_modal_hint*(window: Window; modal: gboolean) {.
    importc: "gdk_window_set_modal_hint", libgdk.}
proc `modal_hint=`*(window: Window; modal: gboolean) {.
    importc: "gdk_window_set_modal_hint", libgdk.}
proc set_skip_taskbar_hint*(window: Window; 
    skips_taskbar: gboolean) {.importc: "gdk_window_set_skip_taskbar_hint", 
                               libgdk.}
proc `skip_taskbar_hint=`*(window: Window; 
    skips_taskbar: gboolean) {.importc: "gdk_window_set_skip_taskbar_hint", 
                               libgdk.}
proc set_skip_pager_hint*(window: Window; 
                                     skips_pager: gboolean) {.
    importc: "gdk_window_set_skip_pager_hint", libgdk.}
proc `skip_pager_hint=`*(window: Window; 
                                     skips_pager: gboolean) {.
    importc: "gdk_window_set_skip_pager_hint", libgdk.}
proc set_urgency_hint*(window: Window; urgent: gboolean) {.
    importc: "gdk_window_set_urgency_hint", libgdk.}
proc `urgency_hint=`*(window: Window; urgent: gboolean) {.
    importc: "gdk_window_set_urgency_hint", libgdk.}
proc set_geometry_hints*(window: Window; 
                                    geometry: Geometry; 
                                    geom_mask: WindowHints) {.
    importc: "gdk_window_set_geometry_hints", libgdk.}
proc `geometry_hints=`*(window: Window; 
                                    geometry: Geometry; 
                                    geom_mask: WindowHints) {.
    importc: "gdk_window_set_geometry_hints", libgdk.}
proc get_clip_region*(window: Window): cairo.Region {.
    importc: "gdk_window_get_clip_region", libgdk.}
proc clip_region*(window: Window): cairo.Region {.
    importc: "gdk_window_get_clip_region", libgdk.}
proc get_visible_region*(window: Window): cairo.Region {.
    importc: "gdk_window_get_visible_region", libgdk.}
proc visible_region*(window: Window): cairo.Region {.
    importc: "gdk_window_get_visible_region", libgdk.}
proc begin_paint_rect*(window: Window; 
                                  rectangle: Rectangle) {.
    importc: "gdk_window_begin_paint_rect", libgdk.}
proc mark_paint_from_clip*(window: Window; cr: cairo.Context) {.
    importc: "gdk_window_mark_paint_from_clip", libgdk.}
proc begin_paint_region*(window: Window; 
                                    region: cairo.Region) {.
    importc: "gdk_window_begin_paint_region", libgdk.}
proc end_paint*(window: Window) {.
    importc: "gdk_window_end_paint", libgdk.}
proc flush*(window: Window) {.importc: "gdk_window_flush", 
    libgdk.}
proc set_title*(window: Window; title: cstring) {.
    importc: "gdk_window_set_title", libgdk.}
proc `title=`*(window: Window; title: cstring) {.
    importc: "gdk_window_set_title", libgdk.}
proc set_role*(window: Window; role: cstring) {.
    importc: "gdk_window_set_role", libgdk.}
proc `role=`*(window: Window; role: cstring) {.
    importc: "gdk_window_set_role", libgdk.}
proc set_startup_id*(window: Window; startup_id: cstring) {.
    importc: "gdk_window_set_startup_id", libgdk.}
proc `startup_id=`*(window: Window; startup_id: cstring) {.
    importc: "gdk_window_set_startup_id", libgdk.}
proc set_transient_for*(window: Window; 
                                   parent: Window) {.
    importc: "gdk_window_set_transient_for", libgdk.}
proc `transient_for=`*(window: Window; 
                                   parent: Window) {.
    importc: "gdk_window_set_transient_for", libgdk.}
proc set_background*(window: Window; color: Color) {.
    importc: "gdk_window_set_background", libgdk.}
proc `background=`*(window: Window; color: Color) {.
    importc: "gdk_window_set_background", libgdk.}
proc set_background_rgba*(window: Window; rgba: RGBA) {.
    importc: "gdk_window_set_background_rgba", libgdk.}
proc `background_rgba=`*(window: Window; rgba: RGBA) {.
    importc: "gdk_window_set_background_rgba", libgdk.}
proc set_background_pattern*(window: Window; 
    pattern: cairo.Pattern) {.importc: "gdk_window_set_background_pattern", 
                                    libgdk.}
proc `background_pattern=`*(window: Window; 
    pattern: cairo.Pattern) {.importc: "gdk_window_set_background_pattern", 
                                    libgdk.}
proc get_background_pattern*(window: Window): cairo.Pattern {.
    importc: "gdk_window_get_background_pattern", libgdk.}
proc background_pattern*(window: Window): cairo.Pattern {.
    importc: "gdk_window_get_background_pattern", libgdk.}
proc set_cursor*(window: Window; cursor: Cursor) {.
    importc: "gdk_window_set_cursor", libgdk.}
proc `cursor=`*(window: Window; cursor: Cursor) {.
    importc: "gdk_window_set_cursor", libgdk.}
proc get_cursor*(window: Window): Cursor {.
    importc: "gdk_window_get_cursor", libgdk.}
proc cursor*(window: Window): Cursor {.
    importc: "gdk_window_get_cursor", libgdk.}
proc set_device_cursor*(window: Window; 
                                   device: Device; 
                                   cursor: Cursor) {.
    importc: "gdk_window_set_device_cursor", libgdk.}
proc `device_cursor=`*(window: Window; 
                                   device: Device; 
                                   cursor: Cursor) {.
    importc: "gdk_window_set_device_cursor", libgdk.}
proc get_device_cursor*(window: Window; 
                                   device: Device): Cursor {.
    importc: "gdk_window_get_device_cursor", libgdk.}
proc device_cursor*(window: Window; 
                                   device: Device): Cursor {.
    importc: "gdk_window_get_device_cursor", libgdk.}
proc get_user_data*(window: Window; data: var gpointer) {.
    importc: "gdk_window_get_user_data", libgdk.}
proc get_geometry*(window: Window; x: var gint; y: var gint; 
                              width: var gint; height: var gint) {.
    importc: "gdk_window_get_geometry", libgdk.}
proc get_width*(window: Window): cint {.
    importc: "gdk_window_get_width", libgdk.}
proc width*(window: Window): cint {.
    importc: "gdk_window_get_width", libgdk.}
proc get_height*(window: Window): cint {.
    importc: "gdk_window_get_height", libgdk.}
proc height*(window: Window): cint {.
    importc: "gdk_window_get_height", libgdk.}
proc get_position*(window: Window; x: var gint; y: var gint) {.
    importc: "gdk_window_get_position", libgdk.}
proc get_origin*(window: Window; x: var gint; y: var gint): gint {.
    importc: "gdk_window_get_origin", libgdk.}
proc origin*(window: Window; x: var gint; y: var gint): gint {.
    importc: "gdk_window_get_origin", libgdk.}
proc get_root_coords*(window: Window; x: gint; y: gint; 
                                 root_x: var gint; root_y: var gint) {.
    importc: "gdk_window_get_root_coords", libgdk.}
proc coords_to_parent*(window: Window; x: gdouble; 
                                  y: gdouble; parent_x: var gdouble; 
                                  parent_y: var gdouble) {.
    importc: "gdk_window_coords_to_parent", libgdk.}
proc coords_from_parent*(window: Window; parent_x: gdouble; 
                                    parent_y: gdouble; x: var gdouble; 
                                    y: var gdouble) {.
    importc: "gdk_window_coords_from_parent", libgdk.}
proc get_root_origin*(window: Window; x: var gint; 
                                 y: var gint) {.
    importc: "gdk_window_get_root_origin", libgdk.}
proc get_frame_extents*(window: Window; 
                                   rect: var RectangleObj) {.
    importc: "gdk_window_get_frame_extents", libgdk.}
proc get_scale_factor*(window: Window): gint {.
    importc: "gdk_window_get_scale_factor", libgdk.}
proc scale_factor*(window: Window): gint {.
    importc: "gdk_window_get_scale_factor", libgdk.}
when not MULTIDEVICE_SAFE: # when not(defined(MULTIDEVICE_SAFE)): 
  proc get_pointer*(window: Window; x: var gint; 
                               y: var gint; mask: var ModifierType): Window {.
      importc: "gdk_window_get_pointer", libgdk.}
  proc pointer*(window: Window; x: var gint; 
                               y: var gint; mask: var ModifierType): Window {.
      importc: "gdk_window_get_pointer", libgdk.}
proc get_device_position*(window: Window; 
                                     device: Device; x: var gint; 
                                     y: var gint; mask: var ModifierType): Window {.
    importc: "gdk_window_get_device_position", libgdk.}
proc device_position*(window: Window; 
                                     device: Device; x: var gint; 
                                     y: var gint; mask: var ModifierType): Window {.
    importc: "gdk_window_get_device_position", libgdk.}
proc get_device_position_double*(window: Window; 
    device: Device; x: var gdouble; y: var gdouble; 
    mask: var ModifierType): Window {.
    importc: "gdk_window_get_device_position_double", libgdk.}
proc device_position_double*(window: Window; 
    device: Device; x: var gdouble; y: var gdouble; 
    mask: var ModifierType): Window {.
    importc: "gdk_window_get_device_position_double", libgdk.}
proc get_parent*(window: Window): Window {.
    importc: "gdk_window_get_parent", libgdk.}
proc parent*(window: Window): Window {.
    importc: "gdk_window_get_parent", libgdk.}
proc get_toplevel*(window: Window): Window {.
    importc: "gdk_window_get_toplevel", libgdk.}
proc toplevel*(window: Window): Window {.
    importc: "gdk_window_get_toplevel", libgdk.}
proc get_effective_parent*(window: Window): Window {.
    importc: "gdk_window_get_effective_parent", libgdk.}
proc effective_parent*(window: Window): Window {.
    importc: "gdk_window_get_effective_parent", libgdk.}
proc get_effective_toplevel*(window: Window): Window {.
    importc: "gdk_window_get_effective_toplevel", libgdk.}
proc effective_toplevel*(window: Window): Window {.
    importc: "gdk_window_get_effective_toplevel", libgdk.}
proc get_children*(window: Window): glib.GList {.
    importc: "gdk_window_get_children", libgdk.}
proc children*(window: Window): glib.GList {.
    importc: "gdk_window_get_children", libgdk.}
proc peek_children*(window: Window): glib.GList {.
    importc: "gdk_window_peek_children", libgdk.}
proc get_children_with_user_data*(window: Window; 
    user_data: gpointer): glib.GList {.importc: "gdk_window_get_children_with_user_data", 
                                      libgdk.}
proc children_with_user_data*(window: Window; 
    user_data: gpointer): glib.GList {.importc: "gdk_window_get_children_with_user_data", 
                                      libgdk.}
proc get_events*(window: Window): EventMask {.
    importc: "gdk_window_get_events", libgdk.}
proc events*(window: Window): EventMask {.
    importc: "gdk_window_get_events", libgdk.}
proc set_events*(window: Window; event_mask: EventMask) {.
    importc: "gdk_window_set_events", libgdk.}
proc `events=`*(window: Window; event_mask: EventMask) {.
    importc: "gdk_window_set_events", libgdk.}
proc set_device_events*(window: Window; 
                                   device: Device; 
                                   event_mask: EventMask) {.
    importc: "gdk_window_set_device_events", libgdk.}
proc `device_events=`*(window: Window; 
                                   device: Device; 
                                   event_mask: EventMask) {.
    importc: "gdk_window_set_device_events", libgdk.}
proc get_device_events*(window: Window; 
                                   device: Device): EventMask {.
    importc: "gdk_window_get_device_events", libgdk.}
proc device_events*(window: Window; 
                                   device: Device): EventMask {.
    importc: "gdk_window_get_device_events", libgdk.}
proc set_source_events*(window: Window; 
                                   source: InputSource; 
                                   event_mask: EventMask) {.
    importc: "gdk_window_set_source_events", libgdk.}
proc `source_events=`*(window: Window; 
                                   source: InputSource; 
                                   event_mask: EventMask) {.
    importc: "gdk_window_set_source_events", libgdk.}
proc get_source_events*(window: Window; 
                                   source: InputSource): EventMask {.
    importc: "gdk_window_get_source_events", libgdk.}
proc source_events*(window: Window; 
                                   source: InputSource): EventMask {.
    importc: "gdk_window_get_source_events", libgdk.}
proc set_icon_list*(window: Window; pixbufs: glib.GList) {.
    importc: "gdk_window_set_icon_list", libgdk.}
proc `icon_list=`*(window: Window; pixbufs: glib.GList) {.
    importc: "gdk_window_set_icon_list", libgdk.}
proc set_icon_name*(window: Window; name: cstring) {.
    importc: "gdk_window_set_icon_name", libgdk.}
proc `icon_name=`*(window: Window; name: cstring) {.
    importc: "gdk_window_set_icon_name", libgdk.}
proc set_group*(window: Window; leader: Window) {.
    importc: "gdk_window_set_group", libgdk.}
proc `group=`*(window: Window; leader: Window) {.
    importc: "gdk_window_set_group", libgdk.}
proc get_group*(window: Window): Window {.
    importc: "gdk_window_get_group", libgdk.}
proc group*(window: Window): Window {.
    importc: "gdk_window_get_group", libgdk.}
proc set_decorations*(window: Window; 
                                 decorations: WMDecoration) {.
    importc: "gdk_window_set_decorations", libgdk.}
proc `decorations=`*(window: Window; 
                                 decorations: WMDecoration) {.
    importc: "gdk_window_set_decorations", libgdk.}
proc get_decorations*(window: Window; 
                                 decorations: var WMDecoration): gboolean {.
    importc: "gdk_window_get_decorations", libgdk.}
proc decorations*(window: Window; 
                                 decorations: var WMDecoration): gboolean {.
    importc: "gdk_window_get_decorations", libgdk.}
proc set_functions*(window: Window; functions: WMFunction) {.
    importc: "gdk_window_set_functions", libgdk.}
proc `functions=`*(window: Window; functions: WMFunction) {.
    importc: "gdk_window_set_functions", libgdk.}
proc create_similar_surface*(window: Window; 
    content: cairo.Content; width: cint; height: cint): cairo.Surface {.
    importc: "gdk_window_create_similar_surface", libgdk.}
proc create_similar_image_surface*(window: Window; 
    format: cairo.Format; width: cint; height: cint; scale: cint): cairo.Surface {.
    importc: "gdk_window_create_similar_image_surface", libgdk.}
proc beep*(window: Window) {.importc: "gdk_window_beep", 
    libgdk.}
proc iconify*(window: Window) {.
    importc: "gdk_window_iconify", libgdk.}
proc deiconify*(window: Window) {.
    importc: "gdk_window_deiconify", libgdk.}
proc stick*(window: Window) {.importc: "gdk_window_stick", 
    libgdk.}
proc unstick*(window: Window) {.
    importc: "gdk_window_unstick", libgdk.}
proc maximize*(window: Window) {.
    importc: "gdk_window_maximize", libgdk.}
proc unmaximize*(window: Window) {.
    importc: "gdk_window_unmaximize", libgdk.}
proc fullscreen*(window: Window) {.
    importc: "gdk_window_fullscreen", libgdk.}
proc set_fullscreen_mode*(window: Window; 
                                     mode: FullscreenMode) {.
    importc: "gdk_window_set_fullscreen_mode", libgdk.}
proc `fullscreen_mode=`*(window: Window; 
                                     mode: FullscreenMode) {.
    importc: "gdk_window_set_fullscreen_mode", libgdk.}
proc get_fullscreen_mode*(window: Window): FullscreenMode {.
    importc: "gdk_window_get_fullscreen_mode", libgdk.}
proc fullscreen_mode*(window: Window): FullscreenMode {.
    importc: "gdk_window_get_fullscreen_mode", libgdk.}
proc unfullscreen*(window: Window) {.
    importc: "gdk_window_unfullscreen", libgdk.}
proc set_keep_above*(window: Window; setting: gboolean) {.
    importc: "gdk_window_set_keep_above", libgdk.}
proc `keep_above=`*(window: Window; setting: gboolean) {.
    importc: "gdk_window_set_keep_above", libgdk.}
proc set_keep_below*(window: Window; setting: gboolean) {.
    importc: "gdk_window_set_keep_below", libgdk.}
proc `keep_below=`*(window: Window; setting: gboolean) {.
    importc: "gdk_window_set_keep_below", libgdk.}
proc set_opacity*(window: Window; opacity: gdouble) {.
    importc: "gdk_window_set_opacity", libgdk.}
proc `opacity=`*(window: Window; opacity: gdouble) {.
    importc: "gdk_window_set_opacity", libgdk.}
proc register_dnd*(window: Window) {.
    importc: "gdk_window_register_dnd", libgdk.}
proc get_drag_protocol*(window: Window; 
                                   target: var Window): DragProtocol {.
    importc: "gdk_window_get_drag_protocol", libgdk.}
proc drag_protocol*(window: Window; 
                                   target: var Window): DragProtocol {.
    importc: "gdk_window_get_drag_protocol", libgdk.}
proc begin_resize_drag*(window: Window; edge: WindowEdge; 
                                   button: gint; root_x: gint; root_y: gint; 
                                   timestamp: guint32) {.
    importc: "gdk_window_begin_resize_drag", libgdk.}
proc begin_resize_drag_for_device*(window: Window; 
    edge: WindowEdge; device: Device; button: gint; root_x: gint; 
    root_y: gint; timestamp: guint32) {.
    importc: "gdk_window_begin_resize_drag_for_device", libgdk.}
proc begin_move_drag*(window: Window; button: gint; 
                                 root_x: gint; root_y: gint; 
                                 timestamp: guint32) {.
    importc: "gdk_window_begin_move_drag", libgdk.}
proc begin_move_drag_for_device*(window: Window; 
    device: Device; button: gint; root_x: gint; root_y: gint; 
    timestamp: guint32) {.importc: "gdk_window_begin_move_drag_for_device", 
                          libgdk.}
proc invalidate_rect*(window: Window; 
                                 rect: Rectangle; 
                                 invalidate_children: gboolean) {.
    importc: "gdk_window_invalidate_rect", libgdk.}
proc invalidate_region*(window: Window; 
                                   region: cairo.Region; 
                                   invalidate_children: gboolean) {.
    importc: "gdk_window_invalidate_region", libgdk.}
type 
  WindowChildFunc* = proc (window: Window; user_data: gpointer): gboolean {.cdecl.}
proc invalidate_maybe_recurse*(window: Window; 
    region: cairo.Region; child_func: WindowChildFunc; 
    user_data: gpointer) {.importc: "gdk_window_invalidate_maybe_recurse", 
                           libgdk.}
proc get_update_area*(window: Window): cairo.Region {.
    importc: "gdk_window_get_update_area", libgdk.}
proc update_area*(window: Window): cairo.Region {.
    importc: "gdk_window_get_update_area", libgdk.}
proc freeze_updates*(window: Window) {.
    importc: "gdk_window_freeze_updates", libgdk.}
proc thaw_updates*(window: Window) {.
    importc: "gdk_window_thaw_updates", libgdk.}
proc freeze_toplevel_updates_libgtk_only*(window: Window) {.
    importc: "gdk_window_freeze_toplevel_updates_libgtk_only", libgdk.}
proc thaw_toplevel_updates_libgtk_only*(window: Window) {.
    importc: "gdk_window_thaw_toplevel_updates_libgtk_only", libgdk.}
proc window_process_all_updates*() {.
    importc: "gdk_window_process_all_updates", libgdk.}
proc process_updates*(window: Window; 
                                 update_children: gboolean) {.
    importc: "gdk_window_process_updates", libgdk.}
proc window_set_debug_updates*(setting: gboolean) {.
    importc: "gdk_window_set_debug_updates", libgdk.}
proc window_constrain_size*(geometry: Geometry; 
                                flags: WindowHints; width: gint; 
                                height: gint; new_width: var gint; 
                                new_height: var gint) {.
    importc: "gdk_window_constrain_size", libgdk.}
proc enable_synchronized_configure*(window: Window) {.
    importc: "gdk_window_enable_synchronized_configure", libgdk.}
proc configure_finished*(window: Window) {.
    importc: "gdk_window_configure_finished", libgdk.}
proc get_default_root_window*(): Window {.
    importc: "gdk_get_default_root_window", libgdk.}
proc default_root_window*(): Window {.
    importc: "gdk_get_default_root_window", libgdk.}
proc offscreen_window_get_surface*(window: Window): cairo.Surface {.
    importc: "gdk_offscreen_window_get_surface", libgdk.}
proc offscreen_window_set_embedder*(window: Window; 
    embedder: Window) {.importc: "gdk_offscreen_window_set_embedder", 
                               libgdk.}
proc offscreen_window_get_embedder*(window: Window): Window {.
    importc: "gdk_offscreen_window_get_embedder", libgdk.}
proc geometry_changed*(window: Window) {.
    importc: "gdk_window_geometry_changed", libgdk.}
proc set_support_multidevice*(window: Window; 
    support_multidevice: gboolean) {.importc: "gdk_window_set_support_multidevice", 
                                     libgdk.}
proc `support_multidevice=`*(window: Window; 
    support_multidevice: gboolean) {.importc: "gdk_window_set_support_multidevice", 
                                     libgdk.}
proc get_support_multidevice*(window: Window): gboolean {.
    importc: "gdk_window_get_support_multidevice", libgdk.}
proc support_multidevice*(window: Window): gboolean {.
    importc: "gdk_window_get_support_multidevice", libgdk.}
proc get_frame_clock*(window: Window): FrameClock {.
    importc: "gdk_window_get_frame_clock", libgdk.}
proc frame_clock*(window: Window): FrameClock {.
    importc: "gdk_window_get_frame_clock", libgdk.}
proc set_opaque_region*(window: Window; 
                                   region: cairo.Region) {.
    importc: "gdk_window_set_opaque_region", libgdk.}
proc `opaque_region=`*(window: Window; 
                                   region: cairo.Region) {.
    importc: "gdk_window_set_opaque_region", libgdk.}
proc set_event_compression*(window: Window; 
    event_compression: gboolean) {.importc: "gdk_window_set_event_compression", 
                                   libgdk.}
proc `event_compression=`*(window: Window; 
    event_compression: gboolean) {.importc: "gdk_window_set_event_compression", 
                                   libgdk.}
proc get_event_compression*(window: Window): gboolean {.
    importc: "gdk_window_get_event_compression", libgdk.}
proc event_compression*(window: Window): gboolean {.
    importc: "gdk_window_get_event_compression", libgdk.}
proc set_shadow_width*(window: Window; left: gint; 
                                  right: gint; top: gint; bottom: gint) {.
    importc: "gdk_window_set_shadow_width", libgdk.}
proc `shadow_width=`*(window: Window; left: gint; 
                                  right: gint; top: gint; bottom: gint) {.
    importc: "gdk_window_set_shadow_width", libgdk.}
proc show_window_menu*(window: Window; event: Event): gboolean {.
    importc: "gdk_window_show_window_menu", libgdk.}
proc create_gl_context*(window: Window; 
                                   profile: GLProfile; 
                                   error: var glib.GError): GLContext {.
    importc: "gdk_window_create_gl_context", libgdk.}

proc test_render_sync*(window: Window) {.
    importc: "gdk_test_render_sync", libgdk.}
proc test_simulate_key*(window: Window; x: gint; y: gint; 
                            keyval: guint; modifiers: ModifierType; 
                            key_pressrelease: EventType): gboolean {.
    importc: "gdk_test_simulate_key", libgdk.}
proc test_simulate_button*(window: Window; x: gint; y: gint; 
                               button: guint; modifiers: ModifierType; 
                               button_pressrelease: EventType): gboolean {.
    importc: "gdk_test_simulate_button", libgdk.}

proc threads_init*() {.importc: "gdk_threads_init", libgdk.}
proc threads_enter*() {.importc: "gdk_threads_enter", libgdk.}
proc threads_leave*() {.importc: "gdk_threads_leave", libgdk.}
proc threads_set_lock_functions*(enter_fn: GCallback; leave_fn: GCallback) {.
    importc: "gdk_threads_set_lock_functions", libgdk.}
proc threads_add_idle_full*(priority: gint; function: GSourceFunc; 
                                data: gpointer; notify: GDestroyNotify): guint {.
    importc: "gdk_threads_add_idle_full", libgdk.}
proc threads_add_idle*(function: GSourceFunc; data: gpointer): guint {.
    importc: "gdk_threads_add_idle", libgdk.}
proc threads_add_timeout_full*(priority: gint; interval: guint; 
                                   function: GSourceFunc; data: gpointer; 
                                   notify: GDestroyNotify): guint {.
    importc: "gdk_threads_add_timeout_full", libgdk.}
proc threads_add_timeout*(interval: guint; function: GSourceFunc; 
                              data: gpointer): guint {.
    importc: "gdk_threads_add_timeout", libgdk.}
proc threads_add_timeout_seconds_full*(priority: gint; interval: guint; 
    function: GSourceFunc; data: gpointer; notify: GDestroyNotify): guint {.
    importc: "gdk_threads_add_timeout_seconds_full", libgdk.}
proc threads_add_timeout_seconds*(interval: guint; function: GSourceFunc; 
                                      data: gpointer): guint {.
    importc: "gdk_threads_add_timeout_seconds", libgdk.}

template gdk_visual*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, visual_get_type(), VisualObj))

template gdk_is_visual*(obj: expr): expr = 
  (g_type_check_instance_type(obj, visual_get_type()))

type 
  VisualType* {.size: sizeof(cint), pure.} = enum 
    STATIC_GRAY, GRAYSCALE, STATIC_COLOR, 
    PSEUDO_COLOR, TRUE_COLOR, DIRECT_COLOR
proc visual_get_type*(): GType {.importc: "gdk_visual_get_type", 
                                     libgdk.}
proc visual_get_best_depth*(): gint {.
    importc: "gdk_visual_get_best_depth", libgdk.}
proc visual_get_best_type*(): VisualType {.
    importc: "gdk_visual_get_best_type", libgdk.}
proc visual_get_system*(): Visual {.
    importc: "gdk_visual_get_system", libgdk.}
proc visual_get_best*(): Visual {.importc: "gdk_visual_get_best", 
    libgdk.}
proc visual_get_best_with_depth*(depth: gint): Visual {.
    importc: "gdk_visual_get_best_with_depth", libgdk.}
proc visual_get_best_with_type*(visual_type: VisualType): Visual {.
    importc: "gdk_visual_get_best_with_type", libgdk.}
proc visual_get_best_with_both*(depth: gint; visual_type: VisualType): Visual {.
    importc: "gdk_visual_get_best_with_both", libgdk.}
proc query_depths*(depths: var ptr gint; count: var gint) {.
    importc: "gdk_query_depths", libgdk.}
proc query_visual_types*(visual_types: var ptr VisualType; 
                             count: var gint) {.
    importc: "gdk_query_visual_types", libgdk.}
proc list_visuals*(): glib.GList {.importc: "gdk_list_visuals", libgdk.}
proc get_screen*(visual: Visual): Screen {.
    importc: "gdk_visual_get_screen", libgdk.}
proc screen*(visual: Visual): Screen {.
    importc: "gdk_visual_get_screen", libgdk.}
proc get_visual_type*(visual: Visual): VisualType {.
    importc: "gdk_visual_get_visual_type", libgdk.}
proc visual_type*(visual: Visual): VisualType {.
    importc: "gdk_visual_get_visual_type", libgdk.}
proc get_depth*(visual: Visual): gint {.
    importc: "gdk_visual_get_depth", libgdk.}
proc depth*(visual: Visual): gint {.
    importc: "gdk_visual_get_depth", libgdk.}
proc get_byte_order*(visual: Visual): ByteOrder {.
    importc: "gdk_visual_get_byte_order", libgdk.}
proc byte_order*(visual: Visual): ByteOrder {.
    importc: "gdk_visual_get_byte_order", libgdk.}
proc get_colormap_size*(visual: Visual): gint {.
    importc: "gdk_visual_get_colormap_size", libgdk.}
proc colormap_size*(visual: Visual): gint {.
    importc: "gdk_visual_get_colormap_size", libgdk.}
proc get_bits_per_rgb*(visual: Visual): gint {.
    importc: "gdk_visual_get_bits_per_rgb", libgdk.}
proc bits_per_rgb*(visual: Visual): gint {.
    importc: "gdk_visual_get_bits_per_rgb", libgdk.}
proc get_red_pixel_details*(visual: Visual; 
    mask: var guint32; shift: var gint; precision: var gint) {.
    importc: "gdk_visual_get_red_pixel_details", libgdk.}
proc get_green_pixel_details*(visual: Visual; 
    mask: var guint32; shift: var gint; precision: var gint) {.
    importc: "gdk_visual_get_green_pixel_details", libgdk.}
proc get_blue_pixel_details*(visual: Visual; 
    mask: var guint32; shift: var gint; precision: var gint) {.
    importc: "gdk_visual_get_blue_pixel_details", libgdk.}
{.deprecated: [PRectangle: Rectangle, TRectangle: RectangleObj].}
{.deprecated: [PCursor: Cursor, TCursor: CursorObj].}
{.deprecated: [PVisual: Visual, TVisual: VisualObj].}
{.deprecated: [PDevice: Device, TDevice: DeviceObj].}
{.deprecated: [PDragContext: DragContext, TDragContext: DragContextObj].}
{.deprecated: [PDisplayManager: DisplayManager, TDisplayManager: DisplayManagerObj].}
{.deprecated: [PDeviceManager: DeviceManager, TDeviceManager: DeviceManagerObj].}
{.deprecated: [PDisplay: Display, TDisplay: DisplayObj].}
{.deprecated: [PScreen: Screen, TScreen: ScreenObj].}
{.deprecated: [PWindow: Window, TWindow: WindowObj].}
{.deprecated: [PKeymap: Keymap, TKeymap: KeymapObj].}
{.deprecated: [PAppLaunchContext: AppLaunchContext, TAppLaunchContext: AppLaunchContextObj].}
{.deprecated: [PGLContext: GLContext, TGLContext: GLContextObj].}
{.deprecated: [PPoint: Point, TPoint: PointObj].}
{.deprecated: [PTimeCoord: TimeCoord, TTimeCoord: TimeCoordObj].}
{.deprecated: [PEventSequence: EventSequence, TEventSequence: EventSequenceObj].}
{.deprecated: [PEventAny: EventAny, TEventAny: EventAnyObj].}
{.deprecated: [PEventExpose: EventExpose, TEventExpose: EventExposeObj].}
{.deprecated: [PEventVisibility: EventVisibility, TEventVisibility: EventVisibilityObj].}
{.deprecated: [PEventMotion: EventMotion, TEventMotion: EventMotionObj].}
{.deprecated: [PEventButton: EventButton, TEventButton: EventButtonObj].}
{.deprecated: [PEventTouch: EventTouch, TEventTouch: EventTouchObj].}
{.deprecated: [PEventScroll: EventScroll, TEventScroll: EventScrollObj].}
{.deprecated: [PEventKey: EventKey, TEventKey: EventKeyObj].}
{.deprecated: [PEventCrossing: EventCrossing, TEventCrossing: EventCrossingObj].}
{.deprecated: [PEventFocus: EventFocus, TEventFocus: EventFocusObj].}
{.deprecated: [PEventConfigure: EventConfigure, TEventConfigure: EventConfigureObj].}
{.deprecated: [PEventProperty: EventProperty, TEventProperty: EventPropertyObj].}
{.deprecated: [PEventSelection: EventSelection, TEventSelection: EventSelectionObj].}
{.deprecated: [PEventOwnerChange: EventOwnerChange, TEventOwnerChange: EventOwnerChangeObj].}
{.deprecated: [PEventProximity: EventProximity, TEventProximity: EventProximityObj].}
{.deprecated: [PEventSetting: EventSetting, TEventSetting: EventSettingObj].}
{.deprecated: [PEventWindowState: EventWindowState, TEventWindowState: EventWindowStateObj].}
{.deprecated: [PEventGrabBroken: EventGrabBroken, TEventGrabBroken: EventGrabBrokenObj].}
{.deprecated: [PEventDND: EventDND, TEventDND: EventDNDObj].}
{.deprecated: [PEvent: Event, TEvent: EventObj].}
{.deprecated: [PColor: Color, TColor: ColorObj].}
{.deprecated: [PRGBA: RGBA, TRGBA: RGBAObj].}
{.deprecated: [PFrameTimings: FrameTimings, TFrameTimings: FrameTimingsObj].}
{.deprecated: [PFrameClock: FrameClock, TFrameClock: FrameClockObj].}
{.deprecated: [PKeymapKey: KeymapKey, TKeymapKey: KeymapKeyObj].}
{.deprecated: [PWindowAttr: WindowAttr, TWindowAttr: WindowAttrObj].}
{.deprecated: [PGeometry: Geometry, TGeometry: GeometryObj].}
{.deprecated: [PWindowClass: WindowClass, TWindowClass: WindowClassObj].}
{.deprecated: [GdkRectangle: Rectangle, GdkRectangleObj: RectangleObj].}
{.deprecated: [GdkCursor: Cursor, GdkCursorObj: CursorObj].}
{.deprecated: [GdkVisual: Visual, GdkVisualObj: VisualObj].}
{.deprecated: [GdkDevice: Device, GdkDeviceObj: DeviceObj].}
{.deprecated: [GdkDragContext: DragContext, GdkDragContextObj: DragContextObj].}
{.deprecated: [GdkDisplayManager: DisplayManager, GdkDisplayManagerObj: DisplayManagerObj].}
{.deprecated: [GdkDeviceManager: DeviceManager, GdkDeviceManagerObj: DeviceManagerObj].}
{.deprecated: [GdkDisplay: Display, GdkDisplayObj: DisplayObj].}
{.deprecated: [GdkScreen: Screen, GdkScreenObj: ScreenObj].}
{.deprecated: [GdkWindow: Window, GdkWindowObj: WindowObj].}
{.deprecated: [GdkKeymap: Keymap, GdkKeymapObj: KeymapObj].}
{.deprecated: [GdkAppLaunchContext: AppLaunchContext, GdkAppLaunchContextObj: AppLaunchContextObj].}
{.deprecated: [GdkGLContext: GLContext, GdkGLContextObj: GLContextObj].}
{.deprecated: [GdkPoint: Point, GdkPointObj: PointObj].}
{.deprecated: [GdkTimeCoord: TimeCoord, GdkTimeCoordObj: TimeCoordObj].}
{.deprecated: [GdkEventSequence: EventSequence, GdkEventSequenceObj: EventSequenceObj].}
{.deprecated: [GdkEventAny: EventAny, GdkEventAnyObj: EventAnyObj].}
{.deprecated: [GdkEventExpose: EventExpose, GdkEventExposeObj: EventExposeObj].}
{.deprecated: [GdkEventVisibility: EventVisibility, GdkEventVisibilityObj: EventVisibilityObj].}
{.deprecated: [GdkEventMotion: EventMotion, GdkEventMotionObj: EventMotionObj].}
{.deprecated: [GdkEventButton: EventButton, GdkEventButtonObj: EventButtonObj].}
{.deprecated: [GdkEventTouch: EventTouch, GdkEventTouchObj: EventTouchObj].}
{.deprecated: [GdkEventScroll: EventScroll, GdkEventScrollObj: EventScrollObj].}
{.deprecated: [GdkEventKey: EventKey, GdkEventKeyObj: EventKeyObj].}
{.deprecated: [GdkEventCrossing: EventCrossing, GdkEventCrossingObj: EventCrossingObj].}
{.deprecated: [GdkEventFocus: EventFocus, GdkEventFocusObj: EventFocusObj].}
{.deprecated: [GdkEventConfigure: EventConfigure, GdkEventConfigureObj: EventConfigureObj].}
{.deprecated: [GdkEventProperty: EventProperty, GdkEventPropertyObj: EventPropertyObj].}
{.deprecated: [GdkEventSelection: EventSelection, GdkEventSelectionObj: EventSelectionObj].}
{.deprecated: [GdkEventOwnerChange: EventOwnerChange, GdkEventOwnerChangeObj: EventOwnerChangeObj].}
{.deprecated: [GdkEventProximity: EventProximity, GdkEventProximityObj: EventProximityObj].}
{.deprecated: [GdkEventSetting: EventSetting, GdkEventSettingObj: EventSettingObj].}
{.deprecated: [GdkEventWindowState: EventWindowState, GdkEventWindowStateObj: EventWindowStateObj].}
{.deprecated: [GdkEventGrabBroken: EventGrabBroken, GdkEventGrabBrokenObj: EventGrabBrokenObj].}
{.deprecated: [GdkEventDND: EventDND, GdkEventDNDObj: EventDNDObj].}
{.deprecated: [GdkEvent: Event, GdkEventObj: EventObj].}
{.deprecated: [GdkColor: Color, GdkColorObj: ColorObj].}
{.deprecated: [GdkRGBA: RGBA, GdkRGBAObj: RGBAObj].}
{.deprecated: [GdkFrameTimings: FrameTimings, GdkFrameTimingsObj: FrameTimingsObj].}
{.deprecated: [GdkFrameClock: FrameClock, GdkFrameClockObj: FrameClockObj].}
{.deprecated: [GdkKeymapKey: KeymapKey, GdkKeymapKeyObj: KeymapKeyObj].}
{.deprecated: [GdkWindowAttr: WindowAttr, GdkWindowAttrObj: WindowAttrObj].}
{.deprecated: [GdkGeometry: Geometry, GdkGeometryObj: GeometryObj].}
{.deprecated: [GdkWindowClass: WindowClass, GdkWindowClassObj: WindowClassObj].}
{.deprecated: [PGdkRectangle: Rectangle, TGdkRectangle: RectangleObj].}
{.deprecated: [PGdkCursor: Cursor, TGdkCursor: CursorObj].}
{.deprecated: [PGdkVisual: Visual, TGdkVisual: VisualObj].}
{.deprecated: [PGdkDevice: Device, TGdkDevice: DeviceObj].}
{.deprecated: [PGdkDragContext: DragContext, TGdkDragContext: DragContextObj].}
{.deprecated: [PGdkDisplayManager: DisplayManager, TGdkDisplayManager: DisplayManagerObj].}
{.deprecated: [PGdkDeviceManager: DeviceManager, TGdkDeviceManager: DeviceManagerObj].}
{.deprecated: [PGdkDisplay: Display, TGdkDisplay: DisplayObj].}
{.deprecated: [PGdkScreen: Screen, TGdkScreen: ScreenObj].}
{.deprecated: [PGdkWindow: Window, TGdkWindow: WindowObj].}
{.deprecated: [PGdkKeymap: Keymap, TGdkKeymap: KeymapObj].}
{.deprecated: [PGdkAppLaunchContext: AppLaunchContext, TGdkAppLaunchContext: AppLaunchContextObj].}
{.deprecated: [PGdkGLContext: GLContext, TGdkGLContext: GLContextObj].}
{.deprecated: [PGdkPoint: Point, TGdkPoint: PointObj].}
{.deprecated: [PGdkTimeCoord: TimeCoord, TGdkTimeCoord: TimeCoordObj].}
{.deprecated: [PGdkEventSequence: EventSequence, TGdkEventSequence: EventSequenceObj].}
{.deprecated: [PGdkEventAny: EventAny, TGdkEventAny: EventAnyObj].}
{.deprecated: [PGdkEventExpose: EventExpose, TGdkEventExpose: EventExposeObj].}
{.deprecated: [PGdkEventVisibility: EventVisibility, TGdkEventVisibility: EventVisibilityObj].}
{.deprecated: [PGdkEventMotion: EventMotion, TGdkEventMotion: EventMotionObj].}
{.deprecated: [PGdkEventButton: EventButton, TGdkEventButton: EventButtonObj].}
{.deprecated: [PGdkEventTouch: EventTouch, TGdkEventTouch: EventTouchObj].}
{.deprecated: [PGdkEventScroll: EventScroll, TGdkEventScroll: EventScrollObj].}
{.deprecated: [PGdkEventKey: EventKey, TGdkEventKey: EventKeyObj].}
{.deprecated: [PGdkEventCrossing: EventCrossing, TGdkEventCrossing: EventCrossingObj].}
{.deprecated: [PGdkEventFocus: EventFocus, TGdkEventFocus: EventFocusObj].}
{.deprecated: [PGdkEventConfigure: EventConfigure, TGdkEventConfigure: EventConfigureObj].}
{.deprecated: [PGdkEventProperty: EventProperty, TGdkEventProperty: EventPropertyObj].}
{.deprecated: [PGdkEventSelection: EventSelection, TGdkEventSelection: EventSelectionObj].}
{.deprecated: [PGdkEventOwnerChange: EventOwnerChange, TGdkEventOwnerChange: EventOwnerChangeObj].}
{.deprecated: [PGdkEventProximity: EventProximity, TGdkEventProximity: EventProximityObj].}
{.deprecated: [PGdkEventSetting: EventSetting, TGdkEventSetting: EventSettingObj].}
{.deprecated: [PGdkEventWindowState: EventWindowState, TGdkEventWindowState: EventWindowStateObj].}
{.deprecated: [PGdkEventGrabBroken: EventGrabBroken, TGdkEventGrabBroken: EventGrabBrokenObj].}
{.deprecated: [PGdkEventDND: EventDND, TGdkEventDND: EventDNDObj].}
{.deprecated: [PGdkEvent: Event, TGdkEvent: EventObj].}
{.deprecated: [PGdkColor: Color, TGdkColor: ColorObj].}
{.deprecated: [PGdkRGBA: RGBA, TGdkRGBA: RGBAObj].}
{.deprecated: [PGdkFrameTimings: FrameTimings, TGdkFrameTimings: FrameTimingsObj].}
{.deprecated: [PGdkFrameClock: FrameClock, TGdkFrameClock: FrameClockObj].}
{.deprecated: [PGdkKeymapKey: KeymapKey, TGdkKeymapKey: KeymapKeyObj].}
{.deprecated: [PGdkWindowAttr: WindowAttr, TGdkWindowAttr: WindowAttrObj].}
{.deprecated: [PGdkGeometry: Geometry, TGdkGeometry: GeometryObj].}
{.deprecated: [PGdkWindowClass: WindowClass, TGdkWindowClass: WindowClassObj].}
{.deprecated: [gdk_device_get_type: device_get_type].}
{.deprecated: [gdk_device_get_name: get_name].}
{.deprecated: [gdk_device_get_has_cursor: get_has_cursor].}
{.deprecated: [gdk_device_get_source: get_source].}
{.deprecated: [gdk_device_get_mode: get_mode].}
{.deprecated: [gdk_device_set_mode: set_mode].}
{.deprecated: [gdk_device_get_n_keys: get_n_keys].}
{.deprecated: [gdk_device_get_key: get_key].}
{.deprecated: [gdk_device_set_key: set_key].}
{.deprecated: [gdk_device_get_axis_use: get_axis_use].}
{.deprecated: [gdk_device_set_axis_use: set_axis_use].}
{.deprecated: [gdk_device_get_state: get_state].}
{.deprecated: [gdk_device_get_position: get_position].}
{.deprecated: [gdk_device_get_window_at_position: get_window_at_position].}
{.deprecated: [gdk_device_get_position_double: get_position_double].}
{.deprecated: [gdk_device_get_window_at_position_double: get_window_at_position_double].}
{.deprecated: [gdk_device_get_history: get_history].}
{.deprecated: [gdk_device_free_history: device_free_history].}
{.deprecated: [gdk_device_get_n_axes: get_n_axes].}
{.deprecated: [gdk_device_list_axes: list_axes].}
{.deprecated: [gdk_device_get_axis_value: get_axis_value].}
{.deprecated: [gdk_device_get_axis: get_axis].}
{.deprecated: [gdk_device_get_display: get_display].}
{.deprecated: [gdk_device_get_associated_device: get_associated_device].}
{.deprecated: [gdk_device_list_slave_devices: list_slave_devices].}
{.deprecated: [gdk_device_get_device_type: get_device_type].}
{.deprecated: [gdk_device_grab: grab].}
{.deprecated: [gdk_device_ungrab: ungrab].}
{.deprecated: [gdk_device_warp: warp].}
{.deprecated: [gdk_device_grab_info_libgtk_only: device_grab_info_libgtk_only].}
{.deprecated: [gdk_device_get_last_event_window: get_last_event_window].}
{.deprecated: [gdk_device_get_vendor_id: get_vendor_id].}
{.deprecated: [gdk_device_get_product_id: get_product_id].}
{.deprecated: [gdk_drag_context_get_type: drag_context_get_type].}
{.deprecated: [gdk_drag_context_set_device: set_device].}
{.deprecated: [gdk_drag_context_get_device: get_device].}
{.deprecated: [gdk_drag_context_list_targets: list_targets].}
{.deprecated: [gdk_drag_context_get_actions: get_actions].}
{.deprecated: [gdk_drag_context_get_suggested_action: get_suggested_action].}
{.deprecated: [gdk_drag_context_get_selected_action: get_selected_action].}
{.deprecated: [gdk_drag_context_get_source_window: get_source_window].}
{.deprecated: [gdk_drag_context_get_dest_window: get_dest_window].}
{.deprecated: [gdk_drag_context_get_protocol: get_protocol].}
{.deprecated: [gdk_drag_status: drag_status].}
{.deprecated: [gdk_drop_reply: drop_reply].}
{.deprecated: [gdk_drop_finish: drop_finish].}
{.deprecated: [gdk_drag_get_selection: drag_get_selection].}
{.deprecated: [gdk_drag_begin: drag_begin].}
{.deprecated: [gdk_drag_begin_for_device: drag_begin_for_device].}
{.deprecated: [gdk_drag_find_window_for_screen: drag_find_window_for_screen].}
{.deprecated: [gdk_drag_motion: drag_motion].}
{.deprecated: [gdk_drag_drop: drag_drop].}
{.deprecated: [gdk_drag_abort: drag_abort].}
{.deprecated: [gdk_drag_drop_succeeded: drag_drop_succeeded].}
{.deprecated: [gdk_event_get_type: event_get_type].}
{.deprecated: [gdk_event_sequence_get_type: event_sequence_get_type].}
{.deprecated: [gdk_events_pending: events_pending].}
{.deprecated: [gdk_event_get: event_get].}
{.deprecated: [gdk_event_peek: event_peek].}
{.deprecated: [gdk_event_put: put].}
{.deprecated: [gdk_event_new: event_new].}
{.deprecated: [gdk_event_copy: copy].}
{.deprecated: [gdk_event_free: free].}
{.deprecated: [gdk_event_get_window: get_window].}
{.deprecated: [gdk_event_get_time: get_time].}
{.deprecated: [gdk_event_get_state: get_state].}
{.deprecated: [gdk_event_get_coords: get_coords].}
{.deprecated: [gdk_event_get_root_coords: get_root_coords].}
{.deprecated: [gdk_event_get_button: get_button].}
{.deprecated: [gdk_event_get_click_count: get_click_count].}
{.deprecated: [gdk_event_get_keyval: get_keyval].}
{.deprecated: [gdk_event_get_keycode: get_keycode].}
{.deprecated: [gdk_event_get_scroll_direction: get_scroll_direction].}
{.deprecated: [gdk_event_get_scroll_deltas: get_scroll_deltas].}
{.deprecated: [gdk_event_get_axis: get_axis].}
{.deprecated: [gdk_event_set_device: set_device].}
{.deprecated: [gdk_event_get_device: get_device].}
{.deprecated: [gdk_event_set_source_device: set_source_device].}
{.deprecated: [gdk_event_get_source_device: get_source_device].}
{.deprecated: [gdk_event_request_motions: event_request_motions].}
{.deprecated: [gdk_event_triggers_context_menu: triggers_context_menu].}
{.deprecated: [gdk_events_get_distance: events_get_distance].}
{.deprecated: [gdk_events_get_angle: events_get_angle].}
{.deprecated: [gdk_events_get_center: events_get_center].}
{.deprecated: [gdk_event_handler_set: event_handler_set].}
{.deprecated: [gdk_event_set_screen: set_screen].}
{.deprecated: [gdk_event_get_screen: get_screen].}
{.deprecated: [gdk_event_get_event_sequence: get_event_sequence].}
{.deprecated: [gdk_event_get_event_type: get_event_type].}
{.deprecated: [gdk_set_show_events: set_show_events].}
{.deprecated: [gdk_get_show_events: get_show_events].}
{.deprecated: [gdk_setting_get: setting_get].}
{.deprecated: [gdk_device_manager_get_type: device_manager_get_type].}
{.deprecated: [gdk_device_manager_get_display: get_display].}
{.deprecated: [gdk_device_manager_list_devices: list_devices].}
{.deprecated: [gdk_device_manager_get_client_pointer: get_client_pointer].}
{.deprecated: [gdk_display_get_type: display_get_type].}
{.deprecated: [gdk_display_open: display_open].}
{.deprecated: [gdk_display_get_name: get_name].}
{.deprecated: [gdk_display_get_n_screens: get_n_screens].}
{.deprecated: [gdk_display_get_screen: get_screen].}
{.deprecated: [gdk_display_get_default_screen: get_default_screen].}
{.deprecated: [gdk_display_device_is_grabbed: device_is_grabbed].}
{.deprecated: [gdk_display_beep: beep].}
{.deprecated: [gdk_display_sync: sync].}
{.deprecated: [gdk_display_flush: flush].}
{.deprecated: [gdk_display_close: close].}
{.deprecated: [gdk_display_is_closed: is_closed].}
{.deprecated: [gdk_display_list_devices: list_devices].}
{.deprecated: [gdk_display_get_event: get_event].}
{.deprecated: [gdk_display_peek_event: peek_event].}
{.deprecated: [gdk_display_put_event: put_event].}
{.deprecated: [gdk_display_has_pending: has_pending].}
{.deprecated: [gdk_display_set_double_click_time: set_double_click_time].}
{.deprecated: [gdk_display_set_double_click_distance: set_double_click_distance].}
{.deprecated: [gdk_display_get_default: display_get_default].}
{.deprecated: [gdk_display_open_default_libgtk_only: display_open_default_libgtk_only].}
{.deprecated: [gdk_display_supports_cursor_alpha: supports_cursor_alpha].}
{.deprecated: [gdk_display_supports_cursor_color: supports_cursor_color].}
{.deprecated: [gdk_display_get_default_cursor_size: get_default_cursor_size].}
{.deprecated: [gdk_display_get_maximal_cursor_size: get_maximal_cursor_size].}
{.deprecated: [gdk_display_get_default_group: get_default_group].}
{.deprecated: [gdk_display_supports_selection_notification: supports_selection_notification].}
{.deprecated: [gdk_display_request_selection_notification: request_selection_notification].}
{.deprecated: [gdk_display_supports_clipboard_persistence: supports_clipboard_persistence].}
{.deprecated: [gdk_display_store_clipboard: store_clipboard].}
{.deprecated: [gdk_display_supports_shapes: supports_shapes].}
{.deprecated: [gdk_display_supports_input_shapes: supports_input_shapes].}
{.deprecated: [gdk_display_supports_composite: supports_composite].}
{.deprecated: [gdk_display_notify_startup_complete: notify_startup_complete].}
{.deprecated: [gdk_display_get_device_manager: get_device_manager].}
{.deprecated: [gdk_display_get_app_launch_context: get_app_launch_context].}
{.deprecated: [gdk_screen_get_type: screen_get_type].}
{.deprecated: [gdk_screen_get_system_visual: get_system_visual].}
{.deprecated: [gdk_screen_get_rgba_visual: get_rgba_visual].}
{.deprecated: [gdk_screen_is_composited: is_composited].}
{.deprecated: [gdk_screen_get_root_window: get_root_window].}
{.deprecated: [gdk_screen_get_display: get_display].}
{.deprecated: [gdk_screen_get_number: get_number].}
{.deprecated: [gdk_screen_get_width: get_width].}
{.deprecated: [gdk_screen_get_height: get_height].}
{.deprecated: [gdk_screen_get_width_mm: get_width_mm].}
{.deprecated: [gdk_screen_get_height_mm: get_height_mm].}
{.deprecated: [gdk_screen_list_visuals: list_visuals].}
{.deprecated: [gdk_screen_get_toplevel_windows: get_toplevel_windows].}
{.deprecated: [gdk_screen_make_display_name: make_display_name].}
{.deprecated: [gdk_screen_get_n_monitors: get_n_monitors].}
{.deprecated: [gdk_screen_get_primary_monitor: get_primary_monitor].}
{.deprecated: [gdk_screen_get_monitor_geometry: get_monitor_geometry].}
{.deprecated: [gdk_screen_get_monitor_workarea: get_monitor_workarea].}
{.deprecated: [gdk_screen_get_monitor_at_point: get_monitor_at_point].}
{.deprecated: [gdk_screen_get_monitor_at_window: get_monitor_at_window].}
{.deprecated: [gdk_screen_get_monitor_width_mm: get_monitor_width_mm].}
{.deprecated: [gdk_screen_get_monitor_height_mm: get_monitor_height_mm].}
{.deprecated: [gdk_screen_get_monitor_plug_name: get_monitor_plug_name].}
{.deprecated: [gdk_screen_get_monitor_scale_factor: get_monitor_scale_factor].}
{.deprecated: [gdk_screen_get_default: screen_get_default].}
{.deprecated: [gdk_screen_get_setting: get_setting].}
{.deprecated: [gdk_screen_set_font_options: set_font_options].}
{.deprecated: [gdk_screen_get_font_options: get_font_options].}
{.deprecated: [gdk_screen_set_resolution: set_resolution].}
{.deprecated: [gdk_screen_get_resolution: get_resolution].}
{.deprecated: [gdk_screen_get_active_window: get_active_window].}
{.deprecated: [gdk_screen_get_window_stack: get_window_stack].}
{.deprecated: [gdk_app_launch_context_get_type: app_launch_context_get_type].}
{.deprecated: [gdk_app_launch_context_new: app_launch_context_new].}
{.deprecated: [gdk_app_launch_context_set_display: set_display].}
{.deprecated: [gdk_app_launch_context_set_screen: set_screen].}
{.deprecated: [gdk_app_launch_context_set_desktop: set_desktop].}
{.deprecated: [gdk_app_launch_context_set_timestamp: set_timestamp].}
{.deprecated: [gdk_app_launch_context_set_icon: set_icon].}
{.deprecated: [gdk_app_launch_context_set_icon_name: set_icon_name].}
{.deprecated: [gdk_color_get_type: color_get_type].}
{.deprecated: [gdk_color_copy: copy].}
{.deprecated: [gdk_color_free: free].}
{.deprecated: [gdk_color_hash: hash].}
{.deprecated: [gdk_color_equal: equal].}
{.deprecated: [gdk_color_parse: color_parse].}
{.deprecated: [gdk_color_to_string: to_string].}
{.deprecated: [gdk_rgba_get_type: rgba_get_type].}
{.deprecated: [gdk_rgba_copy: copy].}
{.deprecated: [gdk_rgba_free: free].}
{.deprecated: [gdk_rgba_hash: rgba_hash].}
{.deprecated: [gdk_rgba_equal: rgba_equal].}
{.deprecated: [gdk_rgba_parse: parse].}
{.deprecated: [gdk_rgba_to_string: to_string].}
{.deprecated: [gdk_pixbuf_get_from_window: pixbuf_get_from_window].}
{.deprecated: [gdk_pixbuf_get_from_surface: pixbuf_get_from_surface].}
{.deprecated: [gdk_cairo_create: cairo_create].}
{.deprecated: [gdk_cairo_get_clip_rectangle: cairo_get_clip_rectangle].}
{.deprecated: [gdk_cairo_set_source_rgba: cairo_set_source_rgba].}
{.deprecated: [gdk_cairo_set_source_pixbuf: cairo_set_source_pixbuf].}
{.deprecated: [gdk_cairo_set_source_window: cairo_set_source_window].}
{.deprecated: [gdk_cairo_rectangle: cairo_rectangle].}
{.deprecated: [gdk_cairo_region: cairo_region].}
{.deprecated: [gdk_cairo_region_create_from_surface: cairo_region_create_from_surface].}
{.deprecated: [gdk_cairo_set_source_color: cairo_set_source_color].}
{.deprecated: [gdk_cairo_surface_create_from_pixbuf: cairo_surface_create_from_pixbuf].}
{.deprecated: [gdk_cairo_draw_from_gl: cairo_draw_from_gl].}
{.deprecated: [gdk_cursor_get_type: cursor_get_type].}
{.deprecated: [gdk_cursor_new_for_display: cursor_new_for_display].}
{.deprecated: [gdk_cursor_new: cursor_new].}
{.deprecated: [gdk_cursor_new_from_pixbuf: cursor_new_from_pixbuf].}
{.deprecated: [gdk_cursor_new_from_surface: cursor_new_from_surface].}
{.deprecated: [gdk_cursor_new_from_name: cursor_new_from_name].}
{.deprecated: [gdk_cursor_get_display: get_display].}
{.deprecated: [gdk_cursor_ref: `ref`].}
{.deprecated: [gdk_cursor_unref: unref].}
{.deprecated: [gdk_cursor_get_image: get_image].}
{.deprecated: [gdk_cursor_get_surface: get_surface].}
{.deprecated: [gdk_cursor_get_cursor_type: get_cursor_type].}
{.deprecated: [gdk_display_manager_get_type: display_manager_get_type].}
{.deprecated: [gdk_display_manager_get: display_manager_get].}
{.deprecated: [gdk_display_manager_get_default_display: get_default_display].}
{.deprecated: [gdk_display_manager_set_default_display: set_default_display].}
{.deprecated: [gdk_display_manager_list_displays: list_displays].}
{.deprecated: [gdk_display_manager_open_display: open_display].}
{.deprecated: [gdk_cursor_type_get_type: cursor_type_get_type].}
{.deprecated: [gdk_input_source_get_type: input_source_get_type].}
{.deprecated: [gdk_input_mode_get_type: input_mode_get_type].}
{.deprecated: [gdk_axis_use_get_type: axis_use_get_type].}
{.deprecated: [gdk_device_type_get_type: device_type_get_type].}
{.deprecated: [gdk_drag_action_get_type: drag_action_get_type].}
{.deprecated: [gdk_drag_protocol_get_type: drag_protocol_get_type].}
{.deprecated: [gdk_filter_return_get_type: filter_return_get_type].}
{.deprecated: [gdk_event_type_get_type: event_type_get_type].}
{.deprecated: [gdk_visibility_state_get_type: visibility_state_get_type].}
{.deprecated: [gdk_scroll_direction_get_type: scroll_direction_get_type].}
{.deprecated: [gdk_notify_type_get_type: notify_type_get_type].}
{.deprecated: [gdk_crossing_mode_get_type: crossing_mode_get_type].}
{.deprecated: [gdk_property_state_get_type: property_state_get_type].}
{.deprecated: [gdk_window_state_get_type: window_state_get_type].}
{.deprecated: [gdk_setting_action_get_type: setting_action_get_type].}
{.deprecated: [gdk_owner_change_get_type: owner_change_get_type].}
{.deprecated: [gdk_frame_clock_phase_get_type: frame_clock_phase_get_type].}
{.deprecated: [gdk_prop_mode_get_type: prop_mode_get_type].}
{.deprecated: [gdk_byte_order_get_type: byte_order_get_type].}
{.deprecated: [gdk_modifier_type_get_type: modifier_type_get_type].}
{.deprecated: [gdk_modifier_intent_get_type: modifier_intent_get_type].}
{.deprecated: [gdk_status_get_type: status_get_type].}
{.deprecated: [gdk_grab_status_get_type: grab_status_get_type].}
{.deprecated: [gdk_grab_ownership_get_type: grab_ownership_get_type].}
{.deprecated: [gdk_event_mask_get_type: event_mask_get_type].}
{.deprecated: [gdk_gl_profile_get_type: gl_profile_get_type].}
{.deprecated: [gdk_gl_error_get_type: gl_error_get_type].}
{.deprecated: [gdk_visual_type_get_type: visual_type_get_type].}
{.deprecated: [gdk_window_window_class_get_type: window_window_class_get_type].}
{.deprecated: [gdk_window_type_get_type: window_type_get_type].}
{.deprecated: [gdk_window_attributes_type_get_type: window_attributes_type_get_type].}
{.deprecated: [gdk_window_hints_get_type: window_hints_get_type].}
{.deprecated: [gdk_window_type_hint_get_type: window_type_hint_get_type].}
{.deprecated: [gdk_wm_decoration_get_type: wm_decoration_get_type].}
{.deprecated: [gdk_wm_function_get_type: wm_function_get_type].}
{.deprecated: [gdk_gravity_get_type: gravity_get_type].}
{.deprecated: [gdk_window_edge_get_type: window_edge_get_type].}
{.deprecated: [gdk_fullscreen_mode_get_type: fullscreen_mode_get_type].}
{.deprecated: [gdk_frame_timings_get_type: frame_timings_get_type].}
{.deprecated: [gdk_frame_timings_ref: `ref`].}
{.deprecated: [gdk_frame_timings_unref: unref].}
{.deprecated: [gdk_frame_timings_get_frame_counter: get_frame_counter].}
{.deprecated: [gdk_frame_timings_get_complete: get_complete].}
{.deprecated: [gdk_frame_timings_get_frame_time: get_frame_time].}
{.deprecated: [gdk_frame_timings_get_presentation_time: get_presentation_time].}
{.deprecated: [gdk_frame_timings_get_refresh_interval: get_refresh_interval].}
{.deprecated: [gdk_frame_timings_get_predicted_presentation_time: get_predicted_presentation_time].}
{.deprecated: [gdk_frame_clock_get_type: frame_clock_get_type].}
{.deprecated: [gdk_frame_clock_get_frame_time: get_frame_time].}
{.deprecated: [gdk_frame_clock_request_phase: request_phase].}
{.deprecated: [gdk_frame_clock_begin_updating: begin_updating].}
{.deprecated: [gdk_frame_clock_end_updating: end_updating].}
{.deprecated: [gdk_frame_clock_get_frame_counter: get_frame_counter].}
{.deprecated: [gdk_frame_clock_get_history_start: get_history_start].}
{.deprecated: [gdk_frame_clock_get_timings: get_timings].}
{.deprecated: [gdk_frame_clock_get_current_timings: get_current_timings].}
{.deprecated: [gdk_frame_clock_get_refresh_info: get_refresh_info].}
{.deprecated: [gdk_gl_error_quark: gl_error_quark].}
{.deprecated: [gdk_gl_context_get_type: gl_context_get_type].}
{.deprecated: [gdk_gl_context_get_display: get_display].}
{.deprecated: [gdk_gl_context_get_window: get_window].}
{.deprecated: [gdk_gl_context_get_profile: get_profile].}
{.deprecated: [gdk_gl_context_get_shared_context: get_shared_context].}
{.deprecated: [gdk_gl_context_set_required_version: set_required_version].}
{.deprecated: [gdk_gl_context_get_required_version: get_required_version].}
{.deprecated: [gdk_gl_context_set_debug_enabled: set_debug_enabled].}
{.deprecated: [gdk_gl_context_get_debug_enabled: get_debug_enabled].}
{.deprecated: [gdk_gl_context_set_forward_compatible: set_forward_compatible].}
{.deprecated: [gdk_gl_context_get_forward_compatible: get_forward_compatible].}
{.deprecated: [gdk_gl_context_realize: realize].}
{.deprecated: [gdk_gl_context_make_current: make_current].}
{.deprecated: [gdk_gl_context_get_current: gl_context_get_current].}
{.deprecated: [gdk_gl_context_clear_current: gl_context_clear_current].}
{.deprecated: [gdk_keymap_get_type: keymap_get_type].}
{.deprecated: [gdk_keymap_get_default: keymap_get_default].}
{.deprecated: [gdk_keymap_get_for_display: keymap_get_for_display].}
{.deprecated: [gdk_keymap_lookup_key: lookup_key].}
{.deprecated: [gdk_keymap_translate_keyboard_state: translate_keyboard_state].}
{.deprecated: [gdk_keymap_get_entries_for_keyval: get_entries_for_keyval].}
{.deprecated: [gdk_keymap_get_entries_for_keycode: get_entries_for_keycode].}
{.deprecated: [gdk_keymap_get_direction: get_direction].}
{.deprecated: [gdk_keymap_have_bidi_layouts: have_bidi_layouts].}
{.deprecated: [gdk_keymap_get_caps_lock_state: get_caps_lock_state].}
{.deprecated: [gdk_keymap_get_num_lock_state: get_num_lock_state].}
{.deprecated: [gdk_keymap_get_modifier_state: get_modifier_state].}
{.deprecated: [gdk_keymap_add_virtual_modifiers: add_virtual_modifiers].}
{.deprecated: [gdk_keymap_map_virtual_modifiers: map_virtual_modifiers].}
{.deprecated: [gdk_keymap_get_modifier_mask: get_modifier_mask].}
{.deprecated: [gdk_keyval_name: keyval_name].}
{.deprecated: [gdk_keyval_from_name: keyval_from_name].}
{.deprecated: [gdk_keyval_convert_case: keyval_convert_case].}
{.deprecated: [gdk_keyval_to_upper: keyval_to_upper].}
{.deprecated: [gdk_keyval_to_lower: keyval_to_lower].}
{.deprecated: [gdk_keyval_is_upper: keyval_is_upper].}
{.deprecated: [gdk_keyval_is_lower: keyval_is_lower].}
{.deprecated: [gdk_keyval_to_unicode: keyval_to_unicode].}
{.deprecated: [gdk_unicode_to_keyval: unicode_to_keyval].}
{.deprecated: [gdk_parse_args: parse_args].}
{.deprecated: [gdk_init: init].}
{.deprecated: [gdk_init_check: init_check].}
{.deprecated: [gdk_add_option_entries_libgtk_only: add_option_entries_libgtk_only].}
{.deprecated: [gdk_pre_parse_libgtk_only: pre_parse_libgtk_only].}
{.deprecated: [gdk_get_program_class: get_program_class].}
{.deprecated: [gdk_set_program_class: set_program_class].}
{.deprecated: [gdk_notify_startup_complete: notify_startup_complete].}
{.deprecated: [gdk_notify_startup_complete_with_id: notify_startup_complete_with_id].}
{.deprecated: [gdk_error_trap_push: error_trap_push].}
{.deprecated: [gdk_error_trap_pop: error_trap_pop].}
{.deprecated: [gdk_error_trap_pop_ignored: error_trap_pop_ignored].}
{.deprecated: [gdk_get_display_arg_name: get_display_arg_name].}
{.deprecated: [gdk_get_display: get_display].}
{.deprecated: [gdk_screen_width: screen_width].}
{.deprecated: [gdk_screen_height: screen_height].}
{.deprecated: [gdk_screen_width_mm: screen_width_mm].}
{.deprecated: [gdk_screen_height_mm: screen_height_mm].}
{.deprecated: [gdk_set_double_click_time: set_double_click_time].}
{.deprecated: [gdk_beep: beep].}
{.deprecated: [gdk_flush: flush].}
{.deprecated: [gdk_disable_multidevice: disable_multidevice].}
{.deprecated: [gdk_set_allowed_backends: set_allowed_backends].}
{.deprecated: [gdk_pango_context_get_for_screen: pango_context_get_for_screen].}
{.deprecated: [gdk_pango_context_get: pango_context_get].}
{.deprecated: [gdk_pango_layout_line_get_clip_region: pango_layout_line_get_clip_region].}
{.deprecated: [gdk_pango_layout_get_clip_region: pango_layout_get_clip_region].}
{.deprecated: [gdk_atom_intern: atom_intern].}
{.deprecated: [gdk_atom_intern_static_string: atom_intern_static_string].}
{.deprecated: [gdk_atom_name: name].}
{.deprecated: [gdk_property_get: property_get].}
{.deprecated: [gdk_property_change: property_change].}
{.deprecated: [gdk_property_delete: property_delete].}
{.deprecated: [gdk_text_property_to_utf8_list_for_display: text_property_to_utf8_list_for_display].}
{.deprecated: [gdk_utf8_to_string_target: utf8_to_string_target].}
{.deprecated: [gdk_rectangle_intersect: intersect].}
{.deprecated: [gdk_rectangle_union: union].}
{.deprecated: [gdk_rectangle_get_type: rectangle_get_type].}
{.deprecated: [gdk_selection_owner_set: selection_owner_set].}
{.deprecated: [gdk_selection_owner_get: selection_owner_get].}
{.deprecated: [gdk_selection_owner_set_for_display: selection_owner_set_for_display].}
{.deprecated: [gdk_selection_owner_get_for_display: selection_owner_get_for_display].}
{.deprecated: [gdk_selection_convert: selection_convert].}
{.deprecated: [gdk_selection_property_get: selection_property_get].}
{.deprecated: [gdk_selection_send_notify: selection_send_notify].}
{.deprecated: [gdk_selection_send_notify_for_display: selection_send_notify_for_display].}
{.deprecated: [gdk_window_get_type: window_get_type].}
{.deprecated: [gdk_window_new: new].}
{.deprecated: [gdk_window_destroy: destroy].}
{.deprecated: [gdk_window_get_window_type: get_window_type].}
{.deprecated: [gdk_window_is_destroyed: is_destroyed].}
{.deprecated: [gdk_window_get_visual: get_visual].}
{.deprecated: [gdk_window_get_screen: get_screen].}
{.deprecated: [gdk_window_get_display: get_display].}
{.deprecated: [gdk_window_show: show].}
{.deprecated: [gdk_window_hide: hide].}
{.deprecated: [gdk_window_withdraw: withdraw].}
{.deprecated: [gdk_window_show_unraised: show_unraised].}
{.deprecated: [gdk_window_move: move].}
{.deprecated: [gdk_window_resize: resize].}
{.deprecated: [gdk_window_move_resize: move_resize].}
{.deprecated: [gdk_window_reparent: reparent].}
{.deprecated: [gdk_window_raise: `raise`].}
{.deprecated: [gdk_window_lower: lower].}
{.deprecated: [gdk_window_restack: restack].}
{.deprecated: [gdk_window_focus: focus].}
{.deprecated: [gdk_window_set_user_data: set_user_data].}
{.deprecated: [gdk_window_set_override_redirect: set_override_redirect].}
{.deprecated: [gdk_window_get_accept_focus: get_accept_focus].}
{.deprecated: [gdk_window_set_accept_focus: set_accept_focus].}
{.deprecated: [gdk_window_get_focus_on_map: get_focus_on_map].}
{.deprecated: [gdk_window_set_focus_on_map: set_focus_on_map].}
{.deprecated: [gdk_window_add_filter: add_filter].}
{.deprecated: [gdk_window_remove_filter: remove_filter].}
{.deprecated: [gdk_window_scroll: scroll].}
{.deprecated: [gdk_window_move_region: move_region].}
{.deprecated: [gdk_window_ensure_native: ensure_native].}
{.deprecated: [gdk_window_shape_combine_region: shape_combine_region].}
{.deprecated: [gdk_window_set_child_shapes: set_child_shapes].}
{.deprecated: [gdk_window_get_composited: get_composited].}
{.deprecated: [gdk_window_set_composited: set_composited].}
{.deprecated: [gdk_window_merge_child_shapes: merge_child_shapes].}
{.deprecated: [gdk_window_input_shape_combine_region: input_shape_combine_region].}
{.deprecated: [gdk_window_set_child_input_shapes: set_child_input_shapes].}
{.deprecated: [gdk_window_merge_child_input_shapes: merge_child_input_shapes].}
{.deprecated: [gdk_window_is_visible: is_visible].}
{.deprecated: [gdk_window_is_viewable: is_viewable].}
{.deprecated: [gdk_window_is_input_only: is_input_only].}
{.deprecated: [gdk_window_is_shaped: is_shaped].}
{.deprecated: [gdk_window_get_state: get_state].}
{.deprecated: [gdk_window_set_static_gravities: set_static_gravities].}
{.deprecated: [gdk_window_set_invalidate_handler: set_invalidate_handler].}
{.deprecated: [gdk_window_has_native: has_native].}
{.deprecated: [gdk_window_set_type_hint: set_type_hint].}
{.deprecated: [gdk_window_get_type_hint: get_type_hint].}
{.deprecated: [gdk_window_get_modal_hint: get_modal_hint].}
{.deprecated: [gdk_window_set_modal_hint: set_modal_hint].}
{.deprecated: [gdk_window_set_skip_taskbar_hint: set_skip_taskbar_hint].}
{.deprecated: [gdk_window_set_skip_pager_hint: set_skip_pager_hint].}
{.deprecated: [gdk_window_set_urgency_hint: set_urgency_hint].}
{.deprecated: [gdk_window_set_geometry_hints: set_geometry_hints].}
{.deprecated: [gdk_window_get_clip_region: get_clip_region].}
{.deprecated: [gdk_window_get_visible_region: get_visible_region].}
{.deprecated: [gdk_window_begin_paint_rect: begin_paint_rect].}
{.deprecated: [gdk_window_mark_paint_from_clip: mark_paint_from_clip].}
{.deprecated: [gdk_window_begin_paint_region: begin_paint_region].}
{.deprecated: [gdk_window_end_paint: end_paint].}
{.deprecated: [gdk_window_flush: flush].}
{.deprecated: [gdk_window_set_title: set_title].}
{.deprecated: [gdk_window_set_role: set_role].}
{.deprecated: [gdk_window_set_startup_id: set_startup_id].}
{.deprecated: [gdk_window_set_transient_for: set_transient_for].}
{.deprecated: [gdk_window_set_background: set_background].}
{.deprecated: [gdk_window_set_background_rgba: set_background_rgba].}
{.deprecated: [gdk_window_set_background_pattern: set_background_pattern].}
{.deprecated: [gdk_window_get_background_pattern: get_background_pattern].}
{.deprecated: [gdk_window_set_cursor: set_cursor].}
{.deprecated: [gdk_window_get_cursor: get_cursor].}
{.deprecated: [gdk_window_set_device_cursor: set_device_cursor].}
{.deprecated: [gdk_window_get_device_cursor: get_device_cursor].}
{.deprecated: [gdk_window_get_user_data: get_user_data].}
{.deprecated: [gdk_window_get_geometry: get_geometry].}
{.deprecated: [gdk_window_get_width: get_width].}
{.deprecated: [gdk_window_get_height: get_height].}
{.deprecated: [gdk_window_get_position: get_position].}
{.deprecated: [gdk_window_get_origin: get_origin].}
{.deprecated: [gdk_window_get_root_coords: get_root_coords].}
{.deprecated: [gdk_window_coords_to_parent: coords_to_parent].}
{.deprecated: [gdk_window_coords_from_parent: coords_from_parent].}
{.deprecated: [gdk_window_get_root_origin: get_root_origin].}
{.deprecated: [gdk_window_get_frame_extents: get_frame_extents].}
{.deprecated: [gdk_window_get_scale_factor: get_scale_factor].}
{.deprecated: [gdk_window_get_device_position: get_device_position].}
{.deprecated: [gdk_window_get_device_position_double: get_device_position_double].}
{.deprecated: [gdk_window_get_parent: get_parent].}
{.deprecated: [gdk_window_get_toplevel: get_toplevel].}
{.deprecated: [gdk_window_get_effective_parent: get_effective_parent].}
{.deprecated: [gdk_window_get_effective_toplevel: get_effective_toplevel].}
{.deprecated: [gdk_window_get_children: get_children].}
{.deprecated: [gdk_window_peek_children: peek_children].}
{.deprecated: [gdk_window_get_children_with_user_data: get_children_with_user_data].}
{.deprecated: [gdk_window_get_events: get_events].}
{.deprecated: [gdk_window_set_events: set_events].}
{.deprecated: [gdk_window_set_device_events: set_device_events].}
{.deprecated: [gdk_window_get_device_events: get_device_events].}
{.deprecated: [gdk_window_set_source_events: set_source_events].}
{.deprecated: [gdk_window_get_source_events: get_source_events].}
{.deprecated: [gdk_window_set_icon_list: set_icon_list].}
{.deprecated: [gdk_window_set_icon_name: set_icon_name].}
{.deprecated: [gdk_window_set_group: set_group].}
{.deprecated: [gdk_window_get_group: get_group].}
{.deprecated: [gdk_window_set_decorations: set_decorations].}
{.deprecated: [gdk_window_get_decorations: get_decorations].}
{.deprecated: [gdk_window_set_functions: set_functions].}
{.deprecated: [gdk_window_create_similar_surface: create_similar_surface].}
{.deprecated: [gdk_window_create_similar_image_surface: create_similar_image_surface].}
{.deprecated: [gdk_window_beep: beep].}
{.deprecated: [gdk_window_iconify: iconify].}
{.deprecated: [gdk_window_deiconify: deiconify].}
{.deprecated: [gdk_window_stick: stick].}
{.deprecated: [gdk_window_unstick: unstick].}
{.deprecated: [gdk_window_maximize: maximize].}
{.deprecated: [gdk_window_unmaximize: unmaximize].}
{.deprecated: [gdk_window_fullscreen: fullscreen].}
{.deprecated: [gdk_window_set_fullscreen_mode: set_fullscreen_mode].}
{.deprecated: [gdk_window_get_fullscreen_mode: get_fullscreen_mode].}
{.deprecated: [gdk_window_unfullscreen: unfullscreen].}
{.deprecated: [gdk_window_set_keep_above: set_keep_above].}
{.deprecated: [gdk_window_set_keep_below: set_keep_below].}
{.deprecated: [gdk_window_set_opacity: set_opacity].}
{.deprecated: [gdk_window_register_dnd: register_dnd].}
{.deprecated: [gdk_window_get_drag_protocol: get_drag_protocol].}
{.deprecated: [gdk_window_begin_resize_drag: begin_resize_drag].}
{.deprecated: [gdk_window_begin_resize_drag_for_device: begin_resize_drag_for_device].}
{.deprecated: [gdk_window_begin_move_drag: begin_move_drag].}
{.deprecated: [gdk_window_begin_move_drag_for_device: begin_move_drag_for_device].}
{.deprecated: [gdk_window_invalidate_rect: invalidate_rect].}
{.deprecated: [gdk_window_invalidate_region: invalidate_region].}
{.deprecated: [gdk_window_invalidate_maybe_recurse: invalidate_maybe_recurse].}
{.deprecated: [gdk_window_get_update_area: get_update_area].}
{.deprecated: [gdk_window_freeze_updates: freeze_updates].}
{.deprecated: [gdk_window_thaw_updates: thaw_updates].}
{.deprecated: [gdk_window_freeze_toplevel_updates_libgtk_only: freeze_toplevel_updates_libgtk_only].}
{.deprecated: [gdk_window_thaw_toplevel_updates_libgtk_only: thaw_toplevel_updates_libgtk_only].}
{.deprecated: [gdk_window_process_all_updates: window_process_all_updates].}
{.deprecated: [gdk_window_process_updates: process_updates].}
{.deprecated: [gdk_window_set_debug_updates: window_set_debug_updates].}
{.deprecated: [gdk_window_constrain_size: window_constrain_size].}
{.deprecated: [gdk_window_enable_synchronized_configure: enable_synchronized_configure].}
{.deprecated: [gdk_window_configure_finished: configure_finished].}
{.deprecated: [gdk_get_default_root_window: get_default_root_window].}
{.deprecated: [gdk_offscreen_window_get_surface: offscreen_window_get_surface].}
{.deprecated: [gdk_offscreen_window_set_embedder: offscreen_window_set_embedder].}
{.deprecated: [gdk_offscreen_window_get_embedder: offscreen_window_get_embedder].}
{.deprecated: [gdk_window_geometry_changed: geometry_changed].}
{.deprecated: [gdk_window_set_support_multidevice: set_support_multidevice].}
{.deprecated: [gdk_window_get_support_multidevice: get_support_multidevice].}
{.deprecated: [gdk_window_get_frame_clock: get_frame_clock].}
{.deprecated: [gdk_window_set_opaque_region: set_opaque_region].}
{.deprecated: [gdk_window_set_event_compression: set_event_compression].}
{.deprecated: [gdk_window_get_event_compression: get_event_compression].}
{.deprecated: [gdk_window_set_shadow_width: set_shadow_width].}
{.deprecated: [gdk_window_show_window_menu: show_window_menu].}
{.deprecated: [gdk_window_create_gl_context: create_gl_context].}
{.deprecated: [gdk_test_render_sync: test_render_sync].}
{.deprecated: [gdk_test_simulate_key: test_simulate_key].}
{.deprecated: [gdk_test_simulate_button: test_simulate_button].}
{.deprecated: [gdk_threads_init: threads_init].}
{.deprecated: [gdk_threads_set_lock_functions: threads_set_lock_functions].}
{.deprecated: [gdk_threads_add_idle_full: threads_add_idle_full].}
{.deprecated: [gdk_threads_add_idle: threads_add_idle].}
{.deprecated: [gdk_threads_add_timeout_full: threads_add_timeout_full].}
{.deprecated: [gdk_threads_add_timeout: threads_add_timeout].}
{.deprecated: [gdk_threads_add_timeout_seconds_full: threads_add_timeout_seconds_full].}
{.deprecated: [gdk_threads_add_timeout_seconds: threads_add_timeout_seconds].}
{.deprecated: [gdk_visual_get_type: visual_get_type].}
{.deprecated: [gdk_visual_get_best_depth: visual_get_best_depth].}
{.deprecated: [gdk_visual_get_best_type: visual_get_best_type].}
{.deprecated: [gdk_visual_get_system: visual_get_system].}
{.deprecated: [gdk_visual_get_best: visual_get_best].}
{.deprecated: [gdk_visual_get_best_with_depth: visual_get_best_with_depth].}
{.deprecated: [gdk_visual_get_best_with_type: visual_get_best_with_type].}
{.deprecated: [gdk_visual_get_best_with_both: visual_get_best_with_both].}
{.deprecated: [gdk_query_depths: query_depths].}
{.deprecated: [gdk_query_visual_types: query_visual_types].}
{.deprecated: [gdk_list_visuals: list_visuals].}
{.deprecated: [gdk_visual_get_screen: get_screen].}
{.deprecated: [gdk_visual_get_visual_type: get_visual_type].}
{.deprecated: [gdk_visual_get_depth: get_depth].}
{.deprecated: [gdk_visual_get_byte_order: get_byte_order].}
{.deprecated: [gdk_visual_get_colormap_size: get_colormap_size].}
{.deprecated: [gdk_visual_get_bits_per_rgb: get_bits_per_rgb].}
{.deprecated: [gdk_visual_get_red_pixel_details: get_red_pixel_details].}
{.deprecated: [gdk_visual_get_green_pixel_details: get_green_pixel_details].}
{.deprecated: [gdk_visual_get_blue_pixel_details: get_blue_pixel_details].}
