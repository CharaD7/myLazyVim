return {
  'HallerPatrick/py_lsp.nvim',
  config = function()
    require('py_lsp').setup({
      default_venv_name = ".venv", -- For local venv
      host_python = ".venv/bin/python3",
      language_server = {"pyright", "pylsp"},
      source_strategies = {"system"},
      capabilities = capabilities,
      on_attach = on_attach,
      pylsp_plugins = {
        autopep8 = { enabled = true },
        pyls_mypy = { enabled = true },
        pyls_isort = { enabled = true },
        flake8 = { enabled = true, executable = ".venv/bin/flake8" },
      },
    })
  end
}

