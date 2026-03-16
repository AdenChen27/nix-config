local u = require("snippets.tex.utils")
local s, sn, t, i, f, d = u.s, u.sn, u.t, u.i, u.f, u.d
local select_or_insert = u.select_or_insert
local fmt, fmta = u.fmt, u.fmta
local conds, rep = u.conds, u.rep
local in_math, not_in_math = u.in_math, u.not_in_math
local autosnippet = u.autosnippet
local tex = u.tex

-- helper: creates an autosnippet for math mode with postfix trigger
local function in_math_postfix_snippet(name, trigger, template, opts)
	return autosnippet(
		vim.tbl_extend("force", {
			trig = trigger,
			wordTrig = false,
			regTrig = true,
			name = name,
			condition = in_math,
		}, opts or {}),
		f(function(_, snip)
			return string.format(template, snip.captures[1])
		end, {})
	)
end

-- helper: creates a tab-triggered snippet for math mode with postfix trigger
local function in_math_postfix_tab_snippet(name, trigger, template, opts)
	return s(
		vim.tbl_extend("force", {
			trig = trigger,
			wordTrig = false,
			regTrig = true,
			name = name,
			condition = in_math,
		}, opts or {}),
		f(function(_, snip)
			return string.format(template, snip.captures[1])
		end, {})
	)
end

