-- UI, statusline, picker/explorer, and visual workflow plugins
return {
	-- snacks.lua
	{
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{ "<leader>e", function() Snacks.explorer() end, desc = "Toggle file explorer" },
		{ "<leader>er", function() Snacks.explorer({ focus = true }) end, desc = "Focus file explorer" },
		{ "<leader>ef", function() Snacks.explorer({ focus = true, follow_file = true }) end, desc = "Reveal current file in explorer" },
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
		{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
		{ "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
		{ "<leader>fs", function() Snacks.picker.lines() end, desc = "Search current buffer lines" },
		{ "<leader>fo", function() Snacks.picker.lsp_symbols() end, desc = "Find document symbols" },
		{ "<leader>fi", function() Snacks.picker.lsp_references() end, desc = "Find LSP references" },
		{ "<leader>fm", function() Snacks.picker.lsp_symbols({ symbols = { "method", "function" } }) end, desc = "Find methods/functions" },
		{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find config files" },
		{ "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Find diagnostics" },
		{ "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor" },
		{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find" },
		{ "<leader>fF", function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = "Find all files" },
		{ "<leader>fG", function() Snacks.picker.grep({ hidden = true, ignored = true }) end, desc = "Live grep all files" },
		{ "<leader>gF", function() Snacks.picker.git_files() end, desc = "Find git files" },
		{ "<leader>gc", function() Snacks.picker.git_status() end, desc = "Git status picker" },
	},
	opts = {
		bigfile = { enabled = true },
		dashboard = { enabled = false },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true, sources = { files = { hidden = true, ignored = true } } },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		explorer = {
			enabled = true,
			opts = {
				auto_close = true,
				open_on_setup = false,
				tree = false,
				follow_file = false,
			},
			win = {
				wo = {
					winhighlight = "Normal:SnacksExplorerNormal",
				},
			},
		},
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
},

	-- mini.lua
	{
	"echasnovski/mini.nvim",
	config = function()
		require("mini.statusline").setup()
		require("mini.icons").setup({
			file = {
				[".gitignore"] = { glyph = "󰒓", hl = "MiniIconsGrey" },
			},
		})
	end,
},

	-- lualine.lua
	{
	"nvim-lualine/lualine.nvim",
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = "",
				section_separators = "",
			},
		})
	end,
},

	-- which-key.lua
	{
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		spec = {
			{ "<leader>b", group = "Buffers" },
			{ "<leader>d", group = "Debug/Diff" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Go/Git/LSP" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>n", group = "Harpoon/Navigation" },
			{ "<leader>q", group = "Quickfix" },
			{ "<leader>r", group = "Refactor" },
			{ "<leader>s", group = "Splits" },
			{ "<leader>t", group = "Tabs/Tests" },
			{ "<leader>w", group = "Write/Quit" },
			{ "<leader>x", group = "Execute/REST" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
},

	-- zen.lua
	{
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
},

	-- fidget.lua
	{
	"j-hui/fidget.nvim",
	opts = {
		-- Your options here
	},
}
}
