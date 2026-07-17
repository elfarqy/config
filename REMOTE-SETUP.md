# Remote & Clipboard Setup

How this dotfiles setup handles working on remote / ephemeral servers over SSH:
clipboard, terminal choice, tmux, and the terminfo gotchas.

The moving parts:

```
your terminal (kitty/alacritty)  ──ssh──▶  server: tmux ─▶ nvim / nano / shell
        ▲                                                        │
        └──────────────── OSC 52 escape (clipboard) ◀────────────┘
```

---

## 1. Clipboard (remote → local) uses OSC 52

To copy text on the server and have it land in your **local** machine's
clipboard, the text is emitted as an **OSC 52** terminal escape sequence. It
travels: app → tmux (forwards it) → your terminal → local clipboard.

**Hard requirement: your local terminal must support OSC 52.**

| Terminal | OSC 52 | Notes |
|---|---|---|
| kitty | ✅ | `$TERM=xterm-kitty` (terminfo caveat — see §4) |
| Alacritty | ✅ | needs `osc52 = "CopyPaste"` (already set in `alacritty/`) |
| wezterm / ghostty / foot | ✅ | foot is Wayland-only |
| **xfce4-terminal / GNOME (VTE)** | ❌ | drops OSC 52 silently — do not use for remote clipboard |
| recent xterm | ✅ | needs `allowWindowOps` |

Test any terminal (locally, no tmux/ssh):
```bash
printf '\e]52;c;%s\a' "$(printf 'osc52-works' | base64)"   # then paste
```
If `osc52-works` pastes, OSC 52 works.

### What copies to the clipboard, and what doesn't

OSC 52 is **not automatic** — each program must emit it.

- **Neovim** — configured to (see `nvim/init.lua`, `TextYankPost` → OSC 52).
  `y` copies to the local clipboard; `p` pastes what you copied (from an
  internal cache — remote paste-*back* of the system clipboard is not
  supported, terminals don't answer OSC 52 reads over SSH).
- **tmux copy-mode** — `set -g set-clipboard on` makes tmux emit OSC 52 for
  **any** on-screen text. This is the universal path: `prefix [`, `v` to
  select, `y` to copy.
- **nano and most CLI tools** — do **not** emit OSC 52. To copy from them, use
  tmux copy-mode (above), not the app's own copy.

### tmux config that makes it work (`.tmux.conf`)
```tmux
set -g allow-passthrough on
set -g set-clipboard on
set -as terminal-features ',xterm-kitty:clipboard'
set -as terminal-features ',alacritty:clipboard'
set -as terminal-features ',xterm-256color:clipboard'
```
The `clipboard` feature must name the **outer** terminal ($TERM before tmux
starts), not tmux's inner `tmux-256color`, or tmux won't forward OSC 52 out.

---

## 2. Terminal choice

Pick **one** OSC-52-capable terminal. Both kitty and Alacritty are configured
in this repo; either works. Alacritty is lighter (no tabs/splits — tmux handles
those anyway); kitty has `kitten ssh` (see §4), which is handy for terminfo.

---

## 3. tmux status bar (local vs remote marker)

The status bar is self-contained — no external script (it used to depend on
`~/.config/tmux-powerline/status-right.sh`, which isn't deployed on servers).

- **Left:** session name. When tmux is started inside an SSH session
  (`$SSH_CONNECTION` set), a red **`REMOTE <host>`** badge appears — so a remote
  shell is never mistaken for local.
- **Right:** git branch (`*` = dirty) · `cpu %` · `mem used/total` · date+time.
  - CPU % is blank for the first ~2s (needs two `/proc/stat` samples).

> The REMOTE badge latches when the tmux **server starts**. It works because the
> workflow is: SSH in → *then* start tmux. Starting tmux locally and attaching
> over SSH later won't flip it.

Reload after changes: `prefix + r`.

---

## 4. Connecting to servers (terminfo / TERM)

tmux refuses to attach if the client's terminal has no terminfo entry on the
server:

```
missing or unsuitable terminal: xterm-kitty
```

This is common on **ephemeral servers** (fresh box each time, changing IP) that
only ship `xterm-256color`.

### Immediate unblock
```bash
TERM=xterm-256color tmux attach -t 0
```

### Durable fixes (best first)

1. **`kitten ssh` (kitty only)** — auto-installs the terminfo on each new
   server; nothing to pre-deploy:
   ```bash
   kitten ssh user@host
   ```

2. **`.zshrc` fallback (already in this repo)** — in an SSH session, if `$TERM`
   has no terminfo here, downgrade to `xterm-256color`:
   ```zsh
   if [[ -n "$SSH_CONNECTION" ]] && ! infocmp "$TERM" &>/dev/null; then
     export TERM=xterm-256color
   fi
   ```
   Only helps once these dotfiles are deployed on the server, for the user
   whose shell loads them.

3. **Install terminfo once** (not great for ephemeral — repeats per box). From
   local:
   ```bash
   infocmp -x xterm-kitty | ssh user@host 'mkdir -p ~/.terminfo && tic -x -o ~/.terminfo /dev/stdin'
   ```

### Gotcha: `kitten ssh root@host` then `su - deploy`

`kitten ssh` installs terminfo into **root's** `~/.terminfo`. After
`su - deploy`, you're a different user with no `~/.terminfo`, but `TERM=xterm-kitty`
carries over → tmux fails again. Options:

- SSH straight in as the working user: `kitten ssh deploy@host` (use `sudo` for
  root tasks) — cleanest, nothing to redo per box.
- Or just `TERM=xterm-256color tmux attach -t 0` after `su`.
- Or add `export TERM=xterm-256color` to that user's `~/.bashrc` / `~/.zshrc`.

---

## 5. Quick reference

| Symptom | Fix |
|---|---|
| tmux: "missing or unsuitable terminal" | `TERM=xterm-256color tmux attach -t 0`; long-term use `kitten ssh` or the `.zshrc` fallback |
| nvim `p` → "Nothing in register" | fixed in `nvim/init.lua` (cache-based paste) |
| yank/copy doesn't reach local clipboard | check terminal supports OSC 52 (§1); not xfce4-terminal |
| nano copy doesn't reach clipboard | use tmux copy-mode: `prefix [`, `v`, `y` |
| status bar right side blank | you're on old config — now inlined, no external script |
| not sure if local or remote | look for the red `REMOTE <host>` badge in tmux |
