local nvim_lsp = require("nvim_lsp") -- composer global require php-stubs/wordpress-globals php-stubs/wordpress-stubs php-stubs/woocommerce-stubs php-stubs/acf-pro-stubs wpsyntex/polylang-stubs php-stubs/genesis-stubs php-stubs/wp-cli-stubs
local configs = require'lspconfig.configs'
local util = require'lspconfig.util'

vim.lsp.set_log_level("off")

require('lspkind').init()
require("lsp_lines").setup()

local on_attach = function(client, bufnr)
    vim.lsp.completion.enable(true, client, bufnr, {autotrigger=true})
    require'lsp_signature'.on_attach({
        bind = true,
        floating_window = true,
        handler_opts = {
            border = "rounded"
        }
    })

    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false
        })

        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = 'lsp_document_highlight',
        })

        vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd('CursorMoved', {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {'documentation', 'detail', 'additionalTextEdits',}
}

local coq = require("coq")
capabilities = coq.lsp_ensure_capabilities(capabilities)
nvim_lsp.intelephense.setup({
    settings = {
        intelephense = {
            stubs = {"bcmath", "bz2", "Core", "curl", "date", "dom", "fileinfo", "filter", "gd", "gettext", "hash", "iconv", "imap", "intl", "json", "libxml", "mbstring", "mcrypt", "mysql", "mysqli", "password", "pcntl", "pcre", "PDO", "pdo_mysql", "Phar", "readline", "regex", "session", "SimpleXML", "sockets", "sodium", "standard", "superglobals", "tokenizer", "xml", "xdebug", "xmlreader", "xmlwriter", "yaml", "zip", "zlib", "wordpress-stubs", "woocommerce-stubs", "acf-pro-stubs", "wordpress-globals", "wp-cli-stubs", "genesis-stubs", "polylang-stubs"},
            environment = {
                includePaths = {'/home/chara-tech/.composer/vendor/php-stubs/', '/home/chara-tech/.composer/vendor/wpsyntex/'}
            },
            files = {
                maxSize = 5000000;
            };
        };
    },
    capabilities = capabilities,
    on_attach = on_attach
})

local phpactor_capabilities = vim.lsp.protocol.make_client_capabilities()
phpactor_capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

phpactor_capabilities['textDocument']['codeAction'] = {}
nvim_lsp.phpactor.setup{
    capabilities = phpactor_capabilities,
    on_attach = on_attach
}

nvim_lsp.cssls.setup{
    capabilities = capabilities,
    on_attach = on_attach
}

nvim_lsp.html.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    filetpyes = {
      "html",
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx"
    }
}

nvim_lsp.bashls.setup{
    capabilities = capabilities,
    on_attach = on_attach
}

nvim_lsp.tailwindcss.setup{
    capabilities = capabilities,
    on_attach = on_attach
}
require("tailwind-tools").setup({
})
nvim_lsp.typos_lsp.setup{
    capabilities = capabilities,
    on_attach = on_attach
}
nvim_lsp.emmet_language_server.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
      html = {
        options = {
          -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
          ["bem.enabled"] = true,
        },
      },
    },
}
nvim_lsp.gitlab_ci_ls.setup{
    capabilities = capabilities,
    on_attach = on_attach
}
nvim_lsp.htmx.setup{
    capabilities = capabilities,
    on_attach = on_attach
}
nvim_lsp.jsonls.setup{}
nvim_lsp.lua_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
}
nvim_lsp.marksman.setup{
    capabilities = capabilities,
    on_attach = on_attach
}
nvim_lsp.ruby_lsp.setup{
    capabilities = capabilities,
    on_attach = on_attach
}
-- PYTHON
nvim_lsp.ruff_lsp.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  keys = {
    {
      "<leader>oi",
      function ()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            only = { "source.organizeImports"},
            diagnostics = {},
          }
        })
      end,
      desc = "Organize Imports",
    },
  },
}

require'py_lsp'.setup({
    language_server = "pylsp",
    source_strategies = {"poetry", "default", "system"},
    capabilities = capabilities,
    on_attach = on_attach,
    pylsp_plugins = {
        pyls_mypy = {
            enabled = true
        },
        rope_autoimport = {
            enabled = true
        },
        rope_completion = {
            enabled = true
        },
        pyls_isort = {
            enabled = true
        },
        pycodestyle = {
            enabled = false,
        },
        flake8 = {
            enabled = true,
            executable = venv_bin_detection("flake8"),
        }
    }
})

-- I want to be sure that there isn't any pycodestyle
local function filter_diagnostics(diagnostic)
  if diagnostic.source == 'pycodestyle'then
    return false
  end
  return true
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  function(_, result, ctx, config)
    result.diagnostics = vim.tbl_filter(filter_diagnostics, result.diagnostics)
    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
  end,
  {}
)

require'nvim-lightbulb'.update_lightbulb({
    sign = {
        enabled = true,
        priority = 10,
    },
    float = {
        enabled = false,
    },
    virtual_text = {
        enabled = true,
        hl_mode = "combine",
    },
    status_text = {
        enabled = true,
    }
})

vim.api.nvim_create_autocmd({'CursorHoldI', 'CursorHold'}, {
    pattern = '*',
    callback = function() require'nvim-lightbulb'.update_lightbulb() end,
})

local notify = require'notify'
vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({'ERROR', 'WARN', 'INFO', 'DEBUG',})[result.type]
    notify(result.message, lvl, {
        title = 'LSP | ' .. client.name,
        timeout = 10000,
        keep = function() return lvl == 'ERROR' or lvl == 'WARN' end,
    })
end

require('tw-values').setup({
    show_unknown_classes = true,
})


return {
  -- LSPconfig
  "neovim/nvim-lspconfig",
  dependencies = {
    "ms-jpq/coq_nvim",
    "ms-jpq/coq.thirdparty",
    {
      "ms-jpq/coq.artifacts",
      branch = "artifacts",
    },
    {
      "Mte90/coq_wordpress",
    }
  },
  init = function()
    vim.g.coq_settings = {
      auto_start = true, -- if you want to start COQ at startup
      opts = {
        keymaps = {
          jump_to_mark = '<S-h>',
          bigger_preview = '<S-k>'
        }
      }
    }
  end,
  clients = {
    lsp = { enabled = true },
    tree_sitter = { enabled = true, weight_adjust = 1.0 },
  },
  -- Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "shfmt",
        "eslint-lsp",
        "dart-debug-adapter",
        "csharp-language-server",
        "htmx-lsp",
        "rust-analyzer",
        "svelte-language-server",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "emmet-ls",
        "shellcheck",
        "vls",
        "clangd",
        "marksman",
        "gopls",
        "prettier",
      })
    end,
  },
  -- Mason lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()
    end,
  },
  -- Null-ls
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(opts.sources, nls.builtins.formatting.prettierd)
    end,
  },
  -- Color picker
  {
    "uga-rosa/ccc.nvim",
    opts = {},
    cmd = {
      "CccPick",
      "CccConvert",
      "CccHighlighterEnable",
      "CccHighlighterDisable",
      "CccHighlighterToggle",
    },
    keys = {
      { "<leader>zp", "<cmd>CccPick<cr>", desc = "Pick" },
      { "<leader>zc", "<cmd>CccConvert<cr>", desc = "Convert" },
      { "<leader>zh", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Highlighter" },
    },
  },
}
