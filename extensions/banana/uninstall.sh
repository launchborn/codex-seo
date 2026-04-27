#!/usr/bin/env bash
set -euo pipefail

main() {
    echo "→ Uninstalling Banana Image Generation extension..."

    # Remove skill (includes copied scripts and references)
    rm -rf "${HOME}/.codex/skills/seo-image-gen"

    # Remove agent prompt file
    rm -f "${HOME}/.codex/skills/seo/agents/seo-image-gen.md"

    # Ask before removing MCP server (user may use standalone banana skill)
    CONFIG_FILE="${CODEX_CONFIG:-${CODEX_HOME:-${HOME}/.codex}/config.toml}"
    if [ -f "${CONFIG_FILE}" ]; then
        # Check if standalone banana skill still exists
        if [ -d "${HOME}/.codex/skills/banana" ]; then
            echo "  ℹ  Standalone banana skill detected at ~/.codex/skills/banana/"
            echo "  ℹ  Keeping nanobanana-mcp in Codex config (used by standalone skill)"
        else
            # No standalone skill, safe to remove MCP
            HELPER="${HOME}/.codex/skills/seo/scripts/codex_mcp_config.py"
            if [ -f "${HELPER}" ]; then
                CODEX_CONFIG="${CONFIG_FILE}" python3 "${HELPER}" remove nanobanana-mcp 2>/dev/null || \
                    echo "  ⚠  Could not auto-remove MCP config. Remove 'nanobanana-mcp' from ${CONFIG_FILE} manually."
            fi
        fi
    fi

    echo "✓ Banana Image Generation extension uninstalled."
}

main "$@"
