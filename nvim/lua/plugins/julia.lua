-- ~/.config/nvim/lua/plugins/julia.lua
return {
  {
    "JuliaEditorSupport/julia-vim",
    lazy = false, -- load immediately at startup 
    init = function()
    vim.g.latex_to_unicode_tab = "insert"
    vim.g.latex_to_unicode_auto = 1
    end, 
  },
}
