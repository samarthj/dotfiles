local function load(use)

    -- Themes
    use {
        'ayu-theme/ayu-vim',
        disable = true
    }
    use {
        'romgrk/doom-one.vim',
        disable = true
    }
    use {
        'joshdick/onedark.vim',
        disable = true
    }
    use {
        'morhetz/gruvbox',
        disable = true
    }
    use {
        'npxbr/gruvbox.nvim',
        disable = true,
        requires = { 'rktjmp/lush.nvim' }
    }
    use {
        'RRethy/nvim-base16',
        config = function()
            vim.g.base16_theme = 'base16-atelier-lakeside'
            require('base16-colorscheme').setup('atelier-lakeside')
        end
    }

    -- Icons
    use 'nvim-tree/nvim-web-devicons'

    -- Tools
    use {
        'tpope/vim-surround',
        config = function()
            local char2nr = vim.fn.char2nr
            vim.g['surround_' .. char2nr('r')] = "{'\r'}"
            vim.g['surround_' .. char2nr('j')] = "{/* \r */}"
            vim.g['surround_' .. char2nr('c')] = "/* \r */"
        end
    }
    -- use {
    --     'b3nj5m1n/kommentary',
    --     config = function()
    --         require('kommentary.config').configure_language('default', {
    --             prefer_single_line_comments = true
    --         })
    --     end
    -- }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-tree/nvim-web-devicons' },
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' }
        },
        config = function()
            require('cfg.telescope')
        end
    }

    use { 'wellle/targets.vim' } -- More useful text objects (e.g. function arguments)

    use { 'tpope/vim-fugitive' } -- Git helper

    use {
        'airblade/vim-gitgutter',
        config = function()
            local u = require 'utils'.u
            local gutter = u '2595'
            vim.g.gitgutter_sign_added = gutter
            vim.g.gitgutter_sign_modified = gutter
            vim.g.gitgutter_sign_removed = gutter
        end
    }

    if vim.fn.executable('xkb-switch') > 0 or vim.fn.executable('g3kb-switch') > 0 then
        use {
            'lyokha/vim-xkbswitch',
            config = function()
                vim.g.XkbSwitchEnabled = 1
                if vim.env['XDG_CURRENT_DESKTOP'] == 'GNOME' then
                    vim.g.XkbSwitchLib = '/usr/local/lib/libg3kbswitch.so'
                end
            end
        }
    end

    use { 'chrisbra/Colorizer' }

    use { 'mattn/emmet-vim' }

    -- Missing languages in tree-sitter
    use { 'neovimhaskell/haskell-vim' }
    use { 'editorconfig/editorconfig-vim' }
    use { 'elixir-editors/vim-elixir' }
    use { 'chr4/nginx.vim' }
    use { 'tpope/vim-markdown' }
    use { 'adimit/prolog.vim' }

    if vim.fn.has('unix') > 0 and (vim.fn.executable('g++') > 0 or vim.fn.executable('clang++') > 0) then
        use {
            'nvim-treesitter/nvim-treesitter',
            -- requires = {
            --     'nvim-treesitter/playground',
            --     -- 'nvim-treesitter/nvim-treesitter-refactor',
            -- },
            run = function()
                local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
                ts_update()
            end,
            config = function()
                require('cfg.tree_sitter')
            end
        }
    end

    use {
        'RRethy/vim-illuminate',
        -- disable = true,
        config = function()
            local utils = require('utils')
            utils.highlight {
                'illuminatedWord',
                bg = '#303A49'
            }
        end
    }

    -- use {
    --     'SirVer/ultisnips',
    --     disable = true,
    --     config = function()
    --         vim.g.UltiSnipsExpandTrigger = '<F10>'
    --         vim.g.UltiSnipsJumpForwardTrigger = '<C-J>'
    --         vim.g.UltiSnipsJumpBackwardTrigger = '<C-K>'
    --     end
    -- }
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    use {
        'hrsh7th/nvim-cmp',
        -- after = {
        --     'hrsh7th/cmp-nvim-lsp',
        --     'hrsh7th/cmp-buffer',
        --     'hrsh7th/cmp-path',
        --     'hrsh7th/cmp-cmdline',
        --     'L3MON4D3/LuaSnip',
        --     'saadparwaiz1/cmp_luasnip'
        --     -- 'SirVer/ultisnips',
        --     -- 'honza/vim-snippets',
        --     -- 'neovim/nvim-lspconfig'
        --     -- 'nvim-tree/nvim-web-devicons',
        --     -- opt = true
        -- },
        config = function()
            require('cfg.cmp')
        end
    }

    use {
        'neovim/nvim-lspconfig',
        -- requires = {
        --     -- 'hrsh7th/nvim-cmp',
        --     'hrsh7th/cmp-nvim-lsp'
        -- },
        -- after = { 'cmp-nvim-lsp' },
        ensure_required = true,
        config = function()
            require('cfg.lsp')
        end
    }

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
            -- opt = true
        },
        config = function()
            local utils = require('utils')
            local u = utils.u
            utils.highlight { 'NvimTreeFolderName', 'Title' }
            utils.highlight { 'NvimTreeFolderIcon', 'Title' }
            vim.g.nvim_tree_icons = {
                folder = {
                    default = u 'f07b',
                    open = u 'f07c',
                    symlink = u 'f0c1'
                }
            }
            vim.g.nvim_tree_auto_close = 1
            vim.g.nvim_tree_indent_markers = 0
            vim.g.nvim_tree_quit_on_open = 1
            vim.g.nvim_tree_disable_netrw = 0
            vim.g.nvim_tree_hijack_netrw = 1
        end
    }

    use {
        'sbdchd/neoformat',
        config = function()
            for _, ft in ipairs { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } do
                vim.g['neoformat_enabled_' .. ft] = {}
            end
            vim.g.neoformat_try_formatprg = 1
            vim.g.neoformat_run_all_formatters = 0
        end
    }

    -- YAML tree-sitter parser
    use {
        "cuducos/yaml.nvim",
        ft = { "yaml" }, -- optional
        requires = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim" -- optional
        },
    }

    -- Helpers
    use {
        'sudormrfbin/cheatsheet.nvim',
        requires = {
            { 'nvim-telescope/telescope.nvim' },
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
        }
    }
