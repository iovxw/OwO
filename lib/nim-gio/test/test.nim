import gio

var f: GFile

f = g_file_new_for_path(".")

echo f.path

