return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- Enable core plugins
		bigfile = { enabled = true },
		dashboard = { enabled = false },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true, sources = { files = { hidden = true, ignored = true } } },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		explorer = {
			enabled = true,
			opts = {
				auto_close = true,
				open_on_setup = false,
				tree = false,
				follow_file = false,
			},
		},
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
}
