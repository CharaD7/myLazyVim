local masonconfig = require("mason-lspconfig")

local servers = {
  "stylua",
  "luacheck",
  "shfmt",
  "tailwindcss-language-server",
  "typescript-language-server",
  "css-lsp",
  "shellcheck",
  "vls",
  "clangd",
  "marksman",
  "gopls",
}

masonconfig.setup_handlers {
  function (server_name)
    require("lspconfig")[server_name].setup {}
  end
}

return {
  -- Mason
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = servers,
    automatic_installation = true,
  }
}
