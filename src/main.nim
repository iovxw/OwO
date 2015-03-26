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

import os, strutils, critbits, threadpool
import gtk3, glib, gobject

type
  Emos = CritBitTree[tuple[btn: Button, tags: seq[string]]]
  EIndex = CritBitTree[CritBitTree[int]]

proc findLast(a:string, item:char): int =
  for i in countdown(a.len-1, 0):
    if a[i] == item:
      return i

proc parseEmos(s: string): Emos =
  for v in s.splitLines():
    var e = v[0..v.find('[')-1].strip()
    # 此处用findLast是为了防止颜文字中本身含有“[”和“]”
    var t = v[v.findLast('[')+1..v.findLast(']')-1].split()
    result[e] = (nil,t)

proc parseEIndex(emos: Emos): EIndex =
  for emo, v in emos:
    for tag in v.tags:
      var buf = result[tag]
      buf[emo] = 0
      result[tag] = buf

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
  eIndex = parseEIndex(emos)

proc changeBackLabel(btn: Button, label: string) =
  sleep(450)
  btn.label = label
  btn.sensitive = true

proc btnClicked(widget: Widget, data: gpointer) {.cdecl.} =
  var btn = Button(widget)
  btn.clipboard(nil).setText(btn.label, gint(btn.label.len))
  window.title = btn.label
  btn.sensitive = false
  let label = $btn.label
  btn.label = "已复制到剪贴板"
  spawn changeBackLabel(btn, label)

for k, v in emos:
  var btn = buttonNew(k)
  list.packStart(btn, GFALSE, GTRUE, 0)
  emos[k] = (btn, v.tags) # 记录按钮控件用于以后操作

  discard gSignalConnect(btn, "clicked", gCallback(btnClicked), nil)

proc searchEmo(widget: Widget, data: gpointer) {.cdecl.} =
  var text = $search.text
  if text == "":
    # 显示所有按钮
    for k ,v in emos:
      v.btn.visible = true
  elif eIndex.hasKey(text):
    for emo, v in emos:
      # 检查此标签的表情列表中是否含有本表情
      if eIndex[text].hasKey(emo):
        v.btn.visible = true
      else:
        v.btn.visible = false
  else:
    # 标签不存在，直接不显示按钮
    for k, v in emos:
      v.btn.visible = false

discard gSignalConnect(search, "search-changed", gCallback(searchEmo), nil)

l.addWithViewport(list)

var box = boxNew(Orientation.VERTICAL, 0)

box.packStart(search, GFALSE, GTRUE, 0)
box.packStart(l, GTRUE, GTRUE, 0)

window.add(box)
window.showAll()
gtk3.main()
