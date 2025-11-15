import asyncio
from typing import List, Callable
import gi
gi.require_version('Gtk', '4.0')
from gi.repository import Gtk, Gio, Gdk

from core.models import ClipboardItem
from backend.history import HistoryManager

class HistoryWindow(Gtk.ApplicationWindow):
    def __init__(self, history_manager: HistoryManager, on_item_selected: Callable[[str], None]):
        super().__init__(title="Clipboard History")
        self.history_manager = history_manager
        self.on_item_selected = on_item_selected
        self.items = []

        self.set_default_size(600, 400)

        # Create main box
        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.set_child(main_box)

        # Search entry
        self.search_entry = Gtk.Entry()
        self.search_entry.set_placeholder_text("Search clipboard history...")
        self.search_entry.connect("changed", self.on_search_changed)
        main_box.append(self.search_entry)

        # Scrolled window for list
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_vexpand(True)
        main_box.append(scrolled)

        # List box
        self.list_box = Gtk.ListBox()
        self.list_box.connect("row-activated", self.on_row_activated)
        scrolled.set_child(self.list_box)

        # Load initial items
        asyncio.create_task(self.load_items())

    async def load_items(self, query: str = ""):
        """Load clipboard items."""
        if query:
            self.items = await self.history_manager.search(query)
        else:
            self.items = await self.history_manager.get_recent()

        # Clear list
        while True:
            row = self.list_box.get_first_child()
            if row is None:
                break
            self.list_box.remove(row)

        # Add items
        for item in self.items:
            row = self.create_item_row(item)
            self.list_box.append(row)

    def create_item_row(self, item: ClipboardItem) -> Gtk.ListBoxRow:
        """Create a row for a clipboard item."""
        row = Gtk.ListBoxRow()
        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        row.set_child(box)

        # Content label
        label = Gtk.Label(label=item.content[:100] + "..." if len(item.content) > 100 else item.content)
        label.set_halign(Gtk.Align.START)
        label.set_hexpand(True)
        box.append(label)

        # Buttons
        button_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=3)
        box.append(button_box)

        copy_button = Gtk.Button(label="Copy")
        copy_button.connect("clicked", lambda w: self.on_item_selected(item.content))
        button_box.append(copy_button)

        pin_button = Gtk.ToggleButton(label="Pin" if not item.pinned else "Unpin")
        pin_button.set_active(item.pinned)
        button_box.append(pin_button)

        delete_button = Gtk.Button(label="Delete")
        delete_button.connect("clicked", lambda w: asyncio.create_task(self.delete_item(item.id)))
        button_box.append(delete_button)

        return row

    def on_search_changed(self, entry):
        """Handle search entry change."""
        query = entry.get_text()
        asyncio.create_task(self.load_items(query))

    def on_row_activated(self, list_box, row):
        """Handle row activation."""
        index = row.get_index()
        if index < len(self.items):
            self.on_item_selected(self.items[index].content)

    async def delete_item(self, item_id: int):
        """Delete an item."""
        await self.history_manager.delete_item(item_id)
        await self.load_items(self.search_entry.get_text())
