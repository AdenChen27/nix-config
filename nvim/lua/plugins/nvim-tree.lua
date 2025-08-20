return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "left",
      },
      filters = {
        dotfiles = false,
      },
      git = {
        enable = true,
      },
      diagnostics = {
        enable = true,
      },
      filters = {
        custom = {
          "\\.DS_Store",
          "^\\.git$",
          "^.direnv$",
        },
      },
    })

    -- Keybinding to toggle file tree
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Tree" })
  end,
}

