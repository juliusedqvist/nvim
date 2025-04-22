local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmta
local i = ls.insert_node

ls.add_snippets("tex", {
	ls.s(
		"texinit",
		fmt(
			[[
        \documentclass{article}
        \usepackage[final]{neurips_2023}
        \usepackage[utf8]{inputenc}
        \usepackage{amsmath}
        \usepackage{amssymb}
        \usepackage{graphicx}
        \graphicspath{ {./} }
        \usepackage[rightcaption]{sidecap}
        \usepackage{braket}
        \newcommand{\unit}[1]{\ensuremath{\, \mathrm{#1}}}
        \usepackage{esint}
        \usepackage{listings}
        \usepackage{gensymb}
        \usepackage{graphicx}
        \usepackage{wrapfig}
        \usepackage{geometry}
        \usepackage{parskip}
        \usepackage{placeins}
        \usepackage{tikz}
        \usepackage{minted}
        \usepackage{svg}
        \setminted[python]{breaklines, framesep=2mm, fontsize=\footnotesize, numbersep=5pt}
        \usetikzlibrary{decorations.pathmorphing}
        \geometry{
         a4paper,
         total={150mm,245mm},
         left=30mm,
         top=20mm,
        }
        \definecolor{codegreen}{rgb}{0,0.6,0}
        \definecolor{codegray}{rgb}{0.5,0.5,0.5}
        \definecolor{codepurple}{rgb}{0.58,0,0.82}
        \definecolor{backcolour}{rgb}{0.95,0.95,0.92}
        \usepackage{listings}
        \lstdefinestyle{mystyle}{
        backgroundcolor=\color{backcolour},
        commentstyle=\color{codegreen},
        keywordstyle=\color{magenta},
        numberstyle=\tiny\color{codegray},
        stringstyle=\color{codepurple},
        basicstyle=\footnotesize\ttfamily,
        breakatwhitespace=false,
        breaklines=true, captionpos=b,
        keepspaces=true, numbers=left,
        numbersep=5pt, showspaces=false,
        showstringspaces=false,
        showtabs=false, tabsize=2,
        }
        \lstset{style=mystyle}
        \usepackage[font=small, font=it]{caption}
        \usepackage{wrapfig}
        \usepackage[T1]{fontenc}
        \usepackage{hyperref}
        \usepackage{url}
        \usepackage{booktabs}
        \usepackage{amsfonts}
        \usepackage{nicefrac}
        \usepackage{microtype}
        \usepackage{xcolor}
        \usepackage{svg}
        \usepackage{tcolorbox}
        \tcbuselibrary{theorems}
        \newcommand*\diff{\mathop{}\!\mathrm{d}}
        \newtheorem{theorem}{Theorem}
        \newtheorem{corollary}{Corollary}[theorem]
        \title{<>}
        \author{Julius Edqvist}
        \date{\today}

        \begin{document}
        \maketitle

        <>

        \end{document}
        ]],
			{ i(1, "Your Title"), i(0) }
		)
	),
})
