#!/bin/bash
# S. Salewski, 08-MAR-2015
# generate pango bindings for Nim -- this is for pango headers 1.36
#
pango_dir="/home/stefan/Downloads/pango-1.36.8"
final="final.h" # the input file for c2nim
list="list.txt"
wdir="tmp_pango"

targets=''
all_t=". ${targets}"

rm -rf $wdir # start from scratch
mkdir $wdir
cd $wdir
cp -r $pango_dir/pango .
cd pango

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

cat pango.h > all.h

# add optional headers
echo '#include <pango/pango-impl-utils.h>' >> all.h
echo '#include <pango/pango-modules.h>' >> all.h
echo '#include <pango/pangofc-fontmap.h>' >> all.h
echo '#include <pango/pango-ot.h>' >> all.h
# we will split these in separate modules
echo '#include <pango/pangocairo.h>' >> all.h
echo '#include <pango/pangoxft.h>' >> all.h
echo '#include <pango/pangoft2.h>' >> all.h
echo '#include <pango/pangocoretext.h>' >> all.h # macosx
echo '#include <pango/pangocairo-coretext.h>' >> all.h
echo '#include <pango/pangowin32.h>' >> all.h

cd ..
mkdir Carbon
touch Carbon/Carbon.h
touch windows.h
touch cairo-quartz.h
# cpp run with all headers to determine order
echo "cat \\" > $list

cpp -I. `pkg-config --cflags gtk+-3.0` pango/all.h $final
echo 'pango-features.h \' >> $list
# extract file names and push names to list
grep ssalewski $final | sed 's/_ssalewski;/ \\/' >> $list

# may that be usefull?
#echo 'pango-script-lang-table.h \' >> $list
#echo 'pango-color-table.h \' >> $list

i=`uniq -d $list | wc -l`
if [ $i != 0 ]; then echo 'list contains duplicates!'; exit; fi;

# now we work again with original headers
rm -rf pango
cp -r $pango_dir/pango . 

# insert for each header file its name as first line
for j in $all_t ; do
  for i in pango/${j}/*.h; do
    sed -i "1i/* file: $i */" $i
    sed -i "1i#define headerfilename \"$i\"" $i # marker for splitting
  done
done

cd pango
  bash ../$list > ../$final
cd ..

# empty macros for c2nim
sed -i "1i#def G_BEGIN_DECLS" $final
sed -i "1i#def G_END_DECLS" $final
sed -i "1i#def G_GNUC_CONST" $final
sed -i "1i#def G_GNUC_PURE" $final
sed -i "1i#def G_DEPRECATED_FOR(i)" $final
sed -i "1i#def G_DEPRECATED" $final

sed -i "/#define PANGO_MATRIX_INIT { 1., 0., 0., 1., 0., 0. }/d" $final

i='struct _PangoAttrSize
{
  PangoAttribute attr;
  int size;
  guint absolute : 1;
};
'
j='struct _PangoAttrSize
{
  PangoAttribute attr;
  int size;
  guint bitfield0PangoAttrSize;
};
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='struct _PangoLogAttr
{
  guint is_line_break : 1;      /* Can break line in front of character */

  guint is_mandatory_break : 1; /* Must break line in front of character */

  guint is_char_break : 1;      /* Can break here when doing char wrap */

  guint is_white : 1;           /* Whitespace character */

  /* Cursor can appear in front of character (i.e. this is a grapheme
   * boundary, or the first character in the text).
   */
  guint is_cursor_position : 1;

  /* Note that in degenerate cases, you could have both start/end set on
   * some text, most likely for sentences (e.g. no space after a period, so
   * the next sentence starts right away).
   */

  guint is_word_start : 1;      /* first character in a word */
  guint is_word_end   : 1;      /* is first non-word char after a word */

  /* There are two ways to divide sentences. The first assigns all
   * intersentence whitespace/control/format chars to some sentence,
   * so all chars are in some sentence; is_sentence_boundary denotes
   * the boundaries there. The second way doesn'\''t assign
   * between-sentence spaces, etc. to any sentence, so
   * is_sentence_start/is_sentence_end mark the boundaries of those
   * sentences.
   */
  guint is_sentence_boundary : 1;
  guint is_sentence_start : 1;  /* first character in a sentence */
  guint is_sentence_end : 1;    /* first non-sentence char after a sentence */

  /* If set, backspace deletes one character rather than
   * the entire grapheme cluster.
   */
  guint backspace_deletes_character : 1;

  /* Only few space variants (U+0020 and U+00A0) have variable
   * width during justification.
   */
  guint is_expandable_space : 1;

  /* Word boundary as defined by UAX#29 */
  guint is_word_boundary : 1;	/* is NOT in the middle of a word */
};
'
j='struct _PangoLogAttr
{
  guint bitfield0PangoLogAttr;
};
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='struct _PangoGlyphVisAttr
{
  guint is_cluster_start : 1;
};
'
j='struct _PangoGlyphVisAttr
{
  guint bitfield0PangoGlyphVisAttr;
};
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='#define PANGO_ENGINE_DEFINE_TYPE(name, prefix, class_init, instance_init, parent_type) \
static GType prefix ## _type;						  \
static void								  \
prefix ## _register_type (GTypeModule *module)				  \
{									  \
  const GTypeInfo object_info =						  \
    {									  \
      sizeof (name ## Class),						  \
      (GBaseInitFunc) NULL,						  \
      (GBaseFinalizeFunc) NULL,						  \
      (GClassInitFunc) class_init,					  \
      (GClassFinalizeFunc) NULL,					  \
      NULL,          /* class_data */					  \
      sizeof (name),							  \
      0,             /* n_prelocs */					  \
      (GInstanceInitFunc) instance_init,				  \
      NULL           /* value_table */					  \
    };									  \
									  \
  prefix ## _type =  g_type_module_register_type (module, parent_type,	  \
						  # name,		  \
						  &object_info, 0);	  \
}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#define PANGO_ENGINE_LANG_DEFINE_TYPE(name, prefix, class_init, instance_init)	\
  PANGO_ENGINE_DEFINE_TYPE (name, prefix,				\
			    class_init, instance_init,			\
			    PANGO_TYPE_ENGINE_LANG)
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#define PANGO_ENGINE_SHAPE_DEFINE_TYPE(name, prefix, class_init, instance_init)	\
  PANGO_ENGINE_DEFINE_TYPE (name, prefix,				\
			    class_init, instance_init,			\
			    PANGO_TYPE_ENGINE_SHAPE)

'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='#ifdef PANGO_MODULE_PREFIX
#define PANGO_MODULE_ENTRY(func) _PANGO_MODULE_ENTRY2(PANGO_MODULE_PREFIX,func)
#define _PANGO_MODULE_ENTRY2(prefix,func) _PANGO_MODULE_ENTRY3(prefix,func)
#define _PANGO_MODULE_ENTRY3(prefix,func) prefix##_script_engine_##func
#else
#define PANGO_MODULE_ENTRY(func) script_engine_##func
#endif
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

i='struct _PangoLayoutLine
{
  PangoLayout *layout;
  gint         start_index;     /* start of line as byte index into layout->text */
  gint         length;		/* length of line in bytes */
  GSList      *runs;
  guint        is_paragraph_start : 1;  /* TRUE if this is the first line of the paragraph */
  guint        resolved_dir : 3;  /* Resolved PangoDirection of line */
};
'
j='struct _PangoLayoutLine
{
  PangoLayout *layout;
  gint         start_index;
  gint         length;
  GSList      *runs;
  guint bitfield0PangoLayoutLine;
};
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='struct _PangoFcFont
{
  PangoFont parent_instance;

  FcPattern *font_pattern;	    /* fully resolved pattern */
  PangoFontMap *fontmap;	    /* associated map */
  gpointer priv;		    /* used internally */
  PangoMatrix matrix;		    /* used internally */
  PangoFontDescription *description;

  GSList *metrics_by_lang;

  guint is_hinted : 1;
  guint is_transformed : 1;
};
'
j='struct _PangoFcFont
{
  PangoFont parent_instance;
  FcPattern *font_pattern;
  PangoFontMap *fontmap;
  gpointer priv;
  PangoMatrix matrix;
  PangoFontDescription *description;
  GSList *metrics_by_lang;
  guint bitfield0PangoFcFont;
};
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" $final

i='static inline G_GNUC_UNUSED int
pango_unichar_width (gunichar c)
{
  return G_UNLIKELY (g_unichar_iszerowidth (c)) ? 0 :
	   G_UNLIKELY (g_unichar_iswide (c)) ? 2 : 1;
}

static G_GNUC_UNUSED glong
pango_utf8_strwidth (const gchar *p)
{
  glong len = 0;
  g_return_val_if_fail (p != NULL, 0);

  while (*p)
    {
      len += pango_unichar_width (g_utf8_get_char (p));
      p = g_utf8_next_char (p);
    }

  return len;
}

/* Glib'\''s g_utf8_strlen() is broken and stops at embedded NUL'\''s.
 * Wrap it here. */
static G_GNUC_UNUSED glong
pango_utf8_strlen (const gchar *p, gssize max)
{
  glong len = 0;
  const gchar *start = p;
  g_return_val_if_fail (p != NULL || max == 0, 0);

  if (max <= 0)
    return g_utf8_strlen (p, max);

  p = g_utf8_next_char (p);
  while (p - start < max)
    {
      ++len;
      p = g_utf8_next_char (p);
    }

  /* only do the last len increment if we got a complete
   * char (don'\''t count partial chars)
   */
  if (p - start <= max)
    ++len;

  return len;
}


/* To be made public at some point */

