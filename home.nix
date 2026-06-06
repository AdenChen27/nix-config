{
  config,
  pkgs,
  lib,
  ...
}:
let
  env = import ./env.nix;
  python = pkgs.python312.withPackages (
    ps: with ps; [
      pip
      numpy
      pandas
      scipy
      jupyterlab
      matplotlib
      ipykernel
      openai
      statsmodels
      markitdown
    ]
  );
in
{
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
    nerd-fonts.jetbrains-mono
    neovim
    nixfmt-rfc-style
    nil
    code-minimap
    texlive.combined.scheme-full
    openssh
    tmux
    stylua
    statix
    deadnix
    shellcheck
    shfmt
    julia-bin
    ripgrep
    gh
    wget
    imagemagick
    poppler-utils
    ocrmypdf
    tesseract
    ghostscript
    pandoc
    python
    uv
  ];

  programs.git.enable = true;

  imports = [
    ./modules/zsh.nix
    ./modules/kitty.nix
    ./modules/nvim.nix
    ./modules/ssh.nix
    ./modules/git.nix
    ./modules/hammerspoon.nix
    ./modules/sioyek.nix
    ./modules/karabiner.nix
    ./modules/tex.nix
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
      StartCalendarInterval = [
        {
          Weekday = 5;
          Hour = 1;
          Minute = 0;
        }
      ];
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/update-notes.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/update-notes.log";
    };
  };

  # direnv
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
