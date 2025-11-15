import os
from pathlib import Path
from .models import Config

# Constants
APP_NAME = "Clipboard Manager"
APP_VERSION = "1.0.0"

# Default config
DEFAULT_CONFIG = Config()

# Database schema
CREATE_HISTORY_TABLE = """
CREATE TABLE IF NOT EXISTS history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pinned BOOLEAN DEFAULT 0
);
"""

# Paths
CONFIG_DIR = Path.home() / ".config" / "clipboard_manager"
DATABASE_PATH = CONFIG_DIR / "history.db"

# Ensure config directory exists
CONFIG_DIR.mkdir(parents=True, exist_ok=True)
