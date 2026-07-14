# harmless macmon — macOS Process Analyzer & Cleanup Tool

**Source:** https://github.com/harmlessparasite

**Version:** 1.01

`harmless macmon` is a single-file, dependency-free command-line tool for macOS that
helps you find and stop unnecessary, high-CPU, or bloatware background
processes. It scans running processes and third-party auto-start services
(LaunchAgents / LaunchDaemons), classifies them by priority, and lets you
kill the ones you don't need — all from a clean terminal UI or a plain-text
report.

> Launch it from any Terminal just by typing: `macmon`

> Built and tested on **Apple Silicon Macs (M1/M2/M3/M4, arm64)**.

---

## What it does on Apple Silicon Macs

- **Process scan** — reads `ps aux` to list every running process with its
  CPU % and memory % usage.
- **Auto-start mapping** — inspects the standard launchd locations:
  - `~/Library/LaunchAgents` (your login items)
  - `/Library/LaunchAgents` (all users)
  - `/Library/LaunchDaemons` (system boot)
  - `/System/Library/Launch{Agents,Daemons}` (Apple's own — flagged read-only)
- **Priority classification** — processes are bucketed into **HIGH /
  MEDIUM / LOW** based on CPU usage, known-bloatware lists, and whether a
  third party is auto-launching them at login or boot.
- **Interactive TUI** — a `curses`-based UI (arrow keys, space to select,
  enter to confirm) for picking and killing processes safely.
- **Plain report mode** — `macmon --no-kill` prints the same analysis as
  colored text with no UI (great for piping / scripting).
- **Session memory** — remembers what you killed last time and marks those
  processes with `↩` on the next run, so repeated cleanups are one keystroke
  (`R`) away.

### Apple Silicon specifics

- Runs natively as a **Python 3** script. macOS ships `python3` on Apple
  Silicon; no Rosetta or extra packages are required.
- Correctly accounts for **System Integrity Protection (SIP)**: system
  binaries under `/System/`, `/usr/libexec/`, etc. are recognized and left
  alone, and killing a protected or root-owned process will automatically
  prompt for `sudo` where needed.
- Reads the modern Apple Silicon system paths (`/System/Cryptexes/`,
  `/System/iOSSupport/`) so bundled system processes aren't mistaken for
  user junk.
- Whether you're on an **arm64 native** or **Rosetta-translated**
  environment, `macmon` only inspects process metadata — it never modifies
  system files, so it's safe on both.

---

## Install

### Option A — Disk image (recommended for most users)

Grab `macmon.dmg` from the releases and:

1. Double-click **`install.command`**.
   - Copies the app to `~/Applications/harmless-macmon/`
  - Symlinks the `macmon` command into `~/bin/macmon` (no admin rights needed)
2. Open a **new** Terminal window and just type:

   ```sh
   macmon
   ```

To remove it later, double-click **`uninstall.command`** in the DMG.

### Option B — Manual

```sh
chmod +x macmon
sudo cp macmon /usr/local/bin/      # or ~/bin if that's on your PATH
macmon
```

---

## Usage

```sh
macmon            # launch the interactive analyzer / cleanup UI
macmon --no-kill  # print the analysis as text without the UI
macmon --high     # show only HIGH-priority processes
macmon --help     # full help
```

### TUI keys

| Key            | Action                                  |
| -------------- | --------------------------------------- |
| ↑ / ↓          | Navigate the list                       |
| SPACE          | Select / deselect a process             |
| ENTER          | Confirm and kill selected processes     |
| R              | Re-select processes killed last session |
| A              | Toggle all HIGH-priority processes      |
| PgUp / PgDn    | Scroll half a page                      |
| Q / ESC        | Quit without killing                    |

### Markers

- `●` Selected for killing
- `★` Has a third-party auto-start (LaunchAgent / Daemon)
- `↩` Was killed in your last `macmon` session

---

## Requirements

- macOS (Apple Silicon or Intel)
- Python 3 (`python3` on `PATH`)

No `pip install`, no compilation — it's one script.

---

## Safety

`macmon` will never touch macOS system processes or anything in
`ESSENTIAL` (launchd, WindowServer, Finder, your shell, Terminal, etc.).
It only acts on processes you explicitly confirm. Killing a root-owned
process will ask for your password via `sudo`.

---

## Files in this repo

| File               | Purpose                                            |
| ------------------ | -------------------------------------------------- |
| `macmon`           | The application (Python 3 CLI script)              |
| `install.command`  | Installer — sets up global `macmon` command        |
| `uninstall.command`| Uninstaller — removes app + launcher + session data|
| `macmon.dmg`       | Prebuilt disk image bundling the above             |
| `README.md`        | This file                                          |
