vim.g.vimtex_context_pdf_viewer = 1
vim.g.vimtex_view_method = "zathura_simple"
vim.g.vimtex_view_general_viewer = "zathura"
vim.g.vimtex_view_forward_search_on_start = true
vim.g.vimtex_fold_enabled = true
vim.g.vimtex_fold_manual = true
vim.g.vimtex_fold_bib_enabled = true
vim.g.vimtex_indent_enabled = true
vim.g.vimtex_quickfix_mode = 0
vim.cmd[[let g:vimtex_quickfix_ignore_filters = [
\   'Underfull' ,
\   'Overfull',
\]
]]
-- vim.cmd[[let g:vimtex_compiler_latexmk = {
-- \            'options' : [
-- \                '-verbose',
-- \                '-file-line-error',
-- \                'synctex=1',
-- \                'interaction=nonstopmode',
-- \    ],
-- \}
-- ]]

-- vim.cmd[[let g:vimtex_compiler_latexmk_engines = {
--         -- \ 'xelatex'          : '-xelatex -output-driver="xdvipdfmx -z3"',
-- \}
-- ]]

vim.cmd [[set fillchars=fold:\ ]]

