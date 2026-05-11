local M = {}

local state = { buf = nil, win = nil }

function M.open_float()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_set_current_win(state.win)
		vim.cmd.startinsert()
		return
	end

	local width = math.floor(vim.o.columns * 0.85)
	local height = math.floor(vim.o.lines * 0.75)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)
	local cwd = vim.fn.getcwd(-1, -1)

	state.buf = vim.api.nvim_create_buf(false, true)
	vim.bo[state.buf].bufhidden = "wipe"
	vim.bo[state.buf].filetype = "terminal"

	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Terminal: " .. cwd .. " ",
		title_pos = "center",
	})

	vim.fn.termopen(vim.o.shell, {
		cwd = cwd,
		on_exit = function()
			vim.schedule(function()
				if state.win and vim.api.nvim_win_is_valid(state.win) then
					vim.api.nvim_win_close(state.win, true)
				end
				state.win = nil
				state.buf = nil
			end)
		end,
	})

	vim.cmd.startinsert()
end

function M.setup()
	vim.keymap.set("n", "<leader>j", M.open_float, { desc = "Open floating terminal" })
	vim.keymap.set("t", "<leader>k", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
end

return M
