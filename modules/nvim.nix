{ config, pkgs, ... }: {
  xdg.configFile."nvim/init.lua".source    = ../nvim/init.lua;
  home.file."/.config/nvim/lua/snippets".source = ../nvim/lua/snippets;
  home.file."/.config/nvim/lua/config".source = ../nvim/lua/config;
  home.file."/.config/nvim/lua/plugins".source = ../nvim/lua/plugins;
  home.file."/.config/nvim/lua/lsp".source = ../nvim/lua/lsp;
  home.file."/.config/nvim/after/syntax".source = ../nvim/after/syntax;
}

