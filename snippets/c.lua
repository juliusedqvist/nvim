local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		{ trig = "for" },
		fmt(
			[[
		for (int {} = {}; {} < {}; {}) {{
			{}
		}}
		{}
	]],
			{
				i(1, "i"), -- Loop variable
				i(2, "0"), -- Initial value
				i(3, "i"), -- Condition variable
				i(4, "N"), -- Condition value
				i(5, "i++"), -- Increment step
				i(6), -- Inside loop body
				i(0), -- Cursor after loop
			}
		)
	),
	s({ trig = "init" }, {
		t({ "#include <stdio.h>", "#include <stdlib.h>", "", "int main (int argc, char *argv[]) {", "\t" }),
		i(0), -- Cursor placement for user input
		t({ "", "\treturn 0;", "}" }),
	}),
}
