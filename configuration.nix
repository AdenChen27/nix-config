# System-level macOS settings (Dock, Finder, keyboard, Homebrew casks).
# User-level config (packages, dotfiles, shell) lives in home.nix.
{
  lib,
  pkgs,
  user,
  ...
}:
let
  zathuraMacos = import ./packages/zathura-macos.nix { inherit pkgs; };
in
{
  system.primaryUser = user.username;

  system.activationScripts.applications.text = lib.mkAfter ''
    if [ -e /Applications/Zathura.app ] || [ -L /Applications/Zathura.app ]; then
      /bin/rm -rf /Applications/Zathura.app
    fi
    if [ -e "/Applications/Nix Apps/Zathura.app" ] || [ -L "/Applications/Nix Apps/Zathura.app" ]; then
      /bin/rm -rf "/Applications/Nix Apps/Zathura.app"
    fi
    /usr/bin/ditto "${zathuraMacos.app}/Applications/Zathura.app" /Applications/Zathura.app
  '';

  homebrew = {
    enable = true;
    brews = [ "dbus" ];
    casks = [
      "codex"
      "firefox"
      "hammerspoon"
      "jordanbaird-ice"
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

  # Hiddify's TUN currently breaks TLS over IPv6. Route daemon downloads
  # through its local mixed proxy so Nix remains usable while the VPN is on.
  nix.envVars = {
    http_proxy = "http://127.0.0.1:12334";
    https_proxy = "http://127.0.0.1:12334";
  };

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
