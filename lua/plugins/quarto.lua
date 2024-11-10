return {
  "quarto-dev/quarto-nvim",
  dependencies = {
    "jmbuhr/otter.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local function markdown_codeblock(language, content)
        return '\\`\\`\\`{' .. language .. '}\n' .. content .. '\n\\`\\`\\`'
    end

    local quarto_notebook_cmd = 'nvim -c enew -c "set filetype=quarto"' ..
    ' -c "norm GO## IPython\nThis is Quarto IPython notebook. Syntax is the same as in markdown\n\n' .. markdown_codeblock('python', '# enter code here\n') .. '"' ..
    ' -c "norm Gkk"' ..
    -- This line needed because QuartoActivate and MoltenInit commands must be accessible; should be adjusted depending on plugin manager
    " -c \"lua require('lazy.core.loader').load({'molten-nvim', 'quarto-nvim'}, {cmd = 'Lazy load'})\"" ..
    ' -c "MoltenInit python3" -c QuartoActivate -c startinsert'
    require("quarto").setup({
      lspFeatures = {
        enabled = true,
        chunks = "curly",
        languages = { "r", "python", "jupyter" },
      },
      codeRunner = {
        enabled = false,
        default_method = 'molten',
        ft_runners = {
          python = "molten",
        }
      },
    })
  end,
  keys = {
    {"<leader>qr", ":lua require('quarto.runner').run_cell()<cr>", desc = "Run Cell"},
    {"<leader>qa", ":lua require('quarto.runner).run_above()<cr>", desc = "Run Cell and Above"},
    {"<leader>qA", ":lua require('quarto.runner).run_all()<cr>", desc = "Run All Cells"},
    {"<leader>ql", ":lua require('quarto.runner).run_line()<cr>", desc = "Run Line"},
    {"<leader>qv", ":lua require('quarto.runner).run_range()<cr>", desc = "Run Visual Range"},
    {"<leader>RA", ":lua require('quarto.runner').run_all(true)<cr>", desc = "Run All Cells of All Languages"},
    {
      "<C-p>",
      ":lua require('toggleterm.terminal').Terminal:new({ cmd = 'python3', hidden = true, direction = 'float' }):toggle()<cr>",
      desc = "Toggle quarto python terminal"
    }
  },
  opts = {
    ft = { "quarto", "markdown" },
  },
}
