return {
  -- Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "luacheck",
        "spellcheck",
        "shfmt",
        "tailwindcss",
        "tsserver",
        "css_lsp",
        "lua_ls",
        "emmet_ls",
        "vls",
        "svelte",
        "teal_ls",
        "jsonls",
        "bashls",
        "clangd",
        "marksman",
        "eslint",
        "gopls",
        "html",
      })
    end,
  },

  -- Lspsaga
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { "n", "[f", ":Lspsaga lsp_finder<cr>", desc = "Finder" },
      { "n", "[a", ":Lspsaga code_action<cr>", desc = "Code Action" },
      { "n", "[g", ":Lspsaga open_floaterm lazygit<cr>", desc = "Lazygit" },
      { "n", "[o", ":Lspsaga hover_doc<cr>", desc = "Hover doc" },
      { "n", "[s", ":Lspsaga signature_help<cr>", desc = "Signature help" },
      { "n", ";t", ":Lspsaga outline<cr>", desc = "Outline" },
      { "n", "[n", ":Lspsaga rename<cr>", desc = "Rename" },
      { "n", "[N", ":Lspsaga rename ++project<cr>", desc = "Rename project" },
      { "n", "gd", ":Lspsaga preview_definition<cr>", desc = "Preview definition" },
      { "n", "<A-d>", ":Lspsaga term_toggle<cr>", desc = "Toggle term" },
      { "n", "<leader>cd", ":Lspsaga show_line_diagnostics<cr>", desc = "Show line diagnostics" },
      { "n", "<leader>cd", ":Lspsaga show_cursor_diagnostics<cr>", desc = "Show cursor diagnostics" },
      { "n", "[b", ":Lspsaga show_buf_diagnostics<cr>", desc = "Show buffer diagnostics" },
      { "n", "[e", ":Lspsaga diagnostic_jump_next<cr>", desc = "Diagnostic jump next" },
      { "n", "]e", ":Lspsaga diagnostic_jump_prev<cr>", desc = "Diagnostic jump previous" },
    },
  },
}
