z = []	
	File.open("test.csv") do |f|
		f.each_line do |line|
		z << line.slice!(/uc......../)
		#puts z.inspect
	File.open('DONOTOPENUNTILFINISHED.csv', 'w') {|raw| raw.puts z}
end
end