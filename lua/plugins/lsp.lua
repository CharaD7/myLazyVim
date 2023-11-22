return {
  -- Mason
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
}
