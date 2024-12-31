return {
	"Exafunction/codeium.vim",
	event = "BufEnter",
	config = function()
		-- Keybinding to accept Codeium suggestion
		vim.g.codeium_no_map_tab = 1
		vim.keymap.set("i", "<C-a>", function()
			return vim.fn["codeium#Accept"]()
		end, { expr = true, silent = true, desc = "Codeium Accept" })

		-- Keybinding to clear Codeium suggestion
		vim.keymap.set("i", "<C-x>", function()
			return vim.fn["codeium#Clear"]()
		end, { expr = true, silent = true, desc = "Codeium Clear" })

		-- Keybinding to cycle through Codeium completions
		vim.keymap.set("i", "<C-]>", function()
			return vim.fn["codeium#CycleCompletions"](1)
		end, { expr = true, silent = true, desc = "Codeium Cycle Completions Next" })

		-- Keybinding to toggle Codeium on and off
		vim.keymap.set("n", "<leader>ct", function()
			if vim.g.codeium_enabled == 1 then
				vim.g.codeium_enabled = 0
				print("Codeium disabled")
			else
				vim.g.codeium_enabled = 1
				print("Codeium enabled")
			end
		end, { desc = "Toggle Codeium" })

		-- Disable Codeium for specific filetypes
		vim.g.codeium_filetypes = {
			markdown = false,
		}

		-- Initialize Codeium as enabled by default
		vim.g.codeium_enabled = 1
	end,
}
