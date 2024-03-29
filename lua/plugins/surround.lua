return {
  "ur4ltz/surround.nvim",
  config = function ()
    local surround = require("surround")
    surround.setup({
      context_offset = 101,
      load_autogroups = false,
      mappings_style = "sandwich",
      map_insert_mode = true,
      quotes = { "'", '"' },
      brackets = { "(", "{", "[" },
      space_on_closing_char = true,
      pairs = {
        nestable = { b = { "(", ")" }, s = { "[", "]" }, B = { "{", "}" }, a = { "<", ">" } },
        linear = { q = { "'", "'" }, t = { "`", "`" }, d = { '"', '"' } },
      },
      prefix = "/",
    })
  end
}
