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

-- Configuration for vim diagnostics
create({ 'DiagnosticChanged' }, {
  callback = function()
    local icons = require "chara.icons"
    local sign = function(opts)
      vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
      })
    end

    sign({ name = 'DiagnosticSign', text = icons.ui.Gear })
    sign({ name = 'DiagnosticSignError', text = icons.diagnostics.Error })
    sign({ name = 'DiagnosticSignWarn', text = icons.diagnostics.Warning })
    sign({ name = 'DiagnosticSignInfo', text = icons.diagnostics.Information })
    sign({ name = 'DiagnosticSignHint', text = icons.diagnostics.Hint })
  end
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

-- Open in last edit point
create({ 'BufReadPost' }, {
  callback = function()
    vim.cmd [[ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif ]]
  end
})

-- Border color for all floating windows
create({
  'VimEnter',
  'BufEnter',
  'WinEnter',
  'BufWinEnter'
}, {
  callback = function()
    vim.cmd [[ highlight FloatBorder guifg=#F28FAD ]]
    vim.cmd [[ highlight CursorLineNr gui=bold guifg=#F28FAD ]]
    vim.cmd [[ highlight CursorLine guibg=#002b36 ]]
    vim.cmd [[ highlight LineNr guifg=#2aa198 ]]
  end
})

-- Set popup scrollbar color and vertical split color
create({
  'VimEnter',
  'BufEnter',
  'WinEnter',
  'BufWinEnter'
}, {
  callback = function()
    vim.cmd [[ highlight PmenuThumb guifg=#61AFEF guibg=#61AFEF ]]
    vim.cmd [[ highlight VertSplit guifg=#61AFEF ]]
  end
})

-- Italic/Bold/Underline/underdashed font support for various neovim highlights
create({
  'VimEnter',
  'BufEnter',
  'WinEnter',
  'BufWinEnter'
}, {
  callback = function()
    -- All Keywords
    vim.cmd [[ hi Keyword gui=underdotted cterm=underdotted ]]
    -- All Comments
    vim.cmd [[ hi Comment gui=italic cterm=italic ]]
    -- All Functions
    vim.cmd [[ hi Function gui=bold cterm=bold ]]
    -- All Constants
    vim.cmd [[ hi Constant gui=underline cterm=underline ]]
    -- All Exceptions
    vim.cmd [[ hi Exception gui=italic cterm=italic ]]
    -- All Types
    vim.cmd [[ hi Type gui=italic cterm=italic ]]
    -- All Labels
    vim.cmd [[ hi Label gui=italic cterm=italic ]]
    -- All Includes
    vim.cmd [[ hi Include gui=underdashed cterm=underdashed ]]
    -- All StorageClasses
    vim.cmd [[ hi StorageClass gui=underdashed cterm=underdashed ]]
    -- All Structures
    vim.cmd [[ hi Structure gui=italic cterm=italic ]]
    -- All Typedefs
    vim.cmd [[ hi Typedef gui=underdouble cterm=underdouble ]]
    -- All SpecialComments
    vim.cmd [[ hi SpecialComment gui=italic cterm=italic ]]
    -- All PreProcs
    vim.cmd [[ hi PreProc gui=italic cterm=italic ]]
  end
})

-- windows to close
-- Function to define autocmd groups
local function augroup(name, autocmds)
    vim.api.nvim_command('augroup ' .. name)
    vim.api.nvim_command('autocmd!')

    for _, autocmd in ipairs(autocmds) do
        local cmd = table.concat(vim.tbl_flatten {'autocmd', autocmd}, ' ')
        vim.api.nvim_command(cmd)
    end

    vim.api.nvim_command('augroup END')
end
-- Autocommands
augroup('close_with_q', {
    {'FileType', {
        'OverseerForm',
        'OverseerList',
        'checkhealth',
        'floggraph',
        'fugitive',
        'git',
        'help',
        'lspinfo',
        'man',
        'neotest-output',
        'neotest-summary',
        'qf',
        'query',
        'spectre_panel',
        'startuptime',
        'toggleterm',
        'tsplayground',
        'vim',
        'neoai-input',
        'neoai-output',
        'notify',
    }, 'lua vim.bo[<abuf>].buflisted = false | lua vim.keymap.buf_set_keymap("n", "q", "<cmd>close<cr>", { noremap = true, silent = true })'},
})

augroup('auto_format_options', {
  {
    "BufWinEnter", {},
      'lua vim.cmd "set formatoptions-=cro"'
  },
})
