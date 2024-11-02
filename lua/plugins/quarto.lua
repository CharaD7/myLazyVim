return {
  "quarto-dev/quarto-nvim",
  dependencies = {
    "jmbuhr/otter.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local runner = require("quarto.runner")
    vim.keymap.set("n", "<leader>qr", runner.run_cell, { desc = "Run Cell", silent = true })
    vim.keymap.set("n", "<leader>qa", runner.run_above, { desc = "Run Cell and Above", silent = true })
    vim.keymap.set("n", "<leader>qA", runner.run_all, { desc = "Run All Cells", silent = true })
    vim.keymap.set("n", "<leader>ql", runner.run_line, { desc = "Run Line", silent = true })
    vim.keymap.set("n", "<leader>qv", runner.run_range, { desc = "Run Visual Range", silent = true })
    vim.keymap.set("n", "<leader>RA", function() runner.run_all(true) end, { desc = "Run All Cells of All Languages", silent = true })
  end,
}
