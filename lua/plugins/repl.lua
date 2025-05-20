return {
	"pappasam/nvim-repl",
	init = function()
		vim.g["repl_filetype_commands"] = {
			bash = "bash",
			javascript = "node",
			haskell = "ghci",
			ocaml = { cmd = "utop", suffix = ";;" },
			python = "ipython --no-autoindent",
			r = "R",
			sh = "sh",
			vim = "nvim --clean -ERM",
			zsh = "zsh",
		}
	end,
	keys = {
		{ "<Leader>rn", "<Cmd>ReplNewCell<CR>", mode = "n", desc = "Create New Cell" },
		{ "<Leader>ro", "<Cmd>ReplOpen<CR>", mode = "n", desc = "Create New Cell" },
		{ "<Leader>rs", "<Plug>(ReplSendCell)", mode = "n", desc = "Send Repl Cell" },
		{ "<Leader>r", "<Plug>(ReplSendLine)", mode = "n", desc = "Send Repl Line" },
		{ "<Leader>r", "<Plug>(ReplSendVisual)", mode = "v", desc = "Send Repl Visual Selection" },
	},
}
