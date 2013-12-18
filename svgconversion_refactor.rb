require 'RMagick'
require 'FileUtils'
require_relative "commandList.rb"
include Magick

# TODO - implement basic vocab
# open magician file, either via command line argument
# or with default 'magician.txt' filename
# --> magician ||= ARGV[0] || "magician.txt"
# --> commands = File.new(magician).readlines

# Grab path .rb script
absolutePath = File.dirname(File.expand_path('__FILE__'))

# regexp the command, looking for the folder name to read from
# --> sourceDir = File.join(absolutePath, commands[0][/"(.*)"/][1..-2] + "/")
sourceDir = File.join(absolutePath, "source/")

# take a filetype and load the images into a hash

svg_hash = read_images(sourceDir, "*.svg", ".png")

# resize the images
svg_hash.each do |file_name, img|
	svg_hash[file_name] = img.resize(40, 40)
end

opacity = Float(ARGV[0])
cutoff = Float(ARGV[1])
svg_hash.each do |file_name, img|
	make_transparent(img, 40, 40, opacity, cutoff)
end


# write images
svg_hash.each do |file_name, img|
	Dir.chdir(absolutePath + "/destination/" + file_name[0.. -5] + "/")
	#img.scene >> 0
	img.write(file_name)
	#img.scene >> 1
	#img.write(file_name[0 .. -5] + "_grey.png")
end
