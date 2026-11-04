-- See `:help option-list`

-- Must be set before plugins load, otherwise the wrong leader is used
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.o.number = true
-- vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false -- already shown in the statusline

-- Sync clipboard with the OS. Scheduled because it can increase startup time.
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

-- Indent with 4 spaces by default. Filetypes that need tabs (e.g. make, go) override this in their ftplugin
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.undofile = true

-- Case-insensitive searching unless \C or a capital letter is in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

-- How whitespace characters are displayed
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split' -- preview substitutions as you type
vim.o.cursorline = true
vim.o.scrolloff = 10

-- Ask to save instead of failing on operations like `:q` with unsaved changes
vim.o.confirm = true

-- Extra filetypes. .vert and .frag are already detected as GLSL.
vim.filetype.add { extension = { frac = 'glsl' } }