static G_GNUC_UNUSED void
pango_glyph_string_reverse_range (PangoGlyphString *glyphs,
				  int start, int end)
{
  int i, j;

  for (i = start, j = end - 1; i < j; i++, j--)
    {
      PangoGlyphInfo glyph_info;
      gint log_cluster;

      glyph_info = glyphs->glyphs[i];
      glyphs->glyphs[i] = glyphs->glyphs[j];
      glyphs->glyphs[j] = glyph_info;

      log_cluster = glyphs->log_clusters[i];
      glyphs->log_clusters[i] = glyphs->log_clusters[j];
      glyphs->log_clusters[j] = log_cluster;
    }
}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" $final

# add missing {} for struct
sed -i 's/typedef struct _PangoCoverage PangoCoverage;/typedef struct _PangoCoverage{} PangoCoverage;/g' $final
sed -i 's/typedef struct _PangoScriptIter PangoScriptIter;/typedef struct _PangoScriptIter{} PangoScriptIter;/g' $final
sed -i 's/typedef struct _PangoLanguage PangoLanguage;/typedef struct _PangoLanguage{} PangoLanguage;/g' $final
sed -i 's/typedef struct _PangoFontDescription PangoFontDescription;/typedef struct _PangoFontDescription{} PangoFontDescription;/g' $final
sed -i 's/typedef struct _PangoAttrIterator PangoAttrIterator;/typedef struct _PangoAttrIterator{} PangoAttrIterator;/g' $final
sed -i 's/typedef struct _PangoAttrList     PangoAttrList;/typedef struct _PangoAttrList{} PangoAttrList;/g' $final
sed -i 's/typedef struct _PangoFontsetSimple  PangoFontsetSimple;/typedef struct _PangoFontsetSimple{} PangoFontsetSimple;/g' $final
sed -i 's/typedef struct _PangoTabArray PangoTabArray;/typedef struct _PangoTabArray{} PangoTabArray;/g' $final
sed -i 's/typedef struct _PangoLayout      PangoLayout;/typedef struct _PangoLayout{} PangoLayout;/g' $final
sed -i 's/typedef struct _PangoLayoutIter PangoLayoutIter;/typedef struct _PangoLayoutIter{} PangoLayoutIter;/g' $final
sed -i 's/typedef struct _PangoRendererPrivate PangoRendererPrivate;/typedef struct _PangoRendererPrivate{} PangoRendererPrivate;/g' $final
sed -i 's/typedef struct _PangoCairoFontMap        PangoCairoFontMap;/typedef struct _PangoCairoFontMap{} PangoCairoFontMap;/g' $final
sed -i 's/typedef struct _PangoCairoFont      PangoCairoFont;/typedef struct _PangoCairoFont{} PangoCairoFont;/g' $final
sed -i 's/typedef struct _PangoXftRendererPrivate PangoXftRendererPrivate;/typedef struct _PangoXftRendererPrivate{} PangoXftRendererPrivate;/g' $final
sed -i 's/typedef struct _PangoFT2FontMap      PangoFT2FontMap;/typedef struct _PangoFT2FontMap{} PangoFT2FontMap;/g' $final
sed -i 's/typedef struct _PangoWin32FontCache PangoWin32FontCache;/typedef struct _PangoWin32FontCache{} PangoWin32FontCache;/g' $final
sed -i 's/typedef struct _PangoMap PangoMap;/typedef struct _PangoMap{} PangoMap;/g' $final
sed -i 's/typedef struct _PangoOTInfo       PangoOTInfo;/typedef struct _PangoOTInfo{} PangoOTInfo;/g' $final
sed -i 's/typedef struct _PangoOTBuffer     PangoOTBuffer;/typedef struct _PangoOTBuffer{} PangoOTBuffer;/g' $final
sed -i 's/typedef struct _PangoOTRuleset    PangoOTRuleset;/typedef struct _PangoOTRuleset{} PangoOTRuleset;/g' $final
sed -i 's/typedef struct _PangoFcFontsetKey  PangoFcFontsetKey;/typedef struct _PangoFcFontsetKey{} PangoFcFontsetKey;/g' $final
sed -i 's/typedef struct _PangoFcFontKey     PangoFcFontKey;/typedef struct _PangoFcFontKey{} PangoFcFontKey;/g' $final
sed -i 's/typedef struct _PangoFcFontMapPrivate PangoFcFontMapPrivate;/typedef struct _PangoFcFontMapPrivate{} PangoFcFontMapPrivate;/g' $final
sed -i 's/typedef struct _PangoCoreTextFontKey      PangoCoreTextFontKey;/typedef struct _PangoCoreTextFontKey{} PangoCoreTextFontKey;/g' $final
sed -i 's/typedef struct _PangoCoreTextFace         PangoCoreTextFace;/typedef struct _PangoCoreTextFace{} PangoCoreTextFace;/g' $final
sed -i 's/typedef struct _PangoCoreTextFontPrivate  PangoCoreTextFontPrivate;/typedef struct _PangoCoreTextFontPrivate{} PangoCoreTextFontPrivate;/g' $final
sed -i 's/typedef struct _PangoContext PangoContext;/typedef struct _PangoContext{} PangoContext;/g' $final
sed -i 's/typedef struct _PangoXftFont    PangoXftFont;/typedef struct _PangoXftFont{} PangoXftFont;/g' $final

ruby ../fix_.rb $final

i='
#ifdef __INCREASE_TMP_INDENT__
#ifdef C2NIM
#  dynlib lib
#endif
#endif
'
perl -0777 -p -i -e "s/^/$i/" $final

ruby ../fix_gtk_type.rb final.h PANGO_
c2nim096 --skipcomments --skipinclude $final
sed -i -f gtk_type_sedlist final.nim

sed -i 's/ out: / `out`: /g' final.nim
sed -i 's/\bend: /`end`: /g' final.nim
sed -i 's/\bend\*: /`end`\*: /g' final.nim
sed -i 's/\btype: /`type`: /g' final.nim
sed -i 's/\btype\*: /`type`\*: /g' final.nim
sed -i 's/\biterator: /`iterator`: /g' final.nim
sed -i 's/\bconverter\b/`&`/g' final.nim
sed -i 's/\bfunc\(\)\*/`func`\1\*/' final.nim
sed -i 's/\bfunc\(\):/`func`\1:/' final.nim

# we use our own defined pragma
sed -i "s/\bdynlib: lib\b/libpango/g" final.nim

ruby ../remdef.rb final.nim

i='const 
  headerfilename* = '
perl -0777 -p -i -e "s~\Q$i\E~  ### ~sg" final.nim

sed -i '1d' final.nim
sed -i 's/^  //' final.nim

i=' {.deadCodeElim: on.}
'
j='{.deadCodeElim: on.}

# Note: Not all pango C macros are available in Nim yet.
# Some are converted by c2nim to templates, some manually to procs.
# Most of these should be not necessary for Nim programmers.
# We may have to add more and to test and fix some, or remove unnecessary ones completely...
# pango-color-table.h and pango-script-lang-table.h is currently not included.

when defined(windows): 
  const LIB_PANGO* = "libpango-1.0-0.dll"
elif defined(macosx):
  const LIB_PANGO* = "libpango-1.0.dylib"
else: 
  const LIB_PANGO* = "libpango-1.0.so.0"

{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}

const
  PANGO_DISABLE_DEPRECATED* = false
  PANGO_ENABLE_BACKEND* = true
  PANGO_ENABLE_ENGINE* = true
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

ruby ../underscorefix.rb final.nim

i='type 
  PangoMatrix* = object 
    xx*: cdouble
    xy*: cdouble
    yx*: cdouble
    yy*: cdouble
    x0*: cdouble
    y0*: cdouble
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim
j='type 
  PangoGravity* {.size: sizeof(cint).} = enum 
    PANGO_GRAVITY_SOUTH, PANGO_GRAVITY_EAST, PANGO_GRAVITY_NORTH, 
    PANGO_GRAVITY_WEST, PANGO_GRAVITY_AUTO
'
perl -0777 -p -i -e "s~\Q$j\E~$i$j~s" final.nim

j='proc pango_gravity_get_for_script*(script: PangoScript; 
                                   base_gravity: PangoGravity; 
                                   hint: PangoGravityHint): PangoGravity {.
    importc: "pango_gravity_get_for_script", libpango.}
proc pango_gravity_get_for_script_and_width*(script: PangoScript; 
    wide: gboolean; base_gravity: PangoGravity; hint: PangoGravityHint): PangoGravity {.
    importc: "pango_gravity_get_for_script_and_width", libpango.}
'
perl -0777 -p -i -e "s~\Q$j\E~~s" final.nim
i='proc pango_script_for_unichar*(ch: gunichar): PangoScript {.
    importc: "pango_script_for_unichar", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j$i~s" final.nim

i='proc pango_script_get_sample_language*(script: PangoScript): ptr PangoLanguage {.
    importc: "pango_script_get_sample_language", libpango.}
### "pango/./pango-language.h"


type 
  PangoLanguage* = object 
'
j='type 
  PangoLanguage* = object 
proc pango_script_get_sample_language*(script: PangoScript): ptr PangoLanguage {.
    importc: "pango_script_get_sample_language", libpango.}
### "pango/./pango-language.h"

'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='const 
  PANGO_SCALE_XX_SMALL* = (cast[cdouble](0.5787037037036999))
  PANGO_SCALE_X_SMALL* = (cast[cdouble](0.6444444444444))
  PANGO_SCALE_SMALL* = (cast[cdouble](0.8333333333333))
  PANGO_SCALE_MEDIUM* = (cast[cdouble](1.0))
  PANGO_SCALE_LARGE* = (cast[cdouble](1.2))
  PANGO_SCALE_X_LARGE* = (cast[cdouble](1.4399999999999))
  PANGO_SCALE_XX_LARGE* = (cast[cdouble](1.728))
