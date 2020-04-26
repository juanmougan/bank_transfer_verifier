# Bank transfer verifier

OCR parser meant to be used to register payments

## Getting it to work

### Dependencies

- Imagemagick: to fix images to make OCR parsing easier.

- Tesseract: to actually do the parsing.

### Install

1. Install Imagemagick `brew install imagemagick    # Or apt-get, or whatever.`

2. Install Tesseract `brew install tesseract                 # Or apt-get, or whatever.`

### Run

  $ ./folder.sh
  $ gem install

The image to convert should be placed inside folder `images`, and then run

  $ ruby script.rb <input_image_name>

Outputs a file in folder `outputs`, that contains the name of the input_image_name

## Roadmap

1. Actually return formatted data, even with different pictures

2. Convert to a Gem

3. Testing!
