#   Copyright 2015 Bluek404 <i@bluek404.net>
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

import os, strutils, critbits
import gtk3, glib, gobject

type Emos = CritBitTree[tuple[btn: Button, tags: seq[string]]]

# 去除首尾空格
proc remB2ESpace(s: string): string =
  var ss = s
  while true:
    if ss[0] == ' ':
      ss = ss[1..ss.len-1]
    elif ss[ss.len-1] == ' ':
      ss = ss[0..ss.len-2]
    else:
      return ss

proc findLast(a:string, item:char): int =
  var last:int
  for i in a.items:
    if i == item:
      last = result
    result.inc()
  result = -1
  return last

proc parseEmos(s: string): Emos =
  var es: Emos
  for v in s.splitLines():
    var e = v[0..v.find('[')-1].remB2ESpace()
    # 此处用findLast是为了防止颜文字中本身含有“[”和“]”
    var t = v[v.findLast('[')+1..v.findLast('[')-1].split()
    es[e] = (nil,t)
  return es

var
  i: cint = 0
  a: cstringArray = cast[cstringArray](nil)

gtk3.init(i, a)

var window = windowNew(WindowType.TOPLEVEL)

discard gSignalConnect(window, "destroy", gCallback(main_quit), nil)

window.title = "o(*≧▽≦)ツ"
window.setSizeRequest(100, 300)
window.borderWidth = 5

var
  search = searchEntryNew()
  list = boxNew(Orientation.VERTICAL, 0)
  l = scrolledWindowNew(nil, nil)
  emos = parseEmos(readFile("e.text"))

proc btnClicked(widget: Widget, data: gpointer) {.cdecl.} =
  var btn = Button(widget)
  btn.clipboard(nil).setText(btn.label, gint(btn.label.len))
  window.title = btn.label

for k, v in emos:
  var btn = buttonNew(k)
  list.packStart(btn, GFALSE, GTRUE, 0)
  emos[k] = (btn, v.tags) # 记录按钮控件用于以后操作

  discard gSignalConnect(btn, "clicked", gCallback(btnClicked), nil)

proc searchEmo(widget: Widget, data: gpointer) {.cdecl.} =
  echo search.text
  # TODO: 表情搜索功能

discard gSignalConnect(search, "search-changed", gCallback(searchEmo), nil)

l.addWithViewport(list)

var box = boxNew(Orientation.VERTICAL, 0)

box.packStart(search, GFALSE, GTRUE, 0)
box.packStart(l, GTRUE, GTRUE, 0)

window.add(box)
window.showAll()
gtk3.main()
