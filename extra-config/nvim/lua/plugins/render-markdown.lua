-- Renders Markdown in the buffer: headings, lists, checkboxes, tables and code blocks.
-- The line under the cursor shows the raw text so it can still be edited.
return {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    keys = {
        { '<leader>tm', '<cmd>RenderMarkdown toggle<CR>', desc = '[T]oggle [M]arkdown rendering' },
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
}
