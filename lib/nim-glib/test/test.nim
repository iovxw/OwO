import glib

var s: cstring

s = g_get_current_dir()
echo s
g_free(s)
s = g_get_user_name()
echo s
g_free(s)
echo g_get_num_processors()
echo g_ascii_islower('a')
echo g_ascii_islower('B')
