# System-level macOS settings (Dock, Finder, keyboard, Homebrew casks).
# User-level config (packages, dotfiles, shell) lives in home.nix.
{ pkgs, user, ... }:
let
  zathura = import ./packages/zathura-macos.nix { inherit pkgs; };
in
{
  system.primaryUser = user.username;

  environment.systemPackages = [ zathura ];

  homebrew = {
    enable = true;
    casks = [
      "codex"
      "firefox"
      "hammerspoon"
      "iterm2"
      "karabiner-elements"
      "keepingyouawake"
      "sioyek"
    ];
    onActivation.cleanup = "zap";
  };

  # Dock
  system.defaults.dock = {
    autohide = true;
    tilesize = 36;
    show-recents = false;
    mru-spaces = false;
  };

  # Finder
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    ShowPathbar = true;
    FXPreferredViewStyle = "Nlsv"; # list view
    _FXShowPosixPathInTitle = false;
  };

  # Global keyboard / UI
  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true;
    KeyRepeat = 2;
    InitialKeyRepeat = 15;
  };

  # Trackpad
  system.defaults.trackpad = {
    Clicking = true; # tap to click
    TrackpadRightClick = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    interval = [
      {
        Weekday = 7;
        Hour = 3;
        Minute = 15;
      }
    ];
    options = "--delete-older-than 30d";
  };

  nix.optimise = {
    automatic = true;
    interval = [
      {
        Weekday = 7;
        Hour = 4;
        Minute = 15;
      }
    ];
  };

  system.configurationRevision = null;

  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
