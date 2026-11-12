# macOS dependencies

Tools the stowed configs assume are installed. Items are grouped by what depends
on them, so you can skip a section if you don't use that piece.

For Homebrew install commands to work, install Homebrew first:
<https://brew.sh>.

## Core (everything needs these)

- **stow** — `brew install stow`. Used by `stow_mac.sh`.
- **oh-my-zsh** — installer:
  `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`.
  Both `.zshrc` files source `$ZSH/oh-my-zsh.sh` and use the `minimal` theme.
- **nvm** — installer at <https://github.com/nvm-sh/nvm>. `.zshrc` sources
  `~/.nvm/nvm.sh`; missing `~/.nvm` is fine (the source is guarded), but Node
  won't be on PATH.
- **direnv** — `brew install direnv`. `.zshrc` runs `eval "$(direnv hook zsh)"`,
  and `~/rc/.envrc` flips `CLAUDE_CONFIG_DIR` for the personal Claude Code
  account (see README "Claude Code accounts").
- **gnu-sed** — `brew install gnu-sed`. `.zshrc` aliases `sed=gsed`.
- **`~/.local/bin/env`** — sourced unconditionally by `.zshrc`; create an empty
  file if you don't have one to port over (`touch ~/.local/bin/env`). This is
  where personal PATH/env additions live outside the repo.

## Terminal & multiplexer

- **Alacritty** — `brew install --cask alacritty`. AeroSpace's `alt-enter`
  binding launches it.
- **tmux** — `brew install tmux`. `~/.tmux.conf` is stowed.
- **fzf** — `brew install fzf`. Used by `tmux-sessionizer` (`<prefix> f`).
- **choose-gui** — `brew install choose-gui`. `linkr-pick` hardcodes
  `/opt/homebrew/bin/choose` for the `alt-i` link picker.

## Window manager

- **AeroSpace** — `brew install --cask nikitabobko/tap/aerospace`. Config at
  `~/.config/aerospace/aerospace.toml`. After install, grant Accessibility
  permission in System Settings → Privacy & Security → Accessibility (needed
  for the Cmd+V synthetic keystroke in `bw-type-password`).

## Home-row mods (built-in keyboard)

Gives the laptop keyboard the same home-row mods the Glove80 does in firmware —
`a/s/d/f` = ctrl/alt/cmd/shift, `;/l/k/j` = ctrl/alt/cmd/shift. Config lives at
`~/.config/kanata/kanata.kbd`; skip this whole section if you always have the
Glove80 with you.

Three pieces, in order:

1. **Karabiner VirtualHIDDevice driver, v6.2.0 exactly** — kanata is built
   against that release's IPC and pqrs ships protocol changes between minor
   versions, so newer driver releases are not guaranteed to work. Download
   `Karabiner-DriverKit-VirtualHIDDevice-6.2.0.pkg` from
   <https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/tag/v6.2.0>,
   install it, then activate the system extension:

   ```sh
   sudo installer -pkg ~/Downloads/Karabiner-DriverKit-VirtualHIDDevice-6.2.0.pkg -target /
   sudo /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager forceActivate
   ```

   Then approve it in System Settings → General → Login Items & Extensions →
   Driver Extensions. Verify with `sudo launchctl list | grep org.pqrs`.

   The .pkg installs the daemon binary but no launchd job (Karabiner-Elements
   normally manages it, and we don't install Karabiner-Elements), so the plist
   stowed alongside the config supplies it:

   ```sh
   sudo cp ~/.config/kanata/launchd/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist /Library/LaunchDaemons/
   sudo chown root:wheel /Library/LaunchDaemons/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist
   sudo launchctl bootstrap system /Library/LaunchDaemons/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist
   ```

2. **kanata** — `brew install kanata`. Grant it Input Monitoring and
   Accessibility in System Settings → Privacy & Security. Test in the
   foreground first, so failures are visible and `Ctrl+C` gets you out:

   ```sh
   sudo kanata --cfg ~/.config/kanata/kanata.kbd
   ```

3. **Run it at boot** — `sudo brew services start kanata`. The formula's
   service block already points at `~/.config/kanata/kanata.kbd` and runs from
   `/opt/homebrew/opt/kanata/bin/kanata`, a stable path across upgrades. Logs
   go to `/opt/homebrew/var/log/kanata.log`. `sudo brew services stop kanata`
   turns the mods off; a `--cfg` reload is `sudo brew services restart kanata`.

The config sets `macos-dev-names-include ("Apple Internal Keyboard / Trackpad")`
so kanata only grabs the built-in keyboard. The Glove80 passes through
untouched — without that filter its firmware hold-taps would be re-processed by
kanata and misfire. Use `kanata --list` to get the exact name of another
keyboard you want to add.

## Browsers & linkr

- **Brave Browser** — `brew install --cask brave-browser`. The work browser;
  also the source bundle for Brave Home.
- **Brave Home** — built locally by `~/.local/bin/rebuild-brave-home` (stowed
  from `macos/bin/`). It rewrites `Brave Browser.app` into a separate
  `com.brave.Browser.home` bundle so AeroSpace can route the two profiles to
  different workspaces. Run it once after installing Brave; rerun after Brave
  updates if you want the security/feature deltas. See README "Browser setup
  → macOS" for the full story. Uses only macOS-bundled tools (`codesign`,
  `xattr`, `/usr/libexec/PlistBuddy`, `lsregister`) — no extra installs.

