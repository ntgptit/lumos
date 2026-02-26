#!/usr/bin/env python3
"""
Backend checklist guard entrypoint.

Run:
  python tool/verify_backend_checklists.py
  python tool/verify_backend_checklists.py --strict
"""

from backend_guard.core import main


if __name__ == "__main__":
    raise SystemExit(main())
