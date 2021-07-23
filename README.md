# Bank transfer verifier

OCR parser meant to be used to register payments

## Getting it to work

### Dependencies

- Imagemagick: to fix images to make OCR parsing easier.

- Tesseract: to actually do the parsing.

### Install

1. Install Imagemagick `brew install imagemagick    # Or apt-get, or whatever.`

2. Install Tesseract `brew install tesseract                 # Or apt-get, or whatever.`
    
    i. Also install Tesseract's modules: `sudo apt-get install esseract-ocr-spa`

### Run

    ruby script.rb <input_image>

Outputs a file with a name starting with `output`, that's the "improved" image. Also prints its content.

## Roadmap

1. Actually return formatted data, even with different pictures

2. Convert to a Gem

3. Testing!
