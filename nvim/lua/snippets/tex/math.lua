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
local not_in_math = function(...)
	return not in_math(...)
end

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
	s("item", fmt("\\begin{{itemize}}{}\n\\end{{itemize}}", { i(1) })),
	s("enum", fmt("\\begin{{enumerate}}[label=(\\roman*)]{}\n\\end{{enumerate}}", { i(1) })),
	autosnippet("align*", fmt("\\begin{{align*}}{}\n\\end{{align*}}", { i(1) })),
	s("beg", fmt("\\begin{{{}}}{}\n\\end{{{}}}", { i(1), i(2), rep(1) })),
}

-- Text abbreviations (plain snippets)
M.text_abbr = {
	s("cont", t("continuous")),
	s("iff", t("if and only if")),
	s("nhbd", t("neighborhood")),
	s("nhbds", t("neighborhoods")),
	s("st", t("such that")),
	s("fe", t("for every")),
	s("ae", t("almost everywhere")),
}

-- Text mode formatting (word triggers)
M.text_format = {
	s({ trig = "tt", wordTrig = false }, fmt("\\text{{{}}}", { i(1) })),
	s({ trig = "ttt", wordTrig = true }, fmt("\\texttt{{{}}}", { i(1) })),
	s({ trig = "tit", wordTrig = true }, fmt("\\textit{{{}}}", { i(1) })),
	s({ trig = "tbf", wordTrig = true }, fmt("\\textbf{{{}}}", { i(1) })),
	autosnippet({
		trig = "^^",
		wordTrig = false,
		condition = not_in_math,
	}, fmt("\\textsuperscript{{{}}}", { i(1) })),
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
	autosnippet(
		{ trig = "mk", name = "inline math" },
		fmta("\\(<>\\)<>", { i(1), i(0) }),
		{ condition = not_in_math, show_condition = not_in_math }
	),

	-- Display math \[ ... \]
	autosnippet(
		{ trig = "dm", name = "display math" },
		fmta(
			[[
    \[
      <>
    \]<>]],
			{ i(1), i(0) }
		),
		{ condition = conds.line_begin, show_condition = tex.show_line_begin }
	),

	-- Common math snippets with math context
	autosnippet(
		{ trig = "neq", dscr = "not equals", wordTrig = true, regTrig = false, condition = in_math },
		t("\\neq ")
	),
	autosnippet({ trig = "equiv", dscr = "equivalent", wordTrig = true, condition = in_math }, t("\\equiv ")),
	-- autosnippet({ trig = "in", wordTrig = true, condition = in_math }, t("\\in")),
	autosnippet({ trig = "(%s)in", wordTrig = false, regTrig = true, condition = in_math }, {
		f(function(_, snip)
			return snip.captures[1] .. "\\in"
		end),
	}),

	autosnippet({ trig = "!=", dscr = "not equal", wordTrig = true, condition = in_math }, t("\\neq ")),
	autosnippet({ trig = "=:", dscr = "coloneqq", wordTrig = true, condition = in_math }, t("\\eqqcolon")),
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
	s({ trig = "inv", wordTrig = false, condition = in_math }, t("^{-1}")),
	s({ trig = "conj", wordTrig = true, condition = in_math }, fmt("\\overline{{{}}}", { i(1) })),
	s({ trig = "xx", wordTrig = true, condition = in_math }, t("\\times ")),
	s({ trig = "oxx", wordTrig = true, condition = in_math }, t("\\otimes ")),
	s({ trig = "~~", wordTrig = true, condition = in_math }, t("\\sim ")),
	s({ trig = "oo", wordTrig = true, condition = in_math }, t("\\infty")),
	autosnippet({ trig = "...", wordTrig = true, condition = in_math }, t("\\dots ")),
	s({ trig = "||", wordTrig = true, condition = in_math }, fmt("\\abs{{{}}}", { i(1) })),
	autosnippet({ trig = "|||", wordTrig = true, condition = in_math }, fmt("\\norm{{{}}}", { i(1) })),

	-- Functions and postfix forms (some with postfix helper)
	s({ trig = "abs", wordTrig = true, condition = in_math }, fmt("\\abs{{{}}}", { i(1) })),
	s({ trig = "norm", wordTrig = true, condition = in_math }, fmt("\\norm{{{}}}", { i(1) })),
	autosnippet({ trig = "bar", wordTrig = true, condition = in_math }, fmt("\\overline{{{}}}", { i(1) })),
	autosnippet({ trig = "tilde", wordTrig = true, condition = in_math }, fmt("\\tilde{{{}}}", { i(1) })),
	autosnippet({ trig = "hat", wordTrig = true, condition = in_math }, fmt("\\hat{{{}}}", { i(1) })),
	autosnippet({ trig = "vec", wordTrig = true, condition = in_math }, fmt("\\vec{{{}}}", { i(1) })),

	-- s(
	-- 	{
	-- 		trig = "(%s%a)hat",
	-- 		regTrig = true,
	-- 		wordTrig = false,
	-- 		snippetType = "autosnippet",
	-- 		name = "hat",
	-- 		condition = in_math,
	-- 	},
	-- 	f(function(_, snip)
	-- 		return string.format(" \\hat{%s}", snip.captures[1]:gsub("^%s+", ""))
	-- 	end, {})
	-- ),
	-- in_math_postfix_snippet("bar",   "(%S+)bar",   "\\overline{%s}"),
	-- in_math_postfix_snippet("tilde", "(%S+)tilde", "\\tilde{%s}"),
	s({ trig = "dot", wordTrig = false, condition = in_math }, fmt("\\dot{{{}}}", { i(1) })),
	s({ trig = "ddot", wordTrig = false, condition = in_math }, fmt("\\ddot{{{}}}", { i(1) })),
	in_math_postfix_snippet("widehat", "(%w)hat", "\\hat{%s}"),
	-- in_math_postfix_snippet("ddot",  "(%S+)ddot",  "\\ddot{%s}"),
	-- in_math_postfix_snippet("vec",   "(%S+),%.",    "\\vec{%s}"),
	-- in_math_postfix_snippet("vec",   "(%S+)%.,",    "\\vec{%s}"),
	in_math_postfix_snippet("bar", "(%w+)bar", "\\overline{%s}"),
	in_math_postfix_snippet("tilde", "(%w+)tilde", "\\tilde{%s}"),
	in_math_postfix_snippet("widehat", "(%w%w+)hat", "\\widehat{%s}"),
	in_math_postfix_snippet("ddot", "(%w+)ddot", "\\ddot{%s}"),
	in_math_postfix_snippet("vec", "(%w+),%.", "\\vec{%s}"),
	in_math_postfix_snippet("vec", "(%w+)%.,", "\\vec{%s}"),

	-- Subscripts and superscripts
	autosnippet(
		{
			trig = "([%a%}%]%)])(%d+)",
			regTrig = true,
			wordTrig = false,
			name = "auto-subscript",
			condition = require("luasnip.extras.expand_conditions").in_mathzone,
		},
		d(1, function(_, snip)
			local base = snip.captures[1]
			local sub = snip.captures[2]
			return sn(nil, {
				f(function()
					return base .. "_"
				end),
				t(sub),
			})
		end)
	),
	-- Subscript: `__` → _{...}
	autosnippet(
		{
			trig = "__",
			wordTrig = false,
			condition = in_math,
		},
		fmt("_{{{}}}", {
			d(1, function(_, parent)
				if #parent.snippet.env.SELECT_RAW > 0 then
					return sn(nil, t(parent.snippet.env.SELECT_RAW))
				else
					return sn(nil, i(1))
				end
			end),
		})
	),

	-- Superscript: `^^` → ^{...}
	autosnippet(
		{
			trig = "^^",
			wordTrig = false,
			condition = in_math,
		},
		fmt("^{{{}}}", {
			d(1, function(_, parent)
				if #parent.snippet.env.SELECT_RAW > 0 then
					return sn(nil, t(parent.snippet.env.SELECT_RAW))
				else
					return sn(nil, i(1))
				end
			end),
		})
	),

	-- Fractions
	autosnippet({ trig = "//", condition = in_math }, {
		t("\\frac{"),
		i(1),
		t("}{"),
		i(2),
		t("}"),
		i(0),
	}),
	autosnippet(
		{
			trig = "([^%s%{%}]+)/",
			regTrig = true,
			wordTrig = false,
			condition = in_math,
			name = "frac",
		},
		d(1, function(_, snip)
			local num = snip.captures[1]
			return sn(nil, {
				f(function()
					return "\\frac{" .. num .. "}{"
				end),
				i(1),
				t("}"),
			})
		end)
	),

	-- Delimiters
	s({ trig = "%(%)", wordTrig = false, regTrig = true, condition = in_math }, fmt("\\left( {} \\right)", { i(1) })),
	s({ trig = "%[%]", wordTrig = false, regTrig = true, condition = in_math }, fmt("\\left[ {} \\right]", { i(1) })),
	s(
		{ trig = "%{%}", wordTrig = false, regTrig = true, condition = in_math },
		fmt("\\left\\{{{} \\right\\}}", { i(1) })
	),
	s({ trig = "<>", wordTrig = false, regTrig = true, condition = in_math }, fmt("\\left< {} \\right>", { i(1) })),

	--
	autosnippet({ trig = "!>", wordTrig = false, condition = in_math }, t("\\mapsto ")),
	autosnippet({ trig = ">>", wordTrig = false, condition = in_math }, t("\\gg")),
	autosnippet({ trig = "<<", wordTrig = false, condition = in_math }, t("\\ll")),
	-- derivatives etc
	autosnippet(
		{ trig = "deri", wordTrig = true, condition = in_math },
		fmt("\\frac{{\\d {}}}{{\\d {}}}", { i(1, "V"), i(2, "x") })
	),
	s(
		{ trig = "part", wordTrig = true, condition = in_math },
		fmt("\\frac{{\\partial {}}}{{\\partial {}}}", { i(1, "V"), i(2, "x") })
	),

	s(
		{ trig = "ipart", wordTrig = true, condition = in_math },
		fmt("{{\\partial {}}} / {{\\partial {}}}", { i(1, "V"), i(2, "x") })
	),

	s(
		{ trig = "partk", wordTrig = true, condition = in_math },
		fmt("\\frac{{\\partial^{{{}}} {}}}{{\\partial {}^{{{}}}}}", { i(1, "k"), i(2, "V"), i(3, "x"), rep(1) })
	),

	s(
		{ trig = "ipartk", wordTrig = true, condition = in_math },
		fmt("{{\\partial^{{{}}} {}}} / {{\\partial {}^{{{}}}}}", { i(1, "k"), i(2, "V"), i(3, "x"), rep(1) })
	),
	-- bigfun
	autosnippet(
		{
			trig = "bigfun",
			wordTrig = true,
			condition = in_math,
		},
		fmt(
			[[
    \begin{{align*}}
      {}: {} &\longrightarrow {} \\\\
           {} &\longmapsto {}
    \end{{align*}}
    ]],
			{
				i(1),
				i(2),
				i(3),
				i(4),
				i(5),
			}
		)
	),
}

-- Export all snippets combined
M.all = {}
for _, group in ipairs({ M.sections, M.text_abbr, M.text_format, M.math }) do
	for _, snip in ipairs(group) do
		table.insert(M.all, snip)
	end
end

return M.all
