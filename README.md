# Clipboard Manager

A Linux clipboard manager written in Python, optimized for Fedora systems using Wayland and X11.

## Features

- Background daemon that monitors clipboard changes
- SQLite-based history storage
- GTK4-based UI for viewing and managing clipboard history
- Tray icon for quick access
- Support for both Wayland and X11 environments

## Installation

### System Dependencies (Fedora)

```bash
sudo dnf install python3-gobject gobject-introspection-devel gtk4 gtk4-devel libappindicator-gtk3 xclip xsel sqlite-devel dbus-devel libX11-devel
```

### Python Dependencies

```bash
pip install -r requirements.txt
```

## Usage

### Daemon Mode (Background)

```bash
python daemon.py
```

### GUI Mode

```bash
python app.py
```

## Architecture

- `core/`: Core models and settings
- `backend/`: Clipboard listeners and history management
- `ui/`: GTK4 UI components
- `daemon.py`: Background service entrypoint
- `app.py`: GUI application entrypoint

## Configuration

Edit the config in `core/settings.py` or modify the `Config` model in `core/models.py`.
