#!/usr/bin/env python3
import re
import argparse
import os
import sys

def extract_statements(latex_text):
    """Extracts theorems, propositions, lemmas, corollaries, and definitions from LaTeX text,
    grouped under demoted section headings."""
    section_map = {'section': 'subsection', 'subsection': 'subsubsection', 'subsubsection': 'subsubsection'}
    pattern = re.compile(
        r'(\\(section|subsection|subsubsection)\*?\{([^\n]*)\})'
        r'|(\\begin\{(theorem|proposition|lemma|corollary)\}.*?\\end\{\5\})',
        re.DOTALL
    )

    results = []
    pending_sections = []

    for match in pattern.finditer(latex_text):
        if match.group(2):  # section heading
            level = match.group(2)
            title = match.group(3)
            pending_sections.append(f'\\{section_map[level]}{{{title}}}')
        else:  # theorem environment
            stmt = re.sub(r'\\label\{.*?\}', '', match.group(4)).strip()
            results.extend(pending_sections)
            pending_sections = []
            results.append(stmt)

    return results

def main():
    parser = argparse.ArgumentParser(description="Extract mathematical statements from a LaTeX file.")
    parser.add_argument("file", type=str, nargs="?", default="notes.tex", help="Path to the LaTeX file (default: notes.tex)")
    parser.add_argument("-o", "--outfile", type=str, default="notes-theorem-list.tex", help="Output file (default: notes-theorem-list.tex)")
    args = parser.parse_args()
    
    if os.path.exists(args.outfile):
        answer = input(f"'{args.outfile}' already exists. Overwrite? [y/N] ")
        if answer.strip().lower() != "y":
            sys.exit(0)

    try:
        with open(args.file, "r", encoding="utf-8") as f:
            latex_text = f.read()
            lines = latex_text.splitlines()
            # Remove comments
            lines_without_comments = [line for line in lines if not line.strip().startswith('%')]
            extracted_statements = extract_statements("\n".join(lines_without_comments))

        with open(args.outfile, "w", encoding="utf-8") as out:
            for statement in extracted_statements:
                out.write(statement + "\n\n")
        print(f"Written to '{args.outfile}'.")
    except FileNotFoundError:
        print(f"Error: File '{args.file}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()

