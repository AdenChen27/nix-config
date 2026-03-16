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
  python = pkgs.python312.withPackages (ps: with ps; [
    pip
    setuptools
    pandas
    wheel
    scipy
    jupyterlab
    matplotlib
    notebook
    ipykernel
    charset-normalizer
    openai
  ]);
in {
  programs.home-manager.enable = true;
  home.sessionVariables = env;

  home.username = "aden";
  home.homeDirectory = "/Users/aden";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    coreutils
    nodejs_22
    pyright
    tree
    tree-sitter
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
    tmux
    stylua
    julia-bin
    poetry
    ripgrep
    imagemagick
    poppler_utils
    ghostscript

    # rWithPackages
    # python312
    # pipx
    # python312Packages.pip
    python
  ];

  programs.git.enable = true;

  imports = [
    ./modules/zsh.nix
    ./modules/kitty.nix
    ./modules/nvim.nix
    ./modules/ssh.nix
    ./modules/git.nix
  ];

  home.activation = {
    boxSymlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -snf "${config.home.homeDirectory}/Library/CloudStorage/Box-Box" "$HOME/Box"
      ln -snf "${config.home.homeDirectory}/Library/CloudStorage/Box-Box/Courses" "$HOME/Courses"
      ln -snf "${config.home.homeDirectory}/Library/CloudStorage/Box-Box/books" "$HOME/books"
      ln -snf "${config.home.homeDirectory}/Library/CloudStorage/Box-Box/Econ" "$HOME/Econ"
    '';
  };

  # Path
  home.sessionPath = [
    "${config.home.homeDirectory}/bin"
    "${config.home.homeDirectory}/.local/bin"
    "${pkgs.coreutils}/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  # Scripts in ~/bin
  home.file."bin".source = ./bin;
  home.file."bin".recursive = true;

  # Update notes LaunchAgent (replaces cron: 0 1 * * 5)
  launchd.agents.update-notes = {
    enable = true;
    config = {
      ProgramArguments = [ "${config.home.homeDirectory}/bin/update-notes.sh" ];
      StartCalendarInterval = [{
        Weekday = 5;
        Hour = 1;
        Minute = 0;
      }];
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/update-notes.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/update-notes.log";
    };
  };

  # direnv
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
