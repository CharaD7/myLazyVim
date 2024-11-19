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

  { -- scrollbar
    'dstein64/nvim-scrollview',
    enabled = true,
    opts = {
      current_only = true,
    },
  },

  { -- show tree of symbols in the current file
    'hedyhli/outline.nvim',
    cmd = 'Outline',
    keys = {
      { '<leader>lo', ':Outline<cr>', desc = 'symbols outline' },
    },
    opts = {
      providers = {
        priority = { 'markdown', 'lsp',  'norg' },
        -- Configuration for each provider (3rd party providers are supported)
        lsp = {
          -- Lsp client names to ignore
          blacklist_clients = {},
        },
        markdown = {
          -- List of supported ft's to use the markdown provider
          filetypes = { 'markdown', 'quarto' },
        },
      },
    },
  },

  -- notify
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
    }
  },

}
