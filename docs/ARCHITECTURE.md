# Architecture

## Overview

Codex SEO follows the Codex plugin and skill conventions with a modular, multi-skill architecture.

## Directory Structure

```
~/.codex/
├── skills/
│   ├── seo/              # Main orchestrator skill
│   │   ├── SKILL.md          # Entry point with routing logic
│   │   ├── references/       # On-demand reference files
│   │       ├── cwv-thresholds.md
│   │       ├── schema-types.md
│   │       ├── eeat-framework.md
│   │       └── quality-gates.md
│   │   └── agents/           # Agent prompt files for environments with parallel delegation
│   │       ├── seo-technical.md
│   │       ├── seo-content.md
│   │       ├── seo-schema.md
│   │       ├── seo-sitemap.md
│   │       ├── seo-performance.md
│   │       └── seo-visual.md
│   │
│   ├── seo-audit/            # Full site audit
│   ├── seo-competitor-pages/ # Competitor comparison pages
│   ├── seo-content/          # E-E-A-T analysis
│   ├── seo-geo/              # AI search optimization
│   ├── seo-hreflang/         # Hreflang/i18n SEO
│   ├── seo-images/           # Image optimization
│   ├── seo-page/             # Single page analysis
│   ├── seo-plan/             # Strategic planning
│   │   └── assets/           # Industry templates
│   ├── seo-programmatic/     # Programmatic SEO
│   ├── seo-schema/           # Schema markup
│   ├── seo-sitemap/          # Sitemap analysis/generation
│   └── seo-technical/        # Technical SEO
```

## Component Types

### Skills

Skills are markdown files with YAML frontmatter that define capabilities and instructions.

**SKILL.md Format:**
```yaml
---
name: skill-name
description: >
  When to use this skill. Include activation keywords
  and concrete use cases.
---

# Skill Title

Instructions and documentation...
```

### Agent Prompt Files

Agent prompt files are specialized analysis contracts that Codex can use as reference prompts. If the current Codex environment supports native parallel agents and the user requested parallel delegation, use them for concurrent audit slices; otherwise run the same checks inline.

**Prompt Format:**
```yaml
---
name: agent-name
description: What this agent does.
tools: Read, Bash, Write, Glob, Grep
---

Instructions for the agent...
```

### Reference Files

Reference files contain static data loaded on-demand to avoid bloating the main skill.

## Orchestration Flow

### Full Audit (`/seo audit`)

```
User Request
    │
    ▼
┌─────────────────┐
│   seo       │  ← Main orchestrator
│   (SKILL.md)    │
└────────┬────────┘
         │
         │  Detects business type
         │  Runs specialist audit slices
         │
    ┌────┴────┬────────┬────────┬────────┬────────┐
    ▼         ▼        ▼        ▼        ▼        ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│tech   │ │content│ │schema │ │sitemap│ │perf   │ │visual │
│agent  │ │agent  │ │agent  │ │agent  │ │agent  │ │agent  │
└───┬───┘ └───┬───┘ └───┬───┘ └───┬───┘ └───┬───┘ └───┬───┘
    │         │        │        │        │        │
    └─────────┴────────┴────┬───┴────────┴────────┘
                            │
                            ▼
                    ┌───────────────┐
                    │  Aggregate    │
                    │  Results      │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │  Generate     │
                    │  Report       │
                    └───────────────┘
```

### Individual Command

```
User Request (e.g., /seo page)
    │
    ▼
┌─────────────────┐
│   seo       │  ← Routes to sub-skill
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   seo-page      │  ← Sub-skill handles directly
│   (SKILL.md)    │
└─────────────────┘
```

## Design Principles

### 1. Progressive Disclosure

- Main SKILL.md is concise (<200 lines)
- Reference files loaded on-demand
- Detailed instructions in sub-skills

### 2. Parallel Processing

- Specialist audit slices can run concurrently when native Codex parallel agents are available and requested
- Independent analyses don't block each other
- Results aggregated after all complete

### 3. Quality Gates

- Built-in thresholds prevent bad recommendations
- Location page limits (30 warning, 50 hard stop)
- Schema deprecation awareness
- FID → INP replacement enforced

### 4. Industry Awareness

