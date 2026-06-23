# Neovim Navigation Guide

For beginners coming from VS Code. Simple movements you'll use daily.

---

## 1. Basic Movement (No Arrow Keys Needed)

Think of your keyboard as a movement pad:

```
     k
   h   l
     j
```

| Key | Direction | Remember |
|-----|-----------|----------|
| `h` | Left | **H**and moves left |
| `j` | Down | **J** points down |
| `k` | Up | **K** points up |
| `l` | Right | **L**ast key on right |

**Pro tip:** You can use arrow keys, but `hjkl` is faster once you get used to it.

---

## 2. Word Navigation (SUPER USEFUL)

| Key | Action | Example |
|-----|--------|---------|
| `w` | Jump to **next word** | `const| getUser` → press `w` → `const getUser|` |
| `b` | Jump **back** to previous word | `const| getUser` → press `b` → `|const getUser` |
| `e` | Jump to **end** of word | `con|st` → press `e` → `cons|t` |

**Real example:**
```
function getUserById(id) { }
         ↑
         press w → getUserById
         press w → (id)
         press w → {
```

---

## 3. Line Navigation

| Key | Action | Example |
|-----|--------|---------|
| `0` | Go to **start** of line | `    const x = 1|` → `|const x = 1` |
| `$` | Go to **end** of line | `|const x = 1` → `const x = 1|` |
| `^` | Go to first **non-space** character | `    |const x = 1` |
| `gg` | Go to **top** of file | Anywhere → line 1 |
| `G` | Go to **bottom** of file | Anywhere → last line |
| `:10` | Go to **line 10** | Jump to specific line |

**Quick example:**
```
    const x = 1;
|
Press 0  → |const x = 1;
Press $  → const x = 1;|
```

---

## 4. Jump Within Line

| Key | Action | Example |
|-----|--------|---------|
| `f` + char | Find character **forward** | `f;` jumps to next `;` |
| `F` + char | Find character **backward** | `F;` jumps to previous `;` |
| `t` + char | **Till** character (before it) | `t;` jumps right before `;` |

**Example:**
```
const getUser = function() { };
              ↑
              Press f; → jumps here →  ;
```

---

## 5. Code Navigation (LSP)

These work when you open a code file (TypeScript, Python, etc.)

| Key | Action | Remember |
|-----|--------|----------|
| `gd` | Go to definition | **G**o **D**efinition |
| `gr` | Find references | **G**o **R**eferences |
| `Ctrl + o` | Go **back** to previous position | Like browser back button |
| `Ctrl + i` | Go **forward** | Like browser forward button |

**Example workflow:**
```
1. Cursor on "getUser"
2. Press gd → jumps to getUser function definition
3. Read the function
4. Press Ctrl + o → go back to where you were
```

---

## 6. Window Navigation (Split Windows)

| Key | Action |
|-----|--------|
| `Ctrl + h` | Move to **left** window |
| `Ctrl + j` | Move to **bottom** window |
| `Ctrl + k` | Move to **top** window |
| `Ctrl + l` | Move to **right** window |

**Visual:**
```
┌─────────┬─────────┐
│         │         │
│   Ctrl+h│Ctrl+l   │
│   ←     │    →    │
├─────────┼─────────┤
│         │         │
│   Ctrl+k│         │
│     ↑   │         │
│   Ctrl+j│         │
│     ↓   │         │
└─────────┴─────────┘
```

---

## 7. File & Buffer Navigation

| Key | Action | Purpose |
|-----|--------|---------|
| `<leader>ff` | Find files | Open file picker |
| `<leader>fg` | Search in files | Find text in project |
| `<leader>e` | Toggle file tree | Show/hide sidebar |
| `<leader>bn` | Next buffer | Next open file |
| `<leader>bp` | Previous buffer | Previous open file |

---

## 8. Screen Movement

| Key | Action | When cursor stays, screen moves |
|-----|--------|----------------------------------|
| `Ctrl + e` | Move screen **down** | Scroll down, cursor stays |
| `Ctrl + y` | Move screen **up** | Scroll up, cursor stays |
| `Ctrl + d` | Move **down** half-screen | Jump down 50% |
| `Ctrl + u` | Move **up** half-screen | Jump up 50% |
| `zt` | Move line to **top** of screen | Current line at top |
| `zz` | Move line to **center** of screen | Current line in center |
| `zb` | Move line to **bottom** of screen | Current line at bottom |

---

## 9. Matching Brackets

| Key | Action | Example |
|-----|--------|---------|
| `%` | Jump to matching bracket | `function() { }` |

**Example:**
```
function getUser() {
  if (true) {
    |
  }
}
Press % → jumps to }
Press % → jumps back to {
```

---

## 10. Most Used Navigation Cheat Sheet

```
Word movement:    w (next)  b (back)
Line movement:    0 (start) $ (end)
File movement:    gg (top)  G (bottom)
Code navigation:  gd (def)  gr (refs)
Go back:          Ctrl + o

Window split:     Ctrl + h/j/k/l
```

---

## Practice This First

**Start with these 5 keys:**

| Key | Use it for |
|-----|------------|
| `w` | Move between words |
| `0` | Go to line start |
| `$` | Go to line end |
| `gd` | Go to function definition |
| `Ctrl + o` | Go back |

---

## Quick Reference Card

```
┌──────────────────────────────────────┐
│ BASIC MOVEMENT                        │
├──────────────────────────────────────┤
│ h j k l        ← ↓ ↑ →                │
│ w b            word forward/backward  │
│ 0 $            line start/end         │
│ gg G           file top/bottom        │
├──────────────────────────────────────┤
│ CODE JUMPING                          │
├──────────────────────────────────────┤
│ gd             go to definition       │
│ gr             find references        │
│ Ctrl + o       go back                │
│ %              matching bracket       │
├──────────────────────────────────────┤
│ WINDOW MOVEMENT                       │
├──────────────────────────────────────┤
│ Ctrl + h/j/k/l  move between windows  │
└──────────────────────────────────────┘
```

---

## Remember This

```
Don't memorize everything at once!

Week 1:  h j k l, w, 0, $
Week 2:  gd, Ctrl + o, gg, G
Week 3:  Add more as needed

You'll pick it up naturally.
```

---

**Need more?** Check `:help motion` in Neovim for complete reference.
