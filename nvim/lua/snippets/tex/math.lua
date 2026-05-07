local u = require("snippets.tex.utils")
local s, sn, t, i, f, d = u.s, u.sn, u.t, u.i, u.f, u.d
local select_or_insert = u.select_or_insert
local fmt, fmta = u.fmt, u.fmta
local conds, rep = u.conds, u.rep
local in_math, not_in_math = u.in_math, u.not_in_math
local autosnippet = u.autosnippet
local tex = u.tex

-- helper: creates a postfix snippet for math mode
-- auto=false → tab-triggered; otherwise autosnippet (default)
local function postfix(name, trigger, template, opts, auto)
	local constructor = (auto == false) and s or autosnippet
	return constructor(
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

-- Data-driven symbol tables: { trigger, output, [description], [wordTrig] }
-- wordTrig defaults to true; set [4]=false to override
local auto_symbols = {
	{ "neq",   "\\neq ",            "not equals" },
	{ "equiv", "\\equiv ",          "equivalent" },
	{ "!=",    "\\neq ",            "not equal" },
	{ ":=",    "\\coloneq",         "coloneq" },
	{ "=:",    "\\eqcolon",         "eqcolon" },
	{ "EE",    "\\exists " },
	{ "AA",    "\\forall " },
	{ "eset",  "\\emptyset" },
	{ "~~",    "\\sim " },
	{ "...",   "\\dots " },
	{ "!>",    "\\mapsto ",         nil, false },
	{ "-->",   "\\longrightarrow ", nil, false },
	{ "=>",    "\\Rightarrow",      nil, false },
	{ "<=",    "\\Leftarrow",       nil, false },
	{ ">>",    "\\gg ",             nil, false },
	{ "<<",    "\\ll ",             nil, false },
}

local tab_symbols = {
	{ "cc",     "\\subset " },
	{ "cceq",   "\\subseteq " },
	{ "ccneq",  "\\subsetneq " },
	{ "ncc",    "\\supset " },
	{ "ncceq",  "\\supseteq " },
	{ "nccneq", "\\supsetneq " },
	{ "contra", "\\contradiction " },
	{ "\\",     "\\setminus " },
	{ "xx",     "\\times " },
	{ "oxx",    "\\otimes " },
	{ "oo",     "\\infty" },
	{ "compl",  "^\\complement",    nil, false },
	{ "inv",    "^{-1}",            nil, false },
}

local snippets = {}

for _, v in ipairs(auto_symbols) do
	table.insert(snippets, autosnippet(
		{ trig = v[1], dscr = v[3], wordTrig = v[4] ~= false, condition = in_math },
		t(v[2])
	))
end

for _, v in ipairs(tab_symbols) do
	table.insert(snippets, s(
		{ trig = v[1], dscr = v[3], wordTrig = v[4] ~= false, condition = in_math },
		t(v[2])
	))
end

vim.list_extend(snippets, {
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

	-- (%s)in → \in (regex: requires whitespace before "in")
	autosnippet({ trig = "(%s)in", wordTrig = false, regTrig = true, condition = in_math }, {
		f(function(_, snip)
			return snip.captures[1] .. "\\in"
		end),
	}),

	-- Delimiters with insert nodes
	s({ trig = "ceil", wordTrig = true, condition = in_math }, fmt("\\left\\lceil {} \\right\\rceil ", { i(1) })),
	s({ trig = "floor", wordTrig = true, condition = in_math }, fmt("\\left\\lfloor {} \\right\\rfloor ", { i(1) })),
	s({ trig = "||", wordTrig = true, condition = in_math }, fmt("\\abs{{{}}}", { i(1) })),
	autosnippet({ trig = "|||", wordTrig = true, condition = in_math }, fmt("\\norm{{{}}}", { i(1) })),

	-- Set notation
	autosnippet({ trig = "set", name = "set notation" }, fmta("\\{<>\\}<>", { i(1), i(0) }), { condition = in_math }),

	-- Functions and decorations (with insert nodes)
	s({ trig = "abs", wordTrig = true, condition = in_math }, fmt("\\abs{{{}}}", { i(1) })),
	s({ trig = "norm", wordTrig = true, condition = in_math }, fmt("\\norm{{{}}}", { i(1) })),
	autosnippet({ trig = "bar", wordTrig = true, condition = in_math }, fmt("\\bar{{{}}}", { i(1) })),
	autosnippet({ trig = "tilde", wordTrig = true, condition = in_math }, fmt("\\tilde{{{}}}", { i(1) })),
	autosnippet({ trig = "hat", wordTrig = true, condition = in_math }, fmt("\\hat{{{}}}", { i(1) })),
	s({ trig = "ol", wordTrig = true, condition = in_math }, fmt("\\overline{{{}}}", { i(1) })),
	s({ trig = "ul", wordTrig = true, condition = in_math }, fmt("\\underline{{{}}}", { i(1) })),
	autosnippet({ trig = "vec", wordTrig = true, condition = in_math }, fmt("\\vec{{{}}}", { i(1) })),
	s({ trig = "dot", wordTrig = false, condition = in_math }, fmt("\\dot{{{}}}", { i(1) })),
	s({ trig = "ddot", wordTrig = false, priority = 1001, condition = in_math }, fmt("\\ddot{{{}}}", { i(1) })),

	-- Postfix decorations
	-- Mode 2: single-char postfix — frontier pattern prevents match after another word char
	-- hat/bar/tilde are auto; ol/ul are tab-triggered
	postfix("hat", "(%f[%w]%w)hat", "\\hat{%s}"),
	postfix("bar", "(%f[%w]%w)bar", "\\bar{%s}"),
	postfix("tilde", "(%f[%w]%w)tilde", "\\tilde{%s}"),
	postfix("overline", "(%f[%w]%w)ol", "\\overline{%s}", nil, false),
	postfix("underline", "(%f[%w]%w)ul", "\\underline{%s}", nil, false),
	-- Mode 3: multi-char postfix — tab for bar/tilde/hat (wide variants), auto for ol/ul
	postfix("widehat", "([\\%w][%w]+)hat", "\\widehat{%s}", { priority = 2000 }, false),
	postfix("overline", "([\\%w][%w]+)bar", "\\overline{%s}", { priority = 2000 }, false),
	postfix("widetilde", "([\\%w][%w]+)tilde", "\\widetilde{%s}", { priority = 2000 }, false),
	postfix("overline", "([\\%w][%w]+)ol", "\\overline{%s}", { priority = 2000 }, false),
	postfix("underline", "([\\%w][%w]+)ul", "\\underline{%s}", { priority = 2000 }, false),
	postfix("ddot", "(%w+)ddot", "\\ddot{%s}"),
	postfix("vec", "(%w+),%.", "\\vec{%s}"),
	postfix("vec", "(%w+)%.,", "\\vec{%s}"),

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

	-- Big operators
	s({ trig = "sum", wordTrig = true, condition = in_math }, fmta("\\sum_{<>}^{<>}<>", { i(1), i(2), i(0) })),
	s({ trig = "int", wordTrig = true, condition = in_math }, fmta("\\int_{<>}^{<>}<>", { i(1), i(2), i(0) })),
	s({ trig = "prod", wordTrig = true, condition = in_math }, fmta("\\prod_{<>}^{<>}<>", { i(1), i(2), i(0) })),
	s({ trig = "lim", wordTrig = true, condition = in_math }, fmta("\\lim_{<> \\to <>}<>", { i(1), i(2), i(0) })),

	-- Derivatives
	s(
		{ trig = "deri", wordTrig = true, condition = in_math },
		fmt("\\frac{{\\dd {}}}{{\\dd {}}}", { i(1, ""), i(2, "x") })
	),
	s(
		{ trig = "derik", wordTrig = true, condition = in_math },
		fmt("\\frac{{\\dd^{{{}}} {}}}{{\\dd {}^{{{}}}}}", { i(1, "k"), i(2, ""), i(3, "x"), rep(1) })
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
})

return snippets
