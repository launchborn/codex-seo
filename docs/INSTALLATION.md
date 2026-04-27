# Installation Guide

## Prerequisites

- **Python 3.10+** with pip
- **Git** for cloning the repository
- **Codex CLI** installed and configured

Optional:
- **Playwright** for screenshot capabilities

## Quick Install

### Unix/macOS/Linux

```bash
curl -fsSL https://raw.githubusercontent.com/launchborn/codex-seo/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
git clone --depth 1 https://github.com/launchborn/codex-seo.git
cd codex-seo
powershell -ExecutionPolicy Bypass -File install.ps1
```

## Manual Installation

1. **Clone the repository**

```bash
git clone https://github.com/launchborn/codex-seo.git
cd codex-seo
```

2. **Run the installer**

```bash
./install.sh
```

3. **Install Python dependencies** (if not done automatically)

The installer creates a venv at `~/.codex/skills/seo/.venv/`. If that fails, install manually:

```bash
# Option A: Use the venv
~/.codex/skills/seo/.venv/bin/pip install -r ~/.codex/skills/seo/requirements.txt

# Option B: User-level install
pip install --user -r ~/.codex/skills/seo/requirements.txt
```

4. **Install Playwright browsers** (optional, for visual analysis)

```bash
pip install playwright
playwright install chromium
```

Playwright is optional. Without it, visual analysis uses WebFetch as a fallback.

## Installation Paths

The installer copies files to:

| Component | Path |
|-----------|------|
| Main skill | `~/.codex/skills/seo/` |
| Sub-skills | `~/.codex/skills/seo-*/` |
| Agent prompt files | `~/.codex/skills/seo/agents/seo-*.md` |

## Verify Installation

1. Start Codex:

```bash
codex
```

2. Check that the skill is loaded:

```
/seo
```

You should see a help message or prompt for a URL.

## Uninstallation

```bash
curl -fsSL https://raw.githubusercontent.com/launchborn/codex-seo/main/uninstall.sh | bash
```

Or manually:

```bash
rm -rf ~/.codex/skills/seo
rm -rf ~/.codex/skills/seo-audit
rm -rf ~/.codex/skills/seo-backlinks
rm -rf ~/.codex/skills/seo-competitor-pages
rm -rf ~/.codex/skills/seo-content
rm -rf ~/.codex/skills/seo-dataforseo
rm -rf ~/.codex/skills/seo-geo
rm -rf ~/.codex/skills/seo-google
rm -rf ~/.codex/skills/seo-hreflang
rm -rf ~/.codex/skills/seo-image-gen
rm -rf ~/.codex/skills/seo-images
rm -rf ~/.codex/skills/seo-local
rm -rf ~/.codex/skills/seo-maps
rm -rf ~/.codex/skills/seo-page
rm -rf ~/.codex/skills/seo-plan
rm -rf ~/.codex/skills/seo-programmatic
rm -rf ~/.codex/skills/seo-schema
rm -rf ~/.codex/skills/seo-sitemap
rm -rf ~/.codex/skills/seo-technical
rm -rf ~/.codex/skills/seo/agents
```

## Upgrading

To upgrade to the latest version:

```bash
# Uninstall current version
curl -fsSL https://raw.githubusercontent.com/launchborn/codex-seo/main/uninstall.sh | bash

# Install new version
curl -fsSL https://raw.githubusercontent.com/launchborn/codex-seo/main/install.sh | bash
```

## Troubleshooting

### "Skill not found" error

Ensure the skill is installed in the correct location:

```bash
ls ~/.codex/skills/seo/SKILL.md
```

If the file doesn't exist, re-run the installer.

### Python dependency errors

Install dependencies manually:

```bash
pip install beautifulsoup4 requests lxml playwright Pillow urllib3 validators
```

### Playwright screenshot errors

Install Chromium browser:

```bash
playwright install chromium
```

### Permission errors on Unix

Make sure scripts are executable:

```bash
chmod +x ~/.codex/skills/seo/scripts/*.py
```
