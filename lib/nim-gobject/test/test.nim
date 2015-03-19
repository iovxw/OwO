import gobject

var
  s: cstring
  t: GType
t = g_date_get_type()
s = name(t)
echo s
s = g_type_name(t)
echo s
