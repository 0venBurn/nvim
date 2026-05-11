local M = {}

M.config = {
	-- File runners are for quick scripts/scratch files.
	runners = {
		python = { "python3", "$file" },
		go = { "go", "run", "$file" },
		typescript = { "tsx", "$file" },
		javascript = { "node", "$file" },
		odin = { "odin", "run", "$file" },
	},
	width = 0.85,
	height = 0.8,
}

local state = {
	win = nil,
	buf = nil,
	job = nil,
	last = nil,
}

local function close_float()
	if state.job then
		vim.fn.jobstop(state.job)
		state.job = nil
	end
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
	end
	state.win = nil
end

local function append(lines)
	if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
		return
	end

	-- nvim_buf_set_lines requires every item to be a string. Some callers use
	-- conditional entries (for example cwd), which can produce nil table items.
	local clean = {}
	for _, line in ipairs(lines) do
		if line ~= nil then
			table.insert(clean, tostring(line))
		end
	end

	if #clean == 0 then
		return
	end
	-- job callbacks can include a final empty line; avoid adding noise.
	if #clean == 1 and clean[1] == "" then
		return
	end
	vim.api.nvim_buf_set_option(state.buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(state.buf, -1, -1, false, clean)
	vim.api.nvim_buf_set_option(state.buf, "modifiable", false)
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_set_cursor(state.win, { vim.api.nvim_buf_line_count(state.buf), 0 })
	end
end

local function open_float(title)
	close_float()

	state.buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(state.buf, "Run Output")
	vim.api.nvim_buf_set_option(state.buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(state.buf, "filetype", "run-output")

	local width = math.floor(vim.o.columns * M.config.width)
	local height = math.floor(vim.o.lines * M.config.height)
	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
		title = " " .. title .. " ",
		title_pos = "center",
	})

	vim.keymap.set("n", "q", close_float, { buffer = state.buf, silent = true, desc = "Close run output" })
	vim.keymap.set("n", "<Esc>", close_float, { buffer = state.buf, silent = true, desc = "Close run output" })
	vim.api.nvim_buf_set_option(state.buf, "modifiable", false)
end

local function expand_command(command, file)
	if type(command) == "function" then
		command = command(file)
	end

	if type(command) == "string" then
		return command:gsub("%$file", vim.fn.shellescape(file))
	end

	local expanded = {}
	for _, part in ipairs(command) do
		table.insert(expanded, part == "$file" and file or part)
	end
	return expanded
end

local function cmd_to_string(cmd)
	return type(cmd) == "table" and table.concat(cmd, " ") or cmd
end

local function split_cli_args(args)
	local result = {}
	local current = {}
	local quote = nil
	local escape = false

	for i = 1, #args do
		local char = args:sub(i, i)
		if escape then
			table.insert(current, char)
			escape = false
		elseif char == "\\" then
			escape = true
		elseif quote then
			if char == quote then
				quote = nil
			else
				table.insert(current, char)
			end
		elseif char == "'" or char == '"' then
			quote = char
		elseif char:match("%s") then
			if #current > 0 then
				table.insert(result, table.concat(current))
				current = {}
			end
		else
			table.insert(current, char)
		end
	end

	if escape then
		table.insert(current, "\\")
	end
	if quote then
		return nil, "unclosed quote"
	end
	if #current > 0 then
		table.insert(result, table.concat(current))
	end
	return result
end

local function add_cli_args(cmd, args)
	if not args or args == "" then
		return cmd
	end

	if type(cmd) == "string" then
		return cmd .. " " .. args
	end

	local extra_args, err = split_cli_args(args)
	if not extra_args then
		vim.notify("Invalid CLI args: " .. err, vim.log.levels.ERROR)
		return nil
	end

	local expanded = vim.deepcopy(cmd)
	if expanded[1] == "npm" and expanded[2] == "run" then
		table.insert(expanded, "--")
	end
	for _, arg in ipairs(extra_args) do
		table.insert(expanded, arg)
	end
	return expanded
end

local start_command

local function prompt_and_start(cmd, title, cwd, cli_args)
	local function run_with_args(args)
		local expanded = add_cli_args(cmd, args)
		if expanded then
			start_command(expanded, title, cwd)
		end
	end

	if cli_args ~= nil then
		run_with_args(cli_args)
		return
	end

	vim.ui.input({ prompt = title .. " args: ", default = "" }, function(args)
		if args == nil then
			return
		end
		run_with_args(args)
	end)
end

local function find_upward(names, start)
	local dir = vim.fs.dirname(start ~= "" and start or vim.fn.getcwd())
	local found = vim.fs.find(names, { upward = true, path = dir })[1]
	return found and vim.fs.dirname(found) or nil
end

local function read_json(path)
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return nil
	end
	local ok_decode, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
	return ok_decode and decoded or nil
end

local function package_json_command(root, preferred_scripts)
	local package = read_json(root .. "/package.json")
	local scripts = package and package.scripts or {}
	for _, script in ipairs(preferred_scripts) do
		if scripts[script] then
			return { "npm", "run", script }
		end
	end
	return nil
end

local function current_file()
	local file = vim.fn.expand("%:p")
	if file == "" then
		vim.notify("No file to run", vim.log.levels.WARN)
		return nil
	end
	if vim.bo.modified then
		vim.cmd.write()
	end
	return file
