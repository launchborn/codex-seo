#!/usr/bin/env python3
"""
Setup script for Banana MCP server in Codex.

Configures @ycse/nanobanana-mcp in Codex's config.toml
with the user's Google AI API key.

Usage:
    python3 setup_mcp.py                    # Interactive (prompts for key)
    python3 setup_mcp.py --key YOUR_KEY     # Non-interactive
    python3 setup_mcp.py --check            # Verify existing setup
    python3 setup_mcp.py --remove           # Remove MCP config
    python3 setup_mcp.py --help             # Show usage
"""

import sys
import os
from pathlib import Path

CODEX_HOME = Path(os.environ.get("CODEX_HOME", "~/.codex")).expanduser()
CONFIG_PATH = Path(os.environ.get("CODEX_CONFIG", str(CODEX_HOME / "config.toml"))).expanduser()
MCP_NAME = "nanobanana-mcp"
MCP_PACKAGE = "@ycse/nanobanana-mcp"
DEFAULT_MODEL = "gemini-3.1-flash-image-preview"


def quote(value: str) -> str:
    import json
    return json.dumps(str(value))


def remove_block(text: str) -> str:
    base = f"mcp_servers.{MCP_NAME}"
    kept = []
    skip = False
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("[") and stripped.endswith("]"):
            header = stripped[1:-1].strip()
            skip = header == base or header.startswith(f"{base}.")
            if skip:
                continue
        if not skip:
            kept.append(line)
    return "\n".join(kept).rstrip() + ("\n" if kept else "")


def read_config() -> str:
    return CONFIG_PATH.read_text(encoding="utf-8") if CONFIG_PATH.exists() else ""


def write_config(text: str) -> None:
    CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)
    CONFIG_PATH.write_text(text, encoding="utf-8")
    print(f"Config saved to {CONFIG_PATH}")


def check_setup() -> bool:
    """Check if MCP is already configured."""
    text = read_config()
    if f"[mcp_servers.{MCP_NAME}]" in text:
        key = os.environ.get("GOOGLE_AI_API_KEY", "")
        masked = key[:8] + "..." + key[-4:] if len(key) > 12 else "(configured in config)"
        print(f"MCP server '{MCP_NAME}' is configured.")
        print(f"  Package: {MCP_PACKAGE}")
        print(f"  API Key: {masked}")
        print(f"  Model:   {DEFAULT_MODEL}")
        return True
    print(f"MCP server '{MCP_NAME}' is NOT configured.")
    return False


def remove_mcp() -> None:
    """Remove MCP configuration."""
    text = read_config()
    updated = remove_block(text)
    write_config(updated)
    print(f"Removed '{MCP_NAME}' from Codex config.")


def setup_mcp(api_key: str) -> None:
    """Configure MCP server in Codex settings."""
    if not api_key or not api_key.strip():
        print("Error: API key cannot be empty.")
        sys.exit(1)

    api_key = api_key.strip()
    text = remove_block(read_config())
    block = "\n".join([
        f"[mcp_servers.{MCP_NAME}]",
        'command = "npx"',
        f"args = [\"-y\", {quote(MCP_PACKAGE)}]",
        f"[mcp_servers.{MCP_NAME}.env]",
        f"GOOGLE_AI_API_KEY = {quote(api_key)}",
        f"NANOBANANA_MODEL = {quote(DEFAULT_MODEL)}",
        "",
    ])
    separator = "\n" if text and not text.endswith("\n\n") else ""
    write_config(f"{text}{separator}{block}")
    print(f"\nMCP server '{MCP_NAME}' configured successfully!")
    print(f"  Package: {MCP_PACKAGE}")
    print(f"  Model:   {DEFAULT_MODEL}")
    print(f"\nRestart Codex for changes to take effect.")
    print(f"Generated images will be saved to: ~/Documents/nanobanana_generated/")


def main() -> None:
    args = sys.argv[1:]

    if "--help" in args or "-h" in args:
        print("Usage: python3 setup_mcp.py [OPTIONS]")
        print()
        print("Options:")
        print("  --key KEY        Provide API key non-interactively")
        print("  --check          Verify existing setup")
        print("  --remove         Remove MCP configuration")
        print("  --help, -h       Show this help message")
        print()
        print("Get a free API key at: https://aistudio.google.com/apikey")
        sys.exit(0)

    if "--check" in args:
        check_setup()
        return

    if "--remove" in args:
        remove_mcp()
        return

    # Get API key
    api_key = None
    for i, arg in enumerate(args):
        if arg == "--key" and i + 1 < len(args):
            api_key = args[i + 1]
            break

    if not api_key:
        # Check environment
        api_key = os.environ.get("GOOGLE_AI_API_KEY")

    if not api_key:
        print("Banana - MCP Setup")
        print("=" * 40)
        print(f"\nGet your free API key at: https://aistudio.google.com/apikey")
        print()
        try:
            api_key = input("Enter your Google AI API key: ")
        except (EOFError, KeyboardInterrupt):
            print("\nError: No input received. Provide a key with --key or set GOOGLE_AI_API_KEY env var.")
            sys.exit(1)

    setup_mcp(api_key)


if __name__ == "__main__":
    main()
