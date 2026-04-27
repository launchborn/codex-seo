#!/usr/bin/env bash
set -euo pipefail

main() {
    echo "→ Uninstalling Codex SEO..."

    CODEX_HOME="${CODEX_HOME:-${HOME}/.codex}"
    SKILL_ROOT="${CODEX_HOME}/skills"

    # Remove main skill (includes venv and requirements.txt)
    rm -rf "${SKILL_ROOT}/seo"

    # Remove sub-skills
    for skill in seo-audit seo-backlinks seo-cluster seo-competitor-pages seo-content seo-dataforseo seo-drift seo-ecommerce seo-firecrawl seo-flow seo-geo seo-google seo-hreflang seo-image-gen seo-images seo-local seo-maps seo-page seo-plan seo-programmatic seo-schema seo-sitemap seo-sxo seo-technical; do
        rm -rf "${SKILL_ROOT}/${skill}"
    done

    # Remove legacy top-level agent copies from earlier Codex SEO installers.
    for agent in seo-technical seo-content seo-schema seo-sitemap seo-performance seo-visual seo-geo; do
        rm -f "${CODEX_HOME}/agents/${agent}.md"
    done

    echo "✓ Codex SEO uninstalled."
}

main "$@"
