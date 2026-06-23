# Neovim Quick Reference

VS Code to Neovim equivalents - simple and practical.

---

## 1. Go to Definition (Ctrl + Click)

```
Place cursor on function name → press gd
```

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to type definition |
| `gr` | Find all references |
| `K` | Show documentation |
| `Ctrl + o` | Go back to previous position |

---

## 2. Find Function in File

**Option A: Search**
```
/typeFunctionName
n  = next match
N  = previous match
```

**Option B: Use Telescope**
```
:Telescope current_function_fuzzy
```

---

## 3. Comment/Uncomment Multiple Lines

First, add Comment.nvim plugin to `lua/plugins.lua`:

```lua
{
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup()
  end,
},
```

Then restart Neovim.

**Usage:**

| Action | Keys |
|--------|------|
| Comment/uncomment current line | `gcc` |
| Comment/uncomment multiple lines | Select lines, then `gc` |

**Example - Comment 3 lines:**
```
1. Press V (capital V)
2. Press jj (select 3 lines down)
3. Press gc
```

---

## 4. Edit Multiple Lines at Once

**Visual Block Mode:**

| Step | Action |
|------|--------|
| 1. Press | `Ctrl + v` |
| 2. Select lines | `j` or `k` |
| 3. Start editing | `Shift + i` |
| 4. Type text | (your text) |
| 5. Apply to all | `Esc` |

**Example - Add "const " to 3 lines:**
```
Before:
line1
line2
line3

Steps:
1. Ctrl+v
2. jj (select 3 lines)
3. Shift+i
4. type "const "
5. Esc

After:
const line1
const line2
const line3
```

---

## 5. Visual Mode Summary

| Key | Mode | Use For |
|-----|------|---------|
| `v` | Character mode | Select specific characters |
| `V` | Line mode | Select entire lines |
| `Ctrl + v` | Block mode | Edit multiple lines vertically |

---

## 6. Common LSP Keybindings

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |

(`<leader>` = SPACE key)

---

## 7. File Navigation

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Search in files |
| `<leader>e` | Toggle file tree |
| `Ctrl + h/j/k/l` | Navigate between windows |

---

## Cheat Sheet - Comment Multiple Lines

```
Single line:     gcc
Multiple lines:  Select (V+jj) → gc
Uncomment:       Same command (gc)
```

---

## Cheat Sheet - Multi-line Edit

```
Ctrl+v  →  jj  →  Shift+i  →  type  →  Esc
select  select  edit   apply
```
