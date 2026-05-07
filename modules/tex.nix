{ ... }: {
  home.file.".latexmkrc".text = ''
    $pdf_mode = 5;
    $xelatex = 'xelatex -synctex=1 -interaction=nonstopmode %O %S';
  '';
}
