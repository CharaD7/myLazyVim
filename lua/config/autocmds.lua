-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local create = vim.api.nvim_create_autocmd

-- Turn off paste mode when leaving insert mode
create("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Turn off virtual_line when mason window is open
create("WinEnter", {
  callback = function()
    local win_config = vim.api.nvim_win_get_config(0)
    if win_config.zindex then
      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_lines = false })
    end
  end,
})

-- Fix conceallevel for json files
create("FileType", {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

-- Persist indentation for Filetypes
create({
  "FileType",
  "BufRead",
  "BufNewFile",
}, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[ set tabstop=2 ]])
    vim.cmd([[ set shiftwidth=2 ]])
    vim.cmd([[ set expandtab ]])
  end,
})

-- Use php syntax for blade Filetypes
create({
  "FileType",
  "BufRead",
  "BufNewFile",
}, {
  pattern = { "*.blade.php" },
  callback = function()
    vim.cmd([[ set filetype=php ]])
  end,
})

-- Enable italics if colorscheme is set to gruvbox
create("ColorScheme", {
  pattern = "*",
  callback = function()
    local colorscheme = vim.g.colors_name
    if colorscheme == "gruvbox" then
      vim.g.gruvbox_italic = 1
    end
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

-- Configuration for vim diagnostics
create({ "DiagnosticChanged" }, {
  callback = function()
    local icons = require("chara.icons")
    local sign = function(opts)
      vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = "",
      })
    end
    sign({ name = "DiagnosticSign", text = icons.ui.Gear })
    sign({ name = "DiagnosticSignError", text = icons.diagnostics.Error })
    sign({ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning })
    sign({ name = "DiagnosticSignInfo", text = icons.diagnostics.Information })
    sign({ name = "DiagnosticSignHint", text = icons.diagnostics.Hint })
  end,
})

-- Show diagnostic in floating window on hover
-- create({ "CursorHold", "CursorHoldI" }, {
--   callback = function()
--     vim.cmd([[ :Lspsaga hover_doc ]])
--     -- vim.cmd([[ lua vim.diagnostic.open_float(nil, { focus=false }) ]])
--   end,
-- })

-- Enable autosave at every edit and on focus lost
create({ "CursorHold", "CursorHoldI", "FocusLost" }, {
  callback = function()
    vim.cmd([[ :wa! ]])
  end,
})

-- Check tiem anytime focus is restored or we enter a buffer
create({ 'FocusGained', 'BufEnter' }, {
  pattern = { '*' },
  command = 'checktime',
})

local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- Disable line number and signcolumn when terminal is open
create({ 'TermOpen' }, {
  pattern = { '*' },
  callback = function(_)
    vim.cmd.setlocal 'nonumber'
    vim.wo.signcolumn = 'no'
    set_terminal_keymaps()
  end,
})

-- Hot reload dart files on save
create({ "BufWritePost" }, {
  pattern = { "*.dart" },
  callback = function()
    require("flutter-tools").setup({})
    vim.fn.system("flutter pub get") -- Ensure dependencies are up to date
    vim.cmd("FlutterReload")
  end,
})

-- Open in last edit point
create({ "BufReadPost" }, {
  callback = function()
    vim.cmd([[ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif ]])
  end,
})

-- Border color for all floating windows
create({
  "ColorScheme",
  "VimEnter",
  "BufEnter",
  "WinEnter",
  "BufWinEnter",
}, {
  callback = function()
    vim.cmd([[ highlight FloatBorder guifg=#61AFEF ]])
    vim.cmd([[ highlight CursorLineNr gui=bold guifg=#F28FAD ]])
    vim.cmd([[ highlight Visual guibg=#555500 guifg=#FFFFFF ]]) -- background and foreground color for visual line
    vim.cmd([[ highlight LineNr guifg=#2aa198 ]])
    vim.cmd([[ highlight CursorLine guibg=#3f3a60 ]])
  end,
})

-- Highlights for Bufferline
--gui=underline cterm=underline
create({
  "ColorScheme",
  "VimEnter",
  "BufEnter",
  "WinEnter",
  "BufWinEnter",
}, {
  callback = function()
    vim.cmd([[ highlight BufferLineTabSelected gui=bold,underline guisp=#F28FAD guifg=#F28FAD ]])
    vim.cmd([[ highlight BufferLineTabSeparatorSelected gui=bold,underline guisp=#F28FAD guifg=#F28FAD ]])
  end,
})

-- Automtically hot-reload Flutter app when dart file is written to buffer
-- create({'BufWritePost'}, {
--   pattern = '*.dart',
--   callback = function ()
--     vim.cmd([[ :silent !clear | execute "Flutter" .. (FlutterDevices() > 0 and \"Reload\" or \"Run\") ]])
--   end,
-- })

-- Set popup scrollbar color and vertical split color
create({
  "VimEnter",
  "BufEnter",
  "WinEnter",
  "BufWinEnter",
}, {
  callback = function()
    vim.cmd([[ highlight PmenuThumb guifg=#61AFEF guibg=#61AFEF ]])
    vim.cmd([[ highlight ScrollView guifg=#61AFEF guibg=#61AFEF ]])
    vim.cmd([[ highlight WinSeparator guifg=#61AFEF ]])
    -- vim.cmd([[ highlight BlinkCmpDocBorder guifg=#61AFEF ]])
  end,
})

-- Source bufferline config on VimEnter and BufEnter
create({
  "VimEnter",
  "BufEnter",
}, {
  callback = function()
    vim.cmd([[ source ~/.config/nvim/lua/plugins/bufferline.lua ]])
  end,
})

-- Italic/Bold/Underline/underdashed font support for various neovim highlights
create({
  "VimEnter",
  "BufEnter",
  "WinEnter",
  "BufWinEnter",
}, {
  callback = function()
    -- All Keywords
    vim.cmd([[ hi Keyword gui=underdotted cterm=underdotted ]])
    -- All Comments
    vim.cmd([[ hi Comment gui=italic cterm=italic ]])
    -- All Functions
    vim.cmd([[ hi Function gui=bold cterm=bold ]])
    -- All Constants
    vim.cmd([[ hi Constant gui=underline cterm=underline ]])
    -- All Exceptions
    vim.cmd([[ hi Exception gui=italic cterm=italic ]])
    -- All Types
    vim.cmd([[ hi Type gui=italic cterm=italic ]])
    -- All Labels
    vim.cmd([[ hi Label gui=italic cterm=italic ]])
    -- All Includes
    vim.cmd([[ hi Include gui=underdashed cterm=underdashed ]])
    -- All StorageClasses
    vim.cmd([[ hi StorageClass gui=underdashed cterm=underdashed ]])
    -- All Structures
    vim.cmd([[ hi Structure gui=italic cterm=italic ]])
    -- All Typedefs
    vim.cmd([[ hi Typedef gui=underdouble cterm=underdouble ]])
    -- All SpecialComments
    vim.cmd([[ hi SpecialComment gui=italic cterm=italic ]])
    -- All PreProcs
    vim.cmd([[ hi PreProc gui=italic cterm=italic ]])
  end,
})
