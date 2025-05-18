{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    git
  ];


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.configurationRevision = null;

  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";
}

