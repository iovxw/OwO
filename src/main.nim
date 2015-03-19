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

import strutils
import gtk3, glib, gobject

type Emos = seq[tuple[emo: string, tags: seq[string]]]

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
  var es: Emos = @[]
  for v in s.splitLines():
    var e = v[0..v.find('[')-1].remB2ESpace()
    var t = v[v.findLast('[')+1..v.len-2].split()
    es.add((emo: e, tags:t))
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
  search = entryNew()
  list = boxNew(Orientation.VERTICAL, 0)
  l = scrolledWindowNew(nil, nil)
  emos = parseEmos(readFile("e.text"))

for i, v in emos:
  list.packStart(buttonNew(v.emo), GFALSE, GTRUE, 0)

l.addWithViewport(list)

var box = boxNew(Orientation.VERTICAL, 0)

box.packStart(search, GFALSE, GTRUE, 0)
box.packStart(l, GTRUE, GTRUE, 0)

window.add(box)
window.showAll()
gtk3.main()