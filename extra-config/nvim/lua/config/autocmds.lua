-- See `:help lua-guide-autocommands`

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Wrap prose at word boundaries instead of mid-word',
    group = vim.api.nvim_create_augroup('prose-wrap', { clear = true }),
    pattern = { 'markdown', 'text', 'gitcommit', 'rst', 'tex', 'plaintex', 'typst' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})
