require "mini_magick"       # WARN: https://stackoverflow.com/a/31193536/3923525
require "rtesseract"                  # TODO brew install tesseract

base_dir = Dir.pwd
input_file_path = File.join(Dir.pwd, 'images')
temp_file_path = File.join(Dir.pwd, 'temp')
output_file_path = File.join(Dir.pwd, 'outputs')
puts "basedir: #{base_dir}"

# input
input_file_name = ARGV[0]
puts "input name #{input_file_name}"
input_file_path = File.join(input_file_path, input_file_name)

# temp
temp_file_name = "temp_#{Time.new.usec}_#{input_file_name}"
puts "temp_file_name: #{temp_file_name}"
temp_file_path = File.join(temp_file_path, temp_file_name)
temp_file = File.new(temp_file_path, "w")

puts "will open #{input_file_path}"
img = MiniMagick::Image.open(input_file_path)
# to gray
img.colorspace('Gray')
img.write(temp_file_path)


# Cleaning
# MiniMagick::Tool::Magick.new do |magick|
#    magick << output_file_path
#    magick.negate
#    magick.threshold("007%")    # I couldn't prevent myself
#    magick.negate
#    magick << output_file_path
# end

# Clean up image
convert = MiniMagick::Tool::Convert.new
convert << temp_file_path
convert.negate
convert.deskew("80%")
convert.threshold("007%")    # I couldn't prevent myself
convert.negate
convert << temp_file_path

# Parse OCR
image_text_content = RTesseract.new(temp_file_path)

# output
output_file_path = File.join(output_file_path, "#{File.basename(input_file_name, ".*")}#{Time.new.usec}.txt")
output_file = File.new(output_file_path , "w")
output_file.write(image_text_content.to_s)
output_file.close