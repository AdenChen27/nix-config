local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local tex = require("snippets.tex.conditions")
local in_math = tex.in_math
local not_in_math = function(...) return not in_math(...) end

local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

local M = {}

-- Sections (normal snippets)
M.sections = {
    s("sec", fmt("\\section{{{}}}", { i(1) })),
    autosnippet("sec*", fmt("\\section*{{{}}}", { i(1) })),
    s("subsec", fmt("\\subsection{{{}}}", { i(1) })),
    autosnippet("subsec*", fmt("\\subsection*{{{}}}", { i(1) })),
    s("subsubsec", fmt("\\subsubsection{{{}}}", { i(1) })),
    autosnippet("subsubsec*", fmt("\\subsubsection*{{{}}}", { i(1) })),
}

-- Text abbreviations (plain snippets)
M.text_abbr = {
    s("cont", t("continuous ")),
    s("iff", t("if and only if ")),
    s("nhbd", t("neighborhood ")),
    s("nhbds", t("neighborhoods ")),
    s("st", t("such that ")),
    s("fe", t("for every ")),
    s("ae", t("almost everywhere ")),
}

-- Text mode formatting (word triggers)
M.text_format = {
    s({ trig = "tt", wordTrig = true }, fmt("\\text{{{}}} ", { i(1) })),
    s({ trig = "ttt", wordTrig = true }, fmt("\\texttt{{{}}} ", { i(1) })),
    s({ trig = "tit", wordTrig = true }, fmt("\\textit{{{}}} ", { i(1) })),
    s({ trig = "tbf", wordTrig = true }, fmt("\\textbf{{{}}} ", { i(1) })),
    autosnippet({ trig = "^^", wordTrig = false }, fmt("\\textsuperscript{{{}}}", { i(1) })),
}

-- Math mode snippets and autosnippets
-- helper: creates an autosnippet for math mode with postfix trigger
local function in_math_postfix_snippet(name, trigger, template)
  return autosnippet(
    {
      trig = trigger,
      wordTrig = false,
      regTrig = true,
      name = name,
      condition = in_math,
    },
    f(function(_, snip)
      return string.format(template, snip.captures[1])
    end, {})
  )
end

