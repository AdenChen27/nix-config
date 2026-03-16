{ config, pkgs, ... }: {
  xdg.configFile."nvim/init.lua".source        = ../nvim/init.lua;
  xdg.configFile."nvim/lua/snippets".source    = ../nvim/lua/snippets;
  xdg.configFile."nvim/lua/config".source      = ../nvim/lua/config;
  xdg.configFile."nvim/lua/plugins".source     = ../nvim/lua/plugins;
  xdg.configFile."nvim/lua/lsp".source         = ../nvim/lua/lsp;
  xdg.configFile."nvim/after/syntax".source    = ../nvim/after/syntax;
}

