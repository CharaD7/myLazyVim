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
create("BufEnter", {
  pattern = {"Mason"},
  callback = function()
    require("lsp_lines").setup()
    vim.diagnostic.config({ virtual_lines = false })
  end
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
  'FileType',
  'BufRead',
  'BufNewFile',
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
  'FileType',
  'BufRead',
  'BufNewFile',
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

-- Hot reload dart files on save
create({ "BufWritePost" }, {
  pattern = { "*.dart" },
  callback = function()
    require("flutter-tools").setup {}
    vim.fn.system("flutter pub get") -- Ensure dependencies are up to date
    vim.fn.system("flutter pub global run flutter_tools --hot-reload")
  end
})

-- automatically import output chunks from a jupytr notebook
-- tris to find a kernel that matches the krnel in the jupyter notebook
-- falls back to a kernel that matches the name of the active venv (if any)
local imb = function(e) -- init molten buffer
  vim.schedule(function ()
    local kernels = vim.fn.MoltenAvailableKernels()
    local try_kernel_name = function()
      local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
      return metadata["kernelspec"]["name"]
    end
    local ok, kernel_name = pcall(try_kernel_name)
    if not ok or not vim.tbl_contains(kernels, kernel_name) then
      kernel_name = nil
      local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
      if venv ~= nil then
        kernel_name = string.match(venv, "/.+/(.+)")
      end
    end
    if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
      vim.cmd(("MoltenInit %s"):format(kernel_name))
    end
    vim.cmd("MoltenImportOutput")
  end)
end

-- automatically import output chunks from a jupyter notebook
create({ "BufAdd" }, {
  pattern = { "*.ipynb" },
  callback = imb,
})

-- catch open files like ./hi.ipynb
create({ "BufEnter", }, {
  pattern = {"*.ipynb"},
  callback = function(e)
    if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
      imb(e)
    end
  end
})

-- use molten for regular python files
create({ "BufEnter" }, {
  pattern = {"*.py"},
  callback = function(e)
    if string.match(e.file, ".otter.") then
      return
    end
    if require("molten.status").initialized() == "Molten" then --this is kinda hacky
      vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
      vim.fn.MoltenUpdateOption("virt_text_output", false)
    else
      vim.g.molten_virt_lines_off_by_1 = false
      vim.g.molten_virt_text_output = false
    end
  end,
})

-- Undo those config changes when we go back to a markdown or quarto file
create({ "BufEnter" }, {
  pattern = {
    '*.qmd',
    '*.md',
    '*.ipynb',
  },
  callback = function(e)
    if string.match(e.file, ".otter.") then
      return
    end
    if require("molten.status").initialized() == "Molten" then --this is kinda hacky
      vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
      vim.fn.MoltenUpdateOption("virt_text_output", true)
    else
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_virt_text_output = true
    end
  end,
})

-- Provide a command to create a blank new Python notebook
-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
-- if you use another language than Python, you should change it in the template.
local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_notebook(filename)
  local path = filename .. ".ipynb"
  local file = io.open(path, "w")
  if file then
    file:write(default_notebook)
    file:close()
    vim.cmd("edit " .. path)
  else
    print("Error: Could not open new notebook file for writing.")
  end
end

vim.api.nvim_create_user_command('NewNotebook', function(opts)
    new_notebook(opts.args)
  end, {
    nargs = 1,
    complete = 'file',
  }
)

-- Open in last edit point
create({ 'BufReadPost' }, {
  callback = function()
    vim.cmd [[ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif ]]
  end
})

-- Border color for all floating windows
create({
  'ColorScheme',
  'VimEnter',
  'BufEnter',
  'WinEnter',
  'BufWinEnter'
}, {
  callback = function()
    vim.cmd [[ highlight FloatBorder guifg=#F28FAD ]]
    vim.cmd [[ highlight CursorLineNr gui=bold guifg=#F28FAD ]]
    vim.cmd [[ highlight LineNr guifg=#2aa198 ]]
    vim.cmd [[ highlight CursorLine guibg=#3f3a60 ]]
  end
})

-- Highlights for Bufferline
--gui=underline cterm=underline 
create({
  'ColorScheme',
  'VimEnter',
  'BufEnter',
  'WinEnter',
  'BufWinEnter'
}, {
  callback = function()
    vim.cmd [[ highlight BufferLineTabSelected gui=bold,underline guisp=#F28FAD guifg=#F28FAD ]]
    vim.cmd [[ highlight BufferLineTabSeparatorSelected gui=bold,underline guisp=#F28FAD guifg=#F28FAD ]]
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
    vim.cmd [[ highlight WinSeparator guifg=#61AFEF ]]
  end
})

-- Source bufferline config on VimEnter and BufEnter
create({
  'VimEnter',
  'BufEnter',
}, {
  callback = function()
    vim.cmd [[ source ~/.config/nvim/lua/plugins/bufferline.lua ]]
    vim.cmd [[ :set relativenumber ]] -- Enforce relative line numbers
    vim.diagnostic.config({virtual_text = false}) -- disable diagnostic virtual text
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
