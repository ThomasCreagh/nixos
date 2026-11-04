-- Plugin-specific keymaps live with their plugin in lua/plugins/

-- Clear search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostics
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode. May not work in all terminal emulators/tmux; <C-\><C-n> always does.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Move between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Undo tree. Moving the cursor in its window jumps the buffer to that undo state.
vim.keymap.set('n', '<leader>tu', '<cmd>Undotree<CR>', { desc = '[T]oggle [U]ndo tree' })

-- Explorer
vim.keymap.set('n', '<leader>et', ':Neotree toggle<CR>', { desc = '[E]xplorer [T]oggle' })
vim.keymap.set('n', '<leader>ef', ':Neotree focus<CR>', { desc = '[E]xplorer [F]ocus' })

-- User interface
vim.keymap.set('n', '<leader>ut', ':Telescope colorscheme<CR>', { desc = '[U]ser Interface [T]heme' })
vim.keymap.set('n', '<leader>ud', ':colorscheme tokyonight-night<CR>', { desc = '[U]ser Interface [D]ark theme' })
vim.keymap.set('n', '<leader>ul', ':colorscheme tokyonight-day<CR>', { desc = '[U]ser Interface [L]ight theme' })
