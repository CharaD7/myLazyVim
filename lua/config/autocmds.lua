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
			pcall(function()
				require("lsp_lines").setup()
				vim.diagnostic.config({ virtual_lines = false })
			end)
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

-- Check conda environment for all python-type files
create({
	"FileType",
	"BufRead",
	"BufNewFile",
}, {
		pattern = { "*.py", "*.ipynb", "*.qmd" },
		callback = function()
			-- source the conda environment if conda is activated
			if vim.fn.exists("$CONDA_SHLVL") == 1 and vim.fn.getenv("CONDA_SHLVL") > 0 then
				vim.cmd([[ source ~/anaconda3/etc/profile.d/conda.fish ]])
			end
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
local icons
create({ "DiagnosticChanged" }, {
	callback = function()
		icons = icons or require("chara.icons")
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

-- Enable autosave on focus lost only (CursorHold is too frequent)
create({ "FocusLost" }, {
	callback = function()
		vim.cmd([[ :wa! ]])
		if vim.fn.expand("%:e") == "dart" then
			vim.cmd([[ FlutterReload ]])
		end
	end,
})

-- Check time anytime focus is restored or we enter a buffer
create({ "FocusGained", "BufEnter" }, {
	pattern = { "*" },
	command = "checktime",
})

local function set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- Disable line number and signcolumn when terminal is open
create({ "TermOpen" }, {
	pattern = { "*" },
	callback = function(_)
		vim.cmd.setlocal("nonumber")
		vim.wo.signcolumn = "no"
		set_terminal_keymaps()
	end,
})

-- Open in last edit point
create({ "BufReadPost" }, {
	callback = function()
		vim.cmd([[ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif ]])
	end,
})

-- Consolidated highlights: set on VimEnter, VeryLazy (after lazy plugins load), and ColorScheme
local function set_highlights()
  vim.cmd([[ highlight FloatBorder guifg=#61AFEF ]])
  vim.cmd([[ highlight CursorLineNr guifg=#F28FAD gui=bold ]])
  vim.cmd([[ highlight Visual guibg=#555500 guifg=#FFFFFF ]])
  vim.cmd([[ highlight LineNr guifg=#2aa198 ]])
  vim.cmd([[ highlight Cursor guifg=#61AFEF ]])
  vim.cmd([[ highlight BufferLineTabSelected gui=bold,underline guisp=#F28FAD guifg=#F28FAD ]])
  vim.cmd([[ highlight BufferLineTabSeparatorSelected gui=bold,underline guisp=#F28FAD guifg=#F28FAD ]])
  vim.cmd([[ highlight PmenuThumb guifg=#61AFEF guibg=#61AFEF ]])
  vim.cmd([[ highlight ScrollView guifg=#61AFEF guibg=#61AFEF ]])
  vim.cmd([[ highlight WinSeparator guifg=#61AFEF ]])
  vim.cmd([[ hi Keyword gui=underdotted cterm=underdotted ]])
  vim.cmd([[ hi Comment gui=italic cterm=italic ]])
  vim.cmd([[ hi Function gui=bold cterm=bold ]])
  vim.cmd([[ hi Constant gui=underline cterm=underline ]])
  vim.cmd([[ hi Exception gui=italic cterm=italic ]])
  vim.cmd([[ hi Type gui=italic cterm=italic ]])
  vim.cmd([[ hi Label gui=italic cterm=italic ]])
  vim.cmd([[ hi Include gui=underdashed cterm=underdashed ]])
  vim.cmd([[ hi StorageClass gui=underdashed cterm=underdashed ]])
  vim.cmd([[ hi Structure gui=italic cterm=italic ]])
  vim.cmd([[ hi Typedef gui=underdouble cterm=underdouble ]])
  vim.cmd([[ hi SpecialComment gui=italic cterm=italic ]])
  vim.cmd([[ hi PreProc gui=italic cterm=italic ]])
  pcall(function()
    local t = require("transparent")
    t.clear_prefix("NeoTree")
    t.clear_prefix("BufferLine")
    vim.cmd([[ TransparentEnable ]])
  end)
end

create({ "VimEnter" }, { callback = set_highlights })
create("User", { pattern = "VeryLazy", callback = set_highlights })
create({ "ColorScheme" }, { callback = set_highlights })

-- Enforce indentation settings for all files to have tabs instead of space
create({
	"FileType",
	"BufRead",
	"BufNewFile",
}, {
		pattern = { "*" },
		callback = function()
			local indent = 2
			vim.bo.expandtab = false     -- use real tabs
			vim.bo.shiftwidth = indent        -- number of spaces per indent
			vim.bo.tabstop = indent           -- how wide a tab appears
			vim.bo.softtabstop = 0
		end,
	})


-- Render binary files within neovim
-- Render pdf files
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.pdf",
  callback = function()
    local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
    vim.cmd("silent !mupdf " .. filename .. " &")
    vim.cmd("let tobedeleted = bufnr('%') | b# | exe \"bd! \" . tobedeleted")
  end
})

-- Render image files
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  callback = function()
    local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
    vim.cmd("silent !eyestalk " .. filename .. " &")
    vim.cmd("let tobedeleted = bufnr('%') | b# | exe \"bd! \" . tobedeleted")
  end
})

