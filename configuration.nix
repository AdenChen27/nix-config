# System-level macOS settings (Dock, Finder, keyboard, Homebrew casks).
# User-level config (packages, dotfiles, shell) lives in home.nix.
{ ... }: {
  system.primaryUser = "aden";

  homebrew = {
    enable = true;
    casks = [
      "codex"
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.configurationRevision = null;

  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
