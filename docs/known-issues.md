# Known issues

Open problems in the configs. Checked 2026-09-29 on branch `master`; line numbers refer to that state.

## Missing from the repo

| Item | Effect |
| --- | --- |
| hopes | `prefix t` and `prefix T` open an empty popup until `~/.cargo/bin/hopes` exists. Source unknown |
| `anifetch` | The `fastfetch` alias runs `anifetch` with a relative path (`zsh/.zshrc:47`) and fails outside a directory holding `anifetch/` |

## Hardcoded values

| File | Line | Value |
| --- | --- | --- |
| `zsh/.zshrc` | 25, 31-33 | `Python/3.14`, `/opt/homebrew/opt/openjdk`, `/opt/homebrew/opt/ffmpeg-full`, `/usr/local/mysql/bin` |
| `zsh/.zshrc` | 46 | `ctags` alias to `/opt/homebrew/bin/ctags` |
| `zsh/.zshrc` | 75 | `schd` opens `~/College/Schedule/Y2T3/image.png` |
| `bin/tmux-sessionizer` | 4-11 | Search paths `~/Dotfiles`, `~/Github`, `~/Codes`, `~/College`, `~/Downloads`, `~/Pictures/*`, `~/LBYARCH` |
| `tmux/.tmux.conf` | 31-36 | Jump keys for `~/Github`, `~/College`, `~/Codes`, `~/Downloads`, `~/LBYARCH` |
| `tmux/.tmux.conf` | 38 | `$HOME/.cargo/bin/hopes` |
| `nvim/.config/nvim/lua/plugins/liveserver.lua` | 6, 8 | Port 6767, browser `brave browser` |
| `nvim/.config/nvim/lua/plugins/markdown.lua` | 14 | Port 8081 |
| `nvim/.config/nvim/lua/plugins/ipynb-peek.lua`, `md-peek.lua` | 4 | Local dev path `~/Github/...` (used only when `use_local_dev = true`) |
| `nvim/.config/nvim/lua/callo/set.lua` | 37 | `shell = "/bin/bash"` |
| `nvim/.config/nvim/lua/plugins/dap.lua` | 1-3 | Adapters under `~/.local/share/nvim` |
| `git/.gitconfig` | 3 | Email `carlosranara0@gmail.com` |
| `git/.gitconfig` | 6 | `credential.helper = store` saves tokens in plain text in `~/.git-credentials` |
| `ghostty/.config/ghostty/config` | 1 | Font `jetbrains mono` |

## Design tradeoffs kept

| Item | Reason |
| --- | --- |
| `nvim/.config/nvim/lua/callo/remap.lua` | `<leader>s` and `<leader>j` are prefixes of spell (`<leader>ss`) and iron.nvim (`<leader>j*`) keys, so they wait for `timeoutlen`. Kept to avoid changing muscle memory |
| `fconv` and `git-purge` duplicate the `die`, `info`, `success` helpers | Scripts stay standalone and portable |
| `organize-screenshots` moves every other top-level file in `~/Pictures` into `other/` | Intended behavior |
| `discord/nocturnal-mod-old.theme.css` | Imports remote CSS from `xcruxiex.github.io` and `discordstyles.github.io`. Needed by the theme |
| `nvim/.config/nvim` matches the `linux` branch | Same config on both branches. Debugging through gdb does not run on Apple silicon, and no LSP is configured |
