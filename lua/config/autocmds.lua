-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local create = vim.api.nvim_create_autocmd

-- Turn off paste mode when leaving insert mode
create("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Fix conceallevel for json files
create("FileType", {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

-- Remove trailing whitespace
create({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[ %s/\s\+$//e ]])
    vim.cmd([[ %s/\n\+\%$//e ]])
  end,
})

-- Show diagnostic in floating window on hover
create({ "CursorHold", "CursorHoldI" }, {
  callback = function()
    vim.cmd([[ lua vim.diagnostic.open_float(nil, { focus=false }) ]])
  end,
})

-- Enable autosave at every edit and on focus lost
create({ "CursorHold", "CursorHoldI", "FocusLost" }, {
  callback = function()
    vim.cmd([[ :wa! ]])
  end,
})
