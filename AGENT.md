# Repository Data Summary

**The Compiler's Garage** - A minimalist static blog by Lex Zabrovsky, DevOps engineer and former quantum physics researcher.

## 📚 Documentation Guide

This file provides the main overview. For detailed workflows and references:

- **[.claude/WORKFLOWS.md](.claude/WORKFLOWS.md)** - Step-by-step procedures for common tasks
- **[.claude/QUICK_REFERENCE.md](.claude/QUICK_REFERENCE.md)** - Fast lookup cheat sheet
- **[.claude/AUTOMATION_TASKS.md](.claude/AUTOMATION_TASKS.md)** - Pre-defined agent tasks and recipes
- **[.claude/](.claude/)** - Complete Claude agent documentation directory

## Project Overview

- **Type:** Static HTML blog built with Pandoc from Markdown
- **Stack:** Nix, Pandoc, GNU Make, vanilla CSS/JS (no frameworks)
- **Design:** Minimalist monospace theme with CSS Grid and line-height grid system
- **Content:** DevOps, Kubernetes, infrastructure, and quantum physics topics
- **Published as:** npm package `@owickstrom/the-monospace-web` (v0.1.5)
- **Live Site:** <https://lex-zabrovsky.github.io/compilers-garage/>
- **License:** MIT

## Directory Structure

```text
compilers-garage/
├── .devcontainer/          # Alpine Linux dev container (Nix, lazygit)
├── .github/workflows/      # CI/CD: builds and deploys to GitHub Pages
├── src/                    # CSS (reset.css, index.css) and JS (index.js)
├── demo/
│   ├── _posts/            # Markdown blog posts with YAML frontmatter
│   ├── index.md           # Homepage with latest posts
│   ├── blog-index.md      # Blog archive by year/month
│   └── template.html      # Pandoc HTML5 template
├── *.html                  # Generated files (gitignored)
├── Makefile                # Build automation
├── flake.nix              # Nix development environment
└── package.json           # npm package metadata
```

## Technology Details

- **Build System:** GNU Make (28-line Makefile with pattern rules)
- **Markdown Processor:** Pandoc with custom HTML5 template
- **Package Manager:** Nix flakes (reproducible builds)
- **Dev Server:** live-server (auto-reload)
- **Metadata Tool:** jq (extracts version from package.json)
- **CI/CD:** GitHub Actions (Nix-based builds, automatic GitHub Pages deployment)

## Key Features

- **Responsive Design:** Mobile breakpoint at 480px
- **Dark Mode:** Automatic via `prefers-color-scheme: dark`
- **Grid System:** 1.20rem line-height grid with CSS custom properties
- **Debug Mode:** Toggle to visualize grid alignment (see [src/index.js](src/index.js))
- **Typography:** Monospace throughout with 8px borders
- **No Runtime Dependencies:** Pure static HTML/CSS/JS

# Agent Instructions

## Development Environment Setup

### Option 1: Nix Shell (Recommended)

```bash
# Enter Nix development shell
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes

# Or with direnv (auto-loads when entering directory)
direnv allow
```

### Option 2: DevContainer

- Open in VS Code with Remote-Containers extension
- Uses Alpine Linux 3.22 with Nix, bash, and lazygit
- See [.devcontainer/devcontainer.json](.devcontainer/devcontainer.json)

## Common Workflows

> **Detailed workflows available in [.claude/WORKFLOWS.md](.claude/WORKFLOWS.md)**

### Building the Site

```bash
# Full rebuild (clean + build)
make clean && make

# Build specific file
make demo/_posts/2024-01-01-the-basics.html

# Build homepage
make index.html

# Build blog archive
make blog-index.html
```

### Local Preview

```bash
# Start live server (auto-reloads on changes)
live-server

# Then visit http://127.0.0.1:8080 in browser
# Toggle debug mode with checkbox in page header to visualize grid
```

### Adding New Blog Post

1. Create file in [demo/_posts/](demo/_posts/) with pattern: `YYYY-MM-DD-title-slug.md`
2. Add YAML frontmatter:

   ```yaml
   ---
   title: "Your Post Title"
   subtitle: "Optional subtitle"
   author: "Lex Zabrovsky"
   date: "YYYY-MM-DD"
   ---
   ```

3. Write content in Markdown
4. Run `make` to generate HTML
5. Update [demo/index.md](demo/index.md) to add link to latest posts section
6. Update [demo/blog-index.md](demo/blog-index.md) to add to archive

### Modifying Styling

