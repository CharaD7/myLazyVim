return {
  "akinsho/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  config = true,
  opts = {
    decorations = {
      statusline = {
        -- Show currently running device if an application is started with a spec: device
        app_version = true,
        device = true,
      },
    },
    debugger = { -- integrate with nvim dap + install dart code debugger
      enabled = true,
      run_via_dap = true,
      register_configurations = function(path)
        require("dap").adapters.dart = {
          type = "executable",
          command = vim.fn.stdpath("data") .. "/mason/bin/dart-debug-adapter",
          args = { "flutter" },
        }
        require("dap").configurations.dart = {
          {
            type = "dart",
            request = "launch",
            name = "Launch Flutter Program",
            -- The nvim-dap plugin populates this variable with the filename of the current buffer
            program = "${file}",
            -- The nvim-dap plugin populates this variable with the editor's current working directory
            cwd = "${workspaceFolder}",
            -- This gets forwarded to the Flutter CLI tool, substitute `linux` for whatever device you wish to launch
            toolArgs = { "-d", "linux" },
          },
        }
      end,
    },
    widget_guides = {
      enabled = true,
    },
    dev_log = {
      enabled = false,
      notify_errors = true, -- if there is an error whilst running, then notify the user.
    },
    lsp = {
      color = {
        enabled = true, -- whether or not to highlight color variables at all
        background = true, -- highlight the background
        virtual_text = true,
        virtual_text_str = "■", -- the virtual text character to highlight
      },
      settings = {
        showTodos = true,
        completeFunctionCalls = true,
        renameFilesWithClasses = "prompt",
        enableSnippets = true,
        updateImportsOnRename = true,
      },
    },
    ui = {
      border = "rounded",
    },
  },
}
