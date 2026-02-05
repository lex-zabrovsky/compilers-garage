# Repository Data Summary

This is compilers-garage, a static site generator blog project by Lex Zabrovsky:

- Type: Static HTML blog built with Pandoc from Markdown
- Stack: Nix, Pandoc, GNU Make, vanilla CSS/JS
- Design: Minimalist monospace theme with CSS Grid
- Content: DevOps, Kubernetes, quantum physics topics
- CI/CD: GitHub Actions deploys to GitHub Pages on main branch
- Build: make generates HTML from Markdown using Pandoc template
- Development: nix develop provides build tools (live-server, pandoc, jq, gnumake)
- Source: demo/_posts/ (Markdown blog posts), src/ (CSS/JS), demo/template.html (Pandoc template)

# Agent Instructions

When working on this repository:

1. Build: Initialize Nix shell using `nix develop --extra-experimental-features nix-command --extra-experimental-features flakes`. Run `make clean && make` to generate HTML from Markdown sources
2. Preview: Use live-server via Nix to preview generated pages
3. Content: Add/edit Markdown files in demo/_posts/ with YAML frontmatter
4. Styling: Modify CSS in src/index.css and src/reset.css
5. Template: Update demo/template.html for Pandoc HTML output format
6. Dependencies: Managed via flake.nix (pandoc, jq, gnumake, live-server)
7. Deployment: Automatic via GitHub Actions on main branch push