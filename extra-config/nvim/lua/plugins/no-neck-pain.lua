-- Centres Markdown files, with empty margins on both sides
return {
    'shortcuts/no-neck-pain.nvim',
    version = '*',
    ft = 'markdown',
    config = function()
        local nnp = require 'no-neck-pain'
        nnp.setup {
            width = 100, -- width of the text column
        }

        local function enabled()
            return _G.NoNeckPain.state ~= nil and _G.NoNeckPain.state.enabled
        end

        -- Turn margins on for Markdown and off again for anything else
        vim.api.nvim_create_autocmd('BufWinEnter', {
            group = vim.api.nvim_create_augroup('markdown-margins', { clear = true }),
            callback = function(args)
                if vim.bo[args.buf].buftype ~= '' then
                    return
                end
                local markdown = vim.bo[args.buf].filetype == 'markdown'
                vim.schedule(function()
                    if markdown and not enabled() then
                        nnp.enable()
                    elseif not markdown and enabled() then
                        nnp.disable()
                    end
                end)
            end,
        })
    end,
}
