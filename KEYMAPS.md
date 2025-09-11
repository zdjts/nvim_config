# Neovim Keymap Organization

This document outlines the reorganized keymap structure for your Neovim configuration. The goal is to create a logical, easy-to-remember, and discoverable set of keybindings using `which-key.nvim`.

## Guiding Principles

1.  **Centralization**: All custom keymaps are defined in a single file: `lua/config/keymaps.lua`.
2.  **Mnemonics**: Keybindings are grouped under the `<leader>` key (`<Space>`) using mnemonic prefixes (e.g., `f` for **f**ile, `l` for **L**SP).
3.  **Discoverability**: `which-key.nvim` provides an interactive popup menu, helping you learn and explore your keybindings without leaving the editor.

## Keymap Structure

All keybindings are registered in `lua/config/keymaps.lua` using `which-key.register()`.

### Leader Key Mappings (`<Space>`)

| Prefix      | Group          | Description                               |
| ----------- | -------------- | ----------------------------------------- |
| `<leader>f` | **F**ind/Files | File management, searching with Telescope |
| `<leader>b` | **B**uffer     | Buffer navigation and management          |
| `<leader>l` | **L**SP        | Language Server Protocol features         |
| `<leader>t` | **T**oggle     | Toggling UI elements and settings         |
| `<leader>w` | **W**indow     | Window navigation                         |
| `<leader>d` | **D**iagnostic | Navigating diagnostics (errors, warnings) |

---

### Detailed Mappings

#### `<leader>f` - Find / Files

| Key           | Action                      | Command (`<cmd>...`)         |
| ------------- | --------------------------- | ---------------------------- |
| `<leader>ff` | Find Files                  | `Telescope find_files`       |
| `<leader>fg` | Live Grep (Search Text)     | `Telescope live_grep`        |
| `<leader>fb` | Find Buffers                | `Telescope buffers`          |
| `<leader>fh` | Search Help Tags            | `Telescope help_tags`        |
| `<leader>fo` | Open File Explorer (Oil)    | `Oil`                        |

#### `<leader>b` - Buffer

| Key           | Action                      | Command (`<cmd>...`)         |
| ------------- | --------------------------- | ---------------------------- |
| `<leader>bn` | Next Buffer                 | `BufferLineCycleNext`        |
| `<leader>bp` | Previous Buffer             | `BufferLineCyclePrev`        |
| `<leader>bd` | Close Buffer                | `bdelete`                    |

#### `<leader>l` - LSP

| Key           | Action                      | Function (`vim.lsp.buf...`)  |
| ------------- | --------------------------- | ---------------------------- |
| `<leader>la` | Code Action                 | `code_action`                |
| `<leader>lr` | Rename                      | `rename`                     |
| `<leader>ld` | Line Diagnostics            | `vim.diagnostic.open_float`  |
| `<leader>lt` | Toggle Inlay Hints          | (custom function)            |

#### `<leader>t` - Toggle

| Key           | Action                      | Command (`<cmd>...`)         |
| ------------- | --------------------------- | ---------------------------- |
| `<leader>tt` | Toggle Terminal             | `ToggleTerm`                 |
| `<leader>tn` | Toggle Noice                | `Noice`                      |
| `<leader>td` | Toggle Diagnostics          | (custom function)            |

#### `<leader>w` - Window

| Key           | Action                      | Command                      |
| ------------- | --------------------------- | ---------------------------- |
| `<leader>wh` | Navigate Left               | `<C-w>h`                     |
| `<leader>wj` | Navigate Down               | `<C-w>j`                     |
| `<leader>wk` | Navigate Up                 | `<C-w>k`                     |
| `<leader>wl` | Navigate Right              | `<C-w>l`                     |

#### `<leader>d` - Diagnostic

| Key           | Action                      | Function (`vim.diagnostic...`)|
| ------------- | --------------------------- | ---------------------------- |
| `<leader>de` | Next Error                  | `goto_next({severity=ERROR})`|
| `<leader>dE` | Previous Error              | `goto_prev({severity=ERROR})`|
| `<leader>dw` | Next Warning                | `goto_next({severity=WARN})` |
| `<leader>dW` | Previous Warning            | `goto_prev({severity=WARN})` |

---

This new structure should make your keybindings much more predictable and easier to use.
