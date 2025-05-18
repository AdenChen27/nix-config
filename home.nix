{ config, pkgs, lib, ... }:
let
  env = import ./env.nix;
in {
  programs.home-manager.enable = true;
  programs.zsh.enable = true;
  home.sessionVariables = env;

  home.username = "aden";
  home.homeDirectory = "/Users/aden";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    starship
    zoxide
    fd
    bat
    fzf
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    neovim
    code-minimap
    texlive.combined.scheme-full
    openssh
    nodejs_22

    # Programming Languages
    python311
    python311Packages.pip
  ];

  programs.git.enable = true;

  imports = [
    ./modules/zsh.nix
    ./modules/kitty.nix
    ./modules/nvim.nix
    ./modules/wakatime.nix
    ./modules/python311.nix
    ./modules/ssh.nix
    ./modules/git.nix
  ];

  home.activation = {
    boxSymlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -snf "/Users/aden/Library/CloudStorage/Box-Box" "$HOME/Box"
      ln -snf "/Users/aden/Library/CloudStorage/Box-Box/Courses" "$HOME/Courses"
      ln -snf "/Users/aden/Library/CloudStorage/Box-Box/books" "$HOME/books"
      ln -snf "/Users/aden/Library/CloudStorage/Box-Box/Econ" "$HOME/Econ"
    '';
  };
}

