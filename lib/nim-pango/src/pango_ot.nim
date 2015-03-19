{.deadCodeElim: on.}
import pango
from glib import guint32, guint, gushort, gulong, gboolean
from gobject import GType
from pango_fc import FcFont
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  FT_Face = ptr object # dummy objects!

when ENABLE_ENGINE: 
  type 
    OTTag* = guint32
  template pango_ot_tag_make*(c1, c2, c3, c4: expr): expr = 
    (cast[OTTag](FT_MAKE_TAG(c1, c2, c3, c4)))

  template pango_ot_tag_make_from_string*(s: expr): expr = 
    (pango_ot_tag_make((cast[cstring](s))[0], (cast[cstring](s))[1], 
                       (cast[cstring](s))[2], (cast[cstring](s))[3]))

  type 
    OTInfo* =  ptr OTInfoObj
    OTInfoPtr* = ptr OTInfoObj
    OTInfoObj* = object 
    
    OTBuffer* =  ptr OTBufferObj
    OTBufferPtr* = ptr OTBufferObj
    OTBufferObj* = object 
    
    OTRuleset* =  ptr OTRulesetObj
    OTRulesetPtr* = ptr OTRulesetObj
    OTRulesetObj* = object 
    
  type 
    OTTableType* {.size: sizeof(cint), pure.} = enum 
      GSUB, GPOS
  const 
    OT_ALL_GLYPHS* = guint(0x0000FFFF)
    OT_NO_FEATURE* = guint(0x0000FFFF)
    OT_NO_SCRIPT* = guint(0x0000FFFF)
    OT_DEFAULT_LANGUAGE* = guint(0x0000FFFF)
  #const 
    #OT_TAG_DEFAULT_SCRIPT* = pango_ot_tag_make(D, F, L, T)
    #OT_TAG_DEFAULT_LANGUAGE* = pango_ot_tag_make(d, f, l, t)
  type 
    OTGlyph* =  ptr OTGlyphObj
    OTGlyphPtr* = ptr OTGlyphObj
    OTGlyphObj* = object 
      glyph*: guint32
      properties*: guint
      cluster*: guint
      component*: gushort
      ligID*: gushort
      internal*: guint

  type 
    OTFeatureMap* =  ptr OTFeatureMapObj
    OTFeatureMapPtr* = ptr OTFeatureMapObj
    OTFeatureMapObj* = object 
      feature_name*: array[5, char]
      property_bit*: gulong

  type 
    OTRulesetDescription* =  ptr OTRulesetDescriptionObj
    OTRulesetDescriptionPtr* = ptr OTRulesetDescriptionObj
    OTRulesetDescriptionObj* = object 
      script*: Script
      language*: Language
      static_gsub_features*: OTFeatureMap
      n_static_gsub_features*: guint
      static_gpos_features*: OTFeatureMap
      n_static_gpos_features*: guint
      other_features*: OTFeatureMap
      n_other_features*: guint

  template pango_ot_info*(`object`: expr): expr = 
    (g_type_check_instance_cast(`object`, ot_info_get_type(), OTInfoObj))

  template pango_is_ot_info*(`object`: expr): expr = 
    (g_type_check_instance_type(`object`, ot_info_get_type()))

  proc ot_info_get_type*(): GType {.importc: "pango_ot_info_get_type", 
      libpango.}
  template pango_ot_ruleset*(`object`: expr): expr = 
    (g_type_check_instance_cast(`object`, ot_ruleset_get_type(), 
                                OTRulesetObj))

  template pango_is_ot_ruleset*(`object`: expr): expr = 
    (g_type_check_instance_type(`object`, ot_ruleset_get_type()))

  proc ot_ruleset_get_type*(): GType {.
      importc: "pango_ot_ruleset_get_type", libpango.}
  proc ot_info_get*(face: FT_Face): OTInfo {.
      importc: "pango_ot_info_get", libpango.}
  proc find_script*(info: OTInfo; 
                                  table_type: OTTableType; 
                                  script_tag: OTTag; 
                                  script_index: ptr guint): gboolean {.
      importc: "pango_ot_info_find_script", libpango.}
  proc find_language*(info: OTInfo; 
                                    table_type: OTTableType; 
                                    script_index: guint; 
                                    language_tag: OTTag; 
                                    language_index: ptr guint; 
                                    required_feature_index: ptr guint): gboolean {.
      importc: "pango_ot_info_find_language", libpango.}
  proc find_feature*(info: OTInfo; 
                                   table_type: OTTableType; 
                                   feature_tag: OTTag; 
                                   script_index: guint; language_index: guint; 
                                   feature_index: ptr guint): gboolean {.
      importc: "pango_ot_info_find_feature", libpango.}
  proc list_scripts*(info: OTInfo; 
                                   table_type: OTTableType): ptr OTTag {.
      importc: "pango_ot_info_list_scripts", libpango.}
  proc list_languages*(info: OTInfo; 
                                     table_type: OTTableType; 
                                     script_index: guint; 
                                     language_tag: OTTag): ptr OTTag {.
      importc: "pango_ot_info_list_languages", libpango.}
  proc list_features*(info: OTInfo; 
                                    table_type: OTTableType; 
                                    tag: OTTag; script_index: guint; 
                                    language_index: guint): ptr OTTag {.
      importc: "pango_ot_info_list_features", libpango.}
  proc ot_buffer_new*(font: FcFont): OTBuffer {.
      importc: "pango_ot_buffer_new", libpango.}
  proc destroy*(buffer: OTBuffer) {.
      importc: "pango_ot_buffer_destroy", libpango.}
  proc clear*(buffer: OTBuffer) {.
      importc: "pango_ot_buffer_clear", libpango.}
  proc set_rtl*(buffer: OTBuffer; rtl: gboolean) {.
      importc: "pango_ot_buffer_set_rtl", libpango.}
  proc `rtl=`*(buffer: OTBuffer; rtl: gboolean) {.
      importc: "pango_ot_buffer_set_rtl", libpango.}
  proc add_glyph*(buffer: OTBuffer; glyph: guint; 
                                  properties: guint; cluster: guint) {.
      importc: "pango_ot_buffer_add_glyph", libpango.}
  proc get_glyphs*(buffer: OTBuffer; 
                                   glyphs: var OTGlyph; 
                                   n_glyphs: var cint) {.
      importc: "pango_ot_buffer_get_glyphs", libpango.}
  proc output*(buffer: OTBuffer; 
                               glyphs: GlyphString) {.
      importc: "pango_ot_buffer_output", libpango.}
  proc set_zero_width_marks*(buffer: OTBuffer; 
      zero_width_marks: gboolean) {.importc: "pango_ot_buffer_set_zero_width_marks", 
                                    libpango.}
  proc `zero_width_marks=`*(buffer: OTBuffer; 
      zero_width_marks: gboolean) {.importc: "pango_ot_buffer_set_zero_width_marks", 
                                    libpango.}
  proc ot_ruleset_get_for_description*(info: OTInfo; 
      desc: OTRulesetDescription): OTRuleset {.
      importc: "pango_ot_ruleset_get_for_description", libpango.}
  proc ot_ruleset_new*(info: OTInfo): OTRuleset {.
      importc: "pango_ot_ruleset_new", libpango.}
  proc ot_ruleset_new_for*(info: OTInfo; script: Script; 
                                 language: Language): OTRuleset {.
      importc: "pango_ot_ruleset_new_for", libpango.}
  proc ot_ruleset_new_from_description*(info: OTInfo; 
      desc: OTRulesetDescription): OTRuleset {.
      importc: "pango_ot_ruleset_new_from_description", libpango.}
  proc add_feature*(ruleset: OTRuleset; 
                                     table_type: OTTableType; 
                                     feature_index: guint; 
                                     property_bit: gulong) {.
      importc: "pango_ot_ruleset_add_feature", libpango.}
  proc maybe_add_feature*(ruleset: OTRuleset; 
      table_type: OTTableType; feature_tag: OTTag; 
      property_bit: gulong): gboolean {.
      importc: "pango_ot_ruleset_maybe_add_feature", libpango.}
  proc maybe_add_features*(ruleset: OTRuleset; 
      table_type: OTTableType; features: OTFeatureMap; 
      n_features: guint): guint {.importc: "pango_ot_ruleset_maybe_add_features", 
                                  libpango.}
  proc get_feature_count*(ruleset: OTRuleset; 
      n_gsub_features: ptr guint; n_gpos_features: ptr guint): guint {.
      importc: "pango_ot_ruleset_get_feature_count", libpango.}
  proc feature_count*(ruleset: OTRuleset; 
      n_gsub_features: ptr guint; n_gpos_features: ptr guint): guint {.
      importc: "pango_ot_ruleset_get_feature_count", libpango.}
  proc substitute*(ruleset: OTRuleset; 
                                    buffer: OTBuffer) {.
      importc: "pango_ot_ruleset_substitute", libpango.}
  proc position*(ruleset: OTRuleset; 
                                  buffer: OTBuffer) {.
      importc: "pango_ot_ruleset_position", libpango.}
  proc to_script*(script_tag: OTTag): Script {.
      importc: "pango_ot_tag_to_script", libpango.}
  proc ot_tag_from_script*(script: Script): OTTag {.
      importc: "pango_ot_tag_from_script", libpango.}
  proc to_language*(language_tag: OTTag): Language {.
      importc: "pango_ot_tag_to_language", libpango.}
  proc ot_tag_from_language*(language: Language): OTTag {.
      importc: "pango_ot_tag_from_language", libpango.}
  proc hash*(desc: OTRulesetDescription): guint {.
      importc: "pango_ot_ruleset_description_hash", libpango.}
  proc equal*(
      desc1: OTRulesetDescription; 
      desc2: OTRulesetDescription): gboolean {.
      importc: "pango_ot_ruleset_description_equal", libpango.}
  proc copy*(desc: OTRulesetDescription): OTRulesetDescription {.
      importc: "pango_ot_ruleset_description_copy", libpango.}
  proc free*(desc: OTRulesetDescription) {.
      importc: "pango_ot_ruleset_description_free", libpango.}
