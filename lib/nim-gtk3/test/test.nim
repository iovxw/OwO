import gtk3, glib, gobject

#template radio_button_new*(w: RadioButton, label: cstring): RadioButton =
#  gtk3.new_with_label_from_widget*(gtk3.RadioButton(w), cstring(label))


#proc radio_button_new*(w: RadioButton, label: cstring): RadioButton =
#  gtk3.new_with_label_from_widget*(gtk3.RadioButton(w), cstring(label))

#const radio_button_new* = gtk3.new_with_label_from_widget


#template g_callback*(f: expr): expr = 
#  cast[GCallback](f)


#proc g_callback*(p: proc): gobject.GCallback = 
#  cast[GCallback](p)





proc destroy(widget: Widget, data: gpointer) {.cdecl.} = main_quit()

var
  i: cint = 0
  a: cstringArray = cast[cstringArray](nil)

gtk3.init(i, a) # we should find a smarter init()!

var window = window_new(WindowType.TOPLEVEL) # gtk_ proc prefix is deprecated, gives fine warning

discard g_signal_connect(window, "destroy", g_callback(test.destroy), nil)

window.title = "Radio Buttons"
echo(window.title)
echo(window.get_title) # get_ is available also

window.border_width = 10
window.set_border_width(10) # set_ is available also

var
  r1 = radio_button_new("Radio_Button 1")
  r2: PRadioButton # old deprecated P prefix -- gives warning

r2 = new_with_label_from_widget(r1, "Radio_Button 2")

var
  r3 = radio_button_new(r1, "Radio_Button 2")


var 
  #r3 = gtk_radio_button_new_with_label_from_widget(r1, "Radio_Button 3") # polymorphism works not for deprecated symbols 
  box = box_new(Orientation.VERTICAL, 0)

box.pack_start(r1, GFALSE, GTRUE, 0) # maybe we should add default values
box.pack_start(r2, GFALSE, GTRUE, 0)
#box.pack_start(r3, GFALSE, GTRUE, 0)
window.add(box)
window.show_all
gtk3.main()

