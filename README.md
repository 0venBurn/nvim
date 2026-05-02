# Neovim config

A personal, warm, minimal Neovim configuration using `lazy.nvim` as the plugin manager.

The config is organised by feature domain rather than one-file-per-plugin. It uses the custom `cuimhne` colourscheme, inspired by a warm linen / dark reading-room design system.

## Requirements

- Neovim 0.11+
- `git`
- `rg` / ripgrep for picker grep
- `fd` recommended for file finding
- A C compiler for Treesitter parsers
- Language runtimes/toolchains as needed:
  - Java: `java` on `PATH` or `JAVA_HOME` set
  - Python: `python3`
  - Go: `go`
  - Node/npm for web tooling and markdown preview

## Structure

```text
init.lua                  -- bootstrap lazy.nvim, load core modules, set colorscheme
colors/
  cuimhne.lua             -- configurable custom colourscheme
ftplugin/
  markdown.lua            -- markdown-local wrap/spell settings
lua/
  core/
    options.lua           -- editor options
    autocmds.lua          -- user autocmds, e.g. yank highlight
    keymaps.lua           -- native/plugin-independent keymaps
    lsp-toggle.lua        -- persistent LSP enable/disable commands
  plugins/
    ai.lua                -- sidekick
    completion.lua        -- nvim-cmp, LuaSnip, cmp sources
    debug.lua             -- nvim-dap-ui, dap adapters, virtual text
    editing.lua           -- autopairs, todo-comments
    git.lua               -- diffview, lazygit, git-blame
    lsp.lua               -- lspconfig, Mason, conform, jdtls
    markdown.lua          -- render-markdown, markdown-preview, obsidian, img-clip
    navigation.lua        -- harpoon, tmux navigator
    treesitter.lua        -- Treesitter parser setup
    ui.lua                -- Snacks, statusline, which-key, zen, fidget
```

## Plugin manager

`lazy.nvim` is bootstrapped directly in `init.lua`.

This config does **not** use LazyVim defaults. LazyVim was intentionally removed; only the `lazy.nvim` plugin manager remains.

Plugin specs are loaded with:

```lua
require("lazy").setup("plugins", { ... })
```

## Colourscheme: `cuimhne`

The active colourscheme is loaded from `colors/cuimhne.lua`:

```lua
vim.cmd.colorscheme("cuimhne")
```

`cuimhne` is a configurable Lua colourscheme with:

- warm dark palette
- Treesitter highlights
- LSP semantic token highlights
- Java-specific semantic highlighting
- Snacks picker/explorer highlights
- nvim-cmp, DAP, Mini, WhichKey and markdown integration highlights

The colourscheme exposes:

```lua
require("cuimhne").setup({
  transparent_mode = false,
  terminal_colors = true,
  overrides = {},
  palette_overrides = {},
})
```

Since it is loaded as a normal Vim colourscheme, most users should just use `vim.cmd.colorscheme("cuimhne")`.

## LSP toggle

LSP is **disabled by default** unless a persisted state file says otherwise. Thanks Ginger Bill for the wisdom.

Commands:

```vim
:LspOn       " enable LSP and persist enabled state
:LspOff      " disable LSP and persist disabled state
:LspToggle   " toggle persisted LSP state
:LspStatus   " show current state and active clients for this buffer
```

The state is stored at:

```text
stdpath("state")/lsp-enabled
```

If the state file does not exist, LSP starts disabled.

### Configured LSP servers

Managed through Mason / lspconfig in `lua/plugins/lsp.lua`:

- Bash: `bashls`
- CSS: `cssls`
- PowerShell: `powershell_es`
- Odin: `ols`
- Ruby: `solargraph`, `rubocop`
- Python: `basedpyright`
- HTML: `html`, `emmet_ls`
- Java: `jdtls`
- Gradle: `gradle_ls`
- Docker: `dockerls`, `docker_compose_language_service`
- Lua: `lua_ls`
- JSON: `jsonls`
- Rust: `rust_analyzer`
- Svelte: `svelte`
- XML: `lemminx`
- Nginx: `nginx_language_server`
- Markdown: `marksman`
- Zig: `zls`
- YAML: `yamlls`
- Tailwind: `tailwindcss`
- GraphQL: `graphql`
- Go: `gopls`
- TypeScript/JavaScript: `ts_ls`, or `denols` when `deno.json` / `deno.jsonc` exists

### Java / jdtls

Java support uses `nvim-jdtls` and Mason's `jdtls` package.

The launcher is cross-platform:

- Uses `$JAVA_HOME/bin/java` when available
- Falls back to `java` on `PATH`
- Selects Mason's platform config automatically:
  - macOS Intel: `config_mac`
  - macOS ARM: `config_mac_arm`
  - Linux x64: `config_linux`
  - Linux ARM: `config_linux_arm`
  - Windows: `config_win`

Java keymaps are defined with the Java plugin spec:

```text
<leader>go  organize imports
<leader>gu  update project config
<leader>tc  test class
<leader>tm  test nearest method
```

## Formatting

Formatting uses `stevearc/conform.nvim`.

Configured formatters include:

