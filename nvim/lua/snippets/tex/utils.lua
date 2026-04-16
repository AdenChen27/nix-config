local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local rep = require("luasnip.extras").rep
local tex = require("snippets.tex.conditions")

local M = {
	ls = ls,
	s = s,
	sn = sn,
	t = t,
	i = i,
	f = f,
	d = d,
	fmt = fmt,
	fmta = fmta,
	conds = conds,
	rep = rep,
	tex = tex,
	in_math = tex.in_math,
}

function M.not_in_math(...)
	return not tex.in_math(...)
end

M.autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

--- Dynamic node: uses SELECT_RAW (visual selection) if available, else insert node
function M.select_or_insert(pos)
	return d(pos, function(_, parent)
		if #parent.snippet.env.SELECT_RAW > 0 then
			return sn(nil, t(parent.snippet.env.SELECT_RAW))
		else
			return sn(nil, i(1))
		end
	end)
end

--- Returns { regular_snippet, starred_autosnippet } for \begin{env}...\end{env}
function M.env_pair(trigger, env_name)
	local env_fmt = "\\begin{{%s}}{}\n\\end{{%s}}"
	return {
		s(
			{ trig = trigger, condition = M.not_in_math },
			fmt(string.format(env_fmt, env_name, env_name), { i(1) })
		),
		M.autosnippet(
			{ trig = trigger .. "*", condition = M.not_in_math },
			fmt(string.format(env_fmt, env_name .. "*", env_name .. "*"), { i(1) })
		),
	}
end

--- Returns a single snippet for \begin{env}...\end{env} (no starred variant)
function M.env(trigger, env_name)
	return s(
		{ trig = trigger, condition = M.not_in_math },
		fmt(string.format("\\begin{{%s}}{}\n\\end{{%s}}", env_name, env_name), { i(1) })
	)
end

--- Like env(), but gated on being inside math mode
function M.math_env(trigger, env_name)
	return s(
		{ trig = trigger, condition = tex.in_math },
		fmt(string.format("\\begin{{%s}}{}\n\\end{{%s}}", env_name, env_name), { i(1) })
	)
end

--- Returns { regular_snippet, starred_autosnippet } for \section{}, etc.
function M.sec_pair(trigger, cmd_name)
	local sec_fmt = "\\%s{{{}}}"
	return {
		s({ trig = trigger, condition = M.not_in_math }, fmt(string.format(sec_fmt, cmd_name), { i(1) })),
		M.autosnippet({ trig = trigger .. "*", condition = M.not_in_math }, fmt(string.format(sec_fmt, cmd_name .. "*"), { i(1) })),
	}
end

return M
