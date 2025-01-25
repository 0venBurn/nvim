-- lua/plugins/zen-mode.lua
return {
	"folke/zen-mode.nvim",
	dependencies = { "folke/twilight.nvim" },
	opts = {
		window = {
			width = 100,
			options = {
				number = true,
				relativenumber = true,
				signcolumn = "no",
			},
		},
		plugins = {
			twilight = { enabled = false },
		},
	},
	keys = {
		{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
	},
	config = function(_, opts)
		require("zen-mode").setup(opts)
		-- Auto-enable Zen Mode when opening Neovim
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.fn.argc() == 1 then
					require("zen-mode").toggle()
				end
			end,
		})
	end,
}
