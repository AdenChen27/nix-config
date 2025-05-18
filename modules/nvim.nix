{ config, pkgs, ... }: {
  xdg.configFile."nvim/init.lua".source    = ../nvim/init.lua;
  home.file."/.config/nvim/lua/snippets".source = ../nvim/lua/snippets;
  home.file."/.config/nvim/lua/config".source = ../nvim/lua/config;
}

