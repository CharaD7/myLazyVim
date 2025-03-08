return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    opts = {
      backend = "tmux",
      processor = "magick_rock", -- or "magick_cli"
      integrations = {
        markdown = {
          filetypes = { "markdown", "vimwiki", "quarto" }, -- markdown extensions (ie. quarto) can go here
        },
      },
      max_width = 100, -- or nil for size
      max_height = 20, -- or nil for no size
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
    },
  }
}
