return {
  -- Noice
  {
    "folke/noice.nvim",
    opts = function (_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information Available",
        },
        opts = { skip = true },
      })

      opts.presets.lsp_doc_border = true
      opts.presets.inc_rename = false
    end
  },

  -- Animate
  "echasnovski/mini.animate",
  event = "VeryLazy",
  opts = function (_, opts)
    opts.scroll = {
      enable = false,
    }
  end,
}
