local function in_sympy_block()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], false)[1]
	return line and line:match("sympy .* sympy") ~= nil
end

local ls = require("luasnip")

ls.config.setup({
	enable_autosnippets = true,
	ext_opts = {
		condition = function()
			return not in_sympy_block()
		end,
	},
})

local s = ls.snippet
local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local extras = require("luasnip.extras")
local rep = extras.rep
local extdec = ls.extend_decorator
local postfix = require("luasnip.extras.postfix").postfix
local sn = ls.snippet_node

local function in_mathzone()
	return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1 and not in_sympy_block()
end

extdec.register(s, { arg_indx = 3 })
extdec.register(postfix, { arg_indx = 3 })
local sm = extdec.apply(s, { condition = in_mathzone, show_condition = in_mathzone })
local sb = extdec.apply(s, { condition = line_begin })

local postfixm = extdec.apply(postfix, { condition = in_mathzone, show_condition = in_mathzone })

return {
	-- Test Greek
	s({ trig = "alp", snippetType = "autosnippet" }, t("\\alpha"), { condition = in_mathzone }),
	s({ trig = "circ", snippetType = "autosnippet" }, t("\\circ"), { condition = in_mathzone }),

	-- Example regex
	s( -- This snippets creates the sympy block ;)
		{ trig = "sym", desc = "Creates a sympy block" },
		fmt("sympy {} sympy{}", { i(1), i(0) })
	),

	s( -- This one evaluates anything inside the simpy block
		{ trig = "sympy.*sympy", regTrig = true, desc = "Sympy block evaluator" },
		d(1, function(_, parent)
			-- Gets the part of the block we actually want, and replaces spaces
			-- at the beginning and at the end
			local to_eval = string.gsub(parent.trigger, "^sympy(.*)sympy", "%1")
			to_eval = string.gsub(to_eval, "^%s+(.*)%s+$", "%1")

			local Job = require("plenary.job")

			local sympy_script = string.format(
				[[
from sympy import *
from sympy.parsing.sympy_parser import parse_expr
from sympy.printing.latex import print_latex
parsed = parse_expr('%s')
print_latex(parsed)
            ]],
				to_eval
			)

			sympy_script = string.gsub(sympy_script, "^[\t%s]+", "")
			local result = ""

			Job:new({
				command = "python",
				args = {
					"-c",
					sympy_script,
				},
				on_exit = function(j)
					result = j:result()
				end,
			}):sync()

			return sn(nil, t(result))
		end)
	),

	s({
		trig = "([oO]mg)",
		snippetType = "autosnippet",
		condition = in_mathzone,
		regTrig = true,
	}, {
		f(function(_, snip)
			return "\\" .. snip.captures[1]:sub(1, 1) .. "mega"
		end),
	}),

	-- Greek letters connection

	s({ trig = "Alp", snippetType = "autosnippet" }, t("\\Alpha"), { condition = in_mathzone }),
	s({ trig = "Beta", snippetType = "autosnippet" }, t("\\Beta"), { condition = in_mathzone }),
	s({ trig = "beta", snippetType = "autosnippet" }, t("\\beta"), { condition = in_mathzone }),
	s({ trig = "gam", snippetType = "autosnippet" }, t("\\gamma"), { condition = in_mathzone }),
	s({ trig = "Gam", snippetType = "autosnippet" }, t("\\Gamma"), { condition = in_mathzone }),
	s({ trig = "del", snippetType = "autosnippet" }, t("\\delta"), { condition = in_mathzone }),
	s({ trig = "Del", snippetType = "autosnippet" }, t("\\Delta"), { condition = in_mathzone }),
	s({ trig = "eps", snippetType = "autosnippet" }, t("\\epsilon"), { condition = in_mathzone }),
	s({ trig = "Eps", snippetType = "autosnippet" }, t("\\Epsilon"), { condition = in_mathzone }),
	s({ trig = "zeta", snippetType = "autosnippet" }, t("\\zeta"), { condition = in_mathzone }),
	s({ trig = "Zeta", snippetType = "autosnippet" }, t("\\Zeta"), { condition = in_mathzone }),
	s({ trig = "eta", snippetType = "autosnippet" }, t("\\eta"), { condition = in_mathzone }),
	s({ trig = "Eta", snippetType = "autosnippet" }, t("\\Eta"), { condition = in_mathzone }),
	s({ trig = "tht", snippetType = "autosnippet" }, t("\\theta"), { condition = in_mathzone }),
	s({ trig = "Tht", snippetType = "autosnippet" }, t("\\Theta"), { condition = in_mathzone }),
	s({ trig = "iota", snippetType = "autosnippet" }, t("\\iota"), { condition = in_mathzone }),
	s({ trig = "Iota", snippetType = "autosnippet" }, t("\\Iota"), { condition = in_mathzone }),
	s({ trig = "kap", snippetType = "autosnippet" }, t("\\kappa"), { condition = in_mathzone }),
	s({ trig = "Kap", snippetType = "autosnippet" }, t("\\Kappa"), { condition = in_mathzone }),
	s({ trig = "lam", snippetType = "autosnippet" }, t("\\lambda"), { condition = in_mathzone }),
	s({ trig = "Lam", snippetType = "autosnippet" }, t("\\Lambda"), { condition = in_mathzone }),
	s({ trig = "mu", snippetType = "autosnippet" }, t("\\mu"), { condition = in_mathzone }),
	s({ trig = "Mu", snippetType = "autosnippet" }, t("\\Mu"), { condition = in_mathzone }),
	s({ trig = "nu", snippetType = "autosnippet" }, t("\\nu"), { condition = in_mathzone }),
	s({ trig = "Nu", snippetType = "autosnippet" }, t("\\Nu"), { condition = in_mathzone }),
	s({ trig = "xi", snippetType = "autosnippet" }, t("\\xi"), { condition = in_mathzone }),
	s({ trig = "Xi", snippetType = "autosnippet" }, t("\\Xi"), { condition = in_mathzone }),
	s({ trig = "omicron", snippetType = "autosnippet" }, t("\\omicron"), { condition = in_mathzone }),
	s({ trig = "Omicron", snippetType = "autosnippet" }, t("\\Omicron"), { condition = in_mathzone }),
	s({ trig = "pi", snippetType = "autosnippet" }, t("\\pi"), { condition = in_mathzone }),
	s({ trig = "Pi", snippetType = "autosnippet" }, t("\\Pi"), { condition = in_mathzone }),
	s({ trig = "rho", snippetType = "autosnippet" }, t("\\rho"), { condition = in_mathzone }),
	s({ trig = "Rho", snippetType = "autosnippet" }, t("\\Rho"), { condition = in_mathzone }),
	s({ trig = "sigma", snippetType = "autosnippet" }, t("\\sigma"), { condition = in_mathzone }),
	s({ trig = "Sigma", snippetType = "autosnippet" }, t("\\Sigma"), { condition = in_mathzone }),
	s({ trig = "tau", snippetType = "autosnippet" }, t("\\tau"), { condition = in_mathzone }),
	s({ trig = "Tau", snippetType = "autosnippet" }, t("\\Tau"), { condition = in_mathzone }),
	s({ trig = "upsilon", snippetType = "autosnippet" }, t("\\upsilon"), { condition = in_mathzone }),
	s({ trig = "Upsilon", snippetType = "autosnippet" }, t("\\Upsilon"), { condition = in_mathzone }),
	s({ trig = "phi", snippetType = "autosnippet" }, t("\\phi"), { condition = in_mathzone }),
	s({ trig = "Phi", snippetType = "autosnippet" }, t("\\Phi"), { condition = in_mathzone }),
	s({ trig = "chi", snippetType = "autosnippet" }, t("\\chi"), { condition = in_mathzone }),
	s({ trig = "Chi", snippetType = "autosnippet" }, t("\\Chi"), { condition = in_mathzone }),
	s({ trig = "psi", snippetType = "autosnippet" }, t("\\psi"), { condition = in_mathzone }),
	s({ trig = "Psi", snippetType = "autosnippet" }, t("\\Psi"), { condition = in_mathzone }),
	s({ trig = "nab", snippetType = "autosnippet" }, t("\\nabla"), { condition = in_mathzone }),
	s({ trig = "xk", snippetType = "autosnippet" }, t("x_k"), { condition = in_mathzone }),

	-- Functions

	s({ trig = "sin", snippetType = "autosnippet" }, t("\\sin"), { condition = in_mathzone }),
	s({ trig = "cos", snippetType = "autosnippet" }, t("\\cos"), { condition = in_mathzone }),
	s({ trig = "arccos", snippetType = "autosnippet" }, t("\\arccos"), { condition = in_mathzone }),
	s({ trig = "ln", snippetType = "autosnippet" }, t("\\ln"), { condition = in_mathzone }),
	s({ trig = "log", snippetType = "autosnippet" }, t("\\log"), { condition = in_mathzone }),
	s({ trig = "exp", snippetType = "autosnippet" }, t("\\exp"), { condition = in_mathzone }),

	-- Matrices

	s({ trig = "...", snippetType = "autosnippet" }, t("\\ldots"), { condition = in_mathzone }),
	s({ trig = "vdots", snippetType = "autosnippet" }, t("\\vdots"), { condition = in_mathzone }),
	s({ trig = "ddots", snippetType = "autosnippet" }, t("\\ddots"), { condition = in_mathzone }),
	s({ trig = "cdots", snippetType = "autosnippet" }, t("\\cdots"), { condition = in_mathzone }),

	-- Latex

	s("beg", {
		t("\\begin{"),
		i(1),
		t("}"),
		t({ "", "\t" }),
		i(0),
		t({ "", "\\end{" }),
		rep(1),
		t("}"),
	}),
	s("enum", {
		t("\\begin{enumerate}"),
		t({ "", "\t\\item " }),
		i(0),
		t({ "", "\\end{enumerate}" }),
	}),
	s("item", {
		t("\\begin{itemize}"),
		t({ "", "\t\\item " }),
		i(0),
		t({ "", "\\end{itemize}" }),
	}),
	s({ trig = "ali", condition = in_mathzone, snippetType = "autosnippet" }, {
		t("\\begin{aligned}"),
		t({ "", "\t\\item " }),
		i(0),
		t({ "", "\\end{aligned}" }),
	}),

	-- Maths

	s({ trig = "=>", snippetType = "autosnippet" }, t("\\implies"), { condition = in_mathzone }),
	s({ trig = "=<", snippetType = "autosnippet" }, t("\\impliedby"), { condition = in_mathzone }),
	s({ trig = "iff", snippetType = "autosnippet" }, t("\\iff"), { condition = in_mathzone }),
	s({ trig = "och", snippetType = "autosnippet" }, t("&"), { condition = in_mathzone }),
	s({ trig = "new", snippetType = "autosnippet" }, t("\\\\"), { condition = in_mathzone }),
	s({ trig = "!=", snippetType = "autosnippet" }, t("\\neq"), { condition = in_mathzone }),
	s({ trig = "qd", snippetType = "autosnippet" }, t("\\quad"), { condition = in_mathzone }),
	s({ trig = "ooo", snippetType = "autosnippet" }, t("\\infty"), { condition = in_mathzone }),
	s({ trig = "<=", snippetType = "autosnippet" }, t("\\le"), { condition = in_mathzone }),
	s({ trig = ">=", snippetType = "autosnippet" }, t("\\ge"), { condition = in_mathzone }),
	s({ trig = "xx", snippetType = "autosnippet" }, t("\\times"), { condition = in_mathzone }),
	s({ trig = ",,", snippetType = "autosnippet" }, t("\\cdot"), { condition = in_mathzone }),
	s(
		{ trig = "<->", snippetType = "autosnippet" },
		t("\\leftrightarrow"),
		{ condition = in_mathzone, priority = 1000 } -- Higher priority for <->
	),
	s(
		{ trig = "->", snippetType = "autosnippet" },
		t("\\to"),
		{ condition = in_mathzone, priority = 500 } -- Lower priority for ->
	),
	s({ trig = "->", snippetType = "autosnippet" }, t("\\rightarrow"), { condition = in_mathzone }),
	s({ trig = "invs", snippetType = "autosnippet" }, t("^{-1}"), { condition = in_mathzone }),
	s({ trig = "cc", snippetType = "autosnippet" }, t("\\subset"), { condition = in_mathzone }),
	s({ trig = "cceq", snippetType = "autosnippet" }, t("\\subseteq"), { condition = in_mathzone }),
	s({ trig = "notin", snippetType = "autosnippet" }, t("\\not\\in"), { condition = in_mathzone }),
	s({ trig = "inn", snippetType = "autosnippet" }, t("\\in"), { condition = in_mathzone }),
	s({ trig = "hbr", snippetType = "autosnippet" }, t("\\hslash"), { condition = in_mathzone }),
	s({ trig = "top", snippetType = "autosnippet" }, t("\\top"), { condition = in_mathzone }),
	s({ trig = "bot", snippetType = "autosnippet" }, t("\\bot"), { condition = in_mathzone }),

	-- Math more complex

	s(
		{ trig = "lrp", condition = in_mathzone, snippetType = "autosnippet" },
		fmta("\\left( <> \\right)", {
			i(1),
		})
	),
	s(
		{ trig = "lrs", condition = in_mathzone, snippetType = "autosnippet" },
		fmta("\\left[ <> \\right]", {
			i(1),
		})
	),

	s(
		{ trig = "lrb", condition = in_mathzone, snippetType = "autosnippet" },
		fmta("\\left{ <> \\right}", {
			i(1),
		})
	),
	s(
		{ trig = "lra", condition = in_mathzone, snippetType = "autosnippet" },
		fmt("\\left< {} \\right>", {
			i(1),
		}, { delimiters = "{}" })
	),

	s(
		{ trig = "abs", condition = in_mathzone, snippetType = "autosnippet" },
		fmt("\\left| {} \\right|", {
			i(1),
		}, { delimiters = "{}" })
	),
	s(
		{ trig = "norm", condition = in_mathzone, snippetType = "autosnippet" },
		fmt("\\left\\| {} \\right\\|", {
			i(1),
		}, { delimiters = "{}" })
	),
	s(
		{ trig = "dotp", condition = in_mathzone, snippetType = "autosnippet" },
		fmt("\\left< {}, {} \\right>", {
			i(1),
			i(2),
		}, { delimiters = "{}" })
	),
	s(
		{ trig = "sum", condition = in_mathzone, snippetType = "autosnippet" },
		fmta("\\sum_{<>}^{<>}", {
			i(1, "k=0"),
			i(2, "\\infty"),
		})
	),
	s(
		{ trig = "lim", condition = in_mathzone, snippetType = "autosnippet" },
		fmta("\\lim_{<> \\to <>}", {
			i(1, "n"),
			i(2, "\\infty"),
		})
	),
	s(
		{ trig = "part", condition = in_mathzone, snippetType = "autosnippet" },
		fmta("\\frac{\\partial <>}{\\partial <>}", {
			i(1, "y"),
			i(2, "x"),
		})
	),
	s(
		{ trig = "2part", condition = in_mathzone, snippetType = "autosnippet" },
		fmta("\\frac{\\partial^2 <>}{\\partial <>^2}", { i(1, "y"), i(2, "x") })
	),
	s(
		{
			trig = "d([a-zA-Z])d([a-zA-Z])",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			condition = in_mathzone,
		},
		fmta("\\frac{\\partial <>", {
			f(function(_, snip)
				return snip.captures[1] .. "}{\\partial " .. snip.captures[2] .. "}"
			end),
		})
	),
	s(
		{
			trig = "2d([a-zA-Z])d([a-zA-Z])",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			condition = in_mathzone,
		},
		fmta("\\frac{\\partial^2 <>", {
			f(function(_, snip)
				return snip.captures[1] .. "}{\\partial " .. snip.captures[2] .. "^2}"
			end),
		})
	),
	s(
		{
			trig = "dd([a-zA-Z])",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			condition = in_mathzone,
		},
		fmta("\\frac{\\partial}{\\partial <>}", {
			f(function(_, snip)
				return snip.captures[1]
			end),
		})
	),
	s({ trig = "int", condition = in_mathzone, snippetType = "autosnippet" }, fmta("\\int <>", { i(1) })),
	s(
		{ trig = "dint", condition = in_mathzone, snippetType = "autosnippet" },
		fmta("\\int_{<>}^{<>}<>", { i(1, "0"), i(2, "\\infty"), i(3) })
	),

	-- Integral variable

	s(
		{
			trig = "([a-zA-Z]var)",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			condition = in_mathzone,
		},
		fmta("<>", {
			f(function(_, snip)
				return "\\,d" .. snip.captures[1]:sub(1, 1)
			end),
		})
	),

	s({ trig = "sq", condition = in_mathzone, snippetType = "autosnippet" }, fmta("\\sqrt{<>}", { i(1) })),

	-- Matrix

	s({ trig = "pmat", condition = in_mathzone, snippetType = "autosnippet" }, {
		t("\\begin{pmatrix}"),
		t({ "", "\t" }),
		i(1),
		t({ "", "\\end{pmatrix}" }),
		i(0),
	}),

	-- Math operations

	s(
		{ trig = "//", snippetType = "autosnippet", condition = in_mathzone },
		fmt("\\frac{<>}{<>}", {
			i(1),
			i(2),
		}, { delimiters = "<>" })
	),
	s({
		trig = "^.*%)%/", -- Matches any string ending with ')/'
		regTrig = true,
		condition = in_mathzone,
		snippetType = "autosnippet",
	}, {
		f(function(_, snip)
			-- Retrieve the matched string and strip the trailing '/'
			local stripped = snip.trigger:sub(1, -2)
			local depth = 0
			local i = #stripped

			-- Loop to find the balanced opening parenthesis
			while i > 0 do
				local char = stripped:sub(i, i)
				if char == ")" then
					depth = depth + 1
				elseif char == "(" then
					depth = depth - 1
				end
				if depth == 0 then
					break
				end
				i = i - 1
			end

			-- Construct the fraction
			local before = stripped:sub(1, i - 1)
			local inside = stripped:sub(i + 1, -2)
			return before .. "\\frac{" .. inside .. "}"
		end, {}),
		t("{"),
		i(1),
		t("}"),
	}),

	-- Setup math env

	s(
		{ trig = "mk", snippetType = "autosnippet" },
		fmta("$<>$", {
			i(1),
		})
	),
	s(
		{ trig = "dm", snippetType = "autosnippet" },
		fmt("$$\n<>\n$$", {
			i(1),
		}, { delimiters = "<>" })
	),
	s(
		{
			trig = "([%a%)%]%}%|])(%d)",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			description = "auto_subscript",
			condition = in_mathzone,
		},
		fmta("<>", {
			f(function(_, snip)
				return snip.captures[1] .. "_{" .. snip.captures[2] .. "}"
			end),
		})
	),
	s(
		{
			trig = "([%a%)%]%}%|])(__)",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			description = "subscript",
		},
		fmta("<>_{<>}", {
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(1),
		})
	),
	s(
		{
			trig = "([%a%)%]%}%|])(TT)",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			description = "to the power of",
			condition = in_mathzone,
		},
		fmta("<>^{T}", {
			f(function(_, snip)
				return snip.captures[1]
			end),
		})
	),
	s(
		{
			trig = "([%a%)%]%}%|])(td)",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			description = "to the power of",
		},
		fmta("<>^{<>}", {
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(1),
		})
	),
	s({ trig = "td", condition = in_mathzone, snippetType = "autosnippet" }, fmta("^{<>}", { i(1) })),
	s(
		{
			trig = "([a-zA-Z]hat)",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			condition = in_mathzone,
		},
		fmta("<>", {
			f(function(_, snip)
				return "\\hat{" .. snip.captures[1]:sub(1, 1) .. "}"
			end),
		})
	),
	s(
		{
			trig = "([^i])sts",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			condition = in_mathzone,
		},
		fmta("<>_\\text{<>}", {
			f(function(_, snip)
				-- Capturing and including the preceding character
				return snip.captures[1] or ""
			end),
			i(1),
		})
	),

	s(
		{
			trig = "([a-zA-Z]mcal)",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			condition = in_mathzone,
		},
		fmta("<>", {
			f(function(_, snip)
				return "\\mathcal{" .. snip.captures[1]:sub(1, 1) .. "}"
			end),
		})
	),
	s(
		{
			trig = "([a-zA-Z]bar)",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			condition = in_mathzone,
		},
		fmta("<>", {
			f(function(_, snip)
				return "\\overline{" .. snip.captures[1]:sub(1, 1) .. "}"
			end),
		})
	),
	s({
		trig = "mdinit",
		snippetType = "autosnippet",
	}, {
		t({ "---", "" }),
		t({ "header-includes: |", "" }),
		t({ "\t\\usepackage{tcolorbox}", "" }),
		t({ "\t\\usepackage{xifthen}", "" }),
		t({ "\t\\usepackage{pdfpages}", "" }),
		t({ "\t\\usepackage{transparent}", "" }),
		t({ "\t\\usepackage{import}", "" }),
		t({ "---", "" }),
		t({ "", "" }),
		t("\\newcommand{\\incfig}[1]{\\def\\svgwidth{\\columnwidth}\\import{./figures/}{#1.pdf_tex}}"),
	}),
	s({
		trig = "!note",
		snippetType = "autosnippet",
	}, {
		t({ "\\begin{center}", "" }),
		t({ "\t\\begin{tcolorbox}[colback=blue!5!white,colframe=blue!75!black,title=Note]", "" }),
		t("\t"),
		i(1),
		t({ "", "\t\\end{tcolorbox}", "" }),
		t({ "\\end{center}", "" }),
		i(0),
	}),
	s({
		trig = "!the",
		snippetType = "autosnippet",
	}, {
		t({ "\\begin{center}", "" }),
		t({ "\t\\begin{tcolorbox}[colback=red!5!white,colframe=red!75!black,title=Theorem]", "" }),
		t("\t"),
		i(1),
		t({ "", "\t\\end{tcolorbox}", "" }),
		t({ "\\end{center}", "" }),
		i(0),
	}),
	s({
		trig = "!def",
		snippetType = "autosnippet",
	}, {
		t({ "\\begin{center}", "" }),
		t({ "\t\\begin{tcolorbox}[colback=yellow!5!white,colframe=yellow!75!black,title=Definition]", "" }),
		t("\t"),
		i(1),
		t({ "", "\t\\end{tcolorbox}", "" }),
		t({ "\\end{center}", "" }),
		i(0),
	}),

	s({ trig = "txt", condition = in_mathzone, snippetType = "autosnippet" }, fmta("\\text{<>}", { i(1) })),
}
