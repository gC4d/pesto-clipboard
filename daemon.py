#!/usr/bin/env python3
import asyncio
import logging
import signal
import sys
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent))

from backend.service import ClipboardService

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

async def main():
    """Main daemon function."""
    service = ClipboardService()

    def signal_handler(signum, frame):
        logging.info("Received signal, shutting down...")
        sys.exit(0)

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    try:
        await service.run()
    except Exception as e:
        logging.error(f"Error in daemon: {e}")
        sys.exit(1)

if __name__ == "__main__":
    asyncio.run(main())
