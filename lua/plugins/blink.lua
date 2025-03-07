return {
  'saghen/blink.cmp',
  depedencies = {
    -- 'hrsh7th/nvim-cmp',
    'rafamadriz/friendly-snippets',
    'codeium.nvim',
    'saghen/blink.compat',
  },
  opts = {
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      compat = { "codeium" },
      providers = {
        codeium = {
          kind = "Codeium",
          score_offset = 100,
          async = true,
        },
      },
    },
    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },
    -- opts_extend = { "sources.default" },
    completion = {
      menu = { border = 'single' },
      documentation = { window = { border = 'single' } },
    },
    signature = { window = { border = 'single' } },
  },
}
