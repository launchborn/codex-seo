#!/usr/bin/env bash
set -euo pipefail

main() {
    echo "→ Uninstalling DataForSEO extension..."

    # Remove skill
    rm -rf "${HOME}/.codex/skills/seo-dataforseo"

    # Remove agent prompt file
    rm -f "${HOME}/.codex/skills/seo/agents/seo-dataforseo.md"

    # Remove field config
    rm -f "${HOME}/.codex/skills/seo/dataforseo-field-config.json"

    # Remove MCP server entry from Codex config.toml
    HELPER="${HOME}/.codex/skills/seo/scripts/codex_mcp_config.py"
    if [ -f "${HELPER}" ]; then
        python3 "${HELPER}" remove dataforseo 2>/dev/null || \
            echo "  ⚠  Could not auto-remove MCP config. Remove 'dataforseo' from ~/.codex/config.toml manually."
    fi

    echo "✓ DataForSEO extension uninstalled."
}

main "$@"
