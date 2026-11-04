-- Options come first: they set the leader key, which keymaps and plugins rely on.
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'

-- Built-in undo tree. Must come after lazy.nvim, which resets the runtimepath.
vim.cmd.packadd 'nvim.undotree'
