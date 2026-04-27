# DataForSEO Extension Uninstaller for Codex SEO (Windows)

$ErrorActionPreference = "Stop"

Write-Host "→ Uninstalling DataForSEO extension..." -ForegroundColor Yellow

# Remove skill
if (Test-Path "$env:USERPROFILE\.codex\skills\seo-dataforseo") {
    Remove-Item -Recurse -Force "$env:USERPROFILE\.codex\skills\seo-dataforseo"
}

# Remove agent
$agentFile = "$env:USERPROFILE\.codex\skills\seo\agents\seo-dataforseo.md"
if (Test-Path $agentFile) {
    Remove-Item -Force $agentFile
}

# Remove field config
$fieldConfig = "$env:USERPROFILE\.codex\skills\seo\dataforseo-field-config.json"
if (Test-Path $fieldConfig) {
    Remove-Item -Force $fieldConfig
}

# Remove MCP server entry from Codex config.toml
$python = Get-Command -Name python -ErrorAction SilentlyContinue
if ($null -eq $python) {
    $python = Get-Command -Name py -ErrorAction SilentlyContinue
}
$helper = "$env:USERPROFILE\.codex\skills\seo\scripts\codex_mcp_config.py"
if (($null -ne $python) -and (Test-Path $helper)) {
    & $python.Source $helper remove dataforseo | Out-Null
    Write-Host "  ✓ Removed dataforseo from Codex config" -ForegroundColor Green
}

Write-Host "✓ DataForSEO extension uninstalled." -ForegroundColor Green