end

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        print('`packer.nvim` is not installed, installing...')
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()
local packer = require('packer')
return packer.startup({ function()
    -- print('`packer` startup...')
    packer.use 'wbthomason/packer.nvim'
    -- print('`plugins` load...')
    load(packer.use)

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    -- print('`packer` sync...', packer_bootstrap)
    if packer_bootstrap then
        packer.sync()
    else
        vim.cmd('autocmd BufWritePost plugins.lua :PackerCompile')
    end
    -- vim.cmd([[
    --         augroup packer_user_config
    --             autocmd!
    --             autocmd BufWritePost plugins.lua source plugins.lua | PackerCompile
    --         augroup end
    -- ]])
end,
    config = {
        display = {
            non_interactive = true,
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end
        },
        -- log = { level = 'debug' },
        git = {
            clone_timeout = 240
        },
        profile = {
            enable = true,
            threshold = 1 -- the amount in ms that a plugin's load time must be over for it to be included in the profile
        },
        autoremove = true
    }
})
-- return function()
-- local fn = vim.fn
-- local packer_install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
-- local not_installed = fn.empty(fn.glob(packer_install_path)) > 0

-- if not_installed then
--     print('`packer.nvim` is not installed, installing...')
--     local repo = 'https://github.com/wbthomason/packer.nvim'
--     ---@diagnostic disable-next-line: lowercase-global
--     packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', repo, packer_install_path })
--     -- vim.cmd('PackerSync')
--     --     vim.cmd(sprintf('!git clone %s %s', repo, packer_install_path))
-- end

-- vim.cmd('PackerSync')

-- require('packer').startup {
--     load,
--     config = {
--         git = {
--             clone_timeout = 240
--         }
--     },
--     -- vim.cmd('PackerSync')
-- }
-- vim.cmd('autocmd BufWritePost plugins.lua :PackerCompile')

-- if not_installed then
--     vim.cmd('PackerSync')
-- end
-- end



-- https://github.com/wbthomason/packer.nvim#specifying-plugins
-- use {
--   'myusername/example',        -- The plugin location string
--   -- The following keys are all optional
--   disable = boolean,           -- Mark a plugin as inactive
--   as = string,                 -- Specifies an alias under which to install the plugin
--   installer = function,        -- Specifies custom installer. See "custom installers" below.
--   updater = function,          -- Specifies custom updater. See "custom installers" below.
--   after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
--   rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
--   opt = boolean,               -- Manually marks a plugin as optional.
--   bufread = boolean,           -- Manually specifying if a plugin needs BufRead after being loaded
--   branch = string,             -- Specifies a git branch to use
--   tag = string,                -- Specifies a git tag to use. Supports '*' for "latest tag"
--   commit = string,             -- Specifies a git commit to use
--   lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
--   run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
--   requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
--   rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
--   config = string or function, -- Specifies code to run after this plugin is loaded.
--   -- The setup key implies opt = true
--   setup = string or function,  -- Specifies code to run before this plugin is loaded.
--   -- The following keys all imply lazy-loading and imply opt = true
--   cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
--   ft = string or list,         -- Specifies filetypes which load this plugin.
--   keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
--   event = string or list,      -- Specifies autocommand events which load this plugin.
--   fn = string or list          -- Specifies functions which load this plugin.
--   cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
--   module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
--                                -- with one of these module names, the plugin will be loaded.
--   module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When requiring a string which matches one of these patterns, the plugin will be loaded.
-- }
