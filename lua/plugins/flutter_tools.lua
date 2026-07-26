return {
  "akinsho/flutter-tools.nvim",
  ft = "dart",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  config = true,
  opts = {
    decorations = {
      statusline = {
        app_version = true,
        device = true,
      },
    },
    debugger = {
      enabled = true,
      run_via_dap = true,
      register_configurations = function(_)
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
            dartSdkPath = "~/flutter/bin/cache/dart-sdk",
            flutterSdkPath = "~/flutter",
            program = "${workspaceFolder}/lib/main.dart",
            cwd = "${workspaceFolder}",
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
      notify_errors = true,
    },
    lsp = {
      color = {
        enabled = true,
        background = true,
        virtual_text = true,
        virtual_text_str = "■",
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
