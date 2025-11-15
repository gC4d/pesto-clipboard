import aiosqlite
from pathlib import Path
from typing import List
from core.models import ClipboardItem
from core.settings import DATABASE_PATH, CREATE_HISTORY_TABLE

class HistoryManager:
    def __init__(self, db_path: Path = DATABASE_PATH):
        self.db_path = db_path

    async def init_db(self):
        """Initialize the database."""
        async with aiosqlite.connect(self.db_path) as db:
            await db.execute(CREATE_HISTORY_TABLE)
            await db.commit()

    async def add_item(self, content: str) -> int:
        """Add a new clipboard item to history."""
        async with aiosqlite.connect(self.db_path) as db:
            cursor = await db.execute(
                "INSERT INTO history (content) VALUES (?)",
                (content,)
            )
            await db.commit()
            return cursor.lastrowid

    async def get_recent(self, limit: int = 50) -> List[ClipboardItem]:
        """Get recent clipboard items."""
        async with aiosqlite.connect(self.db_path) as db:
            cursor = await db.execute(
                "SELECT id, content, created_at, pinned FROM history ORDER BY created_at DESC LIMIT ?",
                (limit,)
            )
            rows = await cursor.fetchall()
            return [ClipboardItem(id=row[0], content=row[1], created_at=row[2], pinned=bool(row[3])) for row in rows]

    async def search(self, query: str, limit: int = 50) -> List[ClipboardItem]:
        """Search clipboard history."""
        async with aiosqlite.connect(self.db_path) as db:
            cursor = await db.execute(
                "SELECT id, content, created_at, pinned FROM history WHERE content LIKE ? ORDER BY created_at DESC LIMIT ?",
                (f"%{query}%", limit)
            )
            rows = await cursor.fetchall()
            return [ClipboardItem(id=row[0], content=row[1], created_at=row[2], pinned=bool(row[3])) for row in rows]

    async def delete_item(self, item_id: int):
        """Delete a clipboard item."""
        async with aiosqlite.connect(self.db_path) as db:
            await db.execute("DELETE FROM history WHERE id = ?", (item_id,))
            await db.commit()

    async def prune(self, max_items: int):
        """Prune history to max_items."""
        async with aiosqlite.connect(self.db_path) as db:
            await db.execute(
                "DELETE FROM history WHERE id NOT IN (SELECT id FROM history ORDER BY created_at DESC LIMIT ?)",
                (max_items,)
            )
            await db.commit()
