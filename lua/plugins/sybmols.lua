return {
  -- nvim surround
  {
    "ur4ltz/surround.nvim",
    config = function ()
      local surround = require("surround")

      surround.setup {
        mappings_style = "surround",
      }
    end
  },

}
