{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    shellAliases = {
      # SSH
      mw2 = "ssh adenc@midway2.rcc.uchicago.edu";
      mw3 = "ssh adenc@midway3.rcc.uchicago.edu";
      mw33 = "ssh adenc@midway3-login3.rcc.uchicago.edu";
      mwssd = "ssh adenc@ssd.rcc.uchicago.edu";
      csil = "ssh adenc@linux.cs.uchicago.edu";

      # ls + vim
      ls = "ls -G --color=auto";
      ll = "ls -lGrth --color=auto";
      vim = "nvim";
      vi = "nvim";
      v = "nvim";

      # Darwin rebuild
      drs = "darwin-rebuild switch --flake ~/nix-config#\"Aden's Brain\"";
    };

    initExtra = ''
      # Run ll on directory change
      function chpwd() {
        emulate -L zsh
	ls -lGrth --color=auto
      }
    '';
  };
}

