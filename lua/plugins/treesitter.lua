return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "astro",
      "cmake",
      "css",
      "fish",
      "gitignore",
      "php",
      "go",
      "http",
      "rust",
      "scss",
      "typescript",
      "svelte",
      "solidity",
      "python",
      "lua",
      "json",
      "vim",
      "vue"
    },
    -- MDX
    vim.filetype.add({
      extension = {
        mdx = "mdx",
      }
    }),
    vim.treesitter.language.register("markdown", "mdx"),
  },
  highlight = {
    enable = true,
  },
  textobjects = {
    move = {
      enable = true,
      set_jumps = false,
      goto_next_start = {
        -- other keymaps
        ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
      },
      goto_previous_start = {
        -- other keymaps
        ["]b"] = { query = "@code_cell.inner", desc = "previous code block"},
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ib"] = { query = "@code_cell.inner", desc = "in block" },
        ["ab"] = { query = "@code_cell.inner", desc = "around block" },
      },
    },
    swap = { -- swap only works with code blocks that are under the same markdonw header
      enable = true,
      swap_next = {
        -- other keymaps
        ["<leader>sbl"] = "@code_cell.inner",
      },
      swap_previous = {
        -- other keymaps
        ["<leader>sbh"] = "@code_cell.inner",
      },
    },
  },
}
