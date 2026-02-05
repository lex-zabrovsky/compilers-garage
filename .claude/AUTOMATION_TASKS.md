# Automation Tasks & Recipes

Pre-defined tasks for Claude agents working on The Compiler's Garage project.

## 📖 Documentation Navigation

- **[README.md](README.md)** - Documentation index and guide
- **[WORKFLOWS.md](WORKFLOWS.md)** - Step-by-step procedures
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Fast lookup cheat sheet
- **[../AGENT.md](../AGENT.md)** - Main project overview

---

## Task: Create New Blog Post

**Input Required**: Post title, optional subtitle, topic/content outline

**Steps**:

1. Generate filename with current date: `YYYY-MM-DD-title-slug.md`
2. Create file in [demo/_posts/](../demo/_posts/)
3. Add YAML frontmatter with title, subtitle (if provided), author "Lex Zabrovsky", and current date
4. Write content based on outline
5. Run `make` to build HTML
6. Update [demo/index.md](../demo/index.md) - add link in "Latest Posts" section
7. Update [demo/blog-index.md](../demo/blog-index.md) - add under appropriate year/month
8. Rebuild with `make clean && make`
9. Report file location and preview URL

**Validation**:

- [ ] YAML frontmatter is valid
- [ ] Filename follows YYYY-MM-DD-slug.md pattern
- [ ] Build succeeds without errors
- [ ] Post appears in index pages

## Task: Update Site Colors

**Input Required**: Color scheme (background, text, accent colors)

**Steps**:

1. Read [src/index.css](../src/index.css) lines 1-100 (to see current variables and light mode)
2. Locate CSS custom properties section (lines 1-30)
3. Update color values for light mode
4. Locate `@media (prefers-color-scheme: dark)` section
5. Update color values for dark mode
6. Run `make clean && make` to rebuild
7. Suggest testing with `live-server` in both light/dark modes

**Validation**:

- [ ] Colors have sufficient contrast (WCAG AA minimum)
- [ ] Both light and dark modes updated
- [ ] Build succeeds
- [ ] CSS syntax valid

## Task: Debug Layout Issue

**Input Required**: Description of layout problem

**Steps**:

1. Read [src/index.css](../src/index.css) to understand grid system
2. Read [src/index.js](../src/index.js) to understand grid calculations
3. Identify relevant CSS rules for the affected elements
4. Check for common issues:
   - Grid misalignment (check --line-height value)
   - Media padding (check adjustMediaPadding function)
   - Responsive breakpoints (480px threshold)
   - Dark mode conflicts
5. Propose fix with explanation
6. If needed, modify CSS or JS
7. Recommend testing with debug mode enabled

**Validation**:

- [ ] Debug mode shows correct grid alignment
- [ ] No console errors
- [ ] Responsive behavior correct
- [ ] Works in light and dark modes

## Task: Add New Dependency

**Input Required**: Package name and purpose

**Steps**:

1. Read [flake.nix](../flake.nix) to see current dependencies
2. Add new package to buildInputs list in appropriate section
3. Update flake.lock: `nix flake update`
4. Test build in updated environment
5. Document the dependency purpose in [AGENT.md](AGENT.md) if significant

**Validation**:

- [ ] Nix flake evaluates without errors
- [ ] Package available in dev shell
- [ ] Build still succeeds
- [ ] flake.lock committed with changes

## Task: Optimize Build Performance

**Input Required**: None (analysis task)

**Steps**:

1. Analyze [Makefile](../Makefile) for optimization opportunities
2. Check for redundant builds or missing dependencies
3. Profile Pandoc conversion time
4. Suggest caching strategies if applicable
5. Propose parallel build targets if possible
6. Document recommendations

**Validation**:

- [ ] Proposed changes maintain correctness
- [ ] Build time improvements measured
- [ ] No regression in output quality

## Task: Update Template Structure

**Input Required**: Desired structural changes

**Steps**:

1. Read [demo/template.html](../demo/template.html)
2. Understand Pandoc variable substitution (`$variable$`)
3. Make requested changes while preserving:
   - Version and date metadata
   - Debug mode checkbox
   - CSS/JS includes
   - Table of contents support
4. Test with sample post: `pandoc demo/_posts/2024-01-01-the-basics.md -o test.html --template=demo/template.html --standalone`
5. Rebuild all pages: `make clean && make`
6. Verify all pages render correctly

**Validation**:

- [ ] All Pandoc variables still work
- [ ] CSS and JS load correctly
- [ ] Metadata displays properly
- [ ] All 9 pages build successfully

## Task: Fix YAML Frontmatter Error

**Input Required**: Error message or affected file

**Steps**:

1. Read the affected .md file in [demo/_posts/](../demo/_posts/)
2. Check YAML syntax:
   - Proper `---` delimiters
   - Correct indentation
   - Quoted strings if containing special characters
   - Valid date format (YYYY-MM-DD)
3. Fix syntax errors
4. Test build: `make`
5. Verify HTML generates correctly

**Validation**:

- [ ] YAML parses without errors
- [ ] All required fields present (title, author, date)
- [ ] Build succeeds
- [ ] Metadata displays in HTML

## Task: Implement Responsive Design Fix

**Input Required**: Responsive issue description

