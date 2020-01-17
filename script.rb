require "mini_magick"       # WARN: https://stackoverflow.com/a/31193536/3923525
require "rtesseract"                  # TODO brew install tesseract

base_dir = Dir.pwd
puts "basedir: #{base_dir}"
input_file_name = ARGV[0]
puts "input name #{input_file_name}"
input_file_path = File.join(base_dir, input_file_name)
output_file_name = "output_#{Time.new.usec}_#{input_file_name}"
puts "output_file_name: #{output_file_name}"
output_file_path = File.new(output_file_name, "w")
puts "will open #{input_file_path}"
img = MiniMagick::Image.open(input_file_path)
# to gray
img.colorspace('Gray')
img.write(output_file_path)

# Cleaning
#MiniMagick::Tool::Magick.new do |magick|
#    magick << output_file_path
#    magick.negate
#    magick.threshold("007%")    # I couldn't prevent myself
#    magick.negate
#    magick << output_file_path
#end

# Clean up image
convert = MiniMagick::Tool::Convert.new
convert << output_file_path
convert.negate
convert.threshold("007%")    # I couldn't prevent myself
convert.negate
convert << output_file_path

# Parse OCR
image_text_content = RTesseract.new(output_file_name)
puts image_text_content.to_s
