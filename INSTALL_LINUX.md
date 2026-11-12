# Linux dependencies

Tools the stowed configs assume are installed. Package names below assume
Debian/Ubuntu (`apt`); adapt for other distros. Items are grouped by what
depends on them, so you can skip a section if you don't use that piece.

## Core (everything needs these)

- **stow** — `apt install stow`. Used by `stow_linux.sh`.
- **zsh** — `apt install zsh`, then `chsh -s $(which zsh)`.
- **oh-my-zsh** — installer:
  `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`.
  `.zshrc` sources `$ZSH/oh-my-zsh.sh` and uses the `minimal` theme.
- **nvm** — installer at <https://github.com/nvm-sh/nvm>. `.zshrc` sources
  `~/.nvm/nvm.sh`; missing `~/.nvm` is fine, but Node won't be on PATH.
- **direnv** — `apt install direnv`. Linux `.zshrc` doesn't currently hook
  it, but install it anyway if you want per-directory env scoping (mirrors
  the macOS Claude Code account split).
- **`~/.local/bin/env`** — sourced unconditionally by `.zshrc`; create empty
  if missing (`touch ~/.local/bin/env`). This is where personal PATH/env
  additions live outside the repo.

## Terminal & multiplexer

- **Alacritty** — `apt install alacritty` (or build from source if your
  distro's package is too old).
- **tmux** — `apt install tmux`.
- **fzf** — `apt install fzf`. Used by `tmux-sessionizer` (`<prefix> f`).
- **xclip** — `apt install xclip`. tmux copy-mode pipes through
  `xclip -in -selection clipboard`; the `clip` and `i3-screenshot` scripts
  also use it.

## Window manager (i3 stack)

The i3 config at `~/.config/i3/config` autostarts a fairly opinionated
desktop. Anything you don't want, comment out the matching `exec`/`bindsym`.

- **i3** — `apt install i3` (pulls in `i3status`, `i3lock`, `i3-wm`).
- **rofi** — `apt install rofi`. `$mod+i` runs
  `rofi -show combi -modi "combi#custom:$HOME/.local/bin/linkr"`.
- **dex** — `apt install dex`. Runs XDG autostart `.desktop` files.
- **udiskie** — `apt install udiskie`. USB auto-mount + tray.
- **xss-lock** — `apt install xss-lock`. Auto-locks via `i3lock` on suspend.
- **network-manager-gnome** (provides `nm-applet`) —
  `apt install network-manager-gnome`.
- **nitrogen** — `apt install nitrogen`. Wallpaper restorer.
- **picom** — `apt install picom`. Compositor (transparency / vsync).
- **pulseaudio-utils** (provides `pactl`) — `apt install pulseaudio-utils`.
  Bound to `XF86Audio*` keys.
- **libnotify-bin** (provides `notify-send`) —
  `apt install libnotify-bin`. Used by screenshot and bw-type-password
  scripts.

## Browser & linkr

- **Brave Browser** — install from <https://brave.com/linux/>. The
  `brave-work` and `brave-home` wrapper scripts (stowed from
  `linux/bin/.local/bin/`) launch Brave with `--user-data-dir` and
  `--class=brave-work` / `--class=brave-home` so i3 can `assign` them to
  different workspaces.
- **`Brave-Browser-Work.desktop`** in `~/.local/share/applications` is
  stowed by the work-browser launcher entry; rofi picks it up
  automatically.

## Screenshot

- **maim** — `apt install maim`. Screenshot capture.
- **xdotool** — `apt install xdotool`. `i3-screenshot window` uses it to
  grab the active window ID; `bw-type-password` uses `xdotool type` to type
  the password into the focused field.

## Bluetooth & keyboard

- **bluez** (provides `bluetoothctl`) — `apt install bluez`. The `btc` /
  `btcl` zsh aliases call `bt-connect`, and `$mod+b` connects Pixel Buds.
- **udisks2** (provides `udisksctl`), **util-linux** (provides `blkid`,
  `lsblk`) — usually preinstalled. Used by `flash-glove80` to mount and
  copy firmware to the Glove80 keyboard halves. Skip if you don't have a
  Glove80.

## Editor

- **Neovim 0.10+** — distro packages are often too old; prefer the AppImage
  or PPA from <https://github.com/neovim/neovim/blob/master/INSTALL.md>.
- **build-essential & make** — `apt install build-essential`. Needed by
  lazy.nvim to build `nvim-treesitter` parsers and `telescope-fzf-native`
  (`build = "make"`).
- **ripgrep** — `apt install ripgrep`. Used by Telescope `live_grep`.
- **fd-find** — `apt install fd-find` (binary is `fdfind`; symlink to `fd`
  on PATH if you want plain `fd`).
- **Python 3 + pip** — `apt install python3 python3-pip python3-venv`.
  Mason installs `pyright`, `ruff`, `debugpy` into managed Python venvs.
- **Node** (via nvm) — Mason uses `npm` for some LSPs.
- **A Nerd Font** — e.g. download from <https://www.nerdfonts.com>,
  unpack into `~/.local/share/fonts`, run `fc-cache -fv`, then point
  Alacritty at it. `blink.cmp` is configured with
  `nerd_font_variant = 'mono'` and renders boxes without one.

The first `nvim` launch will bootstrap lazy.nvim and `:MasonInstall` the
LSPs listed in `mason-lspconfig.lua` (`pyright`, `ruff`, `lua_ls`) plus
`stylua` and `debugpy`. Run `:checkhealth` afterwards.

## Optional Neovim extras

- **Ollama + `starcoder:3b`** — only required for `llm.nvim` inline FIM
  completion. Install Ollama from <https://ollama.com>, then
  `ollama pull starcoder:3b`. The plugin's `cond` callback skips loading
  if Ollama isn't running on `localhost:11434`, so leaving this out costs
  nothing.
- **Lean 4 toolchain** — only needed if you edit `.lean` files. See
  <https://lean-lang.org/lean4/doc/quickstart.html>.

## Claude Code

- **claude CLI** — install per <https://claude.com/claude-code>. `.zshrc`
  defines `cr` / `crd` aliases. Linux `.zshrc` does not currently set
  `CLAUDE_CONFIG_DIR`; if you want the per-directory account split
  documented for macOS in the README, add `export
  CLAUDE_CONFIG_DIR=$HOME/.claude-work` and `eval "$(direnv hook zsh)"`
  to `linux/zsh/.zshrc`.

## Optional / personal

- **cursor-agent** — no Linux alias is currently set, so nothing depends
  on it.

## Files to port manually (not in repo)

These are listed in the README under "Local files (not committed)". The
most load-bearing ones:

- `~/.bw_master` (Bitwarden master password, `chmod 600`) —
  `bw-type-password` reads it and types via `xdotool`.
- `~/.ssh/`, `~/.gitconfig`.
- `~/.claude-work/`, `~/.claude-personal/` — regenerated by logging in.
- `~/.config/google-drive-mcp/{credentials,gcp-oauth.keys,tokens}.json` —
  only if you use the Google Drive MCP.
