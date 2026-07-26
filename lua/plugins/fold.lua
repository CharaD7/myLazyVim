return {
  "anuvyklack/pretty-fold.nvim",
  event = "BufReadPost",
  opts = {
    keep_indentation = false,
    fill_char = '━',
    matchup_patterns = {
      { '^%s*do$', 'end' },
      { '^%s*if', 'end' },
      { '^%s*for', 'end' },
      { 'function%s*%(', 'end' },
      { '{', '}' },
      { '%%(', ')' },
      { '%%[', ']' },
    },
  },
}
