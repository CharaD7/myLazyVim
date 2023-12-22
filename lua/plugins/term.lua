return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    direction = "float",
    float_opts = {
      border = "curved",
    },
    highlights = {
      FloatBorder = {
        guifg = "#F28FAD"
      },
    },
    shell = "/usr/bin/tmux",
    winbar = {
      enabled = true,
      name_formatter = function(term) --  term: Terminal
        return term.name
      end,
    },
  },
}
