from abc import ABC, abstractmethod
from typing import Callable, Awaitable

class BaseClipboardListener(ABC):
    def __init__(self, on_clipboard_change: Callable[[str], Awaitable[None]]):
        self.on_clipboard_change = on_clipboard_change

    @abstractmethod
    async def run(self) -> None:
        """Start listening for clipboard changes."""
        pass

    @abstractmethod
    async def get_current_clipboard_text(self) -> str:
        """Get the current clipboard text content."""
        pass
