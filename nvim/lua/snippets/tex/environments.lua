local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

return {
	s("sec", fmt("\\section{{{}}}", { i(1) })),
	autosnippet("sec*", fmt("\\section*{{{}}}", { i(1) })),
	s("subsec", fmt("\\subsection{{{}}}", { i(1) })),
	autosnippet("subsec*", fmt("\\subsection*{{{}}}", { i(1) })),
	s("subsubsec", fmt("\\subsubsection{{{}}}", { i(1) })),
	autosnippet("subsubsec*", fmt("\\subsubsection*{{{}}}", { i(1) })),

	s("thm", fmt("\\begin{{theorem}}{}\n\\end{{theorem}}", { i(1) })),
	autosnippet("thm*", fmt("\\begin{{theorem*}}{}\n\\end{{theorem*}}", { i(1) })),
	s("lem", fmt("\\begin{{lemma}}{}\n\\end{{lemma}}", { i(1) })),
	autosnippet("lem*", fmt("\\begin{{lemma*}}{}\n\\end{{lemma*}}", { i(1) })),
	s("cor", fmt("\\begin{{corollary}}{}\n\\end{{corollary}}", { i(1) })),
	autosnippet("cor*", fmt("\\begin{{corollary*}}{}\n\\end{{corollary*}}", { i(1) })),
	s("def", fmt("\\begin{{definition}}{}\n\\end{{definition}}", { i(1) })),
	autosnippet("def*", fmt("\\begin{{definition*}}{}\n\\end{{definition*}}", { i(1) })),
	s("prop", fmt("\\begin{{proposition}}{}\n\\end{{proposition}}", { i(1) })),
	autosnippet("prop*", fmt("\\begin{{proposition*}}{}\n\\end{{proposition*}}", { i(1) })),
	s("rem", fmt("\\begin{{remark}}{}\n\\end{{remark}}", { i(1) })),
	autosnippet("rem*", fmt("\\begin{{remark*}}{}\n\\end{{remark*}}", { i(1) })),
	s("proof", fmt("\\begin{{proof}}{}\n\\end{{proof}}", { i(1) })),
	s("example", fmt("\\begin{{example}}{}\n\\end{{example}}", { i(1) })),
	autosnippet("example*", fmt("\\begin{{example*}}{}\n\\end{{example*}}", { i(1) })),
	s("problem", fmt("\\begin{{problem}}{}\n\\end{{problem}}", { i(1) })),
	autosnippet("problem*", fmt("\\begin{{problem*}}{}\n\\end{{problem*}}", { i(1) })),
	s("eqn", fmt("\\begin{{equation}}{}\n\\end{{equation}}", { i(1) })),
	autosnippet("eqn*", fmt("\\begin{{equation*}}{}\n\\end{{equation*}}", { i(1) })),
	s("align", fmt("\\begin{{align}}{}\n\\end{{align}}", { i(1) })),
	s("gather", fmt("\\begin{{gather}}{}\n\\end{{gather}}", { i(1) })),
	autosnippet("gather*", fmt("\\begin{{gather*}}{}\n\\end{{gather*}}", { i(1) })),
	s("item", fmt("\\begin{{itemize}}{}\n\\end{{itemize}}", { i(1) })),
	s("enum", fmt("\\begin{{enumerate}}[label=(\\roman*)]{}\n\\end{{enumerate}}", { i(1) })),
	autosnippet("align*", fmt("\\begin{{align*}}{}\n\\end{{align*}}", { i(1) })),
	s("beg", fmt("\\begin{{{}}}{}\n\\end{{{}}}", { i(1), i(2), rep(1) })),
	s("case", fmt("\\begin{{cases}}{}\n\\end{{cases}}", { i(1) })),
	s("pmat", fmt("\\begin{{pmatrix}}{}\n\\end{{pmatrix}}", { i(1) })),
	s("bmat", fmt("\\begin{{bmatrix}}{}\n\\end{{bmatrix}}", { i(1) })),
	s("vmat", fmt("\\begin{{vmatrix}}{}\n\\end{{vmatrix}}", { i(1) })),
	s("fig", fmt(
		"\\begin{{figure}}[{}]\n  \\centering\n  \\includegraphics[width={}\\textwidth]{{{}}}\n  \\caption{{{}}}\n  \\label{{fig:{}}}\n\\end{{figure}}",
		{ i(1, "htbp"), i(2, "0.8"), i(3, "filename"), i(4, "caption"), i(5) }
	)),
	s("tab", fmt(
		"\\begin{{table}}[{}]\n  \\centering\n  \\begin{{tabular}}{{{}}}\n    {}\n  \\end{{tabular}}\n  \\caption{{{}}}\n  \\label{{tab:{}}}\n\\end{{table}}",
		{ i(1, "htbp"), i(2, "cc"), i(3), i(4, "caption"), i(5) }
	)),
}
