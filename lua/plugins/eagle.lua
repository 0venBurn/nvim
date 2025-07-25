return {
	"soulis-1256/eagle.nvim",
	config = function()
		require("eagle").setup({
			-- Mouse mode for hover detection
			mouse_mode = true,
			-- Keyboard mode for cursor-based detection
			keyboard_mode = true,
			-- Show diagnostics and LSP info
			show_lsp_info = true,
			-- Delay before showing (in ms)
			render_delay = 500,
			detect_idle_timer = 50,
			-- Window styling
			border = "rounded",
			max_width_factor = 2,
			max_height_factor = 2.5,
		})

		-- Enable mouse movement events (required for mouse mode)
		vim.o.mousemoveevent = true

		-- Optional: keybind for manual trigger
		vim.keymap.set("n", "<Tab>", ":EagleWin<CR>", { noremap = true, silent = true })
	end,
}
