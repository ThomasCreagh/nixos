-- See `:help lua-guide-autocommands`

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Wrap prose at word boundaries and check spelling',
    group = vim.api.nvim_create_augroup('prose-wrap', { clear = true }),
    pattern = { 'markdown', 'text', 'gitcommit', 'rst', 'tex', 'plaintex', 'typst' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
    end,
})

-- Neovim asks what to do about a swap file left by a crashed session, and that question
-- turns into an error when a plugin like neo-tree opens the file. Swap files owned by a
-- running Neovim are already handled by Neovim's defaults.
vim.api.nvim_create_autocmd('SwapExists', {
    desc = 'Handle swap files left by a Neovim that is no longer running',
    group = vim.api.nvim_create_augroup('stale-swapfiles', { clear = true }),
    callback = function()
        local info = vim.fn.swapinfo(vim.v.swapname)
        if info.error or info.pid > 0 then
            return
        end

        if info.dirty == 0 then
            vim.v.swapchoice = 'd' -- no unsaved changes, so the swap file is safe to delete
        else
            vim.v.swapchoice = 'o'
            vim.notify(
                ('Opened read-only: a crashed session left unsaved changes in %s\nTo get them back, run :recover, check the file, :w, then delete that swap file'):format(
                    vim.v.swapname
                ),
                vim.log.levels.WARN
            )
        end
    end,
})
