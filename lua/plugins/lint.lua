return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		local eslint = lint.linters.eslint_d

		-- Function to check for ESLint config
		local function eslint_config_exists()
			local eslint_config_files = {
				".eslintrc.js",
				".eslintrc.cjs",
				".eslintrc.yaml",
				".eslintrc.yml",
				".eslintrc.json",
				"package.json",
			}
			local current_dir = vim.fn.expand("%:p:h")
			local root_dir = vim.fn.finddir(".git/..", current_dir .. ";")
			for _, config_file in ipairs(eslint_config_files) do
				if vim.fn.filereadable(root_dir .. "/" .. config_file) == 1 then
					return true
				end
			end
			return false
		end

		lint.linters_by_ft = {
			javascript = { "eslint_d", "eslint" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			ruby = { "rubocop" },
			Dockerfile = { "hadolint" },
			python = { "ruff" },
		}

		-- Configuration for Ruff
		lint.linters.ruff.cmd = "ruff"
		lint.linters.ruff.args = {
			"check",
			"--format",
			"json",
			"-",
			"--stdin-filename",
		}

		-- Existing ESLint configuration
		eslint.args = {
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
		}

		-- Modified try_lint function
		local function try_lint()
			local filetype = vim.bo.filetype
			local linters = lint.linters_by_ft[filetype] or {}

			-- Check if ESLint is one of the linters and if config exists
			if vim.tbl_contains(linters, "eslint_d") or vim.tbl_contains(linters, "eslint") then
				if not eslint_config_exists() then
					-- Remove ESLint from linters if no config file is found
					linters = vim.tbl_filter(function(linter)
						return linter ~= "eslint_d" and linter ~= "eslint"
					end, linters)
				end
			end

			-- Run remaining linters
			lint.try_lint(linters)
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = try_lint,
		})

		vim.keymap.set("n", "§", try_lint, { desc = "Trigger linting for current file" })
	end,
}
