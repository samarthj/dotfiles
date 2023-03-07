-- LuaFormatter off
local enabled = {
    'bash',
    'cmake',
    'comment',
    'css',
    'diff',
    'dockerfile',
    'fish',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'go',
    'gomod',
    'gosum',
    'gowork',
    'graphql',
    'haskell',
    'hcl',
    'help',
    'hjson',
    'html',
    'http',
    'java',
    'javascript',
    'jq',
    'jsdoc',
    'json',
    'json5',
    'jsonc',
    'jsonnet',
    'lua',
    -- 'luap',
    'make',
    'markdown',
    'markdown_inline',
    'mermaid',
    'meson',
    'ninja',
    'nix',
    'passwd',
    'perl',
    'php',
    'proto',
    'python',
    'ql',
    'query', -- Tree-sitter query language
    'regex',
    'ron',
    'rst',
    'rust',
    'scheme',
    'scss',
    'sql',
    'terraform',
    'thrift',
    'toml',
    'typescript',
    'vim',
    'vue',
    'yaml',
    'zig',
}
-- LuaFormatter on
require('nvim-treesitter.configs').setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = enabled,

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- ignore_install = disabled,

    indent = {
        enable = true
    },
    highlight = {
        enable = true,
        -- disable = disabled,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = enabled,
    },
    -- playground = {
    --     enable = true,
    --     disable = disabled,
    --     updatetime = 25,
    --     persist_queries = false
    -- },
    -- incremental_selection = {
    --     enable = true,
    --     keymaps = {
    --         init_selection = '<Leader>)',
    --         node_incremental = ')',
    --         node_decremental = '('
    --     }
    -- }
}
