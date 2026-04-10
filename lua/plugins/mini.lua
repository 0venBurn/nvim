return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.statusline").setup()
		require("mini.icons").setup({
			file = {
				[".gitignore"] = { glyph = "󰒓", hl = "MiniIconsGrey" },
			},
		})
	end,
}
