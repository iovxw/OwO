# very ugly test to see if lib is found and loaded 
import gdk3, glib

var
  s: Screen
  s1: PScreen # deprecated warnings
  s2: GdkScreen# deprecated warnings
  s3: PGdkScreen # deprecated warnings
  r: gdouble
  str: cstring = ""
  #p: ptr cstring = addr(str)
  i: gint = 0
  p: cstringArray = cast[cstringArray](nil)

init(i, p)

s = screen_get_default()

r = s.get_resolution()
echo r
echo s.resolution # -1.0 == unset

echo s.width # 1600, correct
echo get_width(s) # also available

echo gdk_screen_get_width(s) # deprecated warnings

