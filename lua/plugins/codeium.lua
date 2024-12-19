return {
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("codeium").setup({
      enable_chat = true,
      key_bindings = {
        accept = "<cr>",
        next = "<Tab>",
        prev = "<S-Tab>",
      }
    })
  end
}
