return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  options = {
    numbers = "raise",
    indicator = {
      style = "underline",
    },
    diagnostics = "nvim_lsp",
    color_icons = true,
    show_tab_indicators = true,
    separator_style = "thin",
    always_show_bufferline = true,
  },
}
