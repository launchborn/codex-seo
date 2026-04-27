#!/usr/bin/env python3
"""Add or remove MCP server blocks in Codex config.toml."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path


def _config_path() -> Path:
    if os.environ.get("CODEX_CONFIG"):
        return Path(os.environ["CODEX_CONFIG"]).expanduser()
    codex_home = Path(os.environ.get("CODEX_HOME", "~/.codex")).expanduser()
    return codex_home / "config.toml"


def _quote(value: str) -> str:
    return json.dumps(str(value))


def _remove_server_block(text: str, name: str) -> str:
    base = f"mcp_servers.{name}"
    kept: list[str] = []
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


def add_server(name: str, command: str, args: list[str], env: dict[str, str]) -> None:
    config_path = _config_path()
    text = config_path.read_text(encoding="utf-8") if config_path.exists() else ""
    text = _remove_server_block(text, name)

    lines = [
        f"[mcp_servers.{name}]",
        f"command = {_quote(command)}",
        "args = [" + ", ".join(_quote(arg) for arg in args) + "]",
    ]
    if env:
        lines.append(f"[mcp_servers.{name}.env]")
        for key, value in env.items():
            lines.append(f"{key} = {_quote(value)}")

    config_path.parent.mkdir(parents=True, exist_ok=True)
    separator = "\n" if text and not text.endswith("\n\n") else ""
    config_path.write_text(f"{text}{separator}{chr(10).join(lines)}\n", encoding="utf-8")
    print(f"configured {name} in {config_path}")


def remove_server(name: str) -> None:
    config_path = _config_path()
    if not config_path.exists():
        print(f"no Codex config at {config_path}")
        return
    text = config_path.read_text(encoding="utf-8")
    updated = _remove_server_block(text, name)
    config_path.write_text(updated, encoding="utf-8")
    print(f"removed {name} from {config_path}")


def parse_env(pairs: list[str]) -> dict[str, str]:
    env: dict[str, str] = {}
    for pair in pairs:
        if "=" not in pair:
            raise SystemExit(f"Invalid --env value {pair!r}; expected KEY=VALUE")
        key, value = pair.split("=", 1)
        if not key:
            raise SystemExit("Environment variable name cannot be empty")
        env[key] = value
    return env


def main() -> None:
    parser = argparse.ArgumentParser(description="Manage Codex MCP server config")
    sub = parser.add_subparsers(dest="command_name", required=True)

    add = sub.add_parser("add")
    add.add_argument("name")
    add.add_argument("--command", required=True)
    add.add_argument("--args-json", default="[]")
    add.add_argument("--env", action="append", default=[])

    remove = sub.add_parser("remove")
    remove.add_argument("name")

    args = parser.parse_args()
    if args.command_name == "add":
        try:
            server_args = json.loads(args.args_json)
        except json.JSONDecodeError as exc:
            raise SystemExit(f"Invalid --args-json: {exc}") from exc
        if not isinstance(server_args, list) or not all(isinstance(item, str) for item in server_args):
            raise SystemExit("--args-json must be a JSON array of strings")
        add_server(args.name, args.command, server_args, parse_env(args.env))
    else:
        remove_server(args.name)


if __name__ == "__main__":
    main()
