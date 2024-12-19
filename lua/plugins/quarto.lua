return {
  { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
    -- for complete functionality (language features)
    'quarto-dev/quarto-nvim',
    ft = { 'quarto' },
    dev = false,
    opts = {
      lspFeatures = {
        languages = {"python", "markdown", "html"},
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
        ft_runners = {
          python = 'molten',
          markdown = 'molten',
          html = 'molten',
        },
      },
    },
    keys = {
      { ';qp', ':QuartoPreview<cr>', desc = 'Quarto Preview' },
      { ';qc', ':QuartoClosePreview<cr>', desc = 'Quarto Close Preview' },
      { ';qa', ':QuartoActivate<cr>', desc = 'Quarto Activate' },
      -- { ';qd', ':QuartoDiagnostics<cr>', desc = 'Quarto Diagnostics' },
      -- { ';qs', ':QuartoSend<cr>', desc = 'Quarto Send' },
      -- { ';qSa', ':QuartoSendAbove<cr>', desc = 'Quarto Send Above' },
      -- { ';qSb', ':QuartoSendBelow<cr>', desc = 'Quarto Send Below' },
      -- { ';qSA', ':QuartoSendAll<cr>', desc = 'Quarto Send All' },
      -- { ';qSl', ':QuartoSendLine<cr>', desc = 'Quarto Send Line' },
    },
    dependencies = {
      -- for language features in code cells
      -- configured in lua/plugins/lsp.lua and
      -- added as a nvim-cmp source in lua/plugins/completion.lua
      'jmbuhr/otter.nvim',
      'nvim-treesitter/nvim-treesitter',
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
    config = true,
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

  { -- send code from python/r/qmd documents to a terminal or REPL
    -- like ipython, R, bash
    'jpalardy/vim-slime',
    dev = false,
    init = function()
      vim.b['quarto_is_python_chunk'] = false
      Quarto_is_in_python_chunk = function()
        require('otter.tools.functions').is_otter_language_context 'python'
      end

      vim.cmd [[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
      return [a:text, "\n"]
      else
      return [a:text]
      end
      end
      endfunction
      ]]

      vim.g.slime_target = 'neovim'
      vim.g.slime_no_mappings = true
      vim.g.slime_python_ipython = 1
    end,
    config = function()
      vim.g.slime_input_pid = false
      vim.g.slime_suggest_default = true
      vim.g.slime_menu_config = false
      vim.g.slime_neovim_ignore_unlisted = true

      local function mark_terminal()
        local job_id = vim.b.terminal_job_id
        vim.print('job_id: ' .. job_id)
      end

      local function set_terminal()
        vim.fn.call('slime#config', {})
      end
      vim.keymap.set('n', '<leader>cm', mark_terminal, { desc = '[m]ark terminal' })
      vim.keymap.set('n', '<leader>cs', set_terminal, { desc = '[s]et terminal' })
    end,
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

  { -- preview equations
    'jbyuki/nabla.nvim',
    keys = {
      { '<leader>qm', ':lua require"nabla".toggle_virt()<cr>', desc = 'toggle [m]ath equations' },
    },
  },

  {
    'benlubas/molten-nvim',
    enabled = true,
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    keys = {
      { "<leader>me", ":MoltenEvaluateOperator<cr>", desc = "Evaluate Operator" },
      { "<leader>mo", ":noautocmd MoltenEnterOutput<cr>", desc = "Open Output Window" },
      { "<leader>mr", ":MoltenReevaluateCell<cr>", desc = "Re-evaluate Cell" },
      { "<leader>mv", ":MoltenEvaluateVisual<cr>gv", mode = "v", desc = "Evaluate Visual Selection" },
      { "<leader>mh", ":MoltenHideOutput<cr>", desc = "Close Output Window" },
      { "<leader>md", ":MoltenDelete<cr>", desc = "Delete Molten Cell" },
      -- The below works for html outputs
      { "<leader>mb", ":MoltenOpenInBrowser<cr>", desc = "Open Output in Browser" },
      { '<leader>mi', ':MoltenInit<cr>', desc = 'Molten Init' },
    },
  },

}

