return {
	"r-pletnev/pdfreader.nvim",
  cmd = "PdfReader",
	dependencies = {
		"folke/snacks.nvim",
	},
	config = function()
		require("pdfreader").setup()
	end,
}
