return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      mode = "buffers",
      numbers = function(opts)
        return string.format("%s", opts.raise(opts.ordinal))
      end,
      indicator = {
        style = "underline",
      },
      diagnostics_update_in_insert = true,
      color_icons = true,
      sort_by = "insert_at_end",
      show_tab_indicators = true,
      separator_style = "slope",
      always_show_bufferline = true,
      truncate_names = false,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true,
        },
      },
    },
  },
  init = function()
    local numbers =
      { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "12", "13", "14", "15", "16", "17", "18", "19", "20" }
    for _, num in ipairs(numbers) do
      vim.keymap.set("n", "<leader>" .. num, "<cmd>BufferLineGoToBuffer " .. num .. "<CR>")
    end
    vim.g.transparent_groups = vim.list_extend(
      vim.g.transparent_groups or {},
      vim.tbl_map(function(v)
        return v.hl_group
      end, vim.tbl_values(require("bufferline.config").highlights))
    )
  end,
}
