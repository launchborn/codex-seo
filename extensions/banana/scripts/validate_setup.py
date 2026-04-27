#!/usr/bin/env python3
"""
Validate that the Banana MCP server is properly configured.

Checks:
1. Codex config.toml has the MCP entry
2. API key is present
3. Node.js/npx is available
4. Output directory exists or can be created

Usage:
    python3 validate_setup.py
"""

import json
import os
import shutil
import sys
from pathlib import Path

CODEX_HOME = Path(os.environ.get("CODEX_HOME", "~/.codex")).expanduser()
CONFIG_PATH = Path(os.environ.get("CODEX_CONFIG", str(CODEX_HOME / "config.toml"))).expanduser()
MCP_NAME = "nanobanana-mcp"
OUTPUT_DIR = Path.home() / "Documents" / "nanobanana_generated"


def check(label: str, passed: bool, detail: str = "") -> bool:
    status = "PASS" if passed else "FAIL"
    msg = f"  [{status}] {label}"
    if detail:
        msg += f": {detail}"
    print(msg)
    return passed


def main() -> int:
    print("Banana - Setup Validation")
    print("=" * 40)
    results = []

    # 1. Codex config exists
    results.append(check(
        "Codex config.toml exists",
        CONFIG_PATH.exists(),
        str(CONFIG_PATH),
    ))

    if not CONFIG_PATH.exists():
        print("\nCannot continue without config.toml.")
        return 1

    text = CONFIG_PATH.read_text(encoding="utf-8")

    # 2. MCP entry exists
    has_mcp = f"[mcp_servers.{MCP_NAME}]" in text
    results.append(check(f"MCP server '{MCP_NAME}' configured", has_mcp))

    if has_mcp:
        # 3. Command is npx
        results.append(check(
            "Command is 'npx'",
            'command = "npx"' in text,
        ))

        # 4. Package is correct
        has_pkg = "@ycse/nanobanana-mcp" in text
        results.append(check(
            "Package is @ycse/nanobanana-mcp",
            has_pkg,
        ))

        # 5. API key present
        key = ""
        for line in text.splitlines():
            if line.strip().startswith("GOOGLE_AI_API_KEY"):
                _, _, value = line.partition("=")
                try:
                    key = json.loads(value.strip())
                except json.JSONDecodeError:
                    key = value.strip().strip('"')
                break
        results.append(check(
            "GOOGLE_AI_API_KEY is set",
            bool(key),
            f"{key[:8]}...{key[-4:]}" if len(key) > 12 else "(empty or short)",
        ))

        # 6. Model configured
        model = "NANOBANANA_MODEL" if "NANOBANANA_MODEL" in text else ""
        results.append(check(
            "NANOBANANA_MODEL is set",
            bool(model),
            model or "(not set, will use package default)",
        ))

    # 8. Node.js/npx available
    has_npx = shutil.which("npx") is not None
    results.append(check(
        "npx is available in PATH",
        has_npx,
        shutil.which("npx") or "not found",
    ))

    # 9. Output directory
    if OUTPUT_DIR.exists():
        results.append(check("Output directory exists", True, str(OUTPUT_DIR)))
    else:
        try:
            OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
            results.append(check("Output directory created", True, str(OUTPUT_DIR)))
        except OSError as e:
            results.append(check("Output directory writable", False, str(e)))

    # Summary
    passed = sum(1 for r in results if r)
    total = len(results)
    print(f"\n{'=' * 40}")
    print(f"Results: {passed}/{total} checks passed")

    if passed == total:
        print("Status: Ready to generate images!")
        return 0
    else:
        print("Status: Some checks failed. Fix the issues above.")
        return 1


if __name__ == "__main__":
    sys.exit(main())
