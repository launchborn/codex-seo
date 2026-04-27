#!/usr/bin/env pwsh
# codex-seo uninstaller for Windows
# Cleanly removes all SEO skills, agents, and scripts

$ErrorActionPreference = "Stop"

function Write-Color($Color, $Text) {
    Write-Host $Text -ForegroundColor $Color
}

function Main {
    $CodexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }
    $SkillDir = Join-Path $CodexHome "skills"
    $AgentDir = Join-Path $CodexHome "agents"

    Write-Color Cyan "=== Uninstalling codex-seo ==="
    Write-Host ""

    # Remove main skill (includes venv, references, scripts, hooks)
    $seoDir = Join-Path $SkillDir "seo"
    if (Test-Path $seoDir) {
        Remove-Item -Recurse -Force $seoDir
        Write-Color Green "  Removed: $seoDir"
    }

    # Remove sub-skills
    $subSkills = @(
        "seo-audit", "seo-backlinks", "seo-cluster", "seo-competitor-pages",
        "seo-content", "seo-dataforseo", "seo-drift", "seo-ecommerce",
        "seo-firecrawl", "seo-flow", "seo-geo", "seo-google", "seo-hreflang",
        "seo-image-gen", "seo-images", "seo-local", "seo-maps", "seo-page",
        "seo-plan", "seo-programmatic", "seo-schema", "seo-sitemap",
        "seo-sxo", "seo-technical"
    )
    foreach ($skill in $subSkills) {
        $skillPath = Join-Path $SkillDir $skill
        if (Test-Path $skillPath) {
            Remove-Item -Recurse -Force $skillPath
            Write-Color Green "  Removed: $skillPath"
        }
    }

    # Remove legacy top-level agent copies from earlier Codex SEO installers.
    $agents = @(
        "seo-technical", "seo-content", "seo-schema",
        "seo-sitemap", "seo-performance", "seo-visual", "seo-geo"
    )
    foreach ($agent in $agents) {
        $agentPath = Join-Path $AgentDir "$agent.md"
        if (Test-Path $agentPath) {
            Remove-Item -Force $agentPath
            Write-Color Green "  Removed: $agentPath"
        }
    }

    Write-Host ""
    Write-Color Cyan "=== codex-seo uninstalled ==="
    Write-Host ""
    Write-Color Yellow "Restart Codex to complete removal."
}

Main
