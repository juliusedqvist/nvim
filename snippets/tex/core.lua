local ls = require("luasnip")
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta
local i = ls.insert_node
local t = ls.text_node
local rep = require("luasnip.extras").rep

return {
	s(
		{ trig = "sec" },
		fmta(
			[[
		\section<>{<>}
		<>
		]],
			{
				i(1),
				i(2),
				i(0),
			}
		)
	),
	s(
		{ trig = "ssec" },
		fmta(
			[[
		\subsection<>{<>}
		<>
		]],
			{
				i(1),
				i(2),
				i(0),
			}
		)
	),
	s(
		{ trig = "img" },
		fmta(
			[[
\begin{figure}[ht!]
    \centering
    \includegraphics[width=0.5\linewidth]{<>}
    \caption{<>}
    \label{fig:fig<>}
\end{figure}


        ]],
			{
				i(1, "image_path"),
				i(2, "caption"),
				i(3, "label"),
			}
		)
	),
	s(
		{ trig = "beg" },
		fmta(
			[[
\begin{<>}
    <>
\end{<>}


        ]],
			{
				i(1),
				i(2),
				rep(1),
			}
		)
	),
}
