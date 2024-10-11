local numbers =
{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "12", "13", "14", "15", "16", "17", "18", "19", "20" }
for _, num in pairs(numbers) do
	vim.keymap.set("n", "<leader>" .. num, "<cmd>BufferLineGoToBuffer " .. num .. "<CR>")
end

local bufferline = require "bufferline"

return {
  "akinsho/bufferline.nvim",
  version = "*",
  lazy = true,
  dependencies = "nvim-tree/nvim-web-devicons",
  bufferline.setup({
    options = {
      mode = "buffers", -- tabs or buffers
      numbers = function(opts)
        return string.format("%s", opts.raise(opts.ordinal))
      end,
      indicator = {
        style = "underline",
      },
      diagnostics_update_in_insert = true,
      color_icons = true,
      sort_by = "insert_at_end", -- 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
      show_tab_indicators = true,
      separator_style = "slope",
      always_show_bufferline = true,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true -- use a "true" to enable the default, or set your own character
        }
      },
    },
  })
}
