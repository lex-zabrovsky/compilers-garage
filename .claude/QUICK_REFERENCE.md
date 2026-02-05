# Quick Reference Card

Fast lookup guide for The Compiler's Garage static blog project.

## 📖 Documentation Navigation

- **[README.md](README.md)** - Documentation index and guide
- **[WORKFLOWS.md](WORKFLOWS.md)** - Step-by-step procedures
- **[AUTOMATION_TASKS.md](AUTOMATION_TASKS.md)** - Pre-defined agent tasks
- **[../AGENT.md](../AGENT.md)** - Main project overview

---

## Essential Commands

```bash
# Setup
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes
direnv allow  # Alternative if using direnv

# Build
make clean && make

# Preview
live-server

# New post
touch demo/_posts/$(date +%Y-%m-%d)-title.md
```

## File Locations

| What | Where |
| ---- | ----- |
| Blog posts (source) | [demo/_posts/*.md](../demo/_posts/) |
| Homepage content | [demo/index.md](../demo/index.md) |
| Archive page | [demo/blog-index.md](../demo/blog-index.md) |
| HTML template | [demo/template.html](../demo/template.html) |
| Main styles | [src/index.css](../src/index.css) |
| CSS reset | [src/reset.css](../src/reset.css) |
| JavaScript | [src/index.js](../src/index.js) |
| Build config | [Makefile](../Makefile) |
| Dev environment | [flake.nix](../flake.nix) |
| CI/CD workflow | [.github/workflows/deploy.yml](../.github/workflows/deploy.yml) |
| Package metadata | [package.json](../package.json) |

## Post Frontmatter Template

```yaml
---
title: "Post Title Here"
subtitle: "Optional subtitle"
author: "Lex Zabrovsky"
date: "YYYY-MM-DD"
---
```

## CSS Custom Properties (Lines 1-30 of src/index.css)

```css
--font-family: monospace
--line-height: 1.20rem
--border-thickness: 8px
--root-font-size: 20px (mobile: 16px)
```

## Responsive Breakpoints

```css
@media (max-width: 480px) { /* Mobile styles */ }
@media (prefers-color-scheme: dark) { /* Dark mode */ }
```

## Grid System

- Base unit: 1.20rem line-height
- Grid size: Calculated by JavaScript
- Debug mode: Checkbox in page header

## Directory Structure Quick View

```text
compilers-garage/
├── demo/_posts/        # Write posts here
├── src/                # Edit styles/JS here
├── *.html             # Generated (don't edit)
├── Makefile           # Build rules
└── flake.nix          # Dev environment
```

## Build Targets

```bash
make                   # Build all (default)
make index.html        # Build homepage
make blog-index.html   # Build archive
make %.html            # Build specific post
make clean             # Remove generated files
```

## Git Workflow

```bash
git status
git add .
git commit -m "type: description"
git push origin main   # Triggers CI/CD
```

## Commit Types

- `feat:` New blog post or feature
- `fix:` Bug fix
- `style:` CSS/design changes
- `refactor:` Code restructuring
- `chore:` Dependencies, config
- `docs:` Documentation updates

## Debug Checklist

- [ ] Nix shell active?
- [ ] Dependencies available? (`which pandoc make jq`)
- [ ] YAML frontmatter valid?
- [ ] File permissions correct?
- [ ] Clean build? (`make clean && make`)
- [ ] Browser console errors?
- [ ] Debug mode enabled?
- [ ] Tested responsive design?
- [ ] Tested dark mode?

## Live Site

Production: <https://lex-zabrovsky.github.io/compilers-garage/>

Local preview: <http://127.0.0.1:8080>

## npm Package

Package: `@owickstrom/the-monospace-web`

Version: 0.1.5 (update in [package.json](../package.json))

Install: `npm install @owickstrom/the-monospace-web`

## Common Issues & Solutions

| Issue | Solution |
| ----- | -------- |
| Make command not found | Enter Nix shell: `nix develop` |
| Pandoc errors | Check YAML frontmatter syntax |
| Layout broken | Enable debug mode, check console |
| Dark mode not working | Test with system preference |
| Live server not starting | Check port 8080 not in use |
| CI/CD failing | Check GitHub Actions logs |
| direnv not loading | Run `direnv allow` |

## Key Dependencies

- **Pandoc**: Markdown → HTML converter
- **GNU Make**: Build automation
- **jq**: JSON parsing (for version extraction)
- **live-server**: Local development server
- **Nix**: Package manager (dev environment)

## Useful Pandoc Options

```bash
pandoc input.md \
  -o output.html \
  --template=demo/template.html \
  --standalone \
  --variable version:0.1.5 \
  --variable date:2026-02-05 \
  --toc  # Table of contents
```

## GitHub Actions

Workflow: [.github/workflows/deploy.yml](../.github/workflows/deploy.yml)

Triggers:

- Push to main
- Pull request to main

Jobs:

1. Build (runs on all triggers)
2. Deploy to GitHub Pages (main only)

## VS Code DevContainer

Config: [.devcontainer/devcontainer.json](../.devcontainer/devcontainer.json)

Base: Alpine Linux 3.22

Features: Nix, bash, lazygit

## Support & Resources

- GitHub Issues: <https://github.com/lex-zabrovsky/compilers-garage/issues>
- Pandoc Docs: <https://pandoc.org/MANUAL.html>
- Nix Manual: <https://nixos.org/manual/nix/stable/>
- Live Server: <https://www.npmjs.com/package/live-server>

## License

MIT - See [LICENSE](../LICENSE) for details
