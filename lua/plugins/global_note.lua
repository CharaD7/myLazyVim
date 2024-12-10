return {
  "backdround/global-note",
  config = function ()
    local global_note = require("global-note")
    global_note.setup({
      additional_presets = {
        git_branch_local = {
          command_name = "GitBranchNote",

          directory = function()
            return vim.fn.stdpath("data") .. "/global-note/" .. get_project_name()
          end,

          filename = function()
            local git_branch = get_git_branch()
            if git_branch == nil then
              return nil
            end
            return get_git_branch():gsub("[^%w-]", "-") .. ".md"
          end,

          title = get_git_branch,
        },
      }
    })

    vim.keymap.set("n", ";gn", function()
      global_note.toggle_note("git_branch_local")
    end, {
        desc = "Toggle git branch note",
      })
  end
}
