return {
  { 'sindrets/diffview.nvim', cmd = "DiffviewOpen" },

  {
    'lewis6991/gitsigns.nvim',
    event = "BufReadPost",
    config = function()
      require('gitsigns').setup {}
    end,
  },

  {
    'akinsho/git-conflict.nvim',
    keys = {
      { '<leader>gco', ':GitConflictChooseOurs<cr>' },
      { '<leader>gct', ':GitConflictChooseTheirs<cr>' },
      { '<leader>gcb', ':GitConflictChooseBoth<cr>' },
      { '<leader>gc0', ':GitConflictChooseNone<cr>' },
      { ']x', ':GitConflictNextConflict<cr>' },
      { '[x', ':GitConflictPrevConflict<cr>' },
    },
    config = function()
      require('git-conflict').setup {
        default_mappings = true,
        disable_diagnostics = false,
      }
    end,
  },
  {
    'f-person/git-blame.nvim',
    event = "BufReadPost",
    config = function()
      require('gitblame').setup {
        enabled = true,
      }
      vim.g.gitblame_display_virtual_text = 1
      vim.g.gitblame_enabled = 1
    end,
  },
}
