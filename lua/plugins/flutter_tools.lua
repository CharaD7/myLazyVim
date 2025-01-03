return {
  'akinsho/flutter-tools.nvim',
  lazy = false,
  dependencies = {
      'nvim-lua/plenary.nvim',
  },
  config = true,
  opts ={
    decorations = {
      statusline = {
        -- Show currently running device if an application is started with a spec: device
        app_version = true,
        device = true,
      },
    },
    debugger = { -- integrate with nvim dap + install dart code debugger
      enabled = false,
      register_configurations = function (path)
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
            toolArgs = {"-d", "linux"},
          }
        }
      end
    },
    widget_guides = {
      enabled = true,
    },
    lsp = {
      color = {
        enabled = true, -- whether or not to highlight color variables at all
        background = true, -- highlight the background
        virtual_text = false,
      },
    },
    ui = {
      border = "rounded",
    },
  },
}
