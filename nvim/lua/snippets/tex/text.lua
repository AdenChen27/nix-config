local u = require("snippets.tex.utils")
local s, t, i, fmt = u.s, u.t, u.i, u.fmt
local autosnippet, not_in_math = u.autosnippet, u.not_in_math

return {
	-- Abbreviations
	s("cont", t("continuous")),
	s("iff", t("if and only if")),
	s("nhbd", t("neighborhood")),
	s("nhbds", t("neighborhoods")),
	s("st", t("such that")),
	s("fe", t("for every")),
	s("ae", t("almost everywhere")),

	-- Formatting
	s({ trig = "tt", wordTrig = true }, fmt("\\text{{{}}}", { i(1) })),
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
