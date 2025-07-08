return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- Never set this value to "*"! Never!
	opts = {
		provider = "copilot", -- Default provider is Copilot
		providers = {
			-- Enable Copilot provider
			copilot = {
				enabled = true,
				-- Optional: Set the model to use for Copilot
				model = "claude-3.7-sonnet", -- Fixed model name (was claude-3.7-sonnet)
			},
		},
		ask = {
			floating = true,
			start_insert = true, -- Start in insert mode
			border = "rounded", -- Use rounded borders for the floating window
		},
	},
	build = "make",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		-- Optional dependencies
		"echasnovski/mini.pick",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"ibhagwan/fzf-lua",
		"stevearc/dressing.nvim",
		"folke/snacks.nvim",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua",
		{
			-- Image pasting support
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
			-- Ensure render-markdown loads before avante
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
