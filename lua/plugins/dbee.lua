return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = "Dbee",
  config = function()
    require("dbee").setup({})
  end,
}
