-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local on_attach = require("lsp.on_attach").on_attach
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
  }
}

