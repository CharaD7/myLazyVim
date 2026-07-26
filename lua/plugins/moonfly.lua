return {
  "bluz71/vim-moonfly-colors",
  priority = 1000,
  config = function()
    vim.cmd.syntax("enable")

    vim.api.nvim_set_hl(0, "MoltenOutputBorder", { link = "Normal" })
    vim.api.nvim_set_hl(0, "MoltenOutputBorderFail", { link = "MoonflyCrimson" })
    vim.api.nvim_set_hl(0, "MoltenOutputBorderSuccess", { link = "MoonflyBlue" })
  end,
}