- **CSS Variables:** Edit custom properties in [src/index.css](src/index.css) (lines 1-30)
- **Grid System:** Adjust `--line-height`, `--border-thickness` variables
- **Dark Mode:** Modify `@media (prefers-color-scheme: dark)` section
- **Layout:** Update grid CSS using `:has()` selectors
- **Typography:** Change `--font-family` and heading sizes

### Updating Template

- Edit [demo/template.html](demo/template.html) for HTML structure
- Template uses Pandoc variables: `$version$`, `$date$`, `$title$`, `$author$`, `$toc$`
- Metadata injected via Makefile using jq and date commands

### Testing Changes

1. Make your edits
2. Run `make clean && make`
3. Start `live-server`
4. Check responsive design (resize browser)
5. Test dark mode (toggle system preference)
6. Enable debug mode (checkbox in header) to verify grid alignment

## File Reference Guide

### When to Edit Each File

| Task | Files to Modify |
| ---- | --------------- |
| Add blog post | `demo/_posts/*.md`, `demo/index.md`, `demo/blog-index.md` |
| Change colors/fonts | [src/index.css](src/index.css) (CSS variables section) |
| Fix layout bugs | [src/index.css](src/index.css) (grid/layout sections) |
| Update page structure | [demo/template.html](demo/template.html) |
| Add JS functionality | [src/index.js](src/index.js) |
| Modify build process | [Makefile](Makefile) |
| Change dependencies | [flake.nix](flake.nix) |
| Update npm package | [package.json](package.json) |
| Configure CI/CD | [.github/workflows/deploy.yml](.github/workflows/deploy.yml) |

### Generated Files (Don't Edit)

- All `*.html` files in root directory (auto-generated from Markdown)
- These are gitignored and rebuilt on each `make` run

## CI/CD Pipeline

GitHub Actions workflow ([.github/workflows/deploy.yml](.github/workflows/deploy.yml)):

1. **Triggers:** Push to main, PRs to main
2. **Build Job:**
   - Checks out code
   - Installs Nix (unstable)
   - Runs `make` to build HTML
3. **Deploy Job:** (main branch only)
   - Uploads artifacts to GitHub Pages
   - Publishes to <https://lex-zabrovsky.github.io/compilers-garage/>

## Publishing npm Package

The blog's CSS/JS are published as an npm package:

- Package: `@owickstrom/the-monospace-web`
- Published files: `src/index.css`, `src/reset.css`, `src/index.js`, `LICENSE`, `README.md`
- Version: Update in [package.json](package.json)
- To publish: `npm publish` (requires npm auth)

## Troubleshooting

> **Quick troubleshooting reference in [.claude/QUICK_REFERENCE.md](.claude/QUICK_REFERENCE.md#common-issues--solutions)**

### Build Issues

- **Pandoc errors:** Check YAML frontmatter syntax in Markdown files
- **Make errors:** Ensure Nix shell is active (`nix develop`)
- **Missing metadata:** Verify package.json has version field

### Layout Issues

- **Grid misalignment:** Enable debug mode and check [src/index.js](src/index.js) console logs
- **Media not fitting grid:** Check padding calculations in adjustMediaPadding()
- **Dark mode not working:** Test with system preference, not browser DevTools

### Dev Environment Issues

- **Nix commands fail:** Enable flakes: `--extra-experimental-features nix-command --extra-experimental-features flakes`
- **direnv not working:** Run `direnv allow` in repository root
- **DevContainer issues:** Ensure Docker is running and VS Code has Remote-Containers extension

## Dependency Management

All dependencies are locked in [flake.lock](flake.lock):

- To update: `nix flake update`
- To add package: Edit [flake.nix](flake.nix) buildInputs
- No npm dependencies (runtime is dependency-free)

## Content Guidelines

### Blog Post Topics

- DevOps and infrastructure automation
- Kubernetes deployment and orchestration
- Container technologies (RKE2, etc.)
- Linux system administration (Astra Linux, etc.)
- Search engines (OpenSearch)
- Load balancing (HAProxy)
- Quantum physics and research

### Markdown Formatting

- Use standard Markdown syntax
- Pandoc extensions supported (tables, fenced code blocks, YAML metadata)
- Images: Place in demo/ and reference relatively
- Code blocks: Use triple backticks with language identifier

### Style Conventions

- Post filenames: `YYYY-MM-DD-lowercase-with-hyphens.md`
- Dates: ISO format `YYYY-MM-DD`
- Author: "Lex Zabrovsky"
- Keep posts technical and focused
