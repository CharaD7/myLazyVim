return {
  'xiyaowong/transparent.nvim',
  lazy = false,
  opts = {
    groups = {
      'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
      'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
      'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
      'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
      'EndOfBuffer',
    },
    extra_groups = {'NeoTreeNormal', 'NeoTreeNormalNC'},
  },
  config = function()
    local transparent = require('transparent')
    transparent.clear_prefix('BufferLine')
    transparent.clear_prefix('NeoTree')
  end
}
