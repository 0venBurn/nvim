return {
	"github/copilot.vim",
	event = "VeryLazy", -- Load the plugin lazily
	config = function()
		-- Configuration for copilot.vim
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_assume_mapped = true
		vim.g.copilot_tab_fallback = ""
	end,
}