end

start_command = function(cmd, title, cwd, remember)
	if not cmd then
		return
	end
	open_float(title .. " (q to close)")
	append({ "$ " .. cmd_to_string(cmd), cwd and ("cwd: " .. cwd) or nil, "" })

	if remember ~= false then
		state.last = { cmd = cmd, title = title, cwd = cwd }
	end

	state.job = vim.fn.jobstart(cmd, {
		cwd = cwd,
		stdout_buffered = false,
		stderr_buffered = false,
		on_stdout = function(_, data)
			vim.schedule(function()
				append(data)
			end)
		end,
		on_stderr = function(_, data)
			vim.schedule(function()
				append(data)
			end)
		end,
		on_exit = function(_, code)
			vim.schedule(function()
				append({ "", "[process exited with code " .. code .. "]" })
				state.job = nil
			end)
		end,
	})

	if state.job <= 0 then
		append({ "Failed to start runner" })
		state.job = nil
	end
end

function M.run_current_file(cli_args)
	local file = current_file()
	if not file then
		return
	end

	local ft = vim.bo.filetype
	local runner = M.config.runners[ft]
	if not runner then
		vim.notify("No runner configured for filetype: " .. ft, vim.log.levels.WARN)
		return
	end

	prompt_and_start(expand_command(runner, file), "Run file: " .. vim.fn.fnamemodify(file, ":t"), nil, cli_args)
end

function M.run_package(cli_args)
	local file = current_file()
	if not file then
		return
	end
	local dir = vim.fs.dirname(file)
	local ft = vim.bo.filetype
	local cmd

	if ft == "go" then
		cmd = { "go", "run", "." }
	elseif ft == "python" then
		cmd = { "python3", "-m", vim.fn.fnamemodify(dir, ":t") }
	elseif ft == "typescript" or ft == "javascript" then
		cmd = { "npm", "run", "dev" }
	elseif ft == "odin" then
		cmd = { "odin", "run", "." }
	end

	if not cmd then
		vim.notify("No package runner configured for filetype: " .. ft, vim.log.levels.WARN)
		return
	end
	prompt_and_start(cmd, "Run package", dir, cli_args)
end

function M.run_project(cli_args)
	local file = current_file()
	if not file then
		return
	end
	local ft = vim.bo.filetype
	local root = find_upward(
		{ "go.mod", "package.json", "pyproject.toml", "setup.py", "requirements.txt", "ols.json", ".git" },
		file
	) or vim.fs.dirname(file)
	local cmd

	if ft == "go" then
		cmd = { "go", "run", "." }
	elseif ft == "typescript" or ft == "javascript" then
		cmd = package_json_command(root, { "dev", "start" }) or { "npm", "run", "dev" }
	elseif ft == "python" then
		cmd = { "python3", "-m", vim.fn.fnamemodify(root, ":t") }
	elseif ft == "odin" then
		cmd = { "odin", "run", "." }
	end

	if not cmd then
		vim.notify("No project runner configured for filetype: " .. ft, vim.log.levels.WARN)
		return
	end
	prompt_and_start(cmd, "Run project", root, cli_args)
end

function M.run_tests(cli_args)
	local file = current_file()
	if not file then
		return
	end
	local ft = vim.bo.filetype
	local root = find_upward(
		{ "go.mod", "package.json", "pyproject.toml", "setup.py", "requirements.txt", "ols.json", ".git" },
		file
	) or vim.fs.dirname(file)
	local cmd

	if ft == "go" then
		cmd = { "go", "test", "./..." }
	elseif ft == "typescript" or ft == "javascript" then
		cmd = package_json_command(root, { "test" }) or { "npm", "test" }
	elseif ft == "python" then
		cmd = { "pytest" }
	elseif ft == "odin" then
		cmd = { "odin", "test", "." }
	end

	if not cmd then
		vim.notify("No test runner configured for filetype: " .. ft, vim.log.levels.WARN)
		return
	end
	prompt_and_start(cmd, "Run tests", root, cli_args)
end

function M.run_last()
	if not state.last then
		vim.notify("No previous run command", vim.log.levels.WARN)
		return
	end
	start_command(state.last.cmd, state.last.title, state.last.cwd, false)
end

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	vim.api.nvim_create_user_command("RunFile", function(opts)
		M.run_current_file(opts.args ~= "" and opts.args or nil)
	end, { nargs = "*", desc = "Run current file in a floating window" })
	vim.api.nvim_create_user_command("RunPackage", function(opts)
		M.run_package(opts.args ~= "" and opts.args or nil)
	end, { nargs = "*", desc = "Run current package/directory in a floating window" })
	vim.api.nvim_create_user_command("RunProject", function(opts)
		M.run_project(opts.args ~= "" and opts.args or nil)
	end, { nargs = "*", desc = "Run current project in a floating window" })
	vim.api.nvim_create_user_command("RunTests", function(opts)
		M.run_tests(opts.args ~= "" and opts.args or nil)
	end, { nargs = "*", desc = "Run project tests in a floating window" })
	vim.api.nvim_create_user_command("RunLast", M.run_last, { desc = "Rerun last runner command in a floating window" })
end

return M
