import asyncio
from typing import Callable

from core.settings import APP_NAME

class TrayIcon:
    def __init__(self, on_show_history: Callable, on_clear_history: Callable, on_quit: Callable):
        self.on_show_history = on_show_history
        self.on_clear_history = on_clear_history
        self.on_quit = on_quit

    def setup(self):
        """Dummy setup - no tray available."""
        pass

    def run(self):
        """Dummy run - no tray available."""
        pass
