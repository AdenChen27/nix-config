#!/Users/aden/anaconda3/bin/python3
import argparse
import os
import subprocess
import re
from pathlib import Path

def get_pdf_page_count(pdf_filename):
    """Get the number of pages in the PDF using pdfinfo."""
    try:
        output = subprocess.check_output(["pdfinfo", pdf_filename], universal_newlines=True)
        match = re.search(r"Pages:\s+(\d+)", output)
        return int(match.group(1)) if match else 0
    except Exception as e:
        print(f"Error getting page count for {pdf_filename}: {e}")
        return 0

def convert_pdf_to_named_images(pdf_filename, names_filename, out_dir, density=500, all_pages=False):
    """Convert PDF to images with specified names directly using ImageMagick."""
    os.makedirs(out_dir, exist_ok=True)
    page_count = get_pdf_page_count(pdf_filename)
    
    # Read names from names file
    names_file = Path(names_filename)
    if not names_file.is_file():
        print(f"Names file {names_filename} not found.")
        return
    
    with names_file.open() as f:
        names = f.read().splitlines()

    # Validate number of names
    if all_pages and len(names) < page_count:
        print("Warning: Not enough names provided for all pages. Additional pages will use default names.")

    def process_img(page_index):
        output_name = names[page_index] if page_index < len(names) else f"output_{page_index}"
        output_file = f"{out_dir}/{output_name}.png"
        print(f"Processing page {page_index + 1}, saving to {output_file} ...")

        # convert to png
        subprocess.run(["magick", "-density", str(density), f"{pdf_filename}[{page_index}]", output_file])
        # trim
        subprocess.run(["magick", str(output_file), "-fuzz", "7%", "-trim", str(output_file)])
    
    if all_pages:
        for i in range(page_count):
            process_img(i)
    else:
        # only convert and trim last page
        last_page_index = page_count - 1
        process_img(last_page_index)


def main():
    parser = argparse.ArgumentParser(description="Convert PDF to named images directly.")
    parser.add_argument("pdf_filename", help="Filename of the PDF to convert")
    parser.add_argument("-n", "--names_filename", default="names.txt", help="Filename containing image names")
    parser.add_argument("-o", "--out_dir", default=".", help="Directory to save the output images")
    parser.add_argument("-a", "--all_pages", action="store_true", help="Convert all pages (default is to convert only the last page)")
    args = parser.parse_args()

    convert_pdf_to_named_images(args.pdf_filename, args.names_filename, args.out_dir, all_pages=args.all_pages)

if __name__ == "__main__":
    main()

