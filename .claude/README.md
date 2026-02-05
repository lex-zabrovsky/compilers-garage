# Claude Agent Documentation

This directory contains comprehensive documentation for Claude agents working on **The Compiler's Garage** static blog project.

## 📖 Documentation Structure

```text
.claude/
├── README.md              # This file - documentation index
├── WORKFLOWS.md           # Step-by-step procedures for common tasks
├── QUICK_REFERENCE.md     # Fast lookup cheat sheet
├── AUTOMATION_TASKS.md    # Pre-defined agent tasks and recipes
└── settings.local.json    # Claude Code local settings
```

## 🎯 Start Here

### For Quick Lookups

**[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Use this when you need:
- Essential command syntax
- File locations
- Post frontmatter template
- CSS variable names
- Debug checklist
- Common error solutions

### For Step-by-Step Instructions

**[WORKFLOWS.md](WORKFLOWS.md)** - Use this when you need to:
- Create and publish a new blog post
- Modify site styling
- Update dependencies
- Publish npm package updates
- Debug layout issues
- Set up development environment
- Troubleshoot build failures

### For Automated Tasks

**[AUTOMATION_TASKS.md](AUTOMATION_TASKS.md)** - Use this when you need:
- Pre-defined task templates
- Validation checklists
- Utility scripts
- Agent behavior guidelines
- Task recipes for common operations

### For Project Overview

**[../AGENT.md](../AGENT.md)** - Use this for:
- Repository data summary
- Project overview and architecture
- Technology stack details
- Key features
- Development environment setup
- File reference guide
- CI/CD pipeline info
- Content guidelines

## 🚀 Quick Start by Use Case

### "I need to create a new blog post"

1. Check [WORKFLOWS.md → Workflow 1](WORKFLOWS.md#workflow-1-create-and-publish-a-new-blog-post)
2. Use [AUTOMATION_TASKS.md → Create New Blog Post](AUTOMATION_TASKS.md#task-create-new-blog-post) for template
3. Reference [QUICK_REFERENCE.md → Post Frontmatter](QUICK_REFERENCE.md#post-frontmatter-template) for YAML structure

### "I need to modify styles"

1. Follow [WORKFLOWS.md → Workflow 2](WORKFLOWS.md#workflow-2-modify-site-styling)
2. Check [QUICK_REFERENCE.md → CSS Custom Properties](QUICK_REFERENCE.md#css-custom-properties-lines-1-30-of-srcindexcss)
3. Review [AGENT.md → Modifying Styling](../AGENT.md#modifying-styling)

### "Something is broken"

1. Check [QUICK_REFERENCE.md → Debug Checklist](QUICK_REFERENCE.md#debug-checklist)
2. Review [QUICK_REFERENCE.md → Common Issues](QUICK_REFERENCE.md#common-issues--solutions)
3. Follow [WORKFLOWS.md → Workflow 7](WORKFLOWS.md#workflow-7-troubleshoot-build-failures)
4. See [AGENT.md → Troubleshooting](../AGENT.md#troubleshooting)

### "I need to understand the project"

1. Read [AGENT.md → Project Overview](../AGENT.md#project-overview)
2. Review [AGENT.md → Directory Structure](../AGENT.md#directory-structure)
3. Check [AGENT.md → Technology Details](../AGENT.md#technology-details)

## 📋 Documentation Cross-Reference

### Commands & Syntax

| Topic | Quick Reference | Detailed Workflow | Main Docs |
| ----- | --------------- | ----------------- | --------- |
| Build commands | [QUICK_REFERENCE.md](QUICK_REFERENCE.md#essential-commands) | [WORKFLOWS.md](WORKFLOWS.md#workflow-1-create-and-publish-a-new-blog-post) | [AGENT.md](../AGENT.md#building-the-site) |
| Development setup | [QUICK_REFERENCE.md](QUICK_REFERENCE.md#essential-commands) | [WORKFLOWS.md](WORKFLOWS.md#workflow-6-set-up-development-environment) | [AGENT.md](../AGENT.md#development-environment-setup) |
| Git workflow | [QUICK_REFERENCE.md](QUICK_REFERENCE.md#git-workflow) | [WORKFLOWS.md](WORKFLOWS.md#workflow-1-create-and-publish-a-new-blog-post) | [AGENT.md](../AGENT.md) |

### Tasks & Operations

| Task | Automation Template | Workflow Guide | Reference Info |
| ---- | ------------------- | -------------- | -------------- |
| New blog post | [AUTOMATION_TASKS.md](AUTOMATION_TASKS.md#task-create-new-blog-post) | [WORKFLOWS.md](WORKFLOWS.md#workflow-1-create-and-publish-a-new-blog-post) | [QUICK_REFERENCE.md](QUICK_REFERENCE.md#post-frontmatter-template) |
| Update colors | [AUTOMATION_TASKS.md](AUTOMATION_TASKS.md#task-update-site-colors) | [WORKFLOWS.md](WORKFLOWS.md#workflow-2-modify-site-styling) | [QUICK_REFERENCE.md](QUICK_REFERENCE.md#css-custom-properties-lines-1-30-of-srcindexcss) |
| Debug layout | [AUTOMATION_TASKS.md](AUTOMATION_TASKS.md#task-debug-layout-issue) | [WORKFLOWS.md](WORKFLOWS.md#workflow-5-debug-layout-issues) | [AGENT.md](../AGENT.md#layout-issues) |
| Update deps | [AUTOMATION_TASKS.md](AUTOMATION_TASKS.md#task-add-new-dependency) | [WORKFLOWS.md](WORKFLOWS.md#workflow-3-update-dependencies) | [AGENT.md](../AGENT.md#dependency-management) |
| Publish npm | [AUTOMATION_TASKS.md](AUTOMATION_TASKS.md#task-prepare-release-npm-package) | [WORKFLOWS.md](WORKFLOWS.md#workflow-4-publish-npm-package-update) | [AGENT.md](../AGENT.md#publishing-npm-package) |

### Troubleshooting

| Issue Type | Quick Fix | Detailed Guide | Related Docs |
| ---------- | --------- | -------------- | ------------ |
| Build failures | [QUICK_REFERENCE.md](QUICK_REFERENCE.md#common-issues--solutions) | [WORKFLOWS.md](WORKFLOWS.md#workflow-7-troubleshoot-build-failures) | [AGENT.md](../AGENT.md#build-issues) |
| Layout bugs | [QUICK_REFERENCE.md](QUICK_REFERENCE.md#debug-checklist) | [WORKFLOWS.md](WORKFLOWS.md#workflow-5-debug-layout-issues) | [AGENT.md](../AGENT.md#layout-issues) |
| CI/CD issues | [QUICK_REFERENCE.md](QUICK_REFERENCE.md#common-issues--solutions) | [AUTOMATION_TASKS.md](AUTOMATION_TASKS.md#task-cicd-troubleshooting) | [AGENT.md](../AGENT.md#cicd-pipeline) |
| Environment | [QUICK_REFERENCE.md](QUICK_REFERENCE.md#common-issues--solutions) | [WORKFLOWS.md](WORKFLOWS.md#workflow-6-set-up-development-environment) | [AGENT.md](../AGENT.md#dev-environment-issues) |

## 🔧 For Claude Agents

### Agent Workflow Recommendations

1. **On first interaction**: Read [AGENT.md](../AGENT.md) for project context
2. **For specific tasks**: Use [AUTOMATION_TASKS.md](AUTOMATION_TASKS.md) templates
3. **When uncertain**: Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md) first
4. **For complex operations**: Follow [WORKFLOWS.md](WORKFLOWS.md) step-by-step
5. **Before making changes**: Review relevant troubleshooting sections

### Key Agent Guidelines

From [AUTOMATION_TASKS.md → Agent Behavior Guidelines](AUTOMATION_TASKS.md#agent-behavior-guidelines):

1. Always enter Nix shell first
2. Read files before editing
3. Use `make clean && make` for clean builds
4. Test responsive design at mobile breakpoint
5. Verify both light and dark modes
6. Update index pages when adding posts
7. Follow existing patterns
8. Commit with conventional commit messages
9. Document significant changes
10. Validate YAML before committing posts

## 📂 File Locations Quick Map

```text
Repository Root
├── AGENT.md                           ← Main overview & instructions
├── .claude/
│   ├── README.md                      ← This file
│   ├── WORKFLOWS.md                   ← Step-by-step procedures
│   ├── QUICK_REFERENCE.md             ← Cheat sheet
│   └── AUTOMATION_TASKS.md            ← Task templates
├── demo/
│   ├── _posts/                        ← Blog post source files
│   ├── index.md                       ← Homepage content
│   ├── blog-index.md                  ← Archive content
│   └── template.html                  ← Pandoc template
├── src/
│   ├── index.css                      ← Main styles (lines 1-30: variables)
│   ├── reset.css                      ← CSS reset
│   └── index.js                       ← Grid system & debug mode
├── Makefile                           ← Build automation
├── flake.nix                          ← Nix environment
└── package.json                       ← npm metadata
```

## 🎓 Learning Path

### Beginner (First Time Working on This Project)

1. Read [AGENT.md → Project Overview](../AGENT.md#project-overview)
2. Review [AGENT.md → Directory Structure](../AGENT.md#directory-structure)
3. Follow [WORKFLOWS.md → Workflow 6](WORKFLOWS.md#workflow-6-set-up-development-environment)
4. Try [WORKFLOWS.md → Workflow 1](WORKFLOWS.md#workflow-1-create-and-publish-a-new-blog-post)
5. Bookmark [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

### Intermediate (Familiar with Project)

1. Use [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for daily work
2. Reference [WORKFLOWS.md](WORKFLOWS.md) for complex tasks
3. Leverage [AUTOMATION_TASKS.md](AUTOMATION_TASKS.md) templates
4. Consult [AGENT.md](../AGENT.md) for architecture decisions

### Advanced (Contributing/Maintaining)

1. Understand all sections of [AGENT.md](../AGENT.md)
2. Master all workflows in [WORKFLOWS.md](WORKFLOWS.md)
3. Customize [AUTOMATION_TASKS.md](AUTOMATION_TASKS.md) scripts
4. Update documentation when patterns change

## 🔗 External Resources

- **Pandoc Manual**: <https://pandoc.org/MANUAL.html>
- **Nix Manual**: <https://nixos.org/manual/nix/stable/>
- **GitHub Actions Docs**: <https://docs.github.com/en/actions>
- **CSS Grid Guide**: <https://css-tricks.com/snippets/css/complete-guide-grid/>
- **Project Repository**: <https://github.com/lex-zabrovsky/compilers-garage>
- **Live Site**: <https://lex-zabrovsky.github.io/compilers-garage/>

## 💡 Tips for Effective Use

- **Ctrl+F (Find)** is your friend - all docs are keyword-rich
- **Links are clickable** - use them to navigate between docs
- **Code blocks are copyable** - ready to paste into terminal
- **Checklists are actionable** - use them to verify work
- **Examples are practical** - based on actual project needs

## 📝 Maintaining This Documentation

When updating documentation:

1. Keep cross-references synchronized
2. Update all four files if structure changes
3. Test all code examples
4. Verify all file path references
5. Maintain consistent formatting
6. Add new patterns as they emerge
7. Remove outdated information

---

**Last Updated**: 2026-02-05

**Documentation Version**: 1.0

**Project**: The Compiler's Garage Static Blog
