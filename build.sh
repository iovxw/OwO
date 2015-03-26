#! /bin/bash

clear() {
  rm -rf build
  rm -rf bin
}

case "$1" in
  "")
    if [ ! -d "build" ]; then
      clear
    fi

    mkdir build
    cd build

    ln -s ../lib/nim-gtk3/src/gtk3.nim
    ln -s ../lib/nim-glib/src/glib.nim
    ln -s ../lib/nim-gio/src/gio.nim
    ln -s ../lib/nim-atk/src/atk.nim
    ln -s ../lib/nim-gdk3/src/gdk3.nim
    ln -s ../lib/nim-gobject/src/gobject.nim
    ln -s ../lib/nim-cairo/src/cairo.nim
    ln -s ../lib/nim-pango/src/pango.nim
    ln -s ../lib/nim-gdk_pixbuf/src/gdk_pixbuf.nim

    cp ../src/main.nim main.nim
    nim c --threads:on -d:release main.nim

    cd ..
    mkdir bin
    mv build/main bin/main
    ;;

  clear)
    clear
    ;;
esac