# glib for Nim, fix this:
#template G_TYPE_FUNDAMENTAL*(`type`: expr): expr = 

arg0 = ARGV[0]
text = File.read(arg0)
list = Array.new
text.lines{|line|
	#if m = /^(\s*)(\w+)\* = object $/.match(line)
	if m = /^\s*template (\w+)\*?\(/.match(line)
		list << m[1]
	end
}

list.sort_by!{|el| -el.length}
list.each{|pat|
	text.gsub!(/\b#{pat}\b/, pat.downcase)
}

File.open(arg0, "w") {|file|
	file.write(text)
}

