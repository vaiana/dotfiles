# dotfiles

Configuration for macOS and Linux, managed with [GNU stow](https://www.gnu.org/software/stow/).

## Setup

Clone the repo and run the appropriate script:

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles

# macOS
./stow_mac.sh

# Linux
./stow_linux.sh
```

Each script stows everything in `shared/` followed by the platform-specific directory.

## Structure

```
dotfiles/
├── shared/          # All platforms
│   ├── alacritty/
│   ├── bin/         # linkr, tmux-sessionizer
│   └── nvim/
├── linux/
│   ├── bin/         # clip, i3-screenshot
│   ├── i3/
│   ├── linkr/
│   ├── rofi/
│   ├── rofi-themes/
│   └── tmux/
├── macos/
│   ├── aerospace/
│   ├── bin/         # linkr-pick, screenshot
│   ├── linkr/
│   ├── tmux/
│   └── zsh/
├── stow_mac.sh
└── stow_linux.sh
```

## linkr

`linkr` is a script that maps short names to browser commands. Run it with no arguments
to list all shortcuts, or pass a name to open it:

```bash
linkr go/github     # opens in personal browser
linkr w/mail        # opens in work browser
```

On Linux, `$mod+i` opens a rofi picker backed by linkr. On macOS, `alt-i` opens a
choose-gui picker with the same shortcuts.

Platform-specific browser configs live in `linux/linkr/` and `macos/linkr/`.

## Browser setup

### Linux

i3 auto-places browser windows using the `--class` flag. A separate work browser
instance is launched with:

```
brave-browser-stable --user-data-dir=$HOME/.config/brave-work --class=brave-work
```

A custom desktop entry (`Brave-Browser-Work.desktop`) in `~/.local/share/applications`
makes this launchable from rofi.

### macOS

Two browsers, fully isolated profiles, AeroSpace routes them to different
workspaces:

- **Brave Browser** (`/Applications/Brave Browser.app`, bundle id
  `com.brave.Browser`) — work. System default browser, so clicked links from
  Slack / Mail / etc. land here. AeroSpace → workspace 2.
- **Brave Home** (`/Applications/Brave Home.app`, bundle id
  `com.brave.Browser.home`) — personal. Distinct `--user-data-dir` so it's
  blind to the work profile and vice versa. AeroSpace → workspace 1.

#### Why a wrapper bundle

The Linux `--class=brave-work` trick doesn't work on macOS — AeroSpace routes
on bundle id, and two `Brave Browser.app` instances launched with different
`--user-data-dir`s both report `com.brave.Browser`. To get a genuinely
separate bundle id, `Brave Home.app` is a full rebranded copy of
`Brave Browser.app`:

- All `CFBundleIdentifier` values rewritten from `com.brave.Browser*` to
  `com.brave.Browser.home*` (top-level + framework + helper apps).
- Main executable replaced with a shell script that exec's the renamed
  Brave launcher with `--user-data-dir=…/Brave-Browser-Home` baked in, so
  every launch path (Spotlight, Dock, linkr, `open -a "Brave Home"`) uses
  the home profile.
- `BraveUpdater.app` removed so it can't auto-update the wrapper and revert
  the Info.plist edits.
- Re-signed ad-hoc and registered with Launch Services.

The build is automated by `~/.local/bin/rebuild-brave-home` (source in
`macos/bin/.local/bin/rebuild-brave-home`). It only writes to
`/Applications/Brave Home.app`; it never touches Brave Stable or any user
data dir.

#### Keeping Brave Home up to date

Brave Stable auto-updates itself but can't reach inside `Brave Home.app`, so
Brave Home is version-frozen at the moment of last rebuild. To pull in the
latest Chromium / Brave fixes:

```bash
# Quit Brave Home first (the script rm -rf's the bundle)
rebuild-brave-home
```

Then relaunch Brave Home. macOS will prompt once with "Brave Home wants to
use your confidential information stored in 'Brave Safe Storage'" — click
Always Allow. (It re-prompts on every rebuild because the ad-hoc code
signature changes.)

To check whether a rebuild is overdue, compare versions in
`brave://version` between Brave Browser and Brave Home. There's no urgency —
Brave Home keeps working indefinitely without rebuilding; you're just behind
on security/feature updates until you do.

## Bitwarden unlock

Bitwarden master password is bound to `Alt+p` on Linux (i3, types directly
into the focused field) and `Alt+Cmd+P` on macOS (AeroSpace, copies to the
clipboard then sends Cmd+V to the focused app, then restores the prior
clipboard). macOS uses a Cmd combo because alt/alt-shift combos produce
typed special characters when AeroSpace fails to capture the binding
(observed when a browser is focused), and clipboard+paste because
synthesized character keystrokes don't reliably reach browser password
fields. The password itself is not stored in this repo — create it on each
machine:

```bash
echo -n 'your-master-password' > ~/.bw_master
chmod 600 ~/.bw_master
```

AeroSpace needs Accessibility permission so System Events can deliver the
synthetic Cmd+V to the focused app (System Settings → Privacy & Security →
Accessibility).

## tmux

The prefix is `Ctrl+a` on both platforms. On macOS, Alacritty is configured to send
`Ctrl+a` when `Cmd+a` is pressed so muscle memory stays consistent across platforms.

Clipboard integration uses `xclip` on Linux and `pbcopy` on macOS.

## Claude Code accounts

Two Claude Code subscription logins on one machine, scoped per directory.
Work account is the default; personal account activates inside `~/rc/`.

The mechanism is the `CLAUDE_CONFIG_DIR` env var, which Claude Code reads
its credential store from (falling back to `~/.claude/`). Two stores live
side by side:

- `~/.claude-work/` — work account (default)
- `~/.claude-personal/` — personal account, used inside `~/rc/`

`.zshrc` exports `CLAUDE_CONFIG_DIR=$HOME/.claude-work` as the default and
hooks `direnv`. `~/rc/.envrc` overrides the variable to `~/.claude-personal`
when shells start anywhere under `~/rc/`. Switching is per-process: each
shell evaluates its own `CLAUDE_CONFIG_DIR` at startup, so two tmux panes
can run different subscriptions concurrently.

`<prefix> f` (tmux-sessionizer) spawns a fresh shell in the chosen dir, so
new sessions inherit the right account automatically. Existing sessions
keep whatever account they started with — `cd`'ing across the boundary
inside one shell flips the env on the next prompt via direnv's hook.

The legacy `~/.claude/` directory is unused once `CLAUDE_CONFIG_DIR` is set.

## Local files (not committed)

These files live outside this repo but are needed for a full working setup.
Port them manually (scp from another machine, restore from a backup, or
regenerate) after cloning.

### Secrets / credentials

- `~/.bw_master` — Bitwarden master password (see "Bitwarden unlock"; `chmod 600`).
- `~/.ssh/` — SSH keys, including the `github` keypair used for pushing. Permissions: `700` on the dir, `600` on private keys.
- `~/.gitconfig` — git user/email/editor config. Small and safe to copy as-is.
- `~/.credentials/personal/claude-code-oauth-token` — Claude Code OAuth token. Regenerated by logging in via `claude` CLI if missing.
- `~/.claude-work/` and `~/.claude-personal/` — Claude Code credential
  stores, one per account (see "Claude Code accounts"). Each holds its own
  `.credentials.json` and `.claude.json`; both are regenerated by logging
  in via the `claude` CLI with the matching `CLAUDE_CONFIG_DIR` set.
- `~/rc/.envrc` — direnv config that scopes `CLAUDE_CONFIG_DIR` to the
  personal account inside `~/rc/`. After creating, run `direnv allow ~/rc`.

### MCP auth

- `~/.config/google-drive-mcp/credentials.json`
- `~/.config/google-drive-mcp/gcp-oauth.keys.json`
- `~/.config/google-drive-mcp/tokens.json`

The two `*.json` key files are the OAuth client config; `tokens.json` is the
refresh token. Without these, the Google Drive MCP won't authenticate.

### Install-required (not secrets, but the stowed configs assume they exist)

- `~/.oh-my-zsh` — installed via the oh-my-zsh installer. The minimal theme assumes it's present.
- `~/.nvm` — installed via the nvm installer. `.zshrc` sources it.
- `stow` itself — `brew install stow` (macOS) or `apt install stow` (Linux).
- `direnv` — `brew install direnv` (macOS) or `apt install direnv` (Linux).
  Hooked from `.zshrc` and required for the per-directory Claude account
  switching (see "Claude Code accounts").
