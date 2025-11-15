import asyncio
from typing import Callable, Awaitable
from dbus_next import BusType, Message
from dbus_next.aio import MessageBus

from .base_listener import BaseClipboardListener

class WaylandClipboardListener(BaseClipboardListener):
    def __init__(self, on_clipboard_change: Callable[[str], Awaitable[None]]):
        super().__init__(on_clipboard_change)
        self.bus = None
        self.last_content = ""

    async def run(self) -> None:
        """Start listening for Wayland clipboard changes via DBus portal."""
        self.bus = await MessageBus(bus_type=BusType.SESSION).connect()

        # Subscribe to clipboard signals
        await self.bus.call(
            Message(
                destination='org.freedesktop.portal.Desktop',
                path='/org/freedesktop/portal/desktop',
                interface='org.freedesktop.portal.Clipboard',
                member='ReadClipboardData'
            )
        )

        # Listen for signals
        self.bus.add_message_handler(self._handle_message)

        while True:
            await asyncio.sleep(1)  # Keep alive, signals will trigger handlers

    def _handle_message(self, message):
        """Handle incoming DBus messages."""
        if message.interface == 'org.freedesktop.portal.Clipboard':
            if message.member == 'ClipboardChanged':
                asyncio.create_task(self._check_clipboard())

    async def _check_clipboard(self) -> None:
        """Check clipboard content via portal."""
        content = await self.get_current_clipboard_text()
        if content and content != self.last_content:
            self.last_content = content
            await self.on_clipboard_change(content)

    async def get_current_clipboard_text(self) -> str:
        """Get current clipboard text via DBus portal."""
        try:
            reply = await self.bus.call(
                Message(
                    destination='org.freedesktop.portal.Desktop',
                    path='/org/freedesktop/portal/desktop',
                    interface='org.freedesktop.portal.Clipboard',
                    member='ReadClipboardData',
                    signature='s',
                    body=['text/plain']
                )
            )
            if reply and reply.body:
                return reply.body[0]
        except Exception:
            pass
        return ""
