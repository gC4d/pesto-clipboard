import asyncio
import os
from typing import Optional
from backend.base_listener import BaseClipboardListener
from backend.x11_listener import X11ClipboardListener
from backend.wayland_listener import WaylandClipboardListener
from backend.history import HistoryManager
from core.settings import DEFAULT_CONFIG

class ClipboardService:
    def __init__(self, config=None):
        self.config = config or DEFAULT_CONFIG
        self.history = HistoryManager()
        self.listener: Optional[BaseClipboardListener] = None

    async def init(self):
        """Initialize the service."""
        await self.history.init_db()
        await self._select_listener()

    async def _select_listener(self):
        """Select appropriate listener based on environment."""
        # Check if Wayland
        if os.environ.get('WAYLAND_DISPLAY'):
            try:
                self.listener = WaylandClipboardListener(self._on_clipboard_change)
                print("Using Wayland listener")
            except Exception as e:
                print(f"Wayland listener failed: {e}")
                self.listener = X11ClipboardListener(self._on_clipboard_change)
                print("Falling back to X11 listener")
        else:
            self.listener = X11ClipboardListener(self._on_clipboard_change)
            print("Using X11 listener")

    async def _on_clipboard_change(self, content: str):
        """Handle clipboard change."""
        if self.config.ignore_duplicates:
            recent = await self.history.get_recent(1)
            if recent and recent[0].content == content:
                return
        await self.history.add_item(content)
        await self.history.prune(self.config.max_history_items)

    async def run(self):
        """Run the clipboard service."""
        await self.init()
        if self.listener:
            await self.listener.run()
