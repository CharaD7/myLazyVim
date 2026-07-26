return {
  "ErichDonGubler/lsp_lines.nvim",
  event = "LspAttach",
  config = function()
    require("lsp_lines").setup()
    vim.diagnostic.config({
      virtual_text = false,
    })
  end,
}
