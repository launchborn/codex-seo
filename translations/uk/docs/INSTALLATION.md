<!-- i18n-source: docs/INSTALLATION.md -->
<!-- i18n-source-sha: HEAD -->
<!-- i18n-date: 2026-04-10 -->

# Посібник зі встановлення

## Передумови

- **Python 3.10+** з pip
- **Git** для клонування репозиторію
- **Codex CLI** встановлений та налаштований

Опціонально:
- **Playwright** для можливості створення скріншотів

## Швидке встановлення

### Unix/macOS/Linux

```bash
curl -fsSL https://raw.githubusercontent.com/launchborn/codex-seo/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/launchborn/codex-seo/main/install.ps1 | iex
```

## Ручне встановлення

1. **Клонуйте репозиторій**

```bash
git clone https://github.com/launchborn/codex-seo.git
cd codex-seo
```

2. **Запустіть інсталятор**

```bash
./install.sh
```

3. **Встановіть залежності Python** (якщо не встановлено автоматично)

Інсталятор створює venv у `~/.codex/skills/seo/.venv/`. Якщо це не вдалося, встановіть вручну:

```bash
# Option A: Use the venv
~/.codex/skills/seo/.venv/bin/pip install -r ~/.codex/skills/seo/requirements.txt

# Option B: User-level install
pip install --user -r ~/.codex/skills/seo/requirements.txt
```

4. **Встановіть браузери Playwright** (опціонально, для візуального аналізу)

```bash
pip install playwright
playwright install chromium
```

Playwright опціональний. Без нього візуальний аналіз використовує WebFetch як резервний варіант.

## Шляхи встановлення

Інсталятор копіює файли до:

| Компонент | Шлях |
|-----------|------|
| Основна навичка | `~/.codex/skills/seo/` |
| Піднавички | `~/.codex/skills/seo-*/` |
| Файли agent prompts | `~/.codex/skills/seo/agents/seo-*.md` |

## Перевірка встановлення

1. Запустіть Codex:

```bash
codex
```

2. Перевірте, що навичка завантажена:

```
/seo
```

Ви повинні побачити довідкове повідомлення або запит на URL.

## Видалення

```bash
curl -fsSL https://raw.githubusercontent.com/launchborn/codex-seo/main/uninstall.sh | bash
```

Або вручну:

```bash
rm -rf ~/.codex/skills/seo
rm -rf ~/.codex/skills/seo-audit
rm -rf ~/.codex/skills/seo-competitor-pages
rm -rf ~/.codex/skills/seo-content
rm -rf ~/.codex/skills/seo-geo
rm -rf ~/.codex/skills/seo-hreflang
rm -rf ~/.codex/skills/seo-images
rm -rf ~/.codex/skills/seo-page
rm -rf ~/.codex/skills/seo-plan
rm -rf ~/.codex/skills/seo-programmatic
rm -rf ~/.codex/skills/seo-schema
rm -rf ~/.codex/skills/seo-sitemap
rm -rf ~/.codex/skills/seo-technical
rm -f ~/.codex/skills/seo/agents/seo-*.md
```

## Оновлення

Для оновлення до останньої версії:

```bash
# Uninstall current version
curl -fsSL https://raw.githubusercontent.com/launchborn/codex-seo/main/uninstall.sh | bash

# Install new version
curl -fsSL https://raw.githubusercontent.com/launchborn/codex-seo/main/install.sh | bash
```

## Усунення неполадок

### Помилка "Skill not found"

Переконайтеся, що навичка встановлена у правильному місці:

```bash
ls ~/.codex/skills/seo/SKILL.md
```

Якщо файл не існує, запустіть інсталятор повторно.

### Помилки залежностей Python

Встановіть залежності вручну:

```bash
pip install beautifulsoup4 requests lxml playwright Pillow urllib3 validators
```

### Помилки скріншотів Playwright

Встановіть браузер Chromium:

```bash
playwright install chromium
```

### Помилки дозволів на Unix

Переконайтеся, що скрипти мають права на виконання:

```bash
chmod +x ~/.codex/skills/seo/scripts/*.py
```
