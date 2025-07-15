return {
  'benlubas/molten-nvim',
  enabled = true,
  build = ':UpdateRemotePlugins',
  init = function()
    vim.g.molten_image_provider = 'image.nvim'
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = false
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true
    vim.g.molten_terminal = "tmux"
  end,
  keys = {
    { "<leader>me", ":MoltenEvaluateOperator<cr>", desc = "Evaluate Operator" },
    { "<leader>mo", ":noautocmd MoltenEnterOutput<cr>", desc = "Open Output Window" },
    { "<leader>mr", ":MoltenReevaluateCell<cr>", desc = "Re-evaluate Cell" },
    { "<leader>mv", ":MoltenEvaluateVisual<cr>gv", mode = "v", desc = "Evaluate Visual Selection" },
    { "<leader>mh", ":MoltenHideOutput<cr>", desc = "Close Output Window" },
    { "<leader>md", ":MoltenDelete<cr>", desc = "Delete Molten Cell" },
    -- The below works for html outputs
    { "<leader>mb", ":MoltenOpenInBrowser<cr>", desc = "Open Output in Browser" },
    { '<leader>mi', ':MoltenInit<cr>', desc = 'Molten Init' },
  },
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      max_width = 10,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs" }
    },
  }
}
