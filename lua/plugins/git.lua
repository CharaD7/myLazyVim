-- git plugins

return {
  { 'sindrets/diffview.nvim' },

  {
    'lewis6991/gitsigns.nvim',
    enabled = false,
    config = function()
      require('gitsigns').setup {}
    end,
  },

  {
    'akinsho/git-conflict.nvim',
    init = function()
      require('git-conflict').setup {
        default_mappings = true,
        disable_diagnostics = false,
      }
    end,
    -- keys = {
    --   { '<leader>gco', ':GitConflictChooseOurs<cr>' },
    --   { '<leader>gct', ':GitConflictChooseTheirs<cr>' },
    --   { '<leader>gcb', ':GitConflictChooseBoth<cr>' },
    --   { '<leader>gc0', ':GitConflictChooseNone<cr>' },
    --   { ']x', ':GitConflictNextConflict<cr>' },
    --   { '[x', ':GitConflictPrevConflict<cr>' },
    -- },
  },
  {
    'f-person/git-blame.nvim',
    init = function()
      require('gitblame').setup {
        enabled = false,
      }
      vim.g.gitblame_display_virtual_text = 1
      vim.g.gitblame_enabled = 1
    end,
  },
}