- Templates for different business types
- Automatic detection from homepage signals
- Tailored recommendations per industry

## File Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Skill | `seo-{name}/SKILL.md` | `seo-audit/SKILL.md` |
| Agent | `seo-{name}.md` | `seo-technical.md` |
| Reference | `{topic}.md` | `cwv-thresholds.md` |
| Script | `{action}_{target}.py` | `fetch_page.py` |
| Template | `{industry}.md` | `saas.md` |

## Extension Points

### Adding a New Sub-Skill

1. Create `skills/seo-newskill/SKILL.md`
2. Add YAML frontmatter with name and description
3. Write skill instructions
4. Update main `skills/seo/SKILL.md` to route to new skill

### Adding a New Agent Prompt

1. Create `agents/seo-newagent.md`
2. Add YAML frontmatter with name, description, tools
3. Write agent instructions
4. Reference from relevant skills

### Adding a New Reference File

1. Create file in appropriate `references/` directory
2. Reference in skill with load-on-demand instruction

## Extensions

Extensions are opt-in add-ons that integrate external data sources via MCP servers. They live in `extensions/<name>/` and include their own install/uninstall scripts.

```
extensions/
├── dataforseo/               # DataForSEO MCP integration
│   ├── README.md                  # Extension documentation
│   ├── install.sh                 # Unix installer
│   ├── install.ps1                # Windows installer
│   ├── uninstall.sh               # Unix uninstaller
│   ├── uninstall.ps1              # Windows uninstaller
│   ├── field-config.json          # API response field filtering
│   ├── skills/
│   │   └── seo-dataforseo/
│   │       └── SKILL.md           # Sub-skill (22 commands)
│   ├── agents/
│   │   └── seo-dataforseo.md      # Agent prompt file
│   └── docs/
│       └── DATAFORSEO-SETUP.md    # Account setup guide
│
└── banana/                   # Banana Image Generation (Gemini AI)
    ├── README.md                  # Extension documentation
    ├── install.sh                 # Unix installer
    ├── uninstall.sh               # Unix uninstaller
    ├── skills/
    │   └── seo-image-gen/
    │       └── SKILL.md           # Sub-skill (6 commands)
    ├── agents/
    │   └── seo-image-gen.md       # Image audit prompt file
    ├── scripts/                   # Python scripts (stdlib only)
    │   ├── generate.py            # Direct API fallback
    │   ├── edit.py                # Image editing fallback
    │   ├── batch.py               # CSV batch workflow
    │   ├── cost_tracker.py        # Usage and cost tracking
    │   ├── presets.py             # Brand preset management
    │   ├── setup_mcp.py           # MCP configuration
    │   └── validate_setup.py      # Installation verification
    ├── references/                # On-demand knowledge
    │   ├── prompt-engineering.md  # 6-component Reasoning Brief
    │   ├── gemini-models.md       # Model specs and pricing
    │   ├── mcp-tools.md           # MCP tool reference
    │   ├── post-processing.md     # ImageMagick recipes
    │   ├── cost-tracking.md       # Cost tracking guide
    │   ├── presets.md             # Preset schema
    │   └── seo-image-presets.md   # SEO-specific presets
    └── docs/
        └── BANANA-SETUP.md        # API key and MCP setup
```

### Available Extensions

| Extension | Package | What it Adds |
|-----------|---------|-------------|
| **DataForSEO** | `dataforseo-mcp-server` | 22 commands: live SERP, keywords, backlinks, on-page analysis, content analysis, business listings, AI visibility, LLM mentions |
| **Banana Image Gen** | `@ycse/nanobanana-mcp` | 6 commands: OG image, hero image, product photo, infographic, custom, and batch generation via Gemini AI |

### Extension Convention

Each extension follows this pattern:
1. Self-contained in `extensions/<name>/`
2. Own `install.sh` and `install.ps1` that copy files and configure MCP
3. Own `uninstall.sh` and `uninstall.ps1` that cleanly reverse installation
4. Installs skill to `~/.codex/skills/seo-<name>/`
5. Installs agent prompt files under `~/.codex/skills/seo/agents/`
6. Merges MCP config into `~/.codex/config.toml` through `scripts/codex_mcp_config.py` (non-destructive)
