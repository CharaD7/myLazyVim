return {
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("codeium").setup({
      enable_cmp_source = true,
      key_bindings = {
        accept = "<cr>",
        next = "<Tab>",
        prev = "<S-Tab>",
      }
    })
  end
}