'
j='const 
  PANGO_SCALE_XX_SMALL* = cdouble(0.5787037037036999)
  PANGO_SCALE_X_SMALL* = cdouble(0.6444444444444)
  PANGO_SCALE_SMALL* = cdouble(0.8333333333333)
  PANGO_SCALE_MEDIUM* = cdouble(1.0)
  PANGO_SCALE_LARGE* = cdouble(1.2)
  PANGO_SCALE_X_LARGE* = cdouble(1.4399999999999)
  PANGO_SCALE_XX_LARGE* = cdouble(1.728)
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='when defined(PANGO_ENABLE_BACKEND): 
  proc pango_font_metrics_new*(): ptr PangoFontMetrics {.
      importc: "pango_font_metrics_new", libpango.}
  type 
    PangoFontMetrics* = object 
      ref_count*: guint
      ascent*: cint
      descent*: cint
      approximate_char_width*: cint
      approximate_digit_width*: cint
      underline_position*: cint
      underline_thickness*: cint
      strikethrough_position*: cint
      strikethrough_thickness*: cint
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim
j='when defined(PANGO_ENABLE_BACKEND): 
  type 
    PangoFontMetrics* = object 
      ref_count*: guint
      ascent*: cint
      descent*: cint
      approximate_char_width*: cint
      approximate_digit_width*: cint
      underline_position*: cint
      underline_thickness*: cint
      strikethrough_position*: cint
      strikethrough_thickness*: cint
  proc pango_font_metrics_new*(): ptr PangoFontMetrics {.
      importc: "pango_font_metrics_new", libpango.}
else:
  type
    PangoFontMetrics* = object 
'
i='proc pango_font_description_get_type*(): GType {.
    importc: "pango_font_description_get_type", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j$i~s" final.nim

i='template PANGO_FONT_FAMILY*(object: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_CAST((object), font_family_get_type(), 
                              PangoFontFamily))

template PANGO_IS_FONT_FAMILY*(object: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_TYPE((object), font_family_get_type()))

proc pango_font_family_get_type*(): GType {.
    importc: "pango_font_family_get_type", libpango.}
proc pango_font_family_list_faces*(family: ptr PangoFontFamily; 
                                   faces: ptr ptr ptr PangoFontFace; 
                                   n_faces: ptr cint) {.
    importc: "pango_font_family_list_faces", libpango.}
proc pango_font_family_get_name*(family: ptr PangoFontFamily): cstring {.
    importc: "pango_font_family_get_name", libpango.}
proc pango_font_family_is_monospace*(family: ptr PangoFontFamily): gboolean {.
    importc: "pango_font_family_is_monospace", libpango.}
when defined(PANGO_ENABLE_BACKEND): 
  template PANGO_FONT_FAMILY_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), font_family_get_type(), 
                             PangoFontFamilyClass))

  template PANGO_IS_FONT_FAMILY_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), font_family_get_type()))

  template PANGO_FONT_FAMILY_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), font_family_get_type(), 
                               PangoFontFamilyClass))

  type 
    PangoFontFamily* = object 
      parent_instance*: GObject

  type 
    PangoFontFamilyClass* = object 
      parent_class*: GObjectClass
      list_faces*: proc (family: ptr PangoFontFamily; 
                         faces: ptr ptr ptr PangoFontFace; n_faces: ptr cint)
      get_name*: proc (family: ptr PangoFontFamily): cstring
      is_monospace*: proc (family: ptr PangoFontFamily): gboolean
      pango_reserved2: proc ()
      pango_reserved3: proc ()
      pango_reserved4: proc ()
'
j='when defined(PANGO_ENABLE_BACKEND): 
  template PANGO_FONT_FAMILY_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), font_family_get_type(), 
                             PangoFontFamilyClass))

  template PANGO_IS_FONT_FAMILY_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), font_family_get_type()))

  template PANGO_FONT_FAMILY_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), font_family_get_type(), 
                               PangoFontFamilyClass))

  type 
    PangoFontFace* = object 
      parent_instance*: GObject
  type 
    PangoFontFamily* = object 
      parent_instance*: GObject

  type 
    PangoFontFamilyClass* = object 
      parent_class*: GObjectClass
      list_faces*: proc (family: ptr PangoFontFamily; 
                         faces: ptr ptr ptr PangoFontFace; n_faces: ptr cint)
      get_name*: proc (family: ptr PangoFontFamily): cstring
      is_monospace*: proc (family: ptr PangoFontFamily): gboolean
      pango_reserved2: proc ()
      pango_reserved3: proc ()
      pango_reserved4: proc ()
else:
  type 
    PangoFontFace* = object 
      parent_instance*: GObject
  type 
    PangoFontFamily* = object 

template PANGO_FONT_FAMILY*(object: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_CAST((object), font_family_get_type(), 
                              PangoFontFamily))

template PANGO_IS_FONT_FAMILY*(object: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_TYPE((object), font_family_get_type()))

proc pango_font_family_get_type*(): GType {.
    importc: "pango_font_family_get_type", libpango.}
proc pango_font_family_list_faces*(family: ptr PangoFontFamily; 
                                   faces: ptr ptr ptr PangoFontFace; 
                                   n_faces: ptr cint) {.
    importc: "pango_font_family_list_faces", libpango.}
proc pango_font_family_get_name*(family: ptr PangoFontFamily): cstring {.
    importc: "pango_font_family_get_name", libpango.}
proc pango_font_family_is_monospace*(family: ptr PangoFontFamily): gboolean {.
    importc: "pango_font_family_is_monospace", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

sed -i 's/(object:/(`object`:/' final.nim
sed -i 's/(object)/(`object`)/' final.nim

i='template PANGO_FONT_FAMILY*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_CAST((`object`), font_family_get_type(), 
                              PangoFontFamily))

template PANGO_IS_FONT_FAMILY*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_TYPE((`object`), font_family_get_type()))

proc pango_font_family_get_type*(): GType {.
    importc: "pango_font_family_get_type", libpango.}
proc pango_font_family_list_faces*(family: ptr PangoFontFamily; 
                                   faces: ptr ptr ptr PangoFontFace; 
                                   n_faces: ptr cint) {.
    importc: "pango_font_family_list_faces", libpango.}
proc pango_font_family_get_name*(family: ptr PangoFontFamily): cstring {.
    importc: "pango_font_family_get_name", libpango.}
proc pango_font_family_is_monospace*(family: ptr PangoFontFamily): gboolean {.
    importc: "pango_font_family_is_monospace", libpango.}

template PANGO_FONT_FACE*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_CAST((`object`), font_face_get_type(), PangoFontFace))

template PANGO_IS_FONT_FACE*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_TYPE((`object`), font_face_get_type()))

proc pango_font_face_get_type*(): GType {.importc: "pango_font_face_get_type", 
    libpango.}
proc pango_font_face_describe*(face: ptr PangoFontFace): ptr PangoFontDescription {.
    importc: "pango_font_face_describe", libpango.}
proc pango_font_face_get_face_name*(face: ptr PangoFontFace): cstring {.
    importc: "pango_font_face_get_face_name", libpango.}
proc pango_font_face_list_sizes*(face: ptr PangoFontFace; sizes: ptr ptr cint; 
                                 n_sizes: ptr cint) {.
    importc: "pango_font_face_list_sizes", libpango.}
proc pango_font_face_is_synthesized*(face: ptr PangoFontFace): gboolean {.
    importc: "pango_font_face_is_synthesized", libpango.}
when defined(PANGO_ENABLE_BACKEND): 
  template PANGO_FONT_FACE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), font_face_get_type(), PangoFontFaceClass))

  template PANGO_IS_FONT_FACE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), font_face_get_type()))

  template PANGO_FONT_FACE_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), font_face_get_type(), PangoFontFaceClass))

  type 
    PangoFontFace* = object 
      parent_instance*: GObject

  type 
    PangoFontFaceClass* = object 
      parent_class*: GObjectClass
      get_face_name*: proc (face: ptr PangoFontFace): cstring
      describe*: proc (face: ptr PangoFontFace): ptr PangoFontDescription
      list_sizes*: proc (face: ptr PangoFontFace; sizes: ptr ptr cint; 
                         n_sizes: ptr cint)
      is_synthesized*: proc (face: ptr PangoFontFace): gboolean
      pango_reserved3: proc ()
      pango_reserved4: proc ()
'
j='when defined(PANGO_ENABLE_BACKEND): 
  template PANGO_FONT_FACE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), font_face_get_type(), PangoFontFaceClass))

  template PANGO_IS_FONT_FACE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), font_face_get_type()))

  template PANGO_FONT_FACE_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), font_face_get_type(), PangoFontFaceClass))

  type 
    PangoFontFaceClass* = object 
      parent_class*: GObjectClass
      get_face_name*: proc (face: ptr PangoFontFace): cstring
      describe*: proc (face: ptr PangoFontFace): ptr PangoFontDescription
      list_sizes*: proc (face: ptr PangoFontFace; sizes: ptr ptr cint; 
                         n_sizes: ptr cint)
      is_synthesized*: proc (face: ptr PangoFontFace): gboolean
      pango_reserved3: proc ()
      pango_reserved4: proc ()

template PANGO_FONT_FAMILY*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_CAST((`object`), font_family_get_type(), 
                              PangoFontFamily))

template PANGO_IS_FONT_FAMILY*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_TYPE((`object`), font_family_get_type()))

proc pango_font_family_get_type*(): GType {.
    importc: "pango_font_family_get_type", libpango.}
proc pango_font_family_list_faces*(family: ptr PangoFontFamily; 
                                   faces: ptr ptr ptr PangoFontFace; 
                                   n_faces: ptr cint) {.
    importc: "pango_font_family_list_faces", libpango.}
proc pango_font_family_get_name*(family: ptr PangoFontFamily): cstring {.
    importc: "pango_font_family_get_name", libpango.}
