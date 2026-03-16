return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    event = "VeryLazy",
    config = function()
      local ls = require("luasnip")

      ls.config.set_config {
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      }

      vim.schedule(function()
        require("luasnip.loaders.from_lua").lazy_load({
          paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
        })
      end)
    end,
  },
}