## Editor

- **Neovim 0.10+** — `brew install neovim`.
- **C compiler & make** — `xcode-select --install`. Needed by lazy.nvim to
  build `nvim-treesitter` parsers and `telescope-fzf-native` (`build = "make"`).
- **ripgrep** — `brew install ripgrep`. Used by Telescope `live_grep`.
- **fd** — `brew install fd`. Used by Telescope `find_files`.
- **Python 3** — `brew install python` (or any 3.x). Mason installs `pyright`,
  `ruff`, and `debugpy` into Python-managed locations.
- **Node** (via nvm) — Mason uses `npm` to install some LSPs (e.g. `pyright`).
- **A Nerd Font** — e.g. `brew install --cask font-jetbrains-mono-nerd-font`,
  then point Alacritty at it. `blink.cmp` is configured with
  `nerd_font_variant = 'mono'` and renders boxes without one.

The first `nvim` launch will bootstrap lazy.nvim and `:MasonInstall` the LSPs
listed in `mason-lspconfig.lua` (`pyright`, `ruff`, `lua_ls`) plus `stylua`
and `debugpy`. Run `:checkhealth` afterwards.

## Optional Neovim extras

- **Ollama + `starcoder:3b`** — only required for `llm.nvim` inline FIM
  completion. Install Ollama from <https://ollama.com>, then
  `ollama pull starcoder:3b`. The plugin's `cond` callback skips loading if
  Ollama isn't running on `localhost:11434` or the model isn't pulled, so
  leaving this out costs nothing.
- **Lean 4 toolchain** — only needed if you edit `.lean` files. See
  <https://lean-lang.org/lean4/doc/quickstart.html>.

## Claude Code

- **claude CLI** — install per <https://claude.com/claude-code>. `.zshrc`
  defines `cr` / `crd` aliases and exports `CLAUDE_CONFIG_DIR=~/.claude-work`.
  Personal account lives in `~/.claude-personal/` and is selected inside
  `~/rc/` via direnv. After install, log into each account separately with
  the matching env var set (see README "Claude Code accounts").

## Optional / personal

- **cursor-agent** — `.zshrc` aliases `ca="cursor-agent"`. Ships with Cursor
  (<https://cursor.sh>); the alias just fails harmlessly if not installed.
- **nmap** — `brew install nmap`. Only used by `find-deep` (locates the
  `deep` SSH host on the LAN). Skip unless you use that script.

## Files to port manually (not in repo)

These are listed in the README under "Local files (not committed)". The most
load-bearing ones:

- `~/.bw_master` (Bitwarden master password, `chmod 600`) — `bw-type-password`
  reads it and pastes via Cmd+V.
- `~/.ssh/`, `~/.gitconfig`.
- `~/.claude-work/`, `~/.claude-personal/` — regenerated by logging in.
- `~/rc/.envrc` — then `direnv allow ~/rc`.
- `~/.config/google-drive-mcp/{credentials,gcp-oauth.keys,tokens}.json` — only
  if you use the Google Drive MCP.
