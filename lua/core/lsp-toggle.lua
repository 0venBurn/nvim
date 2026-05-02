local M = {}

local state_file = vim.fn.stdpath("state") .. "/lsp-enabled"

M.servers = {
	"bashls",
	"cssls",
	"powershell_es",
	"solargraph",
	"basedpyright",
	"html",
	"gradle_ls",
	"dockerls",
	"docker_compose_language_service",
	"lua_ls",
	"rubocop",
	"jsonls",
	"rust_analyzer",
	"svelte",
	"lemminx",
	"nginx_language_server",
	"marksman",
	"zls",
	"yamlls",
	"tailwindcss",
	"graphql",
	"gopls",
	"emmet_ls",
}

local function read_state()
	local f = io.open(state_file, "r")
	if not f then
		return false
	end
	local value = f:read("*a")
	f:close()
	return not value:match("^%s*off%s*$")
end

local function write_state(enabled)
	vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
	local f = assert(io.open(state_file, "w"))
	f:write(enabled and "on" or "off")
	f:close()
end

function M.is_enabled()
	if vim.g.lsp_enabled == nil then
		vim.g.lsp_enabled = read_state()
	end
	return vim.g.lsp_enabled ~= false
end

function M.servers_to_enable()
	local servers = vim.deepcopy(M.servers)
	if vim.fn.filereadable("deno.json") == 1 or vim.fn.filereadable("deno.jsonc") == 1 then
		table.insert(servers, "denols")
	else
		table.insert(servers, "ts_ls")
	end
	return servers
end

local function enable_server(server, enabled)
	if vim.lsp and vim.lsp.enable then
		pcall(vim.lsp.enable, server, enabled)
	end
end

function M.enable(opts)
	opts = opts or {}
	vim.g.lsp_enabled = true
	write_state(true)
	if vim.diagnostic and vim.diagnostic.enable then
		vim.diagnostic.enable(true)
	end
	pcall(function()
		require("lazy").load({ plugins = { "nvim-lspconfig" } })
	end)
	for _, server in ipairs(M.servers_to_enable()) do
		enable_server(server, true)
	end
	if vim.bo.filetype == "java" then
		M.start_jdtls()
	end
	if not opts.silent then
		vim.notify("LSP enabled", vim.log.levels.INFO)
	end
end

function M.disable(opts)
	opts = opts or {}
	vim.g.lsp_enabled = false
	write_state(false)
	for _, server in ipairs(M.servers_to_enable()) do
		enable_server(server, false)
	end
	local clients = vim.lsp.get_clients and vim.lsp.get_clients() or vim.lsp.get_active_clients()
	for _, client in ipairs(clients) do
		client:stop(true)
	end
	if vim.diagnostic and vim.diagnostic.enable then
		vim.diagnostic.enable(false)
	end
	if not opts.silent then
		vim.notify("LSP disabled", vim.log.levels.INFO)
	end
end

function M.toggle()
	if M.is_enabled() then
		M.disable()
	else
		M.enable()
	end
end

function M.status()
	local status = M.is_enabled() and "enabled" or "disabled"
	local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = 0 }) or vim.lsp.get_active_clients({ bufnr = 0 })
	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end
	vim.notify("LSP is " .. status .. ". Active in this buffer: " .. (#names > 0 and table.concat(names, ", ") or "none"), vim.log.levels.INFO)
end

function M.start_jdtls()
	if not M.is_enabled() then
		return
	end
	local ok, jdtls = pcall(require, "jdtls")
	if not ok then
		return
	end

	local jdtls_install = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
	local root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }) or vim.fn.getcwd()
	local project_name = vim.fn.fnamemodify(root_dir, ":p:t")
	local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

	local java_bin = vim.env.JAVA_HOME and (vim.env.JAVA_HOME .. "/bin/java") or ""
	if vim.fn.executable(java_bin) == 0 then
		java_bin = vim.fn.exepath("java")
	end
	if java_bin == "" then
		vim.notify("jdtls: java executable not found. Set JAVA_HOME or add java to PATH.", vim.log.levels.ERROR)
		return
	end

	local uname = vim.loop.os_uname()
	local os = uname.sysname
	local arch = uname.machine
	local config_dir = "config_linux"
	if os == "Darwin" then
		config_dir = arch == "arm64" and "config_mac_arm" or "config_mac"
	elseif os == "Linux" then
		config_dir = (arch == "aarch64" or arch == "arm64") and "config_linux_arm" or "config_linux"
	elseif os:match("Windows") then
		config_dir = "config_win"
	end

	local launcher = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	if launcher == "" then
		vim.notify("jdtls: launcher jar not found. Run :MasonInstall jdtls", vim.log.levels.ERROR)
		return
	end

	local config = {
		cmd = {
			java_bin,
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xmx1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens", "java.base/java.util=ALL-UNNAMED",
			"--add-opens", "java.base/java.lang=ALL-UNNAMED",
			"-jar", launcher,
			"-configuration", jdtls_install .. "/" .. config_dir,
			"-data", workspace_dir,
		},
		root_dir = root_dir,
		settings = {
			java = {
				signatureHelp = { enabled = true },
				contentProvider = { preferred = "fernflower" },
			},
		},
		init_options = {
			bundles = {},
		},
	}
	jdtls.start_or_attach(config)
end

function M.setup()
	vim.g.lsp_enabled = read_state()
	vim.api.nvim_create_user_command("LspOn", function()
		M.enable()
	end, { desc = "Enable LSP and persist it" })
	vim.api.nvim_create_user_command("LspOff", function()
		M.disable()
	end, { desc = "Disable LSP and persist it" })
	vim.api.nvim_create_user_command("LspToggle", function()
		M.toggle()
	end, { desc = "Toggle LSP on/off and persist it" })
	vim.api.nvim_create_user_command("LspStatus", function()
		M.status()
	end, { desc = "Show LSP toggle status" })
end

return M
