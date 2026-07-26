return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    code_action = {
      show_server_name = true,
    },
    ui = {
      border = "rounded",
    },
    outline = {
      win_width = 20,
    },
  },
}
