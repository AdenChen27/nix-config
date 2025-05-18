{ pkgs, ... }:

let
  python    = pkgs.python311;
  pyPkgs    = pkgs.python311Packages;
in {
  # make pipx, jupyter and mypy available everywhere in your user shell
  home.packages = with pkgs; [
    # pipx
    # jupyterlab
    # pyPkgs.mypy
  ];

  # optionally use the home-manager integration
  # programs.pipx.enable = true;
  # programs.jupyter.kernels = [ python ];
}

