return {
  "3rd/image.nvim",
  opts = {
    backend = "tmux",
    integrations = {},
    max_width = 100,
    max_height = 12,
    max_height_window_percentage = math.huge, -- needed for good experience
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = {
      "cmp_menu",
      "cmp_docs",
      "",
    },
  },
  config = function()
  end
}
