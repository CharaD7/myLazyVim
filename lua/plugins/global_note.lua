return {
  "backdround/global-note.nvim",
  keys = {
    { ";gn", desc = "Toggle global note" },
  },
  config = function()
    local global_note = require("global-note")
    global_note.setup()

    vim.keymap.set("n", ";gn", global_note.toggle_note, {
      desc = "Toggle global note",
    })
  end,
}
