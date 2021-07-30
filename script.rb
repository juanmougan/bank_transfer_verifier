require "mini_magick"       			# WARN: https://stackoverflow.com/a/31193536/3923525
require "rtesseract"					# TODO brew install tesseract and the languages
require 'tmpdir'

TICKET_PARSER_PREFIX = "ticket_parser_prefix"

def get_input_output_file_paths
	base_dir = Dir.pwd
	puts "basedir: #{base_dir}"
	input_file_name = ARGV[0]
	puts "input name #{input_file_name}"
	input_file_path = File.join(base_dir, input_file_name)
	input_file_name = File.basename(input_file_path)
	puts "input_file_path #{input_file_path}"
	output_file_name = "output_#{Time.new.usec}_#{input_file_name}"
	puts "output_file_name: #{output_file_name}"
	puts "will open #{input_file_path}"
	return input_file_path, output_file_name
end

def load_grey_scaled_image(input_file_path, output_file_path)
	img = MiniMagick::Image.open(input_file_path)
	# to gray
	img.colorspace('Gray')
	img.write(output_file_path)
end

def clean_up_image(output_file_path)
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
	puts "Tesseract will open: #{output_file_path}"
	image_text_content = RTesseract.new(output_file_path, lang: 'spa')
	return image_text_content.to_s
end

input_file_path, output_file_name = get_input_output_file_paths
Dir.mktmpdir(TICKET_PARSER_PREFIX) do |dir|
	output_file_base_path = File.join(dir, output_file_name)
	output_file_path = File.path(File.new(output_file_base_path, "w"))
	puts "output_file_path: #{output_file_path}"
	load_grey_scaled_image(input_file_path, output_file_path)
	clean_up_image(input_file_path)
	img_text_content = parse_ocr(output_file_path)
	puts "Image content: \n#{img_text_content&.strip}"
end
