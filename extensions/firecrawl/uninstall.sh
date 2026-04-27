#!/usr/bin/env bash
set -euo pipefail

echo "Removing Firecrawl extension..."

# Remove skill directory
rm -rf "${HOME}/.codex/skills/seo-firecrawl"
echo "v Removed skill files"

# Remove MCP entry from Codex config.toml
HELPER="${HOME}/.codex/skills/seo/scripts/codex_mcp_config.py"
if [ -f "${HELPER}" ]; then
    python3 "${HELPER}" remove firecrawl-mcp 2>/dev/null || \
        echo "  Warning: Could not update Codex config automatically."
fi

echo ""
echo "v Firecrawl extension uninstalled."
echo "  Core Codex SEO skills are unchanged."
