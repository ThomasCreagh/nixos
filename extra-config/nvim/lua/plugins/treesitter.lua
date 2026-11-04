-- Highlight, edit, and navigate code
return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master', -- the default branch (main) is a rewrite that this config doesn't support
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'nix', 'query', 'vim', 'vimdoc' },
        auto_install = true,
        highlight = {
            enable = true,
            -- Ruby depends on vim's regex highlighting for indent rules
            additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
    },
}
