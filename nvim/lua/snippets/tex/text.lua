local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local tex = require("snippets.tex.conditions")
local in_math = tex.in_math
local not_in_math = function(...)
	return not in_math(...)
end

local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

return {
	-- Text abbreviations
	s("cont", t("continuous")),
	s("iff", t("if and only if")),
	s("nhbd", t("neighborhood")),
	s("nhbds", t("neighborhoods")),
	s("st", t("such that")),
	s("fe", t("for every")),
	s("ae", t("almost everywhere")),

	-- Text mode formatting
	s({ trig = "tt", wordTrig = false }, fmt("\\text{{{}}}", { i(1) })),
	s({ trig = "ttt", wordTrig = true }, fmt("\\texttt{{{}}}", { i(1) })),
	s({ trig = "tit", wordTrig = true }, fmt("\\textit{{{}}}", { i(1) })),
	s({ trig = "tbf", wordTrig = true }, fmt("\\textbf{{{}}}", { i(1) })),
	s({ trig = "mrm", wordTrig = true }, fmt("\\mathrm{{{}}}", { i(1) })),
	s({ trig = "mbb", wordTrig = true }, fmt("\\mathbb{{{}}}", { i(1) })),
	s({ trig = "mcal", wordTrig = true }, fmt("\\mathcal{{{}}}", { i(1) })),
	s({ trig = "mfrak", wordTrig = true }, fmt("\\mathfrak{{{}}}", { i(1) })),
	autosnippet({
		trig = "^^",
		wordTrig = false,
		condition = not_in_math,
	}, fmt("\\textsuperscript{{{}}}", { i(1) })),
}
