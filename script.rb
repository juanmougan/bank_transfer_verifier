require "mini_magick"       			# WARN: https://stackoverflow.com/a/31193536/3923525
require "rtesseract"					# TODO brew install tesseract and the languages

def get_input_output_file_paths
	base_dir = Dir.pwd
	puts "basedir: #{base_dir}"
	input_file_name = ARGV[0]
	puts "input name #{input_file_name}"
	input_file_path = File.join(base_dir, input_file_name)
	output_file_name = "output_#{Time.new.usec}_#{input_file_name}"
	puts "output_file_name: #{output_file_name}"
	output_file_path = File.new(output_file_name, "w")
	puts "will open #{input_file_path}"
	return input_file_path, output_file_path
end

def load_grey_scaled_image(input_file_path, output_file_path)
	img = MiniMagick::Image.open(input_file_path)
	# to gray
	img.colorspace('Gray')
	img.write(output_file_path)
end

def clean_up_image(output_file_path)
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
	convert.deskew("80%")
	convert.threshold("007%")    # I couldn't prevent myself
	convert.negate
	convert << output_file_path
end

def parse_ocr(output_file_path)
	# Parse OCR
	image_text_content = RTesseract.new(File.basename(output_file_path), lang: 'spa')
	return image_text_content.to_s
end

input_file_path, output_file_path = get_input_output_file_paths
load_grey_scaled_image(input_file_path, output_file_path)
clean_up_image(input_file_path)
img_text_content = parse_ocr(output_file_path)
puts "Image content: \n#{img_text_content}"
