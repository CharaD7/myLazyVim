return {
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("codeium").setup({
      enable_chat = true,
      key_bindings = {
        accept = "<cr>",
        next = "<Tab>",
        prev = "<S-Tab>",
      },
      opts = function ()
        LazyVim.cmp.actions.ai_accept = function()
          if require("codeium.virtual_text").get_current_completion_item() then
            LazyVim.create_undo()
            vim.api.nvim_input(require("codeium.virtual_text").accept())
            return true
          end
        end
      end
    })
  end
}
