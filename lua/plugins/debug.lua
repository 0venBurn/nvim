-- Debug adapter protocol UI and helpers
return {
	-- nvim-dap-ui.lua
	{
	"rcarriga/nvim-dap-ui",
	event = "VeryLazy",
	dependencies = {
		{
			"julianolf/nvim-dap-lldb",
			dependencies = { "mfussenegger/nvim-dap" },
			config = function()
				require("dap-lldb").setup({
					configurations = {
						cpp = {
							{
								name = "Launch C++ Debug",
								type = "lldb",
								request = "launch",
								program = function()
									return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
								end,
								cwd = "${workspaceFolder}",
								stopOnEntry = false,
								args = {},
								runInTerminal = false,
							},
						},
						c = {
							{
								name = "Launch C Debug",
								type = "lldb",
								request = "launch",
								program = function()
									return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
								end,
								cwd = "${workspaceFolder}",
								stopOnEntry = false,
								args = {},
								runInTerminal = false,
							},
						},
						rust = {
							{
								name = "Launch Rust Debug",
								type = "lldb",
								request = "launch",
								program = function()
									return vim.fn.input(
										"Path to executable: ",
										vim.fn.getcwd() .. "/target/debug/",
										"file"
									)
								end,
								cwd = "${workspaceFolder}",
								stopOnEntry = false,
								args = {},
								runInTerminal = false,
							},
						},
					},
				})
			end,
		},
		"mfussenegger/nvim-dap-python",
		"leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},
	keys = {
		{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
		{ "<leader>dB", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "DAP set log breakpoint" },
		{ "<leader>dR", function() require("dap").clear_breakpoints() end, desc = "DAP clear breakpoints" },
		{ "<leader>dc", function() require("dap").continue() end, desc = "DAP continue" },
		{ "<leader>dj", function() require("dap").step_over() end, desc = "DAP step over" },
		{ "<leader>dk", function() require("dap").step_into() end, desc = "DAP step into" },
		{ "<leader>do", function() require("dap").step_out() end, desc = "DAP step out" },
		{ "<leader>dd", function() require("dap").disconnect(); require("dapui").close() end, desc = "DAP disconnect" },
		{ "<leader>dt", function() require("dap").terminate(); require("dapui").close() end, desc = "DAP terminate" },
		{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "DAP REPL toggle" },
		{ "<leader>dl", function() require("dap").run_last() end, desc = "DAP run last" },
		{ "<leader>di", function() require("dap.ui.widgets").hover() end, desc = "DAP inspect" },
		{ "<leader>d?", function() local widgets = require("dap.ui.widgets"); widgets.centered_float(widgets.scopes) end, desc = "DAP scopes" },
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
		require("dapui").setup(opts)

		local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy"
		local debugpy_python = mason_debugpy .. "/venv/bin/python"
		if vim.fn.executable(debugpy_python) == 0 then
			debugpy_python = vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or vim.fn.exepath("python")
		end
		require("dap-python").setup(debugpy_python)

		local debugpy_adapter = mason_debugpy .. "/debugpy-adapter"
		if vim.fn.executable(debugpy_adapter) == 1 then
			dap.adapters.python = {
				type = "executable",
				command = debugpy_adapter,
			}
		end

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
			},
		}
		local dlv_path = vim.fn.stdpath("data") .. "/mason/bin/dlv"
		require("dap-go").setup({
			delve = {
				path = vim.fn.executable(dlv_path) == 1 and dlv_path or "dlv",
			},
		})

		dap.configurations.go = {
			{
				type = "go",
				name = "Debug",
				request = "launch",
				program = "${file}",
			},
		}

		dap.listeners.after.event_initialized["dapui_config"] = function()
			require("dapui").open()
		end

		dap.listeners.before.event_terminated["dapui_config"] = function()
			-- Commented to prevent DAP UI from closing when unit tests finish
			-- require('dapui').close()
		end

		dap.listeners.before.event_exited["dapui_config"] = function()
			-- Commented to prevent DAP UI from closing when unit tests finish
			-- require('dapui').close()
		end

		-- Add dap configurations based on your language/adapter settings
		-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
		--

		dap.configurations.java = {
			{
				name = "Debug Launch (2GB)",
				type = "java",
				request = "launch",
				vmArgs = "" .. "--enable-preview -Xmx2g ",
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
		}
	end,
},

	-- nvim-dap-virtual-text.lua
	{
  -- https://github.com/theHamsta/nvim-dap-virtual-text
  'theHamsta/nvim-dap-virtual-text',
  lazy = true,
  opts = {
    -- Display debug text as a comment
    commented = true,
    -- Customize virtual text
    display_callback = function(variable, buf, stackframe, node, options)
      if options.virt_text_pos == 'inline' then
        return ' = ' .. variable.value
      else
        return variable.name .. ' = ' .. variable.value
      end
    end,
  }
}
}
