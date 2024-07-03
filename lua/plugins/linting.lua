return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		local eslint = lint.linters.eslint_d

		-- Path to your Python virtual environment
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			go = { "revive" },
			ruby = { "rubocop" },
			python = { "ruff" },
			Dockerfile = { "hadolint" },
		}

		require("lint").linters.pylint.cmd = "python"
		require("lint").linters.pylint.args = { "-m", "ruff", "-f", "json" }

		-- Configure eslint
		eslint.args = {
			"--no-warn-ignored",
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
		}

		-- Set up autocommands
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		-- Set up key mapping to manually trigger linting
		vim.keymap.set("n", "<leader>Li", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
