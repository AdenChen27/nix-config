#!/usr/bin/env python3
import re
import argparse

def extract_statements(latex_text):
    """Extracts theorems, propositions, lemmas, corollaries, and definitions from LaTeX text."""
    pattern = re.compile(r'(\\begin\{(theorem|proposition|lemma|corollary)\}.*?\\end\{\2\})', re.DOTALL)
    
    statements = []
    for match in pattern.finditer(latex_text):
        full_statement, _ = match.groups()
        # remove \label{...}
        full_statement = re.sub(r'\\label\{.*?\}', '', full_statement)
        statements.append(full_statement.strip())
    
    return statements

def main():
    parser = argparse.ArgumentParser(description="Extract mathematical statements from a LaTeX file.")
    parser.add_argument("file", type=str, help="Path to the LaTeX file")
    args = parser.parse_args()
    
    try:
        with open(args.file, "r", encoding="utf-8") as f:
            latex_text = f.read()
            lines = latex_text.splitlines()
            # Remove comments
            lines_without_comments = [line for line in lines if not line.strip().startswith('%')]
            extracted_statements = extract_statements("\n".join(lines_without_comments))
            
            for statement in extracted_statements:
                print(statement + "\n")
    except FileNotFoundError:
        print(f"Error: File '{args.file}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()

