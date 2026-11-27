# Emacs

A beginner's guide to this setup. Config in `emacs/.emacs.d`, adapted from [rexim/dotfiles](https://github.com/rexim/dotfiles). `em` runs it inside the terminal, `emg` opens a window.

## Start here

1. Run `em` (or `em notes.txt` to open a file).
2. Press `C-h t` for the built-in tutorial.
3. If you get stuck, press `C-g` to cancel.

## How to read keys

| Written | Press |
| --- | --- |
| `C-x` | hold Control, press `x` |
| `M-x` | hold Alt, press `x` (or press `Esc`, then `x`) |
| `C-x C-s` | Control+`x`, then Control+`s` |
| `C-x b` | Control+`x`, release, then `b` |
| `S-<left>` | hold Shift, press the left arrow |

## Words Emacs uses

| Word | Meaning |
| --- | --- |
| buffer | an open file (or other text) |
| window | a split inside Emacs |
| frame | what other apps call a window |
| point | the cursor |
| mark, region | where a selection starts, the selected text |
| kill, yank | cut, paste |
| minibuffer | the line at the bottom where you answer prompts |
| mode | behavior for a file type or feature |

## Everyday keys

### Files and buffers

| Keys | Action |
| --- | --- |
| `C-x C-f` | open or create a file |
| `C-x C-s` | save |
| `C-x b` | switch buffer |
| `C-x C-b` | list buffers |
| `C-x k` | close a buffer |
| `C-x C-c` | quit (answer `y`) |

### Moving

| Keys | Action |
| --- | --- |
| `C-f`, `C-b` | right, left |
| `C-n`, `C-p` | down, up |
| `C-a`, `C-e` | start, end of line |
| `M-f`, `M-b` | forward, back one word |
| `C-v`, `M-v` | page down, page up |
| `M-<`, `M->` | top, bottom of file |

Arrow keys work too. Inside tmux, press `C-a` twice, because `C-a` is the tmux prefix.

### Editing

| Keys | Action |
| --- | --- |
| `C-SPC` | start selecting |
| `M-w` | copy |
| `C-w` | cut |
| `C-y` | paste |
| `M-y` | after pasting, swap in an older copy |
| `C-k` | cut to end of line |
| `C-/` | undo |
| `M-p`, `M-n` | move the line up, down |

### Search and replace

| Keys | Action |
| --- | --- |
| `C-s`, `C-r` | search forward, backward (repeat for the next match) |
| `M-%` | replace, asking each time (`y` yes, `n` no, `!` all) |

### Splits

| Keys | Action |
| --- | --- |
| `C-x 2` | split top and bottom |
| `C-x 3` | split left and right |
| `C-x o` | go to the other split |
| `S-<left>`, `S-<right>`, `S-<up>`, `S-<down>` | go to the split in that direction |
| `C-x 0` | close this split |
| `C-x 1` | keep only this split |

### Help

| Keys | Action |
| --- | --- |
| `C-h k`, then a key | what that key does |
| `C-h f` | describe a function |
| `C-h v` | describe a variable |
| `C-h m` | keys for the current mode |
| `M-x` | run any command by name |

## Font size

In a window (`emg`): `C-=` or `C-+` bigger, `C--` smaller, `C-0` reset. In the terminal (`em`), use the terminal's own zoom keys.

## What this config adds

Learn these after the keys above.

| Keys | Action |
| --- | --- |
| `C-x d` | file manager (dired). `RET` opens, `q` leaves |
| `C-x C-g` | open the file or URL under the cursor |
| `C-c i m` | jump to a function or heading |
| `C-c m s` | git status (Magit). `?` shows its keys, `q` leaves |
| `C-c m l` | git log |
| `C-c h f` | find files by name |
| `C-c h r` | recent files |
| `C-c h g g` | search a git repo |
| `C-c M-q` | join a paragraph into one line |
| `C-x p d` | insert a timestamp |
| `C-x p s` | search files for the selected text |

In Magit, `s` stages, `c c` commits and `P p` pushes.

### Keys your terminal may not send

Terminals often cannot send these combinations. If one does nothing, press `M-x`, type the command name and press `RET`.

| Keys | Command | Action |
| --- | --- | --- |
| `C-,` | `rc/duplicate-line` | duplicate the line |
| `C->` | `mc/mark-next-like-this` | add a cursor at the next match |
| `C-<` | `mc/mark-previous-like-this` | add a cursor at the previous match |
| `C-c C-<` | `mc/mark-all-like-this` | add a cursor at every match |
| `C-S-c C-S-c` | `mc/edit-lines` | add a cursor on each selected line |

## Org mode

Notes and to-do lists in `.org` files. Agenda and capture need this once:

```sh
mkdir -p ~/Documents/Agenda && touch ~/Documents/Agenda/Tasks.org
```

| Keys | Action |
| --- | --- |
| `TAB` | fold or unfold a heading |
| `C-c C-t` | cycle TODO state |
| `C-c c` | capture a task |
| `C-x a` | agenda |

## Things that may surprise you

- No backup files are made. Save often and use git.
- Trailing spaces are deleted on save in most code files.
- Brackets in Lisp files stay balanced (paredit), so deleting one can seem blocked.
- Completion suggestions pop up as you type (company). `RET` accepts.
- Type a snippet key and press `TAB` to expand it. Snippets are in `emacs/.emacs.d/snippets`.
- Haskell, Racket, Coq and TypeScript features need those tools installed.

## Changing the config

| Path in `emacs/.emacs.d` | Content |
| --- | --- |
| `early-init.el` | dark colours for the first frame |
| `init.el` | theme, packages, most keys |
| `rc/rc.el` | package install helpers |
| `rc/misc-rc.el` | general settings and small commands |
| `rc/org-mode-rc.el` | Org settings |
| `custom.el` | settings Emacs saves itself |
| `local/` | language modes not installed from MELPA |

- Add a package: `(rc/require 'package-name)` in `init.el`. It installs on the next start.
- Add a key: `(global-set-key (kbd "C-c d") 'rc/duplicate-line)`.
- Change the theme: edit the `rc/require-theme` line.
- Apply changes: `emacsclient -e '(kill-emacs)'`, then run `em` again (the daemon keeps the old config).
- Config broken: run `emacs -q` to start without it, or `emacs --debug-init` to see the error.
