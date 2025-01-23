return {
	"shortcuts/no-neck-pain.nvim",
	event = "UIEnter", -- Load when Neovim UI starts
	opts = {
		width = 100, -- Width of the centered buffer
		autocmds = {
			enableOnVimEnter = true, -- Activate on Neovim startup
			enableOnTabEnter = true, -- Activate when switching tabs
		},
		integrations = {
			NvimTree = {
				position = "left", -- Position NvimTree on the left
			},
		},
	},
	config = function(_, opts)
		require("no-neck-pain").setup(opts)
	end,
}
