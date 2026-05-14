{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "AdenChen27";
      email = "adenchen2005@gmail.com";
    };
  };
}
