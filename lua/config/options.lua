-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local cmd = vim.cmd
local tabsize = 2

local options = {
  guifont = "Fira Code iScript:h7",
  ve = "block", -- All virtual text editing modes in block
  cmdheight = 1, -- hide cmd line when not in use
  list = true,
  -- term = 'xterm-256color',
  termguicolors = true,
  fillchars = 'eob: ',
  relativenumber = true,
  encoding = 'utf-8',
  fileencoding = 'utf-8',
  updatetime = 100,
  timeoutlen = 500,
  ttimeoutlen = 10,
  wildoptions = "pum",
  signcolumn = 'yes:3', -- consistent signcolumns
  expandtab = false,
  shiftwidth = tabsize,
  tabstop = tabsize,
  smartindent = true,
  breakindent = true,
  guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait400-blinkoff400-blinkon400-Cursor/lCursor,sm:block-blinkwait175-blinkoff175-blinkon175",
  pumblend = 15,
  winblend = 15,
  completeopt = "menuone,noinsert,popup",
}

for key, value in pairs(options) do
  vim.opt[key] = value
end

-- Undercurl
cmd([[ let &t_Cs = "\e[4:3m]" ]])
cmd([[ let &t_Ce = "\e[4:0m]" ]])

-- diagnostics
vim.diagnostic.config {
  underline = true,
  signs = true,
}

-- additional builtin vim packages
-- filter quickfix list with Cfilter
vim.cmd.packadd 'cfilter'

-- Pretty Fold
vim.opt.fillchars:append('fold:•')
-- More options for listchars.
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")
vim.opt.listchars:append("trail:␣")
vim.opt.listchars:append("tab:» ")

-- don't continue comments automagically
-- https://neovim.io/doc/user/options.html#'formatoptions'
vim.opt.formatoptions:remove 'c'
vim.opt.formatoptions:remove 'r'
vim.opt.formatoptions:remove 'o'

-- Neovide Configuration
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_text_gamma = 0.0
  vim.g.neovide_text_contrast = 0.5
  vim.g.neovide_fullscreen = false
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_floating_blur_amount_x = 4.0 -- works only on mac
  vim.g.floaterm_winblend = 15
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_theme = 'auto' -- Detect neovim set theme mode and switch accordingly
  vim.g.neovide_floating_blur_amount_y = 4.0 -- works only on mac
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_opacity = 0.8
  vim.g.neovide_padding_top = 5
  vim.g.neovide_padding_bottom = 5
  vim.g.neovide_padding_right = 5
  vim.g.neovide_padding_left = 5
  vim.g.neovide_cursor_animation_length = 0.15
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_cursor_unfocused_outline_width = 0.5
  vim.g.neovide_cursor_trail_length = 1.2
  vim.g.neovide_cursor_vfx_mode = "wireframe" -- railgun, torpedo, ripple, or wireframe
  vim.g.neovide_cursor_vfx_opacity = 200.0
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.8
  vim.g.neovide_cursor_vfx_particle_density = 9.0
  vim.g.neovide_cursor_vfx_particle_speed = 15.0
  vim.g.neovide_cursor_vfx_particle_phase = 1.5 -- only for railgun
  vim.g.neovide_cursor_vfx_particle_curl = 1.0 -- only for railgun
end
