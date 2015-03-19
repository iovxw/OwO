# Cairo for Nim, fix this:
# proc cairo_font_options_get_hint_style*(options: ptr cairo_font_options_t): cairo_hint_style_t {.
# and
# proc cairo_font_options_get_hint_style*(
# options: ptr cairo_font_options_t): cairo_hint_style_t {.
#
# http://stackoverflow.com/questions/1509915/converting-camel-case-to-underscore-case-in-ruby
#
# should be a safe operation -- compiler should detect name conflicts for us.
# function underscore seems to be not necessary for cairo naming schemes.
#

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end
last_line = nil
arg0 = ARGV[0]
text = File.read(arg0)
text << "\n"
File.open(arg0, "w") {|file|
	text.lines{|line|
		if last_line
			long = last_line.chop + line
			if m = /^\s*proc ([a-z]+_)?([a-z]+_)?([a-z]+_)?([a-z]+_)?([a-z]+_)?([a-z]+_)?([a-z]+_)?\w*\*\(\s*(`?\w+`?):(?: ptr){0,2} (\w+)_t/.match(long)
				a, b, c, d, e, f, g, pp, dt = m[1..9]
				if a && pp && dt
#					if dt == 'gunichar'
#						dt = 'GUnichar'
#					elsif dt == 'GSList'
#						dt = 'GSlist'
#					elsif dt == 'GData'
#						dt = 'GDatalist'
#					elsif dt == 'GIOChannel'
#						dt = 'GIoChannel'
#					elsif dt == 'GHookList' && b == 'hook_' && c != 'list_'
#						dt = 'GHook'
#					elsif dt == 'GSequenceIter' && b == 'sequence_' && c != 'iter_'
#						dt = 'GSequence'
#					end
					dt = dt.underscore
					b ||= ''
					c ||= ''
					d ||= ''
					e ||= ''
					f ||= ''
					g ||= ''
					c1 = c2 = ''
					p = pp + '_'
					if (a + b + c + d + e + f + g == p) || (a + b + c + d + e + f == p) || (a + b + c + d + e == p) || (a + b + c + d == p) || (a + b + c == p) || (a + b == p) || (a == p)
						c1 = pp
					end
					p = dt + '_'
					if (a + b + c + d + e + f + g == p) || (a + b + c + d + e + f == p) || (a + b + c + d + e == p) || (a + b + c + d == p) || (a + b + c == p) || (a + b == p) || (a == p)
						c2 = dt
					end
					p = (c1.length > c2.length ? c1 : c2)
					if p.length > 0
						last_line.sub!(p + '_', '')
					end
				end
			end
			file.write(last_line)
		end
		last_line = line.dup
	}
}

