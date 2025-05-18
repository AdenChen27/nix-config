local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node

return {
  -- Hello World snippet for any filetype
  s("hw", {
    t("print("), i(1, [["Hello, World!"]]), t(")"),
  }),

  -- Simple function template
  s("fn", {
    t("function "), i(1, "name"), t("("), i(2), t({")", "\t"}), i(0), t({"", "end"}),
  }),
}

