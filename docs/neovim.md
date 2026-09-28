# Neovim

Config in `nvim/.config/nvim`. Plugin manager: lazy.nvim. Leader: `Space`. Local leader: `\`. External tools: see `docs/packages.md`.

## Plugins

| Plugin | Purpose | Spec |
| --- | --- | --- |
| folke/lazy.nvim | plugin manager | `lua/callo/lazy.lua` |
| nvim-lua/plenary.nvim | library | `lua/plugins/init.lua` |
| neovim/nvim-lspconfig, mason.nvim, mason-lspconfig.nvim | LSP | `lua/plugins/lsp.lua` |
| saghen/blink.cmp, friendly-snippets, blink-cmp-spell | completion | `lua/plugins/blink.lua` |
| stevearc/conform.nvim | formatting | `lua/plugins/conform.lua` |
| nvim-treesitter/nvim-treesitter (`main`) | parsers, highlight | `lua/plugins/treesitter.lua` |
| nvim-telescope/telescope.nvim | fuzzy finder | `lua/plugins/telescope.lua` |
| ThePrimeagen/harpoon (`harpoon2`) | file marks | `lua/plugins/harpoon.lua` |
| tpope/vim-fugitive | git | `lua/plugins/fugitive.lua` |
| mbbill/undotree | undo tree | `lua/plugins/undotree.lua` |
| windwp/nvim-autopairs, nvim-ts-autotag | brackets, HTML tags | `lua/plugins/autopairs.lua` |
| mattn/emmet-vim | HTML expansion | `lua/plugins/emmet.lua` |
| NvChad/nvim-colorizer.lua | color previews | `lua/plugins/tailwind.lua` |
| rose-pine/neovim, folke/tokyonight.nvim | colorschemes (rose-pine active) | `lua/plugins/colors.lua` |
| mfussenegger/nvim-jdtls | Java | `lua/plugins/jdtls.lua` |
| AlexandrosAlexiou/kotlin.nvim | Kotlin | `lua/plugins/kotlin.lua` |
| Vigemus/iron.nvim, goerz/jupytext.vim | Python REPL, notebooks as `.py` | `lua/plugins/python.lua` |
| AmaneKai/ipynb-peek.nvim | notebook preview | `lua/plugins/ipynb-peek.lua` |
| AmaneKai/md-peek.nvim | Markdown preview | `lua/plugins/md-peek.lua` |
| iamcco/markdown-preview.nvim | Markdown preview in browser | `lua/plugins/markdown.lua` |
| chomosuke/typst-preview.nvim | Typst preview | `lua/plugins/typst.lua` |
| barrettruth/live-server.nvim | HTML live reload | `lua/plugins/liveserver.lua` |
| spell-config (local) | spell check for prose | `lua/plugins/spell.lua` |

## Languages

| Language | LSP | Formatter |
| --- | --- | --- |
| Lua | lua_ls | none |
| JavaScript, TypeScript | vtsls, eslint | eslint_d |
| Svelte | svelte | prettier, eslint_d |
| HTML, CSS | html, tailwindcss | prettier |
| JSON, Markdown | none | prettier |
| Python | pyright | ruff_format |
| Rust | rust_analyzer (clippy) | none |
| Java | jdtls (Mason package) | jdtls, on save |
| Kotlin | kotlin-lsp (Mason package) | none |
| Go | gopls if installed by hand | none |

Mason installs: lua_ls, tailwindcss, html, vtsls, rust_analyzer, svelte, eslint, pyright. Install jdtls and kotlin-lsp with `:MasonInstall jdtls kotlin-lsp`.

Treesitter parsers: vimdoc, javascript, typescript, lua, rust, jsdoc, bash, html, css, tsx, json, go, markdown, markdown_inline, kotlin, svelte, python.

## Keymaps: general

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>pv` | n | netrw explorer |
| `<leader>pr` | n | netrw at cwd |
| `<leader>nf` | n | new file relative to current file |
| `<leader>nF` | n | new file from cwd |
| `J`, `K` | v | move selection down, up |
| `J` | n | join lines, keep cursor |
| `<C-d>`, `<C-u>`, `n`, `N` | n | scroll or search, centered |
| `<leader>p` | x | paste without yanking |
| `<leader>y`, `<leader>Y` | n, v | yank to clipboard |
| `<leader>d` | n, v | delete to void register |
| `<C-c>` | i | Esc |
| `<leader>s` | n | substitute word under cursor |
| `<leader>x` | n | `chmod +x` current file |
| `<leader>nh` | n | clear search highlight |
| `<leader>+`, `<leader>-` | n | increment, decrement |
| `<C-k>`, `<C-j>` | n | quickfix next, prev |
| `<leader>k`, `<leader>j` | n | location list next, prev |
| `<leader>ee` | n | Go `if err != nil` snippet |
| `<leader><leader>` | n | source current file |
| `<leader>tt` | n | terminal split |
| `<leader>gr`, `<leader>gb`, `<leader>gt` | n | `./gradlew` run, build, test |
| `<leader>zig` | n | `:LspRestart` |
| `<leader>u` | n | undotree |
| `<leader>f` | n | format with conform |

