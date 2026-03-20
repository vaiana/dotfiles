# Brave Browser Profile Separation (Linux)

## Problem

We use two Brave browser profiles on Linux — one for work and one for personal.
Links clicked in external apps (Slack, terminals, etc.) should open in the **work** profile.

## What didn't work

### 1. Custom `.desktop` file as default browser

Created a `brave-work.desktop` with `--user-data-dir` and set it as the default via
`xdg-settings`. This failed because Chromium uses **process singletons** per user-data-dir.
If the default Brave (no `--user-data-dir`) was already running, it would absorb all new
URLs regardless of what the `.desktop` file specified. The `--user-data-dir` flag was
silently ignored.

### 2. Swapping profile data directories

Tried making the default Brave (no flags) the work profile by swapping the data:

```
mv ~/.config/BraveSoftware/Brave-Browser → ~/.config/brave-home
mv ~/.config/brave-work → ~/.config/BraveSoftware/Brave-Browser
```

This caused two problems:
- The `--user-data-dir` profile structure is flat (`brave-work/Default/...`) but when
  moved into `BraveSoftware/Brave-Browser/`, Brave created a **new** fresh `Default/`
  at the top level and the real data ended up nested at `Brave-Browser/Brave-Browser/`.
- Launching default Brave against this directory overwrote the top-level `Default/`
  with a fresh profile, making it look like all logins/settings were lost.

## Solution that works

Both profiles are launched with **explicit `--user-data-dir` and `--class` flags**,
giving each its own Chromium process singleton. This means they run as truly independent
instances that don't interfere with each other.

### Components

1. **System desktop entry** (`/usr/share/applications/brave-browser-work.desktop`):
   Already existed on this system. Uses `--user-data-dir=$HOME/.config/brave-work`
   and `--class=brave-work`. Set as the default browser via `xdg-settings` so that
   clicked links from Slack/terminals go to the work instance.

2. **`brave-work` wrapper** (`linux/bin/.local/bin/brave-work`):
   Shell script used by linkr for `w/` links. Same flags as the desktop entry.

3. **`brave-home` wrapper** (`linux/bin/.local/bin/brave-home`):
   Shell script for launching the personal profile with
   `--user-data-dir=$HOME/.config/BraveSoftware/Brave-Browser` and `--class=brave-home`.

4. **`brave-home.desktop`** (`linux/applications/.local/share/applications/`):
   Desktop entry for rofi to launch the personal profile.

5. **Hidden duplicate entries** (`brave-browser.desktop`, `brave-work.desktop`,
   `com.brave.Browser.desktop` in `~/.local/share/applications/`):
   Override system entries with `NoDisplay=true` so rofi only shows the two entries
   we want: "Brave Web Browser Work" (system) and "Brave Web Browser (Home)" (ours).

6. **`~/.config/mimeapps.list`**: All HTTP/HTTPS and HTML MIME types point to
   `brave-browser-work.desktop`. This file is **not** managed by stow — it's set
   via `xdg-settings set default-web-browser brave-browser-work.desktop`.

7. **i3 config**: Workspace assignments use WM class matching:
   - `brave-home` → workspace 1
   - `brave-work` → workspace 2

### Data locations

- Work profile: `~/.config/brave-work/`
- Personal profile: `~/.config/BraveSoftware/Brave-Browser/`

## Best practices for backup

**Before making any changes to browser profiles:**

1. Close ALL Brave instances (`pgrep -a brave` to verify)
2. Back up both data directories:
   ```bash
   tar czf ~/brave-work-backup-$(date +%Y%m%d).tar.gz -C ~/.config brave-work
   tar czf ~/brave-home-backup-$(date +%Y%m%d).tar.gz -C ~/.config/BraveSoftware Brave-Browser
   ```
3. Never move or rename profile directories while Brave is running — Chromium will
   create fresh profiles and you'll lose track of which directory has the real data
4. After restoring, verify the profile is correct by checking:
   ```bash
   python3 -c "
   import json
   with open('<profile-dir>/Default/Preferences') as f:
       d = json.load(f)
   print('vertical_tabs:', d.get('brave',{}).get('tabs',{}).get('vertical_tabs_enabled'))
   "
   ```

## To change the default link-opening profile

1. Close all Brave instances
2. Run: `xdg-settings set default-web-browser <desktop-file>`
   - Work: `brave-browser-work.desktop`
   - Personal: `brave-home.desktop`
3. Verify: `xdg-settings get default-web-browser`
4. Update all MIME types if needed:
   ```bash
   xdg-mime default <desktop-file> x-scheme-handler/http x-scheme-handler/https \
     x-scheme-handler/chrome text/html application/xhtml+xml \
     application/x-extension-htm application/x-extension-html \
     application/x-extension-shtml application/x-extension-xhtml \
     application/x-extension-xht
   ```