M.math = {
    -- Inline math \( ... \)
    autosnippet({ trig = "mk", name = "inline math" },
        fmta("\\(<>\\)<>", { i(1), i(0) }),
        { condition = not_in_math, show_condition = not_in_math }),

    -- Display math \[ ... \]
    autosnippet({ trig = "dm", name = "display math" }, fmta([[
    \[
      <>
    \]
    <>]], { i(1), i(0) }), { condition = conds.line_begin, show_condition = tex.show_line_begin }),

    -- Common math snippets with math context
    autosnippet({ trig = "neq", dscr = "not equals", wordTrig = true, regTrig = false, condition = in_math }, t("\\neq ")),
    autosnippet({ trig = "equiv", dscr = "equivalent", wordTrig = true, condition = in_math }, t("\\equiv ")),
    autosnippet({ trig = ":=", dscr = "coloneqq", wordTrig = true, condition = in_math }, t("\\coloneqq ")),
    s({ trig = "ceil", wordTrig = true, condition = in_math }, fmt("\\left\\lceil {} \\right\\rceil ", { i(1) })),
    s({ trig = "floor", wordTrig = true, condition = in_math }, fmt("\\left\\lfloor {} \\right\\rfloor ", { i(1) })),

    -- Logic
    autosnippet({ trig = "EE", wordTrig = true, condition = in_math }, t("\\exists ")),
    autosnippet({ trig = "AA", wordTrig = true, condition = in_math }, t("\\forall ")),
    s({ trig = "contra", wordTrig = true, condition = in_math }, t("\\contradiction ")), -- note: may need user macro

    -- Set notation
    autosnippet({ trig = "set", name = "set notation" }, fmta("\\{<>\\} <>", { i(1), i(0) }), { condition = in_math }),

    -- Relations and set symbols
    s({ trig = "\\", wordTrig = true, condition = in_math }, t("\\setminus ")),
    s({ trig = "cc", wordTrig = true, condition = in_math }, t("\\subset ")),
    s({ trig = "cceq", wordTrig = true, condition = in_math }, t("\\subseteq ")),
    s({ trig = "ccneq", wordTrig = true, condition = in_math }, t("\\subsetneq ")),
    s({ trig = "ncc", wordTrig = true, condition = in_math }, t("\\supset ")),
    s({ trig = "ncceq", wordTrig = true, condition = in_math }, t("\\supseteq ")),
    s({ trig = "nccneq", wordTrig = true, condition = in_math }, t("\\supsetneq ")),
    s({ trig = "compl", wordTrig = true, condition = in_math }, t("^\\complement ")),

    -- Common symbols
    s({ trig = "inv", wordTrig = true, condition = in_math }, t("^{-1}")),
    s({ trig = "conj", wordTrig = true, condition = in_math }, fmt("\\overline{{{}}}", { i(1) })),
    s({ trig = "xx", wordTrig = true, condition = in_math }, t("\\times ")),
    s({ trig = "oxx", wordTrig = true, condition = in_math }, t("\\otimes ")),
    s({ trig = "~~", wordTrig = true, condition = in_math }, t("\\sim ")),
    s({ trig = "oo", wordTrig = true, condition = in_math }, t("\\infty")),
    s({ trig = "...", wordTrig = true, condition = in_math }, t("\\dots ")),
    s({ trig = "||", wordTrig = true, condition = in_math }, fmt("\\abs{{{}}}", { i(1) })),
    s({ trig = "|||", wordTrig = true, condition = in_math }, fmt("\\norm{{{}}}", { i(1) })),

    -- Functions and postfix forms (some with postfix helper)
    autosnippet({ trig = "bar", wordTrig = true, condition = in_math }, fmt("\\overline{{{}}}", { i(1) })),
    autosnippet({ trig = "tilde", wordTrig = true, condition = in_math }, fmt("\\tilde{{{}}}", { i(1) })),
    autosnippet({ trig = "hat", wordTrig = true, condition = in_math }, fmt("\\hat{{{}}}", { i(1) })),
    autosnippet({ trig = "dot", wordTrig = true, condition = in_math }, fmt("\\dot{{{}}}", { i(1) })),
    autosnippet({ trig = "ddot", wordTrig = true, condition = in_math }, fmt("\\ddot{{{}}}", { i(1) })),
    autosnippet({ trig = "vec", wordTrig = true, condition = in_math }, fmt("\\vec{{{}}}", { i(1) })),
    in_math_postfix_snippet("bar",   "(%S+)bar",   "\\overline{%s}"),
    in_math_postfix_snippet("tilde", "(%S+)tilde", "\\tilde{%s}"),
    -- in_math_postfix_snippet("hat",   "%s(%a)hat",   "\\hat{%s}"), -- TODO
    in_math_postfix_snippet("widehat",   "(%S+)hat",   "\\widehat{%s}"),
    in_math_postfix_snippet("dot",   "(%S+)dot",   "\\dot{%s}"),
    in_math_postfix_snippet("ddot",  "(%S+)ddot",  "\\ddot{%s}"),
    in_math_postfix_snippet("vec",   "(%S+),%.",    "\\vec{%s}"),
    in_math_postfix_snippet("vec",   "(%S+)%.,",    "\\vec{%s}"),
    s({
      trig = "(%s(%a)+)hat",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "hat",
      condition = in_math,
    }, f(function(_, snip)
      return string.format(" \\hat{%s}", snip.captures[1])
    end, {})),
}

-- Export all snippets combined
M.all = {}
for _, group in ipairs({M.sections, M.text_abbr, M.text_format, M.math}) do
    for _, snip in ipairs(group) do
        table.insert(M.all, snip)
    end
end

return M.all

