-- Debugging Support
return {
	"rcarriga/nvim-dap-ui",
	event = "VeryLazy",
	dependencies = {
		"mfussenegger/nvim-dap",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-telescope/telescope-dap.nvim",
		"leoluz/nvim-dap-go",
		"suketa/nvim-dap-ruby",
		"mfussenegger/nvim-dap-python",
		{
			"julianolf/nvim-dap-lldb",
			dependencies = { "mfussenegger/nvim-dap" },
			opts = {
				codelldb_path = function()
					-- Find your Mason installation path
					local mason_registry = require("mason-registry")
					local codelldb = mason_registry.get_package("codelldb")
					return codelldb:get_install_path() .. "/extension/adapter/codelldb"
				end,
			},
		},
	},

	opts = {
		controls = {
			element = "repl",
			enabled = false,
			icons = {
				disconnect = "",
				pause = "",
				play = "",
				run_last = "",
				step_back = "",
				step_into = "",
				step_out = "",
				step_over = "",
				terminate = "",
			},
		},
		element_mappings = {},
		expand_lines = true,
		floating = {
			border = "single",
			mappings = {
				close = { "q", "<Esc>" },
			},
		},
		force_buffers = true,
		icons = {
			collapsed = "",
			current_frame = "",
			expanded = "",
		},
		layouts = {
			{
				elements = {
					{
						id = "scopes",
						size = 0.50,
					},
					{
						id = "stacks",
						size = 0.30,
					},
					{
						id = "watches",
						size = 0.10,
					},
					{
						id = "breakpoints",
						size = 0.10,
					},
				},
				size = 40,
				position = "left", -- Can be "left" or "right"
			},
			{
				elements = {
					"repl",
					"console",
				},
				size = 10,
				position = "bottom", -- Can be "bottom" or "top"
			},
		},
		mappings = {
			edit = "e",
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			repl = "r",
			toggle = "t",
		},
		render = {
			indent = 1,
			max_value_lines = 100,
		},
	},
	config = function(_, opts)
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup(opts)

		-- Python setup
		local dap_python = require("dap-python")
		dap_python.setup("python") -- Adjust this path if needed
		dap_python.test_runner = "pytest"

		-- Go setup
		require("dap-go").setup()

		-- Ruby setup
		require("dap-ruby").setup()
		require("dap-lldb").setup(opts)

		-- Java Configuration
		dap.configurations.java = {
			{
				name = "Debug Launch (2GB)",
				type = "java",
				request = "launch",
				vmArgs = "-Xmx2g",
			},
			{
				name = "Debug Attach (8000)",
				type = "java",
				request = "attach",
				hostName = "127.0.0.1",
				port = 8000,
			},
			{
				name = "Debug Attach (5005)",
				type = "java",
				request = "attach",
				hostName = "127.0.0.1",
				port = 5005,
			},
			{
				name = "My Custom Java Run Configuration",
				type = "java",
				request = "launch",
				mainClass = "replace.with.your.fully.qualified.MainClass",
				vmArgs = "-Xmx2g",
			},
		}

		-- DAP UI Listeners
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			-- Commented to prevent DAP UI from closing when unit tests finish
			-- dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			-- Commented to prevent DAP UI from closing when unit tests finish
			-- dapui.close()
		end

		-- Python-specific mappings
		vim.keymap.set("n", "<leader>dn", dap_python.test_method, { desc = "Debug nearest Python test" })
		vim.keymap.set("n", "<leader>df", dap_python.test_class, { desc = "Debug Python test class" })
		vim.keymap.set("v", "<leader>ds", dap_python.debug_selection, { desc = "Debug Python selection" })
	end,
}
