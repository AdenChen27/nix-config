local u = require("snippets.tex.utils")
local s, i, fmt = u.s, u.i, u.fmt
local rep, not_in_math = u.rep, u.not_in_math
local env_pair, sec_pair, env, math_env = u.env_pair, u.sec_pair, u.env, u.math_env

local snippets = {}

-- Sections
vim.list_extend(snippets, sec_pair("sec", "section"))
vim.list_extend(snippets, sec_pair("subsec", "subsection"))
vim.list_extend(snippets, sec_pair("subsubsec", "subsubsection"))

-- Theorem-like environments
vim.list_extend(snippets, env_pair("thm", "theorem"))
vim.list_extend(snippets, env_pair("lem", "lemma"))
vim.list_extend(snippets, env_pair("cor", "corollary"))
vim.list_extend(snippets, env_pair("def", "definition"))
vim.list_extend(snippets, env_pair("prop", "proposition"))
vim.list_extend(snippets, env_pair("rem", "remark"))
vim.list_extend(snippets, env_pair("example", "example"))
vim.list_extend(snippets, env_pair("problem", "problem"))
vim.list_extend(snippets, { s({ trig = "proof", condition = not_in_math }, fmt("\\begin{{proof}}{}\n\\end{{proof}}", { i(1) })) })

-- Equations
vim.list_extend(snippets, env_pair("eqn", "equation"))
vim.list_extend(snippets, env_pair("align", "align"))
vim.list_extend(snippets, env_pair("gather", "gather"))

-- Lists
vim.list_extend(snippets, {
	env("item", "itemize"),
	s({ trig = "enum", condition = not_in_math }, fmt("\\begin{{enumerate}}[label=(\\roman*)]{}\n\\end{{enumerate}}", { i(1) })),
})

-- Matrices
vim.list_extend(snippets, {
	math_env("case", "cases"),
	math_env("pmat", "pmatrix"),
	math_env("bmat", "bmatrix"),
	math_env("vmat", "vmatrix"),
})

-- Generic environment
vim.list_extend(snippets, {
	s({ trig = "beg", condition = not_in_math }, fmt("\\begin{{{}}}{}\n\\end{{{}}}", { i(1), i(2), rep(1) })),
})

-- Floats
vim.list_extend(snippets, {
	s("fig", fmt(
		"\\begin{{figure}}[{}]\n  \\centering\n  \\includegraphics[width={}\\textwidth]{{{}}}\n  \\caption{{{}}}\n  \\label{{fig:{}}}\n\\end{{figure}}",
		{ i(1, "htbp"), i(2, "0.8"), i(3, "filename"), i(4, "caption"), i(5) }
	)),
	s("tab", fmt(
		"\\begin{{table}}[{}]\n  \\centering\n  \\begin{{tabular}}{{{}}}\n    {}\n  \\end{{tabular}}\n  \\caption{{{}}}\n  \\label{{tab:{}}}\n\\end{{table}}",
		{ i(1, "htbp"), i(2, "cc"), i(3), i(4, "caption"), i(5) }
	)),
})

return snippets
