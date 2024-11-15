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
        languages = { "python", "jupyter", "bash", "html" },
      },
      completion = {
        enabled = true,
      },
      codeRunner = {
        enabled = false,
        default_method = 'molten',
        ft_runners = {
          python = "molten",
        }
      },
    })
    require("quarto").activate()
  end,
  keys = {
    {"<leader>qr", ":lua require('quarto.runner').run_cell()<cr>", desc = "Run Cell"},
    {"<leader>qp", ":lua require('quarto.preview').toggle_preview<cr>", desc = "Quarto Preview"},
    {"<leader>qa", ":lua require('quarto.runner).run_above()<cr>", desc = "Run Cell and Above"},
    {"<leader>qA", ":lua require('quarto.runner).run_all()<cr>", desc = "Run All Cells"},
    {"<leader>ql", ":lua require('quarto.runner).run_line()<cr>", desc = "Run Line"},
    {"<leader>qv", ":lua require('quarto.runner).run_range()<cr>", desc = "Run Visual Range"},
    {"<leader>RA", ":lua require('quarto.runner').run_all(true)<cr>", desc = "Run All Cells of All Languages"},
    {
      "<C-p>",
      ":lua require('toggleterm.terminal').Terminal:new({ cmd = 'ipython', hidden = true, direction = 'float' }):toggle()<cr>",
      desc = "Toggle quarto ipython terminal"
    }
  },
  opts = {
    ft = { "quarto", "markdown" },
  },
}
