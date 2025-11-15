from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class ClipboardItem(BaseModel):
    id: Optional[int] = None
    content: str
    created_at: Optional[datetime] = None
    pinned: bool = False

    class Config:
        from_attributes = True

class Config(BaseModel):
    max_history_items: int = 100
    debounce_ms: int = 100
    history_database_path: str = "~/.clipboard_manager/history.db"
    ignore_duplicates: bool = True
