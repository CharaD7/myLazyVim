local js_based_languages = {
  'typescript',
  'javascript',
  'typescriptreact',
  'javascriptreact',
  'vue',
}

local mason_root = vim.fn.stdpath('data') .. '/mason'
local mason_bin = mason_root .. '/bin'
local mason_packages = mason_root .. '/packages'

local function first_that(paths, predicate)
  for _, path in ipairs(paths) do
    local expanded = vim.fn.expand(path)
    if predicate(expanded) then
      return expanded
    end
  end
end

local function first_executable(paths)
  return first_that(paths, function(path)
    return vim.fn.executable(path) == 1
  end)
end

local function detect_python()
  local venv = os.getenv('VIRTUAL_ENV')
  if venv and venv ~= '' then
    return venv .. '/bin/python3'
  end

  local cwd = vim.fn.getcwd()
  for _, path in ipairs { cwd .. '/venv/bin/python', cwd .. '/.venv/bin/python' } do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  local python3 = vim.fn.exepath('python3')
  if python3 ~= '' then
    return python3
  end

  local python = vim.fn.exepath('python')
  if python ~= '' then
    return python
  end

  return 'python3'
end

return {
  {
    'nvim-neotest/neotest',
    dependencies = { 'nvim-neotest/neotest-python' },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('neotest').setup {
        adapters = {
          require 'neotest-python',
        },
      }
    end,
    keys = {
      { ';dtt', ":lua require'neotest'.run.run({strategy = 'dap'})<cr>", desc = '[t]est' },
      { ';dts', ":lua require'neotest'.run.stop()<cr>", desc = '[s]top test' },
      { ';dta', ":lua require'neotest'.run.attach()<cr>", desc = '[a]ttach test' },
      { ';dtf', ":lua require'neotest'.run.run(vim.fn.expand('%'))<cr>", desc = 'test [f]ile' },
      { ';dts', ":lua require'neotest'.summary.toggle()<cr>", desc = 'test [s]ummary' },
    },
  },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'jay-babu/mason-nvim-dap.nvim',
      'mfussenegger/nvim-dap-python',
      'theHamsta/nvim-dap-virtual-text',
      'jbyuki/one-small-step-for-vimkind',
      {
        'rcarriga/nvim-dap-ui',
        opts = {
          icons = {
            expanded = '▾',
            collapsed = '▸',
            current_frame = require("chara.icons").ui.Fire,
          },
          mappings = {
            expand = { '<CR>', '<2-LeftMouse>' },
            open = 'o',
            remove = 'd',
            edit = 'e',
            repl = 'r',
            toggle = 't',
          },
          layouts = {
            {
              elements = {
                { id = 'scopes', size = 0.25 },
                'breakpoints',
                'stacks',
                'watches',
              },
              size = 40,
              position = 'left',
            },
            {
              elements = {
                'repl',
                'console',
              },
              size = 0.25,
              position = 'bottom',
            },
          },
          controls = {
            enabled = true,
            element = 'repl',
            icons = {
              pause = '',
              play = '',
              step_into = '',
              step_over = '',
              step_out = '',
              step_back = '',
              run_last = '↻',
              terminate = '□',
            },
          },
          floating = {
            border = 'rounded',
            mappings = {
              close = { 'q', '<Esc>' },
            },
          },
          windows = { indent = 1 },
          render = {
            max_value_lines = 100,
          },
        },
      },
      {
        'microsoft/vscode-js-debug',
        build = 'npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out',
        version = '1.*',
      },
      {
        'mxsdev/nvim-dap-vscode-js',
        config = function()
          require('dap-vscode-js').setup {
            debugger_path = vim.fn.resolve(vim.fn.stdpath('data') .. '/lazy/vscode-js-debug'),
            adapters = {
              'chrome',
              'pwa-node',
              'pwa-chrome',
              'pwa-msedge',
              'pwa-extensionHost',
              'node-terminal',
            },
          }
        end,
      },
      {
        'Joakker/lua-json5',
        build = './install.sh',
      },
    },
    keys = {
      { '<leader>db', ":lua require'dap'.toggle_breakpoint()<cr>", desc = 'Toggle Breakpoint' },
      { '<leader>dc', ":lua require'dap'.continue()<cr>", desc = 'Continue' },
      { '<leader>do', ":lua require'dap'.step_over()<cr>", desc = 'Step Over' },
      { '<leader>dO', ":lua require'dap'.step_out()<cr>", desc = 'Step Out' },
      { '<leader>di', ":lua require'dap'.step_into()<cr>", desc = 'Step Into' },
      { '<leader>dr', ":lua require'dap'.repl_open()<cr>", desc = 'Repl Open' },
      { '<leader>dl', ":lua require'dap'.run_last()<cr>", desc = 'Run Last' },
      { '<leader>du', ":lua require'dapui'.toggle()<cr>", desc = 'DapUi Toggle' },
      {
        '<leader>da',
        function()
          if vim.fn.filereadable('.vscode/launch.json') == 1 then
            local dap_vscode = require('dap.ext.vscode')
            dap_vscode.load_launchjs(nil, {
              ['pwa-node'] = js_based_languages,
              chrome = js_based_languages,
              ['pwa-chrome'] = js_based_languages,
            })
          end
          require('dap').continue()
        end,
        desc = 'Run with Args',
      },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      local dap_python = require('dap-python')
      local mason_dap = require('mason-nvim-dap')

      mason_dap.setup {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          'codelldb',
          'netcoredbg',
          'dart-debug-adapter',
        },
      }

      vim.fn.sign_define('DapBreakpoint', { text = require("chara.icons").ui.Bug, texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '➡', texthl = '', linehl = 'Visual', numhl = '' })

      require('nvim-dap-virtual-text').setup {
        display_callback = function(variable)
          local name = string.lower(variable.name or '')
          local value = string.lower(variable.value or '')
          if name:match 'secret' or name:match 'api' or value:match 'secret' or value:match 'api' then
            return '*****'
          end

          if (variable.value or ''):len() > 15 then
            return ' ' .. string.sub(variable.value, 1, 15) .. '... '
          end

          return ' ' .. (variable.value or '')
        end,
      }

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      local function configure_js()
        for _, language in ipairs(js_based_languages) do
          dap.configurations[language] = {
            {
              type = 'pwa-node',
              request = 'launch',
              name = 'Launch file',
              program = '${file}',
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
            },
            {
              type = 'pwa-node',
              request = 'attach',
              name = 'Attach',
              processId = require('dap.utils').pick_process,
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
            },
            {
              type = 'pwa-chrome',
              request = 'launch',
              name = 'Launch & Debug Chrome',
              url = function()
                local co = coroutine.running()
                return coroutine.create(function()
                  vim.ui.input({ prompt = 'Enter URL: ', default = 'http://localhost:3000' }, function(url)
                    if url and url ~= '' then
                      coroutine.resume(co, url)
                    end
                  end)
                end)
              end,
              webRoot = vim.fn.getcwd(),
              protocol = 'inspector',
              sourceMaps = true,
              userDataDir = false,
            },
            {
              name = '----- ⬇️ launch.json configs ⬇️ -----',
              type = '',
              request = 'launch',
            },
          }
        end
      end

      local function configure_coreclr()
        local netcoredbg = first_executable {
          mason_bin .. '/netcoredbg',
          '/usr/local/bin/netcoredbg',
          '~/netcoredbg/netcoredbg',
          'netcoredbg',
        }
        if not netcoredbg then
          vim.notify('[dap] netcoredbg not found. Install it via Mason to debug C#.', vim.log.levels.WARN)
          return
        end

        dap.adapters.coreclr = {
          type = 'executable',
          command = netcoredbg,
          args = { '--interpreter=vscode' },
        }

        dap.configurations.cs = {
          {
            type = 'coreclr',
            name = 'launch - netcoredbg',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end,
          },
          {
            type = 'coreclr',
            name = 'Attach to process',
            request = 'attach',
            processId = require('dap.utils').pick_process,
          },
        }
      end

      local python_group = vim.api.nvim_create_augroup('DapPythonConfig', { clear = true })
      local current_python_path

      local function configure_python()
        local python_path = detect_python()
        if current_python_path == python_path then
          return
        end

        current_python_path = python_path
        dap_python.setup(python_path)
        dap_python.resolve_python = function()
          return python_path
        end

        dap.adapters.python = {
          type = 'executable',
          command = python_path,
          args = { '-m', 'debugpy.adapter' },
        }

        dap.configurations.python = {
          {
            type = 'python',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            pythonPath = python_path,
          },
          {
            type = 'python',
            request = 'launch',
            name = 'Launch file with args',
            program = '${file}',
            console = 'integratedTerminal',
            args = function()
              local args_string = vim.fn.input('Arguments: ')
              if args_string == '' then
                return {}
              end
              return vim.split(args_string, '%s+', { trimempty = true })
            end,
            pythonPath = python_path,
          },
          {
            type = 'python',
            request = 'attach',
            name = 'Attach remote',
            connect = function()
              return { host = '127.0.0.1', port = 5678 }
            end,
            pythonPath = python_path,
          },
          {
            type = 'python',
            request = 'launch',
            name = 'Django: runserver',
            program = '${workspaceFolder}/manage.py',
            args = { 'runserver', '0.0.0.0:8000' },
            justMyCode = true,
            django = true,
            console = 'integratedTerminal',
            pythonPath = python_path,
          },
        }
      end

      local function configure_rust()
        local codelldb = first_executable {
          mason_bin .. '/codelldb',
          mason_packages .. '/codelldb/extension/adapter/codelldb',
          'codelldb',
        }
        if not codelldb then
          vim.notify('[dap] codelldb not found. Install it via Mason to debug Rust.', vim.log.levels.WARN)
          return
        end

        dap.adapters.codelldb = {
          type = 'server',
          host = '127.0.0.1',
          port = '${port}',
          executable = {
            command = codelldb,
            args = { '--port', '${port}' },
          },
        }

        dap.configurations.rust = {
          {
            name = 'Debug executable',
            type = 'codelldb',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
          },
          {
            name = 'Attach to process',
            type = 'codelldb',
            request = 'attach',
            pid = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
        }
      end

      local function configure_lua()
        dap.adapters.nlua = function(callback, config)
          callback {
            type = 'server',
            host = config.host or '127.0.0.1',
            port = config.port or 8086,
          }
        end

        dap.configurations.lua = {
          {
            type = 'nlua',
            request = 'attach',
            name = 'Attach to running Neovim',
            host = function()
              local host = vim.fn.input('Host [127.0.0.1]: ')
              if host == '' then
                host = '127.0.0.1'
              end
              return host
            end,
            port = function()
              local port = tonumber(vim.fn.input('Port [8086]: ', '8086'))
              return port or 8086
            end,
          },
        }

        pcall(vim.api.nvim_del_user_command, 'DapLaunchLuaServer')
        vim.api.nvim_create_user_command('DapLaunchLuaServer', function()
          require('osv').launch { port = 8086 }
        end, { desc = 'Start an nlua DAP server on :8086' })
      end

      local function configure_dart()
        if dap.adapters.dart then
          return
        end

        local dart_debug = first_executable { mason_bin .. '/dart-debug-adapter' }
        if not dart_debug then
          return
        end

        dap.adapters.dart = {
          type = 'executable',
          command = dart_debug,
          args = { 'flutter' },
        }

        dap.configurations.dart = {
          {
            type = 'dart',
            request = 'launch',
            name = 'Launch Flutter Program',
            dartSdkPath = '~/flutter/bin/cache/dart-sdk',
            flutterSdkPath = '~/flutter',
            program = '${workspaceFolder}/lib/main.dart',
            cwd = '${workspaceFolder}',
            toolArgs = { '-d', 'linux' },
          },
          {
            type = 'dart',
            request = 'launch',
            name = 'Launch current Dart file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
        }
      end

      configure_js()
      configure_coreclr()
      configure_python()
      configure_rust()
      configure_lua()
      configure_dart()

      vim.api.nvim_create_autocmd({ 'DirChanged', 'BufEnter' }, {
        group = python_group,
        callback = configure_python,
      })
    end,
  },
}
