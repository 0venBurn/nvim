local M = {}

M.config = {
	-- Add more filetypes here later, for example:
	-- javascript = { "node", "$file" },
	-- sh = { "bash", "$file" },
	runners = {
		python = { "python3", "$file" },
	},
	width = 0.85,
	height = 0.8,
}

local state = {
	win = nil,
	buf = nil,
	job = nil,
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
	if #lines == 0 then
		return
	end
	-- job callbacks can include a final empty line; avoid adding noise.
	if #lines == 1 and lines[1] == "" then
		return
	end
	vim.api.nvim_buf_set_option(state.buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(state.buf, -1, -1, false, lines)
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

function M.run_current_file()
	local file = vim.fn.expand("%:p")
	if file == "" then
		vim.notify("No file to run", vim.log.levels.WARN)
		return
	end

	if vim.bo.modified then
		vim.cmd.write()
	end

	local ft = vim.bo.filetype
	local runner = M.config.runners[ft]
	if not runner then
		vim.notify("No runner configured for filetype: " .. ft, vim.log.levels.WARN)
		return
	end

	local cmd = expand_command(runner, file)
	open_float("Run: " .. vim.fn.fnamemodify(file, ":t") .. " (q to close)")
	append({ "$ " .. (type(cmd) == "table" and table.concat(cmd, " ") or cmd), "" })

	state.job = vim.fn.jobstart(cmd, {
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

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	vim.api.nvim_create_user_command("RunFile", M.run_current_file, { desc = "Run current file in a floating window" })
end

return M
