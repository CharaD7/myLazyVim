-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local cmd = vim.cmd

local options = {
  guifont = "Fira Code iScript:h10",
  list = true,
}

for key, value in pairs(options) do
  vim.opt[key] = value
end

-- Undercurl
cmd([[ let &t_Cs = "\e[4:3m]" ]])
cmd([[ let &t_Ce = "\e[4:0m]" ]])

-- Pretty Fold
vim.opt.fillchars:append('fold:•')
-- More options for listchars.
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")
