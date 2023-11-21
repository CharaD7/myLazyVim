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
    }
  },
}
