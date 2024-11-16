return {
  "saghen/blink.cmp",
  version = not vim.g.lazyvim_blink_main and "*",
  build = vim.g.lazyvim_blink_main and "cargo build --release",
  opts_extend = {
    "sources.completion.enabled_providers",
    "sources.compat",
  },
  lazy = false,
  dependencies = {
    "rafamadriz/friendly-snippets",
    "dmitmel/cmp-digraphs",
    -- add blink.compat to dependencies
    { "saghen/blink.compat", opts = {} },
  },
  event = "InsertEnter",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    highlight = {
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release, assuming themes add support
      use_nvim_cmp_as_default = true,
    },
    -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
    windows = {
      autocomplete = {
        -- draw = "reversed",
        winblend = vim.o.pumblend,
        border = 'rounded',
        scrollbar = true,
        auto_show = true,
      },
      documentation = {
        auto_show = true,
      },
      ghost_text = {
        enabled = vim.g.ai_cmp,
      },
    },

    -- experimental auto-brackets support
    accept = { auto_brackets = { enabled = true } },

    -- experimental signature help support
    -- trigger = { signature_help = { enabled = true } }
    sources = {
      -- adding any nvim-cmp sources here will enable them
      -- with blink.compat
      compat = {},
      completion = {
        -- remember to enable your providers here
        enabled_providers = { "lsp", "path", "snippets", "buffer" },
      },
      documentation = {
        border = 'padded',
        scrollbar = true,
      },
      providers = {
        -- create provider
        digraphs = {
          name = 'digraphs', -- IMPORTANT: use the same name as you would for nvim-cmp
          module = 'blink.compat.source',

          -- all blink.cmp source config options work as normal:
          score_offset = -3,

          opts = {
            -- this table is passed directly to the proxied completion source
            -- as the `option` field in nvim-cmp's source config

            -- this is an option from cmp-digraphs
            cache_digraphs_on_start = true,
          }
        }
      },
    },

    keymap = {
      preset = "default",
      ["<Tab>"] = {
        LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
        "fallback",
      },
    },
  },
  ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
  config = function(_, opts)
    -- lspconfig
    local lspconfig = require('lspconfig')
    for server, config in pairs(opts.server or {}) do
      config.capabilities = require('blink-cmp').get_lsp_capabilities(config.capabilities)
      lspconfig[server].setup(config)
    end

    -- setup compat sources
    opts.kind_icons = LazyVim.config.icons.kinds
    local enabled = opts.sources.completion.enabled_providers
    for _, source in ipairs(opts.sources.compat or {}) do
      opts.sources.providers[source] = vim.tbl_deep_extend(
        "force",
        { name = source, module = "blink.compat.source" },
        opts.sources.providers[source] or {}
      )
      if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
        table.insert(enabled, source)
      end
    end
    require("blink.cmp").setup(opts)
  end,
}
