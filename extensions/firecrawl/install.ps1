# Firecrawl Extension Installer for Codex SEO (Windows)
$ErrorActionPreference = 'Stop'

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Firecrawl Extension - Installer" -ForegroundColor Cyan
Write-Host "  For Codex SEO" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

$SkillDir = "$env:USERPROFILE\.codex\skills\seo-firecrawl"
$SeoSkillDir = "$env:USERPROFILE\.codex\skills\seo"
$CodexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { "$env:USERPROFILE\.codex" }
$ConfigFile = if ($env:CODEX_CONFIG) { $env:CODEX_CONFIG } else { Join-Path $CodexHome "config.toml" }

# Check prerequisites
if (-not (Test-Path $SeoSkillDir)) {
    Write-Host "x Codex SEO is not installed." -ForegroundColor Red
    Write-Host "  Install it first: irm https://raw.githubusercontent.com/launchborn/codex-seo/main/install.ps1 | iex"
    exit 1
}
Write-Host "v Codex SEO detected" -ForegroundColor Green

$nodeVersion = (node -v 2>$null) -replace 'v',''
if (-not $nodeVersion) {
    Write-Host "x Node.js is required but not installed." -ForegroundColor Red
    exit 1
}
$major = [int]($nodeVersion -split '\.')[0]
if ($major -lt 20) {
    Write-Host "x Node.js 20+ required (found v$nodeVersion)." -ForegroundColor Red
    exit 1
}
Write-Host "v Node.js v$nodeVersion detected" -ForegroundColor Green

# Prompt for API key
Write-Host ""
Write-Host "Firecrawl API key required." -ForegroundColor Yellow
Write-Host "Sign up at: https://www.firecrawl.dev/app/sign-up"
Write-Host "Free tier: 500 credits/month"
Write-Host ""

$apiKey = Read-Host "Firecrawl API key" -AsSecureString
$apiKeyPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($apiKey))
if ([string]::IsNullOrWhiteSpace($apiKeyPlain)) {
    Write-Host "x API key cannot be empty." -ForegroundColor Red
    exit 1
}

# Determine source directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceDir = $null
if (Test-Path "$ScriptDir\skills\seo-firecrawl\SKILL.md") {
    $SourceDir = $ScriptDir
} elseif (Test-Path "$ScriptDir\extensions\firecrawl\skills\seo-firecrawl\SKILL.md") {
    $SourceDir = "$ScriptDir\extensions\firecrawl"
} else {
    Write-Host "x Cannot find extension source files." -ForegroundColor Red
    exit 1
}

# Install skill
Write-Host ""
Write-Host "=> Installing Firecrawl skill..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
Copy-Item "$SourceDir\skills\seo-firecrawl\SKILL.md" "$SkillDir\SKILL.md" -Force

# Configure MCP server
Write-Host "=> Configuring MCP server..." -ForegroundColor Yellow
$python = Get-Command -Name python -ErrorAction SilentlyContinue
if ($null -eq $python) {
    $python = Get-Command -Name py -ErrorAction SilentlyContinue
}
if ($null -ne $python) {
    $helper = Join-Path $SeoSkillDir "scripts\codex_mcp_config.py"
    $env:CODEX_CONFIG = $ConfigFile
    & $python.Source $helper add firecrawl-mcp `
        --command npx `
        --args-json '["-y", "firecrawl-mcp"]' `
        --env "FIRECRAWL_API_KEY=$apiKeyPlain" | Out-Null
    Write-Host "  v MCP server configured in $ConfigFile" -ForegroundColor Green
} else {
    Write-Host "  Warning: Python not found. Add firecrawl-mcp manually to $ConfigFile" -ForegroundColor Yellow
}

# Pre-warm
Write-Host "=> Pre-downloading firecrawl-mcp..." -ForegroundColor Yellow
npx -y firecrawl-mcp --help 2>$null | Out-Null

Write-Host ""
Write-Host "v Firecrawl extension installed!" -ForegroundColor Green
Write-Host ""
Write-Host "Usage:"
Write-Host "  /seo firecrawl crawl https://example.com"
Write-Host "  /seo firecrawl map https://example.com"
Write-Host "  /seo firecrawl scrape https://example.com/page"
