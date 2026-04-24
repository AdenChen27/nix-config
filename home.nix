{ config, pkgs, lib, ... }:
let
  env = import ./env.nix;
  python = pkgs.python312.withPackages (ps: with ps; [
    pip
    numpy
    pandas
    scipy
    jupyterlab
    matplotlib
    ipykernel
    openai
    statsmodels
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
    nerd-fonts.jetbrains-mono
    neovim
    code-minimap
    texlive.combined.scheme-full
    openssh
    tmux
    stylua
    julia-bin
    ripgrep
    gh
    wget
    imagemagick
    poppler_utils
    ghostscript
    pandoc
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
    karabinerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/karabiner"
      cp ${./karabiner.json} "$HOME/.config/karabiner/karabiner.json"
      chmod 644 "$HOME/.config/karabiner/karabiner.json"
    '';
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

  home.file.".hammerspoon/init.lua".text = ''
    local hyper = {"cmd", "ctrl", "alt", "shift"}

    local function focus(app)
      return function()
        hs.application.launchOrFocus(app)
      end
    end

    hs.hotkey.bind(hyper, "T", focus("kitty"))
    hs.hotkey.bind(hyper, "C", focus("Google Chrome"))
    hs.hotkey.bind(hyper, "Z", focus("Zotero"))
    hs.hotkey.bind(hyper, "P", focus("Sioyek"))

    hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/init.lua", hs.reload):start()
  '';

  home.file."Library/Application Support/sioyek/keys_user.config".text = ''
    next_page     J
    previous_page K
    close_window  x
  '';

  home.file."Library/Application Support/sioyek/prefs_user.config".text = ''
    should_launch_new_window      1
    startup_commands              toggle_synctex
    inverse_search_command        ${config.home.homeDirectory}/bin/sioyek-inverse-search %1 %2
  '';

  # direnv
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
