return {
    'folke/tokyonight.nvim',
    priority = 1000, -- load before all other start plugins
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('tokyonight').setup {
            style = 'night',
            light_style = 'day',
            styles = {
                comments = { italic = false },
            },
        }

        -- Nvim sets 'background' from the terminal's colours at startup, so
        -- start with the matching variant. Changing 'background' later
        -- reloads tokyonight, which swaps between night and day (it would
        -- otherwise fall back to moon for dark).
        require('tokyonight').styles = { light = 'day', dark = 'night' }
        vim.cmd.colorscheme(vim.o.background == 'light' and 'tokyonight-day' or 'tokyonight-night')

        -- Ghostty follows the system theme. Re-ask it for its background
        -- colour (OSC 11) so Nvim's built-in handler updates 'background'
        -- when the theme changes while Nvim is open.
        local function query_bg()
            if vim.g.follow_terminal_bg ~= false then
                vim.api.nvim_ui_send '\027]11;?\007'
            end
        end
        vim.api.nvim_create_autocmd('FocusGained', {
            group = vim.api.nvim_create_augroup('follow-terminal-bg', { clear = true }),
            callback = query_bg,
        })
        vim.fn.timer_start(5000, query_bg, { ['repeat'] = -1 })
    end,
}
