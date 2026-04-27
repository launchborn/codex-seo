# Firecrawl Extension Uninstaller for Codex SEO (Windows)
$ErrorActionPreference = 'Stop'

Write-Host "Removing Firecrawl extension..." -ForegroundColor Yellow

$SkillDir = "$env:USERPROFILE\.codex\skills\seo-firecrawl"

if (Test-Path $SkillDir) {
    Remove-Item -Recurse -Force $SkillDir
    Write-Host "v Removed skill files" -ForegroundColor Green
}

$python = Get-Command -Name python -ErrorAction SilentlyContinue
if ($null -eq $python) {
    $python = Get-Command -Name py -ErrorAction SilentlyContinue
}
$helper = "$env:USERPROFILE\.codex\skills\seo\scripts\codex_mcp_config.py"
if (($null -ne $python) -and (Test-Path $helper)) {
    & $python.Source $helper remove firecrawl-mcp | Out-Null
    Write-Host "v Removed MCP server from Codex config" -ForegroundColor Green
}

Write-Host ""
Write-Host "v Firecrawl extension uninstalled." -ForegroundColor Green
Write-Host "  Core Codex SEO skills are unchanged."