proc pango_font_family_is_monospace*(family: ptr PangoFontFamily): gboolean {.
    importc: "pango_font_family_is_monospace", libpango.}

template PANGO_FONT_FACE*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_CAST((`object`), font_face_get_type(), PangoFontFace))

template PANGO_IS_FONT_FACE*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_TYPE((`object`), font_face_get_type()))

proc pango_font_face_get_type*(): GType {.importc: "pango_font_face_get_type", 
    libpango.}
proc pango_font_face_describe*(face: ptr PangoFontFace): ptr PangoFontDescription {.
    importc: "pango_font_face_describe", libpango.}
proc pango_font_face_get_face_name*(face: ptr PangoFontFace): cstring {.
    importc: "pango_font_face_get_face_name", libpango.}
proc pango_font_face_list_sizes*(face: ptr PangoFontFace; sizes: ptr ptr cint; 
                                 n_sizes: ptr cint) {.
    importc: "pango_font_face_list_sizes", libpango.}
proc pango_font_face_is_synthesized*(face: ptr PangoFontFace): gboolean {.
    importc: "pango_font_face_is_synthesized", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='template PANGO_FONT*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_CAST((`object`), font_get_type(), PangoFont))

template PANGO_IS_FONT*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_TYPE((`object`), font_get_type()))

proc pango_font_get_type*(): GType {.importc: "pango_font_get_type", 
                                     libpango.}
proc pango_font_describe*(font: ptr PangoFont): ptr PangoFontDescription {.
    importc: "pango_font_describe", libpango.}
proc pango_font_describe_with_absolute_size*(font: ptr PangoFont): ptr PangoFontDescription {.
    importc: "pango_font_describe_with_absolute_size", libpango.}
proc pango_font_get_coverage*(font: ptr PangoFont; language: ptr PangoLanguage): ptr PangoCoverage {.
    importc: "pango_font_get_coverage", libpango.}
proc pango_font_find_shaper*(font: ptr PangoFont; language: ptr PangoLanguage; 
                             ch: guint32): ptr PangoEngineShape {.
    importc: "pango_font_find_shaper", libpango.}
proc pango_font_get_metrics*(font: ptr PangoFont; language: ptr PangoLanguage): ptr PangoFontMetrics {.
    importc: "pango_font_get_metrics", libpango.}
proc pango_font_get_glyph_extents*(font: ptr PangoFont; glyph: PangoGlyph; 
                                   ink_rect: ptr PangoRectangle; 
                                   logical_rect: ptr PangoRectangle) {.
    importc: "pango_font_get_glyph_extents", libpango.}
proc pango_font_get_font_map*(font: ptr PangoFont): ptr PangoFontMap {.
    importc: "pango_font_get_font_map", libpango.}
when defined(PANGO_ENABLE_BACKEND): 
  template PANGO_FONT_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), font_get_type(), PangoFontClass))

  template PANGO_IS_FONT_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), font_get_type()))

  template PANGO_FONT_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), font_get_type(), PangoFontClass))

  type 
    PangoFont* = object 
      parent_instance*: GObject

  type 
    PangoFontClass* = object 
      parent_class*: GObjectClass
      describe*: proc (font: ptr PangoFont): ptr PangoFontDescription
      get_coverage*: proc (font: ptr PangoFont; lang: ptr PangoLanguage): ptr PangoCoverage
      find_shaper*: proc (font: ptr PangoFont; lang: ptr PangoLanguage; 
                          ch: guint32): ptr PangoEngineShape
      get_glyph_extents*: proc (font: ptr PangoFont; glyph: PangoGlyph; 
                                ink_rect: ptr PangoRectangle; 
                                logical_rect: ptr PangoRectangle)
      get_metrics*: proc (font: ptr PangoFont; language: ptr PangoLanguage): ptr PangoFontMetrics
      get_font_map*: proc (font: ptr PangoFont): ptr PangoFontMap
      describe_absolute*: proc (font: ptr PangoFont): ptr PangoFontDescription
      pango_reserved1: proc ()
      pango_reserved2: proc ()

  const 
    PANGO_UNKNOWN_GLYPH_WIDTH* = 10
    PANGO_UNKNOWN_GLYPH_HEIGHT* = 14
'
j='when defined(PANGO_ENABLE_BACKEND): 
  template PANGO_FONT_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), font_get_type(), PangoFontClass))

  template PANGO_IS_FONT_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), font_get_type()))

  template PANGO_FONT_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), font_get_type(), PangoFontClass))

  type 
    PangoFontClass* = object 
      parent_class*: GObjectClass
      describe*: proc (font: ptr PangoFont): ptr PangoFontDescription
      get_coverage*: proc (font: ptr PangoFont; lang: ptr PangoLanguage): ptr PangoCoverage
      find_shaper*: proc (font: ptr PangoFont; lang: ptr PangoLanguage; 
                          ch: guint32): ptr PangoEngineShape
      get_glyph_extents*: proc (font: ptr PangoFont; glyph: PangoGlyph; 
                                ink_rect: ptr PangoRectangle; 
                                logical_rect: ptr PangoRectangle)
      get_metrics*: proc (font: ptr PangoFont; language: ptr PangoLanguage): ptr PangoFontMetrics
      get_font_map*: proc (font: ptr PangoFont): ptr PangoFontMap
      describe_absolute*: proc (font: ptr PangoFont): ptr PangoFontDescription
      pango_reserved1: proc ()
      pango_reserved2: proc ()

  const 
    PANGO_UNKNOWN_GLYPH_WIDTH* = 10
    PANGO_UNKNOWN_GLYPH_HEIGHT* = 14

template PANGO_FONT*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_CAST((`object`), font_get_type(), PangoFont))

template PANGO_IS_FONT*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_TYPE((`object`), font_get_type()))

proc pango_font_get_type*(): GType {.importc: "pango_font_get_type", 
                                     libpango.}
proc pango_font_describe*(font: ptr PangoFont): ptr PangoFontDescription {.
    importc: "pango_font_describe", libpango.}
proc pango_font_describe_with_absolute_size*(font: ptr PangoFont): ptr PangoFontDescription {.
    importc: "pango_font_describe_with_absolute_size", libpango.}
proc pango_font_get_coverage*(font: ptr PangoFont; language: ptr PangoLanguage): ptr PangoCoverage {.
    importc: "pango_font_get_coverage", libpango.}
proc pango_font_find_shaper*(font: ptr PangoFont; language: ptr PangoLanguage; 
                             ch: guint32): ptr PangoEngineShape {.
    importc: "pango_font_find_shaper", libpango.}
proc pango_font_get_metrics*(font: ptr PangoFont; language: ptr PangoLanguage): ptr PangoFontMetrics {.
    importc: "pango_font_get_metrics", libpango.}
proc pango_font_get_glyph_extents*(font: ptr PangoFont; glyph: PangoGlyph; 
                                   ink_rect: ptr PangoRectangle; 
                                   logical_rect: ptr PangoRectangle) {.
    importc: "pango_font_get_glyph_extents", libpango.}
