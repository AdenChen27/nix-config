{ config, pkgs, lib, ... }:
let
  env = import ./env.nix;
  # rWithPackages = pkgs.rWrapper.override {
  #   packages = with pkgs.rPackages; [
  #     estimatr
  #     tidyverse
  #     modelsummary
  #     fixest
  #     broom
  #     sandwich
  #     data_table
  #     readxl
  #     haven
  #     knitr
  #   ];
  # };
in {
  programs.home-manager.enable = true;
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
    pkgs.nerd-fonts.jetbrains-mono
    neovim
    code-minimap
    texlive.combined.scheme-full
    openssh
    nodejs_22
    tmux
    coreutils
    starship
    stylua

    # rWithPackages
    python312
    python312Packages.pip
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

  # Path
  home.sessionPath = [
    "${config.home.homeDirectory}/bin"
    "${pkgs.coreutils}/bin"
  ];
  # Scripts in ~/bin
  home.file."bin".source = ./bin;
  home.file."bin".recursive = true;

  # direnv
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}

