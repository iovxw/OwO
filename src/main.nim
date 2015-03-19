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

import gtk3, glib, gobject

var
  i: cint = 0
  a: cstringArray = cast[cstringArray](nil)

gtk3.init(i, a)

var window = windowNew(WindowType.TOPLEVEL)

discard gSignalConnect(window, "destroy", gCallback(main_quit), nil)

window.title = "o(*≧▽≦)ツ"
window.setSizeRequest(100, 300)
window.borderWidth = 5

var emoticons :seq[string]
# TODO: 支持在线和本地读取颜文字列表
# TODO: 支持颜文字按标签分类
emoticons = @["(｡・`ω´･)", "o(*≧▽≦)ツ", "≖‿≖✧", "(´･ω･｀)", "(●—●)", "(╯‵□′)╯︵┻━┻", "∑(っ °Д °;)っ", " (ノ｀Д´)ノ┻━┻", "(・∀・)"]

var
  search = entryNew()
  list = boxNew(Orientation.VERTICAL, 0)
  l = scrolledWindowNew(nil, nil)

for i, v in emoticons:
  list.packStart(buttonNew(v), GFALSE, GTRUE, 0)

l.addWithViewport(list)

var box = boxNew(Orientation.VERTICAL, 0)

box.packStart(search, GFALSE, GTRUE, 0)
box.packStart(l, GTRUE, GTRUE, 0)

window.add(box)
window.showAll()
gtk3.main()