## Keymaps: navigation

| Key | Action |
| --- | --- |
| `<leader>pf` | find files |
| `<C-p>` | git files |
| `<leader>ps` | live grep |
| `<leader>pws` | grep word under cursor |
| `<leader>pb` | buffers |
| `<leader>vh` | help tags |
| `<leader>a` | harpoon add |
| `<C-e>` | harpoon menu |
| `<C-h>`, `<C-n>`, `<C-s>`, `<C-t>` | harpoon 1 to 4 |

## Keymaps: LSP (buffer with LSP attached)

| Key | Mode | Action |
| --- | --- | --- |
| `gd` | n | definition |
| `K` | n | hover |
| `<leader>vws` | n | workspace symbol |
| `<leader>vd` | n | diagnostic float |
| `[d`, `]d` | n | prev, next diagnostic |
| `<leader>vca` | n | code action |
| `<leader>vrr` | n | references |
| `<leader>vrn` | n | rename |
| `<C-h>` | i | signature help |
| `<leader>th` | n | toggle inlay hints |
| `<leader>td` | n | toggle diagnostic virtual text |
| `<leader>jw` | n | Java: wipe jdtls workspace and restart |

## Keymaps: git

| Key | Action |
| --- | --- |
| `<leader>gs` | fugitive status |
| `<leader>p` | push (fugitive buffer) |
| `<leader>P` | pull --rebase (fugitive buffer) |
| `<leader>t` | `:Git push -u origin ` (fugitive buffer) |
| `gu`, `gh` | diffget left, right |

## Keymaps: previews and REPL

| Key | Action | Scope |
| --- | --- | --- |
| `<leader>md` | markdown-preview toggle | Markdown |
| `<leader>mo`, `<leader>mc`, `<leader>mp` | md-peek open, close, toggle | Markdown |
| `<leader>mr`, `<leader>mm` | md-peek refresh, outline | Markdown |
| `<leader>ty`, `<leader>tc`, `<leader>ts` | Typst preview start, stop, sync cursor | Typst |
| `<leader>ls`, `<leader>lc` | live server start, stop | global |
| `<leader>jj`, `<leader>jf` | iron send line, file | global |
| `<leader>jr` | iron send selection (v) | global |
| `<leader>jc`, `<leader>ja` | iron send `# %%` cell, all cells | global |
| `<leader>jt`, `<leader>jo`, `<leader>jh` | iron toggle, open, hide REPL | global |
| `<leader>jR`, `<leader>jq`, `<leader>jl` | iron restart, exit, clear | global |
| `<leader>j<space>` | iron interrupt | global |
| `<leader>jo`, `<leader>jc`, `<leader>jr`, `<leader>jR`, `<leader>jK` | ipynb-peek open, close, run cell, run all, restart kernel | `.ipynb` (overlaps iron, see `docs/known-issues.md`) |
| `<leader>ss`, `<leader>sa`, `<leader>sc` | spell toggle, add word, suggest | typst, markdown, text, tex |
| `<C-y>` | emmet leader | HTML, CSS, JS, JSX, TSX |
| `<C-Space>` | completion menu, docs | insert |

## Settings

| Option | Value |
| --- | --- |
| Indent | 4 spaces. 2 spaces for JS, TS, HTML, CSS, JSON, Svelte, Lua, YAML, Markdown, C++. Tabs width 4 for C |
| Numbers | relative |
| Color column | 100 |
| Clipboard | `unnamedplus` (needs xclip on X11) |
| Undo | persistent, `~/.vim/undodir` |
| Swap, backup | off |
| Shell | `/bin/bash` |
| Providers | python3, node, perl, ruby disabled |

## Auto-save

| Files | Trigger |
| --- | --- |
| `*.html`, `*.css`, `*.js` | text change, insert leave |
| `*.typ` | text change, insert leave |
| `*.kt` | text change, insert leave |

## Commands

| Command | Action |
| --- | --- |
| `:Lazy` | plugin manager |
| `:Mason` | LSP installer |
| `:checkhealth` | diagnostics |
| `:TSUpdate` | update parsers |
| `:MarkdownPreviewToggle` | browser preview on port 8081 |
| `:MdPeekOpen` | md-peek preview |
| `:TypstPreview` | Typst preview |
| `:LiveServerStart`, `:LiveServerStop` | live server on port 6767 |
| `:IronRepl` | ipython REPL |