proc pango_font_get_font_map*(font: ptr PangoFont): ptr PangoFontMap {.
    importc: "pango_font_get_font_map", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='when defined(PANGO_ENABLE_ENGINE): 
  const 
    PANGO_RENDER_TYPE_NONE* = "PangoRenderNone"
  template PANGO_ENGINE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_CAST((`object`), engine_get_type(), PangoEngine))

  template PANGO_IS_ENGINE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_TYPE((`object`), engine_get_type()))

  template PANGO_ENGINE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), engine_get_type(), PangoEngineClass))

  template PANGO_IS_ENGINE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), engine_get_type()))

  template PANGO_ENGINE_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), engine_get_type(), PangoEngineClass))

  type 
    PangoEngine* = object 
      parent_instance*: GObject

  type 
    PangoEngineClass* = object 
      parent_class*: GObjectClass

  proc pango_engine_get_type*(): GType {.importc: "pango_engine_get_type", 
      libpango.}
  const 
    PANGO_ENGINE_TYPE_LANG* = "PangoEngineLang"
  template PANGO_ENGINE_LANG*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_CAST((`object`), engine_lang_get_type(), 
                                PangoEngineLang))

  template PANGO_IS_ENGINE_LANG*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_TYPE((`object`), engine_lang_get_type()))

  template PANGO_ENGINE_LANG_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), engine_lang_get_type(), 
                             PangoEngineLangClass))

  template PANGO_IS_ENGINE_LANG_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), engine_lang_get_type()))

  template PANGO_ENGINE_LANG_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), engine_lang_get_type(), 
                               PangoEngineLangClass))

  type 
    PangoEngineLang* = object 
      parent_instance*: PangoEngine

  type 
    PangoEngineLangClass* = object 
      parent_class*: PangoEngineClass
      script_break*: proc (engine: ptr PangoEngineLang; text: cstring; 
                           len: cint; analysis: ptr PangoAnalysis; 
                           attrs: ptr PangoLogAttr; attrs_len: cint)

  proc pango_engine_lang_get_type*(): GType {.
      importc: "pango_engine_lang_get_type", libpango.}
  const 
    PANGO_ENGINE_TYPE_SHAPE* = "PangoEngineShape"
  template PANGO_ENGINE_SHAPE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_CAST((`object`), engine_shape_get_type(), 
                                PangoEngineShape))

  template PANGO_IS_ENGINE_SHAPE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_TYPE((`object`), engine_shape_get_type()))

  template PANGO_ENGINE_SHAPE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), engine_shape_get_type(), 
                             PangoEngine_ShapeClass))

  template PANGO_IS_ENGINE_SHAPE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), engine_shape_get_type()))

  template PANGO_ENGINE_SHAPE_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), engine_shape_get_type(), 
                               PangoEngineShapeClass))

  type 
    PangoEngineShape* = object 
      parent_instance*: PangoEngine

  type 
    PangoEngineShapeClass* = object 
      parent_class*: PangoEngineClass
      script_shape*: proc (engine: ptr PangoEngineShape; font: ptr PangoFont; 
                           item_text: cstring; item_length: cuint; 
                           analysis: ptr PangoAnalysis; 
                           glyphs: ptr PangoGlyphString; 
                           paragraph_text: cstring; paragraph_length: cuint)
      covers*: proc (engine: ptr PangoEngineShape; font: ptr PangoFont; 
                     language: ptr PangoLanguage; wc: gunichar): PangoCoverageLevel

  proc pango_engine_shape_get_type*(): GType {.
      importc: "pango_engine_shape_get_type", libpango.}
  type 
    PangoEngineScriptInfo* = object 
      script*: PangoScript
      langs*: ptr gchar

  type 
    PangoEngineInfo* = object 
      id*: ptr gchar
      engine_type*: ptr gchar
      render_type*: ptr gchar
      scripts*: ptr PangoEngineScriptInfo
      n_scripts*: gint

  proc script_engine_list*(engines: ptr ptr PangoEngineInfo; 
                           n_engines: ptr cint) {.
      importc: "script_engine_list", libpango.}
  proc script_engine_init*(module: ptr GTypeModule) {.
      importc: "script_engine_init", libpango.}
  proc script_engine_exit*() {.importc: "script_engine_exit", libpango.}
  proc script_engine_create*(id: cstring): ptr PangoEngine {.
      importc: "script_engine_create", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim
j='when defined(PANGO_ENABLE_ENGINE): 
  const 
    PANGO_RENDER_TYPE_NONE* = "PangoRenderNone"
  template PANGO_ENGINE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_CAST((`object`), engine_get_type(), PangoEngine))

  template PANGO_IS_ENGINE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_TYPE((`object`), engine_get_type()))

  template PANGO_ENGINE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), engine_get_type(), PangoEngineClass))

  template PANGO_IS_ENGINE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), engine_get_type()))

  template PANGO_ENGINE_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), engine_get_type(), PangoEngineClass))

  type 
    PangoEngineClass* = object 
      parent_class*: GObjectClass

  proc pango_engine_get_type*(): GType {.importc: "pango_engine_get_type", 
      libpango.}
  const 
    PANGO_ENGINE_TYPE_LANG* = "PangoEngineLang"
  template PANGO_ENGINE_LANG*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_CAST((`object`), engine_lang_get_type(), 
                                PangoEngineLang))

  template PANGO_IS_ENGINE_LANG*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_TYPE((`object`), engine_lang_get_type()))

  template PANGO_ENGINE_LANG_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), engine_lang_get_type(), 
                             PangoEngineLangClass))

  template PANGO_IS_ENGINE_LANG_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), engine_lang_get_type()))

  template PANGO_ENGINE_LANG_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), engine_lang_get_type(), 
                               PangoEngineLangClass))

  type 
    PangoEngineLangClass* = object 
      parent_class*: PangoEngineClass
      script_break*: proc (engine: ptr PangoEngineLang; text: cstring; 
                           len: cint; analysis: ptr PangoAnalysis; 
                           attrs: ptr PangoLogAttr; attrs_len: cint)

  proc pango_engine_lang_get_type*(): GType {.
      importc: "pango_engine_lang_get_type", libpango.}
  const 
    PANGO_ENGINE_TYPE_SHAPE* = "PangoEngineShape"
  template PANGO_ENGINE_SHAPE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_CAST((`object`), engine_shape_get_type(), 
                                PangoEngineShape))

  template PANGO_IS_ENGINE_SHAPE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_TYPE((`object`), engine_shape_get_type()))

  template PANGO_ENGINE_SHAPE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), engine_shape_get_type(), 
                             PangoEngine_ShapeClass))

  template PANGO_IS_ENGINE_SHAPE_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), engine_shape_get_type()))

  template PANGO_ENGINE_SHAPE_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), engine_shape_get_type(), 
                               PangoEngineShapeClass))

  type 
    PangoEngineShapeClass* = object 
      parent_class*: PangoEngineClass
      script_shape*: proc (engine: ptr PangoEngineShape; font: ptr PangoFont; 
                           item_text: cstring; item_length: cuint; 
                           analysis: ptr PangoAnalysis; 
                           glyphs: ptr PangoGlyphString; 
                           paragraph_text: cstring; paragraph_length: cuint)
      covers*: proc (engine: ptr PangoEngineShape; font: ptr PangoFont; 
                     language: ptr PangoLanguage; wc: gunichar): PangoCoverageLevel

  proc pango_engine_shape_get_type*(): GType {.
      importc: "pango_engine_shape_get_type", libpango.}
  type 
    PangoEngineScriptInfo* = object 
      script*: PangoScript
      langs*: ptr gchar

  type 
    PangoEngineInfo* = object 
      id*: ptr gchar
      engine_type*: ptr gchar
      render_type*: ptr gchar
      scripts*: ptr PangoEngineScriptInfo
      n_scripts*: gint

  proc script_engine_list*(engines: ptr ptr PangoEngineInfo; 
                           n_engines: ptr cint) {.
      importc: "script_engine_list", libpango.}
  proc script_engine_init*(module: ptr GTypeModule) {.
      importc: "script_engine_init", libpango.}
  proc script_engine_exit*() {.importc: "script_engine_exit", libpango.}
  proc script_engine_create*(id: cstring): ptr PangoEngine {.
      importc: "script_engine_create", libpango.}
'
i='proc pango_font_face_is_synthesized*(face: ptr PangoFontFace): gboolean {.
    importc: "pango_font_face_is_synthesized", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" final.nim

i='type 
  PangoAnalysis* = object 
    shape_engine*: ptr PangoEngineShape
    lang_engine*: ptr PangoEngineLang
    font*: ptr PangoFont
    level*: guint8
    gravity*: guint8
    flags*: guint8
    script*: guint8
    language*: ptr PangoLanguage
    extra_attrs*: ptr GSList
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

i='  type 
    PangoFontMap* = object 
      parent_instance*: GObject
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

i='type 
  PangoLogAttr* = object 
    bitfield0PangoLogAttr*: guint
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

k='type 
  PangoFontDescription* = object 
  '
# caution, LF is necessary
j='
when defined(PANGO_ENABLE_ENGINE): 
  type 
    PangoEngine* = object 
      parent_instance*: GObject
  type 
    PangoEngineShape* = object 
      parent_instance*: PangoEngine
  #type 
    PangoEngineLang* = object 
      parent_instance*: PangoEngine
else:
  type 
    PangoEngineShape* = object 
  type 
    PangoEngine* = object 
  type 
    PangoEngineLang* = object 

when defined(PANGO_ENABLE_BACKEND): 
  type 
    PangoFont* = object 
      parent_instance*: GObject
  type 
    PangoFontMap* = object 
      parent_instance*: GObject
else:
  type 
    PangoFont* = object 
  type 
    PangoFontMap* = object 

type 
  PangoAnalysis* = object 
    shape_engine*: ptr PangoEngineShape
    lang_engine*: ptr PangoEngineLang
    font*: ptr PangoFont
    level*: guint8
    gravity*: guint8
    flags*: guint8
    script*: guint8
    language*: ptr PangoLanguage
    extra_attrs*: ptr GSList
type 
  PangoLogAttr* = object 
    bitfield0PangoLogAttr*: guint
'
perl -0777 -p -i -e "s~\Q$k\E~$k$j~s" final.nim

i='template PANGO_FONTSET*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_CAST((`object`), fontset_get_type(), PangoFontset))

template PANGO_IS_FONTSET*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_TYPE((`object`), fontset_get_type()))

proc pango_fontset_get_type*(): GType {.importc: "pango_fontset_get_type", 
    libpango.}
type 
  PangoFontsetForeachFunc* = proc (fontset: ptr PangoFontset; 
                                   font: ptr PangoFont; user_data: gpointer): gboolean
proc pango_fontset_get_font*(fontset: ptr PangoFontset; wc: guint): ptr PangoFont {.
    importc: "pango_fontset_get_font", libpango.}
proc pango_fontset_get_metrics*(fontset: ptr PangoFontset): ptr PangoFontMetrics {.
    importc: "pango_fontset_get_metrics", libpango.}
proc pango_fontset_foreach*(fontset: ptr PangoFontset; 
                            `func`: PangoFontsetForeachFunc; data: gpointer) {.
    importc: "pango_fontset_foreach", libpango.}
when defined(PANGO_ENABLE_BACKEND): 
  template PANGO_FONTSET_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), fontset_get_type(), PangoFontsetClass))

  template PANGO_IS_FONTSET_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), fontset_get_type()))

  template PANGO_FONTSET_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), fontset_get_type(), PangoFontsetClass))

  type 
    PangoFontset* = object 
      parent_instance*: GObject

  type 
    PangoFontsetClass* = object 
      parent_class*: GObjectClass
      get_font*: proc (fontset: ptr PangoFontset; wc: guint): ptr PangoFont
      get_metrics*: proc (fontset: ptr PangoFontset): ptr PangoFontMetrics
      get_language*: proc (fontset: ptr PangoFontset): ptr PangoLanguage
      foreach*: proc (fontset: ptr PangoFontset; 
                      `func`: PangoFontsetForeachFunc; data: gpointer)
      pango_reserved1: proc ()
      pango_reserved2: proc ()
      pango_reserved3: proc ()
      pango_reserved4: proc ()

  template PANGO_FONTSET_SIMPLE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_CAST((`object`), fontset_simple_get_type(), 
                                PangoFontsetSimple))

  template PANGO_IS_FONTSET_SIMPLE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_TYPE((`object`), fontset_simple_get_type()))

  type 
    PangoFontsetSimple* = object 
    
  proc pango_fontset_simple_get_type*(): GType {.
      importc: "pango_fontset_simple_get_type", libpango.}
  proc pango_fontset_simple_new*(language: ptr PangoLanguage): ptr PangoFontsetSimple {.
      importc: "pango_fontset_simple_new", libpango.}
  proc pango_fontset_simple_append*(fontset: ptr PangoFontsetSimple; 
                                    font: ptr PangoFont) {.
      importc: "pango_fontset_simple_append", libpango.}
  proc pango_fontset_simple_size*(fontset: ptr PangoFontsetSimple): cint {.
      importc: "pango_fontset_simple_size", libpango.}
