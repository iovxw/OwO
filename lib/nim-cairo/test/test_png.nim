#http://zetcode.com/gfx/cairo/cairobackends/

import cairo

var
  s: Surface
  cr: Context # new 1.0 type

s = image_surface_create(FORMAT.ARGB32, 390, 60)
cr = create(s)

cr.set_source_rgb(0, 0, 0)
select_font_face(cr, "Sans", FONT_SLANT.NORMAL, FONT_WEIGHT.NORMAL)
set_font_size(cr, 40.0)

cairo_move_to(cr, 10.0, 50.0) # fine deprecated warning: use move_to instead
cr.show_text("Disziplin ist Macht.")

discard write_to_png(s, "image.png")

destroy(cr)
destroy(s)
#cairo_surface_destroy(s) # does not work fine: Error: type mismatch: got (Surface)

