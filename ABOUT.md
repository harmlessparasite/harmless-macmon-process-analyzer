# ABOUT — macmon

> Author: Wasim Osman

> Future-reference notes for this project. (See `README.md` for full user docs.)

## What this app is

**macmon** is a single-file, dependency-free command-line tool for
macOS that helps you find and stop unnecessary, high-CPU, or bloatware
background processes. It is a Python 3 script (`macmon`) — no compilation,
no `pip install`, no third-party packages (uses only the Python standard
library: curses, subprocess, os, sys, plistlib, signal, json, re, pathlib,
collections, datetime).

## What it does

- Scans running processes (`ps aux`) for CPU/memory usage.
- Maps third-party auto-start services from LaunchAgents / LaunchDaemons.
- Classifies processes into **HIGH / MEDIUM / LOW** priority.
- Provides an interactive `curses` TUI to select and kill processes, or a
  plain-text report mode (`macmon --no-kill`).
- Remembers what you killed last session (`~/.local/share/macmon/session.json`).

## Platform

- Built and tested on **Apple Silicon Macs (M1/M2/M3/M4, arm64)**.
- Runs natively under the system Python 3; never modifies system files.
- System/SIP-protected processes are left alone; root-owned kills prompt for `sudo`.

## Install / uninstall (from the DMG)

- `install.command` copies the app to `~/Applications/macmon/`
  and symlinks the `macmon` command into `~/bin/macmon` (falls back to
  `~/bin` when `/usr/local/bin` isn't writable). It also ensures Python 3
  is present.
- `uninstall.command` removes the app folder, the `~/bin/macmon` symlink,
  and session data.

## Usage

```sh
macmon            # interactive analyzer / cleanup UI
macmon --no-kill  # text report, no UI
macmon --high     # HIGH priority only
macmon --help     # help
```

## Project layout (this repo)

| File                | Purpose                                     |
| ------------------- | ------------------------------------------- |
| `macmon`            | The application (Python 3 CLI script)       |
| `install.command`   | Installer — sets up the global `macmon` cmd |
| `uninstall.command` | Uninstaller                                 |
| `macmon-1.01.dmg`   | Prebuilt disk image (released on GitHub)    |
| `README.md`         | Full user documentation                     |
| `ABOUT.md`          | This future-reference summary               |

## Version

Current release: **1.01** (tag `v1.01` on GitHub).

## Source

https://github.com/harmlessparasite/macmon-process-analyzer
