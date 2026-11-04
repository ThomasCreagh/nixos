-- Detects tabstop and shiftwidth from a file's contents.
-- Installed but inactive: nothing calls its setup(). Adding `opts = {}` turns it on,
-- at which point files that already use tabs would keep them.
return { 'NMAC427/guess-indent.nvim' }
