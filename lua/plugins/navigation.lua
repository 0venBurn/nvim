-- Navigation integrations
return {
	-- harpoon.lua
	{
		-- https://github.com/ThePrimeagen/harpoon
		"ThePrimeagen/harpoon",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{
				"<leader>na",
				function()
					require("harpoon.mark").add_file()
				end,
				desc = "Harpoon add file",
			},
			{
				"<leader>nh",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				desc = "Harpoon quick menu",
			},
			{
				"<leader>n1",
				function()
					require("harpoon.ui").nav_file(1)
				end,
				desc = "Harpoon file 1",
			},
			{
				"<leader>n2",
				function()
					require("harpoon.ui").nav_file(2)
				end,
				desc = "Harpoon file 2",
			},
			{
				"<leader>n3",
				function()
					require("harpoon.ui").nav_file(3)
				end,
				desc = "Harpoon file 3",
			},
			{
				"<leader>n4",
				function()
					require("harpoon.ui").nav_file(4)
				end,
				desc = "Harpoon file 4",
			},
			{
				"<leader>n5",
				function()
					require("harpoon.ui").nav_file(5)
				end,
				desc = "Harpoon file 5",
			},
		},
		opts = {
			menu = {
				width = 120,
			},
		},
	},

	-- tmux.lua
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
}
