-- Autocompletion
return {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
        {
            'L3MON4D3/LuaSnip',
            version = '2.*',
            build = (function()
                -- Needed for regex support in snippets
                if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
            opts = {},
        },
        'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
        -- See `:h blink-cmp-config-keymap`
        keymap = {
            preset = 'super-tab',
        },

        appearance = {
            nerd_font_variant = 'mono',
        },

        completion = {
            -- <c-space> shows the documentation. Set auto_show to show it after a delay.
            documentation = { auto_show = false, auto_show_delay_ms = 500 },
        },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'lazydev' },
            providers = {
                lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
            },
        },

        snippets = { preset = 'luasnip' },

        -- See `:h blink-cmp-config-fuzzy`
        fuzzy = { implementation = 'lua' },

        signature = { enabled = true },
    },
}
