# Common Workflows for The Compiler's Garage

This file contains step-by-step workflows for common development tasks.

## 📖 Documentation Navigation

- **[README.md](README.md)** - Documentation index and guide
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Fast lookup cheat sheet
- **[AUTOMATION_TASKS.md](AUTOMATION_TASKS.md)** - Pre-defined agent tasks
- **[../AGENT.md](../AGENT.md)** - Main project overview

---

## Workflow 1: Create and Publish a New Blog Post

### Steps

1. **Create the post file**

   ```bash
   # Navigate to posts directory
   cd demo/_posts

   # Create new file with date and slug
   touch $(date +%Y-%m-%d)-your-post-slug.md
   ```

2. **Add frontmatter and content**

   ```yaml
   ---
   title: "Your Post Title"
   subtitle: "Optional subtitle for context"
   author: "Lex Zabrovsky"
   date: "2026-02-05"
   ---

   Your markdown content starts here...
   ```

3. **Build and preview**

   ```bash
   # Return to repo root
   cd ../..

   # Build the post
   make

   # Start live server
   live-server
   ```

4. **Update index pages**
   - Add post link to [demo/index.md](../demo/index.md) in "Latest Posts" section
   - Add post to [demo/blog-index.md](../demo/blog-index.md) under appropriate year/month

5. **Rebuild with updated indexes**

   ```bash
   make clean && make
   ```

6. **Commit and push**

   ```bash
   git add .
   git commit -m "feat: add post about [topic]"
   git push origin main
   ```

7. **Verify deployment**
   - Check GitHub Actions workflow completes successfully
   - Visit <https://lex-zabrovsky.github.io/compilers-garage/> to see the published post

## Workflow 2: Modify Site Styling

### Steps

1. **Identify what to change**
   - Colors/fonts → [src/index.css](../src/index.css) CSS variables (lines 1-30)
   - Layout/grid → [src/index.css](../src/index.css) grid sections
   - Dark mode → [src/index.css](../src/index.css) `@media (prefers-color-scheme: dark)` block
   - Page structure → [demo/template.html](../demo/template.html)

2. **Make changes in appropriate file**

3. **Test locally**

   ```bash
   # Rebuild site
   make clean && make

   # Preview changes
   live-server
   ```

4. **Test responsive design**
   - Resize browser window to mobile size (< 480px)
   - Check tablet sizes
   - Verify desktop layout

5. **Test dark mode**
   - Toggle system dark mode preference
   - Verify colors and contrast
   - Check all page types (index, posts, archive)

6. **Enable debug mode**
   - Check the debug checkbox in page header
   - Verify grid alignment
   - Check console for layout warnings

7. **Commit changes**

   ```bash
   git add src/
   git commit -m "style: update [what you changed]"
   git push origin main
   ```

## Workflow 3: Update Dependencies

### Steps

1. **Update Nix flake**

   ```bash
   # Update all dependencies
   nix flake update

   # Or update specific input
   nix flake lock --update-input nixpkgs
   ```

2. **Test build with new dependencies**

   ```bash
   # Exit current shell if in one
   exit

   # Re-enter with updated dependencies
   nix develop --extra-experimental-features nix-command --extra-experimental-features flakes

   # Test build
   make clean && make
   ```

3. **Verify preview works**

   ```bash
   live-server
   ```

4. **Commit lock file**

   ```bash
   git add flake.lock
   git commit -m "chore: update Nix dependencies"
   git push origin main
   ```

## Workflow 4: Publish npm Package Update

### Steps

1. **Update version in package.json**

   ```json
   {
     "version": "0.1.6"
   }
   ```

2. **Test build**

   ```bash
   make clean && make
   ```

3. **Verify published files are correct**
   - Check [package.json](../package.json) `files` array includes:
     - `src/index.css`
     - `src/reset.css`
     - `src/index.js`
     - `LICENSE`
     - `README.md`

4. **Publish to npm**

   ```bash
   npm publish
   ```

5. **Verify publication**

   ```bash
   npm view @owickstrom/the-monospace-web
   ```

6. **Commit version bump**

   ```bash
   git add package.json
   git commit -m "chore: bump version to 0.1.6"
   git push origin main
   ```

## Workflow 5: Debug Layout Issues

### Steps

