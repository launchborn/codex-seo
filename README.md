<!-- Updated: 2026-04-27 -->

# Codex SEO

Codex-native SEO analysis skill set for technical audits, on-page review,
content quality, structured data, AI search visibility, local SEO, backlinks,
Google SEO APIs, and strategic SEO planning.

Codex discovery starts from `.codex-plugin/plugin.json`. Manual installs place
skills under `~/.codex/skills`, and MCP servers are written to Codex
`config.toml`.

[![CI](https://github.com/launchborn/codex-seo/actions/workflows/ci.yml/badge.svg)](https://github.com/launchborn/codex-seo/actions/workflows/ci.yml)
[![Codex Skill](https://img.shields.io/badge/Codex-Skill-blue)](https://github.com/openai/codex)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/github/v/release/launchborn/codex-seo)](https://github.com/launchborn/codex-seo/releases)

## What It Includes

- Main orchestrator skill: `skills/seo`
- 23 focused SEO sub-skills in `skills/seo-*`
- 18 specialist agent prompt files in `agents/`
- 31 Python execution scripts in `scripts/`
- Schema.org templates in `schema/`
- Optional MCP-backed extensions for DataForSEO, Firecrawl, and Banana image generation
- Codex plugin manifest in `.codex-plugin/plugin.json`

## Installation

### Codex Plugin

Use the bundled manifest with a Codex plugin loader:

```text
.codex-plugin/plugin.json
```

The manifest points Codex at the skill directory and hook configuration.

### Manual Install

Unix, macOS, or Linux:

```bash
git clone --depth 1 https://github.com/launchborn/codex-seo.git
bash codex-seo/install.sh
```

Windows PowerShell:

```powershell
git clone --depth 1 https://github.com/launchborn/codex-seo.git
powershell -ExecutionPolicy Bypass -File codex-seo\install.ps1
```

The installer copies skills to `~/.codex/skills`, installs shared scripts under
`~/.codex/skills/seo/scripts`, and keeps agent prompt files under
`~/.codex/skills/seo/agents`.

To install a specific tag or branch:

```bash
CODEX_HOME="$HOME/.codex" CODEX_SEO_TAG="main" bash codex-seo/install.sh
```

## Quick Start

Start Codex, then run SEO commands from the Codex prompt:

```bash
codex
```

```text
/seo audit https://example.com
/seo page https://example.com/about
/seo technical https://example.com
/seo schema https://example.com
/seo geo https://example.com
```

## Commands

| Command | Purpose |
|---------|---------|
| `/seo audit <url>` | Full website audit across technical, content, schema, performance, visual, GEO, and local SEO surfaces |
| `/seo page <url>` | Deep single-page SEO analysis |
| `/seo technical <url>` | Crawlability, indexability, canonicals, robots, redirects, security, performance basics |
| `/seo content <url>` | E-E-A-T, helpfulness, intent match, readability, thin content, trust signals |
| `/seo schema <url>` | Detect, validate, and generate Schema.org JSON-LD |
| `/seo sitemap <url>` | Analyze XML sitemaps |
| `/seo sitemap generate` | Generate sitemap structures with industry-aware templates |
| `/seo images <url>` | Image SEO audit: filenames, alt text, dimensions, lazy loading, Open Graph images |
| `/seo geo <url>` | AI Overviews and generative engine optimization |
| `/seo local <url>` | Local SEO: NAP, GBP, citations, reviews, local schema |
| `/seo maps [command]` | Maps intelligence: geo-grid, GBP audit, competitor radius, review analysis |
| `/seo hreflang <url>` | International SEO and hreflang validation |
| `/seo google [command] [url]` | Google APIs: Search Console, PageSpeed, CrUX, URL Inspection, Indexing, GA4 |
| `/seo google report [type]` | PDF/HTML reports with charts |
| `/seo backlinks <url>` | Backlink analysis with free sources and optional premium data |
| `/seo backlinks setup` | Configure free backlink data sources |
| `/seo backlinks verify <url>` | Verify known backlinks still exist |
| `/seo cluster <keyword>` | SERP-based semantic clustering and content architecture |
| `/seo sxo <url>` | Search Experience Optimization: page type, personas, user stories |
| `/seo drift baseline <url>` | Capture an SEO baseline for later comparison |
| `/seo drift compare <url>` | Compare current page state to the stored baseline |
| `/seo drift history <url>` | Review SEO drift history |
| `/seo ecommerce <url>` | E-commerce SEO: product schema, marketplaces, category/product page checks |
| `/seo programmatic <url>` | Programmatic SEO analysis and scale planning |
| `/seo competitor-pages <url>` | Competitor comparison and alternatives page planning |
| `/seo firecrawl [command] <url>` | Full-site crawling via Firecrawl extension |
| `/seo dataforseo [command]` | Live SERP, keyword, backlink, and AI visibility data via DataForSEO |
| `/seo image-gen [use-case] <desc>` | SEO image generation via Banana extension |

## Codex Architecture

```text
codex-seo/
  .codex-plugin/plugin.json       # Codex plugin manifest
  CODEX.md                        # Codex-native project instructions
  AGENTS.md                       # Multi-platform fallback instructions
  skills/
    seo/                          # Main router/orchestrator
    seo-*/                        # Focused sub-skills
  agents/                         # Specialist prompt files
  scripts/                        # Python execution layer
  hooks/                          # Codex hook config and schema validation
  schema/                         # JSON-LD templates
  extensions/                     # Optional MCP-backed add-ons
```

Installed layout:

```text
~/.codex/skills/seo/
~/.codex/skills/seo-*/
~/.codex/skills/seo/agents/
~/.codex/skills/seo/scripts/
~/.codex/config.toml
```

Codex SEO uses agent prompt files as reusable specialist instructions. Native
Codex parallel agents can be used when the active Codex environment supports
them and the user requests delegation; otherwise the orchestrator runs the same
checks inline.

## Data And Credentials

Local credential files stay outside the repository:

```text
~/.config/codex-seo/google-api.json
~/.config/codex-seo/backlinks-api.json
~/.codex/config.toml
```

The core scripts include URL validation for SSRF protection before fetching user
URLs. Secrets, OAuth tokens, service account files, and local `.env` files are
ignored by git.

## MCP Integrations

Codex MCP servers are configured in `~/.codex/config.toml`. Extension installers
use `scripts/codex_mcp_config.py` to add or remove MCP server blocks.

Example Codex MCP block:

```toml
[mcp_servers.dataforseo]
command = "npx"
args = ["-y", "dataforseo-mcp-server"]

[mcp_servers.dataforseo.env]
DATAFORSEO_USERNAME = "user@example.com"
DATAFORSEO_PASSWORD = "your-password"
```

See [docs/MCP-INTEGRATION.md](docs/MCP-INTEGRATION.md) for setup details.

## Extensions

### DataForSEO

Live SERP data, keyword research, backlinks, on-page analysis, content analysis,
business listings, AI visibility checking, and LLM mention tracking.

```bash
./extensions/dataforseo/install.sh
```

```text
/seo dataforseo serp best coffee shops
/seo dataforseo keywords seo tools
/seo dataforseo backlinks example.com
/seo dataforseo ai-mentions your brand
```

### Firecrawl

Site crawling, URL discovery, page scraping, and search workflows through the
Firecrawl MCP server.

```bash
./extensions/firecrawl/install.sh
```

```text
/seo firecrawl crawl https://example.com
/seo firecrawl map https://example.com
```

### Banana Image Generation

Generate SEO assets such as Open Graph images, blog heroes, product visuals, and
infographics through the Banana image workflow.

```bash
./extensions/banana/install.sh
```

```text
/seo image-gen og "Professional SaaS dashboard"
/seo image-gen hero "AI-powered content creation"
/seo image-gen batch "Product photography" 3
```

## Feature Areas

- Technical SEO: crawlability, indexability, redirects, canonicals, robots, status codes
- Core Web Vitals: LCP, INP, CLS, PageSpeed Insights, CrUX, CrUX History
- Content quality: E-E-A-T, helpful content, trust signals, intent matching
- Schema: JSON-LD detection, validation, generation, deprecated rich result awareness
- AI search: Google AI Overviews, ChatGPT search, Perplexity, crawler access, citability
- Local SEO: Google Business Profile, citations, reviews, NAP consistency, geo-grid checks
- Backlinks: Moz, Bing Webmaster Tools, Common Crawl graph, verification crawler
- International SEO: hreflang, locale formatting, content parity, cultural profiles
- Programmatic SEO: URL patterns, templates, internal links, index bloat prevention
- E-commerce SEO: product schema, category pages, Google Shopping, marketplace signals
- Drift monitoring: SQLite baselines, comparison rules, historical reports
- FLOW integration: evidence-led SEO prompt library with attribution

## Requirements

- Codex CLI
- Python 3.10+
- Git
- Optional: Node.js 20+ for MCP extensions
- Optional: Playwright for visual rendering checks
- Optional: Google API credentials for enriched reports

Python dependencies are listed in [requirements.txt](requirements.txt).

## Development

Run syntax checks:

```bash
python3 -m py_compile hooks/validate-schema.py scripts/*.py extensions/banana/scripts/*.py
bash -n install.sh uninstall.sh extensions/dataforseo/install.sh extensions/dataforseo/uninstall.sh extensions/firecrawl/install.sh extensions/firecrawl/uninstall.sh extensions/banana/install.sh extensions/banana/uninstall.sh
python3 -m json.tool .codex-plugin/plugin.json hooks/hooks.json
```

Run tests when `pytest` is available:

```bash
python3 -m pytest tests/
```

FLOW prompt sync uses the GitHub API:

```bash
python3 scripts/sync_flow.py --dry-run
```

## Uninstall

```bash
git clone --depth 1 https://github.com/launchborn/codex-seo.git
bash codex-seo/uninstall.sh
```

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File codex-seo\uninstall.ps1
```

## Documentation

- [Installation Guide](docs/INSTALLATION.md)
- [Commands Reference](docs/COMMANDS.md)
- [Architecture](docs/ARCHITECTURE.md)
- [MCP Integration](docs/MCP-INTEGRATION.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Codex Project Instructions](CODEX.md)

## Community Contributors

v1.9.0 includes contributions from the AI Marketing Hub Pro Hub Challenge:

| Contributor | Contribution |
|------------|--------------|
| Lutfiya Miller | Semantic Cluster Engine: `seo-cluster` |
| Florian Schmitz | Search Experience Optimization: `seo-sxo` |
| Dan Colta | SEO Drift Monitor: `seo-drift` |
| Chris Muller | Hreflang and international SEO enhancements |
| Matej Marjanovic | E-commerce SEO and DataForSEO cost guardrails |

See [CONTRIBUTORS.md](CONTRIBUTORS.md) for full credits and source links.

## License

MIT License. See [LICENSE](LICENSE).

## Maintainer

Maintained by [Launchborn](https://github.com/launchborn).