'
j='when defined(PANGO_ENABLE_BACKEND): 
  template PANGO_FONTSET_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_CAST((klass), fontset_get_type(), PangoFontsetClass))

  template PANGO_IS_FONTSET_CLASS*(klass: expr): expr = 
    (G_TYPE_CHECK_CLASS_TYPE((klass), fontset_get_type()))

  template PANGO_FONTSET_GET_CLASS*(obj: expr): expr = 
    (G_TYPE_INSTANCE_GET_CLASS((obj), fontset_get_type(), PangoFontsetClass))

  type 
    PangoFontset* = object 
      parent_instance*: GObject
  type 
    PangoFontsetForeachFunc* = proc (fontset: ptr PangoFontset; 
                                   font: ptr PangoFont; user_data: gpointer): gboolean

  type 
    PangoFontsetClass* = object 
      parent_class*: GObjectClass
      get_font*: proc (fontset: ptr PangoFontset; wc: guint): ptr PangoFont
      get_metrics*: proc (fontset: ptr PangoFontset): ptr PangoFontMetrics
      get_language*: proc (fontset: ptr PangoFontset): ptr PangoLanguage
      foreach*: proc (fontset: ptr PangoFontset; 
                      `func`: PangoFontsetForeachFunc; data: gpointer)
      pango_reserved1: proc ()
      pango_reserved2: proc ()
      pango_reserved3: proc ()
      pango_reserved4: proc ()

  template PANGO_FONTSET_SIMPLE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_CAST((`object`), fontset_simple_get_type(), 
                                PangoFontsetSimple))

  template PANGO_IS_FONTSET_SIMPLE*(`object`: expr): expr = 
    (G_TYPE_CHECK_INSTANCE_TYPE((`object`), fontset_simple_get_type()))

  type 
    PangoFontsetSimple* = object 
    
  proc pango_fontset_simple_get_type*(): GType {.
      importc: "pango_fontset_simple_get_type", libpango.}
  proc pango_fontset_simple_new*(language: ptr PangoLanguage): ptr PangoFontsetSimple {.
      importc: "pango_fontset_simple_new", libpango.}
  proc pango_fontset_simple_append*(fontset: ptr PangoFontsetSimple; 
                                    font: ptr PangoFont) {.
      importc: "pango_fontset_simple_append", libpango.}
  proc pango_fontset_simple_size*(fontset: ptr PangoFontsetSimple): cint {.
      importc: "pango_fontset_simple_size", libpango.}
else:
  type 
    PangoFontset* = object 
  type 
    PangoFontsetForeachFunc* = proc (fontset: ptr PangoFontset; 
                                     font: ptr PangoFont; user_data: gpointer): gboolean

template PANGO_FONTSET*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_CAST((`object`), fontset_get_type(), PangoFontset))

template PANGO_IS_FONTSET*(`object`: expr): expr = 
  (G_TYPE_CHECK_INSTANCE_TYPE((`object`), fontset_get_type()))

proc pango_fontset_get_type*(): GType {.importc: "pango_fontset_get_type", 
    libpango.}
proc pango_fontset_get_font*(fontset: ptr PangoFontset; wc: guint): ptr PangoFont {.
    importc: "pango_fontset_get_font", libpango.}
proc pango_fontset_get_metrics*(fontset: ptr PangoFontset): ptr PangoFontMetrics {.
    importc: "pango_fontset_get_metrics", libpango.}
proc pango_fontset_foreach*(fontset: ptr PangoFontset; 
                            `func`: PangoFontsetForeachFunc; data: gpointer) {.
    importc: "pango_fontset_foreach", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='const 
  PANGO_GLYPH_EMPTY* = (cast[PangoGlyph](0x0FFFFFFF))
  PANGO_GLYPH_INVALID_INPUT* = (cast[PangoGlyph](0xFFFFFFFF))
  PANGO_GLYPH_UNKNOWN_FLAG* = (cast[PangoGlyph](0x10000000))
'
j='const 
  PANGO_GLYPH_EMPTY* = PangoGlyph(0x0FFFFFFF)
  PANGO_GLYPH_INVALID_INPUT* = PangoGlyph(0xFFFFFFFF)
  PANGO_GLYPH_UNKNOWN_FLAG* = PangoGlyph(0x10000000)
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim


i='type 
  PangoAttribute* = object 
    klass*: ptr PangoAttrClass
    start_index*: guint
    end_index*: guint

type 
  PangoAttrFilterFunc* = proc (attribute: ptr PangoAttribute; 
                               user_data: gpointer): gboolean
type 
  PangoAttrDataCopyFunc* = proc (user_data: gconstpointer): gpointer
type 
'
j='type 
  PangoAttribute* = object 
    klass*: ptr PangoAttrClass
    start_index*: guint
    end_index*: guint

#type 
  PangoAttrFilterFunc* = proc (attribute: ptr PangoAttribute; 
                               user_data: gpointer): gboolean
#type 
  PangoAttrDataCopyFunc* = proc (user_data: gconstpointer): gpointer 
#type 
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

# legacy 0.9.6 xlib symbols
sed -i 's/\bptr Display\b/PDisplay/' final.nim
sed -i 's/\bptr LOGFONTA\b/PLOGFONTA/' final.nim

i='when defined(XftVersion) and XftVersion >= 20000: 
else: 
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

ruby ../fix_template.rb final.nim

i='type 
  PangoGlyphUnit* = gint32
type 
  PangoGlyphGeometry* = object 
    width*: PangoGlyphUnit
    x_offset*: PangoGlyphUnit
    y_offset*: PangoGlyphUnit

type 
  PangoGlyphVisAttr* = object 
    bitfield0PangoGlyphVisAttr*: guint

type 
  PangoGlyphInfo* = object 
    glyph*: PangoGlyph
    geometry*: PangoGlyphGeometry
    attr*: PangoGlyphVisAttr

type 
  PangoGlyphString* = object 
    num_glyphs*: gint
    glyphs*: ptr PangoGlyphInfo
    log_clusters*: ptr gint
    space*: gint
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim
j='type 
  PangoGlyph* = guint32
'
perl -0777 -p -i -e "s~\Q$j\E~$j$i~s" final.nim

i='  const 
    PANGO_OT_ALL_GLYPHS* = (cast[guint](0x0000FFFF))
    PANGO_OT_NO_FEATURE* = (cast[guint](0x0000FFFF))
    PANGO_OT_NO_SCRIPT* = (cast[guint](0x0000FFFF))
    PANGO_OT_DEFAULT_LANGUAGE* = (cast[guint](0x0000FFFF))
'
j='  const 
    PANGO_OT_ALL_GLYPHS* = guint(0x0000FFFF)
    PANGO_OT_NO_FEATURE* = guint(0x0000FFFF)
    PANGO_OT_NO_SCRIPT* = guint(0x0000FFFF)
    PANGO_OT_DEFAULT_LANGUAGE* = guint(0x0000FFFF)
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i="  const 
    PANGO_OT_TAG_DEFAULT_SCRIPT* = pango_ot_tag_make('D', 'F', 'L', 'T')
    PANGO_OT_TAG_DEFAULT_LANGUAGE* = pango_ot_tag_make('d', 'f', 'l', 't')
"
j='  #const 
    #PANGO_OT_TAG_DEFAULT_SCRIPT* = pango_ot_tag_make('D', 'F', 'L', 'T')
    #PANGO_OT_TAG_DEFAULT_LANGUAGE* = pango_ot_tag_make('d', 'f', 'l', 't')
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

ruby ../glib_fix_proc.rb final.nim
sed -i -f ../cairo_sedlist final.nim
sed -i -f ../glib_sedlist final.nim
sed -i -f ../gobject_sedlist final.nim

i='from glib import guint8, guint16, gint32, guint32, gint, guint, gushort, gulong, gchar, guchar, gunichar, gdouble,
  gboolean, gpointer, gconstpointer, GList, GSList, GString, GError, GDestroyNotify, GMarkupParseContext, G_MAXUINT

from gobject import GObjectObj, GObjectClassObj, GType, GTypeModule,
  g_type_check_class_type, g_type_check_class_cast, g_type_check_instance_cast, g_type_check_instance_type

'
j='when defined(windows): 
  const LIB_PANGO* = "libpango-1.0-0.dll"
'
perl -0777 -p -i -e "s~\Q$j\E~$i$j~s" final.nim

ruby ../glib_fix_T.rb final.nim pango Pango

sed -i 's/ PANGO_ALIGN_/ PANGO_ALIGNMENT_/g' final.nim
ruby ../glib_fix_enum_prefix.rb final.nim

# generate procs without get_ and set_ prefix
perl -0777 -p -i -e "s/(\n\s*)(proc set_)(\w+)(\*\([^}]*\) {[^}]*})/\$&\1proc \`\3=\`\4/sg" final.nim
perl -0777 -p -i -e "s/(\n\s*)(proc get_)(\w+)(\*\([^}]*\): \w[^}]*})/\$&\1proc \3\4/sg" final.nim

sed -i 's/^proc iterator\*(/proc `iterator`\*(/g' final.nim

sed -i 's/^proc ref\*(/proc `ref`\*(/g' final.nim
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
sed -i 's/\bgobject\.GObjectClassObj\b/GObjectClassObj/g' final.nim

sed -i 's/ ptr gchar\b/ cstring/g' final.nim
sed -i 's/ ptr var / var ptr /g' final.nim

i='const 
  STRICT* = true
when not(defined(WIN32_WINNT)): 
  const 
    WIN32_WINNT = 0x00000501
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

i='template i(string: expr): expr = 
  g_intern_static_string(string)
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

sed -i 's/when not(defined(PANGO_DISABLE_DEPRECATED))/when not PANGO_DISABLE_DEPRECATED/g' final.nim
sed -i 's/when defined(PANGO_ENABLE_BACKEND)/when PANGO_ENABLE_BACKEND/g' final.nim
sed -i 's/ or defined(PANGO_ENABLE_BACKEND)/ or PANGO_ENABLE_BACKEND/g' final.nim
sed -i 's/when defined(PANGO_ENABLE_ENGINE)/when PANGO_ENABLE_ENGINE/g' final.nim

# the gobject lower case templates
sed -i 's/\bG_TYPE_CHECK_CLASS_TYPE\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_CHECK_CLASS_CAST\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_CHECK_INSTANCE_CAST\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_CHECK_INSTANCE_TYPE\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_INSTANCE_GET_CLASS\b/\L&/g' final.nim

# these procs may be private only
i='proc pango_shape_shape(text: cstring; n_chars: cuint; 
                         shape_ink: PangoRectangle; 
                         shape_logical: PangoRectangle; 
                         glyphs: PangoGlyphString) {.
    importc: "_pango_shape_shape", libpango.}
