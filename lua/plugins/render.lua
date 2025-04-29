return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    completion = {
      blink = { enabled = true },
      lsp = { enabled = true },
    },
    signature = {
      enabled = true,
      highlight = 'RenderMarkdownSign',
    },
    indent = {
      enabled = true,
      highlight = 'RenderMarkdownIndent',
    },
    link = {
      enabled = true,
      highlight = 'RenderMarkdownLink',
    },
    pipe_table = { enabled = true },
    quote = {
      enabled = true,
      highlight = {
        'RenderMarkdownQuote1',
        'RenderMarkdownQuote2',
        'RenderMarkdownQuote3',
        'RenderMarkdownQuote4',
        'RenderMarkdownQuote5',
        'RenderMarkdownQuote6',
      },
    },
    checkbox = { enabled = true },
    bullet = { enabled = true },
    dash = { enabled = true },
    code = { enabled = true },
    paragraph = { enabled = true },
    heading = { enabled = true },
  },
}
