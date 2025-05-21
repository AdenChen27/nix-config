-- ~/.config/nvim/lua/config/luasnip.lua
local M = {}

function M.setup()
  local ls  = require("luasnip")
  local map = vim.keymap.set

  ls.config.set_config {
    history      = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
  }

  vim.schedule(function()
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
    })
  end)

  local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, false, true)
  end

  map({ "i", "s" }, "<Tab>", function()
    if ls.expand_or_jumpable() then
      vim.schedule(function() ls.expand_or_jump() end)
    else
      return t("<Tab>")
    end
  end, { expr = true, silent = true })

  map({ "i", "s" }, "<S-Tab>", function()
    if ls.jumpable(-1) then
      vim.schedule(function() ls.jump(-1) end)
    else
      return t("<S-Tab>")
    end
  end, { expr = true, silent = true })

end

return M

