-- Highlight, edit, and navigate code. See `:help treesitter`
local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'nix', 'query', 'vim', 'vimdoc' }

local function start(buf, lang)
    vim.treesitter.start(buf, lang)
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- this plugin doesn't support lazy loading
    build = ':TSUpdate',
    config = function()
        local treesitter = require 'nvim-treesitter'
        treesitter.install(parsers)

        vim.api.nvim_create_autocmd('FileType', {
            desc = 'Start treesitter, installing the parser first if needed',
            group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if not lang then
                    return
                end

                if vim.treesitter.language.add(lang) then
                    start(args.buf, lang)
                elseif vim.tbl_contains(treesitter.get_available(), lang) then
                    treesitter.install(lang):await(function()
                        if vim.api.nvim_buf_is_valid(args.buf) then
                            start(args.buf, lang)
                        end
                    end)
                end
            end,
        })
    end,
}
