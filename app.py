#!/usr/bin/env python3
import asyncio
import sys
from pathlib import Path
import gi
gi.require_version('Gtk', '4.0')
from gi.repository import Gtk, GLib

sys.path.insert(0, str(Path(__file__).parent))

from backend.history import HistoryManager
from ui.window import HistoryWindow
from ui.tray import TrayIcon

class ClipboardManagerApp(Gtk.Application):
    def __init__(self):
        super().__init__(application_id="com.example.PestoClipboard")
        GLib.set_application_name("Pesto Clipboard")
        GLib.set_prgname("Pesto")
        self.history_manager = HistoryManager()
        self.window = None
        self.tray = None

    def do_activate(self):
        """Activate the application."""
        GLib.idle_add(self._init_async)

    def _init_async(self):
        """Initialize async components."""
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        loop.run_until_complete(self.init_app())
        return False  # Don't repeat

    async def init_app(self):
        """Initialize the app."""
        await self.history_manager.init_db()
        self.setup_tray()
        self.setup_window()

    def setup_tray(self):
        """Setup the tray icon."""
        self.tray = TrayIcon(
            on_show_history=self.show_history,
            on_clear_history=self.clear_history,
            on_quit=self.quit
        )
        asyncio.create_task(self.run_tray())

    async def run_tray(self):
        """Run the tray in a separate thread."""
        await asyncio.to_thread(self.tray.run)

    def setup_window(self):
        """Setup the history window."""
        self.window = HistoryWindow(self.history_manager, self.on_item_selected)
        self.window.connect("close-request", self.on_window_close)
        self.add_window(self.window)
        self.window.present()

    def show_history(self):
        """Show the history window."""
        if self.window:
            self.window.present()

    async def clear_history(self):
        """Clear all history."""
        # Implement clear logic if needed
        pass

    def on_item_selected(self, content: str):
        """Handle item selection - copy to clipboard."""
        clipboard = Gdk.Display.get_default().get_clipboard()
        clipboard.set_text(content)

    def on_window_close(self, window):
        """Handle window close."""
        window.hide()
        return True

def main():
    app = ClipboardManagerApp()
    app.run(sys.argv)

if __name__ == "__main__":
    main()
