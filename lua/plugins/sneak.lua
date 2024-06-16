return {
	{
		"justinmk/vim-sneak",
		config = function()
			-- Optional: You can add custom configuration for sneak here
			vim.g["sneak#label"] = 1 -- Example: Enable sneak labels
			-- You can also customize key bindings if needed
			-- For example, to change the default binding from `s` to `S`:
			-- vim.api.nvim_set_keymap('n', 'S', '<Plug>Sneak_s', {})
			-- vim.api.nvim_set_keymap('n', 's', '', {}) -- unbind default `s`
		end,
	},
}
