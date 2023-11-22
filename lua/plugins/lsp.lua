return {
  -- Mason
  "williamboman/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "stylua",
      "luacheck",
      "shfmt",
      "tailwindcss-language-server",
      "typescript-language-server",
      "css-lsp",
      "shellcheck",
      "ruff_lsp",
      "lua_ls",
      "rust_analyzer",
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
