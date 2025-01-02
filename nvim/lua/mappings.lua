-- local lsd = require('lsdynamicnode')
-- Functional wrapper for mapping custom keybindings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

local ls = require("luasnip")
-- local cmp = require "cmp"
-- local types = require "luasnip.util.types"
--map("n", "<space>", "<Nop>", {silent=true})
--vim.g.mapleader = "\<Space>"
-- Single mappings
-- map("i", "jk", "<Esc>", { silent = true })
map("n", "<space>c", "<cmd>VimtexCountWords<CR>", { desc = "Count Words" })
map("n", "<space>b", "<cmd>VimtexCompile<CR>", { desc = "Build" })
map("n", "<space>p", "<cmd>VimtexView<CR>", { desc = "Preview" })
map("n", "<space>i", "<cmd>VimtexTocToggle<CR>", { desc = "Index" })
map("n", "<space>x", "<cmd>VimtexClean<CR>", { desc = "Kill Aux" })
map("n", "<space>l", "<cmd>VimtexErrors<CR>", { desc = "Log" })
map("n", "<space>w", "<cmd>w<CR>", { desc = "write" })
map("n", "<space>t", MiniTrailspace.trim, { desc = "Trail Whitespace" })
map("n", "<space><space>d", "<cmd>bd<CR>", { desc = "write" })
map("n", "<space>q", "<cmd>wqa<CR>", { desc = "quit" })
map("n", "<space>e", "<cmd>lua MiniFiles.open()<CR>", { desc = "Explorer" })
map("n", "<space>u", "<cmd>UndotreeToggle<CR>", { desc = "Undo Tree" })
map("n", "<space>f", "<cmd>Telescope find_files<CR>", { desc = "Telescope ff" })
map({ "n", "v" }, "<space>g", "<cmd>!gnuplot %:p<CR>", { desc = "GnuPlot", silent = true })
vim.keymap.set(
  "n",
  "<leader>rp",
  "<cmd>cd %:p:h<cr><cmd>!python %<cr>",
  {
    noremap = true,
    desc = "Run Python File",
    silent = true,
    expr = false
  }
)
map({ "n", "v" }, "<space>pp", "<cmd>cd %:p:h<cr><cmd>!python %<cr>", { noremap = true, desc = "Python", silent = true, expr=false })
map({ "n", "x" }, "ga", "<Plug>(EasyAlign)", { desc = "Align" })
map({ "n", "x" }, "<space>nc", "<cmd>/\v [&\\] <CR>", { desc = "Jump Between LateX table cells" }) -- Not optimal but works alright
map({ "n", "x" }, "<space>gaip", "<cmd>EasyAlign*|<CR>", { desc = "Align Mkdn Table" })
-- toggle checked / create checkbox if it doesn't exist
map('n', '<leader>n', require('markdown-togglecheck').toggle)
-- toggle checkbox (it doesn't remember toggle state and always creates [ ])
map('n', '<leader>nn', require('markdown-togglecheck').toggle_box)

--map({"n","v"}, "<space>g", "!l gnuplot", {desc="GnuPlot", silent=false})
--map("n", "<space>ms", "<cmd>Telescope find_files<CR>", {desc="Telescope ff"})
map("n", "<S-y>", "y$", { desc = "quit" })
--Horizontal line movements
map({ "n", "v" }, "<S-h>", "g^")
map({ "n", "v" }, "<S-l>", "g$")
--Move vertically even if its the same line
map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")
--Windows
map("n", "<M-h>", "<cmd>vertical resize +2<CR>", { silent = true, remap = true })
map("n", "<M-l>", "<cmd>vertical resize -2<CR>", { silent = true })
map("n", "<M-j>", "<cmd>resize -2<CR>", { silent = true })
map("n", "<M-k>", "<cmd>resize +2<CR>", { silent = true })
map("n", "<C-j>", "<C-w>j", { silent = true })
map("n", "<C-k>", "<C-w>k", { silent = true })
map("n", "<C-h>", "<C-w>h", { silent = true })
map("n", "<C-l>", "<C-w>l", { silent = true })
--Backspace and shift-Tab to move between buffers
map("n", "<BS>", "<cmd>bnext<CR>", { silent = true })
map("n", "<leader>bd", ":bp<bar>sp<bar>bn<bar>bd<CR>", { silent = true })
-- map("n", "<S-TAB>", "<cmd>bprevious<CR>", {silent=true}) -- I never used this and it interferes with org mode mappings
--Luasnip
map({ "n" }, "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/snippets.lua<CR>", { silent = true })
--map({"i", "s"}, "<C-k>", "<cmd>bprevious<CR>", {silent=true})
map({ "i", "s" }, "jk", function()
    if ls.jumpable(1) then
        ls.jump(1)
    end
end, { silent = true })
map({ "i", "s" }, "<C-l>", function()
    if ls.expandable(1) then
        ls.expand(1)
    end
end, { silent = true })
map({ "i", "s" }, "kj", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