1. **Enable debug mode**
   - Open any page in browser
   - Check the "Debug mode" checkbox in header
   - Grid overlay will appear

2. **Check browser console**

   ```javascript
   // Look for messages about:
   // - Grid size calculations
   // - Media padding adjustments
   // - Offset misalignments
   ```

3. **Inspect specific elements**
   - Right-click element → Inspect
   - Check computed styles
   - Verify CSS custom properties:
     - `--line-height`
     - `--border-thickness`
     - `--grid-size`

4. **Test media elements**
   - Images should have adjusted padding
   - Videos should fit grid
   - Check [src/index.js](../src/index.js) `adjustMediaPadding()` function

5. **Verify CSS Grid**
   - Check grid container has proper `display: grid`
   - Verify `:has()` selectors apply correctly
   - Test in different browsers (Grid support)

6. **Fix issues**
   - Adjust CSS in [src/index.css](../src/index.css)
   - Or modify JS in [src/index.js](../src/index.js)
   - Rebuild and test

## Workflow 6: Set Up Development Environment

### Option A: Using Nix (Recommended)

```bash
# Clone repository
git clone https://github.com/lex-zabrovsky/compilers-garage.git
cd compilers-garage

# Enter Nix development environment
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes

# Build site
make

# Preview
live-server
```

### Option B: Using DevContainer

```bash
# Clone repository
git clone https://github.com/lex-zabrovsky/compilers-garage.git
cd compilers-garage

# Open in VS Code
code .

# When prompted, click "Reopen in Container"
# Or use Command Palette: "Remote-Containers: Reopen in Container"

# Once container is ready, build
make

# Preview
live-server
```

### Option C: Using direnv

```bash
# Install direnv: https://direnv.net/docs/installation.html

# Clone repository
git clone https://github.com/lex-zabrovsky/compilers-garage.git
cd compilers-garage

# Allow direnv
direnv allow

# Environment will auto-load (Nix shell activated)

# Build and preview
make && live-server
```

## Workflow 7: Troubleshoot Build Failures

### Steps

1. **Check Nix shell is active**

   ```bash
   # Should show Nix prompt or dev environment indicator
   echo $IN_NIX_SHELL

   # If not active, enter shell
   nix develop --extra-experimental-features nix-command --extra-experimental-features flakes
   ```

2. **Verify dependencies available**

   ```bash
   which pandoc    # Should return path
   which make      # Should return path
   which jq        # Should return path
   ```

3. **Check Makefile syntax**

   ```bash
   # Dry run to see what Make would execute
   make -n
   ```

4. **Test Pandoc manually**

   ```bash
   # Try converting a single post
   pandoc demo/_posts/2024-01-01-the-basics.md \
     -o test-output.html \
     --template=demo/template.html \
     --standalone
   ```

5. **Check YAML frontmatter**
   - Ensure proper YAML syntax
   - Verify all required fields present (title, author, date)
   - Check for special characters that need escaping

6. **Review error messages**
   - Pandoc errors → Usually YAML or Markdown syntax issues
   - Make errors → File permissions or missing files
   - jq errors → Invalid JSON in package.json

7. **Clean and rebuild**

   ```bash
   make clean
   make
   ```

## Quick Reference Commands

```bash
# Full rebuild
make clean && make

# Build and preview
make && live-server

# Update dependencies
nix flake update

# Check git status
git status

# Create new post (with today's date)
touch demo/_posts/$(date +%Y-%m-%d)-post-title.md

# View build targets
make -p | grep "^[^#].*:" | cut -d: -f1

# Check Pandoc version
pandoc --version

# Test template with sample data
pandoc demo/_posts/2024-01-01-the-basics.md \
  -o test.html \
  --template=demo/template.html \
  --standalone \
  --variable version:0.1.5 \
  --variable date:"$(date +%Y-%m-%d)"
```

## Tips and Best Practices

1. **Always use `make clean && make` when debugging build issues**
2. **Test responsive design at 480px breakpoint**
3. **Enable debug mode when working on layout**
4. **Keep post filenames lowercase with hyphens**
5. **Use ISO date format (YYYY-MM-DD) consistently**
6. **Test both light and dark modes**
7. **Check GitHub Actions status after pushing**
8. **Preview locally before pushing to main**
9. **Update both index.md and blog-index.md when adding posts**
10. **Keep CSS custom properties in one place (top of index.css)**