- JS/TS/Svelte/CSS/HTML/JSON/YAML/Markdown/GraphQL/Liquid: `prettier`
- Go: `gofumpt`
- Lua: `stylua`
- Python: `isort`, `black`
- Ruby: `rubocop`

Manual format key:

```text
<leader>mp
```

There is also an LSP format mapping:

```text
<leader>gf
```

## Treesitter

Treesitter is configured in `lua/plugins/treesitter.lua` and starts for filetypes automatically where a parser exists.

Installed parsers include:

- `c`
- `java`
- `lua`
- `vim`
- `vimdoc`
- `query`
- `markdown`, `markdown_inline`
- `comment`
- `xml`
- `http`
- `json`
- `graphql`
- `html`, `html_tags`
- `css`, `scss`
- `javascript`, `typescript`, `tsx`
- `ecma`, `jsx`
- `svelte`

## Keymaps

Core/native keymaps live in `lua/core/keymaps.lua`.

Plugin-specific keymaps live with their plugin specs under `lua/plugins/`.

### General

```text
jk                  exit insert mode
<leader>ww          save file
<leader>wq          save and quit
<leader>qq          quit without saving
<leader><leader>x   execute current Python file in floating window
```

### Splits, tabs, buffers, quickfix

```text
<leader>sv          vertical split
<leader>se          equalize split sizes
<leader>sx          close split
<leader>sj/sk       decrease/increase split height
<leader>sh/sl       decrease/increase split width
<leader>sm          maximize current split

<leader>to          new tab
<leader>tx          close tab
<leader>tn/tp       next/previous tab

<leader>bn/bp       next/previous buffer
<leader>bub         toggle previous buffer
<leader>bb          delete buffer
<leader>bl          list buffers

<leader>qo          open quickfix
<leader>qf/qn/qp/ql first/next/previous/last quickfix item
<leader>qc          close quickfix
```

### Picker / explorer

Provided by Snacks:

```text
<leader>e           toggle file explorer
<leader>er          focus file explorer
<leader>ef          reveal current file in explorer

<leader>ff          find files
<leader>fg          live grep
<leader>fb          find buffers
<leader>fh          help tags
<leader>fs          search current buffer lines
<leader>fo          document symbols
<leader>fi          LSP references
<leader>fm          methods/functions
<leader>fr          recent files
<leader>fc          config files
<leader>fd          diagnostics
<leader>fw          grep word under cursor
<leader><space>     smart find
<leader>fF          find all files, hidden/ignored included
<leader>fG          grep all files, hidden/ignored included
```

### Git

```text
<leader>gF          git files picker
<leader>gc          git status picker
<leader>gb          toggle git blame
<leader>git         open LazyGit
<leader>div         open Diffview against origin/main...HEAD
<leader>dic         close Diffview
```

### LSP

```text
<leader>lt          toggle LSP
<leader>lo          LSP on
<leader>lO          LSP off
<leader>ls          LSP status

<leader>gg          hover
<leader>gd          definition
<leader>gD          declaration
<leader>gi          implementation
<leader>gt          type definition
<leader>gr          references
<leader>gs          signature help
<leader>rr          rename
<leader>gf          format
<leader>ga          code action
<leader>gl          line diagnostics
<leader>gp/gn       previous/next diagnostic
<leader>tr          document symbols
```

### Debugging

DAP keymaps live in `lua/plugins/debug.lua`:

```text
<leader>db          toggle breakpoint
<leader>dB          set log breakpoint
<leader>dR          clear breakpoints
<leader>dc          continue
<leader>dj          step over
<leader>dk          step into
<leader>do          step out
<leader>dd          disconnect and close DAP UI
<leader>dt          terminate and close DAP UI
<leader>dr          toggle DAP REPL
<leader>dl          run last
<leader>di          inspect hover
<leader>d?          scopes float
```

### Navigation

```text
<C-h/j/k/l>         tmux/vim pane navigation
<C-\>               previous tmux pane

<leader>na          Harpoon add file
<leader>nh          Harpoon menu
<leader>n1..n5      Harpoon file slots
```

### AI / Sidekick

```text
<tab>               next edit suggestion/apply suggestion
<c-.>               focus Sidekick CLI
<leader>aa          toggle Sidekick CLI
<leader>as          select CLI
<leader>ad          detach CLI session
<leader>at          send current item
<leader>af          send file
<leader>av          send visual selection
<leader>ap          select prompt
<leader>ac          toggle Claude
```

## Markdown

Markdown-specific editor behaviour is in `ftplugin/markdown.lua`:

- wrap enabled
- breakindent enabled
- linebreak enabled
- `j` / `k` move by visual line
- spellcheck enabled with `en_us`

Markdown plugins:

- `render-markdown.nvim`
- `markdown-preview.nvim`
- `obsidian.nvim`
- `img-clip.nvim`

Image paste:

```text
<leader>pi          paste image from system clipboard
```

## Notes

- LSP defaults to off to keep startup quiet and avoid language-server work unless explicitly enabled.
- The config is intentionally warm/dark-first and avoids LazyVim distro defaults.
