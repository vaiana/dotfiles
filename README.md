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

macOS doesn't support `--user-data-dir` window detection the same way, so instead
Brave Stable is used for work and Brave Beta for personal. Aerospace identifies them
by their distinct bundle IDs (`com.brave.Browser` vs `com.brave.Browser.beta`) and
routes them to workspaces 1 and 2 automatically.

## Bitwarden unlock (Linux)

`Alt+p` types your Bitwarden master password into the focused field. The password
itself is not stored in this repo — you need to create it on each machine:

```bash
echo -n 'your-master-password' > ~/.bw_master
chmod 600 ~/.bw_master
```

## tmux

The prefix is `Ctrl+a` on both platforms. On macOS, Alacritty is configured to send
`Ctrl+a` when `Cmd+a` is pressed so muscle memory stays consistent across platforms.

Clipboard integration uses `xclip` on Linux and `pbcopy` on macOS.
