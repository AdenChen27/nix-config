{ config, pkgs, ... }:
let
  repo = "${config.home.homeDirectory}/nix-config/nvim";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
in
{
  xdg.configFile."nvim/init.lua".source = link "init.lua";
  xdg.configFile."nvim/lua/snippets".source = link "lua/snippets";
  xdg.configFile."nvim/lua/config".source = link "lua/config";
  xdg.configFile."nvim/lua/plugins".source = link "lua/plugins";
  xdg.configFile."nvim/lua/lsp".source = link "lua/lsp";
  xdg.configFile."nvim/after/plugin".source = link "after/plugin";
  xdg.configFile."nvim/after/syntax".source = link "after/syntax";
  xdg.configFile."nvim/lazy-lock.json".source = link "lazy-lock.json";
}
