import asyncio
from typing import Callable, Awaitable
from Xlib import X, display
from Xlib.ext import record
from Xlib.protocol import rq

from .base_listener import BaseClipboardListener

class X11ClipboardListener(BaseClipboardListener):
    def __init__(self, on_clipboard_change: Callable[[str], Awaitable[None]]):
        super().__init__(on_clipboard_change)
        self.disp = display.Display()
        self.root = self.disp.screen().root
        self.last_content = ""
        self.debounced = False

    async def run(self) -> None:
        """Start listening for X11 clipboard changes."""
        # Set up record extension to monitor clipboard events
        ctx = self.disp.record_create_context(
            0,
            [record.AllClients],
            [{
                'core_requests': (0, 0),
                'core_replies': (0, 0),
                'ext_requests': (0, 0, 0, 0),
                'ext_replies': (0, 0, 0, 0),
                'delivered_events': (X.SelectionNotify, X.PropertyNotify),
                'device_events': (0, 0),
                'errors': (0, 0),
                'client_started': False,
                'client_died': False,
            }]
        )

        self.disp.record_enable_context(ctx, self._record_callback)
        self.disp.record_free_context(ctx)

        while True:
            event = self.disp.next_event()
            if event.type == X.PropertyNotify and event.atom == self.disp.intern_atom('CLIPBOARD'):
                await self._check_clipboard()
            elif event.type == X.SelectionNotify:
                await self._check_clipboard()
            await asyncio.sleep(0.01)  # Small delay to avoid busy loop

    def _record_callback(self, reply):
        """Callback for record extension events."""
        if reply.category != record.FromServer:
            return
        if reply.client_swapped:
            return

        data = reply.data
        while len(data):
            event, data = rq.EventField(None).parse_binary_value(data, self.disp.display, None, None)
            if event.type == X.PropertyNotify:
                atom = self.disp.get_atom_name(event.atom)
                if atom in ['CLIPBOARD', 'PRIMARY']:
                    asyncio.create_task(self._check_clipboard())

    async def _check_clipboard(self) -> None:
        """Check if clipboard content has changed."""
        if self.debounced:
            return
        self.debounced = True
        await asyncio.sleep(0.1)  # Debounce
        content = await self.get_current_clipboard_text()
        if content and content != self.last_content:
            self.last_content = content
            await self.on_clipboard_change(content)
        self.debounced = False

    async def get_current_clipboard_text(self) -> str:
        """Get current clipboard text using xclip or similar."""
        import subprocess
        try:
            result = subprocess.run(['xclip', '-o', '-selection', 'clipboard'], capture_output=True, text=True)
            if result.returncode == 0:
                return result.stdout.strip()
            result = subprocess.run(['xclip', '-o', '-selection', 'primary'], capture_output=True, text=True)
            return result.stdout.strip() if result.returncode == 0 else ""
        except Exception:
            return ""
