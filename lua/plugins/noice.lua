return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- Disable fancy notifications from nvim-notify
			notify = {
				enabled = false, -- Disable notifications
			},
			-- Other noice.nvim configurations (optional)
			presets = {
				-- Use a classic bottom cmdline for search
				command_palette = true, -- Enable command palette
				long_message_to_split = true, -- Split long messages
				lsp_doc_border = true, -- Add a border to hover docs
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim", -- Required dependency for noice.nvim
		},
	},
}
