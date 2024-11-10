return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  dependencies = { "3rd/image.nvim" },
  build = ":UpdateRemotePlugins",
  init = function()
    local molten = require("molten")
    molten.setup({
      auto_open_output = false,
      wrap_output = true,
      virt_lines_off_by_1 = true,
      image_provider = "image.nvim",
      output_win_max_height = 20,
    })
  end,
  keys = {
    { "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "Evaluate Operator" },
    { "<leader>mo", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Open Output Window" },
    { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Re-evaluate Cell" },
    { "<leader>mv", "<cmd>MoltenEvaluateVisual<cr>gv", desc = "Evaluate Visual Selection" },
    { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "Close Output Window" },
    { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Delete Molten Cell" },
    -- The below works for html outputs
    { "<leader>mb", "<cmd>MoltenOpenInBrowser<cr>", desc = "Open Output in Browser" },
  },
}
