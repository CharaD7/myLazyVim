return {
  "ms-jpq/coq_nvim",
  branch = "coq",
  dependencies = {
    {
      "ms-jpq/coq.thirdparty",
      branch = "3gp"
    },
    {
      "ms-jpq/coq.artifacts",
      branch = "artifacts",
    },
    {
      "Mte90/coq_wordpress",
    }
  },
  lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
  init = function()
    vim.g.coq_settings = {
        auto_start = true, -- if you want to start COQ at startup
    }
  end,
  clients = {
    lsp = { enabled = true },
    tree_sitter = { enabled = true, weight_adjust = 1.0 },
  },
}
