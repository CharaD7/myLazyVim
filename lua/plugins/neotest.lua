return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-python",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-jest",
    "nvim-lua/plenary.nvim",
    "marilari88/neotest-vitest",
  },
  config = function()
    local neotest = require("neotest")

    local adapters = {
      require("neotest-python")({
        dap = { justMyCode = false },
        args = { "--log-level", "DEBUG", "--log-file", "pytest.log" },
        runner = "pytest",
        pytest_discover_instances = true,
      }),
      require("neotest-vitest")({}),
      require("neotest-jest")({
        jestCommand = "pnpm test --",
        jestArguments = function(defaultArguments, context)
          return defaultArguments
        end,
        env = { CI = true },
        discovery = { enabled = true },
        cwd = function(path)
          return vim.fn.getcwd()
        end,
      }),
    }

    local ok, pw = pcall(require, "neotest-playwright")
    if ok and pw and pw.adapter then
      table.insert(adapters, pw.adapter({
        options = {
          persist_project_selection = false,
          enable_dynamic_test_discovery = true,
          preset = "none",
          get_playwright_binary = function()
            return vim.loop.cwd() .. "/node_modules/.bin/playwright"
          end,
          get_playwright_config = function()
            return vim.loop.cwd() .. "/playwright.config.ts"
          end,
          get_cwd = function()
            return vim.loop.cwd()
          end,
          env = {},
          extra_args = {},
          experimental = {
            telescope = {
              enabled = false,
              opts = {},
            },
          },
        },
      }))
    end

    neotest.setup({
      status = {
        enabled = true,
        virtual_text = true,
        signs = true,
      },
      adapters = adapters,
    })
  end,
  keys = {
    { ";dtr", ":Neotest run<cr>", mode = {"n"}, desc = "Run nearest test" },
    {
      ";dtd",
      ":Neotest run strategy=dap<cr>",
      mode = {"n"},
      desc = "Debug nearest test",
    },
    { ";dtA", ":Neotest run suite=true<cr>", mode = {"n"}, desc = "Run all tests" },
    {
      ";dtB",
      ":lua require('neotest-playwright.preset').select_preset(function(choice) require('neotest-playwright.preset').set_preset(choice) end)<cr>",
      mode = {"n"},
      desc = "Set Playwright browser visibility (debug=devtools, headed=show browser, none=headless)",
    },
    {
      ";dtf",
      ":Neotest run file<cr>",
      mode = {"n"},
      desc = "Run current test file",
    },
    { ";dts", ":Neotest stop<cr>", mode = {"n", "v"}, desc = "Stop test" },
    { ";dto", ":Neotest output<cr>", mode = {"n", "v"}, desc = "Open test output" },
    {
      ";dtp",
      ":Neotest output-panel<cr>",
      mode = {"n"},
      desc = "Toggle test output panel",
    },
    { ";dta", ":Neotest attach<cr>", mode = {"n"}, desc = "Attach to test" },
    {
      ";dtc",
      ":Neotest run suite=true env={CI=true}<cr>",
      mode = {"n"},
      desc = "Run all tests with CI env",
    },
    { ";dtS", ":Neotest summary<cr>", mode = {"n"}, desc = "Toggle test summary" },
    { ";dte", ":Telescope playwright_commands<cr>", mode = {"n"}, desc = "Open Playwright command picker" },
  },
}
