def read_images(path, file_type, *outputs)
	sourceList = Dir.glob(File.join(path, file_type))

	svg_names = sourceList.collect do |location|
		loc = location.rindex('/')
		location = location[loc+1 .. -1]
	end

	svg_hash = {}
	svg_names.each do |file_name|
		if file_name.include? ".svg"
			name_of_file = file_name[0 .. -5]

			FileUtils.mkdir_p("destination/" + name_of_file )

			outputs.each do |t|
				svg_hash.merge!( { (name_of_file + t) => Magick::ImageList.new(path + file_name) } )
			end
		end
	end

	svg_hash
end

def make_transparent(img, xRes, yRes, opacity, cutoff)
	yRes.times do |i|
		xRes.times do |j|
			img.alpha(Magick::ActivateAlphaChannel)
			temp = img.pixel_color(i, j)
			if (temp.red + temp.blue + temp.green == 65535 * 3)
				img.pixel_color(i, j, Pixel.new(65535, 65535, 65535, 65535))
			elsif temp.red + temp.blue + temp.green > cutoff#temp.red + temp.blue + temp.green < cutoff
				img.pixel_color(i, j, Pixel.new(temp.red, temp.blue, temp.green, opacity) )
			elsif temp.red + temp.blue + temp.green > (cutoff / 3)
				img.pixel_color(i, j, Pixel.new(temp.red, temp.blue, temp.green, opacity / 2) )
			elsif temp.red + temp.blue + temp.green > 0
				img.pixel_color(i, j, Pixel.new(temp.red, temp.blue, temp.green, opacity / 3) )
			end
		end
	end

	img
end
