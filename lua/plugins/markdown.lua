return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		file_types = { "markdown", "Avante" },
		-- Add these additional settings for better Avante compatibility
		render_modes = { "n", "c", "t" }, -- Only render in normal, command, and terminal modes
		max_file_size = 10.0, -- Limit file size to prevent performance issues
		debounce = 100, -- Add debounce to prevent rendering conflicts
	},
	ft = { "markdown", "Avante" },
}