return {
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
	-- neq and != are intentional duplicates: both expand to \neq for muscle-memory compatibility
	autosnippet(
		{ trig = "neq", dscr = "not equals", wordTrig = true, regTrig = false, condition = in_math },
		t("\\neq ")
	),
	autosnippet({ trig = "equiv", dscr = "equivalent", wordTrig = true, condition = in_math }, t("\\equiv ")),
	autosnippet({ trig = "(%s)in", wordTrig = false, regTrig = true, condition = in_math }, {
		f(function(_, snip)
			return snip.captures[1] .. "\\in"
		end),
	}),

	autosnippet({ trig = "!=", dscr = "not equal", wordTrig = true, condition = in_math }, t("\\neq ")),
	autosnippet({ trig = ":=", dscr = "coloneq", wordTrig = true, condition = in_math }, t("\\coloneqq")),
	autosnippet({ trig = "=:", dscr = "eqcolon", wordTrig = true, condition = in_math }, t("\\eqqcolon")),
	s({ trig = "ceil", wordTrig = true, condition = in_math }, fmt("\\left\\lceil {} \\right\\rceil ", { i(1) })),
	s({ trig = "floor", wordTrig = true, condition = in_math }, fmt("\\left\\lfloor {} \\right\\rfloor ", { i(1) })),

	-- Logic
	autosnippet({ trig = "EE", wordTrig = true, condition = in_math }, t("\\exists ")),
	autosnippet({ trig = "AA", wordTrig = true, condition = in_math }, t("\\forall ")),
	s({ trig = "contra", wordTrig = true, condition = in_math }, t("\\contradiction ")),

	-- Set notation
	autosnippet({ trig = "set", name = "set notation" }, fmta("\\{<>\\}<>", { i(1), i(0) }), { condition = in_math }),
	autosnippet({ trig = "eset", wordTrig = true, condition = in_math }, t("\\emptyset")),

	-- Relations and set symbols
	s({ trig = "\\", wordTrig = true, condition = in_math }, t("\\setminus ")),
	s({ trig = "cc", wordTrig = true, condition = in_math }, t("\\subset ")),
	s({ trig = "cceq", wordTrig = true, condition = in_math }, t("\\subseteq ")),
	s({ trig = "ccneq", wordTrig = true, condition = in_math }, t("\\subsetneq ")),
	s({ trig = "ncc", wordTrig = true, condition = in_math }, t("\\supset ")),
	s({ trig = "ncceq", wordTrig = true, condition = in_math }, t("\\supseteq ")),
	s({ trig = "nccneq", wordTrig = true, condition = in_math }, t("\\supsetneq ")),
	s({ trig = "compl", wordTrig = false, condition = in_math }, t("^\\complement")),

	-- Common symbols
	s({ trig = "inv", wordTrig = false, condition = in_math }, t("^{-1}")),
	s({ trig = "xx", wordTrig = true, condition = in_math }, t("\\times ")),
	s({ trig = "oxx", wordTrig = true, condition = in_math }, t("\\otimes ")),
	autosnippet({ trig = "~~", wordTrig = true, condition = in_math }, t("\\sim ")),
	s({ trig = "oo", wordTrig = true, condition = in_math }, t("\\infty")),
	autosnippet({ trig = "...", wordTrig = true, condition = in_math }, t("\\dots ")),
	s({ trig = "||", wordTrig = true, condition = in_math }, fmt("\\abs{{{}}}", { i(1) })),
	autosnippet({ trig = "|||", wordTrig = true, condition = in_math }, fmt("\\norm{{{}}}", { i(1) })),

	-- Functions and postfix forms
	s({ trig = "abs", wordTrig = true, condition = in_math }, fmt("\\abs{{{}}}", { i(1) })),
	s({ trig = "norm", wordTrig = true, condition = in_math }, fmt("\\norm{{{}}}", { i(1) })),
	autosnippet({ trig = "bar", wordTrig = true, condition = in_math }, fmt("\\bar{{{}}}", { i(1) })),
	autosnippet({ trig = "tilde", wordTrig = true, condition = in_math }, fmt("\\tilde{{{}}}", { i(1) })),
	autosnippet({ trig = "hat", wordTrig = true, condition = in_math }, fmt("\\hat{{{}}}", { i(1) })),
	s({ trig = "ol", wordTrig = true, condition = in_math }, fmt("\\overline{{{}}}", { i(1) })),
	s({ trig = "ul", wordTrig = true, condition = in_math }, fmt("\\underline{{{}}}", { i(1) })),
	autosnippet({ trig = "vec", wordTrig = true, condition = in_math }, fmt("\\vec{{{}}}", { i(1) })),

	s({ trig = "dot", wordTrig = false, condition = in_math }, fmt("\\dot{{{}}}", { i(1) })),
	s({ trig = "ddot", wordTrig = false, condition = in_math }, fmt("\\ddot{{{}}}", { i(1) })),
	-- Mode 2: single-char postfix (auto) — frontier pattern prevents match after another word char
	in_math_postfix_snippet("hat", "(%f[%w]%w)hat", "\\hat{%s}"),
	in_math_postfix_snippet("bar", "(%f[%w]%w)bar", "\\bar{%s}"),
	in_math_postfix_snippet("tilde", "(%f[%w]%w)tilde", "\\tilde{%s}"),
	in_math_postfix_snippet("overline", "(%w)ol", "\\overline{%s}"),
	in_math_postfix_snippet("underline", "(%w)ul", "\\underline{%s}"),
	-- Mode 3: multi-char postfix — tab for bar/tilde/hat (wide variants), auto for ol/ul
	in_math_postfix_tab_snippet("widehat", "([\\%w][%w]+)hat", "\\widehat{%s}", { priority = 2000 }),
	in_math_postfix_tab_snippet("overline", "([\\%w][%w]+)bar", "\\overline{%s}", { priority = 2000 }),
	in_math_postfix_tab_snippet("widetilde", "([\\%w][%w]+)tilde", "\\widetilde{%s}", { priority = 2000 }),
	in_math_postfix_snippet("overline", "([\\%w][%w]+)ol", "\\overline{%s}", { priority = 2000 }),
	in_math_postfix_snippet("underline", "([\\%w][%w]+)ul", "\\underline{%s}", { priority = 2000 }),
	in_math_postfix_snippet("ddot", "(%w+)ddot", "\\ddot{%s}"),
	in_math_postfix_snippet("vec", "(%w+),%.", "\\vec{%s}"),
	in_math_postfix_snippet("vec", "(%w+)%.,", "\\vec{%s}"),

	-- Subscripts and superscripts
	-- x1 → x_1
	autosnippet(
		{
			trig = "([%a%}%]%)])(%d)",
			regTrig = true,
			wordTrig = false,
			name = "auto-subscript (single digit)",
			condition = in_math,
		},
		f(function(_, snip)
			return snip.captures[1] .. "_" .. snip.captures[2]
		end)
	),
	-- x_12 → x_{12} (fixer: wraps in braces when a second digit appears)
	autosnippet(
		{
			trig = "_(%d%d+)",
			regTrig = true,
			wordTrig = false,
			name = "auto-subscript (multi digit fixer)",
			condition = in_math,
			priority = 2000,
		},
		f(function(_, snip)
			return "_{" .. snip.captures[1] .. "}"
		end)
	),
	-- Subscript: `__` → _{...}
	autosnippet(
		{
			trig = "__",
			wordTrig = false,
			condition = in_math,
		},
		fmt("_{{{}}}", { select_or_insert(1) })
	),

	-- Superscript: `^^` → ^{...}
	autosnippet(
		{
			trig = "^^",
			wordTrig = false,
			condition = in_math,
		},
		fmt("^{{{}}}", { select_or_insert(1) })
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
				t("\\frac{" .. num .. "}{"),
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

	-- Arrows
	autosnippet({ trig = "!>", wordTrig = false, condition = in_math }, t("\\mapsto ")),
	autosnippet({ trig = "-->", wordTrig = false, condition = in_math }, t("\\longrightarrow ")),
	autosnippet({ trig = "=>", wordTrig = false, condition = in_math }, t("\\Rightarrow ")),
	autosnippet({ trig = "<=", wordTrig = false, condition = in_math }, t("\\Leftarrow ")),
	autosnippet({ trig = ">>", wordTrig = false, condition = in_math }, t("\\gg ")),
	autosnippet({ trig = "<<", wordTrig = false, condition = in_math }, t("\\ll ")),

	-- Big operators
	s({ trig = "sum", wordTrig = true, condition = in_math }, fmta("\\sum_{<>}^{<>}<>", { i(1), i(2), i(0) })),
	s({ trig = "int", wordTrig = true, condition = in_math }, fmta("\\int_{<>}^{<>}<>", { i(1), i(2), i(0) })),
	s({ trig = "prod", wordTrig = true, condition = in_math }, fmta("\\prod_{<>}^{<>}<>", { i(1), i(2), i(0) })),
	s({ trig = "lim", wordTrig = true, condition = in_math }, fmta("\\lim_{<> \\to <>}<>", { i(1), i(2), i(0) })),

	-- Derivatives
	s(
		{ trig = "deri", wordTrig = true, condition = in_math },
		fmt("\\frac{{\\d {}}}{{\\d {}}}", { i(1, ""), i(2, "x") })
	),
	s(
		{ trig = "derik", wordTrig = true, condition = in_math },
		fmt("\\frac{{\\d^{{{}}} {}}}{{\\d {}^{{{}}}}}", { i(1, "k"), i(2, ""), i(3, "x"), rep(1) })
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
