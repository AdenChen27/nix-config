{ config, pkgs, ... }:

{
  programs.ssh.enable = true;

  programs.ssh.extraConfig = ''
    Host github.com
      AddKeysToAgent yes
      IdentityFile ~/.ssh/id_ed25519
  '';
}

