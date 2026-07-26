return {
  "quarto-dev/quarto-nvim",
  ft = { "quarto", "markdown" },
  dependencies = {
    "jmbuhr/otter.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    debug = false,
    closePreviewOnExit = true,
    lspFeatures = {
      enabled = true,
      chunks = "curly",
      languages = { "python", "bash", "html" },
      diagnostics = {
        enabled = true,
        triggers = { "BufWritePost" },
      },
      completion = {
        enabled = true,
      },
    },
    codeRunner = {
      enabled = true,
      default_method = "slime",
      ft_runners = {},
      never_run = { 'yaml' },
    },
  },
}
