return {
  "numToStr/Comment.nvim",
  keys = {
    { "gc", mode = { "n", "v" }, desc = "Comment toggle line" },
    { "gb", mode = { "n", "v" }, desc = "Comment toggle block" },
  },
  config = function()
    require("Comment").setup()
  end,
}
