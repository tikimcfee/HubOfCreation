require 'RMagick'
require 'FileUtils'
include Magick

# Grab path .rb
absolutePath = File.dirname(File.expand_path('__FILE__'))

# Locate source folder, cd to it
sourceDir = File.join(absolutePath, "source")
Dir.chdir(sourceDir)

# Create list of svg files to convert, then strip to filename only
# This needs to be done with a regular expression, for sure
sourceList = Dir.glob(File.join(sourceDir, "*.svg"))
svgNames = sourceList.collect do |location|
	loc = location.rindex('/')
	location = location[loc+1 .. -1]
end

# load up the files
svg_hash = {}
svgNames.each do |fileName|
	if fileName.include? ".svg"
		svg_hash.merge!( { (fileName[0.. -5] + ".png") => Magick::ImageList.new(fileName)} )
	end
end

# resize the images
svg_hash.each do |file_name, img|
	svg_hash[file_name] = img.resize(40, 40)
end

# set the opacity of the PNGs
#	a little experimentation shows fuzz between 25000-30000 gives
# 	decent results for quality of transparency + image sharpness.
svg_hash.each do |file_name, img|
	svg_hash[file_name] = img.paint_transparent('white', opacity=TransparentOpacity, invert=false, fuzz=27500)
end

# test method
# svgTransparent = svgSources.collect { |svg| svg.opacity = 127 unless svg }

# check for and make a new directory for conversions, then move to it
# TODO
# ! -- does Dir.chdir need to use absolute pathing for different localities?
# 	-- even if it does, get used to passing absolute pathing, could cause fewer problems
Dir.chdir(absolutePath)
FileUtils.mkdir("destination") unless File.directory?("destination")
Dir.chdir("destination")


# write images
svg_hash.each do |file_name, img|
	img.write(file_name)
end