**Steps**:

1. Identify affected breakpoint (likely 480px mobile threshold)
2. Read [src/index.css](../src/index.css) media queries
3. Locate relevant CSS rules
4. Propose fix considering:
   - Grid system (1.20rem base)
   - Border thickness (8px)
   - Typography scale
   - Layout structure
5. Apply changes
6. Recommend testing at various screen sizes

**Validation**:

- [ ] Mobile (< 480px) displays correctly
- [ ] Desktop displays correctly
- [ ] Transitions smooth between breakpoints
- [ ] Touch targets adequately sized (mobile)

## Task: Prepare Release (npm Package)

**Input Required**: New version number

**Steps**:

1. Read [package.json](../package.json)
2. Update version field
3. Verify `files` array includes all necessary files:
   - src/index.css
   - src/reset.css
   - src/index.js
   - LICENSE
   - README.md
4. Run build test: `make clean && make`
5. Check [README.md](../README.md) has correct version info
6. List release steps:
   - Commit version bump
   - Tag release: `git tag v0.x.x`
   - Push with tags: `git push --tags`
   - Publish: `npm publish`

**Validation**:

- [ ] Version follows semver
- [ ] All published files present
- [ ] Build succeeds
- [ ] README updated

## Task: CI/CD Troubleshooting

**Input Required**: GitHub Actions failure logs

**Steps**:

1. Analyze error messages from workflow logs
2. Check common issues:
   - Nix installation failure
   - Pandoc version issues
   - Missing dependencies
   - Build target errors
   - Permissions problems
3. Read [.github/workflows/deploy.yml](../.github/workflows/deploy.yml)
4. Identify root cause
5. Propose fix (workflow changes or source fixes)
6. Explain testing approach

**Validation**:

- [ ] Root cause identified
- [ ] Fix addresses cause (not symptom)
- [ ] Workflow syntax valid
- [ ] Permissions appropriate

## Task: Add Interactive Feature

**Input Required**: Feature description

**Steps**:

1. Determine if feature should be in [src/index.js](../src/index.js)
2. Read existing JavaScript to understand:
   - Grid calculation system
   - Media padding adjustment
   - Debug mode toggle
   - Event handling patterns
3. Implement feature following existing patterns
4. Ensure feature:
   - Works without JavaScript (progressive enhancement)
   - Respects grid system
   - Works in light/dark modes
   - Is mobile-friendly
5. Test in multiple browsers
6. Document in code comments

**Validation**:

- [ ] Works without breaking grid
- [ ] Degrades gracefully if JS disabled
- [ ] No console errors
- [ ] Accessible (keyboard, screen readers)

## Task: Content Migration

**Input Required**: Source content and format

**Steps**:

1. Convert source content to Markdown
2. Extract metadata for YAML frontmatter
3. Create appropriately named files in [demo/_posts/](../demo/_posts/)
4. Add frontmatter to each file
5. Update [demo/index.md](../demo/index.md) with new posts (if recent)
6. Update [demo/blog-index.md](../demo/blog-index.md) with all posts
7. Build and verify: `make clean && make`
8. Generate summary report of migrated content

**Validation**:

- [ ] All content converted successfully
- [ ] Metadata complete and accurate
- [ ] All builds succeed
- [ ] Index pages updated
- [ ] No broken links

## Task: Performance Audit

**Input Required**: None (analysis task)

**Steps**:

1. Analyze generated HTML file sizes
2. Check CSS size and organization
3. Review JavaScript for optimization opportunities
4. Examine image assets for optimization needs
5. Test page load times
6. Check for:
   - Unused CSS rules
   - Duplicate code
   - Unoptimized assets
   - Render-blocking resources
7. Generate recommendations report

**Validation**:

- [ ] All metrics measured
- [ ] Recommendations prioritized
- [ ] Trade-offs considered
- [ ] Implementation difficulty estimated

## Utility Scripts

### Quick Post Creation

```bash
#!/bin/bash
# create-post.sh <title>
TITLE="$1"
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
DATE=$(date +%Y-%m-%d)
FILE="demo/_posts/${DATE}-${SLUG}.md"

cat > "$FILE" << EOF
---
title: "$TITLE"
subtitle: ""
author: "Lex Zabrovsky"
date: "$DATE"
---

# Introduction

EOF

echo "Created: $FILE"
```

### Build and Preview

```bash
#!/bin/bash
# build-preview.sh
make clean && make && live-server
```

### Pre-commit Check

```bash
#!/bin/bash
# pre-commit-check.sh
echo "Checking build..."
make clean && make
if [ $? -eq 0 ]; then
  echo "✓ Build successful"
  exit 0
else
  echo "✗ Build failed"
  exit 1
fi
```

## Agent Behavior Guidelines

When working on this repository, agents should:

1. **Always enter Nix shell first** before running commands
2. **Read files before editing** to understand context
3. **Use `make clean && make`** for clean builds
4. **Test responsive design** at mobile breakpoint
5. **Verify both light and dark modes** for styling changes
6. **Update index pages** when adding posts
7. **Follow existing patterns** in CSS/JS code
8. **Commit with conventional commit messages**
9. **Document significant changes** in appropriate .md files
10. **Validate YAML** before committing posts
