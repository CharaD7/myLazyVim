local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "vue",
}

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
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        'nvim-neotest/nvim-nio',
        'rcarriga/nvim-dap-ui',
        'mfussenegger/nvim-dap-python',
        'theHamsta/nvim-dap-virtual-text',
      },
    },
    config = function()
      vim.fn.sign_define('DapBreakpoint', { text = '🦆', texthl = '', linehl = '', numhl = '' })
      local dap = require("dap")
      local ui = require("dapui")
      ui.setup()
      require('dap-python').setup()
      require('dap.ext.vscode').load_launchjs 'launch.json'

      require('nvim-dap-virtual-text').setup {
        -- Hides tokens, secrets, and other sensitive information
        -- From TJ DeVries' config
        -- Not necessary, but also can't hurt
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if name:match 'secret' or name:match 'api' or value:match 'secret' or value:match 'api' then
            return '*****'
          end

          if #variable.value > 15 then
            return ' ' .. string.sub(variable.value, 1, 15) .. '... '
          end

          return ' ' .. variable.value
        end,
      }

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
      local venv = os.getenv("VIRTUAL_ENV") .. "/bin/python3"
      dap.adapters.python = {
        type = 'executable',
        command = venv,
        args = {'-m', 'debugpy.adapter'}
      }
      local Config = require("lazyvim.config")

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3]}
        )
      end

      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          -- Debug single nodejs files
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug nodejs processes (I need to add --inspect when I run the process)
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug web applications (client side)
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:3000",
                },
                  function(url)
                    if url == nil or url == "" then
                      return
                    else
                      coroutine.resume(co, url)
                    end
                  end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
          },
          -- Divider for the launch.json derived configs
          {
            name = "----- ⬇️ launch.json configs ⬇️ -----",
            type = "",
            request = "launch",
          },
        }
      end

      local set_cs_dap = function()
        require('dap-csharp').setup()
        dap.configurations.cs = {
          {
            type = 'coreclr',
            name = 'Attach remote',
            request = 'attach',
            mode = 'remote',
          },
        }
      end
      set_cs_dap()

      local set_python_dap = function()
        require('dap-python').setup() -- earlier, so I can setup the various defaults ready to be replaced
        require('dap-python').resolve_python = function()
          return venv
        end
        dap.configurations.python = {
          {
            type = 'python';
            request = 'launch';
            name = "Launch file";
            program = "${file}";
            pythonPath = venv
          },
          {
            type = 'debugpy',
            request = 'launch',
            name = 'Django',
            program = '${workspaceFolder}/manage.py',
            args = {
              'runserver',
            },
            justMyCode = true,
            django = true,
            console = "integratedTerminal",
            pythonPath = venv
          },
          {
            type = 'python';
            request = 'attach';
            name = 'Attach remote';
            connect = function()
              return {
                host = 'localhost',
                port = 5678
              }
            end;
          },
          {
            type = 'python';
            request = 'launch';
            name = 'Launch file with arguments';
            program = '${file}';
            args = function()
              local args_string = vim.fn.input('Arguments: ')
              return vim.split(args_string, " +")
            end;
            console = "integratedTerminal",
            pythonPath = venv
          }
        }
      end

      set_python_dap()
      vim.api.nvim_create_autocmd({"DirChanged", "BufEnter"}, {
        callback = function() set_python_dap() end,
      })
    end,

    keys = {
      { '<leader>db', ":lua require'dap'.toggle_breakpoint()<cr>", desc = 'Toggle Breakpoint' },
      { '<leader>dc', ":lua require'dap'.continue()<cr>", desc = 'Continue' },
      { '<leader>do', ":lua require'dap'.step_over()<cr>", desc = 'Step Over' },
      { '<leader>dO', ":lua require'dap'.step_out()<cr>", desc = 'Step Out' },
      { '<leader>di', ":lua require'dap'.step_into()<cr>", desc = 'Step Into' },
      { '<leader>dr', ":lua require'dap'.repl_open()<cr>", desc = 'Repl Open' },
      { '<leader>du', ":lua require'dapui'.toggle()<cr>", desc = 'DapUi Toggle' },
      {
        "<leader>da",
        function ()
          if vim.fn.filereadable(".vscode/launch.json") then
            local dap_vscode = require("dap.ext.vscode")
            dap_vscode.load_launchjs(nil, {
              ["pwa-node"] = js_based_languages,
              ["chrome"] = js_based_languages,
              ["pwa-chrome"] = js_based_languages,
            })
          end
          require("dap").continue()
        end,
        desc = "Run with Args",
      },
    },
    dependencies = {
      -- Install the vscode-js-debug adapter
      {
        "microsoft/vscode-js-debug",
        -- After install, build and rename the dist directory to out
        build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
        version = "1.*",
      },
      {
        "mxsdev/nvim-dap-vscode-js",
        config = function()
          require("dap-vscode-js").setup({
            -- Path to vscode-js-debug installation.
            debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),

            -- Adapters to register in nvim-dap
            adapters = {
              "chrome",
              "pwa-node",
              "pwa-chrome",
              "pwa-msedge",
              "pwa-extensionHost",
              "node-terminal",
            },
          })
        end,
      },
      {
        "Joakker/lua-json5",
        build = "./install.sh",
      },
    },
  },
}
