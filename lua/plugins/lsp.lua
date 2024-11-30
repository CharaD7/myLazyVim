return {
  -- for lsp features in code cells / embedded code
  {
    'jmbuhr/otter.nvim',
    dev = false,
    dependencies = {
      {
        'neovim/nvim-lspconfig',
        'nvim-treesitter/nvim-treesitter',
      },
    },
    opts = {
      verbose = {
        no_code_found = false,
      }
    },
  },

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
    },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    { -- nice loading notifications
      -- PERF: but can slow down startup
      'j-hui/fidget.nvim',
      enabled = false,
      opts = {},
    },
    {
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
          },
        },
      },
      { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
      { -- optional completion source for require statements and module annotations
        'hrsh7th/nvim-cmp',
        opts = function(_, opts)
          opts.sources = opts.sources or {}
          table.insert(opts.sources, {
            name = 'lazydev',
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          })
        end,
      },
    },
    { 'folke/neoconf.nvim', opts = {}, enabled = false },
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
  config = function ()
    local nvim_lsp = require("nvim_lsp") -- composer global require php-stubs/wordpress-globals php-stubs/wordpress-stubs php-stubs/woocommerce-stubs php-stubs/acf-pro-stubs wpsyntex/polylang-stubs php-stubs/genesis-stubs php-stubs/wp-cli-stubs
    local configs = require('lspconfig.configs')
    local util = require('lspconfig.util')

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
    local lsp_flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 150,
    }

    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }

    capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
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
      on_attach = on_attach,
      flags = lsp_flags,
    }

    nvim_lsp.r_language_server.setup {
      capabilities = capabilities,
      flags = lsp_flags,
      settings = {
        r = {
          lsp = {
            rich_documentation = false,
          },
        },
      },
    }

    nvim_lsp.html.setup{
      capabilities = capabilities,
      on_attach = on_attach,
      flags = lsp_flags,
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
      flags = lsp_flags,
      filetypes = { 'sh', 'bash' },
      on_attach = on_attach
    }

    nvim_lsp.tailwindcss.setup{
      capabilities = capabilities,
      on_attach = on_attach
    }
    nvim_lsp.dotls.setup {
      capabilities = capabilities,
      flags = lsp_flags,
    }
    nvim_lsp.ts_ls.setup {
      capabilities = capabilities,
      flags = lsp_flags,
      filetypes = { 'mjs', 'js', 'javascript', 'typescript', 'ojs' },
    }
    nvim_lsp.yamlls.setup {
      capabilities = capabilities,
      flags = lsp_flags,
      settings = {
        yaml = {
          schemaStore = {
            enable = true,
            url = '',
          },
        },
      },
    }
    require("tailwind-tools").setup({
      capabilities = capabilities,
      flags = lsp_flags,
    })
    nvim_lsp.typos_lsp.setup{
      capabilities = capabilities,
      flags = lsp_flags,
      on_attach = on_attach
    }
    nvim_lsp.emmet_language_server.setup{
      capabilities = capabilities,
      on_attach = on_attach,
      flags = lsp_flags,
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
      flags = lsp_flags,
      on_attach = on_attach
    }
    nvim_lsp.htmx.setup{
      capabilities = capabilities,
      flags = lsp_flags,
      on_attach = on_attach
    }
    nvim_lsp.jsonls.setup{
      capabilities = capabilities,
      flags = lsp_flags,
    }

    local function get_quarto_resource_path()
      local function strsplit(s, delimiter)
        local result = {}
        for match in (s .. delimiter):gmatch('(.-)' .. delimiter) do
          table.insert(result, match)
        end
        return result
      end

      local f = assert(io.popen('quarto --paths', 'r'))
      local s = assert(f:read '*a')
      f:close()
      return strsplit(s, '\n')[2]
    end

    local lua_library_files = vim.api.nvim_get_runtime_file('', true)
    local lua_plugin_paths = {}
    local resource_path = get_quarto_resource_path()
    if resource_path == nil then
      vim.notify_once 'quarto not found, lua library files not loaded'
    else
      table.insert(lua_library_files, resource_path .. '/lua-types')
      table.insert(lua_plugin_paths, resource_path .. '/lua-plugin/plugin.lua')
    end

    nvim_lsp.lua_ls.setup {
      capabilities = capabilities,
      flags = lsp_flags,
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
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          runtime = {
            version = 'LuaJIT',
            -- plugin = lua_plugin_paths, -- handled by lazydev
          },
          diagnostics = {
            disable = { 'trailing-space' },
          },
          workspace = {
            -- library = lua_library_files, -- handled by lazydev
            checkThirdParty = false,
          },
          doc = {
            privateName = { '^_' },
          },
          telemetry = {
            enable = false,
          },
        }
      }
    }
    nvim_lsp.vimls.setup {
      capabilities = capabilities,
      flags = lsp_flags,
    }
    nvim_lsp.julials.setup {
      capabilities = capabilities,
      flags = lsp_flags,
    }
    nvim_lsp.marksman.setup{
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { 'markdown', 'quarto' },
      root_dir = util.root_pattern('.git', '.marksman.toml', '_quarto.yml'),
    }
    nvim_lsp.ruby_lsp.setup{
      capabilities = capabilities,
      flags = lsp_flags,
      on_attach = on_attach
    }
    -- PYTHON
    -- nvim_lsp.ruff_lsp.setup{
    --   capabilities = capabilities,
    --   flags = lsp_flags,
    --   on_attach = on_attach,
    --   trace = 'messages',
    --   init_options ={
    --     settings = {
    --       logLevel = 'debug',
    --     }
    --   },
    --   keys = {
    --     {
    --       "<leader>oi",
    --       function ()
    --         vim.lsp.buf.code_action({
    --           apply = true,
    --           context = {
    --             only = { "source.organizeImports"},
    --             diagnostics = {},
    --           }
    --         })
    --       end,
    --       desc = "Organize Imports",
    --     },
    --   },
    -- }

    -- See https://github.com/neovim/neovim/issues/23291
    -- disable lsp watcher.
    -- Too lags on linux for python projects
    -- because pyright and nvim both create too many watchers otherwise
    if capabilities.workspace == nil then
      capabilities.workspace = {}
      capabilities.workspace.didChangeWatchedFiles = {}
    end
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

    nvim_lsp.pyright.setup {
      capabilities = capabilities,
      flags = lsp_flags,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = 'workspace',
          },
        },
      },
      root_dir = function(fname)
        return util.root_pattern('.git', 'setup.py', 'setup.cfg', 'pyproject.toml', 'requirements.txt')(fname) or util.path.dirname(fname)
      end,
    }

    require'py_lsp'.setup({
      language_server = {"pylsp", "ruff"}, --"pylsp",
      source_strategies = "system", -- {"poetry", "default", "conda", "system"},
      capabilities = capabilities,
      on_attach = on_attach,
      venvs = {".venv", "venv", ".env", "env"},
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
      function(_, result, ctx)
        result.diagnostics = vim.tbl_filter(filter_diagnostics, result.diagnostics)
        vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
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
        enabled = false,
        -- hl_mode = "combine",
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

  end,
  -- Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        'black',
        'isort',
        'tree-sitter-cli',
        'jupytext',
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
