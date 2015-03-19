import pango

var
  i: cint
  x: cdouble
i = pango.units_from_double(cdouble(1))
echo i
x = pango.units_to_double(cint(1024))
echo x
  
