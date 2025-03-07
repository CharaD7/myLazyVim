return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- this is what you want to see
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false, -- only works on Linux
      },
      window = {
        mappings = {
          ['A'] = 'easy',
        }
      },
      commands = {
        ["easy"] = function(state)
          local node = state.tree:get_node()
          local path = node.type == "directory" and node.path or vim.fs.dirname(node.path)
          require("easy-dotnet").create_new_item(path, function()
            require("neo-tree.sources.manager").refresh(state.name)
          end)
        end
      }
    },
  },
}
