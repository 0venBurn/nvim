-- File Explorer / Tree
return {
	-- https://github.com/nvim-tree/nvim-tree.lua
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		-- https://github.com/nvim-tree/nvim-web-devicons
		"nvim-tree/nvim-web-devicons", -- Fancy icon support
	},
	opts = {
		actions = {
			open_file = {
				window_picker = {
					enable = false,
				},
			},
		},
		view = {
			float = {
				enable = true,
				open_win_config = {
					relative = "editor",
					width = 50,
					height = 30,
					row = (vim.o.lines - 30) / 2,
					col = (vim.o.columns - 50) / 2,
					border = "rounded",
				},
			},
		},
	},
	config = function(_, opts)
		-- Recommended settings to disable default netrw file explorer
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		require("nvim-tree").setup(opts)
	end,
}
