local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.expand_conditions")

local rec_ls
rec_ls = function()
    return sn(0, {
        c(1, {
            -- important!! Having the sn(...) as the first choice will cause infinite recursion.
            t({ "" }),
            -- The same dynamicNode as in the snippet (also note: self reference).
            sn(0, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
        }),
    });
end

local function column_count_from_string(descr)
    return #(descr:gsub("[^clm]", ""))
end
-- function for the dynamicNode.
local tab = function(args, snip)
    local cols = column_count_from_string(args[1][1])
    -- snip.rows will not be set by default, so handle that case.
    -- it's also the value set by the functions called from dynamic_node_external_update().
    if not snip.rows then
        snip.rows = 1
    end
    local nodes = {}
    -- keep track of which insert-index we're at.
    local ins_indx = 1
    for j = 1, snip.rows do
        -- use restoreNode to not lose content when updating.
        table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
        ins_indx = ins_indx + 1
        for k = 2, cols do
            table.insert(nodes, t " & ")
            table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
            ins_indx = ins_indx + 1
        end
        table.insert(nodes, t { "\\\\", "" })
    end
    -- fix last node.
    nodes[#nodes] = t ""
    return sn(nil, nodes)
end

ls.add_snippets("tex", {
    s("ls", {
        t({ "\\begin{itemize}",
            "\t\\item " }), i(1), d(2, rec_ls, {}),
        t({ "", "\\end{itemize}" }), i(0)
    }),
    s("bgn", fmt([[
		 \begin{<>}
           <>
		 \end{<>}]],
        { i(1, "env"), i(0, "%content"), rep(1) },
        { delimiters = "<>" }
    )
    ),
    s("frc", fmt([[
    \frac{<>}{<>}
          ]],
        { i(1, "zähler"), i(0, "nenner") },
        { delimiters = "<>" }
    )
    ),
    s("trig", sn(1, {
        t("basically just text "),
        i(1, "And an insertNode.")
    })),
    s({ trig = ";a", snippetType = "autosnippet" },
        {
            t("\\alpha"),
        }
    ),
    s(";m", fmt([[
    \mathrm{<>}
      ]],
        { i(0, "Upright Math") },
        { delimiters = "<>" }
    )
    ),
    s(";s", fmt([[
    \si{\<>}
      ]],
        { i(0, "Unit") },
        { delimiters = "<>" }
    )
    ),
    s(";r", fmt([[
    \autoref{<>}
      ]],
        { i(0, "type:name") },
        { delimiters = "<>" }
    )
    ),
    s(";i", fmt([[
    \textit{<>}
      ]],
        { i(0, "Italic Text") },
        { delimiters = "<>" }
    )
    ),

    s(";b", fmt([[
    \mathbf{<>}
      ]],
        { i(0, "Bold Math") },
        { delimiters = "<>" }
    )
    ),
    s(";s", fmt([[
    \si{<>}
      ]],
        { i(0, "Source") },
        { delimiters = "<>" }
    )
    ),
    s("ct", fmt([[
    \cite{<>}
      ]],
        { i(0, "Source") },
        { delimiters = "<>" }
    )
    ),

    s("tss", fmt([[
    \textsuperscript{<>}
      ]],
        { i(0, "Source") },
        { delimiters = "<>" }
    )
    ),

    s("fg", fmt([[
         \begin{figure}[htbp]
         \centering
         \includegraphics[width=<>\textwidth]{<>}
         \caption{<>}
         \label{fig:<>}
         \end{figure}
          ]],
        { i(1, ""), i(2, "file"), i(3, "caption"), i(0, "label") },
        { delimiters = "<>" }
    )
    ),

    s("tbb", fmt([[
         \begin{{table}}[htbp]
         \centering
         \caption{{{}}}
         \label{{tab:{}}}
         \begin{{tabular}}{{{}}}
         \toprule
          {}
         \bottomrule
         \end{{tabular}}
         \end{{table}}
        ]], { i(1, "caption"), i(2, "label"), i(3, "lcc"), d(4, tab, { 3 }, {
        user_args = {
            -- Pass the functions used to manually update the dynamicNode as user args.
            -- The n-th of these functions will be called by dynamic_node_external_update(n).
            -- These functions are pretty simple, there's probably some cool stuff one could do
            -- with `ui.input`
            function(snip) snip.rows = snip.rows + 1 end,
            -- don't drop below one.
            function(snip) snip.rows = math.max(snip.rows - 1, 1) end
        }
    }) })),
    s("sec", fmt([[
    \FloatBarrier
     \hypertarget{<>}{%
     \section{<>}\label{<>}}]],
        { i(1, "sec"), rep(1), rep(1) },
        { delimiters = "<>" }
    )
    ),
    key = "tex",
})
