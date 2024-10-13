require('plugins')
-- require('vimtex')
-- vim.g.vimtex_view_method = "zathura_simple"


require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { "c", "lua", "rust", "python", "latex", "json", "markdown", "fish", "org" },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    auto_install = false,
    -- List of parsers to ignore installing (for "all")
    ignore_install = { "javascript", "latex" },
    highlight = {
        enable = true,
        -- list of language that will be disabled
        disable = { "c", "rust", "latex" },
        additional_vim_regex_highlighting = { "markdown", "org" },
    },
}

vim.opt.completeopt = { "menu", "menuone", "noselect" }
local cmp = require 'cmp'
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    experimental = {
        view_entries = true,
        ghost_text = true,
    },
    window = {
        --completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-2),
        ['<C-f>'] = cmp.mapping.scroll_docs(2),
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'latex_symbols' },
        { name = 'path' },
        { name = 'omni' },
        { name = 'vimtex' },
        { name = 'luasnip' }, -- For luasnip users.
    }, {
        { name = 'buffer', keyword_length = 3 },
    })
})
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['texlab'].setup {
--     capabilities = capabilities
-- }

--LuaSnip
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

require("nvim-tree").setup()
require("leap").set_default_keymaps()

-- --TexLab LSP
-- require 'lspconfig'.texlab.setup {
--     on_attach = function()
--         vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
--         vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
--         vim.keymap.set("n", "<leader>di", "<cmd>Telescope diagnostics<CR>", { buffer = 0, desc = "Diagnostics" })
--         -- vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { buffer = 0, desc = "Autoformat" })
--         vim.keymap.set({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, { buffer = 0, desc = "Rename" })
--     end,
-- }

--
-- Bash Language Server
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'sh',
--   callback = function()
--     vim.lsp.start({
--       name = 'bash-language-server',
--       cmd = { 'bash-language-server', 'start' },
--     })
--   end,
-- })
--
require 'lspconfig'.bashls.setup({
    on_attach = function()
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
        vim.keymap.set("n", "<leader>di", "<cmd>Telescope diagnostics<CR>", { buffer = 0, desc = "Diagnostics" })
        vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end,
            { noremap = true, silent = true, buffer = 0, desc = "Autoformat" })
        vim.keymap.set({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, { buffer = 0, desc = "Rename" })
    end,
})
-- LuaU LSP
require 'lspconfig'.lua_ls.setup({
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = { 'vim', 'awesome', 'client', 'screen', 'scrlocker' }
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = function()
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
        vim.keymap.set("n", "<leader>di", "<cmd>Telescope diagnostics<CR>", { buffer = 0, desc = "Diagnostics" })
        vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end,
            { noremap = true, silent = true, buffer = 0, desc = "Autoformat" })
        vim.keymap.set({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, { buffer = 0, desc = "Rename" })
    end,
})

--Python3-LSP
require 'lspconfig'.pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                autopep8 = {
                    enabled = false
                },
                yapf = {
                    enabled = true
                },
                pycodestyle = {
                    ignore = { 'W391', 'W605', 'E262', 'E265', 'W504', 'W501', 'E501' },
                    maxLineLength = 100
                },
            },
        },
    },
    on_attach = function()
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0, desc = "Go to definition" })
        vim.keymap.set("n", "<leader>di", "<cmd>Telescope diagnostics<CR>", { buffer = 0 })
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { buffer = 0, desc = "Autoformat" })
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0, desc = "Rename" })
    end,
}

-- require 'lspconfig'.marksman.setup{
--
-- }

require('lualine').setup()
--require('settings.vim')
vim.cmd('source $HOME/.config/nvim/settings.vim')
require('mappings')
require('markdown')
--
require('lsdynamicnode')
-- vim.api.nvim_set_option("background", "light")
-- vim.cmd("colorscheme onehalf-lush")
-- vim.cmd("colorscheme catppuccin-mocha")
-- vim.cmd("colorscheme adwaita")
-- vim.cmd("colorscheme modus_operandi")
-- vim.cmd('colorscheme github_light')
-- vim.cmd('colorscheme gαithub_light')
-- vim.cmd [[colorscheme ayu-mirage]]
