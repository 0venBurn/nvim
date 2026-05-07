-- Git integrations
return {
	-- diffview.lua
	{
		"dlyongemallo/diffview.nvim",
		version = "*",
		keys = {
			{ "<leader>div", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Open diff view" },
			{ "<leader>dic", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
		},
	},

	-- lazy-git.lua
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>sc", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
		},
	},

	-- git-blame-nvim.lua
	{
		-- https://github.com/f-person/git-blame.nvim
		"f-person/git-blame.nvim",
		cmd = "GitBlameToggle",
		keys = {
			{ "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle git blame" },
		},
		opts = {
			enabled = false,
			date_format = "%m/%d/%y %H:%M:%S",
		},
	},
}
