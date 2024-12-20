return {
  "allaman/emoji.nvim",
  version = "1.0.0", -- optionally pin to a tag
  ft = "markdown", -- adjust to your needs
  dependencies = {
    -- util for handling paths
    "nvim-lua/plenary.nvim",
    -- optional for nvim-cmp integration
    "hrsh7th/nvim-cmp",
  },
  opts = {
    -- default is false
    enable_cmp_integration = true,
  },
  config = function(_, opts)
    require("emoji").setup(opts)
    -- optional for fzf integration
    local ts = require('fzf').load_extension 'emoji'
    vim.keymap.set('n', ';se', ts.emoji, { desc = 'Search Emoji' })
  end,
}
