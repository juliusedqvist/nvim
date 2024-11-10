local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		{ trig = "qq", snippetType = "autosnippet" },
		fmt("s({ trig = '<>', snippetType = 'autosnippet' }, t('\\\\<>')),", {
			i(1),
			i(2),
		}, { delimiters = "<>" })
	),
	s(
		{ trig = "qm", snippetType = "autosnippet" },
		fmt("s({ trig = '<>', snippetType = 'autosnippet' }, t('\\\\<>'), { condition = in_mathzone }),", {
			i(1),
			i(2),
		}, { delimiters = "<>" })
	),
	s(
		{ trig = "qa", snippetType = "autosnippet" },
		fmt(
			"s({ trig = '<>', condition = in_mathzone, snippetType = 'autosnippet' }, fmta('<>', { i(1, '<>'), i(2, '<>'), })),",
			{
				i(1),
				i(2),
				i(3),
				i(4),
			},
			{ delimiters = "<>" }
		)
	),
}
