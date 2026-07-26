local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local conf = require("telescope.config").values

local commands = {
  { name = "codegen", desc = "Browser recorder - generate code from user actions", cmd = "pnpm exec playwright codegen", terminal = true },
  { name = "show-trace", desc = "Open trace viewer to inspect test traces", cmd = "pnpm exec playwright show-trace", terminal = false },
  { name = "show-report", desc = "Open HTML test report", cmd = "pnpm exec playwright show-report", terminal = false },
  { name = "clear-cache", desc = "Clear build and test caches", cmd = "pnpm exec playwright clear-cache", terminal = false },
  { name = "install", desc = "Install Playwright browsers", cmd = "pnpm exec playwright install", terminal = true },
  { name = "install-deps", desc = "Install OS dependencies for browsers", cmd = "pnpm exec playwright install-deps", terminal = true },
  { name = "cr", desc = "Open page in Chromium", cmd = "pnpm exec playwright cr", terminal = true },
  { name = "ff", desc = "Open page in Firefox", cmd = "pnpm exec playwright ff", terminal = true },
  { name = "wk", desc = "Open page in WebKit", cmd = "pnpm exec playwright wk", terminal = true },
  { name = "screenshot", desc = "Capture a page screenshot", cmd = "pnpm exec playwright screenshot", terminal = true },
  { name = "pdf", desc = "Save page as PDF", cmd = "pnpm exec playwright pdf", terminal = true },
  { name = "merge-reports", desc = "Merge multiple blob reports into one", cmd = "pnpm exec playwright merge-reports", terminal = true },
  { name = "open", desc = "Open page in browser", cmd = "pnpm exec playwright open", terminal = true },
}

return require("telescope").register_extension({
  exports = {
    playwright_commands = function(opts)
      opts = opts or {}
      pickers.new(opts, {
        prompt_title = "Playwright Commands",
        finder = finders.new_table({
          results = commands,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.name,
              ordinal = entry.name,
            }
          end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            action_set.select(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            if selection then
              if selection.terminal then
                vim.cmd("new")
                vim.fn.termopen(selection.cmd)
              else
                vim.cmd("!" .. selection.cmd)
              end
            end
          end)
          return true
        end,
      }):find()
    end,
  },
})