proc pango_shape_get_extents(n_chars: gint; shape_ink: PangoRectangle; 
                               shape_logical: PangoRectangle; 
                               ink_rect: PangoRectangle; 
                               logical_rect: PangoRectangle) {.
    importc: "_pango_shape_get_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

i='proc pango_core_text_font_set_font_map(afont: PangoCoreTextFont; 
    fontmap: PangoCoreTextFontMap) {.
    importc: "_pango_core_text_font_set_font_map", libpango.}
proc pango_core_text_font_set_face(afont: PangoCoreTextFont; 
                                     aface: PangoCoreTextFace) {.
    importc: "_pango_core_text_font_set_face", libpango.}
proc pango_core_text_font_get_face(font: PangoCoreTextFont): PangoCoreTextFace {.
    importc: "_pango_core_text_font_get_face", libpango.}
proc pango_core_text_font_get_context_key(afont: PangoCoreTextFont): gpointer {.
    importc: "_pango_core_text_font_get_context_key", libpango.}
proc pango_core_text_font_set_context_key(afont: PangoCoreTextFont; 
    context_key: gpointer) {.importc: "_pango_core_text_font_set_context_key", 
                             libpango.}
proc pango_core_text_font_set_font_key(font: PangoCoreTextFont; 
    key: PangoCoreTextFontKey) {.importc: "_pango_core_text_font_set_font_key", 
                                     libpango.}
proc pango_core_text_font_set_ctfont(font: PangoCoreTextFont; 
    font_ref: CTFontRef) {.importc: "_pango_core_text_font_set_ctfont", 
                           libpango.}
proc pango_core_text_font_description_from_ct_font_descriptor(
    desc: CTFontDescriptorRef): PangoFontDescription {.
    importc: "_pango_core_text_font_description_from_ct_font_descriptor", 
    libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

i='proc pango_cairo_core_text_font_new(cafontmap: PangoCairoCoreTextFontMap; 
                                      key: PangoCoreTextFontKey): PangoCoreTextFont {.
    importc: "_pango_cairo_core_text_font_new", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~~s" final.nim

sed -i 's/ ptr ptr / variableptr /g' final.nim
sed -i 's/ ptr cint/ var cint/g' final.nim
sed -i 's/ ptr gint/ var gint/g' final.nim
sed -i 's/ ptr cdouble/ var cdouble/g' final.nim
sed -i 's/ ptr gunichar/ var gunichar/g' final.nim
sed -i 's/ variableptr / var ptr /g' final.nim


perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( PangoStyle)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( PangoVariant)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( PangoWeight)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( PangoStretch)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( PangoDirection)/\1\2\3\4var\6/sg' final.nim



sed -i 's/PangoAttributeObj\* = object/PangoAttributeObj*{.inheritable, pure.} = object/g' final.nim
sed -i 's/PangoEngineClassObj\*{\.final\.} = object of GObjectClassObj/PangoEngineClassObj* = object of GObjectClassObj/g' final.nim
sed -i 's/PangoRendererClassObj\*{\.final\.} = object of GObjectClassObj/PangoRendererClassObj* = object of GObjectClassObj/g' final.nim
sed -i 's/PangoFontMapClassObj\*{\.final\.} = object of GObjectClassObj/PangoFontMapClassObj* = object of GObjectClassObj/g' final.nim
sed -i 's/PangoFontClassObj\*{\.final\.} = object of GObjectClassObj/PangoFontClassObj* = object of GObjectClassObj/g' final.nim
sed -i 's/PangoRendererObj\*{\.final\.} = object of GObjectObj/PangoRendererObj* = object of GObjectObj/g' final.nim
sed -i 's/PangoEngineObj\*{\.final\.} = object of GObjectObj/PangoEngineObj* = object of GObjectObj/g' final.nim
sed -i 's/PangoFontMapObj\*{\.final\.} = object of GObjectObj/PangoFontMapObj* = object of GObjectObj/g' final.nim
sed -i 's/PangoCoreTextFontMapObj\*{\.final\.} = object of PangoFontMapObj/PangoCoreTextFontMapObj* = object of PangoFontMapObj/g' final.nim
sed -i 's/PangoFontObj\*{\.final\.} = object of GObjectObj/PangoFontObj* = object of GObjectObj/g' final.nim
sed -i 's/priv\*: PangoXftRendererPrivate/priv00: PangoXftRendererPrivate/g' final.nim

i='  PangoCairoCoreTextFontMapObj*{.final.} = object of PangoCoreTextFontMapObj
    serial*: guint
    dpi*: gdouble
'
j='  PangoCairoCoreTextFontMapObj*{.final.} = object of PangoCoreTextFontMapObj
    serial_cairo*: guint
    dpi*: gdouble
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

# some procs with get_ prefix do not return something but need var objects instead of pointers:
# vim search term for candidates: proc get_.*\n\?.*\n\?.*) {
i='proc get_glyph_extents*(font: PangoFont; glyph: PangoGlyph; 
                                   ink_rect: PangoRectangle; 
                                   logical_rect: PangoRectangle) {.
    importc: "pango_font_get_glyph_extents", libpango.}
'
j='proc get_glyph_extents*(font: PangoFont; glyph: PangoGlyph; 
                                   ink_rect: var PangoRectangleObj; 
                                   logical_rect: var PangoRectangleObj) {.
    importc: "pango_font_get_glyph_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_cursor_pos*(layout: PangoLayout; index: cint; 
                                  strong_pos: PangoRectangle; 
                                  weak_pos: PangoRectangle) {.
    importc: "pango_layout_get_cursor_pos", libpango.}
'
j='proc get_cursor_pos*(layout: PangoLayout; index: cint; 
                                  strong_pos: var PangoRectangleObj; 
                                  weak_pos: var PangoRectangleObj) {.
    importc: "pango_layout_get_cursor_pos", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_extents*(layout: PangoLayout; 
                               ink_rect: PangoRectangle; 
                               logical_rect: PangoRectangle) {.
    importc: "pango_layout_get_extents", libpango.}
'
j='proc get_extents*(layout: PangoLayout; 
                               ink_rect: var PangoRectangleObj; 
                               logical_rect: var PangoRectangleObj) {.
    importc: "pango_layout_get_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_pixel_extents*(layout: PangoLayout; 
                                     ink_rect: PangoRectangle; 
                                     logical_rect: PangoRectangle) {.
    importc: "pango_layout_get_pixel_extents", libpango.}
'
j='proc get_pixel_extents*(layout: PangoLayout; 
                                     ink_rect: var PangoRectangleObj; 
                                     logical_rect: var PangoRectangleObj) {.
    importc: "pango_layout_get_pixel_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_extents*(line: PangoLayoutLine; 
                                    ink_rect: PangoRectangle; 
                                    logical_rect: PangoRectangle) {.
    importc: "pango_layout_line_get_extents", libpango.}
'
j='proc get_extents*(line: PangoLayoutLine; 
                                    ink_rect: var PangoRectangleObj; 
                                    logical_rect: var PangoRectangleObj) {.
    importc: "pango_layout_line_get_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_pixel_extents*(layout_line: PangoLayoutLine; 
    ink_rect: PangoRectangle; logical_rect: PangoRectangle) {.
    importc: "pango_layout_line_get_pixel_extents", libpango.}
'
j='proc get_pixel_extents*(layout_line: PangoLayoutLine; 
    ink_rect: var PangoRectangleObj; logical_rect: var PangoRectangleObj) {.
    importc: "pango_layout_line_get_pixel_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_char_extents*(iter: PangoLayoutIter; 
    logical_rect: PangoRectangle) {.
    importc: "pango_layout_iter_get_char_extents", libpango.}
'
j='proc get_char_extents*(iter: PangoLayoutIter; 
    logical_rect: var PangoRectangleObj) {.
    importc: "pango_layout_iter_get_char_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_cluster_extents*(iter: PangoLayoutIter; 
    ink_rect: PangoRectangle; logical_rect: PangoRectangle) {.
    importc: "pango_layout_iter_get_cluster_extents", libpango.}
