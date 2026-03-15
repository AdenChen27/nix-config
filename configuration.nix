{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  system.primaryUser = "aden";

  homebrew = {
    enable = true;
    # Add brews/casks/taps here if you want them declarative.
    # Example:
    # brews = [ "mas" ];
    # casks = [ "google-chrome" ];
  };


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.configurationRevision = null;

  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
