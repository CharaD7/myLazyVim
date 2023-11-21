return {
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  -- Go forward/backward with square brackets
	{
		"echasnovski/mini.bracketed",
		event = "BufReadPost",
		config = function()
			local bracketed = require("mini.bracketed")
			bracketed.setup({
				file = { suffix = "" },
				window = { suffix = "" },
				quickfix = { suffix = "" },
				yank = { suffix = "" },
				treesitter = { suffix = "n" },
			})
		end,
	},

	{
		"simrat39/symbols-outline.nvim",
		keys = { { "[t", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		cmd = "SymbolsOutline",
		opts = {
			position = "right",
		},
	},

	{
		"nvim-cmp",
		dependencies = { "hrsh7th/cmp-emoji" },
		opts = function(_, opts)
			table.insert(opts.sources, { name = "emoji" })
		end,
	},

  -- nvim surround
  {
    "ur4ltz/surround.nvim",
    config = function ()
      local surround = require("surround")

      surround.setup {
        mapping_style = "surround",
      }
    end
  },

  -- git conflict resolution
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
  },

  -- Focus nvim
  {
    "nvim-focus/focus.nvim",
    version = "*",
  },

  -- Visual multi
  {
    "mg979/vim-visual-multi"
  },

  -- Vim TMUX Navigator
  {
    "christoomey/vim-tmux-navigator",
  },

  -- Vim Comment
  {
    "numToStr/Comment.nvim"
  },

  -- Lspsaga
  {
    "nvimdev/lspsaga.nvim",
    config = function ()
      require("lspsaga").setup({})
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { "n", "[f", ":Lspsaga lsp_finder<cr>", "Finder" },
      { "n", "[a", ":Lspsaga code_action<cr>", "Code Action" },
      { "n", "[g", ":Lspsaga open_floaterm lazygit<cr>", "Lazygit" },
      { "n", "[o", ":Lspsaga hover_doc<cr>", "Hover doc" },
      { "n", "[s", ":Lspsaga signature_help<cr>", "Signature help" },
      { "n", "[t", ":Lspsaga outline<cr>", "Outline" },
      { "n", "[n", ":Lspsaga rename<cr>", "Rename" },
      { "n", "[N", ":Lspsaga rename ++project<cr>", "Rename project" },
      { "n", "gd", ":Lspsaga preview_definition<cr>", "Preview definition" },
      { "n", "<A-d>", ":Lspsaga term_toggle<cr>", "Toggle term" },
      { "n", "<leader>cd", ":Lspsaga show_line_diagnostics<cr>", "Show line diagnostics" },
      { "n", "<leader>cd", ":Lspsaga show_cursor_diagnostics<cr>", "Show cursor diagnostics" },
      { "n", "[b", ":Lspsaga show_buf_diagnostics<cr>", "Show buffer diagnostics" },
      { "n", "[e", ":Lspsaga diagnostic_jump_next<cr>", "Diagnostic jump next" },
      { "n", "]e", ":Lspsaga diagnostic_jump_prev<cr>", "Diagnostic jump previous" },
    },
  },
}
