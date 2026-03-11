-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local on_attach = require("lsp.on_attach").on_attach
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("pyright", {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("pyright")
    end,
  }
}

