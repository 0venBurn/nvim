-- AI/CLI assistant integrations
return {
	-- sidekick.lua
	{
		"folke/sidekick.nvim",
		opts = {
			nes = {
				enabled = false,
			},
			cli = {
				mux = {
					backend = "tmux",
					enabled = true,
				},
			},
		},
		keys = {
			{
				"<c-.>",
				function()
					require("sidekick.cli").focus()
				end,
				desc = "Sidekick Focus",
				mode = { "n", "t", "i", "x" },
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function()
					require("sidekick.cli").select()
				end,
				-- Or to select only installed tools:
				-- require("sidekick.cli").select({ filter = { installed = true } })
				desc = "Select CLI",
			},
			{
				"<leader>ad",
				function()
					require("sidekick.cli").close()
				end,
				desc = "Detach a CLI Session",
			},
			{
				"<leader>at",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>af",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Send File",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			-- Example of a keybinding to open Claude directly
			{
				"<leader>ac",
				function()
					require("sidekick.cli").toggle({ name = "claude", focus = true })
				end,
				desc = "Sidekick Toggle Claude",
			},
		},
	},
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<C-]>",
					clear_suggestion = "<C-j>",
				},
			})

			-- Keep Supermaven off by default; <leader>so turns it on.
			require("supermaven-nvim.api").stop()
		end,
		keys = {
			{
				"<leader>so",
				function()
					local api = require("supermaven-nvim.api")

					if api.is_running() then
						api.stop()
						vim.notify("Supermaven off", vim.log.levels.INFO)
					else
						api.start()
						vim.notify("Supermaven on", vim.log.levels.INFO)
					end
				end,
				desc = "Toggle Supermaven",
			},
		},
	},
}
