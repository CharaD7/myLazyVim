return {
  'HallerPatrick/py_lsp.nvim',
  config = function()
    require('py_lsp').setup({
      default_venv_name = "venv", -- For local venv
      host_python = "venv/bin/python3",
    })
  end
}

