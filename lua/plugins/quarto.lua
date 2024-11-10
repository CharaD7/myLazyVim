return {
  "quarto-dev/quarto-nvim",
  dependencies = {
    "jmbuhr/otter.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("quarto").setup({
      lspFeatures = {
        enabled = true,
        chunks = "curly",
        languages = { "r", "python", "jupyter" },
      },
      codeRunner = {
        enabled = false,
        default_method = 'molten',
        ft_runners = {
          python = "molten",
        }
      },
    })
  end,
  keys = {
    {"<leader>qr", ":lua require('quarto.runner').run_cell()<cr>", desc = "Run Cell"},
    {"<leader>qa", ":lua require('quarto.runner).run_above()<cr>", desc = "Run Cell and Above"},
    {"<leader>qA", ":lua require('quarto.runner).run_all()<cr>", desc = "Run All Cells"},
    {"<leader>ql", ":lua require('quarto.runner).run_line()<cr>", desc = "Run Line"},
    {"<leader>qv", ":lua require('quarto.runner).run_range()<cr>", desc = "Run Visual Range"},
    {"<leader>RA", ":lua require('quarto.runner').run_all(true)<cr>", desc = "Run All Cells of All Languages"},
    {
      "<C-p>",
      ":lua require('toggleterm.terminal').Terminal:new({ cmd = 'python3', hidden = true, direction = 'float' }):toggle()<cr>",
      desc = "Toggle quarto python terminal"
    }
  },
  opts = {
    ft = { "quarto", "markdown" },
  },
}
