
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  opts = {
    provider = "opencode", -- Reference the custom vendor declared below
    auto_suggestions_provider = "copilot",

    -- Configure your custom provider under the correct vendors table
    providers = {
      opencode = {
        __inherited_from = "openai", -- Inherit standard OpenAI API structure
        endpoint = "https://opencode.ai", -- Replace with OpenCode's actual API endpoint
        model = "opencode-model-name", -- Replace with your desired OpenCode model string
        api_key_name = "OPENCODE_API_KEY", -- Looks up os.getenv("OPENCODE_API_KEY") automatically
      },
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "anomalyco/opencode",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",

    -- Fixed: Cleanly isolated the standalone opencode initialization block
    {
      "anomalyco/opencode",
      init = function()
        vim.cmd("echo 'Initializing OpenCode...'")
      end,
    },

    -- Fixed: Repaired structural brackets around img-clip
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
