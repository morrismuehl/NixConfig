-- Bootstrap lazy.nvim as a package managerplpluginplugplugplug
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
-- Set up Leader key to space (required by lazy)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Give a table of plugins to lazy
require('lazy').setup({
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-omni',
    'hrsh7th/cmp-cmdline',
    {
        'hrsh7th/nvim-cmp',
        -- local cmp = require'cmp',
        dependencies = {
            { "kdheepak/cmp-latex-symbols" },
        },
        -- sources      = {
        --     { name = "latex_symbols" }
        -- },
    },
    --luasnip snippets
    'saadparwaiz1/cmp_luasnip',
    {
        'l3mon4d3/luasnip',
        version = "v2.*",
        build = "make install_jsregexp"
        -- after = 'nvim-cmp',
        -- tag = "v<CurrentMajor>.*",
        -- rocks = 'jsregexp',
        -- config = function() require('snippets') end,
    },


    -- my plugins here
    -- vim surround
    'tpope/vim-surround',
    'tpope/vim-fugitive',
    -- vimtex for latex
    {
        'lervag/vimtex',
        version = "2.15",  --Set to 2.15 because newest version does not work with nvim 0.9.4
        init = function()
            vim.g.vimtex_context_pdf_viewer = 1
            vim.g.vimtex_view_method = "zathura_simple"
            vim.g.vimtex_view_general_viewer = "zathura"
            vim.g.vimtex_view_forward_search_on_start = true
            vim.g.vimtex_fold_enabled = true
            vim.g.vimtex_fold_manual = true
            vim.g.vimtex_fold_bib_enabled = true
            vim.g.vimtex_indent_enabled = true
            vim.g.vimtex_quickfix_mode = 0
            vim.cmd [[let g:vimtex_quickfix_ignore_filters = [
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
        end
    },

    -- themes (Unused themes are commented out to reduce bloat)
    --
    -- 'folke/tokyonight.nvim',
    { "catppuccin/nvim" },
    -- {
    --     'projekt0n/github-nvim-theme',
    --     config = function()
    --         require('github-theme').setup({
    --             -- ...
    --         })
    --     end
    -- },
    {
        'miikanissi/modus-themes.nvim',
        -- priority = 1000,
        config = function()
            require("modus-themes").setup({
                variant = "tinted",
            })
        end
    },

    {
        'Mofiqul/adwaita.nvim',
        lazy = false,
        priority = 999,
        config = function()
            vim.o.background = 'light'
            vim.g.adwaita_disable_cursorline = false
            vim.g.adwaita_transparent = true
            vim.cmd('colorscheme adwaita')
        end
    },
    --undotree
    'mbbill/undotree',
    --  'godlygeek/tabular,

    --vim pandoc
    -- 'vim-pandoc/vim-pandoc' -- didn',t work properly anyways
    -- 'vim-pandoc/vim-pandoc-syntax',
    -- markdown
    -- Note Taking Plugin using markdown
    --
    -- {
    --     'jakewvincent/mkdnflow.nvim',
    --     config = function()
    --         require('mkdnflow').setup({
    --             mappings = {
    --                 MkdnEnter = { { 'i', 'n', 'v' }, '<CR>' }
    --             }
    --             -- Config goes here; leave blank for defaults
    --         })
    --     end
    -- },
    -- {
    --     "tadmccorkle/markdown.nvim",
    --     'event = "VeryLazy"',
    --     opts = {
    --     inline_surround = {
    --          strong = {
    --             key = "z",
    --             txt = "**"
    --          }
    --     }
    --     },
    -- },
    -- {
    --     'kiran94/edit-markdown-table.nvim',
    --     config = true,
    --     dependencies = { "nvim-treesitter/nvim-treesitter" },
    --     cmd = "EditMarkdownTable",
    -- },
    {
        'NFrid/markdown-togglecheck',
        dependencies = 'NFrid/treesitter-utils',
    },


    --statusline written in lua
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
            -- 'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        init = function() vim.g.barbar_auto_setup = false end,
        opts = {
            -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
            -- animation = true,
            -- insert_at_start = true,
            -- …etc.
        },
        version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    --Autopair stuff like () "" ''
    --
    {
        "windwp/nvim-autopairs",
        -- dependencies = "nvim-cmp",
        -- after = "nvim-cmp", --after is no longer needed in lazy.nvim let's... ignore this for now
        config = function()
            require("nvim-autopairs").setup({
                disable_filetype = { "TelescopePrompt", "vim" },
                ignored_next_char = [=[[%w%%%'%[%"%.]]=]
            })
            require('autopairconfig')
        end
    },

    --Super Awesome Telescope Plugin by TJ
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    --Nvim Tree

    {
        'nvim-tree/nvim-tree.lua',
        version = "*",
        lazy = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require("nvim-tree").setup {}
        end
    },

    -- Easy Align →  very useful for e.g. LaTeX tables
    'junegunn/vim-easy-align',
    -- Startup Screen
    {
        "startup-nvim/startup.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("startup").setup()
        end,
    },
    -- Treesitter  Syntax support
    -- Further configuration is performed in init.lua
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },
    'HiPhish/rainbow-delimiters.nvim',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'ggandor/leap.nvim',
    'tpope/vim-repeat',
    --Comment Stuff
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },

    -- {
    --     'nvim-orgmode/orgmode',
    --     dependencies = {
    --         { 'nvim-treesitter/nvim-treesitter', lazy = true },
    --     },
    --
    --     -- event = 'VeryLazy',
    --     config = function()
    --         -- Load treesitter grammar for org
    --         require('orgmode').setup_ts_grammar()
    --
    --         -- Setup treesitter
    --         require('nvim-treesitter.configs').setup({
    --             highlight = {
    --                 enable = true,
    --                 additional_vim_regex_highlighting = { 'org' },
    --             },
    --             ensure_installed = { 'org' },
    --         })
    --
    --         -- Setup orgmode
    --         require('orgmode').setup({
    --             org_agenda_files = '~/orgfiles/**/*',
    --             org_default_notes_file = '~/orgfiles/refile.org',
    --         })
    --     end,
    -- },

    {
        "vhyrro/luarocks.nvim",
        priority = 1001, -- We'd like this plugin to load first out of the rest
        opts = {
            rocks = { "magick" },
            config = true, -- This automatically runs `require("luarocks-nvim").setup()`
        }
    },

    {
        "nvim-neorg/neorg",
        dependencies = { "luarocks.nvim" },
        lazy = false,
        version = "*",
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ["core.integrations.image"] = {},
                    ["core.latex.renderer"] = {},
                    ["core.export"] = {},
                    ["core.dirman"] = {
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                            default_workspace = "notes",
                        },
                    },
                },
            }
            vim.wo.foldlevel = 99
            vim.wo.conceallevel = 3
        end,
    },
    {
        "3rd/image.nvim",
        config = function()
            require("image").setup({})
                integrations = {
                    markdown = {
                        only_render_image_at_cursor = true, -- Useful for files with many images
                    },
                }
        end,
    },
})
