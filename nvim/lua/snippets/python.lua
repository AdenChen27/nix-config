local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  s("section", {
    t("# ---- "),
    i(1, "Section"),
    t(" "),
    f(function(args)
      local title = args[1][1] or ""
      local width = 88
      local used = 7 + #title + 1
      return string.rep("-", math.max(width - used, 0))
    end, { 1 }),
  }),
}