'
j='proc get_cluster_extents*(iter: PangoLayoutIter; 
    ink_rect: var PangoRectangleObj; logical_rect: var PangoRectangleObj) {.
    importc: "pango_layout_iter_get_cluster_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_run_extents*(iter: PangoLayoutIter; 
    ink_rect: PangoRectangle; logical_rect: PangoRectangle) {.
    importc: "pango_layout_iter_get_run_extents", libpango.}
'
j='proc get_run_extents*(iter: PangoLayoutIter; 
    ink_rect: var PangoRectangleObj; logical_rect: var PangoRectangleObj) {.
    importc: "pango_layout_iter_get_run_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_line_extents*(iter: PangoLayoutIter; 
    ink_rect: PangoRectangle; logical_rect: PangoRectangle) {.
    importc: "pango_layout_iter_get_line_extents", libpango.}
'
j='proc get_line_extents*(iter: PangoLayoutIter; 
    ink_rect: var PangoRectangleObj; logical_rect: var PangoRectangleObj) {.
    importc: "pango_layout_iter_get_line_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc get_layout_extents*(iter: PangoLayoutIter; 
    ink_rect: PangoRectangle; logical_rect: PangoRectangle) {.
    importc: "pango_layout_iter_get_layout_extents", libpango.}
'
j='proc get_layout_extents*(iter: PangoLayoutIter; 
    ink_rect: var PangoRectangleObj; logical_rect: var PangoRectangleObj) {.
    importc: "pango_layout_iter_get_layout_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proci extents*(glyphs: PangoGlyphString; 
                                 font: PangoFont; 
                                 ink_rect: PangoRectangle; 
                                 logical_rect: PangoRectangle) {.
    importc: "pango_glyph_string_extents", libpango.}
'
j='proci extents*(glyphs: PangoGlyphString; 
                                 font: PangoFont; 
                                 ink_rect: var PangoRectangleObj; 
                                 logical_rect: var PangoRectangleObj) {.
    importc: "pango_glyph_string_extents", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc extents_range*(glyphs: PangoGlyphString; 
    start: cint; `end`: cint; font: PangoFont; ink_rect: PangoRectangle; 
    logical_rect: PangoRectangle) {.
    importc: "pango_glyph_string_extents_range", libpango.}
'
j='proc extents_range*(glyphs: PangoGlyphString; 
    start: cint; `end`: cint; font: PangoFont; ink_rect: var PangoRectangleObj; 
    logical_rect: var PangoRectangleObj) {.
    importc: "pango_glyph_string_extents_range", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='proc index_to_pos*(layout: PangoLayout; index: cint; 
                                pos: PangoRectangle) {.
    importc: "pango_layout_index_to_pos", libpango.}
'
j='proc index_to_pos*(layout: PangoLayout; index: cint; 
                                pos: var PangoRectangleObj) {.
    importc: "pango_layout_index_to_pos", libpango.}
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

i='type 
  PangoRenderer* =  ptr PangoRendererObj
  PangoRendererPtr* = ptr PangoRendererObj
  PangoRendererObj* = object of GObjectObj
    underline*: PangoUnderline
    strikethrough*: gboolean
    active_count*: cint
    matrix*: PangoMatrix
    priv*: ptr PangoRendererPrivateObj
'
j='type 
  PangoRenderer* =  ptr PangoRendererObj
  PangoRendererPtr* = ptr PangoRendererObj
  PangoRendererObj* = object of GObjectObj
    underline*: PangoUnderline
    strikethrough*: gboolean
    active_count*: cint
    matrix*: PangoMatrix
    priv0*: ptr PangoRendererPrivateObj
'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

# allow passing objects to wrapper procs
i='type 
  PangoRectangle* =  ptr PangoRectangleObj
  PangoRectanglePtr* = ptr PangoRectangleObj
  PangoRectangleObj* = object 
    x*: cint
    y*: cint
    width*: cint
    height*: cint
'
j='converter PRO2PCP(o: var PangoRectangleObj): PangoRectangle =
  addr(o)
'
perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" final.nim
i='type 
  PangoMatrix* =  ptr PangoMatrixObj
  PangoMatrixPtr* = ptr PangoMatrixObj
  PangoMatrixObj* = object 
    xx*: cdouble
    xy*: cdouble
    yx*: cdouble
    yy*: cdouble
    x0*: cdouble
    y0*: cdouble
'
j='converter PMO2PMP(o: var PangoMatrixObj): PangoMatrix =
  addr(o)
'
perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" final.nim
i='type 
  PangoColor* =  ptr PangoColorObj
  PangoColorPtr* = ptr PangoColorObj
  PangoColorObj* = object 
    red*: guint16
    green*: guint16
    blue*: guint16
'
j='converter PCO2PCP(o: var PangoColorObj): PangoColor =
  addr(o)
'
perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" final.nim

sed -i "s/\(^\s*proc \)pango_/\1/g" final.nim
sed -i 's/^proc break\*(/proc `break`\*(/g' final.nim

sed -i 's/\bPangoXftFontObj\b/PXXXangoXftFontObj/g' final.nim
sed -i 's/\bPangoXftFontPtr\b/PXXXangoXftFontPtr/g' final.nim
sed -i 's/\bPangoXftFont\b/PXXXangoXftFont/g' final.nim
ruby ../mangler.rb final.nim Pango
sed -i 's/\bPXXXangoXftFontObj\b/PangoXftFontObj/g' final.nim
sed -i 's/\bPXXXangoXftFontPtr\b/PangoXftFontPtr/g' final.nim
sed -i 's/\bPXXXangoXftFont\b/PangoXftFont/g' final.nim

sed -i 's/SCALE, FALLBACK,/XXXSCALE, FALLBACK,/' final.nim
ruby ../mangler.rb final.nim PANGO_
sed -i 's/XXXSCALE, FALLBACK,/SCALE, FALLBACK,/' final.nim

# now separare the cairo, win32 and other submodules
i='### "pango/./pangowin32.h"'
j='
{.deadCodeElim: on.}
import pango
from glib import gint, gunichar, gboolean
from windows import HDC, HFONT, PLOGFONTA, LOGFONTW
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
'
perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" final.nim
csplit final.nim "/$i/"
mv xx00 final.nim
cat -s xx01 > pango_win32.nim
sed  -i "s/proc pango_win32_/proc /g" pango_win32.nim

i='### "pango/./pangocoretext.h"'
j='
{.deadCodeElim: on.}
import pango
from glib import guint, GHashTable, gpointer, gconstpointer, guint32, gdouble, gboolean
from gobject import GType
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  CTFontRef = ptr object # dummy objects!
  CTFontDescriptorRef = ptr object
'
perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" final.nim
csplit final.nim "/$i/"
mv xx00 final.nim
cat -s xx01 > pango_coretext.nim

i='### "pango/./pangoft2.h"'
j='
{.deadCodeElim: on.}
import pango
from glib import gpointer, gint, GDestroyNotify
from gobject import GType
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  FT_Face = ptr object # dummy objects!
  FcPattern = object
  FT_Bitmap = object
'
perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" final.nim
csplit final.nim "/$i/"
mv xx00 final.nim
cat -s xx01 > pango_ft2.nim
sed  -i "s/proc pango_ft2_/proc /g" pango_ft2.nim

i='### "pango/./pangoxft-render.h"'
j='
{.deadCodeElim: on.}
import pango
from glib import gint, guint, gboolean, gpointer, gunichar, GDestroyNotify
from gobject import GType
from xlib import PDisplay
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  Picture = ptr object # dummy objects!
  FcPattern = object
  FT_Face = ptr object
  XftDraw = object
  XTrapezoid = object
  XftGlyphSpec = object
  XftFont = object
  XftColor = object
'
perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" final.nim
csplit final.nim "/$i/"
mv xx00 final.nim
cat -s  xx01 > pango_xft.nim
sed  -i "s/proc pango_xft_/proc /g" pango_xft.nim

i='### "pango/./pangocairo.h"'
j='
{.deadCodeElim: on.}
import pango
from cairo import TheCairoContext, Font_type, Font_options, Scaled_Font
from glib import gboolean, gpointer, GDestroyNotify
from gobject import GType
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
'
perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" final.nim
csplit final.nim "/$i/"
mv xx00 final.nim
sed -i 's/ Context\b/ pango.Context/g' xx01
sed -i 's/ TheCairoContext\b/ Context/g' xx01
cat -s xx01 > pango_cairo.nim
sed  -i "s/proc pango_cairo_/proc /g" pango_cairo.nim

i='### "pango/./pango-ot.h"'
j='
{.deadCodeElim: on.}
import pango
from glib import guint32, guint, gushort, gulong, gboolean
from gobject import GType
from pango_fc import FcFont
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  FT_Face = ptr object # dummy objects!
'
perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" final.nim
csplit final.nim "/$i/"
mv xx00 final.nim
cat -s xx01 > pango_ot.nim
sed  -i "s/proc pango_ot_/proc /g" pango_ot.nim

i='### "pango/./pangofc-font.h"'
j='
{.deadCodeElim: on.}
import pango
from glib import gpointer, GSList, guint, guint32, gunichar, gconstpointer, gboolean, GDestroyNotify
from gobject import GType, GObjectObj, GObjectClassObj
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  FT_Face = ptr object # dummy objects!
  FcPattern = object
  FcCharSet = object
'
perl -0777 -p -i -e "s~\Q$i\E~$i$j~s" final.nim
csplit final.nim "/$i/"
mv xx00 final.nim
cat -s xx01 > pango_fc.nim
sed  -i "s/proc pango_fc_/proc /g" pango_ot.nim

# do we like the file markers?
for i in "pango*.nim final.nim"; do
  sed -i '/### "pango\/\.\/pango/d' $i
done

sed  -i "s/pango_reserved/&0/g" final.nim
cat -s final.nim > pango.nim

rm -rf pango
rm -rf Carbon
rm cairo-quartz.h windows.h list.txt final.h final.nim xx01

exit

