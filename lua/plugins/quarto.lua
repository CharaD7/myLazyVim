return {
  { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
    -- for complete functionality (language features)
    'quarto-dev/quarto-nvim',
    ft = { 'quarto' },
    dev = false,
    opts = {
      lspFeatures = {
        languages = {"python", "markdown"},
        chunks = "all",
        diagnostics = {
          enabled = true,
          triggers = {"BufWritePost"},
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    keys = {
      { ';qp', ':QuartoPreview<cr>', desc = 'Quarto Preview' },
      { ';qc', ':QuartoClosePreview<cr>', desc = 'Quarto Close Preview' },
      { ';qa', ':QuartoActivate<cr>', desc = 'Quarto Activate' },
      { ';qd', ':QuartoDiagnostics<cr>', desc = 'Quarto Diagnostics' },
      { ';qs', ':QuartoSend<cr>', desc = 'Quarto Send' },
      { ';qSa', ':QuartoSendAbove<cr>', desc = 'Quarto Send Above' },
      { ';qSb', ':QuartoSendBelow<cr>', desc = 'Quarto Send Below' },
      { ';qSA', ':QuartoSendAll<cr>', desc = 'Quarto Send All' },
      { ';qSl', ':QuartoSendLine<cr>', desc = 'Quarto Send Line' },
    },
    dependencies = {
      -- for language features in code cells
      -- configured in lua/plugins/lsp.lua and
      -- added as a nvim-cmp source in lua/plugins/completion.lua
      {
        'jmbuhr/otter.nvim',
        dependencies = {
          'nvim-treesitter/nvim-treesitter'
        },
        opts = {}
      },
    },
    config = function()
      local runner = require("quarto.runner")
      vim.keymap.set("n", ";rc", runner.run_cell,  { desc = "Run Cell", silent = true })
      vim.keymap.set("n", ";ra", runner.run_above, { desc = "Run Cell and Above", silent = true })
      vim.keymap.set("n", ";rA", runner.run_all,   { desc = "Run All Cells", silent = true })
      vim.keymap.set("n", ";rl", runner.run_line,  { desc = "Run Line", silent = true })
      vim.keymap.set("v", ";rr", runner.run_range, { desc = "Run Visual Range", silent = true })
      vim.keymap.set("n", ";rL", function()
        runner.run_all(true)
      end, { desc = "Run All Cells of All Languages", silent = true })
    end
  },

  { -- directly open ipynb files as quarto docuements
    -- and convert back behind the scenes
    'GCBallesteros/jupytext.nvim',
    opts = {
      custom_language_formatting = {
        python = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto',
        },
        r = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto',
        },
      },
    },
  },

  { -- paste an image from the clipboard or drag-and-drop
    'HakonHarnes/img-clip.nvim',
    event = 'BufEnter',
    ft = { 'markdown', 'quarto', 'latex' },
    opts = {
      default = {
        dir_path = 'img',
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = '![$CURSOR]($FILE_PATH)',
          drag_and_drop = {
            download_images = false,
          },
        },
        quarto = {
          url_encode_path = true,
          template = '![$CURSOR]($FILE_PATH)',
          drag_and_drop = {
            download_images = false,
          },
        },
      },
    },
    config = function(_, opts)
      require('img-clip').setup(opts)
      vim.keymap.set('n', '<leader>ii', ':PasteImage<cr>', { desc = 'Insert image from clipboard' })
    end,
  },

}

