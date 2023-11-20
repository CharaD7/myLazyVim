-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment/decrement
keymap.set("n", "+", "<c-a>")
keymap.set("n", "-", "<c-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<s-v>G")

-- Jumplist
keymap.set("n", "<C-m>", "<c-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<cr>", opts)
keymap.set("n", "<s-tab>", ":tabprev<cr>", opts)

-- Split window
keymap.set("n", "ss", ":split<cr>", opts)
keymap.set("n", "sv", ":vsplit<cr>", opts)

-- Move window
keymap.set("n", "sh", "<c-w>h")
keymap.set("n", "sk", "<c-w>k")
keymap.set("n", "sj", "<c-w>j")
keymap.set("n", "sl", "<c-w>l")

-- Resize window
keymap.set("n", "<c-left>", ":vertical resize -2<cr>", opts)
keymap.set("n", "<c-right>", ":vertical resize +2<cr>", opts)
keymap.set("n", "<c-up", ":resize -2<cr>", opts)
keymap.set("n", "<c-down", ":resize +2<cr>", opts)

-- Split focus
-- keymap.set("n", "<leader>h", ":FocusSplitLeft<cr>", opts)
-- keymap.set("n", "<leader>l", ":FocusSplitRight<cr>", opts)
-- keymap.set("n", "<leader>k", ":FocusSplitUp<cr>", opts)
-- keymap.set("n", "<leader>j", ":FocusSplitDown<cr>", opts)

-- Checkhealth
keymap.set("n", "<leader>ch", ":checkhealth<cr>", opts)

-- Source lua file
keymap.set("n", "so", ":source %<cr>", opts)

-- Quit commands
keymap.set("n", "q", ":q<cr>", opts)
keymap.set("n", "Q", ":qa<cr>", opts)

-- Stop highlights after searching.
keymap.set("n", "<esc>", ":noh<cr><esc>", opts)

-- Normal mode Line bubbling
keymap.set("n", "<s-a-j>", ":m .+1<CR>==", opts)
keymap.set("n", "<s-a-k>", ":m .-2<CR>==", opts)

-- Visual mode Line bubbling
keymap.set("v", "<s-a-j>", ":m '>+1<CR>==gv=gv", opts)
keymap.set("v", "<s-a-k>", ":m '<-2<CR>==gv=gv", opts)

-- Delete current buffer
keymap.set("n", "<c-x>", ":bdelete<cr>", opts